Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE876263F54;
	Sun, 31 Aug 2025 12:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643796; cv=none; b=KrKx4Hbcr/bHmR6h5YIF501xIpZo03f1zH0T4inw07gPDEwQZpK7jFmkEJS+lkf+L0N78nRmCg0eMWzDRJNcolW32JPx9xPK3y+mxhRwuUVEtbCuPu1D+Tu7fWBPSBVAslILX9S+YUm3/8n2zoLtbTAeccLPxKBqrc2+FHCl6SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643796; c=relaxed/simple;
	bh=RS6jv98pnSxASt8tSXB8W9+iiLL49EZrErEKsIhDzvI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hM0gt9IZYy0bsDwlwB/y/FcHrldulBlfsOC3+QrP9byGhu3L55ja+c3LnCFKbNjVxE5qWe3H6CRkOVL1NRvA+yqK70KBKyqdhOMkQ2Mmo5i2T6leh8ooyxg4XjisYWfcjOcTR7i98tV12m5e36S6nWpA9lK7Bqmk2Tl+wRvfbIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LxD166UV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LxD166UV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92775C4CEED;
	Sun, 31 Aug 2025 12:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643796;
	bh=RS6jv98pnSxASt8tSXB8W9+iiLL49EZrErEKsIhDzvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LxD166UVZNwifmFSwn5mOgLaEozK1LEW8jt+FwkTEQ5w2gSub7gOw04WXxLRcx0Ul
	 6Xn3EZkOhRk7ef1U6Glepc05Pdpqwm84TUz9hMLMdIF5q1HiBOn3f7wcbCpP74F5AV
	 hgSnyJN7tnQYmBGb7Eyg69EBF2BoJyk51JaNOjkg1ZT1gNLxC/Ijn8+/u/yT/ch0Xn
	 L2w27I48TlpPKz+yS8TM/NKs21mrrYeFyxW53quLsZGwqy7Yh9Z5SOipPDY1Smokrg
	 JNBpTou7VW68EB+5LqIWzA5Uy1mir0BWtAaGb3qVU0JuMXlt1klCtylzOeYq0DloL2
	 F/wzC2KpZBy0g==
Received: by pali.im (Postfix)
	id AB4CF14A3; Sun, 31 Aug 2025 14:36:33 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 15/35] cifs: Do not try to overwrite existing sillyname in cifs_rename_pending_delete()
Date: Sun, 31 Aug 2025 14:35:42 +0200
Message-Id: <20250831123602.14037-16-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250831123602.14037-1-pali@kernel.org>
References: <20250831123602.14037-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If the target location for newly generated sillyname file already exists
then do not try to rename file to that new target name. It would either
fail (because file is still in use) or it will unexpectedly remove
additional file which was not requested.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index be8e5e5ca6cd..89d1b82ac55c 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1793,7 +1793,7 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 
 	/* rename the file */
 	rc = CIFSSMBRenameOpenFile(xid, tcon, fid.netfid, sillyname,
-				   true /* overwrite */,
+				   false /* overwrite */,
 				   cifs_sb->local_nls,
 				   cifs_remap(cifs_sb));
 	if (rc != 0) {
-- 
2.20.1

