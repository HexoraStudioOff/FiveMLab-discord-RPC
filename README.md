# FiveMLab_discordrpc

Script FiveM qui affiche une **Rich Presence Discord** personnalisée pour ton serveur : nom du serveur, nombre de joueurs en ligne en temps réel, image du serveur, et boutons cliquables (boutique / Discord) directement dans le statut Discord des joueurs.

> Développé par **RPSync**, en collaboration avec **FiveM Lab**.

## Sommaire

- [Fonctionnalités](#fonctionnalités)
- [Prérequis](#prérequis)
- [Installation](#installation)
- [Configuration](#configuration)
- [Fonctionnement](#fonctionnement)
- [Personnalisation](#personnalisation)
- [Debug](#debug)
- [Dépannage](#dépannage)

## Fonctionnalités

- Affiche un texte de statut du type `En jeu sur <NomDuServeur> | X joueurs en ligne`
- Compte les joueurs côté serveur et le réplique à tous les clients via un `GlobalState`
- Grande et petite image Discord personnalisables (avec texte au survol)
- Deux boutons cliquables dans le profil Discord (boutique + Discord du serveur)
- Mise à jour automatique lors des connexions/déconnexions de joueurs, en plus d'un rafraîchissement périodique

## Prérequis

- Un serveur **FiveM** (artifact récent, `fx_version 'cerulean'`)
- Une **application Discord** créée sur le [Discord Developer Portal](https://discord.com/developers/applications), avec son *Application ID*
- Dans cette application Discord, avoir uploadé dans l'onglet **Rich Presence > Art Assets** deux images portant exactement les noms définis dans `Config.LargeAsset` et `Config.SmallAsset` (par défaut `logo_big` et `logo_small`)

## Installation

1. Copier le dossier `FiveMLab_discordrpc` dans le dossier `resources` de ton serveur FiveM.
2. Ajouter dans ton `server.cfg` :

```
ensure FiveMLab_discordrpc
```

3. Configurer `config.lua` avec tes propres informations (voir ci-dessous).
4. Redémarrer la ressource ou le serveur.

## Configuration

Tout se passe dans [`config.lua`](config.lua) :

| Variable | Description | Valeur par défaut |
|---|---|---|
| `Config.Debug` | Active/désactive les logs de debug dans la console | `false` |
| `Config.AppId` | ID de ton application Discord (Discord Developer Portal) | *(à remplacer par le tien)* |
| `Config.ServerName` | Nom du serveur affiché dans le statut Discord | `"FiveM Lab RP"` |
| `Config.StoreUrl` | URL du bouton "Boutique" | `"https://rpsync.tebex.io/"` |
| `Config.DiscordUrl` | URL du bouton "Discord" | `"https://discord.gg/xRSvsDgpWm"` |
| `Config.LargeAsset` | Nom de la grande image (doit exister dans les Art Assets Discord) | `"logo_big"` |
| `Config.SmallAsset` | Nom de la petite image (doit exister dans les Art Assets Discord) | `"logo_small"` |
| `Config.ClientStartDelay` | Délai (ms) avant le premier envoi du Rich Presence côté client | `5000` |
| `Config.ClientRefreshInterval` | Intervalle (ms) de rafraîchissement du Rich Presence côté client | `15000` |
| `Config.ServerRefreshInterval` | Intervalle (ms) de rafraîchissement du nombre de joueurs côté serveur | `10000` |
| `Config.ServerStartDelay` | Délai (ms) avant la première mise à jour côté serveur | `2000` |

⚠️ **Important** : `Config.AppId` doit être ton propre Application ID Discord (visible dans l'onglet "General Information" de ton app sur le Developer Portal), sinon la Rich Presence ne s'affichera pas correctement chez les joueurs.

## Fonctionnement

### `server.lua`

- Au démarrage (après `Config.ServerStartDelay`), puis toutes les `Config.ServerRefreshInterval` ms, la fonction `updatePlayerCount` récupère la liste des joueurs connectés (`GetPlayers()`) et stocke le total dans `GlobalState.playerCount`.
- Ce compteur est aussi recalculé immédiatement (avec un léger délai de sécurité de 1s) sur les événements `playerConnecting` et `playerDropped`, pour rester au plus proche du nombre réel de joueurs.
- `GlobalState` étant automatiquement répliqué par FiveM, cette valeur est disponible côté client sans code réseau supplémentaire.

### `client.lua`

- Après `Config.ClientStartDelay`, puis toutes les `Config.ClientRefreshInterval` ms, le script :
  1. Lit `GlobalState.playerCount` (avec un fallback à `0` si la valeur n'est pas encore disponible)
  2. Définit l'Application ID Discord (`SetDiscordAppId`)
  3. Construit et envoie le texte de statut, la grande/petite image avec leurs textes au survol, et les deux boutons d'action

## Personnalisation

Tout ce qui peut être modifié se trouve dans `config.lua`, sans toucher au reste du code :

- **Texte du statut** : modifie directement la chaîne dans `client.lua` (ligne `richText = ...`) si tu veux un format différent de `"En jeu sur %s | %s joueurs en ligne"`.
- **Images** : change `Config.LargeAsset` / `Config.SmallAsset` en uploadant de nouvelles images dans les Art Assets Discord et en réutilisant leur nom exact.
- **Boutons** : modifie `Config.StoreUrl` / `Config.DiscordUrl`, ou change les libellés `"🛒 Boutique"` / `"❤️ Discord"` dans `client.lua` (`SetDiscordRichPresenceAction`). Discord n'autorise que 2 boutons maximum.
- **Fréquences de mise à jour** : ajuste les délais/intervalles dans `config.lua` selon la charge souhaitée sur ton serveur.

## Debug

Passe `Config.Debug` à `true` pour afficher dans la console serveur/client le détail de chaque mise à jour (valeurs envoyées, raison du déclenchement, liste des joueurs, etc.). À repasser à `false` en production pour ne pas polluer la console.

## Dépannage

- **Le statut ne s'affiche pas dans Discord** : vérifie que `Config.AppId` correspond bien à ton application, et que Discord est bien synchronisé avec le jeu (Paramètres Discord > Activité > FiveM/GTA V activé).
- **Les images ne s'affichent pas** : les noms dans `Config.LargeAsset`/`Config.SmallAsset` doivent correspondre **exactement** (casse comprise) aux noms uploadés dans l'onglet Art Assets de ton application Discord.
- **Le nombre de joueurs reste bloqué à 0** : active `Config.Debug` pour vérifier dans la console serveur que `updatePlayerCount` s'exécute bien et que `GlobalState.playerCount` est mis à jour.

## Licence

Script fourni par RPSync en collaboration avec FiveM Lab.
