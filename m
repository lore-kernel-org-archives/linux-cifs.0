Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 320F8C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 31 May 2022 04:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238409AbiEaEGX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 May 2022 00:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbiEaEGW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 May 2022 00:06:22 -0400
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4D28CB28
        for <linux-cifs@vger.kernel.org>; Mon, 30 May 2022 21:06:20 -0700 (PDT)
Received: by mail-vk1-xa29.google.com with SMTP id az25so4538290vkb.12
        for <linux-cifs@vger.kernel.org>; Mon, 30 May 2022 21:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JEqH55kq62XG46jMuWVfbNnYTX0zjEzkfnGSvfpgoAg=;
        b=dTi37SS3ucIlqF6yC9/h1ci74iuUj2j7QCgv2onRwiOqSm5/4k/+zfmM0zYxjcKwrY
         Ar7h/xTcvGzFoIgZWZ6F0q03LG5+whyt+L5MDk/2IPNeBytep4M5N1QajTbAOVW4KgyQ
         1PjXzaZBQ4//mF5GMkfBbqM5A5bwzrXNveXM5sFq6eDNAZUM0RY75GgFTJDm9zrjCqtG
         jJ30+B01XYPWk90lv3S3UgRe9B5jN9HNtkaKt5y3Wm3HDRAX46YLdSWquEf85AwYqEcM
         MudiredpBkenK0xuSGa3V3PehTJzh5n8Aw8+ZyiD8dA9BXBgBiZoqZ5aAWQyzyRsXBos
         Ibmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JEqH55kq62XG46jMuWVfbNnYTX0zjEzkfnGSvfpgoAg=;
        b=Zpnfk43shEyYKOapRvaIJV+Fl+/XBtWQlHi8Zu16nHsisDAxZBaTstNENBP+3BSC7R
         5pYcx9wp7iejL9WfaCnGnJsd9rhHlDtn5RW3bVfWIjUczGSSVv243EHpAqBvJOPz1WaM
         dawnwUuSEH+GC4bo9j6mMmFxhkRQayW1HxeGrK34M1RLgFCHo5iPdTdBdGReEftY62og
         Z+ikeHyupMPO7RbnWEZch0TUJwPJMlrB+nYHCW/W5QjhEJsMhRtWr43iCMoL1uClG6ye
         RTAzNHZwvqw21uryZn7CXXmbgF+6W1Ovtjd2CdFztbCv3cCKXOGPsgp4CFG2kdgU8L/W
         fMPg==
X-Gm-Message-State: AOAM532ftuxpJeWz63NdGoYzG4vKYuDiOLlvhZ44gGh9x9+yrPfU/yyM
        9Y6LpCwKKQasSSDmG5+C2v5toDdxMthGpT/ipVCy47oR
X-Google-Smtp-Source: ABdhPJyyK2knXwLDAnJ2NatETDZ8Hcdc3sidEw/LjP64mvgHvXDwbjtkKTk2R2k5CLtBDWQ/VK5/MX1Bh8EvUbnGhlQ=
X-Received: by 2002:a1f:a7d5:0:b0:34e:4447:6309 with SMTP id
 q204-20020a1fa7d5000000b0034e44476309mr21807066vke.38.1653969979455; Mon, 30
 May 2022 21:06:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220531030117.403302-1-lsahlber@redhat.com>
In-Reply-To: <20220531030117.403302-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 30 May 2022 23:06:08 -0500
Message-ID: <CAH2r5muz2mtWTwL34TpnnhuRhqzquZfiuwUoqwp2=m8g3mJJMA@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix potential double free during failed mount
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

added cc:stable and merged into cifs-2.6.git for-next

On Mon, May 30, 2022 at 10:01 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> RHBZ: https://bugzilla.redhat.com/show_bug.cgi?id=2088799
>
> Signed-off-by: Roberto Bergantinos <rbergant@redhat.com>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifsfs.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index f539a39d47f5..12c872800326 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -838,7 +838,7 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
>               int flags, struct smb3_fs_context *old_ctx)
>  {
>         int rc;
> -       struct super_block *sb;
> +       struct super_block *sb = NULL;
>         struct cifs_sb_info *cifs_sb = NULL;
>         struct cifs_mnt_data mnt_data;
>         struct dentry *root;
> @@ -934,9 +934,11 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
>         return root;
>  out:
>         if (cifs_sb) {
> -               kfree(cifs_sb->prepath);
> -               smb3_cleanup_fs_context(cifs_sb->ctx);
> -               kfree(cifs_sb);
> +               if (!sb || IS_ERR(sb)) {  /* otherwise kill_sb will handle */
> +                       kfree(cifs_sb->prepath);
> +                       smb3_cleanup_fs_context(cifs_sb->ctx);
> +                       kfree(cifs_sb);
> +               }
>         }
>         return root;
>  }
> --
> 2.35.3
>


-- 
Thanks,

Steve
