Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9075528688E
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155214; cv=none; b=KZW461hyaIKenJ56+vaP1rEcqoDjznox3rGdA9Xvw92iXGN1hQ2+zQLFg+bXq/blzD94UGc1r4U/EipuihrU0G9jxpbZORVnQgh+pso8te32FgwL0LAeAXj0xIGThkN7762vQMmTRu6noEAVF8/DZqwyQGIf8YnW8tBVkK21Vjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155214; c=relaxed/simple;
	bh=yHgSz9wf1zkyNXWyyN5DkwTLmoSF3589y/eNTex2RIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imo5ZRcp6XUsFKdEIqWEzbxBSb5tNMvZQp/C4T8rr+dH7FoZl1Q2zj5GzVntzJbaFqqyNIUKBFhTgUJWYqGiPg8BeblurVqLnTqyb0CiFov1H3xsvB/s+8XR5brcSVeF1zdzHMAeaD0GtWaslVyCkKKFl/7HopKFquY/m5qGbhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=O7YkCBHv; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="O7YkCBHv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=hxB3PbeW7jECtrC3U6MfKdxMJMAfwivNOE6dw3ZgpF8=; b=O7YkCBHvyz+mteQcR0cPFXBki5
	vsa//yKW0dumVRC0j2DbDkHBVMgZHw5syS0n3ut47+ryJN0gtMX0fEgszQ5Mg47pz7/1paw3xaLk0
	26gM0H8HRYoPL5dGDhu7OG9rXt/YJpV8StUAFWDV3Z/VtyY51JRwX87dpV5ssVYk9S3axkA2iuQmm
	8uioWL0oT/qV8RNl0xmn097h/DrknQNPQsBXPwHO+Y65QbK7B9sQsiFnFbh5iO3MICMkF5kOVABV4
	eJbXnYpwFSFbPpYEuRFFk6S1b/zSuAXa17wu7TFriSk9aSZsbhtirGyd9Hxi2r94Rj+p7McHVK2Q8
	5QXJf0QJheHlUgw7RuKCM/fJY/Q5oBllaOy2QxUt1S1jZ4Gsm+VKyRCtMj2PHZE6Flvn225g7EN3t
	mV/jJqXvAqQX/TILDsitK6EHkSoFD3YmR7cH1Wt4bl1y5yV5NPVWF4k5Zzhw23bn9PXQ1fP/zLUD0
	M1Pdz5/HHyrJFi+Al2VXsQW+;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeC2-000lXU-0p;
	Mon, 25 Aug 2025 20:53:30 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 070/142] smb: client: pass struct smbdirect_socket to smbd_create_id()
Date: Mon, 25 Aug 2025 22:40:31 +0200
Message-ID: <7f03c1ec15df165ec0f8f1cd3cf01dcba4fdc9c3.1756139607.git.metze@samba.org>
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

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 660edf02afee..3a0b5e3d3142 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -673,10 +673,9 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 }
 
 static struct rdma_cm_id *smbd_create_id(
-		struct smbd_connection *info,
+		struct smbdirect_socket *sc,
 		struct sockaddr *dstaddr, int port)
 {
-	struct smbdirect_socket *sc = &info->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct rdma_cm_id *id;
 	int rc;
@@ -784,7 +783,7 @@ static int smbd_ia_open(
 	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_CREATED);
 	sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED;
 
-	sc->rdma.cm_id = smbd_create_id(info, dstaddr, port);
+	sc->rdma.cm_id = smbd_create_id(sc, dstaddr, port);
 	if (IS_ERR(sc->rdma.cm_id)) {
 		rc = PTR_ERR(sc->rdma.cm_id);
 		goto out1;
-- 
2.43.0

