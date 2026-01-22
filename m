Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36E037648E
	for <linux-cifs@vger.kernel.org>; Thu, 22 Jan 2026 17:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769102242; cv=none; b=JxB+y2Kq1y2NjDp70xnn33h0GzoNRei0tFybTpLX7ouY04xpuTtMvoYCttRkovIHFsONFQTM2vv4GF1G984VKDjr20fX3dD84CheUyVN4oD0/JhuXt9EHoZIYLjx6o/DENK9CDTevLK6D7fKjblx9BfU/cix8XBMbTJ0CJpXYLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769102242; c=relaxed/simple;
	bh=IRnWjuoCT8QBt1nV+SU7ntWeXdKJL2WVsdM44XTCeGg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OEfZ7lsIoAxwXrn5ZOncDOWQgKcKY/9MX7KW0FSPaYyIYrsu4EVDHlMSsGZXFlLIhXBddT2BxeCptXnL7BG7mKMPEnYPmkqH+LlfeWpD/Gf2ifyuMyWmaWSlD5/OcYXjr5gPGYlMBAvsBqNgUH7SS+rP8NRG6XBrE7G2tUm0Rpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ajtbygX9; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ajtbygX9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=6al61wdRgX2wNxInGCOttwc6aXr2oBr5ISu9QnjzqM8=; b=ajtbygX9gHDNuI9EE/AdhdjJ54
	PN7tsVpChOLhOlR8r7ExCAXcQSLe1deShg1BSdFgkjuGXqFsy+nMuFeKaoav9GvolhunKAEWpIJZI
	PhcQV+Pt+kOZBew4wi1EHoWSR7YzcuX3TZ06XT0y/Tf0zOfIQvCiIAwsHWkwVX0wBrqeKMvxHbrDz
	3z91O7hiyyY5wSYaZgmQxteSHe+kwcVsegcizDOgNs0XGmbBqI0d6AfAoloBdd+ltJgtVe7GnwL73
	EyMxAS69PbWD4jepJqh8prCFtg4kYvgRGQnIp9974CeHdJMJru2TPl8a2MC+1UkeI/qmif4ll57YD
	1GhNuf6BLw7rDIB9GdTpO4VzbEy3b31gn3qzr3OL2ILHAMm0IeK4dzhhwxqcD08iQUFXvkEKBJ2yC
	IFu3gSf7udB6TmDSRriXPrQtDL7dXekqLXQfyC8nfTTheagSYa95nkKZzcizyBAHEL7T0VKIjaiGI
	JXkmd+PzPIwh762Y1IPxehn1;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1viyIx-00000001pjp-0WkW;
	Thu, 22 Jan 2026 17:17:11 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 00/20] smbdirect client/server credit fixes
Date: Thu, 22 Jan 2026 18:16:40 +0100
Message-ID: <cover.1769101771.git.metze@samba.org>
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

We may add some more detailed Fixes tags,
but for now at least everything is marked
as stable for 6.18.

I tested the patches and fixed a few minor
but important things in the client patches.

v2:
- we should not add new_credits twice to
  sc->recv_io.credits.count in the client
  patches
- also the need to use request->wr instead
  of a struct ib_send_wr on the stack for
  the client side negotiate request.

Stefan Metzmacher (20):
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
  smb: client: let smbd_post_send_negotiate_req() use smbd_post_send()
  smb: client: let send_done handle a completion without
    IB_SEND_SIGNALED

 fs/smb/client/smbdirect.c                  | 523 ++++++++++++++++-----
 fs/smb/common/smbdirect/smbdirect_socket.h |  18 +
 fs/smb/server/transport_rdma.c             | 147 +++++-
 3 files changed, 551 insertions(+), 137 deletions(-)

-- 
2.43.0

