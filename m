From: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Subject: [PATCH] cifs: When "refer file directly", make new inode cache if
 file type is different
Date: Wed, 24 Dec 2014 11:14:32 +0900
Message-ID: <549A2188.5030809@nttcom.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This problem is similar as
 "Dec/19/2014  [PATCH] cifs: make new inode cache when file type is different"
but we need different patch.


Problem :
When "refer file directly" (e.g. ls <filename>),
 in spite of different file type,
 if file is same name, old inode cache is used.
This causes that you can not cd directory, can not cat SymbolicLink.
So this patch is that if file type is different, return error.


Reproducible sample :
1. create file 'a' at cifs client.
2. rm 'a' and mkdir 'a' at server.
3. ls 'a' at client, then returned error (ls: cannot open directory).
   And you can not cd directory.

SymbolicLink has same problem.

Bug link:
https://bugzilla.kernel.org/show_bug.cgi?id=90031

# cifs_get_inode_info_unix() is for UNIX server.
# cifs_get_inode_info() is for Win server.




Signed-off-by: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
diff -uprN -X linux-3.18-vanilla/Documentation/dontdiff linux-3.18-vanilla/fs/cifs/inode.c linux-3.18/fs/cifs/inode.c
--- linux-3.18-vanilla/fs/cifs/inode.c	2014-12-08 07:21:05.000000000 +0900
+++ linux-3.18/fs/cifs/inode.c	2014-12-18 14:20:35.096468862 +0900
@@ -402,9 +402,18 @@ int cifs_get_inode_info_unix(struct inod
 			rc = -ENOMEM;
 	} else {
 		/* we already have inode, update it */
+
+		/* if filetype is different, return error */
+		if (unlikely(((*pinode)->i_mode & S_IFMT) !=
+		    (fattr.cf_mode & S_IFMT))) {
+			rc = -ENOENT;
+			goto cgiiu_exit;
+		}
+
 		cifs_fattr_to_inode(*pinode, &fattr);
 	}
 
+cgiiu_exit:
 	return rc;
 }
 
@@ -837,6 +846,15 @@ cifs_get_inode_info(struct inode **inode
 		if (!*inode)
 			rc = -ENOMEM;
 	} else {
+		/* we already have inode, update it */
+
+		/* if filetype is different, return error */
+		if (unlikely(((*inode)->i_mode & S_IFMT) !=
+		    (fattr.cf_mode & S_IFMT))) {
+			rc = -ENOENT;
+			goto cgii_exit;
+		}
+
 		cifs_fattr_to_inode(*inode, &fattr);
 	}
