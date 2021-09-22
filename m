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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9985C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 04:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA8DD6112F
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 04:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbhIVEJs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhIVEJr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 22 Sep 2021 00:09:47 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C4EC061574
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 21:08:18 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id c21so4847419edj.0
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 21:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NV+6Ov9sCcSN2hClNwp2rpcTepd/cH14i4vft3a4jAc=;
        b=I6Mq+l+x6c7t0w7B4DEbG7EX+Injmf33qTbEAD2eeyk+DntOHOiNvLpdCObkJDydej
         g8XRKoyWSekpesmi+sbji5/T/25aAlLpxe7bGW7t7Jj9ryR7cVwcaZ0naBMrT5P7qzk9
         e3fnbWyIvHuEM2K66uFxkZt/bRrF0asxZzI+vnABm0+nvDqrxZfU5vZ4W5DwSMQEHiG4
         3F+45+coqZNejVB+ltZOMT15a3xkazCWe+EQxCRkDUo15QhwtkPEG+mrR7K8LBiquTF6
         lFT0ksxwijGuaDWbHR92zr5gLCpgic91tVzwjN0vHTJyQsPexoKmh7wqZoNUtPcyyKnR
         y1IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NV+6Ov9sCcSN2hClNwp2rpcTepd/cH14i4vft3a4jAc=;
        b=fVfOYuJMNapWLrcOv5C13f+1pNuT5g/z8CfR+miJVB2j6qNw6LSrGuoIPBBtWyXzj5
         IPZ9vAUwadghwM9KWKllv+q8ZA8I0oj8eGxcmkGr7D3bBgCGonaZ6dSklaq6y2OzckaV
         Xkvaybbj7cn9LRGAW4D6R6bqK8l5o91u30s2gtMWewVPsjn6Bi2CnsowG3E89xuqrSWx
         GD1vKuXZ1H9q3oqoL+ilCGsfUolrcvKoSbF2tdRDums2fO/CuFHvU9UjPmKsehDZmxEz
         uD3wTPW+nXc5PXgW5xN39nvZe5KU8AnazhhvmrXSd6l8b1lBBt6uokyCv1LEt95FXxax
         wJvA==
X-Gm-Message-State: AOAM530yp7surRYLpJtDl5nRX3InrAEzlg4fjgwW0x2sFpfzF678DFhG
        rc1kOlMFLvnPZA2o9wsGFDzrbp6bKYWZpRjyzAM=
X-Google-Smtp-Source: ABdhPJwOnI7cOrrJqAWsAzoXj54jWYvHWlO9K2dfm2NI/WsjTrI3B6deGQEv0I8dfUHQjXZRyARY1niSyQ7/oCJn828=
X-Received: by 2002:a17:906:49d5:: with SMTP id w21mr38999274ejv.30.1632283696528;
 Tue, 21 Sep 2021 21:08:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210922022811.654412-1-linkinjeon@kernel.org> <CAN05THQGvRqAsej02b6uje8duTAoOv_tdnT9dLHyWg1pDrsXJA@mail.gmail.com>
In-Reply-To: <CAN05THQGvRqAsej02b6uje8duTAoOv_tdnT9dLHyWg1pDrsXJA@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 22 Sep 2021 14:08:04 +1000
Message-ID: <CAN05THQxkVzGXZXunqdb-ZpQe+KA0YXjL7tTMKOeEhd_Cv8=Lg@mail.gmail.com>
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

Ignore.  Looking at the wrong code.

On Wed, Sep 22, 2021 at 1:48 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> I hope I look at the right patches/branches, appologies if not.
>
> Do you have a branch where you have all these patches applied?
>
> On Wed, Sep 22, 2021 at 12:28 PM Namjae Jeon <linkinjeon@kernel.org> wrot=
e:
> >
> > Add validation for request/response buffer size check in smb2_ioctl and
> > fsctl_copychunk() take copychunk_ioctl_req pointer and the other argume=
nts
> > instead of smb2_ioctl_req structure and remove an unused smb2_ioctl_req
> > argument of fsctl_validate_negotiate_info.
> >
> > Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> > Cc: Ralph B=C3=B6hme <slow@samba.org>
> > Cc: Steve French <smfrench@gmail.com>
> > Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> > ---
> >  v2:
> >    - fix warning: variable 'ret' is used uninitialized ret.
> >  v3:
> >    - fsctl_copychunk() take copychunk_ioctl_req pointer and the other a=
rguments
> >      instead of smb2_ioctl_req structure.
> >    - remove an unused smb2_ioctl_req argument of fsctl_validate_negotia=
te_info.
> >  fs/ksmbd/smb2pdu.c | 87 ++++++++++++++++++++++++++++++++++++----------
> >  1 file changed, 68 insertions(+), 19 deletions(-)
> >
> > diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> > index aaf50f677194..e96491c9ab92 100644
> > --- a/fs/ksmbd/smb2pdu.c
> > +++ b/fs/ksmbd/smb2pdu.c
> > @@ -6986,24 +6986,26 @@ int smb2_lock(struct ksmbd_work *work)
> >         return err;
> >  }
> >
> > -static int fsctl_copychunk(struct ksmbd_work *work, struct smb2_ioctl_=
req *req,
> > +static int fsctl_copychunk(struct ksmbd_work *work,
> > +                          struct copychunk_ioctl_req *ci_req,
> > +                          unsigned int cnt_code,
> > +                          unsigned int input_count,
> > +                          unsigned long long volatile_id,
> > +                          unsigned long long persistent_id,
> >                            struct smb2_ioctl_rsp *rsp)
> >  {
> > -       struct copychunk_ioctl_req *ci_req;
> >         struct copychunk_ioctl_rsp *ci_rsp;
> >         struct ksmbd_file *src_fp =3D NULL, *dst_fp =3D NULL;
> >         struct srv_copychunk *chunks;
> >         unsigned int i, chunk_count, chunk_count_written =3D 0;
> >         unsigned int chunk_size_written =3D 0;
> >         loff_t total_size_written =3D 0;
> > -       int ret, cnt_code;
> > +       int ret =3D 0;
> >
> > -       cnt_code =3D le32_to_cpu(req->CntCode);
> > -       ci_req =3D (struct copychunk_ioctl_req *)&req->Buffer[0];
> >         ci_rsp =3D (struct copychunk_ioctl_rsp *)&rsp->Buffer[0];
> >
> > -       rsp->VolatileFileId =3D req->VolatileFileId;
> > -       rsp->PersistentFileId =3D req->PersistentFileId;
> > +       rsp->VolatileFileId =3D cpu_to_le64(volatile_id);
> > +       rsp->PersistentFileId =3D cpu_to_le64(persistent_id);
> >         ci_rsp->ChunksWritten =3D
> >                 cpu_to_le32(ksmbd_server_side_copy_max_chunk_count());
> >         ci_rsp->ChunkBytesWritten =3D
> > @@ -7013,12 +7015,13 @@ static int fsctl_copychunk(struct ksmbd_work *w=
ork, struct smb2_ioctl_req *req,
> >
> >         chunks =3D (struct srv_copychunk *)&ci_req->Chunks[0];
> >         chunk_count =3D le32_to_cpu(ci_req->ChunkCount);
> > +       if (chunk_count =3D=3D 0)
> > +               goto out;
> >         total_size_written =3D 0;
> >
> >         /* verify the SRV_COPYCHUNK_COPY packet */
> >         if (chunk_count > ksmbd_server_side_copy_max_chunk_count() ||
> > -           le32_to_cpu(req->InputCount) <
> > -            offsetof(struct copychunk_ioctl_req, Chunks) +
> > +           input_count < offsetof(struct copychunk_ioctl_req, Chunks) =
+
> >              chunk_count * sizeof(struct srv_copychunk)) {
> >                 rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
> >                 return -EINVAL;
> > @@ -7039,9 +7042,7 @@ static int fsctl_copychunk(struct ksmbd_work *wor=
k, struct smb2_ioctl_req *req,
> >
> >         src_fp =3D ksmbd_lookup_foreign_fd(work,
> >                                          le64_to_cpu(ci_req->ResumeKey[=
0]));
> > -       dst_fp =3D ksmbd_lookup_fd_slow(work,
> > -                                     le64_to_cpu(req->VolatileFileId),
> > -                                     le64_to_cpu(req->PersistentFileId=
));
> > +       dst_fp =3D ksmbd_lookup_fd_slow(work, volatile_id, persistent_i=
d);
> >         ret =3D -EINVAL;
> >         if (!src_fp ||
> >             src_fp->persistent_id !=3D le64_to_cpu(ci_req->ResumeKey[1]=
)) {
> > @@ -7116,8 +7117,8 @@ static __be32 idev_ipv4_address(struct in_device =
*idev)
> >  }
> >
> >  static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
> > -                                       struct smb2_ioctl_req *req,
> > -                                       struct smb2_ioctl_rsp *rsp)
> > +                                       struct smb2_ioctl_rsp *rsp,
> > +                                       int out_buf_len)
> >  {
> >         struct network_interface_info_ioctl_rsp *nii_rsp =3D NULL;
> >         int nbytes =3D 0;
> > @@ -7200,6 +7201,8 @@ static int fsctl_query_iface_info_ioctl(struct ks=
mbd_conn *conn,
> >                         sockaddr_storage->addr6.ScopeId =3D 0;
> >                 }
> >
> > +               if (out_buf_len < sizeof(struct network_interface_info_=
ioctl_rsp))
> > +                       break;
> >                 nbytes +=3D sizeof(struct network_interface_info_ioctl_=
rsp);
> >         }
> >         rtnl_unlock();
> > @@ -7220,11 +7223,16 @@ static int fsctl_query_iface_info_ioctl(struct =
ksmbd_conn *conn,
> >
> >  static int fsctl_validate_negotiate_info(struct ksmbd_conn *conn,
> >                                          struct validate_negotiate_info=
_req *neg_req,
> > -                                        struct validate_negotiate_info=
_rsp *neg_rsp)
> > +                                        struct validate_negotiate_info=
_rsp *neg_rsp,
> > +                                        int in_buf_len)
> >  {
> >         int ret =3D 0;
> >         int dialect;
> >
> > +       if (in_buf_len < sizeof(struct validate_negotiate_info_req) +
> > +                       le16_to_cpu(neg_req->DialectCount) * sizeof(__l=
e16))
> > +               return -EINVAL;
> > +
> >         dialect =3D ksmbd_lookup_dialect_by_id(neg_req->Dialects,
> >                                              neg_req->DialectCount);
> >         if (dialect =3D=3D BAD_PROT_ID || dialect !=3D conn->dialect) {
> > @@ -7400,7 +7408,7 @@ int smb2_ioctl(struct ksmbd_work *work)
> >         struct smb2_ioctl_req *req;
> >         struct smb2_ioctl_rsp *rsp, *rsp_org;
> >         int cnt_code, nbytes =3D 0;
> > -       int out_buf_len;
> > +       int out_buf_len, in_buf_len;
> >         u64 id =3D KSMBD_NO_FID;
> >         struct ksmbd_conn *conn =3D work->conn;
> >         int ret =3D 0;
> > @@ -7430,6 +7438,7 @@ int smb2_ioctl(struct ksmbd_work *work)
> >         cnt_code =3D le32_to_cpu(req->CntCode);
> >         out_buf_len =3D le32_to_cpu(req->MaxOutputResponse);
> >         out_buf_len =3D min(KSMBD_IPC_MAX_PAYLOAD, out_buf_len);
> > +       in_buf_len =3D le32_to_cpu(req->InputCount);
>
> Do you check if you have these many bytes remaining in the buffer?
>
> Also earlier in this function, where you assign req.
> If this is not a component in a compound, then you assign req =3D
> work->request_buf
> which starts with 4 bytes for the length and the smb2_hdr starts at
> offset 4, right?
>
> But if the ioctl is inside a compound, you assign req =3D ksmbd_req_buf_n=
ext()
> which just returns the offset to wherever NextCommand is?
> There are two problems here.
> Now req points to something where teh smb2 header starts at offset 0
> instead of 4.
> I unfortunately do not have any code to create Create/Ioctl/Close
> compounds to test this,
> but it looks like this is a problem.
>
> The second is that there is no check I can see that we validate that
> req now points to valid data,
> which means that when we dereference req just a few lines later
> (req->VolatileFileId)
> we might read random data beyond the end of request_buf   or we might oop=
s.
>
>
> The same might be an issue in other functions as well.
>
>
> >
> >         switch (cnt_code) {
> >         case FSCTL_DFS_GET_REFERRALS:
> > @@ -7465,9 +7474,16 @@ int smb2_ioctl(struct ksmbd_work *work)
> >                         goto out;
> >                 }
> >
> > +               if (in_buf_len < sizeof(struct validate_negotiate_info_=
req))
> > +                       return -EINVAL;
> > +
> > +               if (out_buf_len < sizeof(struct validate_negotiate_info=
_rsp))
> > +                       return -EINVAL;
> > +
> >                 ret =3D fsctl_validate_negotiate_info(conn,
> >                         (struct validate_negotiate_info_req *)&req->Buf=
fer[0],
> > -                       (struct validate_negotiate_info_rsp *)&rsp->Buf=
fer[0]);
> > +                       (struct validate_negotiate_info_rsp *)&rsp->Buf=
fer[0],
> > +                       in_buf_len);
> >                 if (ret < 0)
> >                         goto out;
> >
> > @@ -7476,7 +7492,7 @@ int smb2_ioctl(struct ksmbd_work *work)
> >                 rsp->VolatileFileId =3D cpu_to_le64(SMB2_NO_FID);
> >                 break;
> >         case FSCTL_QUERY_NETWORK_INTERFACE_INFO:
> > -               nbytes =3D fsctl_query_iface_info_ioctl(conn, req, rsp)=
;
> > +               nbytes =3D fsctl_query_iface_info_ioctl(conn, rsp, out_=
buf_len);
> >                 if (nbytes < 0)
> >                         goto out;
> >                 break;
> > @@ -7503,15 +7519,33 @@ int smb2_ioctl(struct ksmbd_work *work)
> >                         goto out;
> >                 }
> >
> > +               if (in_buf_len < sizeof(struct copychunk_ioctl_req)) {
> > +                       ret =3D -EINVAL;
> > +                       goto out;
> > +               }
> > +
> >                 if (out_buf_len < sizeof(struct copychunk_ioctl_rsp)) {
> >                         ret =3D -EINVAL;
> >                         goto out;
> >                 }
> >
> >                 nbytes =3D sizeof(struct copychunk_ioctl_rsp);
> > -               fsctl_copychunk(work, req, rsp);
> > +               rsp->VolatileFileId =3D req->VolatileFileId;
> > +               rsp->PersistentFileId =3D req->PersistentFileId;
> > +               fsctl_copychunk(work,
> > +                               (struct copychunk_ioctl_req *)&req->Buf=
fer[0],
> > +                               le32_to_cpu(req->CntCode),
> > +                               le32_to_cpu(req->InputCount),
> > +                               le64_to_cpu(req->VolatileFileId),
> > +                               le64_to_cpu(req->PersistentFileId),
> > +                               rsp);
> >                 break;
> >         case FSCTL_SET_SPARSE:
> > +               if (in_buf_len < sizeof(struct file_sparse)) {
> > +                       ret =3D -EINVAL;
> > +                       goto out;
> > +               }
> > +
> >                 ret =3D fsctl_set_sparse(work, id,
> >                                        (struct file_sparse *)&req->Buff=
er[0]);
> >                 if (ret < 0)
> > @@ -7530,6 +7564,11 @@ int smb2_ioctl(struct ksmbd_work *work)
> >                         goto out;
> >                 }
> >
> > +               if (in_buf_len < sizeof(struct file_zero_data_informati=
on)) {
> > +                       ret =3D -EINVAL;
> > +                       goto out;
> > +               }
> > +
> >                 zero_data =3D
> >                         (struct file_zero_data_information *)&req->Buff=
er[0];
> >
> > @@ -7549,6 +7588,11 @@ int smb2_ioctl(struct ksmbd_work *work)
> >                 break;
> >         }
> >         case FSCTL_QUERY_ALLOCATED_RANGES:
> > +               if (in_buf_len < sizeof(struct file_allocated_range_buf=
fer)) {
> > +                       ret =3D -EINVAL;
> > +                       goto out;
> > +               }
> > +
> >                 ret =3D fsctl_query_allocated_ranges(work, id,
> >                         (struct file_allocated_range_buffer *)&req->Buf=
fer[0],
> >                         (struct file_allocated_range_buffer *)&rsp->Buf=
fer[0],
> > @@ -7589,6 +7633,11 @@ int smb2_ioctl(struct ksmbd_work *work)
> >                 struct duplicate_extents_to_file *dup_ext;
> >                 loff_t src_off, dst_off, length, cloned;
> >
> > +               if (in_buf_len < sizeof(struct duplicate_extents_to_fil=
e)) {
> > +                       ret =3D -EINVAL;
> > +                       goto out;
> > +               }
> > +
> >                 dup_ext =3D (struct duplicate_extents_to_file *)&req->B=
uffer[0];
> >
> >                 fp_in =3D ksmbd_lookup_fd_slow(work, dup_ext->VolatileF=
ileHandle,
> > --
> > 2.25.1
> >
