Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8047289805
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155135; cv=none; b=SO9JSHrqyjpRmY52fv/vbZjv2kURBMwe5j9/2Sfn1gI0ViUJlYbcJo1yAhnpjOkKQLSWttHS05M08/Hzs50fAMZ9ISc+aB3WS0v0lmTUCOaldgJ3nWWqiry4ODwJiRG6MoRRLfoYAHvriSqzsYyp+1riddupOtxyXcJQ0fD0JSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155135; c=relaxed/simple;
	bh=Z6776y3xFpYevRb/nQ1PafPljChrVkpBfSPj6lTjj+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3S8QSbNyS07hqC+Atzu5s90nHfk8qDxCF4+26Ty5GOlzVK1iYLg/MUTG+sfC1C+aLi5030MwYYw4s/0GgEB7EBShUmfpueyVLsaVyiarFJ/aNPlk1k3mxFs0jBX1NgMaBkj3wBnstJZNUbeHWDCb8eJG/Qh9rqAs5lAymlYAGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=V7pI+9T0; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="V7pI+9T0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=FjoGrQht5h2TF66GmiqpfDnI5PpQeVAM4GxgwJ+f0DM=; b=V7pI+9T00moFd4KLNFJCVtOR2W
	VGw3erfDpJeY7zpJuEOl5hnVl6Drr83fXv/75AnsSveKlkDIdvrLuCvE+CCOPjWiDeV00azC6HjsM
	M8qT6lUOyv88tPefItjDVEVX7gVteOTITjqckxsE4IXe4W84jCKe37BG8pNqiSJBVZoithPqFkPOe
	q2nTFUcIMooUt+isIi9Z6QYdmO/kqxMx5wDjMO/kDCvEbyT4yApfSWKNcvvkg8HXEuBTOyXUDePlY
	Dl3z3+azKaYi6Fc/1nHZBEf0M/LYUQ3r6HgExxFTrNn2HJTZu8h6Kmd6KZmWZH4seGYN/nMhCKOQj
	Pg5QR7jeURXYJAFQJAumpIznbZu/FT7ibsJpYGbS3X/b6laHp3y2z6UYKuD4AqwpvSgYKseSDgGOY
	P+bRHziIREgqVN/GGcto1hufq4j1tB7vgLoksQgEHoadlf8UxnBh5eWntUDk64GM+FfQft+iM699g
	UMFN+kTNpHM1AjlGmMU5RngB;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeAk-000lIB-0z;
	Mon, 25 Aug 2025 20:52:11 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 062/142] smb: client: pass struct smbdirect_socket to manage_credits_prior_sending()
Date: Mon, 25 Aug 2025 22:40:23 +0200
Message-ID: <6366a1ef2ac5101a15b1e413bd5b7fc3d9cba617.1756139607.git.metze@samba.org>
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
index e00a70125ca8..148ba5449b66 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -911,9 +911,8 @@ static int smbd_post_send_negotiate_req(struct smbd_connection *info)
  * buffer as possible, and extend the receive credits to remote peer
  * return value: the new credtis being granted.
  */
-static int manage_credits_prior_sending(struct smbd_connection *info)
+static int manage_credits_prior_sending(struct smbdirect_socket *sc)
 {
-	struct smbdirect_socket *sc = &info->socket;
 	int new_credits;
 
 	if (atomic_read(&sc->recv_io.credits.count) >= sc->recv_io.credits.target)
@@ -1064,7 +1063,7 @@ static int smbd_post_send_iter(struct smbd_connection *info,
 	packet = smbdirect_send_io_payload(request);
 	packet->credits_requested = cpu_to_le16(sp->send_credit_target);
 
-	new_credits = manage_credits_prior_sending(info);
+	new_credits = manage_credits_prior_sending(sc);
 	atomic_add(new_credits, &sc->recv_io.credits.count);
 	packet->credits_granted = cpu_to_le16(new_credits);
 
-- 
2.43.0

