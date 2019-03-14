Return-Path: <SRS0=3edS=RR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FB76C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 15:56:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BD2920811
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 15:56:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f3KUZdOF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfCNP4Y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Mar 2019 11:56:24 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44748 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727389AbfCNP4Y (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Mar 2019 11:56:24 -0400
Received: by mail-pg1-f193.google.com with SMTP id h34so4249120pgh.11
        for <linux-cifs@vger.kernel.org>; Thu, 14 Mar 2019 08:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DpXkGelKXYX0NktcdzRQuCRaK9yESUZGweQwRd1pRWw=;
        b=f3KUZdOFjcaA2rjXzbIdqc+DUWI3agtIYSZgwFPWza/OFdWGAUv/FT9zbGqmgwbWUG
         3moT5zOnwQrus6ThDGIAu4g/VZq9zb5WiqEhTkP/ZAfqepicsT4Ip98k+9s13qPb74zr
         4Y+naWX9YaZV1hpMObfRr3Ii1asvSYPiehCW0WBVGSB7wjD3inbsdFmflutWcmUYOi5k
         XjSljkxtNeWIKbBI+/0Bn6Fzjg5DwDRewyv3E5ofoPiC8CCjaAETakGRuawoEqDrmXCu
         /Qwe4c3Xndlj3aknyEDIRYp9UyTUAozSXzJGPjVmmFb6oQJ0b0WkOUYykSUQW7+UxKl1
         scrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DpXkGelKXYX0NktcdzRQuCRaK9yESUZGweQwRd1pRWw=;
        b=oHe3qXDyTlaLG+1gUY6BlgZ6xhl0WNKxgIf4CsLGDwbE6bDCgP+l4TZ2gVEWkoZXqx
         +oRbooZ7/SGMKNTILzvEh0YEsQz+LL38eR6Ehp6ECi1JSLAKFHlH3ccaoEDCoXIhDL8Q
         WuxOTlJlXj3s3F7rwIL64wn7c+IH7Rj/QNmG+Yym+8f+6BUh9uX+EoLcS5B1Ae6RuCRc
         Tszb3t+b51nEqF2lpT3wspy6JL4mFemjmVDJErmLVtHQrkWuQXxxs7CU2RQQ3STZfwd0
         Zu3bZLJwwYrDTehz/z9iV0+et7RNJMv9Qr385r2vGawksJprjA1zz6FuZg8X89bn2928
         LH2w==
X-Gm-Message-State: APjAAAUpI8sHWsf5Vua6RRYfMj9eJRhxUvbWgUIsBucsqX1zVOW2ZR0p
        oAieUN/PhRihTMXI+ED389MwKOdpwth3mDTzuk8=
X-Google-Smtp-Source: APXvYqynLmuRXYvQyBF2SGB7RSAyz+Q8XCsABfUbTv97LwP6jymmsM7go8vW4qwXDJLRTZ5kJf55/M5IgtHKQabxQWg=
X-Received: by 2002:a63:1053:: with SMTP id 19mr46021338pgq.55.1552578983184;
 Thu, 14 Mar 2019 08:56:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190314140848.11476-1-lsahlber@redhat.com>
In-Reply-To: <20190314140848.11476-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 14 Mar 2019 10:56:11 -0500
Message-ID: <CAH2r5mseQ7TtEokjYm+9xsU5POFJw1-CCPrZP_pyhSg1g2J6FA@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix incorrect handling of smb2_set_sparse() return
 in smb3_simple_falloc
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <stfrench@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Merged into cifs-2.6.git fo-next and kicked off the buildbot with
current for-next

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/162

On Thu, Mar 14, 2019 at 9:08 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> smb2_set_sparse does not return -errno, it returns a boolean where
> true means success.
> Change this to just ignore the return value just like the other callsites.
>
> Additionally add code to handle the case where we must set the file sparse
> and possibly also extending it.
>
> Fixes xfstests: generic/236 generic/350 generic/420
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/cifs/smb2ops.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 32dde87feaa9..03814b9f113d 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -2718,6 +2718,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
>         struct cifsFileInfo *cfile = file->private_data;
>         long rc = -EOPNOTSUPP;
>         unsigned int xid;
> +       __le64 eof;
>
>         xid = get_xid();
>
> @@ -2777,9 +2778,18 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
>                         return rc;
>                 }
>
> -               rc = smb2_set_sparse(xid, tcon, cfile, inode, false);
> +               smb2_set_sparse(xid, tcon, cfile, inode, false);
> +               rc = 0;
> +       } else {
> +               smb2_set_sparse(xid, tcon, cfile, inode, false);
> +               rc = 0;
> +               if (i_size_read(inode) < off + len) {
> +                       eof = cpu_to_le64(off + len);
> +                       rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
> +                                         cfile->fid.volatile_fid, cfile->pid,
> +                                         &eof);
> +               }
>         }
> -       /* BB: else ... in future add code to extend file and set sparse */
>
>         if (rc)
>                 trace_smb3_falloc_err(xid, cfile->fid.persistent_fid, tcon->tid,
> --
> 2.13.6
>


-- 
Thanks,

Steve
