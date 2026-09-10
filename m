Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3AA48A8C5
	for <linux-cifs@vger.kernel.org>; Thu, 10 Sep 2026 12:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789044173; cv=none; b=C17IN/W5oGXiz3oN4bwo3FoLj8/qj4uLXgJrukdwvMK7sFzZ4xfpLjilxF1qqJEMUiTIbpnsFTkkuPoEkpax2dOm8nXi7ZcL237PYz+xfFid5+uG71T5MqO28uNiNZQCxi/deppqn8rBFTpsG7axNCIQg7UNgwlEjivDDxPS6/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789044173; c=relaxed/simple;
	bh=HsLRaYuEbq7ZzzRNl6uSIAKV4rQlZ2M6v1OhzKK4PeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNTNkPvDvAwFKLo0uuEPi07De9luYkoH/hJVwLH09awe92zVh1kobFc9p1lC5wK/rn4LWpm6825cDp8ZQSoE7z+y7syqD+vmju86pothhadZBIIXI4Ez5p0wZ1pNPb95QTfKBQPhjL0oS68uTulq9ARFt5dhR0CfAWT811G7ktw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GOxuNvRh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GOxuNvRh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789044166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hUSOoW0g30UFVhZc7yIBkWk1BVCAbM29mk2RKcbK+JY=;
	b=GOxuNvRhwOg14A2rh6zMAbjsaO1W3oMwRhr6crCREHPlf0syHHgNcPxZR3U2NGc7A0RbKl
	c1Du1TbbzfO3lUtYWoJzzkf00Gu4nhFPwfzEPuB6bBW5MYEF5rhd0MyOyGPZpVhKWcbouO
	uIuB88CIDRKx7lFZqICvn3Sd7mCOCjM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-43-UIXoWfPhPCiSv6Uz3Q3DUA-1; Thu,
 10 Sep 2026 08:42:43 -0400
X-MC-Unique: UIXoWfPhPCiSv6Uz3Q3DUA-1
X-Mimecast-MFC-AGG-ID: UIXoWfPhPCiSv6Uz3Q3DUA_1789044161
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E237418005A6;
	Thu, 10 Sep 2026 12:42:40 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9208630001A2;
	Thu, 10 Sep 2026 12:42:35 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH v3 12/13] smb: client: Use hmac_sha256_zeroize_ctx function to clear hmac_sha256_ctx
Date: Thu, 10 Sep 2026 14:41:31 +0200
Message-ID: <20260910124138.417439-13-thuth@redhat.com>
In-Reply-To: <20260910124138.417439-1-thuth@redhat.com>
References: <20260910124138.417439-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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

