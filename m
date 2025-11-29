Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444DC19EED3
	for <linux-cifs@vger.kernel.org>; Sat, 29 Nov 2025 03:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764388538; cv=none; b=F8K5jy56PFIe8z53kHQobDqyhKdtcL1OQ6Bp3j71SfKx0fy5SGJaGhbYN7xI2QLcL5SBdEM7CTC5yxWnRAqd1UEpw70UhyIC1pnRf2tdiCm0abzXUQ8yV+1hRP85nZa1JWMlCAuEX+V6qOOcYNsFdnSMRLhYt6vvhfSqEZLnn+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764388538; c=relaxed/simple;
	bh=9qBX1u+aps4zqCWy5m1wc1K+mQdd1zT6chat9qWT4Y4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cjzhSR8zxyhob2hSLTbVSD4r51i0SvdzVSg97i/M1+w3PBQq7kaQkwshJTaA4+r0Wy+BwJ3yccFpUM+dFfQsLz8+aDlbAvsbPuW1pWRJnVcWBLqnH9JMar7XJmZlIgkIvhef9iKWyCCIWXVAzsYr2Q6lQPY8ze0wf+wKUaGeEEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hr+HX7TD; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hr+HX7TD"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-882475d8851so25947456d6.2
        for <linux-cifs@vger.kernel.org>; Fri, 28 Nov 2025 19:55:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764388536; x=1764993336; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I6SrfljXqUvNeC7BBVdJLhUKTLQlOe3hkrVbnAJPqxI=;
        b=hr+HX7TD4JYyPK93uuIiEgMXrXK2jOGIhrRK7mV33496aYQH7Bm/5t9yhKokMcR4jz
         ynrx1lCOYj3sM7guOipPyPZ0d8OGzZPdkEnTPZtpE/H8xjd+Z5ZIqpveK0RWUXQxtppV
         GKYxbPsfCR0ghXpNPXbcDcrs7W5d5t4StpD4gAsdISqEazOn+Xst6YAvRhpScCCpRcWE
         1GZAKK6wxM4EXE0jEdv1ypPxyEH1Dv7N5OkraK5lwok7h7PjaKfJZRLiScZaOq6aKg8v
         pH+CIQrgb912XwtxqTUO8PLh+i3SyLpD/7jI2orhhcem4AVvyAEjI3zmp7pfuLbEEDt7
         y93Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764388536; x=1764993336;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I6SrfljXqUvNeC7BBVdJLhUKTLQlOe3hkrVbnAJPqxI=;
        b=HUqbk/42iTXJWMtXFMvv6cjyHEtONMq0JpFWLo9cRPxkBY+OnKViS8r6G2plMHCYw+
         upTtitlbFCjzmh69Z/71QG5d0NLgXpjNrGXJfCPAyCuuJoth+wJKQN/B3hB6oxXj1o/U
         WAmJ5XOHdvX0glgDOjj7JNjEd8hWpefdg8EA5fch7puaapX1lgsh2cwn8asevUVmFKLw
         JKSKoJnYYkiTz+zuMk5j3U6hajo/5O1yW3fazews44cWvJBEkG17GDEVvkZh9+/ZcBcF
         kCm3oTpU9ig7y3owSwnMQkg/fOkjnQ5UPFAUHGEZNKh+gdVeWoPYBAMgQFzEJn9m744+
         k7fA==
X-Forwarded-Encrypted: i=1; AJvYcCWIcJj+zct6ZJSQekZ9q1jE90UbTHowoClZKRPSa1tuNeNOEmj3P0R2OQD8HHeoi1Evjr/XkFx7uSNq@vger.kernel.org
X-Gm-Message-State: AOJu0YxtJVH1DutjJNKTLBbCWU99UtogQKu77WUt+DgRtPOsKC5l1n1n
	vjNj0mbELx5ul59FYFAt3qnetdQXm9Lo2G60gvNCw6+K78zP4BAIGmq1dxS0IEAhqADehNqjG7C
	dA9BOsI8lNWY0ncNhndFaBw9Lu7EmSqc=
X-Gm-Gg: ASbGncuYiIF9FbnUgkz5xzp+STep6mIbLIIogiB2yh8X0Q58Rw3ZLDRIqzlpbbdacwZ
	n0nhfmIJZlDuCc1BbF86HYWCv8xqjDl+uYmrlilsABdmlOfIXDdwjP0bSeKSVnhMBS+NqtQ8R+a
	Ii4rlu1ahFfzlHRf/wdaX6FgMRFiddSEpjTOm5WAEzZkFidJjV14Wi5PsjCagIMhJdMkKWD5hG/
	jIVnTXDJn/L1zTxQiZUBX9I0ChEWDBOk9eVQnLkGFjJpNl9nxXCG89vC8xPyXq4/B/aYuDkP4uD
	wGHgN+WDBgaMntHCkKm4u4a+Yujm/l3td+I5VP4q/uDrL4q5pBUlOQ8DWD/jMzjQ/4lMY7WgUXS
	e+6PZ9YHPvtVn1ZDZIA2X6V18cFchvsyWAlUcWDvo9dddNTdVJ5YcLfA/mvUloIQPAu2hAbebUB
	sfyFWi84mTJGmPWOt/ZI4d
X-Google-Smtp-Source: AGHT+IEgMp/WFBD1bv7s9vSClIUduNlVCjrwEPexmixtaZ+OLnnPd0b/puUpYw8yJ2dP4eCUn/iy89/STbZsLNugpZg=
X-Received: by 2002:ad4:5d42:0:b0:880:2c08:88e with SMTP id
 6a1803df08f44-8847c5206f8mr491522266d6.45.1764388536172; Fri, 28 Nov 2025
 19:55:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251127122637.2094566-1-aadityakansal390@gmail.com>
In-Reply-To: <20251127122637.2094566-1-aadityakansal390@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 28 Nov 2025 21:55:23 -0600
X-Gm-Features: AWmQ_bmQEFbMCKSVBaKhdFBjTWyneNqWb3qsdigY1kwee128nndeddkdnSkBYVA
Message-ID: <CAH2r5mtA3cYYDMkqai3Gs7Op44O2e4cZ_V=stS1o9MnDFu4T5A@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Add check in cifs_mkdir() for SMB2/3
To: Aaditya Kansal <aadityakansal390@gmail.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, bharathsm@microsoft.com, 
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Looking at this more carefully it looks like the comment is wrong (it
can't be skipped for SMB2 and later currently, there is code in it
that is non-SMB1 specific).  Looks like this patch is incorrect.
There is a general todo to rewrite cifs_mkdir() more cleanly (and
partition out the smb1 mkdir code and smb1 posix mkdir code more
cleanly via an smb1 specific helper function) but looks like we can't
skip cifs_mkdir_qinfo() as your patch would

On Thu, Nov 27, 2025 at 6:27=E2=80=AFAM Aaditya Kansal
<aadityakansal390@gmail.com> wrote:
>
> Add a version check in cifs_mkdir(). The check skips a function call to
> cifs_mkdir_qinfo() for SMB 2/3.
>
> Signed-off-by: Aaditya Kansal <aadityakansal390@gmail.com>
> ---
>  fs/smb/client/inode.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index cac355364e43..f6f223a5a97b 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -2314,9 +2314,9 @@ struct dentry *cifs_mkdir(struct mnt_idmap *idmap, =
struct inode *inode,
>                 goto mkdir_out;
>         }
>
> -       /* TODO: skip this for smb2/smb3 */
> -       rc =3D cifs_mkdir_qinfo(inode, direntry, mode, full_path, cifs_sb=
, tcon,
> -                             xid);
> +       if (server->vals->protocol_id =3D=3D SMB10_PROT_ID)
> +               rc =3D cifs_mkdir_qinfo(inode, direntry, mode, full_path,=
 cifs_sb,
> +                               tcon, xid);
>  mkdir_out:
>         /*
>          * Force revalidate to get parent dir info when needed since cach=
ed
> --
> 2.52.0
>
>


--=20
Thanks,

Steve
