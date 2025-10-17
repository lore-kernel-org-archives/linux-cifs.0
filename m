Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA082D0627
	for <linux-cifs@vger.kernel.org>; Fri, 17 Oct 2025 08:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760690864; cv=none; b=iruKoIfO1uUJTTNvuz75WIQu+zQx+xk0urZfXik0r+iJEjK+0YH52Yu7G4AM2tzoC4IBN1LGPa/97bvXQefAembans6KNp66ZesvH9f5obsmOz7VaCngKByZoBvbtuCEvC8HGILHOTCpLUIZxsr2uwrik/ixDcaWbWAAPufse7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760690864; c=relaxed/simple;
	bh=Ba+3pejaChmk2QyZVT8xo3VjUarSz5pmVAh4K1rtou8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDg3b4LbOLirTyEsfw5a8t3BPk7HbraVsmKe300o8njecMYnK5nTnU7E6k+riKi6rKJyknQEccptCS+jogNuema7eVsi2X8/1RsRdIVk/abEe0e10wWrvimu3Y7GN/v9uf7J+yC+pppwoi78zF1U2/d3+GEy4X2yPYBcb+GVbGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FO9sAZPe; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FO9sAZPe"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760690860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/a90+DgKbkpVVTV75K9PtVsd1T594Qs1clx0lbfizLA=;
	b=FO9sAZPeoIV2VbqNWHQ2pWokcicadh4MQFhweuI+gT/Qxb1fZcSA9Dvx1pX8hLndfWa2CZ
	TqJqU8np0tt0JClVMcwzyiXpDA8SkRXo0umLFfVNe7IqRwaQ7C+WNdjA3EW3I4FQeE3Zbv
	xXavxTNryOa3+HFcRqv6V5wCIU4eNfg=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 2/6] smb/server: fix return value of smb2_notify()
Date: Fri, 17 Oct 2025 16:46:06 +0800
Message-ID: <20251017084610.3085644-3-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251017084610.3085644-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251017084610.3085644-1-chenxiaosong.chenxiaosong@linux.dev>
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
index 83d8a325b9ea..c040df0a2073 100644
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
+	return -EOPNOTSUPP,;
 }
 
 /**
-- 
2.43.0

