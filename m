Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BB929A0
	for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 14:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746885874; cv=none; b=jlyU0jX4Kid6grUHnQgCbdqPAf5xx9eTmElDh/djGi3EBW56TkGb3cx3E1E1InM1qF4avDKSgX4O5W/gzlhAXDuJ2rqd+0Gf1KRjfV7Nu9OnNxxX22rxcsAh1kbgwCUhhZ1haVd2bZXzoi9njHkkEHmRrX4PYDqwgvKJQGki5pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746885874; c=relaxed/simple;
	bh=bzzw+lzAFeQwRB5P0tjlLI0dbnHVe1JE69BZ+lcmWt0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fcwo1QAPyHGGvNnt/bo3d+O76GaNN6FcBKarYQZrNChejEFnGCjVnrkQS5kRr4QXIVzUuSW1DhpAPBcDD7SBZ7Kylwnuhw8R2zczaiQAjTa4QIlB+Fd7E+oyqOyTX2qin2B5D9iRK5YzV6a1znwDAfmwZDTcGZGT09kQ+l1VcTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=STJ7nngu; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="STJ7nngu"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5f4d0da2d2cso5474169a12.3
        for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 07:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746885871; x=1747490671; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yCTqjx7T3JMGRbhFwgfL+zwkkS3H+vgeaXj/Hi8aWIA=;
        b=STJ7nngusEFGViucPqTe5h4lfr3/a2TspXCv13be+4MND+JxkffMlVyZKaTDVPXgL/
         cO3Kt0qkzYsPnNoUaAh7Flv5oP2FyvvNudwJgZ04SGe08Wk27D3aLfIqzk7frkzvKi4o
         nXwU9h32HUzobftAYeeQtkLjc6ix8vbsE7mya/8+G2vVJxATf8OTRqbr8HcX+zpzFTYz
         6RTLoK90sqVqkXHNjmmPklu16xpd0viZlRrBOKo6yM5SbsLNnAp2ieb/xgzHw5X6OrHb
         Nm8GZ8H5Bnwn6OREj9TBWNygLbnzLbwA/ku8cPdvlj2/Wudhw1ec/5IevAFDFU3eiFty
         ZUNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746885871; x=1747490671;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yCTqjx7T3JMGRbhFwgfL+zwkkS3H+vgeaXj/Hi8aWIA=;
        b=NRLnqTfkKRPQDuQkixQhfdpmOm+d0hJRSS3/HTLVskS4CrnLj/GHCCfM+G5Ab95mIT
         S6W9REJ4/CSveQ/tv1xJ+NCjpHodP7BYfInvD5xQ8tWpq4fInSHeNmznf1oWgtv0f05S
         29vKY1H06aaHyENtbyh5T/8FdmrJXoRMALYbh632aSyZ5x/abyypi26jK8WmQy8eObdS
         lJ+Shvubr5LisQYcNdBNbb46UjvBx1qdIKyYMtZQ78jaXsNvD5uOfXirFSyeLU8kf81s
         8KXghg4hTQTRh6OQX+GAn+JgH57UqpeUkKkCeIqFPVbwWdy15Y8qGzUfy4Mpt3OycjHB
         liPA==
X-Forwarded-Encrypted: i=1; AJvYcCXbQyxm2P5DRKQzB6s8322m07eQDBpLy6Uftt5tVeryKEwVDLkAUneg6xPBJsQX3PMTVLe5XYAodQz/@vger.kernel.org
X-Gm-Message-State: AOJu0YwKK1+KMauTDbKiZ+48wAh/0764o+GB/NxtELwg01LZOQkl45EY
	ZIap+OMwCh/dEg0sW84TRfMTU9olMcks7EkKx11K+sSGuX/cDUEpEt09s/khOqGuNhfpjQM3uNn
	/285iFEt18hqS7hxRJw0T+B0bwvw=
X-Gm-Gg: ASbGnctqBNM73eC/omdk4k3aLCY5Dku8OEy6lZrf4dt8y0fX3PZNr128vtrJfb9Xr2p
	prRwP6mB0e2PFVMoMzgvsdAvaoKrTMW3vOSjePvqqZ/DT2AMV6rEbCoFcFMRyvvO7+9KzxN4Qub
	KU+8S3OEJhdDo1sl4b2SpVe4Dp1gg9ZKbBwPJMFY0Ji7JSF6vpMHU9EiL6aDNj6js=
X-Google-Smtp-Source: AGHT+IF6qf/SmPAJ1RoeamuQskoMGUtgv843mFb1xbbqezWQOYbgnMJqydwfywJU/NNc7Kw2e1Q9pjWX59DWvNzWav8=
X-Received: by 2002:a17:907:7fa6:b0:ad2:40f4:c251 with SMTP id
 a640c23a62f3a-ad240f4cad2mr112204466b.35.1746885870452; Sat, 10 May 2025
 07:04:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250502051517.10449-1-sprasad@microsoft.com> <aBS8jg4bcmh6EdwT@precision>
 <CANT5p=qGspYwczDEnp6oy6F1UQJZKJ9vYw_3pKdipcByqjjuTQ@mail.gmail.com> <aBgFcc9SPRPOUFHw@precision>
In-Reply-To: <aBgFcc9SPRPOUFHw@precision>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Sat, 10 May 2025 19:34:19 +0530
X-Gm-Features: AX0GCFtUi9EzJ7og-IzZwz3fiaZdWy_-As1N5Rnw2TD38jbCSyD9fVXawyfANLg
Message-ID: <CANT5p=p2Y2m7ELymv94n=GBkzX7eW2Us2r0zw=XkfNA-aNZcbw@mail.gmail.com>
Subject: Re: [PATCH 1/5] cifs: protect cfid accesses with fid_lock
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: smfrench@gmail.com, bharathsm.hsk@gmail.com, ematsumiya@suse.de, 
	pc@manguebit.com, paul@darkrain42.org, ronniesahlberg@gmail.com, 
	linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 5, 2025 at 5:57=E2=80=AFAM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> On Sat, May 03, 2025 at 08:24:13AM +0530, Shyam Prasad N wrote:
> > On Fri, May 2, 2025 at 6:09=E2=80=AFPM Henrique Carvalho
> > <henrique.carvalho@suse.com> wrote:
> > >
> > > Hi Shyam,
> > >
> > > On Fri, May 02, 2025 at 05:13:40AM +0000, nspmangalore@gmail.com wrot=
e:
> > > > From: Shyam Prasad N <sprasad@microsoft.com>
> > > >
> > > > There are several accesses to cfid structure today without
> > > > locking fid_lock. This can lead to race conditions that are
> > > > hard to debug.
> > > >
> > > > With this change, I'm trying to make sure that accesses to cfid
> > > > struct members happen with fid_lock held.
> > > >
> > > > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > > > ---
> > > >  fs/smb/client/cached_dir.c | 87 ++++++++++++++++++++++------------=
----
> > > >  1 file changed, 50 insertions(+), 37 deletions(-)
> > > >
> > >
> > > You are calling dput() here with a lock held, both in path_to_dentry =
and
> > > in smb2_close_cached_fid. Is this correct?
> >
> > Hi Henrique,
> > Thanks for reviewing the patches.
> >
> > Do you see any obvious problem with it?
> > dput would call into VFS layer and might end up calling
> > cifs_free_inode. But that does not take any of the competing locks.
> >
>
> Hi Shyam,
>
> Yes, dput() starts with might_sleep(), which means it may preemp (e.g.,
> due to disk I/O), so it must not be called while holding a spinlock.
>
> If you compile the kernel with CONFIG_DEBUG_ATOMIC_SLEEP=3Dy you will see
> this kind of stack dump.
>
> [  305.667062][  T940] BUG: sleeping function called from invalid context=
 at security/selinux/hooks.c:283
> [  305.668291][  T940] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, =
pid: 940, name: ls
> [  305.669199][  T940] preempt_count: 1, expected: 0
> [  305.669493][  T940] RCU nest depth: 0, expected: 0
> [  305.670092][  T940] 3 locks held by ls/940:
> [  305.670362][  T940]  #0: ffff8881099b8f08 (&f->f_pos_lock){+.+.}-{4:4}=
, at: fdget_pos+0x18a/0x1c0
> [  305.671009][  T940]  #1: ffff88811c490158 (&type->i_mutex_dir_key#7){.=
+.+}-{4:4}, at: iterate_dir+0x85/0x270
> [  305.671615][  T940]  #2: ffff88810cc620b0 (&cfid->fid_lock){+.+.}-{3:3=
}, at: open_cached_dir+0x1098/0x14a0 [cifs]
> [ ... stack trace continues ... ]
>
That's a good point. I'll make sure to dput outside spinlocks.

> > >
> > > Also, the lock ordering here is lock(fid_lock) -> lock(cifs_tcp_ses_l=
ock) ->
> > > unlock(cifs_tcp_ses_lock) -> unlock(fid_lock), won't this blow up in
> > > another path?
> >
> > Can you please elaborate which code path will result in this lock order=
ing?
>
> I was referring to the following pattern in cifs_laundromat_worker():
>
>   spin_lock(&cfid->fid_lock);
>   ...
>   spin_lock(&cifs_tcp_ses_lock);
>   spin_unlock(&cifs_tcp_ses_lock);
>   ...
>   spin_unlock(&cfid->fid_lock);
>
> This was more of an open question. I am not certain this causes any issue=
s,
> and I could not find any concrete problem with it.
>
> I brought it up because cifs_tcp_ses_lock is a more global lock than
> cfid->fid_lock.
>
>
> Best,
> Henrique



--=20
Regards,
Shyam
