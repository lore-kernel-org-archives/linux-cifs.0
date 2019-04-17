Return-Path: <SRS0=xEhF=ST=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF069C282DA
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Apr 2019 21:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FCC920872
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Apr 2019 21:41:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nvFRsxKM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733250AbfDQVl7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Apr 2019 17:41:59 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43861 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfDQVl6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 Apr 2019 17:41:58 -0400
Received: by mail-lj1-f196.google.com with SMTP id f18so34641lja.10
        for <linux-cifs@vger.kernel.org>; Wed, 17 Apr 2019 14:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nML7aKPff03+knA7k1S1DaAOu8Yjttg9p36r/kF+M7s=;
        b=nvFRsxKMVt/asjmJNhcPY1D+egcTCa1l5AkbzREtFk5e/1oeCUCx0pPyX/ytRdcFBH
         +ye3zK0IztUNh6pM+/vht5Yz3UVcxyNmhbyjiELZYek65iutVM0i2m/GHcRbTjgvKXTG
         doDNiYqeACXkaezgardAcAruOgv57BU9JZwekkl/6Py/KWv3TZ3IjLmLqgVWwGO5ipaX
         /gzUqnt7SFztTSXmatAyp0q61T5Zahb1PaEK2MVaVAT6sAL7GF59/imgBaS7UKzn5VG2
         e0oa1nYcbYt7gEUwmlgD0Cv69TaNoKBBti9a0MVp3dpkVhE4R3gTi3F23EMETTG1O84Z
         tm5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nML7aKPff03+knA7k1S1DaAOu8Yjttg9p36r/kF+M7s=;
        b=XkPhXIjFJim1MQI82iCpJVBfwan8o2O9DODESJvUlWyYepS4+45iE4557WkiYup29A
         qJsW7lwCf8GT7aplKYoKMggDdncSjj+v38CDD5LzV089t9iPudzuE63X844e3rQUGfdR
         LSxFQEwMc4cxoEmnA7AfNRDgC85pvB7+UyshoJRA0ckwYchszvpadqjlstSld88AZeId
         wxRfYxzNiJUxLYrtPLfh63PF1ZJ2XfyGiv5tVY1y5+TCH4SIrqMIvT/QPPFB4RYcI+vz
         o73i0EizeEb+UzG6ZeWkbs5B2gir7EbR1AvAsCtsEEQOy2t/LSOTjYYyINdBkHctTAiz
         jUbA==
X-Gm-Message-State: APjAAAWGKp5C9D7QKEfW6tV/hNdI5dNu7KId3wbPuVO7PWejfVQfn6Oc
        i8ZBdGBn2pCwSi5CLKIrlI3w+SF0WNdioTPv8Q==
X-Google-Smtp-Source: APXvYqzUXU6jJIbs7q/jK9Sfz0x4Iuq9x602GJhjIxyJSUVWEHEvPhTjb4j0Yd/WsaHznzcTqZQUMZ+1AE79iuXI0KQ=
X-Received: by 2002:a2e:9196:: with SMTP id f22mr48631671ljg.82.1555537315195;
 Wed, 17 Apr 2019 14:41:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190417063410.6371-1-lsahlber@redhat.com>
In-Reply-To: <20190417063410.6371-1-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 17 Apr 2019 14:41:44 -0700
Message-ID: <CAKywueTsdXc8TSTGUPTm6KXGFop9rmS4=8dQTGXPRyqDGkWyMQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: add SEEK_HOLE/SEEK_DATA support
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--
Best regards,
Pavel Shilovsky

=D0=B2=D1=82, 16 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 23:35, Ronnie Sahl=
berg <lsahlber@redhat.com>:
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifsfs.c   |  9 ++++++++
>  fs/cifs/cifsglob.h |  2 ++
>  fs/cifs/smb2ops.c  | 65 ++++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  fs/cifs/smb2pdu.c  |  7 +++++-
>  fs/cifs/smb2pdu.h  |  5 +++++
>  fs/cifs/smbfsctl.h |  2 +-
>  6 files changed, 88 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 07fdf1771add..a00ef6c6a988 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -884,6 +884,9 @@ static ssize_t cifs_file_write_iter(struct kiocb *ioc=
b, struct iov_iter *from)
>
>  static loff_t cifs_llseek(struct file *file, loff_t offset, int whence)
>  {
> +       struct cifsFileInfo *cfile =3D file->private_data;
> +       struct cifs_tcon *tcon;
> +
>         /*
>          * whence =3D=3D SEEK_END || SEEK_DATA || SEEK_HOLE =3D> we must =
revalidate
>          * the cached file length
> @@ -915,6 +918,12 @@ static loff_t cifs_llseek(struct file *file, loff_t =
offset, int whence)
>                 if (rc < 0)
>                         return (loff_t)rc;
>         }
> +       if (cfile && cfile->tlink) {
> +               tcon =3D tlink_tcon(cfile->tlink);
> +               if (tcon->ses->server->ops->llseek)
> +                       return tcon->ses->server->ops->llseek(file, tcon,
> +                                                             offset, whe=
nce);
> +       }
>         return generic_file_llseek(file, offset, whence);
>  }
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 0dc55f4e6929..828772da5fa4 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -493,6 +493,8 @@ struct smb_version_operations {
>                          char *full_path,
>                          umode_t mode,
>                          dev_t device_number);
> +       /* version specific llseek implementation */
> +       loff_t (*llseek)(struct file *, struct cifs_tcon *, loff_t, int);
>  };
>
>  struct smb_version_values {
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 2824b97c5869..dc36316b9bd5 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -2872,6 +2872,69 @@ static long smb3_simple_falloc(struct file *file, =
struct cifs_tcon *tcon,
>         return rc;
>  }
>
> +static loff_t smb3_llseek(struct file *file, struct cifs_tcon *tcon, lof=
f_t offset, int whence)
> +{
> +       struct cifsFileInfo *cfile =3D file->private_data;
> +       struct cifsInodeInfo *cifsi;
> +       struct inode *inode;
> +       int rc =3D 0;
> +       struct fsctl_query_allocate_ranges in_data, *out_data =3D NULL;
> +       u32 out_data_len;
> +       unsigned int xid;
> +
> +       if (whence !=3D SEEK_HOLE && whence !=3D SEEK_DATA)
> +               return generic_file_llseek(file, offset, whence);
> +
> +       inode =3D d_inode(cfile->dentry);
> +       cifsi =3D CIFS_I(inode);
> +
> +       if (offset < 0 || offset > i_size_read(inode))
> +               return -ENXIO;
> +
> +       if (!(cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE)) {
> +               if (whence =3D=3D SEEK_HOLE)
> +                       offset =3D i_size_read(inode);
> +               else
> +                       offset =3D offset;
> +               goto lseek_exit;
> +       }
> +
> +       in_data.file_offset =3D cpu_to_le64(offset);
> +       in_data.length =3D cpu_to_le64(i_size_read(inode));
> +
> +       xid =3D get_xid();
> +       rc =3D SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
> +                       cfile->fid.volatile_fid,
> +                       FSCTL_QUERY_ALLOCATED_RANGES, true,
> +                       (char *)&in_data, sizeof(in_data),
> +                       sizeof(struct fsctl_query_allocate_ranges),
> +                       (char **)&out_data, &out_data_len);
> +       free_xid(xid);
> +       if (rc =3D=3D -E2BIG)
> +               rc =3D 0;
> +       if (rc)
> +               goto lseek_exit;
> +
> +       if (out_data_len < sizeof(struct fsctl_query_allocate_ranges)) {
> +               rc =3D -EINVAL;
> +               goto lseek_exit;
> +       }
> +       if (whence =3D=3D SEEK_DATA) {
> +               offset =3D le64_to_cpu(out_data->file_offset);
> +               goto lseek_exit;
> +       }
> +       if (offset < le64_to_cpu(out_data->file_offset))
> +               goto lseek_exit;
> +
> +       offset =3D le64_to_cpu(out_data->file_offset) + le64_to_cpu(out_d=
ata->length);
> +
> + lseek_exit:
> +       kfree(out_data);
> +       if (!rc)
> +               return vfs_setpos(file, offset, inode->i_sb->s_maxbytes);
> +       else
> +               return rc;
> +}
>
>  static long smb3_fallocate(struct file *file, struct cifs_tcon *tcon, in=
t mode,
>                            loff_t off, loff_t len)
> @@ -4247,6 +4310,7 @@ struct smb_version_operations smb30_operations =3D =
{
>         .next_header =3D smb2_next_header,
>         .ioctl_query_info =3D smb2_ioctl_query_info,
>         .make_node =3D smb2_make_node,
> +       .llseek =3D smb3_llseek,
>  };
>
>  struct smb_version_operations smb311_operations =3D {
> @@ -4356,6 +4420,7 @@ struct smb_version_operations smb311_operations =3D=
 {
>         .next_header =3D smb2_next_header,
>         .ioctl_query_info =3D smb2_ioctl_query_info,
>         .make_node =3D smb2_make_node,
> +       .llseek =3D smb3_llseek,
>  };
>
>  struct smb_version_values smb20_values =3D {
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 99a015e980d2..ac92d066c724 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -2625,7 +2625,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon=
 *tcon, u64 persistent_fid,
>                 trace_smb3_fsctl_err(xid, persistent_fid, tcon->tid,
>                                 ses->Suid, 0, opcode, rc);
>
> -       if ((rc !=3D 0) && (rc !=3D -EINVAL)) {
> +       if ((rc !=3D 0) && (rc !=3D -EINVAL) && (rc !=3D -E2BIG)) {
>                 cifs_stats_fail_inc(tcon, SMB2_IOCTL_HE);
>                 goto ioctl_exit;
>         } else if (rc =3D=3D -EINVAL) {
> @@ -2634,6 +2634,11 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tco=
n *tcon, u64 persistent_fid,
>                         cifs_stats_fail_inc(tcon, SMB2_IOCTL_HE);
>                         goto ioctl_exit;
>                 }
> +       } else if (rc =3D=3D -E2BIG) {
> +               if (opcode !=3D FSCTL_QUERY_ALLOCATED_RANGES) {
> +                       cifs_stats_fail_inc(tcon, SMB2_IOCTL_HE);
> +                       goto ioctl_exit;
> +               }
>         }
>
>         /* check if caller wants to look at return data or just return rc=
 */
> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> index ee8977688e21..3a29db740fe6 100644
> --- a/fs/cifs/smb2pdu.h
> +++ b/fs/cifs/smb2pdu.h
> @@ -842,6 +842,11 @@ struct fsctl_get_integrity_information_rsp {
>         __le32  ClusterSizeInBytes;
>  } __packed;
>
> +struct fsctl_query_allocate_ranges {

This describes one range, so should be fsctl_query_allocate_range or
even file_allocated_range_buffer as specified here:

https://docs.microsoft.com/en-us/windows/desktop/api/winioctl/ns-winioctl-_=
file_allocated_range_buffer

> +       __le64  file_offset;
> +       __le64  length;
> +} __packed;
> +
>  /* Integrity ChecksumAlgorithm choices for above */
>  #define        CHECKSUM_TYPE_NONE      0x0000
>  #define        CHECKSUM_TYPE_CRC64     0x0002
> diff --git a/fs/cifs/smbfsctl.h b/fs/cifs/smbfsctl.h
> index 9b3459b9a5ce..08628e6a42ac 100644
> --- a/fs/cifs/smbfsctl.h
> +++ b/fs/cifs/smbfsctl.h
> @@ -103,7 +103,7 @@
>  #define FSCTL_SET_ZERO_ON_DEALLOC    0x00090194 /* BB add struct */
>  #define FSCTL_SET_SHORT_NAME_BEHAVIOR 0x000901B4 /* BB add struct */
>  #define FSCTL_GET_INTEGRITY_INFORMATION 0x0009027C
> -#define FSCTL_QUERY_ALLOCATED_RANGES 0x000940CF /* BB add struct */
> +#define FSCTL_QUERY_ALLOCATED_RANGES 0x000940CF
>  #define FSCTL_SET_DEFECT_MANAGEMENT  0x00098134 /* BB add struct */
>  #define FSCTL_FILE_LEVEL_TRIM        0x00098208 /* BB add struct */
>  #define FSCTL_DUPLICATE_EXTENTS_TO_FILE 0x00098344
> --
> 2.13.6
>
