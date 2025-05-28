Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660FE279903
	for <linux-cifs@vger.kernel.org>; Wed, 28 May 2025 16:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748448204; cv=none; b=XUizU/+2tnOfJd4so9BXBTf8n8LQ6YRjKs1h+UjX/uyYEwnqCXJccdjXTIcJjI63iGy4An2RexBf9+lWxsqaSbM0KEksZLh4ca0UCI2kCo9ftivRPy9NHXiEpX19DmnyhdoXtOzuO0xraytJyLMr0/R7RTe0hSxVwS0bvJZGSLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748448204; c=relaxed/simple;
	bh=0+PadEdDWHEviF5tW/Rh/vDCnwSaS6CYWqKqMxWTZTQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q8TW15wJNW8CV/JrdUtdf+w0iRZg8rg8s+ZAM/yi8PaCB/I9GFNtlggdf53TMp0MLvG3HOjr5mJNiDqODoh9hiFAJNPuJ7MYRC6zy/+3Aw7vaWb3lh5QMxw/jPYGb1pwhRtG94H1dQrryHOITX697h/VqDj1Qflkao/u9qXehgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=EL5V/+01; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="EL5V/+01"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-Id:Date:Cc:To:From;
	bh=yqWWjNjEpYpvpW8hXOje6nlrrm13I3oF1ciseBbhLF8=; b=EL5V/+01PzzLsb8DWabVOIWdCC
	CrhToi9d2bgnDcnmrel3l7sZNUK5uUV0F6tZ5MZbnRlJfp/Jj6PL42evVGuowxYphvbrJlgBRT2R3
	IxFrRBik08YrZKgSmuedSiF9soUZqixxSuijc44kIpgh5h94mlFWCYEcoMFAhcmIduA3vbp+iiQuK
	SaA5LOxYmOvi2ZfPNmCOwQcPdgaQisN8Y46LY1bJ8YZekvdQts9Eur2+8pAIaJkwDrnJBuj42Q3/2
	NOWAtDEsecHgMhYg2WxrebpMnzTU6dfSd+CsyaBSodoZEOztYpWpwHPmcO+KaAvluUTpofXk09c4p
	LcNBtbfdHvhcTLhxjBgHnwvjYKzhlpEKa7FoXITdqPmJrEtpprZKtfnienlR97WyDr1m+76Dmt4L0
	0GW4eWFEXPcG871LAywM4hqNVXnl4Sx/wB/hPkqhs9CdslypVvAyX5NCDKaCWOZd53Gbx1wKvuBe2
	cBEgE0O4VcT74DcWErgrUmWl;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uKJFO-007hTa-0P;
	Wed, 28 May 2025 16:03:18 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
	samba-technical@lists.samba.org
Subject: [PATCH v2 10/12] smb: smbdirect: introduce smbdirect_socket_parameters
Date: Wed, 28 May 2025 18:01:39 +0200
Message-Id: <63d3c5da0420fe002e738bd40d1ed2f3f7a7b3ad.1748446473.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1748446473.git.metze@samba.org>
References: <cover.1748446473.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 fs/smb/client/smbdirect.h                  |  1 +
 fs/smb/common/smbdirect/smbdirect.h        | 20 ++++++++++++++++++++
 fs/smb/common/smbdirect/smbdirect_socket.h |  2 ++
 3 files changed, 23 insertions(+)

diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 904c4e5b9e5c..3d325d73364a 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -15,6 +15,7 @@
 #include <rdma/rdma_cm.h>
 #include <linux/mempool.h>
 
+#include "../common/smbdirect/smbdirect.h"
 #include "../common/smbdirect/smbdirect_socket.h"
 
 extern int rdma_readwrite_threshold;
diff --git a/fs/smb/common/smbdirect/smbdirect.h b/fs/smb/common/smbdirect/smbdirect.h
index eedbdf0d0433..b9a385344ff3 100644
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
index 69a55561f91a..e5b15cc44a7b 100644
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
2.34.1

