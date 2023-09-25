//
//  Toast.swift
//  AJ
//
//  Created by Денис on 22.09.2023.
//

import SwiftUI

//struct Toast: ViewModifier {
//
//    var text: String
//    var icon: Image
//    @Binding var isShowing: Bool
//
//    func body(content: Content) -> some View {
//        content
//            .overlay(
//                ZStack {
//                    toastView()
//                        .offset(y: 32)
//                }.animation(.spring)
//            )
//            .transition(.move(edge: .top))
//    }
//
//    private func toastView() -> some View {
//        VStack {
//            HStack(spacing: 2) {
//                icon
//                Text(text)
//            }
//            .padding()
//            .clipShape(RoundedRectangle(cornerRadius: 25.0))
//            .background(Assets.Colors.solidWhite)
//            .shadow(radius: 2)
//        }
//    }
//}
//
//struct ToastModifier: ViewModifier {
//
//  @Binding var toast: Toast?
//  @State private var workItem: DispatchWorkItem?
//
//  func body(content: Content) -> some View {
//    content
//      .frame(maxWidth: .infinity, maxHeight: .infinity)
//      .overlay(
//        ZStack {
//          mainToastView()
//            .offset(y: 32)
//        }.animation(.spring(), value: toast)
//      )
//      .onChange(of: toast) { value in
//        showToast()
//      }
//  }
//
//  @ViewBuilder func mainToastView() -> some View {
//    if let toast = toast {
//      VStack {
//        ToastView(
//          style: toast.style,
//          message: toast.message,
//          width: toast.width
//        ) {
//          dismissToast()
//        }
//        Spacer()
//      }
//    }
//  }
//
//  private func showToast() {
//    guard let toast = toast else { return }
//
//    UIImpactFeedbackGenerator(style: .light)
//      .impactOccurred()
//
//    if toast.duration > 0 {
//      workItem?.cancel()
//
//      let task = DispatchWorkItem {
//        dismissToast()
//      }
//
//      workItem = task
//      DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
//    }
//  }
//
//  private func dismissToast() {
//    withAnimation {
//      toast = nil
//    }
//
//    workItem?.cancel()
//    workItem = nil
//  }
//}
//
//extension View {
//
//    func toast(text: String, icon: Image, isShowing: Binding<Bool>) -> some View {
//        self.modifier(Toast(text: text, icon: icon, isShowing: isShowing))
//    }
//}
