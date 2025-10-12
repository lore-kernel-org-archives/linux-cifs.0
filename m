Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530C92F1FD5
	for <linux-cifs@vger.kernel.org>; Sun, 12 Oct 2025 19:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760296254; cv=none; b=hmWf0tnt5NEtRol+qchC1StRm5r2fCa2+Zn9r3tsZFTlJ78587MGUbkR/qJ7k8I0n9MhDYsrV0xOHkBxHwBk2rlXSnQ/o7z67I2j+Zyy1fL0vRvcQ7Fk4fP2l7/44YghcZD7sevG1vFbuszC8ijUhmMIAzdNHQdz3d/wavAgask=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760296254; c=relaxed/simple;
	bh=4XHn+72sGuxlRfHfKMt7SA85v8ZeKUWauWieLhMLRhc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cacXbWffrMNN/k7z6WrH3YlUEEt3a0jTEiltiECxPF8UkHy/aF6WW2g8pbteJJZc7c3e7mT5kEX/5gElOmos5Uh8/Xo4+IWp7hCQznx4dxMejA8rEiYbs4uI5lmY29n3cJh0Ow/ggNiOWazgoBqKNx91NkJ/QvsJm6ThdKtbzIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=yM4ZEo3+; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="yM4ZEo3+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=C3xK4o2im5CSEngKJSj5dBitw+XSS8ccMgiHuGRZ1JU=; b=yM4ZEo3+pVYeLy5IHReaJ0P3Xl
	EWB//7MgQsH7F72DKlAVGQwCqMoT/4FCpLpUNZp4DRSLX+7WV639rpwdPxb6EU70kn+hG/E4CWWvZ
	AtpR3Z69WqprS3R+t4KZum8lvAViwlNkNgN6LeHzQqbX0N1m3ZEkaThQ0dOy9yP3htebkbcf2w0ed
	Hj2fL/OIfSquaMlFo+3nm/p0+GvEvVc/63cTPp7uvVYILLjPCoFoSa06HxZupTiAk0QehMWSQLUdj
	MguilAml+QQr16q0ryjFHnJUg343VShrTAPi4r9un6kjTlLHIs5iMEPtkLNftWdBvZ0+UljdH1vXR
	omyRrNLW8izEOhy7hdyUpbwj32lJrWbdtTEp0zYmQJUz9OMhJcY9ZYXApgjuwn78cD0YDST67RENg
	MFQNBR/+qj6CV9Q7NqkyzUOYvgcWWggZ0uaAw5Q+v0ix9HiBbKRqu2sytyAODPyX6tzz4efS8n9jy
	he6VAdalxiJvmMw/wnOk8q0X;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v81Sr-008nzT-1L;
	Sun, 12 Oct 2025 19:10:41 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 00/10] improve smbdirect_mr_io lifetime
Date: Sun, 12 Oct 2025 21:10:20 +0200
Message-ID: <cover.1760295528.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

these patches improve and simplify our handling of
smbdirect_mr_io structures and their lifetime.

smbd_register_mr() returns a pointer to struct smbdirect_mr_io
and smbd_deregister_mr() gives the pointer back.

But currently the memory itself is managed by the connection
(struct smbdirect_socket) and smbd_destroy() has a strange
wait loop in order to wait for smbd_deregister_mr() being
called. It means code in smbd_destroy() is aware of
the server mutex in the generic smb client handling above
the transport layer.

These patches do some cleanups and fixes before changing
the logic to use a kref and a mutex in order to allow
smbd_deregister_mr() being called after smbd_destroy()
as the memory of smbdirect_mr_io will stay in memory
but will be detached from the connection.

This makes the code independent of cifs_server_[un]lock()
and will allow us to move more smbdirect code into common
functions (shared between client and server).

I think these should go into 6.18.

Stefan Metzmacher (10):
  smb: smbdirect: introduce smbdirect_mr_io.{kref,mutex} and
    SMBDIRECT_MR_DISABLED
  smb: client: change smbd_deregister_mr() to return void
  smb: client: let destroy_mr_list() call list_del(&mr->list)
  smb: client: let destroy_mr_list() remove locked from the list
  smb: client: improve logic in allocate_mr_list()
  smb: client: improve logic in smbd_register_mr()
  smb: client: improve logic in smbd_deregister_mr()
  smb: client: call ib_dma_unmap_sg if mr->sgt.nents is not 0
  smb: client: let destroy_mr_list() call ib_dereg_mr() before
    ib_dma_unmap_sg()
  smb: client: let destroy_mr_list() keep smbdirect_mr_io memory if
    registered

 fs/smb/client/smbdirect.c                  | 312 ++++++++++++++-------
 fs/smb/client/smbdirect.h                  |   2 +-
 fs/smb/common/smbdirect/smbdirect_socket.h |  11 +-
 3 files changed, 224 insertions(+), 101 deletions(-)

-- 
2.43.0

