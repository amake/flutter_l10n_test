INTL_TRANSLATION := flutter packages pub run intl_translation

SUPPORTED_LOCALES := en ja zh_Hans zh_Hant
L10N_DIR := lib/l10n
L10N_DART := lib/l10n.dart

MESSAGES_ARB := $(L10N_DIR)/intl_messages.arb
LOCALE_ARBS := $(SUPPORTED_LOCALES:%=$(L10N_DIR)/intl_%.arb)
MESSAGES_DART := $(L10N_DIR)/messages_all.dart

.PHONY: l10n-merge
l10n-merge: $(MESSAGES_DART)

.PHONY: l10n-extract
l10n-extract: $(LOCALE_ARBS)

$(L10N_DIR):
	mkdir -p $(@)

$(L10N_DIR)/intl_%.arb: $(MESSAGES_ARB)
	cp $(^) $(@)

$(MESSAGES_ARB): $(L10N_DART) | $(L10N_DIR)
	$(INTL_TRANSLATION):extract_to_arb --output-dir=$(L10N_DIR) $(^)

$(MESSAGES_DART): $(LOCALE_ARBS) | $(L10N_DIR)
	$(INTL_TRANSLATION):generate_from_arb --output-dir=$(L10N_DIR) $(L10N_DART) $(^)
