Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2529A342510;
	Mon, 20 Apr 2026 16:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700998; cv=none; b=mZw9PdnY+uQZ7yfTMP1wrPpclmuENNVJiJi2nQngj84BCaeLRJlWcc0nmZk9OwJQj9llinXWzRwHjow4cwNjtHLf5pZK4wYm6L0079GR5w5OSJLKj8rJ/UjUfSb+f+25Fulk5IZpcEMlmjbxjIXN74RtO9a3Cbd8++99QKVy1Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700998; c=relaxed/simple;
	bh=JqKIT+ym+jtU59yV2c0par+zqPD/lqqZDkTgqshQkks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxuYHhxgn46wCa+Rw9ELElF8hTHx3gFF989/4FGqo4b8ugehiVidbCZzlb2KuAnOuzhn6YIcvKX+JLKC6F2k9bwiZB2oDjFKZ4YxUIUoqu/JGdgph2StChkh91W+hmtKQ0B/83Sf2TQlysk7/K++VLnVGb0tDE466SviC1AlQJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n81K+9e9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n81K+9e9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5A5C19425;
	Mon, 20 Apr 2026 16:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700998;
	bh=JqKIT+ym+jtU59yV2c0par+zqPD/lqqZDkTgqshQkks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n81K+9e9AczdPEk/TY6ElZf3eNsxLI9tT367JjxogpW9dN5mx2N6KiCZZsK757wfe
	 SSseihhMCfYqvm2gmKYzVi17qpCB0syFsYVFznSK6B+X/hGGhoJ9nRdymAXAgGbE5/
	 P4s7QkHM3nIJgzyG/kYVQ/SvrLlfsb+wGU7oLQO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	stable@kernel.org,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 140/198] ksmbd: require 3 sub-authorities before reading sub_auth[2]
Date: Mon, 20 Apr 2026 17:41:59 +0200
Message-ID: <20260420153940.647660902@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 53370cf9090777774e07fd9a8ebce67c6cc333ab upstream.

parse_dacl() compares each ACE SID against sid_unix_NFS_mode and on
match reads sid.sub_auth[2] as the file mode.  If sid_unix_NFS_mode is
the prefix S-1-5-88-3 with num_subauth = 2 then compare_sids() compares
only min(num_subauth, 2) sub-authorities so a client SID with
num_subauth = 2 and sub_auth = {88, 3} will match.

If num_subauth = 2 and the ACE is placed at the very end of the security
descriptor, sub_auth[2] will be  4 bytes past end_of_acl.  The
out-of-band bytes will then be masked to the low 9 bits and applied as
the file's POSIX mode, probably not something that is good to have
happen.

Fix this up by forcing the SID to actually carry a third sub-authority
before reading it at all.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smbacl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -451,7 +451,8 @@ static void parse_dacl(struct mnt_idmap
 		ppace[i]->access_req =
 			smb_map_generic_desired_access(ppace[i]->access_req);
 
-		if (!(compare_sids(&ppace[i]->sid, &sid_unix_NFS_mode))) {
+		if (ppace[i]->sid.num_subauth >= 3 &&
+		    !(compare_sids(&ppace[i]->sid, &sid_unix_NFS_mode))) {
 			fattr->cf_mode =
 				le32_to_cpu(ppace[i]->sid.sub_auth[2]);
 			break;


