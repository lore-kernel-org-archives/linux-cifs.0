Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913C0156236
	for <linux-cifs@vger.kernel.org>; Mon, 29 Dec 2025 03:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766978202; cv=none; b=nyhESBGyqbFbfOhZ1owJRxBN+GOJnbzHE12xFOvrodLOvbRfLk35Z1RGi2eW6KNQuBlHRkk/e2S4AHEpVfEtQexYdzzQbk70VF7OgrBDYmQA0E6qQrOjEuzzNN85nUa7gpId3y6i3HMWv0ROoVyK5gUaNiyIEclDcXDiy70Mzzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766978202; c=relaxed/simple;
	bh=PAqFypx6iVse30Y5pgO6f787j714BU24cMZ1vXV8QBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1ahHR14gyF9r4Zkl4c+qh+cwc0FM2V2N525l7j8cX+22K/vV0kjF0lOLrSfTazp8ePql78JrcaR5mE75xOMoENn//v0h72cGlooP9fGDdJn3WDfYV8qQ7fvyo9i15XFcRN9RdkTPNl0lVe9nl2Qj8Q0oRRJJJiDlNQdLdTbO7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a6VWimFp; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a6VWimFp"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766978198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/V4MbBnADYpGknQJ/0M2hZ76Wv4siTk13mUVvVc0uow=;
	b=a6VWimFpYwd+w2qNeYvUf6sQ3Gt5WPNWGQGmbjZ9mvkDkrNsqdJscgVzpOjHOxJC71C+jm
	JTcRhaBgV15Ju7u/Te853HWpfTKJ/LOzF/ENFLLDNFO0V0Q9SND42sWMbrTuJRMecLqGXH
	daTrXBx/sNhpp3rB/Y9Vv6BQMtgIuh0=
From: chenxiaosong.chenxiaosong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 1/1] smb/server: fix refcount leak in smb2_open()
Date: Mon, 29 Dec 2025 11:15:18 +0800
Message-ID: <20251229031518.1027240-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251229031518.1027240-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251229031518.1027240-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

When ksmbd_vfs_getattr() fails, the reference count of ksmbd_file
must be released.

Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6a966c696f7d..dc730fe348e4 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3007,10 +3007,10 @@ int smb2_open(struct ksmbd_work *work)
 			file_info = FILE_OPENED;
 
 			rc = ksmbd_vfs_getattr(&fp->filp->f_path, &stat);
+			ksmbd_put_durable_fd(fp);
 			if (rc)
 				goto err_out2;
 
-			ksmbd_put_durable_fd(fp);
 			goto reconnected_fp;
 		}
 	} else if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE)
-- 
2.43.0

