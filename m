Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBAF24E4B4
	for <linux-cifs@vger.kernel.org>; Sun,  8 Mar 2026 06:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772951480; cv=pass; b=lrPPGNJKGQ7PUfp65k9Hvf5V7hKZN0cU81Uodgz1fn/AnwmjPYAj/C0RjetGd6WMCVBcoi8rRM9vkd/IdEWrsi7ko6XzClr0Jmurj/3NSBStq+/Pjr2dbzDBV/8NlGiOd7VOSJVGJVdj9MaGEwZrJRXe+yUxaBIas0eixJksAtA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772951480; c=relaxed/simple;
	bh=bqMEOQ0Ckcrgyric5QOWebyRcZKyiXhkKZw3Ukws05o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BFVv3NvrikpTZjnZLsZQVcQUSt1M7V0w/k0BJfd0kgzB+W1TUx5OlS2IoBy5eXe+HOyHafpOT7LEVvGPpXmViYBx+4rW78eoH7TAjX70ZLQWd35KIe6EF1H3s8OGzqLv4BQskkD1lxaUGWa1tS0FjFJsxGfA+eMqQ9h5DCoOWIE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UoBC7Wij; arc=pass smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UoBC7Wij"
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-56b17c0223bso321586e0c.1
        for <linux-cifs@vger.kernel.org>; Sat, 07 Mar 2026 22:31:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772951477; cv=none;
        d=google.com; s=arc-20240605;
        b=M/TVQcL7Rs7lcXSaXHtvRuoHl/xbawFmkNWwh29SabP7EK+aaHegrFSeewY3cASO3S
         WHzOoiyJDFqa9z2NZo7ztegsT4W8iFIlajcsD92qsBV0xv/u9Gs4iCLIck7k7FqQ6ROn
         CUgUxYbheaBxbbmBX4b5+whsZlhUqWgxQ513qJKW+Hmv9zq8ALt1YVXCODXr4FTguftg
         gMmQycd6i30YgBxjjdZavjl1isLwte+uu7y2rTvd5HeXOhsucaBhEMwp4Uou09Z0Ahot
         VDlQAPbogBxbwGLv4ooPbw4CqOmV75r4aefDd21Za8fVhlHMeUfVzacXFN+m7vvBKF77
         URNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wmFGvCnSNVovQCGgt6RuGUFVOm9BbgW1X0Xq7Fd9owU=;
        fh=zODJzpdIDRJVj5uvxvofl70jO/kTJ1JZHOB4MHB0Qrk=;
        b=FKloCh63FEsfPok2AvlE4U6qPlxKOoZgkmWCly5lUrFdEkch0A7oJhJ/BWjK83JOQG
         BzOtUsTkUkpoX8TSb8y/ORI5F1Iw9BTIowPt3TSMz4GFunGAZQ5JHMPDmaNoRE0vyT9C
         oliFyYwsU6bDjc4PKlqSHB/kSl18KZh+uKjsAEiEOZ1iib6MWVwcEJCTyjoJFGxtmEVt
         pCqA1XGu6o6NgQyfKmI86L4mRvopIoXus89eIkIzH+VtvdCfjTG6BvURQsXFIRlYUipu
         l3hzZCYiGJSEYR3XbtcGDzoBVhUP5tP7cblHMjMluCkNXlx33AUdy0Wa6Io2AUhI3CS8
         13JQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772951477; x=1773556277; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wmFGvCnSNVovQCGgt6RuGUFVOm9BbgW1X0Xq7Fd9owU=;
        b=UoBC7WijfmQjVlLHxpWqT3DlTCrRD4bQJHimo+Ve0AMx+0bxsR3bN/1HscBrJM5qp4
         hAoHmEH3IXVxPHPjHP72bQjLwytOTAT5lJd6vLsKUfcx09gi0FJHs8GAtUs2Zp97KKRS
         FEk475ub7vx4XQABNB53DotIZxjsKUBLPuPd0GzyFt/3v07yHqf9qXCPxfHICyaytCF/
         wULC1pF4Xso5tHqPjvY31TUJdWMLPO7UZMC4SdrzuK11/bdvaGVzvdmvJy12Y+tEql+T
         EYn1klj2Rf4ROnNVpKQExB+BChYuTiyYbqJmdmRYKShyl6hiOYBewDd9lUoEbhAHN1Ij
         57aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772951477; x=1773556277;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wmFGvCnSNVovQCGgt6RuGUFVOm9BbgW1X0Xq7Fd9owU=;
        b=YfhkHmT55nF7ykwI1l7RDPY5zzAFf09FDKhRpi4PrVFhqueTnq27Egke6fANAk/Xi3
         pbEasObcIDCtdyXQd2HdP49gfL2EKEYLQlPkGu2xiv0N8BImHOLWFR7Hdp3F2MnMJsKD
         ILdYvK3TqIMebbSQxsAkofOT7/cz0rZyGkqgXUoj249aNnn4LVunDc6HmhOI8ZgKndco
         mMN4xEpegfC6Bu2Dx2ssDIs74O5EJyMu87LMEuX4088TOceltZFW2SGkAe65Zp0RPT05
         r83KVE8Dg6xBjHG6IadVzFqUhPiR12Y7waIz/Q16xxkNsGRJXhL9EYySCzrNOXkASLKd
         0wFg==
X-Forwarded-Encrypted: i=1; AJvYcCUIOjpMFroHIkK7lSGXJHNh2VJqY5s7CA5Nmj0sw9qSnu+lEXKTBWQkZZ+mi9UJi77ebJKyds6GXWiU@vger.kernel.org
X-Gm-Message-State: AOJu0Yyvk8RrcTG/fFTT16YK+rk1dj+W3K0i7wLtU18FjvOTzo50irh6
	DKn4D6zosmmpMFciHHHa/Z+vo5mRNdTgmi22vX91N2ZX4p6fgQ/vdnQjCN/47X8UxADm+4Kmfc7
	ifuOpqrKG71Jj3zbzbN5rSxneM2dGu28=
X-Gm-Gg: ATEYQzxtGNQDgXWGMDuhBl/xCYjaPB3xn/5OTVoxG4AvS4zPjpfIyfLOMoI6/yIU5QJ
	j/+S5TPw/PGBepAk08UZEtJkA6rEVWKenRxE1Oe7vZ1NEF7Hkywg38t3hFiPP8LOsaNlaFclVbY
	NEFzZ9SARKWuFlPy9Xbp5W2YhFzUSiU+YVl16cqIYf5IzmChArSrHzZsm5rPbdjGUcBaV1bFGV1
	mTqo9yhF71HDEVh36qdlFyUkqa/ckiaHKBwqxa+ZFeHJdao+XyHB4fNAhWURirN+IvNOP1l3ich
	8Z4OSm+Ag1EstrR1Xh4t5jiuAS3P4alvvLtiihVjMg==
X-Received: by 2002:a05:6102:41a6:b0:600:11e1:2a4b with SMTP id
 ada2fe7eead31-60011e12bf3mr732622137.34.1772951477120; Sat, 07 Mar 2026
 22:31:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260307140726.70219-1-dorjoychy111@gmail.com>
 <20260307140726.70219-2-dorjoychy111@gmail.com> <CALCETrXVBA9uGEUdQPEZ2MVdxjLwwcWi5kzhOr1NdOWSSRaROw@mail.gmail.com>
In-Reply-To: <CALCETrXVBA9uGEUdQPEZ2MVdxjLwwcWi5kzhOr1NdOWSSRaROw@mail.gmail.com>
From: Dorjoy Chowdhury <dorjoychy111@gmail.com>
Date: Sun, 8 Mar 2026 12:31:06 +0600
X-Gm-Features: AaiRm51WCqo6sYLOpIV6hZ1XNIYME3jM_VRhuXhqPcz8hjUnJuRMBp96SANcO1M
Message-ID: <CAFfO_h4g-QtE1gsp3nw7+BUYnRj29au=pYs1goEnppbdU-8DbA@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] openat2: new OPENAT2_REGULAR flag support
To: Andy Lutomirski <luto@amacapital.net>, brauner@kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, ceph-devel@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, v9fs@lists.linux.dev, 
	linux-kselftest@vger.kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, 
	jlayton@kernel.org, chuck.lever@oracle.com, alex.aring@gmail.com, 
	arnd@arndb.de, adilger@dilger.ca, mjguzik@gmail.com, smfrench@gmail.com, 
	richard.henderson@linaro.org, mattst88@gmail.com, linmag7@gmail.com, 
	tsbogend@alpha.franken.de, James.Bottomley@hansenpartnership.com, 
	deller@gmx.de, davem@davemloft.net, andreas@gaisler.com, idryomov@gmail.com, 
	amarkuze@redhat.com, slava@dubeyko.com, agruenba@redhat.com, 
	trondmy@kernel.org, anna@kernel.org, sfrench@samba.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, shuah@kernel.org, miklos@szeredi.hu, 
	hansg@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 8, 2026 at 12:56=E2=80=AFAM Andy Lutomirski <luto@amacapital.ne=
t> wrote:
>
> On Sat, Mar 7, 2026 at 6:09=E2=80=AFAM Dorjoy Chowdhury <dorjoychy111@gma=
il.com> wrote:
> >
> > This flag indicates the path should be opened if it's a regular file.
> > This is useful to write secure programs that want to avoid being
> > tricked into opening device nodes with special semantics while thinking
> > they operate on regular files. This is a requested feature from the
> > uapi-group[1].
> >
>
> I think this needs a lot more clarification as to what "regular"
> means.  If it's literally
>
> > A corresponding error code EFTYPE has been introduced. For example, if
> > openat2 is called on path /dev/null with OPENAT2_REGULAR in the flag
> > param, it will return -EFTYPE. EFTYPE is already used in BSD systems
> > like FreeBSD, macOS.
>
> I think this needs more clarification as to what "regular" means,
> since S_IFREG may not be sufficient.  The UAPI group page says:
>
> Use-Case: this would be very useful to write secure programs that want
> to avoid being tricked into opening device nodes with special
> semantics while thinking they operate on regular files. This is
> particularly relevant as many device nodes (or even FIFOs) come with
> blocking I/O (or even blocking open()!) by default, which is not
> expected from regular files backed by =E2=80=9Cfast=E2=80=9D disk I/O. Co=
nsider
> implementation of a naive web browser which is pointed to
> file://dev/zero, not expecting an endless amount of data to read.
>
> What about procfs?  What about sysfs?  What about /proc/self/fd/17
> where that fd is a memfd?  What about files backed by non-"fast" disk
> I/O like something on a flaky USB stick or a network mount or FUSE?
>
> Are we concerned about blocking open?  (open blocks as a matter of
> course.)  Are we concerned about open having strange side effects?
> Are we concerned about write having strange side effects?  Are we
> concerned about cases where opening the file as root results in
> elevated privilege beyond merely gaining the ability to write to that
> specific path on an ordinary filesystem?
>

Good questions. I had assumed regular file means S_IFREG when
implementing this as mentioned in the UAPI page:
"O_REGULAR (inspired by the existing O_DIRECTORY flag for open()),
which opens a file only if it is of type S_IFREG"
I think Christian Brauner (cc-d) can better answer your above questions.

Regards,
Dorjoy
