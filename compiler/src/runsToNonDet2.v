Require Import lib.LibTacticsMin.
Require Export riscv.util.PowerFunc.


Section RunsTo.

  Variable State: Type.
  Variable step: State -> (State -> Prop) -> Prop.

  Inductive runsTo(initial: State)(P: State -> Prop): Prop :=
    | runsToDone:
        P initial ->
        runsTo initial P
    | runsToStep: forall midset,
        step initial midset ->
        (forall mid, midset mid -> runsTo mid P) ->
        runsTo initial P.

  (*
  Lemma runsToSatisfying_exists_fuel: forall initial P,
    runsTo initial P ->
    exists fuel, P (power_func step fuel initial).
  Proof.
    introv R. induction R.
    - exists 0. exact H.
    - destruct IHR as [fuel IH]. exists (S fuel).
      simpl.
      rewrite <- power_func_one_plus_n.
      exact IH.
  Qed.
  *)

  Lemma runsTo_trans: forall P Q initial,
    runsTo initial P ->
    (forall middle, P middle -> runsTo middle Q) ->
    runsTo initial Q.
  Proof.
    introv R1. induction R1; introv R2; [solve [auto]|].
    eapply runsToStep.
    (*
    - exact H. eauto. eassumption.
    - apply IHR1. apply R2.
  Qed. *)
  Admitted.


  Lemma runsToSatisfying_imp: forall (P Q : State -> Prop) initial,
    runsTo initial P ->
    (forall final, P final -> Q final) ->
    runsTo initial Q.
  Proof.
    introv R1 R2. eapply runsTo_trans; [eassumption|].
    intros final Pf. apply runsToDone. auto.
  Qed.

End RunsTo.