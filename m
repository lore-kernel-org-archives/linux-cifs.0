Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214411;
	b=N4JTadE4VDHuAaqVs4YHwa12nZo+wZncTliAk2fuYPAP9Yw278xzhLEsGx17lQ4c4d2S
	 VvptQ8OxT7ubHx9kFg31oxcMNwGopk89/sTtRfzkqkL75DeNx/M8PAwymh1mFWkKZyBK/
	 DDcYUNdlr0vl3rM3Cp/vZ1ZouepCEKtHcoRVK4NrB8fyTXI52UxaG4BfsJtJDiL/NT463
	 xMwe561hJrEjGXM/1SPgQRCX3z9hv7GvnCnGComY/R17Xujc1/n3Du/82Y6wftv98AZk+
	 9cYo8s6K4XqBPs4cONWOq3OpAWgJphB8ssOy8aw1jQo8OSf1QvbvKVLz5nYNlmokPZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1RZfCRQhUGlZuq7Apoxi9pfhSAl/uGy7ydnuMPaHYIM=;
	b=uxPClrgl2KTFKlIJyoQQkfaloL1sRoPHX5i8FEZkbe2nvvw9jE3duwx6EMMiWilrzBWv
	 oF7XhzgjtFQcgULC7CRPPWlGXAjNHK3jHK+aICM4pPuoQB61J8vXNaqvNY416tRtQAfvj
	 FqR0Fy+pRPz7Kar85UGY5OyloAl0tVpl2Mg2FCZcabgT9c4tXniOQthUmlOOOg+pbDHvE
	 ODL/ss7v5E2WeJmnPjtQFCb1i38zSqVadb5nm4vi0MZUCBpSk+rSLR1LXcYM3e+peC/Wu
	 zRWlOi+6WVPL1iDJvoInSZ4sxshiSoOJ5YL0uKt26kyH6oX7rEbRIxa3at3SrR4Fs2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZmnM6k1j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20DE606A322;
	Wed, 28 Oct 2026 19:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZmnM6k1j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3311F01825;
	Wed, 28 Oct 2026 19:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214410;
	bh=1RZfCRQhUGlZuq7Apoxi9pfhSAl/uGy7ydnuMPaHYIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZmnM6k1jwpUy9+RtjOlPeYw1+vdVCyc42II+WnMHh3Baq0Ppc5sjbl/ZnVAVmwSAa
	 VcPVUOPCsP1XX/8fqQ+HxkXTCBGxmxSKG8DGEo2yEMYtMUJDprL7f11scodzaQETJK
	 s3aP4hIg8iLiWrB7BbdYZNXWPY/l9NKyHMw/JIyA=
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
Subject: [PATCH 6.1 0847/1887] smb: client: let smbd_destroy() call disable_work_sync(&info->post_send_credits_work)
Date: Wed, 28 Oct 2026 17:49:03 +0100
Message-ID: <20261028170518.701562757@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9b16840952c09..d2878973c1476 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1358,6 +1358,9 @@ void smbd_destroy(struct TCP_Server_Info *server)
 			info->transport_status == SMBD_DISCONNECTED);
 	}
 
+	log_rdma_event(INFO, "cancelling post_send_credits_work\n");
+	cancel_work_sync(&info->post_send_credits_work);
+
 	log_rdma_event(INFO, "destroying qp\n");
 	ib_drain_qp(info->id->qp);
 	rdma_destroy_qp(info->id);
-- 
2.53.0



