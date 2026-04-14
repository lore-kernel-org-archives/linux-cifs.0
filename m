Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD372DEA9D
	for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 03:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776137223; cv=none; b=Xfck4q2xUvXuJi8fEjHQW1Nr8qZrfumFGzHq74cckBi88/0WAA66o/uZ8dTcwxyugI4JsYugNhGHKGNDHvPow9vLcJ/bjl3x6+YUCKD1Ve5tSGQNaNANbVaJXPgWse6Bh7fbp4qf+1V+mzH7nunD1vJmbtufPeJLB7hY11kDy/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776137223; c=relaxed/simple;
	bh=NYchmGnargi2Dt/lXMc/0D82NPIuePa0sR8ViAV9OqE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GLLwXf4eJ88KHSjCDWR7+0NqYwN2hAlTIms/QvWEnNE6sju4VbD+IlTWAq7n9TwzDLC6kLfH0etYD2OwfL+95eMKbo/If21pDXBSti//ellClyyzQ8t1MJxQtqbD2spSOZ2koWr0XJU6RHSLytY2OItQbQDJFAYCyHBD5Y8tlew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GfMB+g5h; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GfMB+g5h"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6718f315fcfso2765127a12.2
        for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 20:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1776137220; x=1776742020; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=D/JseTjBiF//UlXwnA/kgPNbntmplqHjNzKt3bJLvGs=;
        b=GfMB+g5hAAnALArHz/lk5WEKMbklhIs6SZ39q0rGwJ/ed3pV4claWmsz6MfzvSVTMC
         SKjuPJuwu8M69L3tAsiXlfjPL7ujACKfAZFu059Rycj4blivo9OBZlEWwfKeJiAQU9Wo
         7VW9cw7FwQael1aJRo4BWXzpWIQnp987Xa3yU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776137220; x=1776742020;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D/JseTjBiF//UlXwnA/kgPNbntmplqHjNzKt3bJLvGs=;
        b=hLXEKgp5hqMvjEKbAjBO+QrTkgYlTo/mZQ73p6RfND1+w4MXyMeXkYgKXIX/RqvDAY
         0iXzhzXqlAzjt8KeT/pJVkoI/hRAPsHYtwVRw/MhufdrokxnxZXpZta+0vJ1pU6XnnXW
         rIX7HqRzFcgSViKQvUBgWadBVn0QS7VW6nAII5OGpbS4rcK8MVm57OHva7fn48ACHhjD
         8u8E2luxrDY0uBtpHC7jFUTDYoLeKZ6o9ce55kLh2p7Nfg7fFzuUAJQMcIQfL2i6v9n1
         J71MD1lDX0tXqApYQ7MvobO9EtWAoAxBnad7rbT7vF7HF5TbVfpuQdgKiG5nnklaa3ee
         ssIg==
X-Forwarded-Encrypted: i=1; AFNElJ9IiI/+SxstQTbhgcrrTFE+0JBUx3HIA7/Lm5liahyeZc6l3Ol/B2N/xwDyRkQCCkLCRmeCGH5becaG@vger.kernel.org
X-Gm-Message-State: AOJu0YwgQty98jBTSQgmVGMqnZctUhx2qKeGI0jDx2AWzog55Tpz9Ski
	M330p7hK5HZ3shqVMY9XJgi0xsqvtndCaCK56cqD5kJUwXk9s5Y77uSQID+qmABB0bk4M+cHptL
	uTSEaLpA=
X-Gm-Gg: AeBDies+f1jIc7w/fT/g884eCDDZpJI+n44owxbonLQZj8/q9fbKyUPteWuebBKxYzN
	sYVo/LLHHg5iM8ErfnFoSPfVqu2+TCBkO1mPQjfijOB8w0I5b3BiKvA3GYODA3qzPw2//f6QUJ4
	6RSVkhlGX52MG3FMaIAmEzSVFywLcA13HDk7aS4iAFgfcY97vDUmHbxMCFeXETh3/FOACSTEsTw
	xWBcQwvjz1mPMeXNo7gTanlBdpCL3Agq67mSQSBUn/IuZofxzcHrv8Vv9BrSDDkq8rEYfkcyI7a
	nYyJ6yAmHUVPVeGrnHXGd0Tj3XH4s4bpfMf8cBlFFA6xD3CCoJDervQ8+PddgSeTe6WQO4LGprT
	/tfesD2eHmTmL+rF0qoX/K6hx3UHFnejzOMoTd0uwZDHTqiMjbT4gWGoK1RLnMdNB3l4kG9aM+j
	9kln6qaM7BBFFTyhSacF/2YH+GMqg7JaykABh9uRo6rf62nUDIWdXMbv8mg5vcRdds5enkBwNV
X-Received: by 2002:a17:907:3f87:b0:b9d:df73:f0b8 with SMTP id a640c23a62f3a-b9ddf7429e8mr360182566b.32.1776137219833;
        Mon, 13 Apr 2026 20:26:59 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9d6e7c7c81sm358168966b.43.2026.04.13.20.26.59
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2026 20:26:59 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6718f315fcfso2765116a12.2
        for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 20:26:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9EiARFGCapa+tvSggxTl+YMd1WQiALfuUM4y5/6JBpA02/RKUZ9TatbvWJTWJ/El6FpBkxA02joq2V@vger.kernel.org
X-Received: by 2002:a05:6402:21c7:b0:66f:b3cb:502b with SMTP id
 4fb4d7f45d1cf-6707a4814a8mr6268487a12.23.1776137218723; Mon, 13 Apr 2026
 20:26:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5muW_D8eDN0iN7kzFV0km+QBVZn087+AGHTeSHm0E-KqYw@mail.gmail.com>
 <CAHk-=wgerpUKCDhdzKH0FEdLyfhj3doc9t+kO9Yb6rSsTp7hdQ@mail.gmail.com> <ab9457074b5852e73e84f0209bb58279@manguebit.org>
In-Reply-To: <ab9457074b5852e73e84f0209bb58279@manguebit.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 13 Apr 2026 20:26:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjTfaTPf+Vp=XGmW1z9YPZcx8dhPjaGfhfYett9=-jHMA@mail.gmail.com>
X-Gm-Features: AQROBzDN67bVY9YzeEJGRKO3BslazVsHAYMIevna9IzzE-VaAsWPTm3x4oh23lI
Message-ID: <CAHk-=wjTfaTPf+Vp=XGmW1z9YPZcx8dhPjaGfhfYett9=-jHMA@mail.gmail.com>
Subject: Re: [GIT PULL] smb3 client fixes
To: Paulo Alcantara <pc@manguebit.org>
Cc: Steve French <smfrench@gmail.com>, LKML <linux-kernel@vger.kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 13 Apr 2026 at 20:13, Paulo Alcantara <pc@manguebit.org> wrote:
>
> Do the below changes look any better?

Let me suggest:

> -void d_mark_tmpfile_name(struct file *file, const struct qstr *name)
> +int d_mark_tmpfile_name(struct file *file, const struct qstr *name)
>  {
>         struct dentry *dentry = file->f_path.dentry;
>         char *dname = dentry->d_shortname.string;
>
> -       BUG_ON(dname_external(dentry));
> -       BUG_ON(d_really_is_positive(dentry));
> -       BUG_ON(!d_unlinked(dentry));
> -       BUG_ON(name->len > DNAME_INLINE_LEN - 1);
> +       if (WARN_ON_ONCE(dname_external(dentry)))
> +               return -EINVAL;
> +       if (WARN_ON_ONCE(d_really_is_positive(dentry)))
> +               return -EINVAL;
> +       if (WARN_ON_ONCE(!d_unlinked(dentry)))
> +               return -EINVAL;
> +       if (WARN_ON_ONCE(name->len > DNAME_INLINE_LEN - 1))
> +               return -ENAMETOOLONG;

Let's just return errors from this, and put the WARN_ON() in the caller.

It's not like the WARN_ON() is ever going to trigger anyway, unless
there's somethingwrong in the caller, so let's not make this helper
infrastructure any uglier than it needs to be. Adding the warnings
there only makes it less obvious.

You want the warnings to be where the *problem* is. Not in the helper
that did everything right, but was passed the wrong values.

See what I'm saying?

Also, this is a bit of a mixed bag:

> -               scnprintf(name, size,
> -                         CIFS_TMPNAME_PREFIX "%0*x",
> -                         CIFS_TMPNAME_COUNTER_LEN,
> -                         atomic_inc_return(&cifs_tmpcounter));
> +               /* Append tmpfile name to @path */
> +               namelen = scnprintf(name, namesize, ".__smbfile_tmp%0*x",
> +                                   (int)sizeof(cifs_tmpcounter) * 2,
> +                                   atomic_inc_return(&cifs_tmpcounter));

the 'namelen = ' part is better because it makes it much more obvious
where the numbers come from,. but I certainly didn't mind having a
CIFS_TMPNAME_PREFIX define to help abstract things out a bit.

What I minded was seeing *three* different #defines where one was a
magic nmumber that was very tighly tied to the others, but they didn't
help make that obvious.

So it's not that I minded the CIFS_TMPNAME_PREFIX thing,

I minded ther *magic* of it all that made it so obvious that somebody
knew a-priori what they were going to get, and then made the code
match the result they wanted, but without making the code show how
they got there.

That whole "namelen = scnprintf()" is a really cheap way to show "this
is how I got the name length" - because that's what the function
returns anyway.

And the other place you had that scnprintf() you still had that "I
know what the end result is, so I'm just hardcoding it as a random
value".

                            Linus
