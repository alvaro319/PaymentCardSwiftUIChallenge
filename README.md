### Summary: PaymentCardSwiftUIChallenge

This SwiftUI challenge involved displaying a view with a timer giving a user 60 seconds to click an 'Open payment' button. Clicking this button 
allows the user to select a payment method from a list of payments provided. This list is displayed modally. When the modal view opens, the 
user is shown a list of payment methods to choose from along with a search bar. If the search bar is used, then the list of payments is filtered 
with respect to the search text entered. If the user selects a payment method, the Done button is shown at the top right of the modal view along 
with a green check on the selected payment method. The steps listed below are the steps that were required to complete the challenge. I added a 
feature to disable the 'Open payment' button if the time expired. This feature was not required, however.

// 1. Setup UI of the ContentView. Try to keep it as similar as possible.
// 2. Subscribe to the timer and count seconds down from 60 to 0 on the ContentView.
// 3. Present PaymentModalView as a sheet after tapping on the "Open payment" button.
// 4. Load payment types from repository in PaymentInfoView. Show loader when waiting for the response. No need to handle error.
// 5. List should be refreshable.
// 6. Show search bar for the list to filter payment types. You can filter items in any way.
// 7. User should select one of the types on the list. Show checkmark next to the name when item is selected.
// 8. Show "Done" button in navigation bar only if payment type is selected. Tapping this button should hide the modal.
// 9. Show "Finish" button on ContentScreen only when "payment type" was selected.
// 10. Replace main view with "FinishView" when user taps on the "Finish" button.
