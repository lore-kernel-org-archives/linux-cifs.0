Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C702325721
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 14:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764080532; cv=none; b=P/Co0E/pyN5w3zSCn3tUZDVuL17y7kIvIShCqjwAvMbWNKtYzeln/angYpOIuRImv2Noi18imSwgkohHnHriyVrWFp63gbaZPyCta/tvMhmNPPyb/MWkdhGat+TYkENwLx1tdK/VtAvIQQZe89hvAxjVmo9bPki7iv7oG/fGsh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764080532; c=relaxed/simple;
	bh=RQjMCXsuX5U1xGO3HywemjkTmvG68q73Tuw7Yr8TF6g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ngBgxLdzK20rcW/ElywVOMIdRUmZBin4bU6NuMGusIX++SU8CRUAupwnXNPn3bJWV7E830wv00Tgh5EjBGsis6+l4Tvoii5Jfsqe8Lj/qudR+rQgKB2dxvJEO5Uy7Bv61sZzLjc0F07aXW/fLlibVBYBBRoWYXxfWBP0sgyf7eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=d3FYnf2D; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="d3FYnf2D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=bYY3AOmGiKgcZTF7Mmtp25ETkgx4F0BmYP/mA7zw7/s=; b=d3FYnf2DkbEhUgwZTwfkOc/9BQ
	AC9NBtFOv+24lfEAC0E5oY32VN+lcw4dQLdJfH6OOVrTcrto3Q32LQSIzDTijLCDnL6VcIFX9VKWy
	lCxM1qq6gQ6bcnbVkT3q60UnmIQG8siFs9BoBgZhUmYvLhIbKbDm8ZO78jrNUcCB924WisG0RnB5s
	XfMzpEd0zMe+S2agOPXs/OXZJ0avVhUMkpSTkD5Mb2RKJ8lt0uTemoTgu0WYgg+PgQA32AlbWq0cY
	kwLPRsJILf6BTqkuFXnll+w5+nKd70QJlSVf8gOAsMwtzaCifA6EgOuzCuK9NVwIfYZADujFGrHol
	HSkQsuUwBq1snhkRFba92Du774fWfnXHONDtaO0r8JOxRZJB+QKLIa3GXVF/1bMcTGEnZ7rMeNiFs
	+RxSXRoDxHQUguwOjBNm0efFjaSMZ68cCvtzILDvEJ8tQWvB7di5Kzs+qSF2KhbQtrHtSHBeUvMjX
	rACI2XawVLr6Fz/MDlxsJwo2;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNtvd-00Fasw-0E;
	Tue, 25 Nov 2025 14:22:01 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH v3 0/4] smb: smbdirect/client/server: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks
Date: Tue, 25 Nov 2025 15:21:50 +0100
Message-ID: <cover.1764080338.git.metze@samba.org>
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

v3: move __SMBDIRECT_SOCKET_DISCONNECT() defines before including
    smbdirect headers in order to avoid problems with the follow
    up changes for 6.19

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
 fs/smb/server/transport_rdma.c             | 40 +++++++++++++----
 3 files changed, 98 insertions(+), 21 deletions(-)

-- 
2.43.0

