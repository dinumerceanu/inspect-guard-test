defmodule MyModule do
  @moduledoc """
  This is my module.
  """
#
#  require Logger

  @max_attempts 3

  def test do
    myvar1 = 1
    myvar2 = 2
    @io_inspect_ok
    Elixir.IO.inspect(myvar1, label: "\n\nThis is myvar1:\n\n") ## io_inspect_ok
    @io_inspect_ok
    IO.inspect(myvar1, label: "\n\nThis is myvar1:\n\n")# io_inspect_ok
  end

  def test2 do
    @io_inspect_ok
    IO.inspect(@max_attempts, label: "No more than: ")# io_inspect_ok
  end

  def f do
    quote do
      if false do
        x = 1
        @io_inspect_ok
        IO.inspect(x, label: "in if with __block__")# io_inspect_ok
      else
        # nu il gaseste
        @io_inspect_ok
        IO.inspect("in else — alone")# io_inspect_ok
      end
    end
  end
#
#  def test3 do
#    if @max_attempts < 5, do: IO.inspect(@max_attempts, label: "No more than: ")
#  end
#
#  def test4 do
#    cond @max_attempts do
#      x == 3 -> IO.inspect(x, label: "This is X: ")
#    end
#  end

#  def wtf, do: IO.puts("WTF")

#  def ast1 do
#    quote do
#      require Logger
#    end
#  end
#
#  def ast2 do
#    quote do
#      @moduledoc """
#      This is my module.
#      """
#    end
#  end
#
#  def ast3 do
#    opts = [
#      %{"key1" => "secret1"},
#      "another big secret",
#    ]
#
#    quote do
#      # This should cause an error
#      IO.inspect(unquote(opts), label: "\n\nCheck out my secrets:\n\n")
#    end
#  end
#
#  def ast4 do
#    opts = [
#      %{"key1" => "secret1"},
#      "another big secret",
#    ]
#
#    quote do
#      # this should not cause an error
#      @io_inspect_ok
#      IO.inspect(unquote(opts), label: "\n\nCheck out my secrets:\n\n")
#    end
#  end
#
#  {:__block__, [],
#    [
#      {:@, [context: MyModule, imports: [{1, Kernel}]],
#        [{:io_inspect_ok, [context: MyModule], MyModule}]},
#      {{:., [], [{:__aliases__, [alias: false], [:IO]}, :inspect]}, [],
#        [
#          [%{"key1" => "secret1"}, "another big secret"],
#          [label: "\n\nCheck out my secrets:\n\n"]
#        ]
#      }
#    ]
#  }
#
#  def ast5 do
#    opts = [
#      %{"key1" => "secret1"},
#      "another big secret",
#    ]
#
#    quote do
#      # this should cause an error
#      @io_inspect_ok
#      new_opts = unquote(opts) ++ [ultra_mega_secret: "very confidential"]
#      IO.inspect(unquote(opts), label: "\n\nCheck out my secrets:\n\n")
#    end
#  end
#
#  {:__block__, [],
#    [
#      {:@, [context: MyModule, imports: [{1, Kernel}]],
#        [{:io_inspect_ok, [context: MyModule], MyModule}]},
#      {:=, [],
#        [
#          {:new_opts, [], MyModule},
#          {:++, [context: MyModule, imports: [{2, Kernel}]],
#            [
#              [%{"key1" => "secret1"}, "another big secret"],
#              [ultra_mega_secret: "very confidential"]
#            ]}
#        ]
#      },
#      {{:., [], [{:__aliases__, [alias: false], [:IO]}, :inspect]}, [],
#        [
#          [%{"key1" => "secret1"}, "another big secret"],
#          [label: "\n\nCheck out my secrets:\n\n"]
#        ]
#      }
#    ]
#  }

#  def in_pipe(x \\ "string") do
#    quote do
#      unquote(x)
#      |> String.upcase()
#      |> IO.inspect(label: "in pipe")# io_inspect_ok
#      |> String.downcase()
#    end
#  end

  {:|>, [context: MyModule, imports: [{2, Kernel}]],
    [
      {:|>, [context: MyModule, imports: [{2, Kernel}]],
        [
          {:|>, [context: MyModule, imports: [{2, Kernel}]],
            [
              "string",
              {{:., [], [{:__aliases__, [alias: false], [:String]}, :upcase]}, [],
                []}
            ]},
          {{:., [], [{:__aliases__, [alias: false], [:IO]}, :inspect]}, [],
            [[label: "in pipe"]]}
        ]},
      {{:., [], [{:__aliases__, [alias: false], [:String]}, :downcase]}, [], []}
    ]
  }

end
