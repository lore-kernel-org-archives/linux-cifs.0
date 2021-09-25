Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A81C433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 10:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 039096124B
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 10:17:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240997AbhIYKSe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 25 Sep 2021 06:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235805AbhIYKSd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 25 Sep 2021 06:18:33 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5622AC061570
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 03:16:59 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id h30so12725896vsq.3
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 03:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=s4+xuzaazVHJrt6OsU6rb3sbxn6yCSnOn9vpYgbHaVI=;
        b=W1OFSIM803dh+lEaHrZHXa9HAym6QuQZZZ0sUMb/qbg+df6NuNvjobWC7y0i4rK3fo
         Vamt8JJAHrNlQqOkpVPp2nDYzX2jw80ibSXtctL28QfwBv9df9Y610CU3Fi8sAQFyYCv
         hekopEHYMCFoIkQvwh9wmBTN5WdAGuWc8rpqHhhDm4qYHRuiW2AcDVX8tgKEChsqo0yr
         U6DFsNTcdGdeMMsudEepg/9sxABYYeVSbb/aGX0aeEkjTS2qsyprBB3OxNi92l3GAXk/
         PgV0FtSqUbgUujkk0wvzRyI1ZFQRxss5uSADFYWztwleg/iZIyxBIC/G8CQPQK4FA8JM
         Phfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=s4+xuzaazVHJrt6OsU6rb3sbxn6yCSnOn9vpYgbHaVI=;
        b=yO266KRb1JhorGcd2V2L/x1+a3hudpkKCEHbw7iNdgQsnn2TEYOrO23rEJ37vuIO9V
         ROk41R4UQeCV5SRnM6Hb6Ln0ClpN4mxogwyDvucfuWpQrp86v7ke45FgkAZoIr3ikqrg
         nuk6slU3zLfSBGE88wDILNxl8u09qKLslaRQGrnwbCmeMDFbbXrwAvelBcv3FVb3U5NX
         Mg883wHNAFFsvNskdeGVqK7im0/XSuBfReXaw5LOjbqlmg4WGYH0ldlRg91VxXGBMEQD
         VUBgGk727A/HamT1SAamdpntwyBfKNLBzam1v68tsRFQRI67RjV14hNmBLty1szj8xzr
         uj6Q==
X-Gm-Message-State: AOAM530sgP7W3H8cFse95A4PlKP4goVCbiRB1bJr95Pg/63i+IlLKdWz
        5K4ecbGoO1ogKfcDAaxKc2mjrOhW/EcpzM0Tohk=
X-Google-Smtp-Source: ABdhPJxkV/r+0PcwDoaHblWcuRBxEX6iBdxihnFO7gBi66yIIBuHsoZdC3Gw0ieFYH1p+DDDxT5O2/J09weFncvlToY=
X-Received: by 2002:a67:c088:: with SMTP id x8mr12986119vsi.45.1632565018294;
 Sat, 25 Sep 2021 03:16:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210924021254.27096-1-linkinjeon@kernel.org> <20210924021254.27096-2-linkinjeon@kernel.org>
In-Reply-To: <20210924021254.27096-2-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Sat, 25 Sep 2021 19:16:46 +0900
Message-ID: <CANFS6baQVtiBGQCGeZhvCrPeSVF0647PzsNRrU93Wra+m_iNEg@mail.gmail.com>
Subject: Re: [PATCH 1/7] ksmbd: add validation in smb2_ioctl
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021=EB=85=84 9=EC=9B=94 24=EC=9D=BC (=EA=B8=88) =EC=98=A4=EC=A0=84 11:13, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Add validation for request/response buffer size check in smb2_ioctl and
> fsctl_copychunk() take copychunk_ioctl_req pointer and the other argument=
s
> instead of smb2_ioctl_req structure and remove an unused smb2_ioctl_req
> argument of fsctl_validate_negotiate_info.
>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph B=C3=B6hme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/ksmbd/smb2pdu.c | 87 ++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 68 insertions(+), 19 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 0c49a0e887d3..b22d4207c077 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -6927,24 +6927,26 @@ int smb2_lock(struct ksmbd_work *work)
>         return err;
>  }
>
> -static int fsctl_copychunk(struct ksmbd_work *work, struct smb2_ioctl_re=
q *req,
> +static int fsctl_copychunk(struct ksmbd_work *work,
> +                          struct copychunk_ioctl_req *ci_req,
> +                          unsigned int cnt_code,
> +                          unsigned int input_count,
> +                          unsigned long long volatile_id,
> +                          unsigned long long persistent_id,
>                            struct smb2_ioctl_rsp *rsp)
>  {
> -       struct copychunk_ioctl_req *ci_req;
>         struct copychunk_ioctl_rsp *ci_rsp;
>         struct ksmbd_file *src_fp =3D NULL, *dst_fp =3D NULL;
>         struct srv_copychunk *chunks;
>         unsigned int i, chunk_count, chunk_count_written =3D 0;
>         unsigned int chunk_size_written =3D 0;
>         loff_t total_size_written =3D 0;
> -       int ret, cnt_code;
> +       int ret =3D 0;
>
> -       cnt_code =3D le32_to_cpu(req->CntCode);
> -       ci_req =3D (struct copychunk_ioctl_req *)&req->Buffer[0];
>         ci_rsp =3D (struct copychunk_ioctl_rsp *)&rsp->Buffer[0];
>
> -       rsp->VolatileFileId =3D req->VolatileFileId;
> -       rsp->PersistentFileId =3D req->PersistentFileId;
> +       rsp->VolatileFileId =3D cpu_to_le64(volatile_id);
> +       rsp->PersistentFileId =3D cpu_to_le64(persistent_id);
>         ci_rsp->ChunksWritten =3D
>                 cpu_to_le32(ksmbd_server_side_copy_max_chunk_count());
>         ci_rsp->ChunkBytesWritten =3D
> @@ -6954,12 +6956,13 @@ static int fsctl_copychunk(struct ksmbd_work *wor=
k, struct smb2_ioctl_req *req,
>
>         chunks =3D (struct srv_copychunk *)&ci_req->Chunks[0];
>         chunk_count =3D le32_to_cpu(ci_req->ChunkCount);
> +       if (chunk_count =3D=3D 0)
> +               goto out;
>         total_size_written =3D 0;
>
>         /* verify the SRV_COPYCHUNK_COPY packet */
>         if (chunk_count > ksmbd_server_side_copy_max_chunk_count() ||
> -           le32_to_cpu(req->InputCount) <
> -            offsetof(struct copychunk_ioctl_req, Chunks) +
> +           input_count < offsetof(struct copychunk_ioctl_req, Chunks) +
>              chunk_count * sizeof(struct srv_copychunk)) {
>                 rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
>                 return -EINVAL;
> @@ -6980,9 +6983,7 @@ static int fsctl_copychunk(struct ksmbd_work *work,=
 struct smb2_ioctl_req *req,
>
>         src_fp =3D ksmbd_lookup_foreign_fd(work,
>                                          le64_to_cpu(ci_req->ResumeKey[0]=
));
> -       dst_fp =3D ksmbd_lookup_fd_slow(work,
> -                                     le64_to_cpu(req->VolatileFileId),
> -                                     le64_to_cpu(req->PersistentFileId))=
;
> +       dst_fp =3D ksmbd_lookup_fd_slow(work, volatile_id, persistent_id)=
;
>         ret =3D -EINVAL;
>         if (!src_fp ||
>             src_fp->persistent_id !=3D le64_to_cpu(ci_req->ResumeKey[1]))=
 {
> @@ -7057,8 +7058,8 @@ static __be32 idev_ipv4_address(struct in_device *i=
dev)
>  }
>
>  static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
> -                                       struct smb2_ioctl_req *req,
> -                                       struct smb2_ioctl_rsp *rsp)
> +                                       struct smb2_ioctl_rsp *rsp,
> +                                       int out_buf_len)
>  {
>         struct network_interface_info_ioctl_rsp *nii_rsp =3D NULL;
>         int nbytes =3D 0;
> @@ -7141,6 +7142,8 @@ static int fsctl_query_iface_info_ioctl(struct ksmb=
d_conn *conn,
>                         sockaddr_storage->addr6.ScopeId =3D 0;
>                 }
>
> +               if (out_buf_len < sizeof(struct network_interface_info_io=
ctl_rsp))
> +                       break;

Do we need to check whether the remaining(len out_buf_len - nbytes) is
less than sizeof(struct network_interface_info_ioctl_rsp)?

>                 nbytes +=3D sizeof(struct network_interface_info_ioctl_rs=
p);
>         }
>         rtnl_unlock();
> @@ -7161,11 +7164,16 @@ static int fsctl_query_iface_info_ioctl(struct ks=
mbd_conn *conn,
>
>  static int fsctl_validate_negotiate_info(struct ksmbd_conn *conn,
>                                          struct validate_negotiate_info_r=
eq *neg_req,
> -                                        struct validate_negotiate_info_r=
sp *neg_rsp)
> +                                        struct validate_negotiate_info_r=
sp *neg_rsp,
> +                                        int in_buf_len)
>  {
>         int ret =3D 0;
>         int dialect;
>
> +       if (in_buf_len < sizeof(struct validate_negotiate_info_req) +
> +                       le16_to_cpu(neg_req->DialectCount) * sizeof(__le1=
6))
> +               return -EINVAL;
> +
>         dialect =3D ksmbd_lookup_dialect_by_id(neg_req->Dialects,
>                                              neg_req->DialectCount);
>         if (dialect =3D=3D BAD_PROT_ID || dialect !=3D conn->dialect) {
> @@ -7341,7 +7349,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>         struct smb2_ioctl_req *req;
>         struct smb2_ioctl_rsp *rsp, *rsp_org;
>         int cnt_code, nbytes =3D 0;
> -       int out_buf_len;
> +       int out_buf_len, in_buf_len;
>         u64 id =3D KSMBD_NO_FID;
>         struct ksmbd_conn *conn =3D work->conn;
>         int ret =3D 0;
> @@ -7371,6 +7379,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>         cnt_code =3D le32_to_cpu(req->CntCode);
>         out_buf_len =3D le32_to_cpu(req->MaxOutputResponse);
>         out_buf_len =3D min(KSMBD_IPC_MAX_PAYLOAD, out_buf_len);
> +       in_buf_len =3D le32_to_cpu(req->InputCount);
>
>         switch (cnt_code) {
>         case FSCTL_DFS_GET_REFERRALS:
> @@ -7406,9 +7415,16 @@ int smb2_ioctl(struct ksmbd_work *work)
>                         goto out;
>                 }
>
> +               if (in_buf_len < sizeof(struct validate_negotiate_info_re=
q))
> +                       return -EINVAL;
> +
> +               if (out_buf_len < sizeof(struct validate_negotiate_info_r=
sp))
> +                       return -EINVAL;
> +
>                 ret =3D fsctl_validate_negotiate_info(conn,
>                         (struct validate_negotiate_info_req *)&req->Buffe=
r[0],
> -                       (struct validate_negotiate_info_rsp *)&rsp->Buffe=
r[0]);
> +                       (struct validate_negotiate_info_rsp *)&rsp->Buffe=
r[0],
> +                       in_buf_len);
>                 if (ret < 0)
>                         goto out;
>
> @@ -7417,7 +7433,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>                 rsp->VolatileFileId =3D cpu_to_le64(SMB2_NO_FID);
>                 break;
>         case FSCTL_QUERY_NETWORK_INTERFACE_INFO:
> -               nbytes =3D fsctl_query_iface_info_ioctl(conn, req, rsp);
> +               nbytes =3D fsctl_query_iface_info_ioctl(conn, rsp, out_bu=
f_len);
>                 if (nbytes < 0)
>                         goto out;
>                 break;
> @@ -7444,15 +7460,33 @@ int smb2_ioctl(struct ksmbd_work *work)
>                         goto out;
>                 }
>
> +               if (in_buf_len < sizeof(struct copychunk_ioctl_req)) {
> +                       ret =3D -EINVAL;
> +                       goto out;
> +               }
> +
>                 if (out_buf_len < sizeof(struct copychunk_ioctl_rsp)) {
>                         ret =3D -EINVAL;
>                         goto out;
>                 }
>
>                 nbytes =3D sizeof(struct copychunk_ioctl_rsp);
> -               fsctl_copychunk(work, req, rsp);
> +               rsp->VolatileFileId =3D req->VolatileFileId;
> +               rsp->PersistentFileId =3D req->PersistentFileId;
> +               fsctl_copychunk(work,
> +                               (struct copychunk_ioctl_req *)&req->Buffe=
r[0],
> +                               le32_to_cpu(req->CntCode),
> +                               le32_to_cpu(req->InputCount),
> +                               le64_to_cpu(req->VolatileFileId),
> +                               le64_to_cpu(req->PersistentFileId),
> +                               rsp);
>                 break;
>         case FSCTL_SET_SPARSE:
> +               if (in_buf_len < sizeof(struct file_sparse)) {
> +                       ret =3D -EINVAL;
> +                       goto out;
> +               }
> +
>                 ret =3D fsctl_set_sparse(work, id,
>                                        (struct file_sparse *)&req->Buffer=
[0]);
>                 if (ret < 0)
> @@ -7471,6 +7505,11 @@ int smb2_ioctl(struct ksmbd_work *work)
>                         goto out;
>                 }
>
> +               if (in_buf_len < sizeof(struct file_zero_data_information=
)) {
> +                       ret =3D -EINVAL;
> +                       goto out;
> +               }
> +
>                 zero_data =3D
>                         (struct file_zero_data_information *)&req->Buffer=
[0];
>
> @@ -7490,6 +7529,11 @@ int smb2_ioctl(struct ksmbd_work *work)
>                 break;
>         }
>         case FSCTL_QUERY_ALLOCATED_RANGES:
> +               if (in_buf_len < sizeof(struct file_allocated_range_buffe=
r)) {
> +                       ret =3D -EINVAL;
> +                       goto out;
> +               }
> +
>                 ret =3D fsctl_query_allocated_ranges(work, id,
>                         (struct file_allocated_range_buffer *)&req->Buffe=
r[0],
>                         (struct file_allocated_range_buffer *)&rsp->Buffe=
r[0],
> @@ -7530,6 +7574,11 @@ int smb2_ioctl(struct ksmbd_work *work)
>                 struct duplicate_extents_to_file *dup_ext;
>                 loff_t src_off, dst_off, length, cloned;
>
> +               if (in_buf_len < sizeof(struct duplicate_extents_to_file)=
) {
> +                       ret =3D -EINVAL;
> +                       goto out;
> +               }
> +
>                 dup_ext =3D (struct duplicate_extents_to_file *)&req->Buf=
fer[0];
>
>                 fp_in =3D ksmbd_lookup_fd_slow(work, dup_ext->VolatileFil=
eHandle,
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
