Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26712AEE7;
	Tue, 10 Dec 2024 09:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733822193; cv=none; b=AeQpqNftd3gXpPQgjz0Yg/OGXlL0EqTJRGR0rPdSs7F813pWx/H3lVUT+4czoJzjMAtERIRL3CbhFZ2udYYLy4OsvE9BDi+1m8xwG8nQdpjvwjWeL8tnoGCKkpZhhpsI2uUxzVGmAh4xIKva84sbc0y7hTqqn9ew4V8Dza4qYIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733822193; c=relaxed/simple;
	bh=3j2918O/ojWB2Bu48Eq+ABh9KcTYw2UFeAdnGpbUSqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NT//oBwMkuajS+/lkL5VskGJ5oH4SxDjnL3LwyboK0VuPCm8QaT3vVO0+Zk7/PNrjoIHxe1oSMHg/ixIWp3rw/GJb3GjmMNuSS7ENq0nXISEZPeKN6R4GkYI6U9tva2EQKkjYrstI48Zf0vkZY+gdzfvKH1vO3KQkn0dNPCWaJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XAFXyR2Z; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XAFXyR2Z"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-aa66ead88b3so469311266b.0;
        Tue, 10 Dec 2024 01:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733822190; x=1734426990; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lfq86kEzdTDdJEob5VUfgeLkC76+wSbSmEQOfsXHbzY=;
        b=XAFXyR2Z6pNO2pMOB+gPu5VHmLpytLqLpduhRvimf0yobXRDtasbinA7mEsohbsCFN
         tgw/1aIcxZAPAfXAw79m1gungY0s1b3mG89WC1yggEEqzrJu6dHQHLBL2ubQo4gO0eed
         FSb4HK3u7C3y273UtFrW9fFUCrorSsAoj644hWCF2DYW2Fs/n26/8cj60GXc+2pORbTd
         Qw37ThUHyyAWRtmSXQmIQYyaAK/Jbw147BRJie74ZCK504pUKdzYZlbRQuwXijxJOKnt
         qouUe9J5HCDjGrkUMkFQACnAH50SBrTTos+mJoX5VCHymFLOWG3rcFynKviFSxIRYzQM
         J+qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733822190; x=1734426990;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lfq86kEzdTDdJEob5VUfgeLkC76+wSbSmEQOfsXHbzY=;
        b=C4f1XroDY0u19VL4pQxDT85PS53tQ1vWpGRagCNCpDY7LcmH/82q7TNoQalM4T0hPS
         LMXjl6VhivVYbG+iA2U8UKygznotuexLTv+l/R3claisHHZjcHxNKTLlUw6ihu3fA9x5
         44kP/mYQvridPwjwVMtPT7tEGFyvUf7AZdZPkVpgWlUXNlArT6b5rzbKPyN70mLuK9ta
         JqPsQeboEzRByBrBjWX7oE2UbjXzdBbMOWAe08XmcCqc/kOMxHnNEM4ndIcJSFtzVEyX
         tLDz2G4/d+xKG3CBB8EtxrkX8Cp4MaHK6R8FRMkk5/RJ2wGySGQg6P70YXELhR9scdm2
         3J3g==
X-Forwarded-Encrypted: i=1; AJvYcCVTmYCodU1R5DY4UgZ66fTGsB0+mhB5/y5tLNBycfzQ9PKA3Y11xsXuwIqa7ZiReOch2/GIXgAC@vger.kernel.org, AJvYcCXQoDg8zNfxOl6YXHugjAyylr1GzhSNVJdNgZIXegkX+Mx7te3MenkSKtVdWRjhjsQTHS8gKqhdBQi+@vger.kernel.org
X-Gm-Message-State: AOJu0YxZegT6P23BZLQ53NAZNHoztoXmIskyKiP9muwEQRLnmO/+oN8r
	e7/vXnnvvkH0o9KK+/NIHs/tP+hd/5Kmw0SKStHa2O2UP4Rb/EAV
X-Gm-Gg: ASbGncsv9JsZubvF0CEeyq1FN46YvSFTaN53GOB1k5zeXoYa8mZrVOIKAR7KA45oEYn
	wuvo2uEl08Hbmm+iW1mGs33YExZPbVR6MaewGVlh8adKelRP2RRQaQL2bcw+erIABxlq+8k/S9X
	teDn3L3YK24LEISg1IQe/1+qQln7xUrmdQi9QDvrD5FsARfu4uCqe3pg9tO9jOKVLgiQq49CC/t
	4NOc7skwlQ+py35q8Du5gf81z37RQv0zSSxWpTrjdOhHMQOupkYsM7gK2VCE5ZMEEsGW4Ef8miZ
	oNNd9d1IhBJ8WQ==
X-Google-Smtp-Source: AGHT+IEKU3lSElcNaqpwWm31hD9rrWvnyw0r23qxGJX95m6SYT+eLg5pz5VSqpGedQUEDyYf3Xjzdw==
X-Received: by 2002:a17:907:ca0a:b0:aa6:816f:2b40 with SMTP id a640c23a62f3a-aa69ce6b99dmr342867766b.38.1733822189732;
        Tue, 10 Dec 2024 01:16:29 -0800 (PST)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa6808c03a5sm333841366b.137.2024.12.10.01.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 01:16:29 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 3BE79BE2EE7; Tue, 10 Dec 2024 10:16:28 +0100 (CET)
Date: Tue, 10 Dec 2024 10:16:28 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Michael Krause <mk@galax.is>, Paulo Alcantara <pc@manguebit.com>,
	Michael Krause <mk-debian@galax.is>,
	Steve French <stfrench@microsoft.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, linux-cifs@vger.kernel.org
Subject: Re: backporting 24a9799aa8ef ("smb: client: fix UAF in
 smb2_reconnect_server()") to older stable series
Message-ID: <Z1gG7JZmxu_qnbPZ@eldamar.lan>
References: <2024040834-magazine-audience-8aa4@gregkh>
 <Z0rZFrZ0Cz3LJEbI@eldamar.lan>
 <2e1ad828-24b3-488d-881e-69232c8c6062@galax.is>
 <1037557ef401a66691a4b1e765eec2e2@manguebit.com>
 <Z08ZdhIQeqHDHvqu@eldamar.lan>
 <3441d88b-92e6-4f89-83a4-9230c8701d73@galax.is>
 <2024121030-opt-escapist-fdc5@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024121030-opt-escapist-fdc5@gregkh>

Hi Greg,

On Tue, Dec 10, 2024 at 09:51:58AM +0100, Greg KH wrote:
> On Tue, Dec 10, 2024 at 12:05:00AM +0100, Michael Krause wrote:
> > On 12/3/24 3:45 PM, Salvatore Bonaccorso wrote:
> > > Paulo,
> > > 
> > > On Tue, Dec 03, 2024 at 10:18:25AM -0300, Paulo Alcantara wrote:
> > > > Michael Krause <mk-debian@galax.is> writes:
> > > > 
> > > > > On 11/30/24 10:21 AM, Salvatore Bonaccorso wrote:
> > > > > > Michael, did a manual backport of 24a9799aa8ef ("smb: client: fix UAF
> > > > > > in smb2_reconnect_server()") which seems in fact to solve the issue.
> > > > > > 
> > > > > > Michael, can you please post your backport here for review from Paulo
> > > > > > and Steve?
> > > > > 
> > > > > Of course, attached.
> > > > > 
> > > > > Now I really hope I didn't screw it up :)
> > > > 
> > > > LGTM.  Thanks Michael for the backport.
> > > 
> > > Thanks a lot for the review. So to get it accepted it needs to be
> > > brough into the form which Greg can pick up. Michael can you do that
> > > and add your Signed-off line accordingly?
> > Happy to. Hope this is in the proper format:
> > 
> > 
> > 
> > 
> > From 411fb6398fe3c3c08a000d717bff189f08d2041c Mon Sep 17 00:00:00 2001
> > From: Paulo Alcantara <pc@manguebit.com>
> > Date: Mon, 1 Apr 2024 14:13:10 -0300
> > Subject: [PATCH] smb: client: fix UAF in smb2_reconnect_server()
> > 
> > commit 24a9799aa8efecd0eb55a75e35f9d8e6400063aa upstream.
> > 
> > The UAF bug is due to smb2_reconnect_server() accessing a session that
> > is already being teared down by another thread that is executing
> > __cifs_put_smb_ses().  This can happen when (a) the client has
> > connection to the server but no session or (b) another thread ends up
> > setting @ses->ses_status again to something different than
> > SES_EXITING.
> > 
> > To fix this, we need to make sure to unconditionally set
> > @ses->ses_status to SES_EXITING and prevent any other threads from
> > setting a new status while we're still tearing it down.
> > 
> > The following can be reproduced by adding some delay to right after
> > the ipc is freed in __cifs_put_smb_ses() - which will give
> > smb2_reconnect_server() worker a chance to run and then accessing
> > @ses->ipc:
> > 
> > kinit ...
> > mount.cifs //srv/share /mnt/1 -o sec=krb5,nohandlecache,echo_interval=10
> > [disconnect srv]
> > ls /mnt/1 &>/dev/null
> > sleep 30
> > kdestroy
> > [reconnect srv]
> > sleep 10
> > umount /mnt/1
> > ...
> > CIFS: VFS: Verify user has a krb5 ticket and keyutils is installed
> > CIFS: VFS: \\srv Send error in SessSetup = -126
> > CIFS: VFS: Verify user has a krb5 ticket and keyutils is installed
> > CIFS: VFS: \\srv Send error in SessSetup = -126
> > general protection fault, probably for non-canonical address
> > 0x6b6b6b6b6b6b6b6b: 0000 [#1] PREEMPT SMP NOPTI
> > CPU: 3 PID: 50 Comm: kworker/3:1 Not tainted 6.9.0-rc2 #1
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-1.fc39
> > 04/01/2014
> > Workqueue: cifsiod smb2_reconnect_server [cifs]
> > RIP: 0010:__list_del_entry_valid_or_report+0x33/0xf0
> > Code: 4f 08 48 85 d2 74 42 48 85 c9 74 59 48 b8 00 01 00 00 00 00 ad
> > de 48 39 c2 74 61 48 b8 22 01 00 00 00 00 74 69 <48> 8b 01 48 39 f8 75
> > 7b 48 8b 72 08 48 39 c6 0f 85 88 00 00 00 b8
> > RSP: 0018:ffffc900001bfd70 EFLAGS: 00010a83
> > RAX: dead000000000122 RBX: ffff88810da53838 RCX: 6b6b6b6b6b6b6b6b
> > RDX: 6b6b6b6b6b6b6b6b RSI: ffffffffc02f6878 RDI: ffff88810da53800
> > RBP: ffff88810da53800 R08: 0000000000000001 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000001 R12: ffff88810c064000
> > R13: 0000000000000001 R14: ffff88810c064000 R15: ffff8881039cc000
> > FS: 0000000000000000(0000) GS:ffff888157c00000(0000)
> > knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007fe3728b1000 CR3: 000000010caa4000 CR4: 0000000000750ef0
> > PKRU: 55555554
> > Call Trace:
> >  <TASK>
> >  ? die_addr+0x36/0x90
> >  ? exc_general_protection+0x1c1/0x3f0
> >  ? asm_exc_general_protection+0x26/0x30
> >  ? __list_del_entry_valid_or_report+0x33/0xf0
> >  __cifs_put_smb_ses+0x1ae/0x500 [cifs]
> >  smb2_reconnect_server+0x4ed/0x710 [cifs]
> >  process_one_work+0x205/0x6b0
> >  worker_thread+0x191/0x360
> >  ? __pfx_worker_thread+0x10/0x10
> >  kthread+0xe2/0x110
> >  ? __pfx_kthread+0x10/0x10
> >  ret_from_fork+0x34/0x50
> >  ? __pfx_kthread+0x10/0x10
> >  ret_from_fork_asm+0x1a/0x30
> >  </TASK>
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> > Signed-off-by: Steve French <stfrench@microsoft.com>
> > [Michael Krause: Naive, manual merge because the 3rd hunk would not
> >                  apply]
> > Signed-off-by: Michael Krause <mk-debian@galax.is>
> > ---
> >  fs/smb/client/connect.c | 80 ++++++++++++++++++-----------------------
> >  1 file changed, 35 insertions(+), 45 deletions(-)
> 
> What kernel(s) is this commit supposed to be for?

6.1.y (at least, possibly older, but the reporter did test on 6.1.y
for Debian, context from https://bugs.debian.org/1088733). Upper
stable series have already the commit in 6.6.29, 6.8.5.

Regards,
Salvatore
