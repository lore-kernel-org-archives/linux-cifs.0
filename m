Received: from va-2-28.ptr.blmpb.com (va-2-28.ptr.blmpb.com [209.127.231.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B8736B07E
	for <linux-cifs@vger.kernel.org>; Mon, 13 Jul 2026 09:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783935406; cv=none; b=qM5nu9YvGnHiqZxDmpZPDA/R+yK9VbZ1EqK/01PvelSC4dS6nJFWXQuj188GJCldJESVTN/QV+6p143qdt/NQJEpMrCCZzSIFa5WZMW3cntR2j8fQfuL86/BYLqp7gm4YYc8DDaJ8gZKPe/Z8IF6cxUeU2JSZwGc/buy7/DCNCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783935406; c=relaxed/simple;
	bh=9AHAq4ADgEY7x0gebo+0UmF+sPpveeSRLqt9ygz6aHM=;
	h=Content-Type:To:Cc:Mime-Version:References:In-Reply-To:Date:
	 Message-Id:Subject:From; b=ovrt+YloTmDat/M9LLuJamcZWdWAiJxB+TB++tbGI53NbDGUxGsV6KvOcJBvP7t4dKMdx9rdes39cyFk4tENnWK/scrQSTjQElpDRw1Gm1ZxAHSuOJx5If8tDPjoTRYT9+2bn4CtyAqUwfnSU9LzwdWIqqS0yxDxFbRk/1TKHBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=brcbWvJ3; arc=none smtp.client-ip=209.127.231.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="brcbWvJ3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1783935399;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=9AHAq4ADgEY7x0gebo+0UmF+sPpveeSRLqt9ygz6aHM=;
 b=brcbWvJ3Yk3X1SJveges63dg8DXDG7Gl9orEQWk0LXHv/LAbyBg3KJL46pUcyyVYPugJrF
 OEZV6nSZFg6M0iTWnrcZvFdFuhDoSqrN1IPS1POnFRm3rsi8wsseSv+ALjZT7V4ncOSHd0
 ZZ9sd+0UUSbPoFc3YZgh+DYedMAjsiDIsTx314KB/u0XUJcb33GFilHcl9U/Y+aZilHK1G
 JEzJ5QsFgvayNQVF5QvN1tTdLtvH0+W0xYfjPhfZF0cKUAVztauujz9RfSzCMecVdbDGaA
 eAHkrx6wf89I6pHHJUdQU7AAs6voYTX2gc5ln6uz1MM/Qr2gK4vDQzRshUrFLg==
X-Lms-Return-Path: <lba+16a54b1a5+034051+vger.kernel.org+wangzhaolong@fnnas.com>
Content-Type: text/plain; charset=UTF-8
To: "Namjae Jeon" <linkinjeon@kernel.org>
Cc: <linux-cifs@vger.kernel.org>, <smfrench@gmail.com>, 
	<senozhatsky@chromium.org>, <tom@talpey.com>, 
	<linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260713071141.3909087-1-wangzhaolong@fnnas.com> <20260713071141.3909087-4-wangzhaolong@fnnas.com>
	<CAKYAXd-ymPFFLwW+a6_88LHL_tZXEuffUW8NymbSp3t+OZHosw@mail.gmail.com>
In-Reply-To: <CAKYAXd-ymPFFLwW+a6_88LHL_tZXEuffUW8NymbSp3t+OZHosw@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 13 Jul 2026 17:36:35 +0800
Message-Id: <5cf37150673ea4d5c28f94db91cdf68504b50522.bcc0e7a0.69db.419d.9f76.9089ceffc788@feishu.cn>
Subject: Re: [RFC 3/3] ksmbd: use splice payloads for simple SMB2 READ
From: "Wang Zhaolong" <wangzhaolong@fnnas.com>

Hi Namjae,

Thank you for the quick review.

> From: "Namjae Jeon"<linkinjeon@kernel.org>
> Date:=C2=A0 Mon, Jul 13, 2026, 4:59 PM
> Subject:=C2=A0 Re: [RFC 3/3] ksmbd: use splice payloads for simple SMB2 R=
EAD
> To: "wang zhaolong"<wangzhaolong@fnnas.com>
> Cc: <linux-cifs@vger.kernel.org>, <smfrench@gmail.com>, <senozhatsky@chro=
mium.org>, <tom@talpey.com>, <linux-kernel@vger.kernel.org>
> On Mon, Jul 13, 2026 at 4:18=E2=80=AFPM wang zhaolong <wangzhaolong@fnnas=
.com> wrote:
> >
> > From: Wang Zhaolong <wangzhaolong@fnnas.com>
> Hi Wang,
>=C2=A0
> Could you rebase the series on the current #ksmbd-for-next-next branch
> to test this ?

Okay, I will rebase the series onto the current ksmbd-for-next-next branch =
and rerun
the functional and performance tests.

> >
> > Use the page-backed payload path for plain TCP SMB2 READ requests of at
> > least 64 KiB.
> Could you provide benchmark results ? and requests smaller than 64 KiB
> are unlikely to benefit from this optimization? Theoretically, it
> seems like it would improve, but I am wondering how much performance
> improvement there actually is.

Regarding the 64 KiB threshold, it is currently a conservative value rather=
 than
a conclusion based on complete measurements. As noted in the cover letter,
I have already included initial results based on 1 MiB sequential reads, wh=
ere
the splice path showed a clear improvement:

=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0=C2=A0 baseline =C2=A0=C2=A0 patched =C2=A0 =C2=A0 del=
ta
=C2=A0 bandwidth =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1.=
728 GB/s=C2=A0 2.246 GB/s=C2=A0 +30.0%
=C2=A0 mean completion latency =C2=A0 604.1 us =C2=A0=C2=A0 464.5 us =C2=A0=
=C2=A0 -23.1%
=C2=A0 median sample P99 latency 794.6 us =C2=A0=C2=A0 606.2 us =C2=A0=C2=
=A0 -23.7%

These results were obtained in a QEMU environment with ksmbd and the SMB
client in the same guest, using a warm 4 GiB file, SMB 3.1.1, cache=3Dnone,=
 1 MiB
synchronous reads, and one job.

I agree that smaller requests may also benefit. However, for small reads, t=
he
overhead of managing pages and pipes might cancel out some of the gains
from reducing copies, so I chose 64 KiB as a conservative starting threshol=
d.

I will add benchmarks for a range of request sizes, for example 4 KiB, 16 K=
iB, 32 KiB,
64 KiB, 128 KiB, 256 KiB, and 1 MiB. Based on those results, I can either a=
djust the
threshold or remove it if the splice path remains beneficial for smaller re=
quests.

> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return false;
> > + =C2=A0 =C2=A0 =C2=A0 if (ksmbd_stream_fd(fp) || !S_ISREG(file_inode(f=
ilp)->i_mode) ||
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (filp->f_flags & O_DIRECT) || IS_D=
AX(file_inode(filp)))
> Since ksmbd does not currently open files with O_DIRECT, is the
> O_DIRECT check needed here, or is it only intended as a defensive
> guard for future support?
>=C2=A0

The O_DIRECT check is currently only a defensive guard. I added it
to ensure that the page-cache-backed payload path is not accidentally
used if direct-I/O support or another file-opening mode is introduced later=
.

I can remove the check if you prefer to avoid guarding an unsupported
configuration, or keep it with a comment explaining that it is intended for
future-proofing.

Best regards,
Wang Zhaolong
