Return-Path: <SRS0=YW4u=SZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20554C10F03
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Apr 2019 17:51:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2333214AE
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Apr 2019 17:51:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rzo7g6FN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbfDWRvN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Apr 2019 13:51:13 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:38745 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728646AbfDWRvN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Apr 2019 13:51:13 -0400
Received: by mail-lf1-f68.google.com with SMTP id v1so3635367lfg.5;
        Tue, 23 Apr 2019 10:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=f5Fmvo/naDY8w89X2OHTxjqQNn6kydSqcO0oSmsNCfE=;
        b=Rzo7g6FNS7W0oBKeB+IQXrG1zN7xNy9AqSYQMU74LaxfLxoQ9AehmHpP3uDhHN87uT
         erPG7TvEug1PnYWeEqgXydOz/7ZD9WAC+udDxXDVBOj8xlHjvpPh+DIGN/jzpubGGEUt
         nR2YGEK8pV2Rl1VUAGZVQXIPE31ApB1P3RXVxgDCWYymp+6Pb+TKHFiniWMndFvSJjDi
         /17eS7SH8hKI6n4tIJsrLMUbwjlZ8cV0/vWpAZt7DhveQJIjgDur5p1Qo9YJMba8Q5Yn
         NzhZAJXUKs5dwqwuI3wH3CebjyQDsOKuHKyRa1dXvSTlCTINrGVrNB2FSzfw7KZPtfa/
         oBrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=f5Fmvo/naDY8w89X2OHTxjqQNn6kydSqcO0oSmsNCfE=;
        b=KfPKWFxkggnTKni0yKZnmHoqBM4+YKiuB+irzqbBUWlRkbz9XES8ZIFgy6BSrU8vSA
         OcQND4VzpybAUxS7OoiNT2Jut1rAW9Cj+zajncrm8v0zY1VM7sJCGzOwroyLk9q0WWkS
         kZ6/L66wM+Q3YKLhTe9MRJDtzLoV9CYjLylrNTx0iPu0qjFXh2jD+gao6YqHkJnoyIMS
         UMUabbPZEGapgHnl1mK5Vx5na3niW7h94znkS5CUkGWGHy53SNT3bW7UZlxVijfsAiCm
         W5ia865lw6ZExxl5nvn1xJMp++ViwL+w3meSTBjSqemH3DLxdvb5SqL0Cin+PllAuS1u
         XBsA==
X-Gm-Message-State: APjAAAUpkAZsAEjXnj4CvkhTP+6SMuqL7sXoZbS70x16MTCzfLnlt2/u
        JJn+ckJ8INRHfA+ODXq1v04ccHlBo8+Nf0thrQ==
X-Google-Smtp-Source: APXvYqwxEu7cReQODx27WgnTSOl+T+xlUl5td3IyAfxiIE78NZm4bc71eZXkwRSy1CAZpX7HQT53fXlgbSz2rCN1iRQ=
X-Received: by 2002:ac2:5609:: with SMTP id v9mr14147248lfd.159.1556041870972;
 Tue, 23 Apr 2019 10:51:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190423063945.28996-1-lsahlber@redhat.com>
In-Reply-To: <20190423063945.28996-1-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 23 Apr 2019 10:50:59 -0700
Message-ID: <CAKywueTUG+tFLgR0GzxE6XaU2FGxYnJ8dxvGgT20=RfRD7OBRg@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix memory leak in SMB2_read
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 22 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 23:40, Ronnie Sahl=
berg <lsahlber@redhat.com>:
>
> Commit 088aaf17aa79300cab14dbee2569c58cfafd7d6e introduced a leak where
> if SMB2_read() returned an error we would return without feeing the reque=
st
> buffer.
>
> Cc: Stable <stable@vger.kernel.org>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2pdu.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 463c9298cd67..a932dccafc5b 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -3463,6 +3463,7 @@ SMB2_read(const unsigned int xid, struct cifs_io_pa=
rms *io_parms,
>                                     io_parms->tcon->tid, ses->Suid,
>                                     io_parms->offset, 0);
>                 free_rsp_buf(resp_buftype, rsp_iov.iov_base);
> +               cifs_small_buf_release(req);
>                 return rc =3D=3D -ENODATA ? 0 : rc;
>         } else
>                 trace_smb3_read_done(xid, req->PersistentFileId,
> --
> 2.13.6
>

Looks good.

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
