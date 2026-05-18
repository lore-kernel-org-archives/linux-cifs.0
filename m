Received: from out203-205-221-233.mail.qq.com (out203-205-221-233.mail.qq.com [203.205.221.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EE6146A66;
	Mon, 18 May 2026 08:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779092103; cv=none; b=HVnvM6ORzPOH05MyPk9hZV29T97gEZFHPUeUuVQ/2cbd0+jsaNS1VKWo5IivsjGmfaHQLJa8ZZVs06C2GLPyY4gvDSvvxzfIAnAw/Mn8tY9z47wku5x7j/k9N3NAKNeDKLQq6D5euYdnKRGeBZvOOGM2YyuR5C93rxg8JiWHpoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779092103; c=relaxed/simple;
	bh=ldmTIdKJkkDa+wp0kcozr54c9gtLEC0axl/YBSVdXoE=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=Y7yrPwzWj6TPWwLHYoemGt7qakQW7EmWcyMJepxOyLjiXjkcj4+JIl5i6BhrlRbEJiQH3nGFQNbjksTIjGz7LFyCuwoO+CLci/+Q2O2eDBl4KTKylKNws2YaE9WhXI4faNbSE/pNhwm2Q+ZLgcQdWRb/mZl+8WQQtfXM8ZKXBx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=C+D1hk94; arc=none smtp.client-ip=203.205.221.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="C+D1hk94"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1779092092;
	bh=VlvHYJcnbA9RMb2L3as5QUrvusgr4XHBTKdubZkpjy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C+D1hk94b3hMzT/8ekdS2xeaXzoBbR9fJ1L/f3wlPaSTijq/46kMBMSZnffk2h8U+
	 np+KrZ8vA7nShgmBbntAyF/86WPQTs+Kf+Zj03Ejm8i7NON49RHJEG3cqhCLklezZn
	 L7tKbVY2KddfZG0VG31Qqg+SE+OLjO3uohwjtPhI=
Received: from China-team ([47.95.114.252])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id 3AB380DA; Mon, 18 May 2026 16:14:43 +0800
X-QQ-mid: xmsmtpt1779092087t2x593r8g
Message-ID: <tencent_012481AD8B713E60401A2269D96B463EBE09@qq.com>
X-QQ-XMAILINFO: NHez4Gj7c926xtgHTxF2NSl8ziyAnoRttSZRn2uYyHYPRdaeld2Fv6+F72L4gt
	 om25mxAmDBeTFEomJYnX5MxrBdV/2+nComXOqsfZ2yxtx3HsOmYmH4jq40ks9eos23ZuHygmDc1A
	 FaB4GlhmcT3Ei2LZtcp/CZ+cOcYAvF9cU+lvJY2lVZcacoUpYjMVa575Hz3tD/eNWJdbe5yCJ23X
	 I2XcpqC110zXOoCYMGOCbk3Z9nEzOWCgWhwVXflL+R+OxxLBhBisoMCRoqhqwzafXM6zXsHqZJux
	 XqVah81pd6UoVpt9pNOnuLuENhMEhhYz3jAu9l8pDKixc3GHclcL5Q0zEIJOT7hT3CzeXWETlpqm
	 XTLTKWIyzcqRFTt6fEOsnzEqkqFZyIpUIrauJSZtiO7FftgEt0XQ6qOJBYj7U32TCyVJKOMu6GSI
	 G4gghGIvpP7TyfmaD07gdw8SzYEG7W/m0chk/L1NpZl9Eb4h8WMgJZaMMncUpnT3qyHIyQ+Jtmcg
	 Yy3QOMwBXGO/C7tFlZSoMLQcE/30f9PyEkuMyMPCVrFiKgSwijZl6eDpPZsGFBS4FXIgdjBxJJbS
	 BSkBH1pN0fBM3+zhIuvJdSm2ZN+VCyfPn380W0cdH5cdTG2hhe1nRLXXQgfk0r01atsAXGTsJKmV
	 yorcMpRTQYr0aFbYtYwx8GOSmYkTABLiFNKIIQDLsQnUuSX6cleBY6FWbZ3udt7wBDa1PaXllhhP
	 +Aezhw9qmVr0qUP1vwUSB/TEHEgLQf1/xuO98st1KCEBX9X+f9plZ8SzhkelymV7dP+W5K0a89OI
	 Z/WE0gFLOgU0EKAN0cxb/tYsWyiM2YIJM7qewJOjCuGIi8CPYEd05mwZTjgRKc/J77xTD4oXuOuz
	 S05RIRTjHnmhtpqkj9YqsthXd7neOOTnJMvuDVhhUgWHwpdyzGk5/LqdAi8GQnOTUN7TZvt0Li/l
	 f8hLrEfe1kAVaY/ZfM17zJlrI0Xs7Ue4+j+tuO2mO3toIdzR2ehvzGkJJKcZsA/R/pKOuKu1Y7Ku
	 1AaKYpyyLqwBZcmfdZz57E9Ry+h7c=
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
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
Subject: [PATCH 6.12.y 2/2] smb: client: fix OOB reads parsing symlink error response
Date: Mon, 18 May 2026 16:14:01 +0800
X-OQ-MSGID: <20260518081401.21386-2-alvalan9@foxmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260518081401.21386-1-alvalan9@foxmail.com>
References: <20260518081401.21386-1-alvalan9@foxmail.com>
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
index 35d2933982d3..fd331a9f2f4d 100644
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
2.43.0

