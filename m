Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90426332916;
	Mon, 20 Apr 2026 15:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700402; cv=none; b=cfVB7Z6Pj8r2hqZHinJC22b8qBNzWzBkLwRVay7Gn91aBJ4488u+/o+ajhRpKsM9djjpAH3g5f6RX/zC8lB5/TZgbR/x0uk8/ybTFzpgjNiHiCBirtgVRHul7Lq+Es8vXoyRJtUcovvWECKTzbehAMyBAFgs/ckfMdU/nRZbDEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700402; c=relaxed/simple;
	bh=hJD3QkRaqcIkB/16anp0kTHlCusRL1BYapPMyaQqztk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dlVtDMVb1B8TOp3AkWIoACLINv0U+f4mjdc/dbak0rfaBok86ZENODActh4+nPguUYcoydFv7B9+B6adYYJDLnKkgUcoUXG+ZBbLQ75b+jzHsiXHnvzYyFBVMEiGgmZqCvzUqxhFtnVlJvSpSEw3m16LswzzDxSv1Fgz1PQz9+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1LunpTf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1LunpTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E898BC19425;
	Mon, 20 Apr 2026 15:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700402;
	bh=hJD3QkRaqcIkB/16anp0kTHlCusRL1BYapPMyaQqztk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n1LunpTft3uetqd/ccCZVTWjC7OoXXW+teGRM6gpXeo0a0sJFZhnepZyjkmBvSv8Z
	 LxoNQdvNUXTgd1dHffIv5MLOsHmwTC1nEoAq9Da5cgOqyHV2K7FEGSNOVYDhY/X7mR
	 C5gMc6cYgNzxAV3B/DtjSSuyzDmmGP0BhwJhauNk=
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
Subject: [PATCH 6.19 159/220] ksmbd: require 3 sub-authorities before reading sub_auth[2]
Date: Mon, 20 Apr 2026 17:41:40 +0200
Message-ID: <20260420153939.753139892@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


