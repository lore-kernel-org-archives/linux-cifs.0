Received: from hua.moonlit-rail.com (hua.moonlit-rail.com [45.79.167.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620B4370D62;
	Thu, 16 Apr 2026 21:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.167.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776375758; cv=none; b=fkJBr9BwuHyc6aooB1WXGItWf2qIejx9+LpqoM+bPEymLCFFnUXTJBWQkbM0kOBDL8WybHjjkyBQNb40lHNw3VLSdgmkthe6lKOEmpMh4tSNVYB6WWO0w6BXnQOtKEZ1OUqRK4NMSkRmL8C50a6nf1QudKS0MFm1bHzJykln/rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776375758; c=relaxed/simple;
	bh=8ZTNO1FIA7YOlkxSgXCdxibwhJmKVA5PieZRYFqTWWs=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=Yp490wmbozNXcmMpcxg3lWNK8uVRmehH3rxaZaBn2VnAFzsfS5MMZBefvKw2iBGM1nOx6DhaU0zN/Bg77QNQw4okXxbix5WAVs7DQFDXiFf2qcerxB4ckMt/CPK7VvF+qo2Nf6Y5ZxlCfNKPYceXDYlNp0uRCW8pjspnD3y+PUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=moonlit-rail.com; spf=pass smtp.mailfrom=moonlit-rail.com; dkim=pass (2048-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b=kg8QDjJq; dkim=permerror (0-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b=+/G+Z5MT; arc=none smtp.client-ip=45.79.167.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=moonlit-rail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=moonlit-rail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b="kg8QDjJq";
	dkim=permerror (0-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b="+/G+Z5MT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=moonlit-rail.com; s=rsa2021a; h=Content-Transfer-Encoding:Content-Type:Cc:
	To:Subject:From:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=cNiOcISIHeVG9w9HEQ01o2E0KoJv3AfP0afSQV8c+G0=; t=1776374431; x=1778966431; 
	b=kg8QDjJqGtIIKEdyxly8onhJAnGWnhHoXy0YtKfsnOWPxfx8kodqgu0p83kwlwMegC6tWL6fUWh
	H7EP2OztGCCOeQQkpUiK2pCQPXRBLtjnDdZSlFEEUoiBieonipgCpBnxL6l0fBPaa4QWUDL+J6RhJ
	kiMFmlJ/7h4DAnKuEF24jLQHSxo6WsDNLWYDM1Cv45isG/4g7QXLgPNN2jLHx/XaCdx/wjQk9JdOa
	IeFcuZvDbsR6XClaICGpLCf9A/Y8wL/Xe5tN4TOrD+/aFZ7sEJxzhIwmgjJhULUlRFB/s3M9ONaAx
	YVICDOo1+r1CpeJRPIJOujXZ4vsff2dUQPVQ==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
	d=moonlit-rail.com; s=edd2021a; h=Content-Transfer-Encoding:Content-Type:Cc:
	To:Subject:From:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=cNiOcISIHeVG9w9HEQ01o2E0KoJv3AfP0afSQV8c+G0=; t=1776374431; x=1778966431; 
	b=+/G+Z5MTrC7+a6N/PsaZ06VZlAjqhJSCHtvgCwNbS30u9hLCydQ/gSQq54BvFI0jjtyCVD8m3uA
	Jl3BXi9+OBg==;
Message-ID: <f758f4ff-4d54-4244-931d-38f469c3ff14@moonlit-rail.com>
Date: Thu, 16 Apr 2026 17:20:30 -0400
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Kris Karas (Bug Reporting)" <bugs-a21@moonlit-rail.com>
Subject: [REGRESSION] in Linux 7.0: empty CIFS mount point with vers=1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>,
 Linux Cifs <linux-cifs@vger.kernel.org>
Content-Language: en-US, en-GB
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

A bit late to the party, sorry, I should have reported this in 7.0-rcX.

When mounting a CIFS share with vers=1.0, the mount "succeeds" (is added 
to /proc/mounts) but the mountpoint is completely empty.  Even "." and 
".." are missing.  Blindly accessing a known file results in "no such 
file or directory".

Kernels 6.19 and below are not affected.  Using vers=2.0 or vers=3.1.1 
(etc) works fine, but "UNIX File Extensions" is still necessary for my 
workload.  (While "posix" extensions in vers=3.1.1 against Samba Stable 
is getting better, it's not there yet, details on request.)

Example:
     # ls -al /mnt/tmp
     Total 8
     drwxr-xr-x  2 root root 4096 Sep 25  2006 ./
     drwxr-xr-x 12 root root 4096 Apr 11 03:32 ../
     ----------  1 root root    0 Dec 22  2018 filesystem.not.mounted
     # mount -t cifs -o vers=1.0,cred=.creds //Server/Share /mnt/tmp
     # ls -al /mnt/tmp
     Total 0
     #

If Greg KH were reading this, I just know he'd say,
"can you bisect?"  :-)  OK, the winner of the bisect is:

> 4fc3a433c13944ee5766ec5b9bf6f1eb4d29b880 is the first bad commit
> commit 4fc3a433c13944ee5766ec5b9bf6f1eb4d29b880
> Author: Paulo Alcantara <pc@manguebit.org>
> Date:   Mon Feb 23 13:34:35 2026 -0300
> 
>     smb: client: use atomic_t for mnt_cifs_flags
>     
>     Use atomic_t for cifs_sb_info::mnt_cifs_flags as it's currently
>     accessed locklessly and may be changed concurrently in mount/remount
>     and reconnect paths.

I added Paulo to the CC's.

Kris
