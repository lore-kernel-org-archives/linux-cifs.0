Return-Path: <SRS0=GU4v=AS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA91CC433E0
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Jul 2020 23:19:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA3DE206CD
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Jul 2020 23:19:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fiotU18W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgGGXTG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Jul 2020 19:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbgGGXTG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Jul 2020 19:19:06 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE506C061755
        for <linux-cifs@vger.kernel.org>; Tue,  7 Jul 2020 16:19:05 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id ga4so48422099ejb.11
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jul 2020 16:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tC+cUkA/k6r261uR9wLkjBZaHJbyiWRwHMwvKRj57jk=;
        b=fiotU18WmzfdBnIo7+PEyDY9EIF4TlUPloUsI6tPVqbTewBYVv1Q8Op6nruXL3WoBm
         yXuwrLbSbFoJoNNTLzQtwXIP1Es8AmT/MuVuWnJB6USWzfd3zB/ShUZMresNo1v8aKUK
         VpIuy11h0aIt48jhXYtXFdeb5nuvCZrBNxOn1Ib0FL0FolUYaPl3PSJ758NDz4qoF/5e
         eh8tMktibwAexXIdagPIgXrK8HCgA5X7lYqtpdjcBJwT0YAvVDRnGFUfRyZsjB/dWui6
         DF6vS7oRe4Oq9s0aNFDtvTHS7ww0yTkXN6LQ8uik5TdZZmuZupE7WPBlpY+FdKUzcFgw
         v7gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tC+cUkA/k6r261uR9wLkjBZaHJbyiWRwHMwvKRj57jk=;
        b=G2O0YcM7tLUbhSPR0aaOdHppldiG009i8PAbBNsher0Ip4elY7dK/lHpHEHeghG7jL
         NT2Mrx1HBLya7nURNC9hmafNT+d7ol8l5kPDAlwqMIEnkFn7w5XBrBsq3zfJDWAGeomH
         G1bsaRMANunwWT4c1AqUvkzHR7Uo6T4kiSI5lLlUmUP7VZmMgVx+2DTU1lZbSNSIi8gL
         iQnmLTarqO0K9Ln8b4AmNPVYLK9O1mfAWme31clDrGu1kZCP5LBZPhqBaY8pZvoZms9M
         vE09qO1vAGkmryE+uEviEse0/WI6P9CyLuzIitqCeFCfuRi7sCR6yE3eU6WT+VnMCE1T
         1slw==
X-Gm-Message-State: AOAM532kHUoJOZCYaqkST1VILYC3jhCEWBfwmq+wnu7MWgwxumC8uQId
        76/Au2edHvLvxDVS9ak3eAP8+E8JWE0l+DpwbA==
X-Google-Smtp-Source: ABdhPJwdxo+mZ8g5N6uR56QN22emoMEoAp6grvYuMxIcVvwB/f/HlsuQIYn94G3xNmwF+yf4hAdFwRGpFXWDxPeKvXw=
X-Received: by 2002:a17:906:95d6:: with SMTP id n22mr49457299ejy.138.1594163944272;
 Tue, 07 Jul 2020 16:19:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvgtg0QdikUa78ZwCRG7Lx1-v=XKhnVWGVqqi=JMzKA4A@mail.gmail.com>
In-Reply-To: <CAH2r5mvgtg0QdikUa78ZwCRG7Lx1-v=XKhnVWGVqqi=JMzKA4A@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 7 Jul 2020 16:18:53 -0700
Message-ID: <CAKywueQ4v87J8SP4orKa5C8i2bR0f-9QREe2o1vewMi2ommZhw@mail.gmail.com>
Subject: Re: [SMB3][PATCH] smb3: fix access denied on change notify request to
 some servers
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good!

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky

=D0=B2=D1=82, 7 =D0=B8=D1=8E=D0=BB. 2020 =D0=B3. =D0=B2 16:13, Steve French=
 <smfrench@gmail.com>:
>
> read permission, not just read attributes permission, is required
> on the directory.
>
> See MS-SMB2 (protocol specification) section 3.3.5.19.
>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> CC: Stable <stable@vger.kernel.org> # v5.6+
> ---
>  fs/cifs/smb2ops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index d9fdafa5eb60..32f90dc82c84 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -2148,7 +2148,7 @@ smb3_notify(const unsigned int xid, struct file *pf=
ile,
>
>   tcon =3D cifs_sb_master_tcon(cifs_sb);
>   oparms.tcon =3D tcon;
> - oparms.desired_access =3D FILE_READ_ATTRIBUTES;
> + oparms.desired_access =3D FILE_READ_ATTRIBUTES | FILE_READ_DATA;
>   oparms.disposition =3D FILE_OPEN;
>   oparms.create_options =3D cifs_create_options(cifs_sb, 0);
>   oparms.fid =3D &fid;
> --
> 2.25.1
>
>
> --
> Thanks,
>
> Steve
