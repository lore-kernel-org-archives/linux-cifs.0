Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C713BB13C
	for <linux-cifs@vger.kernel.org>; Sun,  6 Sep 2026 17:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788715210; cv=none; b=Fdh44z4zEX2+HuCLeYu4xUU8ygHPoHx1jdlEKVC8nmVuDArea8T7QElz5/7RoknNyu9Tun6JGiEZeWjxYwpjG99LlS4gGK34CZxaeUnjpUjydT0zouK5FQnNX54wYR9sh27JnT5kSl4rSoqX6M+AZxMA7KtPTD94ymGBi9x5HCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788715210; c=relaxed/simple;
	bh=7hugxxBdcOetw+5d8q0pidx4NXZ+3ItAXhF02agz+aY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BMrHmPjuupJE9zdOwL8u68P1xgK3f9EEGvgQurPB9VKcyAAaQcmt+wpjcv/VwUTK8ZjCxlxXsOtw2ShAMzW0b2PyYLC2/hqVjgX2mCJUGKd+b+uHm8H1GFtvnDYjLUIbhZYPFOCa5ZgZywtifCYlFu/jcHu8ZdimXmwN0vdXlY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=2e9O/+Xh; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="2e9O/+Xh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=PxihXhoGTeejWdnkjNzx8wvmGxAyzX/t2Q9xLt1CcJc=; b=2e9O/+Xh//04Azuf2gCa2mhKTU
	Q7P2y99cEu6f/JujGQ113KhEAmo2jcBA863+gqqKtAEWRRsBobx87q629FkDphLo2BzWnH711cxHb
	A/mgLQd09yLEB4KgLe/GpWwxHlA6zNinAwS/1i6TLf55yDzuXTeXX3j2kAWqnv+LLrUeJInwaRtn1
	bLf3rFi7xnMchZfllXBMa1iHW4atnVTVC9aaVHZk3ZN4BAAfzE7bQVmEgnQzKuFQmX2oXFqgWIkmt
	FAlPAfzlOEBsaD1rYFg9ufP7mHzD0SI7lCbW5N21lqxybs6x70znBZtlBphwBF6JSExVepyPtryNj
	q0O1/Y5Q==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x3GXG-00000000nmO-12M5;
	Sun, 06 Sep 2026 14:20:06 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/2] smb: client: honor forceuid/forcegid when mapping SIDs to uid/gid
Date: Sun,  6 Sep 2026 14:20:04 -0300
Message-ID: <20260906172005.627163-1-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the administrator mounts with forceuid or forcegid (uid=/gid=
mount options), they expect all files to appear owned by the specified
user/group.  However, several code paths unconditionally called
sid_to_id() to overwrite cf_uid/cf_gid with server-provided values,
ignoring the administrator's explicit override:

  - smb311_posix_info_to_fattr() (stat via POSIX extensions)
  - cifs_posix_to_fattr() (readdir via POSIX extensions)
  - parse_sec_desc() (CIFS ACL ownership mapping)

This allowed an untrusted server to dictate local file ownership even
when the mount was configured to force specific uid/gid values.

Fix all three call sites to check CIFS_MOUNT_OVERR_UID and
CIFS_MOUNT_OVERR_GID before calling sid_to_id(), following the
same pattern already used by cifs_unix_basic_to_fattr() for unix
extensions.

Closes: https://sashiko.dev/#/patchset/20260906155816.603278-1-pc%40manguebit.org
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/client/cifsacl.c | 29 ++++++++++++++++++-----------
 fs/smb/client/inode.c   |  9 +++++++--
 fs/smb/client/readdir.c |  9 +++++++--
 3 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 213a421bf8e9..def8908dd7e9 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1346,6 +1346,7 @@ static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
 {
 	int rc = 0;
 	struct smb_sid *owner_sid_ptr, *group_sid_ptr;
+	unsigned int sbflags = cifs_sb_flags(cifs_sb);
 	struct smb_acl *dacl_ptr; /* no need for SACL ptr */
 	char *end_of_acl;
 	__u32 dacloffset, osidoffset, gsidoffset;
@@ -1364,17 +1365,21 @@ static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
 	cifs_dbg(NOISY, "revision %d type 0x%x ooffset 0x%x goffset 0x%x sacloffset 0x%x dacloffset 0x%x\n",
 		 pntsd->revision, pntsd->type, osidoffset, gsidoffset,
 		 le32_to_cpu(pntsd->sacloffset), dacloffset);
-/*	cifs_dump_mem("owner_sid: ", owner_sid_ptr, 64); */
+	fattr->cf_uid = cifs_sb->ctx->linux_uid;
+	fattr->cf_gid = cifs_sb->ctx->linux_gid;
+
 	rc = sid_from_sd(pntsd, acl_len, osidoffset, &owner_sid_ptr);
 	if (rc) {
 		cifs_dbg(FYI, "%s: Error %d parsing Owner SID\n", __func__, rc);
 		return rc;
 	}
-	rc = sid_to_id(cifs_sb, owner_sid_ptr, fattr, SIDOWNER);
-	if (rc) {
-		cifs_dbg(FYI, "%s: Error %d mapping Owner SID to uid\n",
-			 __func__, rc);
-		return rc;
+	if (!(sbflags & CIFS_MOUNT_OVERR_UID)) {
+		rc = sid_to_id(cifs_sb, owner_sid_ptr, fattr, SIDOWNER);
+		if (rc) {
+			cifs_dbg(FYI, "%s: Error %d mapping Owner SID to uid\n",
+				 __func__, rc);
+			return rc;
+		}
 	}
 
 	rc = sid_from_sd(pntsd, acl_len, gsidoffset, &group_sid_ptr);
@@ -1383,11 +1388,13 @@ static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
 			 __func__, rc);
 		return rc;
 	}
-	rc = sid_to_id(cifs_sb, group_sid_ptr, fattr, SIDGROUP);
-	if (rc) {
-		cifs_dbg(FYI, "%s: Error %d mapping Group SID to gid\n",
-			 __func__, rc);
-		return rc;
+	if (!(sbflags & CIFS_MOUNT_OVERR_GID)) {
+		rc = sid_to_id(cifs_sb, group_sid_ptr, fattr, SIDGROUP);
+		if (rc) {
+			cifs_dbg(FYI, "%s: Error %d mapping Group SID to gid\n",
+				 __func__, rc);
+			return rc;
+		}
 	}
 
 	if (dacloffset) {
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 49f9993ad567..1fe0ef0a95db 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -851,6 +851,7 @@ static void smb311_posix_info_to_fattr(struct cifs_fattr *fattr,
 	struct smb311_posix_qinfo *info = &data->posix_fi;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	unsigned int sbflags = cifs_sb_flags(cifs_sb);
 
 	memset(fattr, 0, sizeof(*fattr));
 
@@ -895,8 +896,12 @@ static void smb311_posix_info_to_fattr(struct cifs_fattr *fattr,
 		fattr->cf_symlink_target = data->symlink_target;
 		data->symlink_target = NULL;
 	}
-	sid_to_id(cifs_sb, &data->posix_owner, fattr, SIDOWNER);
-	sid_to_id(cifs_sb, &data->posix_group, fattr, SIDGROUP);
+	fattr->cf_uid = cifs_sb->ctx->linux_uid;
+	fattr->cf_gid = cifs_sb->ctx->linux_gid;
+	if (!(sbflags & CIFS_MOUNT_OVERR_UID))
+		sid_to_id(cifs_sb, &data->posix_owner, fattr, SIDOWNER);
+	if (!(sbflags & CIFS_MOUNT_OVERR_GID))
+		sid_to_id(cifs_sb, &data->posix_group, fattr, SIDGROUP);
 
 	cifs_dbg(FYI, "POSIX query info: mode 0x%x uniqueid 0x%llx nlink %d\n",
 		fattr->cf_mode, fattr->cf_uniqueid, fattr->cf_nlink);
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 32a75afca8f5..1ea84f4ada39 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -242,6 +242,7 @@ static void
 cifs_posix_to_fattr(struct cifs_fattr *fattr, struct smb2_posix_info *info,
 		    struct cifs_sb_info *cifs_sb)
 {
+	unsigned int sbflags = cifs_sb_flags(cifs_sb);
 	struct smb2_posix_info_parsed parsed;
 
 	posix_info_parse(info, NULL, &parsed);
@@ -281,8 +282,12 @@ cifs_posix_to_fattr(struct cifs_fattr *fattr, struct smb2_posix_info *info,
 		 le32_to_cpu(info->ReparseTag),
 		 le32_to_cpu(info->Mode));
 
-	sid_to_id(cifs_sb, &parsed.owner, fattr, SIDOWNER);
-	sid_to_id(cifs_sb, &parsed.group, fattr, SIDGROUP);
+	fattr->cf_uid = cifs_sb->ctx->linux_uid;
+	fattr->cf_gid = cifs_sb->ctx->linux_gid;
+	if (!(sbflags & CIFS_MOUNT_OVERR_UID))
+		sid_to_id(cifs_sb, &parsed.owner, fattr, SIDOWNER);
+	if (!(sbflags & CIFS_MOUNT_OVERR_GID))
+		sid_to_id(cifs_sb, &parsed.group, fattr, SIDGROUP);
 }
 
 static void __dir_info_to_fattr(struct cifs_fattr *fattr, const void *info)
-- 
2.55.0

