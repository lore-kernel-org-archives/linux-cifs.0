Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143C85EE9F;
	Fri,  1 Mar 2024 23:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709337548; cv=pass; b=GOo9+ca/+vy7bpFU1cyoz5ZOrpBoLq14WUi+iYm6B+0l58Y/emVVl39EddV8/azVUy2HIcL2D8JKbPLV+6zYfwJkx4aibIjyUYCS9BtRgUWQr9s2xCtvDHDsNqk0iuLenVgjQzgg/HJBpMU6g3ZJ3CWGFajYCb9dvHtEEfF8aQc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709337548; c=relaxed/simple;
	bh=b7iGs5UorpFBfMmXzHrE0vl1I1RNOESfi7LLrC2VNzw=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=nbjVwtztCIuiLaT+CL+eUJxILvwKdzhDnLS6xSQrUDWTMQcjFnl7dUbXZRiq4Ooi6sTBI+y5EVc7l5vpftS7hfoGqGbWPrN64SwCuqRPgiDSDBn+42Mtes874YXOaXiQ25LUZIDKXGuV1LBoNtvwuFmd/SFc4T6iErdxa7ESbRM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=e34oTyxS; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="e34oTyxS"
Message-ID: <a6806fcca760e734f272596cafc2390f@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1709337544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zEyMTCFAs1SAtQhp69C4mqxLGhIQmOhVu8yX2dqx08w=;
	b=e34oTyxSeSwdOxCSVZlNeKVqsNK37tDLXfoiHZgL01UCDYXiKPRqwTqfJLA6I6xcBnxcap
	cpsJxAPN+3elV00/xPETMxNdye4pnFQvHVxmkNOgb8s7zQXdxYdUHYGSyqp69KUneYauzE
	WXCKNStlwStctYXpxWJE9GAh7vLZN6wuZy3i/4YpUNRySk0KvJKyV/SK1q/VdQyjUOnJEd
	TB6IZtNDZ48a4bx7Shck8D6HZqxLQsEBOF99CVE6pUKWrKVriqCtd9j9tkGx+z023/OMp7
	YFs9DKuiyz4N4EFyV0LXEzPVOmHk0+RsQ+nd8SjvRk27/Q8VC+AL6tpMzMHfow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1709337544; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zEyMTCFAs1SAtQhp69C4mqxLGhIQmOhVu8yX2dqx08w=;
	b=Tn9/jmag78+KmofTDsIgrAXw1vG7qqHIOJ0SDwWX3pcpY/HZf8HXqMkQDxbDhuG0h35GZZ
	binYKr13F/qdlsIX+7fUo3qvS65f+qadfMvlGcASzDbS/f9n8H7mgc1G9aa3+1OtuPBooS
	/5t7Ara9CW4bDe2J/UJBWe52aEaOSmihlqH/Hy5oC9MTKF2Uhc2wyAFK2ZM2+EdA2ufAbG
	6lYtAWEZlg+lHjkpyYOenBpEeleOWQQMIFdEEFZoHSPDAO1eqewqvDaPUsqnXnxOnvMD2r
	boka9+X575SbSPA3m5qp11wL4l2GxzGsxAo3zMpAv9FqEedms0WN7WJemItu0w==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1709337544; a=rsa-sha256;
	cv=none;
	b=GlnKQwA9XwFvGaPOONT/gkPLnx2Z0nVKdu/DIAMcBYaLe23Z0dgx71g53k1GEox18InTiN
	1e7w1bNRhgJQ7H7dsPB8cc2vsiXi1Iglc7ZB3RKc0cwVl6xZ8YVHU5DKnyzA+uZj+cqFUh
	jZCXjIZR19qvFGsMdkjn0e7ReTtE7CTqiZG4m2GBGUz/6CSKCqS0Gi8Isqo0uIDfb/97I0
	+9KB+9z1HLeXWIzXaAwh7mILirRyMgY2Irae5Wt9BAWOkuLeLmzbQjHTtY+H5B+wD9htfH
	a9pIuj3tdq6Rd5gsepykaJhRPh1l/MSkfTwkSS8jPqHruJN9EbP8MYtdaax2Og==
From: Paulo Alcantara <pc@manguebit.com>
To: Alexander Aring <aahringo@redhat.com>, Steve French <smfrench@gmail.com>
Cc: Zorro Lang <zlang@kernel.org>, Zorro Lang <zlang@redhat.com>,
 fstests@vger.kernel.org, gfs2@lists.linux.dev, jlayton@kernel.org,
 linux-cifs@vger.kernel.org
Subject: Re: [PATCHv2] generic: add fcntl corner cases tests
In-Reply-To: <CAK-6q+isU4cQN6OV_bLmoKwULsisAUpkAZA+c6SRgOCk8Z9T=g@mail.gmail.com>
References: <20230925201827.1703857-1-aahringo@redhat.com>
 <20240209052631.wfbjveicfosubwns@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAH2r5msWwX7QdXrzmR3tapU85WMga9Y-waNOHm+hMWmWPUF=tQ@mail.gmail.com>
 <20240209114310.c4ny2dptikr24wx5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240301103835.gylf2lzud2azgvx7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAK-6q+jZVfK2=Z6RCCU+K+TLYuHgC4ynqOBz3K-nhcypCoN3ww@mail.gmail.com>
 <a5eb6c3a2de1b959117d49c436b81904@manguebit.com>
 <CAK-6q+isU4cQN6OV_bLmoKwULsisAUpkAZA+c6SRgOCk8Z9T=g@mail.gmail.com>
Date: Fri, 01 Mar 2024 20:59:01 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Alexander Aring <aahringo@redhat.com> writes:

> Hi,
>
> On Fri, Mar 1, 2024 at 11:25=E2=80=AFAM Paulo Alcantara <pc@manguebit.com=
> wrote:
>>
>> Hi Zorro,
>>
>> The problem is that cifs.ko is returning -EACCES from fcntl(2) called
>> in do_test_equal_file_lock() but it is expecting -EAGAIN to be
>> returned, so it hangs in wait4(2):
>>
>> ...
>> [pid 14846] fcntl(3, F_SETLK, {l_type=3DF_WRLCK, l_whence=3DSEEK_SET, l_=
start=3D0, l_len=3D1}) =3D -1 EACCES (Permission denied)
>> [pid 14846] wait4(-1,
>>
>> The man page says:
>>
>>       F_SETLK (struct flock *)
>>               Acquire a lock (when l_type is F_RDLCK or F_WRLCK) or rele=
ase  a
>>               lock  (when  l_type  is  F_UNLCK)  on the bytes specified =
by the
>>               l_whence, l_start, and l_len fields of lock.  If  a  confl=
icting
>>               lock  is  held by another process, this call returns -1 an=
d sets
>>               errno to EACCES or EAGAIN.  (The error  returned  in  this=
  case
>>               differs across implementations, so POSIX requires a portab=
le ap=E2=80=90
>>               plication to check for both errors.)
>>
>> so fcntl_lock_corner_tests should also handle -EACCES.
>>
>
> yes, that is a bug in the test but in my opinion there is still an
> issue. The mentioned fcntl(F_SETLK) above is just a sanity check to
> print out if something is not correct and it will print out that
> something is not correct and fails.

Yes, I agree it might be a cifs.ko issue.  However, it's still important
making sure that the test exits gracefully and then report an error
rather than hanging.

> The problem is that wait() below, the child processes are not
> returning and are in a blocking state which should not be the case.
>
> What the test is doing is the following:
>
> parent:
>
> 1. lock(A) # should be successful to acquire

Client successfully acquires it.

> child:
> thread0:
> 2. lock(A) # should block
> thread1:
> 3. lock(A) # should block

OK - both threads are blocked.

> parent:
>
> 5. sleep(3) #wait until child are in blocking state of lock(A)

OK.

> 5. unlock(A) # both threads of the child should unlock and exit

At this point, both threads are woken up and one of them acquires the
lock and returns.  The other thread gets blocked again because it finds
a conflicting lock that was taken from the other thread.  The child then
never exits because it is waiting in pthread_join().

> 6. sleep 3 # wait for pending unlock op (not really sure if it's necessar=
y)
> ...
> 7. trylock(A) # mentioned sanity check

Client returns -EACCES because one of the child threads acquired the
lock.

> The unlock(A) should unblock the child threads, it is important to
> mention that this test does a lock corner test and the lock(A) in both
> threads ends in a ->lock() call with a "struct file_lock" that has
> mostly the same fields. We had issues with that in gfs2 and a lookup
> function to find the right request with an async complete handler of
> the lock operation.

Alex, thanks for the explanation!  As we've talked, there might be a
missing check of fl_owner or some sort of protocol limitation while
checking for lock conflicts.

Steve, any thoughts on this?
