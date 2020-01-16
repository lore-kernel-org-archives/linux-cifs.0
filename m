Return-Path: <SRS0=6r7N=3F=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C70C1C33CB1
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jan 2020 08:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AAEF2073A
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jan 2020 08:42:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O3fwlr22"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgAPImk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Jan 2020 03:42:40 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:43973 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgAPImk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Jan 2020 03:42:40 -0500
Received: by mail-io1-f66.google.com with SMTP id n21so20844481ioo.10
        for <linux-cifs@vger.kernel.org>; Thu, 16 Jan 2020 00:42:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xIFI4+cGZkzyjo9sgL1qeM64lzBdQDxXx0KpFVgXeSw=;
        b=O3fwlr22HE+lyG7sH7zj2m1b9s17No9rUFX5lDdYm0GXGEh3dbQ3bOQucKl91Wy/iS
         Wv5TXp7MCd1xDzHpe8HKjqU/1pQtxWDhL3fDzHLWJZBorHg+UQZyKj4R9Y6bGauStwW7
         7ZzJGmaaGFYEjY0ISVwdt5TSFAAopqVkXlEpB8bEpzdQ564pr4B1Xn67pxdI49NKQiUl
         yuZ/50IR1vwY6/IxKFg7b96k9dv/6MSasHdiScrDdaPFaZ2/0siKuJwaYYRT4nk4sE1e
         X6bV3UfcwDkrfFfDfzRhtXMAP1qURoWWP8qPnpI/Fs9XDXblZjf2uepAFY/t4pLyjAuy
         HxSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xIFI4+cGZkzyjo9sgL1qeM64lzBdQDxXx0KpFVgXeSw=;
        b=T27WdDW5OvbCIaJHjNMJdfia1hDopqA0feT5RKdzQSlxR6wtLasZZDJ/9mRymgJuG9
         yWO6yBME3jKOU28+MaaR4v6sMNg0CbI92XPQ2WNNPLtk2XPPE98W5kPTOMAykIw4buUD
         KZLAgDozDCHqkGsOsc4px4DHO2cXq6tE1AcqT5w0hucxfp5Nvoc/bmStHoAzmPVtwNyF
         EUCVafGFUdqPxJ8XYsffXDFwEbS4lXh4H04HsBV7gaiETdX7CexmJA/dvqOu9k4Iy8WB
         3GWyvU5569pNLFex/PmTUeeG9nBukN6bGDLaUnuTSteakv2+IpKU83xMfHu/KumEf/Mh
         m2tA==
X-Gm-Message-State: APjAAAX52fVvEDm/muRwR2+YmIBPYhx8ndEKL6OUqhZgyIaGZhkoeYxw
        tRue3dAuYzCZepWhEE2eclkkpOJymh5+hOMD7OU=
X-Google-Smtp-Source: APXvYqxna9MExzNJp1JjER1jPDep5e/NwaSbF/LWoANtPOQx6shXC7+wCCl4fIYIK4xkpPiW3hZXEoXgsUfxlq3fi1k=
X-Received: by 2002:a02:b897:: with SMTP id p23mr28304483jam.58.1579164159379;
 Thu, 16 Jan 2020 00:42:39 -0800 (PST)
MIME-Version: 1.0
References: <20200115012321.6780-1-lsahlber@redhat.com> <20200115012321.6780-2-lsahlber@redhat.com>
 <CAH2r5mst8zDCachJMZC-BgtJs2M7c1F+1VCf-Hfe68Qz0vQ8aQ@mail.gmail.com>
 <CAN05THSBKBw3Az8UUW8fuV_K9_e9is+po1Q05m8mbcd5Rv_uUw@mail.gmail.com>
 <CAH2r5msuycQNBXYdJQF-1pnmzJcikMD-e2mYUWQNCLA_SFFsvw@mail.gmail.com> <CAH2r5mumEjNcCT=Dc4CMatjprWgBDGVS-3nsds2QqPoZMs8xZQ@mail.gmail.com>
In-Reply-To: <CAH2r5mumEjNcCT=Dc4CMatjprWgBDGVS-3nsds2QqPoZMs8xZQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 16 Jan 2020 18:42:28 +1000
Message-ID: <CAN05THRbNrd=ZmSMO4yE8oHD3Xn93zNTMBRXnJBuf7J3C5Cmow@mail.gmail.com>
Subject: Re: [PATCH] cifs: add support for fallocate mode 0 for non-sparse files
To:     Steve French <smfrench@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The bug is basically that if we extend a file by fallocate mode==0
and immediately afterwards mmap() the file we will only mmap() as much
as end-of-file was
prior to the truncate  and then if we try to touch any
address in this extended region userspace dies with bus error.

The patch added "extend a file with fallocate mode==0 for NON-Sparse
files" and caused xfstest to fail.
The fix is to force us to revalidate the file attributes (the size is
the important one) when we extend the file so
mmap() will work properly.
I have fixed this in the patch and will resend tomorrow after some more testing.

Looking for other SMB2_set_eof() callsites I see we already had the
same bug for the case of extending a SPARSE
file using fallocate mode==0. I fixed that too and will audit all
other plases where we use SMB2_set_eof()
to see if they are safe or not before resending.


On Thu, Jan 16, 2020 at 12:33 PM Steve French <smfrench@gmail.com> wrote:
>
> temporarily removed to allow Ronnie to debug a test failure
>
> On Wed, Jan 15, 2020 at 2:14 PM Steve French <smfrench@gmail.com> wrote:
> >
> > Tentatively merged into cifs-2.6.git for-next pending more testing
> >
> > On Tue, Jan 14, 2020 at 8:25 PM ronnie sahlberg
> > <ronniesahlberg@gmail.com> wrote:
> > >
> > > On Wed, Jan 15, 2020 at 11:25 AM Steve French <smfrench@gmail.com> wrote:
> > > >
> > > > Does it affect (or enable) any xfstests?
> > >
> > > It shouldn't affect any current tests.
> > > It adds support for
> > >    xfs_io -c "falloc 0 512M" <file>
> > >
> > > generic/071 now passes with this patch.   Possibly other tests as well
> > > that use "xfs_io -c falloc" as well
> > >
> > >
> > > >
> > > > On Tue, Jan 14, 2020 at 7:23 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> > > > >
> > > > > RHBZ 1336264
> > > > >
> > > > > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > > > ---
> > > > >  fs/cifs/smb2ops.c | 10 +++++++---
> > > > >  1 file changed, 7 insertions(+), 3 deletions(-)
> > > > >
> > > > > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > > > > index 6250370c1170..91818f7c1b9c 100644
> > > > > --- a/fs/cifs/smb2ops.c
> > > > > +++ b/fs/cifs/smb2ops.c
> > > > > @@ -3106,9 +3106,13 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
> > > > >                 else if (i_size_read(inode) >= off + len)
> > > > >                         /* not extending file and already not sparse */
> > > > >                         rc = 0;
> > > > > -               /* BB: in future add else clause to extend file */
> > > > > -               else
> > > > > -                       rc = -EOPNOTSUPP;
> > > > > +               /* extend file */
> > > > > +               else {
> > > > > +                       eof = cpu_to_le64(off + len);
> > > > > +                       rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
> > > > > +                                         cfile->fid.volatile_fid, cfile->pid,
> > > > > +                                         &eof);
> > > > > +               }
> > > > >                 if (rc)
> > > > >                         trace_smb3_falloc_err(xid, cfile->fid.persistent_fid,
> > > > >                                 tcon->tid, tcon->ses->Suid, off, len, rc);
> > > > > --
> > > > > 2.13.6
> > > > >
> > > >
> > > >
> > > > --
> > > > Thanks,
> > > >
> > > > Steve
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
> Thanks,
>
> Steve
