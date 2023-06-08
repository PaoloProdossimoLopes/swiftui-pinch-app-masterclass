//
//  ContentView.swift
//  Pinch
//
//  Created by Paolo Prodossimo Lopes on 07/06/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isAnimating = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset = CGSize.zero
    @State private var isDrawerOpen = false
    
    let pages = pagesData
    
    @State private var pageIndex = 1
    
    func resetImageState() {
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    func currentPage() -> String {
        pages[pageIndex - 1].imageName
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                
                Color.clear
                
                Image(currentPage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
                    .onTapGesture(count: 2) {
                        if imageScale == 1 {
                            withAnimation(.spring()) {
                                imageScale = 5
                            }
                        } else {
                            resetImageState()
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation(.linear(duration: 0.3)) {
                                    imageOffset = value.translation
                                }
                            }
                            .onEnded { _ in
                                if imageScale <= 1 {
                                    resetImageState()
                                }
                            }
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                withAnimation(.linear(duration: 0.3)) {
                                    if imageScale >= 1 && imageScale <= 5 {
                                        imageScale = value
                                    } else if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                            .onEnded { _ in
                                if imageScale > 5 {
                                    imageScale = 5
                                } else if imageScale <= 1 {
                                    resetImageState()
                                }
                            }
                    )
            }
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                withAnimation(.linear(duration: 1)) {
                    isAnimating = true
                }
            }
            .overlay(
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding()
                , alignment: .top
            )
            .overlay(
                Group {
                    HStack {
                        Button(action: {
                            withAnimation(.easeIn(duration: 0.3)) {
                                imageScale -= 1
                            }
                        }) {
                            Image(systemName: "minus.magnifyingglass")
                                .font(.system(size: 36))
                        }
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                imageOffset = .zero
                                imageScale = 1
                            }
                        }) {
                            Image(systemName: "arrow.up.left.and.down.right.magnifyingglass")
                                .font(.system(size: 36))
                        }
                        
                        Button(action: {
                            withAnimation(.easeIn(duration: 0.3)) {
                                imageScale += 1
                            }
                        }) {
                            Image(systemName: "plus.magnifyingglass")
                                .font(.system(size: 36))
                        }
                    }
                    .opacity(isAnimating ? 1 : 0)
                }
                    .padding(.bottom, 30)
                , alignment: .bottom
            )
            .overlay(
                HStack(spacing: 12) {

                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundColor(.secondary)
                        .onTapGesture {
                            isDrawerOpen.toggle()
                        }
                    
                    ForEach(pages) { item in
                        Image(item.thumnailImageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeInOut(duration: 0.5), value: isDrawerOpen)
                            .onTapGesture {
                                isAnimating = true
                                pageIndex = item.id
                            }
                    }
                    
                    Spacer()
                }
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                    .frame(width: 260)
                    .padding(.top, UIScreen.main.bounds.height / 12)
                    .offset(x: isDrawerOpen ? 20 : 200)
                    .animation(.spring(), value: isDrawerOpen)
                , alignment: .topTrailing
            )
        }//: NavigationView
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
