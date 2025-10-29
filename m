Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381982D3A7C
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744421; cv=none; b=jabuzGTFNbk52Z3olgfyj8iA/BqbYckEKqoSIRI0K3Un3DHqkVfdFIrKdfhxJcbmZYVWf26Y3pHaQfXDO0CRF6UBlItX4O0pohfYDtROP+ZNM2baZOHtj0QD5PtJJbm89WhHDw9kjgylywhcba8gPtXtSaTZVYtoJx2v+iznGyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744421; c=relaxed/simple;
	bh=aneteDSdLqytLUDFvmPGoSrkD9FBwxaZ9fuphFofLEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XOhRrV6n5VmvYOcFt4i0tESdcv+iUqzBfpeMZ/6fhutlA0ogfUCP9+YWd82aOe48V+c+lJiaiTAJCxEWSwBBJWcg54oKx+Zpqj0o1BRDPGg+5+Cxalk2xs/SUZJt8aFe9oog7MN4lkcumk1P5Yd0gX7UAuL2+5a3sy3y1gIoL94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=pKhIKwL+; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="pKhIKwL+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=hRYXXsfYRBm58Z/tIXuBn5njWQmh7TMxzV89EXsfNY0=; b=pKhIKwL+JFvH1fQYPMFDnfwICQ
	gyKylyWsVpcJbuwZcH81RpG3u3pFrEkiaoINcGgr9ynO8inOVMi00M9l7TcIatum2Zj0mbyl4wFBG
	mXmZoMo5SHRqjyk5yMO3vKOwo1M/IKXyluzVQEH6utPoIwtCywdUpj9Jb4V4Eb3Gy1qgCuzccqwJh
	MT3e7SWJGtxhUvmQQ13ckABbF4Ph7g2qihzw71/AnG7Rj5iqumYLP0AOq6m0fa4M5lCAagi5hzIGd
	e+fmBZYM52ER+NorB+/IcEbOjQx+4LaNDQQ2dMrXH8KYV3X9bIyCu+lPp0RClNLdygo9+uWjNgZCf
	UKH2a653yrG4htGaoB348m8uKwAa4II9ZA0HR/RXu2gsxWjsoy+e7KrfaI9o311a3SSAEJYt/KNE0
	LSnkw3licWBDXGai4RZ1LR9O1jQQEpZVuA6/yqCo/Tv9Ou+7dT/4me98tH6JQ3jkJmE4pvH1vRuLJ
	yjUgDbLT5IU1lPuNMLYoWki1;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6CX-00Bbra-1B;
	Wed, 29 Oct 2025 13:26:57 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 045/127] smb: smbdirect: introduce smbdirect_connection_legacy_debug_proc_show()
Date: Wed, 29 Oct 2025 14:20:23 +0100
Message-ID: <f78641ce170958aa001d1b0a0bcd494e38e02218.1761742839.git.metze@samba.org>
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
---
 .../common/smbdirect/smbdirect_all_c_files.c  |  1 +
 fs/smb/common/smbdirect/smbdirect_debug.c     | 88 +++++++++++++++++++
 2 files changed, 89 insertions(+)
 create mode 100644 fs/smb/common/smbdirect/smbdirect_debug.c

diff --git a/fs/smb/common/smbdirect/smbdirect_all_c_files.c b/fs/smb/common/smbdirect/smbdirect_all_c_files.c
index 3423330465ae..6d4cd41ebe10 100644
--- a/fs/smb/common/smbdirect/smbdirect_all_c_files.c
+++ b/fs/smb/common/smbdirect/smbdirect_all_c_files.c
@@ -18,3 +18,4 @@
 #include "smbdirect_connection.c"
 #include "smbdirect_mr.c"
 #include "smbdirect_rw.c"
+#include "smbdirect_debug.c"
diff --git a/fs/smb/common/smbdirect/smbdirect_debug.c b/fs/smb/common/smbdirect/smbdirect_debug.c
new file mode 100644
index 000000000000..e7258e0d28a6
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
+__maybe_unused /* this is temporary while this file is included in orders */
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

