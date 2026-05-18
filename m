Received: from out203-205-221-235.mail.qq.com (out203-205-221-235.mail.qq.com [203.205.221.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B063DE427;
	Mon, 18 May 2026 08:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779092100; cv=none; b=pW/h8r2559a67HiepNfEAi3x/XrQD+djB5suIDq/5f0wWRXDJsJiCAtVe0Nf9dwp8JM+xPPi/qpj0mDoN4Sfz4jikqf39edwSH6TfsDdIhlizCdfkGNiYqxTSU6vXO3mAe7B5QiPr9Okm6gcb4NDljVsqEcoG9SUMJ59s1b9dIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779092100; c=relaxed/simple;
	bh=vEN7JUqFS/Z338AaOtlOIsg9UfmeWvebb/hbi7DTIec=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=KHrKZsYWqkvImQqQZQsnU1gHQeZciUTVOscwWpPY4R79L8fv/ZD7e6VTEQmDL8wkWU7Rel/IWB3MBWJoj/w+kwIcUYdVovzaZY+6WFTGkvBC1MyxrlFl+1hlXqJ0mZMYKY22Gbq473NsxKmlCf3asKgeE9gPajOTGcoGUUhG7Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=zDn/ktmK; arc=none smtp.client-ip=203.205.221.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="zDn/ktmK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1779092088;
	bh=+o30prBLPQWw1lGqJwc06DlyrybE3RbNC5Z3QM6FXaY=;
	h=From:To:Cc:Subject:Date;
	b=zDn/ktmKtmcbK5NELmmEXQOhSo6vwMgf6sqGSRBBuzsyLEhjrv6BBgjIRIWpVtNG6
	 aLNAyOC7lfVvADUYeh8/39yKi8Nf/30qartZ5KZv/NJV0Bn+1CRl3enB7xKlaYK4z2
	 0wcbKwhHnjFFjrJk4wIXb6M7XZgA0l5x2dbXRbX0=
Received: from China-team ([47.95.114.252])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id 3AB380DA; Mon, 18 May 2026 16:14:43 +0800
X-QQ-mid: xmsmtpt1779092083tu063d7b4
Message-ID: <tencent_D303270C66A4818296B926E3A34112CDDA05@qq.com>
X-QQ-XMAILINFO: MYM3WZNSjOp9eiVY8f9+WwG/g7icWVcONLbMAlI0dGCyzvuo1zDyl6lfCQK4cm
	 3L5MvYqdlcsW5Ec22LXMHsYmWPMqmj7D84ocukB8vyVtYNag4sbLI1m+y//7aA4VIIe0IxVQSpBy
	 8Rh2Ml80h20GEIeglEV2RprkchUHOQujF23i33ttqbD6sIkZkiDb07CqZpYstpBMQKuhT9+qPPUN
	 VArMUQwM8anJ8jydGP14JaJIBSOIBmXKZnCzMvmEziOLGtpX4zgg11jlUjBpXRHIyhMc7T4MTEho
	 1vS1K4CjUbLJrMBUyYklrOF5QeNpdmwsxPighN2ubPlX8lJh9+C0uJ/8XGhiNOiyskxa35Fi0Wuq
	 8+1NzTmsxgJCU+QX+CGCCh4tFARhCb9RipQv5fCco94LoN8OAoRoUJTtnHt9A4bKELtcPiWue+UV
	 hpcr4dbMe6Z+vMmB0dP5RctNlaxfabglaiC5ZLrkcipjhovCCb7dUV02oPJ1SMoVsNA7R81swFGr
	 8+lTLHZzMtwefK1qdDibpdOsdcx7e44wc2gHLBII2AQOYvl2cEkF1ncAy3HXkW965GjSBa7U2We6
	 5xTd3t4B3UGQCafrWIZqxJth2SDAm2V9y+2+/6W/bucpcmSXzVtXiIx2LVkL4FG0oy15wT06wzsc
	 Inx2yyDKXRyGjMOQs4QiR/DW8axSXm6LtiBl7Tacfjf98zaEtIl7Exkd5pwpwcxP3+NcW0kQTWDI
	 SqM37gzcOEGhdiufKbcUSOFrJgAKNzHTasUl+wOtdGohZg96ZPO7FOj5hgLlAd56UHE7BU8fl1pH
	 MNH+CRKDp8Y09F1w7IxpKwUZRjhhbfMzNM/D5/DQhPg7cNFs7Gr00+Co4v3qmMRz2yc511uQcSiD
	 p8FD7IXPcxzRzJT8JOENBrY/RCegQEYNBKLJNarXzcCahtcrmqfVZSwIRF/FNDSzNgqoDElvhVhg
	 Fv3Anf+VLmeGexLfl+ZO3HuS3RX8pNCnENPkIb9/BNgV1is+CHhRDcqSFKmgSHAoDb0KM+APh9+u
	 FpDT0YgdOHETWHF3AZRiz2r4apHrY=
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
From: Alva Lan <alvalan9@foxmail.com>
To: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Liang Jie <liangjie@lixiang.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 6.12.y 1/2] smb: client: correctly handle ErrorContextData as a flexible array
Date: Mon, 18 May 2026 16:14:00 +0800
X-OQ-MSGID: <20260518081401.21386-1-alvalan9@foxmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Liang Jie <liangjie@lixiang.com>

[ Upstream commit 215b7f9ecb8d7c14d56febdcdd246f3579c32aba ]

The `smb2_symlink_err_rsp` structure was previously defined with
`ErrorContextData` as a single `__u8` byte. However, the `ErrorContextData`
field is intended to be a variable-length array based on `ErrorDataLength`.
This mismatch leads to incorrect pointer arithmetic and potential memory
access issues when processing error contexts.

Updates the `ErrorContextData` field to be a flexible array
(`__u8 ErrorContextData[]`). Additionally, it modifies the corresponding
casts in the `symlink_data()` function to properly handle the flexible
array, ensuring correct memory calculations and data handling.

These changes improve the robustness of SMB2 symlink error processing.

Signed-off-by: Liang Jie <liangjie@lixiang.com>
Suggested-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
---
 fs/smb/client/smb2file.c | 4 ++--
 fs/smb/client/smb2pdu.h  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index b7ab18d4bedc..35d2933982d3 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -42,14 +42,14 @@ static struct smb2_symlink_err_rsp *symlink_data(const struct kvec *iov)
 		end = (struct smb2_error_context_rsp *)((u8 *)err + iov->iov_len);
 		do {
 			if (le32_to_cpu(p->ErrorId) == SMB2_ERROR_ID_DEFAULT) {
-				sym = (struct smb2_symlink_err_rsp *)&p->ErrorContextData;
+				sym = (struct smb2_symlink_err_rsp *)p->ErrorContextData;
 				break;
 			}
 			cifs_dbg(FYI, "%s: skipping unhandled error context: 0x%x\n",
 				 __func__, le32_to_cpu(p->ErrorId));
 
 			len = ALIGN(le32_to_cpu(p->ErrorDataLength), 8);
-			p = (struct smb2_error_context_rsp *)((u8 *)&p->ErrorContextData + len);
+			p = (struct smb2_error_context_rsp *)(p->ErrorContextData + len);
 		} while (p < end);
 	} else if (le32_to_cpu(err->ByteCount) >= sizeof(*sym) &&
 		   iov->iov_len >= SMB2_SYMLINK_STRUCT_SIZE) {
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 076d9e83e1a0..3c09a58dfd07 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -79,7 +79,7 @@ struct smb2_symlink_err_rsp {
 struct smb2_error_context_rsp {
 	__le32 ErrorDataLength;
 	__le32 ErrorId;
-	__u8  ErrorContextData; /* ErrorDataLength long array */
+	__u8  ErrorContextData[] __counted_by_le(ErrorDataLength);
 } __packed;
 
 /* ErrorId values */
-- 
2.43.0

