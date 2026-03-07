Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29362DC772
	for <linux-cifs@vger.kernel.org>; Sat,  7 Mar 2026 01:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772847782; cv=pass; b=GB5NPyVfo9ZPtDEh6MhcQWHuvPhxKubXOEozPcMVF8uhNbeOqhkFCkHG+e1y41sMuEsz9O1IH4wbID+MI1xjwLJxzv5L/3ZDizoapiM1YPnyKsiqsqcLs3/AzLmVFElbm+6kyGMv0HL/Y+Mpd1325cZ/H84Siituhi3bwp4ewzs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772847782; c=relaxed/simple;
	bh=piI8XkLa5GmJkJ3IYr3f0gkWdbwYl9QZ1DCNAO/8Qqk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VE4io7llWbLH0mN1qQU/cZT/3VaWESyi9ecE7Vw5VHL5NussY3YdI4NBpR+8Ras29jWPBlVjwpQr+mAShavOuoK4EM0TFJLHrDNRuZPIZPxJ3gXKuhZGGgQsYJ+9Q8pOFhEvZQc1pcATslxVjmaXW1PCv+Ixjc0SphXtUEIgJSc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ox7HshOM; arc=pass smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ox7HshOM"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-899d6b7b073so104996946d6.2
        for <linux-cifs@vger.kernel.org>; Fri, 06 Mar 2026 17:43:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772847780; cv=none;
        d=google.com; s=arc-20240605;
        b=Lve4OWV5Oy5ysUDm7db+C7rZ7lDNO1Dk4SxFB5gvXPeJU1g4JF3nOptZTSeU6x1DEt
         G6NVQhPMTm0FmflI4gpEd4bl5oCxesmHBxq+GySCGRrw/x6MCSMcAFjg7hSB3yb3WoKh
         DGKbNuwBB+Bfgw0qWTLtIqC1aB+KVx+YnCW00+JaR7SCiOZYonT60IRwN0FXnXVuWJgX
         YOFDx2yk339BEpb+ceDa79G0JkvPeruglgMpOl9MWqs+3Df9qiU2cs8di/fQJrjIiAeg
         lk6rMi0ro+DdEitvdfgbq7o+4oHigAdU9Zv8ehkG47YckTBNIV3hrs7NSNIRF11RTnb0
         fOeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ifY6u6TYDN7Q0UiM7TPk/HVpGA5GkE1iXJ64TlqqWlU=;
        fh=t0mkbo3TV1btoecb5gorGA+BnVGNktDxvaOt3Ahbw6E=;
        b=aGPuitZ9C98NPBKOM6GqNGbAqhBHRnfcGGq2uQ/04Rkx6Ju30t0T5z9yZdO+KZ2lAR
         j7m/6YscGMSQfKKqP3nmgwmG7DzTo2vl2iIU0uEDPws0pPoPjG5E22xPhD1Paw6tFNNL
         jMfxsVdMgzjRC0fvfb5lGQcvMgOaT0ZwR5V1/wCoPIOQbKuUVeDx4dC1lNsJnYIj6nKy
         e0+Ug1Lmks4GFlOuKAPKiUrxyWV3DM0VGM67vENnTinxmsaunjCzdYRFM7Hhw43ya0JV
         3XJw/kRJy8aLGPVTScM4DqZJ8NUiXKqA3qi3L7AFhAKzjyNsl/bgz4rEXOIAnQuEjPxW
         xIbg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772847780; x=1773452580; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ifY6u6TYDN7Q0UiM7TPk/HVpGA5GkE1iXJ64TlqqWlU=;
        b=Ox7HshOMG+PQ4KvJ6lGxWBH+y78AACCFcOHQpdoujLD75FjfA0tK2UFVwlJQsAgbUr
         R5ob6TpdNY+YpQ4l7dbFdpCE6RKh/SkXQIzlQDO1KZ5T7wCPIZ6XQV8trbORJukmdplQ
         fdDhvtrSo8dsKTw9bRghvrOqjVxvioJ7SSKNNoX6RfyocZ5d9b8JWgF6YtmWtOo7cpFE
         xHN3KSVcQUF1+z+eu8Qxz5sXu0Qc9ytWqPGTxB4fIgtxb8HNpcVUV5QYRc0QAWuAZEkW
         0WU803At6AepjAx8ehqldoBIUmLGa3hdziypPVnIz9jFS8KqYPo8kM7y6VHjLHlIHkOw
         o8Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772847780; x=1773452580;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ifY6u6TYDN7Q0UiM7TPk/HVpGA5GkE1iXJ64TlqqWlU=;
        b=kj6fDN1T4UMJDPnWz07Xy1RrwjVHQOlpcE60Xkh/9fUXO5D3aVy0DXJquqWPTFhHWQ
         2WY6ju3q6ezd0NpZkvfx1n0oFAeru5fUux2/hxXM+hdWthkuybidCRdha2sKB0a6N42Z
         DOgrMkDGYvitW2W1NSd341R+iWpTOJ3GR1LKhhORI+RDdYHCvZhZ1VsJTnhjMrosCJ6Z
         16mn28XlD1g1yVpY5JfkYlQuQfgeRS3IDJ7UxMYCqGARsLwZPeQwl2oGiMjnIXS8OU9y
         dT1MQNuq6l75kXHQHuSPoCB8NBKRwJAqF9Ltz4M11Leo0KNDL1yxYmlV6W0qnqKf5zL7
         VpOg==
X-Forwarded-Encrypted: i=1; AJvYcCVL1JnPC2zMSL9LdEBn1y2O1mRI+DNUMHAe2KJ+lOZwgDHjI6/SKlszG0vGtaqWceD7JSwHTLXix9bR@vger.kernel.org
X-Gm-Message-State: AOJu0YwWCJPRLa+vc3JmE4V1ZTIHd+SRjCODmus5k99nuhGI9XnOXMgF
	yVqkaeALgB1bRw08Z2UUzeExyAc41ziE2vSYlL0kOEaw//GrTKF8t5U4iTaFAhLWCB9m3DkOEbY
	KEvG62kIeThwWSdkiTwjfLxV/ORsYKDo=
X-Gm-Gg: ATEYQzz4iwJ21rasikTzHQ+L1zXgQjD8mxK63qG1xf3DaVor8o6TrRcxXWVIzYEzRVT
	S0d0bzwsXpBZ3s9O9bl0lIy+Q/UKz0idVfO74P3IHrc2xyD6EeCu9ZDwpXzbQ+7IpWBNRK3pT1P
	y7g53MwzX5hgg2XNqxwdvcgGqfhFYIi+dmDlw5k1fn73nYO73h70RFP9Beu3/jPZuXn6VT/nj0u
	GCozt3PBjTmF7QMr+LoLYR3wEvqXfqMtawRF2lfg4hX2IjRB2bN1iO71bB0AD5aXXAlx+SuFemd
	/B03jW3Y5rd9k977sND0zVseDI1YL11qKfXNfqRwdRHDTdLTtT3PaQzV2uIvJ7u6AbqrUYvOxuY
	4vm8uTcBQ6lFSu7rUAhDJtsUrBKFzQgZuMAtN8AFqKqMYhm64REdDoYayL9WQODC0uwz5VZIkjM
	7kQSCM8d/UMr9qSsudmbP6llJpruk6OWbZ
X-Received: by 2002:a05:6214:5288:b0:89a:3c4:5161 with SMTP id
 6a1803df08f44-89a30afa2bamr63756306d6.59.1772847779493; Fri, 06 Mar 2026
 17:42:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mu0T+Gcea5YKaAA7L6FfM5OMjEKenih6Sgk2W4EXrSpWw@mail.gmail.com>
 <CAHk-=wjXKY7uS6OBPuNMc8xsiHwyVCfbaEgCZGffooxr=XzOaw@mail.gmail.com>
In-Reply-To: <CAHk-=wjXKY7uS6OBPuNMc8xsiHwyVCfbaEgCZGffooxr=XzOaw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 6 Mar 2026 19:42:48 -0600
X-Gm-Features: AaiRm520bUWFjEuWRMrNL3I2bEV8cDRgJWo7TuJyHxthqVYwaYPzdhCYWyYvSSk
Message-ID: <CAH2r5mtNug117PPEiYpron8kiwieU5g0FbTq9a1ABa1BQkF+TQ@mail.gmail.com>
Subject: Re: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 6, 2026 at 6:22=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, 6 Mar 2026 at 14:04, Steve French <smfrench@gmail.com> wrote:
> >
> > - Security fix
>
> Bah. I had to look this up - I don't think it's an actual security
> issue, just a (good) cleanup.
>
> Yes, yes, the old code did "memcmp" instead of "crypto_memneq". And
> yes, it's in theory timing-sensitive.
>
> But the two compares were of size 8 and 16, and at least clang
> generates a constant-time comparison for that anyway (I bet gcc does
> too):
>
> This is the 16-byte case:
>
>         movq    (%rdi), %rax
>         movq    8(%rdi), %rcx
>         xorq    (%rsi), %rax
>         xorq    8(%rsi), %rcx
>         orq     %rax, %rcx
>         je      ...
>
> and the 8-byte case is even more trivially constant-time.
>
> And I'm sure that you can get the compiler to generate garbage that is
> timing-sensitive by enabling some debug options that make code quality
> much worse, but my point is that as an explanation for the pull
> request, that "security fix" was just not a great explanation
> regardless.

Point taken.


--=20
Thanks,

Steve
