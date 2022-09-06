Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FE14ECAAD3
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Sep 2022 01:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiIFB6n (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 5 Sep 2022 21:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiIFB6m (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 5 Sep 2022 21:58:42 -0400
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EF629CA3
        for <linux-cifs@vger.kernel.org>; Mon,  5 Sep 2022 18:58:41 -0700 (PDT)
Received: by mail-pj1-f41.google.com with SMTP id fv3so3686516pjb.0
        for <linux-cifs@vger.kernel.org>; Mon, 05 Sep 2022 18:58:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=yh8X5n1Pli+zBDVKfiLOSEhFnCS3X0AWhw8OaCxSqZo=;
        b=jkgjA2tBja0SS3G0Z0gP9WP+4987D4Q/iKfak1yvrX2nkEPIFD/kzDbIAsBjl1Aera
         NqJRo/FucyUmDVD+CG1dVz+RdncjHkyoXj6aS1h4vVqSrcPvfxghV4e3T75F/QBdxzzO
         r3r8VygVTvZlxRg5ltnSAH7ES9pKE6d+3pPtuMJKhutLlGWq5RQOgXbdmXl3vcOU2Krf
         vDqNWhDB8FGtcb2R3FJ+r2E61R8JqTDS8Tt/wvcbApwXV9FgONmbYFpXIKEVYhAOkE7l
         Byrd5J3fxq3vso+NIteJoqWGAkOpqXFhDUTcXKxWQDXtIjMfWq1wZFx9960sx/+GgKUM
         qEBQ==
X-Gm-Message-State: ACgBeo1yobojOATRRrKQlKox2YsgkN/BEgYZdsLK575KMJN/eYJh9EPE
        gpyfq7P7pxORv7+pdJ7n/jSqCMAqdj0=
X-Google-Smtp-Source: AA6agR5j4qUjT8LhjkrCW3hERY6NhqG03xTRL2O6R7gtJlrcD9hURK3u27J8CSSgISPcS93E3gGK2g==
X-Received: by 2002:a17:90b:4b8b:b0:1fb:2e2c:c88d with SMTP id lr11-20020a17090b4b8b00b001fb2e2cc88dmr22181651pjb.86.1662429520582;
        Mon, 05 Sep 2022 18:58:40 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id k5-20020a17090a514500b001fb3aba374dsm11083525pjm.31.2022.09.05.18.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 18:58:39 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        tom@talpey.com, atteh.mailbox@gmail.com,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2] ksmbd: update documentation
Date:   Tue,  6 Sep 2022 10:58:23 +0900
Message-Id: <20220906015823.12390-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

configuration.txt in ksmbd-tools moved to ksmb.conf manpage.
update it and more detailed ksmbd-tools build method.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v2:
   - rename smb.conf to ksmbd.conf.
   - add how to set ksmbd module in menuconfig
   - remove --syscondir option for configure, instead change ksmbd
     directory to /usr/local/etc/ksmbd.
   - change the prompt to '$'.

 Documentation/filesystems/cifs/ksmbd.rst | 32 ++++++++++++++++--------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/Documentation/filesystems/cifs/ksmbd.rst b/Documentation/filesystems/cifs/ksmbd.rst
index 1af600db2e70..69d4a4c3313b 100644
--- a/Documentation/filesystems/cifs/ksmbd.rst
+++ b/Documentation/filesystems/cifs/ksmbd.rst
@@ -118,24 +118,36 @@ ksmbd/nfsd interoperability    Planned for future. The features that ksmbd
 How to run
 ==========
 
-1. Download ksmbd-tools and compile them.
-	- https://github.com/cifsd-team/ksmbd-tools
+1. Download ksmbd-tools(https://github.com/cifsd-team/ksmbd-tools/releases) and compile them.
+   - Refer README(https://github.com/cifsd-team/ksmbd-tools/blob/master/README.md)
+     to know how to use ksmbd.<foo> utils
+
+     $ ./autogen.sh
+     $ ./configure --with-rundir=/run
+     $ make && sudo make install
 
 2. Create user/password for SMB share.
+   - See ksmbd.adduser manpage.
+
+     $ man ksmbd.adduser
+     $ sudo ksmbd.adduser -a <Enter USERNAME for SMB share access>
 
-	# mkdir /etc/ksmbd/
-	# ksmbd.adduser -a <Enter USERNAME for SMB share access>
+3. Create /usr/local/etc/ksmbd/ksmbd.conf file, add SMB share in smb.conf file.
+   - Refer ksmbd.conf.example in ksmbd-utils, See ksmbd.conf manpage
+     for details to configure shares.
 
-3. Create /etc/ksmbd/smb.conf file, add SMB share in smb.conf file
-	- Refer smb.conf.example and
-          https://github.com/cifsd-team/ksmbd-tools/blob/master/Documentation/configuration.txt
+        $ man ksmbd.conf
 
-4. Insert ksmbd.ko module
+4. Insert ksmbd.ko module after build your kernel.
+   - Set ksmbd in menuconfig(e.g. $ make menuconfig)
+       [*] Network File Systems  --->
+           <M> SMB server support
 
-	# insmod ksmbd.ko
+	$ sudo insmod ksmbd.ko
 
 5. Start ksmbd user space daemon
-	# ksmbd.mountd
+
+	$ sudo ksmbd.mountd
 
 6. Access share from Windows or Linux using CIFS
 
-- 
2.25.1

