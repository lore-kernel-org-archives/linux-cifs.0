Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0349E33A037
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744639; cv=none; b=iu7fdqMFDrkvMpnTB1vpSBw/QSvQBOp/x06CPoohiHve1FjsIETzIBmi9YjgXXrvPChZkMnX4KW6n9BV2Dd5OtgzuxR5jD353jQjui4jxGqdUd/wyRmId/RAjUkkobzDBpZ60fdq2SM2CyXMgd4xhbhcEEPF6eijg3/hWHuyvfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744639; c=relaxed/simple;
	bh=XJxHiFxZqUsFjGm/l8RnKhSVXu0AOylhOCFO6h/nKYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/3cUZqPIUXlu04/Dc+PZbcGs9V/ElLbXks+3nfckR+mOI7vwMV1VmwHPkK5kdizMPZXsQAkFsVsQwfXx82VuWI9bhEErCfeKfa+0FafVU3yGdxnlhAw8rrnUXapH78OufRzKkAX5VC3mTgfF+6Ur7kj5tvcwSDcKEL1v//4UVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=0ZWI5TMI; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="0ZWI5TMI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=9oPTajjIPyMPzpj6sIvxhn1o/qqu1bykEtaz0IzpG3Q=; b=0ZWI5TMIdaEOhh4T/Q/jN7HdAX
	685FsheR5swiKLFweiIqADctMD4Lu6XqsDZZ+M8rb0xgr2Q59pCxsW8bHnjIEtU69P/VU+VXQlr27
	kfxItDICmNvzw5SQy2NONCPYG2FleNbYjBv9ElIc0TQr3mGVSHV2xftPMionwHPnoNYnv2isWur5z
	GN+8TTck2WhUpTLBibP+yDKmpW1Qk0VYgcG5a+/76ohgprnPyOFnxS2yy55GGXAOyA8o4FudB9y7j
	w8uAZvLkdaX7+PqFP+cZnlVLrhuv/nYUwkmMQlkKkQov6r/eIg2PbaXRC3KUwLF+WcowEU12zxqUb
	D+JlcgQGd4M1B5eg4QmhVVi9HyJcqF/rePtC4J+/ma5FFSVtk81+0+LjxESJrijfn7WMI9wrHV3Cw
	saFlSMsHvnOJr2rE9D1tqEYmBpWy4/+eeTk2TYGjdWoEH7yVZizHZnhcZUMR5whhm6WG88nry2VEL
	MfbADRAPn5hX66sLv/Fra5Ea;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Fy-00BcPB-2e;
	Wed, 29 Oct 2025 13:30:31 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 081/127] smb: client: make use of smbdirect_connection_request_keep_alive()
Date: Wed, 29 Oct 2025 14:20:59 +0100
Message-ID: <25e7fb24c28ce2945d9eb4e74c65e8e347ac6d04.1761742839.git.metze@samba.org>
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

This will help to share more common code soon.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 28 +---------------------------
 1 file changed, 1 insertion(+), 27 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index cb1e7dee9be7..ef2f957d0e86 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -730,32 +730,6 @@ static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
 	return rc;
 }
 
-/*
- * Check if we need to send a KEEP_ALIVE message
- * The idle connection timer triggers a KEEP_ALIVE message when expires
- * SMBDIRECT_FLAG_RESPONSE_REQUESTED is set in the message flag to have peer send
- * back a response.
- * return value:
- * 1 if SMBDIRECT_FLAG_RESPONSE_REQUESTED needs to be set
- * 0: otherwise
- */
-static int manage_keep_alive_before_sending(struct smbdirect_socket *sc)
-{
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-
-	if (sc->idle.keepalive == SMBDIRECT_KEEPALIVE_PENDING) {
-		sc->idle.keepalive = SMBDIRECT_KEEPALIVE_SENT;
-		/*
-		 * Now use the keepalive timeout (instead of keepalive interval)
-		 * in order to wait for a response
-		 */
-		mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
-				 msecs_to_jiffies(sp->keepalive_timeout_msec));
-		return 1;
-	}
-	return 0;
-}
-
 /* Post the send request */
 static int smbd_post_send(struct smbdirect_socket *sc,
 		struct smbdirect_send_io *request)
@@ -898,7 +872,7 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 	packet->credits_granted = cpu_to_le16(new_credits);
 
 	packet->flags = 0;
-	if (manage_keep_alive_before_sending(sc))
+	if (smbdirect_connection_request_keep_alive(sc))
 		packet->flags |= cpu_to_le16(SMBDIRECT_FLAG_RESPONSE_REQUESTED);
 
 	packet->reserved = 0;
-- 
2.43.0

