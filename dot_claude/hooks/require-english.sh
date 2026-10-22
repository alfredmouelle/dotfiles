#!/bin/sh
prompt=$(jq -r '.prompt')

case "$prompt" in
  fr:*) exit 0 ;;
esac

printf '%s' "$prompt" | perl -CSD -Mutf8 -0777 -ne '
  s{^/\S*}{};
  s{`[^`]*`|\S+://\S+|@\S+|\[(Pasted text|Image) #[^\]]*\]}{ }g;
  my $fr = () = /\b(?:le|la|les|une|des|du|de|au|aux|et|est|sont|pas|ne|que|qui|quoi|je|tu|il|elle|nous|vous|ils|elles|mon|ma|mes|ton|ta|tes|sa|ses|ce|cette|ces|ceci|cela|pour|avec|dans|sur|mais|ou|donc|comment|pourquoi|quand|lorsque|oui|non|merci|ça|ca|un|en|si|ai|tout|tous|toutes|bien|aussi|encore|moi|toi|te|faire|fait|fais|peux|peut|veux|faut|doit|devrait|meme|même|comme|avoir|va|vas|sans|etre|être|juste|deja|déjà|maintenant|coup|suis|notre|autre|autres|uniquement|toujours|rien|voir|voici|pense|chose|avant|besoin|par|aucun|seul|souci|pareil|parfait|actu|lance|annule|vire|supprime|supprimes|applique|appliques|utilise|utilises|nettoie|nettoi|garde|corrige|enleve|enlève|ajoute|rajoute|regarde|verifie|vérifie)\b|\b[jldqncmtsy][\x27’]\w/gi;
  my $accents = () = /[éèêàùçôîâûëïœ]/gi;
  my $en = () = /\b(?:the|a|an|and|is|are|was|be|to|of|in|for|with|that|this|it|you|i|can|how|what|why|do|does|not|my|your|we|should|would|could|please|from|at|by)\b/gi;
  exit(($fr >= 3 || ($fr >= 1 && $fr + $accents >= $en) || ($accents >= 1 && $en == 0)) ? 1 : 0);
' && exit 0

echo "Prompt blocked: write it in English (prefix with fr: to bypass)." >&2
exit 2
