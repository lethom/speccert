Require Import SpecCert.x86.

Require Import SpecCert.Smm.Delta.Invariant.

Lemma disable_interrupt_inv:
  preserve_inv (software DisableInterrupt).
Proof.
  unfold preserve_inv.
  unfold inv.
  unfold smramc_inv, smram_code_inv, smrr_inv, cache_clean_inv.
  intros a a' [Hsmramc [Hsmram [Hsmrr Hclean]]] Hstep.
  inversion Hstep as [Hpre Hpost].
  unfold disable_interrupt_post in Hpost.
  unfold disable_interrupt in Hpost.
  rewrite Hpost.
  simpl.
  do 3 (try split); trivial.
Qed.
