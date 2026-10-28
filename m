Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214273;
	b=FBkT5yEQp8oZqwJhWPBwJw0JkWkycpmxpzOO96U3thqEpaPi28gym3OH5RRES9EOeXt1
	 YFFBb7FQ9jw+q1XLSlVWUpwVmYc6Gv01Ao1OJgxCpC9qmjSDh6rs5Bg+eu+Db/EQagcWP
	 c4r1QFX2mxR9yN6+epqckp/kXTqSp8dM3tOybrPGYS6OTrgwkLL91a7KXX9whTt6vR8iS
	 HSM0XiV9KNMoVUB9xOZABUZrFln0Ga4Q6o4vGoBabORizbSggvDkP+2zjt0IfC46h7AT2
	 A9hunLCsxkddk8fagA97EMXU8UG6BZf/081m1iHw2O8w5QueKht3zpZkJOr+GOJ1XGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214273;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=03OPWAPfRAeawCvWNuFYm8tQ7NQsXyTuf4FaquQwQ50=;
	b=Rfk0j/etIhmw+/O80tzQK9axi9SqYeTVeK6+2nWNvKM7L9Rxv7ybPyArEYcjJHiehbwU
	 PemmAvucinF9GXAbMLuJnxVko45Hy5QQycOVVoXtLVqk4I+I8+3EzVAVDi2C9YD1EX8a1
	 kBngEcaDZrww7cuYpXK9j/+mPb4PqeVEGypWaVvYwwyBHqitYuuH6+vvYtRACAqj5rAzn
	 p32Av6241fk22O1FfaSNWUejiPxcrsH5Kceu1gfNHn4xUnsJVqVhkPLSoOEe17cMlT7dU
	 yFCo2oVZsrlsEm2IuJIQo6Wnr9i3QIRTeZIVPo8qaJu+Nwo6K3hgrtrDok6HEj1S2Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DflmmeC5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F16260A2634;
	Wed, 28 Oct 2026 19:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DflmmeC5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4DDD1F01829;
	Wed, 28 Oct 2026 19:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214272;
	bh=03OPWAPfRAeawCvWNuFYm8tQ7NQsXyTuf4FaquQwQ50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DflmmeC5DSUbbVRnJxTM+nupas5RbtcpcyRCH/wwREJddj/zs/GRv2iG/jRfn5ail
	 5ZbKBwpWL5mEMnx1f9YzqYeaAXe9H2YXzhvqc5mBWHF1srMF9Gc/Y8p/HHmI0TaOWp
	 rK5X2Pp2KN5OAHYVqgOzPObGxfao5yKLw78V3Q8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0799/1887] smb: client: fix potential deadlock when reconnecting channels
Date: Wed, 28 Oct 2026 17:48:15 +0100
Message-ID: <20261028170517.612235809@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 fs/smb/client/connect.c  | 56 ++++++++++++++++++++++++++--------------
 2 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index c37f10eedddf2..4e463ee8e40bb 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -589,6 +589,7 @@ get_rfc1002_length(void *buf)
 struct TCP_Server_Info {
 	struct list_head tcp_ses_list;
 	struct list_head smb_ses_list;
+	struct list_head rlist; /* reconnect list */
 	spinlock_t srv_lock;  /* protect anything here that is not protected */
 	__u64 conn_id; /* connection identifier (useful for debugging) */
 	int srv_count; /* reference counter */
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 9172b4136a925..abc03adb692b5 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -185,6 +185,14 @@ static void cifs_resolve_server(struct work_struct *work)
 	cifs_server_unlock(server);
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
@@ -198,35 +206,45 @@ void
 cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
 				bool all_channels)
 {
-	struct TCP_Server_Info *pserver;
+	struct TCP_Server_Info *nserver;
 	struct cifs_ses *ses;
+	LIST_HEAD(reco);
 	int i;
 
-	/* If server is a channel, select the primary channel */
-	pserver = CIFS_SERVER_IS_CHAN(server) ? server->primary_server : server;
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
-			spin_lock(&ses->chans[i].server->srv_lock);
-			ses->chans[i].server->tcpStatus = CifsNeedReconnect;
-			spin_unlock(&ses->chans[i].server->srv_lock);
+	if (CIFS_SERVER_IS_CHAN(server))
+		server = server->primary_server;
+	scoped_guard(spinlock, &cifs_tcp_ses_lock) {
+		set_need_reco(server);
+		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+			spin_lock(&ses->ses_lock);
+			if (ses->ses_status == SES_EXITING) {
+				spin_unlock(&ses->ses_lock);
+				continue;
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
2.53.0



