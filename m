Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE218C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 17 May 2022 08:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242061AbiEQIHu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 May 2022 04:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241048AbiEQIHt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 May 2022 04:07:49 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429183B549
        for <linux-cifs@vger.kernel.org>; Tue, 17 May 2022 01:07:48 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id h14so3925599wrc.6
        for <linux-cifs@vger.kernel.org>; Tue, 17 May 2022 01:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pRb1BLS9XfnVErcSK0xNgBtGheVw5zSVEZaPI7fluT8=;
        b=D7PFQ4mbUS5rK41I0EJAUV3LeavjTfCTzJdfi2HYoapSu69NH6HZIuQXm9ZehO1AYQ
         QH4g2GZENB9Gm6LbvFHgIt7GNxzwC3uCZZZKt+S63KNAak/9SLW7+7gT+vBVBWf8LIMP
         FP0mu8Yb43P1a0kSC7spQMAqoY6efAVXk/sStkYcMBQRtG/1sgbS+8eBcmUYQHDx4eSv
         b1dku+7fwcSTc4I80J0dJyDTzKuCpjEHliBoliq89jToVSJ1cMOvHB+8mdY7pTR+k8gO
         LtC/9SUYxgvo43AwTu+rrvIR3jbugY3urmgK6gyeiqR0aCoWXWoGu8YDKBKWFmxaqNNb
         J9tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pRb1BLS9XfnVErcSK0xNgBtGheVw5zSVEZaPI7fluT8=;
        b=Y+iaWX5zvZGT0U5aD4TaoIy5Qug0xHA9GKIC3wHV4zfO4r0B9hyJq9uEyV7yRu5j5n
         f63mlyBD+hklaAgDT+sUZLHJQXF5vDWUYOQ6sFe6K6m6TNk1n3ZqygPVck3MN+n2ehDO
         Ko12om8rY7ne2GqJH12gT9YH4pGpY3EkDfMdAYiiZKfs4rNr7DgMNKHObDOu2+2lSkAU
         osSH693JACvwFnkdNEStla3XWPv3jtrlk69RPdbXJxd8MPqhKAUdJn4AkdFHoW8t/1ln
         GMX6xkT652UoJ4vxIkZvtrXXNMTc83S0hk0u3VNiQR9qRBGfbJhKuQF+H3kPT0uerM4A
         uRUA==
X-Gm-Message-State: AOAM533wHlxmRsMJ9ySCjR8dcPUHFmH3QxM8156+eBvw8xldQt8fwNlQ
        8MyQDf//HPzaJ9ssAuauJv5JakVP4LN9Y0ts+sk=
X-Google-Smtp-Source: ABdhPJx9fIoDT3zk5CRCSMwUMp0f6OzAc7s/9F1mJicPiHbOrbanFc/vZtmHC5U7UFP9d4PtF7m8oq/rNHZ28j0JcwM=
X-Received: by 2002:a5d:42d0:0:b0:20d:2dd:22f7 with SMTP id
 t16-20020a5d42d0000000b0020d02dd22f7mr10389670wrr.136.1652774866785; Tue, 17
 May 2022 01:07:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220516074140.28522-1-linkinjeon@kernel.org> <20220516074140.28522-3-linkinjeon@kernel.org>
In-Reply-To: <20220516074140.28522-3-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Tue, 17 May 2022 17:07:35 +0900
Message-ID: <CANFS6bY5puvQoh7hAiOr0=J6hhBNEhQyv7Q-=XD7bBDB3e=3_A@mail.gmail.com>
Subject: Re: [PATCH 3/3] ksmbd: fix wrong smbd max read/write size check
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022=EB=85=84 5=EC=9B=94 16=EC=9D=BC (=EC=9B=94) =EC=98=A4=ED=9B=84 4:42, N=
amjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> smb-direct max read/write size can be different with smb2 max read/write
> size. So smb2_read() can return error by wrong max read/write size check.
> This patch use smb_direct_max_read_write_size for this check in
> smb-direct read/write().
>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>

Looks good to me.
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

> ---
>  fs/ksmbd/smb2pdu.c        | 39 +++++++++++++++++++++++++--------------
>  fs/ksmbd/transport_rdma.c |  5 +++++
>  fs/ksmbd/transport_rdma.h |  2 ++
>  3 files changed, 32 insertions(+), 14 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index eb7ca5f24a3b..937f9760f181 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -6098,6 +6098,8 @@ int smb2_read(struct ksmbd_work *work)
>         size_t length, mincount;
>         ssize_t nbytes =3D 0, remain_bytes =3D 0;
>         int err =3D 0;
> +       bool is_rdma_channel =3D false;
> +       unsigned int max_read_size =3D conn->vals->max_read_size;
>
>         WORK_BUFFERS(work, req, rsp);
>
> @@ -6109,6 +6111,11 @@ int smb2_read(struct ksmbd_work *work)
>
>         if (req->Channel =3D=3D SMB2_CHANNEL_RDMA_V1_INVALIDATE ||
>             req->Channel =3D=3D SMB2_CHANNEL_RDMA_V1) {
> +               is_rdma_channel =3D true;
> +               max_read_size =3D get_smbd_max_read_write_size();
> +       }
> +
> +       if (is_rdma_channel =3D=3D true) {
>                 unsigned int ch_offset =3D le16_to_cpu(req->ReadChannelIn=
foOffset);
>
>                 if (ch_offset < offsetof(struct smb2_read_req, Buffer)) {
> @@ -6140,9 +6147,9 @@ int smb2_read(struct ksmbd_work *work)
>         length =3D le32_to_cpu(req->Length);
>         mincount =3D le32_to_cpu(req->MinimumCount);
>
> -       if (length > conn->vals->max_read_size) {
> +       if (length > max_read_size) {
>                 ksmbd_debug(SMB, "limiting read size to max size(%u)\n",
> -                           conn->vals->max_read_size);
> +                           max_read_size);
>                 err =3D -EINVAL;
>                 goto out;
>         }
> @@ -6174,8 +6181,7 @@ int smb2_read(struct ksmbd_work *work)
>         ksmbd_debug(SMB, "nbytes %zu, offset %lld mincount %zu\n",
>                     nbytes, offset, mincount);
>
> -       if (req->Channel =3D=3D SMB2_CHANNEL_RDMA_V1_INVALIDATE ||
> -           req->Channel =3D=3D SMB2_CHANNEL_RDMA_V1) {
> +       if (is_rdma_channel =3D=3D true) {
>                 /* write data to the client using rdma channel */
>                 remain_bytes =3D smb2_read_rdma_channel(work, req,
>                                                       work->aux_payload_b=
uf,
> @@ -6336,8 +6342,9 @@ int smb2_write(struct ksmbd_work *work)
>         size_t length;
>         ssize_t nbytes;
>         char *data_buf;
> -       bool writethrough =3D false;
> +       bool writethrough =3D false, is_rdma_channel =3D false;
>         int err =3D 0;
> +       unsigned int max_write_size =3D work->conn->vals->max_write_size;
>
>         WORK_BUFFERS(work, req, rsp);
>
> @@ -6346,8 +6353,17 @@ int smb2_write(struct ksmbd_work *work)
>                 return smb2_write_pipe(work);
>         }
>
> +       offset =3D le64_to_cpu(req->Offset);
> +       length =3D le32_to_cpu(req->Length);
> +
>         if (req->Channel =3D=3D SMB2_CHANNEL_RDMA_V1 ||
>             req->Channel =3D=3D SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
> +               is_rdma_channel =3D true;
> +               max_write_size =3D get_smbd_max_read_write_size();
> +               length =3D le32_to_cpu(req->RemainingBytes);
> +       }
> +
> +       if (is_rdma_channel =3D=3D true) {
>                 unsigned int ch_offset =3D le16_to_cpu(req->WriteChannelI=
nfoOffset);
>
>                 if (req->Length !=3D 0 || req->DataOffset !=3D 0 ||
> @@ -6382,12 +6398,9 @@ int smb2_write(struct ksmbd_work *work)
>                 goto out;
>         }
>
> -       offset =3D le64_to_cpu(req->Offset);
> -       length =3D le32_to_cpu(req->Length);
> -
> -       if (length > work->conn->vals->max_write_size) {
> +       if (length > max_write_size) {
>                 ksmbd_debug(SMB, "limiting write size to max size(%u)\n",
> -                           work->conn->vals->max_write_size);
> +                           max_write_size);
>                 err =3D -EINVAL;
>                 goto out;
>         }
> @@ -6395,8 +6408,7 @@ int smb2_write(struct ksmbd_work *work)
>         if (le32_to_cpu(req->Flags) & SMB2_WRITEFLAG_WRITE_THROUGH)
>                 writethrough =3D true;
>
> -       if (req->Channel !=3D SMB2_CHANNEL_RDMA_V1 &&
> -           req->Channel !=3D SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
> +       if (is_rdma_channel =3D=3D false) {
>                 if ((u64)le16_to_cpu(req->DataOffset) + length >
>                     get_rfc1002_len(work->request_buf)) {
>                         pr_err("invalid write data offset %u, smb_len %u\=
n",
> @@ -6422,8 +6434,7 @@ int smb2_write(struct ksmbd_work *work)
>                 /* read data from the client using rdma channel, and
>                  * write the data.
>                  */
> -               nbytes =3D smb2_write_rdma_channel(work, req, fp, offset,
> -                                                le32_to_cpu(req->Remaini=
ngBytes),
> +               nbytes =3D smb2_write_rdma_channel(work, req, fp, offset,=
 length,
>                                                  writethrough);
>                 if (nbytes < 0) {
>                         err =3D (int)nbytes;
> diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
> index 6d652ff38b82..0741fd129d16 100644
> --- a/fs/ksmbd/transport_rdma.c
> +++ b/fs/ksmbd/transport_rdma.c
> @@ -220,6 +220,11 @@ void init_smbd_max_io_size(unsigned int sz)
>         smb_direct_max_read_write_size =3D sz;
>  }
>
> +unsigned int get_smbd_max_read_write_size(void)
> +{
> +       return smb_direct_max_read_write_size;
> +}
> +
>  static inline int get_buf_page_count(void *buf, int size)
>  {
>         return DIV_ROUND_UP((uintptr_t)buf + size, PAGE_SIZE) -
> diff --git a/fs/ksmbd/transport_rdma.h b/fs/ksmbd/transport_rdma.h
> index e7b4e6790fab..77aee4e5c9dc 100644
> --- a/fs/ksmbd/transport_rdma.h
> +++ b/fs/ksmbd/transport_rdma.h
> @@ -57,11 +57,13 @@ int ksmbd_rdma_init(void);
>  void ksmbd_rdma_destroy(void);
>  bool ksmbd_rdma_capable_netdev(struct net_device *netdev);
>  void init_smbd_max_io_size(unsigned int sz);
> +unsigned int get_smbd_max_read_write_size(void);
>  #else
>  static inline int ksmbd_rdma_init(void) { return 0; }
>  static inline int ksmbd_rdma_destroy(void) { return 0; }
>  static inline bool ksmbd_rdma_capable_netdev(struct net_device *netdev) =
{ return false; }
>  static inline void init_smbd_max_io_size(unsigned int sz) { }
> +static inline unsigned int get_smbd_max_read_write_size(void) { return 0=
; }
>  #endif
>
>  #endif /* __KSMBD_TRANSPORT_RDMA_H__ */
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
