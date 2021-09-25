Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4AA2C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 09:41:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2F5761279
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 09:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239410AbhIYJn0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 25 Sep 2021 05:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237469AbhIYJnZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 25 Sep 2021 05:43:25 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD76C061570
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 02:41:51 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id o124so12657640vsc.6
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 02:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wz95OJVJwN+SVhLQaz7k3fGr6Ely/9klCeXZ94cMHFs=;
        b=M3pDUvr9JRCUN72JPV0BxhtbQNolfftV+9SS+hOowmcp0Dt16m6TcBSd7npMLXiV+x
         ghpkBRCniyvTFclWJYTnT1lM7wTWp5ML6UtHeuXdCJt5+slG/AZDA4IsF8y8n3siYDZ3
         9JyNNFOcQImnVNRPhNyWAR1e1XwWtvVwVIXq4VIXxf30jKIytO6IXSqZbXIDb4JZ11Mv
         oFbw6SLWLv+UjEYxP3H8qDoqLPz6qPfqMIPOefRvVMz+eRU28Hss9GBjJbXtvRtGs6at
         nF7peX2F6kd8ixWr790eVbIdfW9gZohAXz9VKnR5KbhSTcxn96iUViqwT+HnVRSymfK6
         LNEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wz95OJVJwN+SVhLQaz7k3fGr6Ely/9klCeXZ94cMHFs=;
        b=jA5dxp+IBTNOzwFFMOe0VVRPQuYkazXTHp562l496wNjwJ5TwHVrRmcLGS3/E/MbJP
         P4CH98ioqIZU6OUVu1+WP8t5+EqbHX7T8j3dwXhFp+IsyCfM4nKRuvw2nGSau8ZFNLac
         2WCyf0WauT6/hPRH2cmi31Wmxwl6x3+qmpMtHeWt3vs0VN5/3BR+ShNmm8wh2N09cBVC
         YSELBeHPvCvZP1MmcIhYqjjvI2qCc7orMNuRVbHlzkDIXucE9CsH57h6ZwG/4XWChXik
         V5CQFhXrGXdMg2dy6YLCs70Ngvw6Q/6b6S1IeHtUWniYZjtme0e5Kv1Y8KU2A48FHVE/
         PXhQ==
X-Gm-Message-State: AOAM5318POwVvULaUYM/K3qSgeThSuWQvLfSLYy483wfdiQmD4Zw1Zbv
        JKptP+qQ0vS1fkqaVBCjxYQtLcws2OrEK9aM5PY=
X-Google-Smtp-Source: ABdhPJyXFIcruGCFR46vMtpxAh99x9/B+6LyvyihRuuovAk23Jtq7twmFL2Mj8rS8rQRjoSehGrInbqdJuExW402tR8=
X-Received: by 2002:a67:c088:: with SMTP id x8mr12927792vsi.45.1632562910295;
 Sat, 25 Sep 2021 02:41:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210924021254.27096-1-linkinjeon@kernel.org> <20210924021254.27096-7-linkinjeon@kernel.org>
In-Reply-To: <20210924021254.27096-7-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Sat, 25 Sep 2021 18:41:39 +0900
Message-ID: <CANFS6bbS4N2A_TegWnf+-tEQOMkJk8i2tG89PQdGC3bb3wWhbQ@mail.gmail.com>
Subject: Re: [PATCH 6/7] ksmbd: fix invalid request buffer access in compound
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

Looks good to me.
Acked-by: Hyunchul Lee <hyc.lee@gmail.com>

2021=EB=85=84 9=EC=9B=94 24=EC=9D=BC (=EA=B8=88) =EC=98=A4=EC=A0=84 11:13, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:

>
> Ronnie reported invalid request buffer access in chained command when
> inserting garbage value to NextCommand of compound request.
> This patch add validation check to avoid this issue.
>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph B=C3=B6hme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/ksmbd/smb2pdu.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index a930838fd6ac..4f7b5e18a7b9 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -459,13 +459,22 @@ static void init_chained_smb2_rsp(struct ksmbd_work=
 *work)
>  bool is_chained_smb2_message(struct ksmbd_work *work)
>  {
>         struct smb2_hdr *hdr =3D work->request_buf;
> -       unsigned int len;
> +       unsigned int len, next_cmd;
>
>         if (hdr->ProtocolId !=3D SMB2_PROTO_NUMBER)
>                 return false;
>
>         hdr =3D ksmbd_req_buf_next(work);
> -       if (le32_to_cpu(hdr->NextCommand) > 0) {
> +       next_cmd =3D le32_to_cpu(hdr->NextCommand);
> +       if (next_cmd > 0) {
> +               if ((u64)work->next_smb2_rcv_hdr_off + next_cmd +
> +                       __SMB2_HEADER_STRUCTURE_SIZE >
> +                   get_rfc1002_len(work->request_buf)) {
> +                       pr_err("next command(%u) offset exceeds smb msg s=
ize\n",
> +                              next_cmd);
> +                       return false;
> +               }
> +
>                 ksmbd_debug(SMB, "got SMB2 chained command\n");
>                 init_chained_smb2_rsp(work);
>                 return true;
> --
> 2.25.1
>


--
Thanks,
Hyunchul
