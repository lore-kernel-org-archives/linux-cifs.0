From: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Subject: [PATCH] cifs: make new inode cache when file type is different
Date: Fri, 19 Dec 2014 15:38:14 +0900
Message-ID: <5493C7D6.4080708@nttcom.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In spite of different file type,
 if file is same name and same inode number, old inode cache is used.
This causes that you can not cd directory, can not cat SymbolicLink.
So this patch is that if file type is different, return error.


Reproducible sample :
1. create file 'a' at cifs client.
2. repeat rm and mkdir 'a' 4 times at server, then direcotry 'a' having same inode number is created.
   (Repeat 4 times, then same inode number is recycled.)
   (When server is under RHEL 6.6, 1 time is O.K.  Always same inode number is recycled.)
3. ls -li at client, then you can not cd directory, can not remove directory.

SymbolicLink has same problem.

Bug link:
https://bugzilla.kernel.org/show_bug.cgi?id=90011



Signed-off-by: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
diff -uprN -X linux-3.18-vanilla/Documentation/dontdiff linux-3.18-vanilla/fs/cifs/readdir.c linux-3.18/fs/cifs/readdir.c
--- linux-3.18-vanilla/fs/cifs/readdir.c	2014-12-08 07:21:05.000000000 +0900
+++ linux-3.18/fs/cifs/readdir.c	2014-12-18 14:52:56.268466677 +0900
@@ -69,7 +69,8 @@ static inline void dump_cifs_file_struct
  * Attempt to preload the dcache with the results from the FIND_FIRST/NEXT
  *
  * Find the dentry that matches "name". If there isn't one, create one. If it's
- * a negative dentry or the uniqueid changed, then drop it and recreate it.
+ * a negative dentry or the uniqueid or filetype(mode) changed,
+ * then drop it and recreate it.
  */
 static void
 cifs_prime_dcache(struct dentry *parent, struct qstr *name,
@@ -97,8 +98,11 @@ cifs_prime_dcache(struct dentry *parent,
 			if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM))
 				fattr->cf_uniqueid = CIFS_I(inode)->uniqueid;
 
-			/* update inode in place if i_ino didn't change */
-			if (CIFS_I(inode)->uniqueid == fattr->cf_uniqueid) {
+			/* update inode in place
+			 * if both i_ino and i_mode didn't change */
+			if (CIFS_I(inode)->uniqueid == fattr->cf_uniqueid &&
+			    (inode->i_mode & S_IFMT) ==
+			    (fattr->cf_mode & S_IFMT)) {
 				cifs_fattr_to_inode(inode, fattr);
 				goto out;
 			}
.
