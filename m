Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B3D2727EB;
	Sun,  1 Mar 2026 01:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328405; cv=none; b=jtiiOzyd/kaubp9Mzc84P7CWgQvHprwVoDotWfVqUtfeKJnePEuT/A5aP0wLUesWMDRxGkmA0QsBQcIc9PPT/7NYe4n1axknOeBnMsXUxvF/w7JChLOYIcUWBpGwK8ODpFeptgnlRl1HLsbx0EPlxGItKD1BjZES+RLnE4Y6w+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328405; c=relaxed/simple;
	bh=3fVMHjFYmq3eUCJtUX1P07OM7HpVPhocNNPPUg0EatY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RE2NQSyYL/RS7BoF+7kErrbw7w9H2e6ayYOMyFMhj+lYVYlZN9upaee2QsezArMM7DApO7+DfcKRX7Ze371Terim5sKzES4bpewEXthmIvn+gCtn0lHcPsQZ+HJp2QZr6sfdGWOD9MhiHHijpzh6qb57+jzyfpAXSg8xKwOCh0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BVT0apkJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BVT0apkJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F10C19421;
	Sun,  1 Mar 2026 01:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328404;
	bh=3fVMHjFYmq3eUCJtUX1P07OM7HpVPhocNNPPUg0EatY=;
	h=From:To:Cc:Subject:Date:From;
	b=BVT0apkJSKc+VB/4gIuX5J+8u8akKjIkPwVkGYWGAH6l7UrulZ3ykiFc7o2/LJZXX
	 4EQDltl9OeYTA5vIt4o3fZ1LZw2vm7nb7N9jDEYTLPEdRXej2Lz/2vMjzaUfDHxOW4
	 2Pews54PoXzhn64vQE6T3CWJrwvtpi86SKyOiY5rDqFP0mudcnjq8L23BzAoP5IDv+
	 6uXqltz2aFdMsDhA/bzC4F1VbzDFW9Z40HJXOx8ZEzoFU2IV4q9jq3kmhPsVYSN5Ca
	 8JnvfLatsyFreR7cXbr20s8LJy73Ykk+PVzoxx3qgWUth67Sppz0H5KXct5IACsozy
	 NKH9qqkd/fbug==
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
Subject: FAILED: Patch "smb: client: remove pointless sc->recv_io.credits.count rollback" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:26:42 -0500
Message-ID: <20260301012642.1684141-1-sashal@kernel.org>
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




