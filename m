Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946F62BD022;
	Fri,  6 Mar 2026 00:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772758636; cv=none; b=WWmfPzAsshe+bfNOQJOGzJ1scE4wZCdVr+27IJQa+MbzbLaIIyBibvXPNOPq+86D3MLZ6E5KmoKZlwIA/DzVcygLlDOw+cM3scL799TLEl0SnifvVXg614RLrLX+i/UrO4IsS+QtvQkSoTCSR1PmD0LYvklWdEhFw1l/skLpQDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772758636; c=relaxed/simple;
	bh=PheWvQKuKXoRDzJjoK4g+1bTnXmcmswbNjq3GH+LA/0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HSISAS/qEKm6FbeJoKzUN14c9G1LC3kZzOzK1AJ/y5o3YhHfE0oaq4qaPMNPmekank+OdQen3PdXfsngwvrck1Mzl8UOHFIrwYirw/QAQhMWzQr733aViauglgOmBWoqlyrLivTHWBgM973gl+OyJYa9Xh9cBRkEFojjUc+voC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=Kzqv9M6i; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="Kzqv9M6i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=Am+vpWtLKJr+i43YD+agVSMu36j/0actMvUOyNiUl1I=; b=Kzqv9M6i39syYz1dOhbwaHnjXg
	R4t7ph+yHNLppmx5K1xnGoyHsAh4hUBA5RPAflcH5Xw5y6/tGqbmreX8A+OcYD5WkGsRyOfh+s/rQ
	L2c4sSTg7lleWtIMMqx2yVX0IjJSC9i/yrRmyBHSpvLQteY06tLicxVNijjbG+418Kw7gJ81NDfaR
	T58Het90E2ZpVZ9o5xjUJuWW++yQ31hH+AI7xNtYj31LArtkAcD5NXqfdoJNYJd/tny26ssILTmoa
	KuDUJKgdAf52QwBiepTuf4oizixB1GS1Y7OIq1toBIviKbg9FMqxQ1XoGhBRz3texmxKm/rRvw1Sy
	mBk3FbSw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1vyJV5-00000000LXv-0HJs;
	Thu, 05 Mar 2026 21:57:07 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: Thiago Becker <tbecker@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: fix oops due to uninitialised var in smb2_unlink()
Date: Thu,  5 Mar 2026 21:57:06 -0300
Message-ID: <20260306005706.830672-1-pc@manguebit.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If SMB2_open_init() or SMB2_close_init() fails (e.g. reconnect), the
iovs set @rqst will be left uninitialised, hence calling
SMB2_open_free(), SMB2_close_free() or smb2_set_related() on them will
oops.

Fix this by initialising @close_iov and @open_iov before setting them
in @rqst.

Reported-by: Thiago Becker <tbecker@redhat.com>
Fixes: 1cf9f2a6a544 ("smb: client: handle unlink(2) of files open by different clients")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Cc: stable@vger.kernel.org
---
 fs/smb/client/smb2inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 1c4663ed7e69..5280c5c869ad 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1216,6 +1216,7 @@ smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 	memset(resp_buftype, 0, sizeof(resp_buftype));
 	memset(rsp_iov, 0, sizeof(rsp_iov));
 
+	memset(open_iov, 0, sizeof(open_iov));
 	rqst[0].rq_iov = open_iov;
 	rqst[0].rq_nvec = ARRAY_SIZE(open_iov);
 
@@ -1240,14 +1241,15 @@ smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 	creq = rqst[0].rq_iov[0].iov_base;
 	creq->ShareAccess = FILE_SHARE_DELETE_LE;
 
+	memset(&close_iov, 0, sizeof(close_iov));
 	rqst[1].rq_iov = &close_iov;
 	rqst[1].rq_nvec = 1;
 
 	rc = SMB2_close_init(tcon, server, &rqst[1],
 			     COMPOUND_FID, COMPOUND_FID, false);
+	if (rc)
+		goto err_free;
 	smb2_set_related(&rqst[1]);
-	if (rc)
-		goto err_free;
 
 	if (retries) {
 		/* Back-off before retry */
-- 
2.53.0

