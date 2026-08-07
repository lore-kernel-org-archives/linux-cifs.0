Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1EB3E9F9D
	for <linux-cifs@vger.kernel.org>; Fri,  7 Aug 2026 12:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786107558; cv=none; b=uMmaN2/aS4RQlRIhy2u+/QreleA7BCn6QRqBly/nM6iMPzpKI6X71gTdGDvs8J/0CDK272p+IIPOP9WB/Xw3IyfXpILfY+QBmDgJaR/IhzAIKvBJGXbs4oJmIgU5Kge/Mnyk6HE8Uv7z61RiyekI7xMYpou7Uv1S6tOi5hVJQvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786107558; c=relaxed/simple;
	bh=HY1fXOCc++pdACbCDsnbvo4DN0eMrHtPCYGnQ2C1K8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYeiIM+BHud1jy7mYdEJ8vfql3sQgf1c2mbijQ1Wcby8bYFgUTsioVYyAf7FGXB9GCgESKDUc63sgS/xrcTYo5lXRIbD6NF7xZ7a8ZbX8TQ32z74y6fIhln0jHvRkp7P+oIIboOsWA5YTyWXJlbFA4ECYI1I92ICuKVPPpk6Aok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PaKy7JwI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PaKy7JwI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786107546;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EnK55USt5eYX4DKAb2D0n3Ly2M5DO0VV1eu2CGhl9ns=;
	b=PaKy7JwIrhk9G/TkO5nRLk5Fpi7/2HJSqiSPtpLtO3Al31p7jYIVvK7ymGev0yiKzLdTwe
	umX2NbjChK+0ivyvZmA8SGFKh5oWXgrzqvf13laBEL+v/Q1Fb49DzmTXcfiCw9WSRpSght
	SagWT/m0qgTWUqNVQreSBspNAd7pbgU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-357-sZsFBmd1O1Kh-2j3jyt2wg-1; Fri,
 07 Aug 2026 08:59:02 -0400
X-MC-Unique: sZsFBmd1O1Kh-2j3jyt2wg-1
X-Mimecast-MFC-AGG-ID: sZsFBmd1O1Kh-2j3jyt2wg_1786107539
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 936481954B1B;
	Fri,  7 Aug 2026 12:58:58 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A88BB3000239;
	Fri,  7 Aug 2026 12:58:53 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Steve French <sfrench@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH v2 2/6] smb: clear the aes_cmac_key and aes_cmac_ctx when done
Date: Fri,  7 Aug 2026 14:58:39 +0200
Message-ID: <20260807125845.1477067-3-thuth@redhat.com>
In-Reply-To: <20260807125845.1477067-1-thuth@redhat.com>
References: <20260807125845.1477067-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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
index 4e7b6f0e6b8cd..e8d1c068a43e8 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -509,7 +509,7 @@ void ksmbd_sign_smb2_pdu(struct ksmbd_conn *conn, char *key, struct kvec *iov,
 void ksmbd_sign_smb3_pdu(struct ksmbd_conn *conn, char *key, struct kvec *iov,
 			 int n_vec, char *sig)
 {
-	struct aes_cmac_key cmac_key;
+	struct aes_cmac_key cmac_key __cleanup(aes_cmac_zeroize_key);
 	struct aes_cmac_ctx cmac_ctx;
 	int i;
 
-- 
2.55.0

