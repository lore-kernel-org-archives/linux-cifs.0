Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC59397E81
	for <linux-cifs@vger.kernel.org>; Fri, 17 Jul 2026 15:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784301011; cv=none; b=K1CC2rsE8bWXpqTExTUbX7v/tyDcOSVWVHlIlpsSKgRuFAo6pgTpz5O7/jzMn04o7UwTdr84bVOea3uVvdMK8fmLefH38JY8i2KlCSfhg7zWSnM+kg+vttCTmhYCKKZKJ/s+w3gYt5XKXN+ti1M7t0edK9vrZbViirAc/oKPHx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784301011; c=relaxed/simple;
	bh=P7NX08tm8SefHjr+vCCpss1cWXTi+JPlNirGl8W86iY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TJIq6fWsr7n6WNI3hE7j2ZJLPHZuxvwAboI6xhicpSsnEjE8XOAGZVjm2ENR/tuO4PROuD7ca/tp/lkXOCFiFu5A4+1rysOw7kJ+lz48+r3l6Olkpvk4cLwDJ6pUqTEZdEYHVPGdYrPw2sZBwdZNYKZvAmvPpIGDKO37TKHe4Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KD/Gftwt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KD/Gftwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D87F1F00A3D
	for <linux-cifs@vger.kernel.org>; Fri, 17 Jul 2026 15:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784301010;
	bh=P7NX08tm8SefHjr+vCCpss1cWXTi+JPlNirGl8W86iY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=KD/GftwtmduIkOl+697OM3wgtYMsEUt3Y4YCx0vGF42ELI9tBBTUCdT6w2MFlpGjL
	 uh3XJE4RlNnLXfVLqfI3n9sD6CoCauM45yU4YcJ9kVMfSL5z0BI8LlvEIANS4dKmub
	 XLtc7Yom/KhjvOSl/utjGc8RRMiL89XIRXuFRYX23E/iIQ+ep/Gyu0ksh9sJCagspa
	 UxwOI8ja8VwTXyIECvuD+nG6ZT901rFXEonx8O2cz1fJP3sxeSALdbf9Aif+OUXiMp
	 jS9Gluk5cWL3az5+1DdymalqYt4uLBQkXSK/E2JkQAZJZhOtmlceEbZzlBjUWZ9ghI
	 dxeSVf9IEKIrA==
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-664ce3000e6so4002703d50.0
        for <linux-cifs@vger.kernel.org>; Fri, 17 Jul 2026 08:10:10 -0700 (PDT)
X-Gm-Message-State: AOJu0Yw72+cgCPZoiaVuhY2WdaU07JjBUgdhErrQntcREy1z83Q5DN8R
	25d8YLXO/nt3t0cWm0tDK3PIA8KCDNvm287bPLaXXKE6bnSJEqt3165iPkCXOh/WUjw6n0BfSCA
	qdSMCm9vxQYRK45TA1k7e99+36jKkais=
X-Received: by 2002:a05:690e:138e:b0:667:a284:2280 with SMTP id
 956f58d0204a3-6683bc46560mr759547d50.31.1784301009283; Fri, 17 Jul 2026
 08:10:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260717073721.7487-1-g.blivet@me.com>
In-Reply-To: <20260717073721.7487-1-g.blivet@me.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 18 Jul 2026 00:09:56 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-icBtM3wObc3FERwz=MFx2juK2OdZt7B=f-gJeMciHyw@mail.gmail.com>
X-Gm-Features: AUfX_mwoRXaSXSbbkuj5WInf7P1HLhxT2x2GOgE0cTaU0vRTxTguAijfsNK8BcM
Message-ID: <CAKYAXd-icBtM3wObc3FERwz=MFx2juK2OdZt7B=f-gJeMciHyw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix AsyncId zeroed before use in smb2_lock()
 cancel response
To: =?UTF-8?Q?Ga=C3=ABl_Blivet=2DBailly?= <gael.blivet@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 17, 2026 at 4:37=E2=80=AFPM Ga=C3=ABl Blivet-Bailly
<gael.blivet@gmail.com> wrote:
>
> From: Gael Blivet <gael.blivet@gmail.com>
>
> release_async_work() zeroes work->async_id before the CANCELLED path
> calls smb2_send_interim_resp(work, STATUS_CANCELLED), which reads
> work->async_id to build the response's AsyncId field. The cancellation
> response for a cancelled blocked-lock request is sent with AsyncId=3D0
> instead of the id the client received in the original STATUS_PENDING
> response for this request.
>
> Checked against every other release_async_work() call site in this
> file: smb2_read()/smb2_write() don't send a further async response
> afterward (their status goes out on the synchronous path instead), and
> smb2_notify()'s two async paths already transfer the id to a separate
> struct before releasing, so this reordering is scoped to smb2_lock()
> only.
>
> Send the STATUS_CANCELLED response while work->async_id is still valid,
> then release the async work afterward.
>
> Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
> Assisted-by: Claude:claude-sonnet-5
Applied it to #ksmbd-for-next-next.
Thanks!
