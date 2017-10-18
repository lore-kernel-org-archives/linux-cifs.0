From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v5 01/21] CIFS: SMBD: Add SMB Direct protocol initial values and constants
Date: Wed, 18 Oct 2017 16:09:00 -0700
Message-ID: <20171018230920.21042-2-longli@exchange.microsoft.com>
References: <20171018230920.21042-1-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171018230920.21042-1-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

To prepare for protocol implementation, add constants and user-configurable
values for the SMB Direct protocol.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smbdirect.c | 77 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smbdirect.h | 21 +++++++++++++++
 2 files changed, 98 insertions(+)
 create mode 100644 fs/cifs/smbdirect.c
 create mode 100644 fs/cifs/smbdirect.h

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
new file mode 100644
index 0000000..d3c16f8
--- /dev/null
+++ b/fs/cifs/smbdirect.c
@@ -0,0 +1,77 @@
+/*
+ *   Copyright (C) 2017, Microsoft Corporation.
+ *
+ *   Author(s): Long Li <longli@microsoft.com>
+ *
+ *   This program is free software;  you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU General Public License for more details.
+ */
+#include "smbdirect.h"
+
+/* SMBD version number */
+#define SMBD_V1	0x0100
+
+/* Port numbers for SMBD transport */
+#define SMB_PORT	445
+#define SMBD_PORT	5445
+
+/* Address lookup and resolve timeout in ms */
+#define RDMA_RESOLVE_TIMEOUT	5000
+
+/* SMBD negotiation timeout in seconds */
+#define SMBD_NEGOTIATE_TIMEOUT	120
+
+/* SMBD minimum receive size and fragmented sized defined in [MS-SMBD] */
+#define SMBD_MIN_RECEIVE_SIZE		128
+#define SMBD_MIN_FRAGMENTED_SIZE	131072
+
+/*
+ * Default maximum number of RDMA read/write outstanding on this connection
+ * This value is possibly decreased during QP creation on hardware limit
+ */
+#define SMBD_CM_RESPONDER_RESOURCES	32
+
+/* Maximum number of retries on data transfer operations */
+#define SMBD_CM_RETRY			6
+/* No need to retry on Receiver Not Ready since SMBD manages credits */
+#define SMBD_CM_RNR_RETRY		0
+
+/*
+ * User configurable initial values per SMBD transport connection
+ * as defined in [MS-SMBD] 3.1.1.1
+ * Those may change after a SMBD negotiation
+ */
+/* The local peer's maximum number of credits to grant to the peer */
+int smbd_receive_credit_max = 255;
+
+/* The remote peer's credit request of local peer */
+int smbd_send_credit_target = 255;
+
+/* The maximum single message size can be sent to remote peer */
+int smbd_max_send_size = 1364;
+
+/*  The maximum fragmented upper-layer payload receive size supported */
+int smbd_max_fragmented_recv_size = 1024 * 1024;
+
+/*  The maximum single-message size which can be received */
+int smbd_max_receive_size = 8192;
+
+/* The timeout to initiate send of a keepalive message on idle */
+int smbd_keep_alive_interval = 120;
+
+/*
+ * User configurable initial values for RDMA transport
+ * The actual values used may be lower and are limited to hardware capabilities
+ */
+/* Default maximum number of SGEs in a RDMA write/read */
+int smbd_max_frmr_depth = 2048;
+
+/* If payload is less than this byte, use RDMA send/recv not read/write */
+int rdma_readwrite_threshold = 4096;
diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
new file mode 100644
index 0000000..c55f28b
--- /dev/null
+++ b/fs/cifs/smbdirect.h
@@ -0,0 +1,21 @@
+/*
+ *   Copyright (C) 2017, Microsoft Corporation.
+ *
+ *   Author(s): Long Li <longli@microsoft.com>
+ *
+ *   This program is free software;  you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU General Public License for more details.
+ */
+#ifndef _SMBDIRECT_H
+#define _SMBDIRECT_H
+
+/* Default maximum number of SGEs in a RDMA send/recv */
+#define SMBDIRECT_MAX_SGE	16
+#endif
-- 
2.7.4
