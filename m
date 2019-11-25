Return-Path: <SRS0=nVbX=ZR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2441FC432C0
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Nov 2019 21:29:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8FE420727
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Nov 2019 21:29:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rcx6mQqh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbfKYV3j (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Nov 2019 16:29:39 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45553 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfKYV3j (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Nov 2019 16:29:39 -0500
Received: by mail-lj1-f196.google.com with SMTP id n21so17614030ljg.12
        for <linux-cifs@vger.kernel.org>; Mon, 25 Nov 2019 13:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dhEY/pvMPxJy+3J2FmTu5BSVb7qbAPPohFnNPAmqpzM=;
        b=Rcx6mQqhyee4TewnE11pNOcxe1EHiTHHkUvrFfl+gpINYTUj0u/lJL4P/EbeDxPfZR
         N7/5Ijx3FI7INYrhtp45vPhV23X6mz3SI23PFSYebMNIoejR7dxR4VBuyadeQnwVnXoD
         nBtM7Fx87nVmsOMqIxcN/Ho+sI2Ilc1s8IeGyRnalKyQHoQDKtWfaZzDnDtecnk6hKDX
         jMkWnEjZVVZMo+sAt10+HrvVrHuGlEqyJzKJG/R83P2zN1uKDCCNS1RXV0+i4l5R5ZoO
         EwHL3Wj839CxRFIqAbEkHhvoDeG+ORibzcxdfl0yWDr+UFHOM1AVbErQH5dqIQWtp0dG
         vMFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dhEY/pvMPxJy+3J2FmTu5BSVb7qbAPPohFnNPAmqpzM=;
        b=mHp6K7eMOWCIJzbmks5GvL0z+8lOSlP/zJA03Y8HOu/uYgGBsm0O3bhxyduVX47HSc
         yiuDQnB0tJCa07m7eU+ahGIkk5zgtvQEjHwptDCK0MSz+cpmVqbnVr6ghvmJ4/vQ11AR
         PnCPNVTe7IpXxN5i37hqBjac/C8mRZQgf0iePIOmx91S4L+m86Cjdl4oi4AlNqM5zYj3
         a0IkPvIsnHmRs1UlJvRwh/mGPctZc30no6cWjHrCCJ0mg9i0BnnBHlieNWlkeEnGpNVu
         4je2PGyry3QmasD7cFcxSyufxGNrQj1amq0tjbZPs4KwcRXf5/T8vq+7R9iXBfdueQP2
         t4QA==
X-Gm-Message-State: APjAAAU8mEyPZrH4piWquOFcnzGD+szKy/kakH1U0DoCleKPGXfU2gzb
        yFrXY9u+y9V/SLDsMgDYJTm3z7f3qcgv2iTAZA==
X-Google-Smtp-Source: APXvYqzePo44oY1IsHj3lslzpDCEkuVTundZv6xD76Cg/Vv/efe4IpNe8YXgKLAboZVDLif+83xqTEZ3h4Qm6o/g6eA=
X-Received: by 2002:a05:651c:111a:: with SMTP id d26mr23803298ljo.168.1574717377152;
 Mon, 25 Nov 2019 13:29:37 -0800 (PST)
MIME-Version: 1.0
References: <20191103012112.12212-1-aaptel@suse.com> <20191103012112.12212-2-aaptel@suse.com>
In-Reply-To: <20191103012112.12212-2-aaptel@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 25 Nov 2019 13:29:26 -0800
Message-ID: <CAKywueS3DpPkpeNprSUwrXw=ErZZsn3vRF6uVE646oCWC_8-4w@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] cifs: sort interface list by speed
To:     Aurelien Aptel <aaptel@suse.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D0=B1, 2 =D0=BD=D0=BE=D1=8F=D0=B1. 2019 =D0=B3. =D0=B2 18:21, Aureli=
en Aptel <aaptel@suse.com>:
>
> New channels are going to be opened by walking the list sequentially,
> so by sorting it we will connect to the fastest interfaces first.
>
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> ---
>  fs/cifs/smb2ops.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index cd55af9b7cc5..ea634581791a 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -10,6 +10,7 @@
>  #include <linux/falloc.h>
>  #include <linux/scatterlist.h>
>  #include <linux/uuid.h>
> +#include <linux/sort.h>
>  #include <crypto/aead.h>
>  #include "cifsglob.h"
>  #include "smb2pdu.h"
> @@ -558,6 +559,13 @@ parse_server_interfaces(struct network_interface_inf=
o_ioctl_rsp *buf,
>         return rc;
>  }
>
> +static int compare_iface(const void *ia, const void *ib)
> +{
> +       const struct cifs_server_iface *a =3D (struct cifs_server_iface *=
)ia;
> +       const struct cifs_server_iface *b =3D (struct cifs_server_iface *=
)ib;
> +
> +       return a->speed =3D=3D b->speed ? 0 : (a->speed > b->speed ? -1 :=
 1);
> +}
>
>  static int
>  SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon)
> @@ -587,6 +595,9 @@ SMB3_request_interfaces(const unsigned int xid, struc=
t cifs_tcon *tcon)
>         if (rc)
>                 goto out;
>
> +       /* sort interfaces from fastest to slowest */
> +       sort(iface_list, iface_count, sizeof(*iface_list), compare_iface,=
 NULL);
> +
>         spin_lock(&ses->iface_lock);
>         kfree(ses->iface_list);
>         ses->iface_list =3D iface_list;
> --
> 2.16.4
>

Looks good at the first glance, thanks!

@Steve, you may add

Acked-by: Pavel Shilovsky <pshilov@microsoft.com>

to this and other patches in the series.

--
Best regards,
Pavel Shilovsky
