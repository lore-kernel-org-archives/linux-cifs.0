Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21006C433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Dec 2021 09:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbhLCJdH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Dec 2021 04:33:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234623AbhLCJdG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 3 Dec 2021 04:33:06 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191AEC06173E
        for <linux-cifs@vger.kernel.org>; Fri,  3 Dec 2021 01:29:43 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id g14so8893393edb.8
        for <linux-cifs@vger.kernel.org>; Fri, 03 Dec 2021 01:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=+fTpQsiVspdrwNhGEHy3nxuV6g89hhbjw8PRloN3S0g=;
        b=f6TsAsAN6Cs/9zs/4DyXdb9acto5keUWk/uFtNElLW+I2ugFO4x3zt7Tf4GMV4bELE
         wjJF72l0APTy0RlRJt9U7ZTUEXxPjWifAfYrMXdl7MaykJ+Wzoa6rflBuaxzOFkXWGhp
         VW78yRHcHHoXeX54mxuVfoS57grq+EYmyS80MFb3BH6BFdi5XMQsRKtj0PGdqzFd2jj6
         aQrXy1PQL94TUB8wuOW6ewGaCwGXFaGBSlVp5Y5Kh8F6/cHOZqujAKUR2KC5AtD/EUZQ
         qeIcj/3escq/IByB9EUIlKT/VWRnohEJ5UvqwzT6avClwsC2GJRnH8HywfK5AMpn2Vip
         37iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=+fTpQsiVspdrwNhGEHy3nxuV6g89hhbjw8PRloN3S0g=;
        b=dQcz+1sFDdF/NT1Za6Sp8EALC3FpXEFawkMAIJLKCAm1PltH3NeIrAlFTpXYSSp+6W
         kEEjMoa3b2NASvHrtIpB6RZorAOnHxIoN2Fin25nDJlBg57AUIrnhoVmCVzyqUec8BEE
         O2EKeLmANtqUUi3DO99OlxwrpGuTBGECkgQZCGghYs6YWLICf+M5dmlZsv/j6aijtA2s
         TpxNZllQG1tB9TpmMdEAsHCI/lR8ewwsnYhs9PAJNhLSdWOwlemNpRT6H0/x6hLpwu9E
         5qaFFmczg65WtEzoNapavKWEkuLxkIk3er1g81y0VqCzpzTseBTmzp/vnp14TqLUutVo
         loog==
X-Gm-Message-State: AOAM531/ugTjzGL3uJJN73ZDzw5lCsQhcHjWPgEVNONNkoIxYOWRh4hn
        pJoMgLVHyh0JaNUyUHTMLftgqraR0/S0ZrbK7q8LHenWnqVdvyK8
X-Google-Smtp-Source: ABdhPJz3t08bFdTixoOJSVOQ+knQee+tCLa2FLW5z74Q5D9T14EIKfiObOlnKXdZ9e8ZrziKU36l59t2KEKFHMkWV5E=
X-Received: by 2002:a05:6402:1292:: with SMTP id w18mr25097887edv.46.1638523781628;
 Fri, 03 Dec 2021 01:29:41 -0800 (PST)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 3 Dec 2021 14:59:30 +0530
Message-ID: <CANT5p=oTtfOJxq009jzGLEWxztShPa3cORzHjriO2DNRU8KDtA@mail.gmail.com>
Subject: [PATCH] cifs: avoid use of dstaddr as key for fscache client cookie
To:     David Howells <dhowells@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        CIFS <linux-cifs@vger.kernel.org>, linux-cachefs@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

server->dstaddr can change when the DNS mapping for the
server hostname changes. But conn_id is a u64 counter
that is incremented each time a new TCP connection
is setup. So use only that as a key.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/cifs/fscache.c | 38 +-------------------------------------
 1 file changed, 1 insertion(+), 37 deletions(-)

diff --git a/fs/cifs/fscache.c b/fs/cifs/fscache.c
index 1db3437f3b7d..003c5f1f4dfb 100644
--- a/fs/cifs/fscache.c
+++ b/fs/cifs/fscache.c
@@ -16,14 +16,6 @@
  * Key layout of CIFS server cache index object
  */
 struct cifs_server_key {
- struct {
- uint16_t family; /* address family */
- __be16 port; /* IP port */
- } hdr;
- union {
- struct in_addr ipv4_addr;
- struct in6_addr ipv6_addr;
- };
  __u64 conn_id;
 } __packed;

@@ -32,11 +24,7 @@ struct cifs_server_key {
  */
 void cifs_fscache_get_client_cookie(struct TCP_Server_Info *server)
 {
- const struct sockaddr *sa = (struct sockaddr *) &server->dstaddr;
- const struct sockaddr_in *addr = (struct sockaddr_in *) sa;
- const struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *) sa;
  struct cifs_server_key key;
- uint16_t key_len = sizeof(key.hdr);

  /*
  * Check if cookie was already initialized so don't reinitialize it.
@@ -47,36 +35,12 @@ void cifs_fscache_get_client_cookie(struct
TCP_Server_Info *server)
  return;

  memset(&key, 0, sizeof(key));
-
- /*
- * Should not be a problem as sin_family/sin6_family overlays
- * sa_family field
- */
- key.hdr.family = sa->sa_family;
- switch (sa->sa_family) {
- case AF_INET:
- key.hdr.port = addr->sin_port;
- key.ipv4_addr = addr->sin_addr;
- key_len += sizeof(key.ipv4_addr);
- break;
-
- case AF_INET6:
- key.hdr.port = addr6->sin6_port;
- key.ipv6_addr = addr6->sin6_addr;
- key_len += sizeof(key.ipv6_addr);
- break;
-
- default:
- cifs_dbg(VFS, "Unknown network family '%d'\n", sa->sa_family);
- server->fscache = NULL;
- return;
- }
  key.conn_id = server->conn_id;

  server->fscache =
  fscache_acquire_cookie(cifs_fscache_netfs.primary_index,
        &cifs_fscache_server_index_def,
-       &key, key_len,
+       &key, sizeof(key),
        NULL, 0,
        server, 0, true);
  cifs_dbg(FYI, "%s: (0x%p/0x%p)\n",
