;; Demand Forecasting Contract
;; Predicts resource requirements based on historical data and trends

(define-data-var admin principal tx-sender)

;; Data structure for historical demand records
(define-map historical-demand
  { facility-principal: principal, resource-id: uint, period: uint }
  {
    quantity: uint,
    recorded-at: uint
  }
)

;; Data structure for demand forecasts
(define-map demand-forecasts
  { facility-principal: principal, resource-id: uint, future-period: uint }
  {
    predicted-quantity: uint,
    confidence-level: uint,  ;; 1-100 representing percentage
    created-at: uint
  }
)

;; Record historical demand for a resource at a facility
(define-public (record-historical-demand
    (facility-principal principal)
    (resource-id uint)
    (period uint)
    (quantity uint))
  (begin
    ;; Only the facility itself or admin can record demand
    (asserts! (or (is-eq tx-sender facility-principal) (is-eq tx-sender (var-get admin))) (err u403))

    (map-set historical-demand
      { facility-principal: facility-principal, resource-id: resource-id, period: period }
      {
        quantity: quantity,
        recorded-at: block-height
      }
    )
    (ok true)
  )
)

;; Create a demand forecast
;; In a real implementation, this would use more sophisticated algorithms
;; Here we're using a simplified approach for demonstration
(define-public (create-forecast
    (facility-principal principal)
    (resource-id uint)
    (future-period uint)
    (predicted-quantity uint)
    (confidence-level uint))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (asserts! (<= confidence-level u100) (err u400))

    (map-set demand-forecasts
      { facility-principal: facility-principal, resource-id: resource-id, future-period: future-period }
      {
        predicted-quantity: predicted-quantity,
        confidence-level: confidence-level,
        created-at: block-height
      }
    )
    (ok true)
  )
)

;; Get historical demand for a specific period
(define-read-only (get-historical-demand
    (facility-principal principal)
    (resource-id uint)
    (period uint))
  (map-get? historical-demand
    { facility-principal: facility-principal, resource-id: resource-id, period: period }
  )
)

;; Get forecast for a future period
(define-read-only (get-forecast
    (facility-principal principal)
    (resource-id uint)
    (future-period uint))
  (map-get? demand-forecasts
    { facility-principal: facility-principal, resource-id: resource-id, future-period: future-period }
  )
)

;; Function to transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (ok (var-set admin new-admin))
  )
)
