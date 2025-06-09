Received: from mx.swemel.ru (mx.swemel.ru [95.143.211.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFB443ABC;
	Mon,  9 Jun 2025 10:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.143.211.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749463863; cv=none; b=vAWYygdSWgbV/vIsvg7IdC1MM95hT3XBvx1GlwIonycer0Hz/ZrKC95rxTr/MHqyC2+pLjlcZAoo4tWsgdm6TS0CZXKw+ZU7ENdN5YqkeYObUuuD/3OSJficcyEa5KEVDfVfgxz2hxjJdLx7ZzxkK0/LwHLaI9Ms+slNQrfgBOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749463863; c=relaxed/simple;
	bh=JzvgjZLv5cGW6fc6fGEDZj9SR+1de/3cdl56xIRTnG0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H+A/ROiyQ08joF+9hd1xbzZ/eeEj6frVaPS9SMOMd4vM5fKeGO5AB68X5F7fpm8yIGXwa4BDB9F2zJAwaJMgh7kBtvpYcmKM35/pckemJfjgspA0dKBGOK+sLF8cqTnQ46FtRs7hTIM4FX3i6YEeVWnhOU+QY9N21GPinX2RbFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=swemel.ru; spf=pass smtp.mailfrom=swemel.ru; dkim=pass (1024-bit key) header.d=swemel.ru header.i=@swemel.ru header.b=p1SZvt52; arc=none smtp.client-ip=95.143.211.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=swemel.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=swemel.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=swemel.ru header.i=@swemel.ru header.b="p1SZvt52"
From: Denis Arefev <arefev@swemel.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=swemel.ru; s=mail;
	t=1749463856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jKiJ4waegiA05TQ0OciBg5LgGP0hIGFJmfYuEnY1Jr8=;
	b=p1SZvt529KNd0gCyudk3Gboa3ubKpTi5yCZXMEsoun04RD1qMHtkXY37a/h63lWwMTgTHl
	XH9cNyMkM1A9n/0m9XaBg1yQmqtF4qoNt8393WdumcTqAhCEPq1bLcC9a0LVJRuBMesR3P
	OGkOAPx8GaoB2G5X+SbXlOEDJlAEc9s=
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Paulo Alcantara <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.10] cifs: fix potential memory leaks in session setup
Date: Mon,  9 Jun 2025 13:10:54 +0300
Message-ID: <20250609101056.36485-1-arefev@swemel.ru>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@cjr.nz>

commit 2fe58d977ee05da5bb89ef5dc4f5bf2dc15db46f upstream.

Make sure to free cifs_ses::auth_key.response before allocating it as
we might end up leaking memory in reconnect or mounting.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
[Denis: minor fix to resolve merge conflict.]                                           
Signed-off-by: Denis Arefev <arefev@swemel.ru>                                    
---
Backport fix for CVE-2023-53008
Link: https://nvd.nist.gov/vuln/detail/CVE-2023-53008
---
 fs/cifs/cifsencrypt.c | 1 +
 fs/cifs/sess.c        | 2 ++
 fs/cifs/smb2pdu.c     | 1 +
 3 files changed, 4 insertions(+)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 9daa256f69d4..c75bcdc987e0 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -371,6 +371,7 @@ build_avpair_blob(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	 * ( for NTLMSSP_AV_NB_DOMAIN_NAME followed by NTLMSSP_AV_EOL ) +
 	 * unicode length of a netbios domain name
 	 */
+	kfree_sensitive(ses->auth_key.response);
 	ses->auth_key.len = size + 2 * dlen;
 	ses->auth_key.response = kzalloc(ses->auth_key.len, GFP_KERNEL);
 	if (!ses->auth_key.response) {
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index cf6fd138d8d5..d4e215674597 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -601,6 +601,7 @@ int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 		return -EINVAL;
 	}
 	if (tilen) {
+		kfree_sensitive(ses->auth_key.response);
 		ses->auth_key.response = kmemdup(bcc_ptr + tioffset, tilen,
 						 GFP_KERNEL);
 		if (!ses->auth_key.response) {
@@ -1335,6 +1336,7 @@ sess_auth_kerberos(struct sess_data *sess_data)
 		goto out_put_spnego_key;
 	}
 
+	kfree_sensitive(ses->auth_key.response);
 	ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
 					 GFP_KERNEL);
 	if (!ses->auth_key.response) {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 4197096e7fdb..15f9faa1e20a 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1360,6 +1360,7 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 
 	/* keep session key if binding */
 	if (!ses->binding) {
+		kfree_sensitive(ses->auth_key.response);
 		ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
 						 GFP_KERNEL);
 		if (!ses->auth_key.response) {
-- 
2.43.0

