Return-Path: <SRS0=hquX=DI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6C3BC4727C
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Oct 2020 10:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A97320796
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Oct 2020 10:43:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cz9xSa+X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731965AbgJAKnA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Oct 2020 06:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731131AbgJAKm7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Oct 2020 06:42:59 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45611C0613D0
        for <linux-cifs@vger.kernel.org>; Thu,  1 Oct 2020 03:42:59 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id v60so3658515ybi.10
        for <linux-cifs@vger.kernel.org>; Thu, 01 Oct 2020 03:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=p0iCUyxO2zqBeh75ecJ4ZDVRtL3Lph0idBaUG1V47qg=;
        b=Cz9xSa+Xkf9L8r271pzNY9Vx3Kb9I076Y3IELSIdmx3MYRSviHKvCZMHANe6Bq4swR
         htC9O/tb6L614sn6fQWRC7RlDc7Cpm1QSUqxVDWOUxX491PhzkcvC/44yoeuMCXWNkRL
         Hwj+W99LZAjHtq7GNqzGqVEQuHY9pBudbUy6Y6fdvF7LwIV1Qz2qgmMrUUw/jH99gk2w
         uBVZy/ZB0p3bOJaazu3RyDZaFMo8L7O2jnDCzFPJdhW05lFyHwqj0d2Tot0IXICGEEZU
         HkXkDn9p7NKWke2oF+4kZpJMhr65Nsq6Iyge+deyTO4WGjGMjbwt0Q5sn8Y1wy30J3i8
         Fu7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=p0iCUyxO2zqBeh75ecJ4ZDVRtL3Lph0idBaUG1V47qg=;
        b=EfLfSelzY39hPdp1uN5B2eIPSB/ce6kTCxegh6malup4wuLHThZUCPUzFsgxIlfBGp
         MqsF8HGpC51X3bxDTTDh20LfatZHs4ZI+KoRYEPqDfDDQMcZvX3gTpwPx74hNgMrNHCs
         PC+hj2d4dbagNJWKRrEo2/DBm+Cpu921J6i7FQd+UcKuwBXa2LkPYyNAbUaeCle6IkFP
         nQdrA0bru8l40iAjss/vOStFiGTkZ2h6cZjvMhiEJPNXcQXYKR3hQgHkIfVMToBz2Ynq
         E/3uGzxtyECRsep3xN8gs8c7NSCtU7wZgLcbwEm9EKd9Co3IpFe299R192NR3VFm0mRH
         mLQw==
X-Gm-Message-State: AOAM530gsaBQaVyZEJV/Y6sQ6khanLdMuywe/au/MQbfrnD74Z40Iog3
        Gscd731CNxA731HNP41YgemVrbudgzbrWdUYMv4=
X-Google-Smtp-Source: ABdhPJyWAla+t2DZ9nF0B4JZAYvwhvv+Tj3MiW6+wAsuwi2PS4lo+bhvS7im1q5RzXGxJAPm17u+d503miKc5iQ0WaM=
X-Received: by 2002:a25:6193:: with SMTP id v141mr9678338ybb.34.1601548978332;
 Thu, 01 Oct 2020 03:42:58 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=ojR_Aac4bWSBqb3_FmzzjA6sHQBdN5z4o6c4nFDKmNDQ@mail.gmail.com>
 <87blhok9jd.fsf@suse.com> <CAH2r5murtQh0Mvp53bc_DRh7AwuMNPq=dqPq=gh3ESsQ0Lkwsg@mail.gmail.com>
 <CANT5p=q=8MLgWogmUiGUCRX53qNOsg_tRyXP_YMDjfrfai7awQ@mail.gmail.com>
 <CANT5p=rWSgB77Q-L_8YMUqzaVWsCLbguq7z4moN63cNKqgdHiA@mail.gmail.com>
 <CAN05THRRktH-RFozk24Y8DQ0mNBwQzb8OqwDXjur6CZn-jbyUA@mail.gmail.com>
 <CANT5p=q8GyGvX7B1rR47GEpU2ZqCEANtbKetDjgn8o__BdmfXA@mail.gmail.com> <CAH2r5mtyE7+X6ayp8FfzWu5cyengtd=RMFD0XimZPFoJQ5h+PQ@mail.gmail.com>
In-Reply-To: <CAH2r5mtyE7+X6ayp8FfzWu5cyengtd=RMFD0XimZPFoJQ5h+PQ@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 1 Oct 2020 16:12:47 +0530
Message-ID: <CANT5p=pMo6-j5aVTnUWFdH7+VkPhx2h7Mpie89MuciJ_ARw3eA@mail.gmail.com>
Subject: Re: [PATCH] cifs: Return the appropriate error in cifs_sb_tlink
 instead of a generic error.
To:     Steve French <smfrench@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie does make a good point about the error returned to the user.
However, masking all the errors returned from the
cifs_construct_tcon() doesn't sit well with me.

For example, if the system is low on memory, or there's an EIO
returned due to some reason, those errors will not make it to the
user, and the user will see a blanket "Permission denied". How many
Linux users will check the dmesg/logs when they get an EACCES?

Moreover, if the actual returned is ENOMEM but we return EACCES to the
user, we could have a situation where the user gets EACCES for one I/O
but no such error for the subsequent I/O. This can be quite confusing
for the user.

Opinions?

Regards,
Shyam

On Thu, Oct 1, 2020 at 10:55 AM Steve French <smfrench@gmail.com> wrote:
>
> Ronnie makes a good point about checking valid return codes by api call (=
open, close, read, write) as well ...
>
> On Thu, Oct 1, 2020 at 12:13 AM Shyam Prasad N <nspmangalore@gmail.com> w=
rote:
>>
>> Hi Ronnie,
>>
>> Returning EACCES to userspace does make sense. However, with the
>> current code, even a ENOMEM or EIO will return a EACCES to userspace.
>> I'm thinking that we need to specifically map ENOKEY to EACCES here.
>>
>> I was discussing this with Steve yesterday, and he suggested that I
>> email fs-devel about what is the general expectation from VFS.
>>
>> Regards,
>> Shyam
>>
>> On Thu, Oct 1, 2020 at 4:47 AM ronnie sahlberg <ronniesahlberg@gmail.com=
> wrote:
>> >
>> > On Thu, Oct 1, 2020 at 1:57 AM Shyam Prasad N <nspmangalore@gmail.com>=
 wrote:
>> > >
>> > > Ok. Checked the test. It does a multiuser mount of a file share. (I'=
m
>> > > assuming this is using sec=3Dntlmssp)
>> > > Then does an "ls" on the mount point as another user. Expects EACCES
>> > > as the output.
>> > > With this change, the command returns an ENOKEY.
>> > > With the credentials added to keyring using cifscreds, the ls comman=
d works.
>> > >
>> > > Now the question is: Is the right error to return here EACCES or
>> > > ENOKEY? Even if the expected error here should be EACCES, I'd say th=
at
>> > > the error returned by cifs_set_cifscreds should return that error.
>> > >
>> >
>> > Good find!
>> >
>> > I am leaning towards leaving it as EACCES as that is a generic "you
>> > dont have access" errno we report back to userspace.
>> > System calls like opendir(), stat() etc all list EACCES as a valid
>> > return code but they don't list ENOKEY.
>> > So we then have to consider the applications. For applications that
>> > don't look at errno it wouldn't matter but for applications that do
>> > look at errno and try to take proper action to failures would be
>> > "surprised" since they get an errno that is not listed on the manpage.
>> >
>> > So that is why I think we should leave it as -EACCES as this is the
>> > generic "you don't have access".
>> > But we should make sure that when this happens we do get a more
>> > detailed "you don't have access because you don't have proper
>> > credentials" into log-file / dmesg.
>> >
>> > Regards
>> > Ronnie
>> >
>> > > Regards,
>> > > Shyam
>> > >
>> > > On Wed, Sep 30, 2020 at 8:48 PM Shyam Prasad N <nspmangalore@gmail.c=
om> wrote:
>> > > >
>> > > > It looks like xfstests smb3 multiuser cifsutils-101 and cifs-101 a=
re failing.
>> > > > Maybe they were written keeping in mind the current error code
>> > > > returned by cifs.ko in this situation? Let me take a look.
>> > > > I guess @ronnie sahlberg will be able to debug the failing tests
>> > > > faster. The failing test has his name in the code. :)
>> > > >
>> > > > On Tue, Sep 29, 2020 at 11:16 PM Steve French <smfrench@gmail.com>=
 wrote:
>> > > > >
>> > > > > tentatively merged ... running the usual functional tests
>> > > > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/bui=
lders/2/builds/399
>> > > > >
>> > > > > On Tue, Sep 29, 2020 at 8:16 AM Aur=C3=A9lien Aptel <aaptel@suse=
.com> wrote:
>> > > > > >
>> > > > > > Shyam Prasad N <nspmangalore@gmail.com> writes:
>> > > > > > > One of the cases where this behaviour is confusing is where =
a
>> > > > > > > new tcon needs to be constructed, but it fails due to
>> > > > > > > expired keys. cifs_construct_tcon then returns ENOKEY,
>> > > > > > > but we end up returning a EACCES to the user.
>> > > > > > >
>> > > > > > > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
>> > > > > >
>> > > > > > LGTM
>> > > > > >
>> > > > > > Reviewed-by: Aurelien Aptel <aaptel@suse.com>
>> > > > > >
>> > > > > > Cheers,
>> > > > > > --
>> > > > > > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
>> > > > > > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
>> > > > > > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=
=C3=BCrnberg, DE
>> > > > > > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 24716=
5 (AG M=C3=BCnchen)
>> > > > >
>> > > > >
>> > > > >
>> > > > > --
>> > > > > Thanks,
>> > > > >
>> > > > > Steve
>> > > >
>> > > >
>> > > >
>> > > > --
>> > > > -Shyam
>> > >
>> > >
>> > >
>> > > --
>> > > -Shyam
>>
>>
>>
>> --
>> -Shyam
>
>
>
> --
> Thanks,
>
> Steve



--=20
-Shyam
