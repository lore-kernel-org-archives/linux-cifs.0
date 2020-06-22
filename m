Return-Path: <SRS0=cwmY=AD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B83DC433E1
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Jun 2020 17:46:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C87820732
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Jun 2020 17:46:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jngs8Fdx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730097AbgFVRqd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Jun 2020 13:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729605AbgFVRqc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 Jun 2020 13:46:32 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06779C061573
        for <linux-cifs@vger.kernel.org>; Mon, 22 Jun 2020 10:46:32 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id dr13so18867513ejc.3
        for <linux-cifs@vger.kernel.org>; Mon, 22 Jun 2020 10:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qtVrBo9zCm9WHKS+1UqbrkmxlJgEwTlf3D0xpFuHfTg=;
        b=Jngs8FdxtsELlqIPLhjsN4rsqQmYRHKs9CwwOTyqM4k/U7SrkP2pCbtJSYgBjlZ9Fr
         9goTLZ7HtFFIOvm/1KkZ9Bp7UqtPNewMhWJzwSHibEd6Vt0rgyxnoWph2HX910PBXG+p
         R0mEV7gN5uKYxXuhNFbXCPERN5dq742MJxBe9JIAj21Kqovwcor++ytCR/mD2jMdrSG7
         Xw5oomaPgqijdeBDRXe9R4CmE7nvFQBXhtNXuLCYXX6tSSoBox3eNyBFvbQmsqa0edcr
         kjJi4NauBLdFmBgQGwH7vj0ymIhyWj0svhr5pTaadajcrLhyhcrzeXzA5x4aC4wlx0fc
         LUXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qtVrBo9zCm9WHKS+1UqbrkmxlJgEwTlf3D0xpFuHfTg=;
        b=jE3w2kHPkyuNlPZk0ZmqEk7ogtbswP2YDx4dpA7E9M7IiLMy1Qk10FIxNaNRtTgXBO
         2FBe5nn45VSz+N2A19XHRpsv6wfSgRmS4m5B0r540YiOZQ7Eodp4DBEjQhD1y0SFVefH
         WmhBBksE0zei8NyNMCsqez37QMfF5Rmvs5AZHu879shOzN91iYAIIzOF1syOK2PJdZBl
         rZRy+yUGYT9TpuI/KH4IN9kYwAU1kz4syNiZUVqPdMBQxDz0QRC9olMnVUFBsVTiehPn
         qg8YoDA89nagh+rphd5JbygiJRmjzDhxtLdVbW5Yqz1+a8mBKnsmXlk2xid9EjkL+Ixc
         ngnw==
X-Gm-Message-State: AOAM532ff+/IxZE5r6DguhrGkUH+uBmywRwSXlOCgH6f8//JbE5CeMbQ
        U7OLAUQXnU7RvQVTHhcMWDL1OJTCmg9AXlElOQ==
X-Google-Smtp-Source: ABdhPJzjNTTW/txt6qijBg4LwFKBAt9v9qwg7uLYVef1/LerVEws6433kX3BRsqFhAW0UUcvdTdoSBwtTW6/yq6lDy0=
X-Received: by 2002:a17:906:6a1b:: with SMTP id o27mr17307614ejr.271.1592847990718;
 Mon, 22 Jun 2020 10:46:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200620025033.4180077-1-zhangxiaoxu5@huawei.com>
In-Reply-To: <20200620025033.4180077-1-zhangxiaoxu5@huawei.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 22 Jun 2020 10:46:19 -0700
Message-ID: <CAKywueQD0aM3uJYmC0GbAj_F5RwcKNX1PS1_q+3dn6gyUR_+Xw@mail.gmail.com>
Subject: Re: [PATCH] cifs/smb3: Fix data inconsistent when zero file range
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc:     Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D1=82, 19 =D0=B8=D1=8E=D0=BD. 2020 =D0=B3. =D0=B2 22:04, Zhang Xiaox=
u <zhangxiaoxu5@huawei.com>:
>
> CIFS implements the fallocate(FALLOC_FL_ZERO_RANGE) with send SMB
> ioctl(FSCTL_SET_ZERO_DATA) to server. It just set the range of the
> remote file to zero, but local page cache not update, then the data
> inconsistent with server, which leads the xfstest generic/008 failed.
>
> So we need to remove the local page caches before send SMB
> ioctl(FSCTL_SET_ZERO_DATA) to server. After next read, it will
> re-cache it.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> ---
>  fs/cifs/smb2ops.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 736d86b8a910..250b51aca514 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -3187,6 +3187,11 @@ static long smb3_zero_range(struct file *file, str=
uct cifs_tcon *tcon,
>         trace_smb3_zero_enter(xid, cfile->fid.persistent_fid, tcon->tid,
>                               ses->Suid, offset, len);
>
> +       /*
> +        * We zero the range through ioctl, so we need remove the page ca=
ches
> +        * first, otherwise the data may be inconsistent with the server.
> +        */
> +       truncate_pagecache_range(inode, offset, offset + len - 1);
>
>         /* if file not oplocked can't be sure whether asking to extend si=
ze */
>         if (!CIFS_CACHE_READ(cifsi))
> --
> 2.25.4
>

Looks good!

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

Don't we need to do the same for smb3_punch_hole()?

--
Best regards,
Pavel Shilovsky
