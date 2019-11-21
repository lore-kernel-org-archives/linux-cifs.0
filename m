Return-Path: <SRS0=LLm2=ZN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56DD9C432C0
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Nov 2019 15:11:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AA5D206F4
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Nov 2019 15:11:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SKwGuCOG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfKUPLD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Nov 2019 10:11:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51474 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726358AbfKUPLD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Nov 2019 10:11:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574349061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=NjpIfxHgFRBYgY046me3oAg8/k1k1hVKmtcFylljr00=;
        b=SKwGuCOG1GkI4VwA2DoSLGSF/jGD4ryEP7JOqxITgl6a7DDn3Pi12kDzgg+DkTyczDvD+L
        78eSZsoGVMhN2Rqeme6bWZMccEudCnxZ5WJ2UnBgThoPTjaScfTgOAADq7iszZD/8igYQ/
        +HjDIINq8CoMHlNFG7Oim9FVwoBO3Qg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-VKzBckN9Pziwhn1bmwuOkw-1; Thu, 21 Nov 2019 10:11:00 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EA9F8018A3;
        Thu, 21 Nov 2019 15:10:59 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.76.0.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6146D537B5;
        Thu, 21 Nov 2019 15:10:57 +0000 (UTC)
From:   Kenneth D'souza <kdsouza@redhat.com>
To:     linux-cifs@vger.kernel.org
Cc:     piastryyy@gmail.com, smfrench@gmail.com, lsahlber@redhat.com
Subject: [PATCH] smb2-quota: Simplify code logic for quota entries.
Date:   Thu, 21 Nov 2019 20:40:56 +0530
Message-Id: <20191121151056.19392-1-kdsouza@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: VKzBckN9Pziwhn1bmwuOkw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch changes the program name from smb2quota to
smb2-quota and uses a simple code logic for quota entries.

Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
Signed-off-by: Ronnie Sahlberg <lsahlberg@redhat.com>
---
 smb2quota.py =3D> smb2-quota.py   | 19 +++++++------------
 smb2quota.rst =3D> smb2-quota.rst |  8 ++++----
 2 files changed, 11 insertions(+), 16 deletions(-)
 rename smb2quota.py =3D> smb2-quota.py (91%)
 rename smb2quota.rst =3D> smb2-quota.rst (89%)

diff --git a/smb2quota.py b/smb2-quota.py
similarity index 91%
rename from smb2quota.py
rename to smb2-quota.py
index 21bf4ff..6d0b8a3 100755
--- a/smb2quota.py
+++ b/smb2-quota.py
@@ -1,7 +1,7 @@
 #!/usr/bin/env python
 # coding: utf-8
 #
-# smb2quota is a cmdline tool to display quota information for the
+# smb2-quota is a cmdline tool to display quota information for the
 # Linux SMB client file system (CIFS)
 #
 # Copyright (C) Ronnie Sahlberg (lsahlberg@redhat.com) 2019
@@ -34,7 +34,7 @@ ENDC =3D '\033[m'   # Rest to defaults
=20
 def usage():
     print("Usage: %s [-h] <options> <filename>" % sys.argv[0])
-    print("Try 'smb2quota -h' for more information")
+    print("Try 'smb2-quota -h' for more information")
     sys.exit()
=20
=20
@@ -120,18 +120,13 @@ class QuotaEntry:
 class Quota:
     def __init__(self, buf, flag):
         self.quota =3D []
-        s =3D struct.unpack_from('<I', buf, 0)[0]
-        while s:
-            qe =3D QuotaEntry(buf[0:s], flag)
+        while buf:
+            qe =3D QuotaEntry(buf, flag)
             self.quota.append(qe)
-            buf =3D buf[s:]
-            a =3D s
             s =3D struct.unpack_from('<I', buf, 0)[0]
             if s =3D=3D 0:
-                s =3D a   # Use the last value of s and process it.
-                qe =3D QuotaEntry(buf[0:s], flag)
-                self.quota.append(qe)
                 break
+            buf =3D buf[s:]
=20
     def __str__(self):
         s =3D ''
@@ -158,7 +153,7 @@ def parser_check(path, flag):
         fcntl.ioctl(f, CIFS_QUERY_INFO, buf, 1)
         os.close(f)
         if flag =3D=3D 0:
-            print(BBOLD + " %-7s | %-7s | %-7s | %-7s | %-12s | %s " + END=
C) % (titleused, titlelim, titlethr, titlepercent, titlestatus, titlesid)
+            print((BBOLD + " %-7s | %-7s | %-7s | %-7s | %-12s | %s " + EN=
DC) % (titleused, titlelim, titlethr, titlepercent, titlestatus, titlesid))
         q =3D Quota(buf[24:24 + struct.unpack_from('<I', buf, 16)[0]], fla=
g)
         print(q)
     except IOError as reason:
@@ -171,7 +166,7 @@ def main():
     if len(sys.argv) < 2:
         usage()
=20
-    parser =3D argparse.ArgumentParser(description=3D"Please specify an ac=
tion to perform.", prog=3D"smb2quota")
+    parser =3D argparse.ArgumentParser(description=3D"Please specify an ac=
tion to perform.", prog=3D"smb2-quota")
     parser.add_argument("-t", "--tabular", action=3D"store_true", help=3D"=
print quota information in tabular format")
     parser.add_argument("-c", "--csv",  action=3D"store_true", help=3D"pri=
nt quota information in csv format")
     parser.add_argument("-l", "--list", action=3D"store_true", help=3D"pri=
nt quota information in list format")
diff --git a/smb2quota.rst b/smb2-quota.rst
similarity index 89%
rename from smb2quota.rst
rename to smb2-quota.rst
index 24caca8..508b874 100644
--- a/smb2quota.rst
+++ b/smb2-quota.rst
@@ -1,5 +1,5 @@
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
-smb2quota
+smb2-quota
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
 --------------------------------------------------------------------------=
---------------------------
@@ -11,7 +11,7 @@ Userspace helper to display quota information for the Lin=
ux SMB client file syst
 SYNOPSIS
 ********
=20
-  smb2quota [-h] {options} {file system object}
+  smb2-quota [-h] {options} {file system object}
=20
 ***********
 DESCRIPTION
@@ -19,7 +19,7 @@ DESCRIPTION
=20
 This tool is part of the cifs-utils suite.
=20
-`smb2quota` is a userspace helper program for the Linux SMB
+`smb2-quota` is a userspace helper program for the Linux SMB
 client file system (CIFS).
=20
 This tool works by making an CIFS_QUERY_INFO IOCTL call to the Linux
@@ -49,7 +49,7 @@ SID,Amount Used,Quota Limit,Warning Level
 NOTES
 *****
=20
-Kernel support for smb2quota requires the CIFS_QUERY_INFO
+Kernel support for smb2-quota requires the CIFS_QUERY_INFO
 IOCTL which was initially introduced in the 4.20 kernel and is only
 implemented for mount points using SMB2 or above (see mount.cifs(8)
 `vers` option).
--=20
2.21.0

