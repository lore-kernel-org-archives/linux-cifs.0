Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950521E991B
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093707; cv=none; b=lZoeJPavJBUsb4wmW+HmqsTyAKghk9mFWW/clw5gBNvOo5sbCHyJnWd7jMLEERFSTOVcaazgAFF04VK3mCtqih2mqPz54NwYFL8/bfRkcL1+knlPrYnvamiMFC0UiaoI4IfLgHIwPUFt408EJLDADR7qYt1uggJZhA+D9wwgFlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093707; c=relaxed/simple;
	bh=gunagSxwyhQpg/ar4V2BpzYs3o5HR4yna5jAXc6gpuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EeIOkpchR2hRuPz7N7heXWOJ41Zk0hGyMivUaxV4+/EVRLMJ29LvlhQnNAzt0WiNbKIkOLS7uoBO9EGwkbhnKLlkrbSBkDtpniGEyvTGlIA0biN+NRjSUKm1vkPYwAadGmIjC//mN0vaNv4DaDUgPJKqq9my0ZgR5whVM1oGDFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=MKAKf6A5; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="MKAKf6A5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=A3yHeMH8W+n2/0ZF51SjulsInAIehuLDHBydqU419e0=; b=MKAKf6A5bBapsvsFe2ghLcBUcG
	nU07SEHN0dXQ+fxWu3hqkAe/OYKk6+Uoh+p+vgCRSQPgMTZGmhqEfR972xlthKUx97r3+a2ts1Rr/
	34w0/kUZ95VU5JToM5DsMYPqK+LNWnPYjGcKeauqSFU3/YDdt1I856QyE5iggYEGAWfJMAiNGqPWB
	54EOcr4o3p6c7e6kFVeBpCQlrE9aa88P5bLuGTeP2JqTCQqsJqIedMizVuNYM1b6hZnyBgvxDPufT
	pBPphqUioiQ9xSdKc6qNc8B5ovtv4u0uJFK5hcTSQ3yX5+as3+HanjlsaQQtnYy0H81c4g5EWMW3Q
	8iakMD5PEWQKIR2ZOEVH426SChSk1Ju5xSMzs46AFMDV93aSCHl/PIGCXt/rlo71/WIcWyhG3VRfr
	zsdQDAu7YEzfTGdfQ/pmE6HHxAQBG7UY+rPE+KzbTqtg7Yo6IfYWRBQzHn8e00gDYCMmddl1lyIuU
	DwMAzlM98YkSEfiDeD1IPKhX;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxME-00FdGd-16;
	Tue, 25 Nov 2025 18:01:42 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 048/145] smb: smbdirect: introduce smbdirect_connection_legacy_debug_proc_show()
Date: Tue, 25 Nov 2025 18:54:54 +0100
Message-ID: <2240497ba94c9c199ed2ace63d8f18df34c3879f.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will be used by the client in order to keep the debug output
in the current way without the need to access struct smbdirect_socket
internals.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_all_c_files.c  |  1 +
 fs/smb/common/smbdirect/smbdirect_debug.c     | 88 +++++++++++++++++++
 2 files changed, 89 insertions(+)
 create mode 100644 fs/smb/common/smbdirect/smbdirect_debug.c

diff --git a/fs/smb/common/smbdirect/smbdirect_all_c_files.c b/fs/smb/common/smbdirect/smbdirect_all_c_files.c
index 963a1fc3b54b..51b2bcda5596 100644
--- a/fs/smb/common/smbdirect/smbdirect_all_c_files.c
+++ b/fs/smb/common/smbdirect/smbdirect_all_c_files.c
@@ -19,3 +19,4 @@
 #include "smbdirect_connection.c"
 #include "smbdirect_mr.c"
 #include "smbdirect_rw.c"
+#include "smbdirect_debug.c"
diff --git a/fs/smb/common/smbdirect/smbdirect_debug.c b/fs/smb/common/smbdirect/smbdirect_debug.c
new file mode 100644
index 000000000000..20b87d8aa6d1
--- /dev/null
+++ b/fs/smb/common/smbdirect/smbdirect_debug.c
@@ -0,0 +1,88 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *   Copyright (C) 2017, Microsoft Corporation.
+ *   Copyright (c) 2025, Stefan Metzmacher
+ */
+
+#include "smbdirect_internal.h"
+#include <linux/seq_file.h>
+
+__maybe_unused /* this is temporary while this file is included in others */
+static void smbdirect_connection_legacy_debug_proc_show(struct smbdirect_socket *sc,
+							unsigned int rdma_readwrite_threshold,
+							struct seq_file *m)
+{
+	const struct smbdirect_socket_parameters *sp;
+
+	if (!sc)
+		return;
+	sp = &sc->parameters;
+
+	seq_puts(m, "\n");
+	seq_printf(m, "SMBDirect protocol version: 0x%x ",
+		   SMBDIRECT_V1);
+	seq_printf(m, "transport status: %s (%u)",
+		   smbdirect_socket_status_string(sc->status),
+		   sc->status);
+
+	seq_puts(m, "\n");
+	seq_printf(m, "Conn receive_credit_max: %u ",
+		   sp->recv_credit_max);
+	seq_printf(m, "send_credit_target: %u max_send_size: %u",
+		   sp->send_credit_target,
+		   sp->max_send_size);
+
+	seq_puts(m, "\n");
+	seq_printf(m, "Conn max_fragmented_recv_size: %u ",
+		   sp->max_fragmented_recv_size);
+	seq_printf(m, "max_fragmented_send_size: %u max_receive_size:%u",
+		   sp->max_fragmented_send_size,
+		   sp->max_recv_size);
+
+	seq_puts(m, "\n");
+	seq_printf(m, "Conn keep_alive_interval: %u ",
+		   sp->keepalive_interval_msec * 1000);
+	seq_printf(m, "max_readwrite_size: %u rdma_readwrite_threshold: %u",
+		   sp->max_read_write_size,
+		   rdma_readwrite_threshold);
+
+	seq_puts(m, "\n");
+	seq_printf(m, "Debug count_get_receive_buffer: %llu ",
+		   sc->statistics.get_receive_buffer);
+	seq_printf(m, "count_put_receive_buffer: %llu count_send_empty: %llu",
+		   sc->statistics.put_receive_buffer,
+		   sc->statistics.send_empty);
+
+	seq_puts(m, "\n");
+	seq_printf(m, "Read Queue count_enqueue_reassembly_queue: %llu ",
+		   sc->statistics.enqueue_reassembly_queue);
+	seq_printf(m, "count_dequeue_reassembly_queue: %llu ",
+		   sc->statistics.dequeue_reassembly_queue);
+	seq_printf(m, "reassembly_data_length: %u ",
+		   sc->recv_io.reassembly.data_length);
+	seq_printf(m, "reassembly_queue_length: %u",
+		   sc->recv_io.reassembly.queue_length);
+
+	seq_puts(m, "\n");
+	seq_printf(m, "Current Credits send_credits: %u ",
+		   atomic_read(&sc->send_io.credits.count));
+	seq_printf(m, "receive_credits: %u receive_credit_target: %u",
+		   atomic_read(&sc->recv_io.credits.count),
+		   sc->recv_io.credits.target);
+
+	seq_puts(m, "\n");
+	seq_printf(m, "Pending send_pending: %u ",
+		   atomic_read(&sc->send_io.pending.count));
+
+	seq_puts(m, "\n");
+	seq_printf(m, "MR responder_resources: %u ",
+		   sp->responder_resources);
+	seq_printf(m, "max_frmr_depth: %u mr_type: 0x%x",
+		   sp->max_frmr_depth,
+		   sc->mr_io.type);
+
+	seq_puts(m, "\n");
+	seq_printf(m, "MR mr_ready_count: %u mr_used_count: %u",
+		   atomic_read(&sc->mr_io.ready.count),
+		   atomic_read(&sc->mr_io.used.count));
+}
-- 
2.43.0

