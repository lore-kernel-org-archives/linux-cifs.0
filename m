Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07D92773CC;
	Sun,  1 Mar 2026 01:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329041; cv=none; b=Zz//W9MwZdsM5cId0vtvCIv1gOGz/9Dpii1ChA7yK1PckZIChsG55N+qM/reA8IPnIfNXB6w0hrBHd+PjxRXyQGuzc9LzvwEodDza/qSFI3A7GJWnfGKZR0V54e42pVeFzPq+9w7Yuyz3Y4BYHhxKwcIoKUZLRdTYRSa75v3CMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329041; c=relaxed/simple;
	bh=ivzyvJePGnS15bPL+oaLmHu5Y7CEyrjATi384iR5IGY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AwaKYpcm0oPeGNRxo+kU+cklM22sCt29kJww7iNI5X7uN/CybMfhPR7Fu8124o+YREgbTZPLroDWgV0tlJEw3Sbr5SlM29kXxCkHo2LaqaLfY05WeR9xAJEL2+HS5hpBlEs7b92cIR3UiQhvAYyMb+x1F0MZ2Oi6Brskzw1LBbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=brXnjzeb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="brXnjzeb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7399C19421;
	Sun,  1 Mar 2026 01:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329041;
	bh=ivzyvJePGnS15bPL+oaLmHu5Y7CEyrjATi384iR5IGY=;
	h=From:To:Cc:Subject:Date:From;
	b=brXnjzebKWrV9NRqJldnu3j6ZyGyxkMJ9PtiPms6lCYA0cxdAnuOophbTP5+K+Yfy
	 sSjPoiKqBd3PKHdNk0xnfQAS3968xEv9ZONzbBj/t4Uhvoz5qSCuPrncSmCH4Rydt6
	 gFnbmWyuriQ3jExDWH2CtIPDfGI1q7KMCpKW5cdXtZSxGV2YsIuxh5VU2ggkE+h2qk
	 vgjMd6KSXzGAx6tDzHUGkF9KvjFI6JBM0qz8wBTKgbvnvcimDwN2uqlVxXBTxeSZhD
	 G+sM5CwU6rJloBEsrvBMstcgb9GEde+cp3BsYbFUFP+e/tbyPSdUeLl3OFrvhROh7X
	 MKdoUQXw1Wheg==
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
Subject: FAILED: Patch "smb: client: remove pointless sc->send_io.pending handling in smbd_post_send_iter()" failed to apply to 6.6-stable tree
Date: Sat, 28 Feb 2026 20:37:19 -0500
Message-ID: <20260301013719.1697540-1-sashal@kernel.org>
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

The patch below does not apply to the 6.6-stable tree.
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




