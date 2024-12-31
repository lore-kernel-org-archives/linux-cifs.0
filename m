Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DDF1B422D;
	Tue, 31 Dec 2024 22:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735684630; cv=none; b=JiXNYzPd0Tnm1YyX/lPiKaqypk6j4aPdKI2JPCAZjJjk9coIRHFEXThnovKs/S2EcIYNkWB7d+DWUAPh3eycE4D8/uoXP2kPPNeX6HF9Rl4ayw5ObVgNzBgPuZHui1D2oC/pxnxGhYV0vfOXLId9julOWxO9WyEvKiaki7d7UKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735684630; c=relaxed/simple;
	bh=l0Utkx3SUgSbQuWV7cfRUZJv8R3Vj8FAI5oHLPywygY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GAyWC+pV3gpE1oBzYYYZE+pl7DLwlKdQEEKCy5XV9K/IkF5Ijr2v4wAmqPtNisylBBBu2VK1F8IwZyqEbvRJo+p7bv/m4J/eFRXdAQHl+xHM7YyAIe3+ja8Q8UZ6mIWC7ZOy8R8aIbVl1ofFsOqEE/7DDxkl3vFpJ72fcU9Mwrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A0yE85i/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A0yE85i/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E468DC4CEE0;
	Tue, 31 Dec 2024 22:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735684630;
	bh=l0Utkx3SUgSbQuWV7cfRUZJv8R3Vj8FAI5oHLPywygY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A0yE85i/RvaaJAxHnFBCGmrxcKnFJNcFhELP6Ae76/iJDqUZZbjDekzVqxN7Mx+/1
	 qu2+C41k+xmHCYop8/lYXRLYdMCVY6Z8WYebKEbRiRmiBaulb7PhOv5047D4yhtTuh
	 MtP7Q0zNIoFGdnxYmGrUVmuYa5ebt4GSOw9AAx7mb/4AjHqXemNwRai/ierquTUUjR
	 y//F57uouLfXpahJMwxgqwAtJqnYH9S+owQ7RESG0mim7FgFP0SmgV4ldPv4HkCvC1
	 xsevuaWQ5pp8dZNXMrrrTmT4DUgQsJrWPnqdwS+H2YoUiYllYBh2abJTGn1C5ZPLca
	 mEXeRHBKGz/1Q==
Received: by pali.im (Postfix)
	id B1BE2D12; Tue, 31 Dec 2024 23:37:00 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 05/12] cifs: Fix cifs_query_path_info() for Windows NT servers
Date: Tue, 31 Dec 2024 23:36:35 +0100
Message-Id: <20241231223642.15722-5-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241231223642.15722-1-pali@kernel.org>
References: <20241231223642.15722-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

For TRANS2 QUERY_PATH_INFO request when the path does not exist, the
Windows NT SMB server returns error response STATUS_OBJECT_NAME_NOT_FOUND
or ERRDOS/ERRbadfile without the SMBFLG_RESPONSE flag set. Similarly it
returns STATUS_DELETE_PENDING when the file is being deleted. And looks
like that any error response from TRANS2 QUERY_PATH_INFO does not have
SMBFLG_RESPONSE flag set.

So relax check in check_smb_hdr() for detecting if the packet is response
for this special case.

This change fixes stat() operation against Windows NT SMB servers and also
all operations which depends on -ENOENT result from stat like creat() or
mkdir().

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/misc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 4373dd64b66d..5122f3895dfc 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -323,6 +323,14 @@ check_smb_hdr(struct smb_hdr *smb)
 	if (smb->Command == SMB_COM_LOCKING_ANDX)
 		return 0;
 
+	/*
+	 * Windows NT server returns error resposne (e.g. STATUS_DELETE_PENDING
+	 * or STATUS_OBJECT_NAME_NOT_FOUND or ERRDOS/ERRbadfile or any other)
+	 * for some TRANS2 requests without the RESPONSE flag set in header.
+	 */
+	if (smb->Command == SMB_COM_TRANSACTION2 && smb->Status.CifsError != 0)
+		return 0;
+
 	cifs_dbg(VFS, "Server sent request, not response. mid=%u\n",
 		 get_mid(smb));
 	return 1;
-- 
2.20.1

