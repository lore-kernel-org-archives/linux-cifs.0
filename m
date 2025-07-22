Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797C52E49AF;
	Tue, 22 Jul 2025 14:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193767; cv=none; b=swRbwkRc6SsGcMHdQVb69QDtAkKC6DnV51et37k3V0AZvAnOK9pHQkLA+CPTKATG0EUsmZaiOqoFJeO6DKY+CnP9zUAah4LuSC4omgKTtV0o3wQauQZ2e/wfU9Vbx7c5VjWe2zISYyud4nVgtFXntgubCkNvpwA4EYcjch0rJtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193767; c=relaxed/simple;
	bh=VjdMyWKi4YtlkqleDLK2l7geJOGJ9cri7ZmYbi1aiSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GxdAQ9GXVh3yxBBB3Fck3SKmHZRs83e3MBbw1qC79uph5ojDMQHLdy3l1nZcwOAvSJqpjXy3o8mkNorO0w1H+V18n0a3CLGOFXfL7G7+vKQmc8By1XAA2nGnWPKx3eKXoaH6xQQkFT6QoPDGJfbaBgWcwIE085qsigBtNezlrjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nbuB7SHq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nbuB7SHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EADC4CEEB;
	Tue, 22 Jul 2025 14:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193767;
	bh=VjdMyWKi4YtlkqleDLK2l7geJOGJ9cri7ZmYbi1aiSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nbuB7SHqL0XYGV45HJb2yFwY03Dx4zFvCQSaiU9acwHdiOrntVfhrZUu3xmvYq1to
	 ZQNOBZdpsq4IbNRGhU4vMmFQyRKR4nSWmXPx4HU8lJex0RX2iQTdlc5uJe/54KSZSa
	 Racy2ObkTvRa+H/e9naiONoDWoS5wl9LkYVhYCIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.15 179/187] smb: smbdirect: introduce smbdirect_socket_parameters
Date: Tue, 22 Jul 2025 15:45:49 +0200
Message-ID: <20250722134352.437429400@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

commit dce8047f4725d4469c0813ff50c4115fc2d0b628 upstream.

This is the next step in the direction of a common smbdirect layer.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smbdirect.h                  |    1 +
 fs/smb/common/smbdirect/smbdirect.h        |   20 ++++++++++++++++++++
 fs/smb/common/smbdirect/smbdirect_socket.h |    2 ++
 3 files changed, 23 insertions(+)

--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -15,6 +15,7 @@
 #include <rdma/rdma_cm.h>
 #include <linux/mempool.h>
 
+#include "../common/smbdirect/smbdirect.h"
 #include "../common/smbdirect/smbdirect_socket.h"
 
 extern int rdma_readwrite_threshold;
--- a/fs/smb/common/smbdirect/smbdirect.h
+++ b/fs/smb/common/smbdirect/smbdirect.h
@@ -14,4 +14,24 @@ struct smbdirect_buffer_descriptor_v1 {
 	__le32 length;
 } __packed;
 
+/*
+ * Connection parameters mostly from [MS-SMBD] 3.1.1.1
+ *
+ * These are setup and negotiated at the beginning of a
+ * connection and remain constant unless explicitly changed.
+ *
+ * Some values are important for the upper layer.
+ */
+struct smbdirect_socket_parameters {
+	__u16 recv_credit_max;
+	__u16 send_credit_target;
+	__u32 max_send_size;
+	__u32 max_fragmented_send_size;
+	__u32 max_recv_size;
+	__u32 max_fragmented_recv_size;
+	__u32 max_read_write_size;
+	__u32 keepalive_interval_msec;
+	__u32 keepalive_timeout_msec;
+} __packed;
+
 #endif /* __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_H__ */
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -36,6 +36,8 @@ struct smbdirect_socket {
 		struct ib_qp *qp;
 		struct ib_device *dev;
 	} ib;
+
+	struct smbdirect_socket_parameters parameters;
 };
 
 #endif /* __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_SOCKET_H__ */


