Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E9AEB64DD
	for <linux-cifs@archiver.kernel.org>; Wed,  5 Jul 2023 06:13:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjGEGNz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Jul 2023 02:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbjGEGNz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Jul 2023 02:13:55 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C5F10E3
        for <linux-cifs@vger.kernel.org>; Tue,  4 Jul 2023 23:13:54 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id 3f1490d57ef6-c4cb4919bb9so4202553276.3
        for <linux-cifs@vger.kernel.org>; Tue, 04 Jul 2023 23:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688537633; x=1691129633;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ctNai2q/TxxXaukpnDJk9J/3MAO1r4piN7WGssfunU4=;
        b=Ol5yyK5Uje30GWE79UvpNIXLQ7E8ncRTshjEoezC4yb1HSWMz3rSwmarObQuzuKJqO
         d3gpvNTF2FMPFdaUA/CKVhAKmI5YA+JrvDPNdiVj6RHH77g1Uwllyvp6pfx5MC5+fa2u
         q0XSTdQatySgI4TSX9HHKPIRv0ZGkOtFFAnlOosDf4ZhsJLmGVpkxb9i55UJ+BRVYlud
         t16h3dPTqe/nqsV1UA45JYUa6Lb/YYGDsJV2plZXx893ICnoAiRO0Q2rVVAZGCzA3x9L
         nRsHxIIaHGHC9V0OMv/qmJHKN+156HRb3q/haGozvlS8ykS8f0NOlJz04r0Yx+ityVtN
         P3Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688537633; x=1691129633;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ctNai2q/TxxXaukpnDJk9J/3MAO1r4piN7WGssfunU4=;
        b=CqF/PKlPBWohWOQz5SJPL9B0WjwRX3wrzRPdHAmOiowKMfgzUQiCQnFxg4/Dvo0snm
         GBAxO6mZRt2OHhvQh5SzP2LWHukD9ZJy1CDn3jVExH+yoH30Kel8a5l3yaJetathoMnK
         DhdwQIox7WDasaTszW7VTGt5iujASaJUuVH7D2+Eluecvy+sFc+946igKR0NKPIuoM+1
         dPwiGHtYsm01Ca4yYswajy5juQ3agK8FCZPIgDO9FYU83vG7T1gYzVOpC2NTx0k/xMzv
         ZKtoYB0YdLd0A/0U8mUT+hPGNn6YSwVRoLxadNgioTvZC0Ln36BNZL34N7Pf77P6CULr
         ci+Q==
X-Gm-Message-State: ABy/qLZ+zjtyuTedcHoooETrdGajZsOtCZPSbIH0ybleo3E/BXpP7y+W
        ZIQuzdNJcieXQhMsDMmIDI848L41VrcyVTsn/60=
X-Google-Smtp-Source: APBJJlEhJoSmnvt9jJw4rD3SCMMV+Q0QHUEVBhmqKrsvYeUM//s3UrwZ0orlwBYbV4She4AHSM3iWCV/eY1/teC6dyY=
X-Received: by 2002:a25:23c8:0:b0:c1a:b15d:81b5 with SMTP id
 j191-20020a2523c8000000b00c1ab15d81b5mr13553662ybj.35.1688537633197; Tue, 04
 Jul 2023 23:13:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230703120709.3610-1-bharathsm@microsoft.com> <223dd925bd50acd04bfb25fa18cf276e.pc@manguebit.com>
In-Reply-To: <223dd925bd50acd04bfb25fa18cf276e.pc@manguebit.com>
From:   Bharath SM <bharathsm.hsk@gmail.com>
Date:   Wed, 5 Jul 2023 11:43:42 +0530
Message-ID: <CAGypqWzoo83xy0wbGUO6NX_24pFEM=tpS=e2_iuxvCdRk4e9mA@mail.gmail.com>
Subject: Re: [PATCH] smb: add missing create options for O_DIRECT and O_SYNC flags
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     sfrench@samba.org, lsahlber@redhat.com, sprasad@microsoft.com,
        tom@talpey.com, linux-cifs@vger.kernel.org,
        bharathsm@microsoft.com, nspmangalore@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jul 3, 2023 at 9:33=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> w=
rote:
>
> Bharath SM <bharathsm.hsk@gmail.com> writes:
>
> > The CREATE_NO_BUFFER and CREATE_WRITE_THROUGH file create options
> > are correctly set in cifs_nt_open and cifs_reopen functions based
> > on O_DIRECT and O_SYNC flags. However flags are missing during the
> > file creation process in cifs_atomic_open, this was leading to
> > successful write operations with O_DIRECT even in case on un-aligned
> > size. Fixed by setting create options based on open file flags.
> >
> > Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> > ---
> >  fs/smb/client/dir.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
> > index 30b1e1bfd204..4178a7fb2ac2 100644
> > --- a/fs/smb/client/dir.c
> > +++ b/fs/smb/client/dir.c
> > @@ -292,6 +292,12 @@ static int cifs_do_create(struct inode *inode, str=
uct dentry *direntry, unsigned
> >        * ACLs
> >        */
> >
> > +     if (oflags & O_SYNC)
> > +             create_options |=3D CREATE_WRITE_THROUGH;
> > +
> > +     if (oflags & O_DIRECT)
> > +             create_options |=3D CREATE_NO_BUFFER;
> > +
>
> Looks good, thanks.
>
> I see that cifs_nt_open(), cifs_reopen_file() and cifs_do_create() use
> cifs_create_options().
>
> I'd rather have those flags set in cifs_create_options() by passing a
> new @flags to it, so if we need to make any changes later, only
> cifs_create_options() will require it.  What do you think?

Thanks,
I see there are around 34 places where we call cifs_create_options()
and currently it's taking cifs_sb,create options as arguments. Should
we make another helper function with name
"create_options=3Dcifs_parse_flags(flags)" then pass create_options into
cifs_create_options() ?
I think we can do this cleanup as the next patch. What do you think.?
