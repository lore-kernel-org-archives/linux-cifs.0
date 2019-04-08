Return-Path: <SRS0=JvIj=SK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E60AC10F13
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Apr 2019 15:41:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D8062147A
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Apr 2019 15:41:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GFTRpsIS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbfDHPl4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Apr 2019 11:41:56 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:32892 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbfDHPlz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Apr 2019 11:41:55 -0400
Received: by mail-pl1-f193.google.com with SMTP id t16so7565481plo.0
        for <linux-cifs@vger.kernel.org>; Mon, 08 Apr 2019 08:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pq/xRVb0yxVBPo3D+YlTt0YJ1tKx+OiJKSrUEbQGuNk=;
        b=GFTRpsISSLhaLxq42xszVAsF0zqUHHom1x3JIZsR4nStn5GyD205es9IPlYwlJ3TMV
         XOoIiA6BOY65+Xn2nSc5+TXQ3+07qogHABmZOhUEE5YnjRI6xG0Baljx8qtxgsb+Y4om
         xXJqZT8gzE5sLqvW+BFSm7jLxDXp9iYuwiLFbZiJncSFe+1DVaiN3K3Vf8QkWjcjqFEf
         F5pruEBGDinkutUa9yIfXGuTITjgXsUNNxEhI8LOfnVHROKPWUoMYVCpCuqmLav9sbd6
         Va77+6wOzp2UI8jvOTascUiH4JAWobeu4ON7HLTBf8aC/OR9VJ1sssw4rO3E/i1N7weo
         fkpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pq/xRVb0yxVBPo3D+YlTt0YJ1tKx+OiJKSrUEbQGuNk=;
        b=OrnFcS4Ju3n8Pp5uyaLZmssBpZRvFSpory0BVn0AJxJwD1UYbUR5CvHKnipfp3pVby
         nnE+HUpnI2+IZzd+3M2t3cFYA6v0dtzMpexja3f/EhU31GF8AK9pcDY5Xo7qGPqzicEt
         FFw7aQJ/hRSgroXBCZu32G0cukKVO/f+e5rmJ4Rk+3LqcCOUYngu5yMCLAj6512M+iYm
         09d5KK1CxcxnQf5L4jNwROgLQ6+XUS+7mBfRfhcheqkvevaTbs8rwK1FpM8CW768S2aK
         t9c0vlBWyHSUi8WXaPqHcyHJTbd80A/cwdQD9NVG3e/y30lB/IyRRHNvbJ1Q5bm/xamE
         9UoA==
X-Gm-Message-State: APjAAAUGNDG1wFsRs4193poP7T5fKXUrzFxF1wfk8x8N6iTUYGjAN7Fv
        5SHdcoOMY3K9xru/nJbnGgtyzaNXAPzqdZo7cW+Qx5we
X-Google-Smtp-Source: APXvYqwlo0gRw52BNteBPfX7DnpTxbAZR+nelw2/HMmPiKnN8r8IQIwv3xCOglgweowVaLnnSyVspGob9H8/CudiEps=
X-Received: by 2002:a17:902:9006:: with SMTP id a6mr30161466plp.259.1554738114831;
 Mon, 08 Apr 2019 08:41:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190408145942.6448-1-jlayton@kernel.org> <CAH2r5mubno4Mbb4E3wKoPJ0-va7F2HjG--pk+o-BOwjM=zMprQ@mail.gmail.com>
In-Reply-To: <CAH2r5mubno4Mbb4E3wKoPJ0-va7F2HjG--pk+o-BOwjM=zMprQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 8 Apr 2019 10:41:43 -0500
Message-ID: <CAH2r5msbqFGJ1tFXxowaXtBqPRLUMYwuj0WMEKn8qEDrsRkWqA@mail.gmail.com>
Subject: Re: [RFC PATCH] cifs: remove superfluous inode_lock in cifs_{strict_}fsync
To:     Jeff Layton <jlayton@kernel.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Restarted the automated tests after updating for-next and added this patch ontop

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/185

On Mon, Apr 8, 2019 at 10:29 AM Steve French <smfrench@gmail.com> wrote:
>
> Kicked off automated tests with this patch included - see
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/184
>  (I will kick off other test buckets later)
>
> On Mon, Apr 8, 2019 at 9:59 AM Jeff Layton <jlayton@kernel.org> wrote:
> >
> > Originally, filemap_write_and_wait took the i_mutex internally, but
> > commit 02c24a82187d pushed the mutex acquisition into the individual
> > fsync routines, leaving it up to the subsystem maintainers to remove
> > it if it wasn't needed.
> >
> > For cifs, I see no reason to take the inode_lock here. All of the
> > operations inside that lock are protected in other ways.
> >
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/cifs/file.c | 5 -----
> >  1 file changed, 5 deletions(-)
> >
> > Steve, would you or someone else be able to test this?
> >
> > I'm proposing a similar patch for kcephfs. I don't have an appropriate
> > test rig at the moment, and I was hoping someone more involved with
> > cifs.ko development these days may be able to do so.
> >
> > Thanks,
> > Jeff
> >
> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > index 89006e044973..c4b84fd423c3 100644
> > --- a/fs/cifs/file.c
> > +++ b/fs/cifs/file.c
> > @@ -2424,7 +2424,6 @@ int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
> >         rc = file_write_and_wait_range(file, start, end);
> >         if (rc)
> >                 return rc;
> > -       inode_lock(inode);
> >
> >         xid = get_xid();
> >
> > @@ -2449,7 +2448,6 @@ int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
> >         }
> >
> >         free_xid(xid);
> > -       inode_unlock(inode);
> >         return rc;
> >  }
> >
> > @@ -2461,12 +2459,10 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
> >         struct TCP_Server_Info *server;
> >         struct cifsFileInfo *smbfile = file->private_data;
> >         struct cifs_sb_info *cifs_sb = CIFS_FILE_SB(file);
> > -       struct inode *inode = file->f_mapping->host;
> >
> >         rc = file_write_and_wait_range(file, start, end);
> >         if (rc)
> >                 return rc;
> > -       inode_lock(inode);
> >
> >         xid = get_xid();
> >
> > @@ -2483,7 +2479,6 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
> >         }
> >
> >         free_xid(xid);
> > -       inode_unlock(inode);
> >         return rc;
> >  }
> >
> > --
> > 2.20.1
> >
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
