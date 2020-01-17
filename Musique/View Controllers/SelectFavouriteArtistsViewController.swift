import UIKit
import Alamofire
import os.log


class SelectFavouriteArtistsViewController: UIViewController {
                
    var chartsURL = String()
    
    var topArtists = [Artist]()
    
    typealias JSONStandard = [String : AnyObject]
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    override func viewDidLoad() {
        callDeezerAPI()
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func callDeezerAPI() {
        chartsURL = "https://api.deezer.com/chart/0/artists"
        AF.request(chartsURL).responseJSON(completionHandler: {
            response in
            self.parseData(JSONData: response.data!)
        })
        
        
    }
    
    func parseData(JSONData : Data) {
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            if let chartsData = readableJSON["data"] as? [JSONStandard]{
                for i in 0..<chartsData.count{
                    let item = chartsData[i]
                    let idFromAPI = item["id"] as! Int
                    let artistName = item["name"] as! String
                    let mainImageURL =  URL(string: item["picture_big"] as! String)
                    let mainImageData = NSData(contentsOf: mainImageURL!)
                    let mainImage = UIImage(data: mainImageData! as Data)
                  
                    addArtist((Artist.init(idFromAPI: idFromAPI, name: artistName, image: mainImage!))!)
                    self.collectionView.reloadData()

                }
            }
        }
        catch{
            print(error)
        }
    }
    
    fileprivate func addArtist(_ artist: Artist) {
        topArtists.append(artist)
    }
    
}

extension SelectFavouriteArtistsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.3, height: collectionView.frame.width/2.3)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topArtists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.data = self.topArtists[indexPath.row]
        return cell
    }
    
    
}

class CustomCell: UICollectionViewCell {
    
    var data: Artist? {
        didSet {
            guard let data = data else {return}
            bg.image = data.image
        }
    }
    
    fileprivate let bg: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(bg)
        bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
