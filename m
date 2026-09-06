Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620643C09EE;
	Sun,  6 Sep 2026 19:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788721687; cv=none; b=jcPq02mirltCBsAPxA0Ea+eH3+bd6gwEqFcRlQEv4wkL2D1WW+d5zYXN5+xJoCOViuV7khasHWPXpQgc/ftnXrqilOi2m6k+vBHy8o7GZu9s0qTj5T3gCiH0j1HOj+dBpCT+R8sFLDkNdopLqDKwiNeat25+NtSllVbBnWo/CEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788721687; c=relaxed/simple;
	bh=oBDNTGYgepRxljjSoQnLCMvCkqERUpK6zDWGYrIuGpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKFEhuNMZtoWwAX+LRyfrO63RYBX4DTLyOFRDQgUOVZNMi3F73Gdxr+rTwDz+02ylP+LfAxLlqMhhxysa/LjuNninN+QTicGKo262Ay7it+T/CdI/s+wuHzC9IrxHs18X5hz2KgTnZn+tTioDoW+jg8CWGN62Ywqtcafbkr8BH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=d2+5vmBE; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="d2+5vmBE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=xthyXZ7jQEhlCjI5NR3fSmX75PGPoCaKjUqDlnr3DyQ=; b=d2+5vmBEpaoHZKM4nd/nZ8c8hx
	AWBQp/gF90whW2FOvX4ahPzWcducxEABbzUGxxUVTt3dT3RjQ4tZztwtVghuuPDTSvcZi/VYfR2tu
	iMtXptEFbhNKFVSdWqsPdO6j+1r09swCRgcuyLXfFTDSBNuZKkIaLjchtTKinVWngKvLt9mnro9eQ
	WG0kYPor7x4Ld5pcJA58OXrEwwOlETT5Cf3EE2nd3DJjcqN99G/5c3v4NH2M8QoDJ5KR23hYSV+Cv
	a5klF4UBpobF8JJRsBB/+Zg5xzB/2LHvffz6VIKE3wLfuFVBiljWKZj1kvGYt+YfZmRX5JUaHDKIq
	xRuF1ksw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x3IDk-00000000o5z-2iPW;
	Sun, 06 Sep 2026 16:08:04 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 3/7] smb: client: fix WSL reparse point uid/gid override
Date: Sun,  6 Sep 2026 16:07:59 -0300
Message-ID: <20260906190803.667489-3-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260906190803.667489-1-pc@manguebit.org>
References: <20260906190803.667489-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

wsl_to_fattr() unconditionally overwrites cf_uid/cf_gid with values
from WSL extended attributes ($LXUID/$LXGID), ignoring the
administrator's forceuid/forcegid mount options.  It also doesn't
initialize the uid/gid defaults, so callers that invoke it before
setting cf_uid/cf_gid (e.g. smb311_posix_info_to_fattr()) would
leave zeroed values when forceuid/forcegid is set.

Additionally, when UNIX or SMB3 POSIX extensions are negotiated, the
server already provides authoritative uid/gid and mode values through
the extensions themselves, making the WSL reparse point EA values
($LXUID, $LXGID, $LXMOD) redundant and potentially conflicting.

Fix this by:
  - Initializing cf_uid/cf_gid to the mount-specified linux_uid/
    linux_gid defaults
  - Gating the $LXUID/$LXGID EA parsing on CIFS_MOUNT_OVERR_UID/
    CIFS_MOUNT_OVERR_GID
  - Skipping $LXUID, $LXGID, and $LXMOD EA parsing entirely when
    UNIX or POSIX extensions are active (only $LXDEV is still
    parsed for device major/minor numbers)

Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/smb/client/reparse.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 5cc5b0410d48..10ef82d46d86 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1137,10 +1137,15 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 			 struct cifs_sb_info *cifs_sb,
 			 u32 tag, struct cifs_fattr *fattr)
 {
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
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
@@ -1177,11 +1182,26 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 		nlen = ea->ea_name_length;
 		v = (void *)((u8 *)ea->ea_data + ea->ea_name_length + 1);
 
-		if (!strncmp(name, SMB2_WSL_XATTR_UID, nlen))
-			fattr->cf_uid = wsl_make_kuid(cifs_sb, v);
-		else if (!strncmp(name, SMB2_WSL_XATTR_GID, nlen))
-			fattr->cf_gid = wsl_make_kgid(cifs_sb, v);
-		else if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen)) {
+		/*
+		 * Skip uid/gid/mode when UNIX or POSIX extensions are
+		 * active since the server provides these values through
+		 * the extensions themselves.
+		 */
+		if (tcon->unix_ext || tcon->posix_extensions) {
+			if (!strncmp(name, SMB2_WSL_XATTR_DEV, nlen)) {
+				fattr->cf_rdev = reparse_mkdev(v);
+				have_xattr_dev = true;
+			}
+			continue;
+		}
+
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

