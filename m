Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137DA179958;
	Mon,  5 Aug 2024 17:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722880708; cv=none; b=WtNaKmjuMOcsqL+CkhP+dUIGOKpJzzAied8IWG8bTuDskKcXw2lMnxKoem680vC8CJP/+g5qH5cZ1OUYDCxeFoseJU3Jpjobci2Nga5W4B/Pz8u5nH+jTo3b4uS13SvRW7L5rIZfBI3xdtD/6ZaXPNSmKOoW5zDaWmcN9Wt8ZlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722880708; c=relaxed/simple;
	bh=mvjVhW69jJxI6YiksH+FTLTcA9Vyz0bmDcBXEarPZ+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjFK/HABDd3cgAmrBJBGl0GRcpTRxidSs/3Ti81Tllq0fxDtzzAWL9skiecelXhuO2NwRBlX+ELNBjtd64FGjW87WEdApJ/GQTgRLLybyVlK00yg1RT3BND5Z+R90bKv1JPyqgz/r1vF2slmj0RrFEVui0510ruVKLFduhY0qM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lTA1DBtM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lTA1DBtM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6C1C32782;
	Mon,  5 Aug 2024 17:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722880707;
	bh=mvjVhW69jJxI6YiksH+FTLTcA9Vyz0bmDcBXEarPZ+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lTA1DBtM1vDO1buwL53wVcsfO8kt6pVMkW4PflV3gbhjX82R6jf6P+FNSPHKTawhi
	 peoF288vrO+72yW3DuTOZhcgx3zgsXzfJLX+oKA1MCVGQEXp9pmnLpYOzyDim57S3X
	 PvWvhNsbcA7JMhcvUKPqLpl/HRFbH7N8d9sMawDRkiLuKY8Pz4jsoIdtTWTpVr77rt
	 xtT8Od18/efeByPK3q+Q8Tz9QKmylAlEOPf7uxq0H2Dwn9q9XBWchWdoZuEJFK7tQq
	 QGjO5G8MbkSs22ClDHOfxuIikhObUkOEIPVbDLMUXa8KZS/01sl9qjdABZCa6g3pKT
	 NWVHUUyzObY/Q==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.com>,
	Sebastian Steinbeisser <Sebastian.Steinbeisser@lrz.de>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.6 15/15] smb: client: fix FSCTL_GET_REPARSE_POINT against NetApp
Date: Mon,  5 Aug 2024 13:57:12 -0400
Message-ID: <20240805175736.3252615-15-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240805175736.3252615-1-sashal@kernel.org>
References: <20240805175736.3252615-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.44
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit ddecea00f87f0c46e9c8339a7c89fb2ff891521a ]

NetApp server requires the file to be open with FILE_READ_EA access in
order to support FSCTL_GET_REPARSE_POINT, otherwise it will return
STATUS_INVALID_DEVICE_REQUEST.  It doesn't make any sense because
there's no requirement for FILE_READ_EA bit to be set nor
STATUS_INVALID_DEVICE_REQUEST being used for something other than
"unsupported reparse points" in MS-FSA.

To fix it and improve compatibility, set FILE_READ_EA & SYNCHRONIZE
bits to match what Windows client currently does.

Tested-by: Sebastian Steinbeisser <Sebastian.Steinbeisser@lrz.de>
Acked-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 86f8c81791374..cd7b8ab84e5ca 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -948,7 +948,8 @@ int smb2_query_path_info(const unsigned int xid,
 			cmds[num_cmds++] = SMB2_OP_GET_REPARSE;
 
 		oparms = CIFS_OPARMS(cifs_sb, tcon, full_path,
-				     FILE_READ_ATTRIBUTES | FILE_READ_EA,
+				     FILE_READ_ATTRIBUTES |
+				     FILE_READ_EA | SYNCHRONIZE,
 				     FILE_OPEN, create_options |
 				     OPEN_REPARSE_POINT, ACL_NO_MODE);
 		cifs_get_readable_path(tcon, full_path, &cfile);
@@ -1256,7 +1257,8 @@ int smb2_query_reparse_point(const unsigned int xid,
 	cifs_dbg(FYI, "%s: path: %s\n", __func__, full_path);
 
 	cifs_get_readable_path(tcon, full_path, &cfile);
-	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_READ_ATTRIBUTES,
+	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path,
+			     FILE_READ_ATTRIBUTES | FILE_READ_EA | SYNCHRONIZE,
 			     FILE_OPEN, OPEN_REPARSE_POINT, ACL_NO_MODE);
 	rc = smb2_compound_op(xid, tcon, cifs_sb,
 			      full_path, &oparms, &in_iov,
-- 
2.43.0

