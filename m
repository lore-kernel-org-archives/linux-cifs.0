Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B2719DFA2
	for <linux-cifs@vger.kernel.org>; Fri,  3 Oct 2025 21:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759525916; cv=none; b=dvxrvcAPYl1dO6tvdppu2Wd1ZP7jiyF6mxU6/Wl5NJVBMmdoi1yEot9sv5Qs1b+RVsY1lFP2y6sS15Z6WaJndUZBVx1Mc/hiRez3dicS3HidNfBE9Ewcqps9fc5WWDX5CkNVAFVrbTweKgV2iBrO28Q4A2ZxXjoQcRLslcCptMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759525916; c=relaxed/simple;
	bh=ZarWfiHXGHHB+8+MSp0i9XDvXuhv0vsLNGhp2CdvMMU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FQriZ7qffwwbApCmGjGeX1BPQxTv6wX5+6tH0yhAbc1FiF0FKST66oozS6C+YHaaKmNincyse74efSpgOF+wZr46pE6oiTIyiSz5rDyqxofcneR7o3kOiUE5+h7nFhoQSf+UdR3Os2Un2T3OC1Wd6BkHBbvFuiX76xs3V95xPaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CKtHKuj/; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CKtHKuj/"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b55197907d1so1836871a12.0
        for <linux-cifs@vger.kernel.org>; Fri, 03 Oct 2025 14:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759525914; x=1760130714; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=idBH2LpwUFgIevwHzdiFY2NPh0U8IEm5opIuykd/Lyg=;
        b=CKtHKuj/srV5fMgPA/8UKXuZ+AH0o9p4JSfYK6byxC8/tN+tJjWv2sbSwcZC4afpaq
         8NsNQPEy6wd9NJHd5DY3UWlGkw1QPY2FRSZ9j2K9QzhZ/BmnTiKA0O5JCg/j55QM8lqL
         4tIcXPl1Yly/KcgS9D5g0RCFklKjijD2IDHrC/SPSkVv5OmM4FdkzSslmdqNBKRpUBwA
         RrL+BAYMi79h/b7++/24/CMfyTRJNhlOeXxaTJF3LK6zzQUqPcNAqC2db6/H0oGTvZDB
         WOPLnBlCcSJUagCFk+fUUIjTs97puhBjDskZ+bG6jEyyjc7GFthqzL5jfeyhIwI/YOhS
         Fdrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759525914; x=1760130714;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=idBH2LpwUFgIevwHzdiFY2NPh0U8IEm5opIuykd/Lyg=;
        b=HAPnGNRz1vY+h3iFyi0/RrEx5kYm2JMJ7k26hdz8l1JaXPj/hKouS7BPiFCb/UXRh9
         KwjaAbrUt9+i1T/tNDA87eI8cJt8lQX4TC5ri04ioxk5zxGheK68/JcM01jKjtK5Lc82
         9Gr3uHcZr+lZmw0e7suk+PmLdV8z1zaqwZcpvLrQYJs3WhGbKhqJF/mLquqYkRoZPoDB
         ECkbso4nnzvJJa5xrEGEfpquzxHCIfIK2u+Rq0xtt+kyxfKTS+P3ZHPr3IG/bhMJ2RnC
         D6p6l7WU+H8H3gyDlAg2MiNqcPAJOecBo00+Z8W3ID8aEGSjJF3PL437uuW9olYS0cce
         yTEw==
X-Forwarded-Encrypted: i=1; AJvYcCVeZOcrTkUg6aNMPrPG3PeoihivRKYGgB80MIES3j1QOzfyWimEjzE7cKY3rkzumPFw2B7b69OJnBp6@vger.kernel.org
X-Gm-Message-State: AOJu0YyrRrxHiEZQJa+kvbM1Ay9agIOUk0VJqlOMoR7aU/KgwMyq6pV3
	9iVWuAhPfJPzvtmhLn9I82i2mft7ucBXcNfFER8Dsi1q0r+iJNn9u00DyT0ciezIQ1Nz6H3wH0G
	mfPq5+BIiJYU2AxVY70uzEnWcZCWvh/E=
X-Gm-Gg: ASbGncuuZ8WQpo5Xxe4GTJiLPYi9xi7GQXkGbHVZTF9VtdH3Nwa2NmLuUWoN46rqNyu
	AUz1njYlsPFkO9kxykjBYMyzxR+qXzjPQQNCP0jecQVxSDjgf+uvkzlhtcbOXWqWHi2NDNXPo8q
	jbeIA2sPbBJZBq8BdY1VyBNTJ9jFA2Md+qcCoxVDCSG+iy9rjMEmHCtIJ6i7lMhSHM8p7oZyl8x
	EjadKO3x+2mUiUIXneKf1q2z4w9kH9mQSOvjQieG/Ub1YeyB/t7/zG+1LtQt1IP1KRYBV/dVP5R
	UJR6fNnrt6it4PVO
X-Google-Smtp-Source: AGHT+IESj68bldZNCi4hadzfEkfqbbyvi1Q2I7xucoG5vjfeN4926Z6GVHXgpJPrrPd5ZgEQ+C8FE3WQZyqrwWDH5rM=
X-Received: by 2002:a17:903:230a:b0:24c:965a:f94d with SMTP id
 d9443c01a7336-28e9a62016amr51310735ad.46.1759525914501; Fri, 03 Oct 2025
 14:11:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250925151140.57548-1-cel@kernel.org> <CAOQ4uxj-d87B+L+WgbFgmBQqdrYzrPStyfOKtVfcQ19bOEV6CQ@mail.gmail.com>
 <87tt0gqa8f.fsf@mailhost.krisman.be> <28ffeb31-beec-4c7a-ad41-696d0fd54afe@kernel.org>
 <87plb3ra1z.fsf@mailhost.krisman.be> <4a31ae5c-ddb2-40ae-ae8d-747479da69e3@kernel.org>
In-Reply-To: <4a31ae5c-ddb2-40ae-ae8d-747479da69e3@kernel.org>
From: ronnie sahlberg <ronniesahlberg@gmail.com>
Date: Sat, 4 Oct 2025 07:11:42 +1000
X-Gm-Features: AS18NWC1ODU0PD3hd2knk4ObBSOEE8H2Tv-wusAALRmCDLFFlJTzSTlYgqVa4x0
Message-ID: <CAN05THRXfkRMNiE36ksR5ULFC38Ru3PX7Tbv2w-m03=NEk+Hqw@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: Plumb case sensitivity bits into statx
To: Chuck Lever <cel@kernel.org>
Cc: Gabriel Krisman Bertazi <gabriel@krisman.be>, Amir Goldstein <amir73il@gmail.com>, 
	linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Volker Lendecke <Volker.Lendecke@sernet.de>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 4 Oct 2025 at 07:05, Chuck Lever <cel@kernel.org> wrote:
>
> On 10/3/25 4:43 PM, Gabriel Krisman Bertazi wrote:
> > Chuck Lever <cel@kernel.org> writes:
> >
> >> On 10/3/25 11:24 AM, Gabriel Krisman Bertazi wrote:
>
> >>> Does the protocol care about unicode version?  For userspace, it would
> >>> be very relevant to expose it, as well as other details such as
> >>> decomposition type.
> >>
> >> For the purposes of indicating case sensitivity and preservation, the
> >> NFS protocol does not currently care about unicode version.
> >>
> >> But this is a very flexible proposal right now. Please recommend what
> >> you'd like to see here. I hope I've given enough leeway that a unicode
> >> version could be provided for other API consumers.
> >
> > But also, encoding version information is filesystem-wide, so it would
> > fit statfs.
>
> ext4 appears to have the ability to set the case folding behavior
> on each directory, that's why I started with statx.

I think that is effectively also the case for cifs.
Perhaps not for normal directories but when following DFS links or reparse
points you can traverse between servers/shares that have different
case handling.
So I think statx would make sense here too.

>
>
> --
> Chuck Lever
>
