From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch] cifs: update a check for NULL function pointer
Date: Tue, 26 Aug 2014 10:38:03 +0300
Message-ID: <20140826073802.GA31076@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We changed the function call from ->close() to ->close_dir() so we
should update the test for NULL as well.

Both of them probably work, but my static checker complains when we have
a check for a NULL function pointer and then immediately call a
different function pointer.  This is a common cut and paste error.

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 41e52e2..d2141f1 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -592,7 +592,7 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
 		if (server->ops->dir_needs_close(cfile)) {
 			cfile->invalidHandle = true;
 			spin_unlock(&cifs_file_list_lock);
-			if (server->ops->close)
+			if (server->ops->close_dir)
 				server->ops->close_dir(xid, tcon, &cfile->fid);
 		} else
 			spin_unlock(&cifs_file_list_lock);
