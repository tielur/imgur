defmodule Imgur do
  @doc """
  Uploads a single image.
  """
  def upload_image(file_path) do
    # We're using string interpolation here.
    # #{id} means it inserts the value of id
    url = "https://api.imgur.com/3/image"
    headers = ["Authorization": "Client-ID #{client_id()  }"]

    case HTTPoison.post(url, {:file, file_path}, headers, []) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        # HTTP status 200 (OK) and we have a body
        case Poison.decode(body) do
          {:ok, decoded} -> {:ok, decoded}
          {:error, error} -> {:error, error}
        end
      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        # any other HTTP status code
        {:error, status_code}
      {:error, error} ->
        # some error while making request
        {:error, error}
    end
  end

  @doc """
  Returns a single image by imageHash.
  """
  def get_image(imageHash) do
    # We're using string interpolation here.
    # #{id} means it inserts the value of id
    headers = ["Authorization": "Client-ID #{client_id()}"]
    url = "https://api.imgur.com/3/image/#{imageHash}"

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        # HTTP status 200 (OK) and we have a body
        case Poison.decode(body) do
          {:ok, decoded} -> {:ok, decoded}
          {:error, error} -> {:error, error}
        end
      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        # any other HTTP status code
        {:error, status_code}
      {:error, error} ->
        # some error while making request
        {:error, error}
    end
  end

  defp client_id do
    Application.get_env(:imgur, :client_id)
  end
end
