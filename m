Return-Path: <SRS0=eFbg=AO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D97DC433DF
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Jul 2020 09:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63D7320826
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Jul 2020 09:29:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WhcJxmGm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgGCJ3j (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Jul 2020 05:29:39 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30433 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725796AbgGCJ3i (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 3 Jul 2020 05:29:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593768577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lQpWf5TX9QVHOrdyvWflfSMJMbleJhB7ByB8NJFPiFI=;
        b=WhcJxmGmGq/vRwuvvN9AtU5hV7i51TVoGYzLHWBJU0rgwZxxtIMqJTRmDVNCWG9aHFGTba
        bDtetPOxUS6FBtddvYBiKTF4es3pF7EGWct75UqhAVoPhD9J1ynZy+qW23zF7R2QOCtgam
        dS0WrNxTFAk05GSDNfugeUTLwCqdYdk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-ZFmql5YhMtCnN-Hbw8fzhQ-1; Fri, 03 Jul 2020 05:29:35 -0400
X-MC-Unique: ZFmql5YhMtCnN-Hbw8fzhQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB3F218A8221;
        Fri,  3 Jul 2020 09:29:34 +0000 (UTC)
Received: from idlethread.redhat.com (ovpn-114-21.ams2.redhat.com [10.36.114.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5C3C73FF7;
        Fri,  3 Jul 2020 09:29:33 +0000 (UTC)
From:   Roberto Bergantinos Corpas <rbergant@redhat.com>
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org
Subject: [PATCH] cifs : handle ERRBaduid for SMB1
Date:   Fri,  3 Jul 2020 11:29:32 +0200
Message-Id: <20200703092932.18967-1-rbergant@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If server returns ERRBaduid but does not reset transport connection,
we'll keep sending command with a non-valid UID for the server as long
as transport is healthy, without actually recovering. This have been
observed on the field.

This patch adds ERRBaduid handling so that we set CifsNeedReconnect.

map_and_check_smb_error() can be modified to extend use cases.

Signed-off-by: Roberto Bergantinos Corpas <rbergant@redhat.com>
---
 fs/cifs/cifsproto.h |  1 +
 fs/cifs/netmisc.c   | 27 +++++++++++++++++++++++++++
 fs/cifs/transport.c |  2 +-
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 948bf3474db1..d72cf20ab048 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -149,6 +149,7 @@ extern int decode_negTokenInit(unsigned char *security_blob, int length,
 extern int cifs_convert_address(struct sockaddr *dst, const char *src, int len);
 extern void cifs_set_port(struct sockaddr *addr, const unsigned short int port);
 extern int map_smb_to_linux_error(char *buf, bool logErr);
+extern int map_and_check_smb_error(struct mid_q_entry *mid, bool logErr);
 extern void header_assemble(struct smb_hdr *, char /* command */ ,
 			    const struct cifs_tcon *, int /* length of
 			    fixed section (word count) in two byte units */);
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 9b41436fb8db..ae9679a27181 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -881,6 +881,33 @@ map_smb_to_linux_error(char *buf, bool logErr)
 	return rc;
 }
 
+int
+map_and_check_smb_error(struct mid_q_entry *mid, bool logErr)
+{
+	int rc;
+	struct smb_hdr *smb = (struct smb_hdr *)mid->resp_buf;
+
+	rc = map_smb_to_linux_error((char *)smb, logErr);
+	if (rc == -EACCES && !(smb->Flags2 & SMBFLG2_ERR_STATUS)) {
+		/* possible ERRBaduid */
+		__u8 class = smb->Status.DosError.ErrorClass;
+		__u16 code = le16_to_cpu(smb->Status.DosError.Error);
+
+		/* switch can be used to handle different errors */
+		if (class == ERRSRV && code == ERRbaduid) {
+			cifs_dbg(FYI, "Server returned 0x%x, reconnecting session...\n",
+				code);
+			spin_lock(&GlobalMid_Lock);
+			if (mid->server->tcpStatus != CifsExiting)
+				mid->server->tcpStatus = CifsNeedReconnect;
+			spin_unlock(&GlobalMid_Lock);
+		}
+	}
+
+	return rc;
+}
+
+
 /*
  * calculate the size of the SMB message based on the fixed header
  * portion, the number of word parameters and the data portion of the message
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index cb3ee916f527..e8dbd6b55559 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -935,7 +935,7 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 	}
 
 	/* BB special case reconnect tid and uid here? */
-	return map_smb_to_linux_error(mid->resp_buf, log_error);
+	return map_and_check_smb_error(mid, log_error);
 }
 
 struct mid_q_entry *
-- 
2.21.0

