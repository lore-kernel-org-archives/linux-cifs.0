Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB031FB5;
	Sun, 28 Jul 2024 03:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722139070; cv=none; b=r+k9MAXVlQa7ShVqX3Wlsp1HIsZ46XcKxDs3XR8Saa3DGPwq3cJ/l3Ht4Qtk8CYAQaqHe4gPDSxDJVugGhnk5oeXI4F+cDczUqEwZvxrZkeDeoFEe443Yg7wEqA+sB+Hd3AJnRHvQxgv6Dfe8UsY54ZUFwf0F7vmyx1KdKXclpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722139070; c=relaxed/simple;
	bh=wD2rMwTWDVrfu93DG1yuEKvv6HSyOU5h5AmwQ8f7rNk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nWAzf/tvuH+PE16DbWoPepucX0bry1/iHQnmsbEQ4QPuQ6BJ2oPV/wWeO1E4mV7u0/SKEZz+skWqSuZpn20Od3OgAj0znVZKJAXUWL6x02ddcYm+oF7aCdoEx4uA6urPKS7tKdZ/7Wnj72bF1ZtHExSCmxltedn1SWQ8Sfo/hbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XFaT0DDu; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XFaT0DDu"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-52efef496ccso2423542e87.1;
        Sat, 27 Jul 2024 20:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722139066; x=1722743866; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TlNGvY9aH4NpfBvkP2RpTVgRaaXOJG+AgeG54TxnHeQ=;
        b=XFaT0DDufuYq79KjPQZv1qiLtE/OfAiLtdTT2kCBHwfT86QIbYEXqSR7ahNEA6QMTP
         wB+1fcgtmEsmdZ5VIm2vCJP6SGc80AHQL62+VmouJXN/+i6NfL09fi8Q9vLGu3+tf5yo
         p7fTM9T2Ivoqpf33eD9UBpAO0Ni0DMzpc4W6qIHhpY2cmUTtqdx28x84nWRyxnpwpjMA
         7PT036agcDKeNGZNff277NtieRa2SOE1McKPb7YWIvD46Xt8CDB+JHw2eyKE9DPRFNE6
         GkXMcOJ0nZOZ4q9YwvLN9ATipI4t0aVoCzEhLoHtW+3DzxMhOwnaMkcHSxdScyTaXCrN
         NOkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722139066; x=1722743866;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TlNGvY9aH4NpfBvkP2RpTVgRaaXOJG+AgeG54TxnHeQ=;
        b=Ljooyo2+9QjHDAqy1/SoSjXhRN23OgF/2Q2T0BoEwdzBeCiR/BqebMDCnimiBgwkz7
         55b+a3cztH73Khk7Ag+mcV0vMnZ3nnV/nwPBDqJBd4bGJHH+uxyFYeop7uIULUpEEUa2
         wW7Z9V7zll2oPKvvfon3jO3NDXfmq4XI6g33AV9KsGEokp3D6FX4NdWKVU2lA4aoi/Aj
         avuWC7F9zwcCFbGnvgG07OXPfkINzFOH+qZ2mJQm8RVjjXOukuL/q50QWYYnBrOjgZJj
         HpakkAPYvg4twqz1nc8FL92rstriRIKSWc39Ld+szRLiNxRvq4JkvJQhHAvkvUAPE2/Y
         Z4nA==
X-Forwarded-Encrypted: i=1; AJvYcCUU0dRX46PySFBor0TIlDJ+mi3T/4AEu0mr38eOOIEYpurLVyGGZ4WzpixaW4Q+BReaLwcPdl8jNmRk25/hIst4NnRqENg861FtqpEy
X-Gm-Message-State: AOJu0Yx9I/9VblmLR98Enk4C2y+TzbOZzjADopwLmPMGCKXvBndCJVcp
	yP02GnN2BNuI6oTptHdTa+doEOQnv07t7XwzuzvIqhcWB8etitfUkMuX2GJFBmMfEucorQBkse+
	M7daGs140rQhFR5xRDom4OGtD4MdhHw==
X-Google-Smtp-Source: AGHT+IEIa91NtFvrskYF6tVHjBonQvcmLMfHqCdZRG/Z0lyyuPe7VCs/xehQ2mkaOZXl8mauw/Nznnlv8n75UXBjc04=
X-Received: by 2002:a05:6512:39c9:b0:52c:f38b:41b2 with SMTP id
 2adb3069b0e04-5309b6eddf8mr971986e87.17.1722139066013; Sat, 27 Jul 2024
 20:57:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5msuLY9XywuKvnggezTdjCBQx8HDfYhHNstS-Yijz15sdg@mail.gmail.com>
 <CAHk-=wgS+TLGrPpcL4fy+NRRyuXbd-mJed50sXoqsPR0w75Oig@mail.gmail.com>
In-Reply-To: <CAHk-=wgS+TLGrPpcL4fy+NRRyuXbd-mJed50sXoqsPR0w75Oig@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 27 Jul 2024 22:57:34 -0500
Message-ID: <CAH2r5mvJ5CvnrGxMQOOkVH5BFycwS8Rpub1CoYx_QL48OyEZew@mail.gmail.com>
Subject: Re: [GIT PULL] SMB3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 27, 2024 at 10:17=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sat, 27 Jul 2024 at 17:35, Steve French <smfrench@gmail.com> wrote:
> >
> > Please pull the following changes since commit
> > 33c9de2960d347c06d016c2c07ac4aa855cd75f0:
>
> Hmm. I  got this twice.
>
> After looking closely at the _almost_ identical emails, I assume the
> re-send was because the first one was html and was rejected by the
> lists?

Yes - I accidentally sent without the 'plain text' selected so the
first bounced from the two lists on cc and resent as 'plain text'


--=20
Thanks,

Steve
