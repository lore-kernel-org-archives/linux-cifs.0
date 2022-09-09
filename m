Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0CD1ECAAA1
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Sep 2022 09:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiIIJ24 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Sep 2022 05:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbiIIJ2G (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Sep 2022 05:28:06 -0400
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05782131EC1
        for <linux-cifs@vger.kernel.org>; Fri,  9 Sep 2022 02:26:36 -0700 (PDT)
Received: by mail-pl1-f179.google.com with SMTP id iw17so1280761plb.0
        for <linux-cifs@vger.kernel.org>; Fri, 09 Sep 2022 02:26:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=LEbk7Xw+K91iRlZjEwuiCTLZdZtjHRjY5qK5vEnCgrg=;
        b=hT6bmQS9CtHI7shcWOz4X65ay9RZshk7DegbmWZbWl0oyQybT9v1KxRYZVb95M4k+f
         /75Tl8OX3T+c/Vz9yq33oJ1yRyCgZ+HBjIw3tbNzNFa2LnX2y8D/5LCCrsAZ6ieqyZmQ
         fbSl8G+kcP/hOKdqbblOpwSIc7SkL4g5zP2yIGonm7qnYovxD90x6eZf8glaIpFefdjB
         6Gxet3P2Cb4z2QA8q1xyhvZLpJI30+Be4DifupihPKu1GlBcKeCjbGpYrgFGmSRRDVkh
         5IsneaNfnGljxnAq+8U4aDHO8JyhhpZr/qwB7RK+aNOjEb2HIF4NP/pcLQAr3fin6yaf
         1SOg==
X-Gm-Message-State: ACgBeo2nOnFbykbxhONXbOb3iO8kMnUalWK0MblG2m4CBgkSRzk+67EQ
        drQinDqYOZ6LDfS1TGqeuM/nYPml6e0=
X-Google-Smtp-Source: AA6agR4Dk6mqdgl+SMi0Us1uecaqxIGt6M0+pL/uCQ+nDpMrTPS7JkCY/MGjf49RDf4KD9T0JxfaAw==
X-Received: by 2002:a17:90b:3b91:b0:202:91d7:6a5d with SMTP id pc17-20020a17090b3b9100b0020291d76a5dmr879962pjb.101.1662715595334;
        Fri, 09 Sep 2022 02:26:35 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id e15-20020a17090a7c4f00b002008d0df002sm861874pjl.50.2022.09.09.02.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 02:26:34 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v3] ksmbd: update documentation
Date:   Fri,  9 Sep 2022 18:25:58 +0900
Message-Id: <20220909092558.9498-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220909092558.9498-1-linkinjeon@kernel.org>
References: <20220909092558.9498-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

configuration.txt in ksmbd-tools moved to ksmbd.conf manpage.
update it and more detailed ksmbd-tools build method.

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
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

 Documentation/filesystems/cifs/ksmbd.rst | 40 +++++++++++++++++-------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/Documentation/filesystems/cifs/ksmbd.rst b/Documentation/filesystems/cifs/ksmbd.rst
index 1af600db2e70..4284341c89f3 100644
--- a/Documentation/filesystems/cifs/ksmbd.rst
+++ b/Documentation/filesystems/cifs/ksmbd.rst
@@ -118,26 +118,44 @@ ksmbd/nfsd interoperability    Planned for future. The features that ksmbd
 How to run
 ==========
 
-1. Download ksmbd-tools and compile them.
-	- https://github.com/cifsd-team/ksmbd-tools
+1. Download ksmbd-tools(https://github.com/cifsd-team/ksmbd-tools/releases) and
+   compile them.
+
+   - Refer README(https://github.com/cifsd-team/ksmbd-tools/blob/master/README.md)
+     to know how to use ksmbd.mountd/adduser/addshare/control utils
+
+     $ ./autogen.sh
+     $ ./configure --with-rundir=/run
+     $ make && sudo make install
 
 2. Create user/password for SMB share.
 
-	# mkdir /etc/ksmbd/
-	# ksmbd.adduser -a <Enter USERNAME for SMB share access>
+   - See ksmbd.adduser manpage.
+
+     $ man ksmbd.adduser
+     $ sudo ksmbd.adduser -a <Enter USERNAME for SMB share access>
+
+3. Create /usr/local/etc/ksmbd/ksmbd.conf file, add SMB share in ksmbd.conf file.
 
-3. Create /etc/ksmbd/smb.conf file, add SMB share in smb.conf file
-	- Refer smb.conf.example and
-          https://github.com/cifsd-team/ksmbd-tools/blob/master/Documentation/configuration.txt
+   - Refer ksmbd.conf.example in ksmbd-utils, See ksmbd.conf manpage
+     for details to configure shares.
 
-4. Insert ksmbd.ko module
+        $ man ksmbd.conf
 
-	# insmod ksmbd.ko
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
+6. Access share from Windows or Linux SMB3 clients (cifs.ko or smbclient of samba)
 
 Shutdown KSMBD
 ==============
-- 
2.25.1

