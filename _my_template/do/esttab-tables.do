********* Tables

// Load the data ***************************************************************
	
	local root		"/Users/peppegrass/Documents/GitHub/stata-tables/_my_template" // Replace root
	local output	"`root'/outputs/Raw"
	
	sysuse census.dta, clear
	xtset region

// Run regressions *************************************************************

	// Regression 1: nothing interesting
	eststo reg1:	reg death marriage pop, r /*vce(cluster clustvar)*/
		estadd local region	"No"

	// Regression 2: a different regression
	eststo reg2:	reg death popurban, r /*vce(cluster clustvar)*/
		estadd local region "No"

	// Regression 3: indicator expansion
	eststo reg3:	reg divorce marriage pop, r /*vce(cluster clustvar)*/
		estadd local region "No"

	// Regression 4: categorical control
	eststo reg4:	reg divorce marriage pop i.region, r /*vce(cluster clustvar)*/
		estadd local region 	"Yes"

// Export tables ***************************************************************

	local regressions reg1 reg2 reg3 reg4

	
	*---------------------------------------------------------------------------
	* Add custom model titles and table notes
	*---------------------------------------------------------------------------
	esttab `regressions' using "`output'/t5_esttab_titles.tex", 				///
		mtitles("Title 1" "Title 2" "Title 3" "Title 4") 						/// Just list titles here
		se																		/// Display standard errors instead of t-statistics 
		drop(*.region*) 														///																
		scalars("region Region controls") 										/// 
		nonotes addnotes(/*SE clustered by `e(clustvar)'*/ "Robust standard errors in parentheses"  			/// Each note will be shown in one line
		"Add a note here." "Other custom note here."							/// Each note will be shown in one line
		"\sym{*} \(p<0.10\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\)")  		/// Each note will be shown in one line
		star(* 0.10 ** 0.05 *** 0.01)											/// Changing default legend for levels of significance		
		label																	///
		b(%12.4fc) se(%12.4fc)													///	coefficients (SEs) formats
		replace 
			
	*---------------------------------------------------------------------------
	* Add custom table header and grouping regressions 
	*---------------------------------------------------------------------------
	esttab `regressions' using "`output'/t6_esttab_header.tex", 				///
		nomtitles 																/// Drop automatic titles, since we're customizing them
		se																		/// Display standard errors instead of t-statistics 		
		drop(*.region*) 														///																
		scalars("region Region fixed effects") 									/// 
		nonotes addnotes(/*SE clustered by `e(clustvar)'*/ "Robust standard errors in parentheses"  			/// Each note will be shown in one line
		"Add a note here." "Other custom note here."							/// Each note will be shown in one line
		"\sym{*} \(p<0.10\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\)")  		/// Each note will be shown in one line
		star(* 0.10 ** 0.05 *** 0.01)											/// Changing default legend for levels of significance		
		label																	///		
		mgroups("Number of deaths" "Number of divorces", 						///	Group titles
				pattern(1 0 1 0) 												/// Which columns are in which group? (1 marks the beginning of a new group
				span prefix(\multicolumn{@span}{c}{) suffix(})   				/// Centralize group titles including both groups
		        erepeat(\cmidrule(lr){@span}))									/// Add line under groups
		replace																	///
		/// The following line hardcodes the table hader in LaTeX:
		prehead("\begin{tabular}{l*{4}{c}} \hline\hline & \multicolumn{4}{c}{\textit{Dependent variable:}} \\")
		
		/* might want to add
		stats(N r2 F, labels("Observations" "R-squared"  "F-statistic"))
		*/	
