Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F8038D
	for <linux-cifs@vger.kernel.org>; Tue, 14 Jul 2026 00:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783987266; cv=none; b=sM2YmzrrwyBwB7iFafHmxp/TWQNxkhbqxmtP9F40QRYFGyfgz4CXIf65QJTBbkwClEjGMjA7Q/jTnMV11Uj7C4xDdK/LIZOqmdbyyIT5AdSBxUsYubiZLYJ1b/L0DdJeI5SGG2SGCFciUGH5TeiqyDHSO8gexRbX9O0ZPTVYz8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783987266; c=relaxed/simple;
	bh=PnCRqXFOYnBRe02UJ8o9AgWckbGANVhnPqBjvXE1ylo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YN6GN7GBBCUb9EeCvqJ/xqAN/mUKg8gy6g3TAr7x+64x6rD2D8W/akbC5f2Wtf7A4+Mys8XWkysO/nbFNRduxJxiE6lQxb72uaSuQKWiILBfLPPttOJ4lju6WjXPfXdfZo6PLxeBBWdQ/UPs56GwaazgGR04F77yBysWSw9DhMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RltZjV00; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RltZjV00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BDA1F000E9
	for <linux-cifs@vger.kernel.org>; Tue, 14 Jul 2026 00:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783987264;
	bh=p8F53im0sxh6mvc+BhWcVgXRCy9JYrKNfE5BhQjte7A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=RltZjV00Zdh5UPaM0j4mLIX7tkK2dQEqedWM/AT6UNrSAr7ZGOah6u/RNCbWqa2aM
	 MMQyX2NjUIFj0OR9RhHxFpLkVnWEiPOBrXcF2tw6ZuD8Q/G0hpPVByNyNVU+bhobAD
	 py0luttZTK+PTqkXTcAiMNNIt9k9Tc+omls9UqgsLg9RD8tBMvqFss3k3BBhswieOU
	 OeqnvohHY8Gzfk3CmZKMTfO+a7iyPVgAEhArUMKVWNvIijBiHVGg1Z+jdODNSeNjex
	 rQKfqqSw5dmcmhS1ghhjNvyn73RLG2qB08ltD83B/Fb58YrHcpPyqdb+686T9ETw1J
	 zymI9oMfI0obA==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c15fd3a299eso67645966b.2
        for <linux-cifs@vger.kernel.org>; Mon, 13 Jul 2026 17:01:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpKoT3CuoP9ziC2rbRDbj8VQpJ89jgeXm2LgqXVvAxmiS1qDEohC2ovCFm6cJSmnhPCKJJlp1DaK0VT@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3KpEGEXnNhNYQhxEoNC2t1FacZ/xfR1zH8Qu3pMKu1MxUroa0
	VYBc36LY/Gv39jTbhFSWUcnXMmzfYrEzLskuySqugbO698ZTqjsiKGYx77sU7cQA4ZtnnKkzY7o
	woqPTvew5RV0O8E+c7W/eAuxXIiz5nf0=
X-Received: by 2002:a17:907:9809:b0:c12:5013:4b7e with SMTP id
 a640c23a62f3a-c161e93d948mr536124066b.18.1783987263649; Mon, 13 Jul 2026
 17:01:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260713215510.3288580-1-xmei5@asu.edu>
In-Reply-To: <20260713215510.3288580-1-xmei5@asu.edu>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 14 Jul 2026 09:00:50 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_jJHQwiu2yjs1hxk-r0k3A+YMq5Ax8oN1qdzWfoveycA@mail.gmail.com>
X-Gm-Features: AUfX_mze0dBow8AT66poMlo3sHkesoXkPRq2Y9ieDkNcgSc5H-87rs6YT9JfTwM
Message-ID: <CAKYAXd_jJHQwiu2yjs1hxk-r0k3A+YMq5Ax8oN1qdzWfoveycA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: validate compound request size before reading StructureSize2
To: "Xiang Mei (Microsoft)" <xmei5@asu.edu>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, Ronnie Sahlberg <lsahlber@redhat.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	AutonomousCodeSecurity@microsoft.com, tgopinath@linux.microsoft.com, 
	kys@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 14, 2026 at 6:55=E2=80=AFAM Xiang Mei (Microsoft) <xmei5@asu.ed=
u> wrote:
>
> When ksmbd validates a compound (chained) SMB2 request,
> ksmbd_smb2_check_message() reads pdu->StructureSize2 without first
> checking that the compound element is large enough to contain it.
> StructureSize2 is a 2-byte field at offset 64
> (__SMB2_HEADER_STRUCTURE_SIZE) from the start of each element.
>
> The compound-walking logic only guarantees that a full 64-byte SMB2
> header is present for the trailing element: when NextCommand is 0, len is
> reduced to the number of bytes remaining after next_smb2_rcv_hdr_off. A
> remote client can craft a compound request whose last element has exactly
> 64 bytes, so the 2-byte StructureSize2 read at offset 64 extends one byte
> past the receive buffer, producing a slab-out-of-bounds read.
>
>   BUG: KASAN: slab-out-of-bounds in ksmbd_smb2_check_message (fs/smb/serv=
er/smb2misc.c:402)
>   Read of size 2 at addr ffff888012ae31ac by task kworker/0:1/14
>   The buggy address is located 172 bytes inside of allocated 173-byte reg=
ion
>   Workqueue: ksmbd-io handle_ksmbd_work
>   Call Trace:
>    ...
>    kasan_report (mm/kasan/report.c:595)
>    ksmbd_smb2_check_message (fs/smb/server/smb2misc.c:402)
>    handle_ksmbd_work (fs/smb/server/server.c:119)
>    process_one_work (kernel/workqueue.c:3314)
>    worker_thread (kernel/workqueue.c:3397)
>    kthread (kernel/kthread.c:436)
>    ret_from_fork (arch/x86/kernel/process.c:158)
>    ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
>
> Reject any compound element that is too small to hold StructureSize2
> before dereferencing it.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Reported-by: AutonomousCodeSecurity@microsoft.com
> Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Applied it to #ksmbd-for-next-next.
Thanks!
