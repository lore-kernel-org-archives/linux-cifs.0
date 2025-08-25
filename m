Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610E928CF77
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155154; cv=none; b=ZlOEDyCuK8Jk/DW1bDnnNGTvBVQXC0JWTvkbP+nCRipyyzRao6XoS4RXjbCOfPpGzj1NPUO8hxcDRq6v4vpQzSbSWVxbilXqrdYoXu23vSPm2APzmoBPwkzyVdqCI+YUerBIJeCWvgkEJX2XVsNR9b7AF9hhYLfRXi3NGGw+8/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155154; c=relaxed/simple;
	bh=sTzK4Xlc9FFvTc2fJ07pGRX2iEA7oZt1qTOHVNH9GNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgEgjoDq8xIahzvBE0nV4SLrKzNNXml6EDgzvTt/skWfGFKDOfVtT6WFgSKHM0ghxXCkrH493XnYW4jYZzzU7D2cP4aPh1/xQ9pe/WZLtAaeN3HwHJw6F5MU/r/UP64iCtgPPeBuqmGX88nRI42nugFb7Lm2f46NN8M2V2y3jrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=v8Se3/hT; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="v8Se3/hT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Ra2IgFt5mosX8C0GPiCAz6yc4/uCl62IWCdvHjh1jiU=; b=v8Se3/hT2N0VA60PDVT81TQXeP
	qtftn4RQCWGshBmWcPm6rG4AuRsHrVAiLk/ea4ePFZLeiuEonccJbyfW2UiLbp6xvdZ0BIn4iZipH
	dL3WLYs6WjAlzbJdxinfJGuPsuvfc1H/3YWN6EjbvuyBmRn9pnrmldh8GcFGwsgX6N0Mpfk5UZI4Z
	iYEhUsWbCWdYLQYKvjJ69kRG/BfxzpScQMQwHnqTfVnakeJL/5xyRLcTkq8n4LrCKMFKx9wC8y31A
	z4es8Gv69JN2Kv54m9Wen98AH/32skJQjGOrmKorROMO60SAEqX5BSPYjsF79MpVmVlfaCcUkqkLI
	3LWK+Ot8pn4r0V5WF8DspdZEzWMIvE7VB4tNEo3+/BlIU93CuMclw0J8N7UFym4CMN8q/f+pin8MB
	WzOEpaeFbq4j/Eky8EgLmnRSRCHrnGHEQYt7ep0ISjie3yuj9o6wTjyL/D4+38TbWgWTsQhyJfy5Q
	hQAMLYUKIJ274vs3/TDwK+bW;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeB3-000lMF-1d;
	Mon, 25 Aug 2025 20:52:29 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 064/142] smb: client: pass struct smbdirect_socket to manage_keep_alive_before_sending()
Date: Mon, 25 Aug 2025 22:40:25 +0200
Message-ID: <08b9f7d6acf60d9531eab8183f0fd98d51a8283a.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will make it easier to move function to the common code
in future.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 552eb3d29dfc..782621a844f1 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -938,9 +938,8 @@ static int manage_credits_prior_sending(struct smbdirect_socket *sc)
  * 1 if SMBDIRECT_FLAG_RESPONSE_REQUESTED needs to be set
  * 0: otherwise
  */
-static int manage_keep_alive_before_sending(struct smbd_connection *info)
+static int manage_keep_alive_before_sending(struct smbdirect_socket *sc)
 {
-	struct smbdirect_socket *sc = &info->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 
 	if (sc->idle.keepalive == SMBDIRECT_KEEPALIVE_PENDING) {
@@ -1067,7 +1066,7 @@ static int smbd_post_send_iter(struct smbd_connection *info,
 	packet->credits_granted = cpu_to_le16(new_credits);
 
 	packet->flags = 0;
-	if (manage_keep_alive_before_sending(info))
+	if (manage_keep_alive_before_sending(sc))
 		packet->flags |= cpu_to_le16(SMBDIRECT_FLAG_RESPONSE_REQUESTED);
 
 	packet->reserved = 0;
-- 
2.43.0

