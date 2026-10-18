Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519FB312836
	for <linux-cifs@vger.kernel.org>; Sun, 18 Oct 2026 01:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792286633; cv=none; b=uoyLv2xZ0u8ITFz8nAkfkow+97e/U9tmyRqv+FJHbrvi862ul18if8pQbugqkRDiESzgq+O5Cs3/mXaJk1iIwgXWjOOImUPeU3EIdEFo7Wk+BdyyobrQJLY2nIXmV0JEt7E/GwVhh38egxUyFq0vKWf5wr+77bBIcjrY+8Hna5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792286633; c=relaxed/simple;
	bh=kdIS09yOM769VQIrjhLpMRDuAml2Kw78mE+2NlzQLBI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m1XyOWdIDNLWIPzFr39sT3TcCeumWW3Pir4Bgl1JjjRLJpCT8wwjCnyaly+Dk9SdhWXzo5OGKNZ2QB1P4ZN+vgJquQ5o04clD3ZDeiA1PtBR0hdnC/UZ9jGzXGFWVs3/mLpR/L2j+hml83DYwXI1LObaMwFXDzwueZbOq+5uOR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/ExLNyU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/ExLNyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88971F000C4
	for <linux-cifs@vger.kernel.org>; Sun, 18 Oct 2026 01:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792286630;
	bh=kdIS09yOM769VQIrjhLpMRDuAml2Kw78mE+2NlzQLBI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=h/ExLNyUy0NboTANrohPCMMREjSTrvJnc79tIfpOgo9d8iyqjNTALBKhqzWNOsEiF
	 OuSbxOqWTggbMf5ocI5K+yhz6mw8Ak8qumr11RaCsClh/IvFAQcLc2Lz/DV9QxYFWr
	 Mvu269CEppW8DPtKt8JLDBrczuPEiEf/xsBlwYxZbC1Vw+w5jyEKkuawM74lw8RZ2Q
	 qgs79hXK+gYfu//MWtu+Mwr191cjwFWSettayzJlxWPFKQIgwXDcnqaq70N3FvKQva
	 AJHBhR4lDS4kLxviSjY0JsVKndc4Lfm493HsJmpaagKiZSuQn43yytImmsycBJDQcR
	 li4WRu3p7CPHg==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b170129413so1533556a12.1
        for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 18:23:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxPo3FilUKZmyMYbT3MvqT3tJ/SLMR9gFyZmoyje8fFMlXV1d9/KxoaX4aCpzl4wQGJtJLHrRjjFUyi@vger.kernel.org
X-Gm-Message-State: AFq9FYJVBaKe2XPYlTpwT+ysK1j9n4Up2UaMYMESlDTv8Yy3dT6FMPGK
	+BD3rwj2sAJj7QrIuGs58ar+ITjZH73OGX5ojQ9wcg+sQWLLX1Xc9+mNjzT+LcEEaRwYlG6Pba/
	ZFDhg9mTXxQ83X1LQsHJlp4Sbt7coJj4=
X-Received: by 2002:a17:907:c510:b0:c40:d920:746f with SMTP id
 a640c23a62f3a-c41a0ecce8bmr236774966b.46.1792286629421; Sat, 17 Oct 2026
 18:23:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAN05THQKjL8oyGH1N-K4TTT9cQErNJaz4SO91uP_QHRmRGhG6g@mail.gmail.com>
In-Reply-To: <CAN05THQKjL8oyGH1N-K4TTT9cQErNJaz4SO91uP_QHRmRGhG6g@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 18 Oct 2026 10:23:37 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-9UvkX0qeTNuhV3o3dM3P9Vcm5+GjwWFRQxXOZUmRu=A@mail.gmail.com>
X-Gm-Features: AclHuK-toprV95m5vF3MBjykBrC1kL3BclmJsMk4CdZ1QVLAbrQXak1Dfs3tLM0
Message-ID: <CAKYAXd-9UvkX0qeTNuhV3o3dM3P9Vcm5+GjwWFRQxXOZUmRu=A@mail.gmail.com>
Subject: Re: ksmbd: related compound QUERY_INFO fails with STATUS_FILE_CLOSED
 when the previous operation is not a CREATE
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	chenxiaosong@chenxiaosong.com, linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 17, 2026 at 1:42=E2=80=AFPM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> Hi,
Hi Ronnie,

>
> ksmbd rejects a related compound request that Windows and Samba accept,
> and that MS-SMB2 says the server must accept. It showed up as a libsmb2
> regression: our fstat sends two QUERY_INFO requests on an already open
> handle as a related compound, and against ksmbd the second one fails.
> (libsmb2 now works around it by sending the two as an unrelated
> compound, so nothing is urgent on our side.)
Okay, I will fix it.
Thanks for the report!
