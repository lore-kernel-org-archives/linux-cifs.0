Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795797667;
	b=QXVYkfHzsaiHhSBMapaJRBqcWB1mPYe9QMwQR7+X/IMKcD4KDapLht012uniAEEZvhWq
	 YbabARmSsBAgsgAa9Tjy5ClOYQTyqiLD6R1rsJYs0Vm26j2SIUl/5B4umiTcbn8uU7brJ
	 lVOCuu2XabbaXp/Tfbb09DsNIBLdQLqbWIi4Q0j7zy9bX1HI+aKV99KeaoRCmWWUnDWFm
	 d+b3nzkJBsEgh3KTqfhgFn7ggCUdcrctSdPV6UCcvvoSntttyX01kvKjcA7WquOZF2K3N
	 c/r3PTPdR9C+pdm0DMC759x8DalXYYHTZzXWgjecglWcWNSUgaqBFC9tCgPfWgVUnEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795797667;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=n+cznVKVeK5eBOmjTtcLtZhhSRsczIsKfVh7hQ3kG4Q=;
	b=B1RnqYJv0KvbZM+4tac1AUnvxW+e+A+zrxNqkSeSN1M/0Xwga7i1KS8YISr+yff0dbRs
	 1WDnwvH8MIIDF1/lV6xmoBUxz572/b1FT2rfc0MNWBWVSwJqeNN62O4qBBQ0PmpinNY8V
	 IsaCqMBKRdc+0HfTrqK7PxUGi7GdrqHtf92YYSXh1JuDfCP/ApJg7WZaoQX8foOoXIufP
	 Av3ge7nG5fOKamnpPol7BFMZ0cgI15IJW35l0fwSpndAeVQdk79pMQ5MSyNDG/vY3Y8Ki
	 7Ld2ZBEhdpLAYwD1scrkF6MAcFAwsFBmA1yNBbf3TQeS5Fi5xMC+y6LlazB5SQGpaiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=bmyZKpJv;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4A6606A326;
	Fri, 27 Nov 2026 16:41:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B4A6606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=bmyZKpJv
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=n+cznVKVeK5eBOmjTtcLtZhhSRsczIsKfVh7hQ3kG4Q=; b=bmyZKpJvIrVu8j2Ngth1Asvdm8
	dUruqjceCchTXSxpEbt3912pi5v3/iEu1NItOpvhPPpzPLTS+bizoZh2CFqJtWM2jHJZVEpBZRjI7
	L4y2miDzC60mGMrXUa9lTlpRWC9MEdukYDYQ7Uvj9EXYPGm9IM/RoIPP1r5rpncs1XlOWMJAnhF6v
	7+F4vclfH6xzRJF7MXfE2QCMNwM/WUqkLW9/Kw+cEUIIQ1pBpHGfncRNJyiD10i6hD2KVtMRgJM6Y
	Zgx/DWorgTFdTvPjuDPcZsgZFDYC0mMlLumHVbD2tYmxTWW0BYSonghwEypm1j+3BM88QTVZTZj1d
	FdL8yLaJA5QCKqrV4/QjQCbwqKbc+hSOR/QXA8CDZf8uI1Da+zDM7KfoXoWG+Kkk83b/0pPrl7pCr
	Ny7pJbQeHqrSIinNjdQuKe4azMlpivDMwXI23r8cejZEhU7zcF3i0NcxL31ZIcvp4/kDEzb90kWdN
	LaHvKMIGi/Cpt3dGC+YyhfXH;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWz0O-00000001PwA-3mnP;
	Fri, 27 Nov 2026 16:41:00 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 04/13] smb: smbdirect: give back the send credit if waiting for a recv credit fails
Date: Fri, 27 Nov 2026 17:40:23 +0100
Message-ID: <35b763098ecddf750336d1096e4f29d4eccca09a.1795794871.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1795794871.git.metze@samba.org>
References: <cover.1795794871.git.metze@samba.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If smbdirect_connection_send_single_iter() got the last send credit
and has no recv credits to grant, it waits for the refill work or for
the peer to grant new credits. If that wait failed, it jumped to
credit_failed, which only gives back the local credit, so the send
credit it already took was lost.

As it was the last send credit, sc->send_io.credits.count stays at 0,
so every following send waits until the connection is torn down,
e.g. by the keepalive timeout.

Jump to alloc_failed instead, which also gives back the send credit.

The error paths of smbdirect_connection_send_single_iter() also don't
wake up the credit waiters and don't give back granted receive
credits, that is fixed by "smb: smbdirect: wake up the credit waiters
after a failed send" and "smb: smbdirect: give back granted receive
credits if a send fails".

Fixes: 93ac432274e1 ("smb: client: fix last send credit problem causing disconnects")
Cc: stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/smbdirect/connection.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/smbdirect/connection.c b/fs/smb/smbdirect/connection.c
index e375584ab447..c50096e605ee 100644
--- a/fs/smb/smbdirect/connection.c
+++ b/fs/smb/smbdirect/connection.c
@@ -1184,8 +1184,9 @@ int smbdirect_connection_send_single_iter(struct smbdirect_socket *sc,
 					       sc->status != SMBDIRECT_SOCKET_CONNECTED);
 		if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
 			ret = -ENOTCONN;
+		/* we already have a send credit to give back */
 		if (ret < 0)
-			goto credit_failed;
+			goto alloc_failed;
 
 		new_credits = smbdirect_connection_grant_recv_credits(sc);
 	}
-- 
2.43.0

