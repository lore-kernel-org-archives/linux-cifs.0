Return-Path: <SRS0=GDvn=WE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A0FC0650F
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Aug 2019 06:49:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3FEA21874
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Aug 2019 06:49:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P6VdDg2M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbfHHGtN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Aug 2019 02:49:13 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:33538 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbfHHGtN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Aug 2019 02:49:13 -0400
Received: by mail-pf1-f170.google.com with SMTP id g2so43534826pfq.0;
        Wed, 07 Aug 2019 23:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=3+NFfpGoY8/VELtwuYcVz4gVk+9W0Op7U8Nujrt53LI=;
        b=P6VdDg2MP+9+kORH+ip2nwC13Fpje22BxthOM/9h8STcWscAa1yDkWPPPaHovrDdTe
         o0dFrR/mgR++8PPYpdT05PBCo3RMe0mHUy+LkoxNbK2S0dx6ZU+vo14WNZoA/WOeXIHp
         p+VWIfb7jFcjnncghZq0b0fXgYkaHmj4V571lfZMQZX5pRm/1vqsWEgzprapvlirkCe9
         mk7eEKgwIzqDwfBZI8qkrwpJFMs+wcR8FyO91ItiLDAkbS/dRmo+vKdBX86D5dcs65Vm
         gALFSPX74pcaqazmbLe1/n2FirEoTbVn2vCyg3JVEqN6HJsWwnxTXKs3IQlDlUVNnsI3
         UIIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=3+NFfpGoY8/VELtwuYcVz4gVk+9W0Op7U8Nujrt53LI=;
        b=Dg6az7HY+CEQ5QfcvuWk6WzzQ2hzDZb6xYCtU3VwRwr4PNmxvP5JhU2NavBxjz5d7d
         xcaEdFXv4PFYMt3gIJJqtlgT6vUdkdR5woXxHOr1rl3ou1IP+bp6l0If8l3/NGrp8UVI
         ndRFz1lBfogsLhmZpU0nmXeNSVOQlWzCWxmfpX5cbCKI2OkfE+TRCT9jG36JZTdKJlL8
         azsyS7AmmmU2KjeH+FwmfIB034i/NO7j4yPpMuU4DRHefvfVazP0QgvsB8jd6DPBcVkz
         YnO+wpS45eFsXbertbvtdhvJnvJJ8SQhaoMgPCAofUeJPIgM2Dw19A+7e2pfISH1QVJ+
         0EtQ==
X-Gm-Message-State: APjAAAUNm7poi35WRBGwvB4M8Y59nOf/aio5u8Z6xOahrPD1T2Q1UvMZ
        +qLEz+j7QsnFcUzZK99Wq7Q/d4dxQDDZ5zWiT+uW2+rbGhU=
X-Google-Smtp-Source: APXvYqw+4E+v/5HJq/8MKu2sX8Ia3jyx1gaDAYr5/v2TePUYlod/4L6QKth640WbehsSOsY+gBjJQgwofyebZ011Gkk=
X-Received: by 2002:a17:90a:360c:: with SMTP id s12mr2505968pjb.30.1565246952007;
 Wed, 07 Aug 2019 23:49:12 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 8 Aug 2019 01:49:01 -0500
Message-ID: <CAH2r5ms07ipgU=g7pT_YpNmXQ_rW8KG0buFv=pag46V9qCX01Q@mail.gmail.com>
Subject: [GIT PULL] SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
e21a712a9685488f5ce80495b37b9fdbe96c230d:

  Linux 5.3-rc3 (2019-08-04 18:40:12 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.3-rc3-smb3-fixes

for you to fetch changes up to ee9d66182392695535cc9fccfcb40c16f72de2a9:

  SMB3: Kernel oops mounting a encryptData share with
CONFIG_DEBUG_VIRTUAL (2019-08-05 22:50:38 -0500)

----------------------------------------------------------------
six small SMB3 fixes, two for stable

----------------------------------------------------------------
Pavel Shilovsky (2):
      SMB3: Fix deadlock in validate negotiate hits reconnect
      SMB3: Fix potential memory leak when processing compound chain

Sebastien Tisserant (1):
      SMB3: Kernel oops mounting a encryptData share with CONFIG_DEBUG_VIRTUAL

Steve French (3):
      cifs: fix rmmod regression in cifs.ko caused by force_sig changes
      smb3: send CAP_DFS capability during session setup
      smb3: update TODO list of missing features

 Documentation/filesystems/cifs/TODO | 26 ++++++++++++++++----------
 fs/cifs/connect.c                   |  1 +
 fs/cifs/smb2ops.c                   | 39
++++++++++++++++++++++++++-------------
 fs/cifs/smb2pdu.c                   |  7 ++++++-
 4 files changed, 49 insertions(+), 24 deletions(-)


-- 
Thanks,

Steve
