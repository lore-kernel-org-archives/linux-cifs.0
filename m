Return-Path: <SRS0=3kj9=ZF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08DBEC43331
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Nov 2019 03:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1BAC222BD
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Nov 2019 03:32:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bVkAcfD7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfKMDcj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Nov 2019 22:32:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49202 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727100AbfKMDcj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Nov 2019 22:32:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573615957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0GgLGlhVUr8JyvjUc3dkR2kUhwJ1KHTKL3/98GiR1Pg=;
        b=bVkAcfD7jKB43ss9L5SgHnCDO6G05cozhEC9dG7gTX0lHCtaCylKybktHHGiYAlrDNaaQd
        2KheMk/7Aj+eFCAWcIaDbnGhzxUSsDh8yionSLzw2Lb9JFQJya6MLBGcnsb2MUcVR+FCCa
        CvmAnkSLvyQ9ph0/lLwWYriFZMEzldM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-XJesvqixPHqsAaVappVjVA-1; Tue, 12 Nov 2019 22:32:34 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A92B801E6A;
        Wed, 13 Nov 2019 03:32:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 621FF1B42A;
        Wed, 13 Nov 2019 03:32:33 +0000 (UTC)
Received: from zmail25.collab.prod.int.phx2.redhat.com (zmail25.collab.prod.int.phx2.redhat.com [10.5.83.31])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 59F164BB5C;
        Wed, 13 Nov 2019 03:32:33 +0000 (UTC)
Date:   Tue, 12 Nov 2019 22:32:33 -0500 (EST)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Message-ID: <1128615593.11430327.1573615953153.JavaMail.zimbra@redhat.com>
In-Reply-To: <20191113011635.3511-1-pshilov@microsoft.com>
References: <20191113011635.3511-1-pshilov@microsoft.com>
Subject: Re: [PATCH] CIFS: Respect O_SYNC and O_DIRECT flags during
 reconnect
MIME-Version: 1.0
X-Originating-IP: [10.64.54.39, 10.4.195.19]
Thread-Topic: CIFS: Respect O_SYNC and O_DIRECT flags during reconnect
Thread-Index: IlQrsEFLbsnTgAPy2QsHLjD4CMT0Fg==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: XJesvqixPHqsAaVappVjVA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>


----- Original Message -----
From: "Pavel Shilovsky" <piastryyy@gmail.com>
To: linux-cifs@vger.kernel.org, smfrench@gmail.com
Sent: Wednesday, 13 November, 2019 11:16:35 AM
Subject: [PATCH] CIFS: Respect O_SYNC and O_DIRECT flags during reconnect

Currently the client translates O_SYNC and O_DIRECT flags
into corresponding SMB create options when openning a file.
The problem is that on reconnect when the file is being
re-opened the client doesn't set those flags and it causes
a server to reject re-open requests because create options
don't match. The latter means that any subsequent system
call against that open file fail until a share is re-mounted.

Fix this by properly setting SMB create options when
re-openning files after reconnects.

Fixes: 1013e760d10e6: ("SMB3: Don't ignore O_SYNC/O_DSYNC and O_DIRECT flag=
s")
Cc: Stable <stable@vger.kernel.org>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/file.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index b6f544bc6c73..89617bb058ae 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -721,6 +721,13 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_=
flush)
 =09if (backup_cred(cifs_sb))
 =09=09create_options |=3D CREATE_OPEN_BACKUP_INTENT;
=20
+=09/* O_SYNC also has bit for O_DSYNC so following check picks up either *=
/
+=09if (cfile->f_flags & O_SYNC)
+=09=09create_options |=3D CREATE_WRITE_THROUGH;
+
+=09if (cfile->f_flags & O_DIRECT)
+=09=09create_options |=3D CREATE_NO_BUFFER;
+
 =09if (server->ops->get_lease_key)
 =09=09server->ops->get_lease_key(inode, &cfile->fid);
=20
--=20
2.17.1

