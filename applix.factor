! Copyright (C) 2016 Joseph Moschini. a.k.a. forthnutter
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models prettyprint
      sequences freescale.68000.emulator byte-arrays
      applix.iport applix.ram applix.rom applix.port applix.vpa namespaces
      io freescale.68000 combinators ascii words quotations arrays ;

IN: applix

TUPLE: applix < cpu rom ram readmap writemap reset ;

: mem-bad ( -- )
  ;

: (memory-0) ( n address applix -- seq )
  dup reset>>
  [ drop drop drop { 0 } ]
  [ drop drop drop { 1 } ] if
  ;

: (memory-1) ( -- )
  ;

: (memory-2) ( -- )
  ;

: (memory-3) ( -- )
  ;

: (memory-4) ( -- )
  ;

: (memory-5) ( -- )
  ;

: (memory-6) ( -- )
  ;

: (memory-7) ( -- )
  ;

: (memory-8) ( -- )
  ;

: (memory-9) ( -- )
  ;

: (memory-A) ( -- )
  ;

: (memory-B) ( -- )
  ;

: (memory-C) ( -- )
  ;

: (memory-D) ( -- )
  ;

: (memory-E) ( -- )
  ;

: (memory-F) ( -- )
  ;


! generate the memory map here
: applix-readmap ( applix -- array )
    memap>> dup
    [
          [ drop ] dip
          [
              >hex >upper
              "(memory-" swap append ")" append
              "applix" lookup-word 1quotation
          ] keep
          [ swap ] dip swap [ set-nth ] keep
    ] each-index ;

M: applix read-bytes
  [ [ 19 0 bit-range ] [ 23 20 bit-range ] bi ] dip
  [ memap>> nth ] keep swap
  call( n address applix -- seq ) ;


: <applix> ( -- applix )
    applix new-cpu ! create the tuple for applix
    ! memap is memory decoder
    16 [ mem-bad ] <array> >>memap
    [ applix-memory ] keep swap >>memap
    ! now add 68000 CPU
    ! <mc68k> >>mc68k
    ! build ROM with rom data
    "work/applix/A1616OSV045.bin" <binfile>
    <rom> >>rom ;
    ! 0 1byte-array 0x700081 <iport> memory-add drop ;


: applix-reset ( cpu -- )
    drop ;

! display current registers
: x ( applix -- applix' )
  [ string-DX [ print ] each ] keep
  [ string-AX [ print ] each ] keep
  [ string-PC print ] keep ;

! execute single instruction
: s ( applix -- applix' )
    [ single-step ] keep ;

: sx ( applix -- applix' )
  [ s drop ] [ x ] bi ;
