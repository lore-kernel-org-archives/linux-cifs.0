Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7394E33C1BB
	for <linux-cifs@vger.kernel.org>; Wed, 26 Nov 2025 16:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764173004; cv=none; b=IiF2xCIZ65dP3A1IdhPqpC4ihhbcNOYFcvKvmt2tXBKL7FgITGDWoinOpTiImDN3Qhi619oNmZ/THQ4Sv7Cop4PddxhbCTqDvFho7tFUTmWJH8XnC/JAtkM6ydem9MGovfJnzDVp08rVEictSB9nKvSlHYu3WHHfFkulmPNzY7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764173004; c=relaxed/simple;
	bh=qcvzwavDhA/NxMkwQOaaM+R2JqlgHaVLy+dUAFv2gX8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iZ+B1ptFghgflSQ4IaSS8XTCXNA+OZsAtO0phFI8wX+8UbEHL7MC3fldI7Ob66U1TplBUcONsVOGLyBfPEZkZodI41gJMeU6kpByEL+MGyEM61kJWqiITmNkwW+Ge/YF4tebhTjMhAmSW+Q40CfQlTOMXuhIZ+ZEycyfls7J9JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=xkatiZ2C; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="xkatiZ2C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=kHoyiQwUTzWQKihuxwrE7MsLoLeulN1ryAICzfbKsfQ=; b=xkatiZ2CuLawXdj/V0+CWISWxF
	+C9CD6hj8plU5w3nXImCMjirNRBbre2X189TIgAVJxSrmkIP8w8yRZNgb+9bxAimFjbf7Sdbj4EeN
	bSNAxxAQtgr9cjPPPmDK4L7so5rz+aUmuLZ5eIPIQHtgnhL9xMUcbAntlzj/9aKn9D5069gVtMLyq
	7Ikb0M6JB3YdRoBnnYdGf3QOIaimfeIZ+H88+QtWKLioZ1rQ4cxKgeM/YF+TQ0fgxxhSpJCtBuB91
	xPEbEMZZ8ELhlMP/Ry+LBUlaIsFLPrtdJwKJwaaeP26VzqTa2dumj6DBE/tw/fNN5H8sHMqM1JFHz
	/xC1xNOpYHlwhI/UHSx+gkgwgGeJHRncImwXDEAD44OtP6NxZDd4+Yk2KLlH2LIP/rAC2ympQJvMu
	si8sS5LKbjYvNFCIlyLWBDaF8XowNUSfxDZJpMxvX5eG8Hwhj3wF8AyDszhIZxAM7mA4yOOFHERk4
	PQtC1VP75eYmvOiHQ/ZQrqL2;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vOHzE-00FrnC-0m;
	Wed, 26 Nov 2025 16:03:20 +0000
Message-ID: <ad3feff5-553d-4d98-b702-9c7a594dd7c0@samba.org>
Date: Wed, 26 Nov 2025 17:03:19 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/4] smb: smbdirect/client/server: relax
 WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.org>,
 samba-technical@lists.samba.org, Tom Talpey <tom@talpey.com>,
 Steve French <smfrench@gmail.com>
References: <cover.1764080338.git.metze@samba.org>
 <CAKYAXd_HKKBKx_B7+Z+b_jt+rHazuMkskYYPAp6BROPuy0uBfA@mail.gmail.com>
 <2786ee25-b543-48a8-8fff-e6c7ff341774@samba.org>
 <CAKYAXd8N-j8K1CUUH9_+wXpEZBo5i=K=ywkQPjJmmo76JbmXng@mail.gmail.com>
 <bd457989-d73e-4098-b3f7-c6871f49d188@samba.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <bd457989-d73e-4098-b3f7-c6871f49d188@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 26.11.25 um 16:18 schrieb Stefan Metzmacher via samba-technical:
> Am 26.11.25 um 16:17 schrieb Namjae Jeon:
>> On Wed, Nov 26, 2025 at 4:16 PM Stefan Metzmacher <metze@samba.org> wrote:
>>>
>>> Am 26.11.25 um 00:50 schrieb Namjae Jeon:
>>>> On Tue, Nov 25, 2025 at 11:22 PM Stefan Metzmacher <metze@samba.org> wrote:
>>>>>
>>>>> Hi,
>>>>>
>>>>> here are some small cleanups for a problem Nanjae reported,
>>>>> where two WARN_ON_ONCE(sc->status != ...) checks where triggered
>>>>> by a Windows 11 client.
>>>>>
>>>>> The patches should relax the checks if an error happened before,
>>>>> they are intended for 6.18 final, as far as I can see the
>>>>> problem was introduced during the 6.18 cycle only.
>>>>>
>>>>> Given that v1 of this patchset produced a very useful WARN_ONCE()
>>>>> message, I'd really propose to keep this for 6.18, also for the
>>>>> client where the actual problem may not exists, but if they
>>>>> exist, it will be useful to have the more useful messages
>>>>> in 6.16 final.
>>>> First, the warning message has been improved. Thanks.
>>>> However, when copying a 6-7GB file on a Windows client, the following
>>>> error occurs. These error messages did not occur when testing with the
>>>> older ksmbd rdma(https://github.com/namjaejeon/ksmbd).
>>>
>>> With transport_rdma.* from restored from 6.17?
>> I just tested it and this issue does not occur on ksmbd rdma of the 6.17 kernel.
> 
> 6.17 or just transport_rdma.* from 6.17, but the rest from 6.18?
> 

Can you also test with 6.17 + fad988a2158d743da7971884b93482a73735b25e
Maybe that changed things in order to let RDMA READs fail or cause a
disconnect.

Otherwise I'd suggest to test the following commits in order
to find where the problem was introduced:
177368b9924314bde7d2ea6dc93de0d9ba728b61

After this it gets more tricky.

metze



