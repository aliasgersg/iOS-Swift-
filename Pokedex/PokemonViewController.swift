import UIKit






var savedData = UserDefaults.standard
var pokedex = Pokedex.init(caught: [ : ] )

class PokemonViewController: UIViewController {
    var url: String!
    
    

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    @IBOutlet var catchButton: UIButton!
    @IBOutlet var pokePic: UIImageView!
    
    @IBAction func catchButtonClicked(_ sender: Any, forEvent event: UIEvent) {
        print(url!)
        
        
        if pokedex.caught[nameLabel.text!] == false || pokedex.caught[nameLabel.text!] == nil {
                
                catchButton.setTitle("Release", for: .normal)
                pokedex.caught[nameLabel.text!] = true
                savedData.set(true, forKey: nameLabel.text!)
                
            }
            else{
                catchButton.setTitle("Catch", for: .normal)
                pokedex.caught[nameLabel.text!] = false
                savedData.set(false, forKey: nameLabel.text!)
            }
        
            print("Button pressed \(pokedex.caught)")
        
        

    }
    

    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        loadPokemon()
        loadSprites()
        print("View will appear \(pokedex.caught)")
        nameLabel.text = ""
        numberLabel.text = ""
        type1Label.text = ""
        type2Label.text = ""
        
        
        
 
    }
    
    func loadSprites() {
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let result = try JSONDecoder().decode(PokemonSprite.self, from: data)
                DispatchQueue.main.async {

                    let spriteURL = URL(string: result.sprites.front_default)
                    print("woohoo data can be found at \(spriteURL!)")
                    
                    let pokeData = try? Data(contentsOf: spriteURL!)
                    
                    self.pokePic.image = UIImage(data: pokeData!)
                    
                    
                    
               
                }
                
                
            }
            catch let error{
                print(error)
            }
            
            
            
            
            
        }.resume()
        
        
        
    }

    func loadPokemon() {
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard let data = data else {
                return
            }

            do {
                let result = try JSONDecoder().decode(PokemonResult.self, from: data)
                DispatchQueue.main.async {
                    self.navigationItem.title = self.capitalize(text: result.name)
                    self.nameLabel.text = self.capitalize(text: result.name)
                    self.numberLabel.text = String(format: "#%03d", result.id)
                    
                    
                    if savedData.bool(forKey: self.nameLabel.text!) == true {
                        
                        pokedex.caught[self.nameLabel.text!] = true
          
                        
                    }
                    
                    

                    if pokedex.caught[self.nameLabel.text!] == false || pokedex.caught[self.nameLabel.text!] == nil  {
                            
                        self.catchButton.setTitle("Catch", for: .normal)
                           
                       }
                    else if pokedex.caught[self.nameLabel.text!] == true {
                            
                        self.catchButton.setTitle("Release", for: .normal)

                       }
                    
                    for typeEntry in result.types {
                        if typeEntry.slot == 1 {
                            self.type1Label.text = self.capitalize(text: typeEntry.type.name)
                        }
                        else if typeEntry.slot == 2 {
                            self.type2Label.text = self.capitalize(text: typeEntry.type.name)
                        }
                    }
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }
}
