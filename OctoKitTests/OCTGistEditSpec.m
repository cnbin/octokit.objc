//
//  OCTGistEditSpec.m
//  OctoKit
//
//  Created by Chris Lundie on 2014-03-07.
//

#import <Nimble/Nimble.h>
#import <OctoKit/OctoKit.h>
#import <Quick/Quick.h>

#import "OCTObjectSpec.h"

QuickSpecBegin(OCTGistEditSpec)

describe(@"JSON serialization", ^{
	it(@"can be serialized and deserialized", ^{
		OCTGistEdit *edit = [[OCTGistEdit alloc] init];
		edit.gistDescription = @"The Description";
		edit.publicGist = YES;

		OCTGistFileEdit *fileEditAdd = [[OCTGistFileEdit alloc] init];
		fileEditAdd.filename = @"Add";
		fileEditAdd.content = @"Add Content";
		edit.filesToAdd = @[ fileEditAdd ];
		edit.filenamesToDelete = @[ @"Delete" ];

		OCTGistFileEdit *fileEditModify = [[OCTGistFileEdit alloc] init];
		fileEditModify.filename = @"Modify";
		fileEditModify.content = @"Modify Content";
		edit.filesToModify = @{
			fileEditModify.filename: fileEditModify,
		};

		NSDictionary *expectedDict = @{
			@"public": @(edit.publicGist),
			@"description": edit.gistDescription,
			@"files": @{
				fileEditAdd.filename: @{
					@"content": fileEditAdd.content,
					@"filename": fileEditAdd.filename,
				},
				edit.filenamesToDelete[0]: NSNull.null,
				fileEditModify.filename: @{
					@"content": fileEditModify.content,
					@"filename": fileEditModify.filename,
				},
			},
		};

		NSDictionary *editDict = [MTLJSONAdapter JSONDictionaryFromModel:edit];
		expect(editDict).to(equal(expectedDict));
	});
});

QuickSpecEnd
