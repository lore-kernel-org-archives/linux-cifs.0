Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EEE0C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 21:33:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F07A260F13
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 21:33:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238125AbhIVVew (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 17:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238086AbhIVVev (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 22 Sep 2021 17:34:51 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB04EC061574
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 14:33:20 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id u27so15204822edi.9
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 14:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7LGxkujETQiI1pNbMhuk/VqWE2js81Y+CkeVIBvtm2M=;
        b=LIwoOjzwegOzGzsfOc8Xm/fkJiCczI+kM1VDd7tVLoEstocfZ+7WuuWK72vvyYCmJ5
         h6npu9pMXKN/6c2J+gmJ2aGDh0zWrIXLE/3zr/cTZiyeQPVNArAro/aLUjK/2QZ+HO+E
         DJ1SblrP9Ni+7SP3HgEVLv0CQUTHm4oPb8BD5GqjuDv7UorpDf1onJMeANazV1OSFPx6
         /lqBkdPYNwZJRc7FTHjkxvhj3qmPSrIW4aoLU7fKnmaDfKKGq9e+TkBt3hwDWbn+L9xC
         JW+zNwuh/9XS97c6paUt2M1UrJgfcoX3WMeBQsGo28R65FXSrx9dkgevL1waQdk05mco
         t9sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7LGxkujETQiI1pNbMhuk/VqWE2js81Y+CkeVIBvtm2M=;
        b=Savp9wQTg6qMMqzkw8MvqKRwFr5slg4uyIkVqw/QRUE6BqOcYxwiKw5XyDSgLcNLQe
         SFfEnzN7D8gSDUAxWUQfjKfjOeKz/So/sBuiLLU6khWQUjVT1UyGdQ5JvwmOaLxfOZQy
         xIGx4GsFnN8Oc9NGW29PMy6MQOUOwkY0zJz+kvfwh92MG4lSmrQzC2PWpUrrd/8T0kuT
         VsYYua9C0tF8S4bLka0+sJUEtxeZwjZMox5mXVRJ/f1R8mz4xDfAnYm03gHRpz7cIgpr
         9LoCqcHQJilWlGhBOUJxp+TGXlVqShYtdHMjrVRYB+YK/yV/cgBST/MAGPQbtOo0e3tq
         MLYg==
X-Gm-Message-State: AOAM530iRJuUKxorLJVfNNnlrMoDF758TMn7QKGM5VIA6Mmya6UjUDS3
        Hw9N673PNX0J2jF+73OkcaG/Tllnm2AM7S320pI=
X-Google-Smtp-Source: ABdhPJxGtMXNErKDlEXY5Tywvfkf10xq52k389Uato91Pbc8KHZgUWJVKGORZ4Q2KS3pD0v+lvwCL3rX5GRhR3tZsCs=
X-Received: by 2002:a50:becb:: with SMTP id e11mr1720269edk.161.1632346399288;
 Wed, 22 Sep 2021 14:33:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210922120057.45789-1-linkinjeon@kernel.org>
In-Reply-To: <20210922120057.45789-1-linkinjeon@kernel.org>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 23 Sep 2021 07:33:07 +1000
Message-ID: <CAN05THQVgu33LmFx5u3xm7MjdJZMYe81-bJEvAVJLPrMkjYYZg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: check protocol id in ksmbd_verify_smb_message()
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

reviewed by me

On Wed, Sep 22, 2021 at 10:01 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> When second smb2 pdu has invalid protocol id, ksmbd doesn't detect it
> and allow to process smb2 request. This patch add the check it in
> ksmbd_verify_smb_message() and don't use protocol id of smb2 request as
> protocol id of response.
>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph B=C3=B6hme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Reported-by: Ronnie Sahlberg <lsahlber@redhat.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/ksmbd/smb2pdu.c    |  2 +-
>  fs/ksmbd/smb_common.c | 13 +++++++++----
>  fs/ksmbd/smb_common.h |  1 +
>  3 files changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 3d250e2539e6..3be1493cb18d 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -433,7 +433,7 @@ static void init_chained_smb2_rsp(struct ksmbd_work *=
work)
>                 work->compound_pfid =3D KSMBD_NO_FID;
>         }
>         memset((char *)rsp_hdr + 4, 0, sizeof(struct smb2_hdr) + 2);
> -       rsp_hdr->ProtocolId =3D rcv_hdr->ProtocolId;
> +       rsp_hdr->ProtocolId =3D SMB2_PROTO_NUMBER;
>         rsp_hdr->StructureSize =3D SMB2_HEADER_STRUCTURE_SIZE;
>         rsp_hdr->Command =3D rcv_hdr->Command;
>
> diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
> index da17b21ac685..ace8a1b02c81 100644
> --- a/fs/ksmbd/smb_common.c
> +++ b/fs/ksmbd/smb_common.c
> @@ -129,16 +129,22 @@ int ksmbd_lookup_protocol_idx(char *str)
>   *
>   * check for valid smb signature and packet direction(request/response)
>   *
> - * Return:      0 on success, otherwise 1
> + * Return:      0 on success, otherwise -EINVAL
>   */
>  int ksmbd_verify_smb_message(struct ksmbd_work *work)
>  {
> -       struct smb2_hdr *smb2_hdr =3D work->request_buf;
> +       struct smb2_hdr *smb2_hdr =3D work->request_buf + work->next_smb2=
_rcv_hdr_off;
> +       struct smb_hdr *hdr;
>
>         if (smb2_hdr->ProtocolId =3D=3D SMB2_PROTO_NUMBER)
>                 return ksmbd_smb2_check_message(work);
>
> -       return 0;
> +       hdr =3D work->request_buf;
> +       if (*(__le32 *)hdr->Protocol =3D=3D SMB1_PROTO_NUMBER &&
> +           hdr->Command =3D=3D SMB_COM_NEGOTIATE)
> +               return 0;
> +
> +       return -EINVAL;
>  }
>
>  /**
> @@ -270,7 +276,6 @@ static int ksmbd_negotiate_smb_dialect(void *buf)
>         return BAD_PROT_ID;
>  }
>
> -#define SMB_COM_NEGOTIATE      0x72
>  int ksmbd_init_smb_server(struct ksmbd_work *work)
>  {
>         struct ksmbd_conn *conn =3D work->conn;
> diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
> index d7df19c97c4c..994abede27e9 100644
> --- a/fs/ksmbd/smb_common.h
> +++ b/fs/ksmbd/smb_common.h
> @@ -202,6 +202,7 @@
>                 FILE_READ_ATTRIBUTES | FILE_WRITE_ATTRIBUTES)
>
>  #define SMB1_PROTO_NUMBER              cpu_to_le32(0x424d53ff)
> +#define SMB_COM_NEGOTIATE              0x72
>
>  #define SMB1_CLIENT_GUID_SIZE          (16)
>  struct smb_hdr {
> --
> 2.25.1
>
