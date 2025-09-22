Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85572EDD5D;
	Mon, 22 Sep 2025 19:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569777; cv=none; b=rwOBvtzc+/gJM2DO5fZ9mO5Hc9jjsQQUCouZhFwtSeOa66a45EHD3+18ONS1b4ytGALSc0pbmPBYT8zFgzwtvmxFDMOvNYzcK33O/aV5hYO9JynipTXJtEXPRNJGP/l8KGcrMxreSzUGGvgf7dul7SiIoacL+35jIzhpG2gG9Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569777; c=relaxed/simple;
	bh=U167C+QGuTBgb1He854QVnBKvVY1JfwN3YmT2oi8Zy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZ2g84PGtNOETH8BD5oy2ZB+JpTEf5ZIiZd+hOVuTIm+xWX2EF5cGuL76d77EeaHQxG+/EoHl9O4tBNFbZlrvQ+SkWJ0HLeMD34tOSxw+NIjQnMOPQkK+xu518Frm2uaqXCOkBZHEtCLioOhuNSEK04xyAGbQ00AZJC7/ECMXTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/y3J4EX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/y3J4EX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2856C4CEF0;
	Mon, 22 Sep 2025 19:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569775;
	bh=U167C+QGuTBgb1He854QVnBKvVY1JfwN3YmT2oi8Zy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/y3J4EXkW4RqeiFZXXR7tu9KpeMfsZgmswJvOndD+RZLAwkXNZ6ExCumxMvZhgDh
	 WXcfVadyodwbL2PBsK6nfYYv4l/TfRXpmmXzkI9DUD1Yu3TmxPiyTH87j2DBFfoLfB
	 N0bpgS83rs+P1wAeIDC5GOyQRTjA1DRgI26FMslo=
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
Subject: [PATCH 6.6 56/70] smb: client: fix smbdirect_recv_io leak in smbd_negotiate() error path
Date: Mon, 22 Sep 2025 21:29:56 +0200
Message-ID: <20250922192406.105845403@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 713bd1dcd39cc..be9be8f363319 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1064,8 +1064,10 @@ static int smbd_negotiate(struct smbd_connection *info)
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



