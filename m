Return-Path: <SRS0=edh0=32=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03B4CC33CAC
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Feb 2020 18:42:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDBA2214AF
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Feb 2020 18:42:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t9jkeDy0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgBFSmS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 Feb 2020 13:42:18 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:45025 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgBFSmS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 Feb 2020 13:42:18 -0500
Received: by mail-il1-f193.google.com with SMTP id s85so6036779ill.11
        for <linux-cifs@vger.kernel.org>; Thu, 06 Feb 2020 10:42:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FGYEOBQY9WMtpqLug2YYSAmtGd8o/SrG39AoV4LD6Zg=;
        b=t9jkeDy0vkZlZyyFDgYSmsmtXChBuTPvE4H5MCptocEhuEMil2/gmcd3clDm9noNaZ
         53EOhqUbRMu1XsMvMpcATLp5uP92hct1SGapOX40obvrkS5W5fbcnQ/G6IjBnEn2DZda
         ns6fUzcywgUvyTeuFV2K2iWFThAuBbWPTpZpebqsEPIBBju66YbkAqmplOerrTz8fAgn
         2NGahZ3Q61JTIJWOOGPEBne27W0Sev+XqnhoL9kKUJYGK5x5Eqy664o9dALL/mRfoLcF
         6mQNNASZShMxxK9fBVoyxTi6p8tvWMX71w/67WvVLwnUv2i1ZbuN1r+aFuSkiHvPNgLf
         GFoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FGYEOBQY9WMtpqLug2YYSAmtGd8o/SrG39AoV4LD6Zg=;
        b=I3dbOJpKduXW9P36SuHUqn1d79RBvcfwrKWkkMhggOmV+QO+ZGsNyzef1I4HpPQrbM
         GskHWzOmnSndDQpWBtgbM2ByAldLzhaKw7hAS8372wAnGBMIBpokzoD500lYm9Da5gQ1
         PZ21JhGv1VVVXYXYBgGhbW/LR0Qy2Pul1vbOAcSPyFGYGtvbw71CbsNPl+qwxoY8UIsN
         YwO5vsnXrfmwJgzFM494Cjm12pmfPLIG/6xov1jeq3z3ITNNSxQGMpXPe2brnaCo+QHx
         gkH1ZmMynCz0q0DJD/rJfWwFUoZ1JiXlc7M3tPyaRnZ5nILD4tw8xG7MuWyYsW9xVSj2
         L2dQ==
X-Gm-Message-State: APjAAAVqCrxFypsnN7oLLyfj+/DSGdLzIs6daftKP2quwIHu4V+VrLFE
        GuJefOxLfOsim5wQr7x7yGJUPBvRy7av4LExwHNFJYPT
X-Google-Smtp-Source: APXvYqyrfdR73zJiUDqpK/SgHolo9Rghd/C1BeBnZ2Dz/5lnE7Ny3W30Pk0YlpIZe0ATIhTnSRf1pjdaRZ5Q8aIR//A=
X-Received: by 2002:a6b:cd0e:: with SMTP id d14mr33337944iog.272.1581014536235;
 Thu, 06 Feb 2020 10:42:16 -0800 (PST)
MIME-Version: 1.0
References: <20200206171655.23659-1-aaptel@suse.com> <CAKywueRn3R1P7FXAkMAOD0unbFvUAJcojEXrqT0=bUBCU9b8Jw@mail.gmail.com>
In-Reply-To: <CAKywueRn3R1P7FXAkMAOD0unbFvUAJcojEXrqT0=bUBCU9b8Jw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 6 Feb 2020 12:42:05 -0600
Message-ID: <CAH2r5msef+cygq8+m1L40X+W0E4YsK21V3fzR9A_wA90fL5K_A@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix mode bits from dir listing when mounted with modefromsid
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Aurelien Aptel <aaptel@suse.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I added stable already - will add your reviewed by as well. thx

On Thu, Feb 6, 2020 at 12:24 PM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> =D1=87=D1=82, 6 =D1=84=D0=B5=D0=B2=D1=80. 2020 =D0=B3. =D0=B2 09:17, Aure=
lien Aptel <aaptel@suse.com>:
> >
> > When mounting with -o modefromsid, the mode bits are stored in an
> > ACE. Directory enumeration (e.g. ls -l /mnt) triggers an SMB Query Dir
> > which does not include ACEs in its response. The mode bits in this
> > case are silently set to a default value of 755 instead.
> >
> > This patch marks the dentry created during the directory enumeration
> > as needing re-evaluation (i.e. additional Query Info with ACEs) so
> > that the mode bits can be properly extracted.
> >
> > Quick repro:
> >
> > $ mount.cifs //win19.test/data /mnt -o ...,modefromsid
> > $ touch /mnt/foo && chmod 751 /mnt/foo
> > $ stat /mnt/foo
> >   # reports 751 (OK)
> > $ sleep 2
> >   # dentry older than 1s by default get invalidated
> > $ ls -l /mnt
> >   # since dentry invalid, ls does a Query Dir
> >   # and reports foo as 755 (WRONG)
> >
> > Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> > ---
> >  fs/cifs/readdir.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> > index d17587c2c4ab..ba9dadf3be24 100644
> > --- a/fs/cifs/readdir.c
> > +++ b/fs/cifs/readdir.c
> > @@ -196,7 +196,8 @@ cifs_fill_common_info(struct cifs_fattr *fattr, str=
uct cifs_sb_info *cifs_sb)
> >          * may look wrong since the inodes may not have timed out by th=
e time
> >          * "ls" does a stat() call on them.
> >          */
> > -       if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL)
> > +       if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) ||
> > +           (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID))
> >                 fattr->cf_flags |=3D CIFS_FATTR_NEED_REVAL;
> >
> >         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL &&
> > --
> > 2.16.4
> >
>
> Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
>
> This patch needs stable tag since "modefromsid" was introduced in v5.5.
>
> --
> Best regards,
> Pavel Shilovsky



--=20
Thanks,

Steve
