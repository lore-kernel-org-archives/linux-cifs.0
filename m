Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445801A304A
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 19:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769025061; cv=none; b=eC5KfKizz+3qk++YcsdcRbq7qIG7ocFPWP4a3pObO94cqZnm67sqGcBRIDMVoGnw9gYX9n7JdbBdxMbWxl8n4nlX480W4lfUisGGvcLywl3BYWV3zHr6yWuRri7bSkLIS2uqmWw6AqjfZa7tEvcB7K2I0eGoUIE8e97Vx9Cil+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769025061; c=relaxed/simple;
	bh=BbRnWw8AJdz+bETdw8UxM6gVPwuSaT9ZZjM/8JV1wzk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mTJwob+NKQ7DhV0r2iWKMQiysZHmkDRxVBzLMKNZxaCY0kdUrG+Q3MaPy57sKqMTpQyLr4j3jvLutEdhHlyiNSbDzlgfIz07kw7wGOz3V7ajGwNR7e8czmyvHqqrZEyBUZD1Rtn7vuwurbFtciGWhYgxD+gA5waHg1FOb7j4Dz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=SpjA9enW; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="SpjA9enW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=TxWdd1Zak7k8vMrWiVWxuR5svvGFrjDSr7/fodQ2bJg=; b=SpjA9enWBr2q8QNgG9sPONbkq1
	MDkfOQWat9fuUPwcZr4USYLyDpY81B+zUmleWJ8U34PmmP3wyon9ncgsughsTY5CuYBve9fSIluNh
	WUmSXsgt1d9r+4v0/LPzvmhqtKSOhpOG3S1vBxOv1CEixbRhODgHo4kCEpsdvkK8O2Im7nuDkwrwp
	l8k6UW9JrSQ+dqwOZBeIPxHajWHnOiPy9uANHJMudfEhYII8XXmx10aPk6GwFi1fT4LYFTZzgEC2I
	eqrtP8eWXnY6n8L8Y8n1tjudHEQoCQ3JsciWIz3pfnc8orfxat5uGiKOiC8PRxj3U87Bw9D+S8n2O
	vS+z96+TtC4rgAklVZXdlxhCt1rKSPK8BBguNXMFQUzbZv3WE35HcVR/AtOfQimvXsjNhf1uaPQiC
	kt+YGIhVehuM9D7fj3TSL7sG4ffQWz2SB8WEPUxPKoXvhrDZHDeO/fw0jIXBrdI0LiAsrgFebSNW5
	3M2EPbh4Vb74Q1zDYAMqm882;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vieE5-00000001dyO-1X1G;
	Wed, 21 Jan 2026 19:50:49 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 00/19] smbdirect client/server credit fixes
Date: Wed, 21 Jan 2026 20:50:10 +0100
Message-ID: <cover.1769024269.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

here is my current state of the regression
fixes we have in 6.18 and 6.19-rc6.

The generic and server patches were tested
in as is, but without this 07/19
smb: server: let send_done handle a completionwithout IB_SEND_SIGNALED,
but the related logic was tested on my branch with common code.

The client patches are not tested yet,
but they compile and I want to make it possible
to include in linux-next for testing.

I also need to add some more Fixes tags.

I'll do more tests with this tomorrow.

Stefan Metzmacher (19):
  smb: smbdirect: introduce smbdirect_socket.recv_io.credits.available
  smb: smbdirect: introduce smbdirect_socket.send_io.bcredits.*
  smb: server: make use of smbdirect_socket.recv_io.credits.available
  smb: server: let recv_done() queue a refill when the peer is low on
    credits
  smb: server: make use of smbdirect_socket.send_io.bcredits
  smb: server: fix last send credit problem causing disconnects
  smb: server: let send_done handle a completion without
    IB_SEND_SIGNALED
  smb: client: make use of smbdirect_socket.recv_io.credits.available
  smb: client: let recv_done() queue a refill when the peer is low on
    credits
  smb: client: let smbd_post_send() make use of request->wr
  smb: client: remove pointless sc->recv_io.credits.count rollback
  smb: client: remove pointless sc->send_io.pending handling in
    smbd_post_send_iter()
  smb: client: port and use the wait_for_credits logic used by server
  smb: client: split out smbd_ib_post_send()
  smb: client: introduce and use smbd_{alloc,free}_send_io()
  smb: client: use smbdirect_send_batch processing
  smb: client: make use of smbdirect_socket.send_io.bcredits
  smb: client: fix last send credit problem causing disconnects
  smb: client: let send_done handle a completion without
    IB_SEND_SIGNALED

 fs/smb/client/smbdirect.c                  | 491 ++++++++++++++++-----
 fs/smb/common/smbdirect/smbdirect_socket.h |  18 +
 fs/smb/server/transport_rdma.c             | 147 +++++-
 3 files changed, 545 insertions(+), 111 deletions(-)

-- 
2.43.0

