From: Jan Kara <jack@suse.cz>
Subject: [PATCH 16/16] cifs: Use find_get_pages_range_tag()
Date: Mon,  9 Oct 2017 17:13:59 +0200
Message-ID: <20171009151359.31984-17-jack@suse.cz>
References: <20171009151359.31984-1-jack@suse.cz>
Cc: <linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-cifs@vger.kernel.org,
        Steve French <sfrench@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20171009151359.31984-1-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

wdata_alloc_and_fillpages() needlessly iterates calls to
find_get_pages_tag(). Also it wants only pages from given range. Make it
use find_get_pages_range_tag().

Suggested-by: Daniel Jordan <daniel.m.jordan@oracle.com>
CC: linux-cifs@vger.kernel.org
CC: Steve French <sfrench@samba.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/cifs/file.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 92fdf9c35de2..df9f682708c6 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1963,8 +1963,6 @@ wdata_alloc_and_fillpages(pgoff_t tofind, struct address_space *mapping,
 			  pgoff_t end, pgoff_t *index,
 			  unsigned int *found_pages)
 {
-	unsigned int nr_pages;
-	struct page **pages;
 	struct cifs_writedata *wdata;
 
 	wdata = cifs_writedata_alloc((unsigned int)tofind,
@@ -1972,23 +1970,8 @@ wdata_alloc_and_fillpages(pgoff_t tofind, struct address_space *mapping,
 	if (!wdata)
 		return NULL;
 
-	/*
-	 * find_get_pages_tag seems to return a max of 256 on each
-	 * iteration, so we must call it several times in order to
-	 * fill the array or the wsize is effectively limited to
-	 * 256 * PAGE_SIZE.
-	 */
-	*found_pages = 0;
-	pages = wdata->pages;
-	do {
-		nr_pages = find_get_pages_tag(mapping, index,
-					      PAGECACHE_TAG_DIRTY, tofind,
-					      pages);
-		*found_pages += nr_pages;
-		tofind -= nr_pages;
-		pages += nr_pages;
-	} while (nr_pages && tofind && *index <= end);
-
+	*found_pages = find_get_pages_range_tag(mapping, index, end,
+				PAGECACHE_TAG_DIRTY, tofind, wdata->pages);
 	return wdata;
 }
 
-- 
2.12.3
