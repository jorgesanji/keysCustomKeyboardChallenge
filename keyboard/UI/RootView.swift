//
//  RootView.swift
//  keyboard
//
//  Created by John Peterson on 5/10/22.
//

import SwiftUI

struct RootView: View {
	
	private weak var delegate: KeyDelegate?
	
	@ObservedObject private var viewModel: DefaultKeyboardViewModel
	
	// Get from StyleSheet paddings(p), styles(s) and measures(m).
	typealias p = StyleSheet.Paddings
	typealias s = StyleSheet.Styles
	typealias m = StyleSheet.Measures
	
	init(delegate: KeyDelegate?, viewModel: DefaultKeyboardViewModel){
		self.delegate = delegate
		self.viewModel = viewModel
	}
		
	private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
	
	private var errorView: some View {
		CustomButton(title: Localizables.load_error)
			.onTapGesture {
				viewModel.fetchContent()
			}
			.background(Color.red)
			.cornerRadius(s.cornerRadius)
	}
	
	private var progressView: some View {
		ProgressView().progressViewStyle(CircularProgressViewStyle())
	}
	
	private var gridView: some View {
		ScrollView {
			LazyVGrid(columns: gridItemLayout, spacing: p.spacing) {
		
				ForEach((0..<viewModel.content.count), id: \.self) { index in
				
					CustomButton(title: viewModel.content[index])
						.onTapGesture {
							viewModel.showItemsAtContentIndex(index)
						}
						.background(Color.gray)
						.cornerRadius(s.cornerRadius)
				}
			}
		}.padding(.init(top: p.l, leading: 0, bottom: p.n, trailing: 0))
	}
	
	private var itemView: some View {
		Color.white
			.blur(radius: s.blurRadius)
			.opacity(s.opacity)
			.overlay(
				
				VStack(alignment: .center, spacing: p.spacing, content: {
			
					ForEach((0..<viewModel.items.count), id: \.self) { index in
						
						Text(viewModel.items[index]).onTapGesture {
							
								textSelected(viewModel.items[index])
							
						}.padding(.init(top: p.s, leading: p.n, bottom: p.s, trailing: p.n))
							.foregroundColor(Color.white)
						}
					})
					.background(Color.gray)
					.cornerRadius(s.cornerRadius)
			)
			.onTapGesture {
				viewModel.hideItems()
			}
			.transition(AnyTransition.move(edge: .bottom)
			.combined(with: .opacity))
			.animation(.easeInOut)
	}
	
	private var nextView: some View {
		CustomButton(title: Localizables.next_keyboard)
			.onTapGesture {
				delegate?.advanceToNextInput()
			}
			.background(Color.blue)
			.cornerRadius(s.cornerRadius)
	}
	
	var body: some View {
		VStack {
			ZStack {
				if viewModel.state == .error {
					errorView
				} else if viewModel.state == .syncing || viewModel.state == .idle {
					progressView
				} else {
					gridView
				}
				if viewModel.state == .showItem {
					itemView
				}
			}
			nextView
		}
		.onAppear { viewModel.fetchContent() }
		.frame(minHeight: m.minHeight)
	}
	
	func textSelected(_ text: String) {
		viewModel.hideItems()
		delegate?.setText(text)
	}
}

struct CustomButton: View {
	var title: String
	
	typealias p = StyleSheet.Paddings

	var body: some View {
		HStack {
			Text(title)
				.foregroundColor(.white)
				.padding(EdgeInsets(top: p.s, leading: p.s, bottom: p.s, trailing: p.s))
		}
	}
}

struct BorderedCaption: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.caption2)
			.padding(10)
			.overlay(
				RoundedRectangle(cornerRadius: 15)
					.stroke(lineWidth: 1)
			)
			.foregroundColor(Color.blue)
	}
}

extension View {
	func borderedCaption() -> some View {
		modifier(BorderedCaption())
	}
}
