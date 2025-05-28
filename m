Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD01D288C9B
	for <linux-cifs@vger.kernel.org>; Wed, 28 May 2025 16:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748448180; cv=none; b=nM2lTV08EuB0aYqQvzlPzlP1KDPrvdjJY8vXZm9H9RhbcR+ltCX/OqL16xsTKS14OLgpOiawqdyjHkLY96LyI8h9trm5LRPnmnuD0cOgBnf6XP4wS6hhNS1oFlS1tICozl/S8sL70XM5aub6GWQONIageLNqQYxZ4VWTLEdSogA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748448180; c=relaxed/simple;
	bh=D5rEF6WuQZXgouurh2BHMgvj+jMxiPDtem705IhpnBM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PQ1enbi3oUzCajs0sFLVztMihK9TGuFxL5kvT1Kzw+85qiVvjh2F5/+lsHD+AS3HO/QnOYbuwvPjNFm0J27DuuOVDr+bgwTBqo7KZU1r16fVxmwUFuf2L91RP5vubrkBP9lf0gR4Ubbdo+hwcXFNsoVrXaBpLkFD10fjHvh09Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=LUxSykM9; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="LUxSykM9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-Id:Date:Cc:To:From;
	bh=Zfbc9Cx5WQlMkXUyt/SS7i4F7Qd0VqFig/5zb4B536o=; b=LUxSykM9MtTsb2Qnau3AYe41TO
	IFmQimTi6sNpykCBS9pu8Hs4D0e+wTxGA81zVuHKICVJTEnIBRvR34j1xTgOxVzcYZ6xLJ2Fv3c0Z
	Uq1Dtu23xI3UIyeNa8Z1oyAua5ivAloXCgR9AMKb1EoWfU5yFIqykqzBjhTHKXddVJPh+Gc/f8ZtS
	JDBQ1hFtxtl9EFNr7KbyQrBsNjhbPpeWAFKLFMzl4OwcNnC0rvMYNkYJA6J2EK8knQ+5f7GSut8uQ
	igZpzdGuatbkJFzqOdl0EWArI2khukuYQuDhOb7P8lMWYPVFZYUyOW2bnfxu6d7uQLcR8+Y69y942
	svMM+z6elvI3+YXztgcMy0d7UCG0riDleGlO9yaVbR/qGWrWQJV00OLmfRELLf40qofAjT7s7N8US
	TWFs+8w45NfKThGYaiGRhYMTjJLrOixnAmRWuFGFtnll+sxTPFeXfvBdNd7Ohv69f7oTbddyHAKN1
	dC15u0FuoZbjZi7n3d5578U4;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uKJEz-007hNr-0D;
	Wed, 28 May 2025 16:02:53 +0000
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
Subject: [PATCH v2 07/12] smb: smbdirect: add smbdirect_socket.h
Date: Wed, 28 May 2025 18:01:36 +0200
Message-Id: <6e3641b1c5a48b0f931e9ec526d2b39c126404ee.1748446473.git.metze@samba.org>
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

This abstracts the common smbdirect layer.

Currently with just a few things in it,
but that will change over time until everything is
in common.

Will be used in client and server in the next commits

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
 fs/smb/common/smbdirect/smbdirect_socket.h | 41 ++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 fs/smb/common/smbdirect/smbdirect_socket.h

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
new file mode 100644
index 000000000000..69a55561f91a
--- /dev/null
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ *   Copyright (c) 2025 Stefan Metzmacher
+ */
+
+#ifndef __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_SOCKET_H__
+#define __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_SOCKET_H__
+
+enum smbdirect_socket_status {
+	SMBDIRECT_SOCKET_CREATED,
+	SMBDIRECT_SOCKET_CONNECTING,
+	SMBDIRECT_SOCKET_CONNECTED,
+	SMBDIRECT_SOCKET_NEGOTIATE_FAILED,
+	SMBDIRECT_SOCKET_DISCONNECTING,
+	SMBDIRECT_SOCKET_DISCONNECTED,
+	SMBDIRECT_SOCKET_DESTROYED
+};
+
+struct smbdirect_socket {
+	enum smbdirect_socket_status status;
+
+	/* RDMA related */
+	struct {
+		struct rdma_cm_id *cm_id;
+	} rdma;
+
+	/* IB verbs related */
+	struct {
+		struct ib_pd *pd;
+		struct ib_cq *send_cq;
+		struct ib_cq *recv_cq;
+
+		/*
+		 * shortcuts for rdma.cm_id->{qp,device};
+		 */
+		struct ib_qp *qp;
+		struct ib_device *dev;
+	} ib;
+};
+
+#endif /* __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_SOCKET_H__ */
-- 
2.34.1

