Received: from matoro.tk (matoro.tk [104.188.251.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F382F46
	for <linux-cifs@vger.kernel.org>; Fri, 16 Aug 2024 03:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.188.251.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723780083; cv=none; b=q9PT6Uh8pKv72KIfQVo+wJ95wTEhE+9SzQWZzk7biyLNOq+efBKKpL5GpJkS1+T2ARRrOQXwrjTSH+UgKYIebIk963C1VU9Sbi0XfZEbmlh/rovDrHHs6qN4MHlzhl+NXBn0VfV11ZCOBVasvSRA12Fd20xApJlnLO4pHdVYz48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723780083; c=relaxed/simple;
	bh=uqXPoB64RzL6zLveqKuvZ/KWs4inoEAUwQQ5ry98qjs=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=qpSexFVkFD/vXF0K5BAFwRyXwWxg7EkijKThbj2cmms3HuH0HDTP2N8M9HQQrqzKPfD++QawLx4TGsGf1bhXPRORoZzOCKLHMulhbVbbf6gdYiSy74Kq+MZCho2PUVMYiCzS0/PQzdSAavnyHurmgZ5WSYpj4LpIA6RtDO3SeLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=matoro.tk; spf=pass smtp.mailfrom=matoro.tk; dkim=pass (4096-bit key) header.d=matoro.tk header.i=@matoro.tk header.b=Dt/xJc32; arc=none smtp.client-ip=104.188.251.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=matoro.tk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=matoro.tk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=matoro.tk header.i=@matoro.tk header.b="Dt/xJc32"
DKIM-Signature: a=rsa-sha256; bh=ajWDjxSHklbmIVsYso9MBc0/VKYOAUTTKiIqAQa3Omo=;
 c=relaxed/relaxed; d=matoro.tk;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:In-Reply-To:Message-Id:Message-Id:References:References:Autocrypt:Openpgp;
 i=@matoro.tk; s=20240626; t=1723780074; v=1; x=1724212074;
 b=Dt/xJc32+/TkHDFt7DPA+twReVU52U31+DGDfx/cIvFZde0JFYpdtWw9ASuZDw3ZQ3NIvtwH
 7WoCfRn+e20mHYlLcjTO6uc6K09mpudlPpBpAoItOysJ5WOFXsm/kS5sgbaB6VzcAJ0Nb23ddQI
 G8jQL/R7mGWxnGV69MrknOOJM/iDizPaTphSxyhonSS0CnH4JMF+cjQ1EzPYEma84luaEK9sTmB
 zfkwg3KmvwgoDImJLtyb5ywtSbz8/xRJnHZA2qody45/V57eqQBDiENUNVT1kxHstKHW8r/pH63
 M+EX3YYwuE0m+9HmT2lYUs6SknwquZOaGFH9A6y787BUCzs2ejF+d+tTIAGp9hVA2uZGyKNgUsI
 gxH6mSUTMrhSOnBLJrOQMwbvEAHU1UI70h/fG/YebZx1OkWXhToo/SOBcBS0Jxcwq2ns/PN7NzT
 a3lbFSmNWixocTm0guPlrrnGd0OHThcwyMCbWZG/39ac14qHhmndO0Pb7LcpLWu2rDe0DM37In7
 RpKt5jRdfG++a2VKqMeCOYQLMV6KIPx8z9PkR6hldMoP3BmTvNHXqyeGmQAFcvkSI/kbZimQX71
 CaoxBNIEXsRgKvxdKvkYP7bqcrzDJaCX3s0KjV6tKhYVnOgmt6vn+lIPEWeUjD697FdrMH/SdpS
 QC3Gu1gFGKs=
Received: by matoro.tk (envelope-sender
 <matoro_mailinglist_kernel@matoro.tk>) with ESMTPS id c03dc5c7; Thu, 15 Aug
 2024 23:47:54 -0400
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 15 Aug 2024 23:47:53 -0400
From: matoro <matoro_mailinglist_kernel@matoro.tk>
To: Steve French <smfrench@gmail.com>
Cc: Linux Cifs <linux-cifs@vger.kernel.org>, Bruno Haible <bruno@clisp.org>
Subject: Re: CIFS lockup regression on SMB1 in 6.10
In-Reply-To: <CAH2r5mta2N-hE=uJERWxz3w3hzDxwTpvhXsRhEM=sAzGaufsWw@mail.gmail.com>
References: <cca852e55291d5bb86ea646589b197d5@matoro.tk>
 <CAH2r5msAXgYs7=5D=YxGa8XohegJwpTn6yasVyZCmPmPt1QA9w@mail.gmail.com>
 <bf5a6d9797f33d256b9fffeb79014242@matoro.tk>
 <CAH2r5mta2N-hE=uJERWxz3w3hzDxwTpvhXsRhEM=sAzGaufsWw@mail.gmail.com>
Message-ID: <ec1664df9755a0fef8abf6b8f70ae6cf@matoro.tk>
X-Sender: matoro_mailinglist_kernel@matoro.tk
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit

On 2024-08-15 23:31, Steve French wrote:
> What is the simplest repro you have seen - e.g. is there a git tree
> with very small source that fails with configure that you could share?
> 
> On Thu, Aug 15, 2024 at 4:22 PM matoro
> <matoro_mailinglist_kernel@matoro.tk> wrote:
>> 
>> On 2024-08-15 15:37, Steve French wrote:
>> > Do you have any data on whether this still fails with current Linux
>> > kernel (6.11-rc3 e.g.)?
>> >
>> >
>> > On Thu, Aug 15, 2024 at 1:08 PM matoro
>> > <matoro_mailinglist_kernel@matoro.tk> wrote:
>> >>
>> >> Hi all, I run a service where user home directories are mounted over SMB1
>> >> with unix extensions.  After upgrading to kernel 6.10 it was reported to me
>> >> that users were observing lockups when performing compilations in their
>> >> home
>> >> directories.  I investigated and confirmed this to be the case.  It would
>> >> cause the build processes to get stuck in I/O.  After the lockup triggered
>> >> then all further reads/writes to the CIFS-mounted directory would get
>> >> stuck.
>> >> Even the df(1) command would block indefinitely.  Shutdown was also
>> >> prevented
>> >> as the directory could no longer be unmounted.
>> >>
>> >> Triggering the issue is a little bit tricky.  I used compiling cpython as a
>> >> test case.  Parallel compilation does not seem to be required to trigger
>> >> it,
>> >> because in some tests the hang would occur during ./configure phase, but it
>> >> does seem to provoke it more easily, as the most common point where the
>> >> lockup was observed was immediately after "make -j4".  However, sometimes
>> >> it
>> >> would take 10+ minutes of ongoing compilation before the lockup would
>> >> trigger.  I never observed a complete successful compilation on kernel
>> >> 6.10.
>> >>
>> >> The furthest back I was able to confirm that the lockup is observed was
>> >> v6.10-rc3.  The furthest forward I was able to confirm is good was v6.9.9
>> >> in
>> >> the stable tree.  Unfortunately, between those two tags there seems to be a
>> >> wide range of commits where the CIFS functionality is completely broken,
>> >> and
>> >> reads/writes return total nonsense results.  For example, any git commands
>> >> return "git error: bad signature 0x00000000".  So I cannot execute a
>> >> compilation on commits in this range in order to test whether they observe
>> >> the lockup issue.  Therefore I wasn't able to test most of the range, and
>> >> wasn't able to complete a traditional bisect.  I tried adjusting the
>> >> read/write buffers down to 8192 from the defaults, but this did not help.
>> >> I
>> >> also tried toggling several options that might be related, namely
>> >> CONFIG_FSCACHE, to no effect.  There are no logs emitted to dmesg when the
>> >> lockup occurs.
>> >>
>> >> Thanks - please let me know if there is any further information I can
>> >> provide.  For now I am rolling all hosts back to kernel 6.9.
>> >>
>> >
>> >
>> > --
>> > Thanks,
>> >
>> > Steve
>> 
>> Hi Steve, just tested.  Not only is it still there in 6.11-rc3, but it's 
>> much
>> worse - I got an immediate lockup just from ./configure
>> 
>> Thank you for looking at this.

I've been using the cpython source to test, 
https://github.com/python/cpython.  Just a plain ./configure and make -j4.  
But it seems to affect any substantial build process, I was also able to 
trigger it with coreutils build, really anything that generates I/O load.

Here's what my effective mount options look like:
type cifs 
(rw,nosuid,relatime,vers=1.0,cache=strict,username=nobody,uid=30000,forceuid,gid=30000,forcegid,addr=fd05:0000:0000:0000:0000:0000:0000:0001,soft,unix,posixpaths,serverino,mapposix,acl,reparse=nfs,rsize=1048576,wsize=65536,bsize=1048576,retrans=1,echo_interval=60,actimeo=1,closetimeo=1)
