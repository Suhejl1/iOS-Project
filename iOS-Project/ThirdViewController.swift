import UIKit
import SafariServices
import SQLite3

class ThirdViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var removeBtn: UIButton!
    
    var likedMovies = [Movie]()
    var db: OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        
        if sqlite3_open(getDBPath(), &db) == SQLITE_OK {
            createTable()
        }
    }
    
    deinit {
        sqlite3_close(db)
    }
    
    func getDBPath() -> String {
        let documentsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dbPath = URL(fileURLWithPath: documentsDir).appendingPathComponent("moviesDB.sqlite").path
        return dbPath
    }
    
    func createTable() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS Movies (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            year TEXT,
            imdbID TEXT,
            type TEXT,
            poster TEXT
        );
        """
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating table")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        
        let likedMovie = likedMovies[indexPath.row]
        cell.configure(with: likedMovie)
        
        return cell
    }
    
    func addLikedMovie(_ likedMovie: Movie) {
        likedMovies.append(likedMovie)
        
        // Insert the liked movie into the SQLite database
        if insertMovieIntoDB(movie: likedMovie) {
            // Print a success message
            print("Movie added to DBtable successfully.")
        } else {
            // Print an error message
            print("Failed to add the movie to favorites.")
        }
        
        guard let tableView = tableView else {
            print("ErrorL tblView")
            return
        }
        
        if isViewLoaded && (view.window != nil) {
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
    }
    
    @IBAction func removeButtonPressed(_ sender: UIButton) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            let removedMovie = likedMovies.remove(at: selectedIndexPath.row)
            tableView.reloadData()
            
            // Remove the liked movie from the SQLite database
            if removeMovieFromDB(movie: removedMovie) {
                // Print a success message
                print("Movie removed from DBtable successfully.")
            } else {
                // Print an error message
                print("Failed to remove the movie from favorites.")
            }
        }
    }
    
    func insertMovieIntoDB(movie: Movie) -> Bool {
        let insertQuery = """
        INSERT INTO Movies (title, year, imdbID, type, poster)
        VALUES (?, ?, ?, ?, ?);
        """
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (movie.Title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (movie.Year as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (movie.imdbID as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (movie._Type as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 5, (movie.Poster as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                // Movie added successfully
                sqlite3_finalize(statement)
                return true
            } else {
                print("Error inserting movie into database")
            }
            
            sqlite3_finalize(statement)
        } else {
            print("Error preparing insert statement")
        }
        
        return false
    }
    
    func removeMovieFromDB(movie: Movie) -> Bool {
        let deleteQuery = """
        DELETE FROM Movies
        WHERE imdbID = ?;
        """
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (movie.imdbID as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                // Movie removed successfully
                sqlite3_finalize(statement)
                return true
            } else {
                print("Error deleting movie from database")
            }
            
            sqlite3_finalize(statement)
        } else {
            print("Error preparing delete statement")
        }
        
        return false
    }
}
