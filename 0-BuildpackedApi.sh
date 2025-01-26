# Les deux commandes suivantes permettent de construire l'image de l'API en utilisant buildpack, puis de la publier sur DockerHub.
# Le CLI Pack doit être installé pour exécuter ces commandes.
# Remplacer "leowenex" par votre nom d'utilisateur DockerHub.

cd ./webapi || exit
pack build --builder=gcr.io/buildpacks/builder leowenex/bcff --publish

# Pause at the end
read -n 1 -s -r -p "Press any key to continue"

# En théorie, la commande devrait permettre de construire l'image sans la publier :
# pack build --builder=gcr.io/buildpacks/builder leowenex/bcff

# Cependant, nous ne sommes pas parvenus à faire fonctionner cette commande, nous renvoyant toujours des erreurs
# "[exporter] ERROR: failed to export: saving image: failed to fetch base layers: open /tmp/imgutil.local.image.2964744434/blobs/sha256/348cf60ebe50f38f918881694fefd892f4dc1ff2461e5d7dc7124427eb0995fb: no such file or directory"

# Nous avons également essayé de construire l'image avec un autre builder (heroku/builder:24), mais nous avons eu d'autres erreurs:
# [Error: Heroku Go Buildpack launch process type error] Launch process error: Invalid Go package import path: main
