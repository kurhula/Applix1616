! Copyright (C) 2016 Joseph Moschini.  a.k.a. forthnutter
! See http://factorcode.org/license.txt for BSD license.
!
USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models
      sequences freescale.68000.emulator byte-arrays
      applix.ram namespaces ;

IN: applix.ioport



! IO decoder
! $0060 0001 CENTRONICS
! $0060 0081 DAC
! $0060 0101 VIDLATCH
! $0060 0181 AMUX

TUPLE: ioport reset readmap writemap riport ;

!
: (ioread-0) ( n address cpu -- array )
  drop drop drop { 0 } ;

!
: (ioread-1) ( n address vpa -- array )
  drop drop drop { 1 } ;

!
: (ioread-2) ( n address cpu -- array )
  drop drop drop { 2 } ;

!
: (ioread-3) ( n address cpu -- array )
  drop drop drop { 3 } ;

: (ioread-bad) ( n address cpu -- array )
  drop drop drop { 4 } ;

! generate the read map for vpa
: ioport-readmap ( vpa -- array )
  readmap>> dup
  [
    [ drop ] dip
    [
      >hex >upper
      "(ioread-" swap append ")" append
      "applix.ioport" lookup-word 1quotation
    ] keep
    [ swap ] dip swap [ set-nth ] keep
  ] each-index ;

! PALETTE and CENTRONICS
: (iowrite-0) ( seq address cpu -- )
  drop drop drop ;

! DAC
: (iowrite-1) ( seq address cpu -- )
  drop drop drop ;

! VIDLATCH
: (iowrite-2) ( seq address cpu -- )
  drop drop drop ;

! AMUX
: (iowrite-3) ( seq address cpu -- )
  drop drop drop ;

: (iowrite-bad) ( seq address cpu -- )
  drop drop drop ;

! generate the write map for VPA
: ioport-writemap ( ioport -- array )
  writemap>> dup
  [
    [ drop ] dip
    [
      >hex >upper
      "(vpawrite-" swap append ")" append
      "applix.ioport" lookup-word 1quotation
    ] keep
    [ swap ] dip swap [ set-nth ] keep
  ] each-index ;


: ioport-read ( n address ioport -- data )
  break [ [ 6 0 bit-range ] [ 8 7 bit-range ] bi ] dip
  [ readmap>> nth ] keep swap
  call( n address applix -- seq ) ;

: ioport-write ( seq address cpu -- )
  drop drop drop ;

: <ioport> ( -- ioport )
  ioport new
  4 [ (ioread-bad) ] <array> >>readmap
  [ ioport-readmap ] keep swap >>readmap
  4 [ (iowrite-bad) ] <array> >>writemap
  [ ioport-writemap ] keep swap >>writemap
  0 >>riport ;