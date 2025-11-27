Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276CF2288D5
	for <linux-cifs@vger.kernel.org>; Thu, 27 Nov 2025 15:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764258640; cv=none; b=QjgRsQvhFgdZWPFUCU0IYNi65hhlHSnpsOhDGpr7piUSMtuFlM4N3OLPpl9ibnulFzaEmeXD0eFdScTQgP9gdldMpagzWU2ct6KTxYSGGeR9/jnlmFEkeMke7wMwZu28zEyQU9rBit2NJvHKSCgJQvb8l1LbaqMJoS5IqIC69B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764258640; c=relaxed/simple;
	bh=Bkp15R/Ae4jZLAW/LIaABtnjaICduDQPo0iRzvK1RWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SyrjGuGzEvDSaYXUR9vjYE3ZYsV+99xevV71a0xCbuszcak6J/5u3Sn2iX+RJ7OAQm09K+b3QeyJK11v8RVK6ign8m2h65iIGcjuWgrnxPLBY1XKsvKA0KwWcCcdJ72O8kGkck+Et8gUtIN1VY9vMZNLgxwsv7gfWlD+OZSPrWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=bisRQhF1; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="bisRQhF1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=LmcJOAf2nilmAjJAWuz4InQgKzDMKNrlkSoj/MYzsyY=; b=bisRQhF1yez93gr8kLy1b8H7Qd
	O2x5ID/fLbRWf6Sg3a6RzD6ioNEpr95YNUcUbj2c4ZmRwlhz7BBxojmS6sm7OZcjFPT83tuN6llN5
	LW4lAkb5NFodVPBUNrn5JlUllhoYyACVyDiJNNovFm7SR6nLI2tABuLVud+ptqwi9wEsAfcM7nrVX
	PwaBgQ01hNirydV/dQkxb1BTqWxN1LbOi7gGCoqedZgGLVGsd7WW9uTDY500civ4/7ci8qd/zzH1x
	HtfNNRYX2CkMQbPhYN2PSD6sXX7C7FTOAYx+9+z1Y/nj805POrmr5fJRyclbcCRmL/mziFTW8emRy
	g3TQGPMSCax+EQ59GNxLwHIm813bwcF0XhDrl2lzsNamvI0Pd1zrMjnHywqXhhVynA10Uk2+A7GYz
	dGb6G5cuG4uDSvsU1Qap21TyqOtbEmw0mW0NO2CM6rjJEDfBiA4YHCzdXoCY785N04HTZDWdE42EP
	5rXUfrhdfI0smdFYHSeX4KC1;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vOeGR-00G1Eb-2N;
	Thu, 27 Nov 2025 15:50:35 +0000
Message-ID: <afb8eb46-30e4-4e84-b0b2-b7e145abbdb0@samba.org>
Date: Thu, 27 Nov 2025 16:50:35 +0100
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
Cc: Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, Paulo Alcantara <pc@manguebit.org>,
 Steve French <smfrench@gmail.com>
References: <cover.1764080338.git.metze@samba.org>
 <CAKYAXd_HKKBKx_B7+Z+b_jt+rHazuMkskYYPAp6BROPuy0uBfA@mail.gmail.com>
 <2786ee25-b543-48a8-8fff-e6c7ff341774@samba.org>
 <CAKYAXd8N-j8K1CUUH9_+wXpEZBo5i=K=ywkQPjJmmo76JbmXng@mail.gmail.com>
 <bd457989-d73e-4098-b3f7-c6871f49d188@samba.org>
 <ad3feff5-553d-4d98-b702-9c7a594dd7c0@samba.org>
 <CAKYAXd_UJHTsa6QNW+Qzo6BjEqOXEF_bM=a=XRKm=OFwoigu4A@mail.gmail.com>
 <dea0cad7-c068-4401-85e0-0757252c7857@samba.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <dea0cad7-c068-4401-85e0-0757252c7857@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 27.11.25 um 16:45 schrieb Stefan Metzmacher via samba-technical:
> Am 27.11.25 um 00:10 schrieb Namjae Jeon:
>> On Thu, Nov 27, 2025 at 1:03 AM Stefan Metzmacher <metze@samba.org> wrote:
>>>
>>> Am 26.11.25 um 16:18 schrieb Stefan Metzmacher via samba-technical:
>>>> Am 26.11.25 um 16:17 schrieb Namjae Jeon:
>>>>> On Wed, Nov 26, 2025 at 4:16 PM Stefan Metzmacher <metze@samba.org> wrote:
>>>>>>
>>>>>> Am 26.11.25 um 00:50 schrieb Namjae Jeon:
>>>>>>> On Tue, Nov 25, 2025 at 11:22 PM Stefan Metzmacher <metze@samba.org> wrote:
>>>>>>>>
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> here are some small cleanups for a problem Nanjae reported,
>>>>>>>> where two WARN_ON_ONCE(sc->status != ...) checks where triggered
>>>>>>>> by a Windows 11 client.
>>>>>>>>
>>>>>>>> The patches should relax the checks if an error happened before,
>>>>>>>> they are intended for 6.18 final, as far as I can see the
>>>>>>>> problem was introduced during the 6.18 cycle only.
>>>>>>>>
>>>>>>>> Given that v1 of this patchset produced a very useful WARN_ONCE()
>>>>>>>> message, I'd really propose to keep this for 6.18, also for the
>>>>>>>> client where the actual problem may not exists, but if they
>>>>>>>> exist, it will be useful to have the more useful messages
>>>>>>>> in 6.16 final.
>>>>>>> First, the warning message has been improved. Thanks.
>>>>>>> However, when copying a 6-7GB file on a Windows client, the following
>>>>>>> error occurs. These error messages did not occur when testing with the
>>>>>>> older ksmbd rdma(https://github.com/namjaejeon/ksmbd).
>>>>>>
>>>>>> With transport_rdma.* from restored from 6.17?
>>>>> I just tested it and this issue does not occur on ksmbd rdma of the 6.17 kernel.
>>>>
>>>> 6.17 or just transport_rdma.* from 6.17, but the rest from 6.18?
>>>>
>>>
>>> Can you also test with 6.17 + fad988a2158d743da7971884b93482a73735b25e
>>> Maybe that changed things in order to let RDMA READs fail or cause a
>>> disconnect.
>> The kernel version I tested was 6.17.9 and this patch was already applied.
> 
> Ah, good it also has:
> smb: server: let smb_direct_flush_send_list() invalidate a remote key first
> 
>>> Otherwise I'd suggest to test the following commits in order
>>> to find where the problem was introduced:
>>> 177368b9924314bde7d2ea6dc93de0d9ba728b61
>> I don't have time to do this right now due to other work.
>> Did you test it with a Windows client and can't find this issue?
> 
> I can only reproduce the problem this patchset is fixing,
> (recv completion before getting the ESTABLISHED callback).
> 
> I tested with an Intel-E810-CQDA2 card in RoCEv2 mode
> and a Windows 2025 server (acting as client against ksmbd).
> 
> And I can only reproduce the problem with the recv completion
> before the ESTABLISHED event. So this patchset is not only
> used for setups with a connectx-7, btw were you testing with infiniband or rocev2?
> 
> Otherwise copying a 2G and 5G file to and from the share works
> without problems.

I also tested with my latest smbdirect.ko patchset
in the for-6.19/fs-smb-20251125-v4 branch, also without problems.

