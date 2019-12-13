Return-Path: <SRS0=IAhR=2D=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC64DC43603
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Dec 2019 00:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4E882073B
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Dec 2019 00:29:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a7Ps6kHG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731326AbfLMA3v (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Dec 2019 19:29:51 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46290 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731206AbfLMA3v (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Dec 2019 19:29:51 -0500
Received: by mail-lf1-f65.google.com with SMTP id f15so609952lfl.13
        for <linux-cifs@vger.kernel.org>; Thu, 12 Dec 2019 16:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QNEe5ikCHwRAIXAi2Z3nP6w72nIOYq7jDwRE3wFc9GI=;
        b=a7Ps6kHGBaWVR0be9zdRJ4NRccPD9LVtdhg9vGKLlWyPEgL8ciS3wZEJBtKfErzrG7
         8pnw0Gcl04cIVXKdRvuZYOk8S44yrPJkMX6Mgi1mi5oW5HVeVMmtOY0MR9IR70I8DuM6
         9Y3qvqhCoMvARaICcdIicpf9AYJVVSK+O39M7wQm7WoolvnFHHf4Zp6OWfgbBdiXH6Nn
         xqEvBRaECIoBRyKFtVOSQ2cbph41QjZCiDFDzSbO9rioREPZAQeqgz0IJ6fg83x/JeiF
         MNJcWRwozuXesCGWXVwDtnFyYIorGEvNQRG6LLkriLn9GxCXDnC8n3xjyDjjF3TeAP7Q
         oiFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QNEe5ikCHwRAIXAi2Z3nP6w72nIOYq7jDwRE3wFc9GI=;
        b=Cpa/zWr0CqO7MzT36OJ3eIM5MQscWpd9+57uFqhLG+xs3M2A3x2zQFjpJwLxv97vIg
         AGHFI7yz149SCEiVMA+YyLhJbZ2E1++7cpRCNwEBBtQ47Ww3rdn2SqD4Cdx4adDbJqAC
         7ZV21MBtrFgXFrHz6HCNMdvgceHB9Scs/o2sIX/krV1bwB24fzdYajBIjdKCdVkA/yjA
         fWpgKtf31LtCuy9AOzU5iIgkpgbaIVOc52Cb9Hp2y/A78ieGttBWhbIuyYerfSBTcsKd
         LVMD4GnSleHEPhw0yJQDFvbJ++uWltOMX6EWbWwaA3BKLLlJxxv9rH28N3oBG8UVtIVp
         Youw==
X-Gm-Message-State: APjAAAV8NbupGju1FjdUZuxH6lKI7YknSna12EIJ+nJQY7irMCcA8nvr
        JQlNSGeV6xENuLIRHa7hq8Kcym2KHCaT4p0nHZ++u5s=
X-Google-Smtp-Source: APXvYqzeX3jP4ml3A+EnqhBYHlVr4cmixG8enoiv7eZdYaz2XEJum1WjnWrQ+jDpc1cEdL8vSWy5XSXaT7EgBs36AKg=
X-Received: by 2002:a19:c697:: with SMTP id w145mr7118489lff.54.1576196988176;
 Thu, 12 Dec 2019 16:29:48 -0800 (PST)
MIME-Version: 1.0
References: <20191121151056.19392-1-kdsouza@redhat.com>
In-Reply-To: <20191121151056.19392-1-kdsouza@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 12 Dec 2019 16:29:36 -0800
Message-ID: <CAKywueRk0h7+8neHcAMoQaX4kcEmxVtBS4GLLmdgmAyxY6hcvg@mail.gmail.com>
Subject: Re: [PATCH] smb2-quota: Simplify code logic for quota entries.
To:     "Kenneth D'souza" <kdsouza@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 21 =D0=BD=D0=BE=D1=8F=D0=B1. 2019 =D0=B3. =D0=B2 07:11, Kenne=
th D'souza <kdsouza@redhat.com>:
>
> This patch changes the program name from smb2quota to
> smb2-quota and uses a simple code logic for quota entries.
>
> Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
> Signed-off-by: Ronnie Sahlberg <lsahlberg@redhat.com>
> ---
>  smb2quota.py =3D> smb2-quota.py   | 19 +++++++------------
>  smb2quota.rst =3D> smb2-quota.rst |  8 ++++----
>  2 files changed, 11 insertions(+), 16 deletions(-)
>  rename smb2quota.py =3D> smb2-quota.py (91%)
>  rename smb2quota.rst =3D> smb2-quota.rst (89%)
>
> diff --git a/smb2quota.py b/smb2-quota.py
> similarity index 91%
> rename from smb2quota.py
> rename to smb2-quota.py
> index 21bf4ff..6d0b8a3 100755
> --- a/smb2quota.py
> +++ b/smb2-quota.py
> @@ -1,7 +1,7 @@
>  #!/usr/bin/env python
>  # coding: utf-8
>  #
> -# smb2quota is a cmdline tool to display quota information for the
> +# smb2-quota is a cmdline tool to display quota information for the
>  # Linux SMB client file system (CIFS)
>  #
>  # Copyright (C) Ronnie Sahlberg (lsahlberg@redhat.com) 2019
> @@ -34,7 +34,7 @@ ENDC =3D '\033[m'   # Rest to defaults
>
>  def usage():
>      print("Usage: %s [-h] <options> <filename>" % sys.argv[0])
> -    print("Try 'smb2quota -h' for more information")
> +    print("Try 'smb2-quota -h' for more information")
>      sys.exit()
>
>
> @@ -120,18 +120,13 @@ class QuotaEntry:
>  class Quota:
>      def __init__(self, buf, flag):
>          self.quota =3D []
> -        s =3D struct.unpack_from('<I', buf, 0)[0]
> -        while s:
> -            qe =3D QuotaEntry(buf[0:s], flag)
> +        while buf:
> +            qe =3D QuotaEntry(buf, flag)
>              self.quota.append(qe)
> -            buf =3D buf[s:]
> -            a =3D s
>              s =3D struct.unpack_from('<I', buf, 0)[0]
>              if s =3D=3D 0:
> -                s =3D a   # Use the last value of s and process it.
> -                qe =3D QuotaEntry(buf[0:s], flag)
> -                self.quota.append(qe)
>                  break
> +            buf =3D buf[s:]
>
>      def __str__(self):
>          s =3D ''
> @@ -158,7 +153,7 @@ def parser_check(path, flag):
>          fcntl.ioctl(f, CIFS_QUERY_INFO, buf, 1)
>          os.close(f)
>          if flag =3D=3D 0:
> -            print(BBOLD + " %-7s | %-7s | %-7s | %-7s | %-12s | %s " + E=
NDC) % (titleused, titlelim, titlethr, titlepercent, titlestatus, titlesid)
> +            print((BBOLD + " %-7s | %-7s | %-7s | %-7s | %-12s | %s " + =
ENDC) % (titleused, titlelim, titlethr, titlepercent, titlestatus, titlesid=
))
>          q =3D Quota(buf[24:24 + struct.unpack_from('<I', buf, 16)[0]], f=
lag)
>          print(q)
>      except IOError as reason:
> @@ -171,7 +166,7 @@ def main():
>      if len(sys.argv) < 2:
>          usage()
>
> -    parser =3D argparse.ArgumentParser(description=3D"Please specify an =
action to perform.", prog=3D"smb2quota")
> +    parser =3D argparse.ArgumentParser(description=3D"Please specify an =
action to perform.", prog=3D"smb2-quota")
>      parser.add_argument("-t", "--tabular", action=3D"store_true", help=
=3D"print quota information in tabular format")
>      parser.add_argument("-c", "--csv",  action=3D"store_true", help=3D"p=
rint quota information in csv format")
>      parser.add_argument("-l", "--list", action=3D"store_true", help=3D"p=
rint quota information in list format")
> diff --git a/smb2quota.rst b/smb2-quota.rst
> similarity index 89%
> rename from smb2quota.rst
> rename to smb2-quota.rst
> index 24caca8..508b874 100644
> --- a/smb2quota.rst
> +++ b/smb2-quota.rst
> @@ -1,5 +1,5 @@
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> -smb2quota
> +smb2-quota
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  ------------------------------------------------------------------------=
-----------------------------
> @@ -11,7 +11,7 @@ Userspace helper to display quota information for the L=
inux SMB client file syst
>  SYNOPSIS
>  ********
>
> -  smb2quota [-h] {options} {file system object}
> +  smb2-quota [-h] {options} {file system object}
>
>  ***********
>  DESCRIPTION
> @@ -19,7 +19,7 @@ DESCRIPTION
>
>  This tool is part of the cifs-utils suite.
>
> -`smb2quota` is a userspace helper program for the Linux SMB
> +`smb2-quota` is a userspace helper program for the Linux SMB
>  client file system (CIFS).
>
>  This tool works by making an CIFS_QUERY_INFO IOCTL call to the Linux
> @@ -49,7 +49,7 @@ SID,Amount Used,Quota Limit,Warning Level
>  NOTES
>  *****
>
> -Kernel support for smb2quota requires the CIFS_QUERY_INFO
> +Kernel support for smb2-quota requires the CIFS_QUERY_INFO
>  IOCTL which was initially introduced in the 4.20 kernel and is only
>  implemented for mount points using SMB2 or above (see mount.cifs(8)
>  `vers` option).
> --
> 2.21.0
>

Merged, thanks.

--
Best regards,
Pavel Shilovsky
