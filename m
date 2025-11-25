Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C99732D0FE
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094222; cv=none; b=P3b5WyZEurBni8UT1BEsCEHIFk8a3zYuExWvpAVAcPMNTP8OKkMegrVXcD2Tx20ir4rrE3ufvivJNAc4xU1UA/JK5ETDCGpOoOTlh66p1yxeq99TUKSTOHlIt6ZwEMqR9MoaugAQF5Jbn8OWTUHLklh2Jf55FCuTJYPlCW4HFXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094222; c=relaxed/simple;
	bh=nz1PHzLF3uiaZnm7b0mlFp/PmUwMsnaVWwnnDRu8O5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIE2PGra0cEx4maz5J5igs3sLYnuYYHNzh3Qo2U1gsIkKCs+ST036fgqiq7kB6vIqUqzn27Vi7ZdXU5ZVRAvYtKF9snBK35ZhRwfuppPr9MJ/I01PIL1sIkxlEIWZcD5H0XVDKTm0UVilxcz9zyP+GMG/r/038SntHduoUeoImg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=huoMOTOH; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="huoMOTOH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=rTIFRPGHp14RU6S8wz0iQq0S/05PDnkVL9vegdas8e0=; b=huoMOTOHifA0tP5kFqRBGmuemJ
	evLbMiiKcg+WMBOAGieU5k+K30auvTOBTUVpbZdz05s03dWHd4mFjrIE03PsLFvuxy5ks5Tjm20Qa
	DczEMfDGh8lDaeaY4VaewvYr9Bv3TanzagxwFt6+xwXObmd+MQKmrvQa0+QG2KGgSyE+ZWd7Dh/U9
	XoKhLrtfpPXTC+7n8ytJ/BmfMGK2lmcrJbJCCLpVr22A46hYVDLuHdqYcl0/fdrybhx1VWhycFdOY
	W6TPVKCQl2x6aIqWVoXIh34Cqv0nNriDjZVcKUHKcdXXnx+IavryxscZKovxpf6rBIGrMdEgxgk37
	6/69P58CvDBK+WT7WSZ83zAezEeCPJmD2su6tOWjkR7+OOtUEaedVSJLyg7zeCH4uMGvcp9ZhVNft
	BY8KxZeotBRWprUPLHiILgqyqYWTVI9IFxXOlWfA7Od3an3ZnfetuFGlDpaLPsJFqu23YzkEC3tPb
	3iFddz9elimAUzIokuZ9LryX;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxSg-00Fe2v-11;
	Tue, 25 Nov 2025 18:08:23 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 089/145] smb: client: let smbd_post_send_full_iter() get remaining_length and return data_length
Date: Tue, 25 Nov 2025 18:55:35 +0100
Message-ID: <71859743ab698275ed41babafa2ecf1d6a88014f.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will simplify further changes in order to share
more common code in future.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index a924d1aa4a27..1f7b31cb15af 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -948,9 +948,9 @@ static void smbd_post_send_empty(struct smbdirect_socket *sc)
 
 static int smbd_post_send_full_iter(struct smbdirect_socket *sc,
 				    struct iov_iter *iter,
-				    int *_remaining_data_length)
+				    u32 remaining_data_length)
 {
-	int rc = 0;
+	int bytes = 0;
 
 	/*
 	 * smbd_post_send_iter() respects the
@@ -959,14 +959,16 @@ static int smbd_post_send_full_iter(struct smbdirect_socket *sc,
 	 */
 
 	while (iov_iter_count(iter) > 0) {
-		rc = smbd_post_send_iter(sc, iter, *_remaining_data_length);
+		int rc;
+
+		rc = smbd_post_send_iter(sc, iter, remaining_data_length);
 		if (rc < 0)
-			break;
-		*_remaining_data_length -= rc;
-		rc = 0;
+			return rc;
+		remaining_data_length -= rc;
+		bytes += rc;
 	}
 
-	return rc;
+	return bytes;
 }
 
 /* Perform SMBD negotiate according to [MS-SMBD] 3.1.5.2 */
@@ -1366,16 +1368,20 @@ int smbd_send(struct TCP_Server_Info *server,
 			klen += rqst->rq_iov[i].iov_len;
 		iov_iter_kvec(&iter, ITER_SOURCE, rqst->rq_iov, rqst->rq_nvec, klen);
 
-		rc = smbd_post_send_full_iter(sc, &iter, &remaining_data_length);
+		rc = smbd_post_send_full_iter(sc, &iter, remaining_data_length);
 		if (rc < 0)
 			break;
+		remaining_data_length -= rc;
+		rc = 0;
 
 		if (iov_iter_count(&rqst->rq_iter) > 0) {
 			/* And then the data pages if there are any */
 			rc = smbd_post_send_full_iter(sc, &rqst->rq_iter,
-						      &remaining_data_length);
+						      remaining_data_length);
 			if (rc < 0)
 				break;
+			remaining_data_length -= rc;
+			rc = 0;
 		}
 
 	} while (++rqst_idx < num_rqst);
-- 
2.43.0

