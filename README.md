# JDM
Web application for jeuxdemots.org

Instruction pour l'installation :

- installation d'un serveur web : Mamp, Lamp, Wamp ou Xamp.
- clonner le repértoir dans le htdocs (resp. www).
- importer dans la base de données que vous auriez crée toutes les tables incluses dans le repértoir DUMP.
  - pour l'importation suivre l'ordre suivant pour le respect des contraintes : 
      - Table : table_relationTypes.sql
      - Table : table_nodes.sql
      - Table : table_relations.sql
