;; Usage Tracking Contract
;; Monitors consumption of resources by healthcare facilities

(define-data-var admin principal tx-sender)

;; Data structure for usage records
(define-map usage-records
  { usage-id: uint }
  {
    facility-principal: principal,
    resource-id: uint,
    quantity-used: uint,
    allocation-id: (optional uint),
    usage-date: uint,
    recorded-at: uint,
    notes: (string-utf8 200)
  }
)

;; Counter for usage record IDs
(define-data-var next-usage-id uint u1)

;; Record resource usage
(define-public (record-usage
    (facility-principal principal)
    (resource-id uint)
    (quantity-used uint)
    (allocation-id (optional uint))
    (usage-date uint)
    (notes (string-utf8 200)))
  (let ((usage-id (var-get next-usage-id)))
    (begin
      ;; Only the facility itself or admin can record usage
      (asserts! (or (is-eq tx-sender facility-principal) (is-eq tx-sender (var-get admin))) (err u403))

      (map-set usage-records
        { usage-id: usage-id }
        {
          facility-principal: facility-principal,
          resource-id: resource-id,
          quantity-used: quantity-used,
          allocation-id: allocation-id,
          usage-date: usage-date,
          recorded-at: block-height,
          notes: notes
        }
      )
      (var-set next-usage-id (+ usage-id u1))
      (ok usage-id)
    )
  )
)

;; Get usage record details
(define-read-only (get-usage-details (usage-id uint))
  (map-get? usage-records { usage-id: usage-id })
)

;; Calculate total usage of a resource by a facility
(define-read-only (calculate-total-usage
    (facility-principal principal)
    (resource-id uint)
    (start-date uint)
    (end-date uint))
  ;; Note: In a real implementation, this would iterate through all usage records
  ;; Since Clarity doesn't support loops, this is a simplified placeholder
  ;; In practice, you would need to implement this off-chain or use a different approach
  u0
)

;; Function to transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (ok (var-set admin new-admin))
  )
)
