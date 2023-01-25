Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 607FFC54E94
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Jan 2023 14:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbjAYODV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 Jan 2023 09:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234845AbjAYODU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 25 Jan 2023 09:03:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0324A20B
        for <linux-cifs@vger.kernel.org>; Wed, 25 Jan 2023 06:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674655352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/s8s9yVyMeHLEk3rF5Tk87NjhFDSUAL5CDTE3FqhZzo=;
        b=Avx1IT/zIlh1Af7wdBtqBaE4z1v/OtyMU964dULePzxT7kb+Cd4a/qTSJsrDCIA/OBaVEQ
        I5x/DQJRQnyZz1T4Uy+WmlZlD26mt5Li1SJM1A32asdWrOry7KKOoZZa5xTfxfg9zPNhYy
        tEb0HvaZsn7pPaLrv7xbrX3HWjgEdMg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-C-ANrCIKM5-f9g9R1vChAw-1; Wed, 25 Jan 2023 09:02:16 -0500
X-MC-Unique: C-ANrCIKM5-f9g9R1vChAw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB339280558C;
        Wed, 25 Jan 2023 14:02:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F5A81121333;
        Wed, 25 Jan 2023 14:02:14 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <1130899.1674582538@warthog.procyon.org.uk>
References: <1130899.1674582538@warthog.procyon.org.uk>
To:     Steve French <sfrench@samba.org>
Cc:     dhowells@redhat.com, Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Stefan Metzmacher <metze@samba.org>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH] cifs: Fix oops due to uncleared server->smbd_conn in reconnect
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2132363.1674655333.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 25 Jan 2023 14:02:13 +0000
Message-ID: <2132364.1674655333@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

That attached patch stops the kernel from oopsing, but it still tries
endlessly to send with softRoCE.  I'm having better luck with softIWarp - =
with
some other patches, I can run generic/001 to completion with that transpor=
t.

David

---
commit 820cb3802c6a73c54e2e215b674eb5870fd5d0e5
Author: David Howells <dhowells@redhat.com>
Date:   Wed Jan 25 12:42:07 2023 +0000

    cifs: Fix oops due to uncleared server->smbd_conn in reconnect
    =

    In smbd_destroy(), clear the server->smbd_conn pointer after freeing t=
he
    smbd_connection struct that it points to so that reconnection doesn't =
get
    confused.
    =

    Fixes: 8ef130f9ec27 ("CIFS: SMBD: Implement function to destroy a SMB =
Direct connection")
    Signed-off-by: David Howells <dhowells@redhat.com>
    cc: Long Li <longli@microsoft.com>
    cc: Steve French <smfrench@gmail.com>
    cc: Pavel Shilovsky <pshilov@microsoft.com>
    cc: Ronnie Sahlberg <lsahlber@redhat.com>
    cc: linux-cifs@vger.kernel.org

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 90789aaa6567..8c816b25ce7c 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1405,6 +1405,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	destroy_workqueue(info->workqueue);
 	log_rdma_event(INFO,  "rdma session destroyed\n");
 	kfree(info);
+	server->smbd_conn =3D NULL;
 }
 =

 /*

