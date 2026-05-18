Received: from out203-205-221-242.mail.qq.com (out203-205-221-242.mail.qq.com [203.205.221.242])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2887237D115;
	Mon, 18 May 2026 11:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.242
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779105208; cv=none; b=LEB1+IUvXpm9SmVH6Wi3Kd5hHx5rmdm1nTnbnjLDfk0dL7NF6NIRe+oU51XLWOUA7NDl087EA1u+/dr4pMk9boqUOQwyil/tyiNVGtyOxEDP9LYCsKKR1L5c5h0OSe0UEzjHnbomKBNlOOpsr8VHPdvkq0D7Yu2ZB4P6/pINLSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779105208; c=relaxed/simple;
	bh=a8RHJb5fdvj94taVOB8Zs1yKqugsCa/YlHaWI3CD2ZM=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=jIypprGReFplKwHTQLPHPb8tYeD+X5BQSBV0gtlvhHnf1Tdl9hiazLw+baOTakGFGKctNHlLpHW2Mqjsntp5G2eCGnIWZxfuT/rOzH6+2qQxKFuxtCFjSjWv+Fy5xZxz76HwhTQS5yFOddOR/LC5//UevnZBwee3sjj79rAYYHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=WFFsXNve; arc=none smtp.client-ip=203.205.221.242
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="WFFsXNve"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1779105197;
	bh=0QUjqelaAmgLSOU5FDBk9xFnggyFWdoSoWpzhigwSuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WFFsXNve9W5zmUreYKpyuKG6JOqYPwMEoyBB8hxiyBoPKzoIVJEmcHq+LnV+pc8Br
	 0WVstovKhz/gy/ZEs0R7p3rJ08170GW/KtPA7ZpFlka7SIRm/rIEsXClkLcZWqYMtU
	 QAfnzThS0qp5jmRdilI5boLS87ZS9kQ5Od9zLd0Q=
Received: from China-team ([47.95.114.252])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id D45BF675; Mon, 18 May 2026 19:53:05 +0800
X-QQ-mid: xmsmtpt1779105193t7ai0d8zq
Message-ID: <tencent_B0DF3A0F070846B6219D96AE66E1C34FB205@qq.com>
X-QQ-XMAILINFO: MHlktdARe4QnUgv0VerQzX+qVWhx61/b5UGvDGEYtr+ihX6p7rFo0pYumtzUGb
	 UB6rOmJPZ59aDQtkDHuHUfdEnShQcLTZL0Yos7irAfyDmI7WunRN9JXyUIKJJKVpXu8W6ECi6M2p
	 AXDhK4eTVuMGXep8nRHkLUiLYCY2YfGSp+R8zys1E96lDHWF36bc76tgkPrLvEw6/rgpcBW3ldIT
	 ueKxvDWXkqCOULJK+eUSWY78jcm4JOuU4OMGyN3G08jZMdWACUmPwKkDJXVij1lJ0s+dTKoZRwOJ
	 ank6FOFQxG8zbQ50sdv6s8cAcIrWy5DGCZicIGBNxVJRQ2CXtmdwKVzaWEU6zsvg/100GXOnpttY
	 CXyBIvIkkxQ3gIrOsJsHgaNW2rgdcWOYcaMkuIcjasQBDbtQ6We80lT09nRtQMYjXobG+RFRFjMF
	 24bjr7h2ERxRgZGzgYJ+8OJlSui18yINf3NPQ1SsV361EydxmtWKbpeHF9oLQvD6ZcWWfgoDSau0
	 UEMatzWFUZb9QtCgz33w45/NeDXNet78wYBJ3YbeEtlzrAhGDewBd+AoUksXNjsvbH046f9Fu7xx
	 kK0y0OInbbQS6OXmMXlSlUu2NEv7qxypaLjgYxOqe13p9QHvmes6VKvlyZFKHCi46N3z1pB/MamM
	 ejzb9mNYefdjm6HrZ1fSBzLzgHeiotglHfZQ85KJuIOpKmePmBjsxdwFzuGK9Td3cphAzDx3ZXId
	 qjeETb9IEqi4zsK+7Mhk7SAI7sWfZimYyKjP7f43nG6DFaXo8wVOQm4XVveyNA6tPyc5Gmx/0SBW
	 6OBJtIF5Eph5++MMCdWDY8bHzoahbjHv/xTELCw1fc/Md5BftiaMELrUNnNRHGoB+pdx314TGiH5
	 va3vUpWBvARGCvXQxex7ul6h65E+L6ghGYj1rayOfq8MwYl+kTMzQdD8PHIC9ablAL38UjEbb8ab
	 LwiHY9IGPmVfqeq0+eLM2ECTQQ8EB+aN+pcddECJk2cNkzXuEG20h3zuwpiw5cSWngcnv5k41nBh
	 C3Wa4eJBXD6wCIxnklC6mK4UL7wefLSteW9ck8yDZ3bKrus/WvscfGURH9TC0BnSwvBzR6tYxSHL
	 1huU6L0H02684WL8s=
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
From: Alva Lan <alvalan9@foxmail.com>
To: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	samba-technical@lists.samba.org,
	stable <stable@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 6.1.y 2/2] smb: client: fix OOB reads parsing symlink error response
Date: Mon, 18 May 2026 19:52:52 +0800
X-OQ-MSGID: <20260518115252.22162-2-alvalan9@foxmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260518115252.22162-1-alvalan9@foxmail.com>
References: <20260518115252.22162-1-alvalan9@foxmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 fs/smb/client/smb2file.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index def2602ea0fb..43e38909e20b 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -26,10 +26,11 @@ static struct smb2_symlink_err_rsp *symlink_data(const struct kvec *iov)
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
@@ -38,8 +39,7 @@ static struct smb2_symlink_err_rsp *symlink_data(const struct kvec *iov)
 			return ERR_PTR(-EINVAL);
 
 		p = (struct smb2_error_context_rsp *)err->ErrorData;
-		end = (struct smb2_error_context_rsp *)((u8 *)err + iov->iov_len);
-		do {
+		while ((u8 *)p + sizeof(*p) <= end) {
 			if (le32_to_cpu(p->ErrorId) == SMB2_ERROR_ID_DEFAULT) {
 				sym = (struct smb2_symlink_err_rsp *)p->ErrorContextData;
 				break;
@@ -49,14 +49,16 @@ static struct smb2_symlink_err_rsp *symlink_data(const struct kvec *iov)
 
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
@@ -81,8 +83,10 @@ int smb2_parse_symlink_response(struct cifs_sb_info *cifs_sb, const struct kvec
 	print_len = le16_to_cpu(sym->PrintNameLength);
 	print_offs = le16_to_cpu(sym->PrintNameOffset);
 
-	if (iov->iov_len < SMB2_SYMLINK_STRUCT_SIZE + sub_offs + sub_len ||
-	    iov->iov_len < SMB2_SYMLINK_STRUCT_SIZE + print_offs + print_len)
+	if ((char *)sym->PathBuffer + sub_offs + sub_len >
+		(char *)iov->iov_base + iov->iov_len ||
+	    (char *)sym->PathBuffer + print_offs + print_len >
+		(char *)iov->iov_base + iov->iov_len)
 		return -EINVAL;
 
 	s = cifs_strndup_from_utf16((char *)sym->PathBuffer + sub_offs, sub_len, true,
-- 
2.43.0

