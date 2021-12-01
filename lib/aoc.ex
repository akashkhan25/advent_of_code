defmodule AOC do
  defmacro __using__(day: day) do
    quote do
      @input_dir "#{__DIR__}/inputs"
      def input(filename \\ "#{unquote(day)}.txt") do
        @input_dir
        |> Path.join(filename)
        |> File.read!()
      end
    end
  end
end
