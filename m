Return-Path: <SRS0=JvIj=SK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13BCAC10F13
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Apr 2019 15:29:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D59502147A
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Apr 2019 15:29:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EueozKTD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfDHP3d (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Apr 2019 11:29:33 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35201 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbfDHP3d (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Apr 2019 11:29:33 -0400
Received: by mail-pg1-f196.google.com with SMTP id g8so7533376pgf.2
        for <linux-cifs@vger.kernel.org>; Mon, 08 Apr 2019 08:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iWQfd3QfRBkh8xRf1o8kVBf11QKIpt2IAgGEJ1e9TAc=;
        b=EueozKTDnKaDxsSeCxLcg7IOKXJRkaqCxkZFxLoqA1e1/xx5Bw/9AF19SkgcAV6e14
         0ov2oyLWWOc3j7rG6mJ49lkZPsN/ijRTSxfTbah57V49sTyRe+yok5JYFXN55H2P8hGE
         uBynyICZMPkhxw09NToDWsmAte2nG2Cfx8b6KJHUY9SJC8LDDIQI5qQ05neYycvLfCMr
         YnHwJeOvY+XgdtEzpTwWHAbibMoFbaS+LgpSs0PyU5M9aOcism1ex+0C2m3xNDzvjf5V
         LNkIufTi7a83PPwxmIZb+Td+XcdiZPbRuZf3PVLeJI6SvXSFdiNtEUc338oCm2YPifTf
         DMgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iWQfd3QfRBkh8xRf1o8kVBf11QKIpt2IAgGEJ1e9TAc=;
        b=UlyKeC7iC6KjQjm4ZeK4ENIiwIJ2KfVhh7KwNsqk5zBIDNP7L2SRvyuWdPD7mscoFm
         zaAjnbNn3rr4AGPz8M4co51+B/qJG6+v5K+OUbnYe1SXwHQYQHpmUMUOJw4u4aycd4vh
         4EsO2BN4HuMm1L17zsgzX4scmE/09565ceC70kPNy/A/J2ECoRVgeU84Vw1EG3AZVpkW
         z62x35PK966POkULfrRgs79vKYEC0kcxHp+NnjP6QRjtPdgVpkZQIgob4FAVl3pDwzkj
         hckxVf/zXHtTNOqSY6T7ttuXwIbNXGAyorCd/bL5fLFyKHHxrI9l7ScRi4TRE7wSzHrT
         4Y6w==
X-Gm-Message-State: APjAAAUNBFOUhqSgUCtvwzlpc+StV5LHMOCGXH0YSeXn/JTz0msFJVr7
        htDmOw5/pQGqYl6Vvk3xYUmHq4RYN7+jCTOw5DxMsGyL
X-Google-Smtp-Source: APXvYqw2KRPeRbfoNtEiB48L93po0RRW/EJPIJC2JeErkhk7zRti4u+aafygV/hchSthAwAVAhycivC1x2Iv/Rdrp3w=
X-Received: by 2002:a63:d302:: with SMTP id b2mr28625486pgg.13.1554737372583;
 Mon, 08 Apr 2019 08:29:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190408145942.6448-1-jlayton@kernel.org>
In-Reply-To: <20190408145942.6448-1-jlayton@kernel.org>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 8 Apr 2019 10:29:20 -0500
Message-ID: <CAH2r5mubno4Mbb4E3wKoPJ0-va7F2HjG--pk+o-BOwjM=zMprQ@mail.gmail.com>
Subject: Re: [RFC PATCH] cifs: remove superfluous inode_lock in cifs_{strict_}fsync
To:     Jeff Layton <jlayton@kernel.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Kicked off automated tests with this patch included - see
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/184
 (I will kick off other test buckets later)

On Mon, Apr 8, 2019 at 9:59 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> Originally, filemap_write_and_wait took the i_mutex internally, but
> commit 02c24a82187d pushed the mutex acquisition into the individual
> fsync routines, leaving it up to the subsystem maintainers to remove
> it if it wasn't needed.
>
> For cifs, I see no reason to take the inode_lock here. All of the
> operations inside that lock are protected in other ways.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/cifs/file.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> Steve, would you or someone else be able to test this?
>
> I'm proposing a similar patch for kcephfs. I don't have an appropriate
> test rig at the moment, and I was hoping someone more involved with
> cifs.ko development these days may be able to do so.
>
> Thanks,
> Jeff
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 89006e044973..c4b84fd423c3 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2424,7 +2424,6 @@ int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
>         rc = file_write_and_wait_range(file, start, end);
>         if (rc)
>                 return rc;
> -       inode_lock(inode);
>
>         xid = get_xid();
>
> @@ -2449,7 +2448,6 @@ int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
>         }
>
>         free_xid(xid);
> -       inode_unlock(inode);
>         return rc;
>  }
>
> @@ -2461,12 +2459,10 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>         struct TCP_Server_Info *server;
>         struct cifsFileInfo *smbfile = file->private_data;
>         struct cifs_sb_info *cifs_sb = CIFS_FILE_SB(file);
> -       struct inode *inode = file->f_mapping->host;
>
>         rc = file_write_and_wait_range(file, start, end);
>         if (rc)
>                 return rc;
> -       inode_lock(inode);
>
>         xid = get_xid();
>
> @@ -2483,7 +2479,6 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>         }
>
>         free_xid(xid);
> -       inode_unlock(inode);
>         return rc;
>  }
>
> --
> 2.20.1
>


-- 
Thanks,

Steve
