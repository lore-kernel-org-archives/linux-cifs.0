Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82F2CC433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Jan 2021 16:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54BF223447
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Jan 2021 16:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbhAMQcb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Jan 2021 11:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbhAMQcb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Jan 2021 11:32:31 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1F4C061786
        for <linux-cifs@vger.kernel.org>; Wed, 13 Jan 2021 08:31:50 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id d17so3920926ejy.9
        for <linux-cifs@vger.kernel.org>; Wed, 13 Jan 2021 08:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sD2lhDsADmAeG04JHGihoM+wNZgeReacdiuQJB/0XW8=;
        b=TQEXqCKG/geK3330Mymb93JZWysBl827i/2bfcvDU3nFf1BDrkuKhnwZYBxvisn6kG
         YMG3/zAuDa5lait6QhQwgCdGFTP5T627/P5nR922KDZ3J0B3y/Joo0fENgjsfL0aqp8b
         4Qimfhg4JCywuYliPIha6i/G0WooLiEAB2di65aR2S5lnesEgcoiI/sgOByQQj0zJHOT
         kIntJfmzsqYNIj06l9g/gfgAqlvr2MgdWr3YIX1HYg8CQZCEAOSIxB355dFkJy3lw5Qo
         SM/UlJbQxcBxf3SS1QiovNNqb2PZtAhh5VAQ47sbLS1yN5vQKswvCKNAD5rtrWqJLBlt
         onag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sD2lhDsADmAeG04JHGihoM+wNZgeReacdiuQJB/0XW8=;
        b=hKkLMj2gwkFw1KRFuavBod8CiPb++fq80vB+662YDPrkCZ39V0tJXLKroohwHF0Xjo
         CPEewYQ6LfXa2NrgCGD76KcgpINJth1aZVuZ+jJLXAxLRfAxqjX6ylHXegz9Q0J5nML/
         pCqM5Lt1+0dsf/G3pyJdv4s+ueIIvPw0WarTiWg/oDS/24iDlOQTBF1Xls1GXli5XDqc
         iMtqjyldrLcyhEQ6lFQy2b8NYk4B6kpRZ2BRhB8B2hf7KBXX62j6AIE0vzaiCyIpJR+q
         GHhhNz+UN22PEg56pm098ZIqJyzBIcZvEZ7XEKSEbbYwsLy43vEa9lkEE3wb5zOQpINI
         DUUw==
X-Gm-Message-State: AOAM532Nialg6McxWKJfyAYqIrn8diJMVLbtzUUwtlovp4ol4LUfYl1l
        14GAagNPFkP0I888iyaR2Gc3W+f45tqcakU5FZJg2fNttA==
X-Google-Smtp-Source: ABdhPJyTJJO/jyfZRRVHQEkICGpn1yrZ7TfG6vd2BzF6dUwSmWXIjtWFRo3rK9heA5z4Aga9ijMGWw0tzrLzV2j17sI=
X-Received: by 2002:a17:906:4146:: with SMTP id l6mr2152507ejk.341.1610555509497;
 Wed, 13 Jan 2021 08:31:49 -0800 (PST)
MIME-Version: 1.0
References: <CAE-Mgq2kwwZJicbU9oenD4M5SQhbErhXovGX+LKtcnRbLC4xSg@mail.gmail.com>
 <87ft35kojo.fsf@suse.com>
In-Reply-To: <87ft35kojo.fsf@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 13 Jan 2021 08:31:37 -0800
Message-ID: <CAKywueQ9jmyTaKqR2x0nL-Q8A=-V1fP_1L2n=b+OdUzVhV083Q@mail.gmail.com>
Subject: Re: [bug report] Inconsistent state with CIFS mount after interrupted
 process in Linux 5.10
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <smfrench@gmail.com>
Cc:     Duncan Findlay <duncf@duncf.ca>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks for reporting the issue.

The problem is with the recent fix which changes the error code from
-EINTR to -ERESTARTSYS:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/f=
s/cifs/transport.c?id=3D6988a619f5b79e4efadea6e19dcfe75fbcd350b5

and this problem happens here:

https://git.samba.org/sfrench/?p=3Dsfrench/cifs-2.6.git;a=3Dblob;f=3Dfs/cif=
s/smb2pdu.c;h=3D067eb44c7baa863c1e7ccd2c2f599be0b067f320;hb=3D236237ab6de1c=
de004b0ab3e348fc530334270d5#l3251

So, interrupted close commands don't get restarted by the client and
the client leaks open handles on the server. The offending patch was
tagged stable, so the fix seems quite urgent. The fix itself should be
simple: replace -EINTR with -ERESTARTSYS in the IF condition or even
amend it with "||".

Adding Paulo and Steve to comment.

--
Best regards,
Pavel Shilovsky

=D1=81=D1=80, 13 =D1=8F=D0=BD=D0=B2. 2021 =D0=B3. =D0=B2 04:31, Aur=C3=A9li=
en Aptel <aaptel@suse.com>:
>
> Duncan Findlay <duncf@duncf.ca> writes:
> > There seems to be a problem with the CIFS module in Linux 5.10. Files
> > that are opened and not cleanly closed end up in an inconsistent
> > state. This can be triggered by writing to a file and interrupting the
> > writer with Ctrl-C. Once this happens, attempting to delete the file
> > causes access to the mount to hang. Afterwards, the files are visible
> > to ls, but cannot be accessed or deleted.
> >
> > I'm running Debian unstable with a Debian unstable kernel
> > (5.10.5-1). I attempted to but could not reproduce this with a 4.19 ker=
nel.
> >
> >
> > Repro steps:
> >
> > $ sudo mount -t cifs //test/share /mnt/test --verbose -o
> > rw,user,auto,nosuid,uid=3Duser,gid=3Duser,vers=3D3.1.1,credentials=3D/h=
ome/user/tmp/creds
> > $ mkdir /mnt/test/subdir
> > $ cat > /mnt/test/subdir/foo
> > [ Hit Ctrl-C to interrupt ]
> > $ ls /mnt/test/subdir/
> > foo
> > $ rm /mnt/test/subdir/foo
> > [ Hangs for 35 seconds, errors in dmesg log -- see below ]
> > $ ls /mnt/test/subdir/
> > foo
> > $ stat /mnt/test/subdir/foo
> > stat: cannot statx '/mnt/test/subdir/foo': No such file or directory
> >
> > At this point, the file still exists on the server side, and
> > restarting the server causes it to be deleted.
> >
> > I can provide pcaps if necessary. It looks like with 4.19, when the
> > cat command is killed, the client sends a Close Request, and on 5.10
> > no commands are sent.
>
> I can reproduce this on Steve's current for-next branch but only against
> a Samba server.
>
> On Windows server, doing ^C kills cat properly but the output file is
> never created, which is also a bug.
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>
