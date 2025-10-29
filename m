Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9AD28A704
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744645; cv=none; b=JM0u4RXhD2z9MPckGyIT0rJbFawCl1y5r6DSSyvbPnjWHO9IjLkLqm2/6F5Np0G5Jbr/r0EI3prg+iNGf33ocwlzhyw6JR8oeY4Jk7CQiY00fPFBisyBABfMimvL8EMhTJNkVwHdUugBcgQT7YRsR1/WH9I0iwwfZCZCWp+rQ+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744645; c=relaxed/simple;
	bh=VRqZG77LKlcpl8C0oU6jhtbyxu6SSOjCdnW3I7aSFSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1o1CjljXF9ivK1QE+KpHW4p6IAJRkVp7CwiccqgmNOHVHMebFiZO2VeZl8AhRWKUKaXwko300rmE2WnCKjPI8AqP6libpLh6Ay9dMDRTqoaVdVSJc2b5WotsDerEHHsIbDtY61zNpNSUZPGIZ2UjG7gkW65n5fPLHBP/st/eM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=sinxfE14; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="sinxfE14"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=vLkbr5VcMkb0ltbdDMO/cI6tvAWpoiD+KbE3jF+z8/o=; b=sinxfE14RV0z+z7kj3JKpRK275
	iKtlBCnxzV6OTv99ddrvfVWHHw6NIFV8Hzov3WMKUnjDbyJNRHwjhPHJvS8IySWdB8Yf4+8jTtzOB
	5y+gWZfZ7DYgddiLcU2hSMbdS0AIXnesAgD+XLGK7pRoNV0GaWH75WRoCz9VpEHWn2VrVrp8BqPSo
	2U2lz1viCyGZ/J3wy6T8/uBKiWxcTNNbS+Xt4x2mNmkhvIhJU8K6hyVxrORb2TI0m9PftRjrCWqu+
	TCijk9AiH7Ybdea+4imHIYT5n0/QAFJNNdYE0+jeg1pGKHC8AbK+6LEMkEFm9uCatR3uBSnblf1HF
	oZ0RYvglavczL+8WjzdT9+luA8Bf/1UWTxS4IXHeSHu4OokNrhxSihidQzYSmlcb+qkOOrK6rjSkl
	eK/1IXaFcGhtFJcICKo8m6faTkHiEta/xDIIpOKBbw0bGP5V9s31JV3oZW9CqosIxS6ynxhKttSyh
	zjx6U/lBh08EzUQk9MUag+NW;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6G6-00BcQ2-2b;
	Wed, 29 Oct 2025 13:30:39 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 082/127] smb: client: change smbd_post_send_empty() to void return
Date: Wed, 29 Oct 2025 14:21:00 +0100
Message-ID: <203777eac2f4d21a916399701987c9af42542704.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The caller doesn't check, so we better call
smbdirect_connection_schedule_disconnect() to handle the error.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index ef2f957d0e86..b94fa3bec5c5 100644
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
@@ -929,12 +927,17 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
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
+		smbdirect_connection_schedule_disconnect(sc, ret);
+	}
 }
 
 static int smbd_post_send_full_iter(struct smbdirect_socket *sc,
-- 
2.43.0

