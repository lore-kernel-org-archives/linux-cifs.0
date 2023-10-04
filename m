Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4367DE8FDC3
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Oct 2023 01:13:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239246AbjJDBNQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 Oct 2023 21:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232316AbjJDBNQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 3 Oct 2023 21:13:16 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8FFB0
        for <linux-cifs@vger.kernel.org>; Tue,  3 Oct 2023 18:13:13 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d81d85aae7cso376967276.0
        for <linux-cifs@vger.kernel.org>; Tue, 03 Oct 2023 18:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696381992; x=1696986792; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Vov+OjwAGZgpW+sJbWfht9dksDbSHqK3KW37zgfpqdI=;
        b=WWnAHNfWc61NZZUuM2qMIj1LOV9En41kETs79JalCifw5ES4mSlOFtdfousDR/R50l
         rdPzf2ug7a4dTy6xdr+V0TjBM3+XCC9fcRobgX7C0R0VhJQryqrk+LVXNhT5Titx5aMm
         9YBrYBEj8sEmOs+LE8yyhx/oWz5+D3wTXA4C+F4Z/5jn6rvFR4khCdsJekmsPtnXgNo1
         uVnzCYaV0m7XbpsXEeLCZHkNwUfRL6/D8d6QOrFNlda03Uq59bBF2/3h/HH9lNrcHRFS
         wAGKgGpsiUHZBTUUnfzmU0i5z0e8X5kxQScbItQHjdHDEx+vOQKXLN16XJn3z9l/QiW2
         MU/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696381992; x=1696986792;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vov+OjwAGZgpW+sJbWfht9dksDbSHqK3KW37zgfpqdI=;
        b=Vt6f2CFbA8rvMFnw4DeNaEEZlic5ek8yoeC3RHHmPwT7cDNs9DhwWlVsdDgwrfHrND
         sxom5OOi30PTJiXIMkiuPn3Fu+6Fse27Zg5uOZMFyRaBw949Ne9dF/7Znv0l5ZPZgkpp
         /nGXxXUGxq6GiZcLDguU3fXs1NUSW6yJ9Xz7aOZztt7/HZcPZYgAo1T40vm5K9NmcJnw
         OiUBO+HbPcN7MatQvjjHM5ssq8DE3TdU4zpN8dhs1wQBVdhPcIDMrkDfR3GTJ5YEzHeC
         7L4qXyTp6vFWWu+KCbFGdfYUDfDGhyoIhDu07lFGDMrA3IT84/YB39GoSznKWzi83ZwL
         WWKQ==
X-Gm-Message-State: AOJu0YyZfk1yES7CAEIm9JOedE1sbYc6lTDQoF4dMHEkqfVUk6mukTPe
        KTMv2Dz52NmY5p/UE9z4RJA2ifSJmw==
X-Google-Smtp-Source: AGHT+IEXj6lXfUBrlzRw212Zm1JTFqKAIg+J3EbwcNfRJyryRiFJxPoFIWxFKK7aZfNWYvwatpny5enPqg==
X-Received: from jrife.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:9f])
 (user=jrife job=sendgmr) by 2002:a25:14c1:0:b0:d81:5c03:df99 with SMTP id
 184-20020a2514c1000000b00d815c03df99mr16753ybu.3.1696381992379; Tue, 03 Oct
 2023 18:13:12 -0700 (PDT)
Date:   Tue,  3 Oct 2023 20:13:03 -0500
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20231004011303.979995-1-jrife@google.com>
Subject: [PATCH] smb: use kernel_connect() and kernel_bind()
From:   Jordan Rife <jrife@google.com>
To:     sfrench@samba.org, pc@manguebit.com, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Cc:     Jordan Rife <jrife@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Recent changes to kernel_connect() and kernel_bind() ensure that
callers are insulated from changes to the address parameter made by BPF
SOCK_ADDR hooks. This patch wraps direct calls to ops->connect() and
ops->bind() with kernel_connect() and kernel_bind() to ensure that SMB
mounts do not see their mount address overwritten in such cases.

Link: https://lore.kernel.org/netdev/9944248dba1bce861375fcce9de663934d933ba9.camel@redhat.com/
Cc: <stable@vger.kernel.org> # 6.x.y
Signed-off-by: Jordan Rife <jrife@google.com>
---
 fs/smb/client/connect.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 3902e90dca6b0..ce11165446cfb 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2895,9 +2895,9 @@ bind_socket(struct TCP_Server_Info *server)
 	if (server->srcaddr.ss_family != AF_UNSPEC) {
 		/* Bind to the specified local IP address */
 		struct socket *socket = server->ssocket;
-		rc = socket->ops->bind(socket,
-				       (struct sockaddr *) &server->srcaddr,
-				       sizeof(server->srcaddr));
+		rc = kernel_bind(socket,
+				 (struct sockaddr *) &server->srcaddr,
+				 sizeof(server->srcaddr));
 		if (rc < 0) {
 			struct sockaddr_in *saddr4;
 			struct sockaddr_in6 *saddr6;
@@ -3046,8 +3046,8 @@ generic_ip_connect(struct TCP_Server_Info *server)
 		 socket->sk->sk_sndbuf,
 		 socket->sk->sk_rcvbuf, socket->sk->sk_rcvtimeo);
 
-	rc = socket->ops->connect(socket, saddr, slen,
-				  server->noblockcnt ? O_NONBLOCK : 0);
+	rc = kernel_connect(socket, saddr, slen,
+			    server->noblockcnt ? O_NONBLOCK : 0);
 	/*
 	 * When mounting SMB root file systems, we do not want to block in
 	 * connect. Otherwise bail out and then let cifs_reconnect() perform
-- 
2.42.0.582.g8ccd20d70d-goog

