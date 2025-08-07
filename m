Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838BF7483;
	Thu,  7 Aug 2025 15:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754579830; cv=none; b=MDT8Laq12E4MHFZ4D25DKbPJQJUk2yNL6ka7NW6lyuW4j6ObAXPpEtYljbJQwPvfs13vM+OrY8g8hT3UR9XKXKx3bolJu+Wg7rnc4r7D61nB737IljYEBeFpmwOXVwMWxyqWjZosFAb4JxKeC6aK5vw569ya/ttyS8fDE2AsbGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754579830; c=relaxed/simple;
	bh=q41ltJO4K+pfU6XyCicEH22FWkAJJ0ElGehmhUIfOmQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rDD3Rem0q67OJlmyFCBhxMrxgj46XMiPiaaroYBtKuyVLn6p/b7+ieZiSvHZmf2mbBF3tzFifJS6bfgbbt8Gy0kxo+KBa284EM8o+mVl6GnwDhGYHWvZwwImBfU67x/VItCs3YsGKY/mgzb1cub97j9wFhKAYGEYBJX+Ssk3BlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ObfV2Yai; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ObfV2Yai"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=B5pYJYXbZ/f8P5SI1zJTYLoYcfVzbt8xnzdoq+MkKLM=; b=ObfV2YaiIA2zwrCoBnl7cq3Q1H
	xQTLMGcrCwgGqq6iic5RUuIdAcqv99iHfOeRUZpYe2jv6J5ve6I+wm6434J0Vv8VoBiQa7zIosX+W
	vCKeHCuEavqv2nHN4pKRK25hL66beItY+3hDQoJrb+GhyNMa+uTYAAby2NpmpUFfi5Zt8IMaFP9pr
	i82R4kTOJcEAeAd4qobxIwsLvjXo/gP+kE2nOF+4ZsIvpGPXlTNz6+ueYk6ccLwLVHwKrurHk4IAe
	Y/4JDdMFyackF2VGSgI3GlrlrXfHmtuoddlq7uLU/5QVgE4B13ktctdAJHO/oP+EH+ja5n3a7HW+q
	jh8vkJTeQRxfS2hmANST86aLqsBAjX2FmK2MUBCxHgCvWeGbFP2lyhdpwRP8qfEGKD8LTmJkhMT3v
	kG1F0uGm6jUMI2YyAlgWxgoRvYVTTNPHgi5NTjKxgZnBu0vNTQ8fgIKy3kYaqnLt1nvpTzjgTeFo+
	1ZkpJhLXZAONYhn4Hg/UUqK9;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uk2Mc-001bnC-0S;
	Thu, 07 Aug 2025 15:17:06 +0000
Message-ID: <e685f670-d994-48c2-8913-57358f0f9ad7@samba.org>
Date: Thu, 7 Aug 2025 17:17:05 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Using smatch and sparse together (Re: [PATCH next] smb: client:
 Fix use after free in send_done())
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>
References: <aJNASZzOWtg8aljM@stanley.mountain>
 <ad2e9d94-2d95-4351-b800-627f20672209@samba.org>
 <87646c67-78b8-41c5-9b72-361cb3b733d1@suswa.mountain>
 <e291d925-bfd9-4202-b5d4-de5bf30ab870@samba.org>
 <a1a0046c-f47f-4e8a-ae3c-85db58a6cb2f@suswa.mountain>
 <df4905fb-933e-4055-8363-d6427515773b@samba.org>
 <d3b63d25-1b03-4c7c-85cc-efd9d74c3a8a@suswa.mountain>
 <aa65df64-68f1-47bb-ab69-9817387f3ab8@samba.org>
 <ffc54288-5986-4505-b77f-bd800cc45527@suswa.mountain>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <ffc54288-5986-4505-b77f-bd800cc45527@suswa.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 07.08.25 um 17:06 schrieb Dan Carpenter:
> On Thu, Aug 07, 2025 at 04:27:41PM +0200, Stefan Metzmacher wrote:
>>> The DB is too big and too dependent on your .config but I should
>>> share the smatch_data/ more regularly.  I started to push that into
>>> a separate git repo but I didn't finish that work.  I should do
>>> that.
>>
>> Ok, what's the gain of updating it?
>> Does it help when doing fixes on old kernels?
> 
> If you run smatch_scripts/build_kernel_data.sh then it runs
> smatch_scripts/gen_* which generates a bunch of the files in
> smatch_data/.  Which in theory should enable more warnings for new
> code.
> 
> I've been moving away from generating files and more towards
> putting everything in the DB.  I just took a look at the files now
> to respond to your email and what I saw wasn't good...  I need to
> look at this some more.
> 
> I don't know how often the zero day bot rebuilds the smatch_data.
> I bet they never do and so I think it doesn't really matter.
> 
>>
>> I'm typically doing a full kernel build a week after each rc.
>> My idea was to rebuild the whole db after doing that.
> 
> Yeah.  That's a good strategy.  The data from the existing DB feeds
> into the new one when you rebuild the DB so don't delete the old
> DB at the start or anything.

I mean I'm typically do a git clean -xdf . in order
to wipe everything in order to do a clean:
make -j33 bindeb-pkg

So it would build a new DB, as I'm working based on
the new kernel I guess that's all I need or
are there other reasons to update the existing DB?

Thanks!
metze
