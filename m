Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95888231C88;
	Sun, 13 Oct 2024 17:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728842198; cv=none; b=T3tsPr7m24B4VF94gVoEvQwKTlVDKUweVta0yFmScN6x+A7j5FutCUYplJ2Qp/tLHurChe8FtAjDruwmjRtlgVCkAR8F4yiERKYzasznTB7LsJchzVkdfP8IwjhZk6eljhAFRe6fR62B0dzQHH06dPhnn0gbU4vKOQBCFteaxSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728842198; c=relaxed/simple;
	bh=b7hHCrOEhpE7yCW9KJU8T4YwEehdQgxGVvHQ/HZRM1k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E2qX0CCe7VgD2N15URVi6d0QMOHKuqxLQ3Jo3nBrl83kAaO2uNlmloqVPiVUMYI23+EE9t9Xx29tEi+k+cwC7UuF16GAf2+No8zJ/ZtB905mRxrV+krT2Fb3+S9+TG48PN6xeQxQM2eI22qdpJJgD7SWPFeE4n8Vy7WAUlPihns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lkKe53qU; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lkKe53qU"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-539f58c68c5so396726e87.3;
        Sun, 13 Oct 2024 10:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728842195; x=1729446995; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pl+3AhcUP+NWxOHXU/ZeBD+x4G+Ef6uF0ibzfuXPS+4=;
        b=lkKe53qURJkH2wNF2vwzTSDraS3Wye+ra9GTv+MqFo2sUJb2jvwLF/58mZkeWKR7CC
         qPQhAS1vUeKnvkLUudZUg1LY5O2crh432ect4VBEWkQLywg+I0aTC7HVEAk4ak+QJgJE
         r4F6p/MV3Verirjdi2eokKXTck8xDMHrY4Gb7niOet8tRCgK41tmoUN3+qgOSPqX3tC5
         W+7rLYIU5hOiaj8yJFQ+y8YoMEQXivdZP0KBAiTZC9AnePShsgAL4VVuVd5oOd4uak3B
         CrUF+WyWdmqjdQc1XnZRWeejBsbmMTJVAmpQhigjS0JZruvpJezvOmWK11NuQQ2T764E
         dtDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728842195; x=1729446995;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pl+3AhcUP+NWxOHXU/ZeBD+x4G+Ef6uF0ibzfuXPS+4=;
        b=GOSFPMNZ7kpKGsse1T1p9hWE94BKx6Q4CXQNc5Igwjan/fp9eFBbYiQaVPykTUs1gE
         4UAfKsQ74hBEOc2WmveL4N4YjpNlq93gGdEfVBI98E/boWQIbVphfXD1mgLKzh46PNMB
         9X8ICfTrQwdbcTe5wblGGm/LDFRA0rzmLlZpvUqPXX8OPDn9M8vubS4cLfSXO3ljlAgv
         t1qBFI9EbS0jFsVqFj+CNTfVKKJJuiIPvsP8CW/pOukXCVtAog5d6H4BxlHHTCOep5SZ
         CdOuKZt2dwnJrUSBwSOrbud5Str6MAepcx6fw/I+V6FW5vtgln2tHvscZdHmFMxod7lJ
         gBFA==
X-Forwarded-Encrypted: i=1; AJvYcCUjrd0VnlIKDzlOkDJQHhTPCn9Ddy5kVvbrLz+KmLfYBAgnVM272EMxItAYTwK+TefsJeFEx+2L86bCRAyz@vger.kernel.org, AJvYcCWyqWrP7HSdUaTFrQHGCfjbhx02u6wGzWVpgkppEJi7e333uZuCULr1RJp6cHDmfI0T6qz2JOnVgJ0c@vger.kernel.org
X-Gm-Message-State: AOJu0YynztGfAkrwTh0KsIxKJAuYHUwZ4TxUPs8Bn7hKuMgl4/cU1WHq
	rM6lcr1zcfrz//F7gdSBb/Tf5IpisEbuDo3+dUoqUdtqv13OcDin4+FLYJjmQDSAnDtBYwslmiB
	XClJLcAtYeYOBus8MGfWJXeNT87E=
X-Google-Smtp-Source: AGHT+IG4SGT3ARa561UTDFQp3WxJ74zZCBv/ajjJV+4IL+dBQrarHnw9L7ADk0i4WYiOeSbHxXQ2haHZbT/rQdejIzk=
X-Received: by 2002:a05:6512:3402:b0:533:4505:5b2a with SMTP id
 2adb3069b0e04-539e5515238mr2383721e87.28.1728842194378; Sun, 13 Oct 2024
 10:56:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240929185053.10554-1-pali@kernel.org> <20241005140300.19416-1-pali@kernel.org>
 <20241005140300.19416-5-pali@kernel.org>
In-Reply-To: <20241005140300.19416-5-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Sun, 13 Oct 2024 12:56:23 -0500
Message-ID: <CAH2r5mtbK7vRVHs6rosrvGuer52cyfdsyCt1FL3TFg4RXxULuA@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] cifs: Fix parsing native symlinks directory/file type
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Would this break any pure Linux client example, mounted to Windows,
where previously the Linux client created all symlinks as file
symlinks?  e.g. If there were two Linux clients writing to the share,
one that included this fix and one that did not.

On Sat, Oct 5, 2024 at 9:03=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> wr=
ote:
>
> As SMB protocol distinguish between symlink to directory and symlink to
> file, add some mechanism to disallow resolving incompatible types.
>
> When SMB symlink is of the directory type, ensure that its target path en=
ds
> with slash. This forces Linux to not allow resolving such symlink to file=
.
>
> And when SMB symlink is of the file type and its target path ends with
> slash then returns an error as such symlink is unresolvable. Such symlink
> always points to invalid location as file cannot end with slash.
>
> As POSIX server does not distinguish between symlinks to file and symlink
> directory, do not apply this change for symlinks from POSIX SMB server. F=
or
> POSIX SMB servers, this change does nothing.
>
> This mimics Windows behavior of native SMB symlinks.
>
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
>  fs/smb/client/inode.c     |  5 ++++
>  fs/smb/client/smb2file.c  | 55 +++++++++++++++++++++++++++++++++++++++
>  fs/smb/client/smb2inode.c |  4 +++
>  fs/smb/client/smb2proto.h |  1 +
>  4 files changed, 65 insertions(+)
>
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index 0fe54b2d2561..aa38a3935f8f 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -1110,6 +1110,11 @@ static int reparse_info_to_fattr(struct cifs_open_=
info_data *data,
>                                                               full_path,
>                                                               iov, data);
>                 }
> +
> +               if (data->reparse.tag =3D=3D IO_REPARSE_TAG_SYMLINK && !r=
c) {
> +                       bool directory =3D le32_to_cpu(data->fi.Attribute=
s) & ATTR_DIRECTORY;
> +                       rc =3D smb2_fix_symlink_target_type(&data->symlin=
k_target, directory, cifs_sb);
> +               }
>                 break;
>         }
>
> diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
> index dc52995f5591..149449d9c1c0 100644
> --- a/fs/smb/client/smb2file.c
> +++ b/fs/smb/client/smb2file.c
> @@ -63,6 +63,56 @@ static struct smb2_symlink_err_rsp *symlink_data(const=
 struct kvec *iov)
>         return sym;
>  }
>
> +int smb2_fix_symlink_target_type(char **target, bool directory, struct c=
ifs_sb_info *cifs_sb)
> +{
> +       char *buf;
> +       int len;
> +
> +       /*
> +        * POSIX server does not distinguish between symlinks to file and
> +        * symlink directory. So nothing is needed to fix on the client s=
ide.
> +        */
> +       if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
> +               return 0;
> +
> +       len =3D strlen(*target);
> +       if (!len)
> +               return -EIO;
> +
> +       /*
> +        * If this is directory symlink and it does not have trailing sla=
sh then
> +        * append it. Trailing slash simulates Windows/SMB behavior which=
 do not
> +        * allow resolving directory symlink to file.
> +        */
> +       if (directory && (*target)[len-1] !=3D '/') {
> +               buf =3D kzalloc(len+2, GFP_KERNEL);
> +               if (!buf)
> +                       return -ENOMEM;
> +               memcpy(buf, *target, len);
> +               buf[len] =3D '/';
> +               kfree(*target);
> +               *target =3D buf;
> +       }
> +
> +       /*
> +        * If this is a symlink which points to file name with trailing s=
lash,
> +        * or to file named "." or file named ".." then this symlink cann=
ot be
> +        * resolved on Linux because Linux does not allow files with such=
 names.
> +        * So return an error to prevent resolving this file type symlink=
 to
> +        * directory, as it do not point to directory at all.
> +        */
> +       if (!directory) {
> +               const char *basename =3D kbasename(*target);
> +               int basename_len =3D strlen(basename);
> +               if (basename_len =3D=3D 0 || /* symname ends with slash *=
/
> +                   (basename_len =3D=3D 1 && basename[0] =3D=3D '.') || =
/* last component is "." */
> +                   (basename_len =3D=3D 2 && basename[0] =3D=3D '.' && b=
asename[1] =3D=3D '.')) /* or ".." */
> +                       return -EIO;
> +       }
> +
> +       return 0;
> +}
> +
>  int smb2_parse_symlink_response(struct cifs_sb_info *cifs_sb, const stru=
ct kvec *iov,
>                                 const char *full_path, char **path)
>  {
> @@ -133,6 +183,11 @@ int smb2_open_file(const unsigned int xid, struct ci=
fs_open_parms *oparms, __u32
>                                                NULL, NULL, NULL);
>                                 oparms->create_options &=3D ~OPEN_REPARSE=
_POINT;
>                         }
> +                       if (!rc) {
> +                               bool directory =3D le32_to_cpu(data->fi.A=
ttributes) & ATTR_DIRECTORY;
> +                               rc =3D smb2_fix_symlink_target_type(&data=
->symlink_target,
> +                                                                 directo=
ry, oparms->cifs_sb);
> +                       }
>                 }
>         }
>
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index 9a28a30ec1a3..06bb6f7fbf0f 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -960,6 +960,10 @@ int smb2_query_path_info(const unsigned int xid,
>                 rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path,
>                                       &oparms, in_iov, cmds, num_cmds,
>                                       cfile, NULL, NULL, NULL);
> +               if (data->reparse.tag =3D=3D IO_REPARSE_TAG_SYMLINK && !r=
c) {
> +                       bool directory =3D le32_to_cpu(data->fi.Attribute=
s) & ATTR_DIRECTORY;
> +                       rc =3D smb2_fix_symlink_target_type(&data->symlin=
k_target, directory, cifs_sb);
> +               }
>                 break;
>         case -EREMOTE:
>                 break;
> diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
> index aa01ae234732..1828b825c7d3 100644
> --- a/fs/smb/client/smb2proto.h
> +++ b/fs/smb/client/smb2proto.h
> @@ -113,6 +113,7 @@ extern int smb3_query_mf_symlink(unsigned int xid, st=
ruct cifs_tcon *tcon,
>                           struct cifs_sb_info *cifs_sb,
>                           const unsigned char *path, char *pbuf,
>                           unsigned int *pbytes_read);
> +int smb2_fix_symlink_target_type(char **target, bool directory, struct c=
ifs_sb_info *cifs_sb);
>  int smb2_parse_native_symlink(char **target, const char *buf, unsigned i=
nt len,
>                               bool unicode, bool relative,
>                               const char *full_path,
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
