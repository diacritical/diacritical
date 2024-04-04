defmodule Diacritical.I18nTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.19.0"

  use ExUnit.Case, async: true

  alias Diacritical
  alias DiacriticalCase

  alias Diacritical.I18n

  @typedoc "Represents the context."
  @typedoc since: "0.19.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.19.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec c_gettext(context()) :: context_merge()
  defp c_gettext(c) when is_map(c) do
    msg = "Hello, world!"
    domain = :default

    %{
      gettext: %{
        binding: %{},
        domain: to_string(domain),
        locale: "en",
        msgctxt: nil,
        msgid: msg,
        msgid_plural: msg,
        n: 1,
        translation: {domain, msg}
      }
    }
  end

  describe "__mix_recompile__?/0" do
    import I18n, only: [__mix_recompile__?: 0]

    test "failure" do
      refute __mix_recompile__?()
    end
  end

  describe "__gettext__/1" do
    import I18n, only: [__gettext__: 1]

    test "success" do
      assert __gettext__(:priv) == "priv/diacritical/gettext"
      assert __gettext__(:otp_app) == :diacritical
      assert __gettext__(:known_locales) == ["en"]
      assert __gettext__(:default_locale) == "en"
      assert __gettext__(:default_domain) == "default"
      assert __gettext__(:interpolation) == Gettext.Interpolation.Default
    end
  end

  describe "handle_missing_bindings/2" do
    import I18n, only: [handle_missing_bindings: 2]

    setup :c_gettext

    test "success", %{gettext: %{domain: domain, locale: locale}} do
      assert ExUnit.CaptureLog.capture_log(fn ->
               handle_missing_bindings(
                 %Elixir.Gettext.MissingBindingsError{
                   backend: Gettext,
                   domain: domain,
                   locale: locale,
                   missing: [],
                   msgctxt: "",
                   msgid: ""
                 },
                 ""
               )
             end) =~ "missing Gettext bindings: []"
    end
  end

  describe "handle_missing_translation/5" do
    import I18n, only: [handle_missing_translation: 5]

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
    import I18n, only: [handle_missing_plural_translation: 7]

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
    import I18n, only: [lgettext: 4]

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
    import I18n, only: [lgettext: 5]

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
    import I18n, only: [lngettext: 6]

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
    import I18n, only: [lngettext: 7]

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
