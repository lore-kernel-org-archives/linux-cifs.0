Return-Path: <SRS0=xi6A=3E=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57796C32771
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Jan 2020 20:14:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28CD12081E
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Jan 2020 20:14:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vFbncP17"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgAOUOk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Jan 2020 15:14:40 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:38973 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729026AbgAOUOk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Jan 2020 15:14:40 -0500
Received: by mail-il1-f196.google.com with SMTP id x5so16002384ila.6
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jan 2020 12:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z4x/bNigK1hHFsmtqMIgeyiuWGi7SMyuAKn4IDjblVQ=;
        b=vFbncP17eEke4xrJ1ZANAm++e6+C3kgPh/JtZBbUCH5hFfg40+8wqgvdVtyTgiZZW4
         l409AC6bEgR6UNbU6gL6m9kzFAFt+yUbVKVpnzivrOvnbpyyaVuXi1tNB/hfamRaOYDE
         pnfxhUKseWc9UDB+XIChycztjhDHhOrombdfRGQAOYnovx9g45OU5Cuv+ou9VmAy1gL2
         Wwazp7+UwG6ett4JBLncVQGhsBy4TsD31cZ2fshkO04Pq/1pqtfqy9+ILQNy2Qmvbzt/
         QcvXfVZFpHFJRbeO/OixIOOeZNuA/5YU8dsFiPhyqmy/fCNDLN8zNQAewD/TD3dRg4P2
         GbLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z4x/bNigK1hHFsmtqMIgeyiuWGi7SMyuAKn4IDjblVQ=;
        b=L8upwh+rTSGQN1/6Mto5yh0JAIxh7Ltfpi1/MYYxV/RsJ510w4jmcuwR4lTCfoyJiK
         ODHoXvlQbhZ8/0tl8obs0X8fKxa53GVYDZG+E8v8KCn2D36P9s328ty38uBGIIcNJHX+
         M+jdADt3eDfn1dFIn0F891qy2XNv68gQSu1LNXBzpvQtNzfKYTZEqOvEflCH3pk9nMz4
         ZK+M2PKMXO9VqbrI5gMB16OAVa1l6hYgyMWUb4SsNYfdIuaSUMNh5XDeZx682aVNzYcn
         c0J+e6NCsuEwD11wllzK4mYOccQEj8B6ZADAS32NjdN5zVWQj+16yRN7saaV5zBN7lnS
         C2Rw==
X-Gm-Message-State: APjAAAVVT5kvPtmM50x02AsJtoR9oWqXDIAgdUeE4tHqB5AhuFayR7Vo
        eksbplqNaFE7ynky2zvEpZ/OSjygZO+xyufoXng=
X-Google-Smtp-Source: APXvYqyuv3QnZ/OherhntudAm5igU58HXcsvd6uUXbpmQ2X8tV3X0eE1h+xqMwUXd/4vnBshwfX6+OJQG0miUcNusx4=
X-Received: by 2002:a92:cb8c:: with SMTP id z12mr252848ilo.5.1579119279930;
 Wed, 15 Jan 2020 12:14:39 -0800 (PST)
MIME-Version: 1.0
References: <20200115012321.6780-1-lsahlber@redhat.com> <20200115012321.6780-2-lsahlber@redhat.com>
 <CAH2r5mst8zDCachJMZC-BgtJs2M7c1F+1VCf-Hfe68Qz0vQ8aQ@mail.gmail.com> <CAN05THSBKBw3Az8UUW8fuV_K9_e9is+po1Q05m8mbcd5Rv_uUw@mail.gmail.com>
In-Reply-To: <CAN05THSBKBw3Az8UUW8fuV_K9_e9is+po1Q05m8mbcd5Rv_uUw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 15 Jan 2020 14:14:28 -0600
Message-ID: <CAH2r5msuycQNBXYdJQF-1pnmzJcikMD-e2mYUWQNCLA_SFFsvw@mail.gmail.com>
Subject: Re: [PATCH] cifs: add support for fallocate mode 0 for non-sparse files
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Tentatively merged into cifs-2.6.git for-next pending more testing

On Tue, Jan 14, 2020 at 8:25 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> On Wed, Jan 15, 2020 at 11:25 AM Steve French <smfrench@gmail.com> wrote:
> >
> > Does it affect (or enable) any xfstests?
>
> It shouldn't affect any current tests.
> It adds support for
>    xfs_io -c "falloc 0 512M" <file>
>
> generic/071 now passes with this patch.   Possibly other tests as well
> that use "xfs_io -c falloc" as well
>
>
> >
> > On Tue, Jan 14, 2020 at 7:23 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> > >
> > > RHBZ 1336264
> > >
> > > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > ---
> > >  fs/cifs/smb2ops.c | 10 +++++++---
> > >  1 file changed, 7 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > > index 6250370c1170..91818f7c1b9c 100644
> > > --- a/fs/cifs/smb2ops.c
> > > +++ b/fs/cifs/smb2ops.c
> > > @@ -3106,9 +3106,13 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
> > >                 else if (i_size_read(inode) >= off + len)
> > >                         /* not extending file and already not sparse */
> > >                         rc = 0;
> > > -               /* BB: in future add else clause to extend file */
> > > -               else
> > > -                       rc = -EOPNOTSUPP;
> > > +               /* extend file */
> > > +               else {
> > > +                       eof = cpu_to_le64(off + len);
> > > +                       rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
> > > +                                         cfile->fid.volatile_fid, cfile->pid,
> > > +                                         &eof);
> > > +               }
> > >                 if (rc)
> > >                         trace_smb3_falloc_err(xid, cfile->fid.persistent_fid,
> > >                                 tcon->tid, tcon->ses->Suid, off, len, rc);
> > > --
> > > 2.13.6
> > >
> >
> >
> > --
> > Thanks,
> >
> > Steve



-- 
Thanks,

Steve
