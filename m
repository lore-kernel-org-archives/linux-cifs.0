Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831072C08DC
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744697; cv=none; b=EYhiTMsEGMs80bT48KkaPg3d4Qa+4qkvo2cy3/8Cl8N1mvO356/IvDhod3CLuFoXPjD76v8Mc07VBQmfn0/FqDEA+LzYStG+P+jVpZG8d73MzgyTe2A51LEDnaCvrJEfIsxUxLG/t/jU1HNzRmxPlXfnACECHarTV57u5v+zLiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744697; c=relaxed/simple;
	bh=PIZNbKBAIReUswetk7WgvNgrtTT+wMRWru+eFUYzzhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RjRNQtZtZshukc+yiK3Bp3+z46Xi/6NY9K3lt4ok0vb196JHefClyPXcpVvlq5aorXpBEoz21oV2BTb3vo34u8UKw3bqgQDAceZ8buprRJ+kV/yxHNJMzeq11KrhK6I0X5dsYaQ6csoKIA2RCpfvi9mBpZU8V3zLU2exJZiS+P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=1Z1Ptk60; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="1Z1Ptk60"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=iPX5uioKLEwRQqQaSXOyDFC7WQgJHZQuFLiQm1pn1X0=; b=1Z1Ptk60LXlnta2t9xVhUOwy7s
	xDEJEneqk7oiknDPibME6o+ooKKLFbJE69lG6d75IgD3TLKMe80a2UoygWCp1P2PZzLBGOjv8ABki
	X6AP5Kj/RYsS0GnklO03kEv486pwmTUaJXqdTVxB1i3YBK4bHSFnJ5oeJ3ClXJVrkRLtH09QfcaIX
	KYxLaW0v6g1NRV2aUhg+4A18ScZAwr94Q1o0hVDF8DPBcX0IHhngad7DhH9DtOOvgGNVgwaMp7HjN
	G1xOMd0cq77uWKlpRQXJ5pA+rv8QsQv1TVJ49ysc3JErF1aflXuHrmuB+4u2RIRLhhFG0MIV9w8Nd
	ECb6T2wVZ/s7TwVOr33T7NXr6+p52QjiUfphDTJe847KkmTytYveY/XD0xYfiH4B0ZA1SyB/T3U4H
	i9x2gnwDbPTJF+isyvRhDPCmd0HPBRc0GQKgajtmV4hkcjYgPpCLjjfCHMcO2bLvxZaygWTfaP7KH
	GAGahq1wgr4iwZ8GbJr0PM59;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Gz-00Bcal-00;
	Wed, 29 Oct 2025 13:31:33 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 090/127] smb: client: only use public smbdirect functions
Date: Wed, 29 Oct 2025 14:21:08 +0100
Message-ID: <9f73b3b32ad5b31ffadbc4cbee1f9dae16b17dfc.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Also remove a lot of unused includes...

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smb2pdu.c   |  1 -
 fs/smb/client/smbdirect.c | 20 +++++++++-----------
 fs/smb/client/smbdirect.h | 13 -------------
 3 files changed, 9 insertions(+), 25 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index a9a04c4db6dc..40c918e7ee7d 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -36,7 +36,6 @@
 #include "smb2glob.h"
 #include "cifspdu.h"
 #include "cifs_spnego.h"
-#include "../common/smbdirect/smbdirect.h"
 #include "smbdirect.h"
 #include "trace.h"
 #ifdef CONFIG_CIFS_DFS_UPCALL
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 1efbc15879f4..91ed47ff8f2b 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -7,14 +7,12 @@
 
 #define SMBDIRECT_USE_INLINE_C_FILES 1
 
-#include <linux/module.h>
-#include <linux/highmem.h>
-#include <linux/folio_queue.h>
 #include <linux/errname.h>
 #include "smbdirect.h"
 #include "cifs_debug.h"
 #include "cifsproto.h"
 #include "smb2proto.h"
+#include "../common/smbdirect/smbdirect_public.h"
 
 /* Port numbers for SMBD transport */
 #define SMB_PORT	445
@@ -95,14 +93,6 @@ module_param(smbd_logging_level, uint, 0644);
 MODULE_PARM_DESC(smbd_logging_level,
 	"Logging level for SMBD transport, 0 (default): error, 1: info");
 
-/*
- * This is a temporary solution until all code
- * is moved to smbdirect_all_c_files.c and we
- * have an smbdirect.ko that exports the required
- * functions.
- */
-#include "../common/smbdirect/smbdirect_all_c_files.c"
-
 static bool smbd_logging_needed(struct smbdirect_socket *sc,
 				void *private_ptr,
 				unsigned int lvl,
@@ -537,3 +527,11 @@ void smbd_debug_proc_show(struct TCP_Server_Info *server, struct seq_file *m)
 						    server->rdma_readwrite_threshold,
 						    m);
 }
+
+/*
+ * This is a temporary solution until all code
+ * is moved to smbdirect_all_c_files.c and we
+ * have an smbdirect.ko that exports the required
+ * functions.
+ */
+#include "../common/smbdirect/smbdirect_all_c_files.c"
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 35172076f2ee..bd03ae72e9c8 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -11,12 +11,8 @@
 #define cifs_rdma_enabled(server)	((server)->rdma)
 
 #include "cifsglob.h"
-#include <rdma/ib_verbs.h>
-#include <rdma/rdma_cm.h>
-#include <linux/mempool.h>
 
 #include "../common/smbdirect/smbdirect.h"
-#include "../common/smbdirect/smbdirect_socket.h"
 
 extern int rdma_readwrite_threshold;
 extern int smbd_max_frmr_depth;
@@ -27,15 +23,6 @@ extern int smbd_max_send_size;
 extern int smbd_send_credit_target;
 extern int smbd_receive_credit_max;
 
-/*
- * The context for the SMBDirect transport
- * Everything related to the transport is here. It has several logical parts
- * 1. RDMA related structures
- * 2. SMBDirect connection parameters
- * 3. Memory registrations
- * 4. Receive and reassembly queues for data receive path
- * 5. mempools for allocating packets
- */
 struct smbd_connection {
 	struct smbdirect_socket *socket;
 	struct workqueue_struct *workqueue;
-- 
2.43.0

