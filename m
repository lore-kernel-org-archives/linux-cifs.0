From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [Patch v2 02/19] CIFS: SMBD: Add SMBDirect protocol and transport constants
Date: Sun, 20 Aug 2017 12:04:26 -0700
Message-ID: <1503255883-3041-3-git-send-email-longli@exchange.microsoft.com>
References: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1503255883-3041-1-git-send-email-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

To prepare for protocol implementation, add constants and user-configurable values in the protocol.

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/smbdirect.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smbdirect.h | 20 ++++++++++++++
 2 files changed, 98 insertions(+)
 create mode 100644 fs/cifs/smbdirect.c
 create mode 100644 fs/cifs/smbdirect.h

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
new file mode 100644
index 0000000..d785bc1
--- /dev/null
+++ b/fs/cifs/smbdirect.c
@@ -0,0 +1,78 @@
+/*
+ *   Copyright (C) 2017, Microsoft Corporation.
+ *
+ *   Author(s): Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
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
+#include <linux/module.h>
+#include "smbdirect.h"
+#include "cifs_debug.h"
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
+static int receive_credit_max = 255;
+/* The remote peer's credit request of local peer */
+static int send_credit_target = 255;
+/* The maximum single message size can be sent to remote peer */
+static int max_send_size = 1364;
+/*  The maximum fragmented upper-layer payload receive size supported */
+static int max_fragmented_recv_size = 1024 * 1024;
+/*  The maximum single-message size which can be received */
+static int max_receive_size = 8192;
+
+/* The timeout to initiate send of a keepalive message on idle */
+static int keep_alive_interval = 120;
+
+/*
+ * User configurable initial values for RDMA transport
+ * The actual values used may be lower and are limited to hardware capabilities
+ */
+/* Default maximum number of SGEs in a RDMA send/recv */
+static int max_send_sge = SMBDIRECT_MAX_SGE;
+static int max_recv_sge = SMBDIRECT_MAX_SGE;
+/* Default maximum number of SGEs in a RDMA write/read */
+static int max_frmr_depth = 2048;
+
+/* If payload is less than this byte, use RDMA send/recv not read/write */
+static int rdma_readwrite_threshold = 4096;
diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
new file mode 100644
index 0000000..06eeb0b
--- /dev/null
+++ b/fs/cifs/smbdirect.h
@@ -0,0 +1,20 @@
+/*
+ *   Copyright (C) 2017, Microsoft Corporation.
+ *
+ *   Author(s): Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
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
+#define SMBDIRECT_MAX_SGE	16
+#endif
-- 
2.7.4
