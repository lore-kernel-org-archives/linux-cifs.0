Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E36C31062C
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765175041; cv=none; b=A8c0TAkA33Y+IKHgOAlJM6hQ++wFj9TK4pDkSR3zKazUZg/XLKhxDAPPSGIU8V/jcsTj1aJ2pSjwBCsyRwfRYErrGqYevJVhpBSWF0bi7NdTBGxtm7Fnm4S7IvNXC7H+VD1YhrEII1i8Ak4k1hJpmPilS9xVCFWutcfQTQglqo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765175041; c=relaxed/simple;
	bh=14V99xARpVsTiLeMg6uKzaE1dz3OiFv29BsOiik0anc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Exqm2pw1DivPF8BZRLIiQTPCbDkAymnMWq7HPd7aBGytDC33Ol6qIdWLfQ517NAkbMHPKgHsj+sogNlrkkVEZ0o3RS2b6qr33oADxmoVQa+tH1no21/e7G2Kfmzp9Vx6Qt30YJ7MgjXFdyiyuq/+NhIqrJqF8uZQs9AWT0UkEuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RULE4Ox3; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RULE4Ox3"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765175038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s+HbvGtVM++H6fkb4p/QcHoHn7O99+rV3Sh22NvaGBk=;
	b=RULE4Ox36rcu0hajhbHEV6VK7qVGX3BxnCUXd5YUv2VA+nuZp623N8ZqapGKKf6trflKJ5
	qjnMNQpG0TTOshhXqz0oWBJ0qtHiOP5mZXM8hUH7YJZ+FtAehYgQrWtDsOIprLLGq+OluG
	9NaT42Zq62qvnT7UZnFe+wVvEaTZFnA=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liuzhengyuan@kylinos.cn,
	huhai@kylinos.cn,
	liuyun01@kylinos.cn,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 29/30] smb/client: remove useless elements from mapping_table_ERRSRV array
Date: Mon,  8 Dec 2025 14:20:59 +0800
Message-ID: <20251208062100.3268777-30-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251208062100.3268777-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251208062100.3268777-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

The last element in the array is no longer needed.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/netmisc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/smb/client/netmisc.c b/fs/smb/client/netmisc.c
index 8f3242c1d3da..8f93047305af 100644
--- a/fs/smb/client/netmisc.c
+++ b/fs/smb/client/netmisc.c
@@ -143,9 +143,7 @@ static struct smb_to_posix_error mapping_table_ERRSRV[] = {
 	{ERRbadclient, -EACCES},
 	{ERRbadLogonTime, -EACCES},
 	{ERRpasswordExpired, -EKEYEXPIRED},
-
 	{ERRnosupport, -EINVAL},
-	{0, 0}
 };
 
 static unsigned int errsrv_num = sizeof(mapping_table_ERRSRV) /
-- 
2.43.0

