Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D9A331A5B
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 16:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784997689; cv=pass; b=CX8TEqYGgtEkUUgCDlUzQfZbxAiEwQFrE+QWwpL2gYD5ox67lJwuZh9HwwMJEInv2/qEBKLblJTlL6EBCAHU2IlnePsFXXznwHv86TOVkh9zCqOsJheDab3eXhlXEpZDo8AD6uwJkjDmyk9m9i8wg5+IDnm7RJLD4aiQM/H291I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784997689; c=relaxed/simple;
	bh=jdueYztLEu0Swobrt6m1r6utrs1kDABcVdl/+De8y04=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ii+cVQ0MlxiKFHMLdNmZI4/J9nGOG8s9Y3faxl+WOv7qIq6AdPdP828yyfQiGbhMU1wSUzuOQ69VMSfE89xjB0fYO4sEmCQcjWA1sAjBEca18WtmjiEJnZBSMXU49KegEyKiw00mvmyj1seS4r4asXNcXYvODt+W+f4+FvkXQD0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U2TcWf4N; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U2TcWf4N"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-529a1ee0e62so8098521cf.2
        for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 09:41:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784997687; cv=none;
        d=google.com; s=arc-20260327;
        b=p1OP4bRdAMwVy0mndqOfdP1ys2PDQO1ceXuUitkII1yYq3JiwH6hvh0jMR8Uj/ZYTl
         kTOaU5BCekwj3wbOFV2cb0MTochEpEY4IHXObwTOb2bKGMkbz5/aJe4UGAwpFf/pX0W3
         8CNRJQAztCRiS9/6VsXHRndSnE1ho7Lyyiwq2RslnQMg+VBkW5WMilxoweH9suAlCK5v
         XFkprkD6h5giPfVneS/SrLo4tmda+tuBCORDT7pgKi5lQ+cn8sJjKx44RimsN1p5fccL
         ZT4loLUM3AtENyQ/c8PKY+QHi9+AmrSq2BfpVAXLS6CeQV/ggM7HmHtIGhTAjnzHdrcc
         gQAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jdueYztLEu0Swobrt6m1r6utrs1kDABcVdl/+De8y04=;
        fh=6IuIG+7Aur1rEef+oxSinRXBUVXfS67bep/BQT/px54=;
        b=DFumU6jSBJI4F3QtKwZIUWTBIoYRq4bGMm+8MbqmntVq0Fv6niySTPcexv2yAPZUsh
         hnEZcCPN+v7h+Xb27ktrl+vcqLQoVZIEUOBP4DNqyd2KW6ObmJv4mQdhFTRh2ydfPYAO
         TKcQYbUE0hA3+Dwyr8SHNgfQLTRYQEsuLbAIS7SCaowScRRr5ioZy8yfOZR2gsR8kBK/
         PEGJa/IU0IylMopa1HrsLLQ86Egpp/XS5idNJ0VhW71h+7UVhYXzvoS5hLcIePKWI2X5
         VDCZzZJOER//aI2B0uHKQtFwvVTYAQWjprfQjL4I2atKn2MHc2tDDAQARMWX/AbZHjxl
         Y2gA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784997687; x=1785602487; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jdueYztLEu0Swobrt6m1r6utrs1kDABcVdl/+De8y04=;
        b=U2TcWf4NkOPr0xbgUZupDLz/y9lMhoOl4ZLpFNmimeaDL8qj8i5W3wmHHykzhyjcrj
         hzYOo01IUQ7SuJvcQS0loMGraLcPe07JoF41hTkxdMKDg8199CMFue/dfT7W0B4zz2bJ
         7X03450X3TAjBF3+oIYtc6s6LqFHm7PKm8KsYYRcu3zY+d1/HQ1iDK3XXk2RubEJeyr7
         K0Cw8uNfdeS/aqvVTLkfdxzxhpU/WLFiDF1NqNUvp1O1XmD8tbpMGIcDJAlsbrsfXpUr
         RrD37TRIojxcDHIIAqVsTLMY4QyA4fHGpciHZNC3Tnc+uvDORBk3GYWy5OKcHAOqu0Tw
         pfyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784997687; x=1785602487;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jdueYztLEu0Swobrt6m1r6utrs1kDABcVdl/+De8y04=;
        b=flx7DKpIIyrDMT752oYLdHJfCl+QQau+9KZc6mdJ12MogpP2/WQc9L147XRxcz65Wt
         3ydrzWrkvXD8pUvZGqq8XnkyY14y43VaFl8RiG8eMHBJmn76W6rMswN9ZZ9RwGPDEtEA
         hySb4OBQtEwLEG+J1s0sIJrpL4p/d5IQ8bRgbY++bZeNO/f52SoVk+zsVTCaUihw+HyR
         n4kZELB34FzmQ8rJfm+bgZ5wkZJs2S5SmyPKbgQw2EzwkGAKXZ000dZraYV3ULXhLrIw
         SoYFukZMltGnBOMBoJt6pkKgVsHv3XI0B4otheJzJ2Ffml1CnzZFHFfSBIzivDCFd/0n
         IWvg==
X-Forwarded-Encrypted: i=1; AHgh+Rr5cqPkswH2soxWka+7/2ohfKUXxjGFa7NqSdpnWpbO8+/H3eetmhK+6794yuPyVKkzA0NyZZhUGipC@vger.kernel.org
X-Gm-Message-State: AOJu0YwYsxtwnbvhvflLxZbtd54eMuFckT4Li7OpmHRLkeVO+QaQs0MR
	6O8G0G6Ek8fimZ1190YRQQ5O4WJGKpxf8Ie4DM2qNZV2bxKT4CKsXoiJpStQcDw2IYfP69qbsfI
	o6L7ziU7ahdeFxrcKD6rLPXkq7ILyBGc=
X-Gm-Gg: AR+sD12Tlju/qRFmsyeMo7RblL7o7tZsbFvjai2PI6X8Ov3jWU2G6F4f+28D2erpar8
	ix2SJPS6QrIGOJnMhycehiMguuPS6xljePYitlfemKySiX98+xd0Ep78U0DF/H97bxWigK35QFu
	7URqz3jyan936hAMorajauEbgNJBMny4zm5+08xxfM7hujswrI9+2NbzpIJqA1SGtmXORKrjWMr
	ffcVg2emK9g4aPXpQLkR2zUUJJqf6RD5A5zcWK4TxTHbz9UhGYIfgmFhvVItzDh1LRE71xSNv0w
	7yhFtIJK27JpBwus8D19fEFJ1stz1eoiJPGa1zgNCLmr7gzgYYmwto1d683mCC65f8Q/OSwfmlI
	nCLmSCnJBf7Az3knLotb1TM0yXo4mnOVtTDMSp8e4LrBy53zWHPl7ddmLoAU2pSzXscBwdgaWyG
	Cv
X-Received: by 2002:a05:622a:44e:b0:528:15e:d1cc with SMTP id
 d75a77b69052e-529a8362f85mr27131881cf.13.1784997687200; Sat, 25 Jul 2026
 09:41:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260703122104.69788-1-mdshahid03@gmail.com> <20260724123134.122865-1-mdshahid03@gmail.com>
In-Reply-To: <20260724123134.122865-1-mdshahid03@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 25 Jul 2026 11:41:16 -0500
X-Gm-Features: AUfX_myua-nPkq284-0_DGYhJt9L_BxE7OD2lyAEM0g0nD1_yQv29NznPKvTvg0
Message-ID: <CAH2r5ms6NiGXkvZZhHRVNkg+EjBuzJkD7SyoDcvmj8PbCE+hjQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: remove redundant NULL check before kfree()
To: mdshahid03@gmail.com
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The patch is correct but it doesn't improve clarity and doesn't fix a bug.

Any other opinions on whether merging a patch like this?

On Fri, Jul 24, 2026 at 7:34=E2=80=AFAM <mdshahid03@gmail.com> wrote:
>
> Hi,
>
> Gentle ping on this patch.
>
> Could you please take a look when time permits?
>
> Thanks!
>
> Mohammad Shahid
>
>


--=20
Thanks,

Steve
