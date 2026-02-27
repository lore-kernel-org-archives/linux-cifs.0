Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ACB32F749
	for <linux-cifs@vger.kernel.org>; Fri, 27 Feb 2026 04:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772167069; cv=none; b=DeHSdodMO4DML0cASrYYsVgS0T0tsgXscUCnNcARy9bCgwWMFpNfXCgnZD++Ihen2gl6FVM5QPSMc7dVw79IEzJeu6iRSeLxBBepNBkTRmkgno07/Zcp8QG7sOg9W6B54t7bFF6dx/a9kkbtfOqBDGJ6mEkstSNmLEjaUnwBDiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772167069; c=relaxed/simple;
	bh=44/Db8D0BA3VZNQfiCFo0srmzBgogRvuLBZdefUHEdc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JCDjCZkW6llMFxPENFoWqq5SioAZAs2/+PIG007lY9Fcgucbn45qbZr21kSPHhPM2A0n+dSx9HjgW++9YhmpGjnbVnrbf3WSwz7ootYvYNFo0OU7+XAYH2W1Dleg8nPXBaOCHBG5PT6fuCU9t+yzBI6kqyFq5YOhT8mh6DgQZ+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nJ17ZNR+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nJ17ZNR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935BAC116C6
	for <linux-cifs@vger.kernel.org>; Fri, 27 Feb 2026 04:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772167069;
	bh=44/Db8D0BA3VZNQfiCFo0srmzBgogRvuLBZdefUHEdc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nJ17ZNR+muDOguBbDZna9q2ffLB/CT2im9g+wDJn15nJVC4Z4qxpJOHoinGlG3Q+G
	 Zn+b0KDY3W8n6TOrFxO64qF6bZMBmRsz5NRunyNNHpzNgWpiJ4VvmoAyf1XZ3//4Jt
	 VtY38uWNQS6cyhJGxyIVGU5JOVjUS3NezxMzVLnrTk1MUyj+UiM2y28LZbGYZYdf3i
	 9PTvSYOikrgvCyJXXUgfBi9dXoACg+ARgmUyq1YR8lA+HDJndtaeT3Apu36fKXvqfL
	 Jy7bTfXbSwOrllTEPnf9Zy19ZV6EA1Cib2lwX5rVYudlDKqnqhqK/8yJv0m5yWN3Rq
	 P/1rdhUeuzJpw==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b936331787bso195283466b.3
        for <linux-cifs@vger.kernel.org>; Thu, 26 Feb 2026 20:37:49 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUEYTYT4OnME1PvuBwDQoIzZO+8t1TzDvDSMM3b1RT0LA4vs6eRyV/AZPRYU23MZo8604Gz8AX7ViN1@vger.kernel.org
X-Gm-Message-State: AOJu0YwaVy4msiO5KSD1HKgG+CesEG0BglkNN3QToE+4j9vhHI38pKeL
	/cWS4ThJ2daEalhlQQ6fwh1iZT0o+5MjPynMGh4XQLWUsw0id6PLwlGAgEaVU+dT8nrh/5g5zfq
	gwmuNWk7UpG/y11mzA4B9ZwXPaZnWcig=
X-Received: by 2002:a17:906:ae5a:b0:b8e:d0ec:c9e2 with SMTP id
 a640c23a62f3a-b93765674f9mr52382766b.53.1772167068015; Thu, 26 Feb 2026
 20:37:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260225041100.707468-1-zhang.guodong@linux.dev> <20260225041100.707468-6-zhang.guodong@linux.dev>
In-Reply-To: <20260225041100.707468-6-zhang.guodong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 27 Feb 2026 13:37:36 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8ieg2fvYOK0BwBG8bbT18d9Z2A43-XoC21a5DArwsJKw@mail.gmail.com>
X-Gm-Features: AaiRm52sKwdyKOhuvbqKYXfZIvxLmBsw-Ao5FYyWl_M597PO72cQVNcKfaehXc4
Message-ID: <CAKYAXd8ieg2fvYOK0BwBG8bbT18d9Z2A43-XoC21a5DArwsJKw@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] smb: introduce struct file_posix_info
To: zhang.guodong@linux.dev
Cc: smfrench@gmail.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, ZhangGuoDong <zhangguodong@kylinos.cn>, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

It doesn't seem to have been updated as I said.

> diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
> index 30d70097fe2f..74a332d9cbeb 100644
> --- a/fs/smb/client/smb2pdu.h
> +++ b/fs/smb/client/smb2pdu.h
> @@ -274,20 +274,7 @@ struct create_posix_rsp {
>  struct smb2_posix_info {
>         __le32 NextEntryOffset;
>         __u32 Ignored;
> -       __le64 CreationTime;
> -       __le64 LastAccessTime;
> -       __le64 LastWriteTime;
> -       __le64 ChangeTime;
> -       __le64 EndOfFile;
> -       __le64 AllocationSize;
> -       __le32 DosAttributes;
> -       __le64 Inode;
> -       __le32 DeviceId;
> -       __le32 Zero;
> -       /* beginning of POSIX Create Context Response */
> -       __le32 HardLinks;
> -       __le32 ReparseTag;
> -       __le32 Mode;
> +       struct file_posix_info fpinfo;
>         /*
>          * var sized owner SID
>          * var sized group SID
Please remove these comments included filename and move it to /common.

> diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
> index b4ccddca9256..0d8c522f757a 100644
> --- a/fs/smb/common/fscc.h
> +++ b/fs/smb/common/fscc.h
> @@ -537,9 +537,50 @@ struct file_notify_information {
>  } __packed;
>
>  /*
> - * See POSIX Extensions to MS-FSCC 2.3.2.1
> + * [POSIX-FSCC] POSIX Extensions to MS-FSCC
>   * Link: https://gitlab.com/samba-team/smb3-posix-spec/-/blob/master/fscc_posix_extensions.md
>   */
> +
> +/*
> + * This information class is used to query file posix information.
> + * See POSIX-FSCC 2.3.1.1
> + */
> +struct file_posix_info {
> +       __le64 CreationTime;
> +       __le64 LastAccessTime;
> +       __le64 LastWriteTime;
> +       __le64 ChangeTime;
> +       __le64 EndOfFile;
> +       __le64 AllocationSize;
> +       __le32 DosAttributes;
> +       __le64 Inode;
> +       __le32 DeviceId;
> +       __le32 Zero;
> +       /*
> +        * beginning of POSIX Create Context Response
> +        * See POSIX-SMB2 2.2.14.2.16
> +        */
> +       __le32 HardLinks;
> +       __le32 ReparseTag;
> +       __le32 Mode;
You need to add Sids[] flex array here.
> +       // var sized owner SID
> +       // var sized group SID
> +       /* end of POSIX Create Context Response */
> +       // le32 filenamelength
> +       // u8 filename[]
> +} __packed;
> +
> +/* Level 100 query info */
> +struct smb311_posix_qinfo {
Is there smb311_posix_qinfo definition in specification ? If not, It
could be replaced with smb2_posix_info ?
> +       struct file_posix_info fpinfo;
> +       u8     Sids[];
> +       /*
> +        * le32 filenamelength
> +        * u8  filename[]
> +        */
> +} __packed;

> diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
> index e7cf573e59f0..f05273f48bd0 100644
> --- a/fs/smb/server/smb2pdu.h
> +++ b/fs/smb/server/smb2pdu.h
> @@ -281,30 +281,11 @@ struct create_sd_buf_req {
>  struct smb2_posix_info {
>         __le32 NextEntryOffset;
>         __u32 Ignored;
> -       __le64 CreationTime;
> -       __le64 LastAccessTime;
> -       __le64 LastWriteTime;
> -       __le64 ChangeTime;
> -       __le64 EndOfFile;
> -       __le64 AllocationSize;
> -       __le32 DosAttributes;
> -       __le64 Inode;
> -       __le32 DeviceId;
> -       __le32 Zero;
> -       /* beginning of POSIX Create Context Response */
> -       __le32 HardLinks;
> -       __le32 ReparseTag;
> -       __le32 Mode;
> +       struct file_posix_info fpinfo;
>         /* SidBuffer contain two sids (UNIX user sid(16), UNIX group sid(16)) */
>         u8 SidBuffer[32];
>         __le32 name_len;
>         u8 name[];
> -       /*
> -        * var sized owner SID
> -        * var sized group SID
> -        * le32 filenamelength
> -        * u8  filename[]
> -        */
>  } __packed;
It should be replaced with smb2_posix_info in common.
