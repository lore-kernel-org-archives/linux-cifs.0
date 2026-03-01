Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A66C221FBB;
	Sun,  1 Mar 2026 02:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772330647; cv=none; b=RmWbcW1qVcH1bXSjNdc6d3kJP2byJ6hjEnOpsErR1ox3jgTrzyAFsD/+BBgXnlyB089Liij/jgdbV+SOxni6BqZfvNoStQ4o3Tn6LqFpLQtD1hzvAvSgCZKcBJvYR17ZAZRHJbaeKS0hA0LkvIB23Y7vakDnV47BulQxrS/crsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772330647; c=relaxed/simple;
	bh=k0pMTD2aZnMb6ebu2zRykQUEj+90rQQ/eTTjxDykNu4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HZJXs11+KFAWroooPQsbBsEOiWtaLXEurtemRXQMikksjEAyJRMWQUN8lALRfPEUJ+aD68U6148SQhAEUHvlGUHnQ/qpQSzvCxAw3JLK22TthmrD7yII6Q2xQ6v7kHWCq69lzDu09RJBeaLOMsEjcGO9Zc+Ic63Txe/CTvB91L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E4FcCQ0w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E4FcCQ0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591ECC19421;
	Sun,  1 Mar 2026 02:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772330647;
	bh=k0pMTD2aZnMb6ebu2zRykQUEj+90rQQ/eTTjxDykNu4=;
	h=From:To:Cc:Subject:Date:From;
	b=E4FcCQ0whxV1Y4XMIGiXzZwdalpF+nkxrDM2EwZH8TKx2RGfrLJEmW4X1x/Td8w7R
	 LzrtpdTsiN9S4zK9lKMO4VcmBxghXLEZbAom3UxvM7B22UFyAezMYo0XSS7rRztzHr
	 YM+PI3CVj4aK1vyI1dd6jfBOFrERkj2j2JO/2gE+Qsh0uPYks3LOFdLg+PmKleuT9E
	 sbIEw5kNm9DPZTc9aBWOiRgQqpTxA95zd9gN31gr74cuvMq6ip67E9xU+SZzv9Txrz
	 +Iw+oMytWOekoNsnODg14rQPV7Ky9rfHi/oomBPJbnjWqKWGREkjYFmPap9HkzQWx8
	 yxgXGDNYnjD0A==
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
Subject: FAILED: Patch "smb: client: remove pointless sc->recv_io.credits.count rollback" failed to apply to 5.10-stable tree
Date: Sat, 28 Feb 2026 21:04:04 -0500
Message-ID: <20260301020405.1732402-1-sashal@kernel.org>
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




