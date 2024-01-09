defmodule Gitx.Mock.SwapFunctions do
  @moduledoc """
    Functions to endpoint Swap in Mock
  """

  def get_website(_conn, _params) do
    data =
      "<!DOCTYPE html><!-- This site was created in Webflow. https://www.webflow.com --><!-- Last Published: Fri Nov 17 2023 13:08:54 GMT+0000 (Coordinated Universal Time) --><html data-wf-domain=\"swap.financial\" data-wf-page=\"635a67ed7a09eb93067591c7\" data-wf-site=\"60145959f19bd32ea3ea4d53\" lang=\"pt\"><head><meta charset=\"utf-8\"/><title>Swap, a única infraestrutura financeira one-stop-shop do mercado</title><meta content=\"Amplie seus ganhos com a plataforma de tecnologia financeira especializada para negócios de benefícios e despesas corporativas. Fale com um especialista.\" name=\"description\"/><meta content=\"Swap, a única infraestrutura financeira one-stop-shop do mercado\" property=\"og:title\"/><meta content=\"Amplie seus ganhos com a plataforma de tecnologia financeira especializada para negócios de benefícios e despesas corporativas. Fale com um especialista.\" property=\"og:description\"/><meta content=\"https://assets-global.website-files.com/60145959f19bd32ea3ea4d53/646e8b78592d5f717346801d_opengraph%20Home.jpg\" property=\"og:image\"/><meta content=\"Swap, a única infraestrutura financeira one-stop-shop do mercado\" property=\"twitter:title\"/><meta content=\"Amplie seus ganhos com a plataforma de tecnologia financeira especializada para negócios de benefícios e despesas corporativas. Fale com um especialista.\" property=\"twitter:description\"/>..."

    {:ok, %HTTPoison.Response{body: data, status_code: 200}}
  end

  def throw_error_nxdomain(_conn, _params) do
    {:error, %HTTPoison.Error{reason: :nxdomain}}
  end
end
