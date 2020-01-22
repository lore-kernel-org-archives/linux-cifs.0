Return-Path: <SRS0=MBFb=3L=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97ED8C2D0CE
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Jan 2020 00:25:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33B1D217F4
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Jan 2020 00:25:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kOD7sbiS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgAVAZ5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Jan 2020 19:25:57 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:33198 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgAVAZ5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Jan 2020 19:25:57 -0500
Received: by mail-ed1-f66.google.com with SMTP id r21so4987374edq.0
        for <linux-cifs@vger.kernel.org>; Tue, 21 Jan 2020 16:25:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YJUFydQOHJtIkFbRTL42mdIWMgmFTOzV0gMgMMwvfKA=;
        b=kOD7sbiS54fVkCmUDaSJ/Ifj4slr5fXvFIqdD+9ZIbaKs2SU7+4NGzpHSPz8rPzM/K
         0TJ0qcm4rGgslJGUALjGuq9YkRxcPDNHSIkQiBC+GwU5/Dhc5cx8fNzDfeHF+1qbBOss
         aOR2ym9+69xyElRDWXWzFDVCVIT11l53Up96519e584IBzN5vun5Yw7K+R33/nval4TV
         sbM3m2uaXBBtgcaOSseHM3IbKqZQh2GsQ0NYGCnOlpUmacFOb/7VSstGdtB0qO6dufZm
         NR8ZXc4WZV5xGVyeE9AHR8fwfdmBixOPbMkaXDx8X2tJUepKBoIM/wZuCIQPAUdIiWha
         OJeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YJUFydQOHJtIkFbRTL42mdIWMgmFTOzV0gMgMMwvfKA=;
        b=Ed0SrQDjbEpxAYsF8MTdicez1+ArP9xt0FudGZd+lCPk/xOJd5Je+F+CwBGtjCIjCm
         UovGsg8jTk0cOPjxcDBpt87gBJqKVIkbR3GkQSjy/lc9bzNbC3j/sej0i9PQsYnhu2/x
         q3wLmSXTYVJfYenhLQCUk/xyrLmCp4nzPQmNUFvxDGKr4coSsJsryzygNFiaPO3oDka1
         G3nfqH4u8ZojXUei20eMOJdfr1h3HlfpbwbYH7b2sMupElESfInFj5moHQlnM+tv58MN
         rBC09oKh8uMt9t5j9W0mvuEYSmsb7EV03Dt/3n58Ybj8YSjlH2dxQRxvdXSlOaC/i5eX
         oTeQ==
X-Gm-Message-State: APjAAAXwSf/B8EufU+a5wCVq4gJgqY8WMWrQ/T81FF4k0nvT+MLKQAwm
        Zzv1jq7F7cNbEMvSe+3EI1km7GIo+slw/ce42/VdkxU=
X-Google-Smtp-Source: APXvYqzueXcfblW2WXruWbzzwxJmu4W6PRMjZ7QZst5r9WyXa3vPuMSS1uKlPQNqinr3X2iVN8Dr4RrKGCS9dGT5rA4=
X-Received: by 2002:a2e:9708:: with SMTP id r8mr17779288lji.92.1579652754963;
 Tue, 21 Jan 2020 16:25:54 -0800 (PST)
MIME-Version: 1.0
References: <20200106163119.9083-1-boris.v.protopopov@gmail.com>
In-Reply-To: <20200106163119.9083-1-boris.v.protopopov@gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 21 Jan 2020 16:25:43 -0800
Message-ID: <CAKywueQu5sK8gbNurZw0qZppbAJ9C4myqzPdD_6vSVJw=LXPsQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] Convert owner and group SID offsets to LE format
To:     Boris Protopopov <boris.v.protopopov@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        samba-technical <samba-technical@lists.samba.org>,
        sblbir@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 6 =D1=8F=D0=BD=D0=B2. 2020 =D0=B3. =D0=B2 08:31, Boris Protop=
opov <boris.v.protopopov@gmail.com>:
>
> Convert owner and group SID offsets to LE format
> when writing to ntsd
>
> Signed-off-by: Boris Protopopov <boris.v.protopopov@gmail.com>
> ---
>  setcifsacl.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/setcifsacl.c b/setcifsacl.c
> index f3d0189..9a301e2 100644
> --- a/setcifsacl.c
> +++ b/setcifsacl.c
> @@ -114,12 +114,14 @@ copy_sec_desc(const struct cifs_ntsd *pntsd, struct=
 cifs_ntsd *pnntsd,
>         if (dacloffset <=3D osidsoffset) {
>                 /* owners placed at end of ACL */
>                 nowner_sid_ptr =3D (struct cifs_sid *)((char *)pnntsd + d=
acloffset + size);
> -               pnntsd->osidoffset =3D dacloffset + size;
> +               osidsoffset =3D dacloffset + size;
> +               pnntsd->osidoffset =3D htole32(osidsoffset);
>                 size =3D copy_cifs_sid(nowner_sid_ptr, owner_sid_ptr);
>                 bufsize +=3D size;
>                 /* put group SID after owner SID */
>                 ngroup_sid_ptr =3D (struct cifs_sid *)((char *)nowner_sid=
_ptr + size);
> -               pnntsd->gsidoffset =3D pnntsd->osidoffset + size;
> +               gsidsoffset =3D osidsoffset + size;
> +               pnntsd->gsidoffset =3D htole32(gsidsoffset);
>         } else {
>                 /*
>                  * Most servers put the owner information at the beginnin=
g,
> --
> 2.14.5
>

Merged into "next". Thanks!

--
Best regards,
Pavel Shilovsky
