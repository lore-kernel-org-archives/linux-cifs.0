Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B27271450;
	Mon,  7 Sep 2026 01:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788742989; cv=none; b=Ka+ttDXjBG185j8obcQaFogm5aG+iRkw9kpN5XAU9Oj++6vZTSmgKiIybT9kJCD4tbyVJfYpZup2z+w577VRRYRxI2SVUPoro5p/qq+6y4yv2M3OqpyH6coUJokBCibuoHfRT4cshSLg4nXHSvLYYjFLdfytXJd07HqlYodpubk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788742989; c=relaxed/simple;
	bh=8LDh7DKYxYp6dUrAhEw5EaMywThx2+8UX2UN931Ukgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZT6UlQ9d7qAq7EO4sKTa8LhFj/xurgTFxRNJa7WKAEteKULlgA/sB82lJOM+Pck0fmcf/wVtZsUstFBgyU8c+Mwa4e1g0fvuV487ayr0htxBwu7Ee9bi549hWsUG7UWFQUoub8+mnLI/oYF5fyNb2bsCoN0KhfP95PnU2/0mDfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nuuko2LI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nuuko2LI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4E21F00A3E;
	Mon,  7 Sep 2026 01:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788742987;
	bh=AYmXEkah6BUtmAMZO1tz3v/ye0n752JNOj8XTZCKA3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nuuko2LI2Z/fxdswK8EtqilQUTTo1lvawG7h9y3CIBDwbUHizHtpAlyN216hiNIYb
	 gGXH8UTK2bat5Ti4jKNmxaTWrcIUSXssP+yqhLcXRqRbIb2wh6yzaoG1aXyfennrQW
	 EEdCtLkHdHA8sMGoyNkDC5xbXqIJhl1/Fw4lZjD9kPmTgV/d43Lv6MySVZhPqp87sz
	 kHq+vKgTHYqR0g5BuRs7r0evULwPKfESIP9VIeYlvjYmJNP0ybwwIzq9as2GmriKzD
	 eJse6XCT4cnFMvGnrZJ8u2UdR223XeKQSdrYC9GyLF3xfNxsk08FKlebsdlIZUJLrX
	 m1bMNTXxezCfQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18.y 3/5] cifs: Scripted clean up fs/smb/client/fs_context.h
Date: Sun,  6 Sep 2026 21:03:00 -0400
Message-ID: <20260907010302.1949559-3-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907010302.1949559-1-sashal@kernel.org>
References: <2026090324-defraud-tremble-b3d8@gregkh>
 <20260907010302.1949559-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit 047e504766a357ab751f76ccdec7a2e824e75e6d ]

Remove externs, correct argument names and reformat declarations.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Acked-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: b8e5dc4f95e5 ("smb: client: clear setuid/setgid bit on write with cifsacl/modefromsid/posix extensions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.h | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index b0fec6b9a23b4..f88a3d795799b 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -359,18 +359,20 @@ static inline enum cifs_symlink_type cifs_symlink_type(struct cifs_sb_info *cifs
 	return CIFS_SYMLINK_TYPE_NONE;
 }
 
-extern int smb3_init_fs_context(struct fs_context *fc);
-extern void smb3_cleanup_fs_context_contents(struct smb3_fs_context *ctx);
-extern void smb3_cleanup_fs_context(struct smb3_fs_context *ctx);
+int smb3_init_fs_context(struct fs_context *fc);
+void smb3_cleanup_fs_context_contents(struct smb3_fs_context *ctx);
+void smb3_cleanup_fs_context(struct smb3_fs_context *ctx);
 
 static inline struct smb3_fs_context *smb3_fc2context(const struct fs_context *fc)
 {
 	return fc->fs_private;
 }
 
-extern int smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct smb3_fs_context *ctx);
-extern int smb3_sync_session_ctx_passwords(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses);
-extern void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb);
+int smb3_fs_context_dup(struct smb3_fs_context *new_ctx,
+			struct smb3_fs_context *ctx);
+int smb3_sync_session_ctx_passwords(struct cifs_sb_info *cifs_sb,
+				    struct cifs_ses *ses);
+void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb);
 
 /*
  * max deferred close timeout (jiffies) - 2^30
@@ -378,7 +380,7 @@ extern void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb);
 #define SMB3_MAX_DCLOSETIMEO (1 << 30)
 #define SMB3_DEF_DCLOSETIMEO (1 * HZ) /* even 1 sec enough to help eg open/write/close/open/read */
 #define MAX_CACHED_FIDS 16
-extern char *cifs_sanitize_prepath(char *prepath, gfp_t gfp);
+char *cifs_sanitize_prepath(char *prepath, gfp_t gfp);
 
 extern struct mutex cifs_mount_mutex;
 
-- 
2.53.0

