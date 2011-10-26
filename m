From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: Remove extra mutex_unlock in cifs_lock_add_if
Date: Wed, 26 Oct 2011 23:41:04 +0400
Message-ID: <1319658064-16049-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

to prevent the mutex being unlocked twice if we interrupt a blocked lock.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/file.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 3ad89ec..3dd9af6 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -899,7 +899,6 @@ try_again:
 		else {
 			mutex_lock(&cinode->lock_mutex);
 			list_del_init(&lock->blist);
-			mutex_unlock(&cinode->lock_mutex);
 		}
 	}
 
-- 
1.7.1
