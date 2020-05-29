* Installing packages // Note: this note did not exist in the original repo; it is the first change I made (great, isn't it) which I am now going to commit to the repo I just forked!
foreach package in xml_tab estout outreg outreg2 mktab outtex est2tex {
	ssc install `package' , replace
}

net install sg73 , from(http://www.stata.com/stb/stb40) // modltbl
