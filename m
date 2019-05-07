Return-Path: <SRS0=vQ6B=TH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA43FC004C9
	for <linux-cifs@archiver.kernel.org>; Tue,  7 May 2019 22:54:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85A7620C01
	for <linux-cifs@archiver.kernel.org>; Tue,  7 May 2019 22:54:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DdDM34Xq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbfEGWyQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 May 2019 18:54:16 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36560 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfEGWyP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 May 2019 18:54:15 -0400
Received: by mail-lj1-f195.google.com with SMTP id z1so3566841ljb.3
        for <linux-cifs@vger.kernel.org>; Tue, 07 May 2019 15:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6DDwu4hVnxc3f7TFNvrB0BVpA53RFdTyHqsfcM+9Plo=;
        b=DdDM34XqGL79nY+B+HOJvrXZbcccBZAagiWHANn8eOAh04GHd7Nsl9GxHwXzEkEJQp
         Rgrtim+L41nZKBLDv49/YikwhYJwUxeHcP7TZYOAA++lkTAbDe7TP2W242PTMH6xZT8S
         jRcNA069e2i1tMPwF6hMIeHfJI+ExwFYV2W4H7e2nXGejKGsf9pMEf1TO8MxaiSrOJ/N
         UIPa4yQMZpCfwI2TR/etPaYzL37RahzdY+/87FrwFXIL0BhmNzys0BNovKtZXPOz9M6o
         iQ4Hmgb+OFjwkd4iJsxinuI6v0Xn4j/DNG8X26V65JqVAcFEe3Yin8NeQdfl4Kt1Zfc5
         WykQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6DDwu4hVnxc3f7TFNvrB0BVpA53RFdTyHqsfcM+9Plo=;
        b=umMSeO/aNSooaNS280J0wlJjta+qno/U7LniXL/n2Hsga/Q/S1UotginXUYzl5Nh84
         iAteSnBwdYsPbGaLsmWoAG4hwqUQ/kLaE7OKdMO+uQpAPCXe1uLz3jqA+5Jd+ZK/4G1o
         rTe9R1knRs0cSuC9D1v9rTaikXPO6D0m/cwbiDk8cHzIeW8J3PZT+Y7yOf4M62nrMpj4
         EX+xulDU9D/ZNe0MhHBBzuw9YM1m80TaAB91ZpcSJ1oLQp7rWdqnM6VftqEx09rHW9xb
         E+G+DE53Tyndk+PudiAIVk5kW7tGRb3Iwl76quRmTB08xguD1H/81J4zOzwT0dyCTUpo
         khLg==
X-Gm-Message-State: APjAAAVXdhIv6lyN5BO6UMgat74mLal297sdOaHp2RV9rMOJ8xYppmMK
        /NkmWk+S7fs49n8jHDPvA+AETLWlhLgIJy/Q3A==
X-Google-Smtp-Source: APXvYqxxIxJo9KXKVpupV2PLz7ZKwYKqyC12gerAucaG6bjQb/OC+SStHHG4fJ9hDMOqhBu2IC1vS48Yj59UbNCu5Mw=
X-Received: by 2002:a2e:9d4c:: with SMTP id y12mr18606649ljj.132.1557269653648;
 Tue, 07 May 2019 15:54:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190411022307.26463-1-lsahlber@redhat.com> <20190411022307.26463-2-lsahlber@redhat.com>
In-Reply-To: <20190411022307.26463-2-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 7 May 2019 15:54:02 -0700
Message-ID: <CAKywueSb=-JY8-uL=M=8nr7vEHPq1MJXWPPvaxnYGPM332vxSQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] smbinfo: add GETCOMPRESSION support
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D1=80, 10 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 19:23, Ronnie Sahl=
berg <lsahlber@redhat.com>:
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  smbinfo.c   | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  smbinfo.rst |  2 ++
>  2 files changed, 50 insertions(+)
>
> diff --git a/smbinfo.c b/smbinfo.c
> index 4bc503a..db569b2 100644
> --- a/smbinfo.c
> +++ b/smbinfo.c
> @@ -87,6 +87,8 @@ usage(char *name)
>                 "      Prints FileStandardInfo for a cifs file.\n"
>                 "  fsctl-getobjid:\n"
>                 "      Prints the objectid of the file and GUID of the un=
derlying volume.\n"
> +               "  getcompression:\n"
> +               "      Prints the compression setting for the file.\n"
>                 "  list-snapshots:\n"
>                 "      List the previous versions of the volume that back=
s this file.\n"
>                 "  quota:\n"
> @@ -243,6 +245,50 @@ fsctlgetobjid(int f)
>  }
>
>  static void
> +print_getcompression(uint8_t *sd)
> +{
> +       uint16_t u16;
> +
> +       memcpy(&u16, &sd[0], 2);
> +       u16 =3D le16toh(u16);
> +
> +       printf("Compression: ");
> +       switch (u16) {
> +       case 0:
> +               printf("(0) NONE\n");
> +               break;
> +       case 2:
> +               printf("(2) LZNT1\n");
> +               break;
> +       default:
> +               printf("(%d) UNKNOWN\n", u16);
> +               break;
> +       }
> +}
> +
> +static void
> +getcompression(int f)
> +{
> +       struct smb_query_info *qi;
> +
> +       qi =3D malloc(sizeof(struct smb_query_info) + 2);
> +       memset(qi, 0, sizeof(qi) + 2);
> +       qi->info_type =3D 0x9003c;
> +       qi->file_info_class =3D 0;
> +       qi->additional_information =3D 0;
> +       qi->input_buffer_length =3D 2;
> +       qi->flags =3D PASSTHRU_FSCTL;
> +
> +       if (ioctl(f, CIFS_QUERY_INFO, qi) < 0) {
> +               fprintf(stderr, "ioctl failed with %s\n", strerror(errno)=
);
> +               exit(1);
> +       }
> +       print_getcompression((uint8_t *)(&qi[1]));
> +
> +       free(qi);
> +}
> +
> +static void
>  print_fileaccessinfo(uint8_t *sd, int type)
>  {
>         uint32_t access_flags;
> @@ -1118,6 +1164,8 @@ int main(int argc, char *argv[])
>                 filestandardinfo(f);
>         else if (!strcmp(argv[optind], "fsctl-getobjid"))
>                 fsctlgetobjid(f);
> +       else if (!strcmp(argv[optind], "getcompression"))
> +               getcompression(f);
>         else if (!strcmp(argv[optind], "list-snapshots"))
>                 list_snapshots(f);
>         else if (!strcmp(argv[optind], "quota"))
> diff --git a/smbinfo.rst b/smbinfo.rst
> index 0c96050..ca99b07 100644
> --- a/smbinfo.rst
> +++ b/smbinfo.rst
> @@ -64,6 +64,8 @@ COMMAND
>
>  `fsctl-getobjid`: Prints the ObjectID
>
> +`getcompression`: Prints the compression setting for the file.
> +
>  `list-snapshots`: Lists the previous versions of the volume that backs t=
his file
>
>  `quota`: Print the quota for the volume in the form
> --
> 2.13.6
>

Merged into "next" branch. Thanks.

--
Best regards,
Pavel Shilovsky
