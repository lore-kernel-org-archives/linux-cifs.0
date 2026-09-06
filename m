Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BDB3B14D4
	for <linux-cifs@vger.kernel.org>; Sun,  6 Sep 2026 17:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788715210; cv=none; b=OFSWDLNeMijD6rodmNj/+rjLHcL81g2iDYuD/lr2XdozlxXsa4hma15sxq96xk3Ysc5bPIz7wR05r4lwdDgkGZftsD+2R0eMnKt1GJAQR4A/n1Gj4/D884HFj+YR2fhY+WisBfc1qb+aunmSZPWhIEmql5YFoAAZaC8PTlZM2C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788715210; c=relaxed/simple;
	bh=iPXUBHV3BY4cWUPZkt+JcUGjxJQuquufontU5rDB3kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XU8r4pmgf4YGstqVjIY9tMzAIWw/bK5l7h4AztIkUDjCTEwHsdQeXIMAs+uV3V70ehzmsBsUMe+lmWf9M1Ne9bv7hwxG4p9lHQVS6Djli7OcoSIPuFr5EGBNLz/EN/0AAS3Z31rKrY16W0F1Tbb8Qjvo2XE1qat2BS4mBssmWwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=Q5cNFJ7h; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="Q5cNFJ7h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=7SGnl3yi2+jc1vgQzFQZmlPZagVHJgyHcr3Y5ZQ2kII=; b=Q5cNFJ7hiO2imJj4x0cf4RoJHT
	FG89HCmj25VfytkBJGsvJ1VtivFc3QQCJUdMs0t18QOlpK0KTpLpF8dnnhuWAa7ufzpUelRpXqX0J
	T2QZFYOAFm7F7LLHotqwHBdB+dXRjVomecVRidmp17S9Vgc5CxNhOylcycI1Qm9RZzvq4EExsr+Kv
	1Wx4fT0KrQsiovkKzOQiRWBz68s4MmDhLAceBetyxPIgF4l4jNWNQqZ6UNr5gcBDqDROP1HRdOREs
	PEh0zpZlwGlbhAhFsCFjy/2Qd2Iw3wOzZyV4ERsv5Sx6Mr57bkRdm0klQ+GYqBU23gC9C0nIbMapS
	nTUXJ7MA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x3GXG-00000000nmY-2Sxb;
	Sun, 06 Sep 2026 14:20:06 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/2] smb: client: fix WSL reparse point uid/gid override
Date: Sun,  6 Sep 2026 14:20:05 -0300
Message-ID: <20260906172005.627163-2-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260906172005.627163-1-pc@manguebit.org>
References: <20260906172005.627163-1-pc@manguebit.org>
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
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
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

