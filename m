Return-Path: <SRS0=Xr0N=2E=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66DD4C43603
	for <linux-cifs@archiver.kernel.org>; Sat, 14 Dec 2019 05:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3542A214AF
	for <linux-cifs@archiver.kernel.org>; Sat, 14 Dec 2019 05:56:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rDn4t7GW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbfLNF4p (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 14 Dec 2019 00:56:45 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:46574 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfLNF4p (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 14 Dec 2019 00:56:45 -0500
Received: by mail-io1-f66.google.com with SMTP id t26so1417700ioi.13;
        Fri, 13 Dec 2019 21:56:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=LFidI9AFv4Sc59cMqoo3XgfplDNLRpBH6YFgxECOIsc=;
        b=rDn4t7GWhJctCGjRAHj+vZMGjFHmxfwZhp7JVQz0xTfK/y6ltDWESQvTq+M3pHs78Y
         hlOOtBqRvv68Z4HcS0RR+QW1HKz2nzSbSNpc7T5HV4Kyaz9NMCRwZB/Ho5IKMikslQzl
         SmJf3yyvf73u+dpGA9hOf5uuIIsoznW4DHU9RCuArcPBxYF0ydv6CwbaHuUzsLDaebcR
         L3v9z8S7tDbW14+yFdTApnQpke7c+RFBTukKlLHJVtaw0DoWQRDCAtsCqloVXQgGcpR5
         TIc5wnPt1Z3M4a1CUjgD3A6lIGk5BTKH+isGxLUn1Uv6xScSHAvhGIbo9yRzWSYI5zdx
         HjkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=LFidI9AFv4Sc59cMqoo3XgfplDNLRpBH6YFgxECOIsc=;
        b=ZWJj6VHmAxJTCPNEtD5rteXnrjtfLoSCZLABJuLwsxiAyqtaR4kejNnQuVWsgDPexU
         BxQBMxcLOWhfV0jmSvvBcEtjmDTntz0cl2ik0oQyCDAUVhMe3AIqj6d8CBwydqed7qNt
         oA0upxmsDxcdrfzV4bJLQhglvQKGD/KTsNSQl3t+IiUdk/NJXmg8KGc1KtneNxDXXzPC
         WVqX3cFAf+PEDQ1nWJ823SdCxS7X42hWQhv6woZvvJaFcvtElZga3PUs2jrE3R6i1aAN
         YEwHQ/rLlOttOc12LwtCOMLaYDHA69EEheoLSaVl5oxJ9IiDjNbl2xvjwAWnWQ0+ARUH
         3tTA==
X-Gm-Message-State: APjAAAXvqsnES609fg6YsmUy3dbXUJFtNwTjp6ShWDjsJSTmrz5pgOXr
        qPbg+16jDSOeYDrWS+z1yLcXymUSn9tCfFO30pthy9aP
X-Google-Smtp-Source: APXvYqwo1og5mmiyAD6wxtlYQHdQ0rNneEJnF1EePAZkOeEPvmRwILkhpaTZhuWwprxWWg46ViUXnYWadqywFApwrXw=
X-Received: by 2002:a5d:939a:: with SMTP id c26mr10287438iol.3.1576303004631;
 Fri, 13 Dec 2019 21:56:44 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 13 Dec 2019 23:56:33 -0600
Message-ID: <CAH2r5msFp3RCtV_YYJSewKRMQFMTMRkEN=wHDEs8MJza162S0A@mail.gmail.com>
Subject: [GIT PULL] 3 small SMB3 fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Arthur Marsh <arthur.marsh@internode.on.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
e42617b825f8073569da76dc4510bfa019b1c35a:

  Linux 5.5-rc1 (2019-12-08 14:57:55 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.5-rc1-smb3-fixes

for you to fetch changes up to d9191319358da13ee6a332fb9bf745f2181a612a:

  CIFS: Close cached root handle only if it has a lease (2019-12-13
00:49:57 -0600)

----------------------------------------------------------------
3 small smb3 fixes:  addresses two recent issues reported in
additional testing during rc1, a refcount underflow and a problem with
an intermittent crash in SMB2_open_init

----------------------------------------------------------------
Pavel Shilovsky (1):
      CIFS: Close cached root handle only if it has a lease

Steve French (2):
      smb3: fix refcount underflow warning on unmount when no directory leases
      SMB3: Fix crash in SMB2_open_init due to uninitialized field in
compounding path

 fs/cifs/cifsglob.h  |  2 +-
 fs/cifs/cifssmb.c   |  3 +++
 fs/cifs/smb2inode.c |  1 +
 fs/cifs/smb2ops.c   | 19 ++++++++++++++++++-
 fs/cifs/smb2pdu.c   |  2 +-
 fs/cifs/smb2proto.h |  2 ++
 6 files changed, 26 insertions(+), 3 deletions(-)


-- 
Thanks,

Steve
