********* Tables with notes

// Prepare data ****************************************************************
	
	local root		"/Users/peppegrass/Documents/GitHub/stata-tables/_my_template" // Replace root
	local output	"`root'/outputs/Raw"
	
	sysuse auto, clear

	local controls		headroom trunk length
	split make, gen(make_)
	encode make_1, gen(brand)

	lab var foreign "Car type (1 = foreign)"

// Run regressions *************************************************************

	eststo nocontrols:		reg 	price foreign		
		estadd local controls 	"No"
		estadd local fe 		"No"
	
	eststo controls:		reg 	price foreign `controls'
		estadd local controls	"Yes"
		estadd local fe 		"No"
	
	eststo mpg:				reg 	price foreign mpg `controls'
		estadd local controls	"Yes"
		estadd local fe 		"No"
	
	eststo fixedeffects:	areg 	price foreign `controls', a(brand)
		estadd local controls	"Yes"
		estadd local fe 		"Yes"
	
// Adjusting wide notes ********************************************************

#d
local note 
`"Hi, this is my note. bbla bla bla "'
;
#d cr
	
	// Fixing note width with threeparttable
	esttab nocontrols controls fixedeffects                                 	/// Export three regressions
			using "`output'/t9_threeparttable.tex",                            	/// Saving to tbl_fittednote.tex
			scalars("controls Model controls" "fe Make fixed effects")			/// Adding two lines to bottom of table
			keep(foreign _cons) 												/// Don't display fixed effect coefs
			label																///
			star(* 0.10 ** 0.05 *** 0.01)										/// Changing default legend for levels of significance
			se nomtitles replace nonotes compress								/// Other layout options
			postfoot("\hline\hline \end{tabular}} \begin{tablenotes} \footnotesize \item `note' \end{tablenotes}")    // Input LaTeX code for closing table
		

	// Adjusting note width with threeparttable
	esttab 	nocontrols controls fixedeffects nocontrols controls fixedeffects   /// Export six regressions
			using "`output'/t12_narrow3parttable.tex",                         	/// Saving to tbl_fittednote.tex
			scalars("controls Model controls" "fe Make fixed effects")			/// Adding two lines to bottom of table
			keep(foreign _cons) 												/// Don't display fixed effect coefs
			label																///
			star(* 0.10 ** 0.05 *** 0.01)										/// Changing default legend for levels of significance	
			se nomtitles replace nonotes compress								/// Other layout options
			postfoot("\hline\hline \end{tabular}} \begin{tablenotes} \footnotesize \item \lipsum[1] \end{tablenotes}")    // Input LaTeX code for closing table
