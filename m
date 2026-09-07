Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E72242C508;
	Mon,  7 Sep 2026 14:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788791975; cv=none; b=X5uoI6ifgxvpnrO8FeNfUxUJChJQiuyqKoWFmugi1Jqda1zJvwo8QUjMVa6cneR2I2B1dmNwgwS565ihJ8HgvcE9KeWaK4FyS46YRh7wFfT2qSMSY4uFfWnxb8QM72iqsLEHxJOrwU1nrs0XF/LjE6cbRdCh6hveXtwyhB76+dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788791975; c=relaxed/simple;
	bh=6NHJ7mxXbJigOyVF3N/fh0vOvJXlZBLSq+wvwzcu7xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q98MI1QiPvbbSz6i7cjy81QZk3z+1n9cVsF8wM1zhkM9NzpFbfz0xWaSEVUmhumUNJ2sFS4IJX4cINF1euLJGKPZdaD486YkUODHf/xG3LYir+rlbRx++st5JxeT+8y05DplosPM4CDPe61/4bnB1HV9OGiLN45lvSldvmXxHsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oKjCcXRU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oKjCcXRU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04A11F00A3E;
	Mon,  7 Sep 2026 14:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788791967;
	bh=FF/4LY9T8Md+KHYRgYaW8tObKolXGJt+bxdKVLRNMK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oKjCcXRUx3KIE7PDg4I0iKm39bJwJcc5JLpmGukpJCvgpbPtp+5V+NgRDJH9jcYoR
	 GCUtlBCSiPof+NQIBWp0fHxtxs+EeDzAwBGCVdtL5nAJi4oR3qrLzORnKffpm3W81h
	 bKk41I6aohTMffS91N7ZlJupW8HNbY1r8CN7zplLBvX+uWv2L0YVz1Y+SzsLHxjAA3
	 H41lI5HG3N+LyKjg1cEw3JS9a+vK4LXYLdN3NTyVole7QVGzpXTZZ+o7om57ZFJT58
	 9tV5PGneesnx8ADowDEQWeI7QNR7w8a/pfcKHgePcRTO92JWn391z7T8dpIQJ9Tdf1
	 9DBXvAcQ9qheA==
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
Subject: [PATCH 6.6.y 2/4] cifs: Scripted clean up fs/smb/client/fs_context.h
Date: Mon,  7 Sep 2026 10:39:21 -0400
Message-ID: <20260907143923.3586545-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907143923.3586545-1-sashal@kernel.org>
References: <2026090352-renegade-sneeze-d3c6@gregkh>
 <20260907143923.3586545-1-sashal@kernel.org>
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
index 90ebff5d0199d..bcffc15322604 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -292,18 +292,20 @@ struct smb3_fs_context {
 
 extern const struct fs_parameter_spec smb3_fs_parameters[];
 
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
@@ -311,7 +313,7 @@ extern void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb);
 #define SMB3_MAX_DCLOSETIMEO (1 << 30)
 #define SMB3_DEF_DCLOSETIMEO (1 * HZ) /* even 1 sec enough to help eg open/write/close/open/read */
 #define MAX_CACHED_FIDS 16
-extern char *cifs_sanitize_prepath(char *prepath, gfp_t gfp);
+char *cifs_sanitize_prepath(char *prepath, gfp_t gfp);
 
 extern struct mutex cifs_mount_mutex;
 
-- 
2.53.0

