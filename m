Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9BC0C2B9F4
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Jun 2021 19:05:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAC5D6161F
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Jun 2021 19:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbhFYTIF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 25 Jun 2021 15:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhFYTIE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 25 Jun 2021 15:08:04 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487C5C061574
        for <linux-cifs@vger.kernel.org>; Fri, 25 Jun 2021 12:05:43 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id f30so17991884lfj.1
        for <linux-cifs@vger.kernel.org>; Fri, 25 Jun 2021 12:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=InP6oRCIPiB+HD5DGTbbQNkMuEWrLYsDWMHvun0hZgc=;
        b=kDc0Q/kFHM7vm66aBb3h83rpIhZXfuwDSl1xuF/VSkC8Rpw9G+f4yTKk45t/cqerCS
         cFBdPuZh4PtxHLpgutiHPAi0tNu3nbuJt5dT5bHmFlihOeDa8T0hhIR52PLHpIOoy4Nt
         VOK6hTCKqxULfkAiGgggXLLuxucLSjR0lVXVm7kGioddWd68OkE+HpPBGeXTz+RMTaQd
         R3m3ME8JbGSo7oTIn3Nuymo6kD4cGzRo8WRg5xRW8I32MZ5AHi9pjoaglQvI/wOEA5ek
         ZERyhogzRU+jdgpkMus4A8Cqs6mB8sW+saFDKcggS5E2OiNFaIS2JCTk8hH9KK6uXa+/
         zpUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=InP6oRCIPiB+HD5DGTbbQNkMuEWrLYsDWMHvun0hZgc=;
        b=TpKwfQWz8zOGMdXqBdNfTIrDst/WgLVK98x8eVgCkfx3t8G52T309cans8zskaGUDn
         QbC/V6IJCf2Xxgr7t8bpGM4CLcyaAFi3RmKx96fx2TC/YpqL/7iA96710xu8UaHZvErL
         IRu5WYUxPvvZHo81agu21Eet0xGxcv9mZ0+L/QzHNAt9L7RyvApovNKe9Z/gSXErfoXw
         je1FbVcFqkU0EfGSXY7DIGrryyii/UpiR3eScKSatWF5u1wEtjq98F78H/d9LEEWRrjj
         c5dEdhMXOp9HrGK993OeJaaeDFnfp03Q8T5k+q4qYmdT6YNlPvXXXiueY1IdB0GpvPOD
         meiQ==
X-Gm-Message-State: AOAM531LAzG23w0YGOqnXYnz47e0mSikhX74wRup3vLPPeMyDO8j5UHh
        4GnoehYgd2AxGe49gtJs8x0bTEsJzOsCgaPn26xdP9L4tPcWSg==
X-Google-Smtp-Source: ABdhPJyjmyXVYjZvIZ/IndRCPZJTGNZ11ub++/GQzz8Bm2kG5Z7jp1xx6G1S5r51gXrdDS2yTr0VEIhX4xIYni36fZw=
X-Received: by 2002:a19:6712:: with SMTP id b18mr9355741lfc.184.1624647941106;
 Fri, 25 Jun 2021 12:05:41 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 25 Jun 2021 14:05:30 -0500
Message-ID: <CAH2r5msPAUhfb-4LxYgLXT-XpP32z84QtK11yTJLGpnPZ1edmA@mail.gmail.com>
Subject: [SMB3][PATCH] address minor Coverity warning
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

    There was one place where we weren't locking CurrentMid, and although
    likely to be safe since even without the lock since it is during
    negotiate protocol, it is more consistent to lock it in this last remaining
    place, and avoids confusing Coverity warning.

    Addresses-Coverity: 1486665 ("Data race condition")
    Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index fc6b08e5ebbc..3100f8b66e60 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -621,7 +621,7 @@ struct TCP_Server_Info {
        /* SMB_COM_WRITE_RAW or SMB_COM_READ_RAW. */
        unsigned int capabilities; /* selective disabling of caps by smb sess */
        int timeAdj;  /* Adjust for difference in server time zone in sec */
-       __u64 CurrentMid;         /* multiplex id - rotating counter */
+       __u64 CurrentMid;         /* multiplex id - rotating counter,
protected by GlobalMid_Lock */
        char cryptkey[CIFS_CRYPTO_KEY_SIZE]; /* used by ntlm, ntlmv2 etc */
        /* 16th byte of RFC1001 workstation name is always null */
        char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
@@ -1786,6 +1786,7 @@ require use of the stronger protocol */
  *      updates to XID counters, multiplex id  and SMB sequence numbers
  *      list operations on global DnotifyReqList
  *      updates to ses->status
+ *      updates to server->CurrentMid
  *  tcp_ses_lock protects:
  *     list operations on tcp and SMB session lists
  *  tcon->open_file_lock protects the list of open files hanging off the tcon
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 903de7449aa3..e4c8f603dd58 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -388,7 +388,9 @@ smb2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 {
        int rc;

+       spin_lock(&GlobalMid_Lock);
        cifs_ses_server(ses)->CurrentMid = 0;
+       spin_unlock(&GlobalMid_Lock);
        rc = SMB2_negotiate(xid, ses);
        /* BB we probably don't need to retry with modern servers */
        if (rc == -EAGAIN)


-- 
Thanks,

Steve
