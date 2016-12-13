Require Import SpecCert.Formalism.

Require Import SpecCert.x86.Event.
Require Import SpecCert.x86.Architecture.
Require Import SpecCert.x86.Transition.Event.

Definition x86Context
           (S: Type) :=
  HardwareSoftwareMapping (Architecture S) S.

Definition pre_condition
           {S :Type} :=
  Architecture S -> Prop.

Definition post_condition
           {S :Type} :=
  Architecture S -> Architecture S -> Prop.

Definition no_pre
           {S :Type} :=
  fun (a: Architecture S) => True.

Definition id_post
           {S :Type} :=
  fun (a a':Architecture S) => a = a'.

Definition x86_precondition
           {Label: Type}
           (a:  Architecture Label)
           (ev: x86Event)
  : Prop :=
  match ev with
  | software DisableInterrupt     => no_pre
  | software EnableInterrupt      => no_pre
  | software (Write addr value)   => no_pre
  | software (Read addr value)    => read_pre addr value
  | software OpenSmram            => open_smram_pre
  | software CloseSmram           => close_smram_pre
  | software LockSmramc           => lock_smramc_pre
  | software (NextInstruction pa) => no_pre
  | hardware (ReceiveInterrupt i) => no_pre
  | hardware (Exec value)         => read_pre (ip (proc a)) value
  end a.

Definition x86_postcondition
           {S:       Type}
           (context: x86Context S)
           (h:       Architecture S)
           (ev:      x86Event)
           (h':      Architecture S)
  : Prop :=
  match ev with
  | software DisableInterrupt     => disable_interrupt_post
  | software EnableInterrupt      => enable_interrupt_post
  | software (Write addr value)   => write_post context addr value
  | software (Read addr value)    => read_post addr
  | software OpenSmram            => open_smram_post
  | software CloseSmram           => close_smram_post
  | software LockSmramc           => lock_smramc_post
  | software (NextInstruction pa) => nextinstr_post pa
  | hardware (ReceiveInterrupt i) => receive_interrupt_post i
  | hardware (Exec value)         => read_post (ip (proc h))
  end h h'.
