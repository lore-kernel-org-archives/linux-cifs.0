Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36C343CEED
	for <linux-cifs@vger.kernel.org>; Wed, 12 Aug 2026 13:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786539736; cv=none; b=E0OfbawqBwTBsYcGphIjRihljuKnPjqpJvOUDtygAan76Z2i1hwWZT1oedl6NiPz7slU8fBGQQiR1ox8aKzUpg3Z/XMYV3X+3GlZwiegpBGUJhkl5Hp8+HJkHeSZVdXR19uaSbPNFOm0ZdV9SaeJ5vq0pQkIU/11Arz9QWZr23I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786539736; c=relaxed/simple;
	bh=37ZSvZMQ2O84LLv1NrrM4exFGYMoCZLXyaB0R0JKzLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1o+lixbqnuZZ3Z1skgsI715beYt8pZToYB4jYg1oYv1sASdM5s8Fw/wxfqXOvf2j2oxxWesPtrg0VjvibZI+kBscmcrlTgRodt7TSsAI82UfsBNBm0uiche79FWpxXcuTU1YhGxTgZmw0muc7dp7Wu86eVHemCO5XrR9cCENmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e38q5D3X; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e38q5D3X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786539733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RvIJq3MUEqJM1jGf5uqldrBdTrF/LDQARguKWvHM3lw=;
	b=e38q5D3XW9xidhqezIjSutMpyZExOE4+hMAPoYm/uMrFZbI2/Olw42rP4EcH0ack+ijkVR
	UQ64We/57jb6TG1YLgWeB+QyApul5izYNXwthMZMDc4ggULN5uhcE9ouFPXnYxV72TwZCv
	WQCgy1H6cNZpDqyTU5OgDXPYTTCEUqc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-354-v9kdM2k5O_y1MeNf7Ctwbw-1; Wed,
 12 Aug 2026 09:02:08 -0400
X-MC-Unique: v9kdM2k5O_y1MeNf7Ctwbw-1
X-Mimecast-MFC-AGG-ID: v9kdM2k5O_y1MeNf7Ctwbw_1786539726
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 57AA6180034F;
	Wed, 12 Aug 2026 13:02:06 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D709C195DF91;
	Wed, 12 Aug 2026 13:02:03 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] smb: client: Clear sensitive stack data in cifsencrypt.c
Date: Wed, 12 Aug 2026 15:01:50 +0200
Message-ID: <20260812130152.2861834-4-thuth@redhat.com>
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

Make sure to not leak hash data via the stack, clear it
with memzero_explicit() before leaving the function.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 fs/smb/client/cifsencrypt.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
index 34804e9842a80..71a2a59123f57 100644
--- a/fs/smb/client/cifsencrypt.c
+++ b/fs/smb/client/cifsencrypt.c
@@ -249,12 +249,13 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	E_md4hash(ses->password, nt_hash, nls_cp);
 
 	hmac_md5_init_usingrawkey(&hmac_ctx, nt_hash, CIFS_NTHASH_SIZE);
+	memzero_explicit(nt_hash, sizeof(nt_hash));
 
 	/* convert ses->user_name to unicode */
 	len = ses->user_name ? strlen(ses->user_name) : 0;
 	user = kmalloc(2 + (len * 2), GFP_KERNEL);
 	if (user == NULL)
-		return -ENOMEM;
+		goto out_nomem;
 
 	if (len) {
 		len = cifs_strtoUTF16(user, ses->user_name, len, nls_cp);
@@ -272,7 +273,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 
 		domain = kmalloc(2 + (len * 2), GFP_KERNEL);
 		if (domain == NULL)
-			return -ENOMEM;
+			goto out_nomem;
 
 		len = cifs_strtoUTF16((__le16 *)domain, ses->domainName, len,
 				      nls_cp);
@@ -284,7 +285,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 
 		server = kmalloc(2 + (len * 2), GFP_KERNEL);
 		if (server == NULL)
-			return -ENOMEM;
+			goto out_nomem;
 
 		len = cifs_strtoUTF16((__le16 *)server, ses->ip_addr, len, nls_cp);
 		hmac_md5_update(&hmac_ctx, (const u8 *)server, 2 * len);
@@ -293,6 +294,10 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 
 	hmac_md5_final(&hmac_ctx, ntlmv2_hash);
 	return 0;
+
+out_nomem:
+	memzero_explicit(&hmac_ctx, sizeof(hmac_ctx));
+	return -ENOMEM;
 }
 
 static void CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
@@ -463,6 +468,7 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	rc = 0;
 unlock:
 	cifs_server_unlock(ses->server);
+	memzero_explicit(ntlmv2_hash, sizeof(ntlmv2_hash));
 setup_ntlmv2_rsp_ret:
 	kfree_sensitive(tiblob);
 
-- 
2.55.0

