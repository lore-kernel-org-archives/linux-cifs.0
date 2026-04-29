Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DAF382F01
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 16:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777478436; cv=pass; b=gwFO5nJA5TpBxSywy3t4bhYT2BrYULc5R2Tv/OpeVNK0YSUV0i9qSWle4rl+88h2yaRtg+jB/VCfNr92CKqYuhq1ylZMoF+ViRf1CpKry07xTxnIXOdea9JlJH25VB1fD+hv4elcHzs8Td8Kd7Td7wT1H4WfcL3reOCrLS0dU+8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777478436; c=relaxed/simple;
	bh=ClqcxKRaL4dnan+V5xnQ+K7P63qzxV+3NchBCJmJLEQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U27L2GsiePk9Kvr+Fl4omWOPjicRd/xVOq7IQ0cCR12XRUezPsypMqLZIx621Appu7syvpyc5vPhqfWfqCfdu6C0d+OzNSgIlNWpOhk3F4OEqaD7p/lyNjdG8ocycbw6bXPPwUB81Zwhi5aHfpgJWks9R0NfKT3z26he2NiGPFM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X4n9hw2U; arc=pass smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X4n9hw2U"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8f0a87e23daso814779485a.1
        for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 09:00:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777478434; cv=none;
        d=google.com; s=arc-20240605;
        b=JIBv0Y6ys+dppbaQkusyPDP4mtT1NhTaLXX9tcwO18vgdXP9RqO50NyFtBTn0KljFu
         JAY918KnQTVt3PnBM89zo0kT9cBnEjesDKogDGSUGDBHlrocuqeEzBkmrZGVvKMz5Y6j
         FJkn7PrefZEb/bz15Qz6NoJb9SIbWttsrNuCx8rUig2On3i4ax92L+j9dRbyP8LruMWQ
         9ExPdZ5qLIZnjmyCZbgkDVjFfPSuSMSAt1slMp6fAWXRndI4SfvncktLGoJoJmJVCHf+
         +r0VDz9DA6o3bBOcSX/zANERA12WGPh+CwIUrDfBNFn9vezig4KSh+A/MQQscTolgb+M
         chFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ClqcxKRaL4dnan+V5xnQ+K7P63qzxV+3NchBCJmJLEQ=;
        fh=FRnV+WHfzXR7Ysl/f5dtC/8AeBVj7J4+6QS7n234kgs=;
        b=MPJ/7h1Ln+VRnPbc5fQ7dnwzUhAVtQx/QT+NJng64mz23xwZ6hJ1G4ZTyUwdIIigyv
         qFbmokKhqaU+Dp3VRKX9cepMivYkO92Z+4bv7Z05t1elWT51EU5PXfDPaIQ/fXDf4G6S
         dmrsNg+0gT+EJemIgyLHg+UP/dWEyK7oY8YWoVrZLfxyCJlmp7+dB+Zy5PglBZdE5Jdv
         RDkJ5jQQq4yIOQqqi/J+J+SSBHDCaWOj3UayB9U4cZ0VaH4Nw+KDAjfuzIlsmS2W9qZP
         8k5WrgDqBjT2rGJcrD5/hf6V8lkr4gs9RFK9xZSd1webqrLHGvrJJ7B3FRBe8PRQGXhr
         hIWw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777478434; x=1778083234; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ClqcxKRaL4dnan+V5xnQ+K7P63qzxV+3NchBCJmJLEQ=;
        b=X4n9hw2U8g+F0NsSeL7V6bElsfVaRDDYkLTMHJlPuUy4Sis+iFtpTIegyXWaaapz1/
         rlR40JeJoHgV68cUtK0CxQIMV2bivfdPKFqx4ZRV83o4BO3Fy8LOzpIWXyhSt6z/exGl
         XuqgnU6gXxtruL7ut+LmtSkn8XAoNrmWiK5Ymms2VGQfZ6vjCpopPXxrrDtmAbMaIuju
         1PAa74m3OzD0THLC1CUyVHygCgB7TSqle9CKXGrJLDPW7k4iJTNAS2tWgCzmTvhGCenv
         bgF9U7n/dbtKFy2u+yNpCmhTsxml7usdURVNPDIktYfK9oXt5lblxP0iTY1xcp/TnioG
         6Q/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777478434; x=1778083234;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ClqcxKRaL4dnan+V5xnQ+K7P63qzxV+3NchBCJmJLEQ=;
        b=HfbHDf5Z6sBMtrygqN30siga6uv4EJTlW0l4NdBRpHEofCtIR95a75ztr7q54lxdEP
         7KBhq5xiypgEuvt3/mVdNukjtGnFcHYw/1P6RT7+J7twT8LAkGydBLj9/EwYd0HnJfsX
         AIvwTw89t8ZTfO86zAYlxRlmAUDtOHvdmCuWQ+wUA0B0Mofesfvf1M4+zQNDLa+UDdCA
         ZrXQXNwwifPb4Hv1uYG5L0JtNKo58PswLBt32hlVsz1PHUj5J6salPjYn7igF5V5igYy
         XxqpgSkj215Kmtu6Ak3uLhr40FjbzZYsFU5n0zF5BJLf5mHh2kWBEfXFS6BA2UaUO/bQ
         ieJA==
X-Forwarded-Encrypted: i=1; AFNElJ9LF87re0qI2VMDEEllhCyr9kYSV9DxSvFzEt1z9KrQpPN4lPw9y53a0ON9znR2CpT0vTSxx3VIx39L@vger.kernel.org
X-Gm-Message-State: AOJu0YzwYakDSv99E0nhOlrzr3wDtIO/kaC0Nf/kn8Ky4VSuAnk8ZigE
	xquKERyOCPcvNaLdV7dU6ZpkMazV7UOqdr9tsMH7wWULHWqwiwUc+EfPGmNBjeeJ2V4GHfGuvQl
	0zq1ZFBMlC9qt27S4PVOqsqTKdByb5yw=
X-Gm-Gg: AeBDieu/x0eyy5tllQlXUiThJzkajygMYdymSCOjqT4SMINVLeu52zDxP9CPuStIn33
	IfJhJZ6y351v0snxzdjh3oqDZJAX9vQRJI4dMKWpP6I0cjMVUyfiOiNv+Kovw1EyXoyd49hq6cW
	3B1anEV+FxHWw+tnsA7CcvFJGBUUwu/cOKWp/S7wa7k4tq50XHnx2FYYdVyqrDxSQ37WpB3eCvw
	tXQV1+DF39MB36lwdfzL76Com131AU6UcdYfHtCwUiIoIykBKfaPC0isbaP63zJJ7Y6KiE4yIvn
	bW50eYeZaMdHooEW9wcGgKQO0ZiDd5gj3sL7R5IVwZURZQICiLXIglqPJoApDTTpxuxOrIDtuwz
	RLErDGYzJcdkRNdrx8sqLKld1SNZVaw4PNYiJRgVLDv+2dEfWEuBPNpX74HiSCx4UOtX4hPs=
X-Received: by 2002:a05:6214:c62:b0:89c:a2ad:33a0 with SMTP id
 6a1803df08f44-8b3faf92dfamr3522326d6.45.1777478427727; Wed, 29 Apr 2026
 09:00:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <85118db1.AWEAAJaZP3EAAAAAAAAABAMtJJUAAYKKIjQAAAAAAC-ZZgBp8da6@mailjet.com>
 <CAKYAXd-Ci4ReATdeoSr1Y++JfF1qF3i-QnbX+Qa2NDnGho2aBw@mail.gmail.com>
In-Reply-To: <CAKYAXd-Ci4ReATdeoSr1Y++JfF1qF3i-QnbX+Qa2NDnGho2aBw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 29 Apr 2026 11:00:16 -0500
X-Gm-Features: AVHnY4LflfW3xyEZ5eiiB7Zxl1DZbOLhyICb6eb8JMp3MIWJ8qXtJnlL0ec9mJo
Message-ID: <CAH2r5mviS10YWwYxUF27D6tKsXuEc=SMt0J7XC2_Eztezm-tjg@mail.gmail.com>
Subject: Re: [PATCH v2] smb: smbdirect: fix MR registration for coalesced SG lists
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Yi Kuo <yi@yikuo.dev>, metze@samba.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into ksmbd-for-next

On Wed, Apr 29, 2026 at 5:17=E2=80=AFAM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> On Wed, Apr 29, 2026 at 7:00=E2=80=AFPM Yi Kuo <yi@yikuo.dev> wrote:
> >
> > ib_dma_map_sg() modifies the provided scatterlist and returns the
> > number of mapped entries, which can be fewer than the requested
> > mr->sgt.nents if the DMA controller coalesces contiguous memory
> > segments. Passing the original, uncoalesced count to ib_map_mr_sg()
> > causes memory registration failures if coalescing actually occurs.
> >
> > Capture the actual mapped count returned by ib_dma_map_sg() and pass it
> > to ib_map_mr_sg() to ensure correct MR registration.
> >
> > Also update the ib_dma_map_sg() error logging to drop the error
> > pointer formatting, since the return value is an integer count
> > rather than an error code.
> >
> > Ensure a proper error code (-EIO) is assigned when DMA mapping or
> > MR registration fails.
> >
> > Fixes: de5ef8ec3c46 ("smb: smbdirect: introduce smbdirect_mr.c with cli=
ent mr code")
> > Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D221408
> > Signed-off-by: Yi Kuo <yi@yikuo.dev>
> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
> Thanks!



--=20
Thanks,

Steve
