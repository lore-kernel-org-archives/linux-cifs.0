Return-Path: <SRS0=9NYC=VO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 865E9C7618F
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Jul 2019 18:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 566FB21743
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Jul 2019 18:44:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X7vNzkcx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfGQSoR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Jul 2019 14:44:17 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:46250 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727377AbfGQSoR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 Jul 2019 14:44:17 -0400
Received: by mail-lf1-f67.google.com with SMTP id z15so12981128lfh.13
        for <linux-cifs@vger.kernel.org>; Wed, 17 Jul 2019 11:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0K4kpTnoL9C9WK/r2cUcElmtmKsNm6JdAxdKxqrOFi4=;
        b=X7vNzkcx5V/hvOAEdjysbXXf6FAmfiJkz/mid7FV+ql42GNMkGuDFy7INE4/1SdFC/
         57/zkAma10eXU96WSTILcyPGVoJXmL2ZA8VoFAlkHkwjUeS+4d3NUyk9iajkBFYH8ofx
         8x+aAHubMloYXDQrPU4JHS2eL26s2vgEoMAWSThWW23iaLHcfxxbZXBk0RGSl8jBt4ox
         vJYrCK9C62HOmzvjlffy+eF8Q49H+v8V95LnewhQDb8aXslxPmG8T3QT8VUAG6+FaIDV
         L7qx8vrba2F5bTBXhAKaMdCpgwoz79yADc4xBYJqtBvU5E7oa+t3Y54jkadZTu8OAoFH
         4+0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0K4kpTnoL9C9WK/r2cUcElmtmKsNm6JdAxdKxqrOFi4=;
        b=TjLifrrfLC2K6z7UWTE8lIjLAXaQQ3mLzP75jmP281aHaEHVnrsvTSF3ZKQylpyCzh
         bw/6a+vicfTleMAftHAJSQZ1bFNE1zcv7dBVfLptKW1cRIaLEcHXauHdctk4T/NzkJwX
         7MgPfDFfXzpFj9lx+6XFBBduCLzRwUm8zVTbQCREgS2zWLeWP+FyhfCEACXpwnMo3pVf
         njjzYzAp9bSt0f6/GbQEXCWhOrd3CqHVrOiKcvD8uVqG1KJkSFTctHNaXKrGN1xdMBlM
         G3oXOghA1g+DdZTku2c8JrLnto2OKDxymi6qPvH8jImOijROUUGt4nPSSA8CCUkJe0Mj
         HKgQ==
X-Gm-Message-State: APjAAAXkk3VDFLRqmc82mVhgOz2fybGxfL5wLrQGhjCAYXgAbqnw3HOu
        uE0FYDHjF8VBwCqWF9CBhgQ9vBVdGTK+j9A2Mg==
X-Google-Smtp-Source: APXvYqxnvEtXMjFg86zqiW3/RDBmTC5WpEEk9snhuixP+E0BAP4NZ3SnTcfEPUgaD3avqUHvw/4xZIyZtv4xmo+ODFo=
X-Received: by 2002:ac2:5337:: with SMTP id f23mr19094846lfh.15.1563389055983;
 Wed, 17 Jul 2019 11:44:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190716032349.10711-1-lsahlber@redhat.com>
In-Reply-To: <20190716032349.10711-1-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 17 Jul 2019 11:44:04 -0700
Message-ID: <CAKywueTNf7eTbbmcT=uO8JNrqZC2ZSLDFugw6TOwXWSJm_5zGw@mail.gmail.com>
Subject: Re: [PATCH] cifs: flush before set-info if we have writeable handles
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 15 =D0=B8=D1=8E=D0=BB. 2019 =D0=B3. =D0=B2 20:24, Ronnie Sahl=
berg <lsahlber@redhat.com>:
>
> Servers can defer destaging any data and updating the mtime until close()=
.
> This means that if we do a setinfo to modify the mtime while other handle=
s
> are open for write the server may overwrite our setinfo timestamps when
> if flushes the file on close() of the writeable handle.
>
> To avoid this we add an explicit flush() before any attempts to use setin=
fo
> and update the mtime IF we have writeable handles open.
>
> This makes "cp -p" preserve the mtime when copying files to some smb serv=
ers.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2inode.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> index 278405d26c47..a3603ec3a086 100644
> --- a/fs/cifs/smb2inode.c
> +++ b/fs/cifs/smb2inode.c
> @@ -516,7 +516,11 @@ smb2_set_file_info(struct inode *inode, const char *=
full_path,
>  {
>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
>         struct tcon_link *tlink;
> +       struct cifs_tcon *tcon;
> +       struct TCP_Server_Info *server;
>         int rc;
> +       struct cifsInodeInfo *cifsi;
> +       struct cifsFileInfo *wrcfile;
>
>         if ((buf->CreationTime =3D=3D 0) && (buf->LastAccessTime =3D=3D 0=
) &&
>             (buf->LastWriteTime =3D=3D 0) && (buf->ChangeTime =3D=3D 0) &=
&
> @@ -527,7 +531,19 @@ smb2_set_file_info(struct inode *inode, const char *=
full_path,
>         if (IS_ERR(tlink))
>                 return PTR_ERR(tlink);
>
> -       rc =3D smb2_compound_op(xid, tlink_tcon(tlink), cifs_sb, full_pat=
h,
> +       tcon =3D tlink_tcon(tlink);
> +       server =3D tcon->ses->server;
> +
> +       if (buf->LastWriteTime) {
> +               cifsi =3D CIFS_I(inode);
> +               wrcfile =3D find_writable_file(cifsi, false);

use get_writable_file instead - this will allow us to get a real RC.
if -EBADF is returned then no writable handle and should proceed
normally, otherwise let's fail setattr.

> +               if (wrcfile) {
> +                       filemap_write_and_wait(inode->i_mapping);

If the above function returns error, the same problem that you are
trying to fix appears. If an error happen, we should fail setattr to
avoid corruption of timestamps.

> +                       server->ops->flush(xid, tcon, &wrcfile->fid);

the same logic applies to flush call - need to fail setattr if an error occ=
ured.

> +                       cifsFileInfo_put(wrcfile);
> +               }
> +       }
> +       rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path,
>                               FILE_WRITE_ATTRIBUTES, FILE_OPEN, 0, buf,
>                               SMB2_OP_SET_INFO);
>         cifs_put_tlink(tlink);
> --
> 2.13.6
>


--
Best regards,
Pavel Shilovsky
