Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5B02E54C4;
	Tue,  8 Jul 2025 16:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992406; cv=none; b=n8WaP3zXZTlw50HFq/fNT5dLlb23FMPhci7nMiCPZxnm9KU/b0TCdr6TQR5l5RPXMpGEaJzsDcxlKZqoXIaXhRx3Df/4idddsNlZicuE0CkBKPJk8iHXvvKIiCDH51Fk1N6ZLXyvOw780u7aiOyjGbXwdzwpNHkz6+8juKU51Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992406; c=relaxed/simple;
	bh=z7kgl2wsC5yZCobHLrGav0cWtp95gQYTlpjZ7N/wTTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHSSCQ+SKD4j+BGo16tGZXe4xGE7B4WoGGBoGu0XtgxrrP3n/kMDhFqom20Uzr3yivQfl5E17bkOXcKUbjmZcVe7mfsl6Qv1S8OvYNXERUYPWgdEJjn7pHLSW9ZfmEA1AOKj7my++g+GN/fbma5TxkHHfgPxQ/JVa0HAx/Gw6Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSBW5RkE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSBW5RkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB783C4CEF5;
	Tue,  8 Jul 2025 16:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992406;
	bh=z7kgl2wsC5yZCobHLrGav0cWtp95gQYTlpjZ7N/wTTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSBW5RkEVcHh7/0pETPQdycIe8xaqNFqhxVeHW3Fo9kUbyutFmu8DeavUZPkciyt0
	 XlnxWXZCCgpkV2LUoHV1kfpP9BVGSxSqZJKu3mXVClLgPm9GRDriDNtex7Tw+9P9T/
	 fL+1FKr8FZaPxRgFnjhvrmlZnBV8oEpZOLN06l50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Shyam Prasad N <nspmangalore@gmail.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/132] smb: client: fix warning when reconnecting channel
Date: Tue,  8 Jul 2025 18:22:42 +0200
Message-ID: <20250708162232.153036061@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 3bbe46716092d8ef6b0df4b956f585c5cd0fc78e ]

When reconnecting a channel in smb2_reconnect_server(), a dummy tcon
is passed down to smb2_reconnect() with ->query_interface
uninitialized, so we can't call queue_delayed_work() on it.

Fix the following warning by ensuring that we're queueing the delayed
worker from correct tcon.

WARNING: CPU: 4 PID: 1126 at kernel/workqueue.c:2498 __queue_delayed_work+0x1d2/0x200
Modules linked in: cifs cifs_arc4 nls_ucs2_utils cifs_md4 [last unloaded: cifs]
CPU: 4 UID: 0 PID: 1126 Comm: kworker/4:0 Not tainted 6.16.0-rc3 #5 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-4.fc42 04/01/2014
Workqueue: cifsiod smb2_reconnect_server [cifs]
RIP: 0010:__queue_delayed_work+0x1d2/0x200
Code: 41 5e 41 5f e9 7f ee ff ff 90 0f 0b 90 e9 5d ff ff ff bf 02 00
00 00 e8 6c f3 07 00 89 c3 eb bd 90 0f 0b 90 e9 57 f> 0b 90 e9 65 fe
ff ff 90 0f 0b 90 e9 72 fe ff ff 90 0f 0b 90 e9
RSP: 0018:ffffc900014afad8 EFLAGS: 00010003
RAX: 0000000000000000 RBX: ffff888124d99988 RCX: ffffffff81399cc1
RDX: dffffc0000000000 RSI: ffff888114326e00 RDI: ffff888124d999f0
RBP: 000000000000ea60 R08: 0000000000000001 R09: ffffed10249b3331
R10: ffff888124d9998f R11: 0000000000000004 R12: 0000000000000040
R13: ffff888114326e00 R14: ffff888124d999d8 R15: ffff888114939020
FS:  0000000000000000(0000) GS:ffff88829f7fe000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffe7a2b4038 CR3: 0000000120a6f000 CR4: 0000000000750ef0
PKRU: 55555554
Call Trace:
 <TASK>
 queue_delayed_work_on+0xb4/0xc0
 smb2_reconnect+0xb22/0xf50 [cifs]
 smb2_reconnect_server+0x413/0xd40 [cifs]
 ? __pfx_smb2_reconnect_server+0x10/0x10 [cifs]
 ? local_clock_noinstr+0xd/0xd0
 ? local_clock+0x15/0x30
 ? lock_release+0x29b/0x390
 process_one_work+0x4c5/0xa10
 ? __pfx_process_one_work+0x10/0x10
 ? __list_add_valid_or_report+0x37/0x120
 worker_thread+0x2f1/0x5a0
 ? __kthread_parkme+0xde/0x100
 ? __pfx_worker_thread+0x10/0x10
 kthread+0x1fe/0x380
 ? kthread+0x10f/0x380
 ? __pfx_kthread+0x10/0x10
 ? local_clock_noinstr+0xd/0xd0
 ? ret_from_fork+0x1b/0x1f0
 ? local_clock+0x15/0x30
 ? lock_release+0x29b/0x390
 ? rcu_is_watching+0x20/0x50
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x15b/0x1f0
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>
irq event stamp: 1116206
hardirqs last  enabled at (1116205): [<ffffffff8143af42>] __up_console_sem+0x52/0x60
hardirqs last disabled at (1116206): [<ffffffff81399f0e>] queue_delayed_work_on+0x6e/0xc0
softirqs last  enabled at (1116138): [<ffffffffc04562fd>] __smb_send_rqst+0x42d/0x950 [cifs]
softirqs last disabled at (1116136): [<ffffffff823d35e1>] release_sock+0x21/0xf0

Cc: linux-cifs@vger.kernel.org
Reported-by: David Howells <dhowells@redhat.com>
Fixes: 42ca547b13a2 ("cifs: do not disable interface polling on failure")
Reviewed-by: David Howells <dhowells@redhat.com>
Tested-by: David Howells <dhowells@redhat.com>
Reviewed-by: Shyam Prasad N <nspmangalore@gmail.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h |  1 +
 fs/smb/client/smb2pdu.c  | 10 ++++------
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index d776340ad91ce..a6020f7408fe5 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1268,6 +1268,7 @@ struct cifs_tcon {
 	bool use_persistent:1; /* use persistent instead of durable handles */
 	bool no_lease:1;    /* Do not request leases on files or directories */
 	bool use_witness:1; /* use witness protocol */
+	bool dummy:1; /* dummy tcon used for reconnecting channels */
 	__le32 capabilities;
 	__u32 share_flags;
 	__u32 maximal_access;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index e0f5860093305..357abb0170c49 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -437,9 +437,9 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		free_xid(xid);
 		ses->flags &= ~CIFS_SES_FLAGS_PENDING_QUERY_INTERFACES;
 
-		/* regardless of rc value, setup polling */
-		queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
-				   (SMB_INTERFACE_POLL_INTERVAL * HZ));
+		if (!tcon->ipc && !tcon->dummy)
+			queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
+					   (SMB_INTERFACE_POLL_INTERVAL * HZ));
 
 		mutex_unlock(&ses->session_mutex);
 
@@ -4228,10 +4228,8 @@ void smb2_reconnect_server(struct work_struct *work)
 		}
 		goto done;
 	}
-
 	tcon->status = TID_GOOD;
-	tcon->retry = false;
-	tcon->need_reconnect = false;
+	tcon->dummy = true;
 
 	/* now reconnect sessions for necessary channels */
 	list_for_each_entry_safe(ses, ses2, &tmp_ses_list, rlist) {
-- 
2.39.5



