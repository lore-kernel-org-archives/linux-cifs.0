Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF5D2C0294
	for <linux-cifs@vger.kernel.org>; Sun, 20 Sep 2026 01:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789868270; cv=none; b=B/tUAZZTTdV/vPb+TqvyygYmT8/FfHTAWlM0fmrt+357Hv2ju9oNn3TLlryUFuphT1GB2MBCnQD4y+qGEZelJsFMcJXmI/TY6bf/xdxF1XIgTU8CIdk9IHRi4rXzokPk1PWmLPC5s1gSiZEBQr5tFP4N/fMrvzp2AmnBPZr6rZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789868270; c=relaxed/simple;
	bh=ThPmt7Tt9Xa+lr+h2A+0uZIW3UGNP7WEneu3WtLFvU8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j3PWd6OOHchODiYyVBbkaZjLrucrAfbTF5WHgw96cwaj1OHUZ1zfMmC+Eh2OUWWTei4FABAyiOJgEHaprMgEZvpupys0QvwzXg87pn8mJXiwvrEOcqYEPAwLBXMLDbgA+O+Get6FenyDB99LWtQlQzQmph7j++eTE8ZSgZ1AweM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b4F6DsA1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b4F6DsA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E97F1F000FF
	for <linux-cifs@vger.kernel.org>; Sun, 20 Sep 2026 01:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789868268;
	bh=c7VbFp+goxEnOdKdCkJpX7eK9KOGq5ealBaszLOs1Kc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=b4F6DsA1Q8gkOpEZoU4iOeSrd2wusiiKlEtNaaIbvwYI4OR7LXoki2Gr59/3paMjM
	 7XXbde7v9O1gkqpXIXDgThcCqiFaay+twPr/nKbyNpTlJg5yat6ziNCS8hHC6iMa1W
	 M3siNXNVEklCPoXkjcEjAkfbmP+M7HZF3FJ86xGju+rrFkHsWiOvp8oN6me0nbnh1B
	 MT41jBmDpYLr43JgpVFxhA7dyaUwTSeLLTULuvZPdKXfP4zssxvLIFJEzPFrjxVNOD
	 aWCII7k7PtNwUISAKVWF4lAmr3hDEo4enuadJqCEZYba+3On5Lw5uUx9YEi8Fp2PS6
	 KhvrdX4hTGwnw==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6aa487e2337so2916747a12.0
        for <linux-cifs@vger.kernel.org>; Sat, 19 Sep 2026 18:37:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw3nLhRrERPiHZqjm9suzbT4U89EvvBgpur6skdSFCpEHHWDgh7nEhsGkHM95CnXtLhYBB4qlhLTIDC@vger.kernel.org
X-Gm-Message-State: AFuF++kgGxZ7ZW+LYEma5bXWS30OiFO7mZLTjeLmK90hFFm6eqmPkhuh
	f9OWUcrfwT2SxtaMweiQsceJia5SFtk7cv4QrlLOuV5a1WzZDd92dSGX0/nd5JKn3oA06kZ+PMa
	2AAQJ/cBgymuXpie0buliLzBjGqL3zNM=
X-Received: by 2002:aa7:cb1a:0:b0:6aa:1d71:4a7a with SMTP id
 4fb4d7f45d1cf-6aa36e04b69mr6215931a12.12.1789868267097; Sat, 19 Sep 2026
 18:37:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260919122910.2382-1-gotenksIN@aospa.co>
In-Reply-To: <20260919122910.2382-1-gotenksIN@aospa.co>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 20 Sep 2026 10:37:34 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-B6TC+U5EtZgdC22xt6MDGDP3WCPri8G5zY75rvprxug@mail.gmail.com>
X-Gm-Features: AcwNN1WW5lq9V4f5n4UzT-yP-FTUn3q82YUJ4gBvDFcj9KnMRO665trK2dzhoIg
Message-ID: <CAKYAXd-B6TC+U5EtZgdC22xt6MDGDP3WCPri8G5zY75rvprxug@mail.gmail.com>
Subject: Re: [PATCH v1 0/3] ksmbd: Windows 11 SMB 3.1.1 interoperability fixes
To: Omkar Chandorkar <omkar0926@gmail.com>
Cc: Namjae Jeon <linkinjeon@samba.org>, Steve French <sfrench@samba.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Omkar Chandorkar <gotenksIN@aospa.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 19, 2026 at 9:29=E2=80=AFPM Omkar Chandorkar <omkar0926@gmail.c=
om> wrote:
>
> This patch series resolves three separate protocol interoperability
> defects in ksmbd that affect Windows 11 clients:
>
> Patch 1: smb: compress: relax trailing flags in chained decompression
> Windows 11 leaves residual uninitialized bits in trailing compression
> chunk headers during chained writes (e.g. copying .vhdx files).
> smb_decompress_chained() previously rejected any trailing header whose
> flags did not equal 0x0000, causing connection drops (ECONNRESET) and
> Windows error 0x8007003B. Relax this check to accept non-chained trailing
> payloads while preserving validation on segment lengths and bounds.
>
> Patch 2: ksmbd: fix compound CREATE and CHANGE_NOTIFY response handling
> Windows Explorer opens directories using compound requests chaining
> SMB2_CREATE with SMB2_CHANGE_NOTIFY under SMB2_FLAGS_RELATED_OPERATIONS.
> smb2_notify() checked for all-ones sentinel FileIds before resolving
> compound handles, misclassifying the request as a macOS Time Machine
> sentinel and dropping the preceding CREATE response buffer when setting
> send_no_response =3D 1. This left Explorer hanging for 60 seconds.
> Fix by resolving compound handles first and immediately dispatching
> the completed prefix CREATE response before deferring CHANGE_NOTIFY.
>
> Patch 3: ksmbd: fix FSCTL_PIPE_TRANSCEIVE file lookup and response handli=
ng
> When querying the share list (e.g. browsing \\server or running
> 'net view \\server'), Windows 11 issues NetrShareEnum over \PIPE\srvsvc
> using SMB2_IOCTL with FSCTL_PIPE_TRANSCEIVE. Named pipe handles exist in
> sess->rpc_handle_list rather than the regular file table. Because
> FSCTL_PIPE_TRANSCEIVE was omitted from the no_fileid_ioctl check,
> smb2_ioctl() failed the file lookup with -ENOENT and returned
> STATUS_OBJECT_NAME_NOT_FOUND (0xc0000034), causing Windows to report
> RPC_S_CALL_FAILED (error 1726).
> Fix by validating the RPC handle under rpc_lock and bypassing the
> regular file lookup for pipe shares.
>
> Tooling and AI disclosure:
> AI tooling (GPT-6 Astra / OpenCode) was utilized to assist in protocol
> trace analysis, specification cross-referencing ([MS-SMB2], [MS-SRVS]),
> and initial drafting. All changes were manually audited, static-checked,
> compiled, and verified on physical hardware against live Windows 11
> clients.
>
> Omkar Chandorkar (3):
>   smb: compress: relax trailing flags in chained decompression
>   ksmbd: fix compound CREATE and CHANGE_NOTIFY response handling
>   ksmbd: fix FSCTL_PIPE_TRANSCEIVE file lookup and response handling
Could you please prepare and send this as a patch series based on the
latest #ksmbd-for-next ?
Thanks!
