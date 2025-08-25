Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9902D285C8F
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154631; cv=none; b=RdPkW9WcfVFxijQVRLptM1pGzK8eP0Y/rdENlGoyerRuah4rgn6HLzwoyOVhJT+3mVtGg8pHP92Cve6ghOWZY3OUsPI0SmBVIo7suWjolfdWvyggb4+6YJE6+h9uJSCa5kr8uXqhdhPRASBGBIOJTp0dZXCg3sjSy/mTcjIXa9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154631; c=relaxed/simple;
	bh=iRaMEk8iwAP7RNr3OAllIRy8BkLzKgoYVsaIDjE54Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGE9LPwxNbkRzDvx0gPLPwvdWPdHfpTLH+QM/TXPouW+nFTvSYmkPbEPCdSFCOBBcCdu1HTFy9+WE7uwWO9kOFU2iEs34cKBIRMqlXvEONi4NQHB5fntiYcoGwA4voTcRZP9PuhjfMlwyPhKwQP5AJyOcJ2+akOkj4pyYNZKLq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=SfCXvjLY; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="SfCXvjLY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=A0uqMnQzJ5zybMngTUCbCjTTX8T0NrC0mtPrflGfal4=; b=SfCXvjLYmShakwlu3x8OdTs4HX
	6p8e3PJ/IIbG2UmgQqDdND6+nlFD2j8cbS1FMwgytq3q+SVO5qc4Ug23p+hilec1hZs9qvF11VKIv
	DzlAxbGPbJ+9O9aaPKT4W2yK147LOpBAbzYHcmsov1Mpk2v1Z0u/d9fnu6aVsPSEAOcdM6Xh2KsoB
	w+qLyz4yGxCvbdC/ImqAMUmGc2SjPpPgBbhnZ6DQFgAT7Py8BSd+/NeUlYTHZPqv6yzl2KUCAxHCN
	cFrpJPdIW/hqC6bQvdU+psA5N4tawsatnIVp7umqQy100LPfkXw625XGvkVevFEC5nptDaDto8zIW
	yUzZmLPYuTZE+mTJfqO0eyi3jLQYaW5nlHqwg6OOLmRiTrdxrVr5ninbn2Uw5sMbb5MVy/kgQxaO8
	2nggLyoaOt/Fk+cESNNDxYSzpCEE4pZpw9l4cPh2FG5rsb7GzkRIIJLKaBKE8wT9dP6ovqnYWZgUe
	L/vqi9zXt+LiD9Ke6zFuABb3;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe2a-000jXo-2l;
	Mon, 25 Aug 2025 20:43:45 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 011/142] smb: smbdirect: introduce smbdirect_socket_parameters.{initiator_depth,responder_resources}
Date: Mon, 25 Aug 2025 22:39:32 +0200
Message-ID: <b24b81cf546b2498add2d3033d469dbcffb433ba.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will make it easier to specify these from the outside of the core
code later.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect.h b/fs/smb/common/smbdirect/smbdirect.h
index 17aa08dd6aba..c3274bbb3c02 100644
--- a/fs/smb/common/smbdirect/smbdirect.h
+++ b/fs/smb/common/smbdirect/smbdirect.h
@@ -27,6 +27,8 @@ struct smbdirect_socket_parameters {
 	__u32 resolve_route_timeout_msec;
 	__u32 rdma_connect_timeout_msec;
 	__u32 negotiate_timeout_msec;
+	__u8  initiator_depth;
+	__u8  responder_resources;
 	__u16 recv_credit_max;
 	__u16 send_credit_target;
 	__u32 max_send_size;
-- 
2.43.0

