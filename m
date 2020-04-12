Return-Path: <SRS0=YkwU=54=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC67CC2BB85
	for <linux-cifs@archiver.kernel.org>; Sun, 12 Apr 2020 06:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C6F020709
	for <linux-cifs@archiver.kernel.org>; Sun, 12 Apr 2020 06:09:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zr3t7oNf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgDLGJj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 12 Apr 2020 02:09:39 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33965 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725263AbgDLGJi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 12 Apr 2020 02:09:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586671778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=QcpSZP7NpmF1miYqSO3BH6PxZTslJeNRsQ7VsRdxyiA=;
        b=Zr3t7oNfVZyAXlZpUmhhfmMm5kvMUBQg6y1S1jVgmO5ZHoJBysJUT8+FSP1j+6otpXsI4R
        K5htid2PAwShxvIccTVMMi3fqhKsHVWEyzucSpMjPlg3Y7iRz4nHGWkAzfbb7yfY5OSGd5
        FwYR7aVuMZeS6iFRsaSMNpc+FDuKLSI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-DnZue9egNquycWa2G4l5-A-1; Sun, 12 Apr 2020 02:09:35 -0400
X-MC-Unique: DnZue9egNquycWa2G4l5-A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95779800D5B
        for <linux-cifs@vger.kernel.org>; Sun, 12 Apr 2020 06:09:34 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-101.bne.redhat.com [10.64.54.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 292D811B25D;
        Sun, 12 Apr 2020 06:09:33 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: dump the session id and keys also for SMB2 sessions
Date:   Sun, 12 Apr 2020 16:09:26 +1000
Message-Id: <20200412060926.30733-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We already dump these keys for SMB3, lets also dump it for SMB2
sessions so that we can use the session key in wireshark to check and validate
that the signatures are correct.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2pdu.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 28c0be5e69b7..3ddb0fe6889a 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1541,6 +1541,21 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct SMB2_sess_data *sess_data)
 	}
 
 	rc = SMB2_sess_establish_session(sess_data);
+#ifdef CONFIG_CIFS_DEBUG_DUMP_KEYS
+	if (ses->server->dialect < SMB30_PROT_ID) {
+		cifs_dbg(VFS, "%s: dumping generated SMB2 session keys\n", __func__);
+		/*
+		 * The session id is opaque in terms of endianness, so we can't
+		 * print it as a long long. we dump it as we got it on the wire
+		 */
+		cifs_dbg(VFS, "Session Id    %*ph\n", (int)sizeof(ses->Suid),
+			 &ses->Suid);
+		cifs_dbg(VFS, "Session Key   %*ph\n",
+			 SMB2_NTLMV2_SESSKEY_SIZE, ses->auth_key.response);
+		cifs_dbg(VFS, "Signing Key   %*ph\n",
+			 SMB3_SIGN_KEY_SIZE, ses->auth_key.response);
+	}
+#endif
 out:
 	kfree(ntlmssp_blob);
 	SMB2_sess_free_buffer(sess_data);
-- 
2.13.6

