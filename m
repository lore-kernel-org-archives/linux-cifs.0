Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794925572;
	b=lwJ5b/GkrfDhfBc6zTrDF4VKDvDZ0Y5rp5XkvYVK6nPUVXQ4r/Q6i/19z5LA7BzJcEPm
	 Cj+wN39/nZaoI6oFMMlCKYeWzjpslhy3SrGY+g0Ukj4epB4PS8o3sy5qfCGyg1gBXKiv2
	 EMopd1N1nEZoT8I0d8GvbvJjwOyLTGc2OAjAB8OsfVM7Gn8Ey0mcNdWMWzwa6nhEL+1qz
	 SCV+YoxvGMWjqzgtyinqYVNj8R08Jl5qh2cXf98uRVA0vHVNW7g2+vn5351TL3SU+tdRe
	 wDXuxg+VihARCCgNcISGQBPh5dL770PAmjq3NWRWQIQ7vAPVvTrBactyK+hBMrpv1ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794925572;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=MeZXy8q2Ih+PhsE8XTbG3dzHJIOEGKbRkjxXjSuBUGY=;
	b=rNRhaiy9bwh615tUEFmo1dtL6LvuXcE7AzgRZATplawYWAI705hWuayuvNeDQVDDuX8B
	 maac0YSJftAPb2BeW9dB2gN7/vEEltW8iHeVdWe4SBHqLeyTyGnISr2FeA/q9peq68b+V
	 v9bUFMdZv4Xbestvlc0jxeof+3tvV6dgva9cgtixF5gk+DtmvJnKNg9wUzf3PSYnBh8Yc
	 OMI1AAMiNPRQ4kG6NUj/GFXzO5hFSNyYRE0ssPR8AIWx41ZQ3b9WzbsJ12jO46awUlgDs
	 /gwJuYcJXQT3aqcV/uqKEpcYlYDL7PZ3pEj332FGcMTNNmqEY27bGax7u0IkrySVJUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="I3aD/hMR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AF4606A31C
	for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 14:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I3aD/hMR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23EA1F000C5
	for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 14:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794925572;
	bh=MeZXy8q2Ih+PhsE8XTbG3dzHJIOEGKbRkjxXjSuBUGY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=I3aD/hMRmCXrk/MUDFMtHtgXk1YjfbHU/R5hB2erHIQqeEKgnYs93v9rkRznQRdxg
	 Q1YAKG/I9hjrgq39Z6abSt1P0LmkAzOdLy9rbVWuJVXD+kDwGYE9IAu5SHl/Omr6aR
	 DMURgRLPyvdwYJV5/cZyXOMS4zWSeghJik1jjyme//HlbSOtaU3weczE03ZZvqCQ18
	 KkaHXyf7mdxTJCZ787tsn8GpybeEoZ9IYJGALKhYlNlGvfuu/WLNOgyXK+cPU2DnRk
	 JmDQx/EOZ1fO5uWF2aqbY5MRxaFQQsn24dCbSvwDJoTh/58mkOVO77AjCeYEs8psoK
	 I+lrIfnIgpdMQ==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c4cb6834eaaso328977866b.2
        for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 06:26:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEghJGazfF3IsDpcd2iNepM9bwKJvBdYECZYfZLdiKtlMEorqjFUiw4denABwjKrK2S6LnkJcIFn7Lx@vger.kernel.org
X-Gm-Message-State: APuU4Z/sHmOoNTsn3gGizPBD/nLrWMN982IAb5nT7E2CO1mPOs/pkhrD
	xQj/iqHNMq2hODSoPPCXxfohrII9UQO+4ycIYLyI8Dt/PN6b8vidmSccTg5EQ/DSXtb14JsVRrB
	A/0xuVvqRJSZ4MK7QApXMpvzEbV04qz8=
X-Received: by 2002:a17:907:84b:b0:c35:3880:773b with SMTP id
 a640c23a62f3a-c50963f11f7mr1262630166b.45.1794925571278; Tue, 17 Nov 2026
 06:26:11 -0800 (PST)
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
 <CAKYAXd9KT=1vLYsnRKxmiM6pLJQNACXuodD8wNQzb8S5apiuRQ@mail.gmail.com>
 <CA+Fu+LPL7xqpV_vjjjehedOFtuuBqgZHZTSqJ+FgweUpYo2uBw@mail.gmail.com>
 <CAKYAXd--x9UajLQwzRUwxRZ7PFW5T02xyHdSAnThAo326p_kxw@mail.gmail.com> <CA+Fu+LPnXMd9rMtywkZL77XzLq8n+8AiBW2T8Cau10YnVbofiQ@mail.gmail.com>
In-Reply-To: <CA+Fu+LPnXMd9rMtywkZL77XzLq8n+8AiBW2T8Cau10YnVbofiQ@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 17 Nov 2026 23:25:59 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-xM=gmpjz7g0+n+ZBA4Vb0Sz2i7B89Cs7XdHUY7U6WdA@mail.gmail.com>
X-Gm-Features: AclHuK9JTQa9SIWmjqwwfpK78wDn5ohzB29NrsN34utRaMM5yFJc2lxS4MQQN1I
Message-ID: <CAKYAXd-xM=gmpjz7g0+n+ZBA4Vb0Sz2i7B89Cs7XdHUY7U6WdA@mail.gmail.com>
Subject: Re: [PATCH RFC v1] ksmbd: add use_unbound_wq module parameter for the
 ksmbd-io workqueue
To: Stefan Chulski <stefan.chulski@broadcom.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ilya Lifshits <ilya.lifshits@broadcom.com>, Huiwen He <hehuiwen@kylinos.cn>, 
	Gil Benamar <gil.benamar@broadcom.com>, Florian Fainelli <florian.fainelli@broadcom.com>, 
	bcm-kernel-feedback-list@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 17, 2026 at 5:51=E2=80=AFPM Stefan Chulski
<stefan.chulski@broadcom.com> wrote:
>
> On Tue, Nov 17, 2026 at 3:34=E2=80=AFAM Namjae Jeon <linkinjeon@kernel.or=
g> wrote:
> >
> > On Mon, Nov 16, 2026 at 9:52=E2=80=AFPM Stefan Chulski
> > <stefan.chulski@broadcom.com> wrote:
> > >
> > > On Mon, Nov 16, 2026 at 2:10=E2=80=AFPM Namjae Jeon <linkinjeon@kerne=
l.org> wrote:
> > >
> > > While both address the underlying scheduling limitations of per-CPU
> > > workqueues for ksmbd, my patch introduces the `use_unbound_wq` module
> > > parameter rather than changing the behavior unconditionally. Because
> > > the optimal behavior (cache locality vs. load balancing) heavily
> > > depends on the specific workload and platform, this approach keeps th=
e
> > > existing per-CPU behavior as the default while allowing platforms to
> > > easily opt-in to the unbound workqueue when it yields better
> > > performance.
> > Could you provide the benchmark setup and actual results? If
> > WQ_UNBOUND generally performs better across representative workloads,
> > We could make it the default and provide a module parameter to opt
> > into WQ_PERCPU instead.
>
> These are the results from our embedded systems featuring dual-core ARM C=
PUs.
> The benchmark setup is fairly simple: writing to a USB disk over the
> network. Because the network traffic is a single 5-tuple TCP stream,
> it is pinned to one of the CPUs (depending on the 5-tuple hash).
>
> We tested this on two different platforms and saw the following
> throughput improvements:
> Platform 1: Improved from 178 MB/s to 210 MB/s
> Platform 2: Improved from 215 MB/s to 263 MB/s
Okay.

https://lore.kernel.org/linux-cifs/20261022092514.2590010-1-huiwen.he@linux=
.dev/

Huiwen=E2=80=99s RFC also provides a write_wq module parameter, disabled by
default, so both approaches keep per-CPU request processing as the
default. The main difference is that Huiwen=E2=80=99s patch routes eligible
single-channel WRITEs to a separate unbound queue, while your patch
switches the entire ksmbd-io queue to unbound.
So, Could you test Huiwen=E2=80=99s patch series with write_wq=3D1 on your
platform and compare the results with your patch ?

Thanks.
