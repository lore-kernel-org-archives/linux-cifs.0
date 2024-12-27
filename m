Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56671FB3;
	Fri, 27 Dec 2024 17:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735321032; cv=none; b=QgEGREt2TNk5CmXDQmXrLBTmUZSfpFTeRPzdPUFFyT2mWE1/i3K0wbp5PLh3sdmv7klVGSuQYKIdbKxeQaC0UPZ8ZtxNeIx2HkxlcIKm8lN4vA9Mfa6iZnZRZtVuK/GZc2T65Q2eJS6JZHA2Ya0nDLlEPGBnSKB6Eg+BZZkz01Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735321032; c=relaxed/simple;
	bh=1NU4zcqs+KxMix7VmZ5qtOnmQGP+CeVG0tLdd2VdJmA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=lBRMZ+/Zz/zNoz8KnmAzbKkm81NgKjVkVKFVTw7jIM+mt392g59wj0Ioc8QqFx9W3rH5YweKlsJiQCO1k9gPiBswWGVK0dA9xfW2+5geRCZWFSuylJcs2MPufwROhsDCXrrEwV/UlQIqxV/HZsev1+iMQljpppCMYH6yhiLRfNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p/+nBNVz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p/+nBNVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3727BC4CED0;
	Fri, 27 Dec 2024 17:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735321032;
	bh=1NU4zcqs+KxMix7VmZ5qtOnmQGP+CeVG0tLdd2VdJmA=;
	h=From:To:Cc:Subject:Date:From;
	b=p/+nBNVzQCulhLFF6F0MZGMxWlnOh2LAKbQNfNFo7uIjs4BESbqhssLHy3Is0q3qT
	 iPMaFWNEDL7VXud2Vy48Mb2NFrGYTXNmBEGoRTGA4UGdi7Wgg4eiDtmCwsgE+F+/Rg
	 25vHpqbYAtgVj0HIwmTmnmaMLI1iqIcCc7dbfEoD6yiB1yuWed0dAnWklRtHokPyi5
	 PI88w/h3iHjcOTKdxwNdthIvi4KE3PpChDPgenXGInlpok/E6Mg4jUC4SL1tnTxZWW
	 oWkeS4W/hOy43KLGcLMmY+XWqR7yFWBdkQk1cqgUpYZKqWqA+J8TIi4FUgtM7IXnXA
	 so5cZhh1kSZZQ==
Received: by pali.im (Postfix)
	id 1C07F787; Fri, 27 Dec 2024 18:37:03 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Remove intermediate object of failed create SFU call
Date: Fri, 27 Dec 2024 18:36:43 +0100
Message-Id: <20241227173643.22875-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Check if the server honored ATTR_SYSTEM flag by CREATE_OPTION_SPECIAL
option. If not then server does not support ATTR_SYSTEM and newly
created file is not SFU compatible, which means that the call failed.

If CREATE was successful but either setting ATTR_SYSTEM failed or
writing type/data information failed then remove the intermediate
object created by CREATE. Otherwise intermediate empty object stay
on the server.

This ensures that if the creating of SFU files with system attribute is
unsupported by the server then no empty file stay on the server as a result
of unsupported operation.

This is for example case with Samba server and Linux tmpfs storage without
enabled xattr support (where Samba stores ATTR_SYSTEM bit).

Cc: stable@vger.kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb2ops.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 119ecb6641d1..ba81b662f5c7 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5073,6 +5073,7 @@ int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 {
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct cifs_open_parms oparms;
+	struct cifs_open_info_data idata;
 	struct cifs_io_parms io_parms = {};
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifs_fid fid;
@@ -5142,10 +5143,20 @@ int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 			     CREATE_OPTION_SPECIAL, ACL_NO_MODE);
 	oparms.fid = &fid;
 
-	rc = server->ops->open(xid, &oparms, &oplock, NULL);
+	rc = server->ops->open(xid, &oparms, &oplock, &idata);
 	if (rc)
 		goto out;
 
+	/*
+	 * Check if the server honored ATTR_SYSTEM flag by CREATE_OPTION_SPECIAL
+	 * option. If not then server does not support ATTR_SYSTEM and newly
+	 * created file is not SFU compatible, which means that the call failed.
+	 */
+	if (!(le32_to_cpu(idata.fi.Attributes) & ATTR_SYSTEM)) {
+		rc = -EOPNOTSUPP;
+		goto out_close;
+	}
+
 	if (type_len + data_len > 0) {
 		io_parms.pid = current->tgid;
 		io_parms.tcon = tcon;
@@ -5160,8 +5171,18 @@ int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 					     iov, ARRAY_SIZE(iov)-1);
 	}
 
+out_close:
 	server->ops->close(xid, tcon, &fid);
 
+	/*
+	 * If CREATE was successful but either setting ATTR_SYSTEM failed or
+	 * writing type/data information failed then remove the intermediate
+	 * object created by CREATE. Otherwise intermediate empty object stay
+	 * on the server.
+	 */
+	if (rc)
+		server->ops->unlink(xid, tcon, full_path, cifs_sb, NULL);
+
 out:
 	kfree(symname_utf16);
 	return rc;
-- 
2.20.1

