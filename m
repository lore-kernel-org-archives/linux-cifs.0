Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BA32AE9A;
	Thu,  3 Apr 2025 03:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743650391; cv=none; b=lWbY4XW5kHb+0/cied7xmDvDmGa3CSDl6PtyzfYwLxmhXKiB5EmCpFv09ufqKHrSSpjlOiQSaGeqRKb/UD6Ku2JPDAbf87Uf3x8QmN0nFKD+Gs1TexJ6ApjZ6vTsLN2jWZLhBtKulcx098AfCFEPoePccpK7uWCM7VzeLYuRZlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743650391; c=relaxed/simple;
	bh=dPhV2Dx1i7TPqqgN/SJxdgFanj5RQBOWwZ7zfw1NMBM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hg+e/+bwJF6O8vgJS4UGrAJeJ7XyZlj0WPJd+/WGypcbvgjMG7d/Tk7XdOp1IuhwDTnDmiA4JEPo0ptP3cFWOtx3uLKdNzYSfiAmuxkat5I0VRVs/kTHWDTPmDQySBAq+mJRbaO6SKmhNXc5dsilrBOh1DDtNg4f025MIH3IfLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VijD7vg3; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VijD7vg3"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-30bf8632052so3577251fa.0;
        Wed, 02 Apr 2025 20:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743650388; x=1744255188; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CiIkKQKIy0XxhkSJxnoNEJ2UClSeAt3PNfoi3TRl3cM=;
        b=VijD7vg3pwKq9UEpwXDUhke8Xwj1f6i9ta32gJFnNrhZ8gqH4YLDQEZMnPQOIZSbOA
         MXGHFHYgu1EHNKnXOwMjihQapdX5tIBcBG7EHOYqirUkqHc/1UTB0f8sJIqMiBFcOkEv
         aItR5Gi9bVhR84x8YOADWWgIrd9QGDVse8hLOLwi/9kUXSwAbVx1NSTpX3gFa/kMh1S+
         dkG+UmQ4ywx2mTdNMeqYaItqIAyXRqO3wIJU8i/y/2ZOgR7zBtutp8tOiiGs/QluXmry
         r8uGtSWUYKdjUwcfisK7CJ+ENYIM4N7SCTA2GGZ0574oZbHrVnzjkyskc9Ro1TlBKOhj
         SPfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743650388; x=1744255188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CiIkKQKIy0XxhkSJxnoNEJ2UClSeAt3PNfoi3TRl3cM=;
        b=YPE2dwkBdw1oZap3u0C9zKzcVyxJVJOmFoP6Gbluscp0kmcQyqZ+I/ahV4chYvgSgz
         Gcv1BH9JHZUfxOC9dU5lNCwwSrstvUIH0pxHZCHOcmoirEPLCJte/1gksy/wOYa6GoVN
         xiKv8+Ggu/5oY7FRPraTnMgpKlO1vh/b/IwU7MWjSJD/cRCqZOVfEDTWAnJ7bWuY4QQ6
         6tMLUAGEqwEV8Umdq13ZQyIoGReZpUVLYdOEgAkBeyylD5ZToZusvEqCoHy4dPFv0hqL
         LECJpM3+0/lciTLyGho1uvdNoAFYox2h4qtzTR85yCl/9Tt465v5n8l9xUef6IABskMp
         NnEQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1icdh21jFacffxGkpbJFj9yJRmaKcqcVbDGrzTPy80yyAF/s6Rn7kXVqDK7z6kUXU9PNbJD/bLQ3d@vger.kernel.org, AJvYcCValdvW9qSSay5rHYl5LJ7M4n13iFQ9a49Er6UQG0KRaOhqE2CCLs643dFFXMZweA1wxf160VrWbHz2@vger.kernel.org, AJvYcCXEFufuAFrmDnMNjPfiSzNv8H4JzGmc8XlPdulS3BLuAJb7sF1emRu7QneKvNws0Nk2Id+Eiacq22f1zxnY@vger.kernel.org
X-Gm-Message-State: AOJu0YwxQCCmqbNtKyLVACnjoy48j5+IUy8er3BH09RLVDax94DXPd9l
	YjA5uL3/xO9oyhafoWK/ObqriUtcD7sQE/Fv1whYKAWTgLsIfk1VKqXBsj9IbAbTuvwdEJCAjZ4
	vRh78B8yuPka7Pw065gt0nTFkqAE=
X-Gm-Gg: ASbGnctEpbpf2y218imnzZZoZImY0SGLNRL483wg7lI71xt8gAPSNM+jhJTeeA9T0Zw
	uOl2FoU0QX3hR7oUArM0I3+7ijOUPf7C47NXMb+0sWh7VkowTVG9IWnvHtXC3sERFOuRjZ9RFH3
	qhi9aC4Z1gxuQN4EqaIJ3/CpzHhEVrz50fxG2yvI4QXGjHQjdilw5H3+QHShk=
X-Google-Smtp-Source: AGHT+IG7rjnTU1EgqlwK9adNKeontRlIOfXsSHl79G4extA/wzUM9snPQg2SrcXYgVwKmIOraELNxs0lWw8/ls0tLXg=
X-Received: by 2002:a05:651c:1592:b0:30b:9813:b002 with SMTP id
 38308e7fff4ca-30de02cef5fmr73548441fa.30.1743650387488; Wed, 02 Apr 2025
 20:19:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mt68AFyJGdBcPB+eqzdAdbx=0QXC_U8MY-te26Wb0ye5w@mail.gmail.com>
 <20250403021927.53033-1-kuniyu@amazon.com>
In-Reply-To: <20250403021927.53033-1-kuniyu@amazon.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 2 Apr 2025 22:19:36 -0500
X-Gm-Features: AQ5f1Jp24pzOmXXL0bKtHYtfuJLDcOpHeDOjaRGnmENco1TJg0napsX5Suc74pI
Message-ID: <CAH2r5mu7Wf0n9ZmnhAAWetKRiUczHv+odYHj5bBg6a=G1y2kcQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] cifs: Revert bogus fix for CVE-2024-54680 and its
 followup commit.
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: bharathsm@microsoft.com, ematsumiya@suse.de, kuni1840@gmail.com, 
	linux-cifs@vger.kernel.org, pc@manguebit.com, samba-technical@lists.samba.org, 
	sprasad@microsoft.com, tom@talpey.com, wangzhaolong1@huawei.com, 
	linux-net@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I can run some regression tests with these two patches, but it would
be very helpful if the original patch authors could comment (Wang and
Enzo), and since this apparently relies on a fix to the network stack
(the LOCKDEP fix) it would be helpful if any opinions from the network
devs.

For a complex issue like this it is important to have at least some
Tested-by or Reviewed-by for these two, because I was having trouble
reproducing the various reported problems on Ubuntu (or our Fedora
test VMs), and the refcount issues are more complicated they seem.
Let me know if anyone has reviewed these two patches or tested them.


On Wed, Apr 2, 2025 at 9:19=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.com=
> wrote:
>
> From: Steve French <smfrench@gmail.com>
> Date: Wed, 2 Apr 2025 20:14:03 -0500
> > might be helpful if there were eBPF tracepoints for some of this that
> > would be able to log warnings optionally if refcount issue on
> > sock_release and/or rmmod
>
> I just posted a fix and there explained that the socket and module
> refcnt discrepancy is totally fine without LOCKDEP.
>
> https://lore.kernel.org/netdev/20250403020837.51664-1-kuniyu@amazon.com/
>
> So, in this case, the helpful warning is one logged by hlock_class().
>
> As it returns NULL and triggers null-ptr-derf, it means something went
> wrong, and I guess it was acceptable because LOCKDEP is not enabled in
> production.
>
> Btw, I posted v2 with Cc: stable tags as requested by Greg, so please
> drop this v1.
>
> https://lore.kernel.org/linux-cifs/20250402202714.6799-1-kuniyu@amazon.co=
m/
>
> Thanks!
>
> >
> >
> > On Wed, Apr 2, 2025 at 3:03=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon=
.com> wrote:
> > >
> > > Commit e9f2517a3e18 ("smb: client: fix TCP timers deadlock after
> > > rmmod") was not only a bogus fix for the LOCKDEP issue but also
> > > introduced a real TCP socket leak.
> > >
> > > I'm working on the LOCKDEP fix on the networking side, so let's
> > > revert the commit and its followup fix.
> > >
> > > For details, please see each commit.
> > >
> > >
> > > Kuniyuki Iwashima (2):
> > >   Revert "smb: client: Fix netns refcount imbalance causing leaks and
> > >     use-after-free"
> > >   Revert "smb: client: fix TCP timers deadlock after rmmod"
> > >
> > >  fs/smb/client/connect.c | 34 +++++++++-------------------------
> > >  1 file changed, 9 insertions(+), 25 deletions(-)
> > >
> > > --
> > > 2.48.1



--=20
Thanks,

Steve
