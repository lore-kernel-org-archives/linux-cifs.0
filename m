From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifs: fix use-after-free bug in find_writable_file
Date: Fri, 13 Mar 2015 14:20:29 +0100
Message-ID: <1426252829-31444-1-git-send-email-ddiss@suse.de>
Cc: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Under intermittent network outages, find_writable_file() is susceptible
to the following race condition, which results in a user-after-free in
the cifs_writepages code-path:

Thread 1                                        Thread 2
========                                        ========

inv_file = NULL
refind = 0
spin_lock(&cifs_file_list_lock)

// invalidHandle found on openFileList

inv_file = open_file
// inv_file->count currently 1

cifsFileInfo_get(inv_file)
// inv_file->count = 2

spin_unlock(&cifs_file_list_lock);

cifs_reopen_file()                            cifs_close()
// fails (rc != 0)                            ->cifsFileInfo_put()
                                       spin_lock(&cifs_file_list_lock)
                                       // inv_file->count = 1
                                       spin_unlock(&cifs_file_list_lock)

spin_lock(&cifs_file_list_lock);
list_move_tail(&inv_file->flist,
      &cifs_inode->openFileList);
spin_unlock(&cifs_file_list_lock);

cifsFileInfo_put(inv_file);
->spin_lock(&cifs_file_list_lock)

  // inv_file->count = 0
  list_del(&cifs_file->flist);
  // cleanup!!
  kfree(cifs_file);

  spin_unlock(&cifs_file_list_lock);

spin_lock(&cifs_file_list_lock);
++refind;
// refind = 1
goto refind_writable;

At this point we loop back through with an invalid inv_file pointer
and a refind value of 1. On second pass, inv_file is not overwritten on
openFileList traversal, and is subsequently dereferenced.

Signed-off-by: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index a94b3e6..ca30c39 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1823,6 +1823,7 @@ refind_writable:
 			cifsFileInfo_put(inv_file);
 			spin_lock(&cifs_file_list_lock);
 			++refind;
+			inv_file = NULL;
 			goto refind_writable;
 		}
 	}
-- 
2.1.4
