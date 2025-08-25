Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD051143C61
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155163; cv=none; b=WnWyWWUe+s/Kzmo40aLq8giBu6Z5R82iv1q3hpkzC806sChka3dd8+nsFQejT3i26vYN1gLiaB9ohR5aSNpU1NYDdRIxnkyRumwFOnN9OjXcedrUF08zASek8+Ps5YLU6WjAQftVJ6q2V5kuvhdGBs41/2LlaZHBARfN1vEsxqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155163; c=relaxed/simple;
	bh=Stz9OIuOz1T9z4lAkUcXlEwbIk0FlFPvyiareOxKR64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7kaR4S2kWxp1yRAw8Ea0gaCdflXYdDUuPL4+2ZfRzjeYGlwdTITxATLjPVetrQzX0f4He6BlMFvMTaTKjDOXx8iglG4y9YoQkXchM8vCqNdzrtZ5pe9XBV6nczLlz04nGLaF6MlANp+5C+so2RAAFH+QxW04o7yi9wx8SJpARU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=p+QBGRfX; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="p+QBGRfX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=6e9j636sBIJTj88dsL6ykNeIJE4x0iMDn7Rd9dMBowk=; b=p+QBGRfXI9h/7LHZDAAbw4cRF0
	/9SDlfGY0p+IwmMEt6cCItgkxfXjSO7P+WMC1fcQW/XRUBGaYtZydvGT1BSkkdkmK+2UD3wMmbUOC
	qoubyBou95SmsXPmA6zoB8FHIb5w06itxyWzObu5YpFA8w3KXB6x2nRWbbusbFiA/9MiLnY8LBNuR
	zDijBt/22lYPLeQBPs5vLlywgnKMVJRt+WvWF1uO5CJsHDBp+mwm7wutOsUHjWakoQipZodVjeqYz
	TCRyjNpmuFDTmznrN9mnbXLH7EfSUqDl3PnKYpqZ2oWlsw/eZG/dm7pAEv9Db9IDotVkdQ+X3WBZf
	t9dGSOsqJLdnE+IrwKymqBmM6QxLWatlR+0Lap0wTw3ozfrtJBlq9gvKs/uBmX6OllNjjGPdip6r3
	aBgiYMMR8VJnEOdo7eURye4BaJs9afHrsgqAJTNIQN3BRJ034/7mYQydW2vWYsxbIJGjsdNNlIEjZ
	Tm2d3l3+CIE1nMqnC08ydTUp;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeBC-000lOD-1T;
	Mon, 25 Aug 2025 20:52:38 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 065/142] smb: client: pass struct smbdirect_socket to smbd_post_send_iter()
Date: Mon, 25 Aug 2025 22:40:26 +0200
Message-ID: <13e3904db462b7d1d29ca737331023579f1769b0.1756139607.git.metze@samba.org>
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
 fs/smb/client/smbdirect.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 782621a844f1..40d0233f41df 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -992,11 +992,10 @@ static int smbd_post_send(struct smbdirect_socket *sc,
 	return rc;
 }
 
-static int smbd_post_send_iter(struct smbd_connection *info,
+static int smbd_post_send_iter(struct smbdirect_socket *sc,
 			       struct iov_iter *iter,
 			       int *_remaining_data_length)
 {
-	struct smbdirect_socket *sc = &info->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	int i, rc;
 	int header_length;
@@ -1144,13 +1143,14 @@ static int smbd_post_send_empty(struct smbd_connection *info)
 	int remaining_data_length = 0;
 
 	sc->statistics.send_empty++;
-	return smbd_post_send_iter(info, NULL, &remaining_data_length);
+	return smbd_post_send_iter(sc, NULL, &remaining_data_length);
 }
 
 static int smbd_post_send_full_iter(struct smbd_connection *info,
 				    struct iov_iter *iter,
 				    int *_remaining_data_length)
 {
+	struct smbdirect_socket *sc = &info->socket;
 	int rc = 0;
 
 	/*
@@ -1160,7 +1160,7 @@ static int smbd_post_send_full_iter(struct smbd_connection *info,
 	 */
 
 	while (iov_iter_count(iter) > 0) {
-		rc = smbd_post_send_iter(info, iter, _remaining_data_length);
+		rc = smbd_post_send_iter(sc, iter, _remaining_data_length);
 		if (rc < 0)
 			break;
 	}
-- 
2.43.0

