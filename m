Return-Path: <SRS0=JvIj=SK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7313FC10F13
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Apr 2019 23:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A57720879
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Apr 2019 23:09:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GcxnDlbs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbfDHXJJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Apr 2019 19:09:09 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40549 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfDHXJJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Apr 2019 19:09:09 -0400
Received: by mail-lf1-f65.google.com with SMTP id a28so10753468lfo.7
        for <linux-cifs@vger.kernel.org>; Mon, 08 Apr 2019 16:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uLT4ptHD/cHUi2Djd/oMPL4jcWzTWkCpWMn2Q4PFTmM=;
        b=GcxnDlbs62a1nilR9xESXv1f/aSK8Fed1zFBM5J6YYltp+HhUprPYCVYQ3P359hRMe
         kqHZ+jHmQgut1/AMxDX3AP/3/C6oEjQUGMWdklXRBLqwGUs8/m/0nXYydhqkXcNvPdfY
         ZOHSSmDUxzQc0z3nGN9zaS2MdvZ3IumkVmZUAHlq+RT6Xjm24tduEbQEjfEchRVNvLyG
         GjJ1JMjd7+nydF7XPp6jJXHfry4jbA0D+sZauEkRvF9G9Dx/Ds/1//m74PNQv7T4Gt16
         Ug6XikUFiGlao9MWxGEjpdCBDXSHiuRdRbx7Pv955vCbg1I2MeRGJF+UO/mwOEFKyCHa
         oB+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uLT4ptHD/cHUi2Djd/oMPL4jcWzTWkCpWMn2Q4PFTmM=;
        b=JmkD4HiiwtF9MZPqrXzhO1rRVxld4cn9/1E9Cmaha6VRA8Eix0rf+7g/otBhDn7pkw
         Gc2yAZ7eZZPqyDWmnfInYj3j5ZUIgmDOsG2XcTDd+uQdXUkvRYXgw3T7TkELnt5g/wsu
         /5TlNN0CFIOrOxhGYjSvYkW0seBeK5uXn23DRYI8aa0i8HJtH34HJqD6DHjfWwDV4FqK
         zxvU7mtdRUT9vLDFIVRWWV/HxhkNX1BsLfhxV+nODyW2SHE7e6teS/a82o8vBUrkql3v
         t9HA1fKQ7tC/JIwxavVC0Rip7WQYvZpGjJUhk7ySkpJPtvO5iVKgfvEQJGra8N6XK6B4
         OW9w==
X-Gm-Message-State: APjAAAW+xZ0S0MtDcoWlse0Nz0uXhCQzNw7OsuWQ189i/OIuxgMskrWH
        RScWPOSdUV2m2WRQi4cWHIZ0kBE5Zp+ljFoHxQ==
X-Google-Smtp-Source: APXvYqyxx0qibBZSuEFSJllRc4Cw1R3kcxOoWN2gn24iC+ro2iM35cbbDo4CN1qThOOdKopWThgYvqZ+w/B6BJtMigE=
X-Received: by 2002:a05:6512:248:: with SMTP id b8mr16866105lfo.140.1554764947262;
 Mon, 08 Apr 2019 16:09:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190408145942.6448-1-jlayton@kernel.org> <CAH2r5mubno4Mbb4E3wKoPJ0-va7F2HjG--pk+o-BOwjM=zMprQ@mail.gmail.com>
 <CAH2r5msbqFGJ1tFXxowaXtBqPRLUMYwuj0WMEKn8qEDrsRkWqA@mail.gmail.com>
In-Reply-To: <CAH2r5msbqFGJ1tFXxowaXtBqPRLUMYwuj0WMEKn8qEDrsRkWqA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 8 Apr 2019 16:08:55 -0700
Message-ID: <CAKywueRyAc00eXHPLTLx1hHqKfJKAPAWA+c6uh3n8LReq-Ce5w@mail.gmail.com>
Subject: Re: [RFC PATCH] cifs: remove superfluous inode_lock in cifs_{strict_}fsync
To:     Steve French <smfrench@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Acked-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky

=D0=BF=D0=BD, 8 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 09:06, Steve French=
 <smfrench@gmail.com>:
>
> Restarted the automated tests after updating for-next and added this patc=
h ontop
>
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/b=
uilds/185
>
> On Mon, Apr 8, 2019 at 10:29 AM Steve French <smfrench@gmail.com> wrote:
> >
> > Kicked off automated tests with this patch included - see
> > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2=
/builds/184
> >  (I will kick off other test buckets later)
> >
> > On Mon, Apr 8, 2019 at 9:59 AM Jeff Layton <jlayton@kernel.org> wrote:
> > >
> > > Originally, filemap_write_and_wait took the i_mutex internally, but
> > > commit 02c24a82187d pushed the mutex acquisition into the individual
> > > fsync routines, leaving it up to the subsystem maintainers to remove
> > > it if it wasn't needed.
> > >
> > > For cifs, I see no reason to take the inode_lock here. All of the
> > > operations inside that lock are protected in other ways.
> > >
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/cifs/file.c | 5 -----
> > >  1 file changed, 5 deletions(-)
> > >
> > > Steve, would you or someone else be able to test this?
> > >
> > > I'm proposing a similar patch for kcephfs. I don't have an appropriat=
e
> > > test rig at the moment, and I was hoping someone more involved with
> > > cifs.ko development these days may be able to do so.
> > >
> > > Thanks,
> > > Jeff
> > >
> > > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > > index 89006e044973..c4b84fd423c3 100644
> > > --- a/fs/cifs/file.c
> > > +++ b/fs/cifs/file.c
> > > @@ -2424,7 +2424,6 @@ int cifs_strict_fsync(struct file *file, loff_t=
 start, loff_t end,
> > >         rc =3D file_write_and_wait_range(file, start, end);
> > >         if (rc)
> > >                 return rc;
> > > -       inode_lock(inode);
> > >
> > >         xid =3D get_xid();
> > >
> > > @@ -2449,7 +2448,6 @@ int cifs_strict_fsync(struct file *file, loff_t=
 start, loff_t end,
> > >         }
> > >
> > >         free_xid(xid);
> > > -       inode_unlock(inode);
> > >         return rc;
> > >  }
> > >
> > > @@ -2461,12 +2459,10 @@ int cifs_fsync(struct file *file, loff_t star=
t, loff_t end, int datasync)
> > >         struct TCP_Server_Info *server;
> > >         struct cifsFileInfo *smbfile =3D file->private_data;
> > >         struct cifs_sb_info *cifs_sb =3D CIFS_FILE_SB(file);
> > > -       struct inode *inode =3D file->f_mapping->host;
> > >
> > >         rc =3D file_write_and_wait_range(file, start, end);
> > >         if (rc)
> > >                 return rc;
> > > -       inode_lock(inode);
> > >
> > >         xid =3D get_xid();
> > >
> > > @@ -2483,7 +2479,6 @@ int cifs_fsync(struct file *file, loff_t start,=
 loff_t end, int datasync)
> > >         }
> > >
> > >         free_xid(xid);
> > > -       inode_unlock(inode);
> > >         return rc;
> > >  }
> > >
> > > --
> > > 2.20.1
> > >
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
