Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC761C9ED4;
	Sun, 15 Sep 2024 19:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726429556; cv=none; b=R3KJtWn8mt6oNwQBSjceF99os19FGUgi7tWYSSw1PH8TzyehuvbM24/oGGyqNo5m1wTBA7659vdu2thH5wPpd5OZtJ1SClVA5JcBy5jAR5quKQ5vCNyal81+khA3DuThLUhskxBzLOcMhwCYmmmmG7SAZ/DD/rB/aOnne11kMHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726429556; c=relaxed/simple;
	bh=kBgkdFHz49MetJQnsWgzyt5qwDabg4EPCDFgVX9Fd7Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MP85BLlAx8dmKt0pQIOGVW27536ygn3931oyaB1i9uqNPZv3W6Z/Ij08kpF4LhPAWyNsEetYoDOJCjVfr/xg2M63LivwtjwRIVFt4jKtLybFbClU+Ne4KAiy86T0qOBVn9xzRqliPA2KjUm4wOM7g8zHfrOoiqDypyDmIn4aR4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m1RFBc2M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m1RFBc2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4450C4CEC4;
	Sun, 15 Sep 2024 19:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726429555;
	bh=kBgkdFHz49MetJQnsWgzyt5qwDabg4EPCDFgVX9Fd7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m1RFBc2MUpHdJC1UPwLj4Q6AX5/Uob9B6IXOkWM/kTUE/W+JS3ZeHm/AxNonH/1WM
	 vxdm1bI3oGJtHW7sxfk6XBhBN9+HrEs+BrNyW3yIBSHOozJ8eDPAeCM+gTTAy46Bns
	 dauosbwjKnsvuffml8t/Ff1BvRsOdRKQO0g6W6Pwx4rRbRXfruoJVKEc0VU7MIjkGc
	 GjdcVyBnHVqgPPDDvmIqFf0A6CKs0ukO/4DPzDSu3+kOck2l0wJ5DTJVU4fqSicSXE
	 TL2GsJkzFXfWmdMJUnhPARaReGepihqjmnM/JFfspAb1r8L92J/5SzG1n95UpBhDhi
	 fOFE5atVgWO/w==
Received: by pali.im (Postfix)
	id CF0F9CF3; Sun, 15 Sep 2024 21:45:50 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] cifs: Update SFU comments about fifos and sockets
Date: Sun, 15 Sep 2024 21:45:45 +0200
Message-Id: <20240915194545.14779-5-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240915194545.14779-1-pali@kernel.org>
References: <20240912120548.15877-7-pali@kernel.org>
 <20240915194545.14779-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In SFU mode, activated by -o sfu mount option is now also support for
creating new fifos and sockets.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifssmb.c | 8 ++++----
 fs/smb/client/smb1ops.c | 2 +-
 fs/smb/client/smb2ops.c | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index cfae2e918209..0ffc45aa5e2c 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1076,8 +1076,8 @@ SMBLegacyOpen(const unsigned int xid, struct cifs_tcon *tcon,
 	pSMB->OpenFlags |= cpu_to_le16(REQ_MORE_INFO);
 	pSMB->Mode = cpu_to_le16(access_flags_to_smbopen_mode(access_flags));
 	pSMB->Mode |= cpu_to_le16(0x40); /* deny none */
-	/* set file as system file if special file such
-	   as fifo and server expecting SFU style and
+	/* set file as system file if special file such as fifo,
+	 * socket, char or block and server expecting SFU style and
 	   no Unix extensions */
 
 	if (create_options & CREATE_OPTION_SPECIAL)
@@ -1193,8 +1193,8 @@ CIFS_open(const unsigned int xid, struct cifs_open_parms *oparms, int *oplock,
 	req->AllocationSize = 0;
 
 	/*
-	 * Set file as system file if special file such as fifo and server
-	 * expecting SFU style and no Unix extensions.
+	 * Set file as system file if special file such as fifo, socket, char
+	 * or block and server expecting SFU style and no Unix extensions.
 	 */
 	if (create_options & CREATE_OPTION_SPECIAL)
 		req->FileAttributes = cpu_to_le32(ATTR_SYSTEM);
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index e1f2feb56f45..e03c91a49650 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -1078,7 +1078,7 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 	/*
 	 * Check if mounted with mount parm 'sfu' mount parm.
 	 * SFU emulation should work with all servers, but only
-	 * supports block and char device (no socket & fifo),
+	 * supports block and char device, socket & fifo,
 	 * and was used by default in earlier versions of Windows
 	 */
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 406f2399f0c5..d30f7cab197e 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5190,7 +5190,7 @@ static int smb2_make_node(unsigned int xid, struct inode *inode,
 	/*
 	 * Check if mounted with mount parm 'sfu' mount parm.
 	 * SFU emulation should work with all servers, but only
-	 * supports block and char device (no socket & fifo),
+	 * supports block and char device, socket & fifo,
 	 * and was used by default in earlier versions of Windows
 	 */
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
-- 
2.20.1

