Return-Path: <SRS0=x7S9=4B=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6687C352A3
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Feb 2020 04:22:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9727C206ED
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Feb 2020 04:22:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jj7toDp4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729546AbgBMEWV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 12 Feb 2020 23:22:21 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:39523 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729440AbgBMEWV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 12 Feb 2020 23:22:21 -0500
Received: by mail-il1-f193.google.com with SMTP id f70so3793597ill.6
        for <linux-cifs@vger.kernel.org>; Wed, 12 Feb 2020 20:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UWjx9D1Qx+CSLa1grnqXpeTuLobElg18K7mG80aLybU=;
        b=jj7toDp4Tc1Znzr3Ow3cD+WsZcISQM5o9r8S5zcpvvRyXa4w/b3YjLJ6ZDr4szMakR
         TB797JMBteDcqWYeYRBjSGVQ7mIfAhPCouK3Se4Y6KFYE2EjzF6nttj0TnAaw9rfouz6
         2Y9kuvF/jCZpTVmY+1ZRjyfJrHtYWWLCsLVMqcY8fyvvpSQRiMtq+1Un0wrjJ6kcfUCy
         BlcToauVR6BoAkahDiOjz4Blju9PCeNvDkktBI/i4mX9OOcz88CYucBj4rQkuqTbzZZJ
         lnwSljTW0II4WLdboc7PJzGvkcLlCQ8n2+yTMW+292xvONvvADMW7wXqvh60Z12rwjw4
         vIKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UWjx9D1Qx+CSLa1grnqXpeTuLobElg18K7mG80aLybU=;
        b=UIdEDke9n7Mq6+H+d1J5hoG7A8gTBD7VD5VzHVIpX1pUZj/2vsNyZ+JxBWPSnRfY/b
         JCtq9ov7F0XrukWIa+baamigUcihaDlqgBJOluT4e9kDLegPJHgV+hMrC97o6CZ8gC0T
         EKEub3ysvCt8YNS5qDP3+Er8BtRDuS8pA6n9WVkBSIwLMZpXxnsyyaWlm9ns6/S1bUIO
         T0mVuCg4fOkm5CFkjhjY9DrtOnc965kLFwMZ37yPV1QweZQmx80dSDVYtAIe9zYVfxKv
         SvqIjs3HmqhWy6gWeq8XP0i6Vkj9OH1sO/b35hOqGfxnMrbh3I8Z3KuV/jLJNFbj8K6l
         gedQ==
X-Gm-Message-State: APjAAAUc7Grk8LV/YmBlSRYx2O/I5qbHsXY4Y5UTBNAQrW70pL3wEGci
        32sS5TRiVJX2ow+xh0jSK47lOQ8coy4wTULmTIKZRQcI
X-Google-Smtp-Source: APXvYqxqGcpAfGLzuI0fJAuQ7oStuiR/k1/ECooZEGhuk0GJVe7bDjJbyytK3Q6W+xTKn4j+l1Av/qm2DS6rD2er+TM=
X-Received: by 2002:a92:d642:: with SMTP id x2mr14440940ilp.169.1581567740344;
 Wed, 12 Feb 2020 20:22:20 -0800 (PST)
MIME-Version: 1.0
References: <20200212213148.1143954-1-sorenson@redhat.com>
In-Reply-To: <20200212213148.1143954-1-sorenson@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 12 Feb 2020 22:22:09 -0600
Message-ID: <CAH2r5mu4UHr07pQOVN+mn=kN0TeSqMoMKGQw4w-Y43AF4q1B-A@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix mode output in debugging statements
To:     Frank Sorenson <sorenson@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Wed, Feb 12, 2020 at 3:31 PM Frank Sorenson <sorenson@redhat.com> wrote:
>
> A number of the debug statements output file or directory mode
> in hex.  Change these to print using octal.
>
> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
> ---
>  fs/cifs/cifsacl.c | 4 ++--
>  fs/cifs/connect.c | 2 +-
>  fs/cifs/inode.c   | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index 96ae72b556ac..58b4014fecb6 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -601,7 +601,7 @@ static void access_flags_to_mode(__le32 ace_flags, int type, umode_t *pmode,
>                         ((flags & FILE_EXEC_RIGHTS) == FILE_EXEC_RIGHTS))
>                 *pmode |= (S_IXUGO & (*pbits_to_set));
>
> -       cifs_dbg(NOISY, "access flags 0x%x mode now 0x%x\n", flags, *pmode);
> +       cifs_dbg(NOISY, "access flags 0x%x mode now %04o\n", flags, *pmode);
>         return;
>  }
>
> @@ -630,7 +630,7 @@ static void mode_to_access_flags(umode_t mode, umode_t bits_to_use,
>         if (mode & S_IXUGO)
>                 *pace_flags |= SET_FILE_EXEC_RIGHTS;
>
> -       cifs_dbg(NOISY, "mode: 0x%x, access flags now 0x%x\n",
> +       cifs_dbg(NOISY, "mode: %04o, access flags now 0x%x\n",
>                  mode, *pace_flags);
>         return;
>  }
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 05ea0e2b7e0e..071f5d6726e5 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -4149,7 +4149,7 @@ int cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
>         cifs_sb->mnt_gid = pvolume_info->linux_gid;
>         cifs_sb->mnt_file_mode = pvolume_info->file_mode;
>         cifs_sb->mnt_dir_mode = pvolume_info->dir_mode;
> -       cifs_dbg(FYI, "file mode: 0x%hx  dir mode: 0x%hx\n",
> +       cifs_dbg(FYI, "file mode: %04ho  dir mode: %04ho\n",
>                  cifs_sb->mnt_file_mode, cifs_sb->mnt_dir_mode);
>
>         cifs_sb->actimeo = pvolume_info->actimeo;
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index ca76a9287456..b3f3675e1878 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1649,7 +1649,7 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, umode_t mode)
>         struct TCP_Server_Info *server;
>         char *full_path;
>
> -       cifs_dbg(FYI, "In cifs_mkdir, mode = 0x%hx inode = 0x%p\n",
> +       cifs_dbg(FYI, "In cifs_mkdir, mode = %04ho inode = 0x%p\n",
>                  mode, inode);
>
>         cifs_sb = CIFS_SB(inode->i_sb);
> --
> 2.14.4
>


-- 
Thanks,

Steve
