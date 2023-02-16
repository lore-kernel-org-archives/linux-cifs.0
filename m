Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 147F1C64EC4
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Feb 2023 18:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjBPSnA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Feb 2023 13:43:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjBPSm7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Feb 2023 13:42:59 -0500
X-Greylist: delayed 555 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 16 Feb 2023 10:42:57 PST
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD712005C
        for <linux-cifs@vger.kernel.org>; Thu, 16 Feb 2023 10:42:57 -0800 (PST)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1676572418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KUihj16f+Rl0+EPBbj+6wYxYUlXR+HnEh4sSX2ydQaY=;
        b=WmSnFmve3jX6+ifiOQ/fV0AyxLradgno1F9LSQ3BSTMWd+0WS4XzIoz951WdyR1+jSMzeu
        Z+G/vfb90OAAVWNN0J/DsFjk3OWcFkUapFergbdtAsvQRTCABcRvVt1bu1mMMHiSpliDG6
        Qov4dMVtnj62SOtJRm79oqDbtfC75/QOuTlu1rcZzmBuySEbtR/uYPvSDEKagU/CEaWLyc
        iDdQnIwPJ8EjGWJg3HP5Bv5+huYDnccyfX51IeYNlc63np8HdRDHvtdHKjyPnNGd0HDnoy
        1a6Q7ae8VwTXDqdXW3tlWrOb75tPIqHnCnQP9IUu3gR88vNBYZkJeNWwxJMK8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1676572418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KUihj16f+Rl0+EPBbj+6wYxYUlXR+HnEh4sSX2ydQaY=;
        b=HKOK8l+7wRBDxSwqHfDsAhUjs7odnymY9V0lVZZK/W/cpKmNPQuSrmBLaTWmyiMQ+xvnAB
        r7170JaNXgSr5tSW6ILiCakf2/GdJfhGUVbigbz0a9f3efclvL5gbk3e3olXivfZU08E7C
        rRrg+6QNX1dhmmzoPj19pz+P7h3GPk2b2Wca0jEFZDiJ6pBlrQg69oY6vGF57o5VQIgJ1F
        Syv8jR5FqRxMc1azQTTQH+M/k/vyyYM841LEHghjbjByaTRK8aeuskxKccX5mq1PZnjfPU
        PCvfGgNzJyTlxpB3HjcQWhxTxHNlbwgIW4+CZbuzi31qFx4Uh3h9F1Fpa86ujw==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1676572418; a=rsa-sha256;
        cv=none;
        b=rVjJFmFJHzKbCbnKI44u70qvrAjw9KTENWIVWYdo2heUOSs4zLl4Fk+HS276qGW0+cjvOg
        dAauudSoTNsbkswh/GzSAiAx7MroB3knTD78jJv6DgqvDeK+2b7LX5QnMQ9gbdTvhBjUeW
        RQQvZl/+W4rOQQ5VwGeeO6LbKb4cuMYh6NYDhvQVcLyzcqkBXJUCNUpy0B4ULUmeEfJios
        MfRd6fTn+z3SkahJo8kr/rNT6XQWNdZJ55AY6jLTKRwmOnv1kQjV1RUG8Tei3TFFAVKR1q
        vMe4671wU59+MuwfyfY5NI08qRTukcgW5Nb/Eca0KmD5zsYYRBbRC231TSX+bQ==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH] cifs: fix mount on old smb servers
Date:   Thu, 16 Feb 2023 15:33:22 -0300
Message-Id: <20230216183322@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4C2F2573E50
X-Rspamd-Server: srv0
X-Spamd-Result: default: False [-2.60 / 15.00];
        BAYES_HAM(-3.00)[100.00%];
        R_MISSING_CHARSET(0.50)[];
        MIME_GOOD(-0.10)[text/plain];
        FREEMAIL_TO(0.00)[gmail.com];
        RCVD_COUNT_ZERO(0.00)[0];
        MIME_TRACE(0.00)[0:+];
        FROM_EQ_ENVFROM(0.00)[];
        ASN(0.00)[asn:28573, ipnet:187.181.252.0/22, country:BR];
        FREEMAIL_ENVRCPT(0.00)[gmail.com];
        DKIM_SIGNED(0.00)[manguebit.com:s=dkim];
        ARC_SIGNED(0.00)[manguebit.com:s=dkim:i=1];
        FROM_HAS_DN(0.00)[];
        MID_RHS_MATCH_FROM(0.00)[];
        RCPT_COUNT_THREE(0.00)[3];
        TO_MATCH_ENVRCPT_ALL(0.00)[];
        TO_DN_SOME(0.00)[];
        ARC_NA(0.00)[]
X-Rspamd-Action: no action
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The client was sending rfc1002 session request packet with a wrong
length field set, therefore failing to mount shares against old SMB
servers over port 139.

Fix this by calculating the correct length as specified in rfc1002.

Fixes: d7173623bf0b ("cifs: use ALIGN() and round_up() macros")
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/cifs/connect.c | 100 ++++++++++++++++++----------------------------
 1 file changed, 38 insertions(+), 62 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b2a04b4e89a5..af49ae53aaf4 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2843,72 +2843,48 @@ ip_rfc1001_connect(struct TCP_Server_Info *server)
 	 * negprot - BB check reconnection in case where second
 	 * sessinit is sent but no second negprot
 	 */
-	struct rfc1002_session_packet *ses_init_buf;
-	unsigned int req_noscope_len;
-	struct smb_hdr *smb_buf;
+	struct rfc1002_session_packet req = {};
+	struct smb_hdr *smb_buf = (struct smb_hdr *)&req;
+	unsigned int len;
+
+	req.trailer.session_req.called_len = sizeof(req.trailer.session_req.called_name);
+
+	if (server->server_RFC1001_name[0] != 0)
+		rfc1002mangle(req.trailer.session_req.called_name,
+			      server->server_RFC1001_name,
+			      RFC1001_NAME_LEN_WITH_NULL);
+	else
+		rfc1002mangle(req.trailer.session_req.called_name,
+			      DEFAULT_CIFS_CALLED_NAME,
+			      RFC1001_NAME_LEN_WITH_NULL);
+
+	req.trailer.session_req.calling_len = sizeof(req.trailer.session_req.calling_name);
+
+	/* calling name ends in null (byte 16) from old smb convention */
+	if (server->workstation_RFC1001_name[0] != 0)
+		rfc1002mangle(req.trailer.session_req.calling_name,
+			      server->workstation_RFC1001_name,
+			      RFC1001_NAME_LEN_WITH_NULL);
+	else
+		rfc1002mangle(req.trailer.session_req.calling_name,
+			      "LINUX_CIFS_CLNT",
+			      RFC1001_NAME_LEN_WITH_NULL);
 
-	ses_init_buf = kzalloc(sizeof(struct rfc1002_session_packet),
-			       GFP_KERNEL);
-
-	if (ses_init_buf) {
-		ses_init_buf->trailer.session_req.called_len = 32;
-
-		if (server->server_RFC1001_name[0] != 0)
-			rfc1002mangle(ses_init_buf->trailer.
-				      session_req.called_name,
-				      server->server_RFC1001_name,
-				      RFC1001_NAME_LEN_WITH_NULL);
-		else
-			rfc1002mangle(ses_init_buf->trailer.
-				      session_req.called_name,
-				      DEFAULT_CIFS_CALLED_NAME,
-				      RFC1001_NAME_LEN_WITH_NULL);
-
-		ses_init_buf->trailer.session_req.calling_len = 32;
-
-		/*
-		 * calling name ends in null (byte 16) from old smb
-		 * convention.
-		 */
-		if (server->workstation_RFC1001_name[0] != 0)
-			rfc1002mangle(ses_init_buf->trailer.
-				      session_req.calling_name,
-				      server->workstation_RFC1001_name,
-				      RFC1001_NAME_LEN_WITH_NULL);
-		else
-			rfc1002mangle(ses_init_buf->trailer.
-				      session_req.calling_name,
-				      "LINUX_CIFS_CLNT",
-				      RFC1001_NAME_LEN_WITH_NULL);
-
-		ses_init_buf->trailer.session_req.scope1 = 0;
-		ses_init_buf->trailer.session_req.scope2 = 0;
-		smb_buf = (struct smb_hdr *)ses_init_buf;
-
-		/* sizeof RFC1002_SESSION_REQUEST with no scopes */
-		req_noscope_len = sizeof(struct rfc1002_session_packet) - 2;
+	/*
+	 * As per rfc1002, @len must be the number of bytes that follows the
+	 * length field of a rfc1002 session request payload.
+	 */
+	len = sizeof(req) - offsetof(struct rfc1002_session_packet, trailer.session_req);
 
-		/* == cpu_to_be32(0x81000044) */
-		smb_buf->smb_buf_length =
-			cpu_to_be32((RFC1002_SESSION_REQUEST << 24) | req_noscope_len);
-		rc = smb_send(server, smb_buf, 0x44);
-		kfree(ses_init_buf);
-		/*
-		 * RFC1001 layer in at least one server
-		 * requires very short break before negprot
-		 * presumably because not expecting negprot
-		 * to follow so fast.  This is a simple
-		 * solution that works without
-		 * complicating the code and causes no
-		 * significant slowing down on mount
-		 * for everyone else
-		 */
-		usleep_range(1000, 2000);
-	}
+	smb_buf->smb_buf_length = cpu_to_be32((RFC1002_SESSION_REQUEST << 24) | len);
+	rc = smb_send(server, smb_buf, len);
 	/*
-	 * else the negprot may still work without this
-	 * even though malloc failed
+	 * RFC1001 layer in at least one server requires very short break before
+	 * negprot presumably because not expecting negprot to follow so fast.
+	 * This is a simple solution that works without complicating the code
+	 * and causes no significant slowing down on mount for everyone else
 	 */
+	usleep_range(1000, 2000);
 
 	return rc;
 }
-- 
2.39.1

