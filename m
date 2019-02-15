Return-Path: <SRS0=lRaz=QW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3323AC43381
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Feb 2019 20:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE32C21B18
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Feb 2019 20:06:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qsoNwJlN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389186AbfBOUG5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Feb 2019 15:06:57 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42192 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbfBOUG5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 15 Feb 2019 15:06:57 -0500
Received: by mail-lj1-f195.google.com with SMTP id l7-v6so9386297ljg.9
        for <linux-cifs@vger.kernel.org>; Fri, 15 Feb 2019 12:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qM5Pv+A871AXMYT5zwobkOLx7kyrv/0K8LPrKyXSulU=;
        b=qsoNwJlNI1J/u+QIcfbiLvfo5lh7i/pbWfAlNZ5fVz9Eja/vU5dB5Je5HaFlTEjFCh
         T7HcRSxWTB80OnfKUSUZEYy/CZsnTVEIwK4LwdcdYuIBE9NM7O4H/3jnKLUjECfFETO1
         qCG8ozcEuYwbT+tIu9UHcl+TmFQS/Om02BHGH0CdwdpDi0oI4dwp1/ajvWCCE8pMMe61
         QMWKMx7Ui4Qm86b06jswhTJ8JsGrJh0Qcs24eI3JYjD/g0il7ota/IzPuASISXP4W8Xy
         jnC5hyfB9rlh5xw4chrghx1UuHuW5gJER0xHOcneewnSOGiCl6m1/N7EbYtYgSQAmJPV
         w1wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qM5Pv+A871AXMYT5zwobkOLx7kyrv/0K8LPrKyXSulU=;
        b=GWNS4AY3Pj9p2klF8bMf6yeJmGBnyRd2+PyADGfDNPKTvl8cHG7LjpAD6c3b4ZMHTp
         iYS+TZZVps5WgAv/duspxm9USSMKtFw04SWH9YIanCT7g/uikNm1gMfGHI+c3ArvI55B
         v0Z4IKH0+2GWEJ1kyePeGwirbAuUw5D8n1rN2QYqmO1Dy/z/XJ3EaMP5QIkrDgsCAgEf
         G1zL3d8TRKCq24IxKXyMusnftnTaoDZEbwtpcL2dYlhN2wNUcxieExoMB7E000SZ7Rdz
         JUXefrC9cdVwJg8Lwaffvlyk/6aq9OjbLwfR0SpreEro1/XF4YFh4EUY0cRd29hd2Mbu
         4leA==
X-Gm-Message-State: AHQUAuY7PAmMPQb1qA1WH4pQma+YEDo9uKP949MBnD7r5tptHyneBCoE
        OlHNbRmavhEs7niiVkeXAnm2VkYP1cx8n2McwQ==
X-Google-Smtp-Source: AHgI3IZoUjod1S3bROw2vRj8c7S+Kh2zO/yR7Fc5rrvOsMX+3YrUlceRqhubszjGk52bVhcfegxQVJlW+w7Zv5IMRcY=
X-Received: by 2002:a2e:3807:: with SMTP id f7mr5017731lja.9.1550261214937;
 Fri, 15 Feb 2019 12:06:54 -0800 (PST)
MIME-Version: 1.0
References: <20190215022248.13277-1-kdsouza@redhat.com>
In-Reply-To: <20190215022248.13277-1-kdsouza@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 15 Feb 2019 12:06:43 -0800
Message-ID: <CAKywueRHazDtwUE5YvCCi5bczqz4mPT7zzUtS4oXOXJYKvG+Lw@mail.gmail.com>
Subject: Re: [PATCH v4] Update mount.cifs with vers=default mount option and SMBv3.0.2
To:     "Kenneth D'souza" <kdsouza@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 14 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 18:22, Kenne=
th D'souza <kdsouza@redhat.com>:
>
> Add vers=3D3.0.2 as a valid option for SMBv3.0.2 and explain behavior
> of vers=3Ddefault.
>
> Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
> ---
>  mount.cifs.rst | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/mount.cifs.rst b/mount.cifs.rst
> index a0faf7f..2ad7f59 100644
> --- a/mount.cifs.rst
> +++ b/mount.cifs.rst
> @@ -591,9 +591,13 @@ vers=3Darg
>      different dialect (2.000) that is not supported.
>    - 2.1 - The SMBv2.1 protocol that was introduced in Microsoft Windows =
7 and Windows Server 2008R2.
>    - 3.0 - The SMBv3.0 protocol that was introduced in Microsoft Windows =
8 and Windows Server 2012.
> -  - 3.02 - The SMBv3.0.2 protocol that was introduced in Microsoft Windo=
ws 8.1 and Windows Server 2012R2.
> +  - 3.02 or 3.0.2 - The SMBv3.0.2 protocol that was introduced in Micros=
oft Windows 8.1 and Windows Server 2012R2.
>    - 3.1.1 or 3.11 - The SMBv3.1.1 protocol that was introduced in Micros=
oft Windows Server 2016.
>    - 3 - The SMBv3.0 protocol version and above.
> +  - default - Tries to negotiate the highest SMB2+ version supported by =
both the client and server.
> +
> +  If no dialect is specified on mount vers=3Ddefault is used.
> +  To check ``Dialect`` refer to /proc/fs/cifs/DebugData
>
>    Note too that while this option governs the protocol version used, not
>    all features of each version are available.
> --
> 2.17.2
>

Merged, thanks.

--
Best regards,
Pavel Shilovsky
