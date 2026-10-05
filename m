Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E276E363C5A
	for <linux-cifs@vger.kernel.org>; Mon,  5 Oct 2026 18:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791226038; cv=none; b=OEMIhr4fbOFpgSlc6+2BseuhsIxwjQhEKygo4kIhbqX+5DTAS6ZT5Ot1hNrrgAtd8zfTdMuoMX+uCGA8x+XYtm8LSWefWXYclBGXphj/UiczBre0eDihGwyvtbhgpBd/5st+QMZ9NEi8Ry476cPIv/rMSRYYbyKs3uj2nO/tEHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791226038; c=relaxed/simple;
	bh=HavSsFOrxqVyEnwl46DoR4cd29XRJTp0Mla6K7hNEcM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZxQxJhQzbHb/mjvZ1x6rEYtxf9XC3mPBavXv4H3jM22ENYplzPsmV9EhVpmNx1H0nYoPJSuJSOGomaEVjyq5yoF/l4v9X/IbU9nRhH77aem7BRw8HP3ykQ9uyTJnC94wiv+Eoci3PQqYcL+8oyPoSNgst++7Pd+evvP9viJ1XZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=0R1nt2Tr; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="0R1nt2Tr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=C8dVaC6EEptlsGkjYRscc9njPXLstvpTzSTcEuC9/XM=; b=0R1nt2TrOlXxAUDTwcD8YGlOpw
	4h2wMJJNgNgGIUniKvH163JKcjnIbWkJBEFDpziAHQDAlQpF5TL50Ud+nLRZ7jan648WFDqg72kBB
	rm3vT+NcvsySR04iR4MgbbLU1kxIkFwleS7kDZ2eImLzfBNw+bMwolyCOowUGIkRm6EBRs5DRI/gy
	D8+ukcogr6W7iFEH113tI3Q8Zpz00Zja34WaHNLOZVPqv4vQXuMmefadvxzqhYuFyxfxCvp+1aT6E
	bAV56MTBB1SEWKvoN+CjBTzGlBHWJe73rUUvn35qn9H+7VSfEDomC2Y4GVFYkq/I+yfmoS2B6x5RB
	1B/kma6sVPYej4+nfIuy/oV8FbzIBdCAPA/d70U5vXaWFiqQiOl7g6ki+yo8UxRv0X4sUHVUYA9wn
	dHsXGggqKM4oDu/r8Rg4vMfnNir9Pf0t4SJuVbwIVDTi1aUd0d2X9LoeNU7ybflGKidQKFpyUfRiL
	RcqR+S81ONUWFF/qp6dpH6O6;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xDniT-00000005f86-0W4e;
	Mon, 05 Oct 2026 18:47:13 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 0/5] smb: client: don't use server->smbd_conn without a reference or lock
Date: Mon,  5 Oct 2026 20:46:55 +0200
Message-ID: <cover.1791225453.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Paulo/Namjae,

The SMB Direct client keeps the transport in server->smbd_conn and
accesses it from several places without any locking:

  - smbd_get_parameters()
  - smbd_register_mr()
  - smbd_debug_proc_show()

At the same time cifs_abort_connection() (and the reconnect path) can
call smbd_destroy() at any time, which frees the smbd_connection and
releases the underlying smbdirect socket. So the readers above can race
with the teardown and end up using a freed connection/socket, a
use-after-free.

While looking at this, smbd_get_parameters() also turned out to
dereference server->smbd_conn without checking it, which is a NULL
pointer dereference in smb2_negotiate_wsize()/smb2_negotiate_rsize()
when it is called during a reconnect window.

This series closes the races:

  - server->smbd_conn is only ever changed under server->srv_lock, so
    readers can safely look at it while holding that lock.

  - smbdirect gets smbdirect_socket_get()/smbdirect_socket_put(), which
    take and drop a reference that keeps the socket memory alive (but
    does not keep it connected). smbd_register_mr() uses them to hold
    the socket across smbdirect_connection_register_mr_io(); once the
    connection is gone the socket is no longer connected and the call
    fails gracefully. A registered MR has its own reference counting.

  - smbd_get_parameters() no longer returns a pointer into the socket
    (which cannot be kept valid for the callers). It copies the current
    parameters into the new server->smbd_params under server->srv_lock
    and returns a pointer to that; with no connection it returns zeros.

  - smbd_debug_proc_show() runs with cifs_tcp_ses_lock held, so it takes
    server->srv_lock instead of a socket reference.

The two "pass server to ..." patches are mechanical prototype changes
with no behaviour change, split out so the final fix stays small and
each step builds on its own.

All of this is a use-after-free that goes back to the switch to the
smbdirect socket API, so the whole series is tagged for stable via

  Fixes: b8aef8c8808c ("smb: client: make use of smbdirect_socket_create_kern()/smbdirect_socket_release()")

which is in mainline since v7.1-rc1.

I run various xfstests with this.

I'm unsure if this should go via cifs-next or ksmbd-for-next,
for consistency with the series I just send I guess both
could go via ksmbd-for-next?

Stefan Metzmacher (5):
  smb: client: change server->smbd_conn only under server->srv_lock
  smb: smbdirect: add smbdirect_socket_get() and smbdirect_socket_put()
  smb: client: pass server to smbd_get_parameters()
  smb: client: pass server to smbd_register_mr()
  smb: client: don't use server->smbd_conn without a reference or lock

 fs/smb/client/cifsglob.h  |  12 ++++
 fs/smb/client/connect.c   |  12 +++-
 fs/smb/client/file.c      |   4 +-
 fs/smb/client/smb2ops.c   |   4 +-
 fs/smb/client/smb2pdu.c   |   4 +-
 fs/smb/client/smbdirect.c | 124 +++++++++++++++++++++++++++++++++-----
 fs/smb/client/smbdirect.h |   8 ++-
 fs/smb/smbdirect/socket.c |  27 +++++++++
 include/linux/smbdirect.h |   3 +
 9 files changed, 171 insertions(+), 27 deletions(-)

-- 
2.43.0

