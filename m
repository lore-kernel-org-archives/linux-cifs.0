Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90661473C6B
	for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 13:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787233431; cv=none; b=EZNadHLGJKUQvATEfI3jl4G1jeMztNAbWjNT0dXydyYxA+1YTi1KTUnAcVtpHvbqxu4sUmxUOfGw8VpKRSZJoa0ri/uiKoyjsxryhvoSgbkdJGg9YhOdbsoqrsDIYnmaK3kVY9LSXyiSakObMSB+MGi1/G7JsJYNpRt3/rQ7dBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787233431; c=relaxed/simple;
	bh=9YGDV1km55xsLTmCaqaG7kKHgcDsdFGtt/WuGbawNJQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rEYIob7UUoEurrHm4wLjU2SE+ApRpfXCFQSxpPUXbDgGRMjuXiUtgbx+NiSJCeaESK2WroNZBCiSAuZZ1yjHaWPo7D6/ncfy8B+Fhm8XVbIbrvUfMfxqnxydNTH1c1CtCxF0116HSaEi4cURETnRsE/nTNWCsdQkKjkx6Kz5Pxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GdqylAwQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GdqylAwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669A91F000E9
	for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 13:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787233420;
	bh=QcAlBMrWUL8Az/yt6404lceRdblmJRG4P5UWM5IGnI8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GdqylAwQ+iNvIxUGQX/0mOPOEq/K26mOoMpGNV33e4VsfR1NX5ojsVz23LZ7eR2Eu
	 bFDU7uIyuPlOdIjZvF7V/X/o5rIGQOtlDVk29I4nygviW+c7ac8PXuwvz85ScBRpqX
	 4vp+BNrBxL85yQyBBoQhLnZ8YU3vAoU6mzRcmsMJQTDF/tMQUE57zuIKVfp239QbO5
	 xeQxYKO3BsOEu1gum5iPffDA71g78rSQ21NkD7hVmM49PSuIDMGObnBJ1IQ48MN/wS
	 2kT0xrB/CN3KY0NynQNYeO47QE87+N+hW9xGOBkb7M98PRSSRnTRmtPp1IFKzNbCoc
	 tYfAa53Ar9PCg==
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-81ee6b2da98so34488147b3.3
        for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 06:43:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr+XQyGnbKpz3XIurqVXKoPYlzM7HpEIDjOnO7TqJ99LzpMlAh7pDkNT1ogdVDn7o/aFCCBv5gX2K0T@vger.kernel.org
X-Gm-Message-State: AFuF++kf0O7b6U/998aog3md+aD89KjgRCdbm5b9bd975hBrh9HBKwMo
	B+Jd+umX/Qhtkp8/MRRCG+k5RqANAa4my5C+0skYltzPqz4wrApSQORZS76Pp6ELMYcUPMOOnx9
	ul6/mhDRFLZN2AqWtodOb7a0S89fN7sc=
X-Received: by 2002:a05:690c:83:b0:846:1ade:a8 with SMTP id
 00721157ae682-8461ade26ccmr32605237b3.7.1787233419760; Thu, 20 Aug 2026
 06:43:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260817134521.5505-1-linkinjeon@kernel.org> <ce39a657-a941-4f57-be46-8208d7ec0e80@chenxiaosong.com>
In-Reply-To: <ce39a657-a941-4f57-be46-8208d7ec0e80@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 20 Aug 2026 22:43:25 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9xZ5N6E1Z7v8TA4mLvT+T6vE36C9q0PFYvDP0UxYhAJw@mail.gmail.com>
X-Gm-Features: AcwNN1XhC88vriO6ZxU6MUMUqcilPnpjfGQ7nVF-SN8CouLLwZ3911yos1DcE_U
Message-ID: <CAKYAXd9xZ5N6E1Z7v8TA4mLvT+T6vE36C9q0PFYvDP0UxYhAJw@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: update ksmbd repository URL
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, Tom Talpey <tom@talpey.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 20, 2026 at 9:08=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> It seems that repository URL on ksmbd-for-next branch has not been
> updated yet:
> https://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/smb.git/tree/M=
AINTAINERS?h=3Dksmbd-for-next#n14134
Thank you for letting me know. I just pushed it:)

>
> On 8/17/2026 9:45 PM, Namjae Jeon wrote:
> > Update the ksmbd repository URL to the kernel.org
> > ksmbd-for-next branch.
> >
> > Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> > ---
> >   MAINTAINERS | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 8014b9f8253e..438e3a714c4c 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -14140,7 +14140,7 @@ R:    Sergey Senozhatsky <senozhatsky@chromium.=
org>
> >   R:  Tom Talpey <tom@talpey.com>
> >   L:  linux-cifs@vger.kernel.org
> >   S:  Maintained
> > -T:   git https://git.samba.org/ksmbd.git ksmbd-for-next
> > +T:   git git://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/smb.=
git ksmbd-for-next
> >   F:  Documentation/filesystems/smb/ksmbd.rst
> >   F:  fs/smb/common/
> >   F:  fs/smb/server/
>
> --
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Chinese Homepage: https://chenxiaosong.com
> English Homepage: https://chenxiaosong.com/en
>
