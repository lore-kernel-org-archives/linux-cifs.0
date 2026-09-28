Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1414772BB
	for <linux-cifs@vger.kernel.org>; Mon, 28 Sep 2026 08:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790584290; cv=none; b=f5kAxCx+qP3jtZDAo/rAoWJo05Af/AmGgSUIMWCLP0T3E9nS4VBkYQGhryDjB/d9yGckAG446CgQWc3+451i+nMEJQhbHt2vft2WapknL7mYcA/iTCazp/lJUGl0e5TiA7oQIHe3bur5gAjLNKvGxxn4Nbhza42REf1ueM4pqMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790584290; c=relaxed/simple;
	bh=HsLRaYuEbq7ZzzRNl6uSIAKV4rQlZ2M6v1OhzKK4PeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfAqf7YQl8wGyrg+Gu+1oqiLztomBUR6S0kpAQgjyKJuuwf7feGhhVVO9d4r6oe3lWyxBsEz0YK+p0HAr3lqvHvAcuaTVzTuYSbAFtAUYy+ZMY4AsqqMme/KtQOJoaA1maPJq/UzZUC+9WC4YOojgztLgmN+vaVhLGZhm1yeWzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZgZwCPsN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZgZwCPsN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790584287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hUSOoW0g30UFVhZc7yIBkWk1BVCAbM29mk2RKcbK+JY=;
	b=ZgZwCPsNAX7etiwpj/RpNwCEMlRVCGy5+7UYlRRnDXX5dt1/jM1ulzQqAQKqhsr1S5KLSw
	AkdhFC/2+I8xFTGnNK7hlnq7NFlKeXB1O3+0sucU9Jn488qI70JYg/bAXXCNLT/ySgxnrb
	YAjazEMxTxe/nY3hb8iO2SkjblHlynU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-6-ESo0bJJoPJuHWakY4PDa_A-1; Mon,
 28 Sep 2026 04:31:24 -0400
X-MC-Unique: ESo0bJJoPJuHWakY4PDa_A-1
X-Mimecast-MFC-AGG-ID: ESo0bJJoPJuHWakY4PDa_A_1790584281
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4904E1955F13;
	Mon, 28 Sep 2026 08:31:21 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.32.43])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2D2C51956087;
	Mon, 28 Sep 2026 08:31:15 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 3/3] smb: client: Use hmac_sha256_zeroize_ctx function to clear hmac_sha256_ctx
Date: Mon, 28 Sep 2026 10:30:55 +0200
Message-ID: <20260928083055.104266-4-thuth@redhat.com>
In-Reply-To: <20260928083055.104266-1-thuth@redhat.com>
References: <20260928083055.104266-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

It's just cosmetics, but now that we have a helper function for clearing
hmac_sha256_ctx with a __cleanup() statement, we can also use it in the smb
client code for good measure.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 fs/smb/client/smb2transport.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index c407f30e00401..080864b24a0c5 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -212,7 +212,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	unsigned char smb2_signature[SMB2_HMACSHA256_SIZE];
 	struct kvec *iov = rqst->rq_iov;
 	struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
-	struct hmac_sha256_ctx hmac_ctx;
+	struct hmac_sha256_ctx hmac_ctx __cleanup(hmac_sha256_zeroize_ctx);
 	struct smb_rqst drqst;
 	__u64 sid = le64_to_cpu(shdr->SessionId);
 	u8 key[SMB2_NTLMV2_SESSKEY_SIZE];
@@ -250,7 +250,6 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 		memcpy(shdr->Signature, smb2_signature, SMB2_SIGNATURE_SIZE);
 
 	memzero_explicit(key, sizeof(key));
-	memzero_explicit(&hmac_ctx, sizeof(hmac_ctx));
 	return rc;
 }
 
-- 
2.55.0

