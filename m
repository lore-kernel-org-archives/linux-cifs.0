Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24CC3254AE
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 14:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764080537; cv=none; b=m4qWeuXi0/MnOZIrXl1EXkCyxIRjdkY6AhHE+OaWLvkJWrLf2OB8JM3rYEYEw8deO6Nq2m+tUeqGcYEpKXStdEWuykTRiddQD+vIyk625wfIwFvag2Vhc1GCC6lI6cef23xgwUTH52pH1V2DcwPI14T06ygRzqbSxfuIEMQv94M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764080537; c=relaxed/simple;
	bh=spurD0H5KieptAVt0tv/NPBA06gQvV+xzZ6DFBV8mes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kegiujlLcPtxn9c+7IW4KXVG7Y6+k5UCOLg6XEey6o6OVpXoWX2IGPxvJWzCbYZxU6tVacL44Q1dlETJhPzt/2dKi45USYOp+Y56K1tSGrc4gOS01Wl0jas+1CG8M9354lWAK9Dde9qiKKQ0TpMRmi/j7QFOZ7GX7xeeeAKc41Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=pl6ArdA1; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="pl6ArdA1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=JBks4w2+a2ir27jAy7+dA8QHceTJmX14wJ2ZEbxuhr8=; b=pl6ArdA15OcB32sPdRKLM4SXyE
	2xTLRB9S3P530YuAjOlhGWSykGydgq6yavGymNgTeEdwPwW48dwG/MiXDX/TMlCtiYcRID3XcypzR
	ul1Eptpmed6raE3yo8Zx4GGNkb8vs43+LtRzi+X6nu0uiZeBx5lZpXYfuklijVEqi0oHmRb2ROIpX
	TGE1f6k7Zw7o1R6DBQrFA+6b8jCiQxcFbviuz9b1kmmFF0ZC8Cg1XMjVzdOYT8xYbbWqnjrKtYE5d
	6g4BHnWBjiydxiAbFxpNds3vOYQncnDufNDL1qKeVxBFhgRNkHh+YSLEY7CygUADA0JKfILxUagJX
	4yF6l0CnufW9VxwXxbyzv2kmP2ILHkhOpzLkUAzEn5PQ5EJH/YqZ9VIAWzeNIXNCqeZtTRblGolfP
	vNBGZJ9fO2Crana9qPVdlrhUbn8ycLGxUo+ChAMu/J1xQV7nkKWf3kWUmLFzMhV0nPam3h4k3Em2Z
	od0WVmHh3mHxnBHG/PRtkruw;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNtvo-00FatQ-06;
	Tue, 25 Nov 2025 14:22:12 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH v3 2/4] smb: smbdirect: introduce SMBDIRECT_CHECK_STATUS_{WARN,DISCONNECT}()
Date: Tue, 25 Nov 2025 15:21:52 +0100
Message-ID: <b4a0d59a61e338f6feaef30dba06c0d3ec815b2c.1764080338.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764080338.git.metze@samba.org>
References: <cover.1764080338.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These will be used in various places in order to assert
the current status mostly during the connect and negotiation
phase. It will replace the WARN_ON_ONCE(sc->status != ...)
calls, which are very useless in order to identify the
problem that happened.

As a start client and server will need to define their own
__SMBDIRECT_SOCKET_DISCONNECT(__sc) macro in order to use
SMBDIRECT_CHECK_STATUS_DISCONNECT().

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 38 ++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 611986827a5e..384b19177e1c 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -394,6 +394,44 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 	init_waitqueue_head(&sc->mr_io.cleanup.wait_queue);
 }
 
+#define __SMBDIRECT_CHECK_STATUS_FAILED(__sc, __expected_status, __error_cmd, __unexpected_cmd) ({ \
+	bool __failed = false; \
+	if (unlikely((__sc)->first_error)) { \
+		__failed = true; \
+		__error_cmd \
+	} else if (unlikely((__sc)->status != (__expected_status))) { \
+		__failed = true; \
+		__unexpected_cmd \
+	} \
+	__failed; \
+})
+
+#define __SMBDIRECT_CHECK_STATUS_WARN(__sc, __expected_status, __unexpected_cmd) \
+	__SMBDIRECT_CHECK_STATUS_FAILED(__sc, __expected_status, \
+	, \
+	{ \
+		const struct sockaddr_storage *__src = NULL; \
+		const struct sockaddr_storage *__dst = NULL; \
+		if ((__sc)->rdma.cm_id) { \
+			__src = &(__sc)->rdma.cm_id->route.addr.src_addr; \
+			__dst = &(__sc)->rdma.cm_id->route.addr.dst_addr; \
+		} \
+		WARN_ONCE(1, \
+			"expected[%s] != %s first_error=%1pe local=%pISpsfc remote=%pISpsfc\n", \
+			smbdirect_socket_status_string(__expected_status), \
+			smbdirect_socket_status_string((__sc)->status), \
+			SMBDIRECT_DEBUG_ERR_PTR((__sc)->first_error), \
+			__src, __dst); \
+		__unexpected_cmd \
+	})
+
+#define SMBDIRECT_CHECK_STATUS_WARN(__sc, __expected_status) \
+	__SMBDIRECT_CHECK_STATUS_WARN(__sc, __expected_status, /* nothing */)
+
+#define SMBDIRECT_CHECK_STATUS_DISCONNECT(__sc, __expected_status) \
+	__SMBDIRECT_CHECK_STATUS_WARN(__sc, __expected_status, \
+		__SMBDIRECT_SOCKET_DISCONNECT(__sc);)
+
 struct smbdirect_send_io {
 	struct smbdirect_socket *socket;
 	struct ib_cqe cqe;
-- 
2.43.0

