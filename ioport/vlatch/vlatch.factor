! Copyright (C) 2016 Joseph Moschini.  a.k.a. forthnutter
! See http://factorcode.org/license.txt for BSD license.
! ***************************************
! simulate the Digital to Analog Latch on the applix

USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations arrays
      sequences freescale.68000.emulator byte-arrays quotations
      namespaces ascii words models ;

IN: applix.ioport.vlatch

TUPLE: vlatch < model ;


: vlatch-write ( seq addr vl -- )
  [ vlatch? ] keep swap
  [ [ drop first ] dip set-model ] [ drop drop drop ] if ;

: vlatch-read ( addr vl -- value )
  [ vlatch? ] keep swap
  [ [ drop ] dip value>> 1array ] [ drop drop 0 1array ] if ;


: <vlatch> ( value -- dac )
  vlatch new-model ;
