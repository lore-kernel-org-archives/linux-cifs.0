Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1691269D18;
	Fri, 31 Jul 2026 07:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.16.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785482478; cv=none; b=lnpF+0oSAQt/V+NyZfj+9bXd73xwwZrGpD8u9GOXHsqjMQILtvDCB4C3/9v1tCDLLfGS7eAcmFV0MggVt0SVOQtjPQtyExHBYkGnROjyyaPjpdyyzA1/46HU8wZDv9BEoRstghNa9KB1CngGbkWfZWq5yz1hxb+1+k/KZ4lbbjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785482478; c=relaxed/simple;
	bh=2WJaOmAF+7fB2OAiTnV0nYDau6KaYJx+R/wNmdFSDsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UpKetKavl3hrWVWbnCuwdzEYwpzAPPqK6s4tFMYERC02CmAI6pkukgjQv+WgpxGK/k9nG86WCMadzvXxURVoDYz9BvQ2jWDgjY187cXnZaWNsJeDEtA4TVvkv8CYL4iimpSOuWtLdv+KSvkuVkcP0KT2W4STSxJJ6cNG5KDOaaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=IYjgtsgI; arc=none smtp.client-ip=54.206.16.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="IYjgtsgI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1785482440;
	bh=Ce6qW5W+Jk1+jKSAM+mwYa7/IhvAa3xrkISU2clJRss=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=IYjgtsgIAPni27DslaSh9Q81t2RbZJg7RgjgZVABzo+oXWj0Pq+CjD1KhEr2D682S
	 72vtFttP3OSAAXhOmhiwfOuOdW5At6txMk3+BRL0ulnh+h3/mG1Zho3BkUUe6i8WdT
	 Nw/2cQPPoDJsBzHORLN4scn02nIWnPI4pQGCRyvo=
X-QQ-mid: esmtpsz10t1785482423t5bb2a327
X-QQ-Originating-IP: 5DNYXT1+bKa7fyWneT4LDVF7cbhFA6pbxw97DHF8ESk=
Received: from PEN202512010004 ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 31 Jul 2026 15:20:21 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 12660739180512652076
EX-QQ-RecipientCnt: 8
From: raoxu <raoxu@uniontech.com>
To: linkinjeon@kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	raoxu@uniontech.com,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: preserve STATUS_ACCESS_DENIED for copychunk errors
Date: Fri, 31 Jul 2026 15:20:19 +0800
Message-ID: <2DC5EE1DC892643F+20260731072020.1307022-1-raoxu@uniontech.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: MShfLn39PbN2fnP/xRJDk0a7BU1vn9lj7uLlXsBV/Gjv/crUT2PqABEw
	8pT6G3mqeZlEUCbAyjgc9n8bVOZ3KBtWDIvDDlUBgzl41HZXQPobie/il1jnFr4HbenmACR
	bBIWhWwtiRXXroamuziQlvs+YXMG95xqayf6fEKyRQWxcU018y53GWcb9ZWQHxCyGrOuo+k
	swbXVotilBllV3UE7EO17Zs3UXTpwWxQNiY7YWPojzNWMHMMK80U+DG5MTaxoU2Qw9Hv+SR
	aAIBGbgUhtbv8aY1ooL0zVHnnhgKoigCxjYoc5YnvxL/uNl8HRiRcHGJ9GAZhEtSbqdinPs
	lobQCyX7QnQMN8SfCGxgYiPjmVFhLbf1MFDa9lmx63OyA6jd8N7xfne9wNloQrTzj+dHiMN
	73aowtTUVNqkO6yqySPqpHZOss4uDDRsmH/Iuvdq5qQTpnebRO4Enw6DzMaslWcvVX+Z1CT
	U1JBxzol9jbO8KEBDzXtiirWX39bSGfn94enzwgzj2LfWl+piqGgP1Mn9PFLv1/Gwl3VgnF
	F1AR/uARAqepz1WPMSm++dTZcmNY/soOCFfYsYVTtPo2vgBNrKix+Tk9pBaZKlHM7JdMX0q
	rL7KczP4oCQhegBNJgwkw3zR1GXhbPSnqRrAlv0ty+AOyIFPTkcX2yVi7W7cphw3DWoc27u
	YW1oKlTPOMVsBrOCYD8uXAqCdgeD0wGv4q4pqg8I4rOQFsJJ3CAZybcsoaFIJdi9Mm/xF6u
	hpNe63Yd9hv6enrdGL6Z/sVOGsaC23qrdVVEUQxaScccLCgB5yH12DTf7ccuCYJg28J47Dn
	FfSl+ognlZFjm7MBsct5WpSrY/U2LBySgy7PBGlb2BOeL+CL1V9vrgNzgMCfkgUDi8MnQDb
	QtUH3/XIiFPzjmX+/ciOKShtR3Zd+DHaos5qjQtrSIQsnGg4FHB9G8gqLUO8SMJOd33LPyr
	mbpSMWzKPfFRcbSnyrJL53CDWaUa6MAR7WTfM9TsZkBSpiXE8uFyCKFIJGdSxd/xgy2k6lb
	QxUc1/j3/h6kgTaxHMD100SPxOJl9iaok1hTdRjNEraHXl44Ab
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

From: Xu Rao <raoxu@uniontech.com>

fsctl_copychunk() maps errors from ksmbd_vfs_copy_file_ranges() to SMB
status codes. For -EACCES it first sets STATUS_ACCESS_DENIED, but the
following -EAGAIN test starts a separate if/else-if chain. Because
-EACCES does not match that chain, its final else immediately overwrites
the status with STATUS_UNEXPECTED_IO_ERROR.

MS-SMB2 section 3.3.5.15.6 requires FSCTL_SRV_COPYCHUNK and
FSCTL_SRV_COPYCHUNK_WRITE to fail with STATUS_ACCESS_DENIED when the
source open lacks FILE_READ_DATA or the destination open lacks
FILE_WRITE_DATA or FILE_APPEND_DATA. ksmbd_vfs_copy_file_ranges()
returns -EACCES when its source or destination access check fails, so the
current control flow reports a protocol-visible permission failure as an
unrelated I/O error.

Make the -EAGAIN condition part of the same else-if chain so the -EACCES
mapping is preserved.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index bec692bca1ca..416bf1e55c81 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8524,7 +8524,7 @@ static int fsctl_copychunk(struct ksmbd_work *work,
 	if (ret < 0) {
 		if (ret == -EACCES)
 			rsp->hdr.Status = STATUS_ACCESS_DENIED;
-		if (ret == -EAGAIN)
+		else if (ret == -EAGAIN)
 			rsp->hdr.Status = STATUS_FILE_LOCK_CONFLICT;
 		else if (ret == -EBADF)
 			rsp->hdr.Status = STATUS_INVALID_HANDLE;
--
2.50.1

