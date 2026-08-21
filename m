Received: from mail-24417.protonmail.ch (mail-24417.protonmail.ch [109.224.244.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1285B352004
	for <linux-cifs@vger.kernel.org>; Fri, 21 Aug 2026 03:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787282188; cv=none; b=GkrkXL/jtxCEbuO3CHRKSIkSlXvGI8plO/cKrUozxG4E/NjT0KCnt3IOm94ux00m49fXKU+BDdU9OwzI7bpXi38wz1uVcoKKImPPy+OKxJE7JJ8oWIFBzYxaIkW5mHlg68TELKLOoL6ZAD4yku0+cJtsBLKihyRJc3e9tVAd9Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787282188; c=relaxed/simple;
	bh=y7IbmW/iEDIH2nH6DeCWorWowyeiXbgb9wII9SwnRX8=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dNh3Xo81JDUFfKE3kbbdAhsApef92GRswKOnNWlXlIsWTqdJlwRAeT92rNef9slVeO3DEd39ekBXKjetPwc38owjYq1PRzDS8tABqIdyjq/t7ODqrq1lplNFXa4HSY3UB1ZGsiQTr4PbcxsDA+VL3/5dfBl1USD+MjFLyknjrCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=NwqnjD0j; arc=none smtp.client-ip=109.224.244.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="NwqnjD0j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1787282173; x=1787541373;
	bh=y7IbmW/iEDIH2nH6DeCWorWowyeiXbgb9wII9SwnRX8=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=NwqnjD0jtBEoR0yZzNWQlEZMtdfJXPiJeHQJHqVlYMADLTfoCNQ4mlXgMKc2pR/iU
	 cdJj0rh96dfE2w4gCjLNhwVvl8wEDKEIvWxSz6pUnKiWPGcmB60qjCMifnanKK0NFN
	 CWjn05RIMOp+ouRi4/A39vw4nJf30lDgTR6l+W4kGUkP1urGAqF6jc/H4214jGho+p
	 UkTHy4ySgC5wWTrrIph6370HSvS7XVsNFeqiSMBlyWu3YeYtdnPnCkDSoi/Z8Ax2gj
	 yLb9OaSTYlE39KtDS0y8UKY7f9Up6hjHmuaDRKcNX38Weown5Au1vhzEY++GIawvf3
	 m4FNlXq3sa1Bw==
Date: Fri, 21 Aug 2026 03:16:11 +0000
To: Namjae Jeon <linkinjeon@kernel.org>
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, Shyam Prasad N <sprasad@microsoft.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Jeff Layton <jlayton@kernel.org>, Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, David Howells <dhowells@redhat.com>, samba-technical@lists.samba.org, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smb: client: reject a tree connect response whose byte count is too small
Message-ID: <20260821031606.345596-1-hexlabsecurity@proton.me>
In-Reply-To: <CAKYAXd9pNtfDCSt8+5fM5m1maww_gVeoEzmZpOD_mhGo6dEewg@mail.gmail.com>
References: <20260728-b4-disp-6b8e68d4-v1-1-e69277237297@proton.me> <CAKYAXd9pNtfDCSt8+5fM5m1maww_gVeoEzmZpOD_mhGo6dEewg@mail.gmail.com>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: d4dd73c672a88c66866f138ee48dad9d13c1cac8
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Namjae,

> Can you check the build warning that was reported by the kernel test robo=
t ?

It's mine. The three sites it points at are in the write path, but the
cause is in trace.h.

enum smb_eio_trace is __mode(byte), and the list has held exactly 128
entries since f80ac7eda1cf added it, which puts the last one,
smb_eio_trace_write_too_far, at index 127. My patch inserts
smb_eio_trace_tcon_bcc_too_small ahead of tdis_in_reconnect, everything
after it shifts up one, and write_too_far lands on 128.

It is worse than a warning where CONFIG_WERROR is set, and x86_64 defconfig
sets it: clang gives the enum a signed underlying type, converts the value
to -128 and the build stops. I reproduced that at v7.2 with clang 19.1.7 --
three errors and cifssmb.o fails, so v1 as it stands does not build there.
gcc gives the same enum an unsigned underlying type and says nothing, which
is why the tree had not run into it. Where WERROR is off, the recorded
value stops matching the __print_symbolic() table and those three events
print a raw number instead of their name.

So the enum is full for everyone, not only for me: the next
smb_eio_trace_* anyone adds lands on 128 too, and under gcc it does it
quietly. Of the 68 __mode(byte) enums in the tree this was the only one
with no room left, though rxrpc_abort_reason has 127 entries.

v2 is two patches: 1/2 drops __mode(byte) from enum smb_eio_trace, 2/2 is
the tree connect fix unchanged. I dropped the attribute rather than
widening it because on x86_64 the record does not grow either way -- the
field precedes an unsigned long at offset 8, so sizeof(struct
trace_event_raw_smb3_eio) is 32 whichever type the enum gets -- and a plain
enum avoids a spelling the tree does not use (all 68 __mode() uses are
__mode(byte)). If you or David would rather keep it packed and widen it,
say so and I'll respin.

Two corrections to v1 while I am here, both in the changelog rather than
the code. The initialised prefix is 256 bytes, not the 67 I wrote:
header_assemble() memsets 256 right after cifs_buf_get(), so the byte area
only starts past it from WordCount 111. And the impact is understated --
once bytes_left wraps, the bound handed to cifs_strndup_from_utf16() can
reach 65535 against a ~16 KB cifs_req_poolp object, so this is a slab
out-of-bounds read and not only an uninitialised one.

v2 is on the list:
https://lore.kernel.org/all/20260820-b4-disp-58f78a28-v2-0-1fb7a6cb1533@pro=
ton.me/

Thanks for the review.

Bryam

