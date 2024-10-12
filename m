Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B7D14A092;
	Sat, 12 Oct 2024 08:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728723345; cv=none; b=ESRv40BX2bvBTihEtGN63C2RZY3JyPRanADlkjEqPVhQgjYoOhJd99jER5IbKpg5xeRgpphgbddfshVgF428qQ+nAe09uu/gsV85Q+mXnMc6f9xSj1+RUbC6rpUdMiBXSpwG1MwADfTd8j4uSSYK5hIbAsi93NqLYTgDkHxxj6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728723345; c=relaxed/simple;
	bh=2leM15kk/Vs6N9tTsC8o3+vg/CPabJBZtZdvUeCLCuA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=piUyexr7TPoc5ppHiKABo3pwsXgId4Oh5l3xCXmPk/x04heg+4P6m0ZRaFSLqsftYsNOdeHkFe5UMpqtp0WPCzEy9djv9nsTPG2J1mKTFufDWcJ32LplsT+xV6RsKz4LoRfsp4pNf/9HCVDlVETno7W7Aeir46U2IhPZkVeCOfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QTbjGVTx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QTbjGVTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139BBC4CEC6;
	Sat, 12 Oct 2024 08:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728723345;
	bh=2leM15kk/Vs6N9tTsC8o3+vg/CPabJBZtZdvUeCLCuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTbjGVTxzCa7mNCouu5xO8ACM6yH+PBNswt373y9vZylfvFZhs2c+nrRFsuZOmfIO
	 lhbzVho0NY+Xz7EgFEF51Oz4udurHrIOz1Zv+akkTuTI6ccn987wdPYhxw1sLcbFB5
	 nPMdxPYaLcYdgZiMkYJStbqyCNZqeqN09R8EXELH43GSeHHcBrTdcxUZnwcEHBq884
	 LIoXlqd0Rgb6jQfV2x+QVVgm0puo7Yct2XtU/Ec6RhwfH4OWV3u0BWnUmB+NR8J2y3
	 ahT9ljFP69zorgcOlasDNnSdiAXxUVARV+TIL8jF4tRoWzkhb4Tklf7rVPMHfTQixF
	 JDovbdTkczSPw==
Received: by pali.im (Postfix)
	id 4D1F07BD; Sat, 12 Oct 2024 10:55:39 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/7] cifs: Add mount option -o reparse=none
Date: Sat, 12 Oct 2024 10:55:37 +0200
Message-Id: <20241012085537.652-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241012085252.560-1-pali@kernel.org>
References: <20241012085252.560-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This new mount option allows to completely disable creating new reparse
points. When -o sfu or -o mfsymlinks or -o symlink= is not specified then
creating any special file (fifo, socket, symlink, block and char) will fail
with -EOPNOTSUPP error.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsglob.h   | 3 +++
 fs/smb/client/fs_context.c | 8 +++++++-
 fs/smb/client/fs_context.h | 1 +
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index f419d20f6c38..dcee43889358 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -154,6 +154,7 @@ enum securityEnum {
 };
 
 enum cifs_reparse_type {
+	CIFS_REPARSE_TYPE_NONE,
 	CIFS_REPARSE_TYPE_NFS,
 	CIFS_REPARSE_TYPE_WSL,
 	CIFS_REPARSE_TYPE_DEFAULT = CIFS_REPARSE_TYPE_NFS,
@@ -162,6 +163,8 @@ enum cifs_reparse_type {
 static inline const char *cifs_reparse_type_str(enum cifs_reparse_type type)
 {
 	switch (type) {
+	case CIFS_REPARSE_TYPE_NONE:
+		return "none";
 	case CIFS_REPARSE_TYPE_NFS:
 		return "nfs";
 	case CIFS_REPARSE_TYPE_WSL:
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 6bd4a5e61342..d68db6ac5f73 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -304,6 +304,7 @@ cifs_parse_cache_flavor(struct fs_context *fc, char *value, struct smb3_fs_conte
 
 static const match_table_t reparse_flavor_tokens = {
 	{ Opt_reparse_default,	"default" },
+	{ Opt_reparse_none,	"none" },
 	{ Opt_reparse_nfs,	"nfs" },
 	{ Opt_reparse_wsl,	"wsl" },
 	{ Opt_reparse_err,	NULL },
@@ -318,6 +319,9 @@ static int parse_reparse_flavor(struct fs_context *fc, char *value,
 	case Opt_reparse_default:
 		ctx->reparse_type = CIFS_REPARSE_TYPE_DEFAULT;
 		break;
+	case Opt_reparse_none:
+		ctx->reparse_type = CIFS_REPARSE_TYPE_NONE;
+		break;
 	case Opt_reparse_nfs:
 		ctx->reparse_type = CIFS_REPARSE_TYPE_NFS;
 		break;
@@ -1713,8 +1717,10 @@ enum cifs_symlink_type get_cifs_symlink_type(struct cifs_sb_info *cifs_sb)
 			return CIFS_SYMLINK_TYPE_SFU;
 		else if (cifs_sb->ctx->linux_ext && !cifs_sb->ctx->no_linux_ext)
 			return CIFS_SYMLINK_TYPE_UNIX;
-		else
+		else if (cifs_sb->ctx->reparse_type != CIFS_REPARSE_TYPE_NONE)
 			return CIFS_SYMLINK_TYPE_NATIVE;
+		else
+			return CIFS_SYMLINK_TYPE_NONE;
 	} else {
 		return cifs_sb->ctx->symlink_type;
 	}
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index 3bcf20495fea..5f306f581fd1 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -43,6 +43,7 @@ enum {
 
 enum cifs_reparse_parm {
 	Opt_reparse_default,
+	Opt_reparse_none,
 	Opt_reparse_nfs,
 	Opt_reparse_wsl,
 	Opt_reparse_err
-- 
2.20.1

