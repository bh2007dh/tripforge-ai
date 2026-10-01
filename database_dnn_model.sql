-- ==============================================================================
-- TRIPFORGE AI - NEURAL NETWORK MODELS (BIGQUERY ML / SQL)
-- 1. DNN_CLASSIFIER: Booking Conversion & User Preference Prediction
-- 2. DNN_REGRESSOR: Dynamic Pricing & Seasonal Yield Optimization
-- ==============================================================================

-- STEP 1: Feature Extraction Table for Training
CREATE OR REPLACE TABLE `tripforge_ai.traveler_booking_features` AS
SELECT
  booking_id,
  destination_id,
  region,                             -- Categorical (North, South, West, East, Islands)
  vibe_category,                      -- Categorical (Mountains, Beach, Heritage, Nature, Wildlife, Spiritual)
  trip_duration_days,                 -- Numeric
  package_base_price,                 -- Numeric
  carbon_kg,                          -- Numeric (CO2e emissions)
  crowd_density_index,                -- Numeric (0 to 100)
  traveler_party_size,                -- Numeric (1 solo, 2 duo, 3+ group)
  user_search_lead_days,              -- Numeric (Days prior to departure)
  is_monsoon_season,                  -- Binary (0 or 1)
  is_booked                           -- Target Label (1: Booked, 0: Abandoned)
FROM `tripforge_ai.raw_traveler_sessions`
WHERE session_date >= '2025-01-01';


-- STEP 2: Deep Neural Network Classifier Model (DNN_CLASSIFIER)
CREATE OR REPLACE MODEL `tripforge_ai.booking_conversion_dnn_model`
OPTIONS (
  model_type = 'DNN_CLASSIFIER',
  hidden_units = [128, 64, 32],       -- 3-layer deep feedforward neural network
  activation_fn = 'RELU',             -- Rectified Linear Unit
  dropout = 0.2,                      -- Regularization dropout rate to prevent overfitting
  optimizer = 'ADAM',                 -- Adaptive Moment Estimation
  learn_rate = 0.001,
  batch_size = 64,
  max_iterations = 50,
  early_stop = TRUE,
  input_label_cols = ['is_booked'],
  auto_class_weights = TRUE           -- Handles class imbalance automatically
) AS
SELECT
  region,
  vibe_category,
  trip_duration_days,
  package_base_price,
  carbon_kg,
  crowd_density_index,
  traveler_party_size,
  user_search_lead_days,
  is_monsoon_season,
  is_booked
FROM `tripforge_ai.traveler_booking_features`;


-- STEP 3: Model Evaluation (Accuracy, Precision, Recall, ROC AUC, F1 Score)
SELECT
  *
FROM
  ML.EVALUATE(
    MODEL `tripforge_ai.booking_conversion_dnn_model`,
    (
      SELECT
        region,
        vibe_category,
        trip_duration_days,
        package_base_price,
        carbon_kg,
        crowd_density_index,
        traveler_party_size,
        user_search_lead_days,
        is_monsoon_season,
        is_booked
      FROM `tripforge_ai.traveler_booking_test_split`
    )
  );


-- STEP 4: Real-Time Inference Query for Live Traveler Recommendation
SELECT
  session_id,
  destination_id,
  predicted_is_booked,
  predicted_is_booked_probs[OFFSET(0)].prob AS booking_conversion_probability
FROM
  ML.PREDICT(
    MODEL `tripforge_ai.booking_conversion_dnn_model`,
    (
      SELECT
        session_id,
        destination_id,
        region,
        vibe_category,
        trip_duration_days,
        package_base_price,
        carbon_kg,
        crowd_density_index,
        traveler_party_size,
        user_search_lead_days,
        is_monsoon_season
      FROM `tripforge_ai.live_search_events`
    )
  )
ORDER BY booking_conversion_probability DESC;


-- STEP 5: Deep Neural Network Regressor for Dynamic Pricing (DNN_REGRESSOR)
CREATE OR REPLACE MODEL `tripforge_ai.dynamic_pricing_dnn_model`
OPTIONS (
  model_type = 'DNN_REGRESSOR',
  hidden_units = [256, 128, 64],
  activation_fn = 'RELU',
  dropout = 0.15,
  optimizer = 'ADAM',
  learn_rate = 0.0005,
  max_iterations = 60,
  input_label_cols = ['optimal_dynamic_price']
) AS
SELECT
  destination_id,
  region,
  vibe_category,
  historical_demand_score,
  competitor_avg_price,
  days_until_departure,
  weather_forecast_risk_index,
  optimal_dynamic_price
FROM `tripforge_ai.historical_pricing_training_data`;
