Return-Path: <SRS0=6r7N=3F=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 341F8C32771
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jan 2020 02:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0627E222C3
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jan 2020 02:03:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SmI5Tr8m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730355AbgAPCDY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Jan 2020 21:03:24 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:35601 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729431AbgAPCDY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Jan 2020 21:03:24 -0500
Received: by mail-io1-f66.google.com with SMTP id h8so20069532iob.2
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jan 2020 18:03:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc;
        bh=uLN8gvdsJzlF4d7rIsjRwvW4G+c/g0exjRqbdM0g7UU=;
        b=SmI5Tr8mB9n091pJcZdDQxTJY1Ssn2ekLsegJGz5OZRVsFqPuoFQ6vcdU7tvoFlRyv
         08le2PVmuJ1nUlj72ybU/riKSq9g39yuXMEc6W+y3FihDA7G0PmVvCJkepcwJ8bPeaC/
         lu3KE3D1vgwHP1Jpes4Tv9wA/cU2/ASfH2aKNULKNZylmYelH/4bWLqwGjhejq9gR1So
         3CP5dD4kwJpObDGryjy4iRHV9BCntNlYzuHS8vGMu6tQltKCPwfHiLfRr9V8WMzaiNLn
         /mxHB+qWothDU0niNhYrf0TBYcNXROtvzYTkEb0pgdVmeE7IP6uDvu3PtyaTYcXd2rPp
         X7Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc;
        bh=uLN8gvdsJzlF4d7rIsjRwvW4G+c/g0exjRqbdM0g7UU=;
        b=TnqJ+v0Du3+sJryYsO0FUrS4gMFpGYQ31LvGpdikU6jW3cPB0rqTGdTwEOoCfMTYx9
         oSIYWa5Ul/SecUIF4DS4wtlwVtQ+T6iT+KBHl6mkv5aCP2wWvrvv/jaOQdfL49hM2yvQ
         EOuWTE73DRPFVcI8qSt4mJv2bK+Ej41AV99vdNh653cuoiMcnVopMCTlhie6xWZS0oL5
         i2MTw32ocPbRLxnvfp4+x37wxc2lNqdBCD3Rk1/fDg1aADN0cSbhPEWZtmkUrx4jN9x2
         8xXYhiCcuJphQXayliLVfYUvAqT7CQhxkNQ69DxXhBJ+sKBROjL1cZXjL6KEPxMdhjeW
         5zQg==
X-Gm-Message-State: APjAAAWVnJgd+1JN6JmfcJiOY7ODUvYHGuOJftLdoSVDcu0kzVs4cMED
        KQLN6Ea8iRPlgRMrSwDk8iZm8FNzK0cr4gHCJpU=
X-Received: by 2002:a5d:84d1:: with SMTP id z17mt2700337ior.169.1579140203521;
 Wed, 15 Jan 2020 18:03:23 -0800 (PST)
MIME-Version: 1.0
References: <20200115012321.6780-1-lsahlber@redhat.com> <20200115012321.6780-2-lsahlber@redhat.com>
 <CAH2r5mst8zDCachJMZC-BgtJs2M7c1F+1VCf-Hfe68Qz0vQ8aQ@mail.gmail.com>
 <CAN05THSBKBw3Az8UUW8fuV_K9_e9is+po1Q05m8mbcd5Rv_uUw@mail.gmail.com> <CAH2r5msuycQNBXYdJQF-1pnmzJcikMD-e2mYUWQNCLA_SFFsvw@mail.gmail.com>
In-Reply-To: <CAH2r5msuycQNBXYdJQF-1pnmzJcikMD-e2mYUWQNCLA_SFFsvw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 15 Jan 2020 20:03:12 -0600
Message-ID: <CAH2r5mumEjNcCT=Dc4CMatjprWgBDGVS-3nsds2QqPoZMs8xZQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: add support for fallocate mode 0 for non-sparse files
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

temporarily removed to allow Ronnie to debug a test failure

On Wed, Jan 15, 2020 at 2:14 PM Steve French <smfrench@gmail.com> wrote:
>
> Tentatively merged into cifs-2.6.git for-next pending more testing
>
> On Tue, Jan 14, 2020 at 8:25 PM ronnie sahlberg
> <ronniesahlberg@gmail.com> wrote:
> >
> > On Wed, Jan 15, 2020 at 11:25 AM Steve French <smfrench@gmail.com> wrote:
> > >
> > > Does it affect (or enable) any xfstests?
> >
> > It shouldn't affect any current tests.
> > It adds support for
> >    xfs_io -c "falloc 0 512M" <file>
> >
> > generic/071 now passes with this patch.   Possibly other tests as well
> > that use "xfs_io -c falloc" as well
> >
> >
> > >
> > > On Tue, Jan 14, 2020 at 7:23 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> > > >
> > > > RHBZ 1336264
> > > >
> > > > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > > ---
> > > >  fs/cifs/smb2ops.c | 10 +++++++---
> > > >  1 file changed, 7 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > > > index 6250370c1170..91818f7c1b9c 100644
> > > > --- a/fs/cifs/smb2ops.c
> > > > +++ b/fs/cifs/smb2ops.c
> > > > @@ -3106,9 +3106,13 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
> > > >                 else if (i_size_read(inode) >= off + len)
> > > >                         /* not extending file and already not sparse */
> > > >                         rc = 0;
> > > > -               /* BB: in future add else clause to extend file */
> > > > -               else
> > > > -                       rc = -EOPNOTSUPP;
> > > > +               /* extend file */
> > > > +               else {
> > > > +                       eof = cpu_to_le64(off + len);
> > > > +                       rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
> > > > +                                         cfile->fid.volatile_fid, cfile->pid,
> > > > +                                         &eof);
> > > > +               }
> > > >                 if (rc)
> > > >                         trace_smb3_falloc_err(xid, cfile->fid.persistent_fid,
> > > >                                 tcon->tid, tcon->ses->Suid, off, len, rc);
> > > > --
> > > > 2.13.6
> > > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
