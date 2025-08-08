Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3680186E2D
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 16:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754671706; cv=none; b=FQpg4ukvdbvBZbZ2ILG9nwQfxP2TvGP/CxH/F+5XtMBU7QhgEyUWa4Hs3VGOhZO+9KCSeGBu3p7UvhxA2bQFLk4C4W5JlECi3DldaFOSHTY8hE8Qug24tIr6dMnkIHJo56OwkH82BTTPgqfM8UE2CwBLmOMNQmh4IuJDRfJbkmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754671706; c=relaxed/simple;
	bh=VPz3Qvr8d5OtZATZF77cagzZ+DkzC4eqqNPql71jBMw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nLiW4g+EvL5K5JxsoBJsAfNhPZbmSdkOer+kSUoxfQd3M+YbDMsf8/t5GZwkjPUSY55XVXshu83ta8unvD9M2jWGdPi5pooBFTbaaSTgEzkEOPNlCakNQDRE/yBuAkXLLFIHoF/vmfACSW+qV9hwhQpzzvDmPVZKZXnGaLWc0FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=iUoytrmI; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="iUoytrmI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=i4Pvjp+MJ7/cVrnspLr5xjJdmUHVkyVFKIm5pjL3358=; b=iUoytrmI3DYS5JI/jK3a2Sub5W
	xcF3aADNZ+Urz5w64MSEt3wT3255oK6Ee7DGlZRMz6NiWFhefe7nuguTR61byXCx15nC2hmadAQgn
	zmnEcCOLyKg6Snl+OkWVUJl47un++fNdAzzvdCA6ny+2Ie9IWKMTVNkwnVM/Uf2lN86MMea+NIrQq
	UfiMxptMb5zqDq0YtbI8tkLOqUwUXvbxgsc0vBbquh8NCUr3TOP3/q9R1/h1QYsh1z5ZeV4lE2a+w
	e/udUcgITJJD7+/e0mqOdptpGcQpWh9uqjW+Yi7ra7f6Ai8/kOcGvMvm7P6k5JTMWz0Yd/e8FY4cP
	D33q9BZ3UzTR5X98FhvhAjy2j8Ybg3SGLzt+iR3VMOxXO9ngm3FJPvSrcl+HHE7Cd+ywIRjWpUF+L
	LaYBiQfBQX5yDqwNzhQv3AKsym17XrrXfTbnibYbBxVgBI59vhtR4ME46fTj7j8n1pdA6ydwLLs+J
	qArA2V6yX+dTosI1REOVucXG;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ukQGU-001qLk-0a;
	Fri, 08 Aug 2025 16:48:22 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v3 0/9] smb: client/smbdirect: connect bug fixes/cleanups and smbdirect_socket.status_wait
Date: Fri,  8 Aug 2025 18:48:08 +0200
Message-ID: <cover.1754671444.git.metze@samba.org>
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

V3:
smbd_disconnect_rdma_work() needed to handle more
than SMBDIRECT_SOCKET_CONNECTED in order to call
rdma_disconnect.

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

 fs/smb/client/smbdirect.c                  | 167 +++++++++++++++------
 fs/smb/client/smbdirect.h                  |   8 -
 fs/smb/common/smbdirect/smbdirect_socket.h |  15 +-
 3 files changed, 134 insertions(+), 56 deletions(-)

-- 
2.43.0

