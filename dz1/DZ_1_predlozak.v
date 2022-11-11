(* Dokazi za ALU *)

Set Implicit Arguments.
Require Import List.
Import ListNotations.
Require Import Lia.
Require Import Coq.Arith.Arith.

(* Bit *)

Inductive B : Type :=
  | O : B
  | I : B.

Definition And (x y : B) : B :=
match x with
  | O => O
  | I => y
end.

Definition Or (x y : B) : B :=
match x with
  | O => y
  | I => I
end.

Definition Not (x : B) : B :=
match x with
  | O => I
  | I => O
end.

Definition Add (x y c : B) : B :=
match x, y with
  | O, O => c
  | I, I => c
  | _, _ => Not c
end.

Definition Rem (x y c : B) : B :=
match x, y with
  | O, O => O
  | I, I => I
  | _, _ => c
end.

(* List *)

Fixpoint AndL (x y : list B) : list B :=
match x, y with
| [], _ => []
| _, [] => []
| x :: xs, y :: ys => And x y :: AndL xs ys
end.

Fixpoint OrL (x y : list B) : list B :=
match x, y with
| [], _ => []
| _, [] => []
| x :: xs, y :: ys => Or x y :: OrL xs ys
end.

Fixpoint NotL (x : list B) : list B :=
match x with
  | [] => []
  | x :: xs => Not x :: NotL xs
end.

Fixpoint AddLr (x y : list B) (c : B) : list B :=
match x, y with
| [], _ => []
| _, [] => []
| x :: xs, y :: ys => Add x y c :: AddLr xs ys (Rem x y c)
end.

Definition AddL (x y : list B) : list B := rev (AddLr (rev x) (rev y) O).

Fixpoint IncLr (x : list B) (c : B) : list B :=
match x with
| [] => []
| x :: xs => Add x I c :: IncLr xs (Rem x I c)
end.

Definition IncL (x : list B) : list B := rev (IncLr (rev x) O).

(* ALU *)

Definition flag_zx (f : B) (x : list B) : list B :=
match f with
| I => repeat O (length x)
| O => x
end.

Definition flag_nx (f : B) (x : list B) : list B :=
match f with
| I => NotL x
| O => x
end.

Definition flag_f (f : B) (x y : list B) : list B :=
match f with
| I => AddL x y
| O => AndL x y
end.

Definition ALU (x y : list B) (zx nx zy ny f no : B) : list B := 
  flag_nx no (flag_f f (flag_nx nx (flag_zx zx x)) (flag_nx ny (flag_zx zy y))).

(* Teoremi *)

Lemma ALU_zero (x y : list B) :
  length x = length y -> ALU x y I O I O I O = repeat O (length x).
Proof. 
  intros H. simpl. rewrite ! H. unfold AddL.
  assert(Zero_rev : forall (n : nat), rev(repeat O n) = repeat O n).
  {
   intros. induction n.
   - now simpl.
   - simpl. rewrite IHn. Search(_ :: _ = _ ++ _). 
     now rewrite repeat_cons.  
  }
  rewrite ! Zero_rev.
  assert(Zero_add : forall (n : nat), AddLr (repeat O n) (repeat O n) O = repeat O n).
  {
   intros. induction n.
   - now simpl.
   - simpl. now f_equal.  
  }
  now rewrite Zero_add.
Qed.

Lemma ALU_minus_one (x y : list B) : 
  length x = length y -> ALU x y I I I O I O = repeat I (length x).
Proof. Abort.

Lemma ALU_x (x y : list B) : 
  length x = length y -> ALU x y O O I I O O = x.
Proof. 
  intros H. simpl. rewrite <- H.
  assert(Zero_not : forall (n : nat), NotL (repeat O n) = (repeat I n)).
  {
    intros n. induction n.
    - now simpl.
    - simpl. now f_equal. 
  }
  rewrite Zero_not. simpl.
  assert (H_AndL : forall (l : list B), AndL l (repeat I (length l)) = l).
  {
    intros. induction l.
    - now simpl.
    - simpl. rewrite IHl. f_equal. now destruct a.  
  }
  now rewrite H_AndL.
Qed.

Lemma ALU_y (x y : list B) : 
  length x = length y -> ALU x y I I O O O O = y.
Proof. Abort.

Lemma ALU_Not_x (x y : list B) : 
  length x = length y -> ALU x y O O I I O I = NotL x.
Proof. Abort.

Lemma ALU_Not_y (x y : list B) : 
  length x = length y -> ALU x y I I O O O I = NotL y.
Proof. Abort.

Lemma ALU_Add (x y : list B) : 
  length x = length y -> ALU x y O O O O I O = AddL x y.
Proof. Abort.

(* DZ *)

Lemma ALU_And (x y : list B) : 
  length x = length y -> ALU x y O O O O O O = AndL x y.
Proof. 
  trivial.
Qed.

(* Pomocne DeMorgan leme *)

Lemma Little_DeMorgan_1 (a b : B):
  Not (And a b) = Or (Not a) (Not b).
Proof.
  now destruct a, b.
Qed.

Lemma Little_DeMorgan_2 (a b : B):
  Not (Or a b) = And (Not a) (Not b).
Proof.
  now destruct a, b.
Qed.

Lemma ALU_Or (x y : list B) : 
  length x = length y -> ALU x y O I O I O I = OrL x y.
Proof. 
  intros H. simpl.
  assert(Double_neg_list : forall (l : list B), NotL(NotL l) = l).
  {
   induction l.
   - now simpl.
   - simpl. rewrite IHl. f_equal. destruct a ; now simpl.  
  }
  assert(Double_neg : forall(a : B), Not (Not a) = a).
  {
    now destruct a. 
  }
  assert(De_Morgan_2_reverse : forall (a b : list B), (OrL a b) = NotL(AndL (NotL a) (NotL b) )).
  {
   intros a b. revert b. induction a, b ; try now simpl.
   - simpl. rewrite ! Little_DeMorgan_1. rewrite ! Double_neg.
    f_equal. specialize (IHa b0). apply IHa.
  }
  now rewrite De_Morgan_2_reverse.
Qed.

Lemma ALU_One (n : nat) (x y : list B) :
  length x = n /\ length y = n /\ n <> 0 -> ALU x y I I I I I I = repeat O (pred n) ++ [I].
Proof. 
  intros H. simpl. destruct H as [H1 [H2 H3]].
  rewrite H1, H2.
  assert (H_NotL : forall (m : nat), NotL (repeat O m) = repeat I m).
  {
    intros m. induction m.
    - now simpl.
    - simpl. now rewrite IHm.
  }
  assert (H_NotL2 : forall (m : nat), NotL (repeat I m) = repeat O m).
  {
    intros m. induction m.
    - now simpl.
    - simpl. now rewrite IHm.
  }
  rewrite ! H_NotL. unfold AddL.

  assert (H_RevL_1 : forall (b : B) (m : nat), repeat b m ++ [b] = b :: repeat b m).
  {
    intros. induction m.
    - simpl. reflexivity.
    - simpl. rewrite IHm. reflexivity.
  }
  
  assert (H_RevL_2 : forall (b : B) (m : nat), rev (repeat b m) = repeat b m).
  {
    intros. induction m.
    - simpl. reflexivity.
    - simpl. rewrite IHm. rewrite H_RevL_1. reflexivity.
  }
  rewrite ! H_RevL_2.
  Eval compute in (AddLr (repeat I 5) (repeat I 5) O).
  assert (H_RevL_3 : forall (b b1 : B) (m : nat), rev (b1 :: repeat b m) = rev (repeat b m) ++ [b1]).
  {
    intros. now induction m.  
  }
  assert (H_app_3 : forall (b b1 : B) (m : nat), NotL ((repeat b m) ++ [b1]) = (NotL (repeat b m)) ++ [(Not b1)]).
  {
    intros. induction m.
      - now simpl.
      - simpl. now f_equal.  
  }
  assert(H_AddL_Ultimate_Helper : forall (m : nat), AddLr (repeat I m) (repeat I m) I = repeat I m).
  {
   intros. induction m.
   -- now simpl.
   -- simpl. now f_equal.
  }
  assert(H_AddLr_Ultimate : forall(m : nat), (m <> 0) -> AddLr (repeat I m) (repeat I m) O = O :: (repeat I (Init.Nat.pred m))).
  {
    intros m. destruct m.
      - now intros.
      - intros _. simpl. f_equal. apply H_AddL_Ultimate_Helper. 
  }
  
  rewrite H_AddLr_Ultimate.
    - rewrite H_RevL_3. rewrite H_RevL_2. 
    rewrite ! H_app_3. now rewrite H_NotL2.
    - assumption. 
Qed.







