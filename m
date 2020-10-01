Return-Path: <SRS0=hquX=DI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 686BDC4727C
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Oct 2020 11:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16B8820B1F
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Oct 2020 11:29:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ao1XGkOB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731819AbgJAL3o (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Oct 2020 07:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731670AbgJAL33 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Oct 2020 07:29:29 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A83EC0613D0
        for <linux-cifs@vger.kernel.org>; Thu,  1 Oct 2020 04:29:29 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id z25so6174562iol.10
        for <linux-cifs@vger.kernel.org>; Thu, 01 Oct 2020 04:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2tq6hzbmGoS6rgqCUQ7LUJ00kjZrjqxnHyisJOM2rBc=;
        b=Ao1XGkOBVGqkzIZXp0cJbWUTiv+d1Al7Gjc9nW5D0n0HtqHSRMz43+ONMLarrmYElm
         AA/MD6xrKDGzzFRi59pc5CSBUJv3CA1p9OvjwopFFxnsuAw6L8ShpdRUa2U45x3UCRgG
         BxWlFLBycavAjJz0US3R+aXkTcb/9MrT9GZgLj/fYGKRkZsBceSPMG8zdr52oD6OS/vX
         qfaOz5xEieyQoNgzG8ATTewQmTfYRxqWHXT07kVh19Hq3pJwLbW+TyS1M1wEotz6XGf8
         rtWLg8NIP3FF3TFCYuOTPz6iVWrr9GtSE+BM4T142s+gdTVyX1pRM3VbRKRiq9H1pvTK
         QWBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2tq6hzbmGoS6rgqCUQ7LUJ00kjZrjqxnHyisJOM2rBc=;
        b=qcOzy9JDay3pAzE++8+Cd5X3EScU3v9oSnVZNOBK6yiym0xNv/MIvBQVoQPsUqI3Gk
         nENQB5d3HJGY67+6o02pFXBMKt47praBH/n88o0bXPTcZ2Fn++ziiohnTEuW2xb+cS6I
         xtec2M34bPssEe2WAy9HkWf/glmSJrVkDquFjId4G8hzAAgjyR5wNP3CZ2+o7zRaf+Jj
         WPAAm6HpbwEMiXgSGv7eN0AWhfoS3k5pR7EgWGVoZtSPRkxAqwj0Z7Q4WmXYfrTUHqLP
         6CmR5iwmx9YiM/Rcb6WbJVTU27TpqufM96Fot4kOe4J3d10jShpu5r30GJvOI6Tn7FZq
         Lp2A==
X-Gm-Message-State: AOAM532fJPc/PE4Lw5/d/YCdHqE6npMD5JuwMcybEXtmw5161BYCsBYk
        3UHDSHJXJK21z7AhivXQ0DqUTO069cb7cWAHe3U=
X-Google-Smtp-Source: ABdhPJwWmBOEpQ4B46z1/kXlyhUKtUdGiJe3E/zwREq5QY7J/R5DZH98GH+JLHDsulCGLGL8PC/VTdMLjuE0+uoarLY=
X-Received: by 2002:a6b:e017:: with SMTP id z23mr4927510iog.101.1601551768524;
 Thu, 01 Oct 2020 04:29:28 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=ojR_Aac4bWSBqb3_FmzzjA6sHQBdN5z4o6c4nFDKmNDQ@mail.gmail.com>
 <87blhok9jd.fsf@suse.com> <CAH2r5murtQh0Mvp53bc_DRh7AwuMNPq=dqPq=gh3ESsQ0Lkwsg@mail.gmail.com>
 <CANT5p=q=8MLgWogmUiGUCRX53qNOsg_tRyXP_YMDjfrfai7awQ@mail.gmail.com>
 <CANT5p=rWSgB77Q-L_8YMUqzaVWsCLbguq7z4moN63cNKqgdHiA@mail.gmail.com>
 <CAN05THRRktH-RFozk24Y8DQ0mNBwQzb8OqwDXjur6CZn-jbyUA@mail.gmail.com>
 <CANT5p=q8GyGvX7B1rR47GEpU2ZqCEANtbKetDjgn8o__BdmfXA@mail.gmail.com>
 <CAH2r5mtyE7+X6ayp8FfzWu5cyengtd=RMFD0XimZPFoJQ5h+PQ@mail.gmail.com> <CANT5p=pMo6-j5aVTnUWFdH7+VkPhx2h7Mpie89MuciJ_ARw3eA@mail.gmail.com>
In-Reply-To: <CANT5p=pMo6-j5aVTnUWFdH7+VkPhx2h7Mpie89MuciJ_ARw3eA@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 1 Oct 2020 21:29:17 +1000
Message-ID: <CAN05THQgNq9WnjGBB8utMFSma0s9khOSKnn0Di23hgcnEdsAFA@mail.gmail.com>
Subject: Re: [PATCH] cifs: Return the appropriate error in cifs_sb_tlink
 instead of a generic error.
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Oct 1, 2020 at 8:42 PM Shyam Prasad N <nspmangalore@gmail.com> wrot=
e:
>
> Ronnie does make a good point about the error returned to the user.
> However, masking all the errors returned from the
> cifs_construct_tcon() doesn't sit well with me.
>
> For example, if the system is low on memory, or there's an EIO
> returned due to some reason, those errors will not make it to the
> user, and the user will see a blanket "Permission denied". How many
> Linux users will check the dmesg/logs when they get an EACCES?
>
> Moreover, if the actual returned is ENOMEM but we return EACCES to the
> user, we could have a situation where the user gets EACCES for one I/O
> but no such error for the subsequent I/O. This can be quite confusing
> for the user.

It is primarily about making sure that applications do not misbehave.
Especially applications or glibc that do pay close attention to  what
errno is when a syscall fails. And where errno drives them how to
handle or manage recovery.

It basically depends on case by case scenario. Are applications
calling this syscall directly or via glibc. If the latter, what errnos
does glibc accept for that syscall and how does it deal with them?
The answer here is what the man page says, because that is what
application and glibc are coded against.
We can not introduce new errno values to userspace.

There may be situations where currently we leak "unexpected" errno
values through syscalls. That would be a bug and we need to fix it.

In cifs.ko we have had very serious bugs in the past where we were
leaking "unexpected" errno values to either glibc or application that
turned what should be a simple recoverable error into a serious hard
Data-Loss failure :-(. By causing glibc/application recovery code to
be "surprised" and to fail recovery. Very sad.

The way imho opinion to prevent confusion to end user is to log
warning with explanation to dmesg or log file.
If user caser, user looks at dmesg/log. If user does not care, that is
fine. As long as we do not "surprise" glibc or application.
We make sure we return only those errnos in the manpage and from there
it is the responsibility of glibc/application to handle it.

>
> Opinions?
>
> Regards,
> Shyam
>
> On Thu, Oct 1, 2020 at 10:55 AM Steve French <smfrench@gmail.com> wrote:
> >
> > Ronnie makes a good point about checking valid return codes by api call=
 (open, close, read, write) as well ...
> >
> > On Thu, Oct 1, 2020 at 12:13 AM Shyam Prasad N <nspmangalore@gmail.com>=
 wrote:
> >>
> >> Hi Ronnie,
> >>
> >> Returning EACCES to userspace does make sense. However, with the
> >> current code, even a ENOMEM or EIO will return a EACCES to userspace.
> >> I'm thinking that we need to specifically map ENOKEY to EACCES here.
> >>
> >> I was discussing this with Steve yesterday, and he suggested that I
> >> email fs-devel about what is the general expectation from VFS.
> >>
> >> Regards,
> >> Shyam
> >>
> >> On Thu, Oct 1, 2020 at 4:47 AM ronnie sahlberg <ronniesahlberg@gmail.c=
om> wrote:
> >> >
> >> > On Thu, Oct 1, 2020 at 1:57 AM Shyam Prasad N <nspmangalore@gmail.co=
m> wrote:
> >> > >
> >> > > Ok. Checked the test. It does a multiuser mount of a file share. (=
I'm
> >> > > assuming this is using sec=3Dntlmssp)
> >> > > Then does an "ls" on the mount point as another user. Expects EACC=
ES
> >> > > as the output.
> >> > > With this change, the command returns an ENOKEY.
> >> > > With the credentials added to keyring using cifscreds, the ls comm=
and works.
> >> > >
> >> > > Now the question is: Is the right error to return here EACCES or
> >> > > ENOKEY? Even if the expected error here should be EACCES, I'd say =
that
> >> > > the error returned by cifs_set_cifscreds should return that error.
> >> > >
> >> >
> >> > Good find!
> >> >
> >> > I am leaning towards leaving it as EACCES as that is a generic "you
> >> > dont have access" errno we report back to userspace.
> >> > System calls like opendir(), stat() etc all list EACCES as a valid
> >> > return code but they don't list ENOKEY.
> >> > So we then have to consider the applications. For applications that
> >> > don't look at errno it wouldn't matter but for applications that do
> >> > look at errno and try to take proper action to failures would be
> >> > "surprised" since they get an errno that is not listed on the manpag=
e.
> >> >
> >> > So that is why I think we should leave it as -EACCES as this is the
> >> > generic "you don't have access".
> >> > But we should make sure that when this happens we do get a more
> >> > detailed "you don't have access because you don't have proper
> >> > credentials" into log-file / dmesg.
> >> >
> >> > Regards
> >> > Ronnie
> >> >
> >> > > Regards,
> >> > > Shyam
> >> > >
> >> > > On Wed, Sep 30, 2020 at 8:48 PM Shyam Prasad N <nspmangalore@gmail=
.com> wrote:
> >> > > >
> >> > > > It looks like xfstests smb3 multiuser cifsutils-101 and cifs-101=
 are failing.
> >> > > > Maybe they were written keeping in mind the current error code
> >> > > > returned by cifs.ko in this situation? Let me take a look.
> >> > > > I guess @ronnie sahlberg will be able to debug the failing tests
> >> > > > faster. The failing test has his name in the code. :)
> >> > > >
> >> > > > On Tue, Sep 29, 2020 at 11:16 PM Steve French <smfrench@gmail.co=
m> wrote:
> >> > > > >
> >> > > > > tentatively merged ... running the usual functional tests
> >> > > > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/b=
uilders/2/builds/399
> >> > > > >
> >> > > > > On Tue, Sep 29, 2020 at 8:16 AM Aur=C3=A9lien Aptel <aaptel@su=
se.com> wrote:
> >> > > > > >
> >> > > > > > Shyam Prasad N <nspmangalore@gmail.com> writes:
> >> > > > > > > One of the cases where this behaviour is confusing is wher=
e a
> >> > > > > > > new tcon needs to be constructed, but it fails due to
> >> > > > > > > expired keys. cifs_construct_tcon then returns ENOKEY,
> >> > > > > > > but we end up returning a EACCES to the user.
> >> > > > > > >
> >> > > > > > > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> >> > > > > >
> >> > > > > > LGTM
> >> > > > > >
> >> > > > > > Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> >> > > > > >
> >> > > > > > Cheers,
> >> > > > > > --
> >> > > > > > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> >> > > > > > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> >> > > > > > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=
=C3=BCrnberg, DE
> >> > > > > > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247=
165 (AG M=C3=BCnchen)
> >> > > > >
> >> > > > >
> >> > > > >
> >> > > > > --
> >> > > > > Thanks,
> >> > > > >
> >> > > > > Steve
> >> > > >
> >> > > >
> >> > > >
> >> > > > --
> >> > > > -Shyam
> >> > >
> >> > >
> >> > >
> >> > > --
> >> > > -Shyam
> >>
> >>
> >>
> >> --
> >> -Shyam
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> -Shyam
