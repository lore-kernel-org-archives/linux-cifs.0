Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC65B2C029A;
	Thu, 30 Oct 2025 07:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761810245; cv=none; b=je8MsLI3k9LSgVLGcev4QaXvzoucBbA7ZA0GFurF4ATI5HTtCo7CHLcfTqSgSzm/dntZBxOFcy+eCGIKBqIloFmCECz+wvrTn/DHIu0sV2dj6Wp9CFiWdZS0hibVJJ9/zoSBExcdVTXQ2mbQxOWXol/2jxsVXUjV4P+i6LeZpJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761810245; c=relaxed/simple;
	bh=kxq9qjSwI/euAspvdW8LIPsGMx60Il7SC5u0QaAHm58=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SQ8LtZsaqgBEvU5tHUF+99ntF34P3XPUWxZmWT7sO+aO1xBML9UyvOWvvtXpzws3H5PdF1PKObh+g2dHppE9OlghPJz6WLHBAjkbTsmlUQwdaqCEmIg2oY/eGGwMdU/I8x9ftcVFsq36fk7CD/Gl0n7urg9WGJIzuX0HId0hhrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=fH4ppwqn; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="fH4ppwqn"
Received: from mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net [IPv6:2a02:6b8:c10:49f:0:640:b99a:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id 3CC2180830;
	Thu, 30 Oct 2025 10:43:49 +0300 (MSK)
Received: from i111667286.ld.yandex.ru (unknown [2a02:6bf:8080:56d::1:12])
	by mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id hhZcSK0Ft4Y0-qTvyUiRu;
	Thu, 30 Oct 2025 10:43:48 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1761810228;
	bh=EP6EuytiS7tC0fn/EYZWxe2O/pwA7Pr5SZWQ3bpebgc=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=fH4ppwqn+sm8nIGFWXHE0wAMxA4jlaWZCPAj5E9S0QctZ9YeXzQvErt5Q/UDqiFwc
	 3rXBRGHXS1TpNv7UeXUSHvxATE+ZcvuHwxtJxslJ/GV0v2dShnsRw5+WNsQQTu8jJp
	 +yPmK+YynL2bXcgcheFkAv8sndn2Jc/R7APNXYgQ=
Authentication-Results: mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Andrey Troshin <drtrosh@yandex-team.ru>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrey Troshin <drtrosh@yandex-team.ru>,
	Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH 5.10] smb: client: fix smbdirect_recv_io leak in smbd_negotiate() error path
Date: Thu, 30 Oct 2025 10:43:42 +0300
Message-ID: <20251030074342.1360-1-drtrosh@yandex-team.ru>
X-Mailer: git-send-email 2.51.0.windows.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit daac51c7032036a0ca5f1aa419ad1b0471d1c6e0 ]

During tests of another unrelated patch I was able to trigger this
error: Objects remaining on __kmem_cache_shutdown()

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Fixes: f198186aa9bb ("CIFS: SMBD: Establish SMB Direct connection")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[Andrey Troshin: backport fix from fs/cifs/smbdirect.c to fs/smb/client/smbdirect.c]
Signed-off-by: Andrey Troshin <drtrosh@yandex-team.ru>
---
Backport fix for CVE-2025-39929
Link: https://nvd.nist.gov/vuln/detail/CVE-2025-39929
---
 fs/cifs/smbdirect.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index ae332f3771f6..e273f3b9efcb 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1083,8 +1083,10 @@ static int smbd_negotiate(struct smbd_connection *info)
 	log_rdma_event(INFO, "smbd_post_recv rc=%d iov.addr=%llx iov.length=%x iov.lkey=%x\n",
 		       rc, response->sge.addr,
 		       response->sge.length, response->sge.lkey);
-	if (rc)
+	if (rc) {
+		put_receive_buffer(info, response);
 		return rc;
+	}
 
 	init_completion(&info->negotiate_completion);
 	info->negotiate_done = false;
-- 
2.34.1

