Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6790D1F868E;
	Fri, 27 Dec 2024 17:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735321154; cv=none; b=T+9os2fbCUiDkVvfUGPayxH3BrpJTALVb0gZqXGZuqW381a/MZ3uXXAc+mjBEdFhzJKp7osYxUXKgj34Z/LJuqMFc1ZyU0rTsw0FtUwUcf2+21hPMiUg5tzN4ZsSMWhernM3OrU2HEphrSU4GJTU2gDrJsXEN2lFUurvyB4a37Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735321154; c=relaxed/simple;
	bh=U6ONnIq8oDFK6RRa4Ear/9P7wspwRYBV3GKg4+Oo1ns=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jwt5zJf0Rl0l0Go2EpkciHifA5NVM0SIM2iIDdJb96n5HmNfC0bHSeyCDgIXT9RcG6FURMunuiq0S0KdegsBfa4KsL7lsMNxikJuviAX7r2q96VJ2bjQbN9X1SNf6u/zHEXVyRYvZrFsnyjwoG/jEAjHsC5ITnKbg9HpgnMTYFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V03C+K8c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V03C+K8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85B6C4CED6;
	Fri, 27 Dec 2024 17:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735321154;
	bh=U6ONnIq8oDFK6RRa4Ear/9P7wspwRYBV3GKg4+Oo1ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V03C+K8cy7iCsnfO83gehhZLWUi41WtNpqWtrnQQ+qM1kH59TJ0kUfJ+ebrMC7EOr
	 iz5KypKYnQW6FexM7mJzYChBea5khqUN8BAXZpVDRDS9q138nYiR0Tc2a9QKCEomoj
	 2X18AUVMrUYdJde9dzaS6YK1JDL5EXYWxIYtq/ydjCLzmPZJlFMcReDa3Tvml3752r
	 kXb2orPVOH12pSe2duXoyDJrixoWualQgmrsPHfMQ3I+7I2ufiF7Y0HFEA76dVIeV4
	 wC1bv3JYkXOakfhCEXXJONKiw7i63N1Dwny+FvbReIb+CFShp2reCaLf3N1ZZ9NwvT
	 VfDvsX02hD0ag==
Received: by pali.im (Postfix)
	id 4D3B0A7F; Fri, 27 Dec 2024 18:39:04 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] cifs: Validate EAs for WSL reparse points
Date: Fri, 27 Dec 2024 18:38:40 +0100
Message-Id: <20241227173841.22949-3-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241227173841.22949-1-pali@kernel.org>
References: <20241227173841.22949-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Major and minor numbers for char and block devices are mandatory for stat.
So check that the WSL EA $LXDEV is present for WSL CHR and BLK reparse
points.

WSL reparse point tag determinate type of the file. But file type is
present also in the WSL EA $LXMOD. So check that both file types are same.

Fixes: 78e26bec4d6d ("smb: client: parse uid, gid, mode and dev from WSL reparse points")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 9fe9dd71a6fa..9e40f5709c7f 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1105,11 +1105,12 @@ struct reparse_data_buffer *smb2_get_reparse_point_buffer(const struct kvec *rsp
 					      le32_to_cpu(io->OutputOffset));
 }
 
-static void wsl_to_fattr(struct cifs_open_info_data *data,
+static bool wsl_to_fattr(struct cifs_open_info_data *data,
 			 struct cifs_sb_info *cifs_sb,
 			 u32 tag, struct cifs_fattr *fattr)
 {
 	struct smb2_file_full_ea_info *ea;
+	bool have_xattr_dev = false;
 	u32 next = 0;
 
 	switch (tag) {
@@ -1152,13 +1153,24 @@ static void wsl_to_fattr(struct cifs_open_info_data *data,
 			fattr->cf_uid = wsl_make_kuid(cifs_sb, v);
 		else if (!strncmp(name, SMB2_WSL_XATTR_GID, nlen))
 			fattr->cf_gid = wsl_make_kgid(cifs_sb, v);
-		else if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen))
+		else if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen)) {
+			/* File type in reparse point tag and in xattr mode must match. */
+			if (S_DT(fattr->cf_mode) != S_DT(le32_to_cpu(*(__le32 *)v)))
+				return false;
 			fattr->cf_mode = (umode_t)le32_to_cpu(*(__le32 *)v);
-		else if (!strncmp(name, SMB2_WSL_XATTR_DEV, nlen))
+		} else if (!strncmp(name, SMB2_WSL_XATTR_DEV, nlen)) {
 			fattr->cf_rdev = reparse_mkdev(v);
+			have_xattr_dev = true;
+		}
 	} while (next);
 out:
+
+	/* Major and minor numbers for char and block devices are mandatory. */
+	if (!have_xattr_dev && (tag == IO_REPARSE_TAG_LX_CHR || tag == IO_REPARSE_TAG_LX_BLK))
+		return false;
+
 	fattr->cf_dtype = S_DT(fattr->cf_mode);
+	return true;
 }
 
 static bool posix_reparse_to_fattr(struct cifs_sb_info *cifs_sb,
@@ -1221,7 +1233,9 @@ bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
 	case IO_REPARSE_TAG_AF_UNIX:
 	case IO_REPARSE_TAG_LX_CHR:
 	case IO_REPARSE_TAG_LX_BLK:
-		wsl_to_fattr(data, cifs_sb, tag, fattr);
+		ok = wsl_to_fattr(data, cifs_sb, tag, fattr);
+		if (!ok)
+			return false;
 		break;
 	case IO_REPARSE_TAG_NFS:
 		ok = posix_reparse_to_fattr(cifs_sb, fattr, data);
-- 
2.20.1

