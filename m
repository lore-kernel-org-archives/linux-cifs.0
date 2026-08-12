Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EAE448BB6
	for <linux-cifs@vger.kernel.org>; Wed, 12 Aug 2026 13:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786539731; cv=none; b=sIeaFbUGu79zu0OirdUq7Pavzyg0rGaGQy7tvPz+mIHYe1wyOIqYYw/A035GHMLpA46awFqdbqnBo3tBlCWvgaE/xOyWm9/xk0Afzd/a9nqfpNV2lNFoCmdWKHkrMViYKdBVyydJAC186DVaVH0wvXCEaB9JvjDUfnQqUd8qvck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786539731; c=relaxed/simple;
	bh=ybWsysO1/ldrbMjwy4Ja+LI1+6iB7pNifJt1mUe1yP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yd6KqeAFpOOQw9MPSYvFeCQlyjQ0m06xmsV+/1Y7Lh7ihI8rvc/ISV8ojcwJvZ9NviEM2X8SFE0xChBhCcWZqZUsDsWcIvZlHgVU+9KHI4dKH19WHFV7UBBcju984fVJQpq2jPExBVj2Q3Dyg+k6CLgBzViSbbcvzsDMO1ikhgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TERefRRK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TERefRRK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786539728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8a8VGNlPQgljRTJ9YZVx795VkCB4+m1vlXsh/HAygJo=;
	b=TERefRRK2lY3PV2BAz5qmqtV6XaMqKj9EBXgjOPfpcjd8z5iP3ExOmAqJk/Y3vI1tHY+9P
	KAusE/qRlI/SePYAVBgIP+35h1KWdYMAQgVE13ejfHitdCzg/ih5VSLfcwY4LEglUogGfB
	/3sNFqasOni8u5BcNWT7YU92yeE+unI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-613-jxb2MRUTMwmOViYxJd9RNA-1; Wed,
 12 Aug 2026 09:02:04 -0400
X-MC-Unique: jxb2MRUTMwmOViYxJd9RNA-1
X-Mimecast-MFC-AGG-ID: jxb2MRUTMwmOViYxJd9RNA_1786539723
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 66B981954B07;
	Wed, 12 Aug 2026 13:02:03 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1E221195DF9A;
	Wed, 12 Aug 2026 13:02:00 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] smb: client: Clear sensitive stack and heap data in smb2ops.c
Date: Wed, 12 Aug 2026 15:01:49 +0200
Message-ID: <20260812130152.2861834-3-thuth@redhat.com>
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

Make sure to not leak key-related data via the heap or the stack
by using kfree_sensitive() or memzero_explicit() here.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 fs/smb/client/smb2ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 192649fec25d5..a3099a0e5c2be 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1569,7 +1569,7 @@ SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
 	memcpy(pcchunk->SourceKey, res_key->ResumeKey, COPY_CHUNK_RES_KEY_SIZE);
 
 req_res_key_exit:
-	kfree(res_key);
+	kfree_sensitive(res_key);
 	return rc;
 }
 
@@ -4636,7 +4636,7 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 		rc = crypto_aead_setkey(tfm, key, SMB3_GCM256_CRYPTKEY_SIZE);
 	else
 		rc = crypto_aead_setkey(tfm, key, SMB3_GCM128_CRYPTKEY_SIZE);
-
+	memzero_explicit(key, sizeof(key));
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Failed to set aead key %d\n", __func__, rc);
 		return rc;
-- 
2.55.0

