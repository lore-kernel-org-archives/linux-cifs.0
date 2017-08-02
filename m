From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 02/37] [CIFS] SMBD: Add structure for SMBD transport
Date: Wed,  2 Aug 2017 13:10:13 -0700
Message-ID: <1501704648-20159-3-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Define a new structure for SMBD transport. This stucture will have all the
information on the transport, and it will be stored in the current SMB session.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsrdma.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsrdma.h | 45 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 101 insertions(+)
 create mode 100644 fs/cifs/cifsrdma.c
 create mode 100644 fs/cifs/cifsrdma.h

diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
new file mode 100644
index 0000000..a2c0478
--- /dev/null
+++ b/fs/cifs/cifsrdma.c
@@ -0,0 +1,56 @@
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
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program;  if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#include <linux/fs.h>
+#include <linux/net.h>
+#include <linux/string.h>
+#include <linux/list.h>
+#include <linux/wait.h>
+#include <linux/slab.h>
+#include <linux/pagemap.h>
+#include <linux/ctype.h>
+#include <linux/utsname.h>
+#include <linux/mempool.h>
+#include <linux/delay.h>
+#include <linux/completion.h>
+#include <linux/kthread.h>
+#include <linux/pagevec.h>
+#include <linux/freezer.h>
+#include <linux/namei.h>
+#include <asm/uaccess.h>
+#include <asm/processor.h>
+#include <linux/inet.h>
+#include <linux/module.h>
+#include <keys/user-type.h>
+#include <net/ipv6.h>
+#include <linux/parser.h>
+
+#include "cifspdu.h"
+#include "cifsglob.h"
+#include "cifsproto.h"
+#include "cifs_unicode.h"
+#include "cifs_debug.h"
+#include "cifs_fs_sb.h"
+#include "ntlmssp.h"
+#include "nterr.h"
+#include "rfc1002pdu.h"
+#include "fscache.h"
+
+#include "cifsrdma.h"
+
diff --git a/fs/cifs/cifsrdma.h b/fs/cifs/cifsrdma.h
new file mode 100644
index 0000000..ec6aa61
--- /dev/null
+++ b/fs/cifs/cifsrdma.h
@@ -0,0 +1,45 @@
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
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program;  if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef _CIFS_RDMA_H
+#define _CIFS_RDMA_H
+
+#include "cifsglob.h"
+#include <rdma/ib_verbs.h>
+#include <rdma/rdma_cm.h>
+#include <linux/mempool.h>
+
+/*
+ * The context for the SMBDirect transport
+ * Everything related to the transport is here. It has several logical parts
+ * 1. RDMA related structures
+ * 2. SMBDirect connection parameters
+ * 3. Reassembly queue for data receive path
+ * 4. mempools for allocating packets
+ */
+struct cifs_rdma_info {
+	struct TCP_Server_Info *server_info;
+
+	// for debug purposes
+	unsigned int count_receive_buffer;
+	unsigned int count_get_receive_buffer;
+	unsigned int count_put_receive_buffer;
+	unsigned int count_send_empty;
+};
+#endif
-- 
2.7.4
