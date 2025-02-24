Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F354C8F;
	Mon, 24 Feb 2025 00:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740358145; cv=none; b=Qf92ePc92k3kP9vLZaukyHJJu34RGJzK42QW1yr1U4r8ujA4r5DqfNDPLLLehF/FTKVedkINvYTIGCu6T1pvCwebaNr8CSHUzwMRxZiHtAZqEEW+wEcJ4lYe2aorWBKh1nCfSyCqZX+BgimZQud5Ge9Y6x4n+FbhVeIlzUCwvp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740358145; c=relaxed/simple;
	bh=Jzsw5QO4H3N/xARGLoYmpCSLmmdwVRbyiqi9ZCQ7pEI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HY7Xmq3nnL+vZYLyPFebqSfunGeRatIaVZ9dTlgqJvww+aAp9kRNMWSUcPhnOdR4PslbAKLUjCo3hNuaQk//7g1Yo68riwme5GSkGSOJdxnETJ0HqMoWUi6T3zg8NUFzqnUtzaK4IQO1N6fSn8ZrJyvnRrLueHzvCVXD7b80TAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OBTEXrlR; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OBTEXrlR"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5461a485aa2so3563190e87.2;
        Sun, 23 Feb 2025 16:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740358142; x=1740962942; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xt2LkBK0hGIK9sk8aSwFk64Mnli3ElVLH6wep+qNJUU=;
        b=OBTEXrlRir58G3VJhV3cq11NCguVD+yw86EvrG1zpTYNj6wPyxhXvQyV9MFpy9KqfZ
         mc+Ym2KiIrSLmmyWG2vW9I+JyMqsuyOVeZ4a4GrFoPKIslR+eBE1knLQyc41ZTfcFk9l
         lXDQmY7WDy4KANl5V5g1IfV0HbYcnewk1LAUr+gDuLavS8OpbckBzRNMJzMkDSEF9An5
         TksHMFbCE7V/jivLuu6NJaTs0CNJUcRzQvzIb5v+1II6td9OJ/6sulTl333UBlrFdPr5
         svrH5sNTTjoQd6g6MtRWBohpkrKjjA9r1NYs2WFAhZmfrB02P2PzYn+X9Ce5D/gOaQOI
         gHoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740358142; x=1740962942;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xt2LkBK0hGIK9sk8aSwFk64Mnli3ElVLH6wep+qNJUU=;
        b=jRpbRkLlofYLDKbuVQ5L31QXjzuaQeP4RY0rQpH5tRcXlt+2uNpK6FIitIro7FS602
         UVhRRfHqjnf5D9UTboiRLP5OqGhK8nUsTAHax8s9LKbBMDwDv5dH5zwqL+RPkmnjf9nb
         uN0mp8WuxSB7XK5avCayGQc6f96gMzlTIqV1XUIhGGYbKWBC4RnqUy22KH/OoFoQ78Rz
         9vehnsQkIdRF10eR1GYF5gslInopqCVBuGFxT/j1S5iuXushnZbPNg8VUNA0/dzPfv3g
         k8tPBRyR8lNNgYByDxEAgEZ3o5yibZ3xEWUD4lzilZbf9LQ3kF/ux0VyK25wXcxJ2wfF
         pB/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVSdtSfs0SIz/KdPd9kkVBYcV4IEKtLYum8brzn1OPDf0N8UZeFynv6QEYe2whSXOcQ6G7o1/XlO7ajgOu1@vger.kernel.org, AJvYcCW8EqnMMDafq1FkqdfB50aJvjfRtUsxsfnZ4IMbaHxUOOLJ9pwuKGQPxmjgwoji5aKKDda1lHoL/R06@vger.kernel.org
X-Gm-Message-State: AOJu0Yxw14NFDFarYPr5pZNa3sAs7Sn3MOw+pf1ks9Y6Dmw33AOgRYcH
	n1iYGYzS8mpX5ANpkHbtvBSbtktUjcIx4enyl4wm3xY4mRiAE4X6cWDuyfOG16goSBqinR5bPN1
	lGQKi22ZunuIPjgl56bC1vC+gFJ8=
X-Gm-Gg: ASbGncuTgTwBgrWYuDTPQX1l1t6y5La23EWStFiZ3fKdLdp21hCooVnTsEyiGpCLdcn
	P4JX4YGkkF2S7rfzVBYUbSZkofsplHLwvPlfcwEutUeRjYHWLhlTclJn3lesFWd6j1wKJUnZW07
	UMiTBK+E4=
X-Google-Smtp-Source: AGHT+IGABZZ8wTkaU/4AVUK8/92+7sI96FBM5IfBG3yrIHEi3ysNTlMQstK0NawrS7rEc19Qt2d5Oj4YJWbMFh3Vpxo=
X-Received: by 2002:a05:6512:1106:b0:53e:3a7c:c0b5 with SMTP id
 2adb3069b0e04-54838ee288fmr3802000e87.10.1740358141810; Sun, 23 Feb 2025
 16:49:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241222145845.23801-1-pali@kernel.org> <20250223222306.plgy3bpy5mjojfve@pali>
In-Reply-To: <20250223222306.plgy3bpy5mjojfve@pali>
From: Steve French <smfrench@gmail.com>
Date: Sun, 23 Feb 2025 18:48:50 -0600
X-Gm-Features: AWEUYZko0ubEJcdQ7txR7GliWeRwpKU887NvYFvgu8t8db5jtuyzTa7hlyTi6R4
Message-ID: <CAH2r5mv_+ZarrSPEhDjgEYPzqkvdqL-K7NjDsE0sXtrhx65G7A@mail.gmail.com>
Subject: Re: [PATCH 0/4] cifs: Handle all name surrogate reparse points
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 23, 2025 at 4:23=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> Hello Steve, I see that you have merged first two changes (1/4 and 2/4)
> from this patch series, but the remaining (3/4 and 4/4). Is there any
> reason why 3/4 and 4/4 was not taken?

Mainly because I wasn't able to easily test it, and didn't get test
feedback for anyone else
on those two who had tried it.

I am ok with looking at them again - and thx for rebasing.   There are
some of the 41
patches in your updated cifs branch that do look suitable or rc5


> On Sunday 22 December 2024 15:58:41 Pali Roh=C3=A1r wrote:
> > Name surrogate reparse point represents another named entity in the sys=
tem.
> >
> > If the name surrogate reparse point is not handled by Linux SMB client
> > and it is of directory type then treat it as a new mount point.
> >
> > Cleanup code for all explicit surrogate reparse points (like reparse
> > points with tag IO_REPARSE_TAG_MOUNT_POINT) as they are handled by
> > generic name surrogate reparse point code.
> >
> > Pali Roh=C3=A1r (4):
> >   cifs: Throw -EOPNOTSUPP error on unsupported reparse point type from
> >     parse_reparse_point()
> >   cifs: Treat unhandled directory name surrogate reparse points as moun=
t
> >     directory nodes
> >   cifs: Remove explicit handling of IO_REPARSE_TAG_MOUNT_POINT in
> >     inode.c
> >   cifs: Improve handling of name surrogate reparse points in reparse.c
> >
> >  fs/smb/client/inode.c    | 17 +++++++++++++----
> >  fs/smb/client/reparse.c  | 24 ++++++++++--------------
> >  fs/smb/common/smbfsctl.h |  3 +++
> >  3 files changed, 26 insertions(+), 18 deletions(-)
> >
> > --
> > 2.20.1
> >
>


--=20
Thanks,

Steve
