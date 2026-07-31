Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45045339384
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 02:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465803; cv=none; b=ix9NsimK3uzwLL0qOte3qvUFifuzNiE1KzrAn8uBweV71vCLN08osiNU+vWuyUD/2P+qzBc+Z0TkABCD02k6YaKCwkiKMQC3qlJ5e9wj9mzkWZ96ibliR/22/v8XPpqf3v7eoRTVln+ZHN9coIJi7hgP19Wqv9E6w8HtaRzoROE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465803; c=relaxed/simple;
	bh=31yCz3vPZO81Gn1lWlC9hS5ZYu42gFOE/zuY8NAdjPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=byfXS2gs6pUJ8lNUhgpK7MZUcVLZWUgMSX/yBdfOAANeBOjh9FOuuYOb1a1Tj8ETaHIc6APCarqHs01PE6Rwmg2BxUQmpkFqa6N/DtLXmRH1VjbDyV+Jl0mbvkP/u3AyEi/IgFuTvAdzDwJJd0yzQQoMTDOFz3fRw2BOxSvLdbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V3ZdWyg2; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V3ZdWyg2"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785465800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h5A9WPpK/3W/eBVJ7RHH0eNh40RrO56nXlwXsAd8/sA=;
	b=V3ZdWyg22gWZDvNPKEaNXcfdrcx4h0WTx4mF/OSVDFeyr1q3uJixXrWarkwnZ1464r+QJp
	j0dZbdv7A/4iPqtZKyUdEj9zj4c8xCsRZ2wrb0kUdXuWxGhtgIst+6Z/r0Z/8RUsWPpg0U
	Y+uSaFIZoobXjp9DDPTDI5DbNEwlCkc=
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
Subject: [PATCH 2/2] smb/server: fix memory leak in ksmbd_login_user()
Date: Fri, 31 Jul 2026 10:42:53 +0800
Message-ID: <20260731024253.148107-3-zhang.guodong@linux.dev>
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
the response, but ksmbd_login_user() does not release it.

Free the extended response after ksmbd_alloc_user() has finished with
it.

Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/mgmt/user_config.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/mgmt/user_config.c b/fs/smb/server/mgmt/user_config.c
index cf45841d9d1b..21b1d51d918b 100644
--- a/fs/smb/server/mgmt/user_config.c
+++ b/fs/smb/server/mgmt/user_config.c
@@ -27,6 +27,7 @@ struct ksmbd_user *ksmbd_login_user(const char *account)
 
 	user = ksmbd_alloc_user(resp, resp_ext);
 out:
+	kvfree(resp_ext);
 	kvfree(resp);
 	return user;
 }
-- 
2.43.0

