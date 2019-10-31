Return-Path: <SRS0=po33=YY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 641EACA9EC3
	for <linux-cifs@archiver.kernel.org>; Thu, 31 Oct 2019 03:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37DBC2086D
	for <linux-cifs@archiver.kernel.org>; Thu, 31 Oct 2019 03:55:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d/ndIimS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfJaDz0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 30 Oct 2019 23:55:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44841 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726524AbfJaDz0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 30 Oct 2019 23:55:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572494125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=NVfgJW3nDXWOYa6XY+/47PTAbUS5h/LHk6lmSiLVxdI=;
        b=d/ndIimSHswm+OhJwSVC2jWUl0Y+DSsBBi0rK2AEa2tkjLLXfyUEX4/K7tiN04jKFFm/79
        2taoPrTdnjPczyWupZ6pULwvJyXPtSD/Sp3fgRNXit4NwkxEC3bmI1Nd9H1GKnaKFsQvkI
        2ozg/p4A0Jn8MHn0g7OQURfYzncBxBY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-x2hsDETEM_SJxD4b7CQOxA-1; Wed, 30 Oct 2019 23:55:23 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E57501800D55
        for <linux-cifs@vger.kernel.org>; Thu, 31 Oct 2019 03:55:22 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-99.bne.redhat.com [10.64.54.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7AE411001B07;
        Thu, 31 Oct 2019 03:55:22 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: don't use 'pre:' for MODULE_SOFTDEP
Date:   Thu, 31 Oct 2019 13:55:14 +1000
Message-Id: <20191031035514.20871-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: x2hsDETEM_SJxD4b7CQOxA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

It can cause
to fail with
modprobe: FATAL: Module <module> is builtin.

RHBZ: 1767094

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsfs.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index f8e201c45ccb..a578699ce63c 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1677,17 +1677,17 @@ MODULE_DESCRIPTION
 =09("VFS to access SMB3 servers e.g. Samba, Macs, Azure and Windows (and "
 =09"also older servers complying with the SNIA CIFS Specification)");
 MODULE_VERSION(CIFS_VERSION);
-MODULE_SOFTDEP("pre: ecb");
-MODULE_SOFTDEP("pre: hmac");
-MODULE_SOFTDEP("pre: md4");
-MODULE_SOFTDEP("pre: md5");
-MODULE_SOFTDEP("pre: nls");
-MODULE_SOFTDEP("pre: aes");
-MODULE_SOFTDEP("pre: cmac");
-MODULE_SOFTDEP("pre: sha256");
-MODULE_SOFTDEP("pre: sha512");
-MODULE_SOFTDEP("pre: aead2");
-MODULE_SOFTDEP("pre: ccm");
-MODULE_SOFTDEP("pre: gcm");
+MODULE_SOFTDEP("ecb");
+MODULE_SOFTDEP("hmac");
+MODULE_SOFTDEP("md4");
+MODULE_SOFTDEP("md5");
+MODULE_SOFTDEP("nls");
+MODULE_SOFTDEP("aes");
+MODULE_SOFTDEP("cmac");
+MODULE_SOFTDEP("sha256");
+MODULE_SOFTDEP("sha512");
+MODULE_SOFTDEP("aead2");
+MODULE_SOFTDEP("ccm");
+MODULE_SOFTDEP("gcm");
 module_init(init_cifs)
 module_exit(exit_cifs)
--=20
2.13.6

