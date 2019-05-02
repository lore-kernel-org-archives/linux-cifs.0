Return-Path: <SRS0=G37X=TC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F33C43219
	for <linux-cifs@archiver.kernel.org>; Thu,  2 May 2019 17:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2117220651
	for <linux-cifs@archiver.kernel.org>; Thu,  2 May 2019 17:29:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M0TqH3jL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbfEBR3q (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 May 2019 13:29:46 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41932 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfEBR3q (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 May 2019 13:29:46 -0400
Received: by mail-lj1-f195.google.com with SMTP id k8so2923691lja.8
        for <linux-cifs@vger.kernel.org>; Thu, 02 May 2019 10:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QKjlqeBNm01HrZjIiuF8G9w2XzoTnymH/drugIM/GrQ=;
        b=M0TqH3jLlDIj7NlPIIaTUHp0E/55LV5TYOHqHXokKFa6Kosm0+Lp0D3QajrZLle5NS
         mnBCZLGOlUejVlD835mV0YxiV4+3Zfa0+mg++DZ6SXiZEWCUiJniUfAT2U8iupiTM6xr
         917VGH/Ygzn5F9clslWfYauBEm7ajKBgWJUrqVjihPSiSzOb6mq6oCvePGvNbC3Um5Kl
         3Sj30lrYEAShvwQnkSc/Nh/1Wc2p01ahJW1ZIHo6v4y+Sp9VUdEI6fKMQT1t+VyqimhK
         4Xm0dC8JYkkIejmZ+RfJtawUPLYz+jfvTTanhkfTzig8qmGvPhGq44TghZMF9mB56KbZ
         zMWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QKjlqeBNm01HrZjIiuF8G9w2XzoTnymH/drugIM/GrQ=;
        b=IJQYlkFtxrDGNXnvbsZ/pbH6MHlZ1qwcmWmGg56kCAlwmkf3Uz47e8PdLmjBZMvMI1
         kvRQFdtK9KeaFXe8aOchJLJ+fnGAXiQluN7giaR6qhX2PWJKA1730wKku4FTjB6HXGCB
         aQwKlLNhtS48ODYTf4Vg3pYkLaacBjFIsA7RbuI2aBt0XruvplVqloJNS1nHrU+w4wGn
         fNraYsnrZiEpd+TkInOq5h4SctG87okkw4WKlBo0r+LsUcmyyAFKaZlhQFwS3oKiLyyG
         vLQxqqaZ9UauSv+5svUXy/viIrYEZFtqY3FN0EvgQgzgBH1B7EAPjYZYmGg+5ZCbdcBD
         xvZA==
X-Gm-Message-State: APjAAAUdT/0iphicqAxhgipF1pd/M7D9aBPLKQVmZouK85xVso92fk0P
        Jnsl+AK6ysNcjXOmbA8MlGpGP8kErT+P3L0PTiQpJUY=
X-Google-Smtp-Source: APXvYqyQhkdnsji324H1sW8E73sA77iGvP9hSsdolzXZhZ45WXYx3ElKiJmLrbZ26/RWjOb9oTkUdw7qtVIVBTQlHd4=
X-Received: by 2002:a2e:9d4c:: with SMTP id y12mr2576592ljj.132.1556818183635;
 Thu, 02 May 2019 10:29:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190502055257.31219-1-lsahlber@redhat.com>
In-Reply-To: <20190502055257.31219-1-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 2 May 2019 10:29:31 -0700
Message-ID: <CAKywueT9Lyzu5sjHdHnn_qW0+eReO_M9fBuFPCctLpoorpAhTg@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix smb3_zero_range for Azure
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D1=80, 1 =D0=BC=D0=B0=D1=8F 2019 =D0=B3. =D0=B2 22:53, Ronnie Sahlbe=
rg <lsahlber@redhat.com>:
>
> For zero-range that also extend the file we were sending this as a
> compound of two different operations; a fsctl to set-zero-data for the ra=
nge
> and then an additional set-info to extend the file size.
> This does not work for Azure since it does not support this fsctl which l=
eads
> to fallocate(FALLOC_FL_ZERO_RANGE) failing but still changing the file si=
ze.
>
> To fix this we un-compound this and send these two operations as separate
> commands, firsat one command to set-zero-data for the range and it this
> was successful we proceed to send a set-info to update the file size.
>
> This fixes xfstest generic/469 for Azure servers.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2ops.c | 54 +++++++------------------------------------------=
-----
>  1 file changed, 7 insertions(+), 47 deletions(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 9b7a2f448591..860dd1696830 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -2648,16 +2648,8 @@ static long smb3_zero_range(struct file *file, str=
uct cifs_tcon *tcon,
>         struct cifsInodeInfo *cifsi;
>         struct cifsFileInfo *cfile =3D file->private_data;
>         struct file_zero_data_information fsctl_buf;
> -       struct smb_rqst rqst[2];
> -       int resp_buftype[2];
> -       struct kvec rsp_iov[2];
> -       struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
> -       struct kvec si_iov[1];
> -       unsigned int size[1];
> -       void *data[1];
>         long rc;
>         unsigned int xid;
> -       int num =3D 0, flags =3D 0;
>         __le64 eof;
>
>         xid =3D get_xid();
> @@ -2684,22 +2676,11 @@ static long smb3_zero_range(struct file *file, st=
ruct cifs_tcon *tcon,
>         fsctl_buf.FileOffset =3D cpu_to_le64(offset);
>         fsctl_buf.BeyondFinalZero =3D cpu_to_le64(offset + len);
>
> -       if (smb3_encryption_required(tcon))
> -               flags |=3D CIFS_TRANSFORM_REQ;
> -
> -       memset(rqst, 0, sizeof(rqst));
> -       resp_buftype[0] =3D resp_buftype[1] =3D CIFS_NO_BUFFER;
> -       memset(rsp_iov, 0, sizeof(rsp_iov));
> -
> -
> -       memset(&io_iov, 0, sizeof(io_iov));
> -       rqst[num].rq_iov =3D io_iov;
> -       rqst[num].rq_nvec =3D SMB2_IOCTL_IOV_SIZE;
> -       rc =3D SMB2_ioctl_init(tcon, &rqst[num++], cfile->fid.persistent_=
fid,
> -                            cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA=
,
> -                            true /* is_fctl */, (char *)&fsctl_buf,
> -                            sizeof(struct file_zero_data_information),
> -                            CIFSMaxBufSize);
> +       rc =3D SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
> +                       cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA, tru=
e,
> +                       (char *)&fsctl_buf,
> +                       sizeof(struct file_zero_data_information),
> +                       0, NULL, NULL);
>         if (rc)
>                 goto zero_range_exit;
>
> @@ -2707,33 +2688,12 @@ static long smb3_zero_range(struct file *file, st=
ruct cifs_tcon *tcon,
>          * do we also need to change the size of the file?
>          */
>         if (keep_size =3D=3D false && i_size_read(inode) < offset + len) =
{
> -               smb2_set_next_command(tcon, &rqst[0]);
> -
> -               memset(&si_iov, 0, sizeof(si_iov));
> -               rqst[num].rq_iov =3D si_iov;
> -               rqst[num].rq_nvec =3D 1;
> -
>                 eof =3D cpu_to_le64(offset + len);
> -               size[0] =3D 8; /* sizeof __le64 */
> -               data[0] =3D &eof;
> -
> -               rc =3D SMB2_set_info_init(tcon, &rqst[num++],
> -                                       cfile->fid.persistent_fid,
> -                                       cfile->fid.persistent_fid,
> -                                       current->tgid,
> -                                       FILE_END_OF_FILE_INFORMATION,
> -                                       SMB2_O_INFO_FILE, 0, data, size);
> -               smb2_set_related(&rqst[1]);
> +               rc =3D SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
> +                                 cfile->fid.volatile_fid, cfile->pid, &e=
of);
>         }
>
> -       rc =3D compound_send_recv(xid, ses, flags, num, rqst,
> -                               resp_buftype, rsp_iov);
> -
>   zero_range_exit:
> -       SMB2_ioctl_free(&rqst[0]);
> -       SMB2_set_info_free(&rqst[1]);
> -       free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
> -       free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
>         free_xid(xid);
>         if (rc)
>                 trace_smb3_zero_err(xid, cfile->fid.persistent_fid, tcon-=
>tid,
> --
> 2.13.6
>

Does it also fix test 112?

--
Best regards,
Pavel Shilovsky
