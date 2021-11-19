Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52E9AC433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Nov 2021 21:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbhKSVPa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Nov 2021 16:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbhKSVPa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Nov 2021 16:15:30 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DF2C061574;
        Fri, 19 Nov 2021 13:12:28 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id u18so20282564wrg.5;
        Fri, 19 Nov 2021 13:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=myqMq5JJldoxRnxPAx5ijKAxfMyvPLaQ6eIycx8Zmgk=;
        b=QWGPohrxW6g9WpbnJaihqSJvHimsOxT6/Ojw1de3vhzbKZq7MEovhjNAfl2bOvz2Xe
         4UdrCH1laBTgF09K7x8GV9O6P3dFqvp/jAFyflU6mNOBY5KLoKu2rqsXZTp9KWxYXXUa
         uaDuIcrWIaixnqMPvhSAtqy/Gfpudy9Vi2MqJbgwKN0czkEGJGQCW9gJhjXcu2S62nTA
         oorr1P7QUNTcy6Hq6XBVnvg7aajv0r2+KyK81EP7JU02bt6T7XPE4tDJVZSYOo+/O6F1
         Pu5MZqP5MZscXYPa2MksluWSd7s4jNJybNQBaMFvZyp0MMsPmeHL9/OnmIVL5PsBRgqi
         h4Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=myqMq5JJldoxRnxPAx5ijKAxfMyvPLaQ6eIycx8Zmgk=;
        b=n5hWpvvukCAU5I3/fSz4rjlZFYwa3EfNEvuGQ14L7+QlaZwiSJ9g59mMlxHCmOeEux
         u5cUT6YC8WT3FuGLdj6GJV5mQJ9XFY8G+kP3uVmLRUstjXZKnMpt2yGH4drpZfWX9Rh8
         vLf56dh5wY8L+8VtqZpESMLv4nz2Ef9PRb9n3aaH3qyViXhw734bkcS5T56x02mG3I28
         WxOySvLMLfJhPTOUd2lwGLPxPcS5JfHWHEweArv2L0Sewzvjp1VcIW5Dy3LPt4V6AmiB
         tb5mdRx73RWPl3jAGRIgdXFI//30tnX4uuTL/OUlsn6XV6GixqNPh6u03dDPptgAIvO0
         UXXA==
X-Gm-Message-State: AOAM530LGqFDibFROvnBIAe90b/QYRdQt/+Byp5P9TYuXAGtF7Y4A757
        GoXKTYVlWLRsuF2ybADrEXc=
X-Google-Smtp-Source: ABdhPJzNPjxngLb+dDQlFnMWApFKjPqCiA1IQlAG6qG6d76l84IaJcgU0H1pRsAJIlv9i4fw5ND5yA==
X-Received: by 2002:adf:ee42:: with SMTP id w2mr11427228wro.7.1637356346511;
        Fri, 19 Nov 2021 13:12:26 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id b11sm13070427wmj.35.2021.11.19.13.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 13:12:26 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH] docs: filesystem: cifs: ksmbd: Fix small layout issues
Date:   Fri, 19 Nov 2021 22:12:14 +0100
Message-Id: <20211119211214.2038038-1-carnil@debian.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In some senteces there were missing spaces between words.

Fix wording in item to show which prints are enabled and add a space
beween the cat command and its argument.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steve French <sfrench@samba.org>
CC: Hyunchul Lee <hyc.lee@gmail.com>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
---
 Documentation/filesystems/cifs/ksmbd.rst | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/cifs/ksmbd.rst b/Documentation/filesystems/cifs/ksmbd.rst
index a1326157d53f..b0d354fd8066 100644
--- a/Documentation/filesystems/cifs/ksmbd.rst
+++ b/Documentation/filesystems/cifs/ksmbd.rst
@@ -50,11 +50,11 @@ ksmbd.mountd (user space daemon)
 --------------------------------
 
 ksmbd.mountd is userspace process to, transfer user account and password that
-are registered using ksmbd.adduser(part of utils for user space). Further it
+are registered using ksmbd.adduser (part of utils for user space). Further it
 allows sharing information parameters that parsed from smb.conf to ksmbd in
 kernel. For the execution part it has a daemon which is continuously running
 and connected to the kernel interface using netlink socket, it waits for the
-requests(dcerpc and share/user info). It handles RPC calls (at a minimum few
+requests (dcerpc and share/user info). It handles RPC calls (at a minimum few
 dozen) that are most important for file server from NetShareEnum and
 NetServerGetInfo. Complete DCE/RPC response is prepared from the user space
 and passed over to the associated kernel thread for the client.
@@ -154,11 +154,11 @@ Each layer
 1. Enable all component prints
 	# sudo ksmbd.control -d "all"
 
-2. Enable one of components(smb, auth, vfs, oplock, ipc, conn, rdma)
+2. Enable one of components (smb, auth, vfs, oplock, ipc, conn, rdma)
 	# sudo ksmbd.control -d "smb"
 
-3. Show what prints are enable.
-	# cat/sys/class/ksmbd-control/debug
+3. Show what prints are enabled.
+	# cat /sys/class/ksmbd-control/debug
 	  [smb] auth vfs oplock ipc conn [rdma]
 
 4. Disable prints:
-- 
2.33.1

