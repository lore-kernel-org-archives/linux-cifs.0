From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch] CIFS: double unlock in cifs_lock_add_if()
Date: Sat, 29 Oct 2011 10:18:54 +0300
Message-ID: <20111029071854.GA17780@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We unlocked "cinode->lock_mutex" twice so I've removed the first
unlock.

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index ea096ce..b8dbab8 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -775,11 +775,9 @@ try_again:
 					(lock->blist.next == &lock->blist));
 		if (!rc)
 			goto try_again;
-		else {
-			mutex_lock(&cinode->lock_mutex);
-			list_del_init(&lock->blist);
-			mutex_unlock(&cinode->lock_mutex);
-		}
+
+		mutex_lock(&cinode->lock_mutex);
+		list_del_init(&lock->blist);
 	}
 
 	kfree(lock);
