Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954EA2F7477
	for <linux-cifs@vger.kernel.org>; Tue,  2 Dec 2025 21:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764710156; cv=none; b=REwnrVDEMpLqLKyoW8H40c0ttmfxbB0zIn8I8wMjithn2ZR6cfDSzMuQRF62qJA4/t6St0fy1D5Lh8zzZMNogYSiv3HiTY7lyGBwCyok4PkG5VYmulsiILgccIir3QQ3qqVOBYB+iy/GIG4y6XB+mbFIaIkhWXusLn0UENPv3Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764710156; c=relaxed/simple;
	bh=xJ5/fJjGrIbULTHJkoc34pxVrh48ZymCPJjfjh383sA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jN8BaCqeiNFNoKVOYI1y4NGS/0R2sSer9qx4FOgYqToeCy0Z9OQqj3RpAbYz1lhUZTsoaRVDXz20y0kaBXM+C56LonYHZGYekz7H0Batxm+Fl88g/aNdiTuH77d2+kT7pQs7UGvfTpkS5gKwW7PQvcygNWaMtfh2Tvrrh9UYSzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=PMrju5s6; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="PMrju5s6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=gRXwD70uletccTPFHozrCt8PmOX7/Wh1rB8nIsb7Ri4=; b=PMrju5s6uFH8IXzK2fJUxJdTXT
	LXz/nhCKxuBi4myiATZvnDZptIOnWVWY2tkDb/aAL8kMJhxFs370QVp0byqUJxGlit1jAxYtQjfVo
	K4hiLpqfdUtuO1FUS2BhQmlbRlJ5TpI1XGYSx3juWxYd20Q0kATr08Dvsgte+N5x0NwyUBhWMempd
	OnF8c2K5OdpIUSQtiWzhf9oKwvEXwPvXlFIOWAKHQQ3fNoDmJbrwjzcorzZIscpMqENdimS1ghYaz
	tCxn3ts9dOEO73gEgopKUgEg6QYF0VVk20SCQG7o+yhKzQhVnrGMonbRbBauHWJ0w6OmABeO6vJRW
	ieV5wQFqDtUpFsAjs8TCAj2amvGEpT9t7FvnM8lA/BSQMU25btBPibFFW+JatflbETrtP9T2D+ukk
	AI7PSR+ToYdtzLgeQBR/gzxCqG4wV9cAhM482/8hE83K/QJvD/L4CP8p4agWDRCETcvB0s7YRu28Z
	M2L2/NYYvWw/wrLP2kUVPRZM;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vQXir-00GhsP-1M;
	Tue, 02 Dec 2025 21:15:45 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [RFC PATCH 0/4] smb:smbdirect/server: introduce smb_direct_negotiate_recv_work
Date: Tue,  2 Dec 2025 22:15:23 +0100
Message-ID: <cover.1764709225.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

here's a patchset that implements a better solution
to the problem that the initial recv completion might
arrive before the RDMA_CM_EVENT_ESTABLISHED event.

The last patch is not intended to be applied, but
it helps to see the event flow it generated,
see the commit message.

This is based on the 4 smbirect patches within
v6.19-rc-smb-fixes:

dc10cf1368af8cb816dcaa2502ba7d44fff20612
smb: client: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks in recv_done() and smbd_conn_upcall()
425c32750b48956a6e156b6a4609d281ee471359
smb: server: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks in recv_done() and smb_direct_cm_handler()
1adb2dab9727c5beaaf253f67bf4fc2c54ae70e7
smb: smbdirect: introduce SMBDIRECT_CHECK_STATUS_{WARN,DISCONNECT}()
1f3fd108c5c5a9885c6c276a2489c49b60a6b90d
smb: smbdirect: introduce SMBDIRECT_DEBUG_ERR_PTR() helper

I've tested them on top of v6.18 (without the other patches
in v6.19-rc-smb-fixes).

Sadly there are still problems with Mellanox setups
as well as irdma (in iwarp mode). I'm trying to
prepare patches to debug this next.

Stefan Metzmacher (4):
  smb: smbdirect: introduce smbdirect_socket.connect.{lock,work}
  smb: server: initialize recv_io->cqe.done = recv_done just once
  smb: server: defer the initial recv completion logic to
    smb_direct_negotiate_recv_work()
  fs/smb/server/transport_rdma.c TMP DEBUG connect work

 fs/smb/common/smbdirect/smbdirect_socket.h |  12 +
 fs/smb/server/transport_rdma.c             | 321 +++++++++++++++++++--
 2 files changed, 304 insertions(+), 29 deletions(-)

-- 
2.43.0

