Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F47954723;
	Fri, 13 Feb 2026 13:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990761; cv=none; b=cuFwwOJ+yf6L4JdBVSEwk238/f/45bwKRFOUriTzBiIojN5AjzePpus786ipQueUFJU2FRW6PAjpN8490UfryTv+IyLQf0jUB+vqJvqyGneXJQjH9LQbSRuBP8J+oukJokCcDx2mptKkMGbUr8c7lnqFHpAVyC+8TOGfvT5s7vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990761; c=relaxed/simple;
	bh=bsRc/iw/oC/aST21L6MVx4y8uBZXMafrkp8HAG6Holg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p48IeGaQAp+Hnfd9HOIPAgHpUXeu+ZRV7YHy9LRB8Fq0yflc247hB7GFyRCU6UAqx7qocGPaA6N1G/6lJHOKz66snRJNst4s7UhW9Ex+dIB63OzDBL7SRKJURyRE7KMRC8a7xgTpJVVhg+0rrIf/NDDPvJ3sTHiCxT2P3+fgbr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YebOPwdy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YebOPwdy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1745C116C6;
	Fri, 13 Feb 2026 13:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990761;
	bh=bsRc/iw/oC/aST21L6MVx4y8uBZXMafrkp8HAG6Holg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YebOPwdyACsV0BA7HCsOsICj1sOfBT1tfzfRjaVOnnRh/J9hZoPXegtMyRMY0Nsan
	 0Et+Zz+FWrk8jQMTtppf7w4j6ydMcM2FLQ8i55YT5kmngNFz1vN7xwAaTipZzfLC//
	 yPFEoBpYI4KyadPma/GrPkHohnSDw/4RoEpK02SM=
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
Subject: [PATCH 6.18 17/49] smb: client: remove pointless sc->recv_io.credits.count rollback
Date: Fri, 13 Feb 2026 14:48:01 +0100
Message-ID: <20260213134709.518963436@linuxfoundation.org>
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

commit 6858531e5e8d68828eec349989cefce3f45a487f upstream.

We either reach this code path before we call
new_credits = manage_credits_prior_sending(sc),
which means new_credits is still 0
or the connection is already broken as
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
 fs/smb/client/smbdirect.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index f2ae35a9f047..c9fcd35e0c77 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1288,9 +1288,6 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 					    DMA_TO_DEVICE);
 	mempool_free(request, sc->send_io.mem.pool);
 
-	/* roll back the granted receive credits */
-	atomic_sub(new_credits, &sc->recv_io.credits.count);
-
 err_alloc:
 	atomic_inc(&sc->send_io.credits.count);
 	wake_up(&sc->send_io.credits.wait_queue);
-- 
2.53.0



