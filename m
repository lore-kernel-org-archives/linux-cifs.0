Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4034C25B48
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Oct 2023 15:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345493AbjJZPw4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 Oct 2023 11:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345486AbjJZPwy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 Oct 2023 11:52:54 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF531A2
        for <linux-cifs@vger.kernel.org>; Thu, 26 Oct 2023 08:52:52 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-9ba081173a3so176101366b.1
        for <linux-cifs@vger.kernel.org>; Thu, 26 Oct 2023 08:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698335571; x=1698940371; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DHpktmZl62r3zQoGO3XuM4EIwniUQUg1awqk4+ytNUQ=;
        b=TsSbifg0sz6SCi7EVwVDpzckecSui+ami2E/3Pb4ZDKGGcOiJ4s/0GoovjUZrNjX98
         5MGsb973Z8c8xtUVKtfgMifiGvRcmUiNE4ksne/FC1d719Yz6Jcwl9g7jatMKqezHc+H
         pvliEVr3orsex4m8g7+ebDGDS725GMGH1agJoe8LHdAdy9niptYteSoWVwW+1DjaW0XB
         8OXpbb8Xfi8S6H+1Fly31BA7iVcnwi3+DGbUqX3uC39lerIodCfAyzOwbo/I0P1r6l4m
         8cTwk7I1HpzPAJV4tMcrqqF5LiiuhlY65A49aJXx/bkssXJ8DVp2IFWnwqT+jnKft0WM
         go3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698335571; x=1698940371;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DHpktmZl62r3zQoGO3XuM4EIwniUQUg1awqk4+ytNUQ=;
        b=iuMFtdWhW8EdkCYGf5MeXKey5Bt17tqyUpgbNRKOkGuG/suqFcDtRBEAteAbuBnrYg
         A7zzI1tbsKgIiKt2P3XUhq69BavKXFmRXP8no4ko1pTbHAYTwek7LAxrTGm6KU8qYtrQ
         fuiy4EiR3FVh+yGfC9LN6UFQOXs0ZsxXC2EdDK3RjKSP+3LNz+GakeYAxcCEpIBCZ7Fi
         Bz0/EwMW1TFW132h7Y/tJ1U0mEXZrzDCtHJtHATdblZwcfQNvuEFeh/E/wsmcaF7NpIc
         ZsXhnphXHv/aeMfQ1cHGXB7O6yMl1m9CX/tNyCG1BR9oRcTDuYEdgYkoL3+VBQKw9Ap6
         eQgg==
X-Gm-Message-State: AOJu0Yyz09/aBQEgeRTA3W9zu8RxunwMDst+Y/LV74z7KmVYWxuNpVUE
        153L55HKkuPDgSEsoYsks/exKP8ntHyeTCqEgt6d8AyIM88=
X-Google-Smtp-Source: AGHT+IEyeIq+Tz2J6p/0UlwaQd43gXChplWFDyZtKRSQPrL+OCt4UPNMGXfCqzseSxMrBWvaD108Nbx6AGP/7RjnfV8=
X-Received: by 2002:a17:907:3689:b0:9b2:babd:cd44 with SMTP id
 bi9-20020a170907368900b009b2babdcd44mr76598ejc.44.1698335570460; Thu, 26 Oct
 2023 08:52:50 -0700 (PDT)
MIME-Version: 1.0
References: <20231026122107.3755159-1-mmakassikis@freebox.fr>
In-Reply-To: <20231026122107.3755159-1-mmakassikis@freebox.fr>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 26 Oct 2023 10:52:38 -0500
Message-ID: <CAH2r5mv7EdECgEQZrhiNyWQkYbcUknkkxdo9nmimaahnb2FcLA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: add processed command debug log
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     linux-cifs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

It may be helpful to define dynamic trace points (e.g.
DECLARE_EVENT_CLASS ...) for ksmbd, so can more easily do eBPF
tracing.  XFS and the cifs.ko client have multiple examples, but
fs/nfsd may have some almost exact matches on what could be defined
for fs/smb/server/trace.h and trace.c for ksmbd.ko

On Thu, Oct 26, 2023 at 7:21=E2=80=AFAM Marios Makassikis
<mmakassikis@freebox.fr> wrote:
>
> Additional log to help identify what command is going to be
> processed next.
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> ---
>  fs/smb/server/smb2pdu.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
>
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 93262ca3f58a..d2b51177f0ca 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -39,6 +39,36 @@
>  #include "mgmt/ksmbd_ida.h"
>  #include "ndr.h"
>
> +static const char *const smb2_cmd_str[] =3D {
> +       [SMB2_NEGOTIATE_HE] =3D "SMB2_NEGOTIATE",
> +       [SMB2_SESSION_SETUP_HE] =3D "SMB2_SESSION_SETUP",
> +       [SMB2_LOGOFF_HE] =3D "SMB2_LOGOFF",
> +       [SMB2_TREE_CONNECT_HE] =3D "SMB2_TREE_CONNECT",
> +       [SMB2_TREE_DISCONNECT_HE] =3D "SMB2_TREE_DISCONNECT",
> +       [SMB2_CREATE_HE] =3D "SMB2_CREATE",
> +       [SMB2_CLOSE_HE] =3D "SMB2_CLOSE",
> +       [SMB2_FLUSH_HE] =3D "SMB2_FLUSH",
> +       [SMB2_READ_HE] =3D "SMB2_READ",
> +       [SMB2_WRITE_HE] =3D "SMB2_WRITE",
> +       [SMB2_LOCK_HE] =3D "SMB2_LOCK",
> +       [SMB2_IOCTL_HE] =3D "SMB2_IOCTL",
> +       [SMB2_CANCEL_HE] =3D "SMB2_CANCEL",
> +       [SMB2_ECHO_HE] =3D "SMB2_ECHO",
> +       [SMB2_QUERY_DIRECTORY_HE] =3D "SMB2_QUERY_DIRECTORY",
> +       [SMB2_CHANGE_NOTIFY_HE] =3D "SMB2_CHANGE_NOTIFY",
> +       [SMB2_QUERY_INFO_HE] =3D "SMB2_QUERY_INFO",
> +       [SMB2_SET_INFO_HE] =3D "SMB2_SET_INFO",
> +       [SMB2_OPLOCK_BREAK_HE] =3D "SMB2_OPLOCK_BREAK",
> +};
> +
> +static const char *smb2_cmd_to_str(u16 cmd)
> +{
> +       if (cmd < ARRAY_SIZE(smb2_cmd_str))
> +               return smb2_cmd_str[cmd];
> +
> +       return "unknown_cmd";
> +}
> +
>  static void __wbuf(struct ksmbd_work *work, void **req, void **rsp)
>  {
>         if (work->next_smb2_rcv_hdr_off) {
> @@ -568,6 +598,8 @@ int smb2_check_user_session(struct ksmbd_work *work)
>         unsigned int cmd =3D le16_to_cpu(req_hdr->Command);
>         unsigned long long sess_id;
>
> +       ksmbd_debug(SMB, "received command: %s\n",
> +                   smb2_cmd_to_str(req_hdr->Command));
>         /*
>          * SMB2_ECHO, SMB2_NEGOTIATE, SMB2_SESSION_SETUP command do not
>          * require a session id, so no need to validate user session's fo=
r
> --
> 2.34.1
>


--=20
Thanks,

Steve
