Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94173911B2;
	Thu, 17 Sep 2026 15:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789657337; cv=none; b=klTYLC+GqSAqrXKlZ5HFi+V2ugntYDq+kSRBkYdcLPMt9pKfUb62KkTE38yqxSddixXnW1RtSDeyY5ctgKSwUIHbrXfD4ei0qDf9TUkczjDkqjyz1sX5QgVRVywhH8yoKcxR0pIRKpJOrEdElqaoZ26wT7XRbjd8mMxwVS0L+BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789657337; c=relaxed/simple;
	bh=43pJyrNjHLx07NxgLI8U+deIXV1NzjbrNRkIGcxBfVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XIL9b3VA1JNVjxURJsG6AD1f5tovZcERu95KFAkUwTnOCHeNaGk6pz0cMjKfkfrjW4lBIWa3PkAQBTZ9CGCzwwg/uUoVYZ2KPEB9zyCJyXPLRZoDvaXFvlMVhxLJKrCeOPYRulXRxwAcH0lfJNziwnLZl+G85B7/cGoKjT32yO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A+p+oCPg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A+p+oCPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EA21F008A0;
	Thu, 17 Sep 2026 15:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789657312;
	bh=ySjWueXw8pWExDbtl1Dj0mrYPDgA1mvnE341PxjW03k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A+p+oCPgqgkkX0AfjIvfEFduDVbEOJxl9ouMZwYWVTuJNW3vrm5ZxHPK2UTWUfXjd
	 WoKMKoFKjV+tX7iwkGzjaErZ3HlOkZKvB/rOvyVh+0EuWpB8GKCMZtF1epDXK3R1bW
	 1XSt7rBVF+PT8hCwMr2ty3XXFWAgjpr7nDlREPV0UpYcsgw3lHkpZutll7gLf/3LG2
	 Y8UgOuLQix5NJ8gdCaEHWL42XnxYf0VZkj74A5GYnxQZsp1/3QGHnIUwok9CC5AUf5
	 brdZJGI40mGJruD63QEXZdRzeIGdVyyEbraSSXSFJSpQNY9LB49bn2yQ1+5iDunrzj
	 TBRVyyTWYHv6Q==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12.y 1/2] smb: client: use atomic_t for mnt_cifs_flags
Date: Thu, 17 Sep 2026 11:01:48 -0400
Message-ID: <20260917150149.671513-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026091628-armored-debtless-c6d4@gregkh>
References: <2026091628-armored-debtless-c6d4@gregkh>
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

Backport notes for the dependency of da6e258424319:

Limit this stable backport to the mount-flag accessor needed by the
subsequent readdir fix. Keep mnt_cifs_flags as unsigned int and implement
cifs_sb_flags() as a READ_ONCE macro, adding no functions. The full atomic_t
conversion, generic CIFS_SB helpers, and unrelated call-site changes are
not needed for the target and depend on newer CIFS refactoring.

Include the cifs_posix_to_fattr() portion of 18a72975e9f35 ("smb: client:
honor forceuid/forcegid when mapping SIDs to uid/gid"): snapshot the flags,
initialize cf_uid/cf_gid from the mount context, and respect the override
bits before mapping SIDs. This supplies the target's exact patch context
and the fallback ownership values it needs when SID parsing fails.

The SID parse-error check itself remains in da6e258424319; this dependency
does not apply that target fix.

[ sashal: Reduced backport -- upstream 4fc3a433c1394 touches 27 file(s), this
  backport carries 2. Not backported here:
  fs/smb/client/cached_dir.c
  fs/smb/client/cifsacl.c
  fs/smb/client/cifsfs.c
  fs/smb/client/cifs_fs_sb.h
  fs/smb/client/cifs_ioctl.h
  fs/smb/client/cifs_unicode.c
  fs/smb/client/cifs_unicode.h
  fs/smb/client/connect.c
  ... and 17 more
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: da6e25842431 ("smb: client: avoid using uninitialized SIDs in cifs_posix_to_fattr()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h | 2 ++
 fs/smb/client/readdir.c  | 9 +++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 3f9c03828cd4f..06c08a3ee66fc 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1563,6 +1563,8 @@ CIFS_FILE_SB(struct file *file)
 	return CIFS_SB(file_inode(file)->i_sb);
 }
 
+#define cifs_sb_flags(cifs_sb) READ_ONCE((cifs_sb)->mnt_cifs_flags)
+
 static inline char CIFS_DIR_SEP(const struct cifs_sb_info *cifs_sb)
 {
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 7bf3214117a91..9888756fff888 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -241,6 +241,7 @@ static void
 cifs_posix_to_fattr(struct cifs_fattr *fattr, struct smb2_posix_info *info,
 		    struct cifs_sb_info *cifs_sb)
 {
+	unsigned int sbflags = cifs_sb_flags(cifs_sb);
 	struct smb2_posix_info_parsed parsed;
 
 	posix_info_parse(info, NULL, &parsed);
@@ -280,8 +281,12 @@ cifs_posix_to_fattr(struct cifs_fattr *fattr, struct smb2_posix_info *info,
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
2.53.0

