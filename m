Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DE823BE
	for <linux-cifs@vger.kernel.org>; Mon,  5 May 2025 00:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746404825; cv=none; b=OCmTzRotETdxzBbQ7sEgB3M/GRh495eWMhDIumdMsSQ2ScA8zTRCR7n/Bxo5Gfv7z6zHjk6etcFpwXt5Io5Xm6iiXmL60woAxVXiznlAr8/qNjy8adHGvwjJXiFt9tSKsHjyzUE8/o6PseCt9mnLwgIabaehzyq8qTa/MzMb78A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746404825; c=relaxed/simple;
	bh=yXLbLOVZDa6sYTmSIemzAgaGfQYehNUtiSjx2EQJ4EY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KiUDehEB0F/16NmGyYWumsMDLpZUZn9JFNgXgi/ZaarsWiM157xsEDgYxkXDCflLWYewf0GMI7XKO/GXucoSfwMjSZMoaJPUnbEnUNdL0hMvXob1cljCGNyQmgmh+DudLE85XkSVXSPPYyp/In8FM/x+b5W1mN12oy+P7u9MgiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=R6lbtead; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="R6lbtead"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-39ee5ac4321so4653928f8f.1
        for <linux-cifs@vger.kernel.org>; Sun, 04 May 2025 17:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746404821; x=1747009621; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=c636V7sNa5BkSF14ehm3IrFwHmW+7lD7iJmuPiJZUU4=;
        b=R6lbteadpiHurbEQZoR5yfzsZfU1+iFhtTYY915iOt+vYpQH5xK56W8hWsEBGaa82r
         T0fDpgyu+vUSrE3kzetXHSvOUsl5GVpNZrZ0suv0bLCS8oLaP/PVwzRTB2kRrKBWG1ak
         amnkETx0XuqiekvB8izGOstSGU5D76wT0gggbMAdSvy3/LEzcOR/M0vYJU8dK6L4b3TA
         RYJE9T9Eo2BI+Bh5PRebVMzfRy7sJ4JoIK2OfxahnGAFd54Eotj4C6RJCsZqPYigJn3r
         XSA3b+t0KaftqpgTary6xgfevGM41zkWVoy6DeDO8nEsD2XTD5/tGpsTqA1LxMEIHI5c
         BC8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746404821; x=1747009621;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c636V7sNa5BkSF14ehm3IrFwHmW+7lD7iJmuPiJZUU4=;
        b=CH0Pq+poRP/tf2h4Zv5+IsqDlBJGUS6YDPJrvNPBcGbzzDv/GDG+dAdLTzCzs+vR/v
         qAfBia/3HXjD/GhxaD7PEVPATKkOzV9jsycyjziFufx2q5RoEHqj8G7am1BiHZ9f2aiF
         ZSXQlD9oQwTvEps5dFAP9/yMUX1qPyad5h8BPhJX+tdMSy7Qg0cC1w9CNRh239eHo/Nu
         bmg2EWA5dEOOJLKi39i1qf71QG5CfBVu8K/e23BR9WIkRUo6vOakErre6uHoXnDfovp/
         aPfajA5+of9UGalHJFKj6YcGBeFm4MtPxmBjBuJH6f+e9aHT6jNa4qksDpZFpRiKljR3
         8tyA==
X-Forwarded-Encrypted: i=1; AJvYcCVr0b4AkgmjWRr1qc3VWMS9CZOg7pvB9NmqwlJrejSGOqKwiboyOdcZS+GKWjIck6nReDf/Nb7NBv57@vger.kernel.org
X-Gm-Message-State: AOJu0Yxs+BPJl7B5WG1orcSQ2QHfmnmMn2QAqMg+UmHFZhJae3MOOmL4
	dduqYB+rYezHmnonv4txJeRz90nPFYEWMPvNkMpBuShzp585gmdewVBvVFlgeRU=
X-Gm-Gg: ASbGnct+9eZ7wn1QGyFsKyS9wzcwAzsTtcCalbmCew1gJQUpjZ1tD6TOHtnvp2ikNMj
	86iFWj92wrloRMBZ//TxwX9TRTHs0V3INbcD2rPeErV1XWcvBONaCUwWSPV6G2NXeCrhOR1YGjE
	RSXzOJq2zzeoRj3VIv3ou+pQpeYrA25XrwxdWos3p72RoczVkQe0ZMtb9fdvGJ0CsWcAfvdT2s9
	XXpLqPXLyKgR3H9QdAyKgiqbeFe6sZkbPolDCsFmW+dmd5+F2WMSU7rgP18SqMVcmjGcnq1D6EE
	FsaSQ/njnz3tXVDiwVa6ljavkMZhSBNqwXLycmjwAJPDBlRt
X-Google-Smtp-Source: AGHT+IHnLAvAYVMeUCrvWX+OGgw8MZOc4aK6zXB4JRfdk4wx+uvFMgND4ssZpBnL7L9txXtPv9aDGw==
X-Received: by 2002:a05:6000:186c:b0:39f:9f:a177 with SMTP id ffacd0b85a97d-3a09fd88c00mr3664672f8f.17.1746404820907;
        Sun, 04 May 2025 17:27:00 -0700 (PDT)
Received: from precision ([2804:7f0:bc00:f1b9:dda:9d01:f4c5:2ed4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e150eb6e8sm42971925ad.26.2025.05.04.17.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 17:27:00 -0700 (PDT)
Date: Sun, 4 May 2025 21:25:21 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: smfrench@gmail.com, bharathsm.hsk@gmail.com, ematsumiya@suse.de,
	pc@manguebit.com, paul@darkrain42.org, ronniesahlberg@gmail.com,
	linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 1/5] cifs: protect cfid accesses with fid_lock
Message-ID: <aBgFcc9SPRPOUFHw@precision>
References: <20250502051517.10449-1-sprasad@microsoft.com>
 <aBS8jg4bcmh6EdwT@precision>
 <CANT5p=qGspYwczDEnp6oy6F1UQJZKJ9vYw_3pKdipcByqjjuTQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANT5p=qGspYwczDEnp6oy6F1UQJZKJ9vYw_3pKdipcByqjjuTQ@mail.gmail.com>

On Sat, May 03, 2025 at 08:24:13AM +0530, Shyam Prasad N wrote:
> On Fri, May 2, 2025 at 6:09 PM Henrique Carvalho
> <henrique.carvalho@suse.com> wrote:
> >
> > Hi Shyam,
> >
> > On Fri, May 02, 2025 at 05:13:40AM +0000, nspmangalore@gmail.com wrote:
> > > From: Shyam Prasad N <sprasad@microsoft.com>
> > >
> > > There are several accesses to cfid structure today without
> > > locking fid_lock. This can lead to race conditions that are
> > > hard to debug.
> > >
> > > With this change, I'm trying to make sure that accesses to cfid
> > > struct members happen with fid_lock held.
> > >
> > > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > > ---
> > >  fs/smb/client/cached_dir.c | 87 ++++++++++++++++++++++----------------
> > >  1 file changed, 50 insertions(+), 37 deletions(-)
> > >
> >
> > You are calling dput() here with a lock held, both in path_to_dentry and
> > in smb2_close_cached_fid. Is this correct?
> 
> Hi Henrique,
> Thanks for reviewing the patches.
> 
> Do you see any obvious problem with it?
> dput would call into VFS layer and might end up calling
> cifs_free_inode. But that does not take any of the competing locks.
> 

Hi Shyam,

Yes, dput() starts with might_sleep(), which means it may preemp (e.g.,
due to disk I/O), so it must not be called while holding a spinlock.

If you compile the kernel with CONFIG_DEBUG_ATOMIC_SLEEP=y you will see
this kind of stack dump.

[  305.667062][  T940] BUG: sleeping function called from invalid context at security/selinux/hooks.c:283
[  305.668291][  T940] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 940, name: ls
[  305.669199][  T940] preempt_count: 1, expected: 0
[  305.669493][  T940] RCU nest depth: 0, expected: 0
[  305.670092][  T940] 3 locks held by ls/940:
[  305.670362][  T940]  #0: ffff8881099b8f08 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x18a/0x1c0
[  305.671009][  T940]  #1: ffff88811c490158 (&type->i_mutex_dir_key#7){.+.+}-{4:4}, at: iterate_dir+0x85/0x270
[  305.671615][  T940]  #2: ffff88810cc620b0 (&cfid->fid_lock){+.+.}-{3:3}, at: open_cached_dir+0x1098/0x14a0 [cifs]
[ ... stack trace continues ... ]

> >
> > Also, the lock ordering here is lock(fid_lock) -> lock(cifs_tcp_ses_lock) ->
> > unlock(cifs_tcp_ses_lock) -> unlock(fid_lock), won't this blow up in
> > another path?
> 
> Can you please elaborate which code path will result in this lock ordering?

I was referring to the following pattern in cifs_laundromat_worker():

  spin_lock(&cfid->fid_lock);
  ...
  spin_lock(&cifs_tcp_ses_lock);
  spin_unlock(&cifs_tcp_ses_lock);
  ...
  spin_unlock(&cfid->fid_lock);

This was more of an open question. I am not certain this causes any issues,
and I could not find any concrete problem with it.

I brought it up because cifs_tcp_ses_lock is a more global lock than 
cfid->fid_lock.


Best,
Henrique
