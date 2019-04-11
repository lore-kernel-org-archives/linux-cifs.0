Return-Path: <SRS0=pabO=SN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E9B3C10F13
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Apr 2019 17:49:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D44A2077C
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Apr 2019 17:49:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LgDudOnt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfDKRtT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Apr 2019 13:49:19 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40706 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbfDKRtT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Apr 2019 13:49:19 -0400
Received: by mail-lf1-f66.google.com with SMTP id a28so5379374lfo.7;
        Thu, 11 Apr 2019 10:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fVie9LZCJMpV2qm2o+ePpQuBYYn/j4gk8/yJQovPvTA=;
        b=LgDudOntYEawLVRB0vo9tQEX4PwRlrKTlrDckgM/q/ov16BZsxWqsPqob7NSjtaJfu
         2z6KbrCy4eKxA24dH6bcF7pNI6t8Dc1K/OeacSOhNahzwD9tpCYM7ZvjxR2Z3yug2Hz8
         4AHf9roZBs5xAoa2UmlGQF9s1cRWU25ft2/7LabASV2HbTY1cIp6n/HzvzB1VP8pMkWv
         FJxPoaKwBIFWzTw7EaR/1cVav9iGbu/Oow+FFWBdmOLbjHSlz07zHGvSSiLSmRPgKgej
         ED8Xyrv1XNlVxn4OYVNerAXd1ZhzozSHkxo8+XYoWMq9r3thg2a/bdSH1GSiDD96HqDY
         5HwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fVie9LZCJMpV2qm2o+ePpQuBYYn/j4gk8/yJQovPvTA=;
        b=FqoZ3Afv66iujXlmKL1E/4SGYfEirftnb1wtFKwhoBgYe+LK8wMpYxSru2vZeevEzD
         CCzxo3OfT2O0+M/Pwre/Hlriz9uegfXTvoj4VryYYVpUGp1mQCTXCUWXRq4QGTFm1DuT
         Wta0hFfHEGpbqgbS4u2PU/49Q6iYti4wpKkx7z1M0c9b4CkMydqB75DsebpMdbuIzvrK
         4qP+6H5JiNVjKMULFOZ0Y2/Y2iuUNvLreWN8PDXEkhRF5MI3hMfGACnPHiUyXERZVytK
         0VJGwhUInOwEa8yvp9WyWpe9im8egxFQgPhYERkuDS2A1/Ty4bDoywU6fFi4GtSFXCV9
         wxfA==
X-Gm-Message-State: APjAAAWPCM4DHkS1cIxvV2x48Vx0BCY3NqOM0utbkMChcTehcLlRjKty
        6HjY7yULmZ2Ts348ntKlM2UreRfGwz0PNf473FjBK1s=
X-Google-Smtp-Source: APXvYqwO55TMEmHZ9raH7d5ODDl6uX78DZ0hznD9SSvojhPqpJquBuBlIKokuMIGEMg12WLIGTPnOaPlypa3ZOujc2g=
X-Received: by 2002:ac2:530a:: with SMTP id c10mr25392350lfh.45.1555004957342;
 Thu, 11 Apr 2019 10:49:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190411022017.24942-1-lsahlber@redhat.com> <20190411022017.24942-2-lsahlber@redhat.com>
In-Reply-To: <20190411022017.24942-2-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 11 Apr 2019 10:49:06 -0700
Message-ID: <CAKywueQOJd__BpyF_eki0_KbLvZFYRhtKRkaDo_oWwU6080OYg@mail.gmail.com>
Subject: Re: [PATCH] cifs: Add support for FSCTL passthrough that write data
 to the server
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D1=80, 10 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 19:21, Ronnie Sahl=
berg <lsahlber@redhat.com>:
>
> Add support to pass a blob to the server in FSCTL passthrough.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2ops.c  | 17 +++++++++++++++--
>  fs/cifs/smbfsctl.h | 27 +++++++++++++++++++++++++++
>  2 files changed, 42 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 83a100dd2497..bb7522b882ea 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1382,6 +1382,18 @@ smb2_ioctl_query_info(const unsigned int xid,
>         oparms.fid =3D &fid;
>         oparms.reconnect =3D false;
>
> +       /*
> +        * FSCTL codes encode the special access they need in the fsctl c=
ode.
> +        */
> +       if (qi.flags & PASSTHRU_FSCTL) {
> +               switch (qi.info_type & FSCTL_DEVICE_ACCESS_MASK) {
> +               case FSCTL_DEVICE_ACCESS_FILE_READ_WRITE_ACCESS:
> +                       oparms.desired_access =3D FILE_READ_DATA | FILE_W=
RITE_DATA | FILE_READ_ATTRIBUTES | SYNCHRONIZE;
> +                       ;

This extra ":" looks unnecessary. Don't we need to add cases for
+#define FSCTL_DEVICE_ACCESS_FILE_ANY_ACCESS        (0x00 << 14)
+#define FSCTL_DEVICE_ACCESS_FILE_READ_ACCESS       (0x01 << 14)
+#define FSCTL_DEVICE_ACCESS_FILE_WRITE_ACCESS      (0x02 << 14)
?

--
Best regards,
Pavel Shilovsky
