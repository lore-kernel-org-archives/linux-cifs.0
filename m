Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A7ECC433ED
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Apr 2021 10:02:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47F2D610FB
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Apr 2021 10:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbhDHKCo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Apr 2021 06:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbhDHKCn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Apr 2021 06:02:43 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7873DC061760
        for <linux-cifs@vger.kernel.org>; Thu,  8 Apr 2021 03:02:32 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d124so1400761pfa.13
        for <linux-cifs@vger.kernel.org>; Thu, 08 Apr 2021 03:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Dw/mCQpPHedRgnIBZEoWcG9ZuY/vsppZf9dMKka3+yo=;
        b=RCjY8vuKTWmf3KOzz0s5FmH0QVP5h75UE2YnqvVgojvQDaEdwVtAHnNrtRftJLE6xV
         QcU8ik8fTclIaFr6GVOnFf9WyOivw3S0abwNO2RwGkoVnvK0oAl0ClYSmF34/IvLF95R
         1zjz9mLLhtuZQbnCd0uXLVGxNa5hd/jv7KBvFIOi7t3VsOka4zAMnsn83mBdKDAyRjnV
         bKMzRaRl4+VZh6k8Kex/TNLTZt5wgFpxBM0umffJhXxzst3G6WDm0DPsoHXb5E4GbhrS
         Xfty8D/YFS+exKRwkcCpmQ4WOvkO+FKQ2xAm/XjdB9ZRk2SRGDyGZZChM5nEU94FWis3
         27Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Dw/mCQpPHedRgnIBZEoWcG9ZuY/vsppZf9dMKka3+yo=;
        b=tfZKd4jfIXkcEWptr4dStYiAo0uFDkHhSQZ26vER+hQ8tVoQRIu7VvZXRqZN7b0foR
         Aj7ojQ13uBI0u+dpjX9GmXMge/4paUsVDGW4vwM7VmbKi5jiKMOPp+ngPnyi6F+NsUOI
         /i9E0JoQaZ5WQcAWgH1c7gibv+ouyzFlOjeU//jbTaMUirCT5XcWSwWB9W+sequJuZQH
         30+9sQtEh0MSummvnveolsLqzP2SuBzxiRSacB0CtvQRhvrXjImBc9MawV0cgZcR4UXg
         5z9Pptpux2MIizhXxJA+bH3f6jV2EmK/XhpEx3vsLdtq7gwPbP/xDvKpD4bP6t+3JmdB
         xtnQ==
X-Gm-Message-State: AOAM533RYa5W2sguXNCYs50cao+Z/C273OakDIsYPc/+0yHkp+MVzHDK
        QuvmAoXKZ7CDPvCZzcE43rQIKHnrhwcpc/Zt9vIx8MLa+pN0ew==
X-Google-Smtp-Source: ABdhPJwuL+NjZnOZ39z90c/OHW23/RaGIhVxGGPZSMe0er1tomgs0E0fb5aPu+wKdM0n2MbuT/ItEe1fbjw/XdYOZ8U=
X-Received: by 2002:a62:fb14:0:b029:22e:e189:c6b1 with SMTP id
 x20-20020a62fb140000b029022ee189c6b1mr6925139pfm.31.1617876152076; Thu, 08
 Apr 2021 03:02:32 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?Si4gUGFibG8gR29uesOhbGV6?= <disablez@gmail.com>
Date:   Thu, 8 Apr 2021 12:02:20 +0200
Message-ID: <CAMM8u5miX1JbzWMG3WLZLZeD1_ZL=6nufWJaT7ensA+yPo5zeQ@mail.gmail.com>
Subject: [PATCH] smbinfo: Add command for displaying alternate data streams
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

This patch adds a new command to smbinfo which retrieves and displays
the list of alternate data streams for a file.

Signed-off-by: Juan Pablo Gonz=C3=A1lez <disablez@gmail.com>
---
 smbinfo     | 41 +++++++++++++++++++++++++++++++++++++++++
 smbinfo.rst |  2 ++
 2 files changed, 43 insertions(+)

diff --git a/smbinfo b/smbinfo
index 9752963..55c44e1 100755
--- a/smbinfo
+++ b/smbinfo
@@ -253,6 +253,10 @@ def main():
     sap.add_argument("file")
     sap.set_defaults(func=3Dcmd_filestandardinfo)

+    sap =3D subp.add_parser("filestreaminfo", help=3D"Prints
FileStreamInfo for a cifs file")
+    sap.add_argument("file")
+    sap.set_defaults(func=3Dcmd_filestreaminfo)
+
     sap =3D subp.add_parser("fsctl-getobjid", help=3D"Prints the objectid
of the file and GUID of the underlying volume.")
     sap.add_argument("file")
     sap.set_defaults(func=3Dcmd_fsctl_getobjid)
@@ -753,7 +757,44 @@ def cmd_secdesc(args):
               print(ace)
               off_dacl +=3D ace.size

+def cmd_filestreaminfo(args):
+    qi =3D QueryInfoStruct(info_type=3D0x1, file_info_class=3D22,
input_buffer_length=3DINPUT_BUFFER_LENGTH)
+    try:
+        fd =3D os.open(args.file, os.O_RDONLY)
+        info =3D os.fstat(fd)
+        buf =3D qi.ioctl(fd)
+    except Exception as e:
+        print("syscall failed: %s"%e)
+        return False

+    print_filestreaminfo(buf)
+
+def print_filestreaminfo(buf):
+    offset =3D 0
+
+    while offset < len(buf):
+
+        next_offset =3D struct.unpack_from('<I', buf, offset + 0)[0]
+        name_length =3D struct.unpack_from('<I', buf, offset + 4)[0]
+        if (name_length > 0):
+            stream_size =3D struct.unpack_from('<q', buf, offset + 8)[0]
+            stream_alloc_size =3D struct.unpack_from('<q', buf, offset + 1=
6)[0]
+            stream_utf16le_name =3D struct.unpack_from('< %ss'%
name_length, buf, offset + 24)[0]
+            stream_name =3D stream_utf16le_name.decode("utf-16le")
+            if (offset > 0):
+                print()
+            if (stream_name=3D=3D"::$DATA"):
+                print("Name: %s"% stream_name)
+            else:
+                print("Name: %s"% stream_name[stream_name.find(":") +
1 : stream_name.rfind(':$DATA')])
+            print("Size: %d bytes"% stream_size)
+            print("Allocation size: %d bytes "% stream_alloc_size)
+
+        if (next_offset =3D=3D 0):
+            break
+
+        offset+=3Dnext_offset
+
 class KeyDebugInfoStruct:
     def __init__(self):
         self.suid =3D bytearray()
diff --git a/smbinfo.rst b/smbinfo.rst
index 7413849..1acf3c4 100644
--- a/smbinfo.rst
+++ b/smbinfo.rst
@@ -65,6 +65,8 @@ COMMAND

 `filestandardinfo`: Prints the FileStandardInformation class

+`filestreaminfo`: Prints the FileStreamInformation class
+
 `fsctl-getobjid`: Prints the ObjectID

 `getcompression`: Prints the compression setting for the file.
--=20
2.13.3.windows.1
