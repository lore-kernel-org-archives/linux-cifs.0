Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0073624D4
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 11:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785498666; cv=none; b=DzaMfeZk+oac0mB1svINZasllJjz5RaY3SQYbWpRijPslneDpizydUrPiwefgQq0E0x+nvlQIAXBHbyNRJzhO/+8WVJgqcvglLZbmOEhgvWa8ZnFkleIEzr7towmpJjXyQLMEZMF287oiDNBgjOkWLQPAGC3jW71LZ6QpNGjDY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785498666; c=relaxed/simple;
	bh=byawE269ZjfESW/DnhCFcFiOkAT8p+geyMj8+OqE7xE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dICu6BgPpSVkna/3Myi2nhkR+kDxhawh+TrD+4cY2yNUe470Uvi4DCX33kGoKE/IMUODzrKOJBUwyfVEggjsnQIQouZI0Z+JS+GbEWA+ufcTMfuGLNgUGQE8txg2v+rk9zseHJHAOe5EemvWuVB4ngDSRFui+H9yGJQ06FRMgQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AFwo/bZ/; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AFwo/bZ/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785498661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LilcGyvk0sE3qKrgtMVb9kbUeWQyp+sxjRmakQ9uwv4=;
	b=AFwo/bZ/KvHP0Lq3FnjGZjBHiUtvyFSwYkZoAhwgYlnLLKiUBAX1pqDOPRlSgCHoVcQgL7
	SDgGD0nSVUGvXqcgsnPWogCIY9b8HGn4Ue+kYDIUimqAa0dOQTG4EhaPOdFoblNIGC04pB
	lmjvsP9QymlE5JC4m2y5Pg5hdP3BRWY=
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
Subject: [PATCH 1/6] smb/server: fix null-ptr-deref in ksmbd_ipc_tree_connect_request()
Date: Fri, 31 Jul 2026 11:50:03 +0000
Message-ID: <20260731115008.111211-2-zhang.guodong@linux.dev>
In-Reply-To: <20260731115008.111211-1-zhang.guodong@linux.dev>
References: <20260731115008.111211-1-zhang.guodong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

See the procedure below:

  ksmbd_tree_conn_connect
    ksmbd_share_config_get
      share->name = kstrdup() // fail
      if (!test_share_config_flag(share, KSMBD_SHARE_FLAG_PIPE)) // false
      // do not check `share->name`
    ksmbd_ipc_tree_connect_request
      strlen(share->name) // null-ptr-deref

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/mgmt/share_config.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/mgmt/share_config.c b/fs/smb/server/mgmt/share_config.c
index 1cb58bec0903..53d6f71dd871 100644
--- a/fs/smb/server/mgmt/share_config.c
+++ b/fs/smb/server/mgmt/share_config.c
@@ -215,6 +215,11 @@ static struct ksmbd_share_config *share_config_request(struct ksmbd_work *work,
 	ksmbd_share_tree_conn_init(share);
 	INIT_LIST_HEAD(&share->veto_list);
 	share->name = kstrdup(name, KSMBD_DEFAULT_GFP);
+	if (!share->name) {
+		kill_share(share);
+		share = NULL;
+		goto out;
+	}
 
 	if (!test_share_config_flag(share, KSMBD_SHARE_FLAG_PIPE)) {
 		int path_len = PATH_MAX;
@@ -260,7 +265,7 @@ static struct ksmbd_share_config *share_config_request(struct ksmbd_work *work,
 				share->path = NULL;
 			}
 		}
-		if (ret || !share->name) {
+		if (ret) {
 			kill_share(share);
 			share = NULL;
 			goto out;
-- 
2.54.0

