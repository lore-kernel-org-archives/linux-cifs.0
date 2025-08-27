Received: from cse.ust.hk (cssvr7.cse.ust.hk [143.89.41.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574271A3166
	for <linux-cifs@vger.kernel.org>; Wed, 27 Aug 2025 18:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=143.89.41.157
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756319591; cv=pass; b=uChUq7KHf/y0Fyil7iyoVYnpycE6N2HOBltP8f1SHKkB5QqCwOk2T/cG3Skc/Hmqy2o2iqUWlXf8zofx1K8N2clf4L/hMefThr3cGh56/boedbMMa29VV6aGss4oTT7ZHtT7WAV8t0bS07VAv8F2kD5qWAwL3gz7tm8e5Bdug74=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756319591; c=relaxed/simple;
	bh=YM1TFKQKqDxSDPybY8632l3D0G8173usW0P3iwq8uTM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=QWNfOpihiKqKMpqxtsDGFZ04nYExw2pAu5E56aB48VKDdG8wiHSgG9Ey4cXzEnuXktR7pbi871WnrEBsQabj03CmIOiN4CNMZwvoXBNvifuHe9pZ+YSsi/AwY5HDzcWwUgZH6PaIMS1Mih5Z27qesXpWRtptN+JPBoGAWlhlATc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.ust.hk; spf=pass smtp.mailfrom=cse.ust.hk; dkim=pass (1024-bit key) header.d=cse.ust.hk header.i=@cse.ust.hk header.b=pecqZQ3M; arc=pass smtp.client-ip=143.89.41.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.ust.hk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.ust.hk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cse.ust.hk header.i=@cse.ust.hk header.b="pecqZQ3M"
Received: from homelab ([58.82.196.128])
	(authenticated bits=0)
	by cse.ust.hk (8.18.1/8.12.5) with ESMTPSA id 57RIOOmR418674
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 28 Aug 2025 02:24:32 +0800
ARC-Seal: i=1; a=rsa-sha256; d=cse.ust.hk; s=arccse; t=1756319073; cv=none;
	b=yZaA+LmG/AIlycX9TjByABxIZRNTi+NbUgKIMJ0feW8opNOhNgWfbBPWgoj97dqG4++iil7oNk3ZU0CbfyKLb0pklx1kOm1+6Dey2FxYWftfHxqGboCaw1AckwHk4TU4uoB1BhQofftBbtVxVh0UGA8qcHD6dACALmUd+I4feV0=
ARC-Message-Signature: i=1; a=rsa-sha256; d=cse.ust.hk; s=arccse;
	t=1756319073; c=relaxed/relaxed;
	bh=uGriABf2bFtOrg9k6i3IYRQyw84AaagLQ2Sy4aAi8yo=;
	h=DKIM-Signature:Date:From:To:Subject:Message-ID:MIME-Version; b=yYcAjr037v69Lj/MGGYtH90BBsXLXjUpwJ2YfoQFAkb+jg6Z2pQ418vBRoJ21eQ7GxXd5DzNFLvhBNMr3LE05eQwtZBL1w5QIGob+sFvVEg9FJm2sUINiUsYhZM4F64uSEJy1qlOvQVpQrxTiwbyWj8yXMFDyZs00s/vK1O6QXg=
ARC-Authentication-Results: i=1; cse.ust.hk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cse.ust.hk;
	s=cseusthk; t=1756319073;
	bh=uGriABf2bFtOrg9k6i3IYRQyw84AaagLQ2Sy4aAi8yo=;
	h=Date:From:To:Cc:Subject:From;
	b=pecqZQ3MNxm7iMg6OnArSTT3yfLpAvjqBAvfZUi2w3VXV65edgepGbYUj+OU2D0BB
	 jgEarZa0xbtIoQYacJi43iSzmjg5FlLg81mhtjgacFrSSjpzhwzGSC2owsCXqGw8dC
	 qUpVeIGff3ad2g0uh4h4EOBQ8JDC7Hae8UduuMWs=
Date: Thu, 28 Aug 2025 02:24:19 +0800
From: Shuhao Fu <sfual@cse.ust.hk>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
        Bharath SM <bharathsm@microsoft.com>
Cc: samba-technical@lists.samba.org, linux-cifs@vger.kernel.org
Subject: [PATCH] fs/smb: Fix inconsistent refcnt update
Message-ID: <aK9NPzbY9M_9eKuv@homelab>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Env-From: sfual

A possible inconsistent update of refcount was identified in `smb2_compound_op`.
Such inconsistent update could lead to possible resource leaks.

Why it is a possible bug:
1. In the comment section of the function, it clearly states that the
reference to `cfile` should be dropped after calling this function.
2. Every control flow path would check and drop the reference to
`cfile`, except the patched one.
3. Existing callers would not handle refcount update of `cfile` if
-ENOMEM is returned.

To fix the bug, an extra goto label "out" is added, to make sure that the
cleanup logic would always be respected. As the problem is caused by the 
allocation failure of `vars`, the cleanup logic between label "finished"
and "out" can be safely ignored. According to the definition of function
`is_replayable_error`, the error code of "-ENOMEM" is not recoverable.
Therefore, the replay logic also gets ignored.

Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
---
 fs/smb/client/smb2inode.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 2a0316c51..31c13fb5b 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -207,8 +207,10 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	server = cifs_pick_channel(ses);
 
 	vars = kzalloc(sizeof(*vars), GFP_ATOMIC);
-	if (vars == NULL)
-		return -ENOMEM;
+	if (vars == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 	rqst = &vars->rqst[0];
 	rsp_iov = &vars->rsp_iov[0];
 
@@ -864,6 +866,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	    smb2_should_replay(tcon, &retries, &cur_sleep))
 		goto replay_again;
 
+out:
 	if (cfile)
 		cifsFileInfo_put(cfile);
 
-- 
2.39.5

