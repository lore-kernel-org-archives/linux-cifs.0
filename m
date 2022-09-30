Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D12F0C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Sep 2022 03:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiI3DMT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 23:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiI3DMR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 23:12:17 -0400
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3A51C4319
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 20:12:14 -0700 (PDT)
Received: by mail-vk1-xa2d.google.com with SMTP id s192so1633366vkb.9
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 20:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=VnjTkK2kDCU5pBamk5ZVWRiR2dFuw6IDVrXYkzwbwIQ=;
        b=SoiqEvPYcG5/aLp7ZXMmCgvRZ1ehRLhYojYViSbj7cDqNrburE9L6M337r1myahU3R
         Kdz+hKWGme83diY6Go4UNQtvXP+1GJNOMf9JG6yx1YcDC/BtZsFQ+3S73G2HR+P3hkNh
         SpvkA5RcMp94TuBEPtmDkX6sc4+8R+1hhBR+BOEGNM9BZyazEP2ds2zPka/J3UgwIAKS
         6ecULMiHqSY9TMuZX+q66QiAi5D9N+Bs3YUSP1eBQYTt48DD3IYIbfprvRQWKCAKMYNW
         /xxf75u+7N8POv48sUxEKH5Jv26Gzoj4QdeSRHBKkuHnuk21wvFeJVfYkQngn3/+e881
         x32g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=VnjTkK2kDCU5pBamk5ZVWRiR2dFuw6IDVrXYkzwbwIQ=;
        b=24sIADUQ/N3lba1lfhN5S++iy7R2IIf2ZAM6RPF2j5SrZmgANtki14Ymxr0er8eqDu
         cVYzLQY92W4jf9Wb/Pdlj9rKCtsGOF6vajK2PVf0PNeDa7P/8nOwks4ES91Sw3U16CXu
         /nCRYn/cjV75JLwcplWMupPHfeSfS6yEqwnFmg0w780LSg6QgRYq/8tHSfqO38/zS17K
         F3Q/1KZFIYjTgCLCovuMg2AFOFkuiMDLFKIEgdsIK/C8TLq22WCh9nXEJRI7bJ//oaYY
         xDuYJ9ubvnaAapfHuYnr2i0JN+JZsoA2bhSpRxAhxs2hRKuMv4qmlatyJwBg2bZ4S6PW
         FrCg==
X-Gm-Message-State: ACrzQf0ILxWc17Fmpom2aR2PcfbLn+2wDxetpXMhq72Le+bilBxcH+kN
        4ckXnGeGzI/Tgy/wdsJWAAXUb0ruwtrPds6HbFU=
X-Google-Smtp-Source: AMsMyM7Y322g7Qu1K/8Ur3f49lK0hzyqr9IIBMpdU8LYkrlL+117vJ5cSGGscxVsVzknhFboZlfTBOSd3I5HeDOtCuM=
X-Received: by 2002:a1f:918d:0:b0:3a1:e376:7463 with SMTP id
 t135-20020a1f918d000000b003a1e3767463mr3280348vkd.38.1664507533184; Thu, 29
 Sep 2022 20:12:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220929203652.13178-1-ematsumiya@suse.de> <CAH2r5mtJXYgQro1AgUD+A1fBq6SNNyYYS3KGCJFNj=711RroGg@mail.gmail.com>
In-Reply-To: <CAH2r5mtJXYgQro1AgUD+A1fBq6SNNyYYS3KGCJFNj=711RroGg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 29 Sep 2022 22:12:02 -0500
Message-ID: <CAH2r5mvsHd84-VNw550tZA+y2wPPiY54rQbCKs6ezpaS6QWqgQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] cifs: introduce support for AES-GMAC signing
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, tom@talpey.com, metze@samba.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

xfstest run begun with this gmac signing patch series to see if any
other bugs come up

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/1041

On Thu, Sep 29, 2022 at 10:03 PM Steve French <smfrench@gmail.com> wrote:
>
> improved ... but I see an out of memory error when I do this:
>
> # dd if=/dev/zero of=/mnt1/file bs=4M count=1
> dd: closing output file '/mnt1/file': Cannot allocate memory
> # dmesg
> [  439.674953] CIFS: VFS: \\localhost smb311_calc_aes_gmac: Failed to
> compute AES-GMAC signature, rc=-12
>
> Attached is the trace-cmd output
>
> Will also run some xfstests with this v4 series
>
>
> On Thu, Sep 29, 2022 at 3:36 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
> >
> > v4:
> > Patches 3/8 and 6/8:
> >   - fix checkpatch errors (thanks to Steve)
> >
> > Patch 5/8:
> >   - rename smb311_calc_signature to smb311_calc_aes_gmac, and use SMB3_AES_GCM_NONCE
> >     instead of hardcoded '12' (suggested by metze)
> >   - update commit message to include the reasoning to move ->calc_signature op
> >
> > Patch 8/8:
> >   - move SMB2_PADDING_BUF to smb2glob.h
> >   - check if iov is SMB2_PADDING_BUF in the free functions where
> >     smb2_padding was previously used (pointed out by metze)
> >
> > Enzo Matsumiya (8):
> >   smb3: rename encryption/decryption TFMs
> >   cifs: secmech: use shash_desc directly, remove sdesc
> >   cifs: allocate ephemeral secmechs only on demand
> >   cifs: create sign/verify secmechs, don't leave keys in memory
> >   cifs: introduce AES-GMAC signing support for SMB 3.1.1
> >   cifs: deprecate 'enable_negotiate_signing' module param
> >   cifs: show signing algorithm name in DebugData
> >   cifs: use MAX_CIFS_SMALL_BUFFER_SIZE-8 as padding buffer
> >
> >  fs/cifs/cifs_debug.c    |   7 +-
> >  fs/cifs/cifsencrypt.c   | 157 ++++-------
> >  fs/cifs/cifsfs.c        |  14 +-
> >  fs/cifs/cifsglob.h      |  70 +++--
> >  fs/cifs/cifsproto.h     |   5 +-
> >  fs/cifs/link.c          |  13 +-
> >  fs/cifs/misc.c          |  49 ++--
> >  fs/cifs/sess.c          |  12 -
> >  fs/cifs/smb1ops.c       |   6 +
> >  fs/cifs/smb2glob.h      |  15 ++
> >  fs/cifs/smb2misc.c      |  29 +-
> >  fs/cifs/smb2ops.c       | 102 ++-----
> >  fs/cifs/smb2pdu.c       |  77 ++++--
> >  fs/cifs/smb2pdu.h       |   2 -
> >  fs/cifs/smb2proto.h     |  13 +-
> >  fs/cifs/smb2transport.c | 581 +++++++++++++++++++++-------------------
> >  16 files changed, 577 insertions(+), 575 deletions(-)
> >
> > --
> > 2.35.3
> >
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
