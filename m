Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E21733B975;
	Mon, 20 Apr 2026 15:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699842; cv=none; b=SML2fiu8JpEfApDXqYDZohmK2yu8n5ABJQcSys+T42RwcFf2IqWYrFbyTP0kjHNKapOCfkZ99kJPDUIOIE2hFQMP2Dp1wqlgVG5IF/PmxIo3FzP3hP3QL3zhhnFA0utrT4eat/SGvPYgWEiRNK/fFnQy9RhisnD2E5+tGRFgsmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699842; c=relaxed/simple;
	bh=gV6SKNdvkTxLsozW1+BP4hqvbrO4/YpO6EMURB7yenk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqnTnsiNeYV9pSgO0xpzYGioJlXKH1jjHXmhWo/znQ/q3eWBb6SX9ZhUNucBBJHHgA5uAaWfnINL020haFQGYl/tGF858/bLC4FgZOeArK8HrLQOuuMh8F5sEjp0I89/ETKq0qIGFpqNIMoBgJVHnHCTQNeOvCkoux9TW1WgZzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1yv9yCeh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1yv9yCeh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4D7C2BCB4;
	Mon, 20 Apr 2026 15:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699842;
	bh=gV6SKNdvkTxLsozW1+BP4hqvbrO4/YpO6EMURB7yenk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1yv9yCehp2eqvc8S/MvHGc2tNA4MUfco5H8xqwc8qxohKLutxWQZZvgOb6q8NOpws
	 Nmkv/MvloP7KW5mphgHJb7R65SEKRwm0NJxKr1Ga0LxnF6mIC1Ivo0qaydFxGZVrXB
	 BBgdyVFdg/OoGk3tBEfRCwNJa/D6Nc9DBw/xVrLY=
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
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.0 19/76] smb: client: fix OOB reads parsing symlink error response
Date: Mon, 20 Apr 2026 17:41:30 +0200
Message-ID: <20260420153911.522854085@linuxfoundation.org>
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

commit 3df690bba28edec865cf7190be10708ad0ddd67e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2file.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -27,10 +27,11 @@ static struct smb2_symlink_err_rsp *syml
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
@@ -39,8 +40,7 @@ static struct smb2_symlink_err_rsp *syml
 			return ERR_PTR(-EINVAL);
 
 		p = (struct smb2_error_context_rsp *)err->ErrorData;
-		end = (struct smb2_error_context_rsp *)((u8 *)err + iov->iov_len);
-		do {
+		while ((u8 *)p + sizeof(*p) <= end) {
 			if (le32_to_cpu(p->ErrorId) == SMB2_ERROR_ID_DEFAULT) {
 				sym = (struct smb2_symlink_err_rsp *)p->ErrorContextData;
 				break;
@@ -50,14 +50,16 @@ static struct smb2_symlink_err_rsp *syml
 
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
@@ -128,8 +130,10 @@ int smb2_parse_symlink_response(struct c
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


