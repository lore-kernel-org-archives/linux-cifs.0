Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4F82F1FD5
	for <linux-cifs@vger.kernel.org>; Sun, 12 Oct 2025 19:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760296278; cv=none; b=e/pV7oBeYgFZkdym6RBk0w8RUZ3ULmLEIARR7eSvJ73zEduwIqLi9MJmAuN7EkQhwvLdvJ+Ezfxoeo8WXS5PeGGqAdaFGUJzp4164VCPXkF6ZVm4A9OAObHf2Lm0/DxA7SOpmBQo76TBa9Z2LAF931PxNwQDmhXpLcKvJoE7iIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760296278; c=relaxed/simple;
	bh=qwfDq95Ay1xWcCLtEX5/ZtJ04lXFMxQIjxyXVCNhhiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgkZ2afW8EyLBu/oXbYFsy8/v5jsI3vnRXWGUA0zIxikoLhJioSJUrqxsdk4pZ5/gFXX98PuKs1wQAgix+HVNDN9NWuolAOSMchr8X9Sa7ZY+dqY83yUcJMzSWrwpyIvDMQ6bwmvi73pTf1ZZQOVXtJ7Efmh4FMvClVrRrDdGDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ulvfB/4+; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ulvfB/4+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=hRIn8/fTMfm2RzHetMjt3FbglELaW9ofsowj6oUWlJs=; b=ulvfB/4+conEd9n/7EWytsdgYw
	w77c/TWmRjX5Jjb+avww7BYI3Axg2I6sPJ5lVDGTuTCAv4rZiU8DCU8md6/Ny3roE+8lJZeVT+CuR
	tqH5XG8gVCLy/j8D5Llt576VN5BPyV4NvShTtx9OFfic6ZkV/5RW+3T/+egGIjluNNUufg/xNKuNz
	dmjluJD3BBAqVXPAOCwnzzlZNs/cDH9UfZHBb+omIklVKblOw3xgESyRuwnNOlXM3JpLARUxgG/tf
	NL0w2ipUOf+5XOAssaUhFVKxLTNeBeXow8+n70Oo2fcINeDeZRQe2eCYqGywwtEfw6GeCF3Ox/LhJ
	5H+EIqLWjcR2bQw1MftmAAecLQ7h/+hPDFJ51IZ63qRIJ5cd25XP6ryJFvGgLxOTtah6IwwGG68GS
	nI4EHVhucuPCjkq322jad+zEJLnq3EkefRQ6IctK4yBhFK5q7sb6QvBQVkM1paEjNOlIjeSpckTvd
	XQvF4A83xcCfkNH1tdm4l2KL;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v81TK-008o0z-0J;
	Sun, 12 Oct 2025 19:11:10 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 04/10] smb: client: let destroy_mr_list() remove locked from the list
Date: Sun, 12 Oct 2025 21:10:24 +0200
Message-ID: <52d3cc6ab2a0d454b6db4a8a6fbc4d586d371f5e.1760295528.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1760295528.git.metze@samba.org>
References: <cover.1760295528.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This should make sure get_mr() can't see the removed entries.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index b7be67dacd09..b974ca4e0b2e 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -2355,9 +2355,16 @@ static void smbd_mr_recovery_work(struct work_struct *work)
 static void destroy_mr_list(struct smbdirect_socket *sc)
 {
 	struct smbdirect_mr_io *mr, *tmp;
+	LIST_HEAD(all_list);
+	unsigned long flags;
 
 	disable_work_sync(&sc->mr_io.recovery_work);
-	list_for_each_entry_safe(mr, tmp, &sc->mr_io.all.list, list) {
+
+	spin_lock_irqsave(&sc->mr_io.all.lock, flags);
+	list_splice_tail_init(&sc->mr_io.all.list, &all_list);
+	spin_unlock_irqrestore(&sc->mr_io.all.lock, flags);
+
+	list_for_each_entry_safe(mr, tmp, &all_list, list) {
 		if (mr->state == SMBDIRECT_MR_INVALIDATED)
 			ib_dma_unmap_sg(sc->ib.dev, mr->sgt.sgl,
 				mr->sgt.nents, mr->dir);
-- 
2.43.0

