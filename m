Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E55E19A288;
	Fri, 24 Apr 2026 13:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037554; cv=none; b=Pry3jmW2qbndLfXkZhpOLa+lC31rDMyKeVfEWvy/cvoQjGgPulq9ZXhSRpa0+B3rdeEPCu1Ui/2SXM6PqxMX7XD+egWlp03FCki5SmHyUkVkVXZXaHZdgQl1/FLv3MyCjmBpwzYP0gV2/Y4wQV7uWfZRkYSpOmUxLe2SqOq+4U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037554; c=relaxed/simple;
	bh=LGG/041ZELxwyWk2X2Jw7rQ9sLZN7rA+qjLbrZUnTwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oa9FaBSJ/UcgzYAqyDSW6+PGnlkfnfZC6eib5WSEArGF2D46aGPdHWCV/2H1U4x+atMap6RKu47g/h9WvLalDiiMDVeIqdD8P7L46wPO19bvAC3BMvtTfFNHJeZNx80Hb+jlt6bokJXiD6riQceQqQEtEaGdDwoImxyMql99t5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fM5OCurn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fM5OCurn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0ADC19425;
	Fri, 24 Apr 2026 13:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037554;
	bh=LGG/041ZELxwyWk2X2Jw7rQ9sLZN7rA+qjLbrZUnTwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fM5OCurny2u2tbQsYK29HdJginQDJl10bhmgDC2GWS+1PXO7TBdBu8QYZ+Pw7FaeJ
	 OyUi6y55hHh0L4ua6QFabgB4zuCljCx4H1zKIvPOkOUMWvz5zzXZFE6Yd+evf23BJM
	 pIzw/DIh18ZR9RO9y0V/ofGGsxt+qx8ftsY+KJ9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kris Karas (Bug Reporting)" <bugs-a21@moonlit-rail.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.0 22/42] smb: client: fix dir separator in SMB1 UNIX mounts
Date: Fri, 24 Apr 2026 15:30:47 +0200
Message-ID: <20260424132425.073615531@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
References: <20260424132420.410310336@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit c4d3fc5844d685441befd0caaab648321013cdfd upstream.

When calling cifs_mount_get_tcon() with SMB1 UNIX mounts,
@cifs_sb->mnt_cifs_flags needs to be read or updated only after
calling reset_cifs_unix_caps(), otherwise it might end up with missing
CIFS_MOUNT_POSIXACL and CIFS_MOUNT_POSIX_PATHS bits.

This fixes the wrong dir separator used in paths caused by the missing
CIFS_MOUNT_POSIX_PATHS bit in cifs_sb_info::mnt_cifs_flags.

Reported-by: "Kris Karas (Bug Reporting)" <bugs-a21@moonlit-rail.com>
Closes: https://lore.kernel.org/r/f758f4ff-4d54-4244-931d-38f469c3ff14@moonlit-rail.com
Fixes: 4fc3a433c139 ("smb: client: use atomic_t for mnt_cifs_flags")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |   10 +++++-----
 fs/smb/client/smb1ops.c |   19 ++++++++-----------
 2 files changed, 13 insertions(+), 16 deletions(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3610,7 +3610,6 @@ int cifs_mount_get_tcon(struct cifs_moun
 	server = mnt_ctx->server;
 	ctx = mnt_ctx->fs_ctx;
 	cifs_sb = mnt_ctx->cifs_sb;
-	sbflags = cifs_sb_flags(cifs_sb);
 
 	/* search for existing tcon to this server share */
 	tcon = cifs_get_tcon(mnt_ctx->ses, ctx);
@@ -3625,9 +3624,10 @@ int cifs_mount_get_tcon(struct cifs_moun
 	 * path (i.e., do not remap / and \ and do not map any special characters)
 	 */
 	if (tcon->posix_extensions) {
-		sbflags |= CIFS_MOUNT_POSIX_PATHS;
-		sbflags &= ~(CIFS_MOUNT_MAP_SFM_CHR |
-			     CIFS_MOUNT_MAP_SPECIAL_CHR);
+		atomic_or(CIFS_MOUNT_POSIX_PATHS, &cifs_sb->mnt_cifs_flags);
+		atomic_andnot(CIFS_MOUNT_MAP_SFM_CHR |
+			      CIFS_MOUNT_MAP_SPECIAL_CHR,
+			      &cifs_sb->mnt_cifs_flags);
 	}
 
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
@@ -3651,6 +3651,7 @@ int cifs_mount_get_tcon(struct cifs_moun
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 		tcon->unix_ext = 0; /* server does not support them */
 
+	sbflags = cifs_sb_flags(cifs_sb);
 	/* do not care if a following call succeed - informational */
 	if (!tcon->pipe && server->ops->qfs_tcon) {
 		server->ops->qfs_tcon(mnt_ctx->xid, tcon, cifs_sb);
@@ -3675,7 +3676,6 @@ int cifs_mount_get_tcon(struct cifs_moun
 
 out:
 	mnt_ctx->tcon = tcon;
-	atomic_set(&cifs_sb->mnt_cifs_flags, sbflags);
 	return rc;
 }
 
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -49,7 +49,6 @@ void reset_cifs_unix_caps(unsigned int x
 
 	if (!CIFSSMBQFSUnixInfo(xid, tcon)) {
 		__u64 cap = le64_to_cpu(tcon->fsUnixInfo.Capability);
-		unsigned int sbflags;
 
 		cifs_dbg(FYI, "unix caps which server supports %lld\n", cap);
 		/*
@@ -76,29 +75,27 @@ void reset_cifs_unix_caps(unsigned int x
 		if (cap & CIFS_UNIX_TRANSPORT_ENCRYPTION_MANDATORY_CAP)
 			cifs_dbg(VFS, "per-share encryption not supported yet\n");
 
-		if (cifs_sb)
-			sbflags = cifs_sb_flags(cifs_sb);
-
 		cap &= CIFS_UNIX_CAP_MASK;
 		if (ctx && ctx->no_psx_acl)
 			cap &= ~CIFS_UNIX_POSIX_ACL_CAP;
 		else if (CIFS_UNIX_POSIX_ACL_CAP & cap) {
 			cifs_dbg(FYI, "negotiated posix acl support\n");
-			if (cifs_sb)
-				sbflags |= CIFS_MOUNT_POSIXACL;
+			if (cifs_sb) {
+				atomic_or(CIFS_MOUNT_POSIXACL,
+					  &cifs_sb->mnt_cifs_flags);
+			}
 		}
 
 		if (ctx && ctx->posix_paths == 0)
 			cap &= ~CIFS_UNIX_POSIX_PATHNAMES_CAP;
 		else if (cap & CIFS_UNIX_POSIX_PATHNAMES_CAP) {
 			cifs_dbg(FYI, "negotiate posix pathnames\n");
-			if (cifs_sb)
-				sbflags |= CIFS_MOUNT_POSIX_PATHS;
+			if (cifs_sb) {
+				atomic_or(CIFS_MOUNT_POSIX_PATHS,
+					  &cifs_sb->mnt_cifs_flags);
+			}
 		}
 
-		if (cifs_sb)
-			atomic_set(&cifs_sb->mnt_cifs_flags, sbflags);
-
 		cifs_dbg(FYI, "Negotiate caps 0x%x\n", (int)cap);
 #ifdef CONFIG_CIFS_DEBUG2
 		if (cap & CIFS_UNIX_FCNTL_CAP)


