defmodule MyApp.CredoChecks.IoInspectCustom3 do
  use Credo.Check,
      base_priority: :high,
      category: :warning,
      explanations: [
        check: """
        Calling IO.inspect() can cause leaking sensitive data in a prod env.
        If you really need it for debug purposes, annotate it with @io_inspect_ok
        immediately before the call:

            # not ok
            IO.inspect(secret, label: "secret")

            # ok
            @io_inspect_ok
            IO.inspect(secret, label: "secret")

        Note: @io_inspect_ok applies only to the IO.inspect immediately following it.
        """
      ]

  alias Credo.SourceFile

  @doc false
  @impl true
  def run(%SourceFile{} = source_file, params) do
    ctx = Context.build(source_file, params, __MODULE__)

    {result, _, _} =
      source_file
      |> SourceFile.lines()
      |> Enum.reduce({ctx, false, nil}, fn {line_no, line}, {acc, in_doc?, prev_line} ->
        in_doc? = update_doc_state(line, in_doc?)

        acc =
          if not in_doc? and io_inspect?(line) and not in_comment?(line) and
               not prev_annotated?(prev_line) do
            put_issue(acc, issue_for(acc, line_no))
          else
            acc
          end

        {acc, in_doc?, line}
      end)

    result.issues
  end

  defp update_doc_state(line, in_doc?) do
    stripped = String.trim(line)
    is_heredoc_delimiter? = String.contains?(stripped, ~s("""))

    cond do
      not in_doc? and is_heredoc_delimiter? -> true
      in_doc? and is_heredoc_delimiter?     -> false
      true                                  -> in_doc?
    end
  end

  defp io_inspect?(line), do: String.contains?(line, "IO.inspect")

  defp in_comment?(line) do
    case String.split(line, "#", parts: 2) do
      [before, _] -> not String.contains?(before, "IO.inspect")
      [_]         -> false
    end
  end

  defp prev_annotated?(nil), do: false
  defp prev_annotated?(line), do: String.trim(line) == "@io_inspect_ok"

  defp issue_for(ctx, line_no) do
    format_issue(ctx,
      message: "Module contains an unsafe IO.inspect().",
      line_no: line_no,
      trigger: "IO.inspect"
    )
  end
end