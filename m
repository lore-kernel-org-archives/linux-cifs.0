Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1529C433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Dec 2021 09:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbhLCJcK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Dec 2021 04:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232207AbhLCJcK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 3 Dec 2021 04:32:10 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98867C06173E
        for <linux-cifs@vger.kernel.org>; Fri,  3 Dec 2021 01:28:46 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id x6so8959817edr.5
        for <linux-cifs@vger.kernel.org>; Fri, 03 Dec 2021 01:28:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=wR2mAEloXpBDlp4jpjzUYz+sRB/xAPIS4tW3XUdXFAU=;
        b=GHedDiuxi2kV5cZ3gMz9vKxkN09xWsZrbeNqNpxB1v2s0mFlBc4xyfDeTK4O2wmpUs
         t764ffQ5r9zfCoQYOPqsdNtCokJo8RG9Di7nAIxHT7bLyp8DDLhDEXiS258BiIz4n70y
         WPJZOclSo6JiU5J0IAAHya7uUM0XyJVUkWcWyKDiTrBqqceJKib+yqSrIUhUUCVDQ61s
         Pkx9vHBvQpESrbwGcGlpOWsGf6AUuBwpba7Cdfqc+6NcJCOzjHHwEk1jHQjhRaWqq1EK
         k53uKjp6LCUtZlJm4duN+LDTBM7a2Lqs6luglja43gDliRfCIFZKFVaNVnC6+QI8kWVe
         Agbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=wR2mAEloXpBDlp4jpjzUYz+sRB/xAPIS4tW3XUdXFAU=;
        b=k+rnMKjftSqqGzFtzfSBtRrzvNa4bXA4I28qcganVNMPoQ/DNAYR2eRgbZxcvUP1T6
         QLKBrUCMyCB3D66PpYVO09cwrvE0hBf7BEywTrdMdBvN5Iwn3llZ6vuvjr6gg+j29oiA
         m5UpA7Xivybo7moghtWiVG+GlmRqJg7dxmC5je23lXZ7oQZJupA5KoTdch9XrP9isYte
         +zUYDcXo0wYRZGRucbXg8+UgT2h/lek04CF8mbLdDtvQZUdRErMzOv4/GdrtPCAxWVjh
         ZzIP0iouL5BNRLC/rOpB8/hdS52XXk4J2IvP5ZRSlrhlXDIcRtP8suO0eF7/5BrRKxG6
         3hAQ==
X-Gm-Message-State: AOAM531hTMS0p+GfqwqGHsSEqQuRsm00iZStw9IeBcpk10V8/u9Ecbo4
        LsIwkc+NURMGAJC/S+bsDw0mrQMJ85JIy72dfms=
X-Google-Smtp-Source: ABdhPJwlyYsScxu5SYzQUpxyXGoKxflMI2V0i0MJ+VvxizUlVcTbJ0uDwP9uvZ5UvHQW5x6Xz2O8XSjtxlZwu6Yobog=
X-Received: by 2002:a05:6402:1613:: with SMTP id f19mr25009787edv.322.1638523725102;
 Fri, 03 Dec 2021 01:28:45 -0800 (PST)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 3 Dec 2021 14:58:34 +0530
Message-ID: <CANT5p=pqb7MmFe+kQU67Eytm98tZB1ztr0d5Rwq44oxAq81+Dw@mail.gmail.com>
Subject: [PATCH] cifs: add server conn_id to fscache client cookie
To:     David Howells <dhowells@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        CIFS <linux-cifs@vger.kernel.org>, linux-cachefs@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The fscache client cookie uses the server address
(and port) as the cookie key. This is a problem when
nosharesock is used. Two different connections will
use duplicate cookies. Avoid this by adding
server->conn_id to the key, so that it's guaranteed
that cookie will not be duplicated.

Also, for secondary channels of a session, copy the
fscache pointer from the primary channel. The primary
channel is guaranteed not to go away as long as secondary
channels are in use.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/cifs/connect.c |  2 ++
 fs/cifs/fscache.c | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index eee994b0925f..d8822e835cc4 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1562,6 +1562,8 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
  /* fscache server cookies are based on primary channel only */
  if (!CIFS_SERVER_IS_CHAN(tcp_ses))
  cifs_fscache_get_client_cookie(tcp_ses);
+ else
+ tcp_ses->fscache = tcp_ses->primary_server->fscache;

  /* queue echo request delayed work */
  queue_delayed_work(cifsiod_wq, &tcp_ses->echo, tcp_ses->echo_interval);
diff --git a/fs/cifs/fscache.c b/fs/cifs/fscache.c
index f4da693760c1..1db3437f3b7d 100644
--- a/fs/cifs/fscache.c
+++ b/fs/cifs/fscache.c
@@ -24,6 +24,7 @@ struct cifs_server_key {
  struct in_addr ipv4_addr;
  struct in6_addr ipv6_addr;
  };
+ __u64 conn_id;
 } __packed;

 /*
@@ -37,6 +38,14 @@ void cifs_fscache_get_client_cookie(struct
TCP_Server_Info *server)
  struct cifs_server_key key;
  uint16_t key_len = sizeof(key.hdr);

+ /*
+ * Check if cookie was already initialized so don't reinitialize it.
+ * In the future, as we integrate with newer fscache features,
+ * we may want to instead add a check if cookie has changed
+ */
+ if (server->fscache)
+ return;
+
  memset(&key, 0, sizeof(key));

  /*
@@ -62,6 +71,7 @@ void cifs_fscache_get_client_cookie(struct
TCP_Server_Info *server)
  server->fscache = NULL;
  return;
  }
+ key.conn_id = server->conn_id;

  server->fscache =
  fscache_acquire_cookie(cifs_fscache_netfs.primary_index,
