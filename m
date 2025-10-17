Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA3231815D
	for <linux-cifs@vger.kernel.org>; Fri, 17 Oct 2025 10:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760698039; cv=none; b=C0EdSDQPpuYFE/D60vMzdufRnQx16gc9h8DD9YExre+C9luwGLXZEN89zztOHKyyBk+iFARm20OUGvAsjZZdL8gVTLpBMFoPXl/lBN3lLhTu/NvWO1oiD8/PAwa5THIQylx9a4UgmTAdAoE+sYdtvoLBhUrLwDnt68i0s1C3Dro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760698039; c=relaxed/simple;
	bh=SsjGT9r6HTcpAf+hm/ib3M0giSRUy6czGOiO/GTMoEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cy5WbdI9ZTCi0bZXJO/iPsheReDdkVXNwVMZ8ujFWcaAjq1LwnWbG5h+0L8XwpbP5rERDjpVoVz+i7sgTTWbiChfUTzbzXMa6seBHZfS/Y0MwnFFjXpxirdSb66Zt/1gR2agaXXLCEmHuEgicJG+1+zHgxSEFuel09LxftwNVIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o88TdpTN; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o88TdpTN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760698036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LZYpSan4Xtg7ipurLAFtn4+9Ilq4Ux2WxUZkDOjKwiw=;
	b=o88TdpTN4hfthhPIvkcfwedosu8vdQLJKse3L54R5aKjmm/TCC+BxMA8s/VTFThpJ6nIxD
	LV4X/Q6P5FIAVwhYjsU2mma82X6fSsWJGnUMJupc9D2qJYx5rD/Jx7MDu7CUel77lZK3XM
	5syoOZyZh0SzzeSJEfn9Wp7DKrdkZ+g=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 2/6] smb/server: fix return value of smb2_notify()
Date: Fri, 17 Oct 2025 18:46:08 +0800
Message-ID: <20251017104613.3094031-3-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251017104613.3094031-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251017104613.3094031-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

smb2_notify() should return error code when an error occurs,
__process_request() will print the error messages.

I may implement the SMB2 CHANGE_NOTIFY response (see MS-SMB2 2.2.36)
in the future.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f80a3dbb2d4e..5b5f25a2eb8a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8787,7 +8787,7 @@ int smb2_oplock_break(struct ksmbd_work *work)
  * smb2_notify() - handler for smb2 notify request
  * @work:   smb work containing notify command buffer
  *
- * Return:      0
+ * Return:      0 on success, otherwise error
  */
 int smb2_notify(struct ksmbd_work *work)
 {
@@ -8801,12 +8801,12 @@ int smb2_notify(struct ksmbd_work *work)
 	if (work->next_smb2_rcv_hdr_off && req->hdr.NextCommand) {
 		rsp->hdr.Status = STATUS_INTERNAL_ERROR;
 		smb2_set_err_rsp(work);
-		return 0;
+		return -EIO;
 	}
 
 	smb2_set_err_rsp(work);
 	rsp->hdr.Status = STATUS_NOT_IMPLEMENTED;
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 /**
-- 
2.43.0

