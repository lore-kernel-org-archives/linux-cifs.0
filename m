Return-Path: <SRS0=xi6A=3E=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30262C33C9E
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Jan 2020 02:25:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3F4B24671
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Jan 2020 02:25:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SrTD4RHm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgAOCZX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Jan 2020 21:25:23 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:33177 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728862AbgAOCZX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 14 Jan 2020 21:25:23 -0500
Received: by mail-io1-f66.google.com with SMTP id z8so16168273ioh.0
        for <linux-cifs@vger.kernel.org>; Tue, 14 Jan 2020 18:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gHsRAlzy9F9r5LOpVKNq/+Y34mwPj1tgQJ+nVCqCuWU=;
        b=SrTD4RHmzMxq2/IMoqDzz/pBry3FXQlEZJu1HWAtYIZk8DYY2WSD0JkS6BPjKyafso
         w6j+JW5JEbCg0BNEjHbz7vTkJiB7NjVv1iTGLdL0M1FHendtE1TZaayYbDGnfAA+Dt2X
         TA4Psyz0/2KLmFLwEE7TniUruozIhHLVI3VyxZYN4J9cAJkJYeHxKqs6PBfJmKPwLYQj
         F3BtB22t12YhbbJPKu3Lbn/Rk4U9OdsPR2Y0rp442zAtHs3eIqdoIpdQva58EYMUnScR
         iV4VSwtGthc2Ff82fx+V4YM1goHl0Hule+IEfNhQCpZw9mD0FbXh0Vlj1tI9ThzZ1/1n
         STrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gHsRAlzy9F9r5LOpVKNq/+Y34mwPj1tgQJ+nVCqCuWU=;
        b=jbuRsCPxuWELLyPnCYfqOAR8H3s8dCejyyTbjB7HAt6aqjwZzW/aIRoekDlVXeZU6z
         1U/cMz5XhcwN8vrB0PmJQOhwQmY8ga5jNKH1DbTk07iq9kYEMwK6aklF1gY0SxlJdFga
         ckm4kOdEhmIunWjStaftoHd3IayXPTJbmUphU6VHycqQ6OrgPWQAJyuFVh+6h0QxVuVf
         zy8CM65mTJhSrJkI9qdEdPJ99J8vfCwL0BBTgqxLbNsmwTMsQcmtVXA7IULp3sSxv+6G
         cCrELScNdrz1iz+JdZzLIDwhKwVQsQy3WIQ+wXcXcliZpA6CpJE7qxtDPwZ+CVF1yRZF
         0mzA==
X-Gm-Message-State: APjAAAUaodL5aG8hnt+a5BRDra7nCxPpDuf+9m7HoA3Pb0M6gjPGRk5N
        vv/q8AmsBTm89UY09xmoXJy3n9hJKOmSxT1cPl8=
X-Google-Smtp-Source: APXvYqx8H9UvzUE2dV5tVyvFHQMoorydyeXC/hvA6kUkEEEQXIP3Zh4YGxwaATU9B9UfT45Tz9YxHjFHqNtrWmlpPnY=
X-Received: by 2002:a05:6638:a99:: with SMTP id 25mr22476942jas.37.1579055122697;
 Tue, 14 Jan 2020 18:25:22 -0800 (PST)
MIME-Version: 1.0
References: <20200115012321.6780-1-lsahlber@redhat.com> <20200115012321.6780-2-lsahlber@redhat.com>
 <CAH2r5mst8zDCachJMZC-BgtJs2M7c1F+1VCf-Hfe68Qz0vQ8aQ@mail.gmail.com>
In-Reply-To: <CAH2r5mst8zDCachJMZC-BgtJs2M7c1F+1VCf-Hfe68Qz0vQ8aQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 15 Jan 2020 12:25:11 +1000
Message-ID: <CAN05THSBKBw3Az8UUW8fuV_K9_e9is+po1Q05m8mbcd5Rv_uUw@mail.gmail.com>
Subject: Re: [PATCH] cifs: add support for fallocate mode 0 for non-sparse files
To:     Steve French <smfrench@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jan 15, 2020 at 11:25 AM Steve French <smfrench@gmail.com> wrote:
>
> Does it affect (or enable) any xfstests?

It shouldn't affect any current tests.
It adds support for
   xfs_io -c "falloc 0 512M" <file>

generic/071 now passes with this patch.   Possibly other tests as well
that use "xfs_io -c falloc" as well


>
> On Tue, Jan 14, 2020 at 7:23 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> >
> > RHBZ 1336264
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/smb2ops.c | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index 6250370c1170..91818f7c1b9c 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -3106,9 +3106,13 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
> >                 else if (i_size_read(inode) >= off + len)
> >                         /* not extending file and already not sparse */
> >                         rc = 0;
> > -               /* BB: in future add else clause to extend file */
> > -               else
> > -                       rc = -EOPNOTSUPP;
> > +               /* extend file */
> > +               else {
> > +                       eof = cpu_to_le64(off + len);
> > +                       rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
> > +                                         cfile->fid.volatile_fid, cfile->pid,
> > +                                         &eof);
> > +               }
> >                 if (rc)
> >                         trace_smb3_falloc_err(xid, cfile->fid.persistent_fid,
> >                                 tcon->tid, tcon->ses->Suid, off, len, rc);
> > --
> > 2.13.6
> >
>
>
> --
> Thanks,
>
> Steve
