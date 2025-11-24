Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE782E093B
	for <linux-cifs@vger.kernel.org>; Mon, 24 Nov 2025 20:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764016935; cv=none; b=uxl+SOrAyypECw6ypBFEsAP4WGn2wh9acZzRYV04MD9B/VzJwJzvPa+AReDlFKwtzqKgpTlDjAxhZzbj0wbEV17f1OFIVnXlshgBsgC+3o7RC3F9xnLeNxx6Ncg3fOBZyqNbALQx0gRwsr2qmNqC+LAOV1NptolJIGeTxpl3MQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764016935; c=relaxed/simple;
	bh=/DLaw25uFGabivd7Yv8ZzDSVfTOHOHYITOFZJOa0w3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mj/0XuiDnkQIxnWqtQLa8fBHQg+4Va+gqu5VYnRWJlmr2NcR7VpC/SawEcdjizwjZZF1bUZxhwIp8mzULpmLi5A0b8V90608+IXuP0Ktd0RwISy9GQQuuAiMud73hmGJgsc77HwVv88ZNKKn6NnyrZrWMgN0D0QHH2PUj9+7FQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=kOEYyeRA; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="kOEYyeRA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=wSPRnudz3y3dIXEjEDIh+SELWkEkRQArVYveZr6wYBs=; b=kOEYyeRAIajJ5Ucporq0IwTaJN
	pd4XgZpxsIFBxuo3AklW1aMhIWxcYYys5Xj9RUGzXjeNEjkU3MIMZrFkjiuCE1dwQwTEMac6jHBkq
	WmbCe9CBRjiBqENr5yvZIUuCm5yyMfwTOFJjErYE+w4oL0+C5U0Chno9A7gtD25yOqgCLgsrAEhlF
	rZic2RWnhVX5JWFkigs4qoVfrpAxR/ma8KvtVwRagMcnDNW5qPlQXvmTozWJ/BA6f6udGIKB4b3el
	An+yK/7Vs2b49rZCU4i/VuqldfwKpCUbV0gzPD9u/IFgvXMeJLVc8+6o9hSOMIjw1IZzewfkZzcnw
	udgdPV+FtKodeOKcUYOq6flHL/0lFutBeejv6tYZervmFL/TT7L7Zr2kXSV9yVHizeGuTCIKmCCm/
	bYhxVnpOvhJckaW+sGuH9djRdWkZ0qf86fv5YHgS/cQMsTmOHe1GpH4z+kGrxSHfpG6PTzSmGMffd
	3vNAx0Ao8djt4Jd7olef/I64;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNdNy-00FSWL-21;
	Mon, 24 Nov 2025 20:42:10 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/4] smb: smbdirect: introduce SMBDIRECT_CHECK_STATUS_{WARN,DISCONNECT}()
Date: Mon, 24 Nov 2025 21:41:45 +0100
Message-ID: <15b339454570e9b13c03d91ec7014afbfa731a97.1764016346.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764016346.git.metze@samba.org>
References: <cover.1764016346.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These will be used in various places in order to assert
the current status mostly during the connect and negotiation
phase.

As a start client and server will need to define their own
__SMBDIRECT_SOCKET_DISCONNECT(__sc) macro in order to use
SMBDIRECT_CHECK_STATUS_DISCONNECT().

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
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

