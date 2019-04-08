Return-Path: <SRS0=JvIj=SK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46CD2C10F13
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Apr 2019 23:09:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 111F920879
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Apr 2019 23:09:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RDnJ4Yaf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbfDHXJg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Apr 2019 19:09:36 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43607 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfDHXJg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Apr 2019 19:09:36 -0400
Received: by mail-lj1-f196.google.com with SMTP id f18so12748842lja.10
        for <linux-cifs@vger.kernel.org>; Mon, 08 Apr 2019 16:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qypRg32lj7o5iOEc2Bka7mHvyo8oM+qnqBCOIl4PKPw=;
        b=RDnJ4YafzKf1T0aEA0rHMlqT9HqkTs25NOFOG3+nXiYuJENVKwJMsIflXe2ZTtmMzq
         jpEt1Pwes+1jKNkEdHesHrFf7F8Ms86/20dT7Q4+l9u2jPykrquYZrIrwXjlSk3j+ong
         NCggNx18jslZBfeYAwB/hXbw9BNXAGOjArZzdTYokY2pKDPjK2BrLWsIGVL/5+84X/kg
         Blhr1UzlPbxdynMPubYQdL6iSUfCeAVCbgzWjHONukJ1UUOMkhJu/3An8Q2kSR00yXGs
         Rdioaup2/SUduXbgqba3EuHt/mXNpU+ssNEMPMBaMnI8XVNqnuFaRxJVvQux+GhcYlWQ
         6EAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qypRg32lj7o5iOEc2Bka7mHvyo8oM+qnqBCOIl4PKPw=;
        b=EO7abERxuQ/H5E2LY7wIQAVKiUkB0/vYeqM4kQLoSA3LzS41eS/wTOpC6Gaf+mb4hD
         imJuPG8KzoAdNa2Dd9DywEK1qsmBaHACNPhCO+f4d5rCXGyQ7GfatNHnzRBrYHz0UqjC
         06dejHV9qVht7OLT9W7BmX4GxDG/mgzyqkJCSG3IUqScXfoszDNv+x2vNhxkwY2uLjRZ
         iodn2MiGJA6EobFBtZiVVRPTNKZNGgxSIMr60scrIOF/qoXzN9nTGAkqXnd6PNhImze5
         o+HSrIIQ5Hn41dKWK8/5kiD/lUGEoq9u4kEQStesrY1odC0POwidhXg5yWQglRq5xlyp
         xtaQ==
X-Gm-Message-State: APjAAAWQZj2cYWY8Q74nsXOzm5SkzwjOd0ir5q0A2jpnTiCBMNdjF1O6
        qe5+I4UxiTtyOqU81V9voqEkGPqTaVyZ3C+Cfw==
X-Google-Smtp-Source: APXvYqwpHpDsyYIG5HHQ3QB9Ka/eILNn8nSeux11+k51FEfEg6D3B+JNOQ6O4tiyG53yH7IR1jRnYosIzwm6jzhSrlM=
X-Received: by 2002:a2e:1257:: with SMTP id t84mr18302057lje.115.1554764974477;
 Mon, 08 Apr 2019 16:09:34 -0700 (PDT)
MIME-Version: 1.0
References: <1554690154-34236-1-git-send-email-zhangxiaoxu5@huawei.com> <1554690154-34236-2-git-send-email-zhangxiaoxu5@huawei.com>
In-Reply-To: <1554690154-34236-2-git-send-email-zhangxiaoxu5@huawei.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 8 Apr 2019 16:09:23 -0700
Message-ID: <CAKywueQKFOb_9b_=_xLUBk37KcoN+OatSUaLsKLf-xdTfMbxNg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] cifs: Fix use-after-free in SMB2_write
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
> BUG: KASAN: use-after-free in SMB2_write+0x1342/0x1580
> Read of size 8 at addr ffff8880b6a8e450 by task ln/4196
>
> Should not release the 'req' because it will use in the trace.
>
> Fixes: eccb4422cf97(smb3: Add ftrace tracepoints for improved SMB3 debugg=
ing)
>
> cc: stable@vger.kernel.org (v4.18+)
> Signed-off-by: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
> ---
>  fs/cifs/smb2pdu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 0f14471..fca5b0a 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -3772,7 +3772,6 @@ SMB2_write(const unsigned int xid, struct cifs_io_p=
arms *io_parms,
>
>         rc =3D cifs_send_recv(xid, io_parms->tcon->ses, &rqst,
>                             &resp_buftype, flags, &rsp_iov);
> -       cifs_small_buf_release(req);
>         rsp =3D (struct smb2_write_rsp *)rsp_iov.iov_base;
>
>         if (rc) {
> @@ -3790,6 +3789,7 @@ SMB2_write(const unsigned int xid, struct cifs_io_p=
arms *io_parms,
>                                      io_parms->offset, *nbytes);
>         }
>
> +       cifs_small_buf_release(req);
>         free_rsp_buf(resp_buftype, rsp);
>         return rc;
>  }
> --
> 2.7.4
>

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
