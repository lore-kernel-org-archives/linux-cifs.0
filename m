Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61E915ECD7
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094097; cv=none; b=GYmCLUcGaw4BBI3F5M5V+rlKEpeGkjvBjZOHDhEcF+Z7Tdvprv2GYGB+gPMDnuwhKQDj4V+zI4RAseh8RVZudqrl9R/PPQDGDaGsLtL21XObqigdfD8OCU8gjYldubj+YvoOtV96rIMnq8uoDxGhpw5fdN/vxuHTq48IGbFW4bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094097; c=relaxed/simple;
	bh=wWFV1+zTqpvwFgM+afAAnsEk+cAX14ceuLIhrFgkucE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6MSLySmBLwn0K/nvzgOvMTlg7BeOwACsB9iySSK3wOpGUGpQcQhZuC+WWuyI9tN7sgbvv/lDIwV6NGDhAcHQXXKri7b01VF/jq53kCQ3X7w3PS+QjDS8yEahu0c7qy38X4yCkME44hgB7H/4CsLq2xt7DRTiI9JdGbq+aRKwes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=stXH3Lki; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="stXH3Lki"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=pMTdTq7HOGqXyfkiKU+KEqSuKmskUIzm0AJFeVodh94=; b=stXH3LkiKf0TDmQOj0+GuUUIvQ
	Hy9qbE7bYqLUo1X9A1XSL11ubLGrOzfpQQDMCXr57le/lrqoBu3nsiEk1+aS8msRyQFyiJwSqgf4S
	6nLMryCOBY+oWHfhun9PF+q45kDBPKQEDbzQNofDxJV58XuSo79G7eAzemVEZT39Tvfyn2V9v/EYv
	9hQnrdyapNKEa2D6gvYIhUiZLKIkCp5eRwg/+Sh7IgKRaxyjiIbS8GmGdNZUjyYRfOq5NfOhEF7kr
	snK5iXDbp7sCEBaYKekGrpQSfWL6Q9ERghnwKWAOfXj/e8l4BuafvHkevWc5ZWIjcU+kCTdb0RGSP
	/iYGPsWURybrF2BYdxeYjxN1oI1CmOMHdQbnfJX8Q5xGRX9vTziQrBgZfY9fG47w1fSnYw9nT8asw
	gWpBvKic1FViyMrxQEE5XndW9YqmRJjiVEWvxk0EMkjawaZ+yPHxN1JM2dYBxmN8c1j2ogyoPepqv
	hdNaan1pqbh4xRmCEkhsEaLC;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxOa-00FdfR-16;
	Tue, 25 Nov 2025 18:04:08 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 069/145] smb: client: make use of smbdirect_connection_idle_timer_work()
Date: Tue, 25 Nov 2025 18:55:15 +0100
Message-ID: <f4601fa50f70f1fb558f488bcc061a7afcdb9824.1764091285.git.metze@samba.org>
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

This is basically a copy of idle_connection_timer().

Note smbdirect_socket_prepare_create() already calls INIT_DELAYED_WORK().

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 39d94bea2bbe..d2359d6b18ba 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1342,35 +1342,6 @@ static void send_immediate_empty_message(struct work_struct *work)
 	smbd_post_send_empty(sc);
 }
 
-/* Implement idle connection timer [MS-SMBD] 3.1.6.2 */
-static void idle_connection_timer(struct work_struct *work)
-{
-	struct smbdirect_socket *sc =
-		container_of(work, struct smbdirect_socket, idle.timer_work.work);
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-
-	if (sc->idle.keepalive != SMBDIRECT_KEEPALIVE_NONE) {
-		log_keep_alive(ERR,
-			"error status sc->idle.keepalive=%d\n",
-			sc->idle.keepalive);
-		smbdirect_socket_schedule_cleanup(sc, -ETIMEDOUT);
-		return;
-	}
-
-	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
-		return;
-
-	/*
-	 * Now use the keepalive timeout (instead of keepalive interval)
-	 * in order to wait for a response
-	 */
-	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_PENDING;
-	mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
-			 msecs_to_jiffies(sp->keepalive_timeout_msec));
-	log_keep_alive(INFO, "schedule send of empty idle message\n");
-	queue_work(sc->workqueue, &sc->idle.immediate_work);
-}
-
 /*
  * Destroy the transport and related RDMA and memory resources
  * Need to go through all the pending counters and make sure on one is using
@@ -1774,7 +1745,6 @@ static struct smbd_connection *_smbd_get_connection(
 	}
 
 	INIT_WORK(&sc->idle.immediate_work, send_immediate_empty_message);
-	INIT_DELAYED_WORK(&sc->idle.timer_work, idle_connection_timer);
 	/*
 	 * start with the negotiate timeout and SMBDIRECT_KEEPALIVE_PENDING
 	 * so that the timer will cause a disconnect.
-- 
2.43.0

