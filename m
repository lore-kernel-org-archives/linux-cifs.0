Return-Path: <SRS0=IAhR=2D=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 755FDC43603
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Dec 2019 00:29:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27C1E2073B
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Dec 2019 00:29:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GdOHTcjt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731382AbfLMA3S (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Dec 2019 19:29:18 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40381 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731326AbfLMA3S (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Dec 2019 19:29:18 -0500
Received: by mail-lf1-f68.google.com with SMTP id i23so633419lfo.7
        for <linux-cifs@vger.kernel.org>; Thu, 12 Dec 2019 16:29:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gbdCJSunO94DkecekKlW4vgWqtbyTrcmEHDo9pspipI=;
        b=GdOHTcjtGnZCUtkfeS6bCxtqluDJVymcXS7ws3ydUETDP7S6fyaU2+5MyAFR5S3c97
         qkP3AdnwdTZZdjEpGaBm9sHtRM8K+Tor6HJGQRd9Bhr0eQoe4dRyx9DcvqEdMpHTIY8Y
         rpmhwdL++IzukSV5oIJbhmUQjcgM5nrdWPefALifqZSNZbPxQD0A28zf+/AZ4xTzcva0
         4YCt6QV/kLnJEuAePrmlSyoz0NIRRg7EmPZNGyFBi3mB3nuZAOsQ1OHQ4DFWc4cQ/EQF
         Hoeb4fEcWTqS4VVhSEZNS1ZmBq4nfWa/p/vtOabLsI+4uAaBk869mPQjDL6tPWmIcfig
         NXlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gbdCJSunO94DkecekKlW4vgWqtbyTrcmEHDo9pspipI=;
        b=QljcqGvESG1PODD4BHHnTy8NirOf3XMUxbSUcmsq/VdTwyzkaOpNHUumKZgwVFumP5
         iM37+qjvSWdiFzoBwyXFpmQL3WhaTh9fn9VBShTgO7TdfyT+rrJU4IwuT+6+b0kPbVA6
         Prn3kdHmO35JMrq9DwQ+m9Mbw6KRZGOvYrTyItWfe9ZxdNQp2olY3aBY5khiFp5/B/Y9
         u9JYnCHl8FdXbjUZ27r6EYUBFHc0n+ISNMGke2qJ9kYf8PL7faIh7zeeFPVnvcWQEC8r
         C+QQ2/WtjTlczTSUytWPlfb7BceENz5wk/eMOaztz+kBIwtLcjVZwlvPZ99QohthM4ot
         UUSg==
X-Gm-Message-State: APjAAAXLHAwMJ+H+7EZSbOhb5nWdmt+PIGMHWLiBHJVf4SyXTmVIY/jX
        a1c5YT+7DlHBoX1pJOnomyjkE4K6DHW3Yyq9Cg==
X-Google-Smtp-Source: APXvYqz7KL3XVDlQUHxM1EhWPWSgrhW605VJPeE+gGx6VIu/aiNuvrrw6YuH+P7Ii0ctAcrFL1FueSM0a0JFi3d/by4=
X-Received: by 2002:ac2:4553:: with SMTP id j19mr7687498lfm.142.1576196954394;
 Thu, 12 Dec 2019 16:29:14 -0800 (PST)
MIME-Version: 1.0
References: <20191114175551.18805-1-kdsouza@redhat.com>
In-Reply-To: <20191114175551.18805-1-kdsouza@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 12 Dec 2019 16:29:02 -0800
Message-ID: <CAKywueSazBaHobqKSgyU6tHw-ScHAcUazsejXdusFB50kGgbkw@mail.gmail.com>
Subject: Re: [PATCH] Add program name to error output instead of static mount.cifs
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

=D1=87=D1=82, 14 =D0=BD=D0=BE=D1=8F=D0=B1. 2019 =D0=B3. =D0=B2 09:55, Kenne=
th D'souza <kdsouza@redhat.com>:
>
> As we are supporting mount.smb3 to be invoked, the error output
> should contain the called program and not mount.cifs
>
> Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
> ---
>  mount.cifs.c | 56 ++++++++++++++++++++++++++--------------------------
>  1 file changed, 28 insertions(+), 28 deletions(-)
>
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 0ed9d0a..40918c1 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -194,7 +194,7 @@ struct parsed_mount_info {
>  static const char *thisprogram;
>  static const char *cifs_fstype;
>
> -static int parse_unc(const char *unc_name, struct parsed_mount_info *par=
sed_info);
> +static int parse_unc(const char *unc_name, struct parsed_mount_info *par=
sed_info, const char *progname);
>
>  static int check_setuid(void)
>  {
> @@ -206,7 +206,7 @@ static int check_setuid(void)
>
>  #if CIFS_DISABLE_SETUID_CAPABILITY
>         if (getuid() && !geteuid()) {
> -               printf("This mount.cifs program has been built with the "
> +               printf("This program has been built with the "
>                        "ability to run as a setuid root program disabled.=
\n");
>                 return EX_USAGE;
>         }
> @@ -301,7 +301,7 @@ static int mount_usage(FILE * stream)
>                 "\n\tbsize=3D<size>");
>         fprintf(stream,
>                 "\n\nOptions are described in more detail in the manual p=
age");
> -       fprintf(stream, "\n\tman 8 mount.cifs\n");
> +       fprintf(stream, "\n\tman 8 %s\n", thisprogram);
>         fprintf(stream, "\nTo display the version number of the mount hel=
per:");
>         fprintf(stream, "\n\t%s -V\n", thisprogram);
>
> @@ -636,7 +636,7 @@ return_i:
>
>  static int
>  get_password_from_file(int file_descript, char *filename,
> -                      struct parsed_mount_info *parsed_info)
> +                      struct parsed_mount_info *parsed_info, const char =
*program)
>  {
>         int rc =3D 0;
>         char buf[sizeof(parsed_info->password) + 1];
> @@ -649,8 +649,8 @@ get_password_from_file(int file_descript, char *filen=
ame,
>                 rc =3D access(filename, R_OK);
>                 if (rc) {
>                         fprintf(stderr,
> -                               "mount.cifs failed: access check of %s fa=
iled: %s\n",
> -                               filename, strerror(errno));
> +                               "%s failed: access check of %s failed: %s=
\n",
> +                               program, filename, strerror(errno));
>                         toggle_dac_capability(0, 0);
>                         return EX_SYSERR;
>                 }
> @@ -658,8 +658,8 @@ get_password_from_file(int file_descript, char *filen=
ame,
>                 file_descript =3D open(filename, O_RDONLY);
>                 if (file_descript < 0) {
>                         fprintf(stderr,
> -                               "mount.cifs failed. %s attempting to open=
 password file %s\n",
> -                               strerror(errno), filename);
> +                               "%s failed. %s attempting to open passwor=
d file %s\n",
> +                               program, strerror(errno), filename);
>                         toggle_dac_capability(0, 0);
>                         return EX_SYSERR;
>                 }
> @@ -675,8 +675,8 @@ get_password_from_file(int file_descript, char *filen=
ame,
>         rc =3D read(file_descript, buf, sizeof(buf) - 1);
>         if (rc < 0) {
>                 fprintf(stderr,
> -                       "mount.cifs failed. Error %s reading password fil=
e\n",
> -                       strerror(errno));
> +                       "%s failed. Error %s reading password file\n",
> +                       program, strerror(errno));
>                 rc =3D EX_SYSERR;
>                 goto get_pw_exit;
>         }
> @@ -923,7 +923,7 @@ parse_options(const char *data, struct parsed_mount_i=
nfo *parsed_info)
>                                         "invalid path to network resource=
\n");
>                                 return EX_USAGE;
>                         }
> -                       rc =3D parse_unc(value, parsed_info);
> +                       rc =3D parse_unc(value, parsed_info, thisprogram)=
;
>                         if (rc)
>                                 return rc;
>                         break;
> @@ -1280,7 +1280,7 @@ nocopy:
>         return 0;
>  }
>
> -static int parse_unc(const char *unc_name, struct parsed_mount_info *par=
sed_info)
> +static int parse_unc(const char *unc_name, struct parsed_mount_info *par=
sed_info, const char *progname)
>  {
>         int length =3D strnlen(unc_name, MAX_UNC_LEN);
>         const char *host, *share, *prepath;
> @@ -1305,26 +1305,26 @@ static int parse_unc(const char *unc_name, struct=
 parsed_mount_info *parsed_info
>         }
>
>         if (strncmp(unc_name, "//", 2) && strncmp(unc_name, "\\\\", 2)) {
> -               fprintf(stderr, "mount.cifs: bad UNC (%s)\n", unc_name);
> +               fprintf(stderr, "%s: bad UNC (%s)\n", progname, unc_name)=
;
>                 return EX_USAGE;
>         }
>
>         host =3D unc_name + 2;
>         hostlen =3D strcspn(host, "/\\");
>         if (!hostlen) {
> -               fprintf(stderr, "mount.cifs: bad UNC (%s)\n", unc_name);
> +               fprintf(stderr, "%s: bad UNC (%s)\n", progname, unc_name)=
;
>                 return EX_USAGE;
>         }
>         share =3D host + hostlen + 1;
>
>         if (hostlen + 1 > sizeof(parsed_info->host)) {
> -               fprintf(stderr, "mount.cifs: host portion of UNC too long=
\n");
> +               fprintf(stderr, "%s: host portion of UNC too long\n", pro=
gname);
>                 return EX_USAGE;
>         }
>
>         sharelen =3D strcspn(share, "/\\");
>         if (sharelen + 1 > sizeof(parsed_info->share)) {
> -               fprintf(stderr, "mount.cifs: share portion of UNC too lon=
g\n");
> +               fprintf(stderr, "%s: share portion of UNC too long\n", pr=
ogname);
>                 return EX_USAGE;
>         }
>
> @@ -1335,7 +1335,7 @@ static int parse_unc(const char *unc_name, struct p=
arsed_mount_info *parsed_info
>         prepathlen =3D strlen(prepath);
>
>         if (prepathlen + 1 > sizeof(parsed_info->prefix)) {
> -               fprintf(stderr, "mount.cifs: UNC prefixpath too long\n");
> +               fprintf(stderr, "%s: UNC prefixpath too long\n", progname=
);
>                 return EX_USAGE;
>         }
>
> @@ -1347,7 +1347,7 @@ static int parse_unc(const char *unc_name, struct p=
arsed_mount_info *parsed_info
>         return 0;
>  }
>
> -static int get_pw_from_env(struct parsed_mount_info *parsed_info)
> +static int get_pw_from_env(struct parsed_mount_info *parsed_info, const =
char *program)
>  {
>         int rc =3D 0;
>
> @@ -1355,10 +1355,10 @@ static int get_pw_from_env(struct parsed_mount_in=
fo *parsed_info)
>                 rc =3D set_password(parsed_info, getenv("PASSWD"));
>         else if (getenv("PASSWD_FD"))
>                 rc =3D get_password_from_file(atoi(getenv("PASSWD_FD")), =
NULL,
> -                                           parsed_info);
> +                                           parsed_info, program);
>         else if (getenv("PASSWD_FILE"))
>                 rc =3D get_password_from_file(0, getenv("PASSWD_FILE"),
> -                                           parsed_info);
> +                                           parsed_info, program);
>
>         return rc;
>  }
> @@ -1408,9 +1408,9 @@ static int uppercase_string(char *string)
>         return 1;
>  }
>
> -static void print_cifs_mount_version(void)
> +static void print_cifs_mount_version(const char *progname)
>  {
> -       printf("mount.cifs version: %s\n", VERSION);
> +       printf("%s version: %s\n", progname, VERSION);
>  }
>
>  /*
> @@ -1782,7 +1782,7 @@ assemble_mountinfo(struct parsed_mount_info *parsed=
_info,
>                 parsed_info->flags |=3D CIFS_SETUID_FLAGS;
>         }
>
> -       rc =3D get_pw_from_env(parsed_info);
> +       rc =3D get_pw_from_env(parsed_info, thisprogram);
>         if (rc)
>                 goto assemble_exit;
>
> @@ -1802,7 +1802,7 @@ assemble_mountinfo(struct parsed_mount_info *parsed=
_info,
>
>         parsed_info->flags &=3D ~(MS_USERS | MS_USER);
>
> -       rc =3D parse_unc(orig_dev, parsed_info);
> +       rc =3D parse_unc(orig_dev, parsed_info, thisprogram);
>         if (rc)
>                 goto assemble_exit;
>
> @@ -1987,10 +1987,10 @@ int main(int argc, char **argv)
>                 thisprogram =3D "mount.cifs";
>
>         if(strcmp(thisprogram, "mount.cifs") =3D=3D 0)
> -               cifs_fstype =3D "cifs";
> +               cifs_fstype =3D "cifs";
>
> -        if(strcmp(thisprogram, "mount.smb3") =3D=3D 0)
> -              cifs_fstype =3D "smb3";
> +       if(strcmp(thisprogram, "mount.smb3") =3D=3D 0)
> +               cifs_fstype =3D "smb3";
>
>         /* allocate parsed_info as shared anonymous memory range */
>         parsed_info =3D mmap((void *)0, sizeof(*parsed_info), PROT_READ |=
 PROT_WRITE,
> @@ -2027,7 +2027,7 @@ int main(int argc, char **argv)
>                         ++parsed_info->verboseflag;
>                         break;
>                 case 'V':
> -                       print_cifs_mount_version();
> +                       print_cifs_mount_version(thisprogram);
>                         exit(0);
>                 case 'w':
>                         parsed_info->flags &=3D ~MS_RDONLY;
> --
> 2.21.0
>

Merged, thanks.

I noticed that "thisprogram" variable name is used for static variable
and for assemble_mountinfo() function argument - probably this should
be fixed to avoid confusions.

--
Best regards,
Pavel Shilovsky
