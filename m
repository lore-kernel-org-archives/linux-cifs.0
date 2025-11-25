Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5ED15ECD7
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093423; cv=none; b=bYuYMwgGxCRuXRLrd2N65c/4j8gVN2Pe+sbv7ZTyB37S63BOrQYuZCD3uwyRLrfVwbee+cfmYL3eCnpM3ATsEhanyDYyiKFVt9Kl4V6sLITZJ1AlSl/KTK4WBMDYqPgwO6WDxpjc1L9kzQhcKAhxrKjZLYqxeYPNfiiZeLdf4lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093423; c=relaxed/simple;
	bh=kktJYbiTjk3l3mcuaSK3cikRlKDjLZJo+6L33oyRhMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXvZff1TA6Bnq/qFDEfxksQd5deHgjR+OwPYoxwBgWBjP0fBKzVADDSkB61GXFbFdlkIuieeJZL7EGzkl3nRh/BtYjqBvfFHJ4FgasmovuKX2avoWBZoEVzsA4djNagykUWTtSrQs5pZ3vHylQ23WOc5a1583qbitKgci2YgnEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Uo2coMEP; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Uo2coMEP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=bqIVzD/mSlrQC1NzWaIrNP6ys7jUNsLCqnfxEag7+w8=; b=Uo2coMEPNxAzspYE7V3YIWYZ64
	b5wwJ9J57AYowMTqlzS36/VV1iXFOUIE37ZoVqUyeXIFO6pxBokfjAQU+ejH8a8I6snshynxbobAU
	qJNhQbrTnI+Etug+CAeZeZtGcKaeyl04VNM6PktUXUPEOuI7YIbRStggoUdLTukDmxytqw6KzNkqh
	svhEM8auSugsQPxuDln2+kLt+nxT9x9QpxPHwulKN3zGKGTefQ3hlDxI5qAS5gFg4FSFXlMSM6MNK
	hqHzl/sMEdlhduUk5dtWTONt5gghZ+3qMzZxUedLaAUGE8m8EiF5SXLwO1D/zW1v+eMYGKyuUhdwW
	piEIbDW8cTkJzKD1RTVveZbg/l2tTwkDUnmo4vndNlRBVZKzLyAZrblK6xynROHPeXLKkY5ckkmGr
	KO1vy5YPqrvhyPWPHq9d7S51wgFDCY6B2LwLbY01quIw1feVU/BnebOxp3lAmrsIEL+32EEZ/jBDF
	6G8o+hlotuDI/+lbxUdfHmfM;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxHd-00FcTV-1S;
	Tue, 25 Nov 2025 17:56:57 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 003/145] smb: smbdirect: add some logging to SMBDIRECT_CHECK_STATUS_{WARN,DISCONNECT}()
Date: Tue, 25 Nov 2025 18:54:09 +0100
Message-ID: <9e4f4ecefa69ad9979bb4bb5547aaacd3ddb2260.1764091285.git.metze@samba.org>
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

This should make it easier to analyze any possible problems.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index f449fcd30235..cf8a16d3d895 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -535,7 +535,6 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 
 #define __SMBDIRECT_CHECK_STATUS_WARN(__sc, __expected_status, __unexpected_cmd) \
 	__SMBDIRECT_CHECK_STATUS_FAILED(__sc, __expected_status, \
-	, \
 	{ \
 		const struct sockaddr_storage *__src = NULL; \
 		const struct sockaddr_storage *__dst = NULL; \
@@ -543,6 +542,26 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 			__src = &(__sc)->rdma.cm_id->route.addr.src_addr; \
 			__dst = &(__sc)->rdma.cm_id->route.addr.dst_addr; \
 		} \
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO, \
+			"expected[%s] != %s first_error=%1pe local=%pISpsfc remote=%pISpsfc\n", \
+			smbdirect_socket_status_string(__expected_status), \
+			smbdirect_socket_status_string((__sc)->status), \
+			SMBDIRECT_DEBUG_ERR_PTR((__sc)->first_error), \
+			__src, __dst); \
+	}, \
+	{ \
+		const struct sockaddr_storage *__src = NULL; \
+		const struct sockaddr_storage *__dst = NULL; \
+		if ((__sc)->rdma.cm_id) { \
+			__src = &(__sc)->rdma.cm_id->route.addr.src_addr; \
+			__dst = &(__sc)->rdma.cm_id->route.addr.dst_addr; \
+		} \
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR, \
+			"expected[%s] != %s first_error=%1pe local=%pISpsfc remote=%pISpsfc\n", \
+			smbdirect_socket_status_string(__expected_status), \
+			smbdirect_socket_status_string((__sc)->status), \
+			SMBDIRECT_DEBUG_ERR_PTR((__sc)->first_error), \
+			__src, __dst); \
 		WARN_ONCE(1, \
 			"expected[%s] != %s first_error=%1pe local=%pISpsfc remote=%pISpsfc\n", \
 			smbdirect_socket_status_string(__expected_status), \
-- 
2.43.0

