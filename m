From: Sachin Prabhu <sprabhu@redhat.com>
Subject: [PATCH v2] cifs: Do not lookup hashed negative dentry in cifs_atomic_open
Date: Tue, 30 Oct 2012 19:21:08 +0000
Message-ID: <1351624868-14936-1-git-send-email-sprabhu@redhat.com>
Cc: Steve French <smfrench@gmail.com>,
	Jeff Layton <jlayton@redhat.com>, vit.zahradka@tiscali.cz,
	linux-fsdevel@vger.kernel.org
To: linux-cifs <linux-cifs@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

We do not need to lookup a hashed negative directory since we have
already revalidated it before and have found it to be fine.

This also prevents a crash in cifs_lookup() when it attempts to rehash
the already hashed negative lookup dentry.

The patch has been tested using the reproducer at
https://bugzilla.redhat.com/show_bug.cgi?id=867344#c28

Cc: <stable@kernel.org> # 3.6.x
Reported-by: Vit Zahradka <vit.zahradka@tiscali.cz>
Signed-off-by: Sachin Prabhu <sprabhu@redhat.com>
---
 fs/cifs/dir.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 7c0a812..d903647 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -398,6 +398,13 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 	 * in network traffic in the other paths.
 	 */
 	if (!(oflags & O_CREAT)) {
+		/*
+		 * Check for hashed negative dentry. We have already revalidated
+		 * the dentry and it is fine. No need to perform another lookup.
+		 */
+		if (!d_unhashed(direntry))
+			return -ENOENT;
+
 		struct dentry *res = cifs_lookup(inode, direntry, 0);
 		if (IS_ERR(res))
 			return PTR_ERR(res);
-- 
1.7.11.7

