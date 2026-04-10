Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7D033E377
	for <linux-cifs@vger.kernel.org>; Fri, 10 Apr 2026 20:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775851895; cv=none; b=EHVUldJ4klRcNe2a2Gv4hG5YWrFwKpi2lXVG9ZmzzR/BJZFmpqFe//+3BlF23NStbUZvtLUz/df1MUCt7RYtH1tiqvz+dtoNBbQVNZsR12qkKdrdTm9um5EYFTUCCAmO5XMigY3UD8xq2AA1uYj6jdGKFvos8W/UpfAX3O9bfsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775851895; c=relaxed/simple;
	bh=7V2deim1shwDSds3+C73OGkq6RqsGtKoF6QwJLSFylo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mTd6dAruDYBHoTMX7WZEdUUgzOYtPWoQOKs6J9kS2wkn9M/0GCju1iLYyoaVRzEIXuc0220fdz2YLHxQZcMO8bB50mtVLu4DvIzdEs9NemkUN2/79xjL+lApc1gvCuw+GmaPAiSFgeQAqi5soVRGosNLkiB3+2eOiAn7/zy7lqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=qZ6P/3Bf; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="qZ6P/3Bf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=0/gbFaWlJTvuMgwmQatvgm0QB9NiBlBeSMyg5NxSF+Y=; b=qZ6P/3BfeI+JIVxI1ruB6CcRsh
	6p/FxHlGxHJNA1ahXmCvToC5xm7RnqIHBidfPDewsN5fwBJqU0fbfjf/MRNbHDgshJQXmNWbJZbKj
	y6uQnJpYnqBjYteFj4CMHKpI/EW0r29A6mCAH/ba3FYZXIMPzT8QS/WkhDRSPZK3OQBrEWON4ouO2
	7+AlsVcT1R5t7HBTfyex9KDL7PS1fgGnFUN7YDFL9HEZdJY5Vk2VaWjlbrKHtrwQV2kiaI8ihnQxA
	eXngrKEpozDYrPqIUrUOfrczaKsbFmZC6lUjDZ8EbPSd5KtkThnYeREXgKnj6B2XGvOWH0d0z7yrx
	5MIF/XJCRHHTYa1n4WI7cv+ZMjaNqMm3khdoUrfiwTd9KHHJ3o1IkZrwxOEYyjUoMAeA1dCCf79Rz
	vjbE7dP0IIOHgcCDsfmW99J+EhIFpKm7wPhwDmhwr7Yt4+oQ/t21sKZ2xOEvqqRReyPrRnMxHEmwi
	s142Ir0AYDL74vNI9wRH/+Lw;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wBICL-00000000IJD-2D0g;
	Fri, 10 Apr 2026 20:11:25 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Ruikai Peng <ruikai@pwno.io>,
	stable@kernel.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Paulo Alcantara <pc@manguebit.org>,
	security@kernel.org
Subject: [PATCH 1/2] smb: client: avoid double-free in smbd_free_send_io() after smbd_send_batch_flush()
Date: Fri, 10 Apr 2026 22:11:00 +0200
Message-ID: <63d48102cf16da1bae51f8e37419dd7a5223462c.1775838249.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1775838249.git.metze@samba.org>
References: <cover.1775838249.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smbd_send_batch_flush() already calls smbd_free_send_io(),
so we should not call it again after smbd_post_send()
moved it to the batch list.

Reported-by: Ruikai Peng <ruikai@pwno.io>
Closes: https://lore.kernel.org/linux-cifs/CAFD3drNOSJ05y3A+jNXSDxW-2w09KHQ0DivhxQ_pcc7immVVOQ@mail.gmail.com/
Fixes: 21538121efe6 ("smb: client: make use of smbdirect_socket.send_io.bcredits")
Cc: stable@kernel.org
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ruikai Peng <ruikai@pwno.io>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Cc: security@kernel.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Tested-by: Ruikai Peng <ruikai@pwno.io>
---
 fs/smb/client/smbdirect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index c79304012b08..461658105013 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1551,17 +1551,25 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 
 	rc = smbd_post_send(sc, batch, request);
 	if (!rc) {
+		/*
+		 * From here request is moved to batch
+		 * and we should not free it explicitly.
+		 */
+
 		if (batch != &_batch)
 			return 0;
 
 		rc = smbd_send_batch_flush(sc, batch, true);
 		if (!rc)
 			return 0;
+
+		goto err_flush;
 	}
 
 err_dma:
 	smbd_free_send_io(request);
 
+err_flush:
 err_alloc:
 	atomic_inc(&sc->send_io.credits.count);
 	wake_up(&sc->send_io.credits.wait_queue);
-- 
2.43.0

