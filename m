From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 1/3] cifs: don't allow cifs_iget to match inodes of the wrong type
Date: Mon, 28 Jun 2010 07:10:11 -0400
Message-ID: <1277723413-23769-2-git-send-email-jlayton@redhat.com>
References: <1277723413-23769-1-git-send-email-jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org
To: linux-cifs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1277723413-23769-1-git-send-email-jlayton@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

If the type is different from what we think it should be, then don't
match the existing inode.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/inode.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 6f0683c..f64b95f 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -723,9 +723,14 @@ cifs_find_inode(struct inode *inode, void *opaque)
 {
 	struct cifs_fattr *fattr = (struct cifs_fattr *) opaque;
 
+	/* don't match inode with different uniqueid */
 	if (CIFS_I(inode)->uniqueid != fattr->cf_uniqueid)
 		return 0;
 
+	/* don't match inode of different type */
+	if ((inode->i_mode & S_IFMT) != (fattr->cf_mode & S_IFMT))
+		return 0;
+
 	/*
 	 * uh oh -- it's a directory. We can't use it since hardlinked dirs are
 	 * verboten. Disable serverino and return it as if it were found, the
-- 
1.6.6.1

