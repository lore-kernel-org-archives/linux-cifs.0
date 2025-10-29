Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803F62D0602
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744394; cv=none; b=pVHP3ihEU6mrWH3evcCRqPIr42KeBxhjcjC1E/UUIkHYy8MaYgbpLheZpKqSi38G+IRqG5dke4dFPbgZtOhoquoObqt3RSXOmtehkiL5u68hiWA91tNFXGElSV+i5KVGyeV31urt9zUU3f+A9oTr0/pSJ27t4KRucaEX1R3I99w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744394; c=relaxed/simple;
	bh=NMrb5FZqIYPkaIccXorCJvw6B0hR84BiK8IcgKdO1k4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQ7iH9z0IbRPIYM45/46eMueQNUIcuKi4s8rNS7mfljfgWHar5sHyKLbDxzj8QlRIFz/DL2oC4NhzBPlcMS1HZ9d1ogrSM7POAN79QVzF1b1sr6tYRoxLwEAifGSH66FvuXZRUyzy4ROBGczlo1pqSrk1q7NS/0gTJvlMsghVMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=H6hHfemt; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="H6hHfemt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=vvQwpsjXEaVmWK+UXA4vYgG930Qgt1BRctVJKIjmKFk=; b=H6hHfemt5lUfdk1ccSVojXtlWw
	zjd55f0ojGnw5sNupK5JWvPKfrv8gyqmqUGZMfzwdXGWAmVKny8WrIX+KOI+vlHdQi4ssAEO6oQN7
	3ggAJAgKMcJbG7iasBTZLa95LTB+IEfMWOuCcEpQl6Yc6D0wY8b9MXwXsMK1lN5YvoIwOq6szAMI3
	ThgkqFegJyyoCAZq5oosLkT7CdP1UAcqYsiO0F5dBefU6v1lC0t8u09fO+r8HC9n7DmcZaaaEEvTm
	54dnPoE6rdYxkSIV/wWkri9wBeI8YVieq05PcODNzF3whHGLr3eLWGFcrjNOTkuYkSrmNcGGOjZ4N
	5GrrbyeqY8cobAMt3td+r4omD3tgtSDjWWAR0iJlRzVso/iYeviclPPZ2d7P1ELv3AAxzZsx9cjCQ
	Ps60Wh152DnQ9Ug0XXrmlA7lvyzlSzsz4GbacxkXUIcca7lCYY0LbBNzY7oaDF94GMcqr129O1XAu
	2F2G9u+Lc4bXdzpmD8a/hljR;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6C4-00Bbn5-2d;
	Wed, 29 Oct 2025 13:26:29 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 040/127] smb: smbdirect: introduce smbdirect_connection_request_keep_alive()
Date: Wed, 29 Oct 2025 14:20:18 +0100
Message-ID: <67f705b19b1a06a66d644477e44058a9a281266e.1761742839.git.metze@samba.org>
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

This a copy of manage_keep_alive_before_sending() in client and server,
it will replace these in future.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 .../common/smbdirect/smbdirect_connection.c   | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index da2e9ecdd98d..e2eb3c6cf0f1 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -1057,6 +1057,25 @@ static u16 smbdirect_connection_grant_recv_credits(struct smbdirect_socket *sc)
 	return new_credits;
 }
 
+__maybe_unused /* this is temporary while this file is included in orders */
+static bool smbdirect_connection_request_keep_alive(struct smbdirect_socket *sc)
+{
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
+
+	if (sc->idle.keepalive == SMBDIRECT_KEEPALIVE_PENDING) {
+		sc->idle.keepalive = SMBDIRECT_KEEPALIVE_SENT;
+		/*
+		 * Now use the keepalive timeout (instead of keepalive interval)
+		 * in order to wait for a response
+		 */
+		mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
+				 msecs_to_jiffies(sp->keepalive_timeout_msec));
+		return true;
+	}
+
+	return false;
+}
+
 __maybe_unused /* this is temporary while this file is included in orders */
 static void smbdirect_connection_send_io_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-- 
2.43.0

