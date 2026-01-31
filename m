Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEE218FDBE
	for <linux-cifs@vger.kernel.org>; Sat, 31 Jan 2026 08:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769847489; cv=pass; b=RI2Z2LEumPsDhCmsU83ViDZ3MCK9kDLou1MZB1yskyw9JR+ixKlKWLUkcwE+w51uHc5lxaudJZPLUX5uqn8N9zvgaadYhPWww91tWCgkBy6PHiJm/yOs413AM5RuPbocRx6V8NwPTq2ckKdJYrFN8/ikjrFPD4u4iPblSPNq2PE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769847489; c=relaxed/simple;
	bh=60qsLSBNqHOopC5OMglkxnWLEQmgwca3rl0WV0mEDv8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SwaSPhnsvhW5tJF1Gxpp/BYgBba719pH+HKC5whsF/3TrFUVq0mrUqLzwJ0nT+8toOs/Y2YAzBSU3GWL3alz3L5Z8752c2RCnE9navlkBYfuGvM3okDivRMeI6aV7oZ0GLrQIt6vuEP1CjE0alRY7+APLOv1L/Ei2QU//b27fNY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G61dRXKa; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G61dRXKa"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6581327d6baso4233617a12.3
        for <linux-cifs@vger.kernel.org>; Sat, 31 Jan 2026 00:18:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769847486; cv=none;
        d=google.com; s=arc-20240605;
        b=krUHajSmZ2If4LnfqI796KqnAwESSglD/f7LI20QQTMYI6EXPpIBy/i2qZw7AIApnp
         mKtlNv6KIIvHM+7er3FImUrgOrLXasJibHM2ClTXh3TTYO+5dIbWezTf5gUen90/vmFx
         rEnw8Y2PK0G3LOaxJoBDyiO8pKv562+P0wDZ2xbWV2SGl4TH6fZ6tm9kCeYcMuhBVj6D
         CtFQIsbDRszr0RYEWCNuh7nR/U+Lieou58ZAsIm9YovkQVbvuMyp0emDm6BlYnz8aImB
         Fgl/uOkBfFkV5T8sWJRxFiqP7PdOsqJ87LvWhD/r9lPotD5XdrfzJsWv6co7Xhu8nsaq
         9xLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q30alRj8Wb8qXQ+y61l3KWAv3g1oNMl2F7PgQ4Yu32Y=;
        fh=YBQheK3XoJGMsVMdt2HGbcgjBCe27OI+56RpW50u9Wc=;
        b=QYmptAkNA7h+BWCZ1FKpC67B27hjrpwkTIv487Y8IAnlchezBkohZE2pw5dxMkBJVp
         bLrPsYuX5/K2XSMkAyi1davcHJjJuIqpUi4StKD1u/OWkI9BUuXUVO4dpIHkZN0jPlSO
         RRwGVxioJ+lt+KF51nAtnpijPV/GFo1kxbsN8AVz8A0H3Mrburx34VM20hb0Pf74BxcM
         0BTEGiQzTfeS4JlTJLDARBhADyAepS01D5Y+U6m07iPWm8qDu7c6ShModKHKtkIU8CaH
         gBi79D12GiHzrJHQqKPSIh/g3MAuWJuZdAD0GyqRT8KwUiZxbK3eHSUPYPNKjXXaijhS
         ehFA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769847486; x=1770452286; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q30alRj8Wb8qXQ+y61l3KWAv3g1oNMl2F7PgQ4Yu32Y=;
        b=G61dRXKa3YPymYkGpEGjm7ZG4WRLrqytXHKbj1iBDnwt47kJtGkcQ88V6wfNOLNJjQ
         vYItMQf34ydkx4HTcKhF2StvCxFgBcK5CUZjfuzd5ZMqXdXb5d1OQNtwlhY1u8ECgVWw
         PjVsgSEp+NsUkanp2QD6DlSDM/14GbvBbUn4YC3+95FZsVQlfvOgCX7BOnfLrz8J0nt2
         txOQIkjuHsi/CYdHSmM6uB/Bs9QetmE1lcTF6fd9dxFdBvrQXxbSfLE3ZirAGaZ8ZInT
         EnoS6J7tEIvpL65ChMa+PoFOzjHZeVDave4g0GXQq2By2Q+Ss+yQkyKPn5yJ31sHXB9F
         JvAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769847486; x=1770452286;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q30alRj8Wb8qXQ+y61l3KWAv3g1oNMl2F7PgQ4Yu32Y=;
        b=QmI5PsiGv6+nnSWpfb34AR+IovNxqs1IiJEtrXWtGqDV35AR1+RLM5SPoEn6rTi38J
         lU7wZvvJZGvGnZEZGH50i9XQnRC8ske0050wDCmye8UrhnYvHaYaMipPSw/JLaKNI4fW
         J5nPJtrGXhbNBOFSz+BgeqvyYJ6dhATspxNeWhFqKzHrdToKPlXO9T+kbfpZlCw1HL3R
         cxnITax7KTQ6n2Q3JkWQ2qYZx+NFHkzG5Z6EueO2sEFDChULV4wyuBmdSGT6sabUqPdi
         DqrMsRjG1dY5FbnkaNB9/fAt79tluHW5YhA1TcJt26Od/aTYL7DbLhe/8NiDdomTJ3Aa
         HCnw==
X-Gm-Message-State: AOJu0YzxzqrWnXL0VlDYxYmTKYbb3ZPCdXwE/uq8dilDFzaoG4Z6ACOe
	bNC02k3TaK+ojELEVknJXq0aWexlO+hfjBxytUhfL+VaixLUhywAIqBIl2Jd+Q8Q3CXF6qZv2k1
	xMwlAIxUlolMleAwtzSIJ4hbEbct0WXJSjrUlHQY=
X-Gm-Gg: AZuq6aL9XOEAfrNUYWIFmSJuyMb2wQX9jOBxm014teQU4Kh+DyADxgS02W+dvRrtlwu
	DdzHMqETldoIiVY2QuexD1l6Csa02fkvduEFYo4v8RkcoVgsKAC+bfazNLAJMszH+iBrjqkjgKH
	iIEezkJ/dMAaj9R2jif/FUvV+0Dpv7s8wGxC+usRGjjK5SuRsB7KF7Uee6yySZYVFQVT7TqeZ3S
	hq0m4mj/X6JiIoVMkUcXxQs28wCxJ5mOAmVt8TqWQqCw6ZcMzyQcEpV4LOYB3z8h2fez24s9DWo
	2Qt0
X-Received: by 2002:a17:907:d644:b0:b83:95ca:23e7 with SMTP id
 a640c23a62f3a-b8dff56f484mr300443366b.4.1769847486310; Sat, 31 Jan 2026
 00:18:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129173725.887651-1-sprasad@microsoft.com>
 <20260129173725.887651-4-sprasad@microsoft.com> <2263956.1769780212@warthog.procyon.org.uk>
In-Reply-To: <2263956.1769780212@warthog.procyon.org.uk>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Sat, 31 Jan 2026 13:47:54 +0530
X-Gm-Features: AZwV_Qi6WWCLEpZ4y7hPAgndKU5UUwX1Nga2np48VplqWRbOm8FyUalkD5q3huM
Message-ID: <CANT5p=oL+tP5_SFNRabROCqDMjriXj5osnyyAjrMeq6BiJcr1Q@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] cifs: make retry logic in read/write path
 consistent with other paths
To: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.org, 
	bharathsm@microsoft.com, netfs@lists.linux.dev, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 30, 2026 at 7:06=E2=80=AFPM David Howells <dhowells@redhat.com>=
 wrote:
>
> nspmangalore@gmail.com wrote:
>
> > +     unsigned int                    retries;        /* number of retr=
ies so far */
>
> Is this redundant with netfs_io_subrequest::retry_count?  (This can be ch=
anged
> from u8 to unsigned int if it helps).  I suspect that there might be a fi=
ght
> over who gets to increment it, though.

This is mainly used to track the number of retransmissions from the
client (retrans mount option) when soft mounts are used.
I don't mind netfs doing it's own tracking (the purpose maybe
different from what is there here). I don't see a major issue if
they're not in sync with each other too.
So I'm okay with that.

>
> > +                             if (is_replayable_error(rc)) {
> > +                                     trace_netfs_sreq(&rdata->subreq, =
netfs_sreq_trace_io_req_submitted);
> > +                                     __set_bit(NETFS_SREQ_NEED_RETRY, =
&rdata->subreq.flags);
>
> You didn't see MID_RESPONSE_SUBMITTED, so I would pick a different trace =
value
> there.

That's a typo. Thanks for reviewing. Will fix it.

>
> David
>


--=20
Regards,
Shyam
