Return-Path: <SRS0=yfkL=4J=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70873C11D00
	for <linux-cifs@archiver.kernel.org>; Fri, 21 Feb 2020 02:30:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3145220722
	for <linux-cifs@archiver.kernel.org>; Fri, 21 Feb 2020 02:30:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="POvjZlJr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbgBUCaN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 Feb 2020 21:30:13 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40807 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729222AbgBUCaM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 20 Feb 2020 21:30:12 -0500
Received: by mail-pg1-f194.google.com with SMTP id z7so210643pgk.7
        for <linux-cifs@vger.kernel.org>; Thu, 20 Feb 2020 18:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=WDyuHPljt8pm0G5gdftzN91lk/raRxuLjJG4YigDsdU=;
        b=POvjZlJrBrSKL0Axpb90AsjPJ8tSL/8X//mSpEBlGn9iL87caSRAAsAY0tMnJPPdz8
         fGeil0Li0LFquiNZDqr7Cu67VG6EhfBvvrxE8yBImQ3YD8ehNqOCPvy3q7RUZXaxOVjN
         HzDawxQl/DLlm2XqCbofi+fbmaqzqila41PaIYFQhNc+/8BL3DAUkv5JavEmkF/LCcOk
         lfJmxaRMCtTSbMp2x0zA5Rp5lDyVzWhCje9HuODxPU9PLf2wIJ4SXIFVo17cN/vo3A26
         0ITyHToHByjdI5N1kyv6iQm/HYt3QY55kYeshQlNSxhr7UAvxY+OjdE+YBjD/GXD9x7P
         fqNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=WDyuHPljt8pm0G5gdftzN91lk/raRxuLjJG4YigDsdU=;
        b=NrLEzM5YxJIyPaC0IXJjMP6lZpNHuXL1XN3TIbfhe303ZKrkE+VEL6Rj7VTySNmiJw
         Q7bNCvXOnpLFg5l/h3MtnvWY3ZypowrJYdH865NNHxNr3zNP7hrt3ah5okU4ttjvmSSz
         k55ewdUGpdLvooNeVsdCTrffPoviZLIxB5bXYYx1uWeA6/OUs0bwQ3rR+5LyzcMLyVpL
         q3HvJ+lU07wOAR3M+X12d5LXXFdHu4IEoQtony7QCpJJRFoTdQcldKHaZUtMAoIAJKy7
         Ef4t0WKoqrHX7zFKmeANrITx19rJO3ZR7FYIxVnsb0es4tEnP/RKYAgV8ylEWmAJiuoX
         p9mg==
X-Gm-Message-State: APjAAAVO7W2YPtUSY11tq+XamVhcw53vh4OQmb1uGUCHDUgd/SwcAYjj
        jGcyKEPR8CSe6TC7ciVBnXYJiOlJ
X-Google-Smtp-Source: APXvYqxqU38jlEj+hztAZuARtUbo8OKcs4iXKnv6ouC7sqlgRH2HSKbuOnOcfelhj2Uu+cXUN/fr4Q==
X-Received: by 2002:a63:30c2:: with SMTP id w185mr37771511pgw.307.1582252209668;
        Thu, 20 Feb 2020 18:30:09 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f9sm874492pfd.141.2020.02.20.18.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 18:30:09 -0800 (PST)
Date:   Fri, 21 Feb 2020 10:30:01 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>
Subject: [PATCH v2] cifs: allow unlock flock and OFD lock across fork
Message-ID: <20200221023001.vcoc5f43rdqqeifn@xzhoux.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Since commit d0677992d2af ("cifs: add support for flock") added
support for flock, LTP/flock03[1] testcase started to fail.

This testcase is testing flock lock and unlock across fork.
The parent locks file and starts the child process, in which
it unlock the same fd and lock the same file with another fd
again. All the lock and unlock operation should succeed.

Now the child process does not actually unlock the file, so
the following lock fails. Fix this by allowing flock and OFD
lock go through the unlock routine, not skipping if the unlock
request comes from another process.

Patch has been tested by LTP/xfstests on samba and Windows
server, v3.11, with or without cache=none mount option.

[1] https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/syscalls/flock/flock03.c
Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
---
 fs/cifs/smb2file.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index afe1f03aabe3..eebfbf3a8c80 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -152,7 +152,12 @@ smb2_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 		    (li->offset + li->length))
 			continue;
 		if (current->tgid != li->pid)
-			continue;
+			/*
+			 * flock and OFD lock are associated with an open
+			 * file description, not the process.
+			 */
+			if (!(flock->fl_flags & (FL_FLOCK | FL_OFDLCK)))
+				continue;
 		if (cinode->can_cache_brlcks) {
 			/*
 			 * We can cache brlock requests - simply remove a lock
-- 
2.20.1


