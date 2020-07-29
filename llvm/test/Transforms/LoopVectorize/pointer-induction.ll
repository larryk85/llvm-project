; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s  -loop-vectorize -force-vector-interleave=1 -force-vector-width=4 -S | FileCheck %s
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"


; Function Attrs: nofree norecurse nounwind
define void @a(i8* readnone %b) {
; CHECK-LABEL: @a(
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[TMP0:%.*]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[TMP0]], [[N_MOD_VF]]
; CHECK-NEXT:    [[TMP1:%.*]] = mul i64 [[N_VEC]], -1
; CHECK-NEXT:    [[IND_END:%.*]] = getelementptr i8, i8* null, i64 [[TMP1]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[POINTER_PHI:%.*]] = phi i8* [ null, %vector.ph ], [ [[PTR_IND:%.*]], %pred.store.continue7 ]
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, %vector.ph ], [ [[INDEX_NEXT:%.*]], %pred.store.continue7 ]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr i8, i8* [[POINTER_PHI]], <4 x i64> <i64 0, i64 -1, i64 -2, i64 -3>
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds i8, <4 x i8*> [[TMP2]], i64 -1
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x i8*> [[TMP3]], i32 0
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr i8, i8* [[TMP4]], i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr i8, i8* [[TMP5]], i32 -3
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast i8* [[TMP6]] to <4 x i8>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x i8>, <4 x i8>* [[TMP7]], align 1
; CHECK-NEXT:    [[REVERSE:%.*]] = shufflevector <4 x i8> [[WIDE_LOAD]], <4 x i8> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:    [[TMP8:%.*]] = icmp eq <4 x i8> [[REVERSE]], zeroinitializer
; CHECK-NEXT:    [[TMP9:%.*]] = xor <4 x i1> [[TMP8]], <i1 true, i1 true, i1 true, i1 true>
; CHECK-NEXT:    [[TMP10:%.*]] = extractelement <4 x i1> [[TMP9]], i32 0
; CHECK:       pred.store.continue7:
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP18:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    [[PTR_IND]] = getelementptr i8, i8* [[POINTER_PHI]], i64 -4

entry:
  %cmp.not4 = icmp eq i8* %b, null
  br i1 %cmp.not4, label %for.cond.cleanup, label %for.body.preheader

for.body.preheader:                               ; preds = %entry
  br label %for.body

for.cond.cleanup.loopexit:                        ; preds = %if.end
  br label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup.loopexit, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader, %if.end
  %c.05 = phi i8* [ %incdec.ptr, %if.end ], [ null, %for.body.preheader ]
  %incdec.ptr = getelementptr inbounds i8, i8* %c.05, i64 -1
  %0 = load i8, i8* %incdec.ptr, align 1
  %tobool.not = icmp eq i8 %0, 0
  br i1 %tobool.not, label %if.end, label %if.then

if.then:                                          ; preds = %for.body
  store i8 95, i8* %incdec.ptr, align 1
  br label %if.end

if.end:                                           ; preds = %for.body, %if.then
  %cmp.not = icmp eq i8* %incdec.ptr, %b
  br i1 %cmp.not, label %for.cond.cleanup.loopexit, label %for.body
}
