Require Import Coq.Bool.Bool.

Require Import SpecCert.Cache.Cache_def.
Require Import SpecCert.Address.
Require Import SpecCert.Utils.
Require Import SpecCert.Map.

Definition cache_hit
           {S     :Type}
           (cache :Cache S)
           (pa    :PhysicalAddress)
           :Prop :=
  addr_eq pa (tag (find_in_map cache (phys_to_index pa))).

Definition cache_hit_dec
           {S     :Type}
           (cache :Cache S)
           (pa:PhysicalAddress)
           : {cache_hit cache pa}+{~ cache_hit cache pa}.
refine (
    decide_dec (phys_addr_eq_dec pa
                                 (tag
                                    (find_in_map cache
                                                 (phys_to_index pa)
                                    )
                                 )
               )
  ); unfold cache_hit; simpl in *; trivial.
Defined.

Definition cache_location_is_dirty
           {S     :Type}
           (cache :Cache S)
           (pa    :PhysicalAddress) :=
  dirty (find_in_map cache (phys_to_index pa)) = true.

Definition cache_location_is_dirty_dec
           {S     :Type}
           (cache :Cache S)
           (pa    :PhysicalAddress)
  : {cache_location_is_dirty cache pa}+{~ cache_location_is_dirty cache pa}.
refine (
    decide_dec (
        bool_dec
          (dirty
             (find_in_map cache (phys_to_index pa))
          )
          true
      )
  );
unfold cache_location_is_dirty;
trivial.
Defined.

Definition cache_is_well_formed
           {S     :Type}
           (cache :Cache S) :=
  forall pa:PhysicalAddress,
    phys_to_index pa = phys_to_index (tag (find_in_map cache (phys_to_index pa))).