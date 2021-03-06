; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; Run with --no_x86_scrub_rip because we care a lot about how globals are
; accessed in the code model.

; RUN: llc < %s -relocation-model=static -code-model=small  | FileCheck %s --check-prefix=CHECK --check-prefix=SMALL-STATIC
; RUN: llc < %s -relocation-model=static -code-model=medium | FileCheck %s --check-prefix=CHECK --check-prefix=MEDIUM-STATIC
; RUN: llc < %s -relocation-model=static -code-model=large  | FileCheck %s --check-prefix=CHECK --check-prefix=LARGE-STATIC
; RUN: llc < %s -relocation-model=pic    -code-model=small  | FileCheck %s --check-prefix=CHECK --check-prefix=SMALL-PIC
; RUN: llc < %s -relocation-model=pic    -code-model=medium | FileCheck %s --check-prefix=CHECK --check-prefix=MEDIUM-PIC
; RUN: llc < %s -relocation-model=pic    -code-model=large  | FileCheck %s --check-prefix=CHECK --check-prefix=LARGE-PIC

; Generated from this C source:
;
; static int static_data[10];
; int global_data[10] = {1, 2};
; extern int extern_data[10];
;
; int *lea_static_data() { return &static_data[0]; }
; int *lea_global_data() { return &global_data[0]; }
; int *lea_extern_data() { return &extern_data[0]; }
;
; static void static_fn(void) {}
; void global_fn(void) {}
; void extern_fn(void);
;
; typedef void (*void_fn)(void);
; void_fn lea_static_fn() { return &static_fn; }
; void_fn lea_global_fn() { return &global_fn; }
; void_fn lea_extern_fn() { return &extern_fn; }


; ModuleID = 'model.c'
source_filename = "model.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64--linux"

@global_data = dso_local global [10 x i32] [i32 1, i32 2, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0], align 16
@static_data = internal global [10 x i32] zeroinitializer, align 16
@extern_data = external global [10 x i32], align 16

define dso_local i32* @lea_static_data() #0 {
; SMALL-STATIC-LABEL: lea_static_data:
; SMALL-STATIC:       # %bb.0:
; SMALL-STATIC-NEXT:    movl $static_data, %eax
; SMALL-STATIC-NEXT:    retq
;
; MEDIUM-STATIC-LABEL: lea_static_data:
; MEDIUM-STATIC:       # %bb.0:
; MEDIUM-STATIC-NEXT:    movabsq $static_data, %rax
; MEDIUM-STATIC-NEXT:    retq
;
; LARGE-STATIC-LABEL: lea_static_data:
; LARGE-STATIC:       # %bb.0:
; LARGE-STATIC-NEXT:    movabsq $static_data, %rax
; LARGE-STATIC-NEXT:    retq
;
; SMALL-PIC-LABEL: lea_static_data:
; SMALL-PIC:       # %bb.0:
; SMALL-PIC-NEXT:    leaq static_data(%rip), %rax
; SMALL-PIC-NEXT:    retq
;
; MEDIUM-PIC-LABEL: lea_static_data:
; MEDIUM-PIC:       # %bb.0:
; MEDIUM-PIC-NEXT:    leaq _GLOBAL_OFFSET_TABLE_(%rip), %rcx
; MEDIUM-PIC-NEXT:    movabsq $static_data@GOTOFF, %rax
; MEDIUM-PIC-NEXT:    addq %rcx, %rax
; MEDIUM-PIC-NEXT:    retq
;
; LARGE-PIC-LABEL: lea_static_data:
; LARGE-PIC:       # %bb.0:
; LARGE-PIC-NEXT:  .Ltmp0:
; LARGE-PIC-NEXT:    leaq .Ltmp0(%rip), %rcx
; LARGE-PIC-NEXT:    movabsq $_GLOBAL_OFFSET_TABLE_-.Ltmp0, %rax
; LARGE-PIC-NEXT:    addq %rax, %rcx
; LARGE-PIC-NEXT:    movabsq $static_data@GOTOFF, %rax
; LARGE-PIC-NEXT:    addq %rcx, %rax
; LARGE-PIC-NEXT:    retq
  ret i32* getelementptr inbounds ([10 x i32], [10 x i32]* @static_data, i64 0, i64 0)
}

define dso_local i32* @lea_global_data() #0 {
; SMALL-STATIC-LABEL: lea_global_data:
; SMALL-STATIC:       # %bb.0:
; SMALL-STATIC-NEXT:    movl $global_data, %eax
; SMALL-STATIC-NEXT:    retq
;
; MEDIUM-STATIC-LABEL: lea_global_data:
; MEDIUM-STATIC:       # %bb.0:
; MEDIUM-STATIC-NEXT:    movabsq $global_data, %rax
; MEDIUM-STATIC-NEXT:    retq
;
; LARGE-STATIC-LABEL: lea_global_data:
; LARGE-STATIC:       # %bb.0:
; LARGE-STATIC-NEXT:    movabsq $global_data, %rax
; LARGE-STATIC-NEXT:    retq
;
; SMALL-PIC-LABEL: lea_global_data:
; SMALL-PIC:       # %bb.0:
; SMALL-PIC-NEXT:    leaq global_data(%rip), %rax
; SMALL-PIC-NEXT:    retq
;
; MEDIUM-PIC-LABEL: lea_global_data:
; MEDIUM-PIC:       # %bb.0:
; MEDIUM-PIC-NEXT:    leaq _GLOBAL_OFFSET_TABLE_(%rip), %rcx
; MEDIUM-PIC-NEXT:    movabsq $global_data@GOTOFF, %rax
; MEDIUM-PIC-NEXT:    addq %rcx, %rax
; MEDIUM-PIC-NEXT:    retq
;
; LARGE-PIC-LABEL: lea_global_data:
; LARGE-PIC:       # %bb.0:
; LARGE-PIC-NEXT:  .Ltmp1:
; LARGE-PIC-NEXT:    leaq .Ltmp1(%rip), %rcx
; LARGE-PIC-NEXT:    movabsq $_GLOBAL_OFFSET_TABLE_-.Ltmp1, %rax
; LARGE-PIC-NEXT:    addq %rax, %rcx
; LARGE-PIC-NEXT:    movabsq $global_data@GOTOFF, %rax
; LARGE-PIC-NEXT:    addq %rcx, %rax
; LARGE-PIC-NEXT:    retq
  ret i32* getelementptr inbounds ([10 x i32], [10 x i32]* @global_data, i64 0, i64 0)
}

define dso_local i32* @lea_extern_data() #0 {
; SMALL-STATIC-LABEL: lea_extern_data:
; SMALL-STATIC:       # %bb.0:
; SMALL-STATIC-NEXT:    movl $extern_data, %eax
; SMALL-STATIC-NEXT:    retq
;
; MEDIUM-STATIC-LABEL: lea_extern_data:
; MEDIUM-STATIC:       # %bb.0:
; MEDIUM-STATIC-NEXT:    movabsq $extern_data, %rax
; MEDIUM-STATIC-NEXT:    retq
;
; LARGE-STATIC-LABEL: lea_extern_data:
; LARGE-STATIC:       # %bb.0:
; LARGE-STATIC-NEXT:    movabsq $extern_data, %rax
; LARGE-STATIC-NEXT:    retq
;
; SMALL-PIC-LABEL: lea_extern_data:
; SMALL-PIC:       # %bb.0:
; SMALL-PIC-NEXT:    movq extern_data@GOTPCREL(%rip), %rax
; SMALL-PIC-NEXT:    retq
;
; MEDIUM-PIC-LABEL: lea_extern_data:
; MEDIUM-PIC:       # %bb.0:
; MEDIUM-PIC-NEXT:    movq extern_data@GOTPCREL(%rip), %rax
; MEDIUM-PIC-NEXT:    retq
;
; LARGE-PIC-LABEL: lea_extern_data:
; LARGE-PIC:       # %bb.0:
; LARGE-PIC-NEXT:  .Ltmp2:
; LARGE-PIC-NEXT:    leaq .Ltmp2(%rip), %rax
; LARGE-PIC-NEXT:    movabsq $_GLOBAL_OFFSET_TABLE_-.Ltmp2, %rcx
; LARGE-PIC-NEXT:    addq %rcx, %rax
; LARGE-PIC-NEXT:    movabsq $extern_data@GOT, %rcx
; LARGE-PIC-NEXT:    movq (%rax,%rcx), %rax
; LARGE-PIC-NEXT:    retq
  ret i32* getelementptr inbounds ([10 x i32], [10 x i32]* @extern_data, i64 0, i64 0)
}

define dso_local i32 @load_global_data() #0 {
; SMALL-STATIC-LABEL: load_global_data:
; SMALL-STATIC:       # %bb.0:
; SMALL-STATIC-NEXT:    movl global_data+8(%rip), %eax
; SMALL-STATIC-NEXT:    retq
;
; MEDIUM-STATIC-LABEL: load_global_data:
; MEDIUM-STATIC:       # %bb.0:
; MEDIUM-STATIC-NEXT:    movabsq $global_data, %rax
; MEDIUM-STATIC-NEXT:    movl 8(%rax), %eax
; MEDIUM-STATIC-NEXT:    retq
;
; LARGE-STATIC-LABEL: load_global_data:
; LARGE-STATIC:       # %bb.0:
; LARGE-STATIC-NEXT:    movabsq $global_data, %rax
; LARGE-STATIC-NEXT:    movl 8(%rax), %eax
; LARGE-STATIC-NEXT:    retq
;
; SMALL-PIC-LABEL: load_global_data:
; SMALL-PIC:       # %bb.0:
; SMALL-PIC-NEXT:    movl global_data+8(%rip), %eax
; SMALL-PIC-NEXT:    retq
;
; MEDIUM-PIC-LABEL: load_global_data:
; MEDIUM-PIC:       # %bb.0:
; MEDIUM-PIC-NEXT:    leaq _GLOBAL_OFFSET_TABLE_(%rip), %rax
; MEDIUM-PIC-NEXT:    movabsq $global_data@GOTOFF, %rcx
; MEDIUM-PIC-NEXT:    movl 8(%rax,%rcx), %eax
; MEDIUM-PIC-NEXT:    retq
;
; LARGE-PIC-LABEL: load_global_data:
; LARGE-PIC:       # %bb.0:
; LARGE-PIC-NEXT:  .Ltmp3:
; LARGE-PIC-NEXT:    leaq .Ltmp3(%rip), %rax
; LARGE-PIC-NEXT:    movabsq $_GLOBAL_OFFSET_TABLE_-.Ltmp3, %rcx
; LARGE-PIC-NEXT:    addq %rcx, %rax
; LARGE-PIC-NEXT:    movabsq $global_data@GOTOFF, %rcx
; LARGE-PIC-NEXT:    movl 8(%rax,%rcx), %eax
; LARGE-PIC-NEXT:    retq
  %rv = load i32, i32* getelementptr inbounds ([10 x i32], [10 x i32]* @global_data, i64 0, i64 2)
  ret i32 %rv
}

define dso_local i32 @load_extern_data() #0 {
; SMALL-STATIC-LABEL: load_extern_data:
; SMALL-STATIC:       # %bb.0:
; SMALL-STATIC-NEXT:    movl extern_data+8(%rip), %eax
; SMALL-STATIC-NEXT:    retq
;
; MEDIUM-STATIC-LABEL: load_extern_data:
; MEDIUM-STATIC:       # %bb.0:
; MEDIUM-STATIC-NEXT:    movabsq $extern_data, %rax
; MEDIUM-STATIC-NEXT:    movl 8(%rax), %eax
; MEDIUM-STATIC-NEXT:    retq
;
; LARGE-STATIC-LABEL: load_extern_data:
; LARGE-STATIC:       # %bb.0:
; LARGE-STATIC-NEXT:    movabsq $extern_data, %rax
; LARGE-STATIC-NEXT:    movl 8(%rax), %eax
; LARGE-STATIC-NEXT:    retq
;
; SMALL-PIC-LABEL: load_extern_data:
; SMALL-PIC:       # %bb.0:
; SMALL-PIC-NEXT:    movq extern_data@GOTPCREL(%rip), %rax
; SMALL-PIC-NEXT:    movl 8(%rax), %eax
; SMALL-PIC-NEXT:    retq
;
; MEDIUM-PIC-LABEL: load_extern_data:
; MEDIUM-PIC:       # %bb.0:
; MEDIUM-PIC-NEXT:    movq extern_data@GOTPCREL(%rip), %rax
; MEDIUM-PIC-NEXT:    movl 8(%rax), %eax
; MEDIUM-PIC-NEXT:    retq
;
; LARGE-PIC-LABEL: load_extern_data:
; LARGE-PIC:       # %bb.0:
; LARGE-PIC-NEXT:  .Ltmp4:
; LARGE-PIC-NEXT:    leaq .Ltmp4(%rip), %rax
; LARGE-PIC-NEXT:    movabsq $_GLOBAL_OFFSET_TABLE_-.Ltmp4, %rcx
; LARGE-PIC-NEXT:    addq %rcx, %rax
; LARGE-PIC-NEXT:    movabsq $extern_data@GOT, %rcx
; LARGE-PIC-NEXT:    movq (%rax,%rcx), %rax
; LARGE-PIC-NEXT:    movl 8(%rax), %eax
; LARGE-PIC-NEXT:    retq
  %rv = load i32, i32* getelementptr inbounds ([10 x i32], [10 x i32]* @extern_data, i64 0, i64 2)
  ret i32 %rv
}

define dso_local void @global_fn() #0 {
; CHECK-LABEL: global_fn:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  ret void
}

define internal void @static_fn() #0 {
; CHECK-LABEL: static_fn:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  ret void
}

declare void @extern_fn()

define dso_local void ()* @lea_static_fn() #0 {
; SMALL-STATIC-LABEL: lea_static_fn:
; SMALL-STATIC:       # %bb.0:
; SMALL-STATIC-NEXT:    movl $static_fn, %eax
; SMALL-STATIC-NEXT:    retq
;
; MEDIUM-STATIC-LABEL: lea_static_fn:
; MEDIUM-STATIC:       # %bb.0:
; MEDIUM-STATIC-NEXT:    movabsq $static_fn, %rax
; MEDIUM-STATIC-NEXT:    retq
;
; LARGE-STATIC-LABEL: lea_static_fn:
; LARGE-STATIC:       # %bb.0:
; LARGE-STATIC-NEXT:    movabsq $static_fn, %rax
; LARGE-STATIC-NEXT:    retq
;
; SMALL-PIC-LABEL: lea_static_fn:
; SMALL-PIC:       # %bb.0:
; SMALL-PIC-NEXT:    leaq static_fn(%rip), %rax
; SMALL-PIC-NEXT:    retq
;
; MEDIUM-PIC-LABEL: lea_static_fn:
; MEDIUM-PIC:       # %bb.0:
; MEDIUM-PIC-NEXT:    movabsq $static_fn, %rax
; MEDIUM-PIC-NEXT:    retq
;
; LARGE-PIC-LABEL: lea_static_fn:
; LARGE-PIC:       # %bb.0:
; LARGE-PIC-NEXT:  .Ltmp5:
; LARGE-PIC-NEXT:    leaq .Ltmp5(%rip), %rcx
; LARGE-PIC-NEXT:    movabsq $_GLOBAL_OFFSET_TABLE_-.Ltmp5, %rax
; LARGE-PIC-NEXT:    addq %rax, %rcx
; LARGE-PIC-NEXT:    movabsq $static_fn@GOTOFF, %rax
; LARGE-PIC-NEXT:    addq %rcx, %rax
; LARGE-PIC-NEXT:    retq
  ret void ()* @static_fn
}

define dso_local void ()* @lea_global_fn() #0 {
; SMALL-STATIC-LABEL: lea_global_fn:
; SMALL-STATIC:       # %bb.0:
; SMALL-STATIC-NEXT:    movl $global_fn, %eax
; SMALL-STATIC-NEXT:    retq
;
; MEDIUM-STATIC-LABEL: lea_global_fn:
; MEDIUM-STATIC:       # %bb.0:
; MEDIUM-STATIC-NEXT:    movabsq $global_fn, %rax
; MEDIUM-STATIC-NEXT:    retq
;
; LARGE-STATIC-LABEL: lea_global_fn:
; LARGE-STATIC:       # %bb.0:
; LARGE-STATIC-NEXT:    movabsq $global_fn, %rax
; LARGE-STATIC-NEXT:    retq
;
; SMALL-PIC-LABEL: lea_global_fn:
; SMALL-PIC:       # %bb.0:
; SMALL-PIC-NEXT:    leaq global_fn(%rip), %rax
; SMALL-PIC-NEXT:    retq
;
; MEDIUM-PIC-LABEL: lea_global_fn:
; MEDIUM-PIC:       # %bb.0:
; MEDIUM-PIC-NEXT:    movabsq $global_fn, %rax
; MEDIUM-PIC-NEXT:    retq
;
; LARGE-PIC-LABEL: lea_global_fn:
; LARGE-PIC:       # %bb.0:
; LARGE-PIC-NEXT:  .Ltmp6:
; LARGE-PIC-NEXT:    leaq .Ltmp6(%rip), %rcx
; LARGE-PIC-NEXT:    movabsq $_GLOBAL_OFFSET_TABLE_-.Ltmp6, %rax
; LARGE-PIC-NEXT:    addq %rax, %rcx
; LARGE-PIC-NEXT:    movabsq $global_fn@GOTOFF, %rax
; LARGE-PIC-NEXT:    addq %rcx, %rax
; LARGE-PIC-NEXT:    retq
  ret void ()* @global_fn
}

define dso_local void ()* @lea_extern_fn() #0 {
; SMALL-STATIC-LABEL: lea_extern_fn:
; SMALL-STATIC:       # %bb.0:
; SMALL-STATIC-NEXT:    movl $extern_fn, %eax
; SMALL-STATIC-NEXT:    retq
;
; MEDIUM-STATIC-LABEL: lea_extern_fn:
; MEDIUM-STATIC:       # %bb.0:
; MEDIUM-STATIC-NEXT:    movabsq $extern_fn, %rax
; MEDIUM-STATIC-NEXT:    retq
;
; LARGE-STATIC-LABEL: lea_extern_fn:
; LARGE-STATIC:       # %bb.0:
; LARGE-STATIC-NEXT:    movabsq $extern_fn, %rax
; LARGE-STATIC-NEXT:    retq
;
; SMALL-PIC-LABEL: lea_extern_fn:
; SMALL-PIC:       # %bb.0:
; SMALL-PIC-NEXT:    movq extern_fn@GOTPCREL(%rip), %rax
; SMALL-PIC-NEXT:    retq
;
; MEDIUM-PIC-LABEL: lea_extern_fn:
; MEDIUM-PIC:       # %bb.0:
; MEDIUM-PIC-NEXT:    movq extern_fn@GOTPCREL(%rip), %rax
; MEDIUM-PIC-NEXT:    retq
;
; LARGE-PIC-LABEL: lea_extern_fn:
; LARGE-PIC:       # %bb.0:
; LARGE-PIC-NEXT:  .Ltmp7:
; LARGE-PIC-NEXT:    leaq .Ltmp7(%rip), %rax
; LARGE-PIC-NEXT:    movabsq $_GLOBAL_OFFSET_TABLE_-.Ltmp7, %rcx
; LARGE-PIC-NEXT:    addq %rcx, %rax
; LARGE-PIC-NEXT:    movabsq $extern_fn@GOT, %rcx
; LARGE-PIC-NEXT:    movq (%rax,%rcx), %rax
; LARGE-PIC-NEXT:    retq
  ret void ()* @extern_fn
}

attributes #0 = { noinline nounwind uwtable }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{!"clang version 7.0.0 "}
