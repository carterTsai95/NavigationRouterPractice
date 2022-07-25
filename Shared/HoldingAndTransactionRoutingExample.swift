//
//  HoldingAndTransactionRoutingExample.swift
//  Shared
//
//  Created by Hung-Chun Tsai on 2022-07-16.
//

import SwiftUI
import Combine


// MARK: Model
enum MyRouter {
    case holdingDetail(SecondViewModel)
    case transactions
}

let myAccountList: [AccountModel] = [
    AccountModel("0"),
    AccountModel("1"),
    AccountModel("2"),
    AccountModel("3"),
    AccountModel("4")
]

struct AccountModel: Identifiable {
    var id: String
    init(_ id: String) {
        self.id = id
    }
}

// MARK: ViewModel

class MyViewModel: ObservableObject {
    @Published var selectedAccount: AccountModel
    @Published var destinationRouter: MyRouter? = nil
    private var accountList: [AccountModel] = []
    var cancellable: Set<AnyCancellable> = []

    // Source of truth for the child view model, the parent's vm hold the reference
    var secondViewModel: SecondViewModel?
    
    init(selectedAccount: AccountModel) {
        self.selectedAccount = selectedAccount
        self.accountList = myAccountList
        self.secondViewModel = SecondViewModel(selectedAccount: selectedAccount)
    }

    func prepareRouteToDetail() {
        // Before initiating the route, generate the needed data for the viewModel
        secondViewModel = SecondViewModel(selectedAccount: selectedAccount)

        // Suscribe to the child vm's selectedAccount. Whenever the value is change in child's view. We assign back to current vm.
        secondViewModel?.$selectedAccount
            .sink(receiveValue: { account in
                self.selectedAccount = account
                print(account)
            })
            .store(in: &cancellable)

        if let secondViewModel = secondViewModel {
            // initate the route
            destinationRouter = .holdingDetail(secondViewModel)
        }
    }

    func setAccount(_ account: AccountModel) {
        selectedAccount = account
    }

    // Creating the destination view base on corresponding scenario.
    @ViewBuilder
    func routeToDestination() -> some View {
        if let destinationRouter = destinationRouter {
            switch destinationRouter {
            case .holdingDetail(let secondViewModel):
                SecondView(vm: secondViewModel)
            case .transactions:
                Text("Transaction")
            }
        }
    }

    func resetRoute() {
        destinationRouter = nil
        secondViewModel = nil
    }
}
class SecondViewModel: ObservableObject {
    @Published var selectedAccount: AccountModel
    private var accountList: [AccountModel] = []
    
    init(selectedAccount: AccountModel) {
        self.selectedAccount = selectedAccount
        self.accountList = myAccountList
    }

    func setAccount(_ account: AccountModel) {
        selectedAccount = account
    }
}

// MARK: Views

struct ContentView: View {
    @StateObject var vm = MyViewModel(selectedAccount: myAccountList.first!)
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Parent View")
                    .font(.title)
                    .padding()
                    .background(.brown)
                    .cornerRadius(15)
                
                Text("Current selection account: \(vm.selectedAccount.id)")
                Button {
                    vm.prepareRouteToDetail()
                } label: {
                    Text("Go to Holding Details")
                }

                ForEach(myAccountList) { account in
                    Button {
                        vm.setAccount(account)
                    } label: {
                        Text("Set selection \(account.id)")
                    }
                }
                
                // Invisible tag for navigate to destination
                NavigationLink(
                    destination: vm.routeToDestination(),
                    isActive: Binding(
                        get: { vm.destinationRouter != nil },
                        set: { navigate in
                            if !navigate {
                                vm.resetRoute()
                            }
                        }
                    )
                ) { EmptyView() }
            }
        }
    }
}

struct SecondView: View {
    @ObservedObject var vm: SecondViewModel

    var body: some View {
        VStack {
            Text("Child View")
                .font(.title)
                .padding()
                .background(.cyan)
                .cornerRadius(15)
            Text("Current selection account: \(vm.selectedAccount.id)")
            ForEach(myAccountList) { account in
                Button {
                    vm.setAccount(account)
                } label: {
                    Text("Set selection \(account.id)")
                }
            }
        }
    }
}

// MARK: PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
