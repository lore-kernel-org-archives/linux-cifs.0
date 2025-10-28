Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482592989BF
	for <linux-cifs@vger.kernel.org>; Tue, 28 Oct 2025 04:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761624179; cv=none; b=ee4ZlvR2xNq6vvvb/gl6ZvQVhsCrq/74dFarSm+StRuAHfAziHl3HyIZCa90mVcLZbIX+lSCT/ERvxoGoaVo4ZgUJI4mzLEYUW4mlEm357MaxM1dFfZb022aRhDrcdJnZSj37QJAVDUmB215uyrOgc0xf9Q9A3zT86kPuadgags=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761624179; c=relaxed/simple;
	bh=tQ76DelEERQRex/jtJZfPH2Uwy7MZJd5BE1h4O3y61o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YyEzW3E15Jlap8xNLNPDX0oGedsfJ+eVsVtHL2owAExqJLEPzTmluxcEpvRUeFAk9SHO3qoaSg0oCIBzCNlNOGuu94H7aSs35e0Ir1pl3Mr38d1a5rVp+XOauakZGCkRqdug0gO2pgdBHchEgyUg8HEtH8RdmXh+z1Si1fWuO2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AQZcFttU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AQZcFttU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1495C4CEE7
	for <linux-cifs@vger.kernel.org>; Tue, 28 Oct 2025 04:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761624178;
	bh=tQ76DelEERQRex/jtJZfPH2Uwy7MZJd5BE1h4O3y61o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=AQZcFttUAejCsBupzSJxXGQwIiKwwVZiJy7/3JYhRuyc6iJnRbNUt4Cr1G3n3FkQt
	 U+dSY6I00YwT1wjJA4LjPvKSO5H10uN5kAIBvMu6vNcdZaRGiUrWOXLvd3UwBTWcU9
	 zqI34c+Yfkp1/7w8GEIOHG4DKi8v0amTuXLqYMHt2ztYvtNL2yzyrTj7gEHZzntN48
	 Wiv2h2MiIysSCYtEbNVmIYKH1XVec67pnLk6NC5yr0vGtnHJ6xM/VftmcMMGn6AubP
	 rsNt9UHwtd2RfMXjY25Lz/UyE57019QBtqU/CA0Sbcpa5MxTYO9cBQ2AKsZON9D+da
	 prSGmeG+d1I8A==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-63c09141cabso8120775a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 27 Oct 2025 21:02:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW1ch+eqnlmWDDSgKscYykSNlJLK/9x8Urwestifng4xIVXmkvVBQLx6ptVqrwDSiWf7ShY8A2JMBkK@vger.kernel.org
X-Gm-Message-State: AOJu0YwiPfEA4la81ALch61AfbCF9xBQvQFetu+ztFtXAO2+r1dQ9OW4
	8yDGgeYr8skNVN/ldMc3+Zh9SwycH/FjDl8oyqqSe25XwDw8glnMBKuF3p0sUSJ/43JLh8kvl5R
	dDJC0HvzRO0mXGFBxToRF4K2US9EbWvI=
X-Google-Smtp-Source: AGHT+IHXAMLyGd3ViihkM7YWAwqC60GP3yExiGkJKKlISyVAqClcK8DRhTQvl1yvQUUGcMgAouco7qij1IZFRq6GO4Q=
X-Received: by 2002:a05:6402:280a:b0:634:c377:e188 with SMTP id
 4fb4d7f45d1cf-63ed7f0f51cmr2040695a12.6.1761624177528; Mon, 27 Oct 2025
 21:02:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251027071316.3468472-6-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd_u5+p5hjvQey+TM8w4+P7aN7zSfwDbrUKRtbwx4vtyDw@mail.gmail.com> <75086bc6-9747-4a10-b4ee-ebf9ffdf25ec@linux.dev>
In-Reply-To: <75086bc6-9747-4a10-b4ee-ebf9ffdf25ec@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 28 Oct 2025 13:02:45 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8zuJsy5FZxsEQtPCm1OqJ6Usr-6CPkVgoRPYnX3NiQ9g@mail.gmail.com>
X-Gm-Features: AWmQ_bkIhrtor2FjpadxESdE_tFAx0KuAPo1GLwDErGKEJHKMeO6tthrhAVNJOk
Message-ID: <CAKYAXd8zuJsy5FZxsEQtPCm1OqJ6Usr-6CPkVgoRPYnX3NiQ9g@mail.gmail.com>
Subject: Re: [PATCH v4 05/24] smb: move some duplicate definitions to common/smb1pdu.h
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org, 
	christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 28, 2025 at 12:58=E2=80=AFPM ChenXiaoSong
<chenxiaosong.chenxiaosong@linux.dev> wrote:
>
> Would it be harder to maintain if only part of the definitions are moved?
>
> Moving the related definitions together would make maintenance easier,
> that's just my personal opinion.
Please check Steve's reply on another mail thread.
If you think it looks weird, don't move them.

>
> On 10/28/25 11:42 AM, Namjae Jeon wrote:
> > On Mon, Oct 27, 2025 at 4:15=E2=80=AFPM <chenxiaosong.chenxiaosong@linu=
x.dev> wrote:
> >>
> >> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >>
> >> In order to maintain the code more easily, move duplicate definitions =
to
> >> new common header file.
> >>
> >> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >> Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
> > ksmbd does not use all smb1 pdus. Instead of moving all smb1 definition=
s,
> > move the ones ksmbd uses to smb1pdu.h.
> > Thanks.
>
> --
> Thanks,
> ChenXiaoSong.
>
