!(import! &self "../src/deduction.metta")

!(simple-deduction
   (STV 0.95 0.90)
   (STV 0.90 0.85))

!(deduction
   (STV 0.98 0.92)
   0.90
   (STV 0.95 0.88)
   0.95)