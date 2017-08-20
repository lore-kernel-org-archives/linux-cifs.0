From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v2 19/19] CIFS: SMBD: Add SMBDirect debug counters
Date: Sun, 20 Aug 2017 12:04:43 -0700
Message-ID: <1503255883-3041-20-git-send-email-longli@exchange.microsoft.com>
References: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Export SMBDirect debug counters to /proc/fs/cifs/DebugData, for debugging and troubleshooting.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifs_debug.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index ba0870d..ca73950 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -30,6 +30,7 @@
 #include "cifsproto.h"
 #include "cifs_debug.h"
 #include "cifsfs.h"
+#include "smbdirect.h"
 
 void
 cifs_dump_mem(char *label, void *data, int length)
@@ -152,6 +153,51 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 	list_for_each(tmp1, &cifs_tcp_ses_list) {
 		server = list_entry(tmp1, struct TCP_Server_Info,
 				    tcp_ses_list);
+
+		if (!server->rdma)
+			goto skip_rdma;
+
+		seq_printf(m, "\nSMBDirect transport status (all numbers in hex) protocol version: %x",
+			server->smbd_conn->protocol);
+		seq_printf(m, "\nConn receive_credit_max: %x send_credit_target: %x max_send_size: %x",
+			server->smbd_conn->receive_credit_max,
+			server->smbd_conn->send_credit_target,
+			server->smbd_conn->max_send_size);
+		seq_printf(m, "\nConn max_fragmented_recv_size: %x max_fragmented_send_size: %x max_receive_size:%x",
+			server->smbd_conn->max_fragmented_recv_size,
+			server->smbd_conn->max_fragmented_send_size,
+			server->smbd_conn->max_receive_size);
+		seq_printf(m, "\nConn keep_alive_interval: %x max_readwrite_size: %x rdma_readwrite_threshold: %x",
+			server->smbd_conn->keep_alive_interval,
+			server->smbd_conn->max_readwrite_size,
+			server->smbd_conn->rdma_readwrite_threshold);
+		seq_printf(m, "\nDebug count_receive_buffer: %x count_get_receive_buffer: %x count_put_receive_buffer: %x count_send_empty: %x",
+			server->smbd_conn->count_receive_buffer,
+			server->smbd_conn->count_get_receive_buffer,
+			server->smbd_conn->count_put_receive_buffer,
+			server->smbd_conn->count_send_empty);
+		seq_printf(m, "\nRead Queue count_reassembly_queue: %x count_enqueue_reassembly_queue: %x count_dequeue_reassembly_queue: %x fragment_reassembly_remaining: %x",
+			server->smbd_conn->count_reassembly_queue,
+			server->smbd_conn->count_enqueue_reassembly_queue,
+			server->smbd_conn->count_dequeue_reassembly_queue,
+			server->smbd_conn->fragment_reassembly_remaining);
+		seq_printf(m, "\nCurrent Credits send_credits: %x receive_credits: %x receive_credit_target: %x",
+			atomic_read(&server->smbd_conn->send_credits),
+			atomic_read(&server->smbd_conn->receive_credits),
+			server->smbd_conn->receive_credit_target);
+		seq_printf(m, "\nPending send_pending: %x send_payload_pending: %x recv_pending: %x read_pending: %x",
+			atomic_read(&server->smbd_conn->send_pending),
+			atomic_read(&server->smbd_conn->send_payload_pending),
+			atomic_read(&server->smbd_conn->recv_pending),
+			atomic_read(&server->smbd_conn->read_pending));
+		seq_printf(m, "\nMR responder_resources: %x max_frmr_depth: %x mr_type: %x",
+			server->smbd_conn->responder_resources,
+			server->smbd_conn->max_frmr_depth,
+			server->smbd_conn->mr_type);
+		seq_printf(m, "\nMR mr_ready_count: %x",
+			atomic_read(&server->smbd_conn->mr_ready_count));
+
+skip_rdma:
 		seq_printf(m, "\nNumber of credits: %d", server->credits);
 		i++;
 		list_for_each(tmp2, &server->smb_ses_list) {
-- 
2.7.4
