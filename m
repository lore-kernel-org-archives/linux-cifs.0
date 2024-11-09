Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA1719DF75
	for <linux-cifs@vger.kernel.org>; Sat,  9 Nov 2024 16:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731169105; cv=none; b=RHYrvJI/nz3eDgHfWHUZNNU7Acpi30Y1Kl7L5Ey+1uw4CruC3trq6fANeXMMtIZmZb+p0M1q1JSr1tnW01fSm7vhRiqlbQOwe9WFIS1saFr92GJrxcylEzZP7hbQ8xWUwjLA/wxVT9X81dWOl8hAaUdbIkdGWTL6Z+fgAt1SbaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731169105; c=relaxed/simple;
	bh=QTfEfIZoz7Qw5bSM9rPtE9Wucmciili+fttOwckcmqQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=dfzhwzIHpIx8tiR4Ram124sdLoN0B3l6tDmzLdr+5Ww7N9QyYmGQhWzhwobC2NARG/FjnNPDYco8HvqJomwyh52VVSdEpilr23TOzSxkOl8GicS9mwvCz+K1ge2kkZqaJ22ykEWhmMIjcC4JRuTbuESMYTejUpwgQDGrZWmsgsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Q4MubUFe; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Q4MubUFe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Cc:To:From:Date:Message-ID;
	bh=HD7YyLMm4RkwJ8+EBV4vUexPHQXERT7ftRZ2ELevSAs=; b=Q4MubUFetVE8bWXJ5lEzaXpIkF
	fyC0+QM/X55GUiefb1nthkInNXtpYZgrD7vd/0uQyhQYDw0sO+SSY7mIsqCHd+yqOryrfTeknlWvJ
	s4MRQWTGHC+WyIG+L2aYA+zXGoqe3EOjtiQgX2lTt5YZ8G1HXdg4BefV/+gjijquC8LBS8in0vjPG
	qfiOT30JvByv2DN6vUQJqiJOVLYT/aIoVNSG8vNJ6MeKFR+rAovZ4GTGn/k9Ktob64rP132I9MHs2
	BIFj3JRzMwAFF0B/B/yu96KuspiXuY70gtnML2nu5fuVD+LhDRqdRgm8Y+pK/KoCW9MW+BUkXI4sd
	ZJhXuB83NunSSacbIRNRUH6gn5CHHcSgXPI1w2rbULOj+Y8HiUo3BWoV8EDEYlsz3L1H+zAvXkqzv
	FXTFd8DLDbFB/SDznRoVyfNVZ7imckq8f7JwJn7pODM4ENOVYoLmQlVLiVzW8a7D2+QoT9YzeJX33
	g5ZkVtVuiOnQuTj0XAcLUVDA;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1t9oAH-009nLP-0H;
	Sat, 09 Nov 2024 16:18:21 +0000
Message-ID: <2eb2e4fa-1e74-46d4-a399-0200dd08e348@samba.org>
Date: Sat, 9 Nov 2024 17:18:20 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Current Samba master incorrectly returns STATUS_INVALID_HANDLE on
 copy_chunk
From: Ralph Boehme <slow@samba.org>
To: Jeremy Allison <jra@samba.org>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
References: <CAH2r5mt7cE8Cc2K5K8nRM2RL=R-rwuAR9h6SSyEqtApuochtuQ@mail.gmail.com>
 <e12d7594-02df-4cbb-80fc-276d907afd90@samba.org>
 <CAH2r5muqSmNy+3SViFKNJ=5Sm61u8r9ej9Wy8JLUDeC2XHwccA@mail.gmail.com>
 <77aff6ef-291d-4840-82e2-b02646949541@samba.org>
 <d84732db-dea1-4fbd-9fc9-105c115c9ca0@samba.org>
 <990b4f16-2f5a-49ab-8a14-8b1f3cee94dc@samba.org>
 <ZwVM1-C0kBfJzNfM@jeremy-HP-Z840-Workstation>
 <569625f6-e0d2-43db-88cf-eb0fff6eb70e@samba.org>
 <ZwbczZYBsTU03Ycv@jeremy-HP-Z840-Workstation>
 <c146a052-40e2-4d90-9a8e-9236a0b2dc20@samba.org>
Content-Language: en-US, de-DE
In-Reply-To: <c146a052-40e2-4d90-9a8e-9236a0b2dc20@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/9/24 4:26 PM, Ralph Boehme wrote:
> On 10/9/24 9:43 PM, Jeremy Allison wrote:
>> Can we just map (access_mask (FILE_APPEND_DATA|SYNCHRONIZE)) == 
>> (FILE_APPEND_DATA|SYNCHRONIZE))
>> to O_APPEND, regardless of POSIX mode ?
> 
> thinking about this a bit more, this seems doable, albeit only for POSIX 
> mode. For non-POSIX mode we could potentially break WIndows application 
> that open only with FILE_APPEND_DATA: I checked with a torture test that 
> Windows doesn't enforce append behaviour for FILE_APPEND_DATA|SYNCHRONIZE.
> 
> For POSIX opens we should also allow combinations like 
> FILE_READ_ATTRIBUTES|FILE_APPEND_DATA to map to O_APPEND, so clients can 
> write in append mode to the handle and still are able to fstat() it.
> 
> https://gitlab.com/samba-team/samba/-/merge_requests/3863

oh, forgot to mention that this fixes the failing copy_chunk copy from 
the Linux kernel client in posix mode.

-slow
