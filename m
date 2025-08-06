Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B776D29C33A
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 17:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754501786; cv=none; b=CsyMsukOVPtJkGD8Lx0TGRClJK75XqNuEksGag1ypBKsmc3MMrIXMCg3FfjZ8kPczDYCUEEflPgJ7kWXq//UdZ6iRo2y2y6LljHOL79hnrSn3wKwn8v3yfOKk1MYjsExF7hQ9ZXEhlZGaqIoVAnn7a7RbMJ7LGLoFc2kjhjIAh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754501786; c=relaxed/simple;
	bh=gc0KyyYyVeKXSFKR48nJQrvJxm/xPGTxderTufbLLK0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cGaCglOqkmkBho/xfGI8+qIKsEWJ4KZyo784rtReFZje6c582qq/Ax0NA7bIetEBSh3dyEtAm44NuYoXgVGHlGZ3VKsIPjVPOrErHcm1TqRVTVag5FmOTZHOVtqoJHAVNf94ZokZaBR34jHq03zBNzt6UDuE1KiI9uVKG/uLT7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=hHjO/E9N; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="hHjO/E9N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=NGUczztnA5N8zdxeKC70fijwcwkKlzvVZOfwmMQ1OL4=; b=hHjO/E9NV7OKNOyvXxw/7Z8l/j
	97oI+DpM2u3Y+3EYynCJj/HltvSFv6cg7EzhPKVVRp1XcslyeN85sWdoyeFDDHTufyKd6hhgw2zFN
	ftQS9Mlif9PHPrnNJybybchtOic3t/HSt7wzbRy/w1ppbS8TdVBFZh5i7/9+qrCMLEO8WpO+ihCBu
	+galiPSBZYZRN9vRIUHzeWbv1H7QpQZh15Fh6nAai3hVJRek0l5UHfBx80SK9NjDZKXUa5Ql8cSHC
	SzkAvcSpnfEv3ZCf22SUVqwl0I8pC8V2Ti/8sa5ePK35Tv08Ppd4zlQMkwZhsBqNboP5REVXbQURJ
	BxDnVmWIStTqa8oAtN6ggb+hd1nkV3ZoJmFuTJnZT6RlZKcjSyaXOaGoBq4i4e4F44svfy1mCGJg5
	TFi051ZANyqLqbNtMSmne5WCSCplSuEi+i7vlP3jwU0jKTM7v5gBBf+xtnQBU/8W4x1W44QIr/QZS
	67A5lD/E0rQv3KnT1i6yPiaD;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uji3i-001OWh-1b;
	Wed, 06 Aug 2025 17:36:14 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 00/18] smb: smbdirect: more use of common structures e.g. smbdirect_send_io
Date: Wed,  6 Aug 2025 19:35:46 +0200
Message-ID: <cover.1754501401.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

this is the next step towards a common smbdirect layer
between cifs.ko and ksmbd.ko, with the aim to provide
a socket layer for userspace usage at the end of the road.

This patchset focuses on the usage of a common
smbdirect_send_io and related structures in smbdirect_socket.send_io.

Note only patches 01-08 are intended to be merged soon,
while the ksmbd patches 09-18 are only posted for
completeness (as discussed with Namjae) to get early feedback.

I used the following xfstests as regression tests:
cifs/001 generic/001 generic/002 generic/005 generic/006 generic/007 generic/010 generic/011

Between cifs.ko against ksmbd.ko via siw.ko in all combinations
with and without the patchset on each side.

Stefan Metzmacher (18):
  smb: client: remove unused enum smbd_connection_status
  smb: smbdirect: add SMBDIRECT_RECV_IO_MAX_SGE
  smb: client: make use of SMBDIRECT_RECV_IO_MAX_SGE
  smb: smbdirect: introduce struct smbdirect_send_io
  smb: client: make use of struct smbdirect_send_io
  smb: smbdirect: add smbdirect_socket.{send,recv}_io.mem.{cache,pool}
  smb: client: make use of
    smbdirect_socket.{send,recv}_io.mem.{cache,pool}
  smb: server: make use of common smbdirect_pdu.h
  smb: server: make use of common smbdirect.h
  smb: server: make use of common smbdirect_socket
  smb: server: make use of common smbdirect_socket_parameters
  smb: server: make use of smbdirect_socket->recv_io.expected
  smb: server: make use of struct smbdirect_recv_io
  smb: server: make use of smbdirect_socket.recv_io.free.{list,lock}
  smb: server: make use of smbdirect_socket.recv_io.reassembly.*
  smb: server: make use of SMBDIRECT_RECV_IO_MAX_SGE
  smb: server: make use of struct smbdirect_send_io
  smb: server: make use of
    smbdirect_socket.{send,recv}_io.mem.{cache,pool}

 fs/smb/client/smbdirect.c                  | 112 ++--
 fs/smb/client/smbdirect.h                  |  38 --
 fs/smb/common/smbdirect/smbdirect_socket.h |  54 ++
 fs/smb/server/connection.c                 |   4 +-
 fs/smb/server/connection.h                 |  10 +-
 fs/smb/server/smb2pdu.c                    |  11 +-
 fs/smb/server/smb2pdu.h                    |   6 -
 fs/smb/server/transport_rdma.c             | 742 +++++++++++----------
 fs/smb/server/transport_rdma.h             |  41 --
 9 files changed, 500 insertions(+), 518 deletions(-)

-- 
2.43.0

