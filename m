From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 03/37] [CIFS] SMBD: Add logging functions for debug
Date: Wed,  2 Aug 2017 13:10:14 -0700
Message-ID: <1501704648-20159-4-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

SMBD transport code will use those logging functions for debug.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsrdma.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
index a2c0478..3c9f478 100644
--- a/fs/cifs/cifsrdma.c
+++ b/fs/cifs/cifsrdma.c
@@ -54,3 +54,55 @@
 
 #include "cifsrdma.h"
 
+/* Logging functions
+ * Logging are defined as classes. They can be ORed to define the actual
+ * logging level via module parameter rdma_logging_class
+ * e.g. cifs.rdma_logging_class=0x500 will log all log_rdma_recv() and
+ * log_rdma_event()
+ */
+#define LOG_CREDIT			0x1
+#define LOG_OUTGOING			0x2
+#define LOG_INCOMING			0x4
+#define LOG_RECEIVE_QUEUE		0x8
+#define LOG_REASSEMBLY_QUEUE		0x10
+#define LOG_CIFS_READ			0x20
+#define LOG_CIFS_WRITE			0x40
+#define LOG_RDMA_SEND			0x80
+#define LOG_RDMA_RECV			0x100
+#define LOG_KEEP_ALIVE			0x200
+#define LOG_RDMA_EVENT			0x400
+
+static unsigned int rdma_logging_class = 0;
+module_param(rdma_logging_class, uint, 0644);
+MODULE_PARM_DESC(rdma_logging_class,
+	"Logging class for SMBD transport 0 to 512");
+
+#define log_rdma(class, fmt, args...)					\
+do {									\
+	if (class & rdma_logging_class)					\
+		cifs_dbg(VFS, "%s:%d " fmt, __func__, __LINE__, ##args);\
+} while (0)
+
+#define log_rdma_credit(fmt, args...)	log_rdma(LOG_CREDIT, fmt, ##args)
+#define log_outgoing(fmt, args...)	log_rdma(LOG_OUTGOING, fmt, ##args)
+#define log_incoming(fmt, args...)	log_rdma(LOG_INCOMING, fmt, ##args)
+#define log_receive_queue(fmt, args...)		\
+	log_rdma(LOG_RECEIVE_QUEUE, fmt, ##args)
+#define log_reassembly_queue(fmt, args...) 	\
+		log_rdma(LOG_REASSEMBLY_QUEUE, fmt, ##args)
+#define log_cifs_read(fmt, args...)	log_rdma(LOG_CIFS_READ, fmt, ##args)
+#define log_cifs_write(fmt, args...)	log_rdma(LOG_CIFS_WRITE, fmt, ##args)
+#define log_rdma_send(fmt, args...)	log_rdma(LOG_RDMA_SEND, fmt, ##args)
+#define log_rdma_recv(fmt, args...)	log_rdma(LOG_RDMA_RECV, fmt, ##args)
+#define log_keep_alive(fmt, args...)	log_rdma(LOG_KEEP_ALIVE, fmt, ##args)
+#define log_rdma_event(fmt, args...)	log_rdma(LOG_RDMA_EVENT, fmt, ##args)
+
+#define log_transport_credit(info)					\
+do {									\
+	log_rdma_credit("receive_credits %d receive_credit_target %d "	\
+			"send_credits %d send_credit_target %d\n",	\
+			atomic_read(&info->receive_credits),		\
+			atomic_read(&info->receive_credit_target),	\
+			atomic_read(&info->send_credits),		\
+			info->send_credit_target);			\
+} while (0)
-- 
2.7.4
