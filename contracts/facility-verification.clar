;; Facility Verification Contract
;; Validates healthcare providers and their credentials

(define-data-var admin principal tx-sender)

;; Data map to store verified facilities
(define-map verified-facilities
  principal
  {
    name: (string-utf8 100),
    license-number: (string-utf8 50),
    facility-type: (string-utf8 50),
    verification-date: uint,
    is-active: bool
  }
)

;; Public function to register a new healthcare facility
;; Can only be called by the admin
(define-public (register-facility
    (facility-principal principal)
    (name (string-utf8 100))
    (license-number (string-utf8 50))
    (facility-type (string-utf8 50)))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (asserts! (is-none (map-get? verified-facilities facility-principal)) (err u100))
    (ok (map-set verified-facilities
      facility-principal
      {
        name: name,
        license-number: license-number,
        facility-type: facility-type,
        verification-date: block-height,
        is-active: true
      }
    ))
  )
)

;; Public function to deactivate a facility
(define-public (deactivate-facility (facility-principal principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (asserts! (is-some (map-get? verified-facilities facility-principal)) (err u404))
    (match (map-get? verified-facilities facility-principal)
      facility-data (ok (map-set verified-facilities
        facility-principal
        (merge facility-data { is-active: false })
      ))
      (err u404)
    )
  )
)

;; Public function to reactivate a facility
(define-public (reactivate-facility (facility-principal principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (asserts! (is-some (map-get? verified-facilities facility-principal)) (err u404))
    (match (map-get? verified-facilities facility-principal)
      facility-data (ok (map-set verified-facilities
        facility-principal
        (merge facility-data { is-active: true })
      ))
      (err u404)
    )
  )
)

;; Read-only function to check if a facility is verified
(define-read-only (is-verified (facility-principal principal))
  (match (map-get? verified-facilities facility-principal)
    facility-data (is-eq (get is-active facility-data) true)
    false
  )
)

;; Read-only function to get facility details
(define-read-only (get-facility-details (facility-principal principal))
  (map-get? verified-facilities facility-principal)
)

;; Function to transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (ok (var-set admin new-admin))
  )
)
