Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCA917B418
	for <linux-cifs@vger.kernel.org>; Wed, 28 May 2025 16:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748449302; cv=none; b=ZcWvtPdYC0oqoKJwzRvwpgecbPxsBjnNjm3eIjHRahQBuGGfUUp7MDFtxk2kMa3a6y97SAaS+snym27HGd1tAe7x0jnLwdrIvznOa+yj2vuF9OYo0wS4vUJ/0/U/ZYcPl37cWRjUEEyD7mVPZNhwYZS9NOkaPwSogxDa8P2VHxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748449302; c=relaxed/simple;
	bh=adtMpGHnrk3rgr3EHCYbMyDAoAJNTdL2U8SeYTARWNA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=kgHshAnSbxuZ1aKOIy/sEx2rwyhgesymO2y8GfLQEb6DlEizBOGwbUyJdNA1Bf/D3cFZGvjPpW/PTnddyCWzqr5Y/x1LSkbFv2d1chXDa9KrLw/lFN2SauehTFz0J21tYntLASvliviOjP/9zEsOrVpEfIEzOd5C4vbSAfqFJ0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=wT74Jf6q; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="wT74Jf6q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Cc:To:From:Date:Message-ID;
	bh=3AnAjcZ2Snwbb2TMKRwwkV/OhMakCcECLKgC3s8g90M=; b=wT74Jf6qcpfXgDx4K7cWlxuqcO
	0guAvDlWyW0DuFWVC39XeUYWkL+CZYmiP1g6cs1Oi7MULP0MlQOtLYqp3bMimGDWHZOqyyAgYsSGM
	C5oGMEHM6+GF2bpy0Vj4fziVZ2avdAGGr4flztlZr3uekLfsPRVdcFdcnFZ6uTRLFIr8XahZMEFSg
	c3o5mZf3g6NnagDuH+VziQGxXfDf3kjmCfR3NKvKpB9pIHFbQDLI6UHY0FP4KM5LFkawbPLqfUxxe
	g9gho+9JmD0Ix+YOh2vbJOELfnUt9Vez3RgLu4H6qCH3zn5cnMb/QnedWQKFt6O/9FytZN5WJCLmC
	SObERaqmbpbhVAdSifCGduunt6BHgfN5pRYUdEyMrekLnMscR+tL/RJPSPlxN7+6oOfCaCvfnainN
	klYd7iC8dNvmTH979i+CfYInHnFOs1N45iX7CuNrVlX6DGxlkwBhTpeFq9o7q4P9r512n5G8+x2rA
	r9algffToXRJO2qTXk+gzbSU;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uKJX8-007hxN-1k;
	Wed, 28 May 2025 16:21:38 +0000
Message-ID: <8691d09d-268a-4623-9f53-9f47b1d5bb73@samba.org>
Date: Wed, 28 May 2025 18:21:38 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ksmbd uses ib_destroy_qp() instead of rdma_destroy_qp()
From: Stefan Metzmacher <metze@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
 Hyunchul Lee <hyc.lee@gmail.com>, Tom Talpey <tom@talpey.com>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
References: <04ad8564-4a55-4308-86ad-dd6dc47fcaab@samba.org>
Content-Language: en-US
In-Reply-To: <04ad8564-4a55-4308-86ad-dd6dc47fcaab@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Using Namjae Jeon <linkinjeon@kernel.org> now...

Am 28.05.25 um 18:19 schrieb Stefan Metzmacher:
> Hi Namjae,
> 
> I just found that you used ib_destroy_qp instead of rdma_destroy_qp in ksmbd,
> while rdma_create_qp() was used to create it.
> 
> Is there any specific reason for that?
> 
> The only thing that is different is that rdma_create_qp() takes a mutex
> around calling ib_destroy_qp(), which might be a reason for a potential problem.
> 
> Assuming there's no real reason I guess we should use rdma_destroy_qp
> in order to get trace_cm_qp_destroy().
> 
> Any comments?
> 
> metze

