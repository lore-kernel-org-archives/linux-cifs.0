Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795782588;
	b=vb0XHG2Iftt/omvAJh258RYL79fLYeBIpAUy1SwOAHlcu74QHFjghDKNrE3wFQsC42Lo
	 az+GgIZFP6dUjt2hOsM2rXrRGak1tTsb86sxsEPM9DrPMIqpibv4LZnIEENCq85RQbxNV
	 u9yakCylbpZ8VsOUvpJPLq9uaRk8d7u3eq6T1MKL4oNGB32Tf8yGcS2phpzaYnlvriDCz
	 A/4xmGFnXE66z3LaCppUfgPACoaRmV2FcoiEu10yTcgfkGIprafyoGQwrqDLUNDuvqXtq
	 5shXCBIZBmIhS32cX59HhCdmTuRkrvYKzlFriuJhSpG6p/s6wKeZ8lYq0UQZNKi17Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795782588;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xM9lJ3g49tVus8eXcOv5fsw3rMUCCEvUj8iCD625dY4=;
	b=iavhmuhgPlARbO/PA570HoJAvFmifoKExn1DISG8J9kdZU9c5SfgblwhE6RaVuDrUWdf
	 zqVbx507+M1KMbAQONJC/klw9HlJzo/mmJ5fCTpWwTbxacojBEAWVVO0o5212E0R+/E/6
	 0eUm+7jZXUfLjKl0KZdUCC0C3oAQhDx5GukyBjLDITcXIzJ03+J4D2EZfAxHlEs7xF61p
	 wup9xYs60i/9inPH2R4tG66DH6spffGbVMmhq/IUm2i7bGBWSZjpR683lgkMjSfytCLU2
	 g5nBwm8miMSAQvWaO/DHyI5CGs8OwfiMeP4szhVx26/I5GIJOGwLiBevh41LjeHzxAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=KRDNYgKv;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CFD606A31F;
	Fri, 27 Nov 2026 12:29:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22CFD606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=KRDNYgKv
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=xM9lJ3g49tVus8eXcOv5fsw3rMUCCEvUj8iCD625dY4=; b=KRDNYgKveXdpphYObaCWCuaPXZ
	aHH3OgD7Vy7/KigD15UrnIgvr3efBpLibPZncI3BkPs0wRTY1VprER5ZSu2LGJOxdp5Dt+gGsr0sc
	IW5W04jIHWZP310GzxDKodIEzBZ21t6aPIonSiuZG1m/hJaHlFLtSLnToH9RrIw1kvnj+pk5qE4pn
	wktsZf1DM9PBQHvrCH5JTbq/k5VozpKSUSD12nrkNgjv/oMUqK8fpdmY50OKE+Yj5B450vENAsp0j
	qaHDJeTDA/tlEKR7vLuV9gNMnfk6XD295jPzCSgTV2diAuiEZShrEcl0rSbI+f1naibtJtt4CK4Jf
	AAwBbhFyXelb6C5jwgPZTfofhCyP/wGHI5XV8GXuaP4oNzDx8DCIky4adqIu6bmJzQwyPwPP0zbvq
	GthpEAlfNGEAXDreF/ckwQUHMQJ4rnm9eJnnmj9WKmPlCP+poksYctS7LzTFQO+OUoNAGD1nY24FL
	3cs+WF6fjHw8YsfjpptYSGKO;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWv5D-00000001LbL-12el;
	Fri, 27 Nov 2026 12:29:43 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 04/10] smb: smbdirect: give back the send credit if waiting for a recv credit fails
Date: Fri, 27 Nov 2026 13:29:01 +0100
Message-ID: <ba96336fec7c2af219b1c94cee9638e271643dd9.1795781300.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1795781300.git.metze@samba.org>
References: <cover.1795781300.git.metze@samba.org>
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

