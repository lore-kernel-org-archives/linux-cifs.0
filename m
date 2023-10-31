Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39733C4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Oct 2023 05:36:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjJaFgR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Oct 2023 01:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjJaFgQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Oct 2023 01:36:16 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3353710E9
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 22:35:40 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id 3f1490d57ef6-d9ad67058fcso4710520276.1
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 22:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698730536; x=1699335336; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6GIrxYzNqMAL03ypYkg1wJva3B8oMmI4IYeklUtA2u8=;
        b=G5cqzTnOnUTm7zwwHia4KhGDmtjzpGUzJRX+AwVcIbz80q3IZRsu085IxRqjVhuV6P
         6bsJ7mfh1CkG1TEcjm6ST4TqbtM9PXjwZeRSE8jiG7g4kxYMYtTyaY1htR9x9B3+kTg4
         tRcTR7MBxhTCrP0FDL5ye/VP49LGuSwjtW/4ulX1kKwWw8sqkdQFv6L1HNu9bGbKY1uW
         0SyVAfMKDeF0vH3T076RlZEyQDQKKZkz/HtfPfvoTkTeqjuJooWRK1beC80UfhAZnKmE
         jbk0UYB9CPwLGobeWKIdZPYP7bhMw9ZXKsaG++OA451j06wJ/VQ39r/7+r5mfZ6jXrvi
         uj7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698730536; x=1699335336;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6GIrxYzNqMAL03ypYkg1wJva3B8oMmI4IYeklUtA2u8=;
        b=p9kOfOJKaWFtU52uSNWmjQtvuZquqoxMR/hTYQkr19Mbss6yIQt9zmq7tDVqsET9lh
         3agsA2/bOgpnKdWNzf/UC9kGgXRlOlwZ1yMvkrGKZwP5K4AUWveXpdXLWLmsexS054dp
         qbUyCYektTR+kC/7AplABvAoEBJYv/SvpdoFBQeoEz5pvy+7RbnRTS2zGTiNjXAbuZ2+
         99mnrxKF7CbqA0HHSt7sAKbnr0DmpB63uIoWVD92AtKKplay4jHD27YfnJUW9TlrFkLE
         CTiisf1OPcT+rfZ4xcTiEdDUHixPNhXCNJbVLgfjCGM99aDYSLtkoGBEmXbkC4LmgYG5
         IoXQ==
X-Gm-Message-State: AOJu0YxiC+lX60cnmJ+9R+mKIxAYknj9qcjmPN6/ERmARzZHO3tQkmsG
        SNcIGgh5yLKgzf3Npk9uhLX/URzqwWMTr84voPs=
X-Google-Smtp-Source: AGHT+IE2M8LjuiUUeeJB+vBEffkhfKkvVdMyLn/Jl7MzfBoUftzeAWVZYJj8hdKyGUUhaHwCWtQ7IOeEloDbnSgz/LA=
X-Received: by 2002:a25:d38d:0:b0:d90:c424:53ee with SMTP id
 e135-20020a25d38d000000b00d90c42453eemr11266579ybf.9.1698730536558; Mon, 30
 Oct 2023 22:35:36 -0700 (PDT)
MIME-Version: 1.0
References: <20231030110020.45627-1-sprasad@microsoft.com> <20231030110020.45627-2-sprasad@microsoft.com>
In-Reply-To: <20231030110020.45627-2-sprasad@microsoft.com>
From:   Bharath SM <bharathsm.hsk@gmail.com>
Date:   Tue, 31 Oct 2023 11:05:25 +0530
Message-ID: <CAGypqWzibmZ3zxCoER_BKH6xh33KiH=hh_r8YWTqwJeW=h29hg@mail.gmail.com>
Subject: Re: [PATCH 02/14] cifs: add xid to query server interface call
To:     nspmangalore@gmail.com
Cc:     smfrench@gmail.com, pc@manguebit.com, linux-cifs@vger.kernel.org,
        Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good to me.

On Mon, Oct 30, 2023 at 4:30=E2=80=AFPM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> We were passing 0 as the xid for the call to query
> server interfaces. This is not great for debugging.
> This change adds a real xid.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/connect.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 7b923e36501b..15a1c86482ed 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -119,6 +119,7 @@ static int reconn_set_ipaddr_from_hostname(struct TCP=
_Server_Info *server)
>  static void smb2_query_server_interfaces(struct work_struct *work)
>  {
>         int rc;
> +       int xid;
>         struct cifs_tcon *tcon =3D container_of(work,
>                                         struct cifs_tcon,
>                                         query_interfaces.work);
> @@ -126,7 +127,10 @@ static void smb2_query_server_interfaces(struct work=
_struct *work)
>         /*
>          * query server network interfaces, in case they change
>          */
> -       rc =3D SMB3_request_interfaces(0, tcon, false);
> +       xid =3D get_xid();
> +       rc =3D SMB3_request_interfaces(xid, tcon, false);
> +       free_xid(xid);
> +
>         if (rc) {
>                 cifs_dbg(FYI, "%s: failed to query server interfaces: %d\=
n",
>                                 __func__, rc);
> --
> 2.34.1
>
