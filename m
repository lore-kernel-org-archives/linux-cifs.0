Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8732DAFBA
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 08:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764060970; cv=none; b=HR4sZM9jvdvXdMhWXCK6Cy0H9C3HOxUxtweR+s1UIe9aNGi/k80m8ir8dNeByY3yzNym0ktOpLNG/VPeHMoTVs5C3ABM+Lnm26GmU3wbumDaR1I7AXF/XgnBr0A5EqDDdVapwWAT6rK0Z+wk0MWelolq1pQC4IUxE5im8kfkKnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764060970; c=relaxed/simple;
	bh=vDANsbcwN0CGDPE5o2ahKS6SVu73z2yzwk/uzaBwKqE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TO1/xH8SXAEkzx9CmiSHO3jiZVL0mPR8d9steEpC7kQehAh3/gW9VfOBbx5JCYHPvnf3y0HAXbN+13tWoELdQiijfsnot7EonA3yCBMsmRFWGOyT7wpNmcjBwt1PkP6YToZevQb2w+oaKzcGOZJZ9oiD2hPIVqvVG2W9VMAGxAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=PlhipQ7s; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="PlhipQ7s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Hnz2480szv90NTNQyX8eDnXxOfZ1MVz6HO9CHwNLyTg=; b=PlhipQ7sUTszguxY7kkZe5L03N
	H4GPLFZLxPBnMOSWVr6ORnKedqRzrjyYvhmdzcMYYHZ9thr/Z7tdMCGqGliUJQ10bYe5E0RnuES7h
	8GQDGIdDg0Lipv2xFMERRnRenKF5jb8peQIGy8BC3LcXDEiFslMAz4mcfoKjRt8E8AFbrBy5vfc+l
	wTB8PScSozxEr38SvBeJiGdz3JTDdzML11qUbchBE6U/UrjwFlhisgaTNXoM61mRp+V0iAh5FopW9
	UcB2xld4x4rOT3c9LTMl/Fgu3UYebzIjfen3nmBNcWEE90q/lwd02BFCr0U/SRuxP8qaRHi4oZuR+
	CfUn0oFHIX6FQLj8nR4EDprz2OXEz0pccfsKocwh3JaRaVaCxSaUTWez+YRMOxxLjnfU7r3GJD97v
	LTuZqvEaw7/WV0Ch/Ec7Hrc9bTPHzQB7OEZEQzdgHFNYGPlj93sfg10YBRt7CzEK/tF12McewD4uC
	cIbZk5pMNRaH+mCRlcd6eMot;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNoqB-00FYJH-0x;
	Tue, 25 Nov 2025 08:56:03 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH v2 0/4] smb: smbdirect/client/server: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks
Date: Tue, 25 Nov 2025 09:55:53 +0100
Message-ID: <cover.1764060262.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

here are some small cleanups for a problem Nanjae reported,
where two WARN_ON_ONCE(sc->status != ...) checks where triggered
by a Windows 11 client.

The patches should relax the checks if an error happened before,
they are intended for 6.18 final, as far as I can see the
problem was introduced during the 6.18 cycle only.

Given that v1 of this patchset produced a very useful WARN_ONCE()
message, I'd really propose to keep this for 6.18, also for the
client where the actual problem may not exists, but if they
exist, it will be useful to have the more useful messages
in 6.16 final.

Thanks!
metze

v2: adjust for the case where the recv completion arrives before
    RDMA_CM_EVENT_ESTABLISHED and improve commit messages

Stefan Metzmacher (4):
  smb: smbdirect: introduce SMBDIRECT_DEBUG_ERR_PTR() helper
  smb: smbdirect: introduce SMBDIRECT_CHECK_STATUS_{WARN,DISCONNECT}()
  smb: server: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks in
    recv_done() and smb_direct_cm_handler()
  smb: client: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks in
    recv_done() and smbd_conn_upcall()

 fs/smb/client/smbdirect.c                  | 28 ++++++------
 fs/smb/common/smbdirect/smbdirect_socket.h | 51 ++++++++++++++++++++++
 fs/smb/server/transport_rdma.c             | 39 +++++++++++++----
 3 files changed, 97 insertions(+), 21 deletions(-)

-- 
2.43.0

