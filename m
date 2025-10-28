Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F482777FC
	for <linux-cifs@vger.kernel.org>; Tue, 28 Oct 2025 03:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761622973; cv=none; b=g8ndURa9AmvIrqD61810maX6vDR8r+RuGZtThTZYC764fnTnohjvMgakE5gDvsIAtX0WhoMwRsP+xsCoVOCeRGFjyLmPbKZXv2CYqeH+w4oTYNPpmYa+O664fQGWE9+E0fccJ16wNeOvInmQGHNrE6kNDteXlkPUohtqbUpcp+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761622973; c=relaxed/simple;
	bh=EZxjcoS5qdrAwcRhEUNyB2nv+HkIt/HSRelXLGyxR/c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c7WZpdy5TmnAgZo2fFdwaJ8lPmIEuNDZDWyv+SZWbJRwc7U+ETYO8wkg2KmT+TU64HHTfMsl8WXiqa6/8CB6/p9GE+yFt3Y46XBWboF12oW4DyFuqPC5CJiy2PMI0Ewo8s5E0W59x5JghR8YmB7yfoE6hm5otpONvLQHyZ6WBXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ctmRBT4U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ctmRBT4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2FBC4CEF1
	for <linux-cifs@vger.kernel.org>; Tue, 28 Oct 2025 03:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761622972;
	bh=EZxjcoS5qdrAwcRhEUNyB2nv+HkIt/HSRelXLGyxR/c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ctmRBT4URZ6Cpzu5/Uhz0fQY+6zbTkeNv0+Hn3Hnh95eFwL1b2gfJGHGP65u2X3yq
	 2FQQwgSak9K9/MA4VzL3bGwoT2vnoSZUqAHFWBSF088S2r3Lmh9I6DlqcC3P9UzL1z
	 zyFHBsh87wtQK3RHG7Dm7qOp+wYSQRZqBXWpwWTa3IrA6fySTP/5y9tKoAGi6d1BmI
	 kQx2Kr+dFuZU90q23IWSq8bK04bQAP4T+Aam6xZC6Vj+YF2gDZ+pUGHg7r/BWPocVB
	 QZc18bVq7e2aeXyNY9XJZFHsXDW59VAYr05FYQ0VpkRdV9oar2jd17fh1s/4hGRJwT
	 5Of+3ZMOfTRow==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-63e0abe71a1so10459394a12.1
        for <linux-cifs@vger.kernel.org>; Mon, 27 Oct 2025 20:42:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU5NDyicKOWfjRCaE3x4qvYPSx7MZt5OdiyJ3eOb6WD3ei7zT5xU7moHOBc8qwRKodDQEKGGOPZDMeQ@vger.kernel.org
X-Gm-Message-State: AOJu0YzWTVSQNZ7VNOh9/SQV7mrQYUVfTuOvjBCTY0WdfB1pL6tyartt
	iRC9gk5SL+Ydqjm/9zdC27pZFT8vTnSzApccEGzh2Wh5tKqPtNtYr8peoC1kAU0hI3Fs34j06Fe
	W8270wn+Y/pHunar/KhBxhC+qDLLFg+s=
X-Google-Smtp-Source: AGHT+IE0Lwz1JCRI0jHDYh0j09hHq/x9gpT0MXwMZfzZOvhhSbGEAsEW7sSrOe5WEAS9zt2ERS+jZl1qvzny5tkooLw=
X-Received: by 2002:a05:6402:1ecd:b0:639:6bc8:c7bd with SMTP id
 4fb4d7f45d1cf-63ed8372b59mr1779428a12.15.1761622971503; Mon, 27 Oct 2025
 20:42:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev> <20251027071316.3468472-6-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251027071316.3468472-6-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 28 Oct 2025 12:42:39 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_u5+p5hjvQey+TM8w4+P7aN7zSfwDbrUKRtbwx4vtyDw@mail.gmail.com>
X-Gm-Features: AWmQ_bk529JyA7cBhMnSJ-zScZU08IV0EpoThk9A1m56Np09T_41LA9OSe8XU2M
Message-ID: <CAKYAXd_u5+p5hjvQey+TM8w4+P7aN7zSfwDbrUKRtbwx4vtyDw@mail.gmail.com>
Subject: Re: [PATCH v4 05/24] smb: move some duplicate definitions to common/smb1pdu.h
To: chenxiaosong.chenxiaosong@linux.dev
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org, 
	christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025 at 4:15=E2=80=AFPM <chenxiaosong.chenxiaosong@linux.de=
v> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> In order to maintain the code more easily, move duplicate definitions to
> new common header file.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
ksmbd does not use all smb1 pdus. Instead of moving all smb1 definitions,
move the ones ksmbd uses to smb1pdu.h.
Thanks.
