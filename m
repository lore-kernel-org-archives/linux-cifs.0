Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07309C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 03:48:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D95C8604DA
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 03:48:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhIVDtu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 23:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbhIVDtu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Sep 2021 23:49:50 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E922C061574
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 20:48:20 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id co2so4442970edb.8
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 20:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oKzTNeGhzL0PZsXgVAG7GbBGf5TCYBdNSN8rnmTpKsw=;
        b=Uzcitn2OUKpBs0C5iMVQWtbSQgGqNLHv2MosKTo8wN88OGEkmrOH3lP85VgMDDHM4I
         W6dSr0MEGNwTmWH2f995e24coIiLwHSCLqVH3bbowyk5i3zAGNbfsivmBCz/DfTn3JKo
         bkijmj9tYzFV+OuCCrtB4H/3jqBG6ry9h8CIuTY8OYhHhAGLBz6oTgmpezCgQJJVQ7BJ
         iSTNS/5VIXRibHlWQDQ5omKVukjD4h6240aeVDt5gbiisU8FxiCx+T2xgV9foREoIwMU
         ilg/VE9SRJ2GKs7TwpNtrCuIBkXNvd+PnD1CAQuPkqykPX2Hg0jnlbbXfa/Yc1nCXkCl
         DebA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oKzTNeGhzL0PZsXgVAG7GbBGf5TCYBdNSN8rnmTpKsw=;
        b=3vo91RmJBLiqtR7bfEJIfWfV3rvm5dPZQVLCYKYAMT24f6/drXPQ1DS8dSsbRILPpG
         KFcuCUbnUaKypmBQDcM6GmO1VIKjpoOS25kTqc1YniMRrOGSeD9dWZCY+OjMFu+OTg4N
         gB0vH2vOMkNgrQ3G7TK09bTvXJlGy6B7RG+HnysgQWofPbD8qFIzmlYbubwm8wRSt8ZD
         S4q0OJCbt7M78PzlhBlFX+bo7GsjIiPFcgBOlgVSf/kzkGu6YKfHNec82mMWl1QV7RR2
         XaQ2kVl5FQ2CmYim/8RyYSZRdxyEsYI114wSWaLmMZVkwEJuKkgtiBWaAjIWPgDYgGVc
         fL+w==
X-Gm-Message-State: AOAM531s9eToMf+/T1kTcTPwKWDlNWo44duH+yVcp8Nva7p7nG7P15V4
        BA0qMnESYydCiuzIbh7rZZVpQZwfGlvnald92QbvkcDw
X-Google-Smtp-Source: ABdhPJwhNYHsxc17BAuZ/Dpc+tm/KHlwnNd3oeFpB6xj/1HpOAn3WzfZxGTFhv0wTQFJJspJGNS7OvhZYbITVyuqt7M=
X-Received: by 2002:a17:906:49d5:: with SMTP id w21mr38929068ejv.30.1632282499237;
 Tue, 21 Sep 2021 20:48:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210922022811.654412-1-linkinjeon@kernel.org>
In-Reply-To: <20210922022811.654412-1-linkinjeon@kernel.org>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 22 Sep 2021 13:48:07 +1000
Message-ID: <CAN05THQGvRqAsej02b6uje8duTAoOv_tdnT9dLHyWg1pDrsXJA@mail.gmail.com>
Subject: Re: [PATCH v3] ksmbd: add validation in smb2_ioctl
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I hope I look at the right patches/branches, appologies if not.

Do you have a branch where you have all these patches applied?

On Wed, Sep 22, 2021 at 12:28 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> Add validation for request/response buffer size check in smb2_ioctl and
> fsctl_copychunk() take copychunk_ioctl_req pointer and the other argument=
s
> instead of smb2_ioctl_req structure and remove an unused smb2_ioctl_req
> argument of fsctl_validate_negotiate_info.
>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph B=C3=B6hme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  v2:
>    - fix warning: variable 'ret' is used uninitialized ret.
>  v3:
>    - fsctl_copychunk() take copychunk_ioctl_req pointer and the other arg=
uments
>      instead of smb2_ioctl_req structure.
>    - remove an unused smb2_ioctl_req argument of fsctl_validate_negotiate=
_info.
>  fs/ksmbd/smb2pdu.c | 87 ++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 68 insertions(+), 19 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index aaf50f677194..e96491c9ab92 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -6986,24 +6986,26 @@ int smb2_lock(struct ksmbd_work *work)
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
> @@ -7013,12 +7015,13 @@ static int fsctl_copychunk(struct ksmbd_work *wor=
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
> @@ -7039,9 +7042,7 @@ static int fsctl_copychunk(struct ksmbd_work *work,=
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
> @@ -7116,8 +7117,8 @@ static __be32 idev_ipv4_address(struct in_device *i=
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
> @@ -7200,6 +7201,8 @@ static int fsctl_query_iface_info_ioctl(struct ksmb=
d_conn *conn,
>                         sockaddr_storage->addr6.ScopeId =3D 0;
>                 }
>
> +               if (out_buf_len < sizeof(struct network_interface_info_io=
ctl_rsp))
> +                       break;
>                 nbytes +=3D sizeof(struct network_interface_info_ioctl_rs=
p);
>         }
>         rtnl_unlock();
> @@ -7220,11 +7223,16 @@ static int fsctl_query_iface_info_ioctl(struct ks=
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
> @@ -7400,7 +7408,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>         struct smb2_ioctl_req *req;
>         struct smb2_ioctl_rsp *rsp, *rsp_org;
>         int cnt_code, nbytes =3D 0;
> -       int out_buf_len;
> +       int out_buf_len, in_buf_len;
>         u64 id =3D KSMBD_NO_FID;
>         struct ksmbd_conn *conn =3D work->conn;
>         int ret =3D 0;
> @@ -7430,6 +7438,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>         cnt_code =3D le32_to_cpu(req->CntCode);
>         out_buf_len =3D le32_to_cpu(req->MaxOutputResponse);
>         out_buf_len =3D min(KSMBD_IPC_MAX_PAYLOAD, out_buf_len);
> +       in_buf_len =3D le32_to_cpu(req->InputCount);

Do you check if you have these many bytes remaining in the buffer?

Also earlier in this function, where you assign req.
If this is not a component in a compound, then you assign req =3D
work->request_buf
which starts with 4 bytes for the length and the smb2_hdr starts at
offset 4, right?

But if the ioctl is inside a compound, you assign req =3D ksmbd_req_buf_nex=
t()
which just returns the offset to wherever NextCommand is?
There are two problems here.
Now req points to something where teh smb2 header starts at offset 0
instead of 4.
I unfortunately do not have any code to create Create/Ioctl/Close
compounds to test this,
but it looks like this is a problem.

The second is that there is no check I can see that we validate that
req now points to valid data,
which means that when we dereference req just a few lines later
(req->VolatileFileId)
we might read random data beyond the end of request_buf   or we might oops.


The same might be an issue in other functions as well.


>
>         switch (cnt_code) {
>         case FSCTL_DFS_GET_REFERRALS:
> @@ -7465,9 +7474,16 @@ int smb2_ioctl(struct ksmbd_work *work)
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
> @@ -7476,7 +7492,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>                 rsp->VolatileFileId =3D cpu_to_le64(SMB2_NO_FID);
>                 break;
>         case FSCTL_QUERY_NETWORK_INTERFACE_INFO:
> -               nbytes =3D fsctl_query_iface_info_ioctl(conn, req, rsp);
> +               nbytes =3D fsctl_query_iface_info_ioctl(conn, rsp, out_bu=
f_len);
>                 if (nbytes < 0)
>                         goto out;
>                 break;
> @@ -7503,15 +7519,33 @@ int smb2_ioctl(struct ksmbd_work *work)
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
> @@ -7530,6 +7564,11 @@ int smb2_ioctl(struct ksmbd_work *work)
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
> @@ -7549,6 +7588,11 @@ int smb2_ioctl(struct ksmbd_work *work)
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
> @@ -7589,6 +7633,11 @@ int smb2_ioctl(struct ksmbd_work *work)
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
