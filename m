Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B680FC4338F
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Aug 2021 05:24:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9711B60FD9
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Aug 2021 05:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234071AbhHQFZZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 Aug 2021 01:25:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52138 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233923AbhHQFZY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 17 Aug 2021 01:25:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629177891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GJNjvN+M3wvIRabIxvTjshrWiA86A9Y3KOBSU6fXw10=;
        b=dfIjaf2qX8gdL+qk9pz2vvoQnpHk9Da3UUg8mxOLz1GV6z5qY/IEE7wtOV0OaAx2xNMRln
        McgE2a5ZICqONKciNA1I/njQ9KOVN7hUYA3y1WgfQqAN7RSISsXOzSNURyn4WIokzjnti3
        GcNg6WtzVwiPvxUjDLVTseR2ZNmLkms=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-mMMRdtEZPp-ixa7y6zUKWg-1; Tue, 17 Aug 2021 01:24:49 -0400
X-MC-Unique: mMMRdtEZPp-ixa7y6zUKWg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79C6A801AC0;
        Tue, 17 Aug 2021 05:24:48 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-114.bne.redhat.com [10.64.54.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B69DF5C1D5;
        Tue, 17 Aug 2021 05:24:47 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 1/3] cifs: only compile in smb1ops.c if we configure CIFS_ALLOW_INSECURE_LEGACY
Date:   Tue, 17 Aug 2021 15:24:34 +1000
Message-Id: <20210817052436.1158186-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/Makefile  | 4 +++-
 fs/cifs/smb1ops.c | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index 87fcacdf3de7..96739082718d 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_CIFS) += cifs.o
 cifs-y := trace.o cifsfs.o cifssmb.o cifs_debug.o connect.o dir.o file.o \
 	  inode.o link.o misc.o netmisc.o smbencrypt.o transport.o \
 	  cifs_unicode.o nterr.o cifsencrypt.o \
-	  readdir.o ioctl.o sess.o export.o smb1ops.o unc.o winucase.o \
+	  readdir.o ioctl.o sess.o export.o unc.o winucase.o \
 	  smb2ops.o smb2maperror.o smb2transport.o \
 	  smb2misc.o smb2pdu.o smb2inode.o smb2file.o cifsacl.o fs_context.o \
 	  dns_resolve.o cifs_spnego_negtokeninit.asn1.o asn1.o
@@ -17,6 +17,8 @@ $(obj)/asn1.o: $(obj)/cifs_spnego_negtokeninit.asn1.h
 
 $(obj)/cifs_spnego_negtokeninit.asn1.o: $(obj)/cifs_spnego_negtokeninit.asn1.c $(obj)/cifs_spnego_negtokeninit.asn1.h
 
+cifs-$(CONFIG_CIFS_ALLOW_INSECURE_LEGACY) += smb1ops.o
+
 cifs-$(CONFIG_CIFS_XATTR) += xattr.o
 
 cifs-$(CONFIG_CIFS_UPCALL) += cifs_spnego.o
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 3b83839fc2c2..beb1f74e25a7 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -5,6 +5,7 @@
  *  Copyright (c) 2012, Jeff Layton <jlayton@redhat.com>
  */
 
+#include <ctype.h>
 #include <linux/pagemap.h>
 #include <linux/vfs.h>
 #include "cifsglob.h"
-- 
2.30.2

