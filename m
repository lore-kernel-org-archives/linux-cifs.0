Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276B52820D1
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 15:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754666898; cv=none; b=K8CAtJ5VcmztoE2TGM43xncYXzzkbpNiDnbvU6rao9KZ7SgMvXfIUrXA5H3ymRBp1xpLFwB3QntPTelcmmztj9aJNqp7WmNg7AghryigEIxjf5moV1XXuSQdO9Zjcm+DeOgrj9LzgLLpOlbLGvyHvv5RpA94tlnnHsBvt/qERek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754666898; c=relaxed/simple;
	bh=LhKOUx6Dy/95W9yO1eKxOXLHBmuC4Ujaf/CceroYW+I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nluZylynRKeVgIfiWsB9fAq2y8eGwbtbPND9ymMytsAuA8nPXDZ/n5JOOmoFlRoYu8XZUclGQc53I9x4a8cQep9rbC1lURrWnFvqWWkD1zvpnU4svzi/lyz1jCUeWBiPg7zsTfWqqrPhBxxxdfB/lDc5KZq92MjOTDsztR+fOWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=cwt6TqDZ; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="cwt6TqDZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=ZalSMCbOeBGEO/cAqDXW0q/oqDdJ/qs2lM9C6VfUB/w=; b=cwt6TqDZ8o5QXJmaaNuJxlJX4U
	4/sw0MSdKtrXzh3eRVyFqnuCV5eiyTxSOYp5KSDYAXRerwLxQne9V4qYd5X6xLKKhx4EoVP+7HjTg
	+9DTCRjAgs8agYNSt3lxAXlqJN/gxSxqlZ8vft8lRQZvyP1twRbjs0ggImd0/+CqZ3eNK7Z+lybn2
	gb+iIqrUfxU7tHzVZCcZbm6/spRz9jgRy2bX+EKx/YSh3KINt/MIXfaeF/e4mPm/G9ciBgt7IU5DM
	w2/hC2bflhvk95DlTANqvnJCIJY4ADcqdMNbsf4Zl4Ve8InC3J8hDnoQDV5kvrC9ntmWj7HoA8SCK
	BQu831tBLgZ/UoRkss+ZhK7+ZoRjoAcWyTYaxiRxWL421PKUC0DwAZvuv9dddVL3w0eka/EODl6bM
	aQiT10fJrtxxVsqT5X9/ijEAL7w0r0Zg6C5A+ufV9J1Thg6dKmDeHVprGlV+ISzNxZELAmpIFiIlv
	CXuxbYrd/McuL+ZuY9PLw4j6;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ukP0v-001pNf-0g;
	Fri, 08 Aug 2025 15:28:13 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 0/9] smb: client/smbdirect: connect bug fixes/cleanups and smbdirect_socket.status_wait
Date: Fri,  8 Aug 2025 17:27:58 +0200
Message-ID: <cover.1754666549.git.metze@samba.org>
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

This patchset focuses on the client side.

The first one is a fix for very long timeouts against
unreachable servers.

The others prepare the use of a single wait_queue for state
changes. This removes a lot of special handling during
the connect and negotiate phases.

The last two move the state_wait queue into the common
smbdirect_socket.status_wait.

For the server I have only a single patch that also
uses smbdirect_socket.status_wait, but I'm skipping
the server patches today.

I used the following xfstests as regression tests:
cifs/001 generic/001 generic/002 generic/005 generic/006 generic/007 generic/010 generic/011

Between cifs.ko against ksmbd.ko via siw.ko.

V2:
init_waitqueue_head(&info->status_wait); was moved
to the beginning so that it is correctly initialized
in smbd_create_id().

Stefan Metzmacher (9):
  smb: client: return an error if rdma_connect does not return within 5
    seconds
  smb: client: improve logging in smbd_conn_upcall()
  smb: client: don't call init_waitqueue_head(&info->conn_wait) twice in
    _smbd_get_connection
  smb: client: only use a single wait_queue to monitor smbdirect
    connection status
  smb: client/smbdirect: replace SMBDIRECT_SOCKET_CONNECTING with more
    detailed states
  smb: client: use status_wait and SMBDIRECT_SOCKET_NEGOTIATE_RUNNING
    for completion
  smb: client: use status_wait and
    SMBDIRECT_SOCKET_RESOLVE_{ADDR,ROUTE}_RUNNING for completion
  smb: smbdirect: introduce smbdirect_socket.status_wait
  smb: client: make use of smbdirect_socket.status_wait

 fs/smb/client/smbdirect.c                  | 138 ++++++++++++++-------
 fs/smb/client/smbdirect.h                  |   8 --
 fs/smb/common/smbdirect/smbdirect_socket.h |  15 ++-
 3 files changed, 106 insertions(+), 55 deletions(-)

-- 
2.43.0

