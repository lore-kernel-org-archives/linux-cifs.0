Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1522EE983;
	Thu,  3 Jul 2025 14:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554260; cv=none; b=jvOfzPl9Uj1wJ9YoydqQ5i/DN+nBB9ZYp7pxI+1NpVf4KISEAv+vYRh0O+eMFYxsUyZGXXP6BC3KsV9Haa0Y9LJCSw9/tMmb2p3AxRLHX7pGD5V1ysL/JcbEvKr86SKwbQJoh4rZtYRfZsMbxpQl01omYgN1TrsFOOi2jGZKBBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554260; c=relaxed/simple;
	bh=9//XgK8MpM24VHUZ0kdQr3e0vMJ+u1SF4ffvTD9tuzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNtSTezzT2xkrSeHEBtLELG5EpZHTQPkndLikSNC+6oKw/rBQkM6FF+ZxMMkS7f+r9JGl2eHfVjX105xG0cnwpJXN/ZlDByA4geLpNd2n1XoIdqRnCidm+SnJOeB5874ahKXztECRQfxiqF7UG9NSAy/s1twdakWf6bybsHbVBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYW6EmTe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYW6EmTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5151C4CEE3;
	Thu,  3 Jul 2025 14:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554259;
	bh=9//XgK8MpM24VHUZ0kdQr3e0vMJ+u1SF4ffvTD9tuzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYW6EmTeDPwD04PERQIvVSsebO4PJgVIEwx7UuTYnIgomCGPpDINeMUsqFJdGUsk1
	 xVqkj9atjRrRtAh3s7US+KRE8+RJ2f0lKxc+93DhetNqeCwexY9f3Ke7w9Ske9v+sL
	 V4XrYcZllC9hWcJvCBtjAHQ+PR8TDhxNiZLhj6hg=
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
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 123/218] smb: smbdirect: introduce smbdirect_socket_parameters
Date: Thu,  3 Jul 2025 16:41:11 +0200
Message-ID: <20250703144001.031907692@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit dce8047f4725d4469c0813ff50c4115fc2d0b628 ]

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
Stable-dep-of: 43e7e284fc77 ("cifs: Fix the smbd_response slab to allow usercopy")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smbdirect.h                  |  1 +
 fs/smb/common/smbdirect/smbdirect.h        | 20 ++++++++++++++++++++
 fs/smb/common/smbdirect/smbdirect_socket.h |  2 ++
 3 files changed, 23 insertions(+)

diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index ffc38a48b6140..4b559a4147af1 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -15,6 +15,7 @@
 #include <rdma/rdma_cm.h>
 #include <linux/mempool.h>
 
+#include "../common/smbdirect/smbdirect.h"
 #include "../common/smbdirect/smbdirect_socket.h"
 
 extern int rdma_readwrite_threshold;
diff --git a/fs/smb/common/smbdirect/smbdirect.h b/fs/smb/common/smbdirect/smbdirect.h
index eedbdf0d04337..b9a385344ff31 100644
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
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 69a55561f91ae..e5b15cc44a7ba 100644
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
-- 
2.39.5



