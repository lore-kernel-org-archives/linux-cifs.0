Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E157D3563CD
	for <linux-cifs@vger.kernel.org>; Fri, 21 Aug 2026 00:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787270435; cv=none; b=nppu6RBwYyrQ1ay8GyEM25hOs7f/EG2c+0hXi3PJjigLBaFaf/BSVeWU8tMcJNG+zqnyEa9ROYZFx5hdMKxJlC+6Ls2OOVQU2SKEKFo7oq9jYLXYtoWNpTUOcNSWlEhjqyTARLdu9mjy9P5+VVWAXy6owcmQuLcUuFShHst0aqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787270435; c=relaxed/simple;
	bh=7ZbhctULEkmBi6avWi9Q0mrJ4lPpk3O74RsjhAXpTM8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F98X+1UnBvPRDNteTFK2usjcs17G6xWt/WxaR9cykfZiCkem+Ur+Hi76yd+f90aYS2Yg65tCBXWfguSoQSROXsP731lmp3iCJyFWSwibhHYJUCO+joPScZmzMYTKiH5EK5OMcE70Fz942K4J57qdxGAtOvFLOjk2Z1FHPD8vkxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ODlmHXyB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ODlmHXyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C49FE1F00A3D
	for <linux-cifs@vger.kernel.org>; Fri, 21 Aug 2026 00:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787270431;
	bh=cDda+IRPjA3xmacgMMSmSkvOlzTi/NyOElFby2f5zsw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ODlmHXyBRF984PhO+dFamE54b/kue6FZARpAU+a7HWj7OR3M9zybyMeSFL6PALs+a
	 uF50e/OO1K/3GYKRVL/q9fI27gj2m03pNJgiGWnrbzOEDjdfYdtznfr6k0+wItL3rI
	 tW3ejSFKkKCNflrQDXakOr658+yeQHbIktcYY7YTfcijhUpQZNmJfzXO2VAe27FApc
	 SHSiYBf+9SlbdQH1y4oGVNxVmB8o+vyPf4AUazmnlihJKMwIH0K0wjg0CzQVlSy+zA
	 BXS/v8d3KQ/QCTPUSkjF+wYA3B5qUDYhb+36TRAymgaLTlFo6z57M3VqoqNAtjAX3Q
	 QER5Wi/Irda9g==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6a41191c9a9so1025099a12.3
        for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 17:00:31 -0700 (PDT)
X-Gm-Message-State: AFuF++msduWzAjqqr2j/4puNoS/zUKuIN+CIHkUC3KxnkmMxurynmDnI
	gMv0zG8zZmaTXXCC6dLj1ttAPJ2lLvSdkNLaHo0HzmCgEJYKhDCt8Zn+oOu7VXHEXNrWLVX9ZFA
	+r3A/cr/DrhbR0ZWeR6TWl4gAhJz1Koo=
X-Received: by 2002:a05:6402:20da:b0:6a3:ff14:ebc9 with SMTP id
 4fb4d7f45d1cf-6a42f1bcdd1mr2149119a12.11.1787270430476; Thu, 20 Aug 2026
 17:00:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260820211310.1471930-1-sorenson@redhat.com>
In-Reply-To: <20260820211310.1471930-1-sorenson@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 21 Aug 2026 09:00:17 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9HApK3UYwfiak-CbLELePWspyrEpuVFhOAfzo92yz1iQ@mail.gmail.com>
X-Gm-Features: AcwNN1Wm5agKh3RqtHnuU8tXyz9My3Iz_-7bFvHsOIDrqoXCu1eeY9wKvygTEZM
Message-ID: <CAKYAXd9HApK3UYwfiak-CbLELePWspyrEpuVFhOAfzo92yz1iQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: call pagecache_isize_extended() in cifs_setsize()
 when extending
To: Frank Sorenson <sorenson@redhat.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, stable@vger.kernel.org, 
	David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 21, 2026 at 6:13=E2=80=AFAM Frank Sorenson <sorenson@redhat.com=
> wrote:
>
> cifs_setsize() calls truncate_pagecache() but skips
> pagecache_isize_extended() on extension.  truncate_setsize() shows
> the correct pattern:
>
>   i_size_write(inode, newsize);
>   if (newsize > oldsize)
>       pagecache_isize_extended(inode, oldsize, newsize);
>   truncate_pagecache(inode, newsize);
>
> pagecache_isize_extended() zeroes the tail of the page straddling old
> EOF.  Without it, dirty bytes in that region can be written back to
> the server, exposing stale data in the newly extended range.
>
> Cc: stable@vger.kernel.org
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks.
