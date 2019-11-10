Return-Path: <SRS0=Ir9r=ZC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1861DC43331
	for <linux-cifs@archiver.kernel.org>; Sun, 10 Nov 2019 08:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2A28214E0
	for <linux-cifs@archiver.kernel.org>; Sun, 10 Nov 2019 08:10:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c0XCcM2J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfKJIKc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 10 Nov 2019 03:10:32 -0500
Received: from mail-il1-f175.google.com ([209.85.166.175]:36417 "EHLO
        mail-il1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbfKJIKc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 10 Nov 2019 03:10:32 -0500
Received: by mail-il1-f175.google.com with SMTP id s75so9022219ilc.3;
        Sun, 10 Nov 2019 00:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=kRZmCipwDsQk91sCAu9l8eO02sUQNlc3bd6U2hHhR04=;
        b=c0XCcM2JqOg6gg+5MnGuXGXFf2CcWeuTkdSQOQvfnG09IADPkrTp/P8c7QiaGt3Zd3
         y6fKO0n0YxW1z5q50F2+rgS6oRs19evVc/pzO54GCIhNod1B2cNyLIhKfLolw3F+k0vZ
         lJWTMML79jQtSZ8zBUMy44MgUoo7bLFOBXtEFLvCXG/rtf/rl/abuO9364CRHuDIMsHZ
         exSItXbMY+grWYPAwKwWJv3vvsU8pBFcodWZBwi0P5+WhsgZIosh22OzTBE+DWk/hYku
         WbFQlkCTEhTiWURKcI8Su1uv2HP3NoK/AR7Ma8SW/DMfC+bloRlTcfeKVYWjnxFRdDGj
         s5GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=kRZmCipwDsQk91sCAu9l8eO02sUQNlc3bd6U2hHhR04=;
        b=pZmTTp6TJZBN8PcOCwaFAlvpRILIiypr2ucn4XpWav7AVgeb4dKLHjZFkpI+gQzrNn
         n7C6VXUdnDjHyQZr+19kjGPg3YN5yxn6Ci1vdvUQBCi1gKJqU1798CY7AxyCs1QhLkPQ
         oB91B9aeoYcuYHjqNr5FPU5QI0Xh+J75u8/Esb+KMkmz3RrAJw6tuGcgpRGSSFJ34FOh
         G7cETWYJPEn92/gy7KXDAkdPqYUY+ltXyM5A5cNbiDweqAfV0V2unJRJBCp0QLGVzw5J
         eC5RzIdCPCX2T/qnahdcX+ROJCJM430rMNoQxUBdAgEkuPetYcpy1MD8xLuAMQmVK3pD
         NXbA==
X-Gm-Message-State: APjAAAXL1roxRFCSoysLgb6vl7Wv5ebMi2L5W7+Q1kL88pYpPx/KKJY6
        cHuwIxMZOJzXk5Kr7xpJRVp+bEWGwm0nN/R9MMATw2/V
X-Google-Smtp-Source: APXvYqz2PM0g2SHocmQVYLADpZooUmSNBq9ZCqBCNeF/mxd61dngNqtOavPQyhA9FojbrdMAWliKDea0yNsmfCG2WBQ=
X-Received: by 2002:a92:8b4e:: with SMTP id i75mr22210986ild.5.1573373429640;
 Sun, 10 Nov 2019 00:10:29 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 10 Nov 2019 02:10:18 -0600
Message-ID: <CAH2r5muiDNRJJGnrmdcE=MG5SQvjau=J7sG4CJGUzAe9KpW1bQ@mail.gmail.com>
Subject: [GIT PULL] SMB3 Fix
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
a99d8080aaf358d5d23581244e5da23b35e340b9:

  Linux 5.4-rc6 (2019-11-03 14:07:26 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.4-rc7-smb3-fix

for you to fetch changes up to d243af7ab9feb49f11f2c0050d2077e2d9556f9b:

  SMB3: Fix persistent handles reconnect (2019-11-06 21:32:18 -0600)

----------------------------------------------------------------
small fix for an smb3 reconnect bug
(also marked for stable)

----------------------------------------------------------------
Pavel Shilovsky (1):
      SMB3: Fix persistent handles reconnect

 fs/cifs/smb2pdu.h | 1 +
 1 file changed, 1 insertion(+)


--
Thanks,

Steve
