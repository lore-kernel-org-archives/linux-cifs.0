Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAFE2D8390
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 08:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764060979; cv=none; b=taIpBn7sDTuL+j32DQzk4nlSKN09A9KK5Mb+IZJNaUriiNKkobQvBafydds6LU/KBn80lY/PyZoPAx3B/OOqLRLFFW4Bfu7mjx4nOKcBVmYzT2BpFFkvFIIDzjwPvYEdPXR+z410kx8n2H2+yka/a1Za17YLZdmjZ0CK6ZVOyx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764060979; c=relaxed/simple;
	bh=spurD0H5KieptAVt0tv/NPBA06gQvV+xzZ6DFBV8mes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBPsydEbbklIRf3cKoZvuapkvxNPT9XvIUrctH/hxMNjsMCnxURoP22aWjSIIY3AOtyYm823KKCcqoLea9Vz0JAPuBtAh4tVTfozBEzMKZ8KWK5fS4NV+5hJUECRvvMBk7YJUfXDBCL9Nkz2KIjzE+oo8QPwrSQytCsWBHyDOxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=P+Af7Nft; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="P+Af7Nft"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=JBks4w2+a2ir27jAy7+dA8QHceTJmX14wJ2ZEbxuhr8=; b=P+Af7Nft+fd0WHuCLG8VZ3jXRk
	WnEAZ2joar+vPQZTqBhLvQXUUUBMurhMN9hrRtZuCbOT+Rul7W3a/TDdmHYZ1i/8Dw1TDp+DLozDM
	UGDxiCXuvRRjWJUhLzKhCW/K+HuB31av6f4PeKToWiWzKTgf4Ic9w/+sOMbFeVrm/EATRWUw9B0Uw
	KumxSTOEe9HZXKLF4uSI9+KA8nLy21+sYxk7d3Y2h95crA3zkt6RQMTC61ynWxLwajjIdLmrPqeuc
	tZL44UUy98vzM7utG/CJUnKFAJnNdGncRH/SPHzqnGdNvGYdInefGKclp9JD/NX4F2qBfRso3Gfee
	uXEx8GJX/cLTsB1l3OkesJs3IZTpc7VQv/1VXO/uafm9j8tGuPvsR7giPBoiI+mDWj0Img3FSq872
	NUjIUYbZy0QKn2LDB3Vtb+KqYzhZJ03qeShzArejZC5wuqYvX4ul6xYDQXr3iaVhkzflSO6NHSwuu
	XfEfdFbbK1a26u/olggMCsV7;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNoqM-00FYJi-0v;
	Tue, 25 Nov 2025 08:56:14 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH v2 2/4] smb: smbdirect: introduce SMBDIRECT_CHECK_STATUS_{WARN,DISCONNECT}()
Date: Tue, 25 Nov 2025 09:55:55 +0100
Message-ID: <df492536dbd5a48993ab32423be7dba8b2ad58f2.1764060262.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764060262.git.metze@samba.org>
References: <cover.1764060262.git.metze@samba.org>
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

