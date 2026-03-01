Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C467D269CE6;
	Sun,  1 Mar 2026 01:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328528; cv=none; b=iha6zivI5Dggloghc9/GfA1waaFri5YUbB24YpHaoK3MV/+fV3tEBv6UnZ6RgoU/fVw9scezAuO3RJ2aHMTMyjBRNt3KHvt4abWk0cJq2A4876/5id+h3qQ5AbIJxklbDWpJC3iXguS6g4uKMxTMSU6O+SZ6Wa3UWRUHTN5CAFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328528; c=relaxed/simple;
	bh=ikLkOkgf4c/+QbsyqOWBhhn+r005cWH3UE9tHGo16AQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DSMkb83LtTGYEXV4AjOVtTc33+9hWFfW5kygSxE+X24ohi0Ni3f6LZs0z78kVnx0BL4nO9jCPlxUxbTFkUWkSSf4fLIEDee4i2ppWaCH4UjGBVDQzdEQ2Fu+ZiyDTiFhCdRYDaqCPq3Rtnh/Dg3ASrmZSnoWKBLlFcUxi0ZW7vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HmQmKtot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HmQmKtot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8498DC19424;
	Sun,  1 Mar 2026 01:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328528;
	bh=ikLkOkgf4c/+QbsyqOWBhhn+r005cWH3UE9tHGo16AQ=;
	h=From:To:Cc:Subject:Date:From;
	b=HmQmKtots5RnPoGsNCwVDKHEY3JXrwR547NXWAJKZpVxXfDNRxEqLRI3YQwTPtVo5
	 DGDBvDMCY04q0JjB1nimIABjZceJpigtH3hacO+JQ/4jWkUGGKAY+xiVvxqG7Vs7m2
	 Ng3A2lh3CGZUCLBBZVc6DG7pBQEKEttod/IqPSX7GQptkK9x68Dpyp4Isa4wKu5tQr
	 7APtTHNU+ucKy7kJZ20Yg4eLU1aCgli3RedX9v5IvCWb+tutBwx7SWIN7joM3u1cAH
	 5umABQDUzEEVu18ybtUmgeh9lgY4jZOeX24Otv0NAqUmGwQNhnVahhrkFA++JdLf8L
	 s89pOoRM68Efg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	sprasad@microsoft.com
Cc: Yuchan Nam <entropy1110@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: FAILED: Patch "cifs: some missing initializations on replay" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:28:46 -0500
Message-ID: <20260301012846.1686559-1-sashal@kernel.org>
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

From 14f66f44646333d2bfd7ece36585874fd72f8286 Mon Sep 17 00:00:00 2001
From: Shyam Prasad N <sprasad@microsoft.com>
Date: Sat, 14 Feb 2026 15:59:13 +0530
Subject: [PATCH] cifs: some missing initializations on replay

In several places in the code, we have a label to signify
the start of the code where a request can be replayed if
necessary. However, some of these places were missing the
necessary reinitializations of certain local variables
before replay.

This change makes sure that these variables get initialized
after the label.

Cc: stable@vger.kernel.org
Reported-by: Yuchan Nam <entropy1110@gmail.com>
Tested-by: Yuchan Nam <entropy1110@gmail.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smb2ops.c | 2 ++
 fs/smb/client/smb2pdu.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 61c521712f863..7370d7a18cd0c 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1185,6 +1185,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 
 replay_again:
 	/* reinitialize for possible replay */
+	used_len = 0;
 	flags = CIFS_CP_CREATE_CLOSE_OP;
 	oplock = SMB2_OPLOCK_LEVEL_NONE;
 	server = cifs_pick_channel(ses);
@@ -1588,6 +1589,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 
 replay_again:
 	/* reinitialize for possible replay */
+	buffer = NULL;
 	flags = CIFS_CP_CREATE_CLOSE_OP;
 	oplock = SMB2_OPLOCK_LEVEL_NONE;
 	server = cifs_pick_channel(ses);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 4602b4dfe8322..7f3edf42b9c3f 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2908,6 +2908,7 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 
 replay_again:
 	/* reinitialize for possible replay */
+	pc_buf = NULL;
 	flags = 0;
 	n_iov = 2;
 	server = cifs_pick_channel(ses);
-- 
2.51.0




