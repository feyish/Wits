;; Proof-of-Creativity Platform Smart Contract
;; Allows creators to submit works and validators to verify creativity

;; Constants
(define-constant contract-owner tx-sender)
(define-constant min-votes u3)
(define-constant validation-period u144) ;; ~1 day in blocks
(define-constant validator-reward u10) ;; reward in tokens

;; Error codes
(define-constant err-not-owner (err u100))
(define-constant err-already-submitted (err u101))
(define-constant err-not-found (err u102))
(define-constant err-already-voted (err u103))
(define-constant err-voting-closed (err u104))
(define-constant err-insufficient-votes (err u105))

;; Data variables
(define-data-var next-submission-id uint u0)
(define-data-var next-nft-id uint u0)

;; Principal -> uint mapping for validator reputation
(define-map validator-scores principal uint)

;; Creative work submission structure
(define-map submissions
    uint
    {
        creator: principal,
        content-hash: (buff 32),
        submission-height: uint,
        positive-votes: uint,
        negative-votes: uint,
        verified: bool
    }
)

;; Track who has voted on what
(define-map votes
    {submission-id: uint, validator: principal}
    bool
)

;; NFT tracking
(define-non-fungible-token proof-of-creativity uint)
