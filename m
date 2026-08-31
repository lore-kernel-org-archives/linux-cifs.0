Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1124A9D65;
	Mon, 31 Aug 2026 13:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183993; cv=none; b=VDrQ7bue7R3PFFsPdm6Jjyb9WA0c691OmWwtIzJu3QeL6/mY7rqmNhMjqBuPUs1TSyPshHDNayffA3L3UTUvLqdd7JT+DaInVjn+Rz02focZE/LLUcOQMk5kXok3raCWD35IjTLZ2zc1ekoYoIegEEye4v3078+4CrnniZll3D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183993; c=relaxed/simple;
	bh=Mvan0bU5jmnYHP7mAiBtLDM3eFoANtNHxw1FXIw2F4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bw+R6ySd1Vz6GiiHvKSuwakVTKGLJnBdncHTkS2EVmlL93tQvi0kn5qPJciX1/+sPn/5T1KrOWAbfLJsV1RYNgz0qaJoxjnZDqM63L6VZ3PhH3Mt5wU7HpZKuozjN5paNFv84ddccn2onkiNeQ9eQ2l7hJPIXD9qT1vDQpMU7Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fRu/cJZW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fRu/cJZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5AE1F01565;
	Mon, 31 Aug 2026 13:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183989;
	bh=m7t3smsPaXk+IG6UyJgUgzkkF5ggAJww7sz5QElcuF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fRu/cJZWepFwvGVPHit6uXlwJ169OMHvMCDqCzvZCFkLQ4pHx6k/lbr+erpYxCtta
	 ujyS9DSkMHc6InlUjt/Zp8ZY616dfz40uF7Yt60+enAHLSiMg4Y8k2r5HaIz2f4hqB
	 Uk314ZlRufGnPD1NtcnFer0J3O4NLhHuMSduvhYesLWY13LvUYwqU/YPAA8tYTek/K
	 pG1lGUadUF9TKv1yU8UYnX0PuKm/4bfuQHJP4vy2/0swO7boZW9Og7mvsagzXnlNV6
	 vzCczhPoE8Q4mGe8ZSm3BDkBZpXxWBBKGbZ9VD4qmijcS8kA95EYai29KY/bXOXcQd
	 TDeZpQ3qD6nWQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	pc@manguebit.org,
	linkinjeon@kernel.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] smb/client: zero-initialize stack-allocated cifs_open_info_data
Date: Mon, 31 Aug 2026 09:27:32 -0400
Message-ID: <20260831133314.4125787-424-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit 8fce4cf4369c766a3293a05419500cbfde72e60d ]

Stack-allocated cifs_open_info_data may contain random data.
This can make some fields have wrong value if they are not set later.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background checks finished. Summary:

**Series commits in 6.18.44:** None of the related commits are in your
tree — `fc8789bb57e62`, `1f551e407bb49`, and `8fce4cf4369c7` (the zero-
init fix) all return exit 1 from `git merge-base --is-ancestor`.

**Nlink fix:** The main fstat/nlink fix in the series is `9dd1964ac59d2`
("smb/client: fix incorrect nlink returned by fstat()"), merged via
`8eae393cbfd79` — also not in 6.18.44.

**Backport verdict:** The zero-init patch still applies cleanly to the
three uninitialized `cifs_open_info_data` sites in this tree. It's a
small, correct uninitialized-memory fix in the SMB client, though
immediate impact at those call sites is limited without the sibling
series commits. For 6.18.44:

**YES**

 fs/smb/client/link.c    | 2 +-
 fs/smb/client/smb1ops.c | 2 +-
 fs/smb/client/smb2ops.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index 70f3c0c67eebd..0b8cf3dd65d97 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -234,7 +234,7 @@ cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_open_parms oparms;
 	struct cifs_io_parms io_parms = {0};
 	int buf_type = CIFS_NO_BUFFER;
-	struct cifs_open_info_data query_data;
+	struct cifs_open_info_data query_data = {};
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index ca8f3dd7ff63b..209bcf0fab4be 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -962,7 +962,7 @@ smb_set_file_info(struct inode *inode, const char *full_path,
 	struct cifs_open_parms oparms;
 	struct cifsFileInfo *open_file;
 	FILE_BASIC_INFO new_buf;
-	struct cifs_open_info_data query_data;
+	struct cifs_open_info_data query_data = {};
 	__le64 write_time = buf->LastWriteTime;
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index f4d7eb88d3fdb..43eaad8fd0ad4 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5234,7 +5234,7 @@ int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 {
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct cifs_open_parms oparms;
-	struct cifs_open_info_data idata;
+	struct cifs_open_info_data idata = {};
 	struct cifs_io_parms io_parms = {};
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifs_fid fid;
-- 
2.53.0

