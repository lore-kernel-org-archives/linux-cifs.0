Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9676E36495C
	for <linux-cifs@vger.kernel.org>; Fri, 10 Apr 2026 20:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775851890; cv=none; b=AQtbKfffcOJw8oBMmkSItf4N/eVXpHxMViEwe86r6dKe8MGHcaEu+BXA4zfNJTMdlC5v25tXzVA+yPt4zGgl6MhdPKnJdUzMQR07E9PtaYgg3eTVvBplUq3eeVA/bLaMmKZGp19Tv1cs9ukKfkDK3GiGcCdN5DMpA6u5+scKXfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775851890; c=relaxed/simple;
	bh=Zj91PZcPlRIL+TxypM4Mtqk1g5xF3vWKc60IuJ7hLuI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DSxEWgrLHSyswYNHPEO4Qz1HV5jTSLDQ45MOfTHjVvWs0RaQAND2MIDbIXNa5SbKTe8kRcW/GZm3Sl9HmGbSiiUFptxNZNKyiN0rnG94vEbYAv+kKMwYf1/1Rd6ET6kP0szQdDjSpSwZgP1kG6/WXOPaAdFP5m0woxCn4dBbiOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Cokn3iTz; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Cokn3iTz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=NkbsGmWts+8NpjXxjr3jPhBNvXYMr4h2mi9l+myO+yU=; b=Cokn3iTzu9dhXB5f4EGZwGvIKf
	Udq6mIIJ6ov5dAaVSveT3ABFB1xZb0lzImvvNgfBQvsNrqGRT17p+HEsh368mc7qUdDQg+Oj3LFLI
	JOgAmDUnQicNe6dvzpTOQqd8kxvFOjo6ZCjjSULY0loKUJqz7J9UVMWcJp3ByWSObC6UHt9l52qFx
	I812C9CjMZEY4YYyU2fHK5Y2SeOsFtdwTbsRNox6VdecEyK506bnZviyrF+/WRZFt+bStedpb9U8f
	c7Z5dxv9VCtrw2Gt4VxsdtcNRx9pfMudOVlJW11TjcNb7CVxYXWy7z7AL3DJ3/eLkZbIhni5h6r+u
	eJWTpkSHdRFkvE5fruujCtCm0/mT7Qk31SvD/mN1MIsnp0Sz66blTIJDS470CeONGTeKjzATbE64W
	NSmi9S9DBmhmV9FiKtXVgA5f8um8XL7MZfIBqaLuOd8V5Oy4G/NpYhTgKo2C1U2ysyyy2OKaLtf/7
	4vqUCCPsvM1IfvuylrMJQAMx;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wBICF-00000000IIe-3heA;
	Fri, 10 Apr 2026 20:11:20 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Ruikai Peng <ruikai@pwno.io>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Paulo Alcantara <pc@manguebit.org>,
	security@kernel.org
Subject: [PATCH 0/2] SMB Direct: double-free of send_io on ib_post_send failure in batch flush path
Date: Fri, 10 Apr 2026 22:10:59 +0200
Message-ID: <cover.1775838249.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Steve,

here are the real patches for the changes already tested by
Ruikai Peng for the double-free problem reported, see:
https://lore.kernel.org/linux-cifs/CAFD3drNOSJ05y3A+jNXSDxW-2w09KHQ0DivhxQ_pcc7immVVOQ@mail.gmail.com/

I prepared a branch that can replace ksmbd-for-next.
The 2 changes are rebased below the smbdirect.ko changes,
I resolved the conflicts and made sure the problem is also solved in
the new common code. This in for-7.1/smbdirect-ko-20260410-v12
at commit: 274b415378bbd0cf6fde1a719e264cee2eefc06f
git fetch https://git.samba.org/metze/linux/wip.git for-7.1/smbdirect-ko-20260410-v12
https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/for-7.1/smbdirect-ko-20260410-v12
I made sure each commit compiles fine...


Stefan Metzmacher (2):
  smb: client: avoid double-free in smbd_free_send_io() after
    smbd_send_batch_flush()
  smb: server: avoid double-free in smb_direct_free_sendmsg after
    smb_direct_flush_send_list()

 fs/smb/client/smbdirect.c      | 8 ++++++++
 fs/smb/server/transport_rdma.c | 8 +++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

-- 
2.43.0

