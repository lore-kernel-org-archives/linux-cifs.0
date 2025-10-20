Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6601E9919
	for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 04:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760935946; cv=none; b=jTgZFymShm4u6R8QDttSETtA/5DN+AjNTfcPHN/O4lCZaUJJUjmD7tDLE0oNCrWgo3iq4icfDQ8W5HO9UgC7avFkBeUDtPqJG6gtRXOWJ5xxKmxPQFRWEVsbiudfqUIdeTQNISo9Fo8n6hBD7yG1/xkpcbiPT31Rg6NKbL7HKcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760935946; c=relaxed/simple;
	bh=RWX85HMxsmO4/qLMChtm+VThVZ1Cx193U1PHAy0oFJw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DtZX7Y4FZiTjBOnlZu54YAKzGmhsb/J4ijySpVcCynBo8iq2Xvs3aZbYLswZSAJmTh6V2DtDO9toxo3KC6VBJpbnq8XxRCYr83wFUBR+Pfyj4wo/sTadol/VodRis5GqwR2yWXkJ/JfpH1CfRYmIo3KjzHLwF9RcHHI3F08Nw3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TOsBGZT+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TOsBGZT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDAD2C19424
	for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 04:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760935945;
	bh=RWX85HMxsmO4/qLMChtm+VThVZ1Cx193U1PHAy0oFJw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TOsBGZT+I1W0wrrvYHr3mdXPuh+Z/54Gaw2QtQLLD8iZvxmFLJ4dWHSYcUkGPdenY
	 M6C27NzO6slsjXF8OvG5paAaxy2kNpTfYbW5iW3uS7svBw3hqL/BffmnnSt5FpQ1CC
	 2ICywg6QYXpNYR1up7ikDogWFRsQuGtGKLdzQo1TLjmZ7pT8EIOfmOo3rIDfy8ZHlr
	 k1zUQ/hZLOOz65c9wRdymvztuegZ8TLz+Z6PFmm07++cuPyhOb89/I8qXsf8AbqVIc
	 0yh6SJ+SgGWMDbr7U+GOc8CLDPvJ8qhWLHoeGPpyz57N9UhPZ+7eSwD5neZSuYcxYN
	 q9kFMw14u/XwQ==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-63c09ff13aeso7184471a12.0
        for <linux-cifs@vger.kernel.org>; Sun, 19 Oct 2025 21:52:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUkBf7D2eaIi51xv7J3kBnrnXrt7gsI39fBY2MvjISEZzgp5e1Dkezs7ruxXCH7j+oCz9NFQfWA9MYU@vger.kernel.org
X-Gm-Message-State: AOJu0Ywd2SnDswSTipS8RB+RBpBH/RAIvPwUcRfYSMnfO1TcezhFh9ZS
	hpzrX71mAVud9ZB1fAWxiYsJWo5cE40f4twpTdNPtAhIORWRJJ9WAOymFCz5NobhzsKLmWSq1MD
	UjjfO8Df25FPQVYm8yOtGRn//a8A7VTE=
X-Google-Smtp-Source: AGHT+IGHItkbPi2ADrDcBHUrAbdp4PQwF/p+LMbhlO3lJlhBqp6g5qUXzx5qbuxQUk2bPrnJGC45VJF26C0WQ1a/jHY=
X-Received: by 2002:a05:6402:40c5:b0:63c:1e95:dd4c with SMTP id
 4fb4d7f45d1cf-63c1f6cea34mr11794026a12.27.1760935944345; Sun, 19 Oct 2025
 21:52:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev> <20251014071917.3004573-8-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251014071917.3004573-8-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 20 Oct 2025 13:52:12 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9SJ_92si7_wt=hLm9RZmrVm2oZZqNOPFDGvPZzMzkAYA@mail.gmail.com>
X-Gm-Features: AS18NWC9rJ3BCkasTR-zLLGiCjygRe0e8WsJ37JjLpFH4ojEp1UX1W0MBYorK_A
Message-ID: <CAKYAXd9SJ_92si7_wt=hLm9RZmrVm2oZZqNOPFDGvPZzMzkAYA@mail.gmail.com>
Subject: Re: [PATCH v3 07/22] smb: move some duplicate definitions to common/smb2pdu.h
To: chenxiaosong.chenxiaosong@linux.dev
Cc: stfrench@microsoft.com, metze@samba.org, pali@kernel.org, 
	smfrench@gmail.com, sfrench@samba.org, senozhatsky@chromium.org, 
	tom@talpey.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, bharathsm@microsoft.com, christophe.jaillet@wanadoo.fr, 
	zhangguodong@kylinos.cn, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 14, 2025 at 4:21=E2=80=AFPM <chenxiaosong.chenxiaosong@linux.de=
v> wrote:
>
> From: ZhangGuoDong <zhangguodong@kylinos.cn>
>
> In order to maintain the code more easily, move duplicate definitions to
> new common header file.
>
> Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
> ---
>  fs/smb/client/smb2pdu.h | 24 +++---------------------
>  fs/smb/common/smb2pdu.h | 24 ++++++++++++++++++++++++
>  fs/smb/server/smb2pdu.c |  8 ++++----
>  fs/smb/server/smb2pdu.h | 17 -----------------
>  4 files changed, 31 insertions(+), 42 deletions(-)
>
> diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
> index 101024f8f725..c013560bcfa1 100644
> --- a/fs/smb/client/smb2pdu.h
> +++ b/fs/smb/client/smb2pdu.h
> @@ -135,11 +135,9 @@ struct share_redirect_error_context_rsp {
>
>
>  /* See MS-SMB2 2.2.13.2.11 */
> -/* Flags */
> -#define SMB2_DHANDLE_FLAG_PERSISTENT   0x00000002
>  struct durable_context_v2 {
>         __le32 Timeout;
> -       __le32 Flags;
> +       __le32 Flags; /* see SMB2_DHANDLE_FLAG_PERSISTENT */
>         __u64 Reserved;
>         __u8 CreateGuid[16];
>  } __packed;
> @@ -157,13 +155,13 @@ struct durable_reconnect_context_v2 {
>                 __u64 VolatileFileId;
>         } Fid;
>         __u8 CreateGuid[16];
> -       __le32 Flags; /* see above DHANDLE_FLAG_PERSISTENT */
> +       __le32 Flags; /* see SMB2_DHANDLE_FLAG_PERSISTENT */
>  } __packed;
>
>  /* See MS-SMB2 2.2.14.2.12 */
>  struct durable_reconnect_context_v2_rsp {
>         __le32 Timeout;
> -       __le32 Flags; /* see above DHANDLE_FLAG_PERSISTENT */
> +       __le32 Flags; /* see SMB2_DHANDLE_FLAG_PERSISTENT */
>  } __packed;
>
>  struct create_durable_handle_reconnect_v2 {
> @@ -263,22 +261,6 @@ struct network_resiliency_req {
>  } __packed;
>  /* There is no buffer for the response ie no struct network_resiliency_r=
sp */
>
> -#define RSS_CAPABLE    cpu_to_le32(0x00000001)
> -#define RDMA_CAPABLE   cpu_to_le32(0x00000002)
> -
> -#define INTERNETWORK   cpu_to_le16(0x0002)
> -#define INTERNETWORKV6 cpu_to_le16(0x0017)
> -
> -struct network_interface_info_ioctl_rsp {
> -       __le32 Next; /* next interface. zero if this is last one */
> -       __le32 IfIndex;
> -       __le32 Capability; /* RSS or RDMA Capable */
> -       __le32 Reserved;
> -       __le64 LinkSpeed;
> -       __le16 Family;
> -       __u8 Buffer[126];
> -} __packed;
> -
>  struct iface_info_ipv4 {
>         __be16 Port;
>         __be32 IPv4Address;
> diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
> index f79a5165a7cc..25e8ece283c4 100644
> --- a/fs/smb/common/smb2pdu.h
> +++ b/fs/smb/common/smb2pdu.h
> @@ -1290,6 +1290,10 @@ struct create_mxac_req {
>         __le64 Timestamp;
>  } __packed;
>
> +/* See MS-SMB2 2.2.13.2.11 and MS-SMB2 2.2.13.2.12 and MS-SMB2 2.2.14.2.=
12 */
> +/* Flags */
> +#define SMB2_DHANDLE_FLAG_PERSISTENT   0x00000002
I prefer moving it when the durable handle structures are moved to
/common later.
Thanks.
