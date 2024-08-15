Received: from matoro.tk (matoro.tk [104.188.251.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FA015CB
	for <linux-cifs@vger.kernel.org>; Thu, 15 Aug 2024 18:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.188.251.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723745326; cv=none; b=YKGImjHAGqCwKdHvjGSGf2Is8Gwnu8sx7oaairFKXI7rlUZX14R04DXVOz6CWC28rHvsD7aHI4klKRgjcVDMwof0Pu1ZjQdt5fp/Dxdza+uExRYU5fzodd15cXIhkSa5r7a/F7uW6LWpXu94Jeyx7nD+ZBt8Ip7PgfG2wI/E+8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723745326; c=relaxed/simple;
	bh=9sLw/UGVGBjRIgCVLAN82abdy6zA43C9uNL2TF1FUco=;
	h=MIME-Version:Date:From:To:Cc:Subject:Message-ID:Content-Type; b=XAAjE/V7BGLrQXxUeUz2lyIPSoZ0HVzzfJJx49dQGiVbp2ctdIkbesKuZddfdNBxlrI92GNZQxN2D219b+CYldtN2IRLOM9JPIiBIszrOLzdDExy14FhhNEFKL+e8t5tz1PQhSMZ6E6rmTPGv9uieIFTc6inoYXW024dVy8a+zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=matoro.tk; spf=pass smtp.mailfrom=matoro.tk; dkim=pass (4096-bit key) header.d=matoro.tk header.i=@matoro.tk header.b=dJ9jNAW8; arc=none smtp.client-ip=104.188.251.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=matoro.tk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=matoro.tk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=matoro.tk header.i=@matoro.tk header.b="dJ9jNAW8"
DKIM-Signature: a=rsa-sha256; bh=23WnTESVWirdC0TscroYcaT+etpuRqyCvMh86WGDo+c=;
 c=relaxed/relaxed; d=matoro.tk;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:Message-Id:Message-Id:References:Autocrypt:Openpgp;
 i=@matoro.tk; s=20240626; t=1723744411; v=1; x=1724176411;
 b=dJ9jNAW8/a6xAc3/tDWgVX8L9NQbHY2drCErAneGSydwJyctWdP1qKjGTYCHGcC6X+SdRrRT
 M6Qc0gwJBdGfc2q1eXq9Tywn/IxvV5Ej94a7N/Lx0SSxxxS5rvH1u2IuckD4FYzwFKf/zULnFoZ
 Js6LRgnUtIINOmgruHTb5Q+LVAjdOowFg9FdcQUQgi5c9rjVKeehsyTOr5X+jIc7IhuMLUPnasu
 ZDvXSYOHSoAShhTAV0kH7MMz6nImql2ju8fhcFIpQE5qHqeQ25wJlpz6Mh9bS6f+Seffrlh1s3y
 kG22ei04GcBCAaQLO2nPfDKjX7pofm0VsN51tmuGj8n7r9SusVDEvE5fc4b4ZzgyjRjbTQ9IT1u
 RiPyfAaBhMX7fqOeW7kBveJXcB/BnwrmzvJFakOVOnBVLnhrU0BUTyJIIHOoyr2IHtiLqmB84lO
 ONoOxGy8niAK701bb5b22s3zkNiew+asg36Q7/Yk0sOcqumm4UV2jlcVQfrJUd9qYscfiyHtPb2
 6UNrKFJsZpt24DdOFdzEN5u81loyoRboJgXKM8xJwSurxP7qdRtkcGhfDLSmCrz5eTGxbWwi3L5
 LwF5gdhGDBTo/Znl+cDN4VuNLbzqrnoU6dc47hJTHvfC41jqlWXLlZQ2Jw93yEiYi5bwUFoaGSC
 dIhXpmfv3kI=
Received: by matoro.tk (envelope-sender
 <matoro_mailinglist_kernel@matoro.tk>) with ESMTPS id be223894; Thu, 15 Aug
 2024 13:53:31 -0400
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 15 Aug 2024 13:53:31 -0400
From: matoro <matoro_mailinglist_kernel@matoro.tk>
To: Linux Cifs <linux-cifs@vger.kernel.org>
Cc: Bruno Haible <bruno@clisp.org>
Subject: CIFS lockup regression on SMB1 in 6.10
Message-ID: <cca852e55291d5bb86ea646589b197d5@matoro.tk>
X-Sender: matoro_mailinglist_kernel@matoro.tk
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

Hi all, I run a service where user home directories are mounted over SMB1 
with unix extensions.  After upgrading to kernel 6.10 it was reported to me 
that users were observing lockups when performing compilations in their home 
directories.  I investigated and confirmed this to be the case.  It would 
cause the build processes to get stuck in I/O.  After the lockup triggered 
then all further reads/writes to the CIFS-mounted directory would get stuck.  
Even the df(1) command would block indefinitely.  Shutdown was also prevented 
as the directory could no longer be unmounted.

Triggering the issue is a little bit tricky.  I used compiling cpython as a 
test case.  Parallel compilation does not seem to be required to trigger it, 
because in some tests the hang would occur during ./configure phase, but it 
does seem to provoke it more easily, as the most common point where the 
lockup was observed was immediately after "make -j4".  However, sometimes it 
would take 10+ minutes of ongoing compilation before the lockup would 
trigger.  I never observed a complete successful compilation on kernel 6.10.

The furthest back I was able to confirm that the lockup is observed was 
v6.10-rc3.  The furthest forward I was able to confirm is good was v6.9.9 in 
the stable tree.  Unfortunately, between those two tags there seems to be a 
wide range of commits where the CIFS functionality is completely broken, and 
reads/writes return total nonsense results.  For example, any git commands 
return "git error: bad signature 0x00000000".  So I cannot execute a 
compilation on commits in this range in order to test whether they observe 
the lockup issue.  Therefore I wasn't able to test most of the range, and 
wasn't able to complete a traditional bisect.  I tried adjusting the 
read/write buffers down to 8192 from the defaults, but this did not help.  I 
also tried toggling several options that might be related, namely 
CONFIG_FSCACHE, to no effect.  There are no logs emitted to dmesg when the 
lockup occurs.

Thanks - please let me know if there is any further information I can 
provide.  For now I am rolling all hosts back to kernel 6.9.
