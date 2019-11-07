Return-Path: <SRS0=qFu0=Y7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E7E7C5DF60
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Nov 2019 07:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FAA521D6C
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Nov 2019 07:00:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UEh83+rj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfKGHAu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Nov 2019 02:00:50 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55872 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726016AbfKGHAu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 7 Nov 2019 02:00:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573110049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=C/vX3k12w7zV+JgaGraaX4iGfY7Q3y3AgmA3l7N5L9w=;
        b=UEh83+rjAt58BmFDANyx1ObvXhiAV+f3y2Ny0SPn1PUySidsr4lwzEWZVgtFn6MD0UqqJn
        9PFPbxMTtZggVnltTE+aHBb9KeigNGQX24J/okSmrhpXAqB4xaJMlKEGJ2N/qt9MoeVzxi
        YKKCflPvPTwL4E+guAW1+PFTcfULY9Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-u7nZm_17NDeqCAD6SnuF0Q-1; Thu, 07 Nov 2019 02:00:47 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F539107ACC3
        for <linux-cifs@vger.kernel.org>; Thu,  7 Nov 2019 07:00:47 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-20.bne.redhat.com [10.64.54.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 992E31000328;
        Thu,  7 Nov 2019 07:00:46 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: close the shared root handle on tree disconnect
Date:   Thu,  7 Nov 2019 17:00:38 +1000
Message-Id: <20191107070038.6029-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: u7nZm_17NDeqCAD6SnuF0Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2pdu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 05149862aea4..acb70f67efc9 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1807,6 +1807,8 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *t=
con)
 =09if ((tcon->need_reconnect) || (tcon->ses->need_reconnect))
 =09=09return 0;
=20
+=09close_shroot(&tcon->crfid);
+
 =09rc =3D smb2_plain_req_init(SMB2_TREE_DISCONNECT, tcon, (void **) &req,
 =09=09=09     &total_len);
 =09if (rc)
--=20
2.13.6

