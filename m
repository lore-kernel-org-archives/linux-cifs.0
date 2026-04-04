Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867F36F2F2
	for <linux-cifs@vger.kernel.org>; Sat,  4 Apr 2026 14:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775312906; cv=none; b=ZeW7TAfOL+6e3rv/GZaTJPLB9/HWB0UfSQXcri5HeJe4/N2kouRF6BIA6Nyq6MN2jvSetaHVx+Wsxwl2q+JsOEEiud1PrklxehJyQKeVQCwjz8EKQGL/QppnV1y/l6B2z6WIEB09HLIwAc8b5L50hYH1rBrxPKWcKtUbCsstCCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775312906; c=relaxed/simple;
	bh=OUskXKzbth7ggJphATMPraSMFrxkBsGJGt1vZJpuYsE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I4ygi7174bGegobQBF+e/+eeqyke6lfYF6Dp4y80qADiPHRNM5luIFXoMfuEINvOMC5OMJpu4DHcDfq3Wye93GNOfHANpg0LVzMd8kprh+JgwhFEUNPW3eD2YlxhkatDcKGwgX4tP1usqnSV+rg8AWhw7H7GmkLuN+Qcp2RSLvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lHn8yRTa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lHn8yRTa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D564C4AF09
	for <linux-cifs@vger.kernel.org>; Sat,  4 Apr 2026 14:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775312906;
	bh=OUskXKzbth7ggJphATMPraSMFrxkBsGJGt1vZJpuYsE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=lHn8yRTazkanj8XCubilvX701IGuS/ROzTEPPKSr/iU7yZl+OKaPpvj/hXPSOlDOk
	 1OQ27oQu8FtunopQ4ENg4S7gxcrjhhz3VPjbJxrLTRJ3poE9mGrIVJlWj0QDISF1wV
	 VKVliYQbob8xd8zs0yJH94vQRyBCYjmhQbhjCEeeiBAjNJ/tyg5hug9QTYosy76nqE
	 +xY2f1zED4Xd5B0wqhgak47GqkKU89EaumQ2VErHKXgQMuz+qRaqzd/cCK54rRN4Sy
	 /vJMfJnATzVleh8c612OqpSYQrLcvof4w7AQWwVUXcjMrYjvCZT5J5r2URfZy8vrjm
	 jpQZf3OrBBzcA==
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-66d65646c65so1925887a12.1
        for <linux-cifs@vger.kernel.org>; Sat, 04 Apr 2026 07:28:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXRziowyCJX8dvMpnBXU6txc/0kDJeMY3PCIPBqKnSWv7ps1i4QdpK8sV3Q1rPK/uzKKYisT1URyX9B@vger.kernel.org
X-Gm-Message-State: AOJu0YzLlg3t5kVka0EOD5R8lI6mHQy5df3l8zhgOfzTNY8408DKXkSm
	ZO1aTV03+A5f3dIWnFIZdVG2sJgan1xvF8A5LA5jzaawF8r+ozswkDtfR+ecTM0w+9uwRtBJdWI
	SHFXKz40lJWbMSaiWyr2F/U7aO6Zxkq0=
X-Received: by 2002:a05:6402:5254:b0:66e:192c:e5bf with SMTP id
 4fb4d7f45d1cf-66e3e3f39ebmr3148063a12.7.1775312904616; Sat, 04 Apr 2026
 07:28:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402083912.457676-1-munanevil@gmail.com> <CAKYAXd9Qnq6YgTfbS-59YATBvnbtKrX3w+D+WNk=izZVvQOoVQ@mail.gmail.com>
 <904cb9a8-2ff5-4725-8ce2-f70c4f98791e@chenxiaosong.com>
In-Reply-To: <904cb9a8-2ff5-4725-8ce2-f70c4f98791e@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 4 Apr 2026 23:28:12 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-izPxXKFuzEPYPknwUFG_jQ37yW90D1zCpO_zWxCNJQg@mail.gmail.com>
X-Gm-Features: AQROBzBXu3I4dM9IGZndTZBC4_7GX2bYTtUDu3bcdXjsg9He7krPwsJZgvx-Q_Q
Message-ID: <CAKYAXd-izPxXKFuzEPYPknwUFG_jQ37yW90D1zCpO_zWxCNJQg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix use-after-free in __ksmbd_close_fd() lock cleanup
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: munan Huang <munanevil@gmail.com>, smfrench@gmail.com, senozhatsky@chromium.org, 
	tom@talpey.com, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 4, 2026 at 2:03=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> Hi Namjae and munan,
>
> In `ksmbd_reopen_durable_fd()`, when -EBADF is returned, should
> `list_del(&smb_lock->clist)` be called?
>
> If my understanding is incorrect, please let me know.
I have updated the patch. Please check it.
https://github.com/smfrench/smb3-kernel/commit/38bf2f4ac44b0848677fd4d53940=
4b8c0de15b98

Thanks for the review!
