Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FED3F4F1;
	Sun,  6 Oct 2024 10:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728208869; cv=none; b=IlLCMIXxMGaR9uy2LbJH4soB74vaQVgu9BZLlGuSVNt26p2KWHy7HLwbs1TrXM7ZHlUOoD8WxcgjFW6GB1rvU2jLEVLI9iNa7owRQA6OJ6CBCXH94tXnsdhKiNAF3W0/BwRM+I2hAagz/sv9cCOFePfuFXkpVEBR+dn9FaJP368=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728208869; c=relaxed/simple;
	bh=rM4fCOYDK4HI6B5oF+uWsvRWPszXfVkG2GCmWRKlU/I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Il/YNymoiUgixn/nmJK9D63QlfmM9JitObZqUx3N4hotVX/fllQDFAW0VFYgYokNQkhfPbJy1xCKJzPX/pkGg3N+qQzha77jwPBhcoFEhKr7SkuTrEi0cup1hOo4p/5TNS8+KZnUgOR1AvDo5mSrQHIp/iC7RhgzVT5PWA5v6Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WUTMWn0H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WUTMWn0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EAB8C4CECE;
	Sun,  6 Oct 2024 10:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728208869;
	bh=rM4fCOYDK4HI6B5oF+uWsvRWPszXfVkG2GCmWRKlU/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUTMWn0HMXcXgLzcg8r939WIxmg+FiKbv+NJyiT7RSJd8QPUsKPYjjUeo+nVCDSZw
	 Le/kw59rmTZ9s3niPxxrcBzgm61aMJywOG1RkWpvLVCr7/QlWmfW1QDMV6SMFsVqsa
	 CNfQzINFKNwA9VZaGqxxnhz1EXDiWjyx8INkMVhFIkHEHDb7/IkAIEAQcsTTFPZIKe
	 ab0IlG4YPXHeWoboaBNSgmjwi99sLYvr4cPD60+My1ILvcBYpWH1BzLDAOXxgSaPUP
	 2+MRoR5ofEtoJtNrEwKp+XWXP73KJ9/WXTVT89JhGIDpO33HDi+CU3u5tJFmY+oDLJ
	 3y1D2n64gcZbw==
Received: by pali.im (Postfix)
	id 6B0A5BA4; Sun,  6 Oct 2024 12:01:02 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] cifs: Add mount option -o reparse=none
Date: Sun,  6 Oct 2024 12:00:41 +0200
Message-Id: <20241006100046.30772-3-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241006100046.30772-1-pali@kernel.org>
References: <20241006100046.30772-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This new mount option allows to completely disable creating new reparse
points. When -o sfu or -o mfsymlinks is not specified then creating any
special file (fifo, socket, symlink, block and char) will fail with
-EOPNOTSUPP error.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsglob.h   | 3 +++
 fs/smb/client/fs_context.c | 4 ++++
 fs/smb/client/fs_context.h | 1 +
 3 files changed, 8 insertions(+)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 367f0ac6400d..7632d2ba5390 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -154,6 +154,7 @@ enum securityEnum {
 };
 
 enum cifs_reparse_type {
+	CIFS_REPARSE_TYPE_NONE, /* disable creating new reparse points */
 	CIFS_REPARSE_TYPE_NATIVE, /* native symlinks only */
 	CIFS_REPARSE_TYPE_NATIVE_NFS, /* native for symlinks, nfs for others */
 	CIFS_REPARSE_TYPE_NATIVE_WSL, /* native for symlinks, wsl for others */
@@ -165,6 +166,8 @@ enum cifs_reparse_type {
 static inline const char *cifs_reparse_type_str(enum cifs_reparse_type type)
 {
 	switch (type) {
+	case CIFS_REPARSE_TYPE_NONE:
+		return "none";
 	case CIFS_REPARSE_TYPE_NATIVE:
 		return "native";
 	case CIFS_REPARSE_TYPE_NATIVE_NFS:
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index e5de84912e3d..3e402961cc95 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -303,6 +303,7 @@ cifs_parse_cache_flavor(struct fs_context *fc, char *value, struct smb3_fs_conte
 
 static const match_table_t reparse_flavor_tokens = {
 	{ Opt_reparse_default,	"default" },
+	{ Opt_reparse_none,	"none" },
 	{ Opt_reparse_native,	"native" },
 	{ Opt_reparse_native_nfs, "native+nfs" },
 	{ Opt_reparse_native_wsl, "native+wsl" },
@@ -320,6 +321,9 @@ static int parse_reparse_flavor(struct fs_context *fc, char *value,
 	case Opt_reparse_default:
 		ctx->reparse_type = CIFS_REPARSE_TYPE_DEFAULT;
 		break;
+	case Opt_reparse_none:
+		ctx->reparse_type = CIFS_REPARSE_TYPE_NONE;
+		break;
 	case Opt_reparse_native:
 		ctx->reparse_type = CIFS_REPARSE_TYPE_NATIVE;
 		break;
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index 1011176ba3b7..5db06de2ed35 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -43,6 +43,7 @@ enum {
 
 enum cifs_reparse_parm {
 	Opt_reparse_default,
+	Opt_reparse_none,
 	Opt_reparse_native,
 	Opt_reparse_native_nfs,
 	Opt_reparse_native_wsl,
-- 
2.20.1

