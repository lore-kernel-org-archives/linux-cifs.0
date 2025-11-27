Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8951337118
	for <linux-cifs@vger.kernel.org>; Thu, 27 Nov 2025 15:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764258328; cv=none; b=GfZDUJqJKP7LsKLtRXlnveKHdIqrwkk4JV88KFZ1lKqauTdTJwfkYKaOuYM+Ym79cuftsnVloZVzg2cSHw+kwWxXcSYpp1fFo+st893jZrLQ7xa/TthAYNEXQhkfJK/uZiPPLx2iRGpUqDcpR9R4oQ5cOrGy6USf1EOuwTQIES4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764258328; c=relaxed/simple;
	bh=v6j1bQI0Y3DGFy29bs2meLLQ9Q5ksy6+NCI8SYjCV7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BsyMHMlidJXRP2Hra5vY6ZdFpkx0oUPrE4RXPmspDFlthAetNw4k4LYvb/Ht33baOqLOCd8zDoPSVcCmrMnNI2Zw3EpVM98n3TQqnSlRC1SAgIHmmGa7hVSBsu+BcNXGSVVMtBZEJ6WXOOIzW1+Q+k9boEkty62PkcehjF+W5EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=aIs15CKB; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="aIs15CKB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=JEwbfyEvoztNc4q4YNniTzuVx3CXx9ZEDTDI6655Y9Y=; b=aIs15CKBwXiYH3+xegOkkfROHF
	SDqQuteIib2gGEkYnyOGx17IgBZReMIx1cgkccmTy5JzET2C0S0Wt+v23c8b7KoE6fjDTipMWsawI
	v6gCj2ShK/wJ1hojM76KR77+xwWzs+CoGpcf56JxwyfZi+ykMujqIB81dRUFDsnKuQuZWSmQ84Hea
	n54yZYBGSlWgLtbcmRSspTwGCtiASe77sL9U8ZNsjzCHi5zJr6WRMtk7XogSMrAZBfWrKxVQrMg+o
	FhiVrRXrqke0xZtXdQpmK9eiDOgKtZr35zLkwWhUrl79hRsHWwU1v0BKwJbPTJHwrEHTP7aQMPeOr
	XH1336ltUokEgRU0OblaoIIbFMAk0YHGz5BQd8k4vWa3u+K1C2Pj6m/b0wG9g89ODpG9Sc1SnfA+9
	FZyy9cipLWv66b+WhoqREJ/BqEFE2b9M5xvjnPQ5C1yrVoJ98iHDP1nXntrKOKvxY6YAWFp1Ayltp
	ZA54IM1oDyVk3vXYrAA2sRq0;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vOeBJ-00G1A7-0t;
	Thu, 27 Nov 2025 15:45:17 +0000
Message-ID: <dea0cad7-c068-4401-85e0-0757252c7857@samba.org>
Date: Thu, 27 Nov 2025 16:45:16 +0100
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
 <ad3feff5-553d-4d98-b702-9c7a594dd7c0@samba.org>
 <CAKYAXd_UJHTsa6QNW+Qzo6BjEqOXEF_bM=a=XRKm=OFwoigu4A@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAKYAXd_UJHTsa6QNW+Qzo6BjEqOXEF_bM=a=XRKm=OFwoigu4A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 27.11.25 um 00:10 schrieb Namjae Jeon:
> On Thu, Nov 27, 2025 at 1:03 AM Stefan Metzmacher <metze@samba.org> wrote:
>>
>> Am 26.11.25 um 16:18 schrieb Stefan Metzmacher via samba-technical:
>>> Am 26.11.25 um 16:17 schrieb Namjae Jeon:
>>>> On Wed, Nov 26, 2025 at 4:16 PM Stefan Metzmacher <metze@samba.org> wrote:
>>>>>
>>>>> Am 26.11.25 um 00:50 schrieb Namjae Jeon:
>>>>>> On Tue, Nov 25, 2025 at 11:22 PM Stefan Metzmacher <metze@samba.org> wrote:
>>>>>>>
>>>>>>> Hi,
>>>>>>>
>>>>>>> here are some small cleanups for a problem Nanjae reported,
>>>>>>> where two WARN_ON_ONCE(sc->status != ...) checks where triggered
>>>>>>> by a Windows 11 client.
>>>>>>>
>>>>>>> The patches should relax the checks if an error happened before,
>>>>>>> they are intended for 6.18 final, as far as I can see the
>>>>>>> problem was introduced during the 6.18 cycle only.
>>>>>>>
>>>>>>> Given that v1 of this patchset produced a very useful WARN_ONCE()
>>>>>>> message, I'd really propose to keep this for 6.18, also for the
>>>>>>> client where the actual problem may not exists, but if they
>>>>>>> exist, it will be useful to have the more useful messages
>>>>>>> in 6.16 final.
>>>>>> First, the warning message has been improved. Thanks.
>>>>>> However, when copying a 6-7GB file on a Windows client, the following
>>>>>> error occurs. These error messages did not occur when testing with the
>>>>>> older ksmbd rdma(https://github.com/namjaejeon/ksmbd).
>>>>>
>>>>> With transport_rdma.* from restored from 6.17?
>>>> I just tested it and this issue does not occur on ksmbd rdma of the 6.17 kernel.
>>>
>>> 6.17 or just transport_rdma.* from 6.17, but the rest from 6.18?
>>>
>>
>> Can you also test with 6.17 + fad988a2158d743da7971884b93482a73735b25e
>> Maybe that changed things in order to let RDMA READs fail or cause a
>> disconnect.
> The kernel version I tested was 6.17.9 and this patch was already applied.

Ah, good it also has:
smb: server: let smb_direct_flush_send_list() invalidate a remote key first

>> Otherwise I'd suggest to test the following commits in order
>> to find where the problem was introduced:
>> 177368b9924314bde7d2ea6dc93de0d9ba728b61
> I don't have time to do this right now due to other work.
> Did you test it with a Windows client and can't find this issue?

I can only reproduce the problem this patchset is fixing,
(recv completion before getting the ESTABLISHED callback).

I tested with an Intel-E810-CQDA2 card in RoCEv2 mode
and a Windows 2025 server (acting as client against ksmbd).

And I can only reproduce the problem with the recv completion
before the ESTABLISHED event. So this patchset is not only
used for setups with a connectx-7, btw were you testing with infiniband or rocev2?

Otherwise copying a 2G and 5G file to and from the share works
without problems.

I used this to verify that rdma offload was used:

root@rdmatest04l0:~# cat ksmbd-rdma-xmit.bt
kprobe:smb_direct_rdma_xmit {
         printf("%s pid=%d %s\n", comm, pid, func)
}
root@rdmatest04l0:~# bpftrace ksmbd-rdma-xmit.bt

And it printed a lot of kworker/4:1 pid=6162 smb_direct_rdma_xmit lines...

 From the logs you send it seems the client terminated the tcp and rdma connections,
do you see something in the clients event log?

metze
