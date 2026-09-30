Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F212D0C8F;
	Wed, 30 Sep 2026 00:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790728764; cv=none; b=N+NirWIrfUowHCT5As3UJoNZW5cVk3kKKCcEqqbM2A8O4cMWn5uU18DLgWOSp2mBgnKMsBeclRRffr2Err7JRzxXqDP3dz0L9tK2S+1CaKzQpSOjywco7mdFY3VEYGKnwGmDR2hEXbsLs2BV5AjtCv13h5roTsclfUvSpI5uVoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790728764; c=relaxed/simple;
	bh=JDzD+K9ctWj9DEQN6JeY6YdNXkumA7bmhQ1IponxLb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BybZERkNSTLjHqcVaGXbvhI5oFMgAmwO3y9QfAJgZGG4C+V7jNLdHPbvM1B5Ux3IoRrH+64sM7d12JDteOtIU0Wb1HSMZ8sElywIQxIJWxtdbl4MX8onrYyuEHfH0sXeTTmwzspGCgzj8gGM9Z9iWBvuKjjy1tZafRG7suUxFXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=oBx2vJet; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="oBx2vJet"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=lJT4YyzXCyUvSgOL73p+2MFoE9ZOl3detxnx4sCO+CM=; b=oBx2vJetGi0crZjCp/gA7efucP
	aczPzsQl1DE3LxkkkHWNW3nQgdGUnOSr9JWmjPhagigBcJoqNGG+0IqqcigewfuhlE4CHAMoIZn/U
	n3LxGH/D545BZFiOuKbkp2lwviSFVl4pe/kuyuGZiCqzk2v/KJPz/OaQtxdCBus4022hnh4KAkiJj
	PNwAQjE5BWPnTH46ImI3Hc9FDLawgmPJ/hthKxJ7SXwevm2ft/4CHTrQ1bEqAEeFfbK9QJNs0ksJ6
	IcwG0mejQ5CcBJRY2NxwZAcq/I9vBDIwMFiP2tZ9jsi8P/5bnC0/vWfG3sbBEUBbr5utmJwLiWBfs
	8JcYeFJQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xBiLq-00000002aGD-1u7C;
	Tue, 29 Sep 2026 21:39:14 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev
Cc: Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 15/15] smb: client: require stable pages for signed connections
Date: Tue, 29 Sep 2026 21:39:08 -0300
Message-ID: <20260930003908.1703770-16-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930003908.1703770-1-pc@manguebit.org>
References: <20260930003908.1703770-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When signing, cifs computes the SMB signature over the pagecache folios
in place and then hands those same folios to the socket.  If a buffered
write mutates a folio while a write subrequest is still in flight, the
signature no longer matches the data that follows it, the server rejects
the write with STATUS_ACCESS_DENIED (-EACCES), and the error is latched
in the mapping, so the next fsync()/fallocate() returns -EIO.

Mark the mapping for stable writes so netfs_perform_write() waits for
writeback to complete before modifying an in-flight folio.  This is
only needed when the connection is signed.

Fixes: 3ee1a1fc3981 ("cifs: Cut over to using netfslib")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/smb/client/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 5062474991cf..f29555f3c7d0 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -88,6 +88,8 @@ static void cifs_set_ops(struct inode *inode)
 		else
 			inode->i_data.a_ops = &cifs_addr_ops;
 		mapping_set_large_folios(inode->i_mapping);
+		if (tcon->ses->server->sign)
+			mapping_set_stable_writes(inode->i_mapping);
 		break;
 	case S_IFDIR:
 		if (IS_AUTOMOUNT(inode)) {
-- 
2.55.0

