Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794408283;
	b=rbGqLqQxp6wSFX1Sxmno5jZqe8e1R7s066YOsyoA8ThIjmqhIW3UGOEFYLINAL5LW4aN
	 lSIzIJY58D67uuai4fHigDKlPKlW+qFvkrqH9kYgHgvBNZvxEvPWwkG69lNw/oA87B7Rk
	 xKMurw0cyJEmjnTosswLK/CXNpZlM9SbnPi+RZTrTFM96B/gJ6e5+VzNNqSJidC+4JeSA
	 R41ZrnNv9PMF42T3t2/0nJRwqEqVSbKMK5b9iyzbn4kys006D+EDS8mOdzPvGmr5IPXxn
	 Mv5EGUBx+QOwfmtvnEI7mOfuvSw46qfQNRkrFbDSmAEdlEUpfJtW7PXnGaww/CvgK1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794408283;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=AgQHyXT9t+YaTamXvvCqDIp8X1r1lAVOJNKAUGSeaeY=;
	b=1rfKjgBj/YcOj/IJsy76X0jdgtme0SFIcK2+8kSRfEIjKLHNze2Swx8zx/9aw5pZ2ihT
	 V2jttg/lMMef8ONB9SAFInwZMar6XrBAiQhPdiAmWsBMLcP7882L6lUuCaCwwX6AbAX8c
	 mg5Ge46V471D9D/WwjfWiXjACLIPKFemsErCPvFEQyYHff0hLYkSonzRqg2fM2KYf1da/
	 HVtjgsLOtI9+NI07/kaXoUM9uJqos5eGYHDrGVMHkDg3F6zrqGgFUGCSqsF5V2S/3vfqn
	 NaVjSDIF2uSGKmqL3ps26OFd0mMLrYs6PrvtfM3BQGdOI+X9O/9SRuwbR016P9C8Elw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fju5iZHu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA0460A3833
	for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 14:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fju5iZHu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1F51F0155E
	for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 14:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794408283;
	bh=AgQHyXT9t+YaTamXvvCqDIp8X1r1lAVOJNKAUGSeaeY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fju5iZHuy5IFOhgt5m9ZKKXD8oOF76mx+68KJaUOE6BvEoCFPlbwAGJjwrjl1CNGX
	 RMPaNF0J0ScU+eY8knjIGP5Op53ayu9Kj2nyCZO7KU8sZJ+b9Arzw3MHPuA9LqsVJG
	 rTEc8g1XIKusKfB8IVj2eDBf0ImGDE7qoMagJtrTxSr7m52Qvi92EvG1AVQKmP9an6
	 1F/gfVr6gOG+G9D68dow8O+J7AkP3CXaXbqfp8/IoKCgMJtyPMbDwW6vnhKMI9REjm
	 jtXMazKCwm8i7NYeX1flcsesorSCkt+S4p3qKBSdKaoH4sJj3lYQLs1xhuBiQExWF7
	 rt/BRmlKxBC1g==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c4d30639709so421817466b.0
        for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 06:44:42 -0800 (PST)
X-Gm-Message-State: APuU4Z/EAxZVSqoiVLD9FiCUb2lNgbGaUcBazUFogCShSY9GSaR/XpsM
	jOYnsFhFX+/NLsgts0rOAY2QwVOG9687otuEeJ8y8MDc7q9GzomV9WKEJvwMpswLOpRapAyoCil
	cpbCDslxDLaO4M8OfTDzn+jMeZXmNmCg=
X-Received: by 2002:a17:907:1b03:b0:c42:4750:8d49 with SMTP id
 a640c23a62f3a-c5066b1a20cmr203859366b.25.1794408281685; Wed, 11 Nov 2026
 06:44:41 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111135324.4028153-1-pc@manguebit.org>
In-Reply-To: <20261111135324.4028153-1-pc@manguebit.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 11 Nov 2026 23:44:30 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8rY5K-s965GYKDC3WFw-a4nSBV_GL1Oy15=Q4MGEw7Qw@mail.gmail.com>
X-Gm-Features: AclHuK9KSCpP5YVlLFiFck0lQpPXZw_s28XkAECMrEkz5ZfjHjE4HKo3o8aSMH0
Message-ID: <CAKYAXd8rY5K-s965GYKDC3WFw-a4nSBV_GL1Oy15=Q4MGEw7Qw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] smb: client: retry a hard link open without a lease
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Giuseppe Piscitelli <ooonea@gmail.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 11, 2026 at 10:53=E2=80=AFPM Paulo Alcantara <pc@manguebit.org>=
 wrote:
>
> Opening a hard link of a file that currently holds a lease fails with
> EINVAL over SMB3.  The client caches lease keys per inode, but the server
> ties a lease to the file name it was granted under, so reusing the inode'=
s
> lease key to open a different name of the same inode is rejected with
> STATUS_INVALID_PARAMETER (MS-SMB2 3.3.5.9.11).
>
> Resend the open without a lease when it is rejected that way, as
> smb2_rename_path() already does.  Fold it into the same retry loop as the
> FILE_READ_ATTRIBUTES fallback so either can follow the other in whichever
> order the server rejects them.  Reacting to the server response covers
> every case - including a name kept open by an active handle - without
> racing a handle opened concurrently.
>
> Reported-by: Giuseppe Piscitelli <ooonea@gmail.com>
> Closes: https://lore.kernel.org/r/CACmoRBbDZR3eyEM65j73sWMS7A=3DT89z1QAvC=
P=3D+u0WGzZhwW6g@mail.gmail.com
> Fixes: 262b73ef442e ("smb3 client: fix open hardlink on deferred close fi=
le error")
> Cc: stable@vger.kernel.org
> Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Looks good to me:
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
