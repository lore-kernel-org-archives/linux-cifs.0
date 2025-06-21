Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849A44207A;
	Sat, 21 Jun 2025 16:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750522372; cv=none; b=rWQ5kNiVsGSH6OHKLmbkv2MJAsC12btlpACpqeelNykTV1A6Ag+CDmxwXKBnhNSwm9KeqGfoViIUadqa3KII50WDB9vLP+A1b+HsCGPPFPcwy/oi7TOVGKG3uMlVMqBG0yN86k0ZzVGXZhC8WCELwqKqBCd+FRKYCjoWBGXlyN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750522372; c=relaxed/simple;
	bh=et9I9ifOPuwpU41OwkZfxg1DCMOULNgR8O8WPkv8rIk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YZ+VXUVcvHLi7NCYTlM9platGKIXDipGO2iQarGYaTo+AtPBcLAkYpZPAWOL0My4mRcqs9+08O1yx39WVXot8n5yY5YKLiPraGFgvfzkAL2WoMzSMQ5Eu6yJXwLoiGNeF5Fad3mgXj8Kl+91fuDQNG8f46NItbDjJpwCPoNP1Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RMpOw5Uh; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RMpOw5Uh"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6facf4d8ea8so26612446d6.0;
        Sat, 21 Jun 2025 09:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750522369; x=1751127169; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v7lJIkTpAeIJBC4wgwd2GeVEiknXnQ5RBS9xvuul6gE=;
        b=RMpOw5Uh/jTUJss2gP9Iva2Jr6dhf+NPG5S6fe3/ItO9/mhAQ9ncrseGA5pJ9Oc0Vq
         fkJUluzvSUvNbf4d82xZ8QBUgONpT6M8IqATtUlRohAoStmjMOV5r+KjA/Xq9pdoSZKp
         TbQ2eQ8MJAOefB4Usf85BJyoIPjMXaY9kSgxXc2zXa6SNfzx6un9r/2r1QMFo+1fKc22
         AO0b5zx2pRrjJImeDaBHEohsKBEnGgwLDaxKEajsmST39BKUXL0tPq6MuKSsbJk29Idw
         q/Oz0X48y4dLOvQ1VOrG7Beav5lMsb0z+tUkDFS7JJ7pLJXZGCNx4uU09/We+sU5FIe8
         AZ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750522369; x=1751127169;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v7lJIkTpAeIJBC4wgwd2GeVEiknXnQ5RBS9xvuul6gE=;
        b=sBHRXtKooLU4s4dNOtO59Aoiwf3MtTVhUJXXM8xDJZDiSsq6kNOzE1qhuO85xjHUfp
         r3tdQqmoFgdtkZ/35i3qMQMdCJEe0HzukBaDJUUB1gMRMppjLkY9gWPUWGNAeozLj2fs
         5dW59OrbFyoGj9d/dJveqg/yeuYoj2VdIp5vMcbzOVij9SGGVQYR3VI2rVePyLDWljdy
         ntQpdwWVXp4QggeGa8ovo1EX8pyU22WOhfRtDcHeBMUhDcJjIW82RmoPTduGeqaPaT6N
         sO5C6OK4sZwjBWfbGU/iDjtkkCEFS8PUcft/z+8tv6SqpJIEWlZEXnkEEooICBRdqvpg
         xqjA==
X-Forwarded-Encrypted: i=1; AJvYcCXIrArUYXomkmG7f/9Kp/bdrpQjo4ZO3GA1kUSzuERzJd8H0KKN8ft0Qw5kvrHA3m9UYLRUxQGPJpHq@vger.kernel.org
X-Gm-Message-State: AOJu0YwMBQ7aYUENB9lDIw6J2BkwHEpPoFyZzt6JsEarOZnlGb0F4vv0
	efebv7xL2dUCOQzH+G7LEJWM+nfVkr6BmheTdl5E3SLWDHnACnVIaYd1NW631TpEG497w6Pmqe+
	lE4UmShm5j59GluOOXrNM6JXG/3L1cJQV/g==
X-Gm-Gg: ASbGncv0x4f/NCfzqO6u9MucuSTZzeW6r8VKE4Z+RgDFSs0a/XAdA3GzHx/kiYWdtyq
	OHUdt62Pp+7ixV4yDLnyi5ZGnYUlCjenDgiGG8CkM8fVfpIzdmsdSQTXq+k8kyrueLGkIbYW9T9
	utn1Fb0FYf08SRc74bgxUDJaeQMJQqlOAsDBWmJFvVQekTiXgjtjhSJ3qQjidJYEW0GIaUNj5aV
	2dnuQ==
X-Google-Smtp-Source: AGHT+IFUh10sg8BQ5law1MhjkuXcUniLBMptmZfXLVSP3EzxHgch6Gt6RyF2eFun+9NIY93yLtTzgmE5Yxu1GzzS3u0=
X-Received: by 2002:a05:6214:268b:b0:6e8:f3af:ed59 with SMTP id
 6a1803df08f44-6fd0a531998mr131365056d6.22.1750522369173; Sat, 21 Jun 2025
 09:12:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtz1-JLM8PEZngKOd4bwESBLU+bw8T=ap5aMmJ6LOaNiA@mail.gmail.com>
 <CAHk-=wjZXRvTnAwO-EcheuHkjOmq2YMua9YC3sbaXYBQ+FC8og@mail.gmail.com>
 <CAH2r5msQwv4LuaF=kmmy_n=z5paCyat2vTZowOB46WeJxpwhiQ@mail.gmail.com> <CAHk-=wgReqMNHT8Y8W0jdbnhZBqsY3Omga8wYQJ-yVRumzSDwA@mail.gmail.com>
In-Reply-To: <CAHk-=wgReqMNHT8Y8W0jdbnhZBqsY3Omga8wYQJ-yVRumzSDwA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 21 Jun 2025 11:12:37 -0500
X-Gm-Features: Ac12FXz7esTmV0vwcg1ZGStquq--W0KHVGipkDlbNzXLJO2-EkA1XHzX7W4u_xo
Message-ID: <CAH2r5mtFMbQ_RPghL+=J67o9ABYe3xnsS3tTRkymK7r13Y3Hbw@mail.gmail.com>
Subject: Re: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Understood, have resent the P/R without it, and will try to be more
careful about this kind of thing in the future.

On Sat, Jun 21, 2025 at 11:09=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sat, 21 Jun 2025 at 09:00, Steve French <smfrench@gmail.com> wrote:
> >
> > I can remove that and resend, handling special files properly can be
> > important (and there is a much more important patch being reviewed for
> > fixing some symlink corner cases) but SMB1 is much lower priority.
>
> So honestly, if you had explained it as such, I would have taken a
> look and gone "Ok, I don't care, this area hasn't been a problem".
>
> But instead, it was sold as fixes, and I went "that looks odd". So I
> had to go explore, and decided that it looked decidedly like new
> development.
>
> End result: now there is no way in hell that I'm pulling that thing.
>
> Trying to sneak things in is not ok. Claiming things are "fixes" when
> they aren't, and me having to figure that out just makes me unhappy.
>
> Just be honest about these things.
>
> Sure, I don't always check, because smb hasn't been a problem, and
> maybe you've done this hundreds of times before.
>
> But that's also exactly the problem: now I feel like I can't trust
> your explanations because they seem to be whitewashing what is
> actually going on.
>
> So instead of a "let it go", it's now a "I guess I will have to waste
> time on these things because I feel like I have to double-check what
> Steve sends me".
>
> Which is what neither of us wants, but here we are.
>
>             Linus



--=20
Thanks,

Steve
