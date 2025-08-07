Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CEB126E716
	for <linux-cifs@vger.kernel.org>; Thu,  7 Aug 2025 16:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754583147; cv=none; b=diXjrvgw/PyVY4xDHZp1FBxrSfHBS8ol30MPaFd6gas0OdaqXw5oLOKVY3f5mb0oSzqA9GvzHq/c9rNKA583cUsG01GHmLcQkSZttwN8jLQ4blfHkEn6WlSVv7ZFGJAhEV1wKbrCQ4ybbvavY/InwDCvyvTqora3CvW0nP2ZGGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754583147; c=relaxed/simple;
	bh=eXy+XdKjJ+WPgf53Eiq9hzJDqkT4Kb5b6SbZLQZjKAE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CHh8PHqjiP/vtq4sfxrCYFbjIoBCo7yPIEMonsXbPArfSVdXszFKVkI/qd0M6Y8/od+5jv/lUfXH7IUevi6dNdXUBCWSneawI4FZnY/7O1FkzkT8eEKod1OilHlKIYWfV1F2GQtIcD6tOYTD3JfvPOREa0OeIJ/joItisC4QWMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=BBnC9vRE; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="BBnC9vRE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=/C1CqhI10VUgF6eD/HMz/kLC6eN5I58KPzRJ9uSjIB4=; b=BBnC9vREJtF8A40cGxhIiIKykI
	LX5E2Ek/Xu4flWRxGHuw0FB+onQFz7PgOWPqZr7cJ+8tOxIMjvR9j7UgUSOLudyXbTZxcd5bCqGUL
	wUBbfb52hhYx1SKGTjELz4webVBXHEjV9G+RMa99kVns57r0zehr/eEb23ZfivxxkZmziJm3ero6k
	VHAZwuSeSYuJAQkZVRWcZExdWF5OPc5nEOHBtavDKlV9PgU++HDT2jetKbhY2Hr1KRdl9fEtnb6MK
	Iv4qEwUq07ii2l2bywQms4coq2ZpGXYzoleRBqNn4MjERcvwtmizC78VbdX4xOLDtPCLQi/LbGCSB
	MrGxBj0WnV41uyovY4XqIUNAzdBeYcNhLj0PagPPrBiXxJd73DqvzN2xzbCKqoU+M2O7D9XF8nP7K
	rabkvdn2SyQnAAClwFvCGaOaDPMieN2HBy+jqLnoJTAK3NFHna41eNNXhDteQ3z6/ntyENqFBzWgU
	vyuXtboTSP79XMaAcFkfFITQ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uk3E7-001cYo-2T;
	Thu, 07 Aug 2025 16:12:23 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 0/9] smb: client/smbdirect: connect bug fixes/cleanups and smbdirect_socket.status_wait
Date: Thu,  7 Aug 2025 18:12:10 +0200
Message-ID: <cover.1754582143.git.metze@samba.org>
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

This patchset focuses on the client side today.

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

I plan a lot more progress on the server side tomorrow
and hopefully finish the moving everything from
struct smb_direct_transport into struct smbdirect_socket.

I used the following xfstests as regression tests:
cifs/001 generic/001 generic/002 generic/005 generic/006 generic/007 generic/010 generic/011

Between cifs.ko against ksmbd.ko via siw.ko.

This is on top of the patches for the client I posted yesterday...

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

 fs/smb/client/smbdirect.c                  | 137 ++++++++++++++-------
 fs/smb/client/smbdirect.h                  |   8 --
 fs/smb/common/smbdirect/smbdirect_socket.h |  15 ++-
 3 files changed, 105 insertions(+), 55 deletions(-)

-- 
2.43.0

