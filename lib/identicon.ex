defmodule Identicon do
  @moduledoc """
    Provides method for creating a identicon image
  """

  @doc """
    Return a identicon image based on the input string
  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  @doc """
    Saves image inside the project directory
  """
  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  @doc """
    Uses :egd to create a rectagules within the image already mapped
  """
  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  @doc """
    Build a map of rectangules in the image

  ## Examples

      iex> hash_value = Identicon.hash_input("Philipp")
      %Identicon.Image{
        color: nil,
        grid: nil,
        hex: [184, 59, 178, 82, 36, 141, 116, 69, 158, 124, 109, 119, 135, 101, 130,
        175],
        pixel_map: nil
      }
      iex> grid = Identicon.build_grid(hash_value)
      %Identicon.Image{
        color: nil,
        grid: [
          {184, 0},
          {59, 1},
          {178, 2},
          {59, 3},
          {184, 4},
          {82, 5},
          {36, 6},
          {141, 7},
          {36, 8},
          {82, 9},
          {116, 10},
          {69, 11},
          {158, 12},
          {69, 13},
          {116, 14},
          {124, 15},
          {109, 16},
          {119, 17},
          {109, 18},
          {124, 19},
          {135, 20},
          {101, 21},
          {130, 22},
          {101, 23},
          {135, 24}
        ],
        hex: [184, 59, 178, 82, 36, 141, 116, 69, 158, 124, 109, 119, 135, 101, 130,
         175],
        pixel_map: nil
        }
      iex> filtered_grid = Identicon.filter_odd_squares(grid)
      %Identicon.Image{
        color: nil,
        grid: [
          {184, 0},
          {178, 2},
          {184, 4},
          {82, 5},
          {36, 6},
          {36, 8},
          {82, 9},
          {116, 10},
          {158, 12},
          {116, 14},
          {124, 15},
          {124, 19},
          {130, 22}
        ],
        hex: [184, 59, 178, 82, 36, 141, 116, 69, 158, 124, 109, 119, 135, 101, 130,
         175],
        pixel_map: nil
      }
      iex> Identicon.build_pixel_map(filtered_grid)
      %Identicon.Image{
        color: nil,
        grid: [
          {184, 0},
          {178, 2},
          {184, 4},
          {82, 5},
          {36, 6},
          {36, 8},
          {82, 9},
          {116, 10},
          {158, 12},
          {116, 14},
          {124, 15},
          {124, 19},
          {130, 22}
        ],
        hex: [184, 59, 178, 82, 36, 141, 116, 69, 158, 124, 109, 119, 135, 101, 130,
         175],
        pixel_map: [
          {{0, 0}, {50, 50}},
          {{100, 0}, {150, 50}},
          {{200, 0}, {250, 50}},
          {{0, 50}, {50, 100}},
          {{50, 50}, {100, 100}},
          {{150, 50}, {200, 100}},
          {{200, 50}, {250, 100}},
          {{0, 100}, {50, 150}},
          {{100, 100}, {150, 150}},
          {{200, 100}, {250, 150}},
          {{0, 150}, {50, 200}},
          {{200, 150}, {250, 200}},
          {{100, 200}, {150, 250}}
        ]
      }
  """
  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map =
      Enum.map grid, fn({_code, index}) ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50

        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}

        {top_left, bottom_right}
      end

      %Identicon.Image{image | pixel_map: pixel_map}
  end

  @doc """
    Keeps just even values in the grid

  ## Examples

      iex> hash_value = Identicon.hash_input("Philipp")
      %Identicon.Image{
        color: nil,
        grid: nil,
        hex: [184, 59, 178, 82, 36, 141, 116, 69, 158, 124, 109, 119, 135, 101, 130,
        175],
        pixel_map: nil
      }
      iex> grid = Identicon.build_grid(hash_value)
      %Identicon.Image{
        color: nil,
        grid: [
          {184, 0},
          {59, 1},
          {178, 2},
          {59, 3},
          {184, 4},
          {82, 5},
          {36, 6},
          {141, 7},
          {36, 8},
          {82, 9},
          {116, 10},
          {69, 11},
          {158, 12},
          {69, 13},
          {116, 14},
          {124, 15},
          {109, 16},
          {119, 17},
          {109, 18},
          {124, 19},
          {135, 20},
          {101, 21},
          {130, 22},
          {101, 23},
          {135, 24}
        ],
        hex: [184, 59, 178, 82, 36, 141, 116, 69, 158, 124, 109, 119, 135, 101, 130,
         175],
        pixel_map: nil
        }
      iex> Identicon.filter_odd_squares(grid)
      %Identicon.Image{
        color: nil,
        grid: [
          {184, 0},
          {178, 2},
          {184, 4},
          {82, 5},
          {36, 6},
          {36, 8},
          {82, 9},
          {116, 10},
          {158, 12},
          {116, 14},
          {124, 15},
          {124, 19},
          {130, 22}
        ],
        hex: [184, 59, 178, 82, 36, 141, 116, 69, 158, 124, 109, 119, 135, 101, 130,
         175],
        pixel_map: nil
      }
  """
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid =
      Enum.filter grid, fn({code, _index}) ->
        rem(code, 2) == 0
      end

    %Identicon.Image{image | grid: grid}
  end

  @doc """
    Build and separate grids for each hexadecimal value

  ## Examples

      iex> hash_value = Identicon.hash_input("Philipp")
      %Identicon.Image{
        color: nil,
        grid: nil,
        hex: [184, 59, 178, 82, 36, 141, 116, 69, 158, 124, 109, 119, 135, 101, 130,
        175],
        pixel_map: nil
      }
      iex> Identicon.build_grid(hash_value)
      %Identicon.Image{
        color: nil,
        grid: [
          {184, 0},
          {59, 1},
          {178, 2},
          {59, 3},
          {184, 4},
          {82, 5},
          {36, 6},
          {141, 7},
          {36, 8},
          {82, 9},
          {116, 10},
          {69, 11},
          {158, 12},
          {69, 13},
          {116, 14},
          {124, 15},
          {109, 16},
          {119, 17},
          {109, 18},
          {124, 19},
          {135, 20},
          {101, 21},
          {130, 22},
          {101, 23},
          {135, 24}
        ],
        hex: [184, 59, 178, 82, 36, 141, 116, 69, 158, 124, 109, 119, 135, 101, 130,
         175],
        pixel_map: nil
        }

  """
  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
        |> Enum.chunk_every(3, 3, :discard)
        |> Enum.map(&mirror_row/1)
        |> List.flatten
        |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  @doc """
    Mirror the first and second value to the end of the List

  ## Examples

      iex>Identicon.mirror_row([184, 59, 178])
      [184, 59, 178, 59, 184]

  """
  def mirror_row(row) do
    [first, second | _tail] = row

    row ++ [second, first]
  end

  @doc """
    Gets the three first values from the hexadecimal output value and put in the color variable struct

  ## Examples

      iex> hash_value = Identicon.hash_input("Philipp")
      %Identicon.Image{
        color: nil,
        grid: nil,
        hex: [184, 59, 178, 82, 36, 141, 116, 69, 158, 124, 109, 119, 135, 101, 130,
        175],
        pixel_map: nil
      }
      iex> Identicon.pick_color(hash_value)
      %Identicon.Image{
        color: {184, 59, 178},
        grid: nil,
        hex: [184, 59, 178, 82, 36, 141, 116, 69, 158, 124, 109, 119, 135, 101, 130,
        175],
        pixel_map: nil
      }

  """
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  @doc """
    Returns a hexadecimal value based on the input

  ## Examples

      iex> Identicon.hash_input("Philipp")
      %Identicon.Image{
        color: nil,
        grid: nil,
        hex: [184, 59, 178, 82, 36, 141, 116, 69, 158, 124, 109, 119, 135, 101, 130,
        175],
        pixel_map: nil
      }

  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end
end
