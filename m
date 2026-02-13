Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FE0241665;
	Fri, 13 Feb 2026 13:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990764; cv=none; b=J+2wdNsN9+GsdE8gMHvXmXmPYuxdcJ9ej/GloqxCHV/QNpcH5NhY+anYo2Ht37NWBnoSTuHH4GI1w003auge1u0eHBVkpqba0M9JJ7O1jmc+C5yGWo6QSJqGnEHi5hA9PJzZcnuzDCMzREuB+lc8mU6oLOKCW7BF7jCDuk33OW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990764; c=relaxed/simple;
	bh=R1P1JBU1IE27gV8XQv4wDehyunYP+/IHzBuUDCTMsyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgNS5d1nJODKSwdEqcmpt2LwsD5WRDzDYOxZ3EEQ8I+NaUn6mPW3qSesKmX12REkCyMEk8uZ8nSOSUj0y9cMFVn3q3MNV8FvBGz3SW72DKVziCcBfoYm9fp1y+esgrYILtsM1lRW5ZX4C3SBNBVsj/xYVSNue1B6ybPm4lOqgxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LpG48FN3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LpG48FN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4333DC116C6;
	Fri, 13 Feb 2026 13:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990764;
	bh=R1P1JBU1IE27gV8XQv4wDehyunYP+/IHzBuUDCTMsyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LpG48FN3lF8M/GEMyU0gzsa2gWBZguBLgl21MI1h+h0/Rm/87+sBwDoinDAmQXqIL
	 z+xulHWG4vg0mrbtuX3pBXOeiuYMaSonSSLc3kjsmu0rT/FyodnRdcfB3B5+EhMhzb
	 z9VS3hj1aHPR365qxA0SSiXZgelJI+mWLfAPZlOM=
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
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 18/49] smb: client: remove pointless sc->send_io.pending handling in smbd_post_send_iter()
Date: Fri, 13 Feb 2026 14:48:02 +0100
Message-ID: <20260213134709.554956304@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.885500854@linuxfoundation.org>
References: <20260213134708.885500854@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

commit 8bfe3fd33f36b987c8200b112646732b5f5cd8b3 upstream.

If we reach this the connection is already broken as
smbd_post_send() already called
smbd_disconnect_rdma_connection().

This will also simplify further changes.

Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smbdirect.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index c9fcd35e0c77..cfbe8ce0db42 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1274,11 +1274,6 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 	if (!rc)
 		return 0;
 
-	if (atomic_dec_and_test(&sc->send_io.pending.count))
-		wake_up(&sc->send_io.pending.zero_wait_queue);
-
-	wake_up(&sc->send_io.pending.dec_wait_queue);
-
 err_dma:
 	for (i = 0; i < request->num_sge; i++)
 		if (request->sge[i].addr)
-- 
2.53.0



