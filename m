Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 762C2C19F2B
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Aug 2022 16:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbiHAQEr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Aug 2022 12:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbiHAQEr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Aug 2022 12:04:47 -0400
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C383D581
        for <linux-cifs@vger.kernel.org>; Mon,  1 Aug 2022 09:04:46 -0700 (PDT)
Received: by mail-vk1-xa2a.google.com with SMTP id v13so2957517vke.3
        for <linux-cifs@vger.kernel.org>; Mon, 01 Aug 2022 09:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HxgOkGUAJNt/U5pTqcDz64uHNOpXraWEEEMv0x8gunI=;
        b=FSESMespnPLtdC/8MdHy3sn4z3vRH7VzWxWjcWf3yFO6NLkComa67884MsF1izrJz4
         VFaaTRPPJXs4Nh3xi73rvWB9xejUnSSMwZyD73OGHUUNROHRDIfe+/jSOijPwE/MJHhM
         MxPDOf4Qkq+HYRS/3r1/I8vu1Al56z2FQXpGaBpRUiak8jkhhBrwgZGso4xbaao6qA40
         5dswGpKkKLF+W/LH+JRrk+5nvSFEKoLw+3ol18APeW94YynGmkXsgaOTkSUfdg/ghCw/
         AKYjZqWneMpbrh7r8SQVIASA4Ha2/yqgUjb5SIejnxHOcRJCSVJV2mb1Rj2FCaXq/H1t
         rW1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HxgOkGUAJNt/U5pTqcDz64uHNOpXraWEEEMv0x8gunI=;
        b=ZB/YhDFnN3M/RgTvnGQtixKtRVBhn14wC0KINpf0Pb1EWlAd+fFsQNcew0cLxbROi4
         Lz24/aCrg5SHI5lavoIEvH9cQXJl380LpMl1vDiR2VnYsVGF+/VcXHuTgvIs8Pfqk9zw
         g1YkxE5Bdb9k7tlSZdkcskp9HnFE/C+og1uS+YoCnriM+EwP/9CeirocFWp6vrYrG5ye
         qaBXrEhaS/V3wHyCaVI/O6CKDEQ236K5F6E78Rv9uQ7qA+tqsas63/avb4RCLoSFeDFj
         ba4Z2CK1wi2Z/9v+ODi7FbbgPBJ3ObcVmeqpPdAyDKXOgmkdvj0Y9Ovyl1IzK83QPbCN
         jIrw==
X-Gm-Message-State: ACgBeo1LUXBAODF2cf6T2YOMTyObnel7PYn3lUKTbYnDGQnMYiG8qN+j
        ywmWSWOXlpiAlP6v+13EeCLYbhISKrlDq8it9FvI7s8wNWQ=
X-Google-Smtp-Source: AA6agR7dI65zpBxAOEeLXC4ZpZtZHJWoETe/A5vmb/NQxATHVlBjWCUSG2ylBGm26wr+evvz4+N+u+hlAGQYFqs7xBI=
X-Received: by 2002:a1f:188a:0:b0:377:226b:7cd6 with SMTP id
 132-20020a1f188a000000b00377226b7cd6mr5045571vky.24.1659369885226; Mon, 01
 Aug 2022 09:04:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvX3UT0q50rmMb-WSt6eSxh1i_gcmPdDBW1x1Qn6ppDNg@mail.gmail.com>
 <CAN05THRJTvA7huZjuW-tCPZjk6Nq_8EasjP6kQ0BGMBxBCtgqg@mail.gmail.com> <20220801121507.zpcnz55jj2qre3kh@cyberdelia>
In-Reply-To: <20220801121507.zpcnz55jj2qre3kh@cyberdelia>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 1 Aug 2022 11:04:34 -0500
Message-ID: <CAH2r5muG7tXQGbnR06-cFaooKaEY1F3THL=EVPLNhekduLSOdQ@mail.gmail.com>
Subject: Re: [WIP PATCH][CIFS] move legacy cifs (smb1) code to legacy ifdef
 and do not include in build when legacy disabled
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Aug 1, 2022 at 7:15 AM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> On 08/01, ronnie sahlberg wrote:
> >Small nit : in cifssmb.c  why comment out smb2proto.h,  just delete the line.
>
> Agreed.

Makes sense. Will fix this.


> @Steve also, why ifdef everything instead of putting everything in a
> "smb1" dir and just use Kconfig to build that dir? IOW like I did in in
> my branch https://github.com/ematsumiya/linux/commits/refactor

moving things to smb1 dir seems to be more related to the eventual
move to having two
modules instead of one, e.g. cifs.ko and an smb3.ko (or smbfs.ko or
whatever we call it,
today mounts can do "mount -t smb3" or "mount -t cifs" but we don't
have separate modules for those).
The other reason is that we don't have enough cifs (smb1 only) files
for that to make sense yet.
There are only two smb1 only C files. This patch adds the second one
cifssmb.c (last release I added the
first one smb1ops.c):

cifs-$(CONFIG_CIFS_ALLOW_INSECURE_LEGACY) += smb1ops.o cifssmb.o

We can probably split some headers out, but this step is needed first
(isolating more SMB1/CIFS
code from SMB3 code, and moving it where possible into SMB1/CIFS
specific c files).

> why ifdef everything

Most of the code is in cifssmb.c and smb1ops.c but there are 58 "ifdef
CONFIG_CIFS_ALLOW_INSECURE_LEGACY"
but fewer than 20 of these are distinct functions (those we can move
to cifssmb.c or a new smb1 helper c file) so most
of those require code cleanup in those functions - and most are due to
functions that have hard to read patterns like:

if (smb1 unix extensions) {
           do some smb1 specific stuff which should be in a helper function
           return;
}

call some dialect specific helper function

or similarly smb1 code wedged in dialect neutral code in
file.c/dir.c/inode.c that we need to move e.g.

                if (backup_cred(cifs_sb) && is_smb1_server(server)) {
                        FILE_DIRECTORY_INFO *fdi;
                        SEARCH_ID_FULL_DIR_INFO *si;

                        rc = cifs_backup_query_path_info(xid, tcon, sb,
                                                         full_path,
                                                         &smb1_backup_rsp_buf,
                                                         &data);

Let's do follow on patches to cleanup code like this in file.c/dir.c/inode.c
-- 
Thanks,

Steve
