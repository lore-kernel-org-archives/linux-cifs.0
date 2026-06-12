Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0996E331A77
	for <linux-cifs@vger.kernel.org>; Fri, 12 Jun 2026 01:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781227097; cv=pass; b=EocfG9khnmeWB8Kb42I+32Hwjxz95F6H3yGHZHJuyghZ+EWJWFClTl+SsU76Og1BNS63rgWBKzqfdwWlPwn3QAlqwiIUQjq17zXINM2nNPjqLFBKNj9RmmHm8JM48i6PUSbHPoedq9NmETiZWpYkPWYLp1mbvM7RIuA/NByxHzE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781227097; c=relaxed/simple;
	bh=EJnLEfjr1kM4FKOa6bNZBH7M9XHZ+Q0AezCmxIk5gX4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ai71sVabG3XRa3ith5tg3h2XusSCbYd/5KxyRg8CaHJ7Yvx2qmSXxBKMld3SwbQnEZ/NT0NTE3Cgpy2sf//++2vrFG86HuA1n984ZPraZ4/xfitCvQ1hFRZbtDtqfbpEOhqfQhlP3aCPTShxS5IiOU9R4+h61SqaKrSebB0UDqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NK+dHlRd; arc=pass smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NK+dHlRd"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8ccf181a52bso5095886d6.3
        for <linux-cifs@vger.kernel.org>; Thu, 11 Jun 2026 18:18:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781227094; cv=none;
        d=google.com; s=arc-20240605;
        b=alzA6QpuGf4FHjSFYfv8dki2j34LWImx5BBQeQXiLqTXCMaaVnV09WoNRVSuqVQJGE
         yO/mNltxjDRLGSuMQb2M3PtrpON/RpglMmJf7o+axTlvM2Ov/GoXVVDUJyB1CfJeVxcP
         SjwxfxM9rGf0QxHZF1KPLdwianEqjdwxqingERqoSea+gd505FGUTW+cjiOXybMBmtrC
         jCpKzQNbiLD1u8qK1i0SJXXpxhmnCXMrkmHeuwxVOIO7ihluusMaiLVgezd0w+qJyMiE
         QWlR156QqpTzVrOMOPJDNTWERjSVvtkI774W2bF9q6ppWrhPyRCShjdKesyCQZb8J8sJ
         xP3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M9y/qF+cu7bYwZqx0wIYTi0+0kzxi2nKMOjCWAm66uY=;
        fh=OwYu8HfgZAs/kjqd266XcRPKh1s40VrDOkhvHjg3JVQ=;
        b=PPdafzRl0VK+liQD2S+nH4asna1mQ7DT4x9RUJDO/9iP+ngAJHpz75fKTnu/m62DuE
         Nj/LCQhf+G78duh7JTL0I9bScpPe2+DQHy4EYPiP6DqTOGggYdVexwFc8cIMcBJCBhUj
         5iAKSn95/FhJJ2VwqKkIDCin3xbFfSBogiwhL5JjrnYs13g3k6j0vXgJFJjjSNm3RGwa
         6iWYGsW0QZss9h02ow2KpgoAwfk+hzADCT1LUFhfYhq3esHfdlrXXrlk/G9KJFvvhljf
         R/lcwRBQ36QvJRuWPhbCtwXzK3m1xNdtmMEjvH10+kasZ4G7RdvaQaz5A7eKMRdkfhn5
         V4mQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781227094; x=1781831894; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M9y/qF+cu7bYwZqx0wIYTi0+0kzxi2nKMOjCWAm66uY=;
        b=NK+dHlRdgNVLUQEM5hvzdZAzMu8/B6znxl23SoKds7dC8JubFfa0I1UH2qQVhZ5WUN
         B98tFRQ8xg3ukfGsMXgf1DKEnnpoE/l01A70GzQKohutXB+YMAO08t7JXo6+AFRXq2+U
         bUOrdHpJ5k+8CexUY0D37/u+AIc+DV5dlDnlE4QjM8ZNvW0c+zBLN9yWO8WhIElyxJ3q
         wmDAlLi+bFtdbFtayEZbfzuzft8LQlpUQqVnR8AKUdUyL3qF5891U90lizoU406xF160
         rh22dEN0feSE61LAz93PoJh4n3ghLw4W2zTYkVazrsrhHrN9c+gywvA0lXZnS/rurfv2
         r+7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781227094; x=1781831894;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M9y/qF+cu7bYwZqx0wIYTi0+0kzxi2nKMOjCWAm66uY=;
        b=Gidn3SOp1lnMR/TWROxobd9LvL8SWIRil/EMD45WuHfjhe+qvI+cij0/mmVn2Y8x3/
         3X/0iA0PH5iv17xRkm6oinMKb8TznJdbHQuMK04P4pNOLZOPDWft5OEkdF31dFfw+YiS
         YOHcNPPHlaRkmwa99PT+X4k572ogRfYR/oy+gBblbQwQoV3dTCvzFz8FzZJ/yjNO6rjM
         Dg1kXpcqI/Kmiu/qfiOkE2AOh5tDbm52kwDd1IRtA0TaYQg4JBclBqDd0cGCP/gLtADa
         rPNgytJlUJ1BT4QuyBmitOeleRNsR7rCbFWqI4LxipQpbND8+hGfNePy+Z5GhdnPvro+
         xBvw==
X-Forwarded-Encrypted: i=1; AFNElJ9sJk+0hyuAqImDm4qqXvTEv9U+KpzhJCcRM7nKAJAl6Ffecesj2I7fnZR5gMNdsuq12vJz/jeXxH3k@vger.kernel.org
X-Gm-Message-State: AOJu0YzAK51Ifah+swH99/p4osCDIxmHPtJOPx9gHoUNPwhmbDUYqgZn
	2hoovDNfttEfZUGoMFsFA2fHgdK4P1GRhfYfC5PBpzDLaBVRJh6iDE2AMecK4cJsOZCB148HGZg
	uaInXBJiYkyiO8WhoUBD3M5r/zs6uacQ=
X-Gm-Gg: Acq92OF3IRuuPsHQMUfozcXygHjJnaABgIp2gJwuQauGVunpNIugDA2c0B3ZLq8zPz3
	Cmx7NvOjhWf1+gzQyIScFubz6vmhQ1MGj2iJtBHOv5fhaRr35N0Sv2JxY6cZqnH9McPrRe92zMe
	jio+25EkeZrb21I3EEjpP3hxvw9h/c1DdXxOV5LHS8vTt4CTazbhbPKFiNNb3r/UhmCDfFltggN
	LadbKj7eMfWfov3mMFLvtE1tPIiBkrTxvQs5qLft44dCZyUwlTLC7VDGZz8GOHOw1SRoDLWojev
	cOlcrrkwJBWqI5OLjIP+6zTtbirWDS8ClZpjfDNgVbgUER5FQ2zWSRTOvABFzWLYqwYuzwIshSE
	0MZYAhMDYDdMIsCPqy99ipMsIibOqn9w23Q9gpGGM/htylp51x32NytI3wNWEIbnGMqCbV1qxYy
	LxfJH/Xv8eT/JdC4J5DDT5
X-Received: by 2002:a05:6214:f65:b0:8cc:f343:d76d with SMTP id
 6a1803df08f44-8d32edc4108mr15164576d6.33.1781227093672; Thu, 11 Jun 2026
 18:18:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260608092736.349257-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260608092736.349257-1-chenxiaosong@chenxiaosong.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 11 Jun 2026 20:18:01 -0500
X-Gm-Features: AVVi8CctYM7Xs-fmMS65Ycqpu8ZMLItUp5iwVx3HGTLZeM6enrrjRjiZ75yoHd4
Message-ID: <CAH2r5mtPk7m7t1oZwZdXmO-pdOEnkuujOfoWObJPDWKeUu6VjA@mail.gmail.com>
Subject: Re: [PATCH cifs-utils] smbinfo: add filecompressioninfo subcommand
To: chenxiaosong@chenxiaosong.com
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into smb3-utils for-next branch

I also tested it out to Windows and worked fine.

On Mon, Jun 8, 2026 at 4:28=E2=80=AFAM <chenxiaosong@chenxiaosong.com> wrot=
e:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Example:
>
>   ./smbinfo filecompressioninfo /mnt/file
>   Compressed File Size: 104857600
>   Compression Format: 2 (LZNT1)
>   Compression Unit Shift: 0
>   Chunk Shift: 0
>   Cluster Shift: 0
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  bash-completion/smbinfo |  9 ++++++---
>  smbinfo                 | 33 +++++++++++++++++++++++++++++++++
>  smbinfo.rst             |  2 ++
>  3 files changed, 41 insertions(+), 3 deletions(-)
>
> diff --git a/bash-completion/smbinfo b/bash-completion/smbinfo
> index ec0d8a4..52e6821 100644
> --- a/bash-completion/smbinfo
> +++ b/bash-completion/smbinfo
> @@ -16,6 +16,7 @@ smb_info()
>               filepositioninfo
>               filestandardinfo
>               filestreaminfo
> +             filecompressioninfo
>               fsctl-getobjid
>               getcompression
>               setcompression
> @@ -28,9 +29,11 @@ smb_info()
>                 '-v'|'-h')
>                         return 0
>                         ;;
> -               'fileaccessinfo'|'filealigninfo'|'fileallinfo'|'filebasic=
info'|'fileeainfo'|'filefsfullsizeinfo'|\
> -               'fileinternalinfo'|'filemodeinfo'|'filepositioninfo'|'fil=
estandardinfo'|'filestreaminfo'|'fsctl-getobjid'|\
> -               'getcompression'|'setcompression'|'list-snapshots'|'quota=
'|'secdesc'|'keys'|'gettconinfo')
> +               'fileaccessinfo'|'filealigninfo'|'fileallinfo'|'filebasic=
info'|'fileeainfo'|\
> +               'filefsfullsizeinfo'|'fileinternalinfo'|'filemodeinfo'|'f=
ilepositioninfo'|\
> +               'filestandardinfo'|'filestreaminfo'|'filecompressioninfo'=
|'fsctl-getobjid'|\
> +               'getcompression'|'setcompression'|'list-snapshots'|'quota=
'|'secdesc'|'keys'|\
> +               'gettconinfo')
>                         local IFS=3D$'\n'
>                         compopt -o filenames
>                         COMPREPLY=3D( $(compgen -f -o dirnames -- ${cur:-=
""}) )
> diff --git a/smbinfo b/smbinfo
> index a168186..a6095e1 100755
> --- a/smbinfo
> +++ b/smbinfo
> @@ -31,6 +31,12 @@ import threading
>
>  VERBOSE =3D False
>
> +# InfoType values
> +SMB2_O_INFO_FILE        =3D 0x01
> +
> +# QUERY INFO levels
> +FILE_COMPRESSION_INFORMATION     =3D 28
> +
>  # ioctl ctl codes
>  CIFS_QUERY_INFO          =3D 0xc018cf07
>  CIFS_ENUMERATE_SNAPSHOTS =3D 0x800ccf06
> @@ -263,6 +269,10 @@ def main():
>      sap.add_argument("file")
>      sap.set_defaults(func=3Dcmd_filestreaminfo)
>
> +    sap =3D subp.add_parser("filecompressioninfo", help=3D"Prints FileCo=
mpressionInfo for a cifs file")
> +    sap.add_argument("file")
> +    sap.set_defaults(func=3Dcmd_filecompressioninfo)
> +
>      sap =3D subp.add_parser("fsctl-getobjid", help=3D"Prints the objecti=
d of the file and GUID of the underlying volume.")
>      sap.add_argument("file")
>      sap.set_defaults(func=3Dcmd_fsctl_getobjid)
> @@ -809,6 +819,29 @@ def print_filestreaminfo(buf):
>
>          offset+=3Dnext_offset
>
> +def cmd_filecompressioninfo(args):
> +    qi =3D QueryInfoStruct(info_type=3DSMB2_O_INFO_FILE,
> +                         file_info_class=3DFILE_COMPRESSION_INFORMATION,
> +                         input_buffer_length=3D16)
> +    try:
> +        fd =3D os.open(args.file, os.O_RDONLY)
> +        buf =3D qi.ioctl(fd)
> +    except Exception as e:
> +        print("syscall failed: %s"%e)
> +        return False
> +
> +    comp_size, fmt, unit_shift, chunk_shift, cluster_shift =3D struct.un=
pack_from('<QHBBB', buf, 0)
> +    print("Compressed File Size: %d"%comp_size)
> +    fmt_name =3D "UNKNOWN"
> +    for val, name in COMPRESSION_TYPES:
> +        if fmt =3D=3D val:
> +            fmt_name =3D name
> +            break
> +    print("Compression Format: %d (%s)"%(fmt, fmt_name))
> +    print("Compression Unit Shift: %d"%unit_shift)
> +    print("Chunk Shift: %d"%chunk_shift)
> +    print("Cluster Shift: %d"%cluster_shift)
> +
>  class KeyDebugInfoStruct:
>      def __init__(self):
>          self.suid =3D bytearray()
> diff --git a/smbinfo.rst b/smbinfo.rst
> index 91b8895..7f5bb4d 100644
> --- a/smbinfo.rst
> +++ b/smbinfo.rst
> @@ -67,6 +67,8 @@ COMMAND
>
>  `filestreaminfo`: Prints the FileStreamInformation class
>
> +`filecompressioninfo`: Prints the FileCompressionInformation class
> +
>  `fsctl-getobjid`: Prints the ObjectID
>
>  `getcompression`: Prints the compression setting for the file.
> --
> 2.54.0
>


--=20
Thanks,

Steve
