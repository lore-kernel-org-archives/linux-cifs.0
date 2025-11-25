Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E82A32D42A
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094221; cv=none; b=uoi5l1z/50kwf1prd+c7M0M3+JcmPOzizRAsOfyglS20NFaxNSckwJoGIC6KrL/wewAbzDmkixwTy7kwaZyzEoX38LfmwH/WvtugUfXtRUSrHNpsxMrrqACMAOhJ5kOvKMFDf0ueXObOgfXTbVoI6vgrcZtO1P9FzcHiPpc7N1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094221; c=relaxed/simple;
	bh=AtmwQzOv+fYdq4ZOR+Kv9fGXjVnaTJdm1IbGVvHzlYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCq1pJ0eDcUQa8EC5nKo58S0FKQB5sCQgR4xBkD6ZZG1tO+Zjgao7l1SvXs7oHtpLOas+OWqoo8rju8NxaC2sGFKaStwFjRASEQqSa9YJIAItWvRyof0LXF6bi5LPOvGfvsrTbLX4zdB8TKr2eV76IPhLm0Of70Uts3nClY9YVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=zl+sH/lE; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="zl+sH/lE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=UJ606WCdffDfHpUhfMTmCdhyhR2iTTQXwNiaSGYzpVI=; b=zl+sH/lEAhFTT7b5CxSFtqChkw
	x+rDNE+Z0bo0z21x0k0VDL5dWkJg3yIhZxY4hu8ae3lWhb5WcIH8x3jHyGMbRDFWuyggZPgkYA2zS
	x5sIHA5K/p60LUlS6YQkh/ahcYzFF9D51l5hkZCOB3BGxjVHxC7BeLkqoRix5xRKbIx7o2O5cqjAS
	xRRv/OJJZvl3TYJXKf9ex+FGiHNxUUtqRlwGCLLnT7ZL2fYRKy3x/tkhBBg56JuGY/O8hT2ACYSTu
	16uhErex6JTRq21unc3WsMRSIkfG699JlUF1Zy8mM1DRziVg04CRpHRULNonQ3beRGI/vbnKeJOCw
	7cmExVlPSRxcn7UGqz6y9kUCHEVDGtCd8Lhewoi/EDfxm4GihUBQzU/2XN3E4Vcfz0NETM5XbKw7Y
	pX1ZwfyGRVGJ3SCJBjo+wJhC//ipbDzYcJUESErgP8wT66WqEdWm4D8q1pRjTJFHbhdB3hwjTRIfm
	y7hOE4qM2Pq80/K5f7DmQA7c;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxSD-00Fe0v-1I;
	Tue, 25 Nov 2025 18:07:53 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 087/145] smb: client: change smbd_post_send_empty() to void return
Date: Tue, 25 Nov 2025 18:55:33 +0100
Message-ID: <e4a3efe1810c0d9c5c647209742b4eeb0912111a.1764091285.git.metze@samba.org>
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

The caller doesn't check, so we better call
smbdirect_socket_schedule_cleanup() to handle the error.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 42f85dd42e7b..bc8c3e3f705f 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -23,8 +23,6 @@ const struct smbdirect_socket_parameters *smbd_get_parameters(struct smbd_connec
 	return &sc->parameters;
 }
 
-static int smbd_post_send_empty(struct smbdirect_socket *sc);
-
 /* Port numbers for SMBD transport */
 #define SMB_PORT	445
 #define SMBD_PORT	5445
@@ -930,12 +928,17 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
  * Empty message is used to extend credits to peer to for keep live
  * while there is no upper layer payload to send at the time
  */
-static int smbd_post_send_empty(struct smbdirect_socket *sc)
+static void smbd_post_send_empty(struct smbdirect_socket *sc)
 {
 	int remaining_data_length = 0;
+	int ret;
 
 	sc->statistics.send_empty++;
-	return smbd_post_send_iter(sc, NULL, &remaining_data_length);
+	ret = smbd_post_send_iter(sc, NULL, &remaining_data_length);
+	if (ret < 0) {
+		log_rdma_send(ERR, "smbd_post_send_iter failed ret=%d\n", ret);
+		smbdirect_socket_schedule_cleanup(sc, ret);
+	}
 }
 
 static int smbd_post_send_full_iter(struct smbdirect_socket *sc,
-- 
2.43.0

