Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98ED3272805
	for <linux-cifs@vger.kernel.org>; Fri,  7 Nov 2025 16:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762532628; cv=none; b=tN5OhsFk8lwdopHKdEICT+pc4kCJUKsP+0Mr/4akFUH0WZmRT0MwjpPP2gWEYt772NNL8e77HheUXTsh1URReTSDk+XRyMVhD25s0BwlWPrGrHTXSXs5hKU9OQCa3J7jph+tA21S+K60F5aIhL8cB35s/Vtn/0npBAF+yAm1TCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762532628; c=relaxed/simple;
	bh=J6EunYEz2tEr0LK2DJ7zlLy+0hgjNQzinAZTpJUBdJo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M2Je02okzNvoH8/IYacCg3n8/EM1zbf0dh1LMo57xpkKLgG6algwHa5Iy5CPLUUV2jlA3xFrEGGKWQziPjGSX+CoR72Rb5jWWxdfsmKP4fb4RVVzVpMmUjIJUQlNsvkS2fiZ8DLARVG1YbpIKRHLM7/fik/K3eJ2VCz81G29fds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GwwSenuZ; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GwwSenuZ"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8a479c772cfso53924485a.0
        for <linux-cifs@vger.kernel.org>; Fri, 07 Nov 2025 08:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762532625; x=1763137425; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XNyT8hdstTN7e/8rEeWhIH9mkCHpXo1HxjWjp/fCq8k=;
        b=GwwSenuZlKJeuBBddnWTFlC/lc5/m+gsb6A1TZv5frcL+4IC5w73y4an13s9yYKF8/
         rBAiBxjQWHXb18rk8yFbRW8CyNuDUKHhHf0XJp9g0Qzfi3orTc90tMK0esO+isWO+iEG
         1PquR568JKGMUQQCeSeO3UIdSoBKDBoWPb1jxcGVWdJtbmfcczl+YCzsncyTiVHueZsM
         DOasqYxrqIZYlwSq51E0KnkUKSeQACshmCGJH3paB/dIN6DAFet8a01WS8CHVIaAhJ8O
         6+DaEfvndy2pQ+iM0D0RqluWWnZeMtt9017QxhPeoNZXPrqcT25TYdqUFDXtCSknN2qy
         8HpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762532625; x=1763137425;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XNyT8hdstTN7e/8rEeWhIH9mkCHpXo1HxjWjp/fCq8k=;
        b=hAmBvnxHAOpe9owOJLyMws+91L75GMia+o9kaCC5jqKjsvF8pWIXuQ+dor3Xi5Im4c
         /GtWvZf2sb05OVQ+GrLzL69Pjg4TjsAUqTUsmiW6kicZgHuCqWAa/EIC3j1TRYkpFa1d
         vWxe7ugqimii3BWFkkGStJr91b763R97eh1fe7OFtxIu4WqcFqNg2hkWYwOQAIHWK3cw
         0JyN2eS7PuIYdIhNzlAH5nXXTUJcLIhDoMObG7vv0gyC4qqXUNgXr0tg5xoXA2mIZkoB
         PqU6zS+FgckbfqFEwl2ilaqkEJMyeYQvKs80EIz35Qz7aaCqeN1KtM63ctWrXQqwoi6w
         PRbQ==
X-Gm-Message-State: AOJu0YzR6d5ojvUmMqeDx+YUrC5MybHyqnRV61tv8qoUlMO5ZYtzfuDA
	D3aY0OTKqqu67aLvHP1usDD2JswAkOmADsRf2+uytUZ9/7PkVa7qR6NFhLy0s1vWAE6hX9tTDTm
	ThHr0WmcGP+YCpBCfNhVyWF5CN2D6NYeIVMvmkj8=
X-Gm-Gg: ASbGnctEM9/VRDH6pcFaEG0T4rZtUERp6eArrUQPuUtNhwZ5AFOIqiXAN9m7B4AfzdR
	AYCrL5d4xbsaeEwtdsoniQswsTOKm6lDKIsaeN9L4Gmrdd6vQPoHgwvdtrVmdi0n3oTJXU6ydWV
	ootWV+28Pdi66YJIM+cFaucLsn1jKELSeKxa8G1Eb8M7werNvIJhMLjjJ8Bcke9NMIc2zoandeq
	5u+HxCF7e0PxqgZ5WwQNFLtm2XhPZVNIdlaT13qO6fMpvAbHVcXgIh37fKztZClb8wNrxVIFziA
	cZz7LS6vWoY6Q2ZTTviOEfg+yKZja4xGn5fEMbJo9CvtSYuWlAs025Q57EVzNk7GoqyPrZG/29W
	fwOnJduFXIUO9liDMQns/L8i0jBIW7iuDXnRfFo7BE8s2VXoqOgxZTlcw49jKnvngrTkOQcjDYE
	8=
X-Google-Smtp-Source: AGHT+IH2U2Qvnn+ubT9ZQn53f6cMK7J+Xc93yFMfaPMBNNB7P5IuutxIdU6CYVxtEQgdLyfGtq9QQxQmulxRkksMBko=
X-Received: by 2002:ac8:7fcd:0:b0:4ec:fb8c:5183 with SMTP id
 d75a77b69052e-4ed94a8d4c6mr35326591cf.61.1762532625454; Fri, 07 Nov 2025
 08:23:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtLBAwfk7YbgRkCnA4S7uNyiTGs7kDssa697pci=rCYDw@mail.gmail.com>
 <ONR9GWFvdJx39b1jAUTFBGjhqlY1LgZhwHECF_OroUZSCW0dGQHjcNSBDtiLfxdP1-Ly3UufUTo17bw5Kea5LTglBll2vZjWw9V8aGnMKvg=@joshua.hu>
In-Reply-To: <ONR9GWFvdJx39b1jAUTFBGjhqlY1LgZhwHECF_OroUZSCW0dGQHjcNSBDtiLfxdP1-Ly3UufUTo17bw5Kea5LTglBll2vZjWw9V8aGnMKvg=@joshua.hu>
From: Steve French <smfrench@gmail.com>
Date: Fri, 7 Nov 2025 10:23:34 -0600
X-Gm-Features: AWmQ_bkYKM4SIJOpU5lJW5zVw_Cn56Fl2XFrh8ZX1N09-34a3gQR7iwBi0eGO-Y
Message-ID: <CAH2r5mvcOwmJjSyewm06uyEfXKsfdEWS9ZYgr3aiD-ia+XF2Qg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: validate change notify buffer before copy
To: Joshua Rogers <reszta@joshua.hu>
Cc: CIFS <linux-cifs@vger.kernel.org>, Joshua Rogers <linux@joshua.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Added mention of it in the description (see below).  Let me know if
that is incorrect.   Interesting that I don't see other kernel patches
noting that interesting sounding tool (yet)

    smb: client: validate change notify buffer before copy

    SMB2_change_notify called smb2_validate_iov() but ignored the return
    code, then kmemdup()ed using server provided OutputBufferOffset/Length.

    Check the return of smb2_validate_iov() and bail out on error.

    Discovered with help from the ZeroPath security tooling.

    Signed-off-by: Joshua Rogers <linux@joshua.hu>
    Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
    Cc: stable@vger.kernel.org
    Fixes: e3e9463414f61 ("smb3: improve SMB3 change notification support")
    Signed-off-by: Steve French <stfrench@microsoft.com>

On Fri, Nov 7, 2025 at 9:22=E2=80=AFAM Joshua Rogers <reszta@joshua.hu> wro=
te:
>
> Is it possible to slightly change the commit msg to include "Found with Z=
eroPath"? As this bug was, indeed, found with a tool called ZeroPath.
>
> Thank you.
>
>
> On Friday, 7 November 2025 at 11:23, Steve French <smfrench@gmail.com> wr=
ote:
>
> >
> >
> > SMB2_change_notify called smb2_validate_iov() but ignored the return
> > code, then kmemdup()ed using server provided OutputBufferOffset/Length.
> >
> > Check the return of smb2_validate_iov() and bail out on error.
> >
> > See attached (lightly updated to fix checkpatch warnings from Joshua's
> > original patch)
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve



--=20
Thanks,

Steve
