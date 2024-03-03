Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32747566D
	for <linux-cifs@vger.kernel.org>; Sun,  3 Mar 2024 05:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709442545; cv=none; b=Xe8vrvLjDIavtxSX8MfMf1NgB5L9Teef2sZ7jsGcOi9FQ0kJIAJfo4vIQymIASV3xcGYBlhYQAQvP2mUDP0FD4078ErW8wW8RO87WGIYW2s/8qz02rRfuAGa6GYEA3lKDpOWCrbj8tX0i0G7C/hzqpeA9J+CXDzY/A5ooGdJq7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709442545; c=relaxed/simple;
	bh=l8gGo5ufDURZHmdvzVjci3F2EHTlOcDdHG1mCj3W+XI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OqCISI8ouCh+H9O+3yppiNjX0xJAtUmEcpQu7cQPEKQz2XXzMQefgpAId0VJAU6uwGCpu6aiMP5MQM+GHnZQP6kSdAnQvvd4HqBp8bYn+xX5llaXbF0oHp/ukAE852qyQLsw+YyxiskcLIzVjdA5F9Kq6m+TdLyHbzEcdnsMqFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VT4JcVri; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VT4JcVri"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709442543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JjpbPJcNRbSanMTpfhHKtMnGxhnRcTaRo2vwe3NOWtk=;
	b=VT4JcVriMupppZHHqJi7bcJAN9OGMInJdhFtMWAx/jXZb3h7NLgTje97jOi3mGT4ux0kW7
	O9xI/q00PIm51D+nfMUoSKAzDR4c442boqZcrs0FkBOGyq6/NGXmuFHZvjnX9rnCJTFhpM
	5Q2QC4RowoeVH6AsTuyiVAFGDlEgMOg=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-41-Do16E8vpPqybUsyW6eaHUg-1; Sun, 03 Mar 2024 00:08:59 -0500
X-MC-Unique: Do16E8vpPqybUsyW6eaHUg-1
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3c18df0db21so6465855b6e.3
        for <linux-cifs@vger.kernel.org>; Sat, 02 Mar 2024 21:08:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709442539; x=1710047339;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JjpbPJcNRbSanMTpfhHKtMnGxhnRcTaRo2vwe3NOWtk=;
        b=UArm3rmQGl18HZgKUBKnuIPJ9HJBt97UsMVrvniwzr6RlAVCT5AhUXfv40Bqqj0dnd
         lgvo+3ZRe+xFDHfrrct9C+2p7Wut0MKfujkxJIN0A3UG3sxmbPpTc7DwpcbRaCnhpksi
         ATxOUd83iSrzPNc3sP+BlPnlYeuh9k7tq6Z4cO9FNFYWPqmeIaVukBYkmZnxr0ott1Qz
         xiXZLnRPw1qL3e3hRVKgt2TztRgYZ8EjUkfKaAdRfUaqjDxwRrDIhCMEbZE4mgFhoRuM
         +rbV4KcmesX9oErs7t5h461CPlT7g815I9fGYsvcIWZIl9XS9pEUXqZsYO8yCsqKCDAv
         h5Ew==
X-Forwarded-Encrypted: i=1; AJvYcCXV1p/zH54090yM6kULkR48ZceWb891mUgoetp70sUBzcIVjxpTzdHZLAl/bWqWVOgGk05a7MyvoiLmT3sv7M9clKyI8LK+jtSH0g==
X-Gm-Message-State: AOJu0YyvTjSVZpYh4xAvmJfLCNsihaey/UGRHrYZNLIdGYAwq6arIdFW
	NEPUE3w8cm1oeIs4jhG3Komdy5IPzC/mcA1zYrywfOFftQQaSxf+Y/KnTa8/AcfpeFUd667tpxa
	WiD0gHBH4fhK/SAV2VYC0UMYkGWTmBHZWmfWa6MzZ46Kgd6o6nHccZwWxtbs=
X-Received: by 2002:a54:4388:0:b0:3c1:e835:3f8a with SMTP id u8-20020a544388000000b003c1e8353f8amr2050892oiv.39.1709442538714;
        Sat, 02 Mar 2024 21:08:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHjv5iSXFkzoq34jTrZUzYGVoxQrDPBhk2ZX6DFNrWuKHpObbhXi7qJfeoIgV8G5L/hrfVcZA==
X-Received: by 2002:a54:4388:0:b0:3c1:e835:3f8a with SMTP id u8-20020a544388000000b003c1e8353f8amr2050878oiv.39.1709442538325;
        Sat, 02 Mar 2024 21:08:58 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id v8-20020a17090a458800b0029af67d4fd0sm5526321pjg.44.2024.03.02.21.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Mar 2024 21:08:57 -0800 (PST)
Date: Sun, 3 Mar 2024 13:08:53 +0800
From: Zorro Lang <zlang@redhat.com>
To: Paulo Alcantara <pc@manguebit.com>,
	Alexander Aring <aahringo@redhat.com>
Cc: Steve French <smfrench@gmail.com>, fstests@vger.kernel.org,
	gfs2@lists.linux.dev, jlayton@kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCHv2] generic: add fcntl corner cases tests
Message-ID: <20240303050853.f7wslqfkkgdfv37i@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20230925201827.1703857-1-aahringo@redhat.com>
 <20240209052631.wfbjveicfosubwns@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAH2r5msWwX7QdXrzmR3tapU85WMga9Y-waNOHm+hMWmWPUF=tQ@mail.gmail.com>
 <20240209114310.c4ny2dptikr24wx5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240301103835.gylf2lzud2azgvx7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAK-6q+jZVfK2=Z6RCCU+K+TLYuHgC4ynqOBz3K-nhcypCoN3ww@mail.gmail.com>
 <a5eb6c3a2de1b959117d49c436b81904@manguebit.com>
 <CAK-6q+isU4cQN6OV_bLmoKwULsisAUpkAZA+c6SRgOCk8Z9T=g@mail.gmail.com>
 <a6806fcca760e734f272596cafc2390f@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a6806fcca760e734f272596cafc2390f@manguebit.com>

On Fri, Mar 01, 2024 at 08:59:01PM -0300, Paulo Alcantara wrote:
> Alexander Aring <aahringo@redhat.com> writes:
> 
> > Hi,
> >
> > On Fri, Mar 1, 2024 at 11:25 AM Paulo Alcantara <pc@manguebit.com> wrote:
> >>
> >> Hi Zorro,
> >>
> >> The problem is that cifs.ko is returning -EACCES from fcntl(2) called
> >> in do_test_equal_file_lock() but it is expecting -EAGAIN to be
> >> returned, so it hangs in wait4(2):
> >>
> >> ...
> >> [pid 14846] fcntl(3, F_SETLK, {l_type=F_WRLCK, l_whence=SEEK_SET, l_start=0, l_len=1}) = -1 EACCES (Permission denied)
> >> [pid 14846] wait4(-1,
> >>
> >> The man page says:
> >>
> >>       F_SETLK (struct flock *)
> >>               Acquire a lock (when l_type is F_RDLCK or F_WRLCK) or release  a
> >>               lock  (when  l_type  is  F_UNLCK)  on the bytes specified by the
> >>               l_whence, l_start, and l_len fields of lock.  If  a  conflicting
> >>               lock  is  held by another process, this call returns -1 and sets
> >>               errno to EACCES or EAGAIN.  (The error  returned  in  this  case
> >>               differs across implementations, so POSIX requires a portable ap‐
> >>               plication to check for both errors.)
> >>
> >> so fcntl_lock_corner_tests should also handle -EACCES.
> >>
> >
> > yes, that is a bug in the test but in my opinion there is still an
> > issue. The mentioned fcntl(F_SETLK) above is just a sanity check to
> > print out if something is not correct and it will print out that
> > something is not correct and fails.
> 
> Yes, I agree it might be a cifs.ko issue.  However, it's still important
> making sure that the test exits gracefully and then report an error
> rather than hanging.

Thanks for all of you look into it!

If the C program can deal with issue (report error rather than hang),
that would be good. Or how about give the fcntl testing process a (long enough)
timeout number, to avoid it block the whole fstests test running, and report
error if it exits unnormally.

Thanks,
Zorro

> 
> > The problem is that wait() below, the child processes are not
> > returning and are in a blocking state which should not be the case.
> >
> > What the test is doing is the following:
> >
> > parent:
> >
> > 1. lock(A) # should be successful to acquire
> 
> Client successfully acquires it.
> 
> > child:
> > thread0:
> > 2. lock(A) # should block
> > thread1:
> > 3. lock(A) # should block
> 
> OK - both threads are blocked.
> 
> > parent:
> >
> > 5. sleep(3) #wait until child are in blocking state of lock(A)
> 
> OK.
> 
> > 5. unlock(A) # both threads of the child should unlock and exit
> 
> At this point, both threads are woken up and one of them acquires the
> lock and returns.  The other thread gets blocked again because it finds
> a conflicting lock that was taken from the other thread.  The child then
> never exits because it is waiting in pthread_join().
> 
> > 6. sleep 3 # wait for pending unlock op (not really sure if it's necessary)
> > ...
> > 7. trylock(A) # mentioned sanity check
> 
> Client returns -EACCES because one of the child threads acquired the
> lock.
> 
> > The unlock(A) should unblock the child threads, it is important to
> > mention that this test does a lock corner test and the lock(A) in both
> > threads ends in a ->lock() call with a "struct file_lock" that has
> > mostly the same fields. We had issues with that in gfs2 and a lookup
> > function to find the right request with an async complete handler of
> > the lock operation.
> 
> Alex, thanks for the explanation!  As we've talked, there might be a
> missing check of fl_owner or some sort of protocol limitation while
> checking for lock conflicts.
> 
> Steve, any thoughts on this?
> 

