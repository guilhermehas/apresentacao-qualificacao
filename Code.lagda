\begin{code}
module Code where
\end{code}

definition of natural numbers: Peano Style.

%<*nat>
\begin{code}
data ℕ : Set where
   zero  : ℕ
   suc   : ℕ → ℕ
\end{code}
%</nat>

Some pragmas to tell Agda to use decimal numbers to represent ℕ values.

\begin{code}
{-# BUILTIN NATURAL ℕ #-}
\end{code}

Addition of natural numbers

%<*plus>
\begin{code}
_+_ : ℕ → ℕ → ℕ
zero   + n = n
suc m  + n = suc (m + n)
\end{code}
%</plus>

Example 1: List concatenation
-----------------------------

Definition of lists.

%<*listdef>
\begin{code}
data List (A : Set) : Set where
  []  : List A
  _::_ : A → List A → List A
\end{code} 
%</listdef>

Functions over lists

%<*length>
\begin{code}
length : {A : Set} → List A → ℕ
length []       = 0
length (x :: xs) = suc (length xs)
\end{code}
%</length>

%<*concat>
\begin{code}
_++_ : {A : Set} → List A → List A → List A
[] ++ ys       = ys
(x :: xs) ++ ys = x :: (xs ++ ys)
\end{code}
%</concat>

%<*vector>
\begin{code}
data Vec (A : Set) : ℕ → Set where
  []  : Vec A 0
  _::_ : ∀ {n} → A → Vec A n → Vec A (suc n)
\end{code}
%</vector>

%<*vectorhead>
\begin{code}
head : ∀ {A : Set}{n : ℕ} → Vec A (suc n) → A
head (x :: xs) = x
\end{code}
%</vectorhead>

%<*zipWith>
\begin{code}
zipWith : ∀ {A B C : Set}{n : ℕ} → (A → B → C)
          → Vec A n → Vec B n → Vec C n
zipWith _ [] [] = []
zipWith f (x :: xs) (y :: ys) = f x y :: zipWith f xs ys
\end{code}
%</zipWith>

%<*vectorconcat>
\begin{code}
_++v_ : ∀ {n m A} → Vec A n → Vec A m → Vec A (n + m)
[] ++v ys = ys
(x :: xs) ++v ys = x :: (xs ++v ys) 
\end{code}
%</vectorconcat>

Example 2: List lookup
------------------------

Maybe data type.

%<*maybe>
\begin{code}
data Maybe (A : Set) : Set where
  nothing : Maybe A
  just    : A → Maybe A
\end{code}
%</maybe>

%<*listhead>
\begin{code}
hd : ∀ {A} → List A → Maybe A
hd []       = nothing
hd (x :: xs) = just x 
\end{code}
%</listhead>


Sample lookup without a strong spec.

%<*lookupweak>
\begin{code}
lookupWeak : {A : Set} → ℕ → List A → Maybe A
lookupWeak n       []       = nothing
lookupWeak 0       (x :: _)  = just x
lookupWeak (suc n) (_ :: xs) = lookupWeak n xs
\end{code}
%</lookupweak>


\begin{code}
infix 4 _≡_
data _≡_ {a} {A : Set a} (x : A) : A → Set a where
  refl : x ≡ x
{-# BUILTIN EQUALITY _≡_  #-}
data SimpleBlock : Set where

hashBlock : SimpleBlock → ℕ
hashBlock block = 0
\end{code}


%<*blockchain>
\begin{code}
data GenesisBlock : ℕ → Set where
  block : (n : ℕ) → (sb : SimpleBlock) → n ≡ hashBlock sb → GenesisBlock n

data Block : ℕ → ℕ → Set where
  block : (n : ℕ) → (m : ℕ) → (sb : SimpleBlock) →  m ≡ hashBlock sb → Block n m

data Blockchain : ℕ → Set where
  gen : {n : ℕ} → GenesisBlock n → Blockchain n
  cons : {n m : ℕ} → Block n m → Blockchain n → Blockchain m
\end{code}
%</blockchain>
