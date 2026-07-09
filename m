Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD00C257827
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 13:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783602696; cv=none; b=H2qW54UY68lsQ02xP4Rm6OvqoMMuVfnhVS3Cdk2yWpnouwKWsXBWtnq8za5HihmJwxrFUoNR/QfP7k0nF02FqS8zufJzapYsT74chW70fmzVF6KYqVnjUaDCowW9mTszUvDVeaEic3kJBngMPOg9F+VYOaSlOeEeIhg4POnMtpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783602696; c=relaxed/simple;
	bh=Q9RO21pG2AuCtcLBQC/U7w3+hIQxw6oBprM7RboviPU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VKebTXnYI7KyPrMs69HmV/H9iJMNPHGwav1HKy790e2GGICAHmUODCJu2/VQKA0svLw16ePtsYDAJjRdWQ3CTodEDoJ7+MXHQXJ/T/+K3tOmccV3yyj7bKzdd7D94x3elHQH9aB1gYp9SkzYKrtPbc/lMCf9T8AnOZJGSSP7vLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FDgE/LFj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FDgE/LFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4EF61F00A3F
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 13:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783602695;
	bh=kkTZWFiHxvczmSLEmIPoiJ7/TxUeQ4QJUgW2kowXnfc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FDgE/LFj90KvrW7+OXuzCew61M5uNiqQaz6WbKUd4CikGOxz1KHRfUYcT9Qxu7PBv
	 dHRjc23Ar4FtjhPGQ2ZbcNyh6dMHphnP6TuWv4xu7tUdT6tz96MafVor1v6wPijy9Z
	 /ywxWzvLuOpkDjLUrNsrwymAvWhdXluY6oyiisYnKek2LV2ZGeYXbO5Abwq3Ynr6jf
	 YD3fqFyVa7Sa2thOM/jAWPGUc3F4fYvarjq9ja4atm9jCOV/sxdxfcvXuKNS6UNKUg
	 nRs6RV4S4unaak3NIugzGiagFOHC+Ecl93YGPSA/0se8megWNP1jwuQ27noyInc23r
	 SzPgv1wriQKPA==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c15e3141d02so103210766b.2
        for <linux-cifs@vger.kernel.org>; Thu, 09 Jul 2026 06:11:35 -0700 (PDT)
X-Gm-Message-State: AOJu0YxpusC6DfTT+PDF7QqrmC8l6ckznKB81/1nghwymJ2VyGAxpBjw
	PXkeIlpUuKauUJe09nl6uaMp8WL+XJOaqkB/b2I4fZh7ZpCNVLuwNRYgdr2gvKl7NDduE3c2GS0
	RpL+4Fx/2TnPI9kRWsVaY4C44o2LHTGI=
X-Received: by 2002:a17:907:a43:b0:c12:1c2a:16e6 with SMTP id
 a640c23a62f3a-c15ce0b2f35mr324333366b.23.1783602694398; Thu, 09 Jul 2026
 06:11:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260708125912.1223345-1-ematsumiya@suse.de>
In-Reply-To: <20260708125912.1223345-1-ematsumiya@suse.de>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 9 Jul 2026 22:11:20 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9-GV+1ELu9YQt0RXVSvXwL+JjNwwyf0z7dN+cUqxNHsA@mail.gmail.com>
X-Gm-Features: AUfX_mzEghB8nsb4BfMQF7RuvAzok8aLn3b0pxr-1NYeRivM6e2JPfwP0Io_g0M
Message-ID: <CAKYAXd9-GV+1ELu9YQt0RXVSvXwL+JjNwwyf0z7dN+cUqxNHsA@mail.gmail.com>
Subject: Re: [PATCH v2] smb: server: fix leak of ksmbd_ipc_login_request_ext()
 returned buffer
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, tom@talpey.com, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 8, 2026 at 9:59=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.de> =
wrote:
>
> Free it unconditionally after ksmbd_alloc_user() calls.
>
> kmemleak splat:
>   unreferenced object 0xffff888103b83540 (size 192):
>     comm "pool-0", pid 16970, jiffies 4377290937
>     hex dump (first 32 bytes):
>       00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
>       00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     backtrace (crc 408ccc66):
>       __kvmalloc_node_noprof+0x730/0x920
>       handle_generic_event+0xec/0x1a0 [ksmbd]
>       genl_family_rcv_msg_doit+0xe0/0x130
>       genl_rcv_msg+0x181/0x290
>       netlink_rcv_skb+0x4f/0x100
>       genl_rcv+0x28/0x40
>       netlink_unicast+0x1e6/0x2c0
>       netlink_sendmsg+0x20a/0x450
>       ____sys_sendmsg+0x2e8/0x310
>       ___sys_sendmsg+0x78/0xc0
>       __sys_sendmsg+0x63/0xc0
>       do_syscall_64+0xa1/0x670
>       entry_SYSCALL_64_after_hwframe+0x76/0x7e
>
> Fixes: a77e0e02af1c ("ksmbd: add support for supplementary groups")
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Applied it to #ksmbd-for-next-next.
Thanks!
