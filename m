Received: from out203-205-221-190.mail.qq.com (out203-205-221-190.mail.qq.com [203.205.221.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42743E16B5;
	Mon, 18 May 2026 08:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779092190; cv=none; b=AXQ+L9DSYcEqMi1eASEFtofVMtdZVOPnRAVPQBlCb/5CA1Q/moJu0qGnMuwyNReQFKHQbLxmdsH57zNukZ6gW91EsQrgc8TQFxO0TSJL2ws/38i7zSyma4uzcTae57iHpHb66Pz/jpAjW7i1GWMuQRFrjFHTo0sSAjGosnbZAYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779092190; c=relaxed/simple;
	bh=JhIcdbdQLcgj4UKpNSj9GSm1PBD5jnm5zV0iBTYrM4g=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=RCaV6Yuv/BNtl62FtDb+K/LBnjc9ZU41Dr0f0Q3aWyYXnd/kkfTYbliBC0qolwxb6nkgaSRO01GgP89UJ+2tG8bTWzYYUtehBhctdREGyMDicztKUvDfQQ5wsTT8ybNsIG2mnzrECXb7N8uR1DgAFgLrrFZS6ozP5vaNtmYpgXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=yXPetU0+; arc=none smtp.client-ip=203.205.221.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="yXPetU0+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1779092179;
	bh=4IxuhOwzABNC8IL++ludYkU8O8WExX1VY8dfqrvsQKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yXPetU0+ZZV4gq6h47BGECDRn3ZEEliVGlASFxzaFBHDODNSk6UMownffIocXPBns
	 w5dBMGJsyRUajrKFZgR3W98hyWytsZB4BMmNI+DjC8hwvX1PEl+CkyZWl+lcRG7Yiq
	 uNiFnZJG4/Dn65aIlNmo2m8ia0OeL9lRA9hvXAYk=
Received: from China-team ([47.95.114.252])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 4018BC9E; Mon, 18 May 2026 16:16:01 +0800
X-QQ-mid: xmsmtpt1779092170tmzdlk0g4
Message-ID: <tencent_7A69076B1A3E822455AD85719260081AEE09@qq.com>
X-QQ-XMAILINFO: NX3IH4pixvQA85ED3sK18DcgVIekmMgB5Yc0FuSe4YZ0LJhmDhqP2LOE4fu8QY
	 NXE7Cr2huRHHlD4Y/hlpXScQq2/MQOvN1mLMmekSCA+AvqcKFAEvpChlRyPmANjmZTwe7DWMphRW
	 18LomtP29BLkmvXNr/HaO/2MasQzoZyd6ZC3aRoczPzvMsvL1AFqq1WOvdlIn8IY7QqpMzwPtdiP
	 GlNusFX5bbnEiKBZjZ3uAU3NRFgHnabH4wLads0jBo7BGgcn3Y1mWaOXBuRPrn+bZG4PaJa5Nmih
	 rvv+wm4ryRX0vJXNzk7kp5betwKZ4U/l1DUWeUw3OJOu2f5KfdF4hR4ExzEeTiu9sh8ABpAN5mrt
	 EeP1e7Sq92psCaRq/Z8gWKhNDaZfBGW0dG4sNSX/ADMxJ6n35/BxJ33O/lFDiqIUfSGjHWSoDjJ5
	 KwX6sinRDZDeQsQ5+3j0yR2MvbYXB4OPYxP22nQuK6eAnL/tJv9fV3T3kBAbd1R35vZ0+Uk0t26D
	 OVn7sLDuT6FbEPaQQhuKry7DZz9BgmnqQOMEmwRp/cY/TBo0ZUqpK25e3m9uSD8KfwwMpMbXf899
	 CxLrldKZJTpPjQkvLPs8a9OmDkkndFbMiWfZcCpca5mdaG01Vf1b7B1hOMVhOaYtVy9k/04a4HNi
	 IXVvc/THuWCtWtWqP6OV7eeAyPS128OpH6wC9yb9k0Mm4PIjHgaJyVyRj6Pk8RTANhFn/cVr5xCt
	 pYmEBsXlCSkc0PJNkC3QuPdkQi6C9d5wzbkaxnoa2ovFWYyfR13MMZaZqGFh/ZJyewU/QP8Hdef2
	 PFQFUVJorrwMbvK8PMztf5tB7LEHxb3H9JiUITZusJfMWTTwg8fANCvD08/1CaI1B64Emg0uVlVV
	 KdfakOhXMLizq8n4SVkObdc9chPjOOs1Kn1V+EssUn/D3+V1jYdDaIfw+wAUbAPv+CLs3IGBAsrH
	 GukaohjcqdL+LgWsdRufZyDByRhCPS/vwRzN/vmauiWlPAfESMNY27K4PpC+CvM5AMqf+IilkbPl
	 SKbIcLPfhdEikTRauCuG28chzVkpospLGE5QtB8kl3d7JGafqpf5fm0Naao+lDX+Ge9TY98sJrhT
	 vMxaOB6KbJHlvioljal/H6KJ6fagHdW5BRx3tv
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
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
Subject: [PATCH 6.6.y 2/2] smb: client: fix OOB reads parsing symlink error response
Date: Mon, 18 May 2026 16:15:54 +0800
X-OQ-MSGID: <20260518081554.21484-2-alvalan9@foxmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260518081554.21484-1-alvalan9@foxmail.com>
References: <20260518081554.21484-1-alvalan9@foxmail.com>
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
index 3a5b62b29806..044512b77448 100644
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

