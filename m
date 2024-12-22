Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F9E191489;
	Sun, 22 Dec 2024 14:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734879572; cv=none; b=UyOCjebxj0Tge1zRYxYmxDkIcdA1XkTISlOegDBhjzNZBrI5xrh3qr69w1OM3cwm68/7CijxeraQJHYXCkqmE8odUTrtyeLoh+KlWbUs/WuKSl4s8+XlQdQOgovbuzE1MoDrG72Jyq5qkPSvF1whi8zQ5/Mp9HkrSE1eZelCdmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734879572; c=relaxed/simple;
	bh=qhFm9PJ1h5CY4n+ytIU5HeDsZ6HiiW955ZSMx62QbdM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sEzb/Y4Y9xm+B44o9bhv6XDEL6Gyr6eZCZnHX6Qs7x9LPtesrQcM0FWRGLvPYDT9uRQeL6zFPbOz9UVq/BcSQxRV9aF5OcUQHNfPPro6MfXlSUo9pzOkOj6px9frojqj5TS0eDn5nWGzXT5H5PE7s+WoXf1+H1lTuL0fVp8Kn6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FyIYQJMt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FyIYQJMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14ADFC4CEDE;
	Sun, 22 Dec 2024 14:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734879572;
	bh=qhFm9PJ1h5CY4n+ytIU5HeDsZ6HiiW955ZSMx62QbdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FyIYQJMtFR/KnpAMfh1FnoOCydBxdTuuu7vAK9MxfALZrPROm92sM58hHKoYHO/HA
	 swPeDKKCG+iQbZRoZT1mk2t5Q3rbkOeW+PTpWPajlkI6WsyDMAyBF695ZbaQeDa3qJ
	 T+Uz4UUMkFGoK+ExuomtYlxYikwDRnLI4CXqiHYk3iQVlSt7njKcnnvaYPLY5GSHaA
	 wMiVm7uzeI+XjD9kiZQuny8HzpPTBmINNQX6UKCJm1PotcWrrKhSdysFVl9CFxSRJu
	 Kg21y9GMe1cNSIwy0CS+R0xIk+XfC8FOP+tzjgbdUEw3fq++HCgGkZiSwm3f7F3v6F
	 ABFzBVQ/+zq9w==
Received: by pali.im (Postfix)
	id 15655EEC; Sun, 22 Dec 2024 15:59:22 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] cifs: Improve handling of name surrogate reparse points in reparse.c
Date: Sun, 22 Dec 2024 15:58:45 +0100
Message-Id: <20241222145845.23801-5-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241222145845.23801-1-pali@kernel.org>
References: <20241222145845.23801-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Like previous changes for file inode.c, handle directory name surrogate
reparse points generally also in reparse.c.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 63a95ecc7542..6ffda4455f9b 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1222,16 +1222,6 @@ bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
 	bool ok;
 
 	switch (tag) {
-	case IO_REPARSE_TAG_INTERNAL:
-		if (!(fattr->cf_cifsattrs & ATTR_DIRECTORY))
-			return false;
-		fallthrough;
-	case IO_REPARSE_TAG_DFS:
-	case IO_REPARSE_TAG_DFSR:
-	case IO_REPARSE_TAG_MOUNT_POINT:
-		/* See cifs_create_junction_fattr() */
-		fattr->cf_mode = S_IFDIR | 0711;
-		break;
 	case IO_REPARSE_TAG_LX_SYMLINK:
 	case IO_REPARSE_TAG_LX_FIFO:
 	case IO_REPARSE_TAG_AF_UNIX:
@@ -1249,7 +1239,14 @@ bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
 		fattr->cf_mode |= S_IFLNK;
 		break;
 	default:
-		return false;
+		if (!(fattr->cf_cifsattrs & ATTR_DIRECTORY))
+			return false;
+		if (!IS_REPARSE_TAG_NAME_SURROGATE(tag) &&
+		    tag != IO_REPARSE_TAG_INTERNAL)
+			return false;
+		/* See cifs_create_junction_fattr() */
+		fattr->cf_mode = S_IFDIR | 0711;
+		break;
 	}
 
 	fattr->cf_dtype = S_DT(fattr->cf_mode);
-- 
2.20.1

