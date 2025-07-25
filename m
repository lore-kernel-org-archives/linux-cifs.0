Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53312746A
	for <linux-cifs@vger.kernel.org>; Fri, 25 Jul 2025 03:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753413420; cv=none; b=Bdop8iZVQqoYiydfT9sEGXehe4po3kc18u/6ePNlqluw4zWZc4Ye9mPM5ZWmBzgghqqnlAlMBByJQlI/Us/asX2GRWHhJSdA7r+kDJI4gGKS7ofWl/b6atO/hrHMvKTtXQYrKxbT6VNHhxxnLT9HP6RitVKdbNR2FvFgtJgyVnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753413420; c=relaxed/simple;
	bh=kfdChQQHLGUL2G2Sb8SZE7oEyrCzY99V23ztJtnbJyw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FsL9OgcAxevJPzxGHTP/E33RYue49/R0S025Q3QVAgGEbSqya7jFvJsryervmkqIvtO07/YUFBZq4O95IXI9hGBDh7Su9ejZHSuf+w8OkldegbjV/3E4g6DsMSORQvPv8o1rOTPmXpenmNhCW88BkXAOL38gZ+0lOqG+0OXTrg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=Am0QDMD9; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="Am0QDMD9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=kaM+JQFCGz98074Z9CtHRnvkUcVFwWRUIqqLLiYB9eo=; b=Am0QDMD984F8mowfd4qZA+Qkl4
	LO1MUZhOTv/LhuMDttePo/Fbv1TF4hC0Kim6yPsuj4DVSDrEurrbqh12COYNMcOUCycC2xLoyKIiz
	0RTM4jO/uUDz9H8cNcZFbAdQEsyDzq5DEMqZV76zxvrJmPUlCLwONNnIg+8TItNTpEGbU9RKha+Zs
	wtlImw/NNJOpq+VAGQuBZJHqS6OhCcL83qUUO/Xm3etXwuRmSitJ/E9Mdr4bMA5Yp/EmtUIqTIDso
	mqxWPxozHVaihAT8U9nDZ59OQjs4gawMJ51qeFj3bv24vGm55WlE15kLfwZG5GAY+zXgy9f7i+0cl
	tPgI5+WQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uf8js-00000000Mlp-2RxJ;
	Fri, 25 Jul 2025 00:04:52 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>
Subject: [PATCH 1/2] smb: client: allow parsing zero-length AV pairs
Date: Fri, 25 Jul 2025 00:04:43 -0300
Message-ID: <20250725030444.1851761-1-pc@manguebit.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Zero-length AV pairs should be considered as valid target infos.
Don't skip the next AV pairs that follow them.

Cc: linux-cifs@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Fixes: 0e8ae9b953bc ("smb: client: parse av pair type 4 in CHALLENGE_MESSAGE")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
---
 fs/smb/client/cifsencrypt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
index 35892df7335c..6be850d2a346 100644
--- a/fs/smb/client/cifsencrypt.c
+++ b/fs/smb/client/cifsencrypt.c
@@ -343,7 +343,7 @@ static struct ntlmssp2_name *find_next_av(struct cifs_ses *ses,
 	len = AV_LEN(av);
 	if (AV_TYPE(av) == NTLMSSP_AV_EOL)
 		return NULL;
-	if (!len || (u8 *)av + sizeof(*av) + len > end)
+	if ((u8 *)av + sizeof(*av) + len > end)
 		return NULL;
 	return av;
 }
@@ -363,7 +363,7 @@ static int find_av_name(struct cifs_ses *ses, u16 type, char **name, u16 maxlen)
 
 	av_for_each_entry(ses, av) {
 		len = AV_LEN(av);
-		if (AV_TYPE(av) != type)
+		if (AV_TYPE(av) != type || !len)
 			continue;
 		if (!IS_ALIGNED(len, sizeof(__le16))) {
 			cifs_dbg(VFS | ONCE, "%s: bad length(%u) for type %u\n",
-- 
2.50.1

