//
//  ViewController.m
//  AddingProducts
//
//  Created by volive solutions on 04/10/18.
//  Copyright © 2018 volive solutions. All rights reserved.
//

#import "ViewController.h"
#import "MyProducts-Swift.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,PhotoEditorDelegate>{
    UIImage *profile_pic;
    UIImagePickerController * picker_Profile_Pic;
    NSMutableArray *imagesArray;
}
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (nonatomic, strong) PhotoEditorViewController *photoEditor;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}




//MARK:- PICK IMAGE BTN ACTION

- (IBAction)pickImageBtnAction:(id)sender {
    
    UIAlertController * view=   [UIAlertController alertControllerWithTitle:@"Pick The Image" message:@"From" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* PhotoLibrary = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        self->picker_Profile_Pic = [[UIImagePickerController alloc] init];
        self->picker_Profile_Pic.delegate = self;
        [self->picker_Profile_Pic setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:self->picker_Profile_Pic animated:YES completion:NULL];
        
        [view dismissViewControllerAnimated:YES completion:nil];    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {  }];
    
    
    
    UIAlertAction* camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        self->picker_Profile_Pic = [[UIImagePickerController alloc] init];
        self->picker_Profile_Pic.delegate = self;
        [self->picker_Profile_Pic setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:self->picker_Profile_Pic animated:YES completion:NULL];
        [view dismissViewControllerAnimated:YES completion:nil];   }];
    
    
    [view addAction:PhotoLibrary];
    [view addAction:camera];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}


//MARK:- Image Picker Controller delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *original = [info objectForKey:UIImagePickerControllerOriginalImage];
    _profileImage.image = original;
    _photoEditor = [[PhotoEditorViewController alloc]init];
    
    PhotoEditorViewController *editor = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoEditorViewController"];
    
    editor.photoEditorDelegate = self;
    
    editor.image = original;
    NSMutableArray * imagesArray = [NSMutableArray new];
    [imagesArray removeAllObjects];
    for (int i=0; i<=16; i++) {
        
        NSLog(@"images %@",[NSString stringWithFormat:@"Image%d",i]);
        [imagesArray addObject:[NSString stringWithFormat:@"Image%d",i]];
        //[imagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Image%d",i]]];
        
    }
    editor.stickers = imagesArray;
    NSLog(@"stickers count %lu",(unsigned long)editor.stickers.count);
    [self presentViewController:editor animated:YES completion:nil];
    // [self.navigationController pushViewController:editor animated:YES];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK:- Photo Editor Delegate Methods

- (void)editorCanceled {
    NSLog(@"user cancel");
}

- (void)imageEditedWithImage:(UIImage * _Nonnull)image {
    _profileImage.image = image;
}


@end
