Return-Path: <SRS0=3kj9=ZF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C09C43215
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Nov 2019 17:01:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E10C206D7
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Nov 2019 17:01:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MXMd9xA2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbfKMRBg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Nov 2019 12:01:36 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29737 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726195AbfKMRBg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 13 Nov 2019 12:01:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573664495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=H58pRbcmI7yOqwI1XRhs6dzljYSSojBMh1mx9wvEIzc=;
        b=MXMd9xA2zrdfMyea2Z8dioua9gsPBxFnRBjkaBMIzb7k3PtyzMFSbtRK5VG9UBW37zJwOh
        SPsa2so6WVFGARqC5FxjilM24VtGhHxZaPJGMLHBSx+Msw6A6XT9sgpzpbtAQxL+hoHoUs
        8mp2aVOKvD1WSlUPxpS7HU2z1ODx50Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-cCkpSdLxOX69Aatpv6nQNA-1; Wed, 13 Nov 2019 12:01:32 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 666238E7EF3;
        Wed, 13 Nov 2019 17:01:31 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.76.0.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A853F60BD7;
        Wed, 13 Nov 2019 17:01:29 +0000 (UTC)
From:   Kenneth D'souza <kdsouza@redhat.com>
To:     linux-cifs@vger.kernel.org
Cc:     piastryyy@gmail.com, smfrench@gmail.com, lsahlber@redhat.com
Subject: [PATCH] Add support for smb3 alias/fstype in mount.cifs.c
Date:   Wed, 13 Nov 2019 22:31:26 +0530
Message-Id: <20191113170126.23372-1-kdsouza@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: cCkpSdLxOX69Aatpv6nQNA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

As we will slowly move towards smb3 filesystem,
supporting through "mount -t smb3" is important.

Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
---
 Makefile.am    |  4 ++++
 mount.cifs.c   |  8 +++++++-
 mount.cifs.rst | 12 +++++++++---
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 8291b99..1af2573 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -111,3 +111,7 @@ CLEANFILES +=3D $(rst_man_pages)
 endif
=20
 SUBDIRS =3D contrib
+
+install-exec-hook:
+=09(cd $(ROOTSBINDIR) && ln -sf mount.cifs mount.smb3)
+=09(cd $(man8dir) && ln -sf mount.cifs.8 mount.smb3.8)
diff --git a/mount.cifs.c b/mount.cifs.c
index 6935fe1..0ed9d0a 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -192,7 +192,7 @@ struct parsed_mount_info {
 };
=20
 static const char *thisprogram;
-static const char *cifs_fstype =3D "cifs";
+static const char *cifs_fstype;
=20
 static int parse_unc(const char *unc_name, struct parsed_mount_info *parse=
d_info);
=20
@@ -1986,6 +1986,12 @@ int main(int argc, char **argv)
 =09if (thisprogram =3D=3D NULL)
 =09=09thisprogram =3D "mount.cifs";
=20
+=09if(strcmp(thisprogram, "mount.cifs") =3D=3D 0)
+               cifs_fstype =3D "cifs";
+
+        if(strcmp(thisprogram, "mount.smb3") =3D=3D 0)
+              cifs_fstype =3D "smb3";
+
 =09/* allocate parsed_info as shared anonymous memory range */
 =09parsed_info =3D mmap((void *)0, sizeof(*parsed_info), PROT_READ | PROT_=
WRITE,
 =09=09=09   MAP_ANONYMOUS | MAP_SHARED, -1, 0);
diff --git a/mount.cifs.rst b/mount.cifs.rst
index ee5086c..67ec629 100644
--- a/mount.cifs.rst
+++ b/mount.cifs.rst
@@ -1,6 +1,6 @@
-=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
-mount.cifs
-=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+mount.cifs mount.smb3
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
 --------------------------------------------------
 mount using the Common Internet File System (CIFS)
@@ -23,6 +23,12 @@ protocol and is supported by most Windows servers, Azure=
 (cloud storage),
 Macs and many other commercial servers and Network Attached Storage
 appliances as well as by the popular Open Source server Samba.
=20
+``mount.smb3`` mounts only SMB3 filesystem. It is usually invoked
+indirectly by the mount(8) command when using the "-t smb3" option.
+The ``smb3`` filesystem type was added in kernel-4.18 and above.
+It works in a similar fashion as mount.cifs except it passes filesystem
+type as smb3.
+
 The mount.cifs utility attaches the UNC name (exported network
 resource) specified as service (using ``//server/share`` syntax, where
 "server" is the server name or IP address and "share" is the name of
--=20
2.21.0

