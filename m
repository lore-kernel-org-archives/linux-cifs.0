Return-Path: <SRS0=fS5U=R6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A62C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Mar 2019 22:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEA7720651
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Mar 2019 22:49:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n8dlA6nx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbfC0Wtf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Mar 2019 18:49:35 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46497 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbfC0Wtf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Mar 2019 18:49:35 -0400
Received: by mail-lf1-f68.google.com with SMTP id r25so12561911lfn.13
        for <linux-cifs@vger.kernel.org>; Wed, 27 Mar 2019 15:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0XWISBEPVeZScj9wlFwNJGIzrgmJtq2o+kAxJbbAfSU=;
        b=n8dlA6nxpWpVkrc0SWp0ig7ba/R0ISwtaouBTpRPFb3L1/qwxytSXB27XoXGDft0l2
         fzodIKmUvFOhrNAZ2c7UMespTL+pz5gl9T/jhTnaNVWK+J6KSv3ZHFTeZzFpOUdaLOEN
         9H/n8ihQNiOc5E0mivFvUVboP/GU3eBBeontg19TW5teXQw5/0o8W+yV1xJWHioydP5B
         gb9s1LLIbQbQbhl4/SqxZYwMBO9OUCaCZ+WlCdx+oUk3DIIEhZd0WUrj575hplk5wXYC
         WLGO3i5aCtb2Rb6mmkZTMC7ohvPgAe3ByDagriDvPkDG3A4Suik2Nv9Ur2dEf6weFVuG
         GgyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0XWISBEPVeZScj9wlFwNJGIzrgmJtq2o+kAxJbbAfSU=;
        b=Do73+IpNesfOipsZLQqi2+WvaUugdZT11iX/98ul7Cixpns5ykvsPCjZ66AGlMfHQd
         Qry/hgytGp9IsCNHmYMa0exZCxtlSL9eI/dmBoJT9JyFyw1gjT+zTe6DnktK+mzd5O0I
         JWOSePpPtapDhRbRZ65PW3NILT04UdgptAxmJbXaQGhj6gMvBe63thmbtzRnbpFO5Z50
         wUmDWvKXasZtsZlI1O0RYxy3VWI2CwVO5zYx+IXM5sSRgEcOLB4j6dq+/MHUHW51ojTo
         BrvS7al2Tb5aJ/A7za5xTUM2ChTL1Dw89+2sD0dRQGQrqikiUQNLxy3jdcv+tRAizvxs
         9IGg==
X-Gm-Message-State: APjAAAWELY0MBdML0qTQtisiRpPkwtBHYClei7PlETqH/NbuM2WjXNgy
        xDRyOtHNTVV0XyH2b+CCDQa1srN+L5kNAcEmyQ==
X-Google-Smtp-Source: APXvYqyNP24jSpQavy0ju8UPYncwX7M5MGjdYjXAsOXBaEi729/6Y94yQwilRyzlNFGeLPgOzdaCYZf1nIQup0lv/pA=
X-Received: by 2002:ac2:4825:: with SMTP id 5mr19815744lft.64.1553726973381;
 Wed, 27 Mar 2019 15:49:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAKywueSSULxWaFNb12EGJXmAr9k=hd6f3ND5f0AQhwho0PV6Tw@mail.gmail.com>
 <20190326163152.27385-1-aaptel@suse.com>
In-Reply-To: <20190326163152.27385-1-aaptel@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 27 Mar 2019 15:49:22 -0700
Message-ID: <CAKywueQqTbL8g2t6fD2s_dQjFdqk9gFGaoifGWRv1mdw-PGMiQ@mail.gmail.com>
Subject: Re: [PATCH v1] CIFS: keep FileInfo handle around while writing pages
To:     Aurelien Aptel <aaptel@suse.com>, Steve French <smfrench@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=82, 26 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 09:31, Aurelien Ap=
tel <aaptel@suse.com>:
>
> In the oplock break handler, writing pending changes from pages puts
> the FileInfo handle. If the refcount reaches zero it closes the handle
> and waits for any oplock break handler to return, thus causing a deadlock=
.
>
> To prevent it we keep an additionnal reference of the SMB FileInfo
> handle while we write/read pages so that when writepages puts the
> handle, it won't close it.
>
> This was triggered by xfstest 464.
>
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> ---
>  fs/cifs/file.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 89006e044973..a9a515ea2e14 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -4579,12 +4579,15 @@ void cifs_oplock_break(struct work_struct *work)
>                         break_lease(inode, O_RDONLY);
>                 else
>                         break_lease(inode, O_WRONLY);
> +
> +               cifsFileInfo_get(cfile);
>                 rc =3D filemap_fdatawrite(inode->i_mapping);
>                 if (!CIFS_CACHE_READ(cinode)) {
>                         rc =3D filemap_fdatawait(inode->i_mapping);
>                         mapping_set_error(inode->i_mapping, rc);
>                         cifs_zap_mapping(inode);
>                 }
> +               cifsFileInfo_put(cfile);
>                 cifs_dbg(FYI, "Oplock flush inode %p rc %d\n", inode, rc)=
;
>         }
>
> --
> 2.16.4
>

You mentioned correctly in the other thread that this still doesn't
prevent the deadlock and we need to detect in cifsFileInfo_put() that
it is being called from cifs_oplock_break().

If there is a thread waiting on:

oplock_break_cancelled =3D cancel_work_sync(&cifs_file->oplock_break);

then this handle can't be referenced again by any other threads
because it was removed from the open file lists. So, the extra
reference shouldn't be acquired in oplock break handler routine but
instead be taken before we submit the oplock break handler to the
queue and while we are holding tcon->open_file_lock (see
smb2_tcon_has_lease).

Now, it come to the place where to put this reference. We need to make
sure that the file is not used after we put the reference, so, I would
suggest to try putting it at the very end of cifs_oplock_break()
together with the extra flag (like you mentioned) indicating that we
shouldn't call cancel_work_sync insde.

--
Best regards,
Pavel Shilovsky
