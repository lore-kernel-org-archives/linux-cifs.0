Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A5723875D
	for <linux-cifs@vger.kernel.org>; Wed, 26 Nov 2025 07:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764141376; cv=none; b=ZbWumohErIfTuoB4f6x0ypBSz3jweJbIdzWJrmKlUPnBRKDffoTwSqFNCr89FQfKtmbga8UD7B+8JNHc0Z6c5CKqmenUqA8l+GDg6IiYl7dPzCftCzQvEG61F4jIWTHx9hxPoBFFsdw3SdXusepEsUBc7jhvnxryEKH2JYw6IEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764141376; c=relaxed/simple;
	bh=oPr6ACsBWiTdcqqUClYl1qB6tW7HDAHrkWlcUbfwm2k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fzf9pPQIqmb/1B8lv7Y4WSU+WX5dZ97E/CM56iicbPVzKA6mA9VH9gJrqUW9NZP0U8KsDibBIAUIlrDgN4prtVD3tv5x6jPtHPlpnM8fFopuZVEM1Sk5UYzhj7e4m4j9zaCL5VpH2p8hyYz0TGAwr6GPiO3jhEfnBYIZ10AN59E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=FLrOuAyE; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="FLrOuAyE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=oPr6ACsBWiTdcqqUClYl1qB6tW7HDAHrkWlcUbfwm2k=; b=FLrOuAyE6aSRxiOyZGlnoKS2jW
	fSGFvqNqjRth0K/kTOQqrnyUY+yMO7AHiG6Tc1BZckBQloXv3B0y5nqXYLGGVVRrR+8xb8jMwa8n1
	/UZV+yWVNWRDPI3FQRXf1wNSNlg4TseWFYc01Z+QkGMcbozTa50g200DkiNX7PbzvkZkl9ABKdgFy
	RMbPMMwoizCPTZxDAzmMJMjySKe/8DrnUZI72Evtnkv+qQlGS1pXG4gfUkeisKoQyv9k1RY3NMnIt
	F2Zj5d3NJkRZmagwoJLkGGauV/ektKYEPjRBWcZlaSCneCyY9CHGOsjzIL/UefFVqAI0xu7ksj6oA
	Votb3Uq/x3toGRSxO6UVZrFJJirKw7S9OYoi+/fvp3N9W0cWNCoVewZsUSEHm7EcVZMpJd+wElvFa
	bySM2uuZtzPDTwaGqLhFnDb1JdH78+ILqdNZu5KbSrSEnXwJZdyIVfNri6bk3QRAPXvV+lPbICB4T
	l09AMUjtTp1NrhNjr8qwb37m;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vO9l5-00FnI4-0B;
	Wed, 26 Nov 2025 07:16:11 +0000
Message-ID: <2786ee25-b543-48a8-8fff-e6c7ff341774@samba.org>
Date: Wed, 26 Nov 2025 08:16:09 +0100
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
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAKYAXd_HKKBKx_B7+Z+b_jt+rHazuMkskYYPAp6BROPuy0uBfA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 26.11.25 um 00:50 schrieb Namjae Jeon:
> On Tue, Nov 25, 2025 at 11:22 PM Stefan Metzmacher <metze@samba.org> wrote:
>>
>> Hi,
>>
>> here are some small cleanups for a problem Nanjae reported,
>> where two WARN_ON_ONCE(sc->status != ...) checks where triggered
>> by a Windows 11 client.
>>
>> The patches should relax the checks if an error happened before,
>> they are intended for 6.18 final, as far as I can see the
>> problem was introduced during the 6.18 cycle only.
>>
>> Given that v1 of this patchset produced a very useful WARN_ONCE()
>> message, I'd really propose to keep this for 6.18, also for the
>> client where the actual problem may not exists, but if they
>> exist, it will be useful to have the more useful messages
>> in 6.16 final.
> First, the warning message has been improved. Thanks.
> However, when copying a 6-7GB file on a Windows client, the following
> error occurs. These error messages did not occur when testing with the
> older ksmbd rdma(https://github.com/namjaejeon/ksmbd).

With transport_rdma.* from restored from 6.17?

metze
