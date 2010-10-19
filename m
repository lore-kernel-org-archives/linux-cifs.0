From: Tejun Heo <tj@kernel.org>
Subject: [PATCH v2.6.36-rc7] cifs: cancel_delayed_work() + flush_scheduled_work()
 -> cancel_delayed_work_sync()
Date: Tue, 19 Oct 2010 17:55:54 +0200
Message-ID: <4CBDBF8A.8010106@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

flush_scheduled_work() is going away.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/cifs/cifs_dfs_ref.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: work/fs/cifs/cifs_dfs_ref.c
===================================================================
--- work.orig/fs/cifs/cifs_dfs_ref.c
+++ work/fs/cifs/cifs_dfs_ref.c
@@ -44,8 +44,7 @@ static void cifs_dfs_expire_automounts(s
 void cifs_dfs_release_automount_timer(void)
 {
 	BUG_ON(!list_empty(&cifs_dfs_automount_list));
-	cancel_delayed_work(&cifs_dfs_automount_task);
-	flush_scheduled_work();
+	cancel_delayed_work_sync(&cifs_dfs_automount_task);
 }

 /**
