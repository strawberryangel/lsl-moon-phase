//----------------------------------------------------------------------------------------
// Adapted from
// https://github.com/TorLab/MoonPhaseCalculation
//
//                            MOON PHASE CALCULATION
//
// This is the main function.
//
// It returns an integer in the range [0..27]
// 0 = new moon
// 7 = first quarter
// 14 = full moon
// 21 = last quarter
//
// NOTE!! LSL's float is low precision and the phase number may be off by a day
// due to rounding errors.
//
// USE:
//
// To calculate phase integer for March 9, 2020:
// integer phase = moon_phase(2020, 3, 9);
//----------------------------------------------------------------------------------------
integer moon_phase(integer year, integer month, integer day)
{
  float mjd = __modified_julian_date(year, month, day);  // calculate Modified Julian Date

  float f = mjd + 17852.5; // jd- 2382148.0;
  float  meeDT = f *f / (41048480.0 * 86400.0);

  float meeT = (mjd + meeDT -51544.5 /*jd - 2451545.0*/) / 36525.0;
  float meeT2 = meeT * meeT;
  float meeT3 = meeT2 * meeT;
  float meeD = 297.85 + (445267.1115 * meeT) - (0.0016300 * meeT2) + (meeT3 / 545868.0);
  meeD = __proper_ang(meeD) * DEG_TO_RAD;
  float meeM1 = 134.96 + (477198.8676 * meeT) + (0.0089970 * meeT2) + (meeT3 / 69699.0);
  meeM1 = __proper_ang(meeM1) * DEG_TO_RAD;
  float meeM = 357.53 + (35999.0503 * meeT);
  meeM = __proper_ang(meeM) * DEG_TO_RAD;

  float elong = meeD * RAD_TO_DEG + 6.29 * llSin(meeM1);
  elong = elong - 2.10 * llSin(meeM);
  elong = elong + 1.27 * llSin(2 * meeD - meeM1);
  elong = elong + 0.66 * llSin(2 * meeD);
  elong = __proper_ang(elong);
  elong = llRound(elong);
  integer moonNum = llFloor((elong + 6.43) / 360 * 28);

  if (moonNum == 28)
    moonNum = 0;

  return moonNum;
}

//--------------------------------------------------------------------------------------------
//                                 PROPER ANG
//--------------------------------------------------------------------------------------------

float __proper_ang(float big)
{
  float tmp = 0;
  if (big > 0) {
    tmp = big / 360.0;
    tmp = (tmp - llFloor(tmp)) * 360.0;
  } else {
    tmp = llCeil(llFabs(big / 360.0));
    tmp = big + tmp * 360.0;
  }

  return tmp;
}

//----------------------------------------------------------------------------------------
//                            CALCULATE MODIFIED JULIAN DATE
// From Astronical Algorithms by Jean Meeus
//
// A helpful site that talks about this is https://squarewidget.com/julian-day/
//
// Originally this was a calculation of Julian Date. However
// the limitations of the 32-bit float appears to cause rounding.
// 2460080.000000 + -1517.500000  = 2458563.000000 instead of 2,458,562.5
//----------------------------------------------------------------------------------------

integer __modified_julian_date(integer year, integer month, integer day)
{
  if (month <= 2) {
    year -= 1;
    month += 12;
  }
  integer A = llFloor(year / 100.0);
  integer B = 2 - A + llFloor(A / 4.0);

  // Dance around values to avoid floating-point error.
  integer x = llFloor(365.25 * (year + 4716));
  integer y = llFloor(30.6001 * (month + 1));
  integer z = x + y + day + B - 1525;
  integer MJD = z - 2400000;

  return MJD;
}
