Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87981A6836;
	Sun,  6 Sep 2026 20:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788725121; cv=none; b=OSw94uXvndZddMX0SxocRTi8AXIRj23TE/x47rvzHji5a/BCbnKgYQXoYSVByU0MoUuKwH6ALnXE2cEPUTbYg3RNCZwAXFBLcVPiYi6XAepNG3eOONe4SGSJawS7Ah3pXbqBGHslhqFbVFjx5GGqp42/yHIs1nBgnLwstK0bTe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788725121; c=relaxed/simple;
	bh=HP1lFz9eU+mWUq/LjtfMoyOids3h6RXUlSg28aacxok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6zidqamCl2f1E5QDbrhFTT+l/NObhnWBUgrQuKbYZa0QH4LwguYTbfIdGweOtrlDvfHdbn+J7/Cj224KDHL7/cet0f04z6RkVk5+jbI7cdjTGy/qyi3wSSorZ3C1AGX4Uft7QEEF/K+NfQWoqbsCp5p0Oo4ZU2KY0KhficcCsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=HIAK+tK/; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="HIAK+tK/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=/3/PLT4vod6EZNF3JPooi6HoQuTw2E59kYv8JNDCl6g=; b=HIAK+tK/sgJd4AOtTpTse75NUA
	aN+QaL9hVm1Wfwd+U/+sWptQuqLaDlsPCsJc025ZbuiLg+MmXXfOa91HN+FqlReHGadoZ9Ven1GCe
	phyR3kvk1Vdx2+OZlncrpE8SLmqfZ8AVRC/JTRDCjvxjPyEfxev4v+HmuUOfjwhVDdjTqYjuHnTAV
	bFDOPCkD0ytqLhp0h5VBW0U5cG7HuLjUq0QVUo/XLvwH/JNRi2ee0YpY9xHnizSJDeo98/0du+87b
	3eW7Ly24bVlKKnbfEeMABYjtbtOgK4FdT2C34kReCGEhhGsRpHL8qb540XOyupc9nozoOyYNNvbV+
	MLXSQVlg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x3J78-00000000oE6-0cLa;
	Sun, 06 Sep 2026 17:05:18 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v4 3/7] smb: client: fix WSL reparse point uid/gid override
Date: Sun,  6 Sep 2026 17:05:13 -0300
Message-ID: <20260906200517.725015-3-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260906200517.725015-1-pc@manguebit.org>
References: <20260906200517.725015-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

wsl_to_fattr() unconditionally overwrites cf_uid/cf_gid with values
from WSL extended attributes ($LXUID/$LXGID), ignoring the forceuid
and forcegid mount options.

Fix this by initializing cf_uid/cf_gid to the mount defaults and
gating the $LXUID/$LXGID EA parsing on forceuid/forcegid.

Closes: https://sashiko.dev/#/patchset/20260906190803.667489-1-pc%40manguebit.org
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/smb/client/reparse.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 5cc5b0410d48..178da801e775 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1137,10 +1137,14 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 			 struct cifs_sb_info *cifs_sb,
 			 u32 tag, struct cifs_fattr *fattr)
 {
+	unsigned int sbflags = cifs_sb_flags(cifs_sb);
 	struct smb2_file_full_ea_info *ea;
 	bool have_xattr_dev = false;
 	u32 next = 0;
 
+	fattr->cf_uid = cifs_sb->ctx->linux_uid;
+	fattr->cf_gid = cifs_sb->ctx->linux_gid;
+
 	switch (tag) {
 	case IO_REPARSE_TAG_LX_SYMLINK:
 		fattr->cf_mode |= S_IFLNK;
@@ -1177,11 +1181,13 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 		nlen = ea->ea_name_length;
 		v = (void *)((u8 *)ea->ea_data + ea->ea_name_length + 1);
 
-		if (!strncmp(name, SMB2_WSL_XATTR_UID, nlen))
-			fattr->cf_uid = wsl_make_kuid(cifs_sb, v);
-		else if (!strncmp(name, SMB2_WSL_XATTR_GID, nlen))
-			fattr->cf_gid = wsl_make_kgid(cifs_sb, v);
-		else if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen)) {
+		if (!strncmp(name, SMB2_WSL_XATTR_UID, nlen)) {
+			if (!(sbflags & CIFS_MOUNT_OVERR_UID))
+				fattr->cf_uid = wsl_make_kuid(cifs_sb, v);
+		} else if (!strncmp(name, SMB2_WSL_XATTR_GID, nlen)) {
+			if (!(sbflags & CIFS_MOUNT_OVERR_GID))
+				fattr->cf_gid = wsl_make_kgid(cifs_sb, v);
+		} else if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen)) {
 			/* File type in reparse point tag and in xattr mode must match. */
 			if (S_DT(fattr->cf_mode) != S_DT(le32_to_cpu(*(__le32 *)v)))
 				return false;
-- 
2.55.0

