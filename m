Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29353C6FA8A
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Sep 2022 14:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiIOOHT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Sep 2022 10:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiIOOHS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 15 Sep 2022 10:07:18 -0400
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744E79BB74
        for <linux-cifs@vger.kernel.org>; Thu, 15 Sep 2022 07:07:17 -0700 (PDT)
Received: by mail-pj1-f48.google.com with SMTP id o70-20020a17090a0a4c00b00202f898fa86so8153628pjo.2
        for <linux-cifs@vger.kernel.org>; Thu, 15 Sep 2022 07:07:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=UkxXSZ6pqbqZEDuGjxgZtX0vmMtgqSwi1LDET41Gmtc=;
        b=AwBXcny0fEaIek7BsxNXZ73rGQav0sUVoSBgvZBPBjAiV3nvTBBgIgByUS0EYijxWT
         Xv4pWp6x3flb/fBGIG5uiRzhncGXILo3MmWGd+Ky4CgOsPY7/XAT7GrcJE3TvXj2tK4d
         ZvitofmZJZBdh9yzyU/wI1DsKEra/xqT6dpsRujVy4oFs6QLId9nRclGRTwKLSObnwjE
         bzylvM3FoG5sLFX+3L1rooaMkydDYHR8oUjiaNjwij5R57P1JNSNaESSxoMQnKK40XUH
         zm6+IKKt0JyP4eWeexqU/voPI2LtvYW8oDOhMt/EER3VAA2IjxEZyhbEuZvXJY53kqUK
         3t2g==
X-Gm-Message-State: ACgBeo0tQy0QX54WpHMaw7E/PvegkcEPMI+y2gjJFYC8a/HnRQIqd2dn
        d+R0Wr683sPu+uxSr8RbzJE+maL0bJ8=
X-Google-Smtp-Source: AA6agR4yALJ3VmtAKlq29YtJeItuvXu8t+NG1Zl8nKiQD7Typ+MWVD1LVt+SO/GfCk23E0I+qTUkKw==
X-Received: by 2002:a17:90a:908:b0:200:14d8:1ff9 with SMTP id n8-20020a17090a090800b0020014d81ff9mr10758117pjn.16.1663250836514;
        Thu, 15 Sep 2022 07:07:16 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id gv6-20020a17090b11c600b002002f9eb8c4sm1707190pjb.12.2022.09.15.07.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 07:07:15 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4] ksmbd: update documentation
Date:   Thu, 15 Sep 2022 23:07:00 +0900
Message-Id: <20220915140700.7953-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

configuration.txt in ksmbd-tools moved to ksmbd.conf manpage.
update it and more detailed ksmbd-tools build method.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v4:
   - switch the order of 1 and 2.
 v3:
   - replace CIFS with SMB3 clients.
   - update ksmbd built-in case.
   - replace smb.conf leftover with ksmbd.conf.
   - use full name of utils in ksmbd-tools instead of <foo>.
   - fix the warnings from make htlmdocs build reported by kernel test
     robot.
 v2:
   - rename smb.conf to ksmbd.conf.
   - add how to set ksmbd module in menuconfig
   - remove --syscondir option for configure, instead change ksmbd
     directory to /usr/local/etc/ksmbd.
   - change the prompt to '$'.

 Documentation/filesystems/cifs/ksmbd.rst | 42 +++++++++++++++++-------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/Documentation/filesystems/cifs/ksmbd.rst b/Documentation/filesystems/cifs/ksmbd.rst
index 1af600db2e70..7bed96d794fc 100644
--- a/Documentation/filesystems/cifs/ksmbd.rst
+++ b/Documentation/filesystems/cifs/ksmbd.rst
@@ -118,26 +118,44 @@ ksmbd/nfsd interoperability    Planned for future. The features that ksmbd
 How to run
 ==========
 
-1. Download ksmbd-tools and compile them.
-	- https://github.com/cifsd-team/ksmbd-tools
+1. Download ksmbd-tools(https://github.com/cifsd-team/ksmbd-tools/releases) and
+   compile them.
 
-2. Create user/password for SMB share.
+   - Refer README(https://github.com/cifsd-team/ksmbd-tools/blob/master/README.md)
+     to know how to use ksmbd.mountd/adduser/addshare/control utils
 
-	# mkdir /etc/ksmbd/
-	# ksmbd.adduser -a <Enter USERNAME for SMB share access>
+     $ ./autogen.sh
+     $ ./configure --with-rundir=/run
+     $ make && sudo make install
 
-3. Create /etc/ksmbd/smb.conf file, add SMB share in smb.conf file
-	- Refer smb.conf.example and
-          https://github.com/cifsd-team/ksmbd-tools/blob/master/Documentation/configuration.txt
+2. Create /usr/local/etc/ksmbd/ksmbd.conf file, add SMB share in ksmbd.conf file.
 
-4. Insert ksmbd.ko module
+   - Refer ksmbd.conf.example in ksmbd-utils, See ksmbd.conf manpage
+     for details to configure shares.
 
-	# insmod ksmbd.ko
+        $ man ksmbd.conf
+
+3. Create user/password for SMB share.
+
+   - See ksmbd.adduser manpage.
+
+     $ man ksmbd.adduser
+     $ sudo ksmbd.adduser -a <Enter USERNAME for SMB share access>
+
+4. Insert ksmbd.ko module after build your kernel. No need to load module
+   if ksmbd is built into the kernel.
+
+   - Set ksmbd in menuconfig(e.g. $ make menuconfig)
+       [*] Network File Systems  --->
+           <M> SMB3 server support (EXPERIMENTAL)
+
+	$ sudo modprobe ksmbd.ko
 
 5. Start ksmbd user space daemon
-	# ksmbd.mountd
 
-6. Access share from Windows or Linux using CIFS
+	$ sudo ksmbd.mountd
+
+6. Access share from Windows or Linux using SMB3 client (cifs.ko or smbclient of samba)
 
 Shutdown KSMBD
 ==============
-- 
2.25.1

