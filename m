Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747BE1547CC;
	Mon, 22 Sep 2025 19:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570407; cv=none; b=dizrLFZRPs6+9Xq7RV0iXcugwgcAlOs/noqoIj2R10q3wC/v2kacMjESnIZTqNhdK5oLxD7p/yrNK6CWOWlbf7+GBDcYn8VsUrSQLCYoFj+AAbKuBHdc0/rrioPSXSKJuBWbvt8kPr0T6rfKM8XN21TlgOOApw46ifeZriklIek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570407; c=relaxed/simple;
	bh=XGxslejsWoPrlbZ2bhtQgpfkLWpHAsrsvJlgJBqLvaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWy+R/xskxDupDkvMKxFUhS6RgvHbTx7Lx2sD3sStrakk4Hl0LKLu58Fs91sp8W5FWliwm1EakoJGuzQ4M5ngfJxaXZRC72xk1qh67TyDR8gD3337wKe/JmKYcDc+1huxyUj2Cv3d6qBUN07zUTLjuF02TqrLilZqGBccOh+Y+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLboT4ie; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLboT4ie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5DAC4CEF0;
	Mon, 22 Sep 2025 19:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570407;
	bh=XGxslejsWoPrlbZ2bhtQgpfkLWpHAsrsvJlgJBqLvaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLboT4ie7IXAXifrZIfMH/3LH1B74bY1QAEx/CYzy5+nYnggDdoYi8Z8mc9tq8P7v
	 5vd+nb2s/mzkffC41Kjv9/ggWzSlWlK2BpyProoUQQBZP8jdJgZOcESFPJJKCnJQxy
	 sczkZvIllgCIZpcMiWTUk6e1NekluUSkClhEqacU=
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
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 137/149] smb: client: fix smbdirect_recv_io leak in smbd_negotiate() error path
Date: Mon, 22 Sep 2025 21:30:37 +0200
Message-ID: <20250922192416.320514082@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smbdirect.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 8b920410cd2fe..6dd2a1c66df3d 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1101,8 +1101,10 @@ static int smbd_negotiate(struct smbd_connection *info)
 	log_rdma_event(INFO, "smbd_post_recv rc=%d iov.addr=0x%llx iov.length=%u iov.lkey=0x%x\n",
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
2.51.0



