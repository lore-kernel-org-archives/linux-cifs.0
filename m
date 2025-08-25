Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADF328F1
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155843; cv=none; b=IOEBo2JDVf3MnpCFKeis5+4uM5OkqyzAQVf9qf74mdtGOFpJF/aHpIkRdAAmwF1k4MpY19N/jmvIgv1y15PUqjyLmVEPWkWeb1uC2lziq8+i4HJWx/lNTDyqq0B7MuHOZ+oL1GgIBLEaHOd+wT8nW3HHAxIihRNdzwplwlAC7Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155843; c=relaxed/simple;
	bh=ufXsWDlzbe5+6PbOTCTuT58ce0LaNun1caqVNAwsMoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+J7pV50yWH2918xK3MeV2Nm41ysLDFfrW+hYIUyF77yE+ZB0bbL3JqLMi0NKXtnHotbzY0nplbuTeLS8F03udACm8QuTq+GaHCKA0chDlEipOk4jxh3BwHj5hafpg33F+D522rYB/lohFhG5qFNvvP3QF/Y2j/yVtOeKGZlFok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=eGW+aRug; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="eGW+aRug"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=C+mqjZUyj4EMMjQ0fZt0U2DSls4tURl87r2iFMFbYk8=; b=eGW+aRugVa9G2Run5Y/4zdPAC1
	rbU1sodJLC3AvVPnN0wLaZxWTN81fVC1idmZANdQlRL6AppkdW9kahSYM9o3YMHz7QqJbhhPFWDIH
	hmhNVTlGENUGIGzodJUbTTJEikQ2AByKUvWPgZcFMfH68pObk+hie8Q7JobRyAhzeEAZz2SgGa639
	AS9bZVvCsKC9EJfuYJK9P2zE2ulxiK6+tw0rEFpr1sqXaiCGcdHZTo1BSeuOK0XHHsvZQl3aVKhHz
	N2hqamze9TIjWbudyRhUHhi/ElpByWOjqIDgcNlBOYupK80gRCtDn1GvBiHJeaj1WxXMUv3svkCOb
	HioCvNgsHwPZJxPeh9epHpnHsZYt4+6M2/YduprjgSQSjRGE4zK9euh71iqGeYUYrDxLKmZmzvqYZ
	LDSkdGBfYFtsu3Qf4V7jCVKxIKezMY70rZcPBQgWHdCQzKscIIP6BLxPCrz4kjYWD9OBKvNFY5px4
	oR55YKC1iIjYORVuZgqGJjK0;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeMA-000neO-2W;
	Mon, 25 Aug 2025 21:03:59 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 133/142] smb: server: pass struct smbdirect_socket to wait_for_send_credits()
Date: Mon, 25 Aug 2025 22:41:34 +0200
Message-ID: <2205cb384ce6db174e5e46390faf2d21b60ae2fb.1756139608.git.metze@samba.org>
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

This will make it easier to move function to the common code
in future.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 370e27bbcf12..defebe773b8a 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -967,10 +967,9 @@ static int wait_for_credits(struct smbdirect_socket *sc,
 	} while (true);
 }
 
-static int wait_for_send_credits(struct smb_direct_transport *t,
+static int wait_for_send_credits(struct smbdirect_socket *sc,
 				 struct smbdirect_send_batch *send_ctx)
 {
-	struct smbdirect_socket *sc = &t->socket;
 	int ret;
 
 	if (send_ctx &&
@@ -1162,7 +1161,7 @@ static int smb_direct_post_send_data(struct smb_direct_transport *t,
 	int data_length;
 	struct scatterlist sg[SMBDIRECT_SEND_IO_MAX_SGE - 1];
 
-	ret = wait_for_send_credits(t, send_ctx);
+	ret = wait_for_send_credits(sc, send_ctx);
 	if (ret)
 		return ret;
 
-- 
2.43.0

