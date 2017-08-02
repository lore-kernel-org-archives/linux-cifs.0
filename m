From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 04/37] [CIFS] SMBD: Define per-channel SMBD transport parameters and default values
Date: Wed,  2 Aug 2017 13:10:15 -0700
Message-ID: <1501704648-20159-5-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

For each channel, SMBD defines per-channel parameters. Those can be negotiated with the server, and are restricted by RDMA hardware limitations.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsrdma.c | 14 ++++++++++++++
 fs/cifs/cifsrdma.h | 13 +++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
index 3c9f478..7c4c178 100644
--- a/fs/cifs/cifsrdma.c
+++ b/fs/cifs/cifsrdma.c
@@ -54,6 +54,20 @@
 
 #include "cifsrdma.h"
 
+/*
+ * Per RDMA transport connection parameters
+ * as defined in [MS-SMBD] 3.1.1.1
+ */
+static int receive_credit_max = 512;
+static int send_credit_target = 512;
+static int max_send_size = 8192;
+static int max_fragmented_recv_size = 1024*1024;
+static int max_receive_size = 8192;
+
+// maximum number of SGEs in a RDMA I/O
+static int max_send_sge = 16;
+static int max_recv_sge = 16;
+
 /* Logging functions
  * Logging are defined as classes. They can be ORed to define the actual
  * logging level via module parameter rdma_logging_class
diff --git a/fs/cifs/cifsrdma.h b/fs/cifs/cifsrdma.h
index ec6aa61..9979fd4 100644
--- a/fs/cifs/cifsrdma.h
+++ b/fs/cifs/cifsrdma.h
@@ -36,6 +36,19 @@
 struct cifs_rdma_info {
 	struct TCP_Server_Info *server_info;
 
+	//connection paramters
+	int receive_credit_max;
+	int send_credit_target;
+	int max_send_size;
+	int max_fragmented_recv_size;
+	int max_fragmented_send_size;
+	int max_receive_size;
+	int max_readwrite_size;
+	int protocol;
+	atomic_t send_credits;
+	atomic_t receive_credits;
+	atomic_t receive_credit_target;
+
 	// for debug purposes
 	unsigned int count_receive_buffer;
 	unsigned int count_get_receive_buffer;
-- 
2.7.4
