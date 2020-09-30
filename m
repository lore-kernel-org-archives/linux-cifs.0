Return-Path: <SRS0=H1OG=DH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 695FDC4363D
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Sep 2020 23:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20F812076A
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Sep 2020 23:17:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VYs1/jkS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732128AbgI3XRE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 30 Sep 2020 19:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732105AbgI3XRE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 30 Sep 2020 19:17:04 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0541CC061755
        for <linux-cifs@vger.kernel.org>; Wed, 30 Sep 2020 16:17:04 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id q4so4460000iop.5
        for <linux-cifs@vger.kernel.org>; Wed, 30 Sep 2020 16:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dZUaGtkYfhwaiv0u0te8GoPPrVF6+8RPzKCExjpblwk=;
        b=VYs1/jkSTpgayO55McSVZtip4vZxR1X60nqE9Bu6Yeuk82OeLMOdbMe/f+s/9l+T7/
         Cn6eYKPYoahnyqeaJ2nj1ozxQdGGmIdEysjgz1uqKT7Efn/5L6gdnd3CGyjQUYik37tl
         LjF9nLQS9CS7IR6RkbNFPuyGkwoTUHkGzSx6lqgn3JqehLY74W3ov3fJroj6vS1R55da
         hczTGMjMIxUG/Opss7c0Y5W1QUO0g4qa16isHOYjJ2N1rsAFS/2tz0pfZ2hobVpE00LU
         dVThHFBakh8i8yxGVj1YWZk1prGOLvM8g9QiVQUMwMNGRRd7BxifwRQGUqU22nf0cRNk
         j8hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dZUaGtkYfhwaiv0u0te8GoPPrVF6+8RPzKCExjpblwk=;
        b=B++S12YOMhoLVrvDNDbbZ1h0rzTMssdmjKSiAyibHeEMJCu6iEICy4NMjiSOY9JlGC
         xEUGHepyFOuZaBWdlrc1e52fdpTAJ9jSMq6aIQCdofCeB7evdwMgdzmt6jm1hIudJB06
         p86ZDwdOeczmY6Yf4VxO2EY6KwlWPOL/jhsN3RnuwC3uMLyDwgWNAmUxc6iGw6GZOTdt
         884Yry00MWK1/bffr+eLi+WgO2CReI1RI24CdtRheWlxwQgLeF8OMshtisjtKGiCrYpk
         QAy9OGJEwmcPn5BTLG4R1HfL4dWI7uQrwMdRhBGeeKOkKa3mSSF4p8waZd9tM/oSfJbM
         sYJg==
X-Gm-Message-State: AOAM5302g9WGBfHlQO+J7eLIIn9LsoFwGhcM5xXmtx2J2xxN1b5Vmms9
        tX2ngbUlDfzai7gfYlQAivLNR/FJI8P8MJMZIAI=
X-Google-Smtp-Source: ABdhPJxezS+7qLWX4vzy2tygiyCIG0v8Alyvb+FNx/zVEY2a8nItjMbn/EiuxQqIEs8+SHlm2LZeOiM7ZvlkT8zJT2k=
X-Received: by 2002:a6b:8b52:: with SMTP id n79mr3304875iod.122.1601507823275;
 Wed, 30 Sep 2020 16:17:03 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=ojR_Aac4bWSBqb3_FmzzjA6sHQBdN5z4o6c4nFDKmNDQ@mail.gmail.com>
 <87blhok9jd.fsf@suse.com> <CAH2r5murtQh0Mvp53bc_DRh7AwuMNPq=dqPq=gh3ESsQ0Lkwsg@mail.gmail.com>
 <CANT5p=q=8MLgWogmUiGUCRX53qNOsg_tRyXP_YMDjfrfai7awQ@mail.gmail.com> <CANT5p=rWSgB77Q-L_8YMUqzaVWsCLbguq7z4moN63cNKqgdHiA@mail.gmail.com>
In-Reply-To: <CANT5p=rWSgB77Q-L_8YMUqzaVWsCLbguq7z4moN63cNKqgdHiA@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 1 Oct 2020 09:16:51 +1000
Message-ID: <CAN05THRRktH-RFozk24Y8DQ0mNBwQzb8OqwDXjur6CZn-jbyUA@mail.gmail.com>
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

On Thu, Oct 1, 2020 at 1:57 AM Shyam Prasad N <nspmangalore@gmail.com> wrot=
e:
>
> Ok. Checked the test. It does a multiuser mount of a file share. (I'm
> assuming this is using sec=3Dntlmssp)
> Then does an "ls" on the mount point as another user. Expects EACCES
> as the output.
> With this change, the command returns an ENOKEY.
> With the credentials added to keyring using cifscreds, the ls command wor=
ks.
>
> Now the question is: Is the right error to return here EACCES or
> ENOKEY? Even if the expected error here should be EACCES, I'd say that
> the error returned by cifs_set_cifscreds should return that error.
>

Good find!

I am leaning towards leaving it as EACCES as that is a generic "you
dont have access" errno we report back to userspace.
System calls like opendir(), stat() etc all list EACCES as a valid
return code but they don't list ENOKEY.
So we then have to consider the applications. For applications that
don't look at errno it wouldn't matter but for applications that do
look at errno and try to take proper action to failures would be
"surprised" since they get an errno that is not listed on the manpage.

So that is why I think we should leave it as -EACCES as this is the
generic "you don't have access".
But we should make sure that when this happens we do get a more
detailed "you don't have access because you don't have proper
credentials" into log-file / dmesg.

Regards
Ronnie

> Regards,
> Shyam
>
> On Wed, Sep 30, 2020 at 8:48 PM Shyam Prasad N <nspmangalore@gmail.com> w=
rote:
> >
> > It looks like xfstests smb3 multiuser cifsutils-101 and cifs-101 are fa=
iling.
> > Maybe they were written keeping in mind the current error code
> > returned by cifs.ko in this situation? Let me take a look.
> > I guess @ronnie sahlberg will be able to debug the failing tests
> > faster. The failing test has his name in the code. :)
> >
> > On Tue, Sep 29, 2020 at 11:16 PM Steve French <smfrench@gmail.com> wrot=
e:
> > >
> > > tentatively merged ... running the usual functional tests
> > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders=
/2/builds/399
> > >
> > > On Tue, Sep 29, 2020 at 8:16 AM Aur=C3=A9lien Aptel <aaptel@suse.com>=
 wrote:
> > > >
> > > > Shyam Prasad N <nspmangalore@gmail.com> writes:
> > > > > One of the cases where this behaviour is confusing is where a
> > > > > new tcon needs to be constructed, but it fails due to
> > > > > expired keys. cifs_construct_tcon then returns ENOKEY,
> > > > > but we end up returning a EACCES to the user.
> > > > >
> > > > > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > > >
> > > > LGTM
> > > >
> > > > Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> > > >
> > > > Cheers,
> > > > --
> > > > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > > > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > > > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCr=
nberg, DE
> > > > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG=
 M=C3=BCnchen)
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> >
> >
> > --
> > -Shyam
>
>
>
> --
> -Shyam
