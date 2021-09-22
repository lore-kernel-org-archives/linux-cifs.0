Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0796C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 04:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEEB561131
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 04:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbhIVEPL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:15:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229495AbhIVEPL (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 22 Sep 2021 00:15:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1078C60F02
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 04:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632284022;
        bh=nbUa8P2SDa9tQwWnKnhRDuKPedHs2Fbv8mwii9qDJeg=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=H4jjOoH4uSdqMPPIhXB35FmqKyRSNeaY6ROrlpxgue8bukZjF1cZ+b9qmPmPCN0v4
         QmLWDA6cVUHMRu78e4TCVx+ue6JZFO9vQ7+g1yqBF7LWoRLI4z71hx0yCjWrufg03j
         xk5ROaxnKNxo6Tt4LusaAT4YVAnGCVp6S8f2GOvw7Jyg7Wr+OW+snNN+dKAnbesfoz
         aY/XvrqWNQuFWUB67etZIatpCfYLQLJqz0+Bo74BhCDUTZAlU8QX6iojoEmWHJRbNC
         JeSdIMgF/pQy1+MPa2cKhmk0qK6gvbJYPiWdoMopipRb6Qq100CUBBX3VQbM5sYeCk
         70IO/1SfXNXaw==
Received: by mail-ot1-f51.google.com with SMTP id c42-20020a05683034aa00b0051f4b99c40cso1799248otu.0
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 21:13:42 -0700 (PDT)
X-Gm-Message-State: AOAM532GyYOEEY9vQ88KP4wtpB/9puA9ASIukp+ni0GGjvPkh3ouwcQX
        1nePn7N29q7nce30GoXkLSB1JlN2UUZjLQDe/NI=
X-Google-Smtp-Source: ABdhPJyd2eJaOELmHBbhXJliOOIMUIOWHws022U+TqQvE/7e4S9aSpq4oSu570CvlsdNwj3oZUqJPl09ob/czWcuHcE=
X-Received: by 2002:a9d:5e05:: with SMTP id d5mr28429079oti.61.1632284021434;
 Tue, 21 Sep 2021 21:13:41 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Tue, 21 Sep 2021 21:13:40
 -0700 (PDT)
In-Reply-To: <CAN05THQxkVzGXZXunqdb-ZpQe+KA0YXjL7tTMKOeEhd_Cv8=Lg@mail.gmail.com>
References: <20210922022811.654412-1-linkinjeon@kernel.org>
 <CAN05THQGvRqAsej02b6uje8duTAoOv_tdnT9dLHyWg1pDrsXJA@mail.gmail.com> <CAN05THQxkVzGXZXunqdb-ZpQe+KA0YXjL7tTMKOeEhd_Cv8=Lg@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 22 Sep 2021 13:13:40 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-q+6WDZF=stGd+TzmbumTbS7djONqjPUU79EBLUHhzjw@mail.gmail.com>
Message-ID: <CAKYAXd-q+6WDZF=stGd+TzmbumTbS7djONqjPUU79EBLUHhzjw@mail.gmail.com>
Subject: Re: [PATCH v3] ksmbd: add validation in smb2_ioctl
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-22 13:08 GMT+09:00, ronnie sahlberg <ronniesahlberg@gmail.com>:
> Ignore.  Looking at the wrong code.
To avoid confusion,  I have pushed all in-flight patches to my github
to review correctly.
Please check this branch.
https://github.com/namjaejeon/smb3-kernel/tree/ksmbd-for-next

Thanks!

>
> On Wed, Sep 22, 2021 at 1:48 PM ronnie sahlberg
> <ronniesahlberg@gmail.com> wrote:
>>
>> I hope I look at the right patches/branches, appologies if not.
>>
>> Do you have a branch where you have all these patches applied?
>>
>> On Wed, Sep 22, 2021 at 12:28 PM Namjae Jeon <linkinjeon@kernel.org>
>> wrote:
>> >
>> > Add validation for request/response buffer size check in smb2_ioctl an=
d
>> > fsctl_copychunk() take copychunk_ioctl_req pointer and the other
>> > arguments
>> > instead of smb2_ioctl_req structure and remove an unused smb2_ioctl_re=
q
>> > argument of fsctl_validate_negotiate_info.
>> >
>> > Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> > Cc: Ralph B=C3=B6hme <slow@samba.org>
>> > Cc: Steve French <smfrench@gmail.com>
>> > Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> > ---
>> >  v2:
>> >    - fix warning: variable 'ret' is used uninitialized ret.
>> >  v3:
>> >    - fsctl_copychunk() take copychunk_ioctl_req pointer and the other
>> > arguments
>> >      instead of smb2_ioctl_req structure.
>> >    - remove an unused smb2_ioctl_req argument of
>> > fsctl_validate_negotiate_info.
>> >  fs/ksmbd/smb2pdu.c | 87 ++++++++++++++++++++++++++++++++++++---------=
-
>> >  1 file changed, 68 insertions(+), 19 deletions(-)
>> >
>> > diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> > index aaf50f677194..e96491c9ab92 100644
>> > --- a/fs/ksmbd/smb2pdu.c
>> > +++ b/fs/ksmbd/smb2pdu.c
>> > @@ -6986,24 +6986,26 @@ int smb2_lock(struct ksmbd_work *work)
>> >         return err;
>> >  }
>> >
>> > -static int fsctl_copychunk(struct ksmbd_work *work, struct
>> > smb2_ioctl_req *req,
>> > +static int fsctl_copychunk(struct ksmbd_work *work,
>> > +                          struct copychunk_ioctl_req *ci_req,
>> > +                          unsigned int cnt_code,
>> > +                          unsigned int input_count,
>> > +                          unsigned long long volatile_id,
>> > +                          unsigned long long persistent_id,
>> >                            struct smb2_ioctl_rsp *rsp)
>> >  {
>> > -       struct copychunk_ioctl_req *ci_req;
>> >         struct copychunk_ioctl_rsp *ci_rsp;
>> >         struct ksmbd_file *src_fp =3D NULL, *dst_fp =3D NULL;
>> >         struct srv_copychunk *chunks;
>> >         unsigned int i, chunk_count, chunk_count_written =3D 0;
>> >         unsigned int chunk_size_written =3D 0;
>> >         loff_t total_size_written =3D 0;
>> > -       int ret, cnt_code;
>> > +       int ret =3D 0;
>> >
>> > -       cnt_code =3D le32_to_cpu(req->CntCode);
>> > -       ci_req =3D (struct copychunk_ioctl_req *)&req->Buffer[0];
>> >         ci_rsp =3D (struct copychunk_ioctl_rsp *)&rsp->Buffer[0];
>> >
>> > -       rsp->VolatileFileId =3D req->VolatileFileId;
>> > -       rsp->PersistentFileId =3D req->PersistentFileId;
>> > +       rsp->VolatileFileId =3D cpu_to_le64(volatile_id);
>> > +       rsp->PersistentFileId =3D cpu_to_le64(persistent_id);
>> >         ci_rsp->ChunksWritten =3D
>> >                 cpu_to_le32(ksmbd_server_side_copy_max_chunk_count());
>> >         ci_rsp->ChunkBytesWritten =3D
>> > @@ -7013,12 +7015,13 @@ static int fsctl_copychunk(struct ksmbd_work
>> > *work, struct smb2_ioctl_req *req,
>> >
>> >         chunks =3D (struct srv_copychunk *)&ci_req->Chunks[0];
>> >         chunk_count =3D le32_to_cpu(ci_req->ChunkCount);
>> > +       if (chunk_count =3D=3D 0)
>> > +               goto out;
>> >         total_size_written =3D 0;
>> >
>> >         /* verify the SRV_COPYCHUNK_COPY packet */
>> >         if (chunk_count > ksmbd_server_side_copy_max_chunk_count() ||
>> > -           le32_to_cpu(req->InputCount) <
>> > -            offsetof(struct copychunk_ioctl_req, Chunks) +
>> > +           input_count < offsetof(struct copychunk_ioctl_req, Chunks)
>> > +
>> >              chunk_count * sizeof(struct srv_copychunk)) {
>> >                 rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
>> >                 return -EINVAL;
>> > @@ -7039,9 +7042,7 @@ static int fsctl_copychunk(struct ksmbd_work
>> > *work, struct smb2_ioctl_req *req,
>> >
>> >         src_fp =3D ksmbd_lookup_foreign_fd(work,
>> >
>> > le64_to_cpu(ci_req->ResumeKey[0]));
>> > -       dst_fp =3D ksmbd_lookup_fd_slow(work,
>> > -                                     le64_to_cpu(req->VolatileFileId)=
,
>> > -
>> > le64_to_cpu(req->PersistentFileId));
>> > +       dst_fp =3D ksmbd_lookup_fd_slow(work, volatile_id,
>> > persistent_id);
>> >         ret =3D -EINVAL;
>> >         if (!src_fp ||
>> >             src_fp->persistent_id !=3D le64_to_cpu(ci_req->ResumeKey[1=
]))
>> > {
>> > @@ -7116,8 +7117,8 @@ static __be32 idev_ipv4_address(struct in_device
>> > *idev)
>> >  }
>> >
>> >  static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
>> > -                                       struct smb2_ioctl_req *req,
>> > -                                       struct smb2_ioctl_rsp *rsp)
>> > +                                       struct smb2_ioctl_rsp *rsp,
>> > +                                       int out_buf_len)
>> >  {
>> >         struct network_interface_info_ioctl_rsp *nii_rsp =3D NULL;
>> >         int nbytes =3D 0;
>> > @@ -7200,6 +7201,8 @@ static int fsctl_query_iface_info_ioctl(struct
>> > ksmbd_conn *conn,
>> >                         sockaddr_storage->addr6.ScopeId =3D 0;
>> >                 }
>> >
>> > +               if (out_buf_len < sizeof(struct
>> > network_interface_info_ioctl_rsp))
>> > +                       break;
>> >                 nbytes +=3D sizeof(struct
>> > network_interface_info_ioctl_rsp);
>> >         }
>> >         rtnl_unlock();
>> > @@ -7220,11 +7223,16 @@ static int fsctl_query_iface_info_ioctl(struct
>> > ksmbd_conn *conn,
>> >
>> >  static int fsctl_validate_negotiate_info(struct ksmbd_conn *conn,
>> >                                          struct
>> > validate_negotiate_info_req *neg_req,
>> > -                                        struct
>> > validate_negotiate_info_rsp *neg_rsp)
>> > +                                        struct
>> > validate_negotiate_info_rsp *neg_rsp,
>> > +                                        int in_buf_len)
>> >  {
>> >         int ret =3D 0;
>> >         int dialect;
>> >
>> > +       if (in_buf_len < sizeof(struct validate_negotiate_info_req) +
>> > +                       le16_to_cpu(neg_req->DialectCount) *
>> > sizeof(__le16))
>> > +               return -EINVAL;
>> > +
>> >         dialect =3D ksmbd_lookup_dialect_by_id(neg_req->Dialects,
>> >                                              neg_req->DialectCount);
>> >         if (dialect =3D=3D BAD_PROT_ID || dialect !=3D conn->dialect) =
{
>> > @@ -7400,7 +7408,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>> >         struct smb2_ioctl_req *req;
>> >         struct smb2_ioctl_rsp *rsp, *rsp_org;
>> >         int cnt_code, nbytes =3D 0;
>> > -       int out_buf_len;
>> > +       int out_buf_len, in_buf_len;
>> >         u64 id =3D KSMBD_NO_FID;
>> >         struct ksmbd_conn *conn =3D work->conn;
>> >         int ret =3D 0;
>> > @@ -7430,6 +7438,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>> >         cnt_code =3D le32_to_cpu(req->CntCode);
>> >         out_buf_len =3D le32_to_cpu(req->MaxOutputResponse);
>> >         out_buf_len =3D min(KSMBD_IPC_MAX_PAYLOAD, out_buf_len);
>> > +       in_buf_len =3D le32_to_cpu(req->InputCount);
>>
>> Do you check if you have these many bytes remaining in the buffer?
>>
>> Also earlier in this function, where you assign req.
>> If this is not a component in a compound, then you assign req =3D
>> work->request_buf
>> which starts with 4 bytes for the length and the smb2_hdr starts at
>> offset 4, right?
>>
>> But if the ioctl is inside a compound, you assign req =3D
>> ksmbd_req_buf_next()
>> which just returns the offset to wherever NextCommand is?
>> There are two problems here.
>> Now req points to something where teh smb2 header starts at offset 0
>> instead of 4.
>> I unfortunately do not have any code to create Create/Ioctl/Close
>> compounds to test this,
>> but it looks like this is a problem.
>>
>> The second is that there is no check I can see that we validate that
>> req now points to valid data,
>> which means that when we dereference req just a few lines later
>> (req->VolatileFileId)
>> we might read random data beyond the end of request_buf   or we might
>> oops.
>>
>>
>> The same might be an issue in other functions as well.
>>
>>
>> >
>> >         switch (cnt_code) {
>> >         case FSCTL_DFS_GET_REFERRALS:
>> > @@ -7465,9 +7474,16 @@ int smb2_ioctl(struct ksmbd_work *work)
>> >                         goto out;
>> >                 }
>> >
>> > +               if (in_buf_len < sizeof(struct
>> > validate_negotiate_info_req))
>> > +                       return -EINVAL;
>> > +
>> > +               if (out_buf_len < sizeof(struct
>> > validate_negotiate_info_rsp))
>> > +                       return -EINVAL;
>> > +
>> >                 ret =3D fsctl_validate_negotiate_info(conn,
>> >                         (struct validate_negotiate_info_req
>> > *)&req->Buffer[0],
>> > -                       (struct validate_negotiate_info_rsp
>> > *)&rsp->Buffer[0]);
>> > +                       (struct validate_negotiate_info_rsp
>> > *)&rsp->Buffer[0],
>> > +                       in_buf_len);
>> >                 if (ret < 0)
>> >                         goto out;
>> >
>> > @@ -7476,7 +7492,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>> >                 rsp->VolatileFileId =3D cpu_to_le64(SMB2_NO_FID);
>> >                 break;
>> >         case FSCTL_QUERY_NETWORK_INTERFACE_INFO:
>> > -               nbytes =3D fsctl_query_iface_info_ioctl(conn, req, rsp=
);
>> > +               nbytes =3D fsctl_query_iface_info_ioctl(conn, rsp,
>> > out_buf_len);
>> >                 if (nbytes < 0)
>> >                         goto out;
>> >                 break;
>> > @@ -7503,15 +7519,33 @@ int smb2_ioctl(struct ksmbd_work *work)
>> >                         goto out;
>> >                 }
>> >
>> > +               if (in_buf_len < sizeof(struct copychunk_ioctl_req)) {
>> > +                       ret =3D -EINVAL;
>> > +                       goto out;
>> > +               }
>> > +
>> >                 if (out_buf_len < sizeof(struct copychunk_ioctl_rsp)) =
{
>> >                         ret =3D -EINVAL;
>> >                         goto out;
>> >                 }
>> >
>> >                 nbytes =3D sizeof(struct copychunk_ioctl_rsp);
>> > -               fsctl_copychunk(work, req, rsp);
>> > +               rsp->VolatileFileId =3D req->VolatileFileId;
>> > +               rsp->PersistentFileId =3D req->PersistentFileId;
>> > +               fsctl_copychunk(work,
>> > +                               (struct copychunk_ioctl_req
>> > *)&req->Buffer[0],
>> > +                               le32_to_cpu(req->CntCode),
>> > +                               le32_to_cpu(req->InputCount),
>> > +                               le64_to_cpu(req->VolatileFileId),
>> > +                               le64_to_cpu(req->PersistentFileId),
>> > +                               rsp);
>> >                 break;
>> >         case FSCTL_SET_SPARSE:
>> > +               if (in_buf_len < sizeof(struct file_sparse)) {
>> > +                       ret =3D -EINVAL;
>> > +                       goto out;
>> > +               }
>> > +
>> >                 ret =3D fsctl_set_sparse(work, id,
>> >                                        (struct file_sparse
>> > *)&req->Buffer[0]);
>> >                 if (ret < 0)
>> > @@ -7530,6 +7564,11 @@ int smb2_ioctl(struct ksmbd_work *work)
>> >                         goto out;
>> >                 }
>> >
>> > +               if (in_buf_len < sizeof(struct
>> > file_zero_data_information)) {
>> > +                       ret =3D -EINVAL;
>> > +                       goto out;
>> > +               }
>> > +
>> >                 zero_data =3D
>> >                         (struct file_zero_data_information
>> > *)&req->Buffer[0];
>> >
>> > @@ -7549,6 +7588,11 @@ int smb2_ioctl(struct ksmbd_work *work)
>> >                 break;
>> >         }
>> >         case FSCTL_QUERY_ALLOCATED_RANGES:
>> > +               if (in_buf_len < sizeof(struct
>> > file_allocated_range_buffer)) {
>> > +                       ret =3D -EINVAL;
>> > +                       goto out;
>> > +               }
>> > +
>> >                 ret =3D fsctl_query_allocated_ranges(work, id,
>> >                         (struct file_allocated_range_buffer
>> > *)&req->Buffer[0],
>> >                         (struct file_allocated_range_buffer
>> > *)&rsp->Buffer[0],
>> > @@ -7589,6 +7633,11 @@ int smb2_ioctl(struct ksmbd_work *work)
>> >                 struct duplicate_extents_to_file *dup_ext;
>> >                 loff_t src_off, dst_off, length, cloned;
>> >
>> > +               if (in_buf_len < sizeof(struct
>> > duplicate_extents_to_file)) {
>> > +                       ret =3D -EINVAL;
>> > +                       goto out;
>> > +               }
>> > +
>> >                 dup_ext =3D (struct duplicate_extents_to_file
>> > *)&req->Buffer[0];
>> >
>> >                 fp_in =3D ksmbd_lookup_fd_slow(work,
>> > dup_ext->VolatileFileHandle,
>> > --
>> > 2.25.1
>> >
>
