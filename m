Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E592F0C52;
	Mon, 22 Sep 2025 19:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570027; cv=none; b=nOeAtvwbY/yvhGKfi2mqG+jN9OYkHMtE+oZwPzoVqZGTCzhWu7Q5LqZU8su0tYXh9imcEqhwbAdQJzO3iYG7+kXXvphihUPNrgEhZIVUUMvl/U8KlQWPvzubw0DNq4oGRSB0XGOvia4t4/5BHy2XtkPPjS0JJBPxcAdTtrhJ7LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570027; c=relaxed/simple;
	bh=ANFUOxyKeTKQiJ7hKOVummYz1agVnanljXCIX36ml0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JNrlMki4AtcrxBolsyUj2r7uBxpykQmmMerHc7vFvdKg4s/Fnpdik76d0by/mXMTEVbT7IPweFo9JD8mD8onmyLDF2E2aKb61/wEDMlYhjia7/Y/yW77UawWU2N+L0ckXmKjXJ1bkLBjzfmXgjKpXu1Vy0EXGvB1D0hGuKzk08A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i5vckWpT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5vckWpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AADBC4CEF5;
	Mon, 22 Sep 2025 19:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570027;
	bh=ANFUOxyKeTKQiJ7hKOVummYz1agVnanljXCIX36ml0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5vckWpTOKzbkaDdiU8v0tdgtNO17O0wacoCgsXZ35V5nCbK2ozMpkemoY2hqUk6H
	 AKRENri1szCINBfAddJ4iQFuzmsVxJNNLt6f2jM5pkvM4CviK5CA+vX9xowJzEtE6o
	 4vD7uR0IGoAfJoNpjb1NWP+wZQ994e/HNEUU0T7o=
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
Subject: [PATCH 6.12 081/105] smb: client: let smbd_destroy() call disable_work_sync(&info->post_send_credits_work)
Date: Mon, 22 Sep 2025 21:30:04 +0200
Message-ID: <20250922192411.019798849@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit d9dcbbcf9145b68aa85c40947311a6907277e097 ]

In smbd_destroy() we may destroy the memory so we better
wait until post_send_credits_work is no longer pending
and will never be started again.

I actually just hit the case using rxe:

WARNING: CPU: 0 PID: 138 at drivers/infiniband/sw/rxe/rxe_verbs.c:1032 rxe_post_recv+0x1ee/0x480 [rdma_rxe]
...
[ 5305.686979] [    T138]  smbd_post_recv+0x445/0xc10 [cifs]
[ 5305.687135] [    T138]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 5305.687149] [    T138]  ? __kasan_check_write+0x14/0x30
[ 5305.687185] [    T138]  ? __pfx_smbd_post_recv+0x10/0x10 [cifs]
[ 5305.687329] [    T138]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
[ 5305.687356] [    T138]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 5305.687368] [    T138]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 5305.687378] [    T138]  ? _raw_spin_unlock_irqrestore+0x11/0x60
[ 5305.687389] [    T138]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 5305.687399] [    T138]  ? get_receive_buffer+0x168/0x210 [cifs]
[ 5305.687555] [    T138]  smbd_post_send_credits+0x382/0x4b0 [cifs]
[ 5305.687701] [    T138]  ? __pfx_smbd_post_send_credits+0x10/0x10 [cifs]
[ 5305.687855] [    T138]  ? __pfx___schedule+0x10/0x10
[ 5305.687865] [    T138]  ? __pfx__raw_spin_lock_irq+0x10/0x10
[ 5305.687875] [    T138]  ? queue_delayed_work_on+0x8e/0xa0
[ 5305.687889] [    T138]  process_one_work+0x629/0xf80
[ 5305.687908] [    T138]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 5305.687917] [    T138]  ? __kasan_check_write+0x14/0x30
[ 5305.687933] [    T138]  worker_thread+0x87f/0x1570
...

It means rxe_post_recv was called after rdma_destroy_qp().
This happened because put_receive_buffer() was triggered
by ib_drain_qp() and called:
queue_work(info->workqueue, &info->post_send_credits_work);

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
 fs/smb/client/smbdirect.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index b9bb531717a65..6284252aa4882 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1308,6 +1308,9 @@ void smbd_destroy(struct TCP_Server_Info *server)
 			sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
 	}
 
+	log_rdma_event(INFO, "cancelling post_send_credits_work\n");
+	disable_work_sync(&info->post_send_credits_work);
+
 	log_rdma_event(INFO, "destroying qp\n");
 	ib_drain_qp(sc->ib.qp);
 	rdma_destroy_qp(sc->rdma.cm_id);
-- 
2.51.0



