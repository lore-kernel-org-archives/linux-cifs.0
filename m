Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9783A1FCF63
	for <linux-cifs@vger.kernel.org>; Wed, 27 Nov 2024 14:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732717461; cv=none; b=mVmhPi4J8YPPFXzRPn6aGhWrDChswB6YYVzSirXa15Y3mS8GST4j+OxOZaeT7RZr+WCX01XmH/Pf3Vcbz9g17fVhaARizMVdR6OfS3/pD8uVMN8wYnqPNBvOJ9TndNIsZfAN+eTXW0WyrQQt5oSXzpcWmJ/Kyuo7jHv0rXMQKds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732717461; c=relaxed/simple;
	bh=+QDhgTdEmSg6Waqbkb9chJwjvz9HQYENawNhQYszlAU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K2mkRLMtzwH21EAOk5S0Er07nTS42+4pA+ps4RbQ51YI2BIK7Q5eUofUwX9TTJEpmAzMYdm9XBlV7lifnpG9HSjX55TQYBjRwc0qFNEMUimHOiSbIDzdfgFrux8v+jolWTedseUViUnMwIEOrLA87KT8/rwD2X2LAHmp07yYsSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mNXuR9Fj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mNXuR9Fj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3653AC4CED2
	for <linux-cifs@vger.kernel.org>; Wed, 27 Nov 2024 14:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732717461;
	bh=+QDhgTdEmSg6Waqbkb9chJwjvz9HQYENawNhQYszlAU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mNXuR9FjqScn33xO9OtwyEU3k1wf23e/386NDrJ5rptQJofX7wZJEMu7fUgqv29zp
	 bi0Cvai8JqNLCT5SpZm+AYBYDK8Derz9fM7wPsRTARo9ENkyBf0muv/qyd/WD+dI2+
	 8DLVERUq0HV3EnQJeHg8Ce3CyfquEjEMh6bBhZyZ9+hfScoGeIPmHZbPbDJ4041PX9
	 KaAEW7p0TxFm4V7N1R8LZ+hxzQDwBykzDMNbXTogZksocHCIqMU+wF/3Mlkk5kkCZC
	 4Xv47Ifpnsl8bCZl/GIEvCmoHYzLlrhaDHuF1zUFT02TJPKtgRynxKaVsVfE8LgYj9
	 Tix8ne7pU3mwQ==
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-296b0d23303so3214922fac.2
        for <linux-cifs@vger.kernel.org>; Wed, 27 Nov 2024 06:24:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWmchvZf5HNbloh46+1aC3r39iN/z7f37O+Vr63GpL+HA3oD+Nn5kx7K0RX4Wz+q9qjU3Vj072gXwXh@vger.kernel.org
X-Gm-Message-State: AOJu0YwNJmNBANqtvRRLfFdJnVE3Q1pJIRJ9QzE5s7IXAkjItYIbzFs9
	NSb7S7Zj9NxAwKXpuztY8fUtCABpBEo/2HF3+JeF1fQIkIYqdQRqsW6nEtNzDBu9Nx9N4oFLw7k
	b0zlsLGwOrOOB+mK2zlE9KN+hdtA=
X-Google-Smtp-Source: AGHT+IFe/+xAcjhcdA8V03MsNi+7hIa7+Co85KlsZiWvdW/iL/JDUXVRb4AqKooWTIRozoai8aWo9q/6dqsUzatZUPI=
X-Received: by 2002:a05:6870:ab07:b0:261:22a4:9235 with SMTP id
 586e51a60fabf-29dc42f5d74mr2557821fac.32.1732717460465; Wed, 27 Nov 2024
 06:24:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKYAXd_aZ1RT4yxC4fasmYk+M6vWrpwrjrJgxvf2hNzra7VJPw@mail.gmail.com>
 <20241126061135.2762074-1-brahmajit.xyz@gmail.com>
In-Reply-To: <20241126061135.2762074-1-brahmajit.xyz@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 27 Nov 2024 23:24:09 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8rd5zTDHCtU_5RJSP-TkSoM0dPx4XnnYMG4b4Njkff+w@mail.gmail.com>
Message-ID: <CAKYAXd8rd5zTDHCtU_5RJSP-TkSoM0dPx4XnnYMG4b4Njkff+w@mail.gmail.com>
Subject: Re: [PATCH v2] smb: server: Fix building with GCC 15
To: Brahmajit Das <brahmajit.xyz@gmail.com>
Cc: ematsumiya@suse.de, linux-cifs@vger.kernel.org, sfrench@samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 26, 2024 at 3:12=E2=80=AFPM Brahmajit Das <brahmajit.xyz@gmail.=
com> wrote:
>
> GCC 15 introduces -Werror=3Dunterminated-string-initialization by default=
,
> this results in the following build error
>
> fs/smb/server/smb_common.c:21:35: error: initializer-string for array of =
'char' is too long [-Werror=3Dunterminated-string-ini
> tialization]
>    21 | static const char basechars[43] =3D "0123456789ABCDEFGHIJKLMNOPQR=
STUVWXYZ_-!@#$%";
>       |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~
> cc1: all warnings being treated as errors
>
> To this we are replacing char basechars[43] with a character pointer
> and then using strlen to get the length.
>
> Signed-off-by: Brahmajit Das <brahmajit.xyz@gmail.com>
Applied it to #ksmbd-for-next-next.
Thanks!
