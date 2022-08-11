Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE9DC19F2D
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Aug 2022 08:31:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbiHKIbC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Aug 2022 04:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234521AbiHKIa6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Aug 2022 04:30:58 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D46E73328
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 01:30:54 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id j1so20542641wrw.1
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 01:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=8bo5dAXVZFugXo7VPm3PLCYYW+6kUOWAPAkVEw91Ynw=;
        b=RR/LbXBS/8qfjMVdJflHYFxIaabqKY5vDWEFHZcYF6L1nQp8IsORbe/blcHNX2wFEU
         qHKsGAUXe420NE5V85j41AW8VDmzT0W1+k47vvONh1akVQqZv8pHbCO4GB8DEyV0vDgV
         JOeep19Ao0Bb0u/1u2s93BJY7Zr0Lc9pHTFFJnDF1VmX8J3LrLF4NSOJVmF96fmsmhLv
         D8H4cv33A7oGeG9bwa2Pk7F0UmNEfqd53r/5g21j1CCkI97rz7E73SW5/IJ2w8XXSJhV
         9Kqv9zW3edELzgwFPCwl/NaqHfx3GX9V7HhmLjGtS0Vx0HUzDhix9QdS9R7Qy98D+b4e
         BIkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=8bo5dAXVZFugXo7VPm3PLCYYW+6kUOWAPAkVEw91Ynw=;
        b=WXhqZkjzVqJRCi3ZzrDaVzg4cE4wjMAXAOFj/RIiftHeOPQ+S8jXHTqUqgzDlicn70
         3uvQ5FTiF8W1SsFeaBaG0HiZb2SexXGd+xosBq5Qro30J6+LWkoBhqq/wQtiNbOZcrac
         DBv3BAplUSbZfI8r762jNbK5GpRYzi/InOfJA2UBVIf8+m1xjtK9bongOECbKRvYSo0r
         czPWbuH2nzPFO3wzY7dUyweDSHONpsid78u698H6Cz8Gc1TNafCg5MRyV8odvGjCJLCo
         JwZ2pye6Ln3+wCGOw0WYDFkoFNVLm+9KNOX6Zd99Tgo7UhRDw09Ja5dkpCIGTU6QB0WD
         ZRJQ==
X-Gm-Message-State: ACgBeo2hOlJTzRk38hx2yxNgkgLgD1h1+3lRgl3/CHQGr5Kz+88mJJUb
        P84FEd7Gt5bLPQ9DyOo1RniWn6Pg6qfbVZ0H4Rg=
X-Google-Smtp-Source: AA6agR6O9PKkTC0UID4tx6SRAbXKHa9xnFiV0Tv0FgcxGT8zndKo3IhOuGapOwyzk4tAkiac4lSDl85ffPTr3VXkI4w=
X-Received: by 2002:a5d:5266:0:b0:21f:1280:85f with SMTP id
 l6-20020a5d5266000000b0021f1280085fmr19721498wrc.412.1660206652749; Thu, 11
 Aug 2022 01:30:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220811063659.67248-1-hyc.lee@gmail.com> <YvSm62l0+6fTZ9E8@infradead.org>
In-Reply-To: <YvSm62l0+6fTZ9E8@infradead.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Thu, 11 Aug 2022 17:30:41 +0900
Message-ID: <CANFS6bbq-TUYxkQDYpO-7zYzUF5gw1yu31Dz-TqRGHPT7ywo+w@mail.gmail.com>
Subject: Re: [PATCH v3] ksmbd: remove unnecessary generic_fillattr in smb2_open
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-cifs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022=EB=85=84 8=EC=9B=94 11=EC=9D=BC (=EB=AA=A9) =EC=98=A4=ED=9B=84 3:51, C=
hristoph Hellwig <hch@infradead.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On Thu, Aug 11, 2022 at 03:36:59PM +0900, Hyunchul Lee wrote:
> > +     rc =3D ksmbd_vfs_getattr(&path, &stat);
> > +     if (rc) {
> > +             generic_fillattr(user_ns, d_inode(path.dentry), &stat);
> > +             rc =3D 0;
> > +     }
>
> Why is this calling generic_fillattr at all?  generic_fillattr is a
> helper for file systems.  Consumers of the file system API like ksmbd
> must never use it directly.

I will remove generic_fillattr.
Thank you for your comment.


--=20
Thanks,
Hyunchul
