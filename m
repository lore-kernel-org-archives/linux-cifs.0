Return-Path: <SRS0=edh0=32=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F7D5C35247
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Feb 2020 18:20:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B9D6214AF
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Feb 2020 18:20:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C5NVrTAX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgBFSUh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 Feb 2020 13:20:37 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40601 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727747AbgBFSUg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 Feb 2020 13:20:36 -0500
Received: by mail-lj1-f193.google.com with SMTP id n18so7147097ljo.7
        for <linux-cifs@vger.kernel.org>; Thu, 06 Feb 2020 10:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rvf/YAjW9+llqL24KCvy6wUQbPJ65GkKEaJqqc6MVbE=;
        b=C5NVrTAXicRFyhRUcr08RFwKy3m2ijKddAgcoCPK47Z528tfCxMR/hmt3e6uTzNILL
         spa6HAb6nZ51HH1Dfq+Ic3YkhZ6L9xZxyxv6ry/EV7SC0g2yczAaM9Qvn5k0nIqQ+Ir6
         XkXhjMVwlw9NiDwqrUjfcUAYRBGDRwVpnDN35eBsXKR+ohXTtnCgHAFga3CSc63naQyP
         cCwxULqijqxeYoiDq8W5e5+gkrxY4B/hbS51UsXMVTL8FHuZDqTuFXPIdwev9x4vPvI8
         9eeo0nwIIEsHLl/gtJ2IgnZPtKE/NQbsNSvHfQtbB5vx3Q26ZaTXpLpkFuIjJFfZdtIt
         iGeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rvf/YAjW9+llqL24KCvy6wUQbPJ65GkKEaJqqc6MVbE=;
        b=n06p8SZ6XAUd96mok7k3LHxc7G9OBXYsHA3ZhG64b+l9fIZlV0q6UBCPNx8zppozAe
         sohLkCaqdQ4zPqLud0ZYQnQaTGJQWRns8pyQrqjfT8yODoNThd05ig6BZ4K7VDrPYdX2
         igs2hxsAFCZdfaBXdLxUPUpxU6MCyOkiCNWZDljsETMDXRBgXAYTlHmtATaGTweG36Xh
         JH8FmTEI2AQzRpukh9RlTH1F8SDkOZnt7db+3i9ILzhjcxMC/WunbB/RDxjmxcl+wIWQ
         0CyRdIddn6Sl/4jq0pecgsbcPgZSzY+JoAqnq47UtYzKAIj97a/hoNAlSCoEizcx1ImW
         GkPw==
X-Gm-Message-State: APjAAAX8DyiSu+/cY2rOr1amltIwHFlhuDwv511WZHMke3rRpdXJ+40g
        2DICRv83aFW31RXBZBBU6ts0RaAMPXm2tT7P5Q==
X-Google-Smtp-Source: APXvYqzfGUd04QIRyLAHkQdzo/8ibjeoYdIMfxESgzbDAbaFkN6q4L+gjwewsEth/jC8By++v0JBq9ve7weBcZMD3lk=
X-Received: by 2002:a2e:8755:: with SMTP id q21mr2910174ljj.156.1581013235090;
 Thu, 06 Feb 2020 10:20:35 -0800 (PST)
MIME-Version: 1.0
References: <20200206124926.25376-1-aaptel@suse.com>
In-Reply-To: <20200206124926.25376-1-aaptel@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 6 Feb 2020 10:20:23 -0800
Message-ID: <CAKywueQP9sUQx6OtEAETkH=X2ewthf3CZ6qyLiL+pV-MLxwMbA@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix channel signing
To:     Aurelien Aptel <aaptel@suse.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 6 =D1=84=D0=B5=D0=B2=D1=80. 2020 =D0=B3. =D0=B2 05:00, Aureli=
en Aptel <aaptel@suse.com>:
>
> The server var was accidentally used as an iterator over the global
> list of connections, thus overwritten the passed argument. This
> resulted in the wrong signing key being returned for extra channels.
>
> Fix this by using a separate var to iterate.
>
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> ---
>  fs/cifs/smb2transport.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> index fe6acfce3390..08b703b7a15e 100644
> --- a/fs/cifs/smb2transport.c
> +++ b/fs/cifs/smb2transport.c
> @@ -104,13 +104,14 @@ int smb2_get_sign_key(__u64 ses_id, struct TCP_Serv=
er_Info *server, u8 *key)
>  {
>         struct cifs_chan *chan;
>         struct cifs_ses *ses =3D NULL;
> +       struct TCP_Server_Info *it =3D NULL;
>         int i;
>         int rc =3D 0;
>
>         spin_lock(&cifs_tcp_ses_lock);
>
> -       list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
> -               list_for_each_entry(ses, &server->smb_ses_list, smb_ses_l=
ist) {
> +       list_for_each_entry(it, &cifs_tcp_ses_list, tcp_ses_list) {
> +               list_for_each_entry(ses, &it->smb_ses_list, smb_ses_list)=
 {
>                         if (ses->Suid =3D=3D ses_id)
>                                 goto found;
>                 }

Good catch!

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

Stable candidate?

--
Best regards,
Pavel Shilovsky
