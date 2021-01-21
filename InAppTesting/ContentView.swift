//
//  ContentView.swift
//  InAppTesting
//
//  Created by Batuhan Karababa on 21.01.2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store:StoreService
    
    var body: some View {
        NavigationView{
            List(store.allRecipies, id: \.self){recipe in
                if !recipe.isLocked{ // if user purchased before
                    NavigationLink(
                        destination: Text("test"),
                        label: {
                            RecipeCell(recipe: recipe) {}
                        })
                }else{
                    RecipeCell(recipe: recipe) {
                        if let product =  store.product(for: recipe.id){
                            store.purchaseProduct(product)
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RecipeCell:View{
    let recipe:Recipe
    let action: () -> Void
    
    var body: some View{
        HStack{
            ZStack{
                Image(recipe.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
                    .opacity(recipe.isLocked ? 0.8 : 1)
                    .blur(radius: recipe.isLocked ? 3 : 0)
                    .padding()
                
                Image(systemName: "lock.fill")
                    .font(.largeTitle)
                    .opacity(recipe.isLocked ? 1 : 0)
            }
            VStack{
                Text(recipe.title)
                    .font(.title)
                Text(recipe.description)
                    .font(.caption)
            }
            Spacer()
            if let price = recipe.price, recipe.isLocked{
                Button(action: {
                    
                }){
                    Text(price)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(25)
                }
            }
        }
    }
    
}
