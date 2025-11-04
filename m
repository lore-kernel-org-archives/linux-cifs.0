Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D34286D4E
	for <linux-cifs@vger.kernel.org>; Tue,  4 Nov 2025 09:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762249550; cv=none; b=lswRhvtgY/9wxoEhH2QmA+3kJrtGs4jSUvgLzHxsL2LRQUVJKvadvWYCx5zGsZrOamTrLk5BOSXPQOE1PWJ523hMW/JryZ9+BmzBes+c5QQwyRgRpl7kS31clGIRvp+dDZgHpC3kQsPx4OwZGUSYa7j/TQUbXCQXnjnoGN4Sn7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762249550; c=relaxed/simple;
	bh=Y/8kkJtUlvT/f8ywlYeX1B4ZoD/ySaLtnH0dGnqnmAA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PZh9F6F7V4iDtoAcTmjbIJySQH6JxZFXWIV0a0fYRvVepnKCa8/JEza30RbEq4zj0OLsXRnMFof/3uKa4gyp0hV5xFi7p3K1CjpVjmE6V/6F35TxLo+hPPPx8ojkMuNcqXial39kBEjGZyD9npYl+SasEiHJfC5jQQdTyLslkFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rf3pNu0C; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rf3pNu0C"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-64080ccf749so6854866a12.2
        for <linux-cifs@vger.kernel.org>; Tue, 04 Nov 2025 01:45:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762249547; x=1762854347; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xKJdWvkPbuojvyFkWrgOJDggLZVTca+r/oAisy+M4uA=;
        b=Rf3pNu0Cg1d48tOeaZtZaLUkE/PEszLIZCf1p0J0eQREPNueGK+mEQ6TOQwKX0fevP
         DG7Bf49VqBKXjMXfX+cxHFvoOdj0HEyx787WuG/kGgy0ZKASykSskdCNsJbQakDLDfmB
         t87jC0FfJaGK2EkHbJ2skXAhafGEtVnaWmFwNihX/9k+M/WkZkLc1S7n6MArxGDLViHA
         mxPiF89Dk7LQiqHnGfCi3TdkBqKIDuUcIWubluYRrUL9svX3Pgcse/je3swjxwnN1W1E
         gUlOLs/2RRZquqbAd/Rto2820kkWJatdFt7IFS0sjW6lP07/tMpw3G0PdkY6g5ulk8uB
         zzkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762249547; x=1762854347;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xKJdWvkPbuojvyFkWrgOJDggLZVTca+r/oAisy+M4uA=;
        b=OchfmqE9/0zQEleL7jVnjAsQ3jMQYr5sJoKG9rP0EF2sxFcxCAl6mpsilVdkNdFgFX
         2pJY/7kkBgrRlWSp716dcOZvgMd8lGCk+7tvGA+UtYqx3vPGBO37BJU5b+oV7AHAHV1g
         JVBVAlAfEGIYI0EneXpNJg2igxBMILr5OJjL/TjjNRXGAytIQnl8petgEy/2N/+PBrPp
         s674Z+HVPR/vhEQvoRjj/Cgu5owZFD6mnhaPmyeL3X3/ne0hiWD7+0VxBWXue8iUcOFm
         hbcnXkw0+sQ8ELuzR7Be2w2nLtPcy+ImAwmEIXqNYbsOsVsof13eC2Dfut0IOH2R4Ybr
         7L9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVj49rK1/fDAEYXos/wCVL5s0ihWPfaU3RFemDHfT5/nY00Nf0wEkO2EUOAcfwzlz4r2NDi2VwL6mqz@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4Re02HY0RYHuJgx7gmuaM2X03RDTmm0jaPhE6lK4I+kLc5rYL
	XqIlQN/yy+Gv5XllRMNmGMBXyX9hVyYJtUtWb9wdmhNXFildQEP3ynM1K0UgZ49cxOqlSbkmDhn
	m4VWIxsTYIwjL+ncqLZqzI5EutSJ0PBU=
X-Gm-Gg: ASbGncu9CNTtjU4nGPFSzBkwzy6yJ9MAdT8zjaRsDPft1oOtwA7YeAtRHDhgl68vw9x
	TrDqkAroAxsVJ131KdRVEtMRcXYkIxFF2Q4lCNaqdGCuv0elQ2szYQW0pf6zE8cRVDSVvK27Jmg
	BdVnq7tCGiE1/Wt5Bs4FgC9n3OSYsD/7xiM/IY5PSw6ajHEfdvq/0qDQHS0VW1JoK6NNmUF2+Sv
	XZBcHXGQPlUuipaVRpqn/8H5jp8HcalK5Lf3qAn9vbvKptL12dDE+w3BcvefPh3mWzIQ4CjmY2E
	iF+F/Zy2Wm4L8wf0jjc=
X-Google-Smtp-Source: AGHT+IHXA2qJBi6f10DqUtNaDt/G9hT+Ey8B/WnoFdz3Hmrh6KCUpLdIDtROPfgXbvSfxz+h0BRwI+TkCKOqKrtbbyk=
X-Received: by 2002:a05:6402:1462:b0:640:ea21:8bfd with SMTP id
 4fb4d7f45d1cf-640ea219598mr1427481a12.31.1762249547237; Tue, 04 Nov 2025
 01:45:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251103-work-creds-guards-simple-v1-0-a3e156839e7f@kernel.org>
 <20251103-work-creds-guards-simple-v1-14-a3e156839e7f@kernel.org> <CAHk-=wiSmez2LFEpM05VUX=_GKJC8Ag68TJDByVPO=x4QwjyuA@mail.gmail.com>
In-Reply-To: <CAHk-=wiSmez2LFEpM05VUX=_GKJC8Ag68TJDByVPO=x4QwjyuA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 4 Nov 2025 10:45:36 +0100
X-Gm-Features: AWmQ_bn9rw0ha0qFFSykU1xP6jfkkEMSMAVkMSHJG30ZX97XNHwd3yxbJVnihQI
Message-ID: <CAOQ4uxhw2Tc4YXwhkS=5EVC3Tg4F+QyrA7LE3V29pNhQ4WJeyA@mail.gmail.com>
Subject: Re: [PATCH 14/16] act: use credential guards in acct_write_process()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-aio@kvack.org, 
	linux-unionfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, cgroups@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 4, 2025 at 12:04=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, 3 Nov 2025 at 20:27, Christian Brauner <brauner@kernel.org> wrote=
:
> >
> >         /* Perform file operations on behalf of whoever enabled account=
ing */
> > -       cred =3D override_creds(file->f_cred);
> > -
> > +       with_creds(file->f_cred);
>
> I'd almost prefer if we *only* did "scoped_with_creds()" and didn't
> have this version at all.
>
> Most of the cases want that anyway, and the couple of plain
> "with_creds()" cases look like they would only be cleaned up by making
> the cred scoping more explicit.
>
> What do you think?

I had a similar reaction but for another reason.

The 'with' lingo reminds me of python with statement (e.g.
with open_file('example.txt', 'w') as file:), which implies a scope.
So in my head I am reading "with_creds" as with_creds_do.

Add to that the dubious practice (IMO) of scoped statements
without an explicit {} scope and this can become a source of
human brainos, but maybe the only problematic brain is mine..

Thanks,
Amir.
