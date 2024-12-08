##---------------------------------------------- ##
## Prokaryotic community structure: Project Name ##
##---------------------------------------------- ##
## Working with table with Mitochondria and Chloroplast filtered

## 0. Environment settings ----
source('../Dropbox/R_functions/plots-settings-mar-24_08_24.R')

## 1. Cargamos nuestros archivos producto de QIIME2 ----

        # ver qiime2R web page: https://github.com/jbisanz/qiime2R

	## Step a. Importing artifacts
	ps_raw <- qiime2R::qza_to_phyloseq (
		features = "data/table-nochim-nochloro-nomito.qza", # frequency table qza
		taxonomy = "data/taxonomy.qza",                     # taxonomy file qza
		metadata = "data/MappingFile_Clara_Barcelos.txt",   # metadata
		tree = "data/rooted-tree.qza")                      # rooted-tree
        ps_raw
        
        # step b. Rename ASVs names: remove fasta and put sequencial names
        taxa_names(ps_raw) <- paste0("ASV_", seq(ntaxa(ps_raw)))
        
## 2. Revisión general de nuestros datos
        
        # ver mi tabla de taxonomía, y cómo se llaman mis rangos
        phyloseq::tax_table(ps_raw) %>% View()
        ps_raw %>% phyloseq::rank_names() 
                # renombrar rangos con: colnames(tax_table(ps_raw)) <- c("Domain", "Phylum", "Class", "Order", "Family", "Genus", "Species"); rank_names(ps_raw)
        
        
        # ver mis metadatos
        phyloseq::sample_data(ps_raw) %>% View()
        
        # ver mi otu-table: frequency table
        phyloseq::otu_table(ps_raw) %>% View()

        # ver cuántos grupos taxonómicos anoté: dominio
	ps_raw %>% phyloseq::get_taxa_unique(taxonomic.rank = "Kingdom")
	
	# ver cuántos grupos taxonómicos anoté: phylum
	ps_raw %>% phyloseq::get_taxa_unique(taxonomic.rank = "Phylum")

	## Number of phylotypes per rank type: how many groups per rank
	table(tax_table(ps_raw)[, "Kingdom"], exclude = NULL) #%>% View()
	table(tax_table(ps_raw)[, "Phylum"], exclude = NULL) #%>% View()
	table(tax_table(ps_raw)[, "Class"], exclude = NULL) %>% View()

# 3. Taxonomía a nivel de dominio ----
	
        ps_raw %>% 
        phyloseq::tax_glom(taxrank = "Kingdom", NArm = FALSE) %>%
        # phyloseq::merge_samples(group = "Station", fun = sum) %>%
        phyloseq::transform_sample_counts(fun = function(x){100 * x/sum(x)}) %>% 
        phyloseq::plot_bar(fill = "Kingdom", x = "Sample") +
        ## ggplot settings para tunear plot
        scale_y_continuous(name = "Relative abundance (%)", 
                           expand = c(0,0), limits = c(0,100),
                           breaks = seq(0,100,20)) +
        scale_fill_manual(name = "Domain", values = c("firebrick", "steelblue"))
	

## 4. Barplot at the phylum level
	
	ps_raw %>% 
	        phyloseq::tax_glom(taxrank = "Phylum", NArm = FALSE) %>%
	        # phyloseq::merge_samples(group = "Station", fun = sum) %>%
	        phyloseq::transform_sample_counts(fun = function(x){100 * x/sum(x)}) %>%
	        phyloseq::prune_taxa(taxa = names(sort(x = taxa_sums(.), decreasing = TRUE)[1:20]), x = .) %>%
	        phyloseq::plot_bar(fill = "Phylum", x = "Sample") +
	        labs (x = element_blank(), y = "Relative abundance (%)") +
	        ## ggplot settings para tunear plot
	        scale_y_continuous(expand = c(0,0), limits = c(0,100),
	                           breaks = seq(0,100,20)) +
	        scale_fill_manual(name = "Domain", values = sample(x = col_vector, size = 20))
	

## 5. Otras funciones de phyloseq::
	        
	        phyloseq::merge_samples(x = ps_raw, group = "Station", fun = sum)
		phyloseq::transform_sample_counts(physeq = ps_raw, fun = function(x){100 * x/sum(x)})
		psmelt()
	

	# paleta de 57 colores:
	personal_colors <- c("#666666", "#A6D854", "#B3CDE3", "#FDB462", "#66C2A5", "#FCCDE5", "gray22", "#6A3D9A", "#DECBE4", "#A65628", "#8DA0CB", "#CCEBC5", "#FED9A6", "#8DD3C7", "#FBB4AE", "#BEBADA", "#FC8D62", "#FDBF6F", "#B3B3B3", "#B2DF8A", "#FFFFB3", "#E31A1C", "#FF7F00", "#FFFF33", "#1F78B4", "#FFD92F", "#FB8072", "#7FC97F", "#E6F5C9", "#B3E2CD", "#4DAF4A", "#F0027F", "#F1E2CC", "#FFF2AE", "#E5D8BD", "#FDDAEC", "#E78AC3", "#377EB8", "#FFED6F", "#B15928", "#7570B3", "#B3DE69", "#A6761D", "#BC80BD", "#CAB2D6", "#CBD5E8", "#FDC086", "#BEAED4", "#386CB0", "#BF5B17", "#984EA3", "#999999", "#FFFF99",  "#33A02C", "#FDCDAC", "#D95F02", "#F781BF") %>% unique(.)
	length(personal_colors)

## Guardar un plot.. dos formas
	
	# con ggsave
	ggsave(filename = "/Users/mario/Fig-$$-Class-Mon_font.svg", width = 11, height = 4.3)
	
	
	# empleando el parquete grDevices::
	grDevices::png(filename = "/Users/mario/Fig-$$-Class-Mon_font_R_wprevalence.png", width = 11, height = 4.3, res = 600, units = "in")
	thepanel # this is my plot
	dev.off() # print my plot
	
	
# unir varios plots en uno
	library(cowplot)
	
	plot1 | plot2
	
	
	# more colors ----
mariocolors <- 	c("#A6D854", "#B3CDE3", "#FDB462", "#66C2A5", "#666666", "#BF5B17",
	  "#984EA3", "#999999", "#FFFF99", "#FCCDE5", "#6A3D9A", "#DECBE4",
	  "#33A02C", "#A65628", "#8DA0CB", "#CCEBC5", "#FED9A6", "#8DD3C7",
	  "#FBB4AE", "#CCEBC5", "#BEBADA", "#FC8D62", "#FDBF6F", "#FFFF99",
	  "#B3B3B3", "#B2DF8A", "#FFFFB3", "#E31A1C", "#FF7F00", "#FFFF33",
	  "#1F78B4", "#FFD92F", "#FB8072", "#7FC97F", "#E6F5C9", "#666666",
	  "#B3E2CD", "#4DAF4A", "#FDCDAC", "#D95F02", "#F781BF", "#F0027F",
	  "#FF7F00", "#F1E2CC", "#FFF2AE", "#E5D8BD", "#FDDAEC", "#E78AC3",
	  "#377EB8", "#FFED6F", "#B15928", "#7570B3", "#B3DE69", "#A6761D",
	  "#BC80BD", "#CAB2D6", "#CBD5E8", "#FDC086", "#BEAED4", "#386CB0") %>% unique()
	