Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27065111BE;
	Thu, 17 Sep 2026 13:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789650241; cv=none; b=g5KMw6lnlnitxFSisVGgeWltfLbCAhNb2Z8shDVlDSnMHd5blmgOVhSHP52hG8PfjauHQEJC5tpRDQhgWjBKKoGWD0qU69F75n3mInJKvzXOM6pxAMCClDpZwkSg90wG+rAwZYA03Z/t8gmH1hN+BJOYlTEI8BfPgJ6yW/ld2gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789650241; c=relaxed/simple;
	bh=6/1H1KJvKE+jMYVj5fpw4BU1vGx1ddvCXn8hOW+KAZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2SbE6PYqdh+6sauHKSlCmw49KM25nm0dYmuYTSHJTRrrgRIdfKj9cqG1iLPRWNKlbirh1JPlfAmQvSOTAAaUvBEqp7qLfp/ZakY6gcA8JvpDr5iS/wqZzzlDlojAvT1GSSe8kGEiyhGol6Q8MijnawdYUsodlkmAhKQqoXoSJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=en+t0+Ow; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="en+t0+Ow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC321F00898;
	Thu, 17 Sep 2026 13:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789650230;
	bh=EO6Oy7ZsI8xjPivzeua5l32Qq3nr2jrDA+kt66F7lbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=en+t0+Ow+xUbVduhnmABQ+byWB/lG8zRu14OAecqehuNT4cgkjN2UilAByopSPEBW
	 n9WpjTm49timWboAlS971fT67bQf4dSW6AOJN1NXVGbF+ZfbsiTnv4Gcg5XAFyHlso
	 kHK4uK1WtF7c3/3IPqwDMwgorR+5ueZoQmA2bPx/vMwEmMkicpgh7SL1KXGxVNieFf
	 ByroZTb0s4ujekSSHOpB2GiSsQv5QhKjZ9bhJ2c5PjR974ykOvtDe1tEKqopDrFXnt
	 8HfvLl6LRpsWU8E2VprYyuwwR240Quv0Z1bpEWQDI7YcPtNPFCRoe923ZLhjVYJ3nR
	 SwbS3LeUdK7dQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6.y 1/2] smb: client: use atomic_t for mnt_cifs_flags
Date: Thu, 17 Sep 2026 09:03:47 -0400
Message-ID: <20260917130348.320328-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026091605-runaround-justness-9c84@gregkh>
References: <2026091605-runaround-justness-9c84@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 4fc3a433c13944ee5766ec5b9bf6f1eb4d29b880 ]

Use atomic_t for cifs_sb_info::mnt_cifs_flags as it's currently
accessed locklessly and may be changed concurrently in mount/remount
and reconnect paths.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>

[Stable dependency adaptation for 18a72975e9f35]

Keep only the prerequisites needed by the forceuid/forcegid fix.  On 6.18,
provide cifs_sb_flags as a READ_ONCE macro over the existing unsigned int
field; do not import the tree-wide atomic_t conversion, generic CIFS_SB
helpers, moved functions, or newer oplock/reconnect code.

The target also expects the SID lookup interface introduced upstream by
29f1005b8b4d3.  Rename and adapt the existing parse_sid implementation to
sid_from_sd, with descriptor/offset/full-SID bounds checks, and update
parse_sec_desc to the target's expected context.  This keeps the existing
number of functions and preserves the stable DACL validation.  No new
function is added, and the ownership override fix remains in the target.

[ sashal: Reduced backport -- upstream 4fc3a433c1394 touches 27 file(s), this
  backport carries 2. Not backported here:
  fs/smb/client/cached_dir.c
  fs/smb/client/cifsfs.c
  fs/smb/client/cifs_fs_sb.h
  fs/smb/client/cifs_ioctl.h
  fs/smb/client/cifs_unicode.c
  fs/smb/client/cifs_unicode.h
  fs/smb/client/connect.c
  fs/smb/client/dfs_cache.c
  ... and 17 more
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: 18a72975e9f3 ("smb: client: honor forceuid/forcegid when mapping SIDs to uid/gid")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsacl.c  | 54 ++++++++++++++++++++++++++--------------
 fs/smb/client/cifsglob.h |  3 +++
 2 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 230b98b3a272c..af6f746f68256 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1233,13 +1233,30 @@ static int set_chmod_dacl(struct smb_acl *pdacl, struct smb_acl *pndacl,
 	return 0;
 }
 
-static int parse_sid(struct smb_sid *psid, char *end_of_acl)
+static int sid_from_sd(const struct smb_ntsd *pntsd, __u32 secdesclen,
+		       __u32 sid_offset, struct smb_sid **sid)
 {
-	/* BB need to add parm so we can store the SID BB */
+	struct smb_sid *psid;
+	unsigned int sid_len;
 
-	/* validate that we do not go past end of ACL - sid must be at least 8
-	   bytes long (assuming no sub-auths - e.g. the null SID */
-	if (end_of_acl < (char *)psid + 8) {
+	if (secdesclen < sizeof(struct smb_ntsd)) {
+		cifs_dbg(VFS, "ACL too small to parse security descriptor\n");
+		return -EINVAL;
+	}
+	if (sid_offset < sizeof(struct smb_ntsd) ||
+	    sid_offset > secdesclen - CIFS_SID_BASE_SIZE) {
+		cifs_dbg(VFS, "Server returned illegal SID offset\n");
+		return -EINVAL;
+	}
+
+	psid = (struct smb_sid *)((char *)pntsd + sid_offset);
+	if (psid->num_subauth > SID_MAX_SUB_AUTHORITIES) {
+		cifs_dbg(VFS, "SID contains too many subauthorities %u\n",
+			 psid->num_subauth);
+		return -EINVAL;
+	}
+	sid_len = CIFS_SID_BASE_SIZE + psid->num_subauth * sizeof(__le32);
+	if (sid_len > secdesclen - sid_offset) {
 		cifs_dbg(VFS, "ACL too small to parse SID %p\n", psid);
 		return -EINVAL;
 	}
@@ -1255,13 +1272,12 @@ static int parse_sid(struct smb_sid *psid, char *end_of_acl)
 				 i, le32_to_cpu(psid->sub_auth[i]));
 		}
 
-		/* BB add length check to make sure that we do not have huge
-			num auths and therefore go off the end */
 		cifs_dbg(FYI, "RID 0x%x\n",
 			 le32_to_cpu(psid->sub_auth[psid->num_subauth-1]));
 	}
 #endif
 
+	*sid = psid;
 	return 0;
 }
 
@@ -1285,23 +1301,25 @@ static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
 	int rc = 0;
 	struct smb_sid *owner_sid_ptr, *group_sid_ptr;
 	struct smb_acl *dacl_ptr; /* no need for SACL ptr */
-	char *end_of_acl = ((char *)pntsd) + acl_len;
-	__u32 dacloffset;
+	char *end_of_acl;
+	__u32 dacloffset, osidoffset, gsidoffset;
 
 	if (pntsd == NULL)
 		return -EIO;
+	if (acl_len < (int)sizeof(struct smb_ntsd)) {
+		cifs_dbg(VFS, "ACL too small to parse security descriptor\n");
+		return -EINVAL;
+	}
+	end_of_acl = ((char *)pntsd) + acl_len;
 
-	owner_sid_ptr = (struct smb_sid *)((char *)pntsd +
-				le32_to_cpu(pntsd->osidoffset));
-	group_sid_ptr = (struct smb_sid *)((char *)pntsd +
-				le32_to_cpu(pntsd->gsidoffset));
+	osidoffset = le32_to_cpu(pntsd->osidoffset);
+	gsidoffset = le32_to_cpu(pntsd->gsidoffset);
 	dacloffset = le32_to_cpu(pntsd->dacloffset);
 	cifs_dbg(NOISY, "revision %d type 0x%x ooffset 0x%x goffset 0x%x sacloffset 0x%x dacloffset 0x%x\n",
-		 pntsd->revision, pntsd->type, le32_to_cpu(pntsd->osidoffset),
-		 le32_to_cpu(pntsd->gsidoffset),
+		 pntsd->revision, pntsd->type, osidoffset, gsidoffset,
 		 le32_to_cpu(pntsd->sacloffset), dacloffset);
 /*	cifs_dump_mem("owner_sid: ", owner_sid_ptr, 64); */
-	rc = parse_sid(owner_sid_ptr, end_of_acl);
+	rc = sid_from_sd(pntsd, acl_len, osidoffset, &owner_sid_ptr);
 	if (rc) {
 		cifs_dbg(FYI, "%s: Error %d parsing Owner SID\n", __func__, rc);
 		return rc;
@@ -1313,9 +1331,9 @@ static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
 		return rc;
 	}
 
-	rc = parse_sid(group_sid_ptr, end_of_acl);
+	rc = sid_from_sd(pntsd, acl_len, gsidoffset, &group_sid_ptr);
 	if (rc) {
-		cifs_dbg(FYI, "%s: Error %d mapping Owner SID to gid\n",
+		cifs_dbg(FYI, "%s: Error %d parsing Group SID\n",
 			 __func__, rc);
 		return rc;
 	}
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index a4e0618c58efc..de86aaeb972b6 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1603,6 +1603,9 @@ CIFS_FILE_SB(struct file *file)
 	return CIFS_SB(file_inode(file)->i_sb);
 }
 
+/* The stable tree retains unsigned int storage for the mount flags. */
+#define cifs_sb_flags(cifs_sb) READ_ONCE((cifs_sb)->mnt_cifs_flags)
+
 static inline char CIFS_DIR_SEP(const struct cifs_sb_info *cifs_sb)
 {
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
-- 
2.53.0

