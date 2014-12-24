From: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Subject: [PATCH] cifs: When "refer file directly", make new inode cache if
 "uniqueid is different"
Date: Wed, 24 Dec 2014 11:27:38 +0900
Message-ID: <549A249A.3080000@nttcom.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When refer file "directly" (e.g. ls -li <filename>),
 if file is same name, old inode cache is used.
This causes that client shows wrong(old) inode number.
So this patch is that if uniqueid is different, return error.

## But this patch is applicable to when Server is UNIX.
## When Server is Windows, we need another new patch.


Reproducible sample :
1. create file 'a' at cifs client.
2. rm 'a' and touch 'b a' at server.
3. ls -li 'a' at client, then client shows wrong(old) inode number.

Bug link:
https://bugzilla.kernel.org/show_bug.cgi?id=90021



Signed-off-by: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
diff -uprN -X linux-3.18-vanilla/Documentation/dontdiff linux-3.18-vanilla/fs/cifs/inode.c linux-3.18/fs/cifs/inode.c
--- linux-3.18-vanilla/fs/cifs/inode.c	2014-12-08 07:21:05.000000000 +0900
+++ linux-3.18/fs/cifs/inode.c	2014-12-19 11:07:59.127000000 +0900
@@ -402,9 +402,18 @@ int cifs_get_inode_info_unix(struct inod
 			rc = -ENOMEM;
 	} else {
 		/* we already have inode, update it */
+
+		/* if uniqueid is different, return error */
+		if (unlikely(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM &&
+		    CIFS_I(*pinode)->uniqueid != fattr.cf_uniqueid)) {
+			rc = -ENOENT;
+			goto cgiiu_exit;
+		}
+
 		cifs_fattr_to_inode(*pinode, &fattr);
 	}
 
+cgiiu_exit:
 	return rc;
 }
 
