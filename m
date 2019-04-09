Return-Path: <SRS0=suyG=SL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00796C10F13
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Apr 2019 00:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2381213F2
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Apr 2019 00:29:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GfOEgO22"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfDIA3f (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Apr 2019 20:29:35 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41365 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfDIA3f (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Apr 2019 20:29:35 -0400
Received: by mail-pg1-f196.google.com with SMTP id f6so8230877pgs.8
        for <linux-cifs@vger.kernel.org>; Mon, 08 Apr 2019 17:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2wYgpwm52p7oSkJ9uNjOWyk7Cvrjl3T+B8HQYE0rdSA=;
        b=GfOEgO22UCM64mOBnUz/cJjJzXzIgR+ovrIOnkhTEyfpZtkiiiFm7DvydthVQueCSj
         i3C1G2c4E9X61u2OWwVFUxKJwd1JZDj5t8VCLOrVbK2Qal4NXU/NXNH35OuRG+NH0yOz
         UqA6WvlQoRL8CDSXqbnknHDkLX/2A10V+cqZuY84B+CMo9RGEWd06hcZw5VbZS94NaLj
         TsE/yH0M1Xh4G64PNdrp8Ne5V09JXWpyiN8JbesYHO4+txNK6vtDNd7ucf0h1tITUrhk
         PsK7VI463IVIBR81QEF6bccpf72YmazSMQu+hZC3dKAA6+9uOn7wQyl7R6nCobjz7FRq
         ycLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2wYgpwm52p7oSkJ9uNjOWyk7Cvrjl3T+B8HQYE0rdSA=;
        b=XiOjcQDKtyCCJcGoEbriMFIteCWBUe7YkeCLHoWQ7QmlEc/LlC4PA5BUNUWWkquViy
         DMHTWxiB2DA3vqFajSoDmektN4HHLoBWAyiGV2aO6/Ryj9vq2L5krVjiUJzuGnbW+NrT
         +LYyw//Nt3cBnKXzgtdmx33LxAk8VgyPxsidzpd8JOwzd6ptJPK7zIA5atQe0V2jieyW
         Ifp/pEOu8318bZimfoHN6oZCvENO5lt2RwaorC4YT7L3mG1bz3xLhsEZvg2oWEeVMmuj
         9y9DSHSb7/ht+Po/A86Ra8+PqfyNayINV4WarKdv1R4mrTwFecdZUTzX3zjzHcT54Fqf
         2tlA==
X-Gm-Message-State: APjAAAVTmt1uaoVIzPBe6JeIXHx0v/uR1m8hoD39iiNEqGtUaP0HFet2
        Yj3g3cP5RnlTZyTfeSbVg9TDrO20JIUdToqFSkc=
X-Google-Smtp-Source: APXvYqwN1OT/4eCr98Es+sKptO4EpUXMhs31Skz44g1/X6eooESQ2ZkPK2doavVdI9O60bkKuTpESaIHyV3BIIUF3UI=
X-Received: by 2002:a63:525f:: with SMTP id s31mr31273918pgl.172.1554769774271;
 Mon, 08 Apr 2019 17:29:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190408145942.6448-1-jlayton@kernel.org> <CAH2r5mubno4Mbb4E3wKoPJ0-va7F2HjG--pk+o-BOwjM=zMprQ@mail.gmail.com>
 <CAH2r5msbqFGJ1tFXxowaXtBqPRLUMYwuj0WMEKn8qEDrsRkWqA@mail.gmail.com> <CAKywueRyAc00eXHPLTLx1hHqKfJKAPAWA+c6uh3n8LReq-Ce5w@mail.gmail.com>
In-Reply-To: <CAKywueRyAc00eXHPLTLx1hHqKfJKAPAWA+c6uh3n8LReq-Ce5w@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 8 Apr 2019 19:29:22 -0500
Message-ID: <CAH2r5musOpBpu0XXg2_ztrHkAFtXBor2aJV6=3gud12Q1xCbCw@mail.gmail.com>
Subject: Re: [RFC PATCH] cifs: remove superfluous inode_lock in cifs_{strict_}fsync
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

It passed automated testing (the most recent test bucket run was
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/bui=
lds/141
but it also passed the other test group
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/bui=
lds/185)


On Mon, Apr 8, 2019 at 6:09 PM Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
> Acked-by: Pavel Shilovsky <pshilov@microsoft.com>
>
> --
> Best regards,
> Pavel Shilovsky
>
> =D0=BF=D0=BD, 8 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 09:06, Steve Fren=
ch <smfrench@gmail.com>:
> >
> > Restarted the automated tests after updating for-next and added this pa=
tch ontop
> >
> > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2=
/builds/185
> >
> > On Mon, Apr 8, 2019 at 10:29 AM Steve French <smfrench@gmail.com> wrote=
:
> > >
> > > Kicked off automated tests with this patch included - see
> > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders=
/2/builds/184
> > >  (I will kick off other test buckets later)
> > >
> > > On Mon, Apr 8, 2019 at 9:59 AM Jeff Layton <jlayton@kernel.org> wrote=
:
> > > >
> > > > Originally, filemap_write_and_wait took the i_mutex internally, but
> > > > commit 02c24a82187d pushed the mutex acquisition into the individua=
l
> > > > fsync routines, leaving it up to the subsystem maintainers to remov=
e
> > > > it if it wasn't needed.
> > > >
> > > > For cifs, I see no reason to take the inode_lock here. All of the
> > > > operations inside that lock are protected in other ways.
> > > >
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > ---
> > > >  fs/cifs/file.c | 5 -----
> > > >  1 file changed, 5 deletions(-)
> > > >
> > > > Steve, would you or someone else be able to test this?
> > > >
> > > > I'm proposing a similar patch for kcephfs. I don't have an appropri=
ate
> > > > test rig at the moment, and I was hoping someone more involved with
> > > > cifs.ko development these days may be able to do so.
> > > >
> > > > Thanks,
> > > > Jeff
> > > >
> > > > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > > > index 89006e044973..c4b84fd423c3 100644
> > > > --- a/fs/cifs/file.c
> > > > +++ b/fs/cifs/file.c
> > > > @@ -2424,7 +2424,6 @@ int cifs_strict_fsync(struct file *file, loff=
_t start, loff_t end,
> > > >         rc =3D file_write_and_wait_range(file, start, end);
> > > >         if (rc)
> > > >                 return rc;
> > > > -       inode_lock(inode);
> > > >
> > > >         xid =3D get_xid();
> > > >
> > > > @@ -2449,7 +2448,6 @@ int cifs_strict_fsync(struct file *file, loff=
_t start, loff_t end,
> > > >         }
> > > >
> > > >         free_xid(xid);
> > > > -       inode_unlock(inode);
> > > >         return rc;
> > > >  }
> > > >
> > > > @@ -2461,12 +2459,10 @@ int cifs_fsync(struct file *file, loff_t st=
art, loff_t end, int datasync)
> > > >         struct TCP_Server_Info *server;
> > > >         struct cifsFileInfo *smbfile =3D file->private_data;
> > > >         struct cifs_sb_info *cifs_sb =3D CIFS_FILE_SB(file);
> > > > -       struct inode *inode =3D file->f_mapping->host;
> > > >
> > > >         rc =3D file_write_and_wait_range(file, start, end);
> > > >         if (rc)
> > > >                 return rc;
> > > > -       inode_lock(inode);
> > > >
> > > >         xid =3D get_xid();
> > > >
> > > > @@ -2483,7 +2479,6 @@ int cifs_fsync(struct file *file, loff_t star=
t, loff_t end, int datasync)
> > > >         }
> > > >
> > > >         free_xid(xid);
> > > > -       inode_unlock(inode);
> > > >         return rc;
> > > >  }
> > > >
> > > > --
> > > > 2.20.1
> > > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve



--=20
Thanks,

Steve
