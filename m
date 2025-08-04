Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4237017332C
	for <linux-cifs@vger.kernel.org>; Mon,  4 Aug 2025 12:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754309779; cv=none; b=D0EDNl4tQITfOr6WxZXCcUHiS+xMaepYbfVabP/bLNgo/0EpCC7FcpwWxJl1XtQEzMr/SZMmA+qriHkbGmJJObeCu8iiwDheNxDkbjPa4Wd9ll6IRAkzCT1s3kn+dZPqCehIkapFSUHgz16Fde5EJ9+11HTr6AqyoV2tOCSBIHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754309779; c=relaxed/simple;
	bh=T/kQyHFxXfk6mtA7BY5MeBBx1qUDkliyhqap9r2CuMI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NRYsOHw+t6u8IfQ8BtridFq+ujCNIbHtJAAsXUvjBroPqcX6lQmeLaM3Ib6tkYqdb6oA1Aalwk8TqPZgBmDu//iTg/rIiCcy5TztUPWtWhfsy42HRZTY7oaR8yLd/GP25hOXmb89H8fkLNth8EW81rCUACcbg9j6XP2FVYCKsyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=uLTYsGOm; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="uLTYsGOm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=eora2fqI5chQvxkEuD6zk0R5R0d8Ri8Smny+KGFtbIU=; b=uLTYsGOmYLRuZA7FakALmPNLCE
	zVWatNwIMhoyhk1spc1ijad6MWJOB+clHCCNe32NtUZdrvY9cpmULfrghG7VGg/aASP+85iuyXgEm
	3W6zLJ+BiOuZ6t/kFRstehfLZ2YufRs2fiQvsSbbIwGD74c+AOALyL79FH5pMSmJ3Pkff19zz8N7c
	csHA4wDORk3RF/FNwNOLNKgYeTtELUnyHwXaKGWNqyKImvGQcNG0GzpA1Y8C6Hx830CVVfU2koOY9
	x8pk4wwpFKqN12Gp0KlHzzW0iqtBBfmLPqVKwQIKp6VEAYb1691ANirwYx0RV3k8H69Xl+a7ng4VT
	+0UH1eH4F/rS48JHwvXml6Pf+08VT/hX0nuoyqdLby4N1I6yNNlLqaoFGWPB9t1uW2YA8bgec6Q2T
	Qfu/tZyFl5s9IXvnql5uanJE9PCtjbqQVah96RSfdnsGSERaEiQX4mxoC6CfNZnY74uPQCy2qABL7
	3E9ttXKhX2+93vmPn7FN0+c5;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uiu6w-000wCL-2P;
	Mon, 04 Aug 2025 12:16:14 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 0/4] smb:server: fix possible use after free problems
Date: Mon,  4 Aug 2025 14:15:49 +0200
Message-ID: <cover.1754309565.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While refactoring the client and server smbdirect code I
noticed a few problems where we might hit use after free
style problems.

In order to allow backports I decided to fix the problems
before trying to move things to common code.

The client has similar problems, I've sent a separate
patchset for the client already.

Stefan Metzmacher (4):
  smb: server: remove separate empty_recvmsg_queue
  smb: server: make sure we call ib_dma_unmap_single() only if we called
    ib_dma_map_single already
  smb: server: let recv_done() consitently call
    put_recvmsg/smb_direct_disconnect_rdma_connection
  smb: server: let recv_done() avoid touching data_transfer after
    cleanup/move

 fs/smb/server/transport_rdma.c | 97 ++++++++++++----------------------
 1 file changed, 35 insertions(+), 62 deletions(-)

-- 
2.43.0

