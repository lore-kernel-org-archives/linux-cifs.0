Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794879268;
	b=j3eaz3zccHHHViL6jMITDCC4KMEIqq/7gD8lHKMkTLjc3zYzEWP067ka5T8cNdn0HOjz
	 +9nfHXUG3FvBDKOI3+zDz8uIsTDPE3y5F/Z5ECAeF4UCYyclxfxu6zeSfdo0BJo3Bog/O
	 QjD+zlv9Tauao1Shta5tWn3StbijzXtmXY5rx3zlLSi1I/k/E+e9HCZzSBvXFwn2L/Pkg
	 RxBvJhxTvjNccdkFhPT6JEFZ/aHM7mwsjfHHBYzqnpYnB5WNno5bO2CHpdwpZO1ykW1ZI
	 p2pqrhS441Y+lZqolWq0Lu3cAgARm0KsIFYr3tLWC7OGr95WCtY1C13xGhxtVoRXEeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794879268;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=6NFvMXt49n0aMhQ+tPrYzjCU429v93v4p/pcosygBN4=;
	b=Fgjnbh52ZAHNE86m3IBNSAPUZJf9Qci9ONLL/EaNYOBMeSRRcgc4OnITQk7rtHHc5ZbS
	 Mwe4Soh6RGzwT9/o2DLPQgizMTMoTfTMyam6cSeVjy3BYP4PmG6nMtskcyNUp/8kdOfpX
	 nxZ1UkAV1BPmqIqCUAGX9MepLh0oiNhWZn3NRpx0Z7BaKjjZyOxXnfuxTacdzBHBgBs5X
	 PhlHhNh3hK5fK04iN8t+3C1ls0lGWrBbcAHsxHSXz0y27NDfhlbGOjgy2n3o2qyh3eizF
	 Xd2QPOYP9Vr/ORtotnVnw2m60B4LH6VDR3FZqNaPK6/6/dI8ze/x8mEqQrTgHSOS3WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lIXtZVi+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E634606A31C
	for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 01:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lIXtZVi+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02E51F000CA
	for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 01:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794879268;
	bh=6NFvMXt49n0aMhQ+tPrYzjCU429v93v4p/pcosygBN4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=lIXtZVi+fCWm+GTs6b+USE4T2SqmX3VeNqyLAjeClqIVga3wBTP4CjEKURvJGP4ta
	 eqzNRgUw3cwF7S1NK7vTNyOYM1GtOOAg3u1dYdapR3q8+/D4bhGfoJMuNgp6cAwbeM
	 wKsDFmJ2kUQPQaFhEeypS+fOUnmMY5JX00AxWLzI87P4C/f5vw8GqmNrBj4Sf4UamI
	 797noCQEpa5vt9B0dQjU39xGDxz9hgw8Lc6qDAfR5zt+MI8pZB6UZzk0azJ4X26km/
	 Z1K/qyFU+Cj67aTSfBfv0vZpHubW34P7gKpXfxc3IwpTR3DDbhYUcbN0fMEPf1jmkh
	 rbf+CVW9Id8rA==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b807aab44fso2314864a12.2
        for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 17:34:27 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFoMWFD6tc02Nf3aq5QtTGAXWRgAxOx8k/IQmFZxHw8Wb6txQGEM6rmjqWG7G6IzrE8hmzwyfpyQTm2@vger.kernel.org
X-Gm-Message-State: APuU4Z+yrHzKOYQB0vo2Z6dRuXln6/w7utCw1mM0fIdMuT9cSdj12LwJ
	l+NACiD/N5O9sAA05fBG6dijaN9+MabnUkrcOTKp9cArLjX3Etn/qUACqeSdpRgxtIMZIHE13l6
	aAnkjKUplBSdKx+IJmY3EQyPhOM24dGE=
X-Received: by 2002:a17:906:c14d:b0:c50:5cd7:2901 with SMTP id
 a640c23a62f3a-c509640bfa8mr990170866b.23.1794879266573; Mon, 16 Nov 2026
 17:34:26 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116074849.475815-1-stefan.chulski@broadcom.com>
 <CAKYAXd9KT=1vLYsnRKxmiM6pLJQNACXuodD8wNQzb8S5apiuRQ@mail.gmail.com> <CA+Fu+LPL7xqpV_vjjjehedOFtuuBqgZHZTSqJ+FgweUpYo2uBw@mail.gmail.com>
In-Reply-To: <CA+Fu+LPL7xqpV_vjjjehedOFtuuBqgZHZTSqJ+FgweUpYo2uBw@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 17 Nov 2026 10:34:13 +0900
X-Gmail-Original-Message-ID: <CAKYAXd--x9UajLQwzRUwxRZ7PFW5T02xyHdSAnThAo326p_kxw@mail.gmail.com>
X-Gm-Features: AclHuK-kfPqc8Bh37Jzng9-4IO0zn_61dopqd1mYNeZxWXG2ijut7JfpzpvArRM
Message-ID: <CAKYAXd--x9UajLQwzRUwxRZ7PFW5T02xyHdSAnThAo326p_kxw@mail.gmail.com>
Subject: Re: [PATCH RFC v1] ksmbd: add use_unbound_wq module parameter for the
 ksmbd-io workqueue
To: Stefan Chulski <stefan.chulski@broadcom.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ilya Lifshits <ilya.lifshits@broadcom.com>, Huiwen He <hehuiwen@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 9:52=E2=80=AFPM Stefan Chulski
<stefan.chulski@broadcom.com> wrote:
>
> On Mon, Nov 16, 2026 at 2:10=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.or=
g> wrote:
> >
> > On Mon, Nov 16, 2026 at 4:49=E2=80=AFPM Stefan Chulski
> > <stefan.chulski@broadcom.com> wrote:
> > >
> > > The "ksmbd-io" workqueue has always been per-CPU. Commit 69635d7f4b34
> > > ("fs: WQ_PERCPU added to alloc_workqueue users") only made that
> > > default explicit as part of the treewide transition to unbound-by-def=
ault;
> > > it was not a ksmbd-specific decision.
> > >
> > > Per-CPU work keeps request processing on the CPU that queued it, whic=
h
> > > is good for cache locality, but it also runs work on CPUs that were
> > > isolated from workqueue noise (isolcpus=3D, nohz_full=3D) and prevent=
s the
> > > scheduler from placing blocked or long-running workers elsewhere.
> > > Which behaviour is better depends on the workload and platform.
> > >
> > > Add a boolean use_unbound_wq module parameter. It defaults to false, =
so
> > > behaviour is unchanged unless it is set; when true, "ksmbd-io" is
> > > allocated with WQ_UNBOUND instead of WQ_PERCPU. The "ksmbd-break"
> > > workqueue is already WQ_UNBOUND and is not affected.
> > >
> > > Document the parameter in ksmbd.rst.
> > >
> > > Signed-off-by: Stefan Chulski <stefan.chulski@broadcom.com>
> > Hi Stefan,
> >
> > Do you have numbers comparing the per-CPU and unbound queues,
>
> Yes, on our systems we observed up to an 18% performance improvement
> when using the unbound workqueue.
>
> The primary reason for this improvement is that with the default
> per-CPU workqueue, ksmbd-io work can sometimes start on a CPU that is
> already heavily loaded. Because it is bound to that specific CPU, the
> scheduler cannot move it to a less loaded or idle CPU, leading to
> bottlenecks. By using WQ_UNBOUND, the scheduler is free to migrate the
> work to less loaded CPUs, which significantly improves our CPU cycle
> efficiency.
>
> > How does this compare with the earlier following RFC ?
> >
> > https://lore.kernel.org/linux-cifs/20261022092514.2590010-1-huiwen.he@l=
inux.dev/
> >
> > Thanks.
>
> While both address the underlying scheduling limitations of per-CPU
> workqueues for ksmbd, my patch introduces the `use_unbound_wq` module
> parameter rather than changing the behavior unconditionally. Because
> the optimal behavior (cache locality vs. load balancing) heavily
> depends on the specific workload and platform, this approach keeps the
> existing per-CPU behavior as the default while allowing platforms to
> easily opt-in to the unbound workqueue when it yields better
> performance.
Could you provide the benchmark setup and actual results? If
WQ_UNBOUND generally performs better across representative workloads,
We could make it the default and provide a module parameter to opt
into WQ_PERCPU instead.

Thanks!
>
> Thanks,
> Stefan
