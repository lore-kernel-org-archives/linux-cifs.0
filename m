From: Long Li <longli@linuxonhyperv.com>
Subject: [PATCH 5/7] cifs: smbd: Protect memory registration using RCU
Date: Mon,  7 May 2018 15:20:04 -0700
Message-ID: <20180507222006.20781-5-longli@linuxonhyperv.com>
References: <20180507222006.20781-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180507222006.20781-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Unlike packet I/O sending path, the memory registration is not locked. They
need to be protected when doing transport reconnect or shutdown.

It's not necessary to lock for memory deregistration, since at the time the
transport is already destroyed so it's impossible to pick up the wrong
transport.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smb2pdu.c   | 6 ++++++
 fs/cifs/smbdirect.c | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 8cd164e..09ca098 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2609,10 +2609,13 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 		bool need_invalidate =
 			io_parms->tcon->ses->server->dialect == SMB30_PROT_ID;
 
+		rcu_read_lock();
+		rcu_dereference(server->smbd_conn);
 		rdata->mr = smbd_register_mr(
 				server->smbd_conn, rdata->pages,
 				rdata->nr_pages, rdata->tailsz,
 				true, need_invalidate);
+		rcu_read_unlock();
 		if (!rdata->mr)
 			return -ENOBUFS;
 
@@ -2986,10 +2989,13 @@ smb2_async_writev(struct cifs_writedata *wdata,
 		struct smbd_buffer_descriptor_v1 *v1;
 		bool need_invalidate = server->dialect == SMB30_PROT_ID;
 
+		rcu_read_lock();
+		rcu_dereference(server->smbd_conn);
 		wdata->mr = smbd_register_mr(
 				server->smbd_conn, wdata->pages,
 				wdata->nr_pages, wdata->tailsz,
 				false, need_invalidate);
+		rcu_read_unlock();
 		if (!wdata->mr) {
 			rc = -ENOBUFS;
 			goto async_writev_out;
diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 74620f5..8c46898 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1482,6 +1482,9 @@ void smbd_destroy(struct TCP_Server_Info *server)
 
 	info->transport_status = SMBD_DESTROYED;
 
+	rcu_assign_pointer(server->smbd_conn, NULL);
+	synchronize_rcu();
+
 	destroy_workqueue(info->workqueue);
 	kfree(info);
 }
-- 
2.7.4
