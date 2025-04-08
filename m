Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF522566F4;
	Tue,  8 Apr 2025 23:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744155684; cv=none; b=VFhXoTrzeFfB5PQ+9fCWZE5Yx+oGFknM1JQE52200CXHsPUrJHTqBBOo/GcyADyUPg/ZA545bvY4FWYvbWwmdQo8x8wYF1HUDx7kh53y5doyGbbIW/bHqvQinnSZsavn24Ad6cDa5eUK1PZ6Tjc+OHH4/ae4YwctIUR3pKI9m34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744155684; c=relaxed/simple;
	bh=DyyJsg+2LmMi+/dPAa+iSKUSN1bzJnXOaVDXdmbLOZ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KVB3SF+ymWVQYkuktPPlaZ4WLITtQMktu0g4dhdZ5B1zHpGCj0wY249rZuMmdQXQjsUaNZLo1ltnDQrTXqvfnDSompfV+ekqC7AYIiE+LvHrgJF92QLYbG8REmxF0FRoJjFVyL4y5LJyB49U+srIpvBub8Iek/jE2n7hvgfkyno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PuoELNZj; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PuoELNZj"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-54b10956398so239164e87.0;
        Tue, 08 Apr 2025 16:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744155680; x=1744760480; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5lFnk/LE0iqRbBCIvZfMSg1zhFCPAuCkHRTKrFkX1Pc=;
        b=PuoELNZj+JFBjUyUgwhH1K1PRtAIWxuWL15sJ8ykHdrh7LtHLOg3jER80pGpLoX9Nm
         dM9UP+mjnWSwrGbb+gZ73mWxqDE+ONDrcTw4zb8DiW7JptPLujxLikq/58iSWcM+e9up
         lxjszN/BCI5ELP75aMZNnW1Sq73lBXczLvmlhGxaAU+4j9bb+Z+E0quthunjbXW2eI6/
         FmS9C9p4jTfhBvc/vaD2bMkrIsKmMJl8ejO5p8vpdkiWkBD9nA9a7t23Zuq/lcNmD4is
         7zJ0UdapJJsolkjPHsmuaCXtX3iHWCO1mJyqC2iaLDUemLy7y4I0seJ17k5RiK9MT7r1
         FCtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744155680; x=1744760480;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5lFnk/LE0iqRbBCIvZfMSg1zhFCPAuCkHRTKrFkX1Pc=;
        b=HatWrxqvaeiVfh3NCgk+Y2+NdgNPWEZCCyOJA2TvYE0ENlF+3vXrCpt4bVO2js0keW
         /1yKBgnUVxIYVnOkNfF+uKDkkxcO9/vYR/GFf7aLdeMz2fDeO6HqjtaxmENlfNKpqGJl
         N3EN0CiuOZ5ztsoHt7PKrjvyKn5cAwpM49mTiDzRMQhg5mRsPp9cR/5BUXlzyqul0oxw
         FqlWuFcIs7M+j/eUlb4oT6yMH3m/UZJxk9xPli18vWhDeHFCjz8V8qNaWMIyCqV0l9JM
         98qJWRWSvJjcOu/LDlp9NvsCKWVI2qtZpxl3G38lcvjlub9YfkhfVOE2PDu34UxdHL+q
         jYBg==
X-Forwarded-Encrypted: i=1; AJvYcCUSYZAiuMF8mcdy4SdD3AedqlG+t6H/DrfimD7ptZU6JviUbM71mCJHVHfbZI1eTPYPTa5sHxVOtMur@vger.kernel.org, AJvYcCVlAgRfO2myZ2V6mjDWFxTYjf+8dnmHrwG4I4FhTXoKj1b9XZe0JcQpWMPCdwCbetxHIg1iSJr9IbkQz0jm@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8pnN3HHEa6f/BJIILX+fBQWts//nSemNUexOqUFkpAC75lIUi
	JDnGN4O65UlPZLjoflU4MQQv6yaeQBg9E7rObdKl8tXKt19G926vyIJpB+YGuwj55rfOZR8qivz
	Tb9pOigCo6ZhlOkqxP2GICGeNEq53+g==
X-Gm-Gg: ASbGncuyZDtwgU5H0rDz8QSNr+nVp8kzb551/mFNCRNVvZvgyJVKlgYIYUyLTTPkFUG
	IwR9gYBwbbrKoGY9UO6hAhzSxfjhEqEdG4Ii6JHCyATj1j/l07Z5oqFkYPyhHqbdqbO1Y1e9Ge9
	cs299WZEqBcmM5QARFbWiPzKbM0tIdhEoOHXVzlvhJ576jDv7LBz6gaitdzDwE
X-Google-Smtp-Source: AGHT+IEW83HjOavjUXHZl+brSN7JdZ8nwL3B0A1zoEmhbF+MySB0IXgAQ9bP1i7e+/cVMNjFiyBmRThYKryjmj3DDmw=
X-Received: by 2002:a05:6512:ac4:b0:549:744c:fffb with SMTP id
 2adb3069b0e04-54c43720d7amr210019e87.23.1744155679942; Tue, 08 Apr 2025
 16:41:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250408222949.5041-1-pali@kernel.org>
In-Reply-To: <20250408222949.5041-1-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Tue, 8 Apr 2025 18:41:07 -0500
X-Gm-Features: ATxdqUFIp_Oeu4E4iMIGnfd8dwWpkfIo7ja4DxyUvNfulWPGcuE4-KAkR9DtPkY
Message-ID: <CAH2r5msObxLw_xSCbEY3eySvKWoqD6dRQd9t3BmxbgvnkyodRQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix support for WSL-style symlinks
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Merged into cifs-2.6.git for-next pending additional review

On Tue, Apr 8, 2025 at 5:34=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> wr=
ote:
>
> MS-FSCC in section 2.1.2.7 LX SYMLINK REPARSE_DATA_BUFFER now contains
> documentation about WSL symlink reparse point buffers.
>
> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/683=
37353-9153-4ee1-ac6b-419839c3b7ad
>
> Fix the struct reparse_wsl_symlink_data_buffer to reflect buffer fields
> according to the MS-FSCC documentation.
>
> Fix the Linux SMB client to correctly fill the WSL symlink reparse point
> buffer when creaing new WSL-style symlink. There was a mistake during
> filling the data part of the reparse point buffer. It should starts with
> bytes "\x02\x00\x00\x00" (which represents version 2) but this constant w=
as
> written as number 0x02000000 encoded in little endian, which resulted byt=
es
> "\x00\x00\x00\x02". This change is fixing this mistake.
>
> Fixes: 4e2043be5c14 ("cifs: Add support for creating WSL-style symlinks")
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
>  fs/smb/client/reparse.c | 25 ++++++++++++++++---------
>  fs/smb/common/smb2pdu.h |  6 +++---
>  2 files changed, 19 insertions(+), 12 deletions(-)
>
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index 7cefe903edb5..dbd3dd9b678f 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -520,12 +520,12 @@ static int wsl_set_reparse_buf(struct reparse_data_=
buffer **buf,
>                         kfree(symname_utf16);
>                         return -ENOMEM;
>                 }
> -               /* Flag 0x02000000 is unknown, but all wsl symlinks have =
this value */
> -               symlink_buf->Flags =3D cpu_to_le32(0x02000000);
> -               /* PathBuffer is in UTF-8 but without trailing null-term =
byte */
> +               /* Version field must be set to 2 (MS-FSCC 2.1.2.7) */
> +               symlink_buf->Version =3D cpu_to_le32(2);
> +               /* Target for Version 2 is in UTF-8 but without trailing =
null-term byte */
>                 symname_utf8_len =3D utf16s_to_utf8s((wchar_t *)symname_u=
tf16, symname_utf16_len/2,
>                                                    UTF16_LITTLE_ENDIAN,
> -                                                  symlink_buf->PathBuffe=
r,
> +                                                  symlink_buf->Target,
>                                                    symname_utf8_maxlen);
>                 *buf =3D (struct reparse_data_buffer *)symlink_buf;
>                 buf_len =3D sizeof(struct reparse_wsl_symlink_data_buffer=
) + symname_utf8_len;
> @@ -995,29 +995,36 @@ static int parse_reparse_wsl_symlink(struct reparse=
_wsl_symlink_data_buffer *buf
>                                      struct cifs_open_info_data *data)
>  {
>         int len =3D le16_to_cpu(buf->ReparseDataLength);
> +       int data_offset =3D offsetof(typeof(*buf), Target) - offsetof(typ=
eof(*buf), Version);
>         int symname_utf8_len;
>         __le16 *symname_utf16;
>         int symname_utf16_len;
>
> -       if (len <=3D sizeof(buf->Flags)) {
> +       if (len <=3D data_offset) {
>                 cifs_dbg(VFS, "srv returned malformed wsl symlink buffer\=
n");
>                 return -EIO;
>         }
>
> -       /* PathBuffer is in UTF-8 but without trailing null-term byte */
> -       symname_utf8_len =3D len - sizeof(buf->Flags);
> +       /* MS-FSCC 2.1.2.7 defines layout of the Target field only for Ve=
rsion 2. */
> +       if (le32_to_cpu(buf->Version) !=3D 2) {
> +               cifs_dbg(VFS, "srv returned unsupported wsl symlink versi=
on %u\n", le32_to_cpu(buf->Version));
> +               return -EIO;
> +       }
> +
> +       /* Target for Version 2 is in UTF-8 but without trailing null-ter=
m byte */
> +       symname_utf8_len =3D len - data_offset;
>         /*
>          * Check that buffer does not contain null byte
>          * because Linux cannot process symlink with null byte.
>          */
> -       if (strnlen(buf->PathBuffer, symname_utf8_len) !=3D symname_utf8_=
len) {
> +       if (strnlen(buf->Target, symname_utf8_len) !=3D symname_utf8_len)=
 {
>                 cifs_dbg(VFS, "srv returned null byte in wsl symlink targ=
et location\n");
>                 return -EIO;
>         }
>         symname_utf16 =3D kzalloc(symname_utf8_len * 2, GFP_KERNEL);
>         if (!symname_utf16)
>                 return -ENOMEM;
> -       symname_utf16_len =3D utf8s_to_utf16s(buf->PathBuffer, symname_ut=
f8_len,
> +       symname_utf16_len =3D utf8s_to_utf16s(buf->Target, symname_utf8_l=
en,
>                                             UTF16_LITTLE_ENDIAN,
>                                             (wchar_t *) symname_utf16, sy=
mname_utf8_len * 2);
>         if (symname_utf16_len < 0) {
> diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
> index 764dca80c15c..f79a5165a7cc 100644
> --- a/fs/smb/common/smb2pdu.h
> +++ b/fs/smb/common/smb2pdu.h
> @@ -1567,13 +1567,13 @@ struct reparse_nfs_data_buffer {
>         __u8    DataBuffer[];
>  } __packed;
>
> -/* For IO_REPARSE_TAG_LX_SYMLINK */
> +/* For IO_REPARSE_TAG_LX_SYMLINK - see MS-FSCC 2.1.2.7 */
>  struct reparse_wsl_symlink_data_buffer {
>         __le32  ReparseTag;
>         __le16  ReparseDataLength;
>         __u16   Reserved;
> -       __le32  Flags;
> -       __u8    PathBuffer[]; /* Variable Length UTF-8 string without nul=
-term */
> +       __le32  Version; /* Always 2 */
> +       __u8    Target[]; /* Variable Length UTF-8 string without nul-ter=
m */
>  } __packed;
>
>  struct validate_negotiate_info_req {
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
