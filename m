Return-Path: <SRS0=XmFd=2K=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA3AC43603
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Dec 2019 00:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77D5424672
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Dec 2019 00:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfLTA7F (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 19 Dec 2019 19:59:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48041 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726998AbfLTA7F (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 19 Dec 2019 19:59:05 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-Cho6Wm_RMju_IBW3U_YTNw-1; Thu, 19 Dec 2019 19:59:02 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A44A800D48
        for <linux-cifs@vger.kernel.org>; Fri, 20 Dec 2019 00:59:01 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-93.bne.redhat.com [10.64.54.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E0A97A5EF;
        Fri, 20 Dec 2019 00:59:00 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] smbinfo: remove invalid arguments to ioctl method
Date:   Fri, 20 Dec 2019 10:58:48 +1000
Message-Id: <20191220005848.22327-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: Cho6Wm_RMju_IBW3U_YTNw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 smbinfo | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/smbinfo b/smbinfo
index 1be82c7..ee774d3 100755
--- a/smbinfo
+++ b/smbinfo
@@ -443,7 +443,7 @@ def cmd_filefsfullsizeinfo(args):
     qi =3D QueryInfoStruct(info_type=3D0x2, file_info_class=3D7, input_buf=
fer_length=3D32)
     try:
         fd =3D os.open(args.file, os.O_RDONLY)
-        total, caller_avail, actual_avail, sec_per_unit, byte_per_sec =3D =
qi.ioctl(fd, CIFS_QUERY_INFO, '<QQQII')
+        total, caller_avail, actual_avail, sec_per_unit, byte_per_sec =3D =
qi.ioctl(fd, '<QQQII')
     except Exception as e:
         print("syscall failed: %s"%e)
         return False
@@ -540,7 +540,7 @@ def cmd_getcompression(args):
     qi =3D QueryInfoStruct(info_type=3D0x9003c, flags=3DPASSTHRU_FSCTL, in=
put_buffer_length=3D2)
     try:
         fd =3D os.open(args.file, os.O_RDONLY)
-        ctype =3D qi.ioctl(fd, CIFS_QUERY_INFO, '<H')[0]
+        ctype =3D qi.ioctl(fd, '<H')[0]
     except Exception as e:
         print("syscall failed: %s"%e)
         return False
--=20
2.13.6

