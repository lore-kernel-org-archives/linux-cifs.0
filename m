Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.254.49.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793673944;
	b=PJqRASfmzaZ8dwZXv1JzehgmR6gsyHwD5vRsQXnr+vw//t3yHSXLukmoe0riBTZk9Scm
	 IzFj8mxKJ6BepHEBT+GYGa1nYWP1UW56avnrwFliiN9/FLaf8Hhh4vQfTHg0wIFeHkIJG
	 VW9d9iDRjmbPJq+PKmdLVG7KKCt8EahZvC77f/6nxfdc2vAMOQu/20FGUkFcM7Lm0/Bji
	 jxGx71ifiXbTATZDisrrm8wjoAi1SZyr3zbkkKS+poMSyRKBQwbKDdU2IaHBcWIYPi3c1
	 UY9YHQRlJiz70XOxkSoRBRxTSdq+wO+Tq8adXQ0tMrfR6dmIEXNegm+f496Q3KK4ezg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793673944;
	h=DMARC-Filter:Received:From:To:Cc:Date:Message-ID:Subject:
	 Content-Type:Content-Transfer-Encoding:MIME-Version:X-HM-Tid:
	 X-HM-MType:X-HM-Spam-Status:DKIM-Signature;
	bh=nwlAC0OGiFDOCcl9hz0k9DtD6vLQALBgD/KW414bxrI=;
	b=y2jnBc3O89gSDh/jLAok3hxt3AgY/ApO/WSHX+AEjVBy8avNgIxab0AkL8LAApt7uZX4
	 MBw7wFsWoqZ8XabfYdeVTaf1yNLAqTjzuDmkwl4/xa7QsQqpNm9UGZsN438l1c5dwOffp
	 GVljYp/ZB3iG/dkv6jm+rVQspw1hku5xupayw/EcbknkGNMo0Gjszs1S3+pEPE4rC/oQU
	 tMwVaosBgjA4rayA4/OWkRgxdTjp7RsGcXRAqbSaEEdpRaGdHKLvIcyRpi5tpOEEI73MG
	 V/1ErHAvPD6WUvRfaLlO2TOLrXfITypI742o4gJdZRnGUy6dIgbHpq0ITcqWda0w5uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=stu.pku.edu.cn;
	spf=pass smtp.mailfrom=stu.pku.edu.cn;
	dkim=pass header.d=stu.pku.edu.cn header.i=@stu.pku.edu.cn header.a=rsa-sha256 header.s=default header.b=cjy4FTON;
	arc=none smtp.remote-ip=45.254.49.197
Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18823606D80C;
	Tue,  3 Nov 2026 02:45:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18823606D80C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=stu.pku.edu.cn header.i=@stu.pku.edu.cn header.a=rsa-sha256 header.s=default header.b=cjy4FTON
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa (unknown [IPV6:2409:8a00:3c11:dbc0:2581:8e:ca0f:59ab])
	by smtp.qiye.163.com (Hmail) with ESMTP id 534316a46;
	Tue, 3 Nov 2026 10:45:26 +0800 (GMT+08:00)
From: Yifan Zhang <yfzhang23@stu.pku.edu.cn>
To: Namjae Jeon <linkinjeon@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, linux-cifs@vger.kernel.org
Cc: Tom Talpey <tom@talpey.com>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 Steve French <stfrench@microsoft.com>, Ronnie Sahlberg <lsahlber@redhat.com>,
 Hyunchul Lee <hyc.lee@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 03 Nov 2026 10:45:19 +0800
Message-ID: <179367391951.8187.2063761250230294066@stu.pku.edu.cn>
Subject: [PATCH v2] ksmbd: require NUL-terminated EA names
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-HM-Tid: 0aa19f4c194903a2kunm153cdd6b10a872
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZQkMZVkgdTxlJQx5KQk5LT1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJT0tCQUMaS0tBSBhKSkEfGRhLQUlOQ0pBQx5BGBpLHUFOQh
	oZWVdZFhoPEhUdFFlBWU9LSFVKS0hKTE1DVUpLS1VKQktLWQY+
DKIM-Signature: a=rsa-sha256;
	b=cjy4FTONylSIx4uMhfzzjFXxcAxWqBdMUhUqs+j80qD9QD7IGRqMWHmEK193quWLGKBeH1UzFr5BejEu3/0k7XSNjRtIjNwJMQgBslMXKUh/17fE97816ipigXwhniC1RQDLVO88sIt7ZEy6B29CLz/CgXi82+RyzqLQq+DOhqg=; s=default; c=relaxed/relaxed; d=stu.pku.edu.cn; v=1;
	bh=nwlAC0OGiFDOCcl9hz0k9DtD6vLQALBgD/KW414bxrI=;
	h=date:mime-version:subject:message-id:from;

smb2_set_ea() verifies that the byte reserved for the declared EA-name
terminator lies inside the request, but it does not verify that the byte is
zero. With SMB debug logging enabled, the name is passed to %s and the
diagnostic reads beyond the request allocation.

KASAN reports:

  BUG: KASAN: slab-out-of-bounds in string
  Read of size 1
  string
  vsnprintf
  _printk
  smb2_set_ea
  smb2_set_info

Reject an EA entry whose declared terminator byte is nonzero. Return
-EBADMSG for the malformed buffer, and map that error to
STATUS_EA_LIST_INCONSISTENT for both SET_INFO and CREATE.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Yifan Zhang <yfzhang23@stu.pku.edu.cn>
---
Changes in v2:
- Return -EBADMSG for the malformed EA name terminator.
- Map -EBADMSG to STATUS_EA_LIST_INCONSISTENT in SET_INFO and CREATE.

 fs/smb/server/smb2pdu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index be226664b8afc..c0be3265246dd 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3454,6 +3454,11 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
 		if (!eabuf->EaNameLength)
 			goto next;
 
+		if (eabuf->name[eabuf->EaNameLength]) {
+			rc = -EBADMSG;
+			break;
+		}
+
 		ksmbd_debug(SMB,
 			    "name : <%s>, name_len : %u, value_len : %u, next : %u\n",
 			    eabuf->name, eabuf->EaNameLength,
@@ -5606,6 +5611,8 @@ int smb2_open(struct ksmbd_work *work)
 	if (rc) {
 		if (rc == -EINVAL)
 			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+		else if (rc == -EBADMSG)
+			rsp->hdr.Status = STATUS_EA_LIST_INCONSISTENT;
 		else if (rc == -EOPNOTSUPP)
 			rsp->hdr.Status = STATUS_NOT_SUPPORTED;
 		else if ((rc == -EACCES || rc == -ESTALE || rc == -EXDEV) &&
@@ -9304,6 +9311,8 @@ int smb2_set_info(struct ksmbd_work *work)
 	}
 	else if (rc == -EINVAL)
 		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+	else if (rc == -EBADMSG)
+		rsp->hdr.Status = STATUS_EA_LIST_INCONSISTENT;
 	else if (rc == -EMSGSIZE)
 		rsp->hdr.Status = STATUS_INFO_LENGTH_MISMATCH;
 	else if (rc == -ENOSPC || rc == -EFBIG)
-- 
2.39.5 (Apple Git-154)
