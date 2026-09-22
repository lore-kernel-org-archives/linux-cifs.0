Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAAB25B09D
	for <linux-cifs@vger.kernel.org>; Tue, 22 Sep 2026 01:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790040933; cv=none; b=VcpSYKsuaw7Q4KLAK0C4d7x/M5fXgCIWbeR5rrOReksrCUb0W1epi6/YtjDor7AerlZ4R5y4Zvs8MJgrfK1BuYJzkmlmYxzqoQSgXWGydArxcYLB84V3ubovHK6T7Sd9DazvSY9TPoOJ5dvf4+QOoIJu+Cp600KYtFIsiPX2pl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790040933; c=relaxed/simple;
	bh=j8xJQatrLDHckHQEPFHpuWazOq0+3MD11XNz2vDdfbE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e63jhvJd1WbQ5zf+wKUXUdsAd5iYNrFLJANqRlDUnH86Ka4SdvgQMDzrJdlKUPZ+xORfC8FVjpOVmu5uudREtCuIzBNcLSqERu2j8nbS8F5YqCynTT2I8CXYQrPdPmAQik1+849BGkQ7bTPuMbVcXUzesTchrSVj5nQTfO7r3AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A+YyT5do; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A+YyT5do"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252C01F0089C
	for <linux-cifs@vger.kernel.org>; Tue, 22 Sep 2026 01:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790040932;
	bh=iVMZ69N6521oqcOuPGqLHxFf8ZIKTjOI5rtJziJsruo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=A+YyT5do2K+LtXp0PAETgNUG7Lf+ElKq/8tEzxcRounNo3oizErUOaSJOvXYOGd1o
	 EUplz10rVHXe6/ZHbu9knT2yW9qcNzHWEsiCcW4U2+25XWgxu8XGoYEeaTXrqvtuPb
	 qDP3zwQYJb5rHwbF0Q46t6Bv/9aWMgrrshqMAfzaAKB8QOUl5j1sRkvZQ8TyLfQlRx
	 2+J/3BG8zi+ytapUpe+z/DynsXbrXSVkFduvDovNU/eu8K4eNEdJUB0xE2YDkthhf9
	 u6/oHwUnwygvEOMO1F1rLfnmTMyd/c8t8JGIY20ISJdc7eb5e4V0A5ssNKm0T0i4Ht
	 Eh3sQr1vSEIOw==
Received: by mail-ej2-f31.google.com with SMTP id a640c23a62f3a-c29703cb796so492987566b.2
        for <linux-cifs@vger.kernel.org>; Mon, 21 Sep 2026 18:35:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwitlUs+1xG7e8Jh0s+7M2UFt25rlCDyK+aoPR+cZ2u518aUqLRuuoc2zovwv+dLu6m+Q3jtToqXMZD@vger.kernel.org
X-Gm-Message-State: AFuF++lmlCRYW3kvtpFJtQy3zek5V+v/TFH73N3Pt5IZ+lCPQRQCBzwv
	ili8xbgopCmGxNxAvzZ+RGHKB7pNjlGMvn8oA8leAuvhP2XpXK9vXvvKTdb5tWb6b1HG4aZl22H
	vDawDVW9/OVg+Abkhb1Kj/JGMmv1Rivw=
X-Received: by 2002:a17:906:9f89:b0:c29:41c1:3779 with SMTP id
 a640c23a62f3a-c2a159a972emr1089843966b.11.1790040930758; Mon, 21 Sep 2026
 18:35:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260920053126.28654-1-gotenksIN@aospa.co>
In-Reply-To: <20260920053126.28654-1-gotenksIN@aospa.co>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 22 Sep 2026 10:35:16 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9G7o057WEQyv8QgXAL1dX9DrdGxOnLrgNkSYN073kDAQ@mail.gmail.com>
X-Gm-Features: AcwNN1X39V-HTl8xfGexe7XHsNqintVeQVxDVSupceuxMxLNYAErQNE7PAoOgXE
Message-ID: <CAKYAXd9G7o057WEQyv8QgXAL1dX9DrdGxOnLrgNkSYN073kDAQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] ksmbd: Windows 11 SMB 3.1.1 interoperability fixes
To: Omkar Chandorkar <omkar0926@gmail.com>
Cc: Namjae Jeon <linkinjeon@samba.org>, Steve French <sfrench@samba.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Omkar Chandorkar <gotenksIN@aospa.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 20, 2026 at 2:31=E2=80=AFPM Omkar Chandorkar <omkar0926@gmail.c=
om> wrote:
>
> This patch series resolves SMB 3.1.1 protocol interoperability defects
> in ksmbd affecting Windows 11 clients, rebased on top of the latest
> ksmbd-for-next tree.
>
> Patch 1: smb: compress: relax trailing flags in chained decompression
> Windows 11 leaves residual uninitialized bits in trailing compression
> chunk headers during chained writes (e.g. copying .vhdx files).
> smb_decompress_chained() previously rejected any trailing header whose
> flags did not equal 0x0000, causing connection drops (ECONNRESET) and
> Windows error 0x8007003B. Relax this check to accept non-chained trailing
> payloads while preserving validation on segment lengths and bounds.
>
> Patch 2: ksmbd: fix FSCTL_PIPE_TRANSCEIVE file lookup and response handli=
ng
> When querying the share list (e.g. browsing \\server or running
> 'net view \\server'), Windows 11 issues NetrShareEnum over \PIPE\srvsvc
> using SMB2_IOCTL with FSCTL_PIPE_TRANSCEIVE. Named pipe handles exist in
> sess->rpc_handle_list rather than the regular file table. While
> commit a3bcea7c819a ("ksmbd: exempt FSCTL_PIPE_TRANSCEIVE from the
> generic file-id lookup") exempted FSCTL_PIPE_TRANSCEIVE from the generic
> file ID lookup, the response PersistentFileId and VolatileFileId were
> left unpopulated (violating MS-SMB2 section 2.2.32), and invalid RPC
> handles were not rejected under rpc_lock.
> Fix this by validating the RPC handle under rpc_lock and populating the
> resolved response file IDs before dispatching the transceive request.
>
> Changes in v2:
> - Rebased series onto git.kernel.org linkinjeon/smb.git #ksmbd-for-next
>   at commit 4bb07a7d5852 ("smb/server: rename smb2_file_alt_name_info to
>   smb2_file_name_info").
> - Dropped the compound CREATE + CHANGE_NOTIFY response handling patch
>   from v1 because upstream already merged compound prefix response
>   dispatching in commit 906a62216339 ("smb/server: send compound prefix
>   before async pending response") and compound FID resolution in commit
>   524efc568ea5 ("smb/server: support compound fid in notify requests").
> - Refined the FSCTL_PIPE_TRANSCEIVE patch to populate response FileId
>   fields per MS-SMB2 section 2.2.32 and validate RPC pipe handles under
>   rpc_lock.
>
> Tooling and AI disclosure:
> AI tooling (OpenCode:gpt-6-astra) was utilized to assist in protocol
> trace analysis, specification cross-referencing ([MS-SMB2], [MS-SRVS]),
> and drafting. All changes were manually audited, static-checked,
> compiled, and verified against live Windows 11 clients.
>
> Omkar Chandorkar (2):
>   smb: compress: relax trailing flags in chained decompression
>   ksmbd: fix FSCTL_PIPE_TRANSCEIVE file lookup and response handling
Applied them to #ksmbd-for-next.
Thanks!
