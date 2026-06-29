#defmodule MyApp.CredoChecks.IoInspectCustom2 do
#  use Credo.Check,
#      base_priority: :high,
#      category: :warning,
#      explanations: [
#        check: """
#        Calling IO.inspect() can cause sensitive data to leak in production.
#
#        If you need it for debugging, annotate the same line with # io_inspect_ok:
#
#            # not ok (list is not exhaustive)
#            IO.inspect(secret, label: "secret")
#            x |> IO.inspect(label: "secret")
#            x = IO.inspect(fetch(), label: "secret")
#
#            # ok (any of these forms work)
#            IO.inspect(secret, label: "secret") # io_inspect_ok
#            IO.inspect(secret, label: "secret") #io_inspect_ok
#            IO.inspect(secret, label: "secret") ###       io_inspect_ok
#            IO.inspect(secret, label: "secret") ##random text# io_inspect_ok###whatever
#
#        IO.inspect inside @doc or @moduledoc strings is ignored.
#        """
#      ]
#
#  alias Credo.SourceFile
#
#  @doc false
#  @impl true
#  def run(%SourceFile{} = source_file, params) do
#    ctx = Context.build(source_file, params, __MODULE__)
#
#    {result, _} =
#      source_file
#      |> SourceFile.lines()
#      |> Enum.reduce({ctx, false}, fn {line_no, line}, {acc, in_doc?} ->
#        in_doc? = update_doc_state(line, in_doc?)
#
#        if not in_doc? and io_inspect?(line) and not in_comment?(line) and not annotated?(line) do
#          {put_issue(acc, issue_for(acc, line_no)), in_doc?}
#        else
#          {acc, in_doc?}
#        end
#      end)
#
#    result.issues
#  end
#
#  defp update_doc_state(line, in_doc?) do
#    stripped = String.trim(line)
#    is_heredoc_delimiter? = String.contains?(stripped, ~s("""))
#
#    cond do
#      not in_doc? and is_heredoc_delimiter? -> true
#      in_doc? and is_heredoc_delimiter?     -> false
#      true                                  -> in_doc?
#    end
#  end
#
#  defp io_inspect?(line), do: String.contains?(line, "IO.inspect")
#
#  defp annotated?(line) do
#    case String.split(line, "#", parts: 2) do
#      [_, after_hash] -> String.contains?(after_hash, "io_inspect_ok")
#      [_] -> false
#    end
#  end
#
#  defp in_comment?(line) do
#    case String.split(line, "#", parts: 2) do
#      [before, _] -> not String.contains?(before, "IO.inspect")
#      [_] -> false
#    end
#  end
#
#  defp issue_for(ctx, line_no) do
#    format_issue(ctx,
#      message: "Unsafe IO.inspect() call. Annotate with # io_inspect_ok if intentional.",
#      line_no: line_no,
#      trigger: "IO.inspect"
#    )
#  end
#end