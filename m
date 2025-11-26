Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307FA32E6B8
	for <linux-cifs@vger.kernel.org>; Wed, 26 Nov 2025 15:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764170338; cv=none; b=oyeNP3dIUncOVDirprDDYTuewXwIBqPfejozWtWC2WWbIOl92wnVjt2ksNAI4UygWjr1VznEPptjR1TDt1GdfXiObxLp6KkiyrICjIP2nwqegKTz5JbkEuhfrDgTYRItyw3avEshTf1q2WJlXPu/ZFxOkhDOxgi83VuqmB+F/cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764170338; c=relaxed/simple;
	bh=aLCZ5IQRG4S4UYkf3VihXYPz8/JOTP6xv4YiwhnB/8g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m71ZrN8YfJ88N4UwXlPZ762YN57890+GUZdPakQgW65apoNPekG/JlwsKoCfzD7vLTnRvMC+KtIC6VsPk44TvI+WgeFzlsZ3jnyONWzqiDtu/N5spzbW5E2c9HCCi77npUXVsEwJxIVBj4BEsdMU020avhhndsMJ2jBDkaXBDDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=fsCwMiNi; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="fsCwMiNi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=aLCZ5IQRG4S4UYkf3VihXYPz8/JOTP6xv4YiwhnB/8g=; b=fsCwMiNiuXukd0mGo234i3ogJ3
	4TpMfRX9sF1crtmB5FsA7xGRZkRqCwvEem2FNJC+RjZiC1HdZ/5QvYQkscYep1LNt8qsZfY8kR8MI
	i8OlE/0x31CTc+c9Sth3ej1tYgvQzCemsJsg/q/QwxTHWesVr5umHi7rvebuqsYFB2Zgp/4T4ghLO
	AglUP0AIWJ7WyeAn6GtY8AiGpDNtnKZUcz9LrxUoMCgwyKCeKR8R22Ijj6dQCqrh/Wi9U5CF5sXX4
	xentPmM45ADuB8vCfPu1t7sgjWHd2VussDM48/AjmTuOaJd2/6i3uaDo+PYv367ycJtpF9zuWFImc
	g5N7m4ImyHs6Pf/H5thqhz30BpFOkzMbTCqhyoW8Q2dg+EzZEbZG7SG/wMpPbxYAV5xsPGmU1+0Ub
	sbkmpOM3pVDBHtqUs2s403+9TDXz/t2vsahwa2LMAxE5o8Xsz4OdQAq79RJUDpI2p6h6InX8qq3//
	3qAifWz39l76SqcseFpL5Or3;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vOHIB-00FrQd-06;
	Wed, 26 Nov 2025 15:18:51 +0000
Message-ID: <bd457989-d73e-4098-b3f7-c6871f49d188@samba.org>
Date: Wed, 26 Nov 2025 16:18:50 +0100
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
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
 Long Li <longli@microsoft.com>, Paulo Alcantara <pc@manguebit.org>
References: <cover.1764080338.git.metze@samba.org>
 <CAKYAXd_HKKBKx_B7+Z+b_jt+rHazuMkskYYPAp6BROPuy0uBfA@mail.gmail.com>
 <2786ee25-b543-48a8-8fff-e6c7ff341774@samba.org>
 <CAKYAXd8N-j8K1CUUH9_+wXpEZBo5i=K=ywkQPjJmmo76JbmXng@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAKYAXd8N-j8K1CUUH9_+wXpEZBo5i=K=ywkQPjJmmo76JbmXng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 26.11.25 um 16:17 schrieb Namjae Jeon:
> On Wed, Nov 26, 2025 at 4:16 PM Stefan Metzmacher <metze@samba.org> wrote:
>>
>> Am 26.11.25 um 00:50 schrieb Namjae Jeon:
>>> On Tue, Nov 25, 2025 at 11:22 PM Stefan Metzmacher <metze@samba.org> wrote:
>>>>
>>>> Hi,
>>>>
>>>> here are some small cleanups for a problem Nanjae reported,
>>>> where two WARN_ON_ONCE(sc->status != ...) checks where triggered
>>>> by a Windows 11 client.
>>>>
>>>> The patches should relax the checks if an error happened before,
>>>> they are intended for 6.18 final, as far as I can see the
>>>> problem was introduced during the 6.18 cycle only.
>>>>
>>>> Given that v1 of this patchset produced a very useful WARN_ONCE()
>>>> message, I'd really propose to keep this for 6.18, also for the
>>>> client where the actual problem may not exists, but if they
>>>> exist, it will be useful to have the more useful messages
>>>> in 6.16 final.
>>> First, the warning message has been improved. Thanks.
>>> However, when copying a 6-7GB file on a Windows client, the following
>>> error occurs. These error messages did not occur when testing with the
>>> older ksmbd rdma(https://github.com/namjaejeon/ksmbd).
>>
>> With transport_rdma.* from restored from 6.17?
> I just tested it and this issue does not occur on ksmbd rdma of the 6.17 kernel.

6.17 or just transport_rdma.* from 6.17, but the rest from 6.18?


