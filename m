Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C936CC4338F
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Aug 2021 19:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95F43610CF
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Aug 2021 19:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233644AbhHMT51 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 13 Aug 2021 15:57:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34653 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230440AbhHMT50 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 13 Aug 2021 15:57:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628884619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1dlqH81QyEveO9tVNVzv8OSWtAJG3aqT3lKYrOwnOSE=;
        b=YunoSgBAWeVNoKOCkPwUXbIgePgQeKJwIH3mcSS2E+KiqGcNUyB+fnIWGJPtfYc1GKV5iP
        +nBE/UncdrrMGkJ4h3792B1U15b27JHi/H2r8k4Ojw6qYwz+pBVJXEfgY+CpFVV0G+R9Cv
        MR/s4DwAQMfMmm3TLR0PVOsBYI8/YbU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-xd4L1zrGM1CiVrxTGnvzuw-1; Fri, 13 Aug 2021 15:56:57 -0400
X-MC-Unique: xd4L1zrGM1CiVrxTGnvzuw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A67081008060;
        Fri, 13 Aug 2021 19:56:56 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-114.bne.redhat.com [10.64.54.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDF0710074E1;
        Fri, 13 Aug 2021 19:56:55 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 1/3] cifs: only compile in smb1ops.c if we configure CIFS_ALLOW_INSECURE_LEGACY
Date:   Sat, 14 Aug 2021 05:56:42 +1000
Message-Id: <20210813195644.937810-2-lsahlber@redhat.com>
In-Reply-To: <20210813195644.937810-1-lsahlber@redhat.com>
References: <20210813195644.937810-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

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
-- 
2.30.2

