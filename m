Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB061C433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  5 May 2022 23:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379004AbiEEXqB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 5 May 2022 19:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242876AbiEEXp6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 5 May 2022 19:45:58 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF9F40A02
        for <linux-cifs@vger.kernel.org>; Thu,  5 May 2022 16:42:16 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id r1so5958296oie.4
        for <linux-cifs@vger.kernel.org>; Thu, 05 May 2022 16:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TNkAiDLy7yvi5kWoVx96VZzuPUA7t015YwxU4+KFc8w=;
        b=BRXge4BMM6B1281/LfDtwsprecUPyum3pT44ZPV43EiQ6cugPtTyLR283aAX4mrAo+
         XZZkJ9pVuxBKUn6gJgB/rnUqMBrdAVT9/6EFxaBO2uddfsJmngXQ7PHOa6ebIyVRA3Ra
         7idg+8Mvrlp3O/XJ1li7ugjBZH4uv+YqpnkaCCLZiOPt9LHmifiFUVfYfnqkTl1cW9c0
         kOpD/Ji6UPFQgalRpcIOD/F0ofEEhPiiRniSMwNDQodC6ZQcBUlQVhbmbZ/GWWyo03xR
         xSKzkl0F72nyoa/oGFqEPNT7nwtCG4ccmDHLOH78pQDeGKDdOV95B/evRy8z62UfZvs3
         xZGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TNkAiDLy7yvi5kWoVx96VZzuPUA7t015YwxU4+KFc8w=;
        b=tIpMkiYZlNHE8ADFvAVlyKq94FcKDRmwqZEAqllU8uTjy0oDyFVWs91gyISNo5uNFs
         gy1q0wbJpIw94j7wS0ar92urrIvvU+bvVnn7hZebtU/tz3NtK6nhmzII7yec6UxBfyTY
         rmT2PQHJWh2Me5lbV/PsPPrgGdKYHqW9cmavV3iTEbvntZFFRpVYhd7eKQauMvl9XtrB
         +D8IWrGtNlbYv9lN6OXH9umSunS5PhlHAo7DJsY/F60+vsk5/xcUpLXSzlWb46J+DLGo
         TaLSOblK17U3Eb4qX6a6aZClKPVrJTbY5LTJjyFAFO1UT5LuRHXsJWfi1gHhcWz/Ow1Q
         EBpQ==
X-Gm-Message-State: AOAM531/JQ6k0w429ieiaFFtpjEOqmCefA47FlW/k1n3Bgv0KpH0WH+g
        UzMWc1GxKWL58unNU+TEavqUbgRgTuBLaepufV4VayiD
X-Google-Smtp-Source: ABdhPJyYoYDfVDioH8DGL8gc9EbhzzMkojrrpDzM3xXnUKWPfB/ejhQzedbSMuVAjToaN55qknqrks6uXxYyJR1Toaw=
X-Received: by 2002:a05:6808:1645:b0:325:5182:a9ca with SMTP id
 az5-20020a056808164500b003255182a9camr326242oib.104.1651794136108; Thu, 05
 May 2022 16:42:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220504224640.2865787-1-mmakassikis@freebox.fr>
In-Reply-To: <20220504224640.2865787-1-mmakassikis@freebox.fr>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Fri, 6 May 2022 08:42:04 +0900
Message-ID: <CANFS6baVjD13+DyWOve2ng=dKdySBWkZxDtywGECnQ5yNYQFdQ@mail.gmail.com>
Subject: Re: [PATCH v3] ksmbd: validate length in smb2_write()
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Marios,

2022=EB=85=84 5=EC=9B=94 5=EC=9D=BC (=EB=AA=A9) =EC=98=A4=ED=9B=84 4:00, Ma=
rios Makassikis <mmakassikis@freebox.fr>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:

>
> The SMB2 Write packet contains data that is to be written
> to a file or to a pipe. Depending on the client, there may
> be padding between the header and the data field.
> Currently, the length is validated only in the case padding
> is present.
>
> Since the DataOffset field always points to the beginning
> of the data, there is no need to have a special case for
> padding. By removing this, the length is validated in both
> cases.
>
> Additionally, fix the length check: DataOffset and Length
> fields are relative to the SMB header start, while the packet
> length returned by get_rfc1002_len() includes 4 additional
> bytes.
>

get_rfc1002_len doesn't include additional 4 bytes.
Can you check it again?

> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> ---
> Change since v2:
>  - the length check was wrong, as it did not account for the rfc1002
>  header in work->request_buf.
>
>  fs/ksmbd/smb2pdu.c | 49 ++++++++++++++++++----------------------------
>  1 file changed, 19 insertions(+), 30 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 16c803a9d996..23b47e505e2b 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -6328,23 +6328,18 @@ static noinline int smb2_write_pipe(struct ksmbd_=
work *work)
>         length =3D le32_to_cpu(req->Length);
>         id =3D req->VolatileFileId;
>
> -       if (le16_to_cpu(req->DataOffset) =3D=3D
> -           offsetof(struct smb2_write_req, Buffer)) {
> -               data_buf =3D (char *)&req->Buffer[0];
> -       } else {
> -               if ((u64)le16_to_cpu(req->DataOffset) + length >
> -                   get_rfc1002_len(work->request_buf)) {
> -                       pr_err("invalid write data offset %u, smb_len %u\=
n",
> -                              le16_to_cpu(req->DataOffset),
> -                              get_rfc1002_len(work->request_buf));
> -                       err =3D -EINVAL;
> -                       goto out;
> -               }
> -
> -               data_buf =3D (char *)(((char *)&req->hdr.ProtocolId) +
> -                               le16_to_cpu(req->DataOffset));
> +       if ((u64)le16_to_cpu(req->DataOffset) + length >
> +           get_rfc1002_len(work->request_buf) - 4) {
> +               pr_err("invalid write data offset %u, smb_len %u\n",
> +                      le16_to_cpu(req->DataOffset),
> +                      get_rfc1002_len(work->request_buf));
> +               err =3D -EINVAL;
> +               goto out;
>         }
>
> +       data_buf =3D (char *)(((char *)&req->hdr.ProtocolId) +
> +                          le16_to_cpu(req->DataOffset));
> +
>         rpc_resp =3D ksmbd_rpc_write(work->sess, id, data_buf, length);
>         if (rpc_resp) {
>                 if (rpc_resp->flags =3D=3D KSMBD_RPC_ENOTIMPLEMENTED) {
> @@ -6489,22 +6484,16 @@ int smb2_write(struct ksmbd_work *work)
>
>         if (req->Channel !=3D SMB2_CHANNEL_RDMA_V1 &&
>             req->Channel !=3D SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
> -               if (le16_to_cpu(req->DataOffset) =3D=3D
> -                   offsetof(struct smb2_write_req, Buffer)) {
> -                       data_buf =3D (char *)&req->Buffer[0];
> -               } else {
> -                       if ((u64)le16_to_cpu(req->DataOffset) + length >
> -                           get_rfc1002_len(work->request_buf)) {
> -                               pr_err("invalid write data offset %u, smb=
_len %u\n",
> -                                      le16_to_cpu(req->DataOffset),
> -                                      get_rfc1002_len(work->request_buf)=
);
> -                               err =3D -EINVAL;
> -                               goto out;
> -                       }
> -
> -                       data_buf =3D (char *)(((char *)&req->hdr.Protocol=
Id) +
> -                                       le16_to_cpu(req->DataOffset));
> +               if ((u64)le16_to_cpu(req->DataOffset) + length >
> +                   get_rfc1002_len(work->request_buf) - 4) {
> +                       pr_err("invalid write data offset %u, smb_len %u\=
n",
> +                              le16_to_cpu(req->DataOffset),
> +                              get_rfc1002_len(work->request_buf));
> +                       err =3D -EINVAL;
> +                       goto out;
>                 }
> +               data_buf =3D (char *)(((char *)&req->hdr.ProtocolId) +
> +                                   le16_to_cpu(req->DataOffset));
>
>                 ksmbd_debug(SMB, "flags %u\n", le32_to_cpu(req->Flags));
>                 if (le32_to_cpu(req->Flags) & SMB2_WRITEFLAG_WRITE_THROUG=
H)
> --
> 2.25.1
>


--
Thanks,
Hyunchul
