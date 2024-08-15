Received: from matoro.tk (matoro.tk [104.188.251.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC4014EC79
	for <linux-cifs@vger.kernel.org>; Thu, 15 Aug 2024 21:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.188.251.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723756969; cv=none; b=c+Vezlm03TQgpePKoLvsz3I4n43MRIJJgYoRfQVe/bp3xwY6ouRjV5Iw0OnOrjEQLqqLs8QegKumh0aq+ceoWJMvB1liDjqatzER2KbdKrtB6pBKRMNPw8YddKEvXHzuauqgvkrtgxfxGPWl3SVmhtIabS7W9p6XYttv4Hpkqac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723756969; c=relaxed/simple;
	bh=mQPbvyykuhfejo/1gNOCIkuv1gyckiyUfU+nkSGhUHo=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=KST6hvUaXgYWaI+jZzYXZULR5XXW/Ouiu/YQjv1aj3QIob/MicsKuAncMCfrOkQrJFDR+eEUJa7A7WOuDGrYbFwNrjzYFdqDU64/EVPCEt1kJOMR0W9TW6xBrvLSGokaPIJ6WxJSMi+6ew784vi3/TcAjUoyD4RnpY79uLQ/Ieo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=matoro.tk; spf=pass smtp.mailfrom=matoro.tk; dkim=pass (4096-bit key) header.d=matoro.tk header.i=@matoro.tk header.b=BTP+n6ag; arc=none smtp.client-ip=104.188.251.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=matoro.tk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=matoro.tk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=matoro.tk header.i=@matoro.tk header.b="BTP+n6ag"
DKIM-Signature: a=rsa-sha256; bh=oXB8ffYnesT3lULm6F82rWZFuHFzu+2K+CyeDKZPysw=;
 c=relaxed/relaxed; d=matoro.tk;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:In-Reply-To:Message-Id:Message-Id:References:References:Autocrypt:Openpgp;
 i=@matoro.tk; s=20240626; t=1723756959; v=1; x=1724188959;
 b=BTP+n6agOr/FyPCx/5oT87vESuQ+kXIzJQ3MPQrTWNp6gDUZb+yorKV8N/BPEjQ+KNCBnriX
 u1Kxu6UlJbYQyb0eqrqbkpCBWX7Dn8z5PinBIVAnXwTOkr+vJocwhj7QY+iohZC69VXkYWGba4s
 e6fRvVMKe9N6ezmmIxo02vzh08DA0FiFfyiVd4pNI4IQtz+pVKT55candGNJjIEd4qD189mmpBK
 4MSWwkbISJndU6pDdpMfYdR5NyKkY8WwDH3wMgHKvBjL6UIb5bZHFtO99LRhY/18OTDb6Om1vDX
 N3sFDNqZOv+Jczc3U/uiMKPowwjQ9+VPEv577bHKIpua3Weq8NIwlNyETqIBjNbukUgxldP2ztz
 tjD0Yo6TKsk/JzJmDQT6EjEz4pc1VLkKinKzvEpsizi0sX0e3HS2XeXDTt8w8i6BxQTj2G8SogN
 5ZPKLhVz5UFlxYRMV4RsDlMCgk39TV26WXx62BsiyYViivexejFCjfgLf2H+1u2/C4qIGGsS/dN
 4hVB48gPbKJ8BVqrGHV3WthjipFeoQAnjr8OFHWU0C3zcxIycpks69hY09xweoO4LtFQzEBQXfG
 TyLpfXQ1RyXqKhTXjAHnKZb/QN4giZ/S9fqFnu2VBuknr5IDb6at3kltsda77CbGFeC7pNNzuSN
 75dCEuGoDGA=
Received: by matoro.tk (envelope-sender
 <matoro_mailinglist_kernel@matoro.tk>) with ESMTPS id 2581e8c7; Thu, 15 Aug
 2024 17:22:39 -0400
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 15 Aug 2024 17:22:39 -0400
From: matoro <matoro_mailinglist_kernel@matoro.tk>
To: Steve French <smfrench@gmail.com>
Cc: Linux Cifs <linux-cifs@vger.kernel.org>, Bruno Haible <bruno@clisp.org>
Subject: Re: CIFS lockup regression on SMB1 in 6.10
In-Reply-To: <CAH2r5msAXgYs7=5D=YxGa8XohegJwpTn6yasVyZCmPmPt1QA9w@mail.gmail.com>
References: <cca852e55291d5bb86ea646589b197d5@matoro.tk>
 <CAH2r5msAXgYs7=5D=YxGa8XohegJwpTn6yasVyZCmPmPt1QA9w@mail.gmail.com>
Message-ID: <bf5a6d9797f33d256b9fffeb79014242@matoro.tk>
X-Sender: matoro_mailinglist_kernel@matoro.tk
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit

On 2024-08-15 15:37, Steve French wrote:
> Do you have any data on whether this still fails with current Linux
> kernel (6.11-rc3 e.g.)?
> 
> 
> On Thu, Aug 15, 2024 at 1:08 PM matoro
> <matoro_mailinglist_kernel@matoro.tk> wrote:
>> 
>> Hi all, I run a service where user home directories are mounted over SMB1
>> with unix extensions.  After upgrading to kernel 6.10 it was reported to me
>> that users were observing lockups when performing compilations in their 
>> home
>> directories.  I investigated and confirmed this to be the case.  It would
>> cause the build processes to get stuck in I/O.  After the lockup triggered
>> then all further reads/writes to the CIFS-mounted directory would get 
>> stuck.
>> Even the df(1) command would block indefinitely.  Shutdown was also 
>> prevented
>> as the directory could no longer be unmounted.
>> 
>> Triggering the issue is a little bit tricky.  I used compiling cpython as a
>> test case.  Parallel compilation does not seem to be required to trigger 
>> it,
>> because in some tests the hang would occur during ./configure phase, but it
>> does seem to provoke it more easily, as the most common point where the
>> lockup was observed was immediately after "make -j4".  However, sometimes 
>> it
>> would take 10+ minutes of ongoing compilation before the lockup would
>> trigger.  I never observed a complete successful compilation on kernel 
>> 6.10.
>> 
>> The furthest back I was able to confirm that the lockup is observed was
>> v6.10-rc3.  The furthest forward I was able to confirm is good was v6.9.9 
>> in
>> the stable tree.  Unfortunately, between those two tags there seems to be a
>> wide range of commits where the CIFS functionality is completely broken, 
>> and
>> reads/writes return total nonsense results.  For example, any git commands
>> return "git error: bad signature 0x00000000".  So I cannot execute a
>> compilation on commits in this range in order to test whether they observe
>> the lockup issue.  Therefore I wasn't able to test most of the range, and
>> wasn't able to complete a traditional bisect.  I tried adjusting the
>> read/write buffers down to 8192 from the defaults, but this did not help.  
>> I
>> also tried toggling several options that might be related, namely
>> CONFIG_FSCACHE, to no effect.  There are no logs emitted to dmesg when the
>> lockup occurs.
>> 
>> Thanks - please let me know if there is any further information I can
>> provide.  For now I am rolling all hosts back to kernel 6.9.
>> 
> 
> 
> --
> Thanks,
> 
> Steve

Hi Steve, just tested.  Not only is it still there in 6.11-rc3, but it's much 
worse - I got an immediate lockup just from ./configure

Thank you for looking at this.
