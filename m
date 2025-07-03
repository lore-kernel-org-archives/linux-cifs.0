Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D462EA149;
	Thu,  3 Jul 2025 15:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555077; cv=none; b=fi40MVEfzlyNtCkopD8dY19IWkZvAFPIu7YfXvqvYqJPxowKFu7VY8eee6UtEQDwxkub4WZpjIxOL9p6yx7s1arPXekk92qktwARGFUKHeI0KQfCt7Dv7BsJNo4p9H7+mdEecUC8vx3SxOCDrF/nzqTBWvDo6wm0o202eQD0qJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555077; c=relaxed/simple;
	bh=31HfznZZiBY6L3XY2/G6mMsaXjAt9DPDBgW7ECyZwag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgzwtabipojQK68KlpSN+J5g6f+2+YrGvydPt3xMqpsH0l85+KHq1ofErvCwV5STnfZ21elOq6OMN2w5g+iLBRJm2aYkOSHtZa5YwZIOW9CbFolL1L1hfHsGjw0XL7PJr4v9eHEXf0jHCYJF/2uCftbrLQc5fwE9PQeKjxj7OM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G+/46zpf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G+/46zpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623E3C4CEE3;
	Thu,  3 Jul 2025 15:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555076;
	bh=31HfznZZiBY6L3XY2/G6mMsaXjAt9DPDBgW7ECyZwag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G+/46zpfrnnsNu8rXh5QNAYO/eedoHJJSGEU5cIOl0QJEqE2iyNbYjNbUAyLcIOjh
	 +DFVwSgNtLsQIsjODSHFDtJDET3BWt6gTdSPO5zxP2+ljLkPa8zu8O6LS/e1oD3wg/
	 RsUvH2dQMaOY5BRQ+n2I+KTqXkCTSewaP2NFvkVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 170/263] smb: client: fix potential deadlock when reconnecting channels
Date: Thu,  3 Jul 2025 16:41:30 +0200
Message-ID: <20250703144011.170170013@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 711741f94ac3cf9f4e3aa73aa171e76d188c0819 ]

Fix cifs_signal_cifsd_for_reconnect() to take the correct lock order
and prevent the following deadlock from happening

======================================================
WARNING: possible circular locking dependency detected
6.16.0-rc3-build2+ #1301 Tainted: G S      W
------------------------------------------------------
cifsd/6055 is trying to acquire lock:
ffff88810ad56038 (&tcp_ses->srv_lock){+.+.}-{3:3}, at: cifs_signal_cifsd_for_reconnect+0x134/0x200

but task is already holding lock:
ffff888119c64330 (&ret_buf->chan_lock){+.+.}-{3:3}, at: cifs_signal_cifsd_for_reconnect+0xcf/0x200

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #2 (&ret_buf->chan_lock){+.+.}-{3:3}:
       validate_chain+0x1cf/0x270
       __lock_acquire+0x60e/0x780
       lock_acquire.part.0+0xb4/0x1f0
       _raw_spin_lock+0x2f/0x40
       cifs_setup_session+0x81/0x4b0
       cifs_get_smb_ses+0x771/0x900
       cifs_mount_get_session+0x7e/0x170
       cifs_mount+0x92/0x2d0
       cifs_smb3_do_mount+0x161/0x460
       smb3_get_tree+0x55/0x90
       vfs_get_tree+0x46/0x180
       do_new_mount+0x1b0/0x2e0
       path_mount+0x6ee/0x740
       do_mount+0x98/0xe0
       __do_sys_mount+0x148/0x180
       do_syscall_64+0xa4/0x260
       entry_SYSCALL_64_after_hwframe+0x76/0x7e

-> #1 (&ret_buf->ses_lock){+.+.}-{3:3}:
       validate_chain+0x1cf/0x270
       __lock_acquire+0x60e/0x780
       lock_acquire.part.0+0xb4/0x1f0
       _raw_spin_lock+0x2f/0x40
       cifs_match_super+0x101/0x320
       sget+0xab/0x270
       cifs_smb3_do_mount+0x1e0/0x460
       smb3_get_tree+0x55/0x90
       vfs_get_tree+0x46/0x180
       do_new_mount+0x1b0/0x2e0
       path_mount+0x6ee/0x740
       do_mount+0x98/0xe0
       __do_sys_mount+0x148/0x180
       do_syscall_64+0xa4/0x260
       entry_SYSCALL_64_after_hwframe+0x76/0x7e

-> #0 (&tcp_ses->srv_lock){+.+.}-{3:3}:
       check_noncircular+0x95/0xc0
       check_prev_add+0x115/0x2f0
       validate_chain+0x1cf/0x270
       __lock_acquire+0x60e/0x780
       lock_acquire.part.0+0xb4/0x1f0
       _raw_spin_lock+0x2f/0x40
       cifs_signal_cifsd_for_reconnect+0x134/0x200
       __cifs_reconnect+0x8f/0x500
       cifs_handle_standard+0x112/0x280
       cifs_demultiplex_thread+0x64d/0xbc0
       kthread+0x2f7/0x310
       ret_from_fork+0x2a/0x230
       ret_from_fork_asm+0x1a/0x30

other info that might help us debug this:

Chain exists of:
  &tcp_ses->srv_lock --> &ret_buf->ses_lock --> &ret_buf->chan_lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ret_buf->chan_lock);
                               lock(&ret_buf->ses_lock);
                               lock(&ret_buf->chan_lock);
  lock(&tcp_ses->srv_lock);

 *** DEADLOCK ***

3 locks held by cifsd/6055:
 #0: ffffffff857de398 (&cifs_tcp_ses_lock){+.+.}-{3:3}, at: cifs_signal_cifsd_for_reconnect+0x7b/0x200
 #1: ffff888119c64060 (&ret_buf->ses_lock){+.+.}-{3:3}, at: cifs_signal_cifsd_for_reconnect+0x9c/0x200
 #2: ffff888119c64330 (&ret_buf->chan_lock){+.+.}-{3:3}, at: cifs_signal_cifsd_for_reconnect+0xcf/0x200

Cc: linux-cifs@vger.kernel.org
Reported-by: David Howells <dhowells@redhat.com>
Fixes: d7d7a66aacd6 ("cifs: avoid use of global locks for high contention data")
Reviewed-by: David Howells <dhowells@redhat.com>
Tested-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h |  1 +
 fs/smb/client/connect.c  | 58 +++++++++++++++++++++++++---------------
 2 files changed, 37 insertions(+), 22 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 214e53acf72a8..56381cbb63990 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -709,6 +709,7 @@ inc_rfc1001_len(void *buf, int count)
 struct TCP_Server_Info {
 	struct list_head tcp_ses_list;
 	struct list_head smb_ses_list;
+	struct list_head rlist; /* reconnect list */
 	spinlock_t srv_lock;  /* protect anything here that is not protected */
 	__u64 conn_id; /* connection identifier (useful for debugging) */
 	int srv_count; /* reference counter */
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index f9aef60f1901a..e92c7b71626fd 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -124,6 +124,14 @@ static void smb2_query_server_interfaces(struct work_struct *work)
 			   (SMB_INTERFACE_POLL_INTERVAL * HZ));
 }
 
+#define set_need_reco(server) \
+do { \
+	spin_lock(&server->srv_lock); \
+	if (server->tcpStatus != CifsExiting) \
+		server->tcpStatus = CifsNeedReconnect; \
+	spin_unlock(&server->srv_lock); \
+} while (0)
+
 /*
  * Update the tcpStatus for the server.
  * This is used to signal the cifsd thread to call cifs_reconnect
@@ -137,39 +145,45 @@ void
 cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
 				bool all_channels)
 {
-	struct TCP_Server_Info *pserver;
+	struct TCP_Server_Info *nserver;
 	struct cifs_ses *ses;
+	LIST_HEAD(reco);
 	int i;
 
-	/* If server is a channel, select the primary channel */
-	pserver = SERVER_IS_CHAN(server) ? server->primary_server : server;
-
 	/* if we need to signal just this channel */
 	if (!all_channels) {
-		spin_lock(&server->srv_lock);
-		if (server->tcpStatus != CifsExiting)
-			server->tcpStatus = CifsNeedReconnect;
-		spin_unlock(&server->srv_lock);
+		set_need_reco(server);
 		return;
 	}
 
-	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
-		if (cifs_ses_exiting(ses))
-			continue;
-		spin_lock(&ses->chan_lock);
-		for (i = 0; i < ses->chan_count; i++) {
-			if (!ses->chans[i].server)
+	if (SERVER_IS_CHAN(server))
+		server = server->primary_server;
+	scoped_guard(spinlock, &cifs_tcp_ses_lock) {
+		set_need_reco(server);
+		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+			spin_lock(&ses->ses_lock);
+			if (ses->ses_status == SES_EXITING) {
+				spin_unlock(&ses->ses_lock);
 				continue;
-
-			spin_lock(&ses->chans[i].server->srv_lock);
-			if (ses->chans[i].server->tcpStatus != CifsExiting)
-				ses->chans[i].server->tcpStatus = CifsNeedReconnect;
-			spin_unlock(&ses->chans[i].server->srv_lock);
+			}
+			spin_lock(&ses->chan_lock);
+			for (i = 1; i < ses->chan_count; i++) {
+				nserver = ses->chans[i].server;
+				if (!nserver)
+					continue;
+				nserver->srv_count++;
+				list_add(&nserver->rlist, &reco);
+			}
+			spin_unlock(&ses->chan_lock);
+			spin_unlock(&ses->ses_lock);
 		}
-		spin_unlock(&ses->chan_lock);
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+
+	list_for_each_entry_safe(server, nserver, &reco, rlist) {
+		list_del_init(&server->rlist);
+		set_need_reco(server);
+		cifs_put_tcp_session(server, 0);
+	}
 }
 
 /*
-- 
2.39.5



