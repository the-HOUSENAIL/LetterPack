//
//  ViewController.swift
//  MAPTest6
//
//  Created by 今井 秀一 on 2020/09/03.
//  Copyright © 2020 maimai. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FloatingPanel
import RealmSwift

// MKPointAnnotation拡張用クラス
class MapAnnotationWalk: MKPointAnnotation {
    var pinColor: UIColor = .red

    func setPinColor(_ color: UIColor) {
        pinColor = color
    }
}

class ViewController: UIViewController,
                      CLLocationManagerDelegate,
                      UIGestureRecognizerDelegate,
                      UISearchBarDelegate,
                      MKMapViewDelegate
                      {

    @IBOutlet var mapView: MKMapView!
    var locManager: CLLocationManager!
    var mapViewType: UIButton!
    @IBOutlet var longPressGesRec: UILongPressGestureRecognizer!
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var scrollView: UIScrollView!
    
     var delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Screenの高さ
    var screenHeight:CGFloat!
    // Screenの幅
    var screenWidth:CGFloat!
    
    // セミモーダルビューの時に同じく作成する
    var pointAno: MKPointAnnotation = MKPointAnnotation()
    var annotation: MKPointAnnotation = MKPointAnnotation()
    var anAsahiya: MKPointAnnotation = MKPointAnnotation()
    
    var floatingPanelController: FloatingPanelController!
    
    // 検索結果を保存するアノテーションのリスト
    var annotationList = [MapAnnotationWalk]()
    
    // タップした地点の情報
    var tapPointTitle: String! = ""                 // タップした地点のタイトル
    var tapStreetAddr: String! = ""                 // 住所
    var tapDistance: CLLocationDistance! = 0        // 距離
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // mapView.delegateをセット
        //　入れないとピンの設定などが反映されない
        mapView.delegate = self
        
        // デバイスの画面サイズを取得する
        let dispSize: CGSize = UIScreen.main.bounds.size
        //名前変更した方がいいかも？
        let height = Int(dispSize.height)
        let width = Int(dispSize.width)
        
        screenWidth = dispSize.width
        screenHeight = dispSize.height
        // 表示窓のサイズと位置を設定
        scrollView.frame.size =
            CGSize(width: screenWidth, height: screenHeight)
        
        // 検索バーの位置を指定して表示
        searchBar.frame = CGRect(x: 0, y: height-150, width: width, height: 80)
        //searchBar.frame = CGRect(x:width - 50, y:100, width:40, height:40)
        searchBar.tintColor = .red
        searchBar.showsCancelButton = true
        searchBar.delegate = self //UISearchBarDelegate
        searchBar.prompt = "検索"
        self.view.addSubview(searchBar)
        
        // UIScrollViewに追加
        scrollView.addSubview(searchBar)
        // UIScrollViewの大きさをスクリーンの縦方向を２倍にする
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight*2)
        // スクロールの跳ね返り無し
        scrollView.bounces = false
        
        // ビューに追加
        self.view.addSubview(scrollView)
        
        let prefecture1 = Prefecture()
        prefecture1.prefectureKey = 1
        prefecture1.prefecture = "北海道"

        let prefecture2 = Prefecture()
        prefecture2.prefectureKey = 2
        prefecture2.prefecture = "青森県"

        let prefecture13 = Prefecture()
        prefecture13.prefectureKey = 13
        prefecture13.prefecture = "東京都"

        let prefectures = List<Prefecture>()
        prefectures.append(prefecture1)
        prefectures.append(prefecture2)
        prefectures.append(prefecture13)

        let md1 = Maindata()
        md1.latitude = 35.749934
        md1.longitude = 139.76496
        md1.number = 1
        md1.compoundKey = "\(md1.latitude)" + "/" + "\(md1.longitude)" + "/" + "\(md1.number)"
        md1.prefectures.append(objectsIn: prefectures)
        
        let md2 = Maindata()
        md2.latitude = 35.749747
        md2.longitude = 139.765256
        md2.number = 2
        md2.compoundKey = "\(md2.latitude)" + "/" + "\(md2.longitude)" + "/" + "\(md2.number)"
        
        let sh1 = Shop()
        sh1.shopName = "マルホベーカリー"
        sh1.shopCode = 13001
        sh1.shopAddr = "東京都 荒川区 西尾久 2-3-6"
        
        let sh2 = Shop()
        sh2.shopName = "日本そば朝日屋総本店"
        sh2.shopCode = 13002
        sh2.shopAddr = "東京都 荒川区 西尾久 2-4-15"
        
        let url1 = Url()
        url1.url = "https://www.google.co.jp"
        let url2 = Url()
        url2.url = "https://catch-questions.com"
        let url3 = Url()
        url3.url = "https://www.yahoo.co.jp"
        
        let spe1 = Speciality()
        spe1.SpecialityNum = 1
        spe1.SpecialityName = "パン"
        let spe2 = Speciality()
        spe2.SpecialityNum = 2
        spe2.SpecialityName = "蕎麦"
        
// (1)Realmのインスタンスを生成する
        let realm = try! Realm()

        try! realm.write {
//            realm.add(md1)
//            realm.add(md2)
//            realm.add(sh1)
//            realm.add(sh2)
//            realm.add(url1)
//            realm.add(url2)
//            realm.add(url3)
//            realm.add(spe1)
//            realm.add(spe2)
            
        }

        // (2)全データの取得
        let results = realm.objects(Maindata.self)
        let resShops = realm.objects(Shop.self)
        // (3)取得データの確認
        print(results)
        print(resShops)

        print(Maindata())
        print(Shop())
        print("緯度 \(results[0].latitude)")
        print("経度 \(results[0].longitude)")
        
        // 以下を追加 ///
                let annotation: MKPointAnnotation = MKPointAnnotation()
//                ピンを定義する
                annotation.coordinate = CLLocationCoordinate2DMake(results[1].latitude, results[1].longitude)
//        annotation.coordinate = CLLocationCoordinate2DMake(35.749747, 139.765256)
//                annotation.title = "マルホベーカリー"
        annotation.title = resShops[0].shopName
//                annotation.subtitle = "東京都 荒川区 西尾久 2-3-6"
        annotation.subtitle = resShops[0].shopAddr

                // MapViewにピンを立てる
                self.mapView.addAnnotation(annotation)
                //ピン削除
                // mapView.removeAnnotation(pointAno)
                
                let anAsahiya: MKPointAnnotation = MKPointAnnotation()
               anAsahiya.coordinate = CLLocationCoordinate2DMake(results[0].latitude, results[0].longitude)
//        anAsahiya.coordinate = CLLocationCoordinate2DMake(35.749934, 139.76496)
//                anAsahiya.title = "日本そば朝日屋総本店"
        anAsahiya.title = resShops[1].shopName
//                anAsahiya.subtitle = "東京都 荒川区 西尾久 2-4-15"
        anAsahiya.subtitle = resShops[1].shopName
                self.mapView.addAnnotation(anAsahiya)
        
        
        // 地図の初期化
        initMap()

        locManager = CLLocationManager()
        //バックグラウンド・スリープ中でも位置情報を受信する(Invalid parameter not satisfying: ~~~というエラーが出る)
        //locManager.allowsBackgroundLocationUpdates = true
        locManager.delegate = self
        
        // 位置情報の使用の許可を得る
        locManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                // 座標の表示
                locManager.startUpdatingLocation()
                break
            default:
                break
            }
        }
        
        func searchBarSearchButtonClicked(searchBar: UISearchBar) {
            self.view.endEditing(true)
        }
    }
    
   func searchBarShouldReturn(_ searchBar: UISearchBar) -> Bool {
       self.searchBar.endEditing(true)
       return true
   }
    
    // PointPopupViewControllerビューをセミモーダルで表示する
    func showPointPopupView() {
        // かどを丸くする
        floatingPanelController.surfaceView.cornerRadius = 24.0
        // PointPopupViewControllerをセミモーダルに登録する
        let viewCnt = SemiModalViewController()
        floatingPanelController.set(contentViewController: viewCnt)
        // セミモーダルビューを表示する
        floatingPanelController.addPanel(toParent: self, belowView: nil, animated: true)
        floatingPanelController.move(to: .half, animated: true)
    }
    
    // PopUp画面の消去
//    func ExitPointPopupView() {
//        // セミモーダルビューを消去する
//        floatingPanelController.removePanelFromParent(animated: true)
//    }
    
    // ピンが選択された時の挙動
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let annotation = view.annotation

        // POP UP画面に表示する住所
        tapPointTitle = annotation?.title ?? ""
        tapStreetAddr = annotation?.subtitle ?? ""

        // POP UP画面に表示する距離
        let coordinate = CLLocationCoordinate2D(latitude: (annotation?.coordinate.latitude)!, longitude: (annotation?.coordinate.longitude)!)
        tapDistance = calcDistance(mapView.userLocation.coordinate, coordinate)

        // POP UP画面で探索する地点
        var tapRoutePoint = coordinate

        delegate.nameValue = annotation?.title ?? ""
        delegate.StreetAddrValue = annotation?.subtitle ?? ""
//        delegate.DistanceValue = coordinate
        
        
        let smvc = SemiModalViewController()
        present(smvc, animated: true, completion: nil)
        // セミモーダルビューの表示
//        showPointPopupView()
        
    }
    
    // タップした地点の名称を取得する
    public func getTapPointTitle() -> String {
        return tapPointTitle
    }

    // ロングタップした住所を取得する
    public func getTapStreetAddr() -> String {
        return tapStreetAddr
    }

    // ロングタップした位置までの距離を取得する
    public func getTapDistance() -> String {
        var retVal: String!
        let dist = Int(tapDistance)
        if (1000 > dist) {
            retVal = dist.description + " m"
        }
        else {
            let dDist: Double = floor((Double(dist)/1000)*100)/100
            retVal = dDist.description + " km"
        }

        return retVal
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        // セミモーダルビューを非表示にする
//        floatingPanelController.removePanelFromParent(animated: true)
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        
        let lonStr = (locations.last?.coordinate.longitude.description)! //緯度
        let latStr = (locations.last?.coordinate.latitude.description)! //経度

        print("lon : " + lonStr)
        print("lat : " + latStr)
        
        // CLLocationManagerのdelegate：現在位置取得
        // updateCurrentPos((locations.last?.coordinate)!)
        mapView.userTrackingMode = .follow
        
        // CLLocationManagerのdelegate：現在位置取得
        // 現在位置とタッウプした位置の距離(m)を算出する
        let distance = calcDistance(mapView.userLocation.coordinate, pointAno.coordinate)

        if (0 != distance) {
            // ピンに設定する文字列を生成する
            var str:String = Int(distance).description
            str = str + " m"

            // yard
            let yardStr = Int(distance * 1.09361)
            str = str + " / " + yardStr.description + " yard"

            if pointAno.title != str {
                // ピンまでの距離に変化があればtitleを更新する
                pointAno.title = str
                mapView.addAnnotation(pointAno)
            }
        }
        
        // 現在位置とベーカリーの距離(m)を算出する
        let distanceMaruho = calcDistance(mapView.userLocation.coordinate, annotation.coordinate)

        if (0 != distanceMaruho) {
            // ピンに設定する文字列を生成する
            var str:String = Int(distanceMaruho).description
            str = str + " m"

            // yard
            let yardStr = Int(distanceMaruho * 1.09361)
            str = str + " / " + yardStr.description + " yard"

            if annotation.subtitle != str {
                // ピンまでの距離に変化があればtitleを更新する
                annotation.subtitle = str
                mapView.addAnnotation(annotation)
            }
        }
        
        // 現在位置と蕎麦屋の距離(m)を算出する
        let distanceAsahiya = calcDistance(mapView.userLocation.coordinate, anAsahiya.coordinate)

        if (0 != distanceAsahiya) {
            // ピンに設定する文字列を生成する
            var str:String = Int(distanceAsahiya).description
            str = str + " m"

            // yard
            let yardStr = Int(distanceAsahiya * 1.09361)
            str = str + " / " + yardStr.description + " yard"

            if anAsahiya.subtitle != str {
                // ピンまでの距離に変化があればtitleを更新する
                anAsahiya.subtitle = str
                mapView.addAnnotation(anAsahiya)
            }
        }
    }
    
    //検索バーで検索ボタン押した時に呼び出されるメソッド
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // キーボードを消去する
        searchBar.resignFirstResponder()

        // 未入力なら無視する
        if "" == searchBar.text {
            return
        }

        // 検索条件を作成する。
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBar.text

        // 検索範囲はマップビューと同じにする。
        request.region = mapView.region

        // ローカル検索を実行する。
        let localSearch:MKLocalSearch = MKLocalSearch(request: request)
        localSearch.start(completionHandler: {(result, error) in
            self.mapView.removeAnnotations(self.mapView.annotations)
            if nil != result {
                for placemark in (result?.mapItems)! {
                    if(error == nil) {
                        //検索された場所にピンを刺す。
                        let annotation = MapAnnotationWalk()
                        annotation.coordinate =     CLLocationCoordinate2DMake(placemark.placemark.coordinate.latitude, placemark.placemark.coordinate.longitude)
                        annotation.title = placemark.placemark.name
                        annotation.subtitle = "〒\(placemark.placemark.postalCode ?? "")\n\(placemark.placemark.administrativeArea ?? "")\(placemark.placemark.locality ?? "")\n\(placemark.placemark.name ?? "")" //placemark.placemark.title
                        annotation.setPinColor(.green)
                        self.annotationList.append(annotation)
                        self.mapView.addAnnotation(annotation)
                    }
                    else {
                        //エラー
                        print(error.debugDescription)
                    }
                }
            }
        })
    }
    
    func initMap() {
        // 縮尺を設定
        var region:MKCoordinateRegion = mapView.region
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        mapView.setRegion(region,animated:true)

        // 現在位置表示の有効化
        mapView.showsUserLocation = true
        // 現在位置設定（デバイスの動きとしてこの時の一回だけ中心位置が現在位置で更新される）
        mapView.userTrackingMode = .follow
        
        // デバイスの画面サイズを取得する
        let dispSize: CGSize = UIScreen.main.bounds.size
        //名前変更した方がいいかも？
        let height = Int(dispSize.height)
        let width = Int(dispSize.width)
        
        // トラッキングボタン表示
        let trakingBtn = MKUserTrackingButton(mapView: mapView)
        trakingBtn.layer.backgroundColor = UIColor(white: 1, alpha: 0.7).cgColor
        trakingBtn.frame = CGRect(x:width - 50, y:100, width:40, height:40)
        self.view.addSubview(trakingBtn)
        
        // スケールバーの表示
        let scale = MKScaleView(mapView: mapView)
        scale.frame.origin.x = 15
        scale.frame.origin.y = 45
        scale.legendAlignment = .leading
        self.view.addSubview(scale)
        
        // コンパスの表示
        let compass = MKCompassButton(mapView: mapView)
        compass.compassVisibility = .adaptive
        compass.frame = CGRect(x: width - 50, y: 150, width: 40, height: 40)
        self.view.addSubview(compass)
        // デフォルトのコンパスを非表示にする
        mapView.showsCompass = false
        
        // 地図表示タイプを切り替えるボタンを配置する
        mapViewType = UIButton(type: UIButton.ButtonType.detailDisclosure)
        mapViewType.frame = CGRect(x:width - 50, y:60, width:40, height:40)
        mapViewType.layer.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor // 背景色
        mapViewType.layer.borderWidth = 0.5 // 枠線の幅
        mapViewType.layer.borderColor = UIColor.blue.cgColor // 枠線の色
        self.view.addSubview(mapViewType)
        
        mapViewType.addTarget(self, action: #selector(ViewController.mapViewTypeBtnThouchDown(_:)), for: .touchDown)
        
    }
    
    func updateCurrentPos(_ coordinate:CLLocationCoordinate2D) {
        var region:MKCoordinateRegion = mapView.region
        region.center = coordinate
        mapView.setRegion(region,animated:true)
    }
    
    // 地図の表示タイプを切り替える
    @objc internal func mapViewTypeBtnThouchDown(_ sender: Any) {
        switch mapView.mapType {
        case .standard:         // 標準の地図
            mapView.mapType = .satellite
            break
        case .satellite:        // 航空写真
            mapView.mapType = .hybrid
            break
        case .hybrid:           // 標準の地図＋航空写真
            mapView.mapType = .satelliteFlyover
            break
        case .satelliteFlyover: // 3D航空写真
            mapView.mapType = .hybridFlyover
            break
        case .hybridFlyover:    // 3D標準の地図＋航空写真
            mapView.mapType = .mutedStandard
            break
        case .mutedStandard:    // 地図よりもデータを強調
            mapView.mapType = .standard
            break
        }
    }
    
    // UILongPressGestureRecognizerのdelegate：ロングタップを検出する
    @IBAction func mapViewDidLongPress(_ sender: UILongPressGestureRecognizer) {
        // ロングタップ開始
        if sender.state == .began {
            
            // ロングタップ開始時に古いピンを削除する
            mapView.removeAnnotation(pointAno)
            
        }
        // ロングタップ終了（手を離した）
        else if sender.state == .ended {
            
            // タップした位置（CGPoint）を指定してMkMapView上の緯度経度を取得する
            let tapPoint = sender.location(in: view)
            let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)

            let lonStr = center.longitude.description
            let latStr = center.latitude.description
            print("ロングタップ緯度 : " + lonStr)
            print("ロングタップ経度 : " + latStr)
            
            // 現在位置とタッウプした位置の距離(m)を算出する
            let distance = calcDistance(mapView.userLocation.coordinate, center)
            print("distance : " + distance.description)
            
            // ピンに設定する文字列を生成する
            var str:String = Int(distance).description
            str = str + " m"

            // yard
            let yardStr = Int(distance * 1.09361)
            str = str + " / " + yardStr.description + " yard"

            if pointAno.title != str {
                // ピンまでの距離に変化があればtiteを更新する
                pointAno.title = str
                mapView.addAnnotation(pointAno)
            }
            
            // ロングタップを検出した位置にピンを立てる
            pointAno.coordinate = center
            mapView.addAnnotation(pointAno)
            
        }
    }
    
    // 2点間の距離(m)を算出する
    func calcDistance(_ a: CLLocationCoordinate2D, _ b: CLLocationCoordinate2D) -> CLLocationDistance {
        // CLLocationオブジェクトを生成
        let aLoc: CLLocation = CLLocation(latitude: a.latitude, longitude: a.longitude)
        let bLoc: CLLocation = CLLocation(latitude: b.latitude, longitude: b.longitude)
        // CLLocationオブジェクトのdistanceで2点間の距離(m)を算出
        let dist = bLoc.distance(from: aLoc)
        return dist
    }
    
    // ロングタップしたアノテーション情報を更新する
    func updateLongTapPointAno() {
        // 現在位置とタッウプした位置の距離(m)を算出する
        let distance = calcDistance(mapView.userLocation.coordinate, pointAno.coordinate)

        // ピンに設定する文字列を生成する
        var str:String = Int(distance).description
        str = str + " m"

        // yard
        let yardStr = Int(distance * 1.09361)
        str = str + " / " + yardStr.description + " y"
        

    }
}

//セミモーダルビュー
// FloatingPanelControllerDelegate を実装してカスタマイズしたレイアウトを返す
    extension ViewController: FloatingPanelControllerDelegate {
        func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
            return CustomFloatingPanelLayout()
        }
        
        // セミモーダルビューをサイズ変更した時に、登録したビューのサイズを変更する
        func floatingPanelDidEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetPosition: FloatingPanelPosition) {

//            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.semiModalViewController.resize(targetPosition)
        }
        
    }


// CustomFloatingPanelLayout.Swift

class CustomFloatingPanelLayout: FloatingPanelLayout {

    // セミモーダルビューの初期位置
    var initialPosition: FloatingPanelPosition {
        return .half
    }

    var topInteractionBuffer: CGFloat {
        return 0.0
    }

    var bottomInteractionBuffer: CGFloat {
        return 0.0
    }

    // セミモーダルビューの各表示パターンの高さを決定するためのInset
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        var ret: CGFloat!
        switch position {
        case .full:
            ret = nil//56.0
        case .half:
            ret = 262.0
        case .tip:
            ret = 75.0
        default:
            ret = nil
        }
        return ret
    }

    // セミモーダルビューの背景Viewの透明度
    func backdropAlphaFor(position: FloatingPanelPosition) -> CGFloat {
        return 0.0
    }
    
    // サポートする位置
    var supportedPositions: Set<FloatingPanelPosition> {
        return [.full, .half, .tip]
    }
}

