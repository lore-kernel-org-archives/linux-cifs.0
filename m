Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCA7424678
	for <linux-cifs@vger.kernel.org>; Mon,  6 Jul 2026 12:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783340139; cv=pass; b=THZG7I0iAXEeomM95QmToZheF9PQTEkE22fcnBtnwQHy/2zJQSbsYrHRe7x63ckHKjYb5FvFAaJ8Lq92BcdCn9Tntff9ET3eXKJujDYKfROegGM/CB3L0zfxBbSQSNJWZckiWXH8MfscPLGmbpxCeo2Yl0BK50BAyGbYbfYXoV8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783340139; c=relaxed/simple;
	bh=CbGUa94GJcINTxoi/M3EtQma5R4FLilaK9jbb4N5S94=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hW5+/wyvvo6hrylHSN0SUTNQsekGw9WEfa/scAHmimrmJxJYZ2jvb6HofqYQuvMK8gxiiGKg30NW2DoURjXl//Gt9u+11woKtpENPWRfdtrtkdzKvbcAiC6/8JFFt9eoCxJzkQqPz22t5dHi4imPjmkIwcTcM0BFLxUYO8LV2oM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=kRIzBKp6; arc=pass smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="kRIzBKp6"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92e51d3d83cso143173585a.2
        for <linux-cifs@vger.kernel.org>; Mon, 06 Jul 2026 05:15:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783340137; cv=none;
        d=google.com; s=arc-20260327;
        b=SHIQe+4PW2S9HfbD1PEMEH6Zc8sVGQOB7pFLr3u0CUdoRS5dBgOoDmPKMfmpnhsKRy
         bgBc+gPve9BjqFMV6VxwL5vywACOOs78CnwtnJpMopho4Gt7niFLSielK40fXd2M2cqf
         Gfq0WgPHu+LWcFU3uQOWR1Wsd0i4BDvqYcN5P1jiGHJjgt/uHP6/3BOmpvfFj7YWlKLP
         ZK5g3JuXPYlVJ7HCQmaGEuTQ0rhEEmaXFfRXzSj1/8gkk96CaIxJQSONEdp5dJ7b8LsT
         N/FLznidzCDu4N0N54P3DwRmgLBbHQXi0PuQGTbYx56w+Yqq+jAYeQekj3RF/LLrpJro
         N95w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+yRAvxXQ+YKzcyw8T/PhW1FGamEYrVSW8Lfd6EOBYZY=;
        fh=kfoPKv/n0tLJGPgRXU5KFRanFnJj0ENQ3BYGGf2Y/Zg=;
        b=fQxzTBiMu4KTWNxoKLthuurnjKFjWXNeoEOSXNJLU/zdmLanjAGVkfU6yhOrLQF1gK
         Yq/KafZMoHk7YKr5DiObvkvs+q5BxlRcXLLtJ74Q76XkpNptqjgGVn23hAdw8YbWou8S
         OKsDOe2jBpUCwi0Zd2z2FRx39yDthV4S7L1b9o7wtTwzDkRGh+qYVJ8srPycJu1hCK1g
         aPe16WD0wx1m1o46RM571VJ2DfremB6jmhTFpAhY/PkKMnqEet8++I/QXfZl3jovCmNZ
         bSteHDNC269TREgXgUnwtATDslua3tMHJtzhQPo3m/pspIV8++GNsN7myGbuswVfpncj
         zYfg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1783340137; x=1783944937; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+yRAvxXQ+YKzcyw8T/PhW1FGamEYrVSW8Lfd6EOBYZY=;
        b=kRIzBKp6LWf3cA+AzrHaybL5vkbQIqEXQaB0eOadMTNpibUYc4L1d54i5a15AhWRMN
         jqhAL1u0zZCGbO12PRGgjomRKdlkm7+FREp5wfp3ljTIfScf5+53NT31+jDG9YtN7Xau
         gB4gldpRT58H0Qk+6/L6zk2A8PqLY5bOfENFk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783340137; x=1783944937;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+yRAvxXQ+YKzcyw8T/PhW1FGamEYrVSW8Lfd6EOBYZY=;
        b=XjoQLQB6Lh7tkKUUDxi8IWqNY3AfmvughF4BP3mVEZRgLlPonPEox32Fn0sfhsAQGU
         8BVcdCt/bDPh/Qv3W3Yi2YebhVkysA545LH7cYSYGnMWtAc28msbjVx5PE1Hm0RBqEEl
         PWOVb31t8WYYwBvW8HFiq88YngGN/b7prg8gwcnhhuDjpye4nzY90arAdnZItxnda3Vl
         p2ggnjSjttqaC26dGSqAhK2/hvQOf525BbQ41yIaR6jFi+vwRZBnmMSGQv7IEq2S4VCk
         Seg6qmL2GCkNo2nAJmFpzOrcXTuhJWVomiEh/yQTVq7xZVwCfwnywSnR2E1o7xu9m38F
         KtLg==
X-Forwarded-Encrypted: i=1; AHgh+Rp0pCnlfsJYSvLqibdLEtygYSMTLOIwI1NNURA0Sj6CY1dbu+WRCZzuPjLLfMHuV2kU3wtpfwsV8eOK@vger.kernel.org
X-Gm-Message-State: AOJu0YwZyDbz9xN/miyRLYLucsTEpLO5ya0T0cTKxML/atCY9fq5PSgC
	SftjImYWZzHKpVqU7zaqQ6vCE6LsegHIbV/cD+ig9sxOS1aWMeqkg03fct0g2iEkvlLFvzQs0RS
	jxp1ue9mz5f1QmQMFODLjYpVCe3YHFbZoZveWqggzMw==
X-Gm-Gg: AfdE7cluzaNnnBd+Rbn2OK53LuzUjiuhn1EeGlY3A5YVmgM+FIOEsKgoafHDrydDCEA
	bP0atl1N8EO/a/Ud4J0ps5WOZpRhZSI9AbqILT0gr/BdvL7fWktOYBilEWhNCNRgODeBT7Y3SeQ
	UkvrQVUbMbXPrWmY8gGY4UlSwPIyeG2ZpjDXBmkW8LffYKqVymMCi13/BU4MdvXFsx6oUJn0XF2
	j9EPVeQiN4v74hkxi9fZX42AAmViZq8bWlkvTxjhzBRVobVljydtEtaD9P7p/n5kOzLSM1q40s0
	l1c+a1sARPyxcz6xGY+fWM/aGvY=
X-Received: by 2002:a05:620a:178d:b0:915:f27f:e70e with SMTP id
 af79cd13be357-92ebb55a8efmr34373985a.23.1783340136820; Mon, 06 Jul 2026
 05:15:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260702021105.3406439-1-neilb@ownmail.net> <CAJfpegtCL8S=zjv-pwxrX-9YXL0HLGb8Dsw_XWFF_H4Ui3MTZA@mail.gmail.com>
 <178333912248.27465.12516797587230528370@noble.neil.brown.name>
In-Reply-To: <178333912248.27465.12516797587230528370@noble.neil.brown.name>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 6 Jul 2026 14:15:25 +0200
X-Gm-Features: AVVi8CeuDOFDSz8Gvt6e4KwYQoEpDBYAPNRfZl-KsSvQOMnVuq8THZrkeSzzcow
Message-ID: <CAJfpegtMmSLCjn+ZyhyP2uHzJyqUxDYFjXg4N9M_o=UP5Dk+-A@mail.gmail.com>
Subject: Re: d_time and d_fsdata
To: NeilBrown <neil@brown.name>
Cc: Steve French <sfrench@samba.org>, Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 6 Jul 2026 at 13:58, NeilBrown <neilb@ownmail.net> wrote:
>
> On Mon, 06 Jul 2026, Miklos Szeredi wrote:

> > Wanted to get rid of d_time, as it is no longer used by VFS, only a
> > handful of filesystems.   Still a worthwhile goal, IMO.
>
> I thought it might have been that.  Do you recall why you didn't
> complete the job?

Probably got sidetracked and forgotten.

> There aren't many filesystems that use both ->d_time and ->d_fsdata.
> Just nfs and fuse I think, plus cifs and afs which I'm trying to change
> and could manage with a DCACHE_PRIVATE bit rather than ->d_fsdata.
>
> fuse could move the d_time field into fuse_dentry at the cost of an
> extra dereference.  That would mostly affect fuse_dentry_revalidate as
> other places that access d_time also access d_fsdata so it would just be
> another cache access.

This use was recently added and I didn't pay enough attention to this
when reviewing.  I'll tackle this.

> nfs is more complex.  It uses d_fsdata for 3 different things.
>   - the "block opens" flag that I added and could be in d_flags
>   - a path name - only for the IS_ROOT() dentry
>   - nfs_unlinkdata - only for DCACHE_NFSFS_RENAMED which need to
>     be unlinked on last close.  This is only ever present on
>     regular files, so we could repurpose d_children, but that is
>     a bit icky...  Maybe we don't need a d_time for DCACHE_NFSFS_RENAMED
>     dentries - they are quite special.
> Also nfs uses the lsb of d_time to indicate something about delegation,
> so it only uses 63 bits of d_time (31 on 32bit hosts).
>
> d_flags currently has 4 unused bits.  I want one more for locking
> changes.  Allocating 1 for fs-private use (e.g blocking opens) might be
> acceptable. 2 might be a hard sell.
>
> We could probably make it work, but I don't want to distract my self
> with it just now.

Fine.  But not adding new users when not absolutely necessary would be
a good thing, IMO.

Thanks,
Miklos
