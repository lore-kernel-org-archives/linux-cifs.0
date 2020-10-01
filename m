Return-Path: <SRS0=hquX=DI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A5D1C4727C
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Oct 2020 05:13:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2599720888
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Oct 2020 05:13:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pG7VBEit"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgJAFNI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Oct 2020 01:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgJAFNI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Oct 2020 01:13:08 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B31DC061755
        for <linux-cifs@vger.kernel.org>; Wed, 30 Sep 2020 22:13:08 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id k2so3080049ybp.7
        for <linux-cifs@vger.kernel.org>; Wed, 30 Sep 2020 22:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pEBXVu2wRBDGRpRMM4ijN+38DZXE66gYcsWJ9ddoexA=;
        b=pG7VBEitov1oCMpK+DAERxzJVyUmQoowZx7sRFtaajTeLS7ifQH3mwa+Os3Glq8AoF
         S7+cDv50Iyni53JlTmaMBz59Fuh+dj2gaw3fbH5morVAceMHCSaFkokLFhpGkruXfgtt
         3mgGUuFQi1rZCLF4x++cH0JPjI0jwEcsSv7kzZGEc3sfoK52JzFeA55APYSPY3IpfEfj
         4kC05OpDl2gNNB56K01Pjm/KENaDHWBDlSHHvlGCU1/x6hydA16g9WMQDi2TsRPK7fWa
         b7COqwof/vuG8oinFd3n5tgc3ybjvnHT6nrsjknNuRyYdhaCkXTqv6aL/SAn0xeFcubh
         eMCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pEBXVu2wRBDGRpRMM4ijN+38DZXE66gYcsWJ9ddoexA=;
        b=td9sQLWhGGoCjNF1YPAxvPDip7capjhBRix3pepBx40VVL4taH7DldGgPGdc6m9teV
         xQRdfgVs3D/3oqJslBYQxa3agiX3GvnAmW0DhL/blLxSMsDq48fQqGfXmtqCB+XNgzeq
         XKA9iT3Bz0ynKdNnHY5rPsWEHQomvF4grZ+6X50xV36JZczC2k8HypWnPL/yPgeOhVXI
         IUDZ/dbNtGELZTOpaVjdV0hqrgZLmTH+Lqh/HePfZQAkpbgkJXAFsHXnvflBD5mU0ctu
         8xYJl2H74YlG4sHm01iDJ7bJZgLKBHIXWkE+o6KQ/Bi1sIAydX4+Zxk3gzXheUDUWlS8
         c0ew==
X-Gm-Message-State: AOAM533OvZ4Jy1vUtLsNRDTThWl4ZsqEqVbttTLXQFsOlIfTUeOXTcy0
        0iby4QbuTp48+wA7xXMzI1K9MJCA5bKZC00YavA=
X-Google-Smtp-Source: ABdhPJwiyQrsFMtvCGnVTj22Ktkb4S+c031bEfcDimNQzHB19XlDNWvKClN7DVSBrykXKNIyriv73HqpMeuWAM4ceJA=
X-Received: by 2002:a25:6193:: with SMTP id v141mr8255438ybb.34.1601529187614;
 Wed, 30 Sep 2020 22:13:07 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=ojR_Aac4bWSBqb3_FmzzjA6sHQBdN5z4o6c4nFDKmNDQ@mail.gmail.com>
 <87blhok9jd.fsf@suse.com> <CAH2r5murtQh0Mvp53bc_DRh7AwuMNPq=dqPq=gh3ESsQ0Lkwsg@mail.gmail.com>
 <CANT5p=q=8MLgWogmUiGUCRX53qNOsg_tRyXP_YMDjfrfai7awQ@mail.gmail.com>
 <CANT5p=rWSgB77Q-L_8YMUqzaVWsCLbguq7z4moN63cNKqgdHiA@mail.gmail.com> <CAN05THRRktH-RFozk24Y8DQ0mNBwQzb8OqwDXjur6CZn-jbyUA@mail.gmail.com>
In-Reply-To: <CAN05THRRktH-RFozk24Y8DQ0mNBwQzb8OqwDXjur6CZn-jbyUA@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 1 Oct 2020 10:42:57 +0530
Message-ID: <CANT5p=q8GyGvX7B1rR47GEpU2ZqCEANtbKetDjgn8o__BdmfXA@mail.gmail.com>
Subject: Re: [PATCH] cifs: Return the appropriate error in cifs_sb_tlink
 instead of a generic error.
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Ronnie,

Returning EACCES to userspace does make sense. However, with the
current code, even a ENOMEM or EIO will return a EACCES to userspace.
I'm thinking that we need to specifically map ENOKEY to EACCES here.

I was discussing this with Steve yesterday, and he suggested that I
email fs-devel about what is the general expectation from VFS.

Regards,
Shyam

On Thu, Oct 1, 2020 at 4:47 AM ronnie sahlberg <ronniesahlberg@gmail.com> w=
rote:
>
> On Thu, Oct 1, 2020 at 1:57 AM Shyam Prasad N <nspmangalore@gmail.com> wr=
ote:
> >
> > Ok. Checked the test. It does a multiuser mount of a file share. (I'm
> > assuming this is using sec=3Dntlmssp)
> > Then does an "ls" on the mount point as another user. Expects EACCES
> > as the output.
> > With this change, the command returns an ENOKEY.
> > With the credentials added to keyring using cifscreds, the ls command w=
orks.
> >
> > Now the question is: Is the right error to return here EACCES or
> > ENOKEY? Even if the expected error here should be EACCES, I'd say that
> > the error returned by cifs_set_cifscreds should return that error.
> >
>
> Good find!
>
> I am leaning towards leaving it as EACCES as that is a generic "you
> dont have access" errno we report back to userspace.
> System calls like opendir(), stat() etc all list EACCES as a valid
> return code but they don't list ENOKEY.
> So we then have to consider the applications. For applications that
> don't look at errno it wouldn't matter but for applications that do
> look at errno and try to take proper action to failures would be
> "surprised" since they get an errno that is not listed on the manpage.
>
> So that is why I think we should leave it as -EACCES as this is the
> generic "you don't have access".
> But we should make sure that when this happens we do get a more
> detailed "you don't have access because you don't have proper
> credentials" into log-file / dmesg.
>
> Regards
> Ronnie
>
> > Regards,
> > Shyam
> >
> > On Wed, Sep 30, 2020 at 8:48 PM Shyam Prasad N <nspmangalore@gmail.com>=
 wrote:
> > >
> > > It looks like xfstests smb3 multiuser cifsutils-101 and cifs-101 are =
failing.
> > > Maybe they were written keeping in mind the current error code
> > > returned by cifs.ko in this situation? Let me take a look.
> > > I guess @ronnie sahlberg will be able to debug the failing tests
> > > faster. The failing test has his name in the code. :)
> > >
> > > On Tue, Sep 29, 2020 at 11:16 PM Steve French <smfrench@gmail.com> wr=
ote:
> > > >
> > > > tentatively merged ... running the usual functional tests
> > > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builde=
rs/2/builds/399
> > > >
> > > > On Tue, Sep 29, 2020 at 8:16 AM Aur=C3=A9lien Aptel <aaptel@suse.co=
m> wrote:
> > > > >
> > > > > Shyam Prasad N <nspmangalore@gmail.com> writes:
> > > > > > One of the cases where this behaviour is confusing is where a
> > > > > > new tcon needs to be constructed, but it fails due to
> > > > > > expired keys. cifs_construct_tcon then returns ENOKEY,
> > > > > > but we end up returning a EACCES to the user.
> > > > > >
> > > > > > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > > > >
> > > > > LGTM
> > > > >
> > > > > Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> > > > >
> > > > > Cheers,
> > > > > --
> > > > > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > > > > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > > > > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=
=BCrnberg, DE
> > > > > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (=
AG M=C3=BCnchen)
> > > >
> > > >
> > > >
> > > > --
> > > > Thanks,
> > > >
> > > > Steve
> > >
> > >
> > >
> > > --
> > > -Shyam
> >
> >
> >
> > --
> > -Shyam



--=20
-Shyam
