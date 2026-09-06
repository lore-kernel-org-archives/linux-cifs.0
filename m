Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFE13546EA;
	Sun,  6 Sep 2026 18:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788718544; cv=none; b=crWw/wMffTedqtbGVMDiucWvE6rrN/b3G6fcz76F0Ujq4uPUspdv3BK98TyCu92Nr977yaNUoNPRo5C3Z1M3D5VqWPLoqDulFoHzRGafIDBsHe50TKY+kUrDvKGB8DktgIJW9YDxjrVi43z6nBSgYiqCuNFk02Zfqpvv3s8lCmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788718544; c=relaxed/simple;
	bh=oBDNTGYgepRxljjSoQnLCMvCkqERUpK6zDWGYrIuGpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKWkkv3bTSZRSmewlLwQonmzYMOv2rclDcAoDIm22kfjI+mK3zEEnTtIgP1pWBWbU3/OjllV9WoKE/DcbKixVBN0hwBmIRaN0s6aiINYeCvfO1EPNvNbmHA2MgWFm3wfIHfvfp36l6EQINf66yI1dDd3VSmbjVqUa/mrb53QwlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=B9z6uzXD; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="B9z6uzXD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=xthyXZ7jQEhlCjI5NR3fSmX75PGPoCaKjUqDlnr3DyQ=; b=B9z6uzXDMcgnQnKprLmPrbZ4/J
	PQrAYp8DrNggx9E+aXABCp6eBfMFdJX61VRjupb4AYFS7M162+N+UBryQPcZGAJul2gtaU6Upp58d
	0Or7l2sQ18bxnThrM3ZW9S5oqPPTAtHwhp726gJrqGWqKBUezXJamYC5IXezX7wn4QETVR2o1hCTB
	5F8Fu4803gVM2clrdxj/sjM9L3gR3qY36PhD1FsOlX89gD/jYYvdFGsk/EFbQ1huWvxIFiR0Nik8Z
	ygQAukoA9+yCB0vVIcLEzGd36fRLrQXtAaKbQMSM/x+7yFg6d1HzTScvLq3uUSk8Xu+285l1FBdwt
	rGVHkdmg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x3HP3-00000000nxG-2YCI;
	Sun, 06 Sep 2026 15:15:41 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 3/5] smb: client: fix WSL reparse point uid/gid override
Date: Sun,  6 Sep 2026 15:15:38 -0300
Message-ID: <20260906181540.647469-3-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260906181540.647469-1-pc@manguebit.org>
References: <20260906181540.647469-1-pc@manguebit.org>
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

