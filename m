Received: from o-chul.darkrain42.org (o-chul.darkrain42.org [74.207.241.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C3A1C07C4
	for <linux-cifs@vger.kernel.org>; Mon, 18 Nov 2024 21:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.207.241.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731966641; cv=none; b=lqwcVhx8WZufQiAC/u0C/AT7IK9fluTmZPSfNOA59wD8ge9B7WQiHcGiGKpHN6CgYAM88nl7VO+7jfD7kPP93fcRSYl4BNKzW0AhpE8BGLb0QI4nPyXvnmptacC0LxzfStqywQyfuSLwJPbO02cxenXS+ACic08tymPWChCgCxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731966641; c=relaxed/simple;
	bh=/yD78hB77bBOfeAbWiSXOxm0RR53Z14u59VoVYRcqfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qIq/hSu0Pgj7L/huv1m1Ji5um04IAif5CK46z9XjBR1U+u/NA6VfN7QCgxEzZhdwmD+ylf8OprVJdJbUMfMhZWe8tXT4kWup+3y8YiY5YquvOQoScAhT4StzgV1ePqfiUxA56BLg+bOh0ziH30wZYBoGpj28r51U+gGzcwAGxno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org; spf=pass smtp.mailfrom=darkrain42.org; dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=oEIAxeWa; dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=YxDZJWJP; arc=none smtp.client-ip=74.207.241.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="oEIAxeWa";
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="YxDZJWJP"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
 d=darkrain42.org; i=@darkrain42.org; q=dns/txt; s=ed25519-2022-03;
 t=1731966633; h=from : to : cc : subject : date : message-id :
 in-reply-to : references : mime-version : content-transfer-encoding :
 from; bh=joibekbaBl8hAo29wZ3AXThwiTfyTHXyMEsSRMa6ttE=;
 b=oEIAxeWaea/eOKQ9ffxkBICguxIt1QEktYxTBW454fUNSwdzLEqSMTEog25GDmId5jlGn
 NNXsIWlXT5oRK2EBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org;
 i=@darkrain42.org; q=dns/txt; s=rsa-2022-03; t=1731966633; h=from : to
 : cc : subject : date : message-id : in-reply-to : references :
 mime-version : content-transfer-encoding : from;
 bh=joibekbaBl8hAo29wZ3AXThwiTfyTHXyMEsSRMa6ttE=;
 b=YxDZJWJPQeD31VRJtHiqrEkRGa0iPI4F+8+2rySpjJIBgpROMqOTSXnJRQKs7px4RDZcV
 qMy0sy4t5VlYaFtRjAqw91Z6iyJJP/s696mlEJNV8ht40vjM9/YmjAkOxTVz9lWgUIvPjCR
 1agPfDw9oLB+4rzpIFaewoNmkkc9x2IrbD7N+AKLghNAqcfQcW87qxImwfjwLYpzsj9FGqh
 F39gZu534KIJZ+9Ca9CrTMdqlk0VNThhArW6T6q0XHbQevybJhiheiAYtqtLJHoAqno8SxF
 DJelxGDp9Qlyyq2hWTq6oAGTSjQzc0IVlqz9CFfFQj4WgbW9NUGsjmiURIPg==
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by o-chul.darkrain42.org (Postfix) with ESMTPSA id 3C7C583B6;
	Mon, 18 Nov 2024 13:50:33 -0800 (PST)
From: Paul Aurich <paul@darkrain42.org>
To: linux-cifs@vger.kernel.org,
	Steve French <sfrench@samba.org>
Cc: paul@darkrain42.org,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH v2 1/4] smb: cached directories can be more than root file handle
Date: Mon, 18 Nov 2024 13:50:25 -0800
Message-ID: <20241118215028.1066662-2-paul@darkrain42.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241118215028.1066662-1-paul@darkrain42.org>
References: <20241118215028.1066662-1-paul@darkrain42.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update this log message since cached fids may represent things other
than the root of a mount.

Fixes: e4029e072673 ("cifs: find and use the dentry for cached non-root directories also")
Signed-off-by: Paul Aurich <paul@darkrain42.org>
---
 fs/smb/client/cached_dir.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 0ff2491c311d..585e1dc72432 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -399,11 +399,12 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 		return -ENOENT;
 
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry(cfid, &cfids->entries, entry) {
 		if (dentry && cfid->dentry == dentry) {
-			cifs_dbg(FYI, "found a cached root file handle by dentry\n");
+			cifs_dbg(FYI, "found a cached file handle by dentry for %pd\n",
+				 dentry);
 			kref_get(&cfid->refcount);
 			*ret_cfid = cfid;
 			spin_unlock(&cfids->cfid_list_lock);
 			return 0;
 		}
-- 
2.45.2

