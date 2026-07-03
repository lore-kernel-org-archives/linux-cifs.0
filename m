Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AE51DDC3F
	for <linux-cifs@vger.kernel.org>; Fri,  3 Jul 2026 02:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783045871; cv=none; b=Xog2Vpz/gdbZNuRH3pwww8tJsOuEjbN5zS3QzwTxL6JGUQ5yDXUccpJlHULs/OcJUi+hvfuPy4zn1tneQk8rRZ63CayhmB00Gq+2liEdFVEETP9aaX4Ugvts/xiFKft1lo0a4iVcFdkVK/znVZVZpn8ZzNaSux5kukwT556bvr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783045871; c=relaxed/simple;
	bh=jAnzaF5txNxYvh5Ma0GDN/WDcyKooTOAe/AQK9xAcpc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hrXDvyl4LaMqgqW396B24O56lcRUnCc6+3CirxYilgunIgebwY53eBf3cJjnGZ3OB38ySWPmzAyl7kSKdUVgxOMtDoHwK+0cfKCLytsVXRKJr0MrvLKJqnkemeilV0jGulL3RiCfoRH/MGlKuk2vFxWl84Fyb7faI11EsUpzwTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e2G9Rsgn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e2G9Rsgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FDC1F00A3A
	for <linux-cifs@vger.kernel.org>; Fri,  3 Jul 2026 02:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783045870;
	bh=WJhCa2sNygMOIyt0Y7+tuK6Oih42DNSuTmTC37p/FKU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=e2G9Rsgnn9m9P8o9ZeMFi2cmjYRzBo31GsPL95Jg0T7qn0sVG78FvoHXgtRI/ZxIe
	 04Oil0ssfKKgfA1AHXhFBn+xS/F6VU77Bn3aJk6n2Nbjl8suTynAAL2upFdfUpWkbb
	 gGDCKinzglIuxyPzK3ikkLAOX4x8f3qZT+oOLW1/FnR0tUORZbS0zw+3zPLVdEolS8
	 3RJtaNzTSQ0c6UzZCZMJEwubtc0IAhNJW45RTiD1/WNbHEyFJzoqrZIycEu5Uhn3J2
	 T6xEpSj5DJmMSH7EMgFOxR/MRZnQoZOyK4+tWmum6qoJLmeQjxXPl+kx6qAzIyJAtX
	 EWUa9pJhdqyVQ==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c128cc012b4so11900866b.1
        for <linux-cifs@vger.kernel.org>; Thu, 02 Jul 2026 19:31:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoLU/ts+nEJmZaUpt4A8AqS08IbE0Snk0B9Deikq3xhlSonYoQgpnqNKHqtK1+uHUC+gZqDPixpjJlb@vger.kernel.org
X-Gm-Message-State: AOJu0YzUabv8ixpEuZ0ZtbjWCJ0amkQnMyPzL/eqcLhqSuN3MK8c77TP
	8Mv2/j8Mh+WFIUR/FEUZ1UpSyOf05OM6wo+mKBZu4x5hWGjDAtwFTJ3UnoP77/bAvfBKFyjtzc6
	plI4hHMq5meU1V1VyW9cL1DiOsMePkn0=
X-Received: by 2002:a17:907:9307:b0:c12:686d:f673 with SMTP id
 a640c23a62f3a-c12c9f71a74mr115649866b.30.1783045869051; Thu, 02 Jul 2026
 19:31:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260702113222.228413-1-guanwentao@uniontech.com>
In-Reply-To: <20260702113222.228413-1-guanwentao@uniontech.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 3 Jul 2026 11:30:57 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9dgEhagjzofg_H4mx1kYg=tFEE49RrwU9WY-xPMoEVZw@mail.gmail.com>
X-Gm-Features: AVVi8CcL5Nl7f5tcgx7ActxW8WSbdBD0NvGR2Idjtv5I9_5dVLUOLq6VW-mFQ4g
Message-ID: <CAKYAXd9dgEhagjzofg_H4mx1kYg=tFEE49RrwU9WY-xPMoEVZw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: restore DACL size on check_add_overflow() to avoid
 malformed ACL
To: Wentao Guan <guanwentao@uniontech.com>
Cc: smfrench@gmail.com, tristan@talencesecurity.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 2, 2026 at 8:33=E2=80=AFPM Wentao Guan <guanwentao@uniontech.co=
m> wrote:
>
> check_add_overflow() unconditionally writes the truncated sum into *d
> even on overflow, per its contract in include/linux/overflow.h.
> The four check_add_overflow() guards in set_posix_acl_entries_dacl()
> and set_ntacl_dacl() break out of the ACE-building loops on overflow,
> but the truncated *size is then consumed downstream at the end of
> set_ntacl_dacl():
>
>     pndacl->size =3D cpu_to_le16(le16_to_cpu(pndacl->size) + size);
>
> This produces an on-wire NT ACL whose pndacl->size under-reports the
> bytes actually written by the preceding fill_ace_for_sid()/memcpy()
> calls, yielding a malformed ACL that can trigger out-of-bounds reads
> when re-parsed by clients or ksmbd itself.
>
> Restore *size to its pre-addition value on each overflow branch (via
> `*size -=3D ace_sz` / `size -=3D nt_ace_size`) so that after the break,
> *size once again holds the cumulative size of the successfully-written
> ACEs. The committed ACL is then truncated-but-self-consistent rather
> than malformed.
>
> The ksmbd DACL builders are the only check_add_overflow() sites found
> where an overflow path breaks out of a loop and the destination value
> is consumed afterward. The other nearby break-style cases either
> return -EINVAL on overflow (transport_ipc.c) or break without
> consuming the overflowed destination value afterward (buildid.c).
>
> Assisted-by: atomcode:glm-5.2
> Assisted-by: Codex:gpt-5.5
>
> Fixes: 299f962c0b02 ("ksmbd: use check_add_overflow() to prevent u16 DACL=
 size overflow")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Applied it to #ksmbd-for-next-next.
Thanks!
