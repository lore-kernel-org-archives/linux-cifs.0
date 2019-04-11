Return-Path: <SRS0=pabO=SN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A140BC10F11
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Apr 2019 02:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E214206DF
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Apr 2019 02:48:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dg3Te66p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfDKCsy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Apr 2019 22:48:54 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43934 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfDKCsx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Apr 2019 22:48:53 -0400
Received: by mail-pf1-f193.google.com with SMTP id c8so2639196pfd.10;
        Wed, 10 Apr 2019 19:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sdva2oyqaplkf1GRVeL/SMW70s7hCUxzVKBozYE4QPA=;
        b=Dg3Te66pVoX9glxYX5v+25zPz2HA2TY1IREfUGioeiqaXXwW9UqUSGdrXHtJ07GNmA
         GNGo0BGwPC/nOL958AFdyPDI29NejLryEd4L6yRzQ/6JcUCK2dKOVtviC/nbyRuhbjwS
         noR1vVsOvYB0N2L1sypPr19Bto/zYZRUw43llwOHG5L5mlF1YRmniY867SllGWjASfah
         d/Uvu8v44T7q0CHkcSDnmLLv+IRIwPw15Lz+02BiI2hNMtB6dpRaG7BEl8CoVvHcnDfI
         XL43PLrcrHjYzTkXczUZ1OgemEoNHFymPG8kxnpS8cW3UzSqHlppiK8fwVNROBtUC5J8
         cgFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sdva2oyqaplkf1GRVeL/SMW70s7hCUxzVKBozYE4QPA=;
        b=JTOhS/V7Aa6hWibN0qCifPKlEXB6EFY310sXsfHK3NYQHOkdI+846Kh2iIFAClZvc/
         f6Pl07wjI/Lcz78HVmYZChw5z/8Gb3h8UOJl4/sL//cjVA/sJvWCUvITK4Sk/FYri4ob
         kBRAbhdmQxyMNn8hDcgSU+p6zgK9APS40D2u6eIalYQFws0k8hta40uiQ77OxBF80gHR
         XtKf/5XDKtOrG+Q0w3sNEAp5urTZWZAYgJI47d7/aLZj9TWT/yDoZfHV0Emi3X21T6de
         zW2E1JJfJesovOnOcCLbBoLF/W4kISvEDpSg4w6hRklzsi2rnCPnDeCc59KF1dtXlian
         MiAQ==
X-Gm-Message-State: APjAAAX6TxGsoovqLMoh4kMZ6yh6Ldow2bEoXdBdsO8EBlxLUCg1XzuI
        YsfRSq+0kaAzTlfxVeqA++L//509LN9HqIN+yVv0sg==
X-Google-Smtp-Source: APXvYqxm90rSWnMyUFEXBszjM4rB5Az4a1J0wggq7NBzZXjWaSrbnhHGu5nlhZorD3AoICmEbwh56s17c9tUTc0b4hY=
X-Received: by 2002:a62:59cb:: with SMTP id k72mr47791388pfj.111.1554950932986;
 Wed, 10 Apr 2019 19:48:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190411022017.24942-1-lsahlber@redhat.com> <20190411022017.24942-2-lsahlber@redhat.com>
In-Reply-To: <20190411022017.24942-2-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 10 Apr 2019 21:48:41 -0500
Message-ID: <CAH2r5ms0+y4sYJdw=FHMS3Yfz10Fp6zovvZqMDCPdZnOkmo5Pw@mail.gmail.com>
Subject: Re: [PATCH] cifs: Add support for FSCTL passthrough that write data
 to the server
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next

On Wed, Apr 10, 2019 at 9:20 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Add support to pass a blob to the server in FSCTL passthrough.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2ops.c  | 17 +++++++++++++++--
>  fs/cifs/smbfsctl.h | 27 +++++++++++++++++++++++++++
>  2 files changed, 42 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 83a100dd2497..bb7522b882ea 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1382,6 +1382,18 @@ smb2_ioctl_query_info(const unsigned int xid,
>         oparms.fid = &fid;
>         oparms.reconnect = false;
>
> +       /*
> +        * FSCTL codes encode the special access they need in the fsctl code.
> +        */
> +       if (qi.flags & PASSTHRU_FSCTL) {
> +               switch (qi.info_type & FSCTL_DEVICE_ACCESS_MASK) {
> +               case FSCTL_DEVICE_ACCESS_FILE_READ_WRITE_ACCESS:
> +                       oparms.desired_access = FILE_READ_DATA | FILE_WRITE_DATA | FILE_READ_ATTRIBUTES | SYNCHRONIZE;
> +                       ;
> +                       break;
> +               }
> +       }
> +
>         rc = SMB2_open_init(tcon, &rqst[0], &oplock, &oparms, path);
>         if (rc)
>                 goto iqinf_exit;
> @@ -1399,8 +1411,9 @@ smb2_ioctl_query_info(const unsigned int xid,
>
>                         rc = SMB2_ioctl_init(tcon, &rqst[1],
>                                              COMPOUND_FID, COMPOUND_FID,
> -                                            qi.info_type, true, NULL,
> -                                            0, CIFSMaxBufSize);
> +                                            qi.info_type, true, buffer,
> +                                            qi.output_buffer_length,
> +                                            CIFSMaxBufSize);
>                 }
>         } else if (qi.flags == PASSTHRU_QUERY_INFO) {
>                 memset(&qi_iov, 0, sizeof(qi_iov));
> diff --git a/fs/cifs/smbfsctl.h b/fs/cifs/smbfsctl.h
> index f996daeea271..9b3459b9a5ce 100644
> --- a/fs/cifs/smbfsctl.h
> +++ b/fs/cifs/smbfsctl.h
> @@ -35,6 +35,33 @@
>   * below). Additional detail on less common ones can be found in MS-FSCC
>   * section 2.3.
>   */
> +
> +/*
> + * FSCTL values are 32 bits and are constructed as
> + * <device 16bits> <access 2bits> <function 12bits> <method 2bits>
> + */
> +/* Device */
> +#define FSCTL_DEVICE_DFS                 (0x0006 << 16)
> +#define FSCTL_DEVICE_FILE_SYSTEM         (0x0009 << 16)
> +#define FSCTL_DEVICE_NAMED_PIPE          (0x0011 << 16)
> +#define FSCTL_DEVICE_NETWORK_FILE_SYSTEM (0x0014 << 16)
> +#define FSCTL_DEVICE_MASK                0xffff0000
> +/* Access */
> +#define FSCTL_DEVICE_ACCESS_FILE_ANY_ACCESS        (0x00 << 14)
> +#define FSCTL_DEVICE_ACCESS_FILE_READ_ACCESS       (0x01 << 14)
> +#define FSCTL_DEVICE_ACCESS_FILE_WRITE_ACCESS      (0x02 << 14)
> +#define FSCTL_DEVICE_ACCESS_FILE_READ_WRITE_ACCESS (0x03 << 14)
> +#define FSCTL_DEVICE_ACCESS_MASK                   0x0000c000
> +/* Function */
> +#define FSCTL_DEVICE_FUNCTION_MASK       0x00003ffc
> +/* Method */
> +#define FSCTL_DEVICE_METHOD_BUFFERED   0x00
> +#define FSCTL_DEVICE_METHOD_IN_DIRECT  0x01
> +#define FSCTL_DEVICE_METHOD_OUT_DIRECT 0x02
> +#define FSCTL_DEVICE_METHOD_NEITHER    0x03
> +#define FSCTL_DEVICE_METHOD_MASK       0x00000003
> +
> +
>  #define FSCTL_DFS_GET_REFERRALS      0x00060194
>  #define FSCTL_DFS_GET_REFERRALS_EX   0x000601B0
>  #define FSCTL_REQUEST_OPLOCK_LEVEL_1 0x00090000
> --
> 2.13.6
>


-- 
Thanks,

Steve
