#defmodule MyApp.CredoChecks.IoInspectCustom do
#  use Credo.Check,
#      base_priority: :high,
#      category: :warning,
#      explanations: [
#        check: """
#        Calling IO.inspect() can cause leaking sensitive data in a prod env.
#        If you really need it for debug purposes, annotate it with @io_inspect_ok
#        immediately before the call:
#
#            # not ok
#            IO.inspect(secret, label: "secret")
#
#            # ok
#            @io_inspect_ok
#            IO.inspect(secret, label: "secret")
#
#        Note: @io_inspect_ok applies only to the IO.inspect immediately following it.
#        """
#      ]
#
#  alias Credo.SourceFile
#
#  @doc false
#  @impl true
#  def run(%SourceFile{} = source_file, params) do
#    ctx = Context.build(source_file, params, __MODULE__)
#    approved = collect_approved_lines(source_file)
#    result = Credo.Code.prewalk(source_file, &walk(&1, &2, approved), ctx)
#    result.issues
#  end
#
#  defp collect_approved_lines(source_file) do
#    source_file
#    |> SourceFile.lines()
#    |> Enum.chunk_every(2, 1, :discard)
#    |> Enum.reduce(MapSet.new(), fn [{_, prev_line}, {line_no, _}], acc ->
#      if String.trim(prev_line) == "@io_inspect_ok" do
#        MapSet.put(acc, line_no)
#      else
#        acc
#      end
#    end)
#  end
#
#  defp walk(ast, ctx, approved) do
#    if io_inspect?(ast) do
#      meta = elem(ast, 1)
#      if MapSet.member?(approved, meta[:line]) do
#        {ast, ctx}
#      else
#        {ast, put_issue(ctx, issue_for(ctx, meta))}
#      end
#    else
#      {ast, ctx}
#    end
#  end
#
#  defp io_inspect?({{:., _, [{:__aliases__, _, [:IO]}, :inspect]}, _, _}), do: true
#  defp io_inspect?({{:., _, [{:__aliases__, _, [:"Elixir", :IO]}, :inspect]}, _, _}), do: true
#  defp io_inspect?(_), do: false
#
#  defp issue_for(ctx, meta) do
#    format_issue(ctx,
#      message: "Module contains an unsafe IO.inspect().",
#      line_no: meta[:line],
#      trigger: "IO.inspect"
#    )
#  end
#
#end
