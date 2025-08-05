Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B464C1C8603
	for <linux-cifs@vger.kernel.org>; Tue,  5 Aug 2025 16:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754410321; cv=none; b=sQk4gCg0y5E2PhCuhk82CDM04CBVUX+7aZKCvwVHe5JToKtsg8Q+R7eoJMBUDwjzoTtsSVuCvk1Ch57Hjo6zvUGJCXWHI3/INsItG2kEMEYf5jKe2nFoVhG0T1M5/qH68PSIi133ZrumP75PTCcc3lh8MyumNY6TEaudzscOawA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754410321; c=relaxed/simple;
	bh=jOJUTZ5rOdtrRNFeR28FWrdt7MB4OWMoRb1FOX4JHAc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ind3BgS3pXzQvattD4XE+D4YxGksxxXKv02VeonBYnhSstl/lPs7SyaE3Yw0gVv9TFQ78FIZDB4Ai0ujEidlLhP2FvDWctb1QzF97CgNqcCVTTsCc9DEqn5m0NL0yYHYYQ/0Hs8RyVxrzRkDARzfSTxfq9IXp96sqLlDLk7uRLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=UhKpOt3M; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="UhKpOt3M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=00LNmLviPOmuiNw6apWNFzSfq3PsRV1SJJmPYDRheyg=; b=UhKpOt3MZun9wYxhN8iBAGbvNI
	cjKr6ISVsHP4mP0UHSa/WtB7iUL4QO2LENnG1E4ipQjFsBxjKPKzAx5hW+smZmNt0MHwKwoX7v1ea
	yUSeNSmzaSUI6fkdn9j+ZKz07/b2vDL6DB50opYzpRWYXy2+ZjHjqJm/EPnz6kmfbmxkNBt3J01AL
	fFA7UPG1lfmEv6fACKA1g7aoAudVbKX9x5RVgHxTU9bL+SY5SDrkVP7wF423fsMd4yr4x4e6EUA8N
	mWtFXd3gL1Q5QJJaKoX67iAZDnM2WshxqqOqqLvoBjlapSlIhbBfqAXBbZv6VqnHGp9wQkZgBrsV2
	CxO3WU6BYZ09LvLOxJU8ZONZr1Om2pfJWe9mv28YcPnj2JGJBiylMMbjCkVTiZI+IH7JGSG5bWMGF
	I4JZdTAQcnVVXlb9g4b10Lb0Akjr1DtYfaIV6/m1dq6KquPTUHN32grdxtTC2RP80aO8wQeTYJeip
	sJn9INlST3FI0s8Te8x824mm;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ujKGV-0019Yf-18;
	Tue, 05 Aug 2025 16:11:51 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 00/17] smb: smbdirect: more use of common structures
Date: Tue,  5 Aug 2025 18:11:28 +0200
Message-ID: <cover.1754409478.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

this is the next step towards a commin smbdirect layer
between cifs.ko and ksmbd.ko, with the aim to provide
a socket layer for userspace usage at the end of the road.

This patchset focuses on the usage of a common
smbdirect_recv_io and related structures in smbdirect_socket.recv_io.

Note only patches 01-09 are intended to be merged soon,
while the ksmbd patches 10-17 are only posted for
completeness (as discussed with Namjae) to get early feedback.

I used the following xfstests as regression tests:
cifs/001 generic/001 generic/002 generic/005 generic/006 generic/007 generic/010 generic/011

Between cifs.ko against ksmbd.ko via siw.ko in all combinations
with and without the patchset on each side.

Stefan Metzmacher (17):
  smb: client: remove unused
    smbd_connection->fragment_reassembly_remaining
  smb: smbdirect: introduce smbdirect_socket.recv_io.expected
  smb: client: make use of smbdirect_socket->recv_io.expected
  smb: smbdirect: introduce struct smbdirect_recv_io
  smb: client: make use of struct smbdirect_recv_io
  smb: smbdirect: introduce smbdirect_socket.recv_io.free.{list,lock}
  smb: client: make use of smb:
    smbdirect_socket.recv_io.free.{list,lock}
  smb: smbdirect: introduce smbdirect_socket.recv_io.reassembly.*
  smb: client: make use of smbdirect_socket.recv_io.reassembly.*
  smb: server: make use of common smbdirect_pdu.h
  smb: server: make use of common smbdirect.h
  smb: server: make use of common smbdirect_socket
  smb: server: make use of common smbdirect_socket_parameters
  smb: server: make use of smbdirect_socket->recv_io.expected
  smb: server: make use of struct smbdirect_recv_io
  smb: server: make use of smbdirect_socket.recv_io.free.{list,lock}
  smb: server: make use of smbdirect_socket.recv_io.reassembly.*

 fs/smb/client/cifs_debug.c                 |  10 +-
 fs/smb/client/smbdirect.c                  | 203 +++----
 fs/smb/client/smbdirect.h                  |  47 --
 fs/smb/common/smbdirect/smbdirect_socket.h |  64 +++
 fs/smb/server/connection.c                 |   4 +-
 fs/smb/server/connection.h                 |  10 +-
 fs/smb/server/smb2pdu.c                    |  11 +-
 fs/smb/server/smb2pdu.h                    |   6 -
 fs/smb/server/transport_rdma.c             | 608 +++++++++++----------
 fs/smb/server/transport_rdma.h             |  41 --
 10 files changed, 505 insertions(+), 499 deletions(-)

-- 
2.43.0

