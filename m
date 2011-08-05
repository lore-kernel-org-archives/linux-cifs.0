From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH] cifs: cope with negative dentries in cifs_get_root
Date: Fri,  5 Aug 2011 09:02:40 -0400
Message-ID: <1312549360-4317-1-git-send-email-jlayton@redhat.com>
Cc: viro@ZenIV.linux.org.uk, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: smfrench@gmail.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

The loop around lookup_one_len doesn't handle the case where it might
return a negative dentry, which can cause an oops on the next pass
through the loop. Check for that and break out of the loop with an
error of -ENOENT if there is one.

Fixes the panic reported here:

    https://bugzilla.redhat.com/show_bug.cgi?id=727927

Reported-by: TR Bentley <home@trarbentley.net>
Reported-by: Iain Arnell <iarnell@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: stable@kernel.org
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/cifsfs.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 212e562..f93eb94 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -563,6 +563,10 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
 		mutex_unlock(&dir->i_mutex);
 		dput(dentry);
 		dentry = child;
+		if (!dentry->d_inode) {
+			dput(dentry);
+			dentry = ERR_PTR(-ENOENT);
+		}
 	} while (!IS_ERR(dentry));
 	_FreeXid(xid);
 	kfree(full_path);
-- 
1.7.6

