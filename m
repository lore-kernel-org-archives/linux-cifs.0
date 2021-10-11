Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2703AC433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Oct 2021 12:28:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08BE360F43
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Oct 2021 12:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236582AbhJKMah (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 11 Oct 2021 08:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234635AbhJKMaf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 11 Oct 2021 08:30:35 -0400
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B9AC061570
        for <linux-cifs@vger.kernel.org>; Mon, 11 Oct 2021 05:28:35 -0700 (PDT)
Received: by mail-ua1-x932.google.com with SMTP id q13so12416547uaq.2
        for <linux-cifs@vger.kernel.org>; Mon, 11 Oct 2021 05:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SREhfeQ9ccKIcnCF4wp/SbSTWAIRPClfferF3yx+vaQ=;
        b=c8lfRzEV6fnCT/MrirTem0V8aHqcYfc3rvW0nbFmT1dIOWFQ3U8TP3w9TnAUx9HFRD
         +woDA6DUG/dpAwMIVjdpaRKRM3f/XobzIWFR8hzQ5R+CXytrudPCugrG4iawk0Cjkmof
         LEcn8yGvX0Qq+nU8lib2VeImJ5f5ucfi7ir+E1/cCTWBBJhL2whH0Ck/8Im5Q3H7VkvW
         UjUSA8QL59ZnXK8YFPLi3AFN8othPjBuPWB4t/QgRf/kmqosuIdmigqcvsUq8vpPXxCk
         +vggCq0TNDW4x/ps5UyWWBFlhMZKIziuVJa+Rd27knrlGkuQy8moenkgAzKjLHKEdNcQ
         GwMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SREhfeQ9ccKIcnCF4wp/SbSTWAIRPClfferF3yx+vaQ=;
        b=1zjqxzFyEGoQBGPU5RF/H+Xmr4Cr7FqlcV0m6GHBmJGUPdwgs6fmECNtVacv/g5YaF
         sb4GJGmHCwhAlMUwyx1dvihTnpSsdGg14IVlR1+6WHrOb0ylhDHwy2PM1BvpaepoNQrC
         BQJWECrstS22Iv0fxtvuDQQPRPSHZOfFwcyueEInSb8o8xkDomlVony3sqfm2BYlIrOT
         qBeV2HCNKxh/5wFni6qGHAdTkRp9i6pn35IDBtaK1G4PTpoPkhTurj9APX1RDEskaAOX
         a30XVIPJo7LDmUh3MSftstop5mlBncT48hz+anwlt9iMLnoqghImXlv6OokzL8o7/MJm
         t5Cw==
X-Gm-Message-State: AOAM531q4auTclaIyCGc8fBosXV0plZxlYveqvFFD85eeeX9hySbi7+p
        Euqhl5strlXIgrWWkagut892Y3aW9X+QRfAKiGw=
X-Google-Smtp-Source: ABdhPJxaS8SawnhF142QMbMqZXBXw8YzZQBPLEHGQ/PMq0Xuy4I6DGmiM+zLK83RezbOKGJnw1S1GIRZX2NZM0/Q7f0=
X-Received: by 2002:ab0:7110:: with SMTP id x16mr1503007uan.136.1633955314728;
 Mon, 11 Oct 2021 05:28:34 -0700 (PDT)
MIME-Version: 1.0
References: <20211008032931.60797-1-linkinjeon@kernel.org>
In-Reply-To: <20211008032931.60797-1-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Mon, 11 Oct 2021 21:28:23 +0900
Message-ID: <CANFS6baOvbRbtTDDtDJr1s_7h50=BEGMZHHiogk8FXbtty03Gg@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: limit read/write/trans buffer size not to
 exceed MAX_STREAM_PROT_LEN
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021=EB=85=84 10=EC=9B=94 8=EC=9D=BC (=EA=B8=88) =EC=98=A4=ED=9B=84 12:29, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> ksmbd limit read/write/trans buffer size not to exceed
> maximum stream protocol length(0x00FFFFFF).
>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph B=C3=B6hme <slow@samba.org>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  v2:
>   - change 8MB limitation to MAX_STREAM_PROT_LEN.
>
>  fs/ksmbd/smb2ops.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/ksmbd/smb2ops.c b/fs/ksmbd/smb2ops.c
> index b06456eb587b..63289872da97 100644
> --- a/fs/ksmbd/smb2ops.c
> +++ b/fs/ksmbd/smb2ops.c
> @@ -284,6 +284,7 @@ int init_smb3_11_server(struct ksmbd_conn *conn)
>
>  void init_smb2_max_read_size(unsigned int sz)
>  {
> +       sz =3D min_t(u32, sz, MAX_STREAM_PROT_LEN);

If the maximum read size is MAX_STREAM_PROT_LEN, couldn't headers +
data exceed MAX_STREAM_PROT_LEN?

>         smb21_server_values.max_read_size =3D sz;
>         smb30_server_values.max_read_size =3D sz;
>         smb302_server_values.max_read_size =3D sz;
> @@ -292,6 +293,7 @@ void init_smb2_max_read_size(unsigned int sz)
>
>  void init_smb2_max_write_size(unsigned int sz)
>  {
> +       sz =3D min_t(u32, sz, MAX_STREAM_PROT_LEN);
>         smb21_server_values.max_write_size =3D sz;
>         smb30_server_values.max_write_size =3D sz;
>         smb302_server_values.max_write_size =3D sz;
> @@ -300,6 +302,7 @@ void init_smb2_max_write_size(unsigned int sz)
>
>  void init_smb2_max_trans_size(unsigned int sz)
>  {
> +       sz =3D min_t(u32, sz, MAX_STREAM_PROT_LEN);
>         smb21_server_values.max_trans_size =3D sz;
>         smb30_server_values.max_trans_size =3D sz;
>         smb302_server_values.max_trans_size =3D sz;
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
