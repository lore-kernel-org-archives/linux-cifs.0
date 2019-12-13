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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3CACC43603
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Dec 2019 00:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 858482073B
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Dec 2019 00:26:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lze7pUTA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731429AbfLMA0D (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Dec 2019 19:26:03 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41291 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731326AbfLMA0D (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Dec 2019 19:26:03 -0500
Received: by mail-lj1-f195.google.com with SMTP id h23so658811ljc.8
        for <linux-cifs@vger.kernel.org>; Thu, 12 Dec 2019 16:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hWLmM8mi1kGB1FUtypR8kCQH9/00xSh+Q8Zqyref3Rw=;
        b=Lze7pUTAArgUgJXkpQJfIGeOkAwvAUWlHIz+sxzXMCO1YPjPOEPVva7JsuidwCFcUv
         w8OM3nZRnnWS9nS+/J5VXmi/dadUOVJUxFO8SXuzSmJm6to8Z0/cwA9dRLo7Iz5BJZR4
         NVtcfrS0IToLB+1CkfiEWc/J9+5wuxLdLnOrQUn4BTUHtialImeXtwxkHi2/+Mo8cNHf
         6V4pKEtgTAUT6APeaHlYZVwqmGJl1RYyTuY+o/jJDh8UAhGQHIivgUw9yaLikbXeJtmW
         jebSwVvqboiVcrJXfJKSA2K1CAbWN29kvQJbJ/Ulz3GS7Jz8/vbg1FObUtkLmmH/PBhU
         vsmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hWLmM8mi1kGB1FUtypR8kCQH9/00xSh+Q8Zqyref3Rw=;
        b=VaTIQF1LHMjXHi479vhi72aucBmqd50pHKPRwlNM+Isd9/Q/t5johsv07vfL2lXPCg
         Orft5Y0Mx4g29EvVqmUoNU7QoejXASOoyXbS3rROMJb1EFKp/wsIiqYVBsKmKHkV7MQ4
         XYb2M0yQDDQvWbyfteGRdYBc8buH15Qp9BIjQ4tNvVMJazz+Bn/96N0PH8+fAP7pv2GE
         V0dVwb+eSsErthRMuUrV4dEuuJxZO4pPGHALXEi9MXA+QaaqjF4F6LqHqKPPuIkNkBNA
         2Va4ux06F+jJzp/WYjvR8hT1/F6ppTlEO4/tjROBHxIQ+3br/cQXTZKrTM/GwA0ukZty
         YZdQ==
X-Gm-Message-State: APjAAAX9BZCEf/gPQMeQ6Om836rNvoNTUSxyed0uHLp6GjBNC8C3Tcmh
        kRDTTnx0zEDASfZJyuAnmAbfRTerKHBN7zwPrw==
X-Google-Smtp-Source: APXvYqzNQEqeqGkZCIIEG8jZzdqXUkwQv33+ZRRu5dLZAjYAUqUz5kaXkghRYEpBbIoIpzfitljZZ1aAPqRGXsw0ysI=
X-Received: by 2002:a2e:2d11:: with SMTP id t17mr7538216ljt.177.1576196761189;
 Thu, 12 Dec 2019 16:26:01 -0800 (PST)
MIME-Version: 1.0
References: <20191113170126.23372-1-kdsouza@redhat.com>
In-Reply-To: <20191113170126.23372-1-kdsouza@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 12 Dec 2019 16:25:50 -0800
Message-ID: <CAKywueQD+CFBEoySuS493-JJJoMGENp_EkZayOeN8JMrrVRhLg@mail.gmail.com>
Subject: Re: [PATCH] Add support for smb3 alias/fstype in mount.cifs.c
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

=D1=81=D1=80, 13 =D0=BD=D0=BE=D1=8F=D0=B1. 2019 =D0=B3. =D0=B2 09:01, Kenne=
th D'souza <kdsouza@redhat.com>:
>
> As we will slowly move towards smb3 filesystem,
> supporting through "mount -t smb3" is important.
>
> Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
> ---
>  Makefile.am    |  4 ++++
>  mount.cifs.c   |  8 +++++++-
>  mount.cifs.rst | 12 +++++++++---
>  3 files changed, 20 insertions(+), 4 deletions(-)
>
> diff --git a/Makefile.am b/Makefile.am
> index 8291b99..1af2573 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -111,3 +111,7 @@ CLEANFILES +=3D $(rst_man_pages)
>  endif
>
>  SUBDIRS =3D contrib
> +
> +install-exec-hook:
> +       (cd $(ROOTSBINDIR) && ln -sf mount.cifs mount.smb3)
> +       (cd $(man8dir) && ln -sf mount.cifs.8 mount.smb3.8)
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 6935fe1..0ed9d0a 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -192,7 +192,7 @@ struct parsed_mount_info {
>  };
>
>  static const char *thisprogram;
> -static const char *cifs_fstype =3D "cifs";
> +static const char *cifs_fstype;
>
>  static int parse_unc(const char *unc_name, struct parsed_mount_info *par=
sed_info);
>
> @@ -1986,6 +1986,12 @@ int main(int argc, char **argv)
>         if (thisprogram =3D=3D NULL)
>                 thisprogram =3D "mount.cifs";
>
> +       if(strcmp(thisprogram, "mount.cifs") =3D=3D 0)
> +               cifs_fstype =3D "cifs";
> +
> +        if(strcmp(thisprogram, "mount.smb3") =3D=3D 0)
> +              cifs_fstype =3D "smb3";
> +
>         /* allocate parsed_info as shared anonymous memory range */
>         parsed_info =3D mmap((void *)0, sizeof(*parsed_info), PROT_READ |=
 PROT_WRITE,
>                            MAP_ANONYMOUS | MAP_SHARED, -1, 0);
> diff --git a/mount.cifs.rst b/mount.cifs.rst
> index ee5086c..67ec629 100644
> --- a/mount.cifs.rst
> +++ b/mount.cifs.rst
> @@ -1,6 +1,6 @@
> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> -mount.cifs
> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +mount.cifs mount.smb3
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  --------------------------------------------------
>  mount using the Common Internet File System (CIFS)
> @@ -23,6 +23,12 @@ protocol and is supported by most Windows servers, Azu=
re (cloud storage),
>  Macs and many other commercial servers and Network Attached Storage
>  appliances as well as by the popular Open Source server Samba.
>
> +``mount.smb3`` mounts only SMB3 filesystem. It is usually invoked
> +indirectly by the mount(8) command when using the "-t smb3" option.
> +The ``smb3`` filesystem type was added in kernel-4.18 and above.
> +It works in a similar fashion as mount.cifs except it passes filesystem
> +type as smb3.
> +
>  The mount.cifs utility attaches the UNC name (exported network
>  resource) specified as service (using ``//server/share`` syntax, where
>  "server" is the server name or IP address and "share" is the name of
> --
> 2.21.0
>

Merged, thanks.
--
Best regards,
Pavel Shilovsky
