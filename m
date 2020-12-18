Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5370C4361B
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Dec 2020 18:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97D4123B70
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Dec 2020 18:41:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgLRSky (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Dec 2020 13:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbgLRSkx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 18 Dec 2020 13:40:53 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67FBBC0617A7;
        Fri, 18 Dec 2020 10:40:13 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id x2so2756325ybt.11;
        Fri, 18 Dec 2020 10:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z7jR72gvgMysEEXgqv4JPyd7bohxMk2wY0hLM59Aeus=;
        b=FbdHY15z3Rb6j6g4JE9QsSsUHjp04iGmeSA2XUtD/zSlOrxzA0WTS085aKrkesD2cM
         k1xONlEUTEHBpPOitWhRhFLKgFsd94UpbK1/tLqafJnk/Qam1eErX9UpCnMDR0fQA7nR
         DtRFjRL3HuYlImSZoTInMYeMtOD8tMo48iBdK4OlHV3gF9fZ/iRw/kVm2ZAVYD1IXRI5
         YLv8VIxudez75O9+1zj8Txu7pV4lTJvqqyD6LgeakopuhoygseBTHuYAklUQcYkBIXfT
         GRS777gR4TEHQvfsqaKlFV3SBgA7jxYg5R43klgLl7Sljif0Ix/J2cMsdYEO1RBHseLk
         m2IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z7jR72gvgMysEEXgqv4JPyd7bohxMk2wY0hLM59Aeus=;
        b=aQIwFM0B44phLrw6f4h1lVtbCZ9GwnlWfps30rSrF6Ug8r86/3VpvT/kuQw1hbYL9e
         vEBBdIB8ASDf5PKaJt+yG7hlSN6w6tf0vnGjUwrtB8MIRrhMahNshropeO5D6DVdFNV1
         b9fGgb+ENtbDdmC/EfAQCY9zEmqRYOr0b6K/hosOjpxZNRQJKOFndgMVJCar72vABkse
         Wq4djUrwb2floxHM/p9HElY3kdN8zOgmJsEfI/6mtZoiVJPk6q15ccshke4opwdW9CI4
         0pXn2Gtrr3+TtZzO4p5m6kQCiQaIshm5NpHKt+ILkr2KPK3UTXESQPjTMQA/ZATimw0p
         SxrA==
X-Gm-Message-State: AOAM533UJRteSsabW5ZDJ8Y30F0cW4D0mfheM43KW3NtMmhQzbwbeEK8
        7c2Z5slCyWvdSv8Jsz5tpxb/RsncBnwtHlgM5kk=
X-Google-Smtp-Source: ABdhPJyGngw2SmFyfCwklV8KN7Go+Kfm/IAeF4ztQpcuxDt8oEGa/9Hh4/DnTneDjDRt/mMV0coX3qhSnTfpzwpVOHo=
X-Received: by 2002:a05:6902:602:: with SMTP id d2mr7418313ybt.205.1608316812748;
 Fri, 18 Dec 2020 10:40:12 -0800 (PST)
MIME-Version: 1.0
References: <20201027204226.26906-1-pboris@amazon.com> <20201217205808.14756-1-pboris@amazon.com>
 <CANT5p=oMDGHSMOCgOrz6S9tuB3BmbL4mLqsC4vqSPod8pWsTaA@mail.gmail.com>
In-Reply-To: <CANT5p=oMDGHSMOCgOrz6S9tuB3BmbL4mLqsC4vqSPod8pWsTaA@mail.gmail.com>
From:   Boris Protopopov <boris.v.protopopov@gmail.com>
Date:   Fri, 18 Dec 2020 13:40:01 -0500
Message-ID: <CAHhKpQ4qKjZGboa=y=Yq8WAMtDE6UXDr-3vaRvtFJqbmnkXPCQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] Add SMB 2 support for getting and setting SACLs
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Boris Protopopov <pboris@amazon.com>,
        Steven French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, samjonas@amazon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

No objections on my part as far as adding 'if (info & SACL_SECINFO) return'.

I had originally those flags sent from the caller, but that was
confusing at the top level (e.g. in cifsacl.c), so I have opted to
passing only "extra" flags ("additional" was already taken).

-------------
...
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -3315,9 +3315,9 @@ get_smb2_acl(struct cifs_sb_info *cifs_sb,
> >         struct cifs_ntsd *pntsd = NULL;
> >         struct cifsFileInfo *open_file = NULL;
> >
> > -       if (inode)
> > +       if (inode && !(info & SACL_SECINFO))
> >                 open_file = find_readable_file(CIFS_I(inode), true);
> > -       if (!open_file)
> > +       if (!open_file || (info & SACL_SECINFO))
> >                 return get_smb2_acl_by_path(cifs_sb, path, pacllen, info);
> >
> >         pntsd = get_smb2_acl_by_fid(cifs_sb, &open_file->fid, pacllen, info);
> Why not have an if (info & SACL_SECINFO) return
> get_smb2_acl_by_path... right at the beginning?
> Looks cleaner that way IMO.
>
...
> > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > index 0aeb63694306..b207e1eb6803 100644
> > --- a/fs/cifs/smb2pdu.c
> > +++ b/fs/cifs/smb2pdu.c
> > @@ -3472,8 +3472,10 @@ SMB311_posix_query_info(const unsigned int xid, struct cifs_tcon *tcon,
> >  int
> >  SMB2_query_acl(const unsigned int xid, struct cifs_tcon *tcon,
> >                u64 persistent_fid, u64 volatile_fid,
> > -              void **data, u32 *plen, u32 additional_info)
> > +              void **data, u32 *plen, u32 extra_info)
> >  {
> > +       __u32 additional_info = OWNER_SECINFO | GROUP_SECINFO | DACL_SECINFO |
> > +                               extra_info;
> I still prefer having these flags set by the caller. That way, the
> caller has the flexibility to query only the subset needed.
> --
> -Shyam
