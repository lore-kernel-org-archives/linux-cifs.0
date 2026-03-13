Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5FF2D8393
	for <linux-cifs@vger.kernel.org>; Fri, 13 Mar 2026 05:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773379677; cv=pass; b=rL7PlS57qMFaY1o0iGnK0KXnGC5E+Sq6s1XgAEGfqk+D1ToJig7/80bZT3pUJxvPPr12k3dDeNypxQ36oftzwM7zDMct9cyN0OpK6wqOSbmr+BiBEbroTmvXdYkFHWKwJZ+2H26biBlVWBUF7K7BMunb+OtewloRukCuLIsDcz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773379677; c=relaxed/simple;
	bh=0OfuDH4bJEyjji5lct+5q9F+hFFk56r8b+9CnT+8AQA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OLTe5/LV+4kQAL9xRVxoAuYwh+lH3mfro4giQYEQYz83uMR0rF5znoD9jk1R4uAC0DvNHIJyBjbAiR7F3zjaPDkoE8rPsc6h0L6nEh0HiX89EM/CFevo4+vwe0uamdxVFbsiaC9+HcK3NOVT/Zvbc+FqL8j3Vs0AKy6NU+yUeyo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CFVvJk4F; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CFVvJk4F"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-66391baf250so1333579a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 12 Mar 2026 22:27:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773379674; cv=none;
        d=google.com; s=arc-20240605;
        b=gng3Qc5Z62TGk5xLUfoeL8VbwMcouaDf9k4NS1Ha9K5gYs/PBYIbHaMuHroQleqmLs
         aKBzRcWfScRm4JmYhjqT9moipASQ1XpqOFoG9558EFvYwk/QtVjFsoxR+YUdZ/xXZL5c
         K9rhafYOnxfsZua4jNDuot/TzHCfwQFnZ3sOTBkgzT3KLKG6F7QZIsuxrdYOUYzrClWZ
         jfqpX2NwEd2rfk/qhL9zeN3WRrhqOJU6B+qW9E8tp2vpMM0OIny5Qz7XaQHLKqft9AwT
         PHGTTBlth3UL6//YueaIONj1I2nQR5mg/gd/d8TASvs6HpqKqxPi8ziPrAHm/7YAncg4
         7OTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0OfuDH4bJEyjji5lct+5q9F+hFFk56r8b+9CnT+8AQA=;
        fh=7JecXso58ETVEUPHnDZAUIiuOBorpUskgIGXjBNwYgk=;
        b=hQQnV9jfTepPNdotkIfXoL7KgKJ8vVC3k9Uy3BXBxbqbBSJXXjJKfYQvjA4HPX7X3x
         NKnJZ0SjR6F6/V+Einof2zeb1qCNzJMtdNdd3a0Chj7ME73g1RvL3cO4tvRGcn//RL1X
         /7zOoNxRR5PFY3oc7gD+8W+WPmF8u+F8c3055fgagEMyQAuxtZlnKKoU5XqwZlXIb2Q+
         qi6Hg2AGEXbx9yQqSnb+Ir0tcYjctl/kt2WfG7wrmKD9xDdW1JtMUZVTJ+0rIcenezHy
         syPtl9zWHpuYaacEOlMh1T15+wUTEO33IHR0HJAb0oCSb6+1CMlgm9JCTBuGsrwy4tsN
         s60w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773379674; x=1773984474; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0OfuDH4bJEyjji5lct+5q9F+hFFk56r8b+9CnT+8AQA=;
        b=CFVvJk4FpftfBdfMRDbRxiHZ7a2M0F6z9Hrfe0ya+J4XNv9XF79+2GVI6Q954IVwRm
         fJN8jrH3ZsJSslkw1KqqhzCcRmj4CyZUkg0B0+zTR9X+MXNZI6+BH9t3Q3VNtFBAcAUZ
         Xp6i4s+A8LTBd61g7mh1vEcjguPEM/hqRFsHpP92k7D0J2BzCoe2wate0cEaMyjc6k2u
         oXLb6iPOMV0FjfZDaBe4mU2o00/kxBAK/uM+QgEFsuOU/88xsDAVNJLeSJftCSVkuMPR
         XU+YRRP2wCJzNVi1DjGV0QHPvgNQDE0plyg+q5439syh/0JfvwdmFNo2OyxjbKH8AbE1
         Y6Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773379674; x=1773984474;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0OfuDH4bJEyjji5lct+5q9F+hFFk56r8b+9CnT+8AQA=;
        b=YlXfW4M3fhsaafonj7jZVHD58GXmOzcED7W0/GmvdexOIqg7Tx9BlLf/4prND8tZxp
         mblcq9w6IBXmFOPZWHyi5GiEouOs2+NAt5g4vtBixFMVFZoA2GKU5Y8WyQuj11749DSu
         d+/pZfz9vMCgrQyhatWtn7bx2fhBX9LAZfBdf+3MlNMJBIN4MPMkOaITwMHMyU5WJ/8q
         1MK/qx25yc4iUSgnMoOpp7n6w1O2dz0VgfqPApfIvfGsOlmpXLK3zVEzXgNr/6IWkJ8/
         bQULpD3ex+biQBQ0nNgEOUbMGLJnFhb5dG9KqyuGAkR8s3sQSgC9EC1vcN9N7im21GDd
         gfqg==
X-Gm-Message-State: AOJu0Yx4EUv+6zw+nPZLcUOFu95z18KRbiSKIJ1GrGvwxQeqJMjfcCRj
	PCrLpTRLNFeE/3vUJRnjnzqCZrsqSKNpJrSWp+qMbIF/DLzPap3/QDYOfOvv1jiPkHBjtjaWOYK
	D+90CVyJPmV2oGH6SCqgQMALk/c0sKCwTNTvW
X-Gm-Gg: ATEYQzzh2+0yIft7ooOFG9VW50viDg9n7YNHtTU8q3fYTQP7rzCCExRQsyAUqfAMzt7
	Gkxe2cDC53HvQ0lie3eEIsuBBnnslEsmLRVU6d/6yqFC2htRGI1hgsFiI+nnzRFLHYGvkJIv1tz
	9Iq6jysmu93S8EBuCZyjNH8CSX322K0DLxz1Wi78vKNEdwV5e/v/kaXoSM5xWefnkk3yMmaJPpV
	3turcxWyLp2OEDvh5Rl/ycdKULkgd6G14Y8ey3k8SHb91Hiwi4SblfW0mRIKli2qm+ngBZiLtyM
	DnN6lA==
X-Received: by 2002:a05:6402:3486:b0:65a:507b:c7bd with SMTP id
 4fb4d7f45d1cf-663bac17329mr998277a12.26.1773379673632; Thu, 12 Mar 2026
 22:27:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260304124629.1616108-1-sprasad@microsoft.com> <u4s57pxvrttksfxe5evylucarfoyiv3ut32d45nvfafsgmxtog@72x2iew66wrt>
In-Reply-To: <u4s57pxvrttksfxe5evylucarfoyiv3ut32d45nvfafsgmxtog@72x2iew66wrt>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 13 Mar 2026 10:57:42 +0530
X-Gm-Features: AaiRm51kqwT5JCy3boW3dEg7NlB-HryqfLjhZwCADrWkF30RSlhaY9DP2a5O6CQ
Message-ID: <CANT5p=rdme19zW8Dk7WuEXw68Jzdt2QsdfK-gRManJJgGWQByw@mail.gmail.com>
Subject: Re: [PATCH] cifs: open files should not hold ref on superblock
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com, 
	bharathsm@microsoft.com, dhowells@redhat.com, 
	Shyam Prasad N <sprasad@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 13, 2026 at 1:28=E2=80=AFAM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> On Wed, Mar 04, 2026 at 06:15:53PM +0530, nspmangalore@gmail.com wrote:
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > Today whenever we deal with a file, in addition to holding
> > a reference on the dentry, we also get a reference on the
> > superblock. This happens in two cases:
> > 1. when a new cinode is allocated
> > 2. when an oplock break is being processed
> >
> > The reasoning for holding the superblock ref was to make sure
> > that when umount happens, if there are users of inodes and
> > dentries, it does not try to clean them up and wait for the
> > last ref to superblock to be dropped by last of such users.
> >
> > But the side effect of doing that is that umount silently drops
> > a ref on the superblock and we could have deferred closes and
> > lease breaks still holding these refs.
> >
> > Ideally, we should ensure that all of these users of inodes and
> > dentries are cleaned up at the time of umount, which is what this
> > code is doing.
> >
> > This code change allows these code paths to use a ref on the
> > dentry (and hence the inode). That way, umount is
> > ensured to clean up SMB client resources when it's the last
> > ref on the superblock (For ex: when same objects are shared).
> >
> > The code change also moves the call to close all the files in
> > deferred close list to the umount code path. It also waits for
> > oplock_break workers to be flushed before calling
> > kill_anon_super (which eventually frees up those objects).
> >
> > Fixes: 24261fc23db9 ("cifs: delay super block destruction until all cif=
sFileInfo objects are gone")
> > Fixes: 705c79101ccf ("smb: client: fix use-after-free in cifs_oplock_br=
eak")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
>
> Hi Shyam,
>
> So the side effect of the previous code is that the umount hangs until
> all the files are closed?

Hi Henrique
Umount works. All it does is decrement refcount on sb.
When the last file is closed (or when the last cifs_oplock_break
processing completes) that's when cifs_kill_sb would get called.
Before that if there's another mount of the same share, it will reuse
the same session, tcon and open handles. As a result, an attempt to
delete files on the mount point may fail (which is one of first things
done by many xfstests).

>
> Thanks,
>
> --
> Henrique
> SUSE Labs



--=20
Regards,
Shyam
