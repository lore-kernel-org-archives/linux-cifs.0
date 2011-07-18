From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] cifs: fix usage of d_materialise_unique in cifs_get_root
Date: Mon, 18 Jul 2011 17:45:02 +0100
Message-ID: <20110718164501.GB11013@ZenIV.linux.org.uk>
References: <1310990594-3570-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smfrench@gmail.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, piastryyy@gmail.com
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1310990594-3570-1-git-send-email-jlayton@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Mon, Jul 18, 2011 at 08:03:14AM -0400, Jeff Layton wrote:
> It currently calls d_lookup to get a dentry and then passes that to
> d_materialise_unique. This is wrong as d_materialise_unique is intended
> to introduce a new dentry into the tree. It also uses d_lookup when
> lookup_one_len would generally be a better choice since it does
> permission checks.
> 
> Also, fix the dentry hash calculation to work with nocase mounts.

Huh?  First of all, lookup_one_len() doesn't return NULL on failure,
it returns ERR_PTR().  What's more, it already does d_alloc(), ->lookup(),
etc. and you don't need to bother with d_materialise_unique() and this
lookup-by-hand code in there.  Or with calculating hash - also done
by lookup_one_len(), TYVM...  If anything, I'd start with this as the first
approximation and probably looked into simplifying the loop a bit more -
lookup_one_len() doesn't need name component to be NUL-terminated...

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 112fbd96..2d74619 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -574,51 +574,13 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
 		full_path[i] = 0;
 		cFYI(1, "get dentry for %s", pstart);
 
-		name.name = pstart;
-		name.len = len;
-		name.hash = full_name_hash(pstart, len);
-		dchild = d_lookup(dparent, &name);
-		if (dchild == NULL) {
-			cFYI(1, "not exists");
-			dchild = d_alloc(dparent, &name);
-			if (dchild == NULL) {
-				dput(dparent);
-				dparent = ERR_PTR(-ENOMEM);
-				goto out;
-			}
-		}
-
-		cFYI(1, "get inode");
-		if (dchild->d_inode == NULL) {
-			cFYI(1, "not exists");
-			inode = NULL;
-			if (cifs_sb_master_tcon(CIFS_SB(sb))->unix_ext)
-				rc = cifs_get_inode_info_unix(&inode, full_path,
-							      sb, xid);
-			else
-				rc = cifs_get_inode_info(&inode, full_path,
-							 NULL, sb, xid, NULL);
-			if (rc) {
-				dput(dchild);
-				dput(dparent);
-				dparent = ERR_PTR(rc);
-				goto out;
-			}
-			alias = d_materialise_unique(dchild, inode);
-			if (alias != NULL) {
-				dput(dchild);
-				if (IS_ERR(alias)) {
-					dput(dparent);
-					dparent = ERR_PTR(-EINVAL); /* XXX */
-					goto out;
-				}
-				dchild = alias;
-			}
-		}
-		cFYI(1, "parent %p, child %p", dparent, dchild);
-
+		mutex_lock(&dparent->d_inode->i_mutex);
+		dchild = lookup_one_len(pstart, dparent->d_inode, len);
+		mutex_unlock(&dparent->d_inode->i_mutex);
 		dput(dparent);
 		dparent = dchild;
+		if (IS_ERR(dparent))
+			break;
 		len = 0;
 		pstart = full_path + i + 1;
 		full_path[i] = sep;
