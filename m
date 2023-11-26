Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="DuiWnCUr"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E32AF
	for <linux-cifs@vger.kernel.org>; Sat, 25 Nov 2023 18:55:48 -0800 (PST)
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700967347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bSiHnLC5dn5ssQuI322/VMB5vHz405QLyt75lZjzNUA=;
	b=DuiWnCUrfgYV1YxGpgTKrvyqrVgRPMf2c1kvpHUjudApJx9dcR0MUDPZ8NZBd2FtUrszmh
	j/+wPKRhQzWEKRSXKHk1zwDjXCT8HhGdEzcoujbvI0Qz8gxJgem6W+tV22Xs0a44oLby31
	bRnzkCIDMD/92SWOO5zZwjlHoKG3vyBw9Wg5XgL5HMnSeLpliP5N3aX6+wDHVV3b5rZNFS
	Vr9JT9rbW473wNBUcxy9WTJY3/y0eModlx6/5GjQ4CyIwE6UIZog3JIOU0csT4ANExy7gu
	S7VE7/GaAPRW5JoIj60D3/ZXmuziEiiS+OApdvRdvBX2TE9AJHDRoSMj+4PXwA==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1700967347; a=rsa-sha256;
	cv=none;
	b=XpFBYhsWCTmMOCH7CNh6ufWlFPdTVqgF8KYaobSkTCaw0YQ8RkVwixXPJoqBCkp5lEteTF
	d5Mo7KENgqMSPgfiOCkh69hfaJyXxB0p7kayEJ/Prfm14kfc4Cb9ghjduPgIe3kR2x8ds8
	BYQCUNdKII3PT94szh90P3IgWsg76/LO/JQ64AEJxSwsGctpzRVWoy8qjLkxREJX09p5B3
	0+Ent1mjEEskhVBeGw5nhBJSGsP1sJATePQJjLtWSijidXLpl84t7cmWLSU8usd1qsCVeW
	kjBcFQ6SSBLNQalpVr2Mnr56dTMHoKtTcpoJw6ycirj/4V/eg7TJ6gnF5HPo8A==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700967347; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bSiHnLC5dn5ssQuI322/VMB5vHz405QLyt75lZjzNUA=;
	b=NN90X5wOXV4a60sNyA8+QfO7255qvIkNUqIvy0Kztr/deJiG7vOyUXqQeq7OgXIHXZrThI
	HL/0PWKOphytqIWlLNOCmeiejD5RuCw0RdIyvWJv1WfIru+Bn4BIQxCBrt93mIUT0750jl
	VPtV9YhwKvqUVL57swSBT6cI7zpWVikYQz6j+ZXPjE8MdUgTO7x6ejbORWYsY3OV/wmqUi
	5T6+a2/k3bJetuBtJuWbzsRe6LMDMpYHZAB19ymysub8plOhJZ3LzNE/3eNCgAurRo6a/D
	ebV7glqeUWUly52Mm4TfhYzAa7G3yNIV4koteAPokntYjfMOyB3eRwNB2Ik5IA==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH v2 9/9] smb: client: fix missing mode bits for SMB symlinks
Date: Sat, 25 Nov 2023 23:55:10 -0300
Message-ID: <20231126025510.28147-10-pc@manguebit.com>
In-Reply-To: <20231126025510.28147-1-pc@manguebit.com>
References: <20231126025510.28147-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When instantiating inodes for SMB symlinks, add the mode bits from
@cifs_sb->ctx->file_mode as we already do for the other special files.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index d7d19cdb3c8c..39a08f80735d 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -791,7 +791,7 @@ bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
 	case 0: /* SMB1 symlink */
 	case IO_REPARSE_TAG_SYMLINK:
 	case IO_REPARSE_TAG_NFS:
-		fattr->cf_mode = S_IFLNK;
+		fattr->cf_mode = S_IFLNK | cifs_sb->ctx->file_mode;
 		fattr->cf_dtype = DT_LNK;
 		break;
 	default:
-- 
2.43.0

