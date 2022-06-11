Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91FBDC43334
	for <linux-cifs@archiver.kernel.org>; Sat, 11 Jun 2022 16:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbiFKQi6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 11 Jun 2022 12:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbiFKQi5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 11 Jun 2022 12:38:57 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1B513A;
        Sat, 11 Jun 2022 09:38:56 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id e20so2067068vso.4;
        Sat, 11 Jun 2022 09:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=T0+fsFmOup/o09KuIuGw1PBADlVzWVKCMk9v2xQnxN4=;
        b=ST2X0WFBxlhScFYIaEi0r3xQx3Q6gyso1QHyqjqM28ZdEwQzGXGPLYJJdsG8ORPfHX
         u2uTX+w25lme/FUEYMyIpD1x3RKq9jsZd7Rz3XrF3T+Qp66Mb6Zwz8UZBHae2PrG6pr1
         bYeOIywpBwYa3wOmLHaHXZHHcjzuP8p1/s1w15YSDQwIEmCuTZVPd6bBcDGtQpcS4hw2
         etGMWQ+2ZAy8zXynH1q18j5pbc/vcJDyYzmKaMOS33ITgACZnnHK8il+ZOof/fMQS6gk
         6uBrehNDMQFcMJP4FaM1EMgv4HWu8j1eiVFKqomM7WmO6U+gnVDhxnPcAzq7Nst0/aCl
         1L3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=T0+fsFmOup/o09KuIuGw1PBADlVzWVKCMk9v2xQnxN4=;
        b=W2yT7IPs+ETgj7TL8TLqtMzIK6liP7i9Y+Tllm4a3Ay2xmv0wdUhBN3R6Pj5v89RI5
         sNXlVdyx0lx+BWJO9aK8cn9K1azTHJ8o8OwTSb8t9PfY7w5FMxYyawR7jFnp3Sl0Qeez
         Uz1EyeHBVBCH64teuHbllV2Vd2MtOex2zog6T9c6GwlQMIeWJes0VKYlqrq5Y912PKOT
         4bXKdLKQ0IR5kKrvgXcmZOtu+tXr5HAp51pnu0Ab6RwMm4vedv1IgPl9kRaE4YqNARcp
         VwUPvGwMZ0MbE9/iP4si7ApzjO7X6jr8eFfx8O66idKmdIhx9gvLzFpSp9f8BwZahInN
         WlKQ==
X-Gm-Message-State: AOAM533yQzRFf4P/zjBX4CHxT/Y7TdHPoLu0CC7n7Gofe71cuX4RAHA7
        rFqbJCq/6QAsdMt3v3SgLZev3nHTgBNxtEmp3OxqCdl7iV4=
X-Google-Smtp-Source: ABdhPJwtaRvw4iYPzBjhQNX3R1G/D1yZqCexlLnLSbSBIQyYpOIFcSqrHrCECYwtfGnJCbFt8pUAR9VUdmPnd+WHKlI=
X-Received: by 2002:a05:6102:5090:b0:34b:c270:436e with SMTP id
 bl16-20020a056102509000b0034bc270436emr13503080vsb.61.1654965535754; Sat, 11
 Jun 2022 09:38:55 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 11 Jun 2022 11:38:45 -0500
Message-ID: <CAH2r5msLEuGjB+JQBHF34AG+hx4szrzYsT1A=mj7Rmn7Y_r5FQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
f2906aa863381afb0015a9eb7fefad885d4e5a56:

  Linux 5.19-rc1 (2022-06-05 17:18:54 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.19-rc1-smb3-client-fixes

for you to fetch changes up to 4c14d7043fede258957d7b01da0cad2d9fe3a205:

  cifs: populate empty hostnames for extra channels (2022-06-10 18:55:02 -0500)

----------------------------------------------------------------
3 smb3 reconnect fixes, all for stable as well

One of these three reconnect fixes does address a problem with
multichannel reconnect,
but this P/R does not include the additional fix (still being tested)
for dynamically
detecting multichannel adapter changes which will improve those
reconnect scenarios
even more.
----------------------------------------------------------------
Paulo Alcantara (1):
      cifs: fix reconnect on smb3 mount types

Shyam Prasad N (2):
      cifs: return errors during session setup during reconnects
      cifs: populate empty hostnames for extra channels

 fs/cifs/cifsfs.c  |  2 +-
 fs/cifs/cifsfs.h  |  2 +-
 fs/cifs/connect.c |  4 ++++
 fs/cifs/misc.c    | 27 ++++++++++++++++-----------
 fs/cifs/sess.c    |  5 ++++-
 fs/cifs/smb2pdu.c |  3 +++
 6 files changed, 29 insertions(+), 14 deletions(-)


-- 
Thanks,

Steve
