Require Import SpecCert.x86.
Require Import SpecCert.Smm.Delta.Invariant.
Require Import SpecCert.Smm.Software.

Lemma receive_interrupt_inv:
  forall i :Interrupt,
    preserve_inv (hardware (ReceiveInterrupt i)).
Proof.
  unfold preserve_inv.
  unfold inv.
  unfold smramc_inv, smram_code_inv, smrr_inv, cache_clean_inv, ip_inv, smbase_inv.
  unfold context.
  intros i a a' [Hsmramc [Hsmram [Hsmrr [Hclean [Hip Hsmbase]]]]] Hstep.
  inversion Hstep as [Hpre Hpost].
  unfold receive_interrupt_post, receive_interrupt, receive_smi in Hpost.
  destruct (will_process_interrupt_dec (proc a) i);
    destruct i;
    rewrite Hpost; (split; [| split; [| split; [| split; [| split]]]]); simpl; trivial.
Qed.