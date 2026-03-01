Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D785F2727EB;
	Sun,  1 Mar 2026 01:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328414; cv=none; b=R5YGEROP3V+QrmQgCklB+wqOHcY2h2wLDH4hxH8nQUH6/HrhYm1+3SjeNAqdmN2ln8T8LMD1Us3BSKNfMPMUP83RYqoTZlChiJnfgoRnI969TtE7b88dzFbiKiHJqHTATBSe2h8RPuWuOAFUGk3U+d9uVLDxQzjF2jm3kCvLESU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328414; c=relaxed/simple;
	bh=20d1Er3N30HQOik1RjvBIoKxoXtNCflTxdfauBVONlE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p1UNzQx1/RogcyCZHcRHpCEviN1ytBKkjl874o3Y1oUm58kFRLIFR21V/Iecg/sL3sndPudSbk71KOLSpAHO9ztY/i8OSsJbEWbF+4HUyy4fMK6KSR/W27gSopUiqd45G1wte7Wwiqhh0JNdooHG0IRmYPki4kjfrS3UT/m2iUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QWHr5xpc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QWHr5xpc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DDDC19421;
	Sun,  1 Mar 2026 01:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328414;
	bh=20d1Er3N30HQOik1RjvBIoKxoXtNCflTxdfauBVONlE=;
	h=From:To:Cc:Subject:Date:From;
	b=QWHr5xpccwo0lJ6cCxQawVmhmHA4T+DrsXwHDEWePKuoxO7npKQ/fEcvMi+ZzRaZX
	 mLGbU6qZ6qzSfDoxvJydTCxuVS9I1KY8VYGfDj6vuuPhUrRGgnhRN9EDe/YzGpZkVK
	 hW7E1d3cV5YF6+GEMuO3DkP+8+6yByfr1NbhyaBfC3CsVE+8zqACAKePzZdcAVGS4v
	 lwuhdMr8SaalWtRgD7xAGKwN5th9JwP1IZeF73eHzTTP2QRpg0cDBpdbCobxSb28SO
	 3ZEGbSPn9iVuMRbKCEryCiSAO3/xVcgNm50KiJc6wX2klML3tbhvZlFvn4J4kHpI+T
	 k6gVJD8drwRUg==
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
Subject: FAILED: Patch "smb: client: remove pointless sc->send_io.pending handling in smbd_post_send_iter()" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:26:52 -0500
Message-ID: <20260301012652.1684339-1-sashal@kernel.org>
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

The patch below does not apply to the 6.12-stable tree.
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




