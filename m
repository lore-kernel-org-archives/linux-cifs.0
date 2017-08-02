From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 32/37] [CIFS] Add SMBD debug couters to CIFS debug exports
Date: Wed,  2 Aug 2017 13:10:43 -0700
Message-ID: <1501704648-20159-33-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

SMBD tranport defines several debug counters. Add them to common CIFS to export those under /proc.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifs_debug.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index ba0870d..aed17ee 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -30,6 +30,7 @@
 #include "cifsproto.h"
 #include "cifs_debug.h"
 #include "cifsfs.h"
+#include "cifsrdma.h"
 
 void
 cifs_dump_mem(char *label, void *data, int length)
@@ -152,6 +153,28 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 	list_for_each(tmp1, &cifs_tcp_ses_list) {
 		server = list_entry(tmp1, struct TCP_Server_Info,
 				    tcp_ses_list);
+
+               if (!server->rdma_ses)
+                       goto skip_rdma;
+
+                //RDMA counters
+                seq_printf(m, "\nrdma receive buffer: count, get, put send_empty: %u %u %u %u",
+                        server->rdma_ses->count_receive_buffer,
+                        server->rdma_ses->count_get_receive_buffer,
+                        server->rdma_ses->count_put_receive_buffer,
+                        server->rdma_ses->count_send_empty);
+
+                seq_printf(m, "\nrdma reassembly queue: count, enqueue, dequeue: %u %u %u",
+                        server->rdma_ses->count_reassembly_queue,
+                        server->rdma_ses->count_enqueue_reassembly_queue,
+                        server->rdma_ses->count_dequeue_reassembly_queue);
+
+                seq_printf(m, "\nrdma credits: send receive receive_target: %u %u %u",
+                        atomic_read(&server->rdma_ses->send_credits),
+                        atomic_read(&server->rdma_ses->receive_credits),
+                        atomic_read(&server->rdma_ses->receive_credit_target));
+
+skip_rdma:
 		seq_printf(m, "\nNumber of credits: %d", server->credits);
 		i++;
 		list_for_each(tmp2, &server->smb_ses_list) {
-- 
2.7.4
