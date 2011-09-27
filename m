From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch] cifs: accidentally creating empty files
Date: Wed, 28 Sep 2011 00:28:10 +0300
Message-ID: <20110927212810.GA12900@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This solves a problem for where a user without write permissions
was creating empty files.  This function was supposed to do a lookup
only, the create happens later.

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 72d448b..8515afe 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -566,11 +566,13 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 		if (nd && !(nd->flags & LOOKUP_DIRECTORY) &&
 		     (nd->flags & LOOKUP_OPEN) && !pTcon->broken_posix_open &&
 		     (nd->intent.open.file->f_flags & O_CREAT)) {
+			unsigned int f_flags;
+
+			f_flags = (nd->intent.open.file->f_flags & ~O_CREAT);
 			rc = cifs_posix_open(full_path, &newInode,
 					parent_dir_inode->i_sb,
 					nd->intent.open.create_mode,
-					nd->intent.open.file->f_flags, &oplock,
-					&fileHandle, xid);
+					f_flags, &oplock, &fileHandle, xid);
 			/*
 			 * The check below works around a bug in POSIX
 			 * open in samba versions 3.3.1 and earlier where
