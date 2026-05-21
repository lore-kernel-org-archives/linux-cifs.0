Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94973221F0C
	for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 14:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779372145; cv=pass; b=qwDa4EEeNvW09qI9s0O+BxofY+LOF/pAfRlXWs6buB7Pwvu0/vZWMdwh83wewbYx8m0eIKTcxyWTjQUTzVf7QZRZ0GCe+ZQ+fqs7q4px0GhLGK1PZbXjPdNp76X1vMDq9g4ZL/3VgO1Y0BS13e3SMDwPNbNe9952/0yntDsBNno=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779372145; c=relaxed/simple;
	bh=AqcIiYnZVMy1DMc6irobORzJL9YBpUseMINC09n3kks=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JUcDaaQHDjWaTpTXMdtXvDALmJHhMTlv/IU7kw0NMxs2Q2f46WYYlKWrONABkUhTz96r1EFIAc7M6gFb9wMUvwpnm7tsYEqM7U5OXXpEohyozHaVoVLp5jydAUyeBfFD7gD/oBQUe9VfIYlY6CmWLpKDFQqdajepQnRfoqNvK14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pptmKfis; arc=pass smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pptmKfis"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5a8fbe18b1dso10179296e87.2
        for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 07:02:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779372141; cv=none;
        d=google.com; s=arc-20240605;
        b=a0Ntby09f+EdS5GdHjObhbUx2d1HqW85ZbVTjMyHMAlsC5VMJiOG9I7FHTx/I89nqC
         KmW20NIrmEQfyufVNz5fcuElNuCxQFT8/+Zh6yxKIRfzQmodRP+wTHqp209bOVrI2sf7
         S7shdjJ5X1fxL3+vxn1v1c6RDhiowSuY4HjXvRJEOsS1SQcGr0iTtAWmlQOMo74LlVh4
         54f93JjK3kF6bOIojAAO383TtgXfhCqRcoiL6NlNOUj1g0aq94FiOu/IK0NH/czBP0Nc
         ZMt1R0VrxbX488CFi3B7DU8HqQpA/L7ZH/pWnXcflSOWEApduxQUY3lW+Yl1VY9KeG6F
         BYVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mdi2IqcWBZI7urySup8jAHOThdabURnNYJTpBIDvjvk=;
        fh=hX2y/kNOl5BVgwJ1OhSiJRK0zKi9lUiQtwQcB90u1Bw=;
        b=J8f894qrKR5GrFHvevHz01fT72f9eSPtwRGN7qoILbyIicrIIIi8L0xwS5ougOF6o7
         sI2nwZKLoUcWWBvVMOoneKjEcUAO3fakKNB+pKLFboJx2w9AcjEOrf1cSCs0zxQ3/2+1
         el3k+0ABX4Tc/mhZLsQC10w9bufITz44lnHV1Yh3WVJ/OVHjKMFe+HC0jtSzB+Auby7g
         H2AWD2caZwpfatCbjwc7PDKzA5H7nyokOpCa/w6EbHQG34YwI+w5FF2j3KvWd8VUxqfH
         KalRPVoUChJMC5xbBqriNSxgUdhH68Is/jU2F2cq0b9zMqdUxtkjz56JvNZk86KnN+tF
         ig7A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779372141; x=1779976941; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mdi2IqcWBZI7urySup8jAHOThdabURnNYJTpBIDvjvk=;
        b=pptmKfisb/V20iFUqMJyJvZm74Holy2NQGKjP67WFluhJD9bbCgPjWk8GLlmEIRcCQ
         Qd205wb2BICcd499N56Z61KUseygxK2L5k9MtKWwpSz23inVWVYlZCMcq/7a9IMOVKF3
         J+caEGl8HCBfueFxhvUUslEjPJ5viJ1OmT+mlxczkx4cMQoJ4qTfm/OTv/oJ7JvEGseM
         b/hWNpid45TK101v+LiTr06ACTidXoFP+2ykJhzhtk46sj1Ycotp7+UlYjTMnObrNArc
         tfrKFJ5VlZFQUE+gS9jqQn20J7pdIJLUe1bXzhzcQtVouPToNygxDTU028k4b8ybZtQW
         iRJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779372141; x=1779976941;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mdi2IqcWBZI7urySup8jAHOThdabURnNYJTpBIDvjvk=;
        b=QYeSwdL/+INJnE7KW7CIoOY2vT1ve9sE8qwXqRZxYA+M18V1Rgx2wW3VXTU/lrmQnu
         0uplCvGcgHLDKSZ8zTUZr8VB1JIfDn01add2rLYpuly31UOsoeKZRkx2igPKL8IXiyVv
         9NoUJ04DjRNGdyBsvr0dDJY42vd5WbWA4I0yYpxL5R3n1accL1W9+vw8fvIpN5i4yrTH
         /dk7JTIrAvTh1d5iVO/ylcNkjK9E9/hKWalDwXWkurg+OMtwe3JEjfwkfWa7KF+Zfy8p
         fViWv7v8s4CSc5KcHik8mGhej7M3kLtM3mwqqVbVvW9tkb7nQC3dIivWCxuP5rFo4+vW
         SDlA==
X-Forwarded-Encrypted: i=1; AFNElJ/CfdCfEKwfvU5IiLVEshvZMRxvJ4BsDJWxyWbgzts9A3Ff9RDqAOg73v1r6tEcI/lPTKi7NbnXAYB2@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8YZivy4FEOyNriHQby5U3Gb7kYLJO+bLCNJkXsAW+rgAqgBY/
	KO7dkQ+rWq/uf/K1pRkNWDUFno6NrJE8G4gKPQk7z3DlhLxTJBVLEhS8dhl59dw5VbUy1e/j7ol
	dtcBPmet+UndTEzKLpP8TgSXG2ewluMmDzxde
X-Gm-Gg: Acq92OG8r4eQphiV3+d9IhzNwkO4mt+laGrDR2JsTLm9SV1KMrDaPxNqWAfETk2Wlfy
	PgJVpBTvGDfX9AcmGypxCzph1hrFhTQPNj1UY2FOLk+4II8sJyqbFohkXTOYoHcqUqLfpJa4FPc
	wHlZQpt/4TR4qx09qQN4nDoGvUqQUzVTKTJQPUbsK/04l7P2AlAkayxqMdXZwl54N33M/jqQpYU
	vnGKm5xCVz0Ujf9GgKlzNw3+EHkb+EFEyvwzYthcePu/PgDvUAD9vop7GfBOJ6N9kzLHIpAigv8
	cR5mXb6u9h80oIocoZ+G+gCxc1CI1fyQqY6AutzpMDd5+y0DemajilkZz7u5u49RyaP4MauSicV
	pfqJVTmYUOexzH79aHH8uCRvGIoqZ3tfw9bJ/RGRF5pU4XNhjC9cmoRXV61GK5TZ+x5dnmKDDt/
	8sALerlhqkRrvJIOFFjOlClivscdFCClRG
X-Received: by 2002:ac2:41da:0:b0:5a8:96cf:c8c4 with SMTP id
 2adb3069b0e04-5aa2ba6f450mr990698e87.15.1779372141115; Thu, 21 May 2026
 07:02:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260519233934.684906-1-pc@manguebit.org> <2890c040da473576ba622c579c64b3c0@manguebit.org>
In-Reply-To: <2890c040da473576ba622c579c64b3c0@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Thu, 21 May 2026 09:02:06 -0500
X-Gm-Features: AVHnY4KAcC6dy_bReR-26Y_fDImap8Sx_DMXgTf06QkHe4nXgwDQU-sUhMb0MN0
Message-ID: <CAH2r5mtO0Zznbi=KysEjzitvFs++a4Go3n2Q-2GkOiBCQCg0FA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix double free in cached_dir_offload_close()
To: Paulo Alcantara <pc@manguebit.org>
Cc: Vaibhav Nagare <vnagare@redhat.com>, David Howells <dhowells@redhat.com>, 
	Jay Shin <jaeshin@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

removed patch from cifs-2.6.git for-next

On Thu, May 21, 2026 at 8:23=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> Please ignore this.  Will post v2 after sashiko's reviews when time
> allows it.



--=20
Thanks,

Steve
