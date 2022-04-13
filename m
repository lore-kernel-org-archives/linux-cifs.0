Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF804C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Apr 2022 23:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiDMXdy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Apr 2022 19:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236369AbiDMXdx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Apr 2022 19:33:53 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30CD255BA
        for <linux-cifs@vger.kernel.org>; Wed, 13 Apr 2022 16:31:29 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id f7so1146225uap.4
        for <linux-cifs@vger.kernel.org>; Wed, 13 Apr 2022 16:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PG6nMsY33gHgqk5O01UVSCt2KyCm050SUMRV9fHz0XM=;
        b=Daf7Ja9jOfo0KDZIML9r3lA071uOB7KizUvoxrai/lu1uqL2aPcyS8qLYG6+hb+u6G
         5tf6H5qOzz4VWYSwQffsXFxR9I5KAPehcLKqpAJMp5v3j9lob8hGXU4G+61uyqB5HHA+
         gUEa69RZyffsFXIsmstVNgmPLbAS5OMs37iuemCnq06vjU4csj4dA26MnrGWCcbckQ0Z
         sx5WQxPJegZQl8Jl+Q4oGqHCz6LQwhHHE/TNcR486i0NIPCZ815y4gzkUpIyNkKUW+TS
         PKgAk99HLAjxN8XCeXIEvMsHAq8+npzHL2pijKxidy35462PlkXwHZzTZWvqoh27mh8I
         n2ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PG6nMsY33gHgqk5O01UVSCt2KyCm050SUMRV9fHz0XM=;
        b=acq7Z+Wf3PCaul0b8bRayTUtirpHvqfBPZKfS4b411Z5PXMNAxkrruTZz7tWjENlOL
         sBJFbkvEYOnx9+yqcJeMzZ4qR4E1aGdkNfEBHDFXM8ctprvQ6pcfCbwv/sHcDz+9/Rkn
         x+ZlIPvnyWiUGe+/9TJtsBYf28IzypP0VaMcYouY/q7l534ghRK+fAhvu/Odi4E7xFa3
         UDgRWRde7kELqaUFRJBJS7qe4Nn5B4f8AIf2agiTeaX3hGH4LpLXViG7+GgKBTzti7WS
         O4w5p33iXo+QNL2CYYdSbAGn29UlDxctLhcexSZN2cdQVHdZhBQHrZtFF2nrjkT5YmE+
         dAvg==
X-Gm-Message-State: AOAM530xLvHBbUCig6DE4s2b6r/fnGYpQqyGxhL+pdPA1b74R/cTFmiW
        Cqsy/Xhj3X08XlKkXH2yCNS3gpwaJ3Otm0gCfho=
X-Google-Smtp-Source: ABdhPJzQow6OTSLtT2asTCy2G2vdCWfy+0Woc8TbTRvQN1kA1ogvMYpTK5uAWk0EyojhyD6368Okv8J6HTF8AmZlL/s=
X-Received: by 2002:ab0:d95:0:b0:35d:4d4b:c59b with SMTP id
 i21-20020ab00d95000000b0035d4d4bc59bmr2672182uak.97.1649892689060; Wed, 13
 Apr 2022 16:31:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220412225743.5590-1-linkinjeon@kernel.org>
In-Reply-To: <20220412225743.5590-1-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Thu, 14 Apr 2022 08:31:18 +0900
Message-ID: <CANFS6bZjL2gQcP5oFAGX2m14Ox39A_M_QBTdfsT-FFrZfr+XJw@mail.gmail.com>
Subject: Re: [PATCH RESEND] ksmbd: increment reference count of parent fp
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022=EB=85=84 4=EC=9B=94 13=EC=9D=BC (=EC=88=98) =EC=98=A4=EC=A0=84 7:57, N=
amjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Add missing increment reference count of parent fp in
> ksmbd_lookup_fd_inode().
>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---

Looks good to me.

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

>  fs/ksmbd/smb2pdu.c   | 2 ++
>  fs/ksmbd/vfs_cache.c | 1 +
>  2 files changed, 3 insertions(+)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index e38fb68ded21..62cc0f95ab87 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -5758,8 +5758,10 @@ static int set_rename_info(struct ksmbd_work *work=
, struct ksmbd_file *fp,
>         if (parent_fp) {
>                 if (parent_fp->daccess & FILE_DELETE_LE) {
>                         pr_err("parent dir is opened with delete access\n=
");
> +                       ksmbd_fd_put(work, parent_fp);
>                         return -ESHARE;
>                 }
> +               ksmbd_fd_put(work, parent_fp);
>         }
>  next:
>         return smb2_rename(work, fp, user_ns, rename_info,
> diff --git a/fs/ksmbd/vfs_cache.c b/fs/ksmbd/vfs_cache.c
> index 0974d2e972b9..c4d59d2735f0 100644
> --- a/fs/ksmbd/vfs_cache.c
> +++ b/fs/ksmbd/vfs_cache.c
> @@ -496,6 +496,7 @@ struct ksmbd_file *ksmbd_lookup_fd_inode(struct inode=
 *inode)
>         list_for_each_entry(lfp, &ci->m_fp_list, node) {
>                 if (inode =3D=3D file_inode(lfp->filp)) {
>                         atomic_dec(&ci->m_count);
> +                       lfp =3D ksmbd_fp_get(lfp);
>                         read_unlock(&ci->m_lock);
>                         return lfp;
>                 }
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
