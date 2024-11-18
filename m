Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AEA1A9B3D
	for <linux-cifs@vger.kernel.org>; Mon, 18 Nov 2024 15:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731944137; cv=fail; b=leOw/w9l4bnBHiFyhZxFdPit/WGgI24YRrHho37SvzLl1dvUKAKqosR5i0Gpn/CIrFLBvoPg/XnWb4U0LSYEywxyD6bcuUbjk9VPjt/ET5DHfizuN3N5C6dE90DQqmTv32h4p8FXI6XeCT6cNEcdVuVdUyiz6UWpid2GfyI7acE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731944137; c=relaxed/simple;
	bh=kGcFdY3Qu4Hcsn9vtxOKyGMkC/GDtzYB1kMLNM3u/1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMCrLfMs+DWsdH+d7VJTyUEmZC6H45UqZP5waAysvOTqkhBQPkVdWUa1C3R+jTREF5PrMBrg9i311b5l3H3D+bStQGMojQu7Da1nFB72PV6t+FbCglPNGimGl+pDUnLVyjkw7eDQF7neXMh/NacsA6qTC1JN19V0nwafI/6iYJY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=c2AQmKtQ; arc=fail smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="c2AQmKtQ"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1731944128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z6bYezLH9HEYp9M1Lfk9fsTUlHhVC0887Oi8oZJdkyM=;
	b=c2AQmKtQqPHOZ27noNCbkPYxdvR//i0tUSus3My8hOK106LUgbRGXcQL2+D3+lmOa8md3q
	eLvJNNaduSUHiWaZ1czqdYHlc2pUqzwyXxsVLMMxkbuN3ZqT+LWJqq/OGcJnlzr66AW8po
	o03XlOCJqfflo74QFZ72NgrOYkRsgorWquLQuPhPgj2EORR4fNocy5ONhSgCFUT0jEQUFa
	UH8IBSBLYtrrl6FTzKiPsdsgnoLSOCoq8LnSK/ZwdIgynw4abInfe1ggPyEaLxNIoXeI1q
	eilFhbPrciyxwbSN8lqXutA6D/cGS0AbXzeR+F0UKo9nszh0s8GWQ5MdMETqXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1731944128; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z6bYezLH9HEYp9M1Lfk9fsTUlHhVC0887Oi8oZJdkyM=;
	b=GkdF6fwuFse7Zyo8+IHb6mw1eKvp452mNZkyaCsIZzSIMBCGBTcoXRvq+eBxVSsTD/MC7S
	PZvOw5ahekYBo7UCwlogcdLUjzh4JwrCPC0r4ars68f3nomCAqke6D2RUVfuz/0H+9+JTK
	JoIZzE3K8Fnd9zRpKlPPaFHztt12wHkSfBcdvPbhH6wmvZ3F4JipQ5kh3RX2TMVRLSQfDk
	/Lk6LikALzpFIHRcUDkEWY4+her7dwtSJOmTM1G1YtZtg8u2J/affbPbuULkHQN9pCJtpL
	0nOxPHz3zuvKG+o6kUm0aZ3sYYKJmwUOANg2aNDLLFe5rwIh6wQHBs5oYm0r1g==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1731944128; a=rsa-sha256;
	cv=none;
	b=of47eJELfPuezg8taXt9UcXhJJ10Bld+FXFnMvALimbdGMh4eS3hzhAxtFeLUPaUl43rFX
	Y8Fzt05wdmKmXqzpYF74dGXLauXR3SS3LSx268QmcoMThCYnyoXfhHzU+r/N5nFiducchw
	PpQrdrXmgmvG3JlorlJAerr3yMuskpWTfoDBch258UmyVCoQLJob8MeF9ZZlyhFBm+iAE0
	4DGAIX4FNmp+TPYXFciVHD83wTAeaBlcg6FwRocL2bmz3CX5cHv5jQnNSNoL3u5AJGtkq9
	f8vYVIjZ+LL8X+mDcxRBSlvyjCDnSXxUMqFdLpA16dhlg+9OrMnlMrxxsl0iWA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>,
	David Howells <dhowells@redhat.com>
Subject: [PATCH 2/3] smb: client: get rid of bounds check in SMB2_ioctl_init()
Date: Mon, 18 Nov 2024 12:35:15 -0300
Message-ID: <20241118153516.48676-2-pc@manguebit.com>
In-Reply-To: <20241118153516.48676-1-pc@manguebit.com>
References: <20241118153516.48676-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_set_next_command() no longer squashes request iovs into a single
iov, so the bounds check can be dropped.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/smb2pdu.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index ab3a2ca66be3..055236835537 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3313,15 +3313,6 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 		return rc;
 
 	if (indatalen) {
-		unsigned int len;
-
-		if (WARN_ON_ONCE(smb3_encryption_required(tcon) &&
-				 (check_add_overflow(total_len - 1,
-						     ALIGN(indatalen, 8), &len) ||
-				  len > MAX_CIFS_SMALL_BUFFER_SIZE))) {
-			cifs_small_buf_release(req);
-			return -EIO;
-		}
 		/*
 		 * indatalen is usually small at a couple of bytes max, so
 		 * just allocate through generic pool
-- 
2.47.0

