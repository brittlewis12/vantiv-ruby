module Vantiv
  class ResponseCodeMap
    class NoResponseDetailsFoundError < StandardError; end

    def self.get_error_description(code:)
      error_details = RESPONSE_CODES_TO_DETAILS[code]
      raise NoResponseDetailsFoundError if error_details.nil?
      error_details['description']
    end

    RESPONSE_CODES_TO_DETAILS = {
      '000' => {
        'response_message' => 'Approved',
        'response_type' => 'Approved',
        'description' => 'No action required.'
      },
      '010' => {
        'response_message' => 'Partially Approved',
        'response_type' => 'Approved',
        'description' => 'The authorized amount is less than the requested amount.'
      },
      '100' => {
        'response_message' => 'Processing Network Unavailable',
        'response_type' => 'Soft Decline',
        'description' => 'There is a problem with the card network. Contact the network for more information.'
      },
      '101' => {
        'response_message' => 'Issuer Unavailable',
        'response_type' => 'Soft Decline',
        'description' => 'There is a problem with the issuer network. Please contact the issuing bank.'
      },
      '102' => {
        'response_message' => 'Re-submit Transaction',
         'response_type' => 'Soft Decline',
         'description' => 'There is a temporary problem with your submission. Please re-submit the transaction.'
      },
      '110' => {
        'response_message' => 'Insufficient Funds',
        'response_type' => 'Soft Decline',
        'description' => 'The card does not have enough funds to cover the transaction.'
      },
      '111' => {
        'response_message' => 'Authorization amount has already been depleted',
        'response_type' => 'Hard Decline',
        'description' => 'The total amount of the original Authorization has been used.'
      },
      '120' => {
        'response_message' => 'Call Issuer',
        'response_type' => 'Referral or Soft Decline',
        'description' => 'There is an unspecified problem, contact the issuing bank.'
      },
      '121' => {
        'response_message' => 'Call AMEX',
        'response_type' => 'Referral',
        'description' => 'There is an unspecified problem; contact AMEX.'
      },
      '122' => {
        'response_message' => 'Call Diners Club',
        'response_type' => 'Referral',
        'description' => 'There is an unspecified problem; contact Diners Club.'
      },
      '123' => {
        'response_message' => 'Call Discover',
        'response_type' => 'Referral',
        'description' => 'There is an unspecified problem contact Discover.'
      },
      '124' => {
        'response_message' => 'Call JBS',
        'response_type' => 'Referral',
        'description' => 'There is an unspecified problem; contact JBS.'
      },
      '125' => {
        'response_message' => 'Call Visa/MasterCard',
        'response_type' => 'Referral',
        'description' => 'There is an unspecified problem; contact Visa or MasterCard.'
      },
      '126' => {
        'response_message' => 'Call Issuer - Update Cardholder Data',
        'response_type' => 'Referral',
        'description' => 'Some data is out of date; contact the issuer to update this information.'
      },
      '127' => {
        'response_message' => 'Exceeds Approval Amount Limit',
        'response_type' => 'Hard Decline',
        'description' => 'This transaction exceeds the daily approval limit for the card.'
      },
      '130' => {
        'response_message' => 'Call Indicated Number',
        'response_type' => 'Referral',
        'description' => 'There is an unspecified problem; contact the phone number provided.'
      },
      '140' => {
        'response_message' => 'Update Cardholder Data',
        'response_type' => 'Referral',
        'description' => 'Cardholder data is incorrect; contact the issuing bank.'
      },
      '191' => {
        'response_message' => 'The merchant is not registered in the update program.',
        'response_type' => 'N/A',
        'description' => 'This is an Account Updater response indicating a set-up problem that must be resolved prior to submitting another request file. Escalate this to your Litle Customer Experience Manager.'
      },
      '192' => {
        'response_message' => 'Merchant not certified/enabled for IIAS',
        'response_type' => 'Hard Decline',
        'description' => 'Your organization is not certified or enabled for IIAS/FSA transactions.'
      },
      '206' => {
        'response_message' => 'Issuer Generated Error',
        'response_type' => 'Soft Decline',
        'description' => 'An unspecified error was returned by the issuer. Please retry the transaction and if the problem persist, contact the issuing bank.'
      },
      '207' => {
        'response_message' => 'Pickup card - Other than Lost/Stolen',
        'response_type' => 'Hard Decline',
        'description' => 'The issuer indicated that the gift card should be removed from use.'
      },
      '209' => {
        'response_message' => 'Invalid Amount',
        'response_type' => 'Hard Decline',
        'description' => 'The specified amount is invalid for this transaction.'
      },
      '211' => {
        'response_message' => 'Reversal Unsuccessful',
        'response_type' => 'Hard Decline',
        'description' => 'The reversal transaction was unsuccessful.'
      },
      '212' => {
        'response_message' => 'Missing Data',
        'response_type' => 'Hard Decline',
        'description' => 'Contact Litle.'
      },
      '213' => {
        'response_message' => 'Pickup Card - Lost Card',
        'response_type' => 'Hard Decline',
        'description' => 'The submitted card was reported as lost and should be removed from use.'
      },
      '214' => {
        'response_message' => 'Pickup Card - Stolen Card',
        'response_type' => 'Hard Decline',
        'description' => 'The submitted card was reported as stolen and should be removed from use.'
      },
      '215' => {
        'response_message' => 'Restricted Card',
        'response_type' => 'Hard Decline',
        'description' => 'The specified Gift Card is not available for use.'
      },
      '216' => {
        'response_message' => 'Invalid Deactivate',
        'response_type' => 'Hard Decline',
        'description' => 'The Deactivate transaction is invalid for the specified card.'
      },
      '217' => {
        'response_message' => 'Card Already Active',
        'response_type' => 'Hard Decline',
        'description' => 'The submitted card is already active.'
      },
      '218' => {
        'response_message' => 'Card Not Active',
        'response_type' => 'Hard Decline',
        'description' => 'The submitted card has not been activated.'
      },
      '219' => {
        'response_message' => 'Card Already Deactivate',
        'response_type' => 'Hard Decline',
        'description' => 'The submitted card has already been deactivated.'
      },
      '221' => {
        'response_message' => 'Over Max Balance',
        'response_type' => 'Hard Decline',
        'description' => 'The activate or load amount exceeds the maximum allowed for the specified gift Card.'
      },
      '222' => {
        'response_message' => 'Invalid Activate',
        'response_type' => 'Hard Decline',
        'description' => 'The activate transaction is not valid or can no longer be reversed.'
      },
      '223' => {
        'response_message' => 'No transaction Found for Reversal',
        'response_type' => 'Hard Decline',
        'description' => 'The transaction referenced in the reversal transaction does not exist.'
      },
      '226' => {
        'response_message' => 'Incorrect CVV',
        'response_type' => 'Hard Decline',
        'description' => 'The transaction was declined because it was submitted with the incorrect security code.'
      },
      '229' => {
        'response_message' => 'Illegal Transaction',
        'response_type' => 'Hard Decline',
        'description' => 'The transaction would violate the law.'
      },
      '251' => {
        'response_message' => 'Duplicate Transaction',
        'response_type' => 'Hard Decline',
        'description' => 'The transaction is a duplicate of a previously submitted transaction.'
      },
      '252' => {
        'response_message' => 'System Error',
        'response_type' => 'Hard Decline',
        'description' => 'Contact Litle.'
      },
      '253' => {
        'response_message' => 'Deconverted BIN',
        'response_type' => 'Hard Decline',
        'description' => 'The BIN is no longer valid.'
      },
      '254' => {
        'response_message' => 'Merchant Depleted',
        'response_type' => 'Hard Decline',
        'description' => 'No balance remains on gift Card.'
      },
      '255' => {
        'response_message' => 'Gift Card Escheated',
        'response_type' => 'Hard Decline',
        'description' => 'The Gift Card has been seized by the government while resolving an estate.'
      },
      '257' => {
        'response_message' => 'System Error (message format error)',
        'response_type' => 'Hard Decline',
        'description' => 'Issuer reported message format is incorrect. Contact Litle.'
      },
      '258' => {
        'response_message' => 'System Error (cannot process)',
        'response_type' => 'Hard Decline',
        'description' => 'Issuer reported transaction could not be processed. Contact Litle.'
      },
      '301' => {
        'response_message' => 'Invalid Account Number',
        'response_type' => 'Hard Decline',
        'description' => 'The account number is not valid; contact the cardholder to confirm information or inquire about another form of payment.'
      },
      '302' => {
        'response_message' => 'Account Number Does Not Match Payment Type',
        'response_type' => 'Hard Decline',
        'description' => 'The payment type was selected as one card type (e.g. Visa but the card number indicates a different card type (e.g.MasterCard).'
      },
      '303' => {
        'response_message' => 'Pick Up Card',
        'response_type' => 'Hard Decline',
        'description' => 'This is a card present response, but in a card not present environment. Do not process the transaction and contact the issuing bank.'
      },
      '304' => {
        'response_message' => 'Lost/Stolen Card',
        'response_type' => 'Hard Decline',
        'description' => 'The card has been designated as lost or stolen; contact the issuing bank.'
      },
      '305' => {
        'response_message' => 'Expired Card',
        'response_type' => 'Hard Decline',
        'description' => 'The card is expired.'
      },
      '306' => {
        'response_message' => 'Authorization has expired; no need to reverse',
        'response_type' => 'Hard Decline',
        'description' => 'The original Authorization is no longer valid, because it has expired. You can not perform an Authorization Reversal for an expired Authorization.'
      },
      '307' => {
        'response_message' => 'Restricted Card',
        'response_type' => 'Hard Decline',
        'description' => 'The card has a restriction preventing approval for this transaction. Please contact the issuing bank for a specific reason. You may also receive this code if the transaction was declined due to Prior Fraud Advice Filtering and you are using a schema version V8.10 or older.'
      },
      '308' => {
        'response_message' => 'Restricted Card - Chargeback',
        'response_type' => 'Hard Decline',
        'description' => 'This transaction is being declined due the operation of the Litle Prior Chargeback Card Filtering Service or the card has a restriction preventing approval if there are any chargebacks against it.'
      },
      '309' => {
        'response_message' => 'Restricted Card - Prepaid Card Filtering Service',
        'response_type' => 'Hard Decline',
        'description' => 'This transaction is being declined due the operation of the Litle Prepaid Card Filtering service.'
      },
      '310' => {
        'response_message' => 'Invalid track data',
        'response_type' => 'Hard Decline',
        'description' => 'The track data is not valid.'
      },
      '311' => {
        'response_message' => 'Deposit is already referenced by a chargeback',
        'response_type' => 'Hard Decline',
        'description' => 'The deposit is already referenced by a chargeback; therefore, a refund cannot be processed against the original transaction.'
      },
      '312' => {
        'response_message' => 'Restricted Card - International Card Filtering Service',
        'response_type' => 'Hard Decline',
        'description' => 'This transaction is being declined due the operation of the Litle International Card Filtering Service.'
      },
      '315' => {
        'response_message' => 'Restricted Card - Auth Fraud Velocity Filtering Service',
        'response_type' => 'Hard Decline',
        'description' => 'This transaction is being declined due the operation of the Litle Auth Fraud Velocity Filtering Service.'
      },
      '316' => {
        'response_message' => 'Automatic Refund Already Issued',
        'response_type' => 'Hard Decline',
        'description' => 'This refund transaction is a duplicate for one already processed automatically by the Litle Fraud Chargeback Prevention Service (FCPS).'
      },
      '318' => {
        'response_message' => 'Restricted Card - Auth Fraud Advice Filtering Service',
        'response_type' => 'Hard Decline',
        'description' => 'This transaction is being declined due the operation of the Litle Auth Fraud Advice Filtering Service.'
      },
      '319' => {
        'response_message' => 'Restricted Card - Fraud AVS Filtering Service',
        'response_type' => 'Hard Decline',
        'description' => 'This transaction is being declined due the operation of the Litle Auth Fraud AVS Filtering Service.'
      },
      '320' => {
        'response_message' => 'Invalid Expiration Date',
        'response_type' => 'Hard Decline',
        'description' => 'The expiration date is invalid.'
      },
      '321' => {
        'response_message' => 'Invalid Merchant',
        'response_type' => 'Hard Decline',
        'description' => 'The card is not allowed to make purchases from this merchant (e.g. a Travel only card trying to purchase electronics).)',
      },
      '322' => {
        'response_message' => 'Invalid Transaction',
        'response_type' => 'Hard Decline',
        'description' => 'The transaction is not permitted; contact the issuing bank.'
      },
      '323' => {
        'response_message' => 'No such issuer',
        'response_type' => 'Hard Decline',
        'description' => 'The card number references an issuer that does not exist. Do not process the transaction.'
      },
      '324' => {
        'response_message' => 'Invalid Pin',
        'response_type' => 'Hard Decline',
        'description' => 'The PIN provided is invalid.'
      },
      '325' => {
        'response_message' => 'Transaction not allowed at terminal',
        'response_type' => 'Hard Decline',
        'description' => 'The transaction is not permitted; contact the issuing bank.'
      },
      '326' => {
        'response_message' => 'Exceeds number of PIN entries',
        'response_type' => 'Hard Decline',
        'description' => '(Referring to a debit card) The incorrect PIN has been entered excessively and the card is locked.'
      },
      '327' => {
        'response_message' => 'Cardholder transaction not permitted',
        'response_type' => 'Hard Decline',
        'description' => 'Merchant does not allow that card type or specific transaction.'
      },
      '328' => {
        'response_message' => 'Cardholder requested that recurring or installment payment be stopped',
        'response_type' => 'Hard Decline',
        'description' => 'Recurring/Installment Payments no longer accepted by the card issuing bank.'
      },
      '330' => {
        'response_message' => 'Invalid Payment Type',
        'response_type' => 'Hard Decline',
        'description' => 'This payment type is not accepted by the issuer.'
      },
      '331' => {
        'response_message' => 'Invalid POS Capability for Cardholder Authorized Terminal Transaction',
        'response_type' => 'Hard Decline',
        'description' => 'For a Cardholder Authorized Terminal Transaction the POS capability must be set to magstripe.'
      },
      '332' => {
        'response_message' => 'Invalid POS Cardholder ID for Cardholder Authorized Terminal Transaction',
        'response_type' => 'Hard Decline',
        'description' => 'For a Cardholder Authorized Terminal Transaction the POS Cardholder ID must be set to nopin.'
      },
      '335' => {
        'response_message' => 'This method of payment does not support authorization reversals',
        'response_type' => 'Hard Decline',
        'description' => 'You can not perform an Authorization Reversal transaction for this payment type.'
      },
      '336' => {
        'response_message' => 'Reversal amount does not match Authorization amount.',
        'response_type' => 'Hard Decline',
        'description' => 'For a merchant initiated reversal against an American Express authorization, the reversal amount must match the authorization amount exactly.'
      },
      '340' => {
        'response_message' => 'Invalid Amount',
        'response_type' => 'Hard Decline',
        'description' => 'The transaction amount is invalid (too high or too low). For example, less than 0 for an authorization, or less than .01 for other payment types.'
      },
      '341' => {
        'response_message' => 'Invalid Healthcare Amounts',
        'response_type' => 'Hard Decline',
        'description' => 'The amount submitted with this FSA/Healthcare transaction is invalid. The FSA amount must be greater than 0, and cannot be greater than the transaction amount.'
      },
      '346' => {
        'response_message' => 'Invalid billing descriptor prefix',
        'response_type' => 'Hard Decline',
        'description' => 'The billing descriptor prefix submitted is not valid.'
      },
      '347' => {
        'response_message' => 'Invalid billing descriptor',
        'response_type' => 'Hard Decline',
        'description' => 'The billing descriptor is not valid because you are not authorized to send transactions with custom billing fields.'
      },
      '348' => {
        'response_message' => 'Invalid Report Group',
        'response_type' => 'Hard Decline',
        'description' => 'The Report Group specified in the transaction is invalid, because it is either not in the defined list of acceptable Report Groups or there is a mis-match between the Report Group and the defined Billing Descriptor.'
      },
      '349' => {
        'response_message' => 'Do Not Honor',
        'response_type' => 'Soft Decline',
        'description' => 'The issuing bank has put a temporary hold on the card.'
      },
      '350' => {
        'response_message' => 'Generic Decline',
        'response_type' => 'Soft or Hard Decline',
        'description' => 'There is an unspecified problem; contact the issuing bank for more details. Note: This code can be a hard or soft decline, depending on the method of payment, and other variables.'
      },
      '351' => {
        'response_message' => 'Decline - Request Positive ID',
        'response_type' => 'Hard Decline',
        'description' => 'Card Present transaction that requires a picture ID match.'
      },
      '352' => {
        'response_message' => 'Decline CVV2/CID Fail',
        'response_type' => 'Hard Decline',
        'description' => 'The CVV2/CID is invalid.'
      },
      '354' => {
        'response_message' => '3-D Secure transaction not supported by merchant',
        'response_type' => 'Hard Decline',
        'description' => 'You are not certified to submit 3-D Secure transactions.'
      },
      '356' => {
        'response_message' => 'Invalid purchase level III, the transaction contained bad or missing data',
        'response_type' => 'Soft Decline',
        'description' => 'Submitted Level III data is bad or missing.'
      },
      '357' => {
        'response_message' => 'Missing healthcareIIAS tag for an FSA transaction',
        'response_type' => 'Hard Decline',
        'description' => 'The FSA Transactions submitted does not contain the <healtcareIIAS> data element.'
      },
      '358' => {
        'response_message' => 'Restricted by Litle due to security code mismatch.',
        'response_type' => 'Hard Decline',
        'description' => 'The transaction was declined due to the security code (CVV2, CID, etc) not matching.'
      },
      '360' => {
        'response_message' => 'No transaction found with specified litleTxnId',
        'response_type' => 'Hard Decline',
        'description' => 'There were no transactions found with the specified litleTxnId.'
      },
      '361' => {
        'response_message' => 'Authorization no longer available',
        'response_type' => 'Hard Decline',
        'description' => 'The authorization for this transaction is no longer available. Either the authorization has already been consumed by another capture, or the authorization has expired.'
      },
      '362' => {
        'response_message' => 'Auto-void on refund',
        'response_type' => 'Hard Decline',
        'description' => 'This transaction cannot be voided; it has already been delivered.'
      },
      '363' => {
        'response_message' => 'Authorization no longer available',
        'response_type' => 'Hard Decline',
        'description' => 'This transaction (both capture and refund) has been voided.'
      },
      '364' => {
        'response_message' => 'Invalid Account Number - original or NOC updated eCheck account required',
        'response_type' => 'Hard Decline',
        'description' => 'The submitted account number is invalid. Confirm the original account number or check NOC for new account number.'
      },
      '365' => {
        'response_message' => 'Total credit amount exceeds capture amount',
        'response_type' => 'Hard Decline',
        'description' => 'The amount of the credit is greater than the capture, or the amount of this credit plus other credits already referencing this capture are greater than the capture amount.'
      },
      '366' => {
        'response_message' => 'Exceed the threshold for sending redeposits',
        'response_type' => 'Hard Decline',
        'description' => 'NACHA rules allow two redeposit attempts within 180 days of the settlement date of the initial deposit attempt. This threshold has been exceeded.'
      },
      '367' => {
        'response_message' => 'Deposit has not been returned for insufficient/non-sufficient funds',
        'response_type' => 'Hard Decline',
        'description' => 'NACHA rules only allow redeposit attempts against deposits returned for Insufficient or Uncollected Funds.'
      },
      '368' => {
        'response_message' => 'Invalid check number',
        'response_type' => 'Soft Decline',
        'description' => 'The check number is invalid.'
      },
      '369' => {
        'response_message' => 'Redeposit against invalid transaction type',
        'response_type' => 'Hard Decline',
        'description' => 'The redeposit attempted against an invalid transaction type.'
      },
      '370' => {
        'response_message' => 'Internal System Error - Call Litle',
        'response_type' => 'Hard Decline',
        'description' => 'There is a problem with the Litle System. Contact support@litle.com.'
      },
      '372' => {
        'response_message' => 'Soft Decline - Auto Recycling In Progress',
        'response_type' => 'Soft Decline',
        'description' => 'The transaction was intercepted because it is being auto recycled by the Recycling Engine.'
      },
      '373' => {
        'response_message' => 'Hard Decline - Auto Recycling Complete',
        'response_type' => 'Hard Decline',
        'description' => 'The transaction was intercepted because auto recycling has completed with a final decline.'
      },
      '375' => {
        'response_message' => 'Merchant is not enabled for surcharging',
        'response_type' => 'Hard Decline',
        'description' => 'The submitted transaction contained a surcharge and the merchant is not enabled for surcharging.'
      },
      '376' => {
        'response_message' => 'This method of payment does not support surcharging',
        'response_type' => 'Hard Decline',
        'description' => 'The use of a surcharge is only allowed for Visa and MasterCard methods of payment.'
      },
      '377' => {
        'response_message' => 'Surcharge is not valid for debit or prepaid cards',
        'response_type' => 'Hard Decline',
        'description' => 'You cannot apply a surcharge to a transaction using a debit or prepaid card.'
      },
      '378' => {
        'response_message' => 'Surcharge cannot exceed 4% of the sale amount',
        'response_type' => 'Hard Decline',
        'description' => 'The surcharge in the submitted transaction exceeded 4% maximum allowed for a surcharge.'
      },
      '401' => {
        'response_message' => 'Invalid E-mail',
        'response_type' => 'Hard Decline',
        'description' => 'The e-mail address provided is not valid. Verify that it was entered correctly.'
      },
      '469' => {
        'response_message' => 'Invalid Recurring Request - See Recurring Response for Details',
        'response_type' => 'Hard Decline',
        'description' => 'The Recurring Request was invalid, which invalidated the transaction. The Response Code and Message in the Recurring Response contains additional information.'
      },
      '470' => {
        'response_message' => 'Approved - Recurring Subscription Created',
        'response_type' => 'Approved',
        'description' => 'The recurring request was processed successfully'
      },
      '471' => {
        'response_message' => 'Parent Transaction Declined - Recurring Subscription Not Created',
        'response_type' => 'Hard Decline',
        'description' => 'The original payment transaction was declined, so the recurring payments have not been scheduled.'
      },
      '472' => {
        'response_message' => 'Invalid Plan Code',
        'response_type' => 'Hard Decline',
        'description' => 'The plan specified in the recurring request was invalid.'
      },
      '473' => {
        'response_message' => 'Scheduled Recurring Payment Processed',
        'response_type' => 'Approved',
        'description' => 'The scheduled recurring payment has been processed successfully.'
      },
      '475' => {
        'response_message' => 'Invalid Subscription Id',
        'response_type' => 'Hard Decline',
        'description' => 'The referenced subscription Id does not exist.'
      },
      '476' => {
        'response_message' => 'Add On Code Already Exists',
        'response_type' => 'Hard Decline',
        'description' => 'The specified Add On code already exists.'
      },
      '477' => {
        'response_message' => 'Duplicate Add On Codes in Requests',
        'response_type' => 'Hard Decline',
        'description' => 'Multiple createAddOn requests submitted with the same Add On Code.'
      },
      '478' => {
        'response_message' => 'No Matching Add On Code for the Subscription',
        'response_type' => 'Hard Decline',
        'description' => 'The Add On code specified does not exist.'
      },
      '480' => {
        'response_message' => 'No Matching Discount Code for the Subscription',
        'response_type' => 'Hard Decline',
        'description' => 'The Discount Code supplied in the updateDiscount or deleteDiscount transaction does not exist.'
      },
      '481' => {
        'response_message' => 'Duplicate Discount Codes in Request',
        'response_type' => 'Hard Decline',
        'description' => 'Multiple createDiscount requests submitted with the same Discount Code.'
      },
      '482' => {
        'response_message' => 'Invalid Start Date',
        'response_type' => 'Hard Decline',
        'description' => 'The supplied Start Date is invalid.'
      },
      '483' => {
        'response_message' => 'Merchant Not Registered for Recurring Engine',
        'response_type' => 'Hard Decline',
        'description' => 'You are not registered for the use of the Recurring Engine.'
      },
      '500' => {
        'response_message' => 'The account number was changed',
        'response_type' => 'Hard Decline',
        'description' => 'An Account Updater response indicating the Account Number changed from the original number.'
      },
      '501' => {
        'response_message' => 'The account was closed',
        'response_type' => 'Hard Decline',
        'description' => 'An Account Updater response indicating the account was closed. Contact the cardholder directly for updated information.'
      },
      '502' => {
        'response_message' => 'The expiration date was changed',
        'response_type' => 'N/A',
        'description' => 'An Account Updater response indicating the Expiration date for the card has changed.'
      },
      '503' => {
        'response_message' => 'The issuing bank does not participate in the update program',
        'response_type' => 'N/A',
        'description' => 'An Account Updater response indicating the issuing bank does not participate in the update program'
      },
      '504' => {
        'response_message' => 'Contact the cardholder for updated information',
        'response_type' => 'N/A',
        'description' => 'An Account Updater response indicating you should contact the cardholder directly for updated information.'
      },
      '505' => {
        'response_message' => 'No match found',
        'response_type' => 'N/A',
        'description' => 'An Account Updater response indicating no match was found in the updated information.'
      },
      '506' => {
        'response_message' => 'No changes found',
        'response_type' => 'N/A',
        'description' => 'An Account Updater response indicating there have been no changes to the account information.'
      },
      '550' => {
        'response_message' => 'Restricted Device or IP - ThreatMetrix Fraud Score Below Threshold',
        'response_type' => 'Hard Decline',
        'description' => 'The transaction was declined because the resulting ThreatMetrix Fraud Score was below the acceptable threshold set in the merchant’s policy.'
      },
      '601' => {
        'response_message' => 'Soft Decline - Primary Funding Source Failed',
        'response_type' => 'Soft Decline',
        'description' => 'A PayPal response indicating the transaction failed due to an issue with primary funding source (e.g. expired Card, insufficient funds, etc.).'
      },
      '602' => {
        'response_message' => 'Soft Decline - Buyer has alternate funding source',
        'response_type' => 'Soft Decline',
        'description' => 'A PayPal response indicating the merchant may resubmit the transaction immediately, and the use of an alternate funding source will be attempted.'
      },
      '610' => {
        'response_message' => 'Hard Decline - Invalid Billing Agreement Id',
        'response_type' => 'Hard Decline',
        'description' => 'A PayPal response indicating the Billing Agreement ID is invalid.'
      },
      '611' => {
        'response_message' => 'Hard Decline - Primary Funding Source Failed',
        'response_type' => 'Hard Decline',
        'description' => 'A PayPal response indicating the issuer is unavailable.'
      },
      '612' => {
        'response_message' => 'Hard Decline - Issue with Paypal Account',
        'response_type' => 'Hard Decline',
        'description' => 'A PayPal response indicating the transaction failed due to an issue with the buyer account.'
      },
      '613' => {
        'response_message' => 'Hard Decline - PayPal authorization ID missing',
        'response_type' => 'Hard Decline',
        'description' => 'A PayPal response indicating the need to correct the authorization ID before resubmitting.'
      },
      '614' => {
        'response_message' => 'Hard Decline - confirmed email address is not available',
        'response_type' => 'Hard Decline',
        'description' => 'A PayPal response indicating your account is configured to decline transactions without a confirmed address. request another payment method or contact support@litle.com to modify your account settings.'
      },
      '615' => {
        'response_message' => 'Hard Decline - PayPal buyer account denied',
        'response_type' => 'Hard Decline',
        'description' => 'A PayPal response indicating account unauthorized payment risk.'
      },
      '616' => {
        'response_message' => 'Hard Decline - PayPal buyer account restricted',
        'response_type' => 'Hard Decline',
        'description' => 'A PayPal response indicating PayPal is unable to process the payment. Buyer should contact PayPal with questions.'
      },
      '617' => {
        'response_message' => 'Hard Decline - PayPal order has been voided, expired, or completed',
        'response_type' => 'Hard Decline',
        'description' => 'A PayPal response indicating no further authorizations/captures can be processed against this order. A new order must be created.'
      },
      '618' => {
        'response_message' => 'Hard Decline - issue with PayPal refund',
        'response_type' => 'Hard Decline',
        'description' => 'A PayPal response indicating one of these potential refund related issues: duplicate partial refund must be less than or equal to original or remaining amount, past time limit, not allowed for transaction type, consumer account locked/inactive, or complaint exists - only a full refund of total/remaining amount allowed. Contact support@litle.com for specific details.'
      },
      '619' => {
        'response_message' => 'Hard Decline - PayPal credentials issue',
        'response_type' => 'Hard Decline',
        'description' => 'A PayPal response indicating you do not have permissions to make this API call.'
      },
      '620' => {
        'response_message' => 'Hard Decline - PayPal authorization voided or expired',
        'response_type' => 'Hard Decline',
        'description' => 'A PayPal response indicating you cannot capture against this authorization. You need to perform a brand new authorization for the transaction.'
      },
      '621' => {
        'response_message' => 'Hard Decline - required PayPal parameter missing',
        'response_type' => 'Hard Decline',
        'description' => 'A PayPal response indicating missing parameters are required. Contact support@litle.com for specific details.'
      },
      '622' => {
        'response_message' => 'Hard Decline - PayPal transaction ID or auth ID is invalid',
        'response_type' => 'Hard Decline',
        'description' => 'A PayPal response indicating the need to check the validity of the authorization ID prior to reattempting the transaction.'
      },
      '623' => {
        'response_message' => 'Hard Decline - Exceeded maximum number of PayPal authorization attempts',
        'response_type' => 'Hard Decline',
        'description' => 'A PayPal response indicating you should capture against a previous authorization.'
      },
      '624' => {
        'response_message' => 'Hard Decline - Transaction amount exceeds merchant’s PayPal account limit.',
        'response_type' => 'Hard Decline',
        'description' => 'A PayPal response indicating the transaction amount exceeds the merchant’s account limit. Contact support@litle.com to modify your account settings.'
      },
      '625' => {
        'response_message' => 'Hard Decline - PayPal funding sources unavailable.',
        'response_type' => 'Hard Decline',
        'description' => 'A PayPal response indicating the buyer needs to add another funding sources to their account.'
      },
      '626' => {
        'response_message' => 'Hard Decline - issue with PayPal primary funding source.',
        'response_type' => 'Hard Decline',
        'description' => 'A PayPal response indicating there are issues with the buyer’s primary funding source.'
      },
      '627' => {
        'response_message' => 'Hard Decline - PayPal profile does not allow this transaction type.',
        'response_type' => 'Hard Decline',
        'description' => 'Contact Litle to adjust your PayPal merchant profile preferences.'
      },
      '628' => {
        'response_message' => 'Internal System Error with PayPal - Contact Litle',
        'response_type' => 'Hard Decline',
        'description' => 'There is a problem with Litle’s username and password. Contact support@litle.com.'
      },
      '629' => {
        'response_message' => 'Hard Decline - Contact PayPal consumer for another payment method',
        'response_type' => 'Hard Decline',
        'description' => 'A PayPal response indicating you should contact the consumer for another payment method.'
      },
      '637' => {
        'response_message' => 'Invalid terminal Id',
        'response_type' => 'Hard Decline',
        'description' => 'The terminal Id submitted with the POS transaction is invalid.'
      },
      '701' => {
        'response_message' => 'Under 18 years old',
        'response_type' => 'Hard Decline',
        'description' => 'A Bill Me Later (BML) response indicating the customer is under 18 years of age based upon the date of birth.'
      },
      '702' => {
        'response_message' => 'Bill to outside USA.',
        'response_type' => 'Hard Decline',
        'description' => 'A BML response indicating the billing address is outside the United States.'
      },
      '703' => {
        'response_message' => 'Bill to address is not equal to ship to address',
        'response_type' => 'Hard Decline',
        'description' => 'A BML response indicating that the billing address does not match the shipping address.'
      },
      '704' => {
        'response_message' => 'Declined, foreign currency, must be USD',
        'response_type' => 'Hard Decline',
        'description' => 'A BML response indicating the transaction is declined, because it is not in US dollars.'
      },
      '705' => {
        'response_message' => 'On negative file',
        'response_type' => 'Hard Decline',
        'description' => 'A BML response indicating the account is on the negative file.'
      },
      '706' => {
        'response_message' => 'Blocked agreement',
        'response_type' => 'Hard Decline',
        'description' => 'A BML response indicating a blocked agreement account status.'
      },
      '707' => {
        'response_message' => 'Insufficient buying power',
        'response_type' => 'Other',
        'description' => 'A BML response indicating that the account holder does not have sufficient credit available for the transaction amount.'
      },
      '708' => {
        'response_message' => 'Invalid Data',
        'response_type' => 'Hard Decline',
        'description' => 'A BML response indicating that there are one or more problems with the submitted data.'
      },
      '709' => {
        'response_message' => 'Invalid Data - data elements missing',
        'response_type' => 'Hard Decline',
        'description' => 'A BML response indicating one or more required data elements are missing. Also, returned for an eCheck transaction that is missing a required data element. For example, failure to include the name element in an echeckSale or echeckCredit transaction would result in this code being returned.'
      },
      '710' => {
        'response_message' => 'Invalid Data - data format error',
        'response_type' => 'Hard Decline',
        'description' => 'A BML response indicating that some data was formatted incorrectly.'
      },
      '711' => {
        'response_message' => 'Invalid Data - Invalid T&C version',
        'response_type' => 'Hard Decline',
        'description' => 'A BML response indicating the T&C version is invalid.'
      },
      '712' => {
        'response_message' => 'Duplicate transaction',
        'response_type' => 'Hard Decline',
        'description' => 'A BML response indicating that the transaction is a duplicate.'
      },
      '713' => {
        'response_message' => 'Verify billing address',
        'response_type' => 'Hard Decline',
        'description' => 'A BML response indicating that you should verify the billing address.'
      },
      '714' => {
        'response_message' => 'Inactive Account',
        'response_type' => 'Hard Decline',
        'description' => 'A BML response indicating the customer account is inactive.'
      },
      '716' => {
        'response_message' => 'Invalid Auth',
        'response_type' => 'Hard Decline',
        'description' => 'A BML response indicating that the referenced authorization is invalid.'
      },
      '717' => {
        'response_message' => 'Authorization already exists for the order',
        'response_type' => 'Hard Decline',
        'description' => 'A BML response indicating that an authorization already exists for the transaction.'
      },
      '801' => {
        'response_message' => 'Account number was successfully registered',
        'response_type' => 'Approved',
        'description' => 'The card number was successfully registered and a token number was returned.'
      },
      '802' => {
        'response_message' => 'Account number was previously registered',
        'response_type' => 'Approved',
        'description' => 'The card number was previously registered for tokenization.'
      },
      '805' => {
        'response_message' => 'Card Validation Number Updated',
        'response_type' => 'Approved',
        'description' => 'The stored value for CVV2/CVC2/CID has been successfully updated.'
      },
      '820' => {
        'response_message' => 'Credit card number was invalid',
        'response_type' => 'Hard Decline',
        'description' => 'The card number submitted for tokenization is invalid.'
      },
      '821' => {
        'response_message' => 'Merchant is not authorized for tokens',
        'response_type' => 'Hard Decline',
        'description' => 'Your organization is not authorized to use tokens.'
      },
      '822' => {
        'response_message' => 'Token was not found',
        'response_type' => 'Hard Decline',
        'description' => 'The token number submitted with this transaction was not found.'
      },
      '850' => {
        'response_message' => 'Tax Billing only allowed for MCC9311',
        'response_type' => 'Hard Decline',
        'description' => 'Tax Billing elements are allowed only for MCC 9311.'
      },
      '851' => {
        'response_message' => 'MCC 9311 requires taxType element',
        'response_type' => 'Hard Decline',
        'description' => 'Missing taxType element'
      },
      '852' => {
        'response_message' => 'Debt Repayment only allowed for VI transactions on MCCs 6012 and 6051',
        'response_type' => 'Hard Decline',
        'description' => 'You must be either MCC 6012 or 6051 to designate a Visa
        transaction as Debt Repayment (debtRepayment element set to true).'
      },
      '877' => {
        'response_message' => 'Invalid Pay Page Registration Id',
        'response_type' => 'Hard Decline',
        'description' => 'A Pay Page response indicating that the Pay Page Registration ID submitted is invalid.'
      },
      '878' => {
        'response_message' => 'Expired Pay Page Registration Id',
        'response_type' => 'Hard Decline',
        'description' => 'A Pay Page response indicating that the Pay Page Registration ID has expired (Pay Page Registration IDs expire 24 hours after being issued).'
      },
      '879' => {
        'response_message' => 'Merchant is not authorized for Pay Page',
        'response_type' => 'Hard Decline',
        'description' => 'Your organization is not authorized to use the Pay Page.'
      },
      '898' => {
        'response_message' => 'Generic token registration error',
        'response_type' => 'Soft Decline',
        'description' => 'There is an unspecified token registration error; contact Litle & Co.'
      },
      '899' => {
        'response_message' => 'Generic token use error',
        'response_type' => 'Soft Decline',
        'description' => 'There is an unspecified token use error; contact Litle & Co.'
      },
      '900' => {
        'response_message' => 'Invalid Bank Routing Number',
        'response_type' => 'Hard Decline',
        'description' => 'The eCheck routing number submitted with this transaction has failed validation.'
      },
      '950' => {
        'response_message' => 'Decline - Negative Information on File',
        'response_type' => 'Hard Decline',
        'description' => 'An eCheck response indicating the account is on the negative file.'
      },
      '951' => {
        'response_message' => 'Absolute Decline',
        'response_type' => 'Hard Decline',
        'description' => 'An eCheck response indicating that this transaction was declined.'
      },
      '952' => {
        'response_message' => 'The Merchant Profile does not allow the requested operation',
        'response_type' => 'Hard Decline',
        'description' => 'An eCheck response indicating that your Merchant Profile does not allow the requested operation. Contact your Litle & Co. Customer Experience Manager for additional information.'
      },
      '953' => {
        'response_message' => 'The account cannot accept ACH transactions',
        'response_type' => 'Hard Decline',
        'description' => 'An eCheck response indicating the customer’s checking account does not accept ACH transactions.'
      },
      '954' => {
        'response_message' => 'The account cannot accept ACH transactions or site drafts',
        'response_type' => 'Hard Decline',
        'description' => 'An eCheck response indicating the customer’s checking account does not accept ACH transactions or site drafts.'
      },
      '955' => {
        'response_message' => 'Amount greater than limit specified in the Merchant Profile',
        'response_type' => 'Hard Decline',
        'description' => 'An eCheck response indicating that the dollar amount of this transaction exceeds the maximum amount specified in your Merchant Profile. Contact your Litle & Co. Customer Experience Manager for additional information.'
      },
      '956' => {
        'response_message' => 'Merchant is not authorized to perform eCheck Verification transactions',
        'response_type' => 'Hard Decline',
        'description' => 'An eCheck response indicating that your organization is not authorized to perform eCheck verifications. Contact your Litle & Co. Customer Experience Manager for additional information.'
      },
      '957' => {
        'response_message' => 'First Name and Last Name required for eCheck Verifications',
        'response_type' => 'Hard Decline',
        'description' => 'An eCheck response indicating that the first and last name of the customer is required for eCheck verifications.'
      },
      '958' => {
        'response_message' => 'Company Name required for corporate account for eCheck Verifications',
        'response_type' => 'Hard Decline',
        'description' => 'An eCheck response indicating that the company name is required for verifications on corporate accounts.'
      },
      '959' => {
        'response_message' => 'Phone number required for eCheck Verifications',
        'response_type' => 'Hard Decline',
        'description' => 'An eCheck response indicating that the phone number of the customer is required for eCheck verifications.'
      },
    }
  end
end
