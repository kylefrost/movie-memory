//
//  MMWatchedTableViewController.m
//  Movie-Memory
//
//  Created by Kyle Frost on 5/24/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import "MMWatchedTableViewController.h"
#import "MMTableViewCell.h"

@interface MMWatchedTableViewController ()

@end

@implementation MMWatchedTableViewController {
    // Array for the UISearchDisplayController results
    NSArray *searchResults;
}

@synthesize movies = _movies;

// Register view to access the Core Data from the App Delegate
-(NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

-(void)loadMovies
{
    // Load the tableView with information from the Core Data movies
    NSManagedObjectContext *managedContext = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Movie"];
    _movies = [[managedContext executeFetchRequest:request error:nil] mutableCopy];
    [self.tableView reloadData];
}

-(void)viewDidLoad {
    [super viewDidLoad];

    [self loadMovies];
    [self updateTableView];
    
    // Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableView) name:@"updateTableView" object:nil];
    
    // Right BarButtonItem is edit button to edit movie list
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // If user is opening a movie that has already been created, do this
    if ([[segue identifier] isEqualToString:@"EditMovie"]) {
        NSManagedObject *selectedMovie = nil;
        NSIndexPath *indexPath = nil;
        // If user is in the search results list, do this
        if (self.searchDisplayController.active) {
            // Send user to movie info page that is selected
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            selectedMovie = [searchResults objectAtIndex:indexPath.row];
        }
        // If user is just in normal view (i.e. not is search), do this
        else {
            // Send user to movie info page that is selected
            indexPath = [self.tableView indexPathForSelectedRow];
            selectedMovie = [_movies objectAtIndex:indexPath.row];
        }
        
        // Set the destination as the selected movie and open the movie
        MMAddManualViewController *destination = segue.destinationViewController;
        destination.movies = selectedMovie;
    }
    else if ([[segue identifier] isEqualToString:@"addManual"]) {
        MMAddManualViewController *destination = segue.destinationViewController;
        destination.myDelegate = self;
        
        [self addChildViewController:segue.destinationViewController];
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    // Load the tableView with information from the Core Data movies
    NSManagedObjectContext *managedContext = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Movie"];
    _movies = [[managedContext executeFetchRequest:request error:nil] mutableCopy];
    [self.tableView reloadData];
    [self updateTableView];
}

-(void)viewWillAppear:(BOOL)animated {
    
    // Run ViewDidAppear in order to update information in TableView before the user sees the view
    [self updateTableView];
    
    // If there aren't any movies, don't show the edit button
}

- (void)updateTableView {
    [self loadMovies];
    [self.tableView reloadData];
    if (_movies.count == 0) {
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
}

- (IBAction)refreshTableView
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Only show one section in the table view
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // If searching, return searchResults count, if in normal view, return movies count
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchResults.count;
    } else {
        return _movies.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set CellIdentifier of custom MMTableViewCell as Cell
    static NSString *CellIdentifier = @"Cell";
    MMTableViewCell *cell = (MMTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Initialize movie to nil
    NSManagedObject *movie = nil;
    
    // Populate the search and movie list with information from the searchResults or movies arrays
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        movie = [searchResults objectAtIndex:indexPath.row];
    } else {
        movie = [_movies objectAtIndex:indexPath.row];
    }
    
    // Set up the custom UITableViewCell with information
    [cell.titleLabel setText:[NSString stringWithFormat:@"%@", [movie valueForKey:@"title"]]];
    [cell.releaseLabel setText:[NSString stringWithFormat:@"%@", [movie valueForKey:@"releaseYear"]]];
    [cell.watchedLabel setText:[NSString stringWithFormat:@"%@", [movie valueForKey:@"watchedDate"]]];
    
    // Determine movie rating (1-5) and show appropriate star. If no stars show no rating.
    if ([movie valueForKey:@"rating"] == nil) {
        [cell.ratingLabel setText:[NSString stringWithFormat:@"No Rating"]];
    } else if ([[movie valueForKey:@"rating"] intValue] == 1) {
        [cell.ratingImage setImage:[UIImage imageNamed:@"stars_one"]];
    } else if ([[movie valueForKey:@"rating"] intValue] == 2) {
        [cell.ratingImage setImage:[UIImage imageNamed:@"stars_two"]];
    } else if ([[movie valueForKey:@"rating"] intValue] == 3) {
        [cell.ratingImage setImage:[UIImage imageNamed:@"stars_three"]];
    } else if ([[movie valueForKey:@"rating"] intValue] == 4) {
        [cell.ratingImage setImage:[UIImage imageNamed:@"stars_four"]];
    } else if ([[movie valueForKey:@"rating"] intValue] == 5) {
        [cell.ratingImage setImage:[UIImage imageNamed:@"stars_five"]];
    }
    
    // Determine if there is a cover image for the movie
    if ([movie valueForKey:@"cover"] == nil) {
        // If there is no provided cover, show custom No Cover image
        [cell.coverImage setImage:[UIImage imageNamed:@"no_cover"]];
    } else {
        // If there is a cover, show that cover image
        UIImage *coverDataImage = [UIImage imageWithData:[movie valueForKey:@"cover"]];
        [cell.coverImage setImage:coverDataImage];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

// Override to support conditional editing of the table view.
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return Yes to allow deletion of rows
    return YES;
}

// Override to support editing the table view.
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set the context to the managedObjectContext
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // If the editing style is deletion, do this
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the object from the row that was deleted
        [context deleteObject:[_movies objectAtIndex:indexPath.row]];
        
        // Submit that save to Core Data database
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Error deleting!\nError: %@\nDescription: %@", error, [error localizedDescription]);
            return;
        }
        
        // Remove it from the array and from the tableview
        [_movies removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    // Filter the array movies to find only the movies with a title containing the character string entered in search
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"title contains[c] %@", searchText];
    searchResults = [_movies filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Reload the tableview for the search results as the typed search string updates
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

// Set the row height for the cells
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

@end
