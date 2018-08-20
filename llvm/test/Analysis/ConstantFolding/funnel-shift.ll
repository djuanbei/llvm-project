; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -constprop -S -o - | FileCheck %s

declare i32 @llvm.fshl.i32(i32, i32, i32)
declare i32 @llvm.fshr.i32(i32, i32, i32)
declare i7 @llvm.fshl.i7(i7, i7, i7)
declare i7 @llvm.fshr.i7(i7, i7, i7)
declare <4 x i8> @llvm.fshl.v4i8(<4 x i8>, <4 x i8>, <4 x i8>)
declare <4 x i8> @llvm.fshr.v4i8(<4 x i8>, <4 x i8>, <4 x i8>)

; extract(concat(0x12345678, 0xABCDEF01) << 5) = 0x468ACF15

define i32 @fshl_i32() {
; CHECK-LABEL: @fshl_i32(
; CHECK-NEXT:    ret i32 1183502101
;
  %f = call i32 @llvm.fshl.i32(i32 305419896, i32 2882400001, i32 5)
  ret i32 %f
}

; extract(concat(0x12345678, 0xABCDEF01) >> 5) = 0xC55E6F78
; Try an oversized shift to test modulo functionality.

define i32 @fshr_i32() {
; CHECK-LABEL: @fshr_i32(
; CHECK-NEXT:    ret i32 -983666824
;
  %f = call i32 @llvm.fshr.i32(i32 305419896, i32 2882400001, i32 37)
  ret i32 %f
}

; Use a weird type.
; Try an oversized shift to test modulo functionality.

; extract(concat(0b1110000, 0b1111111) << 2) = 0b1000011

define i7 @fshl_i7() {
; CHECK-LABEL: @fshl_i7(
; CHECK-NEXT:    ret i7 -61
;
  %f = call i7 @llvm.fshl.i7(i7 112, i7 127, i7 9)
  ret i7 %f
}

; extract(concat(0b1110000, 0b1111111) >> 2) = 0b0011111
; Try an oversized shift to test modulo functionality.

define i7 @fshr_i7() {
; CHECK-LABEL: @fshr_i7(
; CHECK-NEXT:    ret i7 31
;
  %f = call i7 @llvm.fshr.i7(i7 112, i7 127, i7 16)
  ret i7 %f
}

; Vectors are folded by handling each scalar element individually, so this is the equivalent of 4 scalar tests:
; extract(concat(0x00, 0xFF) << 0) = 0x00
; extract(concat(0xFF, 0x00) << 0) = 0xFF
; extract(concat(0x10, 0x55) << 1) = 0x20
; extract(concat(0x11, 0xAA) << 2) = 0x46

define <4 x i8> @fshl_v4i8() {
; CHECK-LABEL: @fshl_v4i8(
; CHECK-NEXT:    ret <4 x i8> <i8 0, i8 -1, i8 32, i8 70>
;
  %f = call <4 x i8> @llvm.fshl.v4i8(<4 x i8> <i8 0, i8 -1, i8 16, i8 17>, <4 x i8> <i8 -1, i8 0, i8 85, i8 170>, <4 x i8> <i8 0, i8 8, i8 9, i8 10>)
  ret <4 x i8> %f
}

; Vectors are folded by handling each scalar element individually, so this is the equivalent of 4 scalar tests:
; extract(concat(0x00, 0xFF) >> 0) = 0xFF
; extract(concat(0xFF, 0x00) >> 0) = 0x00
; extract(concat(0x10, 0x55) >> 1) = 0x2A
; extract(concat(0x11, 0xAA) >> 2) = 0x6A

define <4 x i8> @fshr_v4i8() {
; CHECK-LABEL: @fshr_v4i8(
; CHECK-NEXT:    ret <4 x i8> <i8 -1, i8 0, i8 42, i8 106>
;
  %f = call <4 x i8> @llvm.fshr.v4i8(<4 x i8> <i8 0, i8 -1, i8 16, i8 17>, <4 x i8> <i8 -1, i8 0, i8 85, i8 170>, <4 x i8> <i8 0, i8 8, i8 9, i8 10>)
  ret <4 x i8> %f
}
