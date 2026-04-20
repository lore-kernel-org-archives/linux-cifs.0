Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359AA3368B2;
	Mon, 20 Apr 2026 15:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699850; cv=none; b=LlwS5Sz4ru5KW8PbzW9qsl8or6kzAV39wyud0rs4SY8wBK76AAyn5HlhZe8oJ3ODbwDZGhJ9sWbDGMZbLvhWZw2+xaUFfs3Zh4T4bcHn6f1Zat7u6GpBBLCgOCpWXxsemmbgRiuHiBAWYlJngdginSrmC9W6DEVj3jADcBtTfV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699850; c=relaxed/simple;
	bh=9fA1TE4FBnSh2tBEN0AVdRgmWJEZZqB5Cehkd42S+ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3tPDlnTIvOCy1/D4+udTaYC3WA9OyQjj6H5IySILhXcpujc15oHGsBH0SLPVjuPgjQDTyo2j+7QGqiPXiFW/bm40vfpTpVkOgTsJPqo9PX5bKmv5QkTj9tVaWg7FFlhqlJioOfyw62LR9TuA1BgCd/1Ht9eW2afTQoiEARInjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dlKW8Es/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dlKW8Es/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A21C19425;
	Mon, 20 Apr 2026 15:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699849;
	bh=9fA1TE4FBnSh2tBEN0AVdRgmWJEZZqB5Cehkd42S+ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dlKW8Es/ULCFQDN9XeVQQxKOiZsqd85Kj/0DDEKYXh9sQuFaw/2YyG3wPIQO6Ql5e
	 EAk7a3NGxp2MxShNSyUta42GjncBUXmgrQcZxhImL+8xqItatQvxIlhGoFcYuZTjEk
	 0gtaVmtF1bd+0CxF8nAPQB835aYN/iDNCNuhLLpI=
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
Subject: [PATCH 7.0 21/76] ksmbd: require 3 sub-authorities before reading sub_auth[2]
Date: Mon, 20 Apr 2026 17:41:32 +0200
Message-ID: <20260420153911.595998799@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
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


