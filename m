Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9B2435EF0
	for <linux-cifs@vger.kernel.org>; Wed, 12 Aug 2026 13:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786539729; cv=none; b=IptQV3fVoRiNFvHVuimYKU6zx82LLSoq49bUZjX9DhToN0zJ+RMAMUNOeZ+us5qccNNVa22NDJLkPwGx8mJPj5jIRiWARxMFF6ANuT4FPwub7NCrk8yDfHWVIh1x0HKi1UBpQvAtnbMvWmGKMtLpm0GRJgTCTz5ZZk/ZdLqGmfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786539729; c=relaxed/simple;
	bh=YXjXrOgNFGzqvM4hsIdhJQXZmmZk6MzBeYRGbDaPGkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLkRuFROXbcANEE4dSlVeVe4oDDes54zJdzJoMn/D+/ibwgP6CWv1RFvdvaP+NZGZnos7v4n9+mia4+uTQuh6rE4oR/U0AK9caHwBaVMwboKnIgjT5itHAm3csim+pkifXK57dwpLxvhkd2Zqae6DsYMO0BkihC9IFaIbYrm0ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Es6KOm9k; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Es6KOm9k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786539726;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z623CKv1hdADKFTYV+YYmA8vdXYt1jIoP/s4pA5BP4c=;
	b=Es6KOm9k4SSfZ9IU23uO8Yt0pryNc5EYq5tJM8ikkDficHv/PAVxRP+pHMcQ/VykbwMIPO
	Z0+3FIZjfbtuxSSNBfzxhWUnrz6Jcw5Efo/zFIy8tA1sCsC1lWOkZ0HkmDzLOYCACD1ZM4
	bWJJSpsIx8Q8KRNm/g4pKKNSbQlToFI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-628-qn4Nae7zMymS2uUA44O0kg-1; Wed,
 12 Aug 2026 09:02:02 -0400
X-MC-Unique: qn4Nae7zMymS2uUA44O0kg-1
X-Mimecast-MFC-AGG-ID: qn4Nae7zMymS2uUA44O0kg_1786539720
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 701211800D9E;
	Wed, 12 Aug 2026 13:02:00 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DAD97195DF91;
	Wed, 12 Aug 2026 13:01:57 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] smb: client: Clear sensitive stack data in smb2transport.c
Date: Wed, 12 Aug 2026 15:01:48 +0200
Message-ID: <20260812130152.2861834-2-thuth@redhat.com>
In-Reply-To: <20260812130152.2861834-1-thuth@redhat.com>
References: <20260812130152.2861834-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Thomas Huth <thuth@redhat.com>

Sensitive data like keys that are stored in stack-local arrays could
be leaked via the stack to the calling functions. There is no known
vulnerability for this right now, but it's good security style to
explicitly zeroize this sensitive material as soon as possible to
avoid that it could be exploited together with other bugs later.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 fs/smb/client/smb2transport.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 1143ee52470a7..fdc634d99da03 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -249,6 +249,8 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	if (!rc)
 		memcpy(shdr->Signature, smb2_signature, SMB2_SIGNATURE_SIZE);
 
+	memzero_explicit(key, sizeof(key));
+	memzero_explicit(&hmac_ctx, sizeof(hmac_ctx));
 	return rc;
 }
 
@@ -283,6 +285,7 @@ static void generate_key(struct cifs_ses *ses, struct kvec label,
 	hmac_sha256_final(&hmac_ctx, prfhash);
 
 	memcpy(key, prfhash, key_size);
+	memzero_explicit(prfhash, sizeof(prfhash));
 }
 
 struct derivation {
@@ -482,6 +485,7 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	memset(shdr->Signature, 0x0, SMB2_SIGNATURE_SIZE);
 
 	rc = aes_cmac_preparekey(&cmac_key, key, SMB2_CMACAES_SIZE);
+	memzero_explicit(key, sizeof(key));
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not set key for cmac aes\n", __func__);
 		return rc;
-- 
2.55.0

