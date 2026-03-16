Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C9F2BE655
	for <linux-cifs@vger.kernel.org>; Mon, 16 Mar 2026 11:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773661615; cv=none; b=jqB21QIypTJu4im2+OKDOTjYDfknkyCWKiHRt6SA7wy9t4lvnqfR3L7/egzCGDx3jbnAmhgisJ3AiVGjYBj6CqTOY0NU3VUcZ0FnyH6KNWsFApLQlz7yGNWKzK4TwzDVr6p2zdamUL10eO4BHVnIV8US114iXLW/wkc/2NFUDso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773661615; c=relaxed/simple;
	bh=580Av2UD2iN7mZA6NjpX3D45cn8/PmgkFJAzu4DQwXs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MbdnPx1MX6oADjX06TGra4N2A0GNoFtqa9MZGMqcMxWKcQNWGicpKULehjeWBaLyVYRx8OPm7jxuosMTtcsmwiBUIagu+35ZdFAEc545d6iPauG/XR3lWudci6qa9RvyXWshOlwVlavGcN2T4TRB5OnMPerph9pnQQkIgKmLBd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=N9m8bT8i; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="N9m8bT8i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=3fd1/vY1K9Lky7rmWMMgfqTgcs0+ctkhoSkEpH1q+9E=; b=N9m8bT8iA1Iu86I589y6ti5vwY
	knyRvP02/FOXFG+ouJLlcxSDSTUYCLsmMW4uT1U5gT/N3EwRf3S0RE3WVyN7ammOZfqDKtm66ykUG
	76Urn3L1LJ6+BF0FhzPMrBeJSyIyK2FIehtE1Leyg0vnczPx0IC/l8t2hwlkwz+LRGct4iMvkW8Co
	ZTmi0NqixkZxjXQO/m67YMjhEkMUYfKEEHN4Qm33FyILDipM4hO2VXmIq6Q3uCtZF8GnAQ+MWj9zu
	j+gEH171i7MqGtsSwCDlJQ5yZIwcL2wHOzOJW0KSya7QK8S5iIT+0yj1Lv1JgqC7/YchkuiZJ2U/E
	5KJLnztYobjpTPLMCNahISaGxB/RVZT1uOtJz4n3LtKMn7wp4Wt9csBEsx6+Z4UF/kyEf+/af741D
	SjCxme6FspzIy1az8pxqVK03BqhEPzwaQXsm4mNb2VWLUv8+Ec8uheialxzlpO0QHZ2AustUe/3It
	aze6smSBsQcd/xjgkU2E/KGg;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1w26PL-00000001TY2-0gco;
	Mon, 16 Mar 2026 11:46:51 +0000
Message-ID: <12936912-5c98-4599-9e6f-b454ad18d264@samba.org>
Date: Mon, 16 Mar 2026 12:46:50 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SMB3 POSIX, byterange locks and close behaviour
To: Ralph Boehme <slow@samba.org>, Jeremy Allison <jra@samba.org>,
 Steven French <Steven.French@microsoft.com>, "vl@samba.org" <vl@samba.org>
Cc: samba-technical <samba-technical@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
References: <b3da51e2-5360-4931-a5ce-95de39cbb294@samba.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <b3da51e2-5360-4931-a5ce-95de39cbb294@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ralph,

> while working on the part for byterange locks of the SMB3 POSIX spec, I noticed a problem in the protocol:
> 
> Neither MS-SMB2+ nor the SMB3 POSIX ext has a way to send a client side identifier for the process (like the pid) to the server. That means when processing SMB2-CLOSE we 
> have no way to correlate opens by the same vs different applications (pids) on the client.
> 
> Suppose on the client this happens:
> 
> 1. application A (pid=X on the client) opens fd1=open("file") and sets a brl
> 2. application A (pid=X on the client) opens another fd2=open("file") and sets a compatible brl
> 3. application B (pid=Y on the client) opens another fd3=open("file") and sets a compatible brl
> 4. application A closes fd1
> 
> According to POSIX rules we have to drop all brls on "file" when closing any fd on "file", but this can't be implemented on the server, as we have no way to tie opens from 
> the same client side process together.
> 
> It's also not possible to implement OFD locks in the protocol, same problem.
> 
> Using OFD locks in the backend on the server doesn't help.
> 
> SMB1 had pidlow/pidhigh in the header and MS-FSA "2.1.5.8 Server Requests a Byte-Range Lock" has:
> 
> ---8<---
> The server provides:
> 
> LockKey: A 32-bit unsigned integer containing an identifier for the lock being obtained by a specific process.
> ---8<---
> 
> and this part of MS-CIFS "3.3.5.15 Receiving an SMB_COM_LOCK_BYTE_RANGE Request":
> 
> ---8<---
> Locks prevent attempts to lock, read, or write the locked portion of the file by other clients or PIDs from the same client.
> ---8<---
> 
> ...implies the SMB1 server passes the PID as LockKey to the FSA layer.
> 
> SMB2+ doesn't have a PID nor has POSIX-SMB2 and I wonder if we need one, at least for the lock/unlock SMB2 requests. SMB2_LOCK_ELEMENT has a 32bit reserved field which we 
> could repurpose, but there'll be dragons, so we might need a different way to extend the protocol.
> 
> We also have a 32bit reserved in FilePosixInformation, that would fit the bill.
> 
> Thoughts? Am I missing something?

I think it's the job of the client to coordinate its local processes.

I guess the client can have just a single open to the server for local fd1 and fd2,
but in the end it's a local problem on the client.

I guess a Windows client has to solve similar problems with multiple
applications running.

metze
