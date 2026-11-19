;; not-not
;;
;; An open-mint test token for the Zero To Batch Tx demo. Testnet only.
;; Anyone can mint. Each call to mint gives the caller one token, so two calls
;; signed in a row leave a balance of two. The token has no value.
;;
;; The functions follow SIP-010. The contract does not declare impl-trait,
;; because no SIP-010 trait contract answered on testnet when this was written.

(define-fungible-token not-not)

(define-constant ERR_NOT_SENDER (err u4))

(define-constant MINT_AMOUNT u1)

;; Mints one token to the caller. Moves nothing out of any account.
(define-public (mint)
  (begin
    (try! (ft-mint? not-not MINT_AMOUNT tx-sender))
    (print {
      event: "mint",
      recipient: tx-sender,
      amount: MINT_AMOUNT,
    })
    (ok MINT_AMOUNT)
  )
)

(define-public (transfer
    (amount uint)
    (sender principal)
    (recipient principal)
    (memo (optional (buff 34)))
  )
  (begin
    (asserts! (or (is-eq tx-sender sender) (is-eq contract-caller sender))
      ERR_NOT_SENDER
    )
    (try! (ft-transfer? not-not amount sender recipient))
    (match memo
      to-print (print to-print)
      0x
    )
    (ok true)
  )
)

(define-read-only (get-name)
  (ok "not-not")
)

(define-read-only (get-symbol)
  (ok "NOT-NOT")
)

(define-read-only (get-decimals)
  (ok u0)
)

(define-read-only (get-balance (who principal))
  (ok (ft-get-balance not-not who))
)

(define-read-only (get-total-supply)
  (ok (ft-get-supply not-not))
)

;; The metadata link is pinned to a commit, so it cannot change after deployment.
(define-read-only (get-token-uri)
  (ok (some u"https://raw.githubusercontent.com/wmnonstx/nothing/67f008441d2d6defcdcd2c2d8f1ec276f3f10b27/assets/not-not.json"))
)
