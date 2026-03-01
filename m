Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6722FE598;
	Sun,  1 Mar 2026 02:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772330642; cv=none; b=FNogymjo5eZanwGzypAYNpFuTxSkl7L0/HqD5Fl/I2n/QAXbjnj5pnAIytjt0wJ+LP8c7iCf+WZ2gjg/gCRTfPrHUmlpKk5Jtp+6xFUBQOIiviDkEXWLFXcJQz2jV0U9mc0x0vIhsMu7NBc15V1m2qdunjX97hemWcP+RJRZEZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772330642; c=relaxed/simple;
	bh=3hhuiNLmnoNEDZ2kRsXUC63jzE3fc0n+WMM4EpNLCcY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=te927+elEHoDG/yiiihTY9DgHt0lY5ZOAm6VVZBzbmfZWcyBr+vLYtG/8eNWvlP4nRB8qNUOhg475fbuDJVugx1kZNtttH4zk1mRwb2xE5OOx30AYod576GwMqiJMo258f+BKuhdJ3NfQSjOOvJ+Pf0yKxpq98Vm65n65Ys/bP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RpFkWJZ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RpFkWJZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ACD3C19421;
	Sun,  1 Mar 2026 02:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772330642;
	bh=3hhuiNLmnoNEDZ2kRsXUC63jzE3fc0n+WMM4EpNLCcY=;
	h=From:To:Cc:Subject:Date:From;
	b=RpFkWJZ4DWzb6t1XCKql9glW+ROx4MbVeZ+G3eP2AbvPXIZdME4jfKZytPSdrSv9f
	 ppPBlgEAr+9dCqEJv95IVRyMdLLGl2zkbP2/Ry/6f/FfSm5Xj4/98bPSeRhr6cibxH
	 0pn3nI2F+4YlZvnzRpPUVG1CzKkl34AbeQ8Qz4oH6IcUf0A3M/EWe718InxsTM3A6F
	 k/S29x25VNKCOtrlBIbRZpfFT8JwFDBwbIADHbf680FqmvoygGoXIBOAc2lnpZfak4
	 oB6KjZMgLJwWEGp7zyNUguBLPqwhp4okcFh2SW+qoW9welCnQTbVG5iihXutN2WFgP
	 kLduwHocc83ww==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	metze@samba.org
Cc: Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>
Subject: FAILED: Patch "smb: client: remove pointless sc->send_io.pending handling in smbd_post_send_iter()" failed to apply to 5.10-stable tree
Date: Sat, 28 Feb 2026 21:03:59 -0500
Message-ID: <20260301020400.1732216-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 8bfe3fd33f36b987c8200b112646732b5f5cd8b3 Mon Sep 17 00:00:00 2001
From: Stefan Metzmacher <metze@samba.org>
Date: Thu, 22 Jan 2026 18:16:52 +0100
Subject: [PATCH] smb: client: remove pointless sc->send_io.pending handling in
 smbd_post_send_iter()

If we reach this the connection is already broken as
smbd_post_send() already called
smbd_disconnect_rdma_connection().

This will also simplify further changes.

Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index c9fcd35e0c77a..cfbe8ce0db422 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1274,11 +1274,6 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 	if (!rc)
 		return 0;
 
-	if (atomic_dec_and_test(&sc->send_io.pending.count))
-		wake_up(&sc->send_io.pending.zero_wait_queue);
-
-	wake_up(&sc->send_io.pending.dec_wait_queue);
-
 err_dma:
 	for (i = 0; i < request->num_sge; i++)
 		if (request->sge[i].addr)
-- 
2.51.0




