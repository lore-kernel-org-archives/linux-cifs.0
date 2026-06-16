Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C623D47CE;
	Tue, 16 Jun 2026 18:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633482; cv=none; b=i+JpSFInxwbUVeEG3WVseYAARKgL6ocO2/jYvSyJY08YLt93entjSjirEiGgiOcA//sLaib5cmttceV+aZTImGF2VrnnxGlIHjq5UJvAyPYwqGcLs3/hkSMEv/QqnNZE4pTh4bVEf4y8vcXyII1dXcgQ2h3ZHELWT8cRvLe7dRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633482; c=relaxed/simple;
	bh=JUWl/6dYX5dbu/K+wW4U2ebys9tiZYE12oCuSZ5oX3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PuyDdpayABlaYaaheYCgieF4iX0BEZAPsUZFmazKR3nvNGtOEEhDwSLgEZcaP/CmI5hi4yeJ6UWkOmY1BkfJjvNJq3Wq3TiM3opWSJ+v7oBt7hENDp6GJnYFxj5ynTmHuHt+dYdike0qzw/9BiytlPxcwSVW38oRwgbT8IosAZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q2VDGr7H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q2VDGr7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CA11F000E9;
	Tue, 16 Jun 2026 18:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633481;
	bh=dXWJTNQHGterfIO2xs2JEeNp16icmg7KOEs24T+OzK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q2VDGr7HAWTxmpC3lp1hniSTV0AKe9yfFz73bRC6URaNH2ynP1WGSv/PC2s1kUYtq
	 8RyLQj1DIr9x3hQ/sEN1hLzmBUkZCtpXj01UUTtVeowT8HM5gLLDm6Cu7t2fV8ZBlr
	 AQplcD4irzprXIOYSzSva73VnvRsJJtbI25rfsKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Robert Garcia <rob_garcia@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/411] smb: client: fix smbdirect_recv_io leak in smbd_negotiate() error path
Date: Tue, 16 Jun 2026 20:24:52 +0530
Message-ID: <20260616145103.161316998@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smbdirect.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 48bd879349fbe2..c9bda34fd2f573 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1084,8 +1084,10 @@ static int smbd_negotiate(struct smbd_connection *info)
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
2.53.0



