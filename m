Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152AF339379
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 02:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465798; cv=none; b=M5DsqOmnpeNcLIcsZ1SsLezo9qdsS2zAfhEaGI71ykYYhxEqKcXDLdiQ5oL53nVOtx4bEfi61oGlo5DzWVy+Fiqq+ovVcaiDAuC7ecAXEaO3BEoBVDVL4rXOAv/8YqP9cF/nSYqKiIp5/VYYr+RDkCbMNJN0dRQogTYfN6vIu9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465798; c=relaxed/simple;
	bh=vwdUzwKh0KAFhPeTsyP4x2FQ2RCNtIaVNgRM2gjTMJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h59cEeheN0JxSJDtwop2TRjA/rSh2w5yajQmHvuIuB+x6Ikmbrmh4V3FeUgPCiGiIcN0gL0SCW9qyvEFCE1jmmUBce3GAXhl3ahsYZEe5QeycvzxxJkOCaT1pkWufWL670/fQsU/Fyd1HcMNXAtarvt3R+QqMuZmk4AMUNz7Zjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oznpABBA; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oznpABBA"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785465795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8jtR7hvGnfBi/6snlM35QeCcGiAdInJhF4TdwagE7r8=;
	b=oznpABBA+gz5qXQViUzRcV48k7hnOXzR4Re/BmlfaaqysKDKuCdV4s1noTWOZgoAxPH5VJ
	p7Xnmr/jmddS2Wz6Ywcym1oEFndD73xqyJFEke6pC7613aXQa0sNvObjbkHT90I8D45i4T
	5VkO/3kN0ZTkcUlFDWuTHbUrHWHnqv0=
From: ZhangGuoDong <zhang.guodong@linux.dev>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 1/2] smb/server: fix memory leak in ksmbd_krb5_authenticate()
Date: Fri, 31 Jul 2026 10:42:52 +0800
Message-ID: <20260731024253.148107-2-zhang.guodong@linux.dev>
In-Reply-To: <20260731024253.148107-1-zhang.guodong@linux.dev>
References: <20260731024253.148107-1-zhang.guodong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

ksmbd_ipc_login_request_ext() returns an independently allocated
response. ksmbd_alloc_user() copies the supplementary group IDs from
the response, but ksmbd_krb5_authenticate() does not release it.

Free the extended response after ksmbd_alloc_user() has finished with
it.

Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/auth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 4e7b6f0e6b8c..e886ea5681ca 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -464,6 +464,7 @@ int ksmbd_krb5_authenticate(struct ksmbd_session *sess, char *in_blob,
 	*out_len = resp->spnego_blob_len;
 	retval = 0;
 out:
+	kvfree(resp_ext);
 	kvfree(resp);
 	return retval;
 }
-- 
2.43.0

