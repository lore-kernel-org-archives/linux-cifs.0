Return-Path: <SRS0=TaZu=3G=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8A08C33CB1
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jan 2020 07:53:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B87520748
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jan 2020 07:53:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tC8YASmQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728986AbgAQHxi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Jan 2020 02:53:38 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:36461 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbgAQHxh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Jan 2020 02:53:37 -0500
Received: by mail-il1-f193.google.com with SMTP id b15so20589700iln.3;
        Thu, 16 Jan 2020 23:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ewcmoyl+6W8TZGkDd/S2uQ2DNIJNVj7mIuv/mX9U2rw=;
        b=tC8YASmQVV85WcRMP7qiq+zbkH7k4UzmDanPJDpIyhVnmFg8WsNqNlbgpvrNxolEml
         dsAHC+covEKZmIy2JOMHcYF+nq/AHfDn2NtSnmIGb3NJ6bM+WNd4tuoAZx81Vb5nY8v4
         AqxvXgFuwDg2VU8aFuSYEmeJdldRCeNQMaR4tOYKL87vB4yZIB0/Maz+kTGr+yPh13Lw
         juE/jJWSmn2nX7tPlsLxSfSX9F5bHW1qacKlKxW5vuohcVrG7BCzkoOvKWi8OpPsYDUx
         xlx52akyKGSBEy+LII7ccOWLlkPw/geakJB2/D9UYqTNA1bNXB+FCncFO0zBqSHw9AzR
         +skA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ewcmoyl+6W8TZGkDd/S2uQ2DNIJNVj7mIuv/mX9U2rw=;
        b=JWBl8uIhheEjGAlgZ8F0N0FFZ+aDbtLajPdvNb9dq/wfO7KFEyz3FeqWqXhxENGzp0
         R4bwl11/qMkWKxS1Jeze/xY/EF+DEM6SSvya4LYbNQ4FXK29k0pro1HNABv093S19aMl
         tCK0MfpxY14tDjxfYHpa8aw8KW5eoaCF4ifBavM1Foryqwg4odcazPcBjOxUl29K4K8z
         OoMc9VGmgCsHFUC4/KVnIXBgGES/SA7+e5hlGWuW6HnOBgqeaPf30OPxakvdaZf5XM39
         nhqO+gyUhRIgaoIRbetBpgRl/FvgIexui1NnweDgLx0EedYk9fwhpTzZSkLotJOcKdJq
         vIXw==
X-Gm-Message-State: APjAAAVVzICiKaVX6hR2enJvb1Q1UwW63m+XlA4CSI1FKegKD5YNNbzf
        sJgmi3JV+gDqLOT/si2VIjOdpd8Zgvgu6V21a6Y=
X-Google-Smtp-Source: APXvYqyJIO6p9W3sIvKgsnI9yM8+QC0mVX+Kx5GTkRRst1rZ6CJocMjvHEfBFMhU3gZEpc++9iMJgmfzVWEplNZ1+6s=
X-Received: by 2002:a92:9a90:: with SMTP id c16mr1971623ill.3.1579247617119;
 Thu, 16 Jan 2020 23:53:37 -0800 (PST)
MIME-Version: 1.0
References: <20200117025717.58636-1-yuehaibing@huawei.com>
In-Reply-To: <20200117025717.58636-1-yuehaibing@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 17 Jan 2020 01:53:26 -0600
Message-ID: <CAH2r5ms=s_c5YOPfXdTE-ee6LX_Quq9_Oao4p_k0b59fDNemWQ@mail.gmail.com>
Subject: Re: [PATCH -next] cifs: remove set but not used variable 'server'
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Steve French <sfrench@samba.org>,
        Pavel Shilovskiy <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Thu, Jan 16, 2020 at 10:01 PM YueHaibing <yuehaibing@huawei.com> wrote:
>
> fs/cifs/smb2pdu.c: In function 'SMB2_query_directory':
> fs/cifs/smb2pdu.c:4444:26: warning:
>  variable 'server' set but not used [-Wunused-but-set-variable]
>   struct TCP_Server_Info *server;
>
> It is not used, so remove it.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  fs/cifs/smb2pdu.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index a23ca3d..64d5a36 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -4441,13 +4441,10 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
>         int resp_buftype = CIFS_NO_BUFFER;
>         struct kvec rsp_iov;
>         int rc = 0;
> -       struct TCP_Server_Info *server;
>         struct cifs_ses *ses = tcon->ses;
>         int flags = 0;
>
> -       if (ses && (ses->server))
> -               server = ses->server;
> -       else
> +       if (!ses || !(ses->server))
>                 return -EIO;
>
>         if (smb3_encryption_required(tcon))
> --
> 2.7.4
>
>


-- 
Thanks,

Steve
