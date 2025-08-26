### Summary: PaymentCardSwiftUIChallenge

This SwiftUI challenge involved displaying a view with a timer giving a user 60 seconds to click an 'Open payment' button. Clicking this button 
allows the user to select a payment method from a list of payments provided. This list is displayed modally. When the modal view opens, the 
user is shown a list of payment methods to choose from along with a search bar. If the search bar is used, then the list of payments is filtered 
with respect to the search text entered. If the user selects a payment method, the Done button is shown at the top right of the modal view along 
with a green check on the selected payment method. The steps listed below are the steps that were required to complete the challenge. I added a 
feature to disable the 'Open payment' button if the time expired. This feature was not required, however.

1. Setup UI of the ContentView. Try to keep it as similar as possible.
2. Subscribe to the timer and count seconds down from 60 to 0 on the ContentView.
3. Present PaymentModalView as a sheet after tapping on the "Open payment" button.
4. Load payment types from repository in PaymentInfoView. Show loader when waiting for the response. No need to handle error.
5. List should be refreshable.
6. Show search bar for the list to filter payment types. You can filter items in any way.
7. User should select one of the types on the list. Show checkmark next to the name when item is selected.
8. Show "Done" button in navigation bar only if payment type is selected. Tapping this button should hide the modal.
9. Show "Finish" button on ContentScreen only when "payment type" was selected.
10. Replace main view with "FinishView" when user taps on the "Finish" button.

Note: This exercise did not require use of any architecture. The requirements were only the items listed above.

### Changes made to Model class

1. Created a timer of type AnyCancellable and assigned it to the subscriber of the Timer publisher
2. When subscribing to the Timer publisher, I decremented the timer on each publish of a new time.
4. If the timer reached 0, I cancel the timer and disable the 'Open payment' button.

### Changes made to the ContentView struct

1. Added blue background color to fulfill requirement(using the Assets folder was not required, if not for the limited time, I would have used the Assets folder to set up background color)
2. Used modifiers to fulfill the requirements on the appearance of the 'Open payment' button
3. Used the .sheet modifier to modally display the PaymentModal View
4. Used .onAppear modifier to get the payment types 'asyncronously' by calling the viewModel's getTypes() function.
5. The function getTypes() was provided in the challenge. This call executes on a background thread.
6. Upon receiving the result, the status of the result of calling getTypes() is checked inside a Main thread closure since UI updates can only occur on the main thread
7. No error checking was required so a failure simply printed out the failure. On success, the result was assigned to the payTypes var 
8. Since the payTypes var is bound to the view since it is defined with the @State modifier, when the payTypes array is refreshed, the View refreshes the list of payments
9. The pay types are listed as buttons. This approach is easier because buttons are clickable and the requirement is that if the payment type in the list is clicked, a check mark is presented on the button.
10. Each button and checkmark is listed within an HStack nested inside a ZStack. The ZStack allows us to superimpose a checkmark on top of the payment type when a user has selected a payment type.
11. The Done button is shown at the top right corner of the PaymentModal View only when a user has selected a payment type.
12. The user can also use the searchbar to filter the list of pay types in the payment list. If the user searches a paytype, the list is filtered.
13. When filtering a pay type, if the user then selects a paytype, all the filtered list of paytypes reappear along with the selected paytype checked. When the user clicks Done, Payment modal is dismissed.
14. The user is then presented with a Finish button. When the Finish button is clicked, another view is displayed stating: Congratulations!
15. Lastly, if the user selects a pay type in the Payment Modal View but the timer expires, the Done button is disabled along with all the paytypes listed. The user may return to the main view but both the Open payment button and the Finish button will be disabled.

