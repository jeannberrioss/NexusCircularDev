trigger updateFileimage on ContentDistribution (after insert) {
    Set<Id> contentVersionIds = new Set<Id>();
    

    for (ContentDistribution cd : Trigger.new) {
        contentVersionIds.add(cd.ContentVersionId);
    }
    
    if (!contentVersionIds.isEmpty()) {
        UpdateFileImageHandler.generateUrls(contentVersionIds);
    }
}