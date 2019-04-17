Return-Path: <SRS0=xEhF=ST=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F9FC282DA
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Apr 2019 21:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A016E2184B
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Apr 2019 21:47:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ECWjDoa5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729500AbfDQVr3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Apr 2019 17:47:29 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43159 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbfDQVr3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 Apr 2019 17:47:29 -0400
Received: by mail-lj1-f193.google.com with SMTP id f18so45169lja.10
        for <linux-cifs@vger.kernel.org>; Wed, 17 Apr 2019 14:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VYNpzIlG7kyxsnF020g4xfmgbXgsBCSSkMyojWCBsyM=;
        b=ECWjDoa5OTM6e0eMESdQpEhmWf2JaVgoIxPBFNfdgMI+I481UzfCHK0ly4nz2MnhPH
         sNoq/K5ONMtPEP+Sg1gBCIiT3WjZHjykgTiw86gsrR7ZyDCcYz7ZKFKurTgompJey6SC
         /q7oREB6yTaVzumd4TcECRyQhpDUQEcTR60spcfoBopkNrem5C4mnqNWs/wMsEe4Jx8o
         LEuGC0+whPQUcbiKqeLu3EkoQxJYLKzzNjwRenfsMHzVdxye93Q7dFfmnXeyBZWuWqY+
         n5wE0tQgWc/IuEKkb94F88Fhzn40LmcOCMToS9fnHB1qlkQZnOEITGmDCvgENRRTnadm
         0w9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VYNpzIlG7kyxsnF020g4xfmgbXgsBCSSkMyojWCBsyM=;
        b=YUhtuR366AGcePK8GcP9F5wni1utZNrmpfvC3/ud9gUSDk8ltvYcCpgtMg5Ij3HKhE
         x+8nn7/L2T+L4xkTQJTyFIgP6ebTbBCQ5G/G8LXOTMAtQVn94BsK14sdC7ruxxp9OuRs
         MSg6E414tdnGf2FSVs7OUV2qS3G8TYCfiFPc71oaygs/y5bBKuOtqWBMtOPmszGURl7v
         E2pSA2MXrLHYAN36Eoi6TWoA/NnMUtizYYPm57Pd6iYZg6yY0IQhEShCqBslVTtVGANR
         lnIMyWE0aP7ZbydmVGPcAA+oVP4zSR3xkPv46LzFtxq33CiWt6Mvq31zYRApTy1InLTt
         kG0w==
X-Gm-Message-State: APjAAAVj42aW2ZHbpxV8qb/wbbH+wDKS1aZ4JUbsVzEYV96+gE2CD7n2
        eMUNslr3u4uKKEuguOGB4nqvuF+Jul4PnsVbGBhz614=
X-Google-Smtp-Source: APXvYqz63LwEWPghuW7WIAK7feutmC6RskUzb3c1AKSBDAu3tzl2T+3Xk4x7Kj2c1gAf4h5WaZy80Ihv1ODDSdJyQoE=
X-Received: by 2002:a2e:9585:: with SMTP id w5mr10637404ljh.132.1555537646653;
 Wed, 17 Apr 2019 14:47:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190411022307.26463-1-lsahlber@redhat.com> <20190411022307.26463-3-lsahlber@redhat.com>
In-Reply-To: <20190411022307.26463-3-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 17 Apr 2019 14:47:15 -0700
Message-ID: <CAKywueTAjbRsmUFpO=u_=wCmjC2xdoW2vO4QmARD=c4Yjyd3-Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] smbinfo: Add SETCOMPRESSION support
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

=D1=81=D1=80, 10 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 19:24, Ronnie Sahl=
berg <lsahlber@redhat.com>:
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  smbinfo.c   | 28 ++++++++++++++++++++++++++++
>  smbinfo.rst |  5 +++++
>  2 files changed, 33 insertions(+)
>
> diff --git a/smbinfo.c b/smbinfo.c
> index db569b2..b87cca4 100644
> --- a/smbinfo.c
> +++ b/smbinfo.c
> @@ -89,6 +89,8 @@ usage(char *name)
>                 "      Prints the objectid of the file and GUID of the un=
derlying volume.\n"
>                 "  getcompression:\n"
>                 "      Prints the compression setting for the file.\n"
> +               "  setcompression <0|1|2>:\n"
> +               "      Sets the compression level for the file.\n"
>                 "  list-snapshots:\n"
>                 "      List the previous versions of the volume that back=
s this file.\n"
>                 "  quota:\n"
> @@ -289,6 +291,30 @@ getcompression(int f)
>  }
>
>  static void
> +setcompression(int f, uint16_t level)
> +{
> +       struct smb_query_info *qi;
> +
> +       qi =3D malloc(sizeof(struct smb_query_info) + 2);
> +       memset(qi, 0, sizeof(qi) + 2);
> +       qi->info_type =3D 0x9c040;
> +       qi->file_info_class =3D 0;
> +       qi->additional_information =3D 0;
> +       qi->output_buffer_length =3D 2;
> +       qi->flags =3D PASSTHRU_FSCTL;
> +
> +       level =3D htole16(level);
> +       memcpy(&qi[1], &level, 2);
> +
> +       if (ioctl(f, CIFS_QUERY_INFO, qi) < 0) {
> +               fprintf(stderr, "ioctl failed with %s\n", strerror(errno)=
);
> +               exit(1);
> +       }
> +
> +       free(qi);
> +}
> +
> +static void
>  print_fileaccessinfo(uint8_t *sd, int type)
>  {
>         uint32_t access_flags;
> @@ -1166,6 +1192,8 @@ int main(int argc, char *argv[])
>                 fsctlgetobjid(f);
>         else if (!strcmp(argv[optind], "getcompression"))
>                 getcompression(f);
> +       else if (!strcmp(argv[optind], "setcompression"))
> +               setcompression(f, strtol(argv[optind + 2], NULL, 10));
>         else if (!strcmp(argv[optind], "list-snapshots"))
>                 list_snapshots(f);
>         else if (!strcmp(argv[optind], "quota"))
> diff --git a/smbinfo.rst b/smbinfo.rst
> index ca99b07..af97b7f 100644
> --- a/smbinfo.rst
> +++ b/smbinfo.rst
> @@ -66,6 +66,11 @@ COMMAND
>
>  `getcompression`: Prints the compression setting for the file.
>
> +`setcompression <0|1|2>`: Sets the compression setting for the file.
> +- 0 No compression
> +- 1 Default compression
> +- 2 LZNT1

0, 1 and 2 don't look obvious, how about "no", "default", "lznt1"?
--
Best regards,
Pavel Shilovsky
