From: Nick Piggin <npiggin@kernel.dk>
Subject: [patch] cifs: don't overwrite dentry name in d_revalidate
Date: Thu, 11 Nov 2010 18:42:16 +1100
Message-ID: <20101111074216.GA10159@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Instead, use fatfs's method for dealing with negative dentries to
preserve case, rather than overwrite dentry name in d_revalidate, which
is a bit ugly and also gets in the way of doing lock-free path walking.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

Index: linux-2.6/fs/cifs/dir.c
===================================================================
--- linux-2.6.orig/fs/cifs/dir.c	2010-11-11 18:05:55.000000000 +1100
+++ linux-2.6/fs/cifs/dir.c	2010-11-11 18:06:49.000000000 +1100
@@ -656,22 +656,34 @@ cifs_lookup(struct inode *parent_dir_ino
 static int
 cifs_d_revalidate(struct dentry *direntry, struct nameidata *nd)
 {
-	int isValid = 1;
-
 	if (direntry->d_inode) {
 		if (cifs_revalidate_dentry(direntry))
 			return 0;
-	} else {
-		cFYI(1, "neg dentry 0x%p name = %s",
-			 direntry, direntry->d_name.name);
-		if (time_after(jiffies, direntry->d_time + HZ) ||
-			!lookupCacheEnabled) {
-			d_drop(direntry);
-			isValid = 0;
-		}
+		else
+			return 1;
+	}
+
+	/*
+	 * This may be nfsd (or something), anyway, we can't see the
+	 * intent of this. So, since this can be for creation, drop it.
+	 */
+	if (!nd)
+		return 0;
+
+	/*
+	 * Drop the negative dentry, in order to make sure to use the
+	 * case sensitive name which is specified by user if this is
+	 * for creation.
+	 */
+	if (!(nd->flags & (LOOKUP_CONTINUE | LOOKUP_PARENT))) {
+		if (nd->flags & (LOOKUP_CREATE | LOOKUP_RENAME_TARGET))
+			return 0;
 	}
 
-	return isValid;
+	if (time_after(jiffies, direntry->d_time + HZ) || !lookupCacheEnabled)
+		return 0;
+
+	return 1;
 }
 
 /* static int cifs_d_delete(struct dentry *direntry)
@@ -709,15 +721,8 @@ static int cifs_ci_compare(struct dentry
 	struct nls_table *codepage = CIFS_SB(dentry->d_inode->i_sb)->local_nls;
 
 	if ((a->len == b->len) &&
-	    (nls_strnicmp(codepage, a->name, b->name, a->len) == 0)) {
-		/*
-		 * To preserve case, don't let an existing negative dentry's
-		 * case take precedence.  If a is not a negative dentry, this
-		 * should have no side effects
-		 */
-		memcpy((void *)a->name, b->name, a->len);
+	    (nls_strnicmp(codepage, a->name, b->name, a->len) == 0))
 		return 0;
-	}
 	return 1;
 }
 
