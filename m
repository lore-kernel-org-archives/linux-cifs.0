Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEEFBEB64DC
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Jul 2023 06:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbjGJGUd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 10 Jul 2023 02:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjGJGUb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 10 Jul 2023 02:20:31 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B163A115
        for <linux-cifs@vger.kernel.org>; Sun,  9 Jul 2023 23:20:26 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2b6a084a34cso60175101fa.1
        for <linux-cifs@vger.kernel.org>; Sun, 09 Jul 2023 23:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688970025; x=1691562025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jSkGO4JyGJZzGGM8QkNidvK+JmO6An3PBFa5/7UJLBs=;
        b=GM/q6ca5qI6nEvQTDZnU6Eb0GCWwN4xdtAMRd1NLO5w4nNouimfwFlcfeBIk9PJxN5
         YDNHM2doqly+WpFe1ytBrOxXZCLWrzFfS6TDJ33yMZUQ9xL/RjLp0mpP+ZMVdOqQ7EXl
         Qs5C++Y3cJ38XlR56Hp1GJZ8hVCEg/uMhXYwjPtD0l5GYMpEWLmCQj0FS+Q6UM9385eZ
         9395+POsP5D/ZjDXH3rGO7BSYqxEmBGGIijKx6kUcZly5z/LisHzgxkyKG0P1iw2N/WF
         MZCfq4ayqplwpV4PltPJ/iX0dIe+aBLQ/uqhD2sGlAvX8bYk3bdUzEvJPMRUp4uo5rt+
         xWLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688970025; x=1691562025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jSkGO4JyGJZzGGM8QkNidvK+JmO6An3PBFa5/7UJLBs=;
        b=kN+OmProH1oWsC+CmWZLFDVDhRj3atmo7JrHqy6JxBcBUh2lRStPPC0jneZ6s7kR1D
         4ho4OswXwvRC8aee8OpZLgwjT0h+ES6WSziyuvlyXTNKPk2yjy5nI5+CZ6HG/hx7/z0F
         cEkF3AqAl/GzqOd6voTz9uLKCF+Ugpe3Erh+vNdCQhwLE+NhjwIdnbckl+4mXJL91A7J
         EcUlddOFs6LtnIodCqOjRXqR8Bud/ftaiQpqr6DKXTEfx/VrvVOiyi2eInsB/GpJm5hh
         wpik7wB4KGSpzehnMNiklgLPC89HMQTzixluWt86FYSCilFoLdA+pjPxHklmTEwwEB+w
         Ms7g==
X-Gm-Message-State: ABy/qLa3mR273LhRV0IfJ/2VJGlwGHlRK6F6MR/KVouhYJ+aXfRrXw3Y
        3Ka8+QVyLTPbtQr3q0/t/BCk10MCxKPGlHQYYEA=
X-Google-Smtp-Source: APBJJlHHxeRp5SRwPzQWE9ZIOIbt0dHikT25gT8TXsEsjKEuIoh7nbgB5uB7Yo78XkHh+RE8uvEHh1vRz/KfbFVKqmc=
X-Received: by 2002:a2e:800f:0:b0:2b6:d8d4:f871 with SMTP id
 j15-20020a2e800f000000b002b6d8d4f871mr8309654ljg.40.1688970024590; Sun, 09
 Jul 2023 23:20:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230707152901.503213-1-bharathsm@microsoft.com>
In-Reply-To: <20230707152901.503213-1-bharathsm@microsoft.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 10 Jul 2023 11:50:13 +0530
Message-ID: <CANT5p=qh1UYS5MjkdxWaMa_yNVBAsuWKb_6SDc0-=5AJ6a11QQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: if deferred close is disabled then close files immediately
To:     Bharath SM <bharathsm.hsk@gmail.com>
Cc:     sfrench@samba.org, pc@manguebit.com, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org,
        bharathsm@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jul 7, 2023 at 9:00=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.com>=
 wrote:
>
> If defer close timeout value is set to 0, then there is no
> need to include files in the deferred close list and utilize
> the delayed worker for closing. Instead, we can close them
> immediately.
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/smb/client/file.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index df88b8c04d03..5a58d438e044 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -1080,8 +1080,8 @@ int cifs_close(struct inode *inode, struct file *fi=
le)
>                 cfile =3D file->private_data;
>                 file->private_data =3D NULL;
>                 dclose =3D kmalloc(sizeof(struct cifs_deferred_close), GF=
P_KERNEL);
> -               if ((cinode->oplock =3D=3D CIFS_CACHE_RHW_FLG) &&
> -                   cinode->lease_granted &&
> +               if ((cifs_sb->ctx->closetimeo && cinode->oplock =3D=3D CI=
FS_CACHE_RHW_FLG)
> +                   && cinode->lease_granted &&
>                     !test_bit(CIFS_INO_CLOSE_ON_LOCK, &cinode->flags) &&
>                     dclose) {
>                         if (test_and_clear_bit(CIFS_INO_MODIFIED_ATTR, &c=
inode->flags)) {
> --
> 2.34.1
>

Looks good to me. And should be CC stable.

--=20
Regards,
Shyam
