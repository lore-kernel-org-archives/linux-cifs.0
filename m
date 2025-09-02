Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289131B21BF;
	Tue,  2 Sep 2025 15:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756826247; cv=none; b=HTlkLW1rsIAwXctx02FGcfzFJLclBiMngDbtaI/tGsf3P6OtzLPkoAJAyU6VNfew6/hjfsE87IRgBTQaYIbVAn4WH5jcaIyvHxdE55eX8FiLBSFuBGB7h4FZvQnek516vCW0rA+Bke2Iawe5vZo+hxI2JTIHtSFnplDZI75EvUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756826247; c=relaxed/simple;
	bh=DaDHPfQzPs8avtxHI0O8Tcq3B0YhEDFGBLLNmSVlmxs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=numk4BhqbFhq2lqFNH7GIA8+trSPERK1e42aDELUt61cL2Sv9PFFZSs0VKrKDngcdD6yB0lL+eQOmsyMWavTnFPptYqay5pOuJYYRJSp5XNSRNBONwB0Lr1FAqjKg+UFONabWyMJhbz5+aF5uZcFb7/WyFcVvZB+RSvzbGnqO+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=QnaDHyX3; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="QnaDHyX3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=grms1MjD6n9Wh6WN8Bqxb2fUhbvXX1gpg/Zy9bm76HM=; b=QnaDHyX3h4B5j1sQctnWqqvGVB
	5A3Di1knra4kC5Qvr6S83KuixbJnMxiA5GkMloFL/XnRG+LIhvqmK/cwyNzLge9mKvAtMRFTFzmA1
	igRHdFGUoNkj/q4Ot2b21sH0pLLx5kYxbZ/pkHgtYfq185QUNQ9P4kikxpA6+4Oei6Zq7hRF7QAzs
	ZHK3PkwlWISU41ZHZe3UGqtDztX15Tshd+ktZQVXjLWKDKffUi1F4zaV+b7FjKcBoEKoY8n0jR1Cx
	0cKCh0i7Z1jHTyBqe3WzPA/Roa2bELMXK0CpxVa31a0HgxuF+WU+EVUSnQ0YhFLegc11XjQs0LDpl
	ozcNekkO/Y036T9x4Ta0Q+oNaWARvZ1cX9xU5YBd9LoTo+pjQ45krDKfaFY8veXanFrgcMh7q545M
	5xyUkEQX90XDsW2DjSoqfS31Lj4/ijeRC44TrQ0KO1fUSqiXJfBr7G11thn7N3RixQjReNiRtIGER
	pFOxHhyxRzWx0Q4UnYigGtHE;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1utSl0-0024d7-2Z;
	Tue, 02 Sep 2025 15:17:14 +0000
Message-ID: <6660f6bd-ea74-4b25-b7dd-280833b5568c@samba.org>
Date: Tue, 2 Sep 2025 17:17:14 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/35] cifs: Fix SMB rmdir() and unlink() against Windows
 SMB servers
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
 ronnie sahlberg <ronniesahlberg@gmail.com>, =?UTF-8?Q?Ralph_B=C3=B6hme?=
 <slow@samba.org>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250831123602.14037-1-pali@kernel.org>
 <dfa557ed-eb34-4eaf-9e17-7cae221e74fd@samba.org>
 <20250901170253.mv63jewqkdo5yqj7@pali>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20250901170253.mv63jewqkdo5yqj7@pali>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Pali,

>>> This patch series improves Linux rmdir() and unlink() syscalls called on
>>> SMB mounts exported from Windows SMB servers which do not implement
>>> POSIX semantics of the file and directory removal.
>>>
>>> This patch series should have no impact and no function change when
>>> communicating with the POSIX SMB servers, as they should implement
>>> proper rmdir and unlink logic.
>>
>> Please note that even servers implementing posix/unix extensions,
>> may also have windows clients connected operating on the same files/directories.
>> And in that case even posix clients will see the windows behaviour
>> of DELETE_PENDING for set disposition or on rename
>> NT_STATUS_ACCESS_DENIED or NT_STATUS_DIRECTORY_NOT_EMPTY.
> 
> Ok. So does it mean that the issue described here applies also for POSIX
> SMB server?

I guess so.

> If yes, then I would propose to first fix the problem with
> Windows/non-POSIX SMB server and then with others. So it is not too big.

That's up to Steve. But isn't it just a matter of removing the
if statement that checks for posix?

>>> When issuing remove path command against non-POSIX / Windows SMB server,
>>> it let the directory entry which is being removed in the directory until
>>> all users / clients close all handles / references to that path.
>>>
>>> POSIX requires from rmdir() and unlink() syscalls that after successful
>>> call, the requested path / directory entry is released and allows to
>>> create a new file or directory with that name. This is currently not
>>> working against non-POSIX / Windows SMB servers.
>>>
>>> To workaround this problem fix and improve existing cifs silly rename
>>> code and extend it also to SMB2 and SMB3 dialects when communicating
>>> with Windows SMB servers. Silly rename is applied only when it is
>>> necessary (when some other client has opened file or directory).
>>> If no other client has the file / dir open then silly rename is not
>>> used.
>>
>> If I 'git grep -i silly fs/smb/client' there's no hit, can you
>> please explain what code do you mean with silly rename?
> 
> Currently (without this patch series) it is CIFSSMBRenameOpenFile()
> function when called with NULL as 3rd argument.
> 
> Cleanup is done in PATCH 11/35, where are more details.
> 
> Originally the "Silly rename" is the term used by NFS client, when it
> does rename instead of unlink when the path is in use.
> I reused this term.
> 
> 
> So for SMB this "silly rename" means:
> - open path with DELETE access and get its handle
> - rename path (via opened handle) to some unique (auto generated) name
> - set delete pending state on the path (via opened handle)
> - close handle
> 
> (plus some stuff around to remove READ_ONLY attr which may disallow to
> open path with DELETE ACCESS)
> 
> So above silly rename means that the original path is not occupied
> anymore (thanks to rename) and the original file / dir is removed after
> all clients / users release handles (thanks to set delete pending).
> 
> It is clear now clear? Or do you need to explain some other steps?
> Sometimes some parts are too obvious for me and I unintentionally omit
> description for something which is important. And seems that this is
> such case. So it is my mistake, I should have explain it better.

I think I understand what it tries to do, thanks for explaining.

I was just wondering why the rename on a busy handle would work
while delete won't work. I'd guess the chances are high that both fail.

Do you have network captures showing the old and new behavior
that's often easier to understand than looking at patches alone.

metze
