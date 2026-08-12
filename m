Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581F1347506
	for <linux-cifs@vger.kernel.org>; Wed, 12 Aug 2026 13:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786539736; cv=none; b=d0vasbGzNfps2ZGxs/qghuc4NSuq40uSAeaOq8Dbjjw9xskPYEU4lmFwWSWwzyft2FnEBaxTdr3EQa/0ulhLnakAnzkUF6sTN6iG8DA18m1bMp5sJvE5QhYIVDygcL8GyUVdVgjRH2qf/cWhgw2gSvDw+MYlndUC5HN3NPLGelU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786539736; c=relaxed/simple;
	bh=Ak8TRsQm8sEv91HLZDJ2c4Tbi82najZMuf991Ee04eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCwpcKB3apnt+zYHI+euPLsNEkkc+HmkKFSeIdS/cKXBN2vMhYYegmF8DIXCdALcEpGha/DQfRFE1X5hStPHAeaPlI0L3kBsvCYD8oLpb6n407Crn1T3suFefZVLv2fjg/n07BSAzh9Zroi3GZv7P1f0tHCPDdNEsIIeN0CvPyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VzLwd/fW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VzLwd/fW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786539734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C4G9wA9sxztkPp9GXgL2r4jkSKN5/Us6P6aBbvPhsk8=;
	b=VzLwd/fW8VZ2m6G3Og1B7rQ8aH6NNEjTISCYjjLIzF0og8Z44dOEPR3PW2wrLpzKGN7Xz3
	AcvTzE/isBpMIEa/Zf2u86208Da36w4NDYkg9iWk/01BSHPWdFStGk3/HeLT0YMnVbnNaz
	+FXNpz/o3GYrGs/hBczmeL7c4nVqimY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-522-8ZbhZGt2PBKLUKZOKg6AKQ-1; Wed,
 12 Aug 2026 09:02:11 -0400
X-MC-Unique: 8ZbhZGt2PBKLUKZOKg6AKQ-1
X-Mimecast-MFC-AGG-ID: 8ZbhZGt2PBKLUKZOKg6AKQ_1786539729
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8CC3618007FD;
	Wed, 12 Aug 2026 13:02:09 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E17E1195DF91;
	Wed, 12 Aug 2026 13:02:06 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] smb: client: Clear sensitive stack data in smb1encrypt.c
Date: Wed, 12 Aug 2026 15:01:51 +0200
Message-ID: <20260812130152.2861834-5-thuth@redhat.com>
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

Make sure to not leak signature data via the stack, clear it
with memzero_explicit() before leaving the function.

To avoid that we have to introduce "goto"-cleanup here, we re-arrange
the code a little bit (and drop the commented cifs_dump_mem debug
code that looks like a leftover from very early days).

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 fs/smb/client/smb1encrypt.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/smb1encrypt.c b/fs/smb/client/smb1encrypt.c
index bf10fdeeedcab..c9eb68f04e7b0 100644
--- a/fs/smb/client/smb1encrypt.c
+++ b/fs/smb/client/smb1encrypt.c
@@ -81,6 +81,7 @@ int cifs_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 	else
 		memcpy(cifs_pdu->Signature.SecuritySignature, smb_signature, 8);
 
+	memzero_explicit(smb_signature, sizeof(smb_signature));
 	return rc;
 }
 
@@ -126,15 +127,13 @@ int cifs_verify_signature(struct smb_rqst *rqst,
 	rc = cifs_calc_signature(rqst, server, what_we_think_sig_should_be);
 	cifs_server_unlock(server);
 
-	if (rc)
-		return rc;
-
-/*	cifs_dump_mem("what we think it should be: ",
-		      what_we_think_sig_should_be, 16); */
-
-	if (crypto_memneq(server_response_sig, what_we_think_sig_should_be, 8))
-		return -EACCES;
-	else
-		return 0;
+	if (!rc) {
+		if (crypto_memneq(server_response_sig,
+				  what_we_think_sig_should_be, 8))
+			rc = -EACCES;
+	}
 
+	memzero_explicit(what_we_think_sig_should_be,
+			 sizeof(what_we_think_sig_should_be));
+	return rc;
 }
-- 
2.55.0

