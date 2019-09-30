Return-Path: <SRS0=Aodf=XZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31024C35280
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Sep 2019 17:06:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07A9B2086A
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Sep 2019 17:06:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jfIbQYvc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730274AbfI3RGa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Sep 2019 13:06:30 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39777 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfI3RGa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Sep 2019 13:06:30 -0400
Received: by mail-pf1-f194.google.com with SMTP id v4so5958167pff.6
        for <linux-cifs@vger.kernel.org>; Mon, 30 Sep 2019 10:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/0F0HHtb70WhU8UdtnaMQFz8WqIiuAICsVCiy0Bk4Rs=;
        b=jfIbQYvcq3EWDUjHH8FNfuFTrULnm4+Bo+dhlQF0l4sQHCfop1r8u9ghOZ3S+FQGSy
         2IuZkpRO9fIyrujkJt7r6XQh/6sB6OPNs1AHhtSDUGIbl+YGyPItTjgaRDB7askA8dR5
         vJ81Rxzb2H3UrkS2txmFCs2yTfdwxUcukjI7ZLcGEmVcedFKKcSSoj87I+5RuE4Dl9pP
         98H91sw9X1eEokopU726Uo1OSxA/qjpiZst3HzXzsUtMGEi88NBv7glgJ6O8Ga8bOOoj
         y91gse0uZpK397fyiVlGoR1vlqvBFk+LEY0Nj8rMLIGFAf7BWLpdbHgMhMsckmznrQ3a
         xboA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/0F0HHtb70WhU8UdtnaMQFz8WqIiuAICsVCiy0Bk4Rs=;
        b=WAfpdKTAmRXzRyjtpCPFF4PNQp2M0ZVI2fljATUt5+NSaW3uvo8xQgsY7WVwKtt8GE
         l+tNgRj7/mPcw4HQ3XuB07N9nTKulvYBq6zqvwjsT+YdBgWDbe6Lqixnmb28bAcxP3QH
         CbN8hY3U4c+7H6fieOILfoHsYoktZ/VjKemkMrq084FwA1jV1Poy2NCpPt+XjX60Da22
         SqhTHymlJgVXMWIxNjdDA/4/gM6h8qsFK+UqteNuIU31Pp6DTBaFtbNN1Kf4aOH1En1y
         cgq+0FOou6BQTj8OjJyOsBHdI/56/i6tK5GR8CWu7pX1Bawv0qBa7UXys8ay9bkSLkK+
         OiQQ==
X-Gm-Message-State: APjAAAXEEYsc6yv3FwtB9ukVTnjX9N26b5M6x+KEOUmjylNxVnojxZcK
        C14I0ebpyKnq7IV7lD5rT9iK/Vw=
X-Google-Smtp-Source: APXvYqy/Dl01ExaAXsRri+D9B1dzSBhmcHk0K3TqhayZahtSpfH3vaOwaZbReBWjJSxCHQAf3IvFBQ==
X-Received: by 2002:a17:90a:c212:: with SMTP id e18mr258364pjt.110.1569863188043;
        Mon, 30 Sep 2019 10:06:28 -0700 (PDT)
Received: from ubuntu-vm.mshome.net ([131.107.147.106])
        by smtp.gmail.com with ESMTPSA id d5sm18350780pfa.180.2019.09.30.10.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 10:06:27 -0700 (PDT)
From:   Pavel Shilovsky <piastryyy@gmail.com>
X-Google-Original-From: Pavel Shilovsky <pshilov@microsoft.com>
To:     linux-cifs@vger.kernel.org
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovskiy <pshilov@microsoft.com>
Subject: [PATCH 2/3] CIFS: Force revalidate inode when dentry is stale
Date:   Mon, 30 Sep 2019 10:06:19 -0700
Message-Id: <20190930170620.29979-2-pshilov@microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190930170620.29979-1-pshilov@microsoft.com>
References: <20190930170620.29979-1-pshilov@microsoft.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Currently the client indicates that a dentry is stale when inode
numbers or type types between a local inode and a remote file
don't match. If this is the case attributes is not being copied
from remote to local, so, it is already known that the local copy
has stale metadata. That's why the inode needs to be marked for
revalidation in order to tell the VFS to lookup the dentry again
before openning a file. This prevents unexpected stale errors
to be returned to the user space when openning a file.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 56ca4b8ccaba..79d9a60f21ba 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -414,6 +414,7 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 		/* if uniqueid is different, return error */
 		if (unlikely(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM &&
 		    CIFS_I(*pinode)->uniqueid != fattr.cf_uniqueid)) {
+			CIFS_I(*pinode)->time = 0; /* force reval */
 			rc = -ESTALE;
 			goto cgiiu_exit;
 		}
@@ -421,6 +422,7 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 		/* if filetype is different, return error */
 		if (unlikely(((*pinode)->i_mode & S_IFMT) !=
 		    (fattr.cf_mode & S_IFMT))) {
+			CIFS_I(*pinode)->time = 0; /* force reval */
 			rc = -ESTALE;
 			goto cgiiu_exit;
 		}
@@ -924,6 +926,7 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
 		/* if uniqueid is different, return error */
 		if (unlikely(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM &&
 		    CIFS_I(*inode)->uniqueid != fattr.cf_uniqueid)) {
+			CIFS_I(*inode)->time = 0; /* force reval */
 			rc = -ESTALE;
 			goto cgii_exit;
 		}
@@ -931,6 +934,7 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
 		/* if filetype is different, return error */
 		if (unlikely(((*inode)->i_mode & S_IFMT) !=
 		    (fattr.cf_mode & S_IFMT))) {
+			CIFS_I(*inode)->time = 0; /* force reval */
 			rc = -ESTALE;
 			goto cgii_exit;
 		}
-- 
2.17.1

