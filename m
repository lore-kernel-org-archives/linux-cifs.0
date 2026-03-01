Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6C52D7DD4;
	Sun,  1 Mar 2026 01:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329046; cv=none; b=WcWM3+bLBPsNXw4NnXZPXRYBpm+IfYw6MsLB+C5ZrqrfRFDABFxbS0aNwE8sF9I3yeeLrDPhutURJKwKhDltOOUz6jKJMn6q55pneyWBwKMf8aNn2hbrzbOqY3rYl20wXtYqdpZiqDHYoGMof0n3qCp695xvHEkS22dxdxkAT3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329046; c=relaxed/simple;
	bh=Vvws0cFwNqQWjasmpi6GBWSORSaui/ndCS1BV4WB/o0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E8SxMFQwF+FOSdwFE10MToEXbBjaGX9ag1aNvWtcZrppGf11p8cgDYf3XHfH6irf5WGqR0fPhiUWmE51tTA66MeEj+5aYpqfEVcuzm/2eEbMc72Gxy2pzcJKNgEeMJYfWQqMx//4oOfwhbVGnKX4soklIRhhBUCp2upuANq3ToY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TsSEz3nO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TsSEz3nO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D374FC19421;
	Sun,  1 Mar 2026 01:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329046;
	bh=Vvws0cFwNqQWjasmpi6GBWSORSaui/ndCS1BV4WB/o0=;
	h=From:To:Cc:Subject:Date:From;
	b=TsSEz3nO1rBIM+xI5u6VJaE3GABkW56YwDjcZzqyn8W9BaCJ7yN18wzWZbpGY0IAi
	 zEJaykb2FJ7ZvvABOnP8WsPZAupdC4qKFNd2roodkL8Ji5FOkDHjhnkr9u+hrolnRp
	 JjnCmo4pZJflw/ETJhAkJpcrOVT9MAto08ABCFx/oPXpNV9c3GLXui7VL15tK14mL3
	 LOXcksuE79WiCQs+NHs7dOx7/DahaBqj0Q9R4Owptfwp3HKzLNGwmndA8THIJkhpOg
	 T7Zq1rkqoIIialAmhvqQeDk19FEJuzQpyA1g8MLcLHnqkVTIg83s1QZCX0Jwfelutz
	 1bAkelcRvr+9w==
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
Subject: FAILED: Patch "smb: client: remove pointless sc->recv_io.credits.count rollback" failed to apply to 6.6-stable tree
Date: Sat, 28 Feb 2026 20:37:24 -0500
Message-ID: <20260301013724.1697632-1-sashal@kernel.org>
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

From 6858531e5e8d68828eec349989cefce3f45a487f Mon Sep 17 00:00:00 2001
From: Stefan Metzmacher <metze@samba.org>
Date: Thu, 22 Jan 2026 18:16:51 +0100
Subject: [PATCH] smb: client: remove pointless sc->recv_io.credits.count
 rollback

We either reach this code path before we call
new_credits = manage_credits_prior_sending(sc),
which means new_credits is still 0
or the connection is already broken as
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
 fs/smb/client/smbdirect.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index f2ae35a9f047f..c9fcd35e0c77a 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1288,9 +1288,6 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 					    DMA_TO_DEVICE);
 	mempool_free(request, sc->send_io.mem.pool);
 
-	/* roll back the granted receive credits */
-	atomic_sub(new_credits, &sc->recv_io.credits.count);
-
 err_alloc:
 	atomic_inc(&sc->send_io.credits.count);
 	wake_up(&sc->send_io.credits.wait_queue);
-- 
2.51.0




