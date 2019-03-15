Return-Path: <SRS0=S2FA=RS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50EBCC43381
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Mar 2019 23:50:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03D992085A
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Mar 2019 23:50:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NogPymSH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbfCOXun (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Mar 2019 19:50:43 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41042 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfCOXun (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 15 Mar 2019 19:50:43 -0400
Received: by mail-pf1-f193.google.com with SMTP id d25so7365797pfn.8;
        Fri, 15 Mar 2019 16:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zmikwNBe1tT4JKm/knzt3ii6qpd05RT/TFRoCn1pKDo=;
        b=NogPymSHX3thzc0Kl6VRLmp3o0oLHW2dotHP3GWFTU6wNIQP5Zafyus8F0VQIpuply
         +gqqf5LS2EjqZ7aGVKyl+FwjXau0eUaPTY0eoGPLJnjI32TxyPW7AD1QXQg6OE7f/Vgp
         lt4URnmIVo5uINoYi1EomfdPx8eHWGIm5NVZFdcsMzuVhqbF+bJwMl+78pO4irM1r3w+
         uVC86XEu/ro+txuYaRZXFk48R973n1TTflzsU4DTV2sh1h/65jd+m0sTAHosP5ES++c0
         HHgAi+Y0foWdI1jqO3YoTHkUlvnw3+yA8SRG/92ImATdTIzu4Eij0whS9JDHtZOGeHho
         JjMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zmikwNBe1tT4JKm/knzt3ii6qpd05RT/TFRoCn1pKDo=;
        b=N3mkiKBCEbKEA+O3/fQ9N1aVNVub1Agbzk9NNou9noF6OQdq5dTDkqkh1JSm4YxMlU
         NTFbHNSb2IffKxrZ6OC5BqhQ5YA3Hf/uNPwGIBusuLHxzhX5tl2hYvF+diIdpX8Hzuif
         grkZaBLms3C8YBcZ3UcPoBpA4LICxzYZQps0lYlTse55xtf/JQOO9U9r9u3aArXdUw2V
         x3N/3WXAvZ9LWcljBZRnXoZ9lqJhqJww75qAKY6BLvYilyhDU3/BqnwUB6I81kFzaO7n
         BGd1BjcMQYSmJZdzAlwVtvqnFwR6OH99lucescX8lPttY3c4rfFIgZgC0eYjKgomraxx
         Rnpw==
X-Gm-Message-State: APjAAAWTjKmwPC5DjjYJIKMz/+/SAu2MVvuL1ZIUaVe1EMakzHKNZp2E
        mATmUD3PoM5c7FYDew8ZKZHaz4z1VJJY7ENP0S7JjowX
X-Google-Smtp-Source: APXvYqxynndly2T+O7e7TLULmpTGytiXs0VLJ7If3TsrzveB6j8KyaBHj+STDnh2hxEMjedu4uSSXClJA/vLNio/Qs4=
X-Received: by 2002:a17:902:822:: with SMTP id 31mr6997542plk.290.1552693842103;
 Fri, 15 Mar 2019 16:50:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvDGcGD=GP+-5984DJ9U_cYLWvkMsJORX4LZ7_1sVKpgw@mail.gmail.com>
In-Reply-To: <CAH2r5mvDGcGD=GP+-5984DJ9U_cYLWvkMsJORX4LZ7_1sVKpgw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 15 Mar 2019 18:50:30 -0500
Message-ID: <CAH2r5mvXXsoa19G=CKDnLfJjZHoqOPYNrhfa1_puuRx07SFKgw@mail.gmail.com>
Subject: Re: [GIT] SMB3 Fixes and debugging improvements
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Previous pull request text was truncated (last 25 lines of text
missing), resending.

Please pull the following changes since commit
f261c4e529dac5608a604d3dd3ae1cd2adf23c89:

  Merge branch 'akpm' (patches from Andrew) (2019-03-14 15:10:10 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.1-rc-smb3

for you to fetch changes up to bc31d0cdcfbadb6258b45db97e93b1c83822ba33:

  CIFS: fix POSIX lock leak and invalid ptr deref (2019-03-14 19:32:36 -0500)

----------------------------------------------------------------
- Various additional dynamic tracing tracepoints
- Debugging improvements (including ability to query the server via
SMB3 fsctl from userspace tools which can help with stats and
debugging)
- One minor performance improvement (root directory inode caching)
- Crediting (SMB3 flow control) fixes
- Some cleanup (docs and to mknod)
- Important fixes: one to smb3 implementation of fallocate zero range
(which fixes three xfstests) and a POSIX lock fix
----------------------------------------------------------------
Aurelien Aptel (2):
      CIFS: make mknod() an smb_version_op
      CIFS: fix POSIX lock leak and invalid ptr deref

Ronnie Sahlberg (11):
      cifs: change wait_for_free_request() to take flags as argument
      cifs: pass flags down into wait_for_free_credits()
      cifs: wait_for_free_credits() make it possible to wait for >=1 credits
      cifs: prevent starvation in wait_for_free_credits for
multi-credit requests
      cifs: add a timeout argument to wait_for_free_credits
      cifs: simplify how we handle credits in compound_send_recv()
      cifs: cache FILE_ALL_INFO for the shared root handle
      cifs: add SMB2_ioctl_init/free helpers to be used with compounding
      cifs: fix smb3_zero_range so it can expand the file-size when required
      cifs: fix incorrect handling of smb2_set_sparse() return in
smb3_simple_falloc
      SMB3: Allow SMB3 FSCTL queries to be sent to server from tools

Steve French (9):
      smb3: display security information in /proc/fs/cifs/DebugData
more accurately
      smb3: add dynamic tracepoint for timeout waiting for credits
      smb3: display volume serial number for shares in /proc/fs/cifs/DebugData
      smb3: Add dynamic trace points for various compounded smb3 ops
      smb3: add dynamic tracepoints for simple fallocate and zero range
      SMB3: passthru query info doesn't check for SMB3 FSCTL passthru
      cifs: remove unused value pointed out by Coverity
      cifs: minor documentation updates
      smb2: fix typo in definition of a few error flags

 Documentation/filesystems/cifs/TODO     |   3 +-
 Documentation/filesystems/cifs/cifs.txt |  34 +++++++----
 fs/cifs/cifs_debug.c                    |  11 +++-
 fs/cifs/cifs_ioctl.h                    |   3 +
 fs/cifs/cifsglob.h                      |  16 ++++-
 fs/cifs/connect.c                       |   4 --
 fs/cifs/dir.c                           | 107 +--------------------------------
 fs/cifs/file.c                          |  14 ++++-
 fs/cifs/smb1ops.c                       | 126
+++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2inode.c                     |  87 ++++++++++++++++++++++++---
 fs/cifs/smb2ops.c                       | 423
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------
 fs/cifs/smb2pdu.c                       | 145
++++++++++++++++++++++++++-------------------
 fs/cifs/smb2pdu.h                       |   7 +++
 fs/cifs/smb2proto.h                     |   7 +++
 fs/cifs/smb2status.h                    |   6 +-
 fs/cifs/trace.h                         | 124
++++++++++++++++++++++++++++++++++++++
 fs/cifs/transport.c                     | 226
+++++++++++++++++++++++++++++++++++++--------------------------------
 17 files changed, 981 insertions(+), 362 deletions(-)

On Fri, Mar 15, 2019 at 6:39 PM Steve French <smfrench@gmail.com> wrote:
>
> Please pull the following changes since commit
> f261c4e529dac5608a604d3dd3ae1cd2adf23c89:
>
>   Merge branch 'akpm' (patches from Andrew) (2019-03-14 15:10:10 -0700)
>
> are available in the Git repository at:
>
>   git://git.samba.org/sfrench/cifs-2.6.git tags/5.1-rc-smb3
>
> for you to fetch changes up to bc31d0cdcfbadb6258b45db97e93b1c83822ba33:
>
>   CIFS: fix POSIX lock leak and invalid ptr deref (2019-03-14 19:32:36 -0500)
>
> ----------------------------------------------------------------
> - Various additional dynamic tracing tracepoints
> - Debugging improvements (including ability to query the server via
> SMB3 fsctl from userspace tools which can help with stats and
> debugging)
> - One minor performance improvement (root directory inode caching)
> - Crediting (SMB3 flow control) fixes
> - Some cleanup (docs and to mknod)
> - Important fixes: one to smb3 implementation of fallocate zero range
> (which fixes three xfstests) and a POSIX lock fix
> ----------------------------------------------------------------
> Aurelien Aptel (2):
>       CIFS: make mknod() an smb_version_op
>       CIFS: fix POSIX lock leak and invalid ptr deref
>
> Ronnie Sahlberg (11):
>       cifs: change wait_for_free_request() to take flags as argument
>       cifs: pass flags down into wait_for_free_credits()
>       cifs: wait_for_free_credits() make it possible to wait for >=1 credits
>       cifs: prevent starvation in wait_for_free_credits for
> multi-credit requests
>       cifs: add a timeout argument to wait_for_free_credits
>       cifs: simplify how we handle credits in compound_send_recv()
>       cifs: cache FILE_ALL_INFO for the shared root handle
>       cifs: add SMB2_ioctl_init/free helpers to be used with compounding
>       cifs: fix smb3_zero_range so it can expand the file-size when required
>       cifs: fix incorrect handling of smb2_set_sparse() return in
> smb3_simple_falloc
>       SMB3: Allow SMB3 FSCTL queries to be sent to server from tools
>
> Steve French (9):
>       smb3: display security information in /proc/fs/cifs/DebugData
> more accurately
>       smb3: add dynamic tracepoint for timeout waiting for credits
>       smb3: display volume serial number for shares in /proc/fs/cifs/DebugData
>       smb3: Add dynamic trace points for various compounded smb3 ops
>       smb3: add dynamic tracepoints for simple fallocate and zero range
>       SMB3: passthru query info doesn't check for SMB3 FSCTL passthru
>       cifs: remove unused value pointed out by Coverity
>       cifs: minor documentation updates
>       smb2: fix typo in definition of a few error flags
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
