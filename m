Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.129
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795527015;
	b=skvSUOndwGQIosw0LGhYe3IOw5HK0s97jvuEbSZOshCIqgqtBEWfoO1rEiz0YqE+v86t
	 MiPr+e8PG5y5EzTQ79Qk37+6K2JPSsKPbztXTzrVvMfY2BQqrjfSTx3FoNc3piqroi9Tk
	 ODCZLKadXcfQESuCOBKjcGfjPTeK0P2VCgeb+ZbW2z2sVVzYvXjO9/WVs6e6X9Hw9YguI
	 Pdp6CQf7IrWmgQjGPM85hXSR0Pl5Dg3QxugmMHNVbeN1bR+CL1ksOQnEuscTdIQXP6kqX
	 n6lClAlQ1jrG/IF7m5DtccyTJMRtt9LxwmZqSLUeTsa9dqP6uOuEgmLfuUXHhNw8o6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795527015;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=G1128rTZNHF3TZTp71wq55rZrR9C5zp6Bb3gqvNEXPY=;
	b=nssPjuRMyJ+qXqA/vuZuchkvfnUWXbXjCz+Qi9aSp40XRoBbO/0qmuTIPx/El/Xn4d4i
	 Tsa8CAPOhK9GbCPYPzFFJDJwu9my9whqtCMUdE4fbd+UrWuGshj8H4p/Ul3IPDFuMpzSA
	 vW/uo9sqUAohE2o6FPYDrO0BnuoQaFQtBco8yk5DDEIPb/BOS/t0YjY3e1R7OTUC3nVV+
	 qY7zMfyv9f92htfTxPJhw76XQIxvVpxcTiUwqbVl2bptQli4Ioeegd3j+L6t3DPZfafZi
	 x6k3XG3knClt09bbNIQpPE1pPdwV2KXAxXX64/HTf/8PcxIw4/8WIYcyhc6R5+TQJbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=sZBN7sJM;
	arc=none smtp.remote-ip=95.215.58.129
Received: from mta1.migadu.com (out-129.mta1.migadu.com [95.215.58.129])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094DD606A32C
	for <linux-cifs@vger.kernel.org>; Tue, 24 Nov 2026 13:30:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 094DD606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=sZBN7sJM
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=jILvBWgUdQBgbN13h1Z1hnj/mPs1bGH6/A63I3+jXoI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795527009; v=1; x=1796131809;
 b=sZBN7sJMdpRSX2eH/sKxkVGPecuYLWOXQnkNt+wFlYY/ESCFL4bSSJ5pJqh0/DgzJLYKWUe3
 e+fFcJB33XxsweU+kgqYtVZu7DtQFHYyBPZDKpwh+5fyba7xGGYg+zffo2YtYmpRDCcAatBARcv
 JSrKwVELiQUCNLZAZe06NKcs=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a47cf47b72ca0424;
	Tue, 24 Nov 2026 13:30:09 +0000
X-Mizu-Trace-ID: a47cf47b72ca0424
X-Migadu-Flow: FLOW_OUT
From: Huiwen He <huiwen.he@linux.dev>
To: Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ksmbd: splice READ payloads over TCP
Date: Tue, 24 Nov 2026 21:25:52 +0800
Message-ID: <20261124132554.1185817-1-huiwen.he@linux.dev>
X-Mailer: git-send-email 2.43.0
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

From: Huiwen He <hehuiwen@kylinos.cn>

ksmbd reads file data into a private response buffer. TCP then copies
the payload into an skb. If the reply must be queued, ksmbd also
copies the unsent bytes into a queue buffer.

This series uses MSG_SPLICE_PAGES to avoid those TCP copies for plain,
standalone READs: patch 1 splices the initial TCP send from private
pages and a header page fragment, and patch 2 retains references to
unsent payload folios on the send queue so the send worker can splice
them as well.

Summary of fio sequential read results (16 jobs, QD32 per job, SMB3.1.1
tmpfs; each column is relative to the preceding commit):

Channels  I/O         Throughput change        Host Gcycles/GiB change
                     patch 1    patch 2          patch 1    patch 2
       1  4 KiB        -0.3%      -0.9%            +1.8%      -1.1%
       1  64 KiB      +28.4%      +0.9%           -31.5%      -5.9%
       1  256 KiB     +60.8%      +5.3%           -40.5%     -22.5%
       1  1 MiB       +51.5%      +9.2%           -33.1%     -32.2%
       4  4 KiB        +0.2%      +0.2%            +0.9%      +0.2%
       4  64 KiB       +3.9%      +2.6%            -6.9%      +0.8%
       4  256 KiB     +12.1%      -0.4%           -43.0%      -0.8%
       4  1 MiB       +17.6%      +7.1%           -39.5%     -34.7%

Huiwen He (2):
  ksmbd: send READ payloads with MSG_SPLICE_PAGES
  ksmbd: retain unsent READ pages on the TCP send queue

 fs/smb/server/connection.c    |  18 +++
 fs/smb/server/connection.h    |   1 +
 fs/smb/server/ksmbd_work.c    |  24 ++--
 fs/smb/server/ksmbd_work.h    |   8 +-
 fs/smb/server/smb2pdu.c       |  74 +++++++++--
 fs/smb/server/transport_tcp.c | 223 ++++++++++++++++++++++++++++++----
 fs/smb/server/transport_tcp.h |   1 +
 7 files changed, 301 insertions(+), 48 deletions(-)


base-commit: 89d5e8fdd5a74a318d18b7267c4ec5d70b2285f1
-- 
2.43.0

