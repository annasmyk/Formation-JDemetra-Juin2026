# Seasonal adjustment in R with JD+ : trading days -----------------------------

# load TD regressors

regs <- read.xlsx(xlsxFile = "V:/Formations-Stats/CVS-CJO/Donnees/reg_cjo_m.xlsx", detectDates = TRUE, sheet = 1L)
View(regs)

mts_regs <- ts(regs[, -1], frequency = 12, start = c(1990, 1))
class(mts_regs)
head(mts_regs)
# att date incluse, num
mts_reg1_LY <- window(mts_regs[, 1:2], start = c(2000, 1))


# Creating calendar regressors from a calendar

# Step 1: Create national (or other see doc) calendar if needed

# French calendar
french_calendar <- national_calendar(
    days = list(
        fixed_day(7, 14), # Bastille Day
        fixed_day(5, 8, validity = list(start = "1982-05-08")), # End of 2nd WW
        special_day("NEWYEAR"),
        special_day("CHRISTMAS"),
        special_day("MAYDAY"),
        special_day("EASTERMONDAY"),
        special_day("ASCENSION"),
        special_day("WHITMONDAY"),
        special_day("ASSUMPTION"),
        special_day("ALLSAINTSDAY"),
        special_day("ARMISTICE")
    )
)

# Luxembourg ?

lux_calendar <- national_calendar(
    days = list(
        fixed_day(6, 23),
        fixed_day(12, 26),
        fixed_day(5, 9, validity = list(start = "2019-01-01")), # End of 2nd WW
        special_day("NEWYEAR"),
        special_day("CHRISTMAS"),
        special_day("MAYDAY"),
        special_day("EASTERMONDAY"),
        special_day("ASCENSION"),
        special_day("WHITMONDAY"),
        special_day("ASSUMPTION"),
        special_day("ALLSAINTSDAY")
    )
)


### Step 2: Create regressors

# Create set of (6) regressors every day is different, contrast with Sunday,
# based on french national calendar
regs_td <- rjd3toolkit::calendar_td(
    calendar = lux_calendar,
    # formats the regressor like your raw series (length, frequency..)
    s = y_raw, # attention prev 
    groups = c(1, 2, 3, 4, 5, 6, 0),
    contrasts = TRUE
)

# create an intervention variable (to be allocated to "trend")
iv1 <- intervention_variable(
    s = y_raw,
    starts = "2015-01-01",
    ends = "2015-12-01"
)


# regressors can be any TS object

#  Step 3: Create a modelling context

# Gather regressors into a list
my_regressors <- list(
    Monday = regs_td[, 1],
    Tuesday = regs_td[, 2],
    Wednesday = regs_td[, 3],
    Thursday = regs_td[, 4],
    Friday = regs_td[, 5],
    Saturday = regs_td[, 6],
    reg1 = iv1
)

# create modelling context
my_context <- modelling_context(variables = my_regressors)
# check variables present in modelling context
rjd3toolkit::.r2jd_modellingcontext(my_context)$getTsVariableDictionary()


### Step 4: Add regressors to specification

x13_spec <- rjd3x13::x13_spec("rsa3")
x13_spec_user_defined <- rjd3toolkit::set_tradingdays(
    x = x13_spec,
    option = "UserDefined",
    uservariable = c(
        "r.Monday",
        "r.Tuesday",
        "r.Wednesday",
        "r.Thursday",
        "r.Friday",
        "r.Saturday"
    ),
    test = "None"
)


###

# add intervention variable to spec, choosing the component to allocate
# the effects to TREND
x13_spec_user_defined <- add_usrdefvar(
    x = x13_spec_user_defined,
    group = "r",
    name = "reg1",
    label = "iv1",
    regeffect = "Trend"
)

x13_spec_user_defined$regarima$regression$users


# Step 4: Estimate with context

sa_x13_ud <- rjd3x13::x13(y_raw, x13_spec_user_defined, context = my_context)
sa_x13_ud$result$preprocessing
summary(sa_x13_ud)


