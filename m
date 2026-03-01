Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4003822AE65;
	Sun,  1 Mar 2026 01:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329570; cv=none; b=EBAe0S6/YO5qCxNIek38qOIcmof15P2Lcw1ErvwbFrhVEKgdairPHfsU/ROMZ0iJv7wG/alFCRALrOpYNltUqklf9IXGOiqXRzW9vyN7mnW965JZOtwo8r/gJMAR2W2N8HXTnrFw6NbHeKWDGGHO4AqA0s2RfjvGNebUWMnbV3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329570; c=relaxed/simple;
	bh=saROlnhhiCbY6JXogQdAlT/M2RF18DqYECrFqO8glFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cYAvSTZ6Rr9suVB9mO1rT9M4jAiPU/oGX0qxzmb5w6oNwpopjPat4bVzUSJl3P+0Q5rD2liYrAxBauWwzGgWKDlc7J3aPy/5e5yCxHrlfDgCmiYmW7sXcK8ERwyl5Bd+mQVtuWMsMLk5VqfSdVoaF9MatELqf7UfCIs+tuhYtd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q0BM1dpD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q0BM1dpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33297C19425;
	Sun,  1 Mar 2026 01:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329570;
	bh=saROlnhhiCbY6JXogQdAlT/M2RF18DqYECrFqO8glFQ=;
	h=From:To:Cc:Subject:Date:From;
	b=Q0BM1dpDUhNn3GFLmtCawlAt+Gfcaxad61noXfy29h0uIK4LYZ707OwqLJ+4NSxON
	 MzKKohC42wKppsTnDXOK1Vp/zI/U8fa5ot1mccgq7IRuISjlZZjRGdxBDJtWB9Na8T
	 vrkLFvrPZRzN1In3tlC1mTt1xFiLJx/EyChLYNltiOpJllhejVIm0jKFPmc+ZK44BX
	 ImFLy2h5UaMmskEhqyvetZTt4BAKJebWCghryYinHSsfAuQkOoOExIyI8fm+6p7DMM
	 7OVru8zUohVp7vTjrt9ya3KTWo00IlvHUGIPnUPADSWUGWo9lHwevhsZavG3ROz8rN
	 UIaWqrM2OmEfg==
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
Subject: FAILED: Patch "smb: client: remove pointless sc->recv_io.credits.count rollback" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:46:07 -0500
Message-ID: <20260301014608.1708990-1-sashal@kernel.org>
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

The patch below does not apply to the 6.1-stable tree.
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




