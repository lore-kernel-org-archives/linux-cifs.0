Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D5138836C
	for <linux-cifs@vger.kernel.org>; Wed,  5 Aug 2026 14:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785940597; cv=none; b=eijiN5Rhu4LQVt9BxDv3wVuONVgeorjcLPX90BnxPjoVCOsCUbLPXI1y3tMVz/HhODlHYzO0hwyywsM6iC6/HQGO6fnMRTjyfklOw/ryXoqDeIUGdQM1sMKj06/JQNC5iXJm1l94E2yqFXOavQR5//9h+U3yfQ5l3osk6aJRYiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785940597; c=relaxed/simple;
	bh=4rCgqeuHEy9E5A8LTGid6IlJZItGQ4fk034XPhbIATk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGdw7Vchbh7aVX8jcwzvLyUo6brJPZRfkpsz6Mw3364UR93SfUZmEXx6QgGP8okhmESPJOjpwKQJMHz4S2xs7/TA4Mp/Gg23ABUEr3ID2IR4hIPIeCd3QpLtKPRVIPH4UL4rSErpdZfOvHtPJtEfsmlBXu9Rp47jUM24b2VOvxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WJBN5W9L; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WJBN5W9L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785940589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SdbllWlXb3ri7lSNaZ11zlDq0wjdTEQ2mDG3hzZ4lUk=;
	b=WJBN5W9LEYLi5qhO8GR5vSZw/hxTvftqG3AtnoEk+SjQKHMA7NsKYHwoZbhj7FMjgbmhE7
	oscvHYCsZJIxhEYh2w/R5i09vo6Dx3Ov/Khq3lc+k7t1nwt5PFTWmcTxA/QO3dqjhx2C5n
	fP9v3rmvQ71EEuJco3fegsywrYHJk6s=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-230-YV8rJ0xiOzGhfOWY9BrAnw-1; Wed,
 05 Aug 2026 10:36:26 -0400
X-MC-Unique: YV8rJ0xiOzGhfOWY9BrAnw-1
X-Mimecast-MFC-AGG-ID: YV8rJ0xiOzGhfOWY9BrAnw_1785940584
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 28E0B1955F7A;
	Wed,  5 Aug 2026 14:36:24 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.209])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 49AFB1800598;
	Wed,  5 Aug 2026 14:36:19 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Biggers <ebiggers@kernel.org>,
	Steve French <sfrench@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH 2/6] smb: clear the aes_cmac_key and aes_cmac_ctx when done
Date: Wed,  5 Aug 2026 16:36:05 +0200
Message-ID: <20260805143611.818559-3-thuth@redhat.com>
In-Reply-To: <20260805143611.818559-1-thuth@redhat.com>
References: <20260805143611.818559-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

From: Thomas Huth <thuth@redhat.com>

Clear the local crypto-related structures via __cleanup() functions
when we're done with them to avoid that sensitive data could leak on
the stack.

Note: cmac_ctx in ksmbd_sign_smb3_pdu() gets cleared in aes_cmac_final()
already, so this does not need a __cleanup() marker.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 fs/smb/client/smb2transport.c | 4 ++--
 fs/smb/server/auth.c          | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 1143ee52470a7..d23566da2ac81 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -464,8 +464,8 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	unsigned char smb3_signature[SMB2_CMACAES_SIZE];
 	struct kvec *iov = rqst->rq_iov;
 	struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
-	struct aes_cmac_key cmac_key;
-	struct aes_cmac_ctx cmac_ctx;
+	struct aes_cmac_key cmac_key __cleanup(aes_cmac_zeroize_key);
+	struct aes_cmac_ctx cmac_ctx __cleanup(aes_cmac_zeroize_ctx);
 	struct smb_rqst drqst;
 	u8 key[SMB3_SIGN_KEY_SIZE];
 
diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 86f521e849d5e..f123e6cf9c424 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -505,7 +505,7 @@ void ksmbd_sign_smb2_pdu(struct ksmbd_conn *conn, char *key, struct kvec *iov,
 void ksmbd_sign_smb3_pdu(struct ksmbd_conn *conn, char *key, struct kvec *iov,
 			 int n_vec, char *sig)
 {
-	struct aes_cmac_key cmac_key;
+	struct aes_cmac_key cmac_key __cleanup(aes_cmac_zeroize_key);
 	struct aes_cmac_ctx cmac_ctx;
 	int i;
 
-- 
2.55.0

