Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE633C433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Feb 2022 22:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbiBCWng (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 3 Feb 2022 17:43:36 -0500
Received: from mail-pf1-f170.google.com ([209.85.210.170]:42840 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiBCWnf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 3 Feb 2022 17:43:35 -0500
Received: by mail-pf1-f170.google.com with SMTP id i65so3440013pfc.9
        for <linux-cifs@vger.kernel.org>; Thu, 03 Feb 2022 14:43:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a3VqzrMb22V+TTpVLtMuizUWrjR2NIU3VfZpF4ROAnA=;
        b=wFykHG6rNo055spEAJPCTaxZaytxRGRAeUFQSb+R6d1yEkyiJTyRHoOj7xdqLx9NTb
         UYhDuz+HOS4WBgixi1PBr+o0cP4iDCRt7OOjLTVarBakpz97+Pcw3Khd/eC2+y28wUmI
         y0FoozBkGAPG3Mf+WS8LbKhMDP70edYNoIu/04aT1VcqDiqsxUYRzFN/leQA5XuWq5pM
         VvL9zHwrr9z42D0Zd2pbJ7dkd5qTm+h/gwfigmAMrVazQeBbIuCIOnyYGbPTTrsVV0DK
         9CKQRokr8L62P7M+/GiHN7DHxwDkHMAH93EVHmCF9639OydIFLFZQNxLm7UlrZ/xMJVM
         EqtA==
X-Gm-Message-State: AOAM53128YWNFjSH5xdnoV55GG6Dr4JX0JTzbv1yNzSCNzzHcZsKCwRW
        W/7W4YADbfppFODcyfl7meEoWCRuQI4=
X-Google-Smtp-Source: ABdhPJxy0OddO24/AhFBPdgNlOSqrlcFaZNEJzh1cdAp50wNZYx3OMiSOxWIH1k5pLOhrfln9+e/jw==
X-Received: by 2002:a05:6a00:1305:: with SMTP id j5mr208172pfu.34.1643928215280;
        Thu, 03 Feb 2022 14:43:35 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id nu7sm18675pjb.30.2022.02.03.14.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 14:43:35 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] Documentation: ksmbd: update Feature Status table
Date:   Fri,  4 Feb 2022 07:39:33 +0900
Message-Id: <20220203223933.6262-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

As RDMA connection with Windows client becomes possible, change SMB
direct to Supported from Partially Supported in the Feature Status table.
It also adds new RSS mode support.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 Documentation/filesystems/cifs/ksmbd.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/cifs/ksmbd.rst b/Documentation/filesystems/cifs/ksmbd.rst
index b0d354fd8066..1af600db2e70 100644
--- a/Documentation/filesystems/cifs/ksmbd.rst
+++ b/Documentation/filesystems/cifs/ksmbd.rst
@@ -82,10 +82,10 @@ Signing Update                 Supported.
 Pre-authentication integrity   Supported.
 SMB3 encryption(CCM, GCM)      Supported. (CCM and GCM128 supported, GCM256 in
                                progress)
-SMB direct(RDMA)               Partially Supported. SMB3 Multi-channel is
-                               required to connect to Windows client.
+SMB direct(RDMA)               Supported.
 SMB3 Multi-channel             Partially Supported. Planned to implement
                                replay/retry mechanisms for future.
+Receive Side Scaling mode      Supported.
 SMB3.1.1 POSIX extension       Supported.
 ACLs                           Partially Supported. only DACLs available, SACLs
                                (auditing) is planned for the future. For
-- 
2.25.1

