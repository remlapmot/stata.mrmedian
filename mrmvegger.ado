*! version 0.1.0 23jun2020 Tom Palmer
program mrmvegger, eclass
version 9
local version : di "version " string(_caller()) ", missing :"
local replay = replay()
if replay() {
        if _by() {
                error 190
        }
        `version' Display `0'
        exit
}

syntax varlist(min=2) [aweight] [if] [in] [, ///
	Level(cilevel) ///
    gxse(varlist numeric) ///
	*]

local callersversion = _caller()

// number of genotypes (i.e. rows of data used in estimation)
qui count `if' `in'
local k = r(N)

tokenize `"`varlist'"'
/*
varlist should be specified as:
1: gd beta
2: gp beta1
3: gp beta2
...
aw: =1/gdSE^2
*/
local npheno = wordcount("`varlist'") - 1

tempvar invvar // gyse
qui gen double `invvar' `exp' `if' `in'
// qui gen double `gyse' = 1/sqrt(`invvar') `if' `in'

* mvegger
tempvar eggercons
qui gen double `eggercons' `exp' `if'`in'
// sem (`gdtr' <- `gpvarstr' `eggercons', nocons) `if'`in'
regress `varlist' [aw = `invvar'] `if'`in', ///
	level(`level') `options'
end
exit
