#!/bin/env ruby

# A node, for example eid=336|n="Astrakhan"|t=1|w=50
# A relation, for example rid=133275|n1=141480|n2=18280|t=10|w=50
# A type of relation, for example rtid=71|name="r_variante"|nom_etendu="variante"|info="Variantes du terme cible. Par exemple, yaourt, yahourt, ou encore évènement, événement."

def parser(filePath)

	#Les 3 files qui vont contenir les insertions SQL en LMD
	nodes = File.new("nodes.sql", "w+")
	relations = File.new("relations.sql", "w+")
	relationTypes = File.new("relationTypes.sql", "w+")
	cpt_nodes = 0
	cpt_relations = 0
	cpt_relationTypes = 0
	cpt_lines = 0

	#On parse le fichier passé en paramètre ligne à ligne
	File.foreach("#{filePath}") do |line|

		#voir https://stackoverflow.com/questions/31644103/ruby-converting-string-encoding-from-iso-8859-1-to-utf-8-not-working
		line = line.force_encoding("ISO-8859-1").encode("utf-8", replace: nil)

		#Garantie que la ligne commence par eid, rid ou rtid
		if(/^(eid|rid|rtid)/ =~ line)

			#Conteneur de la ligne parsée pour construire la string d'insertion ez
			hashLine = Hash.new

			#On split entre chaque '|' (donc "eid=337", "n=\"unMot\"" , ..
			line.split("|").each do |subLine|
				#On split entre le '=' (donc ["eid", "337"])
				subsub = subLine.split("=",2)	
				#On insère ça dans l'Hashmap (donc "eid" => "337", ...) 
				hashLine[subsub[0]] = subsub[1]
			end

			#Ecriture dans les fichiers des Insertions en LMD + comptage pour le fun
			if hashLine.has_key?("eid")
				nodes.write(%|INSERT INTO nodes VALUES (#{hashLine["eid"]},#{hashLine["n"]},#{hashLine["t"]},#{hashLine["w"].chomp});\n|)
				cpt_nodes += 1
			elsif hashLine.has_key?("rid")
				relations.write(%|INSERT INTO relations VALUES (#{hashLine["rid"]},#{hashLine["n1"]},#{hashLine["n2"]},#{hashLine["t"]},#{hashLine["w"].chomp});\n|)
				cpt_relations += 1
			elsif hashLine.has_key?("rtid")
				relationTypes.write(%|INSERT INTO relationTypes VALUES (#{hashLine["rtid"]},#{hashLine["name"]},#{hashLine["nom_etendu"]},#{hashLine["info"].chomp});\n|)
				cpt_relationTypes += 1
			else
				puts(%|Line #{line} not recognized.|)
			end
		end
	end
	nodes.close()
	relations.close()
	relationTypes.close()
	puts(%|On a extrait de #{filePath} :\n#{cpt_nodes} noeuds\n#{cpt_relations} relations\n#{cpt_relationTypes} types.|)
end

if ARGV.empty?
  puts "USAGE : ruby #{$0} <lexicalNet.txt>"
elsif File.file?(ARGV[0])
	t1 = Time.now
	parser(ARGV[0])
	puts("temps = #{Time.now - t1}")
else
  puts "File #{ARGV[0]} not found."
end
