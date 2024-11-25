Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE4D18E359;
	Mon, 25 Nov 2024 21:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732569861; cv=none; b=ouoZy5ExRnODV4Xes0kXp8zjoHdgLb1Ys2Pt2mAs8GBZk4pXd7KzVHLsbFjJmbf8bCqXX14bQ2w8RdmMMJ3pIstvfE1YIsTaM/GtYYGL4QJI4gIjngUVNuk7aMSfqeNyhQQb4Z+Lszj6Yd924k2l75S6nAXfxYMM4y3IojumdsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732569861; c=relaxed/simple;
	bh=5CtDAEAGFgIRPa64S8d1hGjtFDiHuHdt+XKkD8Kc1W0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sd6/RzQByjbNRnX6I/QXBa7XGXhR2eLs2BtScZ6MQL0aq6fVAHIurQsjU6b/Gccx4kA+Kiwc3jozfaxH6btqSu0H2qbx9QDXfGKs7CYK9UVMUD93heDrUKJUFLHot9tb8jOglsDxVWVYG6l+Sm6lI22zf5ze1YNLr09KxOXL8NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dTQbYeHD; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dTQbYeHD"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-53ddd4705f8so2128714e87.0;
        Mon, 25 Nov 2024 13:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732569855; x=1733174655; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0+1WZ/SbKZYL7GP2tOCW3l+o5U7i+3bfPsO9z/9LP1Y=;
        b=dTQbYeHDUA9BFuTnvidkw5GGOzNVvOzl2K8MkXY4RR8JZ5g0jimFEkr4QGrZub6OY9
         vTCCc6Dh867nBtkqNgKXRV8YUYa10aQC7vlefl/5v1RNmcwn6WqXaamtnvHDn8u/y/ol
         xXyPD5XDB1D8qmlUjrMlB/b6Wr+UElNP6LHxVNFJ7QfnOgMvnnspoTCRtFDb+2n5CwvL
         B+Gf93HwA21sdaJKfwpWugzuGg+h21pLfYJRncZrUCzANE0oVJ1HwB0FYaZtJpPeR3V3
         AGJn+toqLtjQL9KoBv26kGO65x2q9yWMBYkkFiMXegKqKSaubj8RVd8V2JVpt/GY66lZ
         TAdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732569855; x=1733174655;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0+1WZ/SbKZYL7GP2tOCW3l+o5U7i+3bfPsO9z/9LP1Y=;
        b=W8F6TD+LsM5tOYsdrLsdJ84K/Ru/Ux7CnTsYV2t5yekxvqZkAqX8LH64Jj4Obm/Jpu
         g7tYaH+iu+cebzpWAkG4DD03jnX5Ru/zCPS49fglWAPm9FpEs+J2r9qX3dc5XqhSNCKE
         4qJGoHY1MwRq5eZuFPf1GEuGOR6sIckblYoOJMsuFW1/RzMqcTfxtM4ExiW9/xRr5+SV
         BMdPIuKX0elXFoE1wP82ZkCJcsVXJ7hbUGUn8iCvIhJbdiffmiofIrJ1A1aDX8uR/Q+s
         AfaCb6I9EatyM1wPjDbL5p6pydeQPaAqwfcQT7W5nOiyT5sfWdr5XzNXP+huSjlSZXKp
         Kwsg==
X-Forwarded-Encrypted: i=1; AJvYcCW1Aj3zJqkZWcRkCymOMAjyEvcQ/OxEApAdw3uDv6uBsAaD32IoDYWXD5mF539QUyb5DACPpLsXMW7BmV7Z@vger.kernel.org, AJvYcCXRyClnjHsXbO71ZwdUAFTuql9VDToSCj3ukzHxNEC3COxAFXc+CKbdX29KxTKUHwGdycsic2KsCW6V@vger.kernel.org
X-Gm-Message-State: AOJu0Yxyvw9uOGmHX3oYpTG/Xa+k9XcFFG3a0y1rImF7lWUZnnzH7a4b
	npgS9AQDjdoMplxYW/oPnZ807XguYUFE8Hl2eshxx6ivVmI+49/Gv4GkzWLjwzclh+0iOffVvi3
	zPFjbfcKxA/JY5enjsXn8hFrS8jg=
X-Gm-Gg: ASbGncuv7FDeQzb/wDzJ+oUMEBmWbG2MGptJce8CGOFq/dDoD6HTcoXgPN+mlfHLhEi
	IvPOlNHx5yssH6+rv/pdqyugHsQbkKmGpunllqBnLO4M/ch7s8x2fcBEnsp6dDJrI
X-Google-Smtp-Source: AGHT+IEY8/fB2/n9+nqmJCBIY3Q6rmtjh/JVWx2KCtVuohcw6+KzsNR8Ms/wRbMD1bUJRL/ev17UljKa17Tih0kFoDI=
X-Received: by 2002:a05:6512:b9b:b0:53d:e123:fba7 with SMTP id
 2adb3069b0e04-53de88505dbmr290218e87.26.1732569855254; Mon, 25 Nov 2024
 13:24:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241006090548.30053-1-pali@kernel.org>
In-Reply-To: <20241006090548.30053-1-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 25 Nov 2024 15:24:03 -0600
Message-ID: <CAH2r5mtLoAsZfHHe33=WfDjLZ1PNgV-SgcN1F-o0g1XXLsoAng@mail.gmail.com>
Subject: Re: [PATCH] cifs: Add support for parsing WSL-style symlinks
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This patch

commit 06a7adf318a30bdcfa1222ed6d2640e6bb266d7b
Author: Pali Roh=C3=A1r <pali@kernel.org>
Date:   Sat Sep 28 13:21:24 2024 +0200

    cifs: Add support for parsing WSL-style symlinks


 led to compile warning:

  CC [M]  fs/smb/client/reparse.o
  CHECK   fs/smb/client/reparse.c
fs/smb/client/reparse.c:679:45: warning: incorrect type in argument 4
(different base types)
fs/smb/client/reparse.c:679:45:    expected unsigned short [usertype] *pwcs
fs/smb/client/reparse.c:679:45:    got restricted __le16 [usertype]
*[assigned] symname_utf16


Let me know if updated version needed

On Sun, Oct 6, 2024 at 4:07=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> wr=
ote:
>
> Linux CIFS client currently does not implement readlink() for WSL-style
> symlinks. It is only able to detect that file is of WSL-style symlink, bu=
t
> is not able to read target symlink location.
>
> Add this missing functionality and implement support for parsing content =
of
> WSL-style symlink.
>
> The important note is that symlink target location stored for WSL symlink
> reparse point (IO_REPARSE_TAG_LX_SYMLINK) is in UTF-8 encoding instead of
> UTF-16 (which is used in whole SMB protocol and also in all other symlink
> styles). So for proper locale/cp support it is needed to do conversion fr=
om
> UTF-8 to local_nls.
>
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
>  fs/smb/client/reparse.c | 49 +++++++++++++++++++++++++++++++++++++++++
>  fs/smb/common/smb2pdu.h |  9 ++++++++
>  2 files changed, 58 insertions(+)
>
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index a577b2d2a4fc..6e9d914bac41 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -875,6 +875,52 @@ static int parse_reparse_symlink(struct reparse_syml=
ink_data_buffer *sym,
>                                          cifs_sb);
>  }
>
> +static int parse_reparse_wsl_symlink(struct reparse_wsl_symlink_data_buf=
fer *buf,
> +                                    struct cifs_sb_info *cifs_sb,
> +                                    struct cifs_open_info_data *data)
> +{
> +       int len =3D le16_to_cpu(buf->ReparseDataLength);
> +       int symname_utf8_len;
> +       __le16 *symname_utf16;
> +       int symname_utf16_len;
> +
> +       if (len <=3D sizeof(buf->Flags)) {
> +               cifs_dbg(VFS, "srv returned malformed wsl symlink buffer\=
n");
> +               return -EIO;
> +       }
> +
> +       /* PathBuffer is in UTF-8 but without trailing null-term byte */
> +       symname_utf8_len =3D len - sizeof(buf->Flags);
> +       /*
> +        * Check that buffer does not contain null byte
> +        * because Linux cannot process symlink with null byte.
> +        */
> +       if (strnlen(buf->PathBuffer, symname_utf8_len) !=3D symname_utf8_=
len) {
> +               cifs_dbg(VFS, "srv returned null byte in wsl symlink targ=
et location\n");
> +               return -EIO;
> +       }
> +       symname_utf16 =3D kzalloc(symname_utf8_len * 2, GFP_KERNEL);
> +       if (!symname_utf16)
> +               return -ENOMEM;
> +       symname_utf16_len =3D utf8s_to_utf16s(buf->PathBuffer, symname_ut=
f8_len,
> +                                           UTF16_LITTLE_ENDIAN,
> +                                           symname_utf16, symname_utf8_l=
en * 2);
> +       if (symname_utf16_len < 0) {
> +               kfree(symname_utf16);
> +               return symname_utf16_len;
> +       }
> +       symname_utf16_len *=3D 2; /* utf8s_to_utf16s() returns number of =
u16 items, not byte length */
> +
> +       data->symlink_target =3D cifs_strndup_from_utf16((u8 *)symname_ut=
f16,
> +                                                      symname_utf16_len,=
 true,
> +                                                      cifs_sb->local_nls=
);
> +       kfree(symname_utf16);
> +       if (!data->symlink_target)
> +               return -ENOMEM;
> +
> +       return 0;
> +}
> +
>  int parse_reparse_point(struct reparse_data_buffer *buf,
>                         u32 plen, struct cifs_sb_info *cifs_sb,
>                         const char *full_path,
> @@ -894,6 +940,9 @@ int parse_reparse_point(struct reparse_data_buffer *b=
uf,
>                         (struct reparse_symlink_data_buffer *)buf,
>                         plen, unicode, cifs_sb, full_path, data);
>         case IO_REPARSE_TAG_LX_SYMLINK:
> +               return parse_reparse_wsl_symlink(
> +                       (struct reparse_wsl_symlink_data_buffer *)buf,
> +                       cifs_sb, data);
>         case IO_REPARSE_TAG_AF_UNIX:
>         case IO_REPARSE_TAG_LX_FIFO:
>         case IO_REPARSE_TAG_LX_CHR:
> diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
> index c769f9dbc0b4..275184c31a89 100644
> --- a/fs/smb/common/smb2pdu.h
> +++ b/fs/smb/common/smb2pdu.h
> @@ -1552,6 +1552,15 @@ struct reparse_symlink_data_buffer {
>
>  /* See MS-FSCC 2.1.2.6 and cifspdu.h for struct reparse_posix_data */
>
> +/* For IO_REPARSE_TAG_LX_SYMLINK */
> +struct reparse_wsl_symlink_data_buffer {
> +       __le32  ReparseTag;
> +       __le16  ReparseDataLength;
> +       __u16   Reserved;
> +       __le32  Flags;
> +       __u8    PathBuffer[]; /* Variable Length UTF-8 string without nul=
-term */
> +} __packed;
> +
>  struct validate_negotiate_info_req {
>         __le32 Capabilities;
>         __u8   Guid[SMB2_CLIENT_GUID_SIZE];
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
