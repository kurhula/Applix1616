! this the MC6845 ctrc from Motora
! we are attempting to emulate this device.

TUPLE: mc6845 address data ;


GENERIC: reset ( mc6845 --  ) ;

! reset all registers a reset signal has happend
M: mc6845 reset
  data>>
  [ drop 0 ] map
;


! Create the tuple
: <mc6845> ( -- mc6845 )
  mc6845 new
  17 <arra> >>data ;
