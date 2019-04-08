Return-Path: <SRS0=JvIj=SK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4E2BC10F13
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Apr 2019 23:09:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A09D520879
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Apr 2019 23:09:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ApFie4sO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfDHXJv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Apr 2019 19:09:51 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35152 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfDHXJv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Apr 2019 19:09:51 -0400
Received: by mail-lf1-f66.google.com with SMTP id u21so10805318lfu.2
        for <linux-cifs@vger.kernel.org>; Mon, 08 Apr 2019 16:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oZypvvBWy5hdemJNpj60lF42wN2r4NWpKLUJoJMO7Z8=;
        b=ApFie4sOM6C7iXqOgsWumS5KI+eBmoha1obmb+vnEvqJtQJoyEgKndJXoEHCTBL+rl
         tO/PcLwHQX8f9wxSDYxEW6Ql27sTZ/Gqn2SuEy21pihcTTJigUulDZsuL7n9WZhfV9E4
         LFbZ7KOF2sN+YeI4EuIH1OALlvFZHXLAE0xLHYuqx2h07eehZJsf9FZ7z/szQ26SfBwL
         IQzXSZ9QD7gkbkgs/wzfPLaNma9f+QvwrKsQsX8R/eODW79ePv90Ag5N5oxZhkOvgbq9
         5UpXIqwgpxjoBRqFcX6gIEwI1SbC1Zv0d+Ciwd9SD7CfVOzl1fux40OZ1B3zKAEAFnTz
         Ad7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oZypvvBWy5hdemJNpj60lF42wN2r4NWpKLUJoJMO7Z8=;
        b=qHf30MIDP9x8oNcN9agjIOhp+qZ4AJz8entPNZZl7caKiHBiqBDeOc8b+b6o6/0AoN
         vsD++w9Mt3KHE1751Vlk+J1zE8Yq+4WyY4DQcO/mh1NjC7lJ/AP9fi1eJ/eIfIOLbpYr
         3PTN5/Sw9KI3EQdNASx73JE/5x64ovB9jlpKtqv0Mvl9VJDF7Qd2LdlTLcVE2qqE743y
         nfhjLz6HhakV8vZ+ndgeSxdLS1SVhtTcHxz6RSY72UAhqqoGdCTCuyvO/HTtW6M+l2ce
         owkkcBVTUcudqHD+oH9RPD7s3qSP+sMP56Y3drTvbASevoXvB80OEmVHrLhs5Zp6+FVO
         jlfQ==
X-Gm-Message-State: APjAAAUODvhftP1HElLhGlaQblaMzhzxzH6hiMd39ljYS6mgOMgSmeUp
        PV9RiCTgVJabiA5rbi9NF6cxWAPZxFGTwfOi+w==
X-Google-Smtp-Source: APXvYqwiHeuQCM99yt9ODerrl8WcLWtck+fuxjkM1fuwKFFzHV6Ssu+eFyd1NnrAe8WRl5TJPd5i4WwpBEajZI/jMQQ=
X-Received: by 2002:ac2:530a:: with SMTP id c10mr14920963lfh.45.1554764989318;
 Mon, 08 Apr 2019 16:09:49 -0700 (PDT)
MIME-Version: 1.0
References: <1554690154-34236-1-git-send-email-zhangxiaoxu5@huawei.com> <1554690154-34236-3-git-send-email-zhangxiaoxu5@huawei.com>
In-Reply-To: <1554690154-34236-3-git-send-email-zhangxiaoxu5@huawei.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 8 Apr 2019 16:09:38 -0700
Message-ID: <CAKywueRz+qrV9TxH9NA0RJ+WoFrGte9nj2k1o6X2idKP5rgdpw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] cifs: Fix use-after-free in SMB2_read
To:     ZhangXiaoxu <zhangxiaoxu5@huawei.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=81, 7 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 19:18, ZhangXiaoxu =
<zhangxiaoxu5@huawei.com>:
>
> There is a KASAN use-after-free:
> BUG: KASAN: use-after-free in SMB2_read+0x1136/0x1190
> Read of size 8 at addr ffff8880b4e45e50 by task ln/1009
>
> Should not release the 'req' because it will use in the trace.
>
> Fixes: eccb4422cf97(smb3: Add ftrace tracepoints for improved SMB3 debugg=
ing)
>
> cc: stable@vger.kernel.org (v4.18+)
> Signed-off-by: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
> ---
>  fs/cifs/smb2pdu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index fca5b0a..b8f7262 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -3451,8 +3451,6 @@ SMB2_read(const unsigned int xid, struct cifs_io_pa=
rms *io_parms,
>         rqst.rq_nvec =3D 1;
>
>         rc =3D cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags, &rsp=
_iov);
> -       cifs_small_buf_release(req);
> -
>         rsp =3D (struct smb2_read_rsp *)rsp_iov.iov_base;
>
>         if (rc) {
> @@ -3474,6 +3472,8 @@ SMB2_read(const unsigned int xid, struct cifs_io_pa=
rms *io_parms,
>                                     io_parms->tcon->tid, ses->Suid,
>                                     io_parms->offset, io_parms->length);
>
> +       cifs_small_buf_release(req);
> +
>         *nbytes =3D le32_to_cpu(rsp->DataLength);
>         if ((*nbytes > CIFS_MAX_MSGSIZE) ||
>             (*nbytes > io_parms->length)) {
> --
> 2.7.4
>

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
