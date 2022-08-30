Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46AEDECAAD1
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Aug 2022 14:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiH3OR5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Aug 2022 10:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiH3ORz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Aug 2022 10:17:55 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70702DEB40
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 07:17:54 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id u9-20020a17090a1f0900b001fde6477464so4967789pja.4
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 07:17:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=/2I90bAELYA/CcsCqFLoTIPpnNKHY+mrQs9k+21PxC8=;
        b=J04OgYpWM7n1GyXO48iuOc+Lzk6oCBmqOqHyG7ARfnmXIIfC7lztViRfZSThtVigz2
         /4wZC16K9CmfcxXOrjnKIn+aQfZOT/OPoYMZMNLXjVzk3o3pjm06KdHT0Kuo1ZICIm26
         afT5iYKhRNGODb0BGs8Cc1sHvg1I5DRbM+vD0xAmzZVLYSukSia6e+aAg1pPSyu2lOEr
         yZ7tvRcxn+pdW8aLL9gWiRbJtctKGUjhItyO/RD2gjIQ7CA/QexN5g5SuSm6RAYck0lG
         0FjXNUNrn9Azo6VM2SRvB8hqp8AeGqujUcKUlJF6WKoK6TJZvqJW9+aA3Nqnl56kj4SA
         /++Q==
X-Gm-Message-State: ACgBeo3HQkI82Os8MkQWAHcSHeVbsta9PSNwS4A1e/11gnEpt6qIEPZi
        pcIrhtnzIVyx6GuZQnPxnnrTgbT+2yo=
X-Google-Smtp-Source: AA6agR7qmuXSVoJ32n0n7iOpZ5eqNuHKkPgVf8ujqTNH0iiSeVzj90Iw4qxG9BJ/O5YGN+rks43d6Q==
X-Received: by 2002:a17:90b:3810:b0:1fd:d001:ed41 with SMTP id mq16-20020a17090b381000b001fdd001ed41mr10245778pjb.209.1661869073736;
        Tue, 30 Aug 2022 07:17:53 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id i72-20020a62874b000000b0052e987c64efsm9671172pfe.174.2022.08.30.07.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 07:17:53 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>
Subject: [PATCH 1/2] ksmbd: update documentation
Date:   Tue, 30 Aug 2022 23:17:31 +0900
Message-Id: <20220830141732.9982-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

configuration.txt in ksmbd-tools moved to smb.conf(5ksmbd) manpage.
update it and more detailed ksmbd-tools build method.

Cc: Tom Talpey <tom@talpey.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 Documentation/filesystems/cifs/ksmbd.rst | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/cifs/ksmbd.rst b/Documentation/filesystems/cifs/ksmbd.rst
index 1af600db2e70..767e12d2045a 100644
--- a/Documentation/filesystems/cifs/ksmbd.rst
+++ b/Documentation/filesystems/cifs/ksmbd.rst
@@ -121,20 +121,26 @@ How to run
 1. Download ksmbd-tools and compile them.
 	- https://github.com/cifsd-team/ksmbd-tools
 
+        # ./autogen.sh
+        # ./configure --sysconfdir=/etc --with-rundir=/run
+        # make & sudo make install
+
 2. Create user/password for SMB share.
 
 	# mkdir /etc/ksmbd/
 	# ksmbd.adduser -a <Enter USERNAME for SMB share access>
 
 3. Create /etc/ksmbd/smb.conf file, add SMB share in smb.conf file
-	- Refer smb.conf.example and
-          https://github.com/cifsd-team/ksmbd-tools/blob/master/Documentation/configuration.txt
+	- Refer smb.conf.example, See smb.conf(5ksmbd) for details.
+
+        # man smb.conf.5ksmbd
 
 4. Insert ksmbd.ko module
 
 	# insmod ksmbd.ko
 
 5. Start ksmbd user space daemon
+
 	# ksmbd.mountd
 
 6. Access share from Windows or Linux using CIFS
-- 
2.25.1

