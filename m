Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B066C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 10:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFC7C61279
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 10:44:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243920AbhIYKpl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 25 Sep 2021 06:45:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235805AbhIYKpl (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 25 Sep 2021 06:45:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A774A6127B
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 10:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632566646;
        bh=WjTCUcwLH5fHK2OvPhJxKOB6rzkwARMkk7Gwy37/9B4=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=vO8+7m2mRy0EEeJC0ialNyAjrXLiUq2uFvmzb44Uyp0WnvHcUUg6yHKaTl0BZPkWw
         tX9E2+ZSNxJxrhJKiHgVglMPnb3XJYAgkPxGi3smC8pAqKehvzz8dwroojogoMAUHi
         FQiMtKUbkXIRv6bYdND3omS7K/hGeXcQ/NMVhl2O2iyIFyN19BHWoynDxuxrftva23
         QLdJkGnSCo8Q6MjKGkEJqotQUs818o13EZ1yGYjm/1QjgVYgni60qxHDhpdzVPJqh4
         3c/sZkuEPW+kk3PaNO8592BgsTPwpXJqXhlOUTeDensH1CY9mmLYTJUNqRYkGeFm5M
         rmHus5ZgalwRg==
Received: by mail-oo1-f51.google.com with SMTP id a17-20020a4a6851000000b002b59bfbf669so144114oof.9
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 03:44:06 -0700 (PDT)
X-Gm-Message-State: AOAM531998+bG0dYRdnvXe6wayG2/qcnGttBuKTq1mqXj6iMtj08cduC
        uqFFwg4vdlo7q9xhAPaQaDQIK5oz2ODdVNCeIe8=
X-Google-Smtp-Source: ABdhPJz819ntqDr/ZdRmGsmONwfcP5yPY9jknqNA+ZnGNduIFI3Xs4fNjeuVtdHNlFZw0Xl8zwOFesWrdu1Hi9WEul4=
X-Received: by 2002:a4a:d30f:: with SMTP id g15mr12267327oos.32.1632566646030;
 Sat, 25 Sep 2021 03:44:06 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Sat, 25 Sep 2021 03:44:05
 -0700 (PDT)
In-Reply-To: <CANFS6baQVtiBGQCGeZhvCrPeSVF0647PzsNRrU93Wra+m_iNEg@mail.gmail.com>
References: <20210924021254.27096-1-linkinjeon@kernel.org> <20210924021254.27096-2-linkinjeon@kernel.org>
 <CANFS6baQVtiBGQCGeZhvCrPeSVF0647PzsNRrU93Wra+m_iNEg@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 25 Sep 2021 19:44:05 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-buj=iLH8VsKoMuYR7k-UAfk+_AaHNaT9OwENSGcaxew@mail.gmail.com>
Message-ID: <CAKYAXd-buj=iLH8VsKoMuYR7k-UAfk+_AaHNaT9OwENSGcaxew@mail.gmail.com>
Subject: Re: [PATCH 1/7] ksmbd: add validation in smb2_ioctl
To:     Hyunchul Lee <hyc.lee@gmail.com>
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

2021-09-25 19:16 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> 2021=EB=85=84 9=EC=9B=94 24=EC=9D=BC (=EA=B8=88) =EC=98=A4=EC=A0=84 11:13=
, Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>>
>> Add validation for request/response buffer size check in smb2_ioctl and
>> fsctl_copychunk() take copychunk_ioctl_req pointer and the other
>> arguments
>> instead of smb2_ioctl_req structure and remove an unused smb2_ioctl_req
>> argument of fsctl_validate_negotiate_info.
>>
>> Cc: Tom Talpey <tom@talpey.com>
>> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> Cc: Ralph B=C3=B6hme <slow@samba.org>
>> Cc: Steve French <smfrench@gmail.com>
>> Cc: Hyunchul Lee <hyc.lee@gmail.com>
>> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>  fs/ksmbd/smb2pdu.c | 87 ++++++++++++++++++++++++++++++++++++----------
>>  1 file changed, 68 insertions(+), 19 deletions(-)
>>
>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> index 0c49a0e887d3..b22d4207c077 100644
>> --- a/fs/ksmbd/smb2pdu.c
>> +++ b/fs/ksmbd/smb2pdu.c
>> @@ -6927,24 +6927,26 @@ int smb2_lock(struct ksmbd_work *work)
>>         return err;
>>  }
>>
>> -static int fsctl_copychunk(struct ksmbd_work *work, struct smb2_ioctl_r=
eq
>> *req,
>> +static int fsctl_copychunk(struct ksmbd_work *work,
>> +                          struct copychunk_ioctl_req *ci_req,
>> +                          unsigned int cnt_code,
>> +                          unsigned int input_count,
>> +                          unsigned long long volatile_id,
>> +                          unsigned long long persistent_id,
>>                            struct smb2_ioctl_rsp *rsp)
>>  {
>> -       struct copychunk_ioctl_req *ci_req;
>>         struct copychunk_ioctl_rsp *ci_rsp;
>>         struct ksmbd_file *src_fp =3D NULL, *dst_fp =3D NULL;
>>         struct srv_copychunk *chunks;
>>         unsigned int i, chunk_count, chunk_count_written =3D 0;
>>         unsigned int chunk_size_written =3D 0;
>>         loff_t total_size_written =3D 0;
>> -       int ret, cnt_code;
>> +       int ret =3D 0;
>>
>> -       cnt_code =3D le32_to_cpu(req->CntCode);
>> -       ci_req =3D (struct copychunk_ioctl_req *)&req->Buffer[0];
>>         ci_rsp =3D (struct copychunk_ioctl_rsp *)&rsp->Buffer[0];
>>
>> -       rsp->VolatileFileId =3D req->VolatileFileId;
>> -       rsp->PersistentFileId =3D req->PersistentFileId;
>> +       rsp->VolatileFileId =3D cpu_to_le64(volatile_id);
>> +       rsp->PersistentFileId =3D cpu_to_le64(persistent_id);
>>         ci_rsp->ChunksWritten =3D
>>                 cpu_to_le32(ksmbd_server_side_copy_max_chunk_count());
>>         ci_rsp->ChunkBytesWritten =3D
>> @@ -6954,12 +6956,13 @@ static int fsctl_copychunk(struct ksmbd_work
>> *work, struct smb2_ioctl_req *req,
>>
>>         chunks =3D (struct srv_copychunk *)&ci_req->Chunks[0];
>>         chunk_count =3D le32_to_cpu(ci_req->ChunkCount);
>> +       if (chunk_count =3D=3D 0)
>> +               goto out;
>>         total_size_written =3D 0;
>>
>>         /* verify the SRV_COPYCHUNK_COPY packet */
>>         if (chunk_count > ksmbd_server_side_copy_max_chunk_count() ||
>> -           le32_to_cpu(req->InputCount) <
>> -            offsetof(struct copychunk_ioctl_req, Chunks) +
>> +           input_count < offsetof(struct copychunk_ioctl_req, Chunks) +
>>              chunk_count * sizeof(struct srv_copychunk)) {
>>                 rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
>>                 return -EINVAL;
>> @@ -6980,9 +6983,7 @@ static int fsctl_copychunk(struct ksmbd_work *work=
,
>> struct smb2_ioctl_req *req,
>>
>>         src_fp =3D ksmbd_lookup_foreign_fd(work,
>>
>> le64_to_cpu(ci_req->ResumeKey[0]));
>> -       dst_fp =3D ksmbd_lookup_fd_slow(work,
>> -                                     le64_to_cpu(req->VolatileFileId),
>> -
>> le64_to_cpu(req->PersistentFileId));
>> +       dst_fp =3D ksmbd_lookup_fd_slow(work, volatile_id, persistent_id=
);
>>         ret =3D -EINVAL;
>>         if (!src_fp ||
>>             src_fp->persistent_id !=3D le64_to_cpu(ci_req->ResumeKey[1])=
) {
>> @@ -7057,8 +7058,8 @@ static __be32 idev_ipv4_address(struct in_device
>> *idev)
>>  }
>>
>>  static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
>> -                                       struct smb2_ioctl_req *req,
>> -                                       struct smb2_ioctl_rsp *rsp)
>> +                                       struct smb2_ioctl_rsp *rsp,
>> +                                       int out_buf_len)
>>  {
>>         struct network_interface_info_ioctl_rsp *nii_rsp =3D NULL;
>>         int nbytes =3D 0;
>> @@ -7141,6 +7142,8 @@ static int fsctl_query_iface_info_ioctl(struct
>> ksmbd_conn *conn,
>>                         sockaddr_storage->addr6.ScopeId =3D 0;
>>                 }
>>
>> +               if (out_buf_len < sizeof(struct
>> network_interface_info_ioctl_rsp))
>> +                       break;
>
> Do we need to check whether the remaining(len out_buf_len - nbytes) is
> less than sizeof(struct network_interface_info_ioctl_rsp)?
Right. will fix it on next version. Thanks for your review!
>
>>                 nbytes +=3D sizeof(struct
>> network_interface_info_ioctl_rsp);
>>         }
>>         rtnl_unlock();
>> @@ -7161,11 +7164,16 @@ static int fsctl_query_iface_info_ioctl(struct
>> ksmbd_conn *conn,
>>
>>  static int fsctl_validate_negotiate_info(struct ksmbd_conn *conn,
>>                                          struct
>> validate_negotiate_info_req *neg_req,
>> -                                        struct
>> validate_negotiate_info_rsp *neg_rsp)
>> +                                        struct
>> validate_negotiate_info_rsp *neg_rsp,
>> +                                        int in_buf_len)
>>  {
>>         int ret =3D 0;
>>         int dialect;
>>
>> +       if (in_buf_len < sizeof(struct validate_negotiate_info_req) +
>> +                       le16_to_cpu(neg_req->DialectCount) *
>> sizeof(__le16))
>> +               return -EINVAL;
>> +
>>         dialect =3D ksmbd_lookup_dialect_by_id(neg_req->Dialects,
>>                                              neg_req->DialectCount);
>>         if (dialect =3D=3D BAD_PROT_ID || dialect !=3D conn->dialect) {
>> @@ -7341,7 +7349,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>>         struct smb2_ioctl_req *req;
>>         struct smb2_ioctl_rsp *rsp, *rsp_org;
>>         int cnt_code, nbytes =3D 0;
>> -       int out_buf_len;
>> +       int out_buf_len, in_buf_len;
>>         u64 id =3D KSMBD_NO_FID;
>>         struct ksmbd_conn *conn =3D work->conn;
>>         int ret =3D 0;
>> @@ -7371,6 +7379,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>>         cnt_code =3D le32_to_cpu(req->CntCode);
>>         out_buf_len =3D le32_to_cpu(req->MaxOutputResponse);
>>         out_buf_len =3D min(KSMBD_IPC_MAX_PAYLOAD, out_buf_len);
>> +       in_buf_len =3D le32_to_cpu(req->InputCount);
>>
>>         switch (cnt_code) {
>>         case FSCTL_DFS_GET_REFERRALS:
>> @@ -7406,9 +7415,16 @@ int smb2_ioctl(struct ksmbd_work *work)
>>                         goto out;
>>                 }
>>
>> +               if (in_buf_len < sizeof(struct
>> validate_negotiate_info_req))
>> +                       return -EINVAL;
>> +
>> +               if (out_buf_len < sizeof(struct
>> validate_negotiate_info_rsp))
>> +                       return -EINVAL;
>> +
>>                 ret =3D fsctl_validate_negotiate_info(conn,
>>                         (struct validate_negotiate_info_req
>> *)&req->Buffer[0],
>> -                       (struct validate_negotiate_info_rsp
>> *)&rsp->Buffer[0]);
>> +                       (struct validate_negotiate_info_rsp
>> *)&rsp->Buffer[0],
>> +                       in_buf_len);
>>                 if (ret < 0)
>>                         goto out;
>>
>> @@ -7417,7 +7433,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>>                 rsp->VolatileFileId =3D cpu_to_le64(SMB2_NO_FID);
>>                 break;
>>         case FSCTL_QUERY_NETWORK_INTERFACE_INFO:
>> -               nbytes =3D fsctl_query_iface_info_ioctl(conn, req, rsp);
>> +               nbytes =3D fsctl_query_iface_info_ioctl(conn, rsp,
>> out_buf_len);
>>                 if (nbytes < 0)
>>                         goto out;
>>                 break;
>> @@ -7444,15 +7460,33 @@ int smb2_ioctl(struct ksmbd_work *work)
>>                         goto out;
>>                 }
>>
>> +               if (in_buf_len < sizeof(struct copychunk_ioctl_req)) {
>> +                       ret =3D -EINVAL;
>> +                       goto out;
>> +               }
>> +
>>                 if (out_buf_len < sizeof(struct copychunk_ioctl_rsp)) {
>>                         ret =3D -EINVAL;
>>                         goto out;
>>                 }
>>
>>                 nbytes =3D sizeof(struct copychunk_ioctl_rsp);
>> -               fsctl_copychunk(work, req, rsp);
>> +               rsp->VolatileFileId =3D req->VolatileFileId;
>> +               rsp->PersistentFileId =3D req->PersistentFileId;
>> +               fsctl_copychunk(work,
>> +                               (struct copychunk_ioctl_req
>> *)&req->Buffer[0],
>> +                               le32_to_cpu(req->CntCode),
>> +                               le32_to_cpu(req->InputCount),
>> +                               le64_to_cpu(req->VolatileFileId),
>> +                               le64_to_cpu(req->PersistentFileId),
>> +                               rsp);
>>                 break;
>>         case FSCTL_SET_SPARSE:
>> +               if (in_buf_len < sizeof(struct file_sparse)) {
>> +                       ret =3D -EINVAL;
>> +                       goto out;
>> +               }
>> +
>>                 ret =3D fsctl_set_sparse(work, id,
>>                                        (struct file_sparse
>> *)&req->Buffer[0]);
>>                 if (ret < 0)
>> @@ -7471,6 +7505,11 @@ int smb2_ioctl(struct ksmbd_work *work)
>>                         goto out;
>>                 }
>>
>> +               if (in_buf_len < sizeof(struct
>> file_zero_data_information)) {
>> +                       ret =3D -EINVAL;
>> +                       goto out;
>> +               }
>> +
>>                 zero_data =3D
>>                         (struct file_zero_data_information
>> *)&req->Buffer[0];
>>
>> @@ -7490,6 +7529,11 @@ int smb2_ioctl(struct ksmbd_work *work)
>>                 break;
>>         }
>>         case FSCTL_QUERY_ALLOCATED_RANGES:
>> +               if (in_buf_len < sizeof(struct
>> file_allocated_range_buffer)) {
>> +                       ret =3D -EINVAL;
>> +                       goto out;
>> +               }
>> +
>>                 ret =3D fsctl_query_allocated_ranges(work, id,
>>                         (struct file_allocated_range_buffer
>> *)&req->Buffer[0],
>>                         (struct file_allocated_range_buffer
>> *)&rsp->Buffer[0],
>> @@ -7530,6 +7574,11 @@ int smb2_ioctl(struct ksmbd_work *work)
>>                 struct duplicate_extents_to_file *dup_ext;
>>                 loff_t src_off, dst_off, length, cloned;
>>
>> +               if (in_buf_len < sizeof(struct duplicate_extents_to_file=
))
>> {
>> +                       ret =3D -EINVAL;
>> +                       goto out;
>> +               }
>> +
>>                 dup_ext =3D (struct duplicate_extents_to_file
>> *)&req->Buffer[0];
>>
>>                 fp_in =3D ksmbd_lookup_fd_slow(work,
>> dup_ext->VolatileFileHandle,
>> --
>> 2.25.1
>>
>
>
> --
> Thanks,
> Hyunchul
>
