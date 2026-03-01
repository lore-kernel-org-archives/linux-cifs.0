Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA7E2D838A;
	Sun,  1 Mar 2026 01:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772330075; cv=none; b=bowlD4k5Ur5JOj5B0khK0eEH/kDMSR6W00b13emFlKui3H0Q2L0x+OuwwgkiwHKogLuy9VeoZtpSCCJ940N+fERr6i4ILUu+scVtJjl+gvtafoN0j7AEpEqBzQYs+BmvEntrPmBkbqsO5/IMcFrKu1k7v/4cdtwGzyxWZaKc3v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772330075; c=relaxed/simple;
	bh=DwbitLtdNGFvtJNY+y7svum/LYUvG2BvNK2oGpPok0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=evoBCo4nKRwCbYIV2YsQYpwiCxaO7V4N71nn0FH+J806+XPJv1przsHw47CDZWnmdVnSkrAWItJqiQWwuj9lRDPASajRKO6R/AFX0mRt9+Zn4DoHgZjBS8iuhdk+A5y9dBtvs5SmwUYrjFGASLr6twKz7Bb+0vRDHtBqggwGpOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BaIKX1le; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BaIKX1le"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61158C19421;
	Sun,  1 Mar 2026 01:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772330075;
	bh=DwbitLtdNGFvtJNY+y7svum/LYUvG2BvNK2oGpPok0Q=;
	h=From:To:Cc:Subject:Date:From;
	b=BaIKX1leFr81OM1QApUKRTJWry5PJqcol8zTKc4UXbkxyWxqr+eHCE59Q5z77a2Fl
	 dj9XNv6K+i8Z5O4Mm3YbjkcvObnVKFj9fRMOgrYBSUZz4LR9dzo+7kXPxpjZaRY/pM
	 bCRCHBeOoO1MfGdZC5Oe8JPiZbFVr/bCmkpt10qR97+sM/TPiOk5KmY73DYwhbDst0
	 EihVeqD3fJJHAExmS+1crD4UPxH3QZJKPUMY1PGf+wgwaVz+oabIu7+sPjI2IMO40f
	 Yb76K6OnqttF/h4bgkPbwCBuxfAQhbK8hOkIAtUVoJbN8EzQm5+bsSHVm2/H3b1MZH
	 7R9J32ET5INPQ==
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
Subject: FAILED: Patch "smb: client: remove pointless sc->send_io.pending handling in smbd_post_send_iter()" failed to apply to 5.15-stable tree
Date: Sat, 28 Feb 2026 20:54:33 -0500
Message-ID: <20260301015433.1721579-1-sashal@kernel.org>
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

The patch below does not apply to the 5.15-stable tree.
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




