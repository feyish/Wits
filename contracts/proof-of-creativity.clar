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

;; Functions

;; Submit a new creative work
(define-public (submit-work (content-hash (buff 32)))
    (let
        (
            (submission-id (var-get next-submission-id))
        )
        (map-set submissions submission-id
            {
                creator: tx-sender,
                content-hash: content-hash,
                submission-height: block-height,
                positive-votes: u0,
                negative-votes: u0,
                verified: false
            }
        )
        (var-set next-submission-id (+ submission-id u1))
        (ok submission-id)
    )
)

;; Vote on a submission
(define-public (vote (submission-id uint) (is-positive bool))
    (let
        (
            (submission (unwrap! (map-get? submissions submission-id) (err err-not-found)))
            (vote-key {submission-id: submission-id, validator: tx-sender})
        )
        ;; Check if voting period is still open
        (asserts! (< block-height (+ (get submission-height submission) validation-period)) (err err-voting-closed))
        ;; Check if validator hasn't voted already
        (asserts! (is-none (map-get? votes vote-key)) (err err-already-voted))

        ;; Record vote
        (map-set votes vote-key true)

        ;; Update vote counts
        (map-set submissions submission-id
            (merge submission
                {
                    positive-votes: (if is-positive
                        (+ (get positive-votes submission) u1)
                        (get positive-votes submission)
                    ),
                    negative-votes: (if is-positive
                        (get negative-votes submission)
                        (+ (get negative-votes submission) u1)
                    )
                }
            )
        )

        ;; Update validator score
        (let
            (
                (current-score (default-to u0 (map-get? validator-scores tx-sender)))
            )
            (map-set validator-scores tx-sender (+ current-score u1))
        )

        (ok true)
    )
)
