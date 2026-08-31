Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B9351FCB2;
	Mon, 31 Aug 2026 13:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183837; cv=none; b=VqHzn6IZfoaRptJc3P/H/n1ASKpYwIcus6cbl3CL/pAwddVo2wtq1ZMc4VRgZ6tt6pIpnqlSXIBBEg8V8HS0H5zIMuldW4SmSUgM42JWtBTy+ieeRXSvBE0pQ/7bn/GLsA7h33y/reCLC1R01/rv+mi46alF87NwK24IKzDhRNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183837; c=relaxed/simple;
	bh=biKOVasoj6tSY6FlcS1irsgZNm0vohE0TNSLOJb+qAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XTaX/mw+i06YRHMc+5tWH+bxxtPKHAcULIKJUNxcfkduaml7TzBPnY0Ej8uzKHcU15jkv2Sn2MmnWMvdc1TkGo8pYe9Ijw5b8GNLMPJ3Plcc3tX4kfT6Ktbs78DMuNNK+os1q+EJ9FkSnPqsfehqSuUYTmrJ+9VbIzC/EePqzpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XFaP480h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XFaP480h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E721F00A3D;
	Mon, 31 Aug 2026 13:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183835;
	bh=BbLvC4XLuHvUox126ylkhDq5kOLzngT/8cbJZ+VZFns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XFaP480h0GabdeSVjArTJ5mCCWq6q49fYU6pdxLSgpfzhyl9bDSmPiCbH1RpcCDA8
	 s8xm8Dgy2EN34poJnqbilDcHKz/8RpdHjk+7ShV8JMVfrtSB0n623tvkNppZ9/JaHX
	 PfAlOplrwLwYurtx4XeiwdrVRGM54KMliDi4L+Ob7/CjTeiaBuDq+XvMKpUOESN0Bf
	 OZjcaGHBbDFsNZqF1h5yAwXRc+l6PyRdF73G8AAxRnVGQFfdHle59S8fCwhiNqsn7b
	 KEPonFh3vABqsfHS38gWeHJ1tGSGSsWJXw8ajeKEsIoqYd4rg3mS17tLVpHH1REZbb
	 w4qDTJAKV8Lzw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jay Vadayath <jay@artiphishell.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	pc@manguebit.org,
	linkinjeon@kernel.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] smb: client: bound dirent name against end of SMB response in cifs_filldir
Date: Mon, 31 Aug 2026 09:26:01 -0400
Message-ID: <20260831133314.4125787-333-sashal@kernel.org>
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

From: Jay Vadayath <jay@artiphishell.com>

[ Upstream commit f8cf09a53a0dc1da298e9dd0ba5f21710cf119d6 ]

cifs_filldir() copies the entry name out of an SMB1 TRANS2_FIND_FIRST /
FIND_NEXT response using a length (de.namelen) supplied by the server.
The kmalloc'd SMB response buffer is bounded, but nothing checks that
de.name + de.namelen still lies inside that buffer before the eventual
filldir64() -> verify_dirent_name() -> memchr() reads namelen bytes.

A hostile SMB1 server that returns an oversized FileNameLength in a
directory entry therefore causes memchr() to read past the end of the
response slab buffer. Reachable from any user who can list a directory
on a CIFS mount served by an attacker-controlled server (getdents64()
on the mounted directory):

  BUG: KASAN: slab-out-of-bounds in memchr+0x71/0x80
  Read of size 1 at addr ffff88800e0640cc by task poc/115
  Call Trace:
   dump_stack_lvl+0x64/0x80
   print_report+0xce/0x620
   kasan_report+0xec/0x120
   memchr+0x71/0x80
   filldir64+0x4c/0x6a0
   cifs_filldir.constprop.0+0x9bb/0x1e00
   cifs_readdir+0x2101/0x3380
   iterate_dir+0x19c/0x520
   __x64_sys_getdents64+0x126/0x210
   do_syscall_64+0x107/0x5a0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

Pass the end-of-response pointer down to cifs_filldir() and reject
entries whose name would extend past that boundary.

This bug was discovered by Artiphishell's vTriage pipeline, which
generated a userspace reproducer (an emulated hostile SMB1 server plus
a getdents64() client) that reliably triggers the KASAN report on an
unpatched kernel. The fix below was drafted with the Claude coding
assistant; a userspace reproducer is available on request.

Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Jay Vadayath <jay@artiphishell.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

That search finished with **no matches** for the fix string `"search
entry name extends past end of SMB"` in the local tree’s history (~6.7
minutes to scan). That confirms the patch isn’t in this 6.18.44
checkout, which is consistent with the **YES** backport recommendation.

 fs/smb/client/readdir.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index f0ce26622a140..d61ce7c6be645 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -949,7 +949,7 @@ static bool cifs_dir_emit(struct dir_context *ctx,
 static int cifs_filldir(char *find_entry, struct file *file,
 			struct dir_context *ctx,
 			char *scratch_buf, unsigned int max_len,
-			struct cached_fid *cfid)
+			char *end_of_smb, struct cached_fid *cfid)
 {
 	struct cifsFileInfo *file_info = file->private_data;
 	struct super_block *sb = file_inode(file)->i_sb;
@@ -970,6 +970,11 @@ static int cifs_filldir(char *find_entry, struct file *file,
 		return -EINVAL;
 	}
 
+	if (de.name + de.namelen > end_of_smb) {
+		cifs_dbg(VFS, "search entry name extends past end of SMB\n");
+		return -EINVAL;
+	}
+
 	/* skip . and .. since we added them first */
 	if (cifs_entry_is_dot(&de, file_info->srch_inf.unicode))
 		return 0;
@@ -1190,7 +1195,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 		 */
 		*tmp_buf = 0;
 		rc = cifs_filldir(current_entry, file, ctx,
-				  tmp_buf, max_len, cfid);
+				  tmp_buf, max_len, end_of_smb, cfid);
 		if (rc) {
 			if (rc > 0)
 				rc = 0;
-- 
2.53.0

