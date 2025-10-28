Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EBA272E5A
	for <linux-cifs@vger.kernel.org>; Tue, 28 Oct 2025 03:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761623419; cv=none; b=UxDwcMAPBCqdy3qxI0k3IQVNQqteE2RP7pNv7YCjSP5/grjh892K69AziLnu4MXvFDTgq19Ql7oDa7sFQitM0kj5FZjQpqfR2ow3xbL0QAb3QbHMdsHWeTjfhIggV7TkKjznPKdlbQYVsm18yG06ouEC9Yug9g8hpzsHzonp8ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761623419; c=relaxed/simple;
	bh=GX5+3aqXD2nsCgd5kp0igvha5Nm5hmSUAzCGmsD6XZE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JLUkDvd2bTG+4eNcFPovQ+4mZGeZ/lfR5sLisLtTncc+ConnR8nWGnJ4XjXw/p/yKlScWpW0SVBJfwN31RDUs/7JpnPKuWlAGe5qIBfrL+Gvh969vcM2HmWQzl6yQTFNR3peHLVrsNq8J0hH5MMPDaWCZuIBmBLs3uJFymzxMY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qlzKQ8Uz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qlzKQ8Uz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B8CC16AAE
	for <linux-cifs@vger.kernel.org>; Tue, 28 Oct 2025 03:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761623419;
	bh=GX5+3aqXD2nsCgd5kp0igvha5Nm5hmSUAzCGmsD6XZE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qlzKQ8UzaJ48peMQ3Pmq6UZseTDzXG/WwpxCW90jnUo4JSkmsj6RYit6TBh/lOFNR
	 PHiXAlp6c7j14bEMqxIaGDJcaA+d9fCnbEEH9y2mqryQD/+dceFI1FhmcTj4cz2zu/
	 WfXQYcd9TnjMvW6z3WV9trfF14tjuUMlkcqQQBme9zdx9OxLfgMZmGyoFxkOMVy0ln
	 QEbAsCYt/PxUSb4xc/ReI0b//pzxeT5xcX++uq+B9wqE9Xmr7c3d2ydnlyDIMVX7/w
	 9vxHCSvdqLbkowRfvAx//FfNqJyJCHWgMsfpoNCR/7ZN8Xrc5oD7oZFxLQdZ4/SSeI
	 +pzJhnDfJAY2g==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b6d53684cfdso1219739366b.0
        for <linux-cifs@vger.kernel.org>; Mon, 27 Oct 2025 20:50:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX35DAC1XZZQNVomIj/A/RKKyC4hpEeDWOz9YGQts3nJTf2lMG0jmOiWD2Y1Ac/2EtQBSMaaLfEJFSg@vger.kernel.org
X-Gm-Message-State: AOJu0YziADomQmA2VZfO35UqatOz74e5AErZjNb1zCMJQxMyEAtwm7Yk
	vTEMEPgH7i8D8O8xlEyeZsHJbRzSDkthVVVRcuENf+11WkGaMD5dMxN0tm6/ZKelS9HzsfjLYmW
	0PchCnjQk6/2GewI24QlvXfDqune/rnA=
X-Google-Smtp-Source: AGHT+IGWi61RE4SipPq0yD++Mc3cWCsrDBtPxuFho7I8zqknsGiDawaPV+gUrIP/8HXhDpM7pXr3B2NTq9c2OlOoP8s=
X-Received: by 2002:a17:907:968b:b0:b6d:552f:e400 with SMTP id
 a640c23a62f3a-b6dba4440a0mr226678666b.3.1761623417854; Mon, 27 Oct 2025
 20:50:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev> <20251027071316.3468472-15-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251027071316.3468472-15-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 28 Oct 2025 12:50:06 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-X62FhZ7+ggb6geq7LGWyWiipmF2x2K0A4LeE3EDpYXA@mail.gmail.com>
X-Gm-Features: AWmQ_bm57GE-BQzhbij7lUjhJmls7N8XtTmJe50Jk0XjT8imjsS57LoirQkB9Vs
Message-ID: <CAKYAXd-X62FhZ7+ggb6geq7LGWyWiipmF2x2K0A4LeE3EDpYXA@mail.gmail.com>
Subject: Re: [PATCH v4 14/24] smb: move SEARCH_ID_FULL_DIR_INFO to common/smb1pdu.h
To: chenxiaosong.chenxiaosong@linux.dev
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org, 
	christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025 at 4:15=E2=80=AFPM <chenxiaosong.chenxiaosong@linux.de=
v> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Rename "struct file_id_full_dir_info" to "SEARCH_ID_FULL_DIR_INFO",
> then move duplicate definitions to common header file.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/cifspdu.h    | 17 -----------------
>  fs/smb/common/smb1pdu.h    | 18 ++++++++++++++++++
>  fs/smb/server/smb2pdu.c    | 14 +++++++-------
>  fs/smb/server/smb_common.h | 17 -----------------
>  4 files changed, 25 insertions(+), 41 deletions(-)
>
> diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
> index 8aac0e04f9fd..d106c6850807 100644
> --- a/fs/smb/client/cifspdu.h
> +++ b/fs/smb/client/cifspdu.h
> @@ -2159,23 +2159,6 @@ typedef struct {
>         };
>  } __attribute__((packed)) FILE_UNIX_INFO; /* level 0x202 */
>
> -typedef struct {
> -       __le32 NextEntryOffset;
> -       __u32 FileIndex;
> -       __le64 CreationTime;
> -       __le64 LastAccessTime;
> -       __le64 LastWriteTime;
> -       __le64 ChangeTime;
> -       __le64 EndOfFile;
> -       __le64 AllocationSize;
> -       __le32 ExtFileAttributes;
> -       __le32 FileNameLength;
> -       __le32 EaSize; /* EA size */
> -       __le32 Reserved;
> -       __le64 UniqueId; /* inode num - le since Samba puts ino in low 32=
 bit*/
> -       char FileName[];
> -} __attribute__((packed)) SEARCH_ID_FULL_DIR_INFO; /* level 0x105 FF rsp=
 data */
> -
>  typedef struct {
>         __u32  ResumeKey;
>         __le16 CreationDate; /* SMB Date */
> diff --git a/fs/smb/common/smb1pdu.h b/fs/smb/common/smb1pdu.h
> index 0bc1e2373210..82331a8f70e8 100644
> --- a/fs/smb/common/smb1pdu.h
> +++ b/fs/smb/common/smb1pdu.h
> @@ -399,6 +399,24 @@ typedef struct {
>         char FileName[];
>  } __packed FILE_FULL_DIRECTORY_INFO; /* level 0x102 rsp data */
>
> +/* See MS-SMB 2.2.8.1.2 */
> +typedef struct {
> +       __le32 NextEntryOffset;
> +       __u32 FileIndex;
> +       __le64 CreationTime;
> +       __le64 LastAccessTime;
> +       __le64 LastWriteTime;
> +       __le64 ChangeTime;
> +       __le64 EndOfFile;
> +       __le64 AllocationSize;
> +       __le32 ExtFileAttributes;
> +       __le32 FileNameLength;
> +       __le32 EaSize; /* EA size */
> +       __le32 Reserved;
> +       __le64 UniqueId; /* inode num - le since Samba puts ino in low 32=
 bit*/
> +       char FileName[];
> +} __packed SEARCH_ID_FULL_DIR_INFO; /* level 0x105 FF rsp data */
Please check if this class name is defined in the fscc specification.
Thanks.
