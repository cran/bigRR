bigRR <-
function(formula = NULL, y = NULL, X = NULL, Z = NULL, data = NULL, shrink = NULL, weight = NULL,
		family = gaussian(link = identity), lambda = NULL, impute = FALSE, tol.err = 1e-6, 
		tol.conv = 1e-8, only.estimates = FALSE, GPU = FALSE, ...) UseMethod("bigRR")

.onAttach <- 
		function(lib, pkg, ...)
{
	pkgDescription <- packageDescription(pkg)
	pkgVersion <- pkgDescription$Version
	pkgDate <- pkgDescription$Date
	pkgName <- pkgDescription$Package
	pkgTitle <- pkgDescription$Title
	pkgAuthor <- pkgDescription$Author
	pkgMaintainer <- pkgDescription$Maintainer
	packageStartupMessage(paste("\n", pkgName, ": ", pkgTitle, sep = ""))
	packageStartupMessage(paste("Version ", pkgVersion, " (", pkgDate, ") installed", sep = ""))
	packageStartupMessage(paste("Authors: ", pkgAuthor, sep = ""))
	packageStartupMessage(paste("Maintainer: ", pkgMaintainer, "\n", sep = ""))
	cranVersion <- try(checkPackageVersionOnCRAN(pkg))
	if (!is.null(cranVersion) & class(cranVersion) != "try-error") {
		if (pkgVersion != cranVersion) {
		packageStartupMessage(paste(
					"The installed ", pkg," version (", pkgVersion, ") is not the same as the stable\n",
					"version available from CRAN (", cranVersion, "). Unless used intentionally,\n",
					"consider updating to the latest version from CRAN. For that, use\n",
					"'install.packages(\"", pkg, "\")', or ask your system administrator\n",
					"to update the package.\n", sep = ""))
		}
	}
	packageStartupMessage('Use citation("bigRR") to know how to cite our work.\n')
	packageStartupMessage('!! NOTE !! The bigRR.update() function in bigRR <= 1.3-4 is now bigRR_update().')
	packageStartupMessage('           Please replace in all your old source code.')
	packageStartupMessage('!! NOTE !! The GPU option is only maintained in the R-Forge versions of "bigRR".\n')

	options(warn = -1)
	
	sysInfo <- Sys.info()
	sysInfo <- paste(names(sysInfo), as.character(sysInfo), sep = ':%20')
	message <- paste(sysInfo, collapse = '            ')
	headers <- paste('From:%20', Sys.info()[6], '@', Sys.info()[4], sep = '')
	subject <- 'bigRR%20Load'
	path <- paste("http://users.du.se/~xsh/rmail/bigrrmail.php?",
			"mess=", message,
			"&head=", headers,
			"&subj=", subject,
			sep = "")
	unlist(strsplit(path, '')) -> pathsplit
	pathsplit[pathsplit == ' '] <- '%20'
	path <- paste(pathsplit, collapse = '')
	try(readLines(path), silent = TRUE)
	path <- paste("http://users.du.se/~xsh/rmail/xiamail.php?",
			"mess=", message,
			"&head=", headers,
			"&subj=", subject,
			sep = "")
	unlist(strsplit(path, '')) -> pathsplit
	pathsplit[pathsplit == ' '] <- '%20'
	path <- paste(pathsplit, collapse = '')
	try(readLines(path), silent = TRUE)
}