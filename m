Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD3430E85E
	for <linux-cifs@vger.kernel.org>; Fri, 20 Jun 2025 15:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750431854; cv=none; b=NIKRLkfK5J2A4JpOj3CCsNRpzutB/Vp3OKwAcKrQnR6FSsowbVanfN8Nfja5Y1M3+um2eW91uZvkIVcvfixK8V+trcBIa336NRv6F82/K5bNTkuhr9vZdcsx4o/X3wZwdzDIJbk0ezxzerJkv6ncwxghsb4JrLOOoBiandvrFJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750431854; c=relaxed/simple;
	bh=qFXauZoyI8kmF/hN9UO4dqoA0DZw6yUaA0W7xe/t9Nk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KbXDuU3HnLSg6qFRNaigZIlSQJ0ReBG6C6uai/+lt08pJjPyNqeFd4859tH4odg8Ccf/2v9yhjvJl3CltyF3QclRTXhR8zmVMxL5qYQZFsuzLSxGQ7kSDF9FLemSsFWZT+P4L/WQqxusq0hB8OSCvVj2cevXwNtwKkU18ho8eP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FNfirscD; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FNfirscD"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-70e23e9aeefso16399497b3.2
        for <linux-cifs@vger.kernel.org>; Fri, 20 Jun 2025 08:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750431851; x=1751036651; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C866tPD99EZ3vGO+Vmv81GcObEtv8Y4ixVsJYIz8a1Q=;
        b=FNfirscDMgj/oqIO+/DqQlU+rMETEL+D6EbptNFvbRVWW737y59K8cn68BjgGhDt4N
         THfLjidNxgA7qHUM9n7IWYYUDMkyutSklrPTYnkN4r8moQxYFsqb2AujuvB0NXfiU5HO
         D+etpNy7d8tIqkyXIet+94w/H11Z6aNp+EVaK5w+J9B5jyLSB39JoXkLP/V3E+laKO7j
         FdA7BsWWLqeJ9YRSboQxrLeCKzR3tRknsbXngp6GlL8LbJGN8ArqtYoe0Z1sUse70T62
         0Ajg5Ab9x09ZJHRCrpamiA6jXOrMcrcssczgIeWYPrpKNA/YffSVC8SbRj0RjnnkQM4U
         ++mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750431851; x=1751036651;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C866tPD99EZ3vGO+Vmv81GcObEtv8Y4ixVsJYIz8a1Q=;
        b=h/S4saY8xa+C906HsHN8Ag5YhQm12OAeuvI9632AG+IIPd9dlkBrDuzF34C+BAj6bj
         cewX+53NWLCsZz1ZKUJSN8bB6otgegboUHwGcMDAYfbutLzNWkXEMZYwAOYsZNR7DR6u
         Qa1sKw+y4uqmpxmcfGxz7gyrBdT08zIpV/osR7OWJpHSvSVUORZymQDC72+x9vNLNcNa
         +5LJGM4d7v6UL+HYsnmYNixBQEKG+ucVGCpN3l4tKP7sx9J/RLD6xGvyv0z4msYuY9fU
         dtulAl+HP7TddmQ60n5fVg7odRnFlEpo04nmHL6W1STr4/SCnfijB093RG6GgwMODil9
         QcdA==
X-Gm-Message-State: AOJu0YwjEFptussl5H/jBh9Otri9cwj7or/RdNrCru/8tsN43NWk9nPe
	nOHREyQLUdjI7fz2tGYsz/uO+elRgGXODlmDL4F0LurctdFXg++BisyD0mdtkWFP5Pl2B117zVx
	fSmdx0xrrD6GQ6olLWhvMMbvS4EttlEQ=
X-Gm-Gg: ASbGncuN2AahaDz1t6wccStVnD/k/RW2Tx8CkvrCyaE1OoYL0m8gzB7N4m9V8gyGzgN
	eE1N81YN1K4hzJCXsXaijwMj7jhajABORQ1wt5UotOK2EgBwn6/Cc85ooIiKBSFVDEQ0j+Hmdt4
	gnNIZ3rJmZXIRO5x07C1yDXFUP1ntaq0dttSTzYYsHxbhWRA==
X-Google-Smtp-Source: AGHT+IG9W11LrcQwxo8yLqTNQwxgoZbU0xRoJkZOZ7IQpJN+JCTPDefMJgOetI9BkYJnQ8DhJNkV8xx84BOC35XKo58=
X-Received: by 2002:a05:690c:6209:b0:702:52fb:4649 with SMTP id
 00721157ae682-712c675e8d2mr47825027b3.27.1750431851487; Fri, 20 Jun 2025
 08:04:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250619153538.1600500-1-bharathsm@microsoft.com>
 <20250619153538.1600500-6-bharathsm@microsoft.com> <804a52779d6988d1d434680002ca4d64@manguebit.org>
In-Reply-To: <804a52779d6988d1d434680002ca4d64@manguebit.org>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Fri, 20 Jun 2025 08:04:00 -0700
X-Gm-Features: Ac12FXyor6PPmppOZ3iMTVRHMVf57AZaxAhlA197ipfPdA2lhvBabAjTMyk6leE
Message-ID: <CAGypqWzgOpsTo01619qY1pjLJt-z0kci9AfEHkGGwsTbwJhoOA@mail.gmail.com>
Subject: Re: [PATCH 6/7] smb: Fix potential divide-by-zero issue when
 iface_min_speed is 0
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 19, 2025 at 9:01=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> Bharath SM <bharathsm.hsk@gmail.com> writes:
>
> > Address potential divide-by-zero issue when iface_min_speed is 0
> > by adding proper handling to prevent undefined behavior.
> >
> > Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> > ---
> >  fs/smb/client/cifs_debug.c | 2 +-
> >  fs/smb/client/sess.c       | 4 ++--
> >  2 files changed, 3 insertions(+), 3 deletions(-)
>
> Isn't be7a6a776695 ("smb: client: fix oops due to unset link speed")
> enough to prevent that already?

Right, I didn't notice this check. I think this fix should take of the issu=
e.
