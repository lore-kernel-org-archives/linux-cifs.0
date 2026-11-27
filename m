Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795798153;
	b=GYk6+qkKRzWNclOd7QnpVEHBm51AyDrVNv40ZEeguvN1ddS72FD5TayMhDwr5X1Q6ziR
	 GnLSCXLDd4WQTPhHi88lR+uL8RAfawPLOr/pyaTBWf6yRmquplxvzXBR1OdpkwIgd/ZFp
	 K2nOFGYhWhl+ttCD0UIgwvFAmgVA05UG30tj/3BsFZ3+FFG9s1pPqIMIUHPwfZ1v5epCe
	 kBO+dMY+yVVVBD7DLlQ9y7ZzkOPrYVgA7S1BJXYMI9B3UhJOGTyasKVNr6raHuixvWxIc
	 GFn+hr7gCNA8jXwaxj8T0CqEhUi0UQxGmX8vTqS0IrnudKDHUYP3NEILI2nW4aeoBcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795798153;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=xxmjMLFGczpztLIHHwj+zdCeTxrOhpZy88DtzWtf9fA=;
	b=c7x+s6uDpvFQm1wr7xr5QTbA+VwfmW9+l/gQCLhD8UBZPNSleB0vxEREfsKKLmZXBVuM
	 8niaUSoU78wM1FrZkYOIxFpvpf5ucfX2xyoNVBLKaaNAyXqg1BT5n4EYVWTsZ18zsLBEj
	 /3J+xQIgU8pDbQNkn8/e5fAqArxH5++uy8TSGOUYplNBMP9EhD5oVx0DYvkflht7AVG8l
	 JxKo/EbOEaMJMdJuohKNyUjpythXmYw/SRNf8dHxF909gBqro4iZyzMnhIkZM+W7TOwLQ
	 I98ukL1iWkT7+xCuMf0gKzeIFdEflgn/fUwtqXgs4YMU+pgBVxZJ2EshKRhBzXF/iug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=y1RUha5Y;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9AE606A31C;
	Fri, 27 Nov 2026 16:49:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D9AE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=y1RUha5Y
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=xxmjMLFGczpztLIHHwj+zdCeTxrOhpZy88DtzWtf9fA=; b=y1RUha5YKnFsgwN8EqZU+0BeL2
	Cdr4rAM5bQkkNW0+uWjxFl4fPnj8oASK8EfIC4rm8tttB9r9p4vGKhDuT5yjusuENCazzFB5KatAI
	dtQZGyJbXm46U7IiLDmZSasr6LB6fizB+lhM/gN9VESpu4S52yPskTK6EjP6yvK9D8whQXeyADZhr
	7IsIcx9c+ytLza1LgLcujRKjAcmIVj9/6pFmVx/pIBuJcuDgX3L2Xqr67hO37vyYW0W81l9iN2RSJ
	pP2VuufKyxrW+qp99UlVCGuU2/pNy9+qyl0qpPfcHp8NvaGqXLNEZfG2xpvI1/xbx9Vk96vJJ+CFr
	vlDFziTZlj6QFv2tB5/4KaVZ1COr7BQ+eXCEoSV7yrOd8rEHyg1eddknbSIljqcOrP5E+AJtQ0aWk
	/lwcMTCIBuJ+98yEWpZFvMO9caRTku/IlsKkX8LLbKgS5z3xFtksmaXPxSkckQkmihj4GPzI4ZpG5
	phpJA1H/PULcBtBw6Ymy4n4c;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWz8B-00000001QXk-2PGu;
	Fri, 27 Nov 2026 16:49:03 +0000
From: Stefan Metzmacher <metze@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: metze@samba.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 0/2] smb: server: fix the nonce of encrypted responses and a listener leak
Date: Fri, 27 Nov 2026 17:48:57 +0100
Message-ID: <cover.1795797772.git.metze@samba.org>
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

Hi Namjae,

these are fixes for ksmbd:

  - The nonce of encrypted responses and of the payload of encrypted
    RDMA reads is a 64-bit counter of the session followed by random
    bits of the session, like Samba does, instead of random bytes,
    which only made a reuse unlikely. With AES-GCM a reused nonce
    reveals the authentication key.

  - smb_direct_listen() leaked the smbdirect socket if binding or
    listening failed, e.g. with -EADDRINUSE (reported by Sashiko).

The client got the same nonce fix in the urgent client series, the
urgent smbdirect fixes are posted separately as well, they are all
independent of each other.

These patches were developed with the help of Claude (Anthropic),
which was used for code analysis, writing parts of the code and the
commit messages. I reviewed all changes and take full responsibility
for them.

Testing: on real hardware, client and server running the urgent
client, smbdirect and ksmbd series together:

  - encrypted (seal) mounts over TCP and over RDMA (RoCE with mlx5
    and irdma) with AES128-GCM and data verification
  - ksmbd started while the RDMA port 445 is already in use,
    smbdirect_socket_bind() fails, no warnings and ksmbd starts again
    afterwards
  - the RDMA tests of the urgent smbdirect series, including 10 ksmbd
    restarts per device while I/O is running

As we are already late in the 7.4 cycle, I leave it up to you to
decide if they should still go into 7.4 or into the next merge
window, both are marked for stable.

Base: v7.4-rc4, like the other smb series. The patches also apply
cleanly (git am) on cifs-next (61c581ea62ee), on ksmbd-for-next
(3c31349456c5) and on both merged, with or without the urgent client
and smbdirect series, and build on both merged.

Stefan Metzmacher (2):
  smb: server: use a counter for the nonce of encrypted responses
  smb: server: don't leak the smbdirect listener socket on errors

 fs/smb/server/auth.c              | 43 +++++++++++++++++++++++++++++++
 fs/smb/server/auth.h              |  4 +++
 fs/smb/server/mgmt/user_session.c |  1 +
 fs/smb/server/mgmt/user_session.h |  3 +++
 fs/smb/server/smb2pdu.c           | 25 +++++++++++-------
 fs/smb/server/transport_rdma.c    |  2 +-
 6 files changed, 67 insertions(+), 11 deletions(-)

-- 
2.43.0

