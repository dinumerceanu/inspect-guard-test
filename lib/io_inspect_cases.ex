defmodule IoInspectCases do
#  @moduledoc """
#  Exhaustive list of all places where IO.inspect can appear.
#  Used for testing the custom Credo check.
#  """

  # ──────────────────────────────────────────
  # 1. AT MODULE LEVEL (in defmodule __block__)
  # ──────────────────────────────────────────
  @io_inspect_ok
  IO.inspect("at module level") # io_inspect_ok

  # ──────────────────────────────────────────
  # 2. IN DEF / DEFP
  # ──────────────────────────────────────────

  # alone in do — no __block__
  @io_inspect_ok
  def single_in_def, do: IO.inspect("alone in do") # io_inspect_ok

  # alone in do block
  def single_in_def_block do
    @io_inspect_ok
    IO.inspect("alone, no __block__")# io_inspect_ok
  end

  # with other expressions — has __block__
  def multiple_in_def do
    x = 1
    @io_inspect_ok
    IO.inspect(x, label: "x")# io_inspect_ok
    x
  end

  # in defp
  defp single_in_defp do
    @io_inspect_ok
    IO.inspect("in defp")# io_inspect_ok
  end

  # ──────────────────────────────────────────
  # 3. IN IF / UNLESS
  # ──────────────────────────────────────────

  def in_if(condition) do
    if condition do
      @io_inspect_ok
      IO.inspect("in if do — alone") # io_inspect_ok
    end
  end

  def in_if_else(condition) do
    if condition do
      x = 1
      @io_inspect_ok
      IO.inspect(x, label: "in if with __block__") # io_inspect_ok
    else
      @io_inspect_ok
      IO.inspect("in else — alone") # io_inspect_ok
    end
  end

  def in_unless(condition) do
    unless condition do
      @io_inspect_ok
      IO.inspect("in unless") # io_inspect_ok
    end
  end

  # ──────────────────────────────────────────
  # 4. IN CASE
  # ──────────────────────────────────────────

  def in_case(result) do
    case result do
      {:ok, val} ->
        @io_inspect_ok
        IO.inspect(val, label: "ok") # io_inspect_ok
      {:error, e} ->
        @io_inspect_ok
        IO.inspect(e, label: "error") # io_inspect_ok
    end
  end

  def in_case_with_block(result) do
    case result do
      {:ok, val} ->
        x = val
        @io_inspect_ok
        IO.inspect(x, label: "ok with __block__") # io_inspect_ok
      _ ->
        :error
    end
  end

  # ──────────────────────────────────────────
  # 5. IN COND
  # ──────────────────────────────────────────

  def in_cond(x) do
    cond do
      x > 0 ->
        @io_inspect_ok
        IO.inspect(x, label: "positive") # io_inspect_ok
      x < 0 ->
        @io_inspect_ok
        IO.inspect(x, label: "negative") # io_inspect_ok
      true  ->
        @io_inspect_ok
        IO.inspect(x, label: "zero") # io_inspect_ok
    end
  end

  # ──────────────────────────────────────────
  # 6. IN WITH
  # ──────────────────────────────────────────

  def in_with do
    with {:ok, val} <- fetch() do
      @io_inspect_ok
      IO.inspect(val, label: "in with do — alone") # io_inspect_ok
    end
  end

  def in_with_else do
    with {:ok, val} <- fetch() do
      @io_inspect_ok
      IO.inspect(val, label: "in with do") # io_inspect_ok
    else
      {:error, e} ->
        @io_inspect_ok
        IO.inspect(e, label: "in with else") # io_inspect_ok
    end
  end

  # ──────────────────────────────────────────
  # 7. IN TRY / RESCUE / CATCH / AFTER
  # ──────────────────────────────────────────

  def in_try do
    try do
      @io_inspect_ok
      IO.inspect("in try do — alone") # io_inspect_ok
    rescue
      e ->
        @io_inspect_ok
        IO.inspect(e, label: "in rescue") # io_inspect_ok
    catch
      val ->
        @io_inspect_ok
        IO.inspect(val, label: "in catch") # io_inspect_ok
    after
      @io_inspect_ok
      IO.inspect("in after") # io_inspect_ok
    end
  end

  # ──────────────────────────────────────────
  # 8. IN RECEIVE
  # ──────────────────────────────────────────

  def in_receive do
    receive do
      {:ok, val} ->
        @io_inspect_ok
        IO.inspect(val, label: "in receive") # io_inspect_ok
      {:error, e} ->
        @io_inspect_ok
        IO.inspect(e, label: "in receive error") # io_inspect_ok
    end
  end

  # ──────────────────────────────────────────
  # 9. IN FN (anonymous functions)
  # ──────────────────────────────────────────

  def in_fn do
    @io_inspect_ok
    f = fn x -> IO.inspect(x, label: "in fn") end # io_inspect_ok
    f.(1)
  end

  def in_fn_multiline do
    f = fn x ->
      y = x * 2
      @io_inspect_ok
      IO.inspect(y, label: "in fn with __block__") # io_inspect_ok
    end
    f.(1)
  end

  # ──────────────────────────────────────────
  # 10. IN FOR COMPREHENSION
  # ──────────────────────────────────────────

  def in_for do
    for x <- [1, 2, 3] do
      @io_inspect_ok
      IO.inspect(x, label: "in for") # io_inspect_ok
    end
  end

  def in_for_multiline do
    for x <- [1, 2, 3] do
      y = x * 2
      @io_inspect_ok
      IO.inspect(y, label: "in for with __block__") # io_inspect_ok
    end
  end

  # ──────────────────────────────────────────
  # 11. IN PIPE
  # ──────────────────────────────────────────

  def in_pipe(x) do
    x
    |> String.upcase()
    |> IO.inspect(label: "in pipe")
    |> String.downcase()
  end

  # ──────────────────────────────────────────
  # 12. AS A FUNCTION ARGUMENT
  # ──────────────────────────────────────────

  def as_argument do
    @io_inspect_ok
    Enum.map([1, 2, 3], &IO.inspect(&1, label: "as argument")) # io_inspect_ok
  end

  def as_nested_argument do
    @io_inspect_ok
    String.upcase(IO.inspect("nested", label: "nested argument")) # io_inspect_ok
  end

  # ──────────────────────────────────────────
  # 13. IN QUOTE
  # ──────────────────────────────────────────

  def in_quote do
    quote do
      @io_inspect_ok
      IO.inspect("in quote — alone") # io_inspect_ok
    end
  end

  def in_quote_multiline do
    quote do
      x = 1
      @io_inspect_ok
      IO.inspect(x, label: "in quote with __block__") # io_inspect_ok
    end
  end

  # ──────────────────────────────────────────
  # 14. IN DEFMACRO
  # ──────────────────────────────────────────

  defmacro in_defmacro(x) do
    @io_inspect_ok
    IO.inspect(x, label: "in defmacro — at compile time") # io_inspect_ok
    x
  end

  # ──────────────────────────────────────────
  # 15. INLINE IN EXPRESSIONS
  # ──────────────────────────────────────────

  def inline_in_match do
    @io_inspect_ok
    x = IO.inspect(fetch(), label: "in match") # io_inspect_ok
    @io_inspect_ok
    IO.inspect(x, label: "THIS IS x: ")
  end

  def inline_in_guard_workaround do
    @io_inspect_ok
    val = IO.inspect(42, label: "before guard") # io_inspect_ok
    if val > 0, do: :positive, else: :negative
  end

  # ──────────────────────────────────────────
  # HELPERS
  # ──────────────────────────────────────────

  defp fetch, do: {:ok, "value"}

end
