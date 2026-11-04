Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793756949;
	b=onsxoVSX2eIgUDWGnFR1OFXEBT/YpUvTS4IySHlfy4rzWJqjdmtjXcYL8CPvAj3406pU
	 uvZb6fP0NxjVUgCJ6l2ySbitfKUK9SkxHEe6EBArWV3rwJuanp3oNHXV7C/FzVoF+TQj7
	 ghDm70R75S6HsUCKKfSxasFvm91FtMJCSzsRQy7jC7cG97TtH/p7oeLK7W8wN2ENpCXTv
	 k1jg1Aq+tUtU/9w6hpMnOR4n3Ngc7MyaR4ubVwxZvEgWAYxQgdm8szXt4In4LtJM9NVto
	 Z00A+8zaItNMV4qurrWj+FxZQwBNa1qb8yNh70/D37cXvm5rk+ErlxwnWZMME/UYBJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793756949;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=O1Eyi9FmECbWJ8xIgK/wWHxJnjEdZ1h2P1PDsMI0jAE=;
	b=yij56a3loQBm6Mj4alDSZDmX57v5aB646M0SzbGclC/+eq6oL9Rdji3l0rKzK8kqaEqG
	 lGYgKRCyJ+cXYaSXRZVrIB5E8E6wHZ0Av14Wv99lYqZ4e6YZbUmcsVZ9WPvs9cPAwDzOR
	 VTnzK9tKoPavg7R/W2oAgS+IwddUjQk0QwrcHGPeBiStoYmuxeSkbFist4SNkt5TLpbV5
	 4okjg5u+gHXemqpUmrs8cKnbuiWJ7rpVnd5pX1qyvYEJH6llAAMgB3FLlMCK6Y3yI01TW
	 WxRaarzSlxZ0efUHX9mxYxY9p4c9gOvL+/NXZmci0MZFn9a4XboS8F77XEy5BcCx+tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g41ltNpF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA79606A31B
	for <linux-cifs@vger.kernel.org>; Wed,  4 Nov 2026 01:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g41ltNpF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F4A1F000C1
	for <linux-cifs@vger.kernel.org>; Wed,  4 Nov 2026 01:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793756948;
	bh=O1Eyi9FmECbWJ8xIgK/wWHxJnjEdZ1h2P1PDsMI0jAE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=g41ltNpFWAn/N0eRGe3VPjG82+fjwwcp7/V3FF90qnRyCn8+cR+uI3HgYEjPBHLtQ
	 FRahbYVQKesWMHVPo/C7j+1rlWK1oaOSlrWc+fyeKA9HziATHlxV4GU/K+wO2YzXhR
	 MbIQHUvh/FzZCoZxA8nrkRXSSrwPx60KDc2AwKXNyAOEtovZmBoz/s9j3sD7f8XDk4
	 Ijp3wjPvw2qh7CiyKEz1wdIL8HBKVOgEtEs/UOGhxmQ8Q/wIKzCVuLvlMRSUrkqRkJ
	 vCYvbBbHrgesGyTP7F8YbxLc2c/wTxhaedRO0CopszHx1NyRjbLuNw+dSTkzo5hwiB
	 xRUUyTPiUqrnw==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b21cf1a580so198436a12.1
        for <linux-cifs@vger.kernel.org>; Tue, 03 Nov 2026 17:49:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzfCxfl3ckfvRZE+J21HYxoTFy30J+gI1RiGjhz0a0Ppa3vxh/eQ+6BADBrup1RDllFumy4W8+wVTng@vger.kernel.org
X-Gm-Message-State: APuU4Z/pcbYlJITWLu+yDY1Y7TE3Yzgp5mBOlNnkq/eyu1talHV+aeDO
	ZxCpZecstVQ2fzTX8FQnCwIqhP29/fDF1O5SpKn1kKx/qngLHLZz/Aex80LCdJ/4vEACVt/aWPx
	ewNe55vCjnDi68VnniRVYEx4huLRyIO4=
X-Received: by 2002:a05:6402:449a:b0:6b5:4f86:3be2 with SMTP id
 4fb4d7f45d1cf-6b54f863ff9mr1346265a12.35.1793756947429; Tue, 03 Nov 2026
 17:49:07 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104010725.50071-1-icb@fastmail.org> <CAKYAXd_xB-2c=19qaNkAqB9a9rKsthGy4pCtJg+QW+J6Z23Q8g@mail.gmail.com>
 <e938dcd4-08b9-4da9-afe7-3e05c792abbf@chenxiaosong.com>
In-Reply-To: <e938dcd4-08b9-4da9-afe7-3e05c792abbf@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 4 Nov 2026 10:48:55 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8OdwexkiC6oRC8GwM4js+BoT-RdMkxm4yBaU00TDWrgw@mail.gmail.com>
X-Gm-Features: AclHuK8Tuv77wmZ1Apf_v8HDdbZsZJtKRVIxJ5wtzIFZx9u_OVBOoRrqsBzK2w4
Message-ID: <CAKYAXd8OdwexkiC6oRC8GwM4js+BoT-RdMkxm4yBaU00TDWrgw@mail.gmail.com>
Subject: Re: ksmbd: refactor security descriptor handling?
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: Ian Bridges <icb@fastmail.org>, ZhangGuoDong <zhangguodong@kylinos.cn>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 4, 2026 at 10:32=E2=80=AFAM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> I also plan to ask my team member ZhangGuoDong to refactor smb2_open().
> This function is over 1300 lines (900 lines a few months ago), and has
> had many memory leaks and refcount leaks.
Sounds great :) Looking forward to the refactor!

>
> On 11/4/26 09:19, Namjae Jeon wrote:
> > This sounds like a great idea. I=E2=80=99d been thinking about doing th=
is
> > myself, but haven=E2=80=99t had the time. I=E2=80=99d be very grateful =
if you could
> > take it on. Please go ahead and send an RFC series.
>
> --
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Chinese Homepage: https://chenxiaosong.com
> English Homepage: https://chenxiaosong.com/en
>
