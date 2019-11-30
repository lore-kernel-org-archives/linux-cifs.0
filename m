Return-Path: <SRS0=R0d0=ZW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E89C43215
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Nov 2019 05:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13BD420833
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Nov 2019 05:31:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MzVVrKj5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbfK3FbO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 30 Nov 2019 00:31:14 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:45172 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbfK3FbO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 30 Nov 2019 00:31:14 -0500
Received: by mail-pj1-f68.google.com with SMTP id r11so6447816pjp.12;
        Fri, 29 Nov 2019 21:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RG3ZZhL0E9GykGjjrk/4EJEMUcXoBYc4Ti1EdJzmX8c=;
        b=MzVVrKj56G3Rjx9PNwPCnF05+CWpsp9qOCWIjLhSMVP1H85Jm+kEMq01a3II/SkjeA
         D2on7ny2E34U4qUzAstO8zqiSbvLyF1I/+6Pgt0bF4b2/OrKnM2tt7myGi3/D4cFMIFo
         VhHpYU+J/+jA8MkczlPzPLFQYpf1IX1JZdbECnrenXKLVlK2MeWqWAH4YaZIOUI8Gd8z
         HrJ0QxI6IbWIQOebPB24cRQ7Im6US8lMaYxZo/Esqm6V4VrLcBObUcgiHOCFtNzQGluO
         NcxS0+A043dL67/NUVptSeAAmdjo0LJIeRQd4zXXKASEkDGZc8/VsCD0TanaTgIFQQ3l
         H1sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RG3ZZhL0E9GykGjjrk/4EJEMUcXoBYc4Ti1EdJzmX8c=;
        b=DYk1I1/GKgGIPgZofrq7+eO3VGgDY8WUhQK52DMv+ckXU/5bNlQCLiqK9rHtHCqeZJ
         2CoQLWLQJJzjmoIZ2XvxcRW0Nb8VNGYiJixzaiGsldqmhxLW7/0HQ3J+UP+K6IAhYTMQ
         gYYfqIAjcz2EIuVdC+wUVvp6HtQ6A6ebhJgbZEf7mk03OxaSwwsagGwOhemEpSb8Oe17
         Wnfrrrn8atHFXDtNI1tcwGSEDx9XziwVnTPuakQH2kmHwPB1PghZZFuGzPB+lkRPci6j
         tTrfKjulZwKPq8PcWGE/fMCEbUzWN540BdYmdlEWHR7AzsB0q6ItcPW3LI/CBKxIY2Ta
         TYiA==
X-Gm-Message-State: APjAAAWvhZcz38P/8ObCVlgieDgfMdM/1qIi4+Q6DFilCsZjCDnxoLMq
        pEfen9l5s2nol7u2jM+8wWk=
X-Google-Smtp-Source: APXvYqyGNzC6Z7/nQnWlPRGSKMBzHzH4LiHA8ULIljDDy4dGNrtzcc0t//GYYPmR1cVantfjMqmdvA==
X-Received: by 2002:a17:902:be02:: with SMTP id r2mr16885299pls.76.1575091873307;
        Fri, 29 Nov 2019 21:31:13 -0800 (PST)
Received: from deepa-ubuntu.lan (c-98-234-52-230.hsd1.ca.comcast.net. [98.234.52.230])
        by smtp.gmail.com with ESMTPSA id a13sm26131734pfi.187.2019.11.29.21.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 21:31:12 -0800 (PST)
From:   Deepa Dinamani <deepa.kernel@gmail.com>
To:     viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, arnd@arndb.de,
        stfrench@microsoft.com, linux-cifs@vger.kernel.org
Subject: [PATCH 2/7] fs: cifs: Fix atime update check vs mtime
Date:   Fri, 29 Nov 2019 21:30:25 -0800
Message-Id: <20191130053030.7868-3-deepa.kernel@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191130053030.7868-1-deepa.kernel@gmail.com>
References: <20191130053030.7868-1-deepa.kernel@gmail.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

According to the comment in the code and commit log, some apps
expect atime >= mtime; but the introduced code results in
atime==mtime.  Fix the comparison to guard against atime<mtime.

Fixes: 9b9c5bea0b96 ("cifs: do not return atime less than mtime")
Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: stfrench@microsoft.com
Cc: linux-cifs@vger.kernel.org
---
 fs/cifs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 8a76195e8a69..ca76a9287456 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -163,7 +163,7 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
 
 	spin_lock(&inode->i_lock);
 	/* we do not want atime to be less than mtime, it broke some apps */
-	if (timespec64_compare(&fattr->cf_atime, &fattr->cf_mtime))
+	if (timespec64_compare(&fattr->cf_atime, &fattr->cf_mtime) < 0)
 		inode->i_atime = fattr->cf_mtime;
 	else
 		inode->i_atime = fattr->cf_atime;
-- 
2.17.1

