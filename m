Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AC6402425;
	Wed, 20 May 2026 18:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302900; cv=none; b=AS+gUH7C0GLgQj6w28xGtTm2DFsqUIZgrKZSLNy4HFL7nM6smqKF+gWwgDGUNfPML+97g1EF0WllIynZaoeu/uEwmh5CLqMlDZ7vVyD7VRSZoFB4MJJqrP2QNDR/mWWZan9VzJbeW3tyH+cuhKofGfwkMwT6q/aFOI8jRe+B3tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302900; c=relaxed/simple;
	bh=t7UUJ3wSZfHW/xqkxoWJmrwnA3u9Req93GqDdNhfP3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pv/c25XaeidjVICcPPFpkOjGWjzzMppLr8CMzd3Ju1maFc9yB7d/0/AGnr9H9DbHOoOKaVwXNj48sFouO5colcGK9HYDAfKUYXP9Q79XgaCVCpL12tLGXVXhX3BtIpPhKiuf6ho6Xf5J41YhIZ0SMRaVTNy/EbuYgqLweW6iYa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNdTvAJ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNdTvAJ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135C51F000E9;
	Wed, 20 May 2026 18:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302898;
	bh=kuu2bIK5tZA0vRJ7E2Fh25kcvP5aetJqNmFD0VAIdCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pNdTvAJ2HOPTr8C8iQJD3rtajvCIQRWf61sqfoeYME8jX5gT2KbHBdZYaYh9Ls/DK
	 86bVWvBW/EuXEgvjLeI+ZWy+ItZHhkit2lsZSWWCs697y+JWf4yoKknZVyPN66zLii
	 rhpQCUrGxzLqJj1d6ykOnGWxX++NeG0StICa1o0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	stable <stable@kernel.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Alva Lan <alvalan9@foxmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 443/508] smb: client: fix OOB reads parsing symlink error response
Date: Wed, 20 May 2026 18:24:26 +0200
Message-ID: <20260520162108.196990692@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 3df690bba28edec865cf7190be10708ad0ddd67e ]

When a CREATE returns STATUS_STOPPED_ON_SYMLINK, smb2_check_message()
returns success without any length validation, leaving the symlink
parsers as the only defense against an untrusted server.

symlink_data() walks SMB 3.1.1 error contexts with the loop test "p <
end", but reads p->ErrorId at offset 4 and p->ErrorDataLength at offset
0.  When the server-controlled ErrorDataLength advances p to within 1-7
bytes of end, the next iteration will read past it.  When the matching
context is found, sym->SymLinkErrorTag is read at offset 4 from
p->ErrorContextData with no check that the symlink header itself fits.

smb2_parse_symlink_response() then bounds-checks the substitute name
using SMB2_SYMLINK_STRUCT_SIZE as the offset of PathBuffer from
iov_base.  That value is computed as sizeof(smb2_err_rsp) +
sizeof(smb2_symlink_err_rsp), which is correct only when
ErrorContextCount == 0.

With at least one error context the symlink data sits 8 bytes deeper,
and each skipped non-matching context shifts it further by 8 +
ALIGN(ErrorDataLength, 8).  The check is too short, allowing the
substitute name read to run past iov_len.  The out-of-bound heap bytes
are UTF-16-decoded into the symlink target and returned to userspace via
readlink(2).

Fix this all up by making the loops test require the full context header
to fit, rejecting sym if its header runs past end, and bound the
substitute name against the actual position of sym->PathBuffer rather
than a fixed offset.

Because sub_offs and sub_len are 16bits, the pointer math will not
overflow here with the new greater-than.

Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Cc: stable <stable@kernel.org>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2file.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index 3a5b62b298063..044512b77448c 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -27,10 +27,11 @@ static struct smb2_symlink_err_rsp *symlink_data(const struct kvec *iov)
 {
 	struct smb2_err_rsp *err = iov->iov_base;
 	struct smb2_symlink_err_rsp *sym = ERR_PTR(-EINVAL);
+	u8 *end = (u8 *)err + iov->iov_len;
 	u32 len;
 
 	if (err->ErrorContextCount) {
-		struct smb2_error_context_rsp *p, *end;
+		struct smb2_error_context_rsp *p;
 
 		len = (u32)err->ErrorContextCount * (offsetof(struct smb2_error_context_rsp,
 							      ErrorContextData) +
@@ -39,8 +40,7 @@ static struct smb2_symlink_err_rsp *symlink_data(const struct kvec *iov)
 			return ERR_PTR(-EINVAL);
 
 		p = (struct smb2_error_context_rsp *)err->ErrorData;
-		end = (struct smb2_error_context_rsp *)((u8 *)err + iov->iov_len);
-		do {
+		while ((u8 *)p + sizeof(*p) <= end) {
 			if (le32_to_cpu(p->ErrorId) == SMB2_ERROR_ID_DEFAULT) {
 				sym = (struct smb2_symlink_err_rsp *)p->ErrorContextData;
 				break;
@@ -50,14 +50,16 @@ static struct smb2_symlink_err_rsp *symlink_data(const struct kvec *iov)
 
 			len = ALIGN(le32_to_cpu(p->ErrorDataLength), 8);
 			p = (struct smb2_error_context_rsp *)(p->ErrorContextData + len);
-		} while (p < end);
+		}
 	} else if (le32_to_cpu(err->ByteCount) >= sizeof(*sym) &&
 		   iov->iov_len >= SMB2_SYMLINK_STRUCT_SIZE) {
 		sym = (struct smb2_symlink_err_rsp *)err->ErrorData;
 	}
 
-	if (!IS_ERR(sym) && (le32_to_cpu(sym->SymLinkErrorTag) != SYMLINK_ERROR_TAG ||
-			     le32_to_cpu(sym->ReparseTag) != IO_REPARSE_TAG_SYMLINK))
+	if (!IS_ERR(sym) &&
+	    ((u8 *)sym + sizeof(*sym) > end ||
+	     le32_to_cpu(sym->SymLinkErrorTag) != SYMLINK_ERROR_TAG ||
+	     le32_to_cpu(sym->ReparseTag) != IO_REPARSE_TAG_SYMLINK))
 		sym = ERR_PTR(-EINVAL);
 
 	return sym;
@@ -82,8 +84,10 @@ int smb2_parse_symlink_response(struct cifs_sb_info *cifs_sb, const struct kvec
 	print_len = le16_to_cpu(sym->PrintNameLength);
 	print_offs = le16_to_cpu(sym->PrintNameOffset);
 
-	if (iov->iov_len < SMB2_SYMLINK_STRUCT_SIZE + sub_offs + sub_len ||
-	    iov->iov_len < SMB2_SYMLINK_STRUCT_SIZE + print_offs + print_len)
+	if ((char *)sym->PathBuffer + sub_offs + sub_len >
+		(char *)iov->iov_base + iov->iov_len ||
+	    (char *)sym->PathBuffer + print_offs + print_len >
+		(char *)iov->iov_base + iov->iov_len)
 		return -EINVAL;
 
 	return smb2_parse_native_symlink(path,
-- 
2.53.0



