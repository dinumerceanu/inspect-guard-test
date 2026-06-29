defmodule MyApp.CredoChecks.RequireLoggerHasModuledoc do
  use Credo.Check,
      base_priority: :high,
      category: :warning,
      explanations: [
        check: """
        Modules that use `require Logger` should also have a `@moduledoc`.
        """
      ]

  alias Credo.SourceFile

  @doc false
  @impl true
  def run(%SourceFile{} = source_file, params) do
    ctx = Context.build(source_file, params, __MODULE__)
    result = Credo.Code.prewalk(source_file, &walk/2, ctx)
    result.issues
  end

  defp walk({:defmodule, meta, [_name, [do: {:__block__, _, body}]]}, ctx) do
    {nil, check_module(body, meta, ctx)}
  end

  defp walk({:defmodule, meta, [_name, [do: single_node]]}, ctx) do
    {nil, check_module([single_node], meta, ctx)}
  end

  defp walk(ast, ctx), do: {ast, ctx}

  defp check_module(body, meta, ctx) do
    if has_require_logger?(body) and not has_moduledoc?(body) do
      put_issue(ctx, issue_for(ctx, meta))
    else
      ctx
    end
  end

  defp has_require_logger?(body) do
    Enum.any?(body, fn
      {:require, _, [{:__aliases__, _, [:Logger]}]} -> true
      _ -> false
    end)
  end

  defp has_moduledoc?(body) do
    Enum.any?(body, fn
      {:@, _, [{:moduledoc, _, _}]} -> true
      _ -> false
    end)
  end

  defp issue_for(ctx, meta) do
    format_issue(ctx,
      message: "Module uses `require Logger` but is missing `@moduledoc`.",
      line_no: meta[:line],
      trigger: "require Logger"
    )
  end

end
