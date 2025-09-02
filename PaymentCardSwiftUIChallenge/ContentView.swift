//
//  ContentView.swift
//  PaymentCardSwiftUIChallenge
//
//  Created by Alvaro Ordonez on 8/7/25.
//

// Your task is to finish this application to satisfy requirements below and make it look like on the attached screenshots. Try to use 80/20 principle.
// Good luck! 🍀

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

import SwiftUI
import Combine

class Model: ObservableObject {

    @Published var processDurationInSeconds: Int = 60
    var repository: PaymentTypesRepository = PaymentTypesRepositoryImplementation()
    //var cancellables: [AnyCancellable] = []
    var timer: AnyCancellable?
    @Published var isButtonDisabled = false

    init() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                //let's make sure weak self isn't nil
                //if we can successfully assign 'let self' to the
                //'weak self' then we can self.count +=1
                //and no need to use the '?' in self?.count += 1
                guard let self = self else { return }
                self.processDurationInSeconds -= 1
                
                if(self.processDurationInSeconds == 0)
                {
                    timer?.cancel()
                    isButtonDisabled = true
                }
                print("\(self.processDurationInSeconds)")
            }
            //.store(in: &cancellables)
    }
}

struct ContentView: View {
    
    @StateObject var viewModel = Model()
    @State var showSheet: Bool = false
    @State var selectedItem: String?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.blue
                    .ignoresSafeArea()
                VStack {
                    
                    Spacer()
                    
                    // Seconds should count down from 60 to 0
                    Text("You have only \(viewModel.processDurationInSeconds) seconds left to get the discount")
                        .font(.title)
                        .bold()
                        .foregroundStyle(Color.white)
                        .padding()
                    
                    Spacer()
                    
                    VStack(spacing: 10) {
                        Button("Open payment", action: {
                            showSheet.toggle()
                        })
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .sheet(isPresented: $showSheet) {
                            PaymentModalView(selectedItem: $selectedItem)
                        }
                        .disabled(viewModel.isButtonDisabled)
                        .opacity(viewModel.isButtonDisabled ? 0.5 : 1.0)
                        
                        if selectedItem != nil {
                            NavigationLink(
                                destination:
                                    FinishView()
                                    .navigationBarHidden(true),
                                label: {
                                    Text("Finish")
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                        .frame(height: 55)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.white)
                                        .cornerRadius(15)
                                        .padding(.horizontal)
                                        .disabled(viewModel.isButtonDisabled)
                                        .opacity(viewModel.isButtonDisabled ? 0.5 : 1.0)
                                        
                                }
                            )
                        }//end if
                    } //end VStack
                }//end VStack
            }// end ZStack
        }//end NavigationView
    }
}

struct FinishView: View {
    var body: some View {
        Text("Congratulations")
    }
}

struct PaymentModalView : View {
    
    @Binding var selectedItem: String?
    
    var body: some View {
        NavigationView {
            PaymentInfoView(selectedItem: $selectedItem)
        }
    }
}

struct PaymentInfoView: View {
    
    var paymentTypesViewModel = PaymentTypesRepositoryImplementation()
    @State private var payTypes : [PaymentType] = []
    @State private var isLoading: Bool = true
    @State private var searchText = ""
    @Binding var selectedItem: String?
    
    @Environment(\.presentationMode) var presentationMode
    @State private var isSearchPresented = false
    
    var body: some View {
        // Load payment types when presenting the view. Repository has 2 seconds delay.
        // User should select an item.
        // Show checkmark in a selected row.
        //
        // No need to handle error.
        // Use refreshing mechanism to reload the list items.
        // Show loader before response comes.
        // Show search bar to filter payment types
        //
        // Finish button should be only available if user selected payment type.
        // Tapping on Finish button should close the modal.

        List(selection: $selectedItem) {//(payTypes) { payType in
            if isLoading {
                ProgressView()
            }
            else {
                ForEach(filteredPayTypes) { payType in
                    ZStack {
                        HStack {
                            Button {
                                isSearchPresented = false
                                print("\(payType.name) selected")
                                selectedItem = payType.name
                            } label: {
                                Text(payType.name)
                            }
                            Spacer()
                            if payType.name == selectedItem {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color.green)
                            }
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText, isPresented: $isSearchPresented)
        .navigationTitle("Payment info")
        .navigationBarItems(
            trailing:
                Button("Done",
                        action: {
                            presentationMode.wrappedValue.dismiss()
                        }
                ).opacity(selectedItem != nil ? 1 : 0)
        )
        .onAppear {
            fetchPaymentTypes()
        }
        .refreshable {
            fetchPaymentTypes()
        }
    }
    
    var filteredPayTypes: [PaymentType] {
        if searchText.isEmpty {
            return payTypes
        } else {
            return payTypes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    private func fetchPaymentTypes() {
        isLoading = true
        paymentTypesViewModel.getTypes { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let value):
                        print("Refresh: \(value)")
                        self.payTypes = value
                        isLoading = false
                        print("Refreshed with \(payTypes)")
                    case .failure(let error): print("Failed with \(error)")
                    }
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        //PaymentInfoView()
    }
}


//#Preview {
//    ContentView()
//}
