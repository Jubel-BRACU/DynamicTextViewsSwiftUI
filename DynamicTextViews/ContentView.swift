//
//  ContentView.swift
//  DynamicTextViews
//
//  Created by Md Jubel Hossain on 15/11/21.
//

import SwiftUI

struct ContentView: View {
    @State private var myviews = ["some text"]
    @State private var phase: CGFloat = 0
    @State var isTapped : Bool = false
    
    @State var postion = CGPoint (x: 0, y: 0)
    @State var lineWidth : CGFloat = 0
    @State var xValue : CGFloat = 0.0
    @State var yValue : CGFloat = 0.0
    @State var width : CGFloat = 0.0
    @State var height : CGFloat = 0.0
    @State var rotationAngle : CGFloat = 0.0
    @State var fontSize : CGFloat = 15
    @State private var position = CGPoint(x: 50, y: 30)
    @State private var dragDiametr: CGFloat = 150
    @State private var arrayOfTextView = []
    
    @State private var pogPosition = CGPoint(x: 30, y: 10)
    @State private var size = CGSize.zero
    var body: some View {
        GeometryReader { gp in
            VStack {
                ForEach(myviews, id: \.self) { myview in
                    Group{
                    Text(myview).foregroundColor(.white)
                    }
                        .zIndex(Double(myviews.count))
                        
                    
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .strokeBorder(style: StrokeStyle(lineWidth: lineWidth, dash: [6], dashPhase: phase)))
                        .background(GeometryReader {
                            Color.clear
                                .preference(key: ViewSizeKey.self, value: $0.frame(in: .local).size)
                        })
                        .onPreferenceChange(ViewSizeKey.self) {
                            self.size = $0
                        }
                        .position(pogPosition)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    if myview == "some text" {
                                    let rect = gp.frame(in: .local)
                                        .inset(by: UIEdgeInsets(top: size.height / 2.0, left: size.width / 2.0, bottom: size.height / 2.0, right: size.width / 2.0))
                                    if rect.contains(value.location) {
                                        self.pogPosition = value.location
                                    }}
                                }
                                .onEnded { value in
                                    print(value.location)
                                }
                        )
                        .onTapGesture(count: 1 , perform:  {
                            lineWidth = 1
                            withAnimation(.linear.repeatForever(autoreverses: false)) {
                                phase -= 10
                            }
                            
                        })
                }
                Button(action: {self.addView()}) {
                    Text("Show details")
                }
            } .onAppear {
                
                let rect = gp.frame(in: .local)
                self.pogPosition = CGPoint(x: rect.midX, y: rect.midY)
                print("layer count: ")
            }
        }.edgesIgnoringSafeArea(.all)
    }
    private func addView() {
        self.myviews.append("some new text")
        
        
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
struct ViewSizeKey: PreferenceKey {
    static var defaultValue = CGSize.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

struct TestView: View {

    @State private var data = 3

    var body: some View {
        VStack {
            MyViewControllerRepresentable(data: $data)
            Text("super special property: \(data)")
            
        }
    }
}


class MyViewController: UIViewController {

    @Binding private var data: Int

    init(data: Binding<Int>) {
        self._data = data
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - undo button
    private let undoBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Show View", for: .normal)
      //  button.setImage(UIImage(named: "arrow.left"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didtapBackBtn), for: .touchUpInside)
        button.backgroundColor = .clear
        button.tintColor = UIColor.black
        return button
    }()
    //MARK: - undo button
    private let increButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Increase by 1", for: .normal)
       // button.backgroundColor = .black
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
      //  button.setImage(UIImage(named: "arrow.left"), for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(didtapBackBtn), for: .touchUpInside)
       // button.backgroundColor = .clear
        button.tintColor = UIColor.black
        return button
    }()
    
    lazy var BottomBarElementView : TextLayerPanel = {
        let view =  TextLayerPanel()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return view
    }()

   
    override func viewDidLoad() {
        view.addSubview(increButton)
        view.addSubview(undoBtn)
        increButton.centerX(inView: view)
        increButton.centerY(inView: view)
        undoBtn.anchorView(top: increButton.bottomAnchor, left: view.leftAnchor,right: view.rightAnchor, paddingTop: 20, height: 50)
        
       
    }
    
    func addView(){
        view.addSubview(BottomBarElementView)
        //   view.addSubview(lineView)
     //   BottomBarElementView.delegate = self
        BottomBarElementView.translatesAutoresizingMaskIntoConstraints = false
        
        
        BottomBarElementView.anchorView(left: view.leftAnchor, bottom: self.view.bottomAnchor, right: view.rightAnchor, height: CGFloat( UIScreen.main.bounds.height < 896 ? (view.height*0.12) : (view.height*0.12)))
        BottomBarElementView.animShow(duration: 0.5)
        
    }

    @objc func buttonPressed() {
        data += 1
    }
    @objc func didtapBackBtn(){
        addView()
    }
}


struct MyViewControllerRepresentable: UIViewControllerRepresentable {

    @Binding var data: Int
    private let viewController: MyViewController

    init(data: Binding<Int>) {
        self._data = data
        viewController = MyViewController(data: data)
    }


    func makeUIViewController(context: Context) -> UIViewController {
        viewController
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}





