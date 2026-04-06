Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110F0224B15;
	Mon,  6 Apr 2026 13:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775483226; cv=none; b=JIS3CDo93lQmRBnaQzC1xYcTiHH1eD+iBX809cL4BsIlTAp5/pgTZuLsds2oWCblwA6Rf/8gqfr3AospiLLwChM1NI2LNi4DWX+9gybrs34NY44gw2SGc3pZ8urMODZKhIchzqFM/PN9AdjFjCr43iRkjVAaYbjq2Z6V8ZxDegs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775483226; c=relaxed/simple;
	bh=6quP6INyONpIyrEnc1WgDudBTHdciV3E8oow+ilwgE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8n3Ma5SYJOhnJPXDa3C31Ou+qkDZZ7dRhkN8RyC1AFdDrUW3EHE3QLHDLY8TG4PIIs0Myow/woZAgjNITFrKRb2heTlw6x4xZWCf6JMneVFOqchSjShm4Wch1qQIzhXorwlY7kyM9kfJgq0DYOdyk1xXcz4alQzN7wouM93rIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=19JfWLx9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="19JfWLx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43857C4CEF7;
	Mon,  6 Apr 2026 13:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775483225;
	bh=6quP6INyONpIyrEnc1WgDudBTHdciV3E8oow+ilwgE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=19JfWLx9V+n/p9bBkif3m0PzGMSyBIVyCDeEkkdaLTE9yg5N/IS7qFHcTf4eOjkp/
	 GjBgD8BDEFDF7K1QscjILfNxYJuWfm/6NJgj10N2tFNNYZXYpmoZmAuPgRPvdwqDJ7
	 sx636ATNio6YGWtJRZm81SMfD09RahbK0qUqlsvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-cifs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	stable <stable@kernel.org>
Subject: [PATCH 2/3] ksmbd: require 3 sub-authorities before reading sub_auth[2]
Date: Mon,  6 Apr 2026 15:46:47 +0200
Message-ID: <2026040646-helium-unedited-245a@gregkh>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026040644-brussels-dab-6f99@gregkh>
References: <2026040644-brussels-dab-6f99@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1719; i=gregkh@linuxfoundation.org; h=from:subject:message-id; bh=6quP6INyONpIyrEnc1WgDudBTHdciV3E8oow+ilwgE8=; b=owGbwMvMwCRo6H6F97bub03G02pJDJmXd7o1Sp17sDHlVOAuRY2HBxZd+LbpzZsfT1IUmPp+T 3k+pXNGdUcsC4MgE4OsmCLLl208R/dXHFL0MrQ9DTOHlQlkCAMXpwBM5NpdhgVn/6WGmbd8nBfj u/zZhJzmk89fTsxgmCupWbHT0W4Xo+qi50svnt2xy2Xu11wA
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit

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
Cc: stable <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smbacl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index c30d01877c41..061a305bf9c8 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -451,7 +451,8 @@ static void parse_dacl(struct mnt_idmap *idmap,
 		ppace[i]->access_req =
 			smb_map_generic_desired_access(ppace[i]->access_req);
 
-		if (!(compare_sids(&ppace[i]->sid, &sid_unix_NFS_mode))) {
+		if (ppace[i]->sid.num_subauth >= 3 &&
+		    !(compare_sids(&ppace[i]->sid, &sid_unix_NFS_mode))) {
 			fattr->cf_mode =
 				le32_to_cpu(ppace[i]->sid.sub_auth[2]);
 			break;
-- 
2.53.0

