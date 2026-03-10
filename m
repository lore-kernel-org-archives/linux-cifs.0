Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526E62C0F6F
	for <linux-cifs@vger.kernel.org>; Tue, 10 Mar 2026 01:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773104585; cv=none; b=Nme8qeGG7EjHSWje8oa5sfTxGkPxpO6m1ng0K+D9JCWMuA1KPSl+Nz0EFpdcTlktgXugRKDo6z5AQHWNwyLvkcK5KhX2RV+btSnL/xsMqnY7CYJZCGaEoxChZ0WoJoLo9Q+1dM8OPlMWzW+QoQEfXYBpok8P7Lk/3qao3wzag2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773104585; c=relaxed/simple;
	bh=ptg6m+5iK3v0QwGJEULujJfpsVG9v4UAhUGbmQjrGuM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KP1OdV5Fhm8rIvCyfHEVlr1JXGNOJhPqn89W4WuJu6aH86ccjmM89TCzqa0Aff5RDBuLucARsR8nMumWdrLFSUy7wl/EuAiQdTZfm0AfjzMBPp51893sRkNu5MGiGgX8su38Sk2ZT6rsphc4DVD9iQtEKztXx3hylL8Q1OUfixQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tBqhzLbA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tBqhzLbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BCBC4AF09
	for <linux-cifs@vger.kernel.org>; Tue, 10 Mar 2026 01:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773104584;
	bh=ptg6m+5iK3v0QwGJEULujJfpsVG9v4UAhUGbmQjrGuM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tBqhzLbAt3RSXHpWh1X07WuLybele3PEtgryxP3CYpUG1tJ6AoHTOXNtHYK064cCg
	 gn/gyVZJshk4iKZs+RRClOlqPZMwt4LDyRgSWf9icxOa78SwUFy3XdYqfo/4vCfpSk
	 gfzZy81uKrW4vVobb62/EbCdR6q3MP+ntOPTvH7AJWRmBLIlKe0f1mBeyn5eJ9h81Q
	 E5Gg43ZwRSV6ZE1kq6aPoOy93me593RFBVZlBh8zhUbBkytH8Rwp1/1rX//0ewHdt1
	 tMWDcMJ/KvFbV007a62znLPWVfhbyNK52kdBKMz/FP4E04LQK8dybDwPF28T4RD232
	 4wJmtHw6IYCGw==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-661f8ea8a2bso4318866a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 09 Mar 2026 18:03:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWy0JMFCht6shrJgTjK2XDW/nu5VjvX83ADhHBrG15sKdlajErLQUjoDQPZT1F8qOhRPBOE9B+NItBK@vger.kernel.org
X-Gm-Message-State: AOJu0YzFggHxTZx2aqa/7/YKN4OcoQKooCgV6ssiPte2RJJAqu3LIN2e
	mToWCjPgi/ZrKOA5bwrhTmOzzWiHtjjMjf3vU2fj9B6RBPtZo1JH9KABmRczVIV7+rx08tRvqK6
	orvX4x9mR03r3r2TtO1sCaEr6ya3mRyw=
X-Received: by 2002:a05:6402:1447:b0:662:d23a:d653 with SMTP id
 4fb4d7f45d1cf-662d23ad82amr145298a12.1.1773104583266; Mon, 09 Mar 2026
 18:03:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260303151317.136332-1-zhang.guodong@linux.dev> <20260303151317.136332-8-zhang.guodong@linux.dev>
In-Reply-To: <20260303151317.136332-8-zhang.guodong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 10 Mar 2026 10:02:50 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-_OU+YMpUmUKR0m86L+OqHPoa1T1WSDgAfo7H70tv_Sw@mail.gmail.com>
X-Gm-Features: AaiRm5204lk6dUnfn8vVRmUUtZqEQCWjaYhprTr-8wvyVyVKc2RwEYPoXVTxIsc
Message-ID: <CAKYAXd-_OU+YMpUmUKR0m86L+OqHPoa1T1WSDgAfo7H70tv_Sw@mail.gmail.com>
Subject: Re: [PATCH v5 7/7] smb: introduce struct file_posix_info
To: zhang.guodong@linux.dev
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, chenxiaosong@kylinos.cn, 
	chenxiaosong@chenxiaosong.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

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
These 3 fields should be removed and use flex array in struct file_posix_info.
And why can't smb2_posix_info move to /smb/common?
> -       /*
> -        * var sized owner SID
> -        * var sized group SID
> -        * le32 filenamelength
> -        * u8  filename[]
> -        */
>  } __packed;
>
>  /* functions */
> --
> 2.52.0
>
