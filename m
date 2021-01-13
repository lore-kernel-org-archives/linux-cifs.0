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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A7D2C433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Jan 2021 16:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27D292339D
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Jan 2021 16:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbhAMQ6d (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Jan 2021 11:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727557AbhAMQ6d (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Jan 2021 11:58:33 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01B6C061575
        for <linux-cifs@vger.kernel.org>; Wed, 13 Jan 2021 08:57:52 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id u21so3370888lja.0
        for <linux-cifs@vger.kernel.org>; Wed, 13 Jan 2021 08:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mbQa/v7kLWh9fwCbx8P7IdR7bsb252WyshIZaMJVNgc=;
        b=AMoJCT5HPGoKZSlJB1TuD/WS8dDYmGkqNi5QSJnY1ZVnHcPBd3xQMGZlbMh0weqhhS
         TCxIrrXWDn/cOLvNX0yghBiVyc/fFoReKBdr0YLpH8waarFlnANwvT/3ADmR/TkVOQN5
         Ap2jYvEqkflCtDkZJpIHjF23yoBKGRNbufyxDljWFsF07Oi1JknZ8J0HrKHtKNhGL8Q4
         S/8XlRKYJlkmFT55ohuM7y+w3ASZGbxhfrQFCymqWu0ia6ZII7PbX3WxVOqRqUY9et3g
         Xq8EESIbyoAq5BBqssKoeYzbBLPQY+fpR4A1czv53ccTmA35wr93muaAT6g7Ndor2KWH
         r6Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mbQa/v7kLWh9fwCbx8P7IdR7bsb252WyshIZaMJVNgc=;
        b=f253b96Ez9nnChst3jeM76DU+SB9TsSWo8NyVzG0NQbkBClBqzkfQZz0t9kKwrtNIE
         xqSFB9GvKNktVoOWxcc2o/+BkbvjI3uJHsOaGCS86s30gMUvpObxHPM+YtatGeROaSeb
         Bs6VIOwiGiQZKYCH3mWXwBYuPfSVuqnqfjFE/sLXTeEVJIH5DpjDxe/xZ09/Mroe+3+Q
         T/t//2Rj1ziNgh3t/ijZ6LVxgQ4q2Pubw0NxK59ZaEDi7RjHYx/VJnZrZlO02+sEVuMr
         HN1H/X4WLUtZ+k008CrJupBvLWTPuZWnaRIMyT9cZd8cFkkwYE9+j30Gi0shG2CWlpJK
         UOag==
X-Gm-Message-State: AOAM533srU3K9Y5DNaRPk8N2YhK1vn5A/l08qnvT5Yh+hAV36dJjy0/7
        rbhinT1imd9BJj4xo1e2+Z5rktIMEhwXRQYkg2sAaRnx7qQ=
X-Google-Smtp-Source: ABdhPJwNdYFkW1VDNTMyEJLmN2ukhCbnI56u6eEPZVSWCCRMbjUl98As8UrHg13+Vusue1o3UDQPuEFeRVxWCw3Zabk=
X-Received: by 2002:a2e:88c8:: with SMTP id a8mr1315274ljk.148.1610557071347;
 Wed, 13 Jan 2021 08:57:51 -0800 (PST)
MIME-Version: 1.0
References: <CAE-Mgq2kwwZJicbU9oenD4M5SQhbErhXovGX+LKtcnRbLC4xSg@mail.gmail.com>
 <87ft35kojo.fsf@suse.com> <CAKywueQ9jmyTaKqR2x0nL-Q8A=-V1fP_1L2n=b+OdUzVhV083Q@mail.gmail.com>
In-Reply-To: <CAKywueQ9jmyTaKqR2x0nL-Q8A=-V1fP_1L2n=b+OdUzVhV083Q@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 13 Jan 2021 10:57:40 -0600
Message-ID: <CAH2r5mvr2VWQLWRF_nHRc=S4ynhpixZAyM43qoo6OXp32-MkXQ@mail.gmail.com>
Subject: Re: [bug report] Inconsistent state with CIFS mount after interrupted
 process in Linux 5.10
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Duncan Findlay <duncf@duncf.ca>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Pavel's explanation looks plausible.


On Wed, Jan 13, 2021 at 10:31 AM Pavel Shilovsky <piastryyy@gmail.com> wrot=
e:
>
> Thanks for reporting the issue.
>
> The problem is with the recent fix which changes the error code from
> -EINTR to -ERESTARTSYS:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/fs/cifs/transport.c?id=3D6988a619f5b79e4efadea6e19dcfe75fbcd350b5
>
> and this problem happens here:
>
> https://git.samba.org/sfrench/?p=3Dsfrench/cifs-2.6.git;a=3Dblob;f=3Dfs/c=
ifs/smb2pdu.c;h=3D067eb44c7baa863c1e7ccd2c2f599be0b067f320;hb=3D236237ab6de=
1cde004b0ab3e348fc530334270d5#l3251
>
> So, interrupted close commands don't get restarted by the client and
> the client leaks open handles on the server. The offending patch was
> tagged stable, so the fix seems quite urgent. The fix itself should be
> simple: replace -EINTR with -ERESTARTSYS in the IF condition or even
> amend it with "||".
>
> Adding Paulo and Steve to comment.
>
> --
> Best regards,
> Pavel Shilovsky
>
> =D1=81=D1=80, 13 =D1=8F=D0=BD=D0=B2. 2021 =D0=B3. =D0=B2 04:31, Aur=C3=A9=
lien Aptel <aaptel@suse.com>:
> >
> > Duncan Findlay <duncf@duncf.ca> writes:
> > > There seems to be a problem with the CIFS module in Linux 5.10. Files
> > > that are opened and not cleanly closed end up in an inconsistent
> > > state. This can be triggered by writing to a file and interrupting th=
e
> > > writer with Ctrl-C. Once this happens, attempting to delete the file
> > > causes access to the mount to hang. Afterwards, the files are visible
> > > to ls, but cannot be accessed or deleted.
> > >
> > > I'm running Debian unstable with a Debian unstable kernel
> > > (5.10.5-1). I attempted to but could not reproduce this with a 4.19 k=
ernel.
> > >
> > >
> > > Repro steps:
> > >
> > > $ sudo mount -t cifs //test/share /mnt/test --verbose -o
> > > rw,user,auto,nosuid,uid=3Duser,gid=3Duser,vers=3D3.1.1,credentials=3D=
/home/user/tmp/creds
> > > $ mkdir /mnt/test/subdir
> > > $ cat > /mnt/test/subdir/foo
> > > [ Hit Ctrl-C to interrupt ]
> > > $ ls /mnt/test/subdir/
> > > foo
> > > $ rm /mnt/test/subdir/foo
> > > [ Hangs for 35 seconds, errors in dmesg log -- see below ]
> > > $ ls /mnt/test/subdir/
> > > foo
> > > $ stat /mnt/test/subdir/foo
> > > stat: cannot statx '/mnt/test/subdir/foo': No such file or directory
> > >
> > > At this point, the file still exists on the server side, and
> > > restarting the server causes it to be deleted.
> > >
> > > I can provide pcaps if necessary. It looks like with 4.19, when the
> > > cat command is killed, the client sends a Close Request, and on 5.10
> > > no commands are sent.
> >
> > I can reproduce this on Steve's current for-next branch but only agains=
t
> > a Samba server.
> >
> > On Windows server, doing ^C kills cat properly but the output file is
> > never created, which is also a bug.
> >
> > Cheers,
> > --
> > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnber=
g, DE
> > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)
> >



--
Thanks,

Steve
