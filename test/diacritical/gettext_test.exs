defmodule Diacritical.GettextTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.19.0"

  use ExUnit.Case, async: true

  alias Diacritical
  alias DiacriticalCase

  alias Diacritical.Gettext

  @typedoc "Represents the context."
  @typedoc since: "0.19.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.19.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec c_gettext(context()) :: context_merge()
  defp c_gettext(c) when is_map(c) do
    domain = :default
    msgid = "Hello, %{name}!"

    %{
      gettext: %{
        binding: %{name: "world"},
        domain: to_string(domain),
        locale: "en",
        msgctxt: nil,
        msgid: msgid,
        msgid_plural: msgid,
        n: 1,
        translation: {domain, "Hello, world!"}
      }
    }
  end

  describe "__mix_recompile__?/0" do
    import Gettext, only: [__mix_recompile__?: 0]

    test "failure" do
      refute __mix_recompile__?()
    end
  end

  describe "__gettext__/1" do
    import Gettext, only: [__gettext__: 1]

    test ":priv" do
      assert __gettext__(:priv) == "priv/diacritical/gettext"
    end

    test ":otp_app" do
      assert __gettext__(:otp_app) == :diacritical
    end

    test ":known_locales" do
      assert __gettext__(:known_locales) == ["en"]
    end

    test ":default_locale" do
      assert __gettext__(:default_locale) == "en"
    end

    test ":default_domain" do
      assert __gettext__(:default_domain) == "default"
    end

    test ":interpolation" do
      assert __gettext__(:interpolation) == Elixir.Gettext.Interpolation.Default
    end
  end

  describe "handle_missing_bindings/2" do
    import Gettext, only: [handle_missing_bindings: 2]

    setup :c_gettext
    setup do: %{missing: []}

    test "success", %{
      gettext: %{
        domain: domain,
        locale: locale,
        msgctxt: msgctxt,
        msgid: msgid
      },
      missing: missing
    } do
      assert ExUnit.CaptureLog.capture_log(fn ->
               handle_missing_bindings(
                 %Elixir.Gettext.MissingBindingsError{
                   backend: Gettext,
                   domain: domain,
                   locale: locale,
                   missing: missing,
                   msgctxt: msgctxt,
                   msgid: msgid
                 },
                 ""
               )
             end) =~ "missing Gettext bindings: #{missing}"
    end
  end

  describe "handle_missing_translation/5" do
    import Gettext, only: [handle_missing_translation: 5]

    setup :c_gettext

    test "success", %{
      gettext: %{
        binding: binding,
        domain: domain,
        locale: locale,
        msgctxt: msgctxt,
        msgid: msgid,
        translation: translation
      }
    } do
      assert handle_missing_translation(
               locale,
               domain,
               msgctxt,
               msgid,
               binding
             ) == translation
    end
  end

  describe "handle_missing_plural_translation/7" do
    import Gettext, only: [handle_missing_plural_translation: 7]

    setup :c_gettext

    test "success", %{
      gettext: %{
        binding: binding,
        domain: domain,
        locale: locale,
        msgctxt: msgctxt,
        msgid: msgid,
        msgid_plural: msgid_plural,
        n: n,
        translation: translation
      }
    } do
      assert handle_missing_plural_translation(
               locale,
               domain,
               msgctxt,
               msgid,
               msgid_plural,
               n,
               binding
             ) == translation
    end
  end

  describe "lgettext/4" do
    import Gettext, only: [lgettext: 4]

    setup :c_gettext

    test "success", %{
      gettext: %{
        binding: binding,
        domain: domain,
        locale: locale,
        msgid: msgid,
        translation: translation
      }
    } do
      assert lgettext(locale, domain, msgid, binding) == translation
    end
  end

  describe "lgettext/5" do
    import Gettext, only: [lgettext: 5]

    setup :c_gettext

    test "success", %{
      gettext: %{
        binding: binding,
        domain: domain,
        locale: locale,
        msgctxt: msgctxt,
        msgid: msgid,
        translation: translation
      }
    } do
      assert lgettext(locale, domain, msgctxt, msgid, binding) == translation
    end
  end

  describe "lngettext/6" do
    import Gettext, only: [lngettext: 6]

    setup :c_gettext

    test "success", %{
      gettext: %{
        binding: binding,
        domain: domain,
        locale: locale,
        msgid: msgid,
        msgid_plural: msgid_plural,
        n: n,
        translation: translation
      }
    } do
      assert lngettext(locale, domain, msgid, msgid_plural, n, binding) ==
               translation
    end
  end

  describe "lngettext/7" do
    import Gettext, only: [lngettext: 7]

    setup :c_gettext

    test "success", %{
      gettext: %{
        binding: binding,
        domain: domain,
        locale: locale,
        msgctxt: msgctxt,
        msgid: msgid,
        msgid_plural: msgid_plural,
        n: n,
        translation: translation
      }
    } do
      assert lngettext(
               locale,
               domain,
               msgctxt,
               msgid,
               msgid_plural,
               n,
               binding
             ) == translation
    end
  end
end
