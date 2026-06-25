Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCCC175A64
	for <linux-cifs@vger.kernel.org>; Thu, 25 Jun 2026 09:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782380267; cv=none; b=ZK/OrXYbbhVMeTOvRhcgbFTHnGfbdrgflqdQi1V1Wd4ZiCCHZMVoN4mogkAK9TlChXBffljXNyhLvDf6I3k4E4w1VDjG+BAOV8KeKwA8taNCc1whNvBmfS/ys4kA+bzsrjXsqtPctWtsq0W18I0DBfyKwVt+WElppJNw+SkwRUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782380267; c=relaxed/simple;
	bh=HQzigTFa8gQx2GuBRk2o/7jQU15EqjfWZgAoqf0zDUs=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=tvHhn1R2IWuBB4oSrO6QgwR1EtUAXsBPvpoO2Ia9PIVNcILvEdrqmReeI6lF8OeOLDNLArhz98QwNTSAUk9D8mwg9i+kCTg/QCdr7wIMoMfrmj+E36qU5KvHFmOB1FRLL0+FsOJZsMJFOKsGgaThVNSzc4Gy/NE6shFFJEGmHDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=x2wm3FLz; arc=none smtp.client-ip=43.163.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="x2wm3FLz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1782380257; bh=5gFITyLWX67ieIdi4Byl4Y5CUgUp5kz/X9xNvUb5PHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x2wm3FLzKPAzYD/+Y299ED7srZSZ9b3P2ryZeqKIOYffoXJsMw0mZbvQFFK3CSSV6
	 mp3ndFn3XPWHLgPWNkRW7bGs4dAw2fpRlZHVrxC4oPrjpEqP9xMqZnjlp7CT3BaLXk
	 YSI/h7PG57x6uV2qd1WhqCtbEam5OQdQ9lLanM+U=
Received: from localhost.localdomain ([116.128.244.169])
	by newxmesmtplogicsvrszb43-0.qq.com (NewEsmtp) with SMTP
	id 88AA22DD; Thu, 25 Jun 2026 17:34:10 +0800
X-QQ-mid: xmsmtpt1782380056thycjyeb5
Message-ID: <tencent_63ED0C7B6581A66C3548B30348BD53B24908@qq.com>
X-QQ-XMAILINFO: MwP4Bu21pARcxLOl8K5lRHWN1JGqCufIicWvMRrFu1M4q9oEjKpvyo79EQhpLD
	 rGxUGyZFw9Qm6tXHOuAYwQOrXyTLYlIwRZj8hDTZ6CAPY7t5P7rxkNkJiJOczUGTscoNOGuHmFQ0
	 xD+vLca8i/AQcPob+Nk2xrPvfyygPZzEJFr/z7scCsaDwGSAJqAekdU3gKtVdp0baSe57X9WDI6h
	 AE2Kwn6h5KZPgmJawQsaiP3o7lY+zxfLHogXjtrYTVp1aIErujZOl97Bu5CTBr0ZR9ynlAWqxRHP
	 q0tcXl4AL5Jsh6fHX6MMU0Mr0bd9AW5hjtZPaxSy5k0JOsit4dTqLqX71UbwGqJoRDoABxNjFlz1
	 CVacgCuOAoQUDD7sjI/tmy1zvvKyhye0f/L8toOQOHSk+42v+CdxUR0Qd8esE43JrdFOW7sBfVZ2
	 81tXXvz9pz1wOTznjnXDgyRfDoy0TFnvEJz/89b5N1Fwb0NFU7jVHWqpldvXg33CB6U/AD2Wzvm4
	 GnUagreEURUMUVCn+7jjUkrQV8NJnNGi7Uf5LzKDdH+bONJoksE09wTvETbRKXza4lvjfMynHFdd
	 yqlJe56jFYbrWmW34fCp345EOtK90MDS7VHN//EgyTD0MrJrYgkmYSKuQeNTNZ+K0zB5fi+QWTZ2
	 S2ABaDKDnweCUyANhZB7Cs9Ui7S7SoscFu6k5XzBmU2jfegtSy6nt1fx0FUK8LS/pV1EYexKySOk
	 pNSqwOgnvWiWXQepGoD9JHJzUTRD7o87MP8y9PzuNR97BfLhCpD175hecBJ30ms2Cv9QGQ9GxBfG
	 HhXgkeUVK3910l5TdJWnGPyKRdaixNcBK5m7BaQb3Veg/81+qDRyoePuS2tZ0Fzu7qvs7PZlW7NB
	 DIqs21CfGfH/P1Db8wNU7wbYNHjFemJbuiBH3CeJyayTfezKeiy8WA7TVEKwAl7o/cCaH1HWfL62
	 8pFfvqsW62FQ0ZhTXaxfnTPIiYnAMOFyw2mBl/ECV8++uyt4z+m6vxZ24JtozGRoGUsmrEvReq2C
	 FyauHV9FZQqH8RmCtWW7lIgNPG8bA=
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
From: Haofeng Li <920484857@qq.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	Haofeng Li <13266079573@163.com>,
	Haofeng Li <lihaofeng@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v1 1/2] ksmbd: reject undersized DACLs before parsing ACEs
Date: Thu, 25 Jun 2026 17:34:07 +0800
X-OQ-MSGID: <20260625093407.2859146-3-920484857@qq.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260625093407.2859146-1-920484857@qq.com>
References: <20260625093407.2859146-1-920484857@qq.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Haofeng Li <lihaofeng@kylinos.cn>

parse_dacl() limits the attacker-controlled ACE count by comparing it
with the number of minimal ACEs that fit in the DACL size. The DACL size
field is 16 bits, but the expression subtracts sizeof(struct smb_acl).
Because sizeof() is unsigned, a DACL size smaller than the ACL header
underflows to a large size_t.

A malicious client can reach this with:

SMB2_SET_INFO (InfoType=SMB2_O_INFO_SECURITY)
  -> smb2_set_info_sec()
  -> set_info_sec()
  -> parse_sec_desc()
  -> parse_dacl()
     -> init_acl_state(..., 0xffff)
     -> init_acl_state(..., 0xffff)
     -> kmalloc_objs(..., 0xffff)

Thus a malformed security descriptor can make num_aces pass the guard
and drive large temporary ACL state and pointer-array allocations.

Reject DACLs smaller than struct smb_acl before doing the subtraction,
so the ACE count check cannot be bypassed by the underflow.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Haofeng Li <lihaofeng@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smbacl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 340ea98fa494..fc9937cedb01 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -374,6 +374,7 @@ static void parse_dacl(struct mnt_idmap *idmap,
 {
 	int i, ret;
 	u16 num_aces = 0;
+	u16 dacl_size;
 	unsigned int acl_size;
 	char *acl_base;
 	struct smb_ace **ppace;
@@ -403,7 +404,11 @@ static void parse_dacl(struct mnt_idmap *idmap,
 	if (num_aces <= 0)
 		return;
 
-	if (num_aces > (le16_to_cpu(pdacl->size) - sizeof(struct smb_acl)) /
+	dacl_size = le16_to_cpu(pdacl->size);
+	if (dacl_size < sizeof(struct smb_acl))
+		return;
+
+	if (num_aces > (dacl_size - sizeof(struct smb_acl)) /
 			(offsetof(struct smb_ace, sid) +
 			 offsetof(struct smb_sid, sub_auth) + sizeof(__le16)))
 		return;
-- 
2.25.1

