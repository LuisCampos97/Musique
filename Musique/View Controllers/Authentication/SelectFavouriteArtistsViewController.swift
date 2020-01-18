import UIKit
import Alamofire
import os.log


class SelectFavouriteArtistsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    @IBOutlet weak var favouriteArtistsCollectionView: UICollectionView!
    @IBOutlet weak var nextPageButton: UIButton!
    
    enum Mode {
        case skip
        case select
    }
    
    var name = ""
    var email = ""
    var password = ""
    var gender = ""
    var birthDate = ""
    
    var chartsURL = String()
    
    var topArtists = [Artist]()
    
    typealias JSONStandard = [String : AnyObject]
        
    var _selectedCells : NSMutableArray = []
    
    var mMode: Mode = .skip

    override func viewDidLoad() {
          callDeezerAPI()
            
          super.viewDidLoad()

        let itemSize = UIScreen.main.bounds.width/2-20
          
          let layout = UICollectionViewFlowLayout()
          layout.itemSize = CGSize(width: itemSize, height: itemSize)
          
          layout.minimumInteritemSpacing = 5
          layout.minimumLineSpacing = 5
          
          favouriteArtistsCollectionView.collectionViewLayout = layout
        
        nextPageButton.setTitle("Skip", for: .normal)
        nextPageButton.layer.cornerRadius = 12
        print(name)


      }

      
      //Number of views
      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return topArtists.count
      }
      
    //Populate view
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SelectFavouriteArtistsCollectionViewCell
        cell.favouriteArtisitsImageView.layer.cornerRadius = 12
        cell.favouriteArtisitsImageView.image = self.topArtists[indexPath.row].image
               
        return cell
      }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.allowsMultipleSelection = true
        _selectedCells.add(self.topArtists[indexPath.row].idFromAPI)
        if _selectedCells.count > 0 {
            nextPageButton.setTitle("Next", for: .normal)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        _selectedCells.remove(self.topArtists[indexPath.row].idFromAPI)
        if _selectedCells.count == 0 {
            nextPageButton.setTitle("Skip", for: .normal)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let sr = collectionView.indexPathsForSelectedItems {
            if sr.count == 3 {
                let alertController = UIAlertController(title: "Oops", message:
                    "You can only choose up to \(3) artists", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                }))
                self.present(alertController, animated: true, completion: nil)
                
                return false
            }
        }
        
        return true
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
                    let mainImageURL =  URL(string: item["picture_xl"] as! String)
                    let mainImageData = NSData(contentsOf: mainImageURL!)
                    let mainImage = UIImage(data: mainImageData! as Data)
                  
                    addArtist((Artist.init(idFromAPI: idFromAPI, name: artistName, image: mainImage!))!)
                    self.favouriteArtistsCollectionView.reloadInputViews()
                    self.favouriteArtistsCollectionView.reloadData()
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
    
    @IBAction func nextTapped(_ sender: Any) {
        
                    
            //Transition to the view of Select 3 favorities artists
            self.performSegue(withIdentifier: "SelectFavouriteArtistsToCompleteSegue", sender: self)

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! RegisterCompleteViewController
        vc.name = self.name
        vc.email = self.email
        vc.password = self.password
        vc.gender = self.gender
        vc.birthDate = self.birthDate
        vc._selectedCells = self._selectedCells
    }
    
}
