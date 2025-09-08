Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D301B3937
	for <linux-cifs@vger.kernel.org>; Mon,  8 Sep 2025 13:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757338207; cv=none; b=rV/9PA5ZPHYwEsJRnJuMXwBUuTcjVT3fg75BliXQDiX5XoXqORo5W9ff4/3YVw4eYV/zDgWVnOs+Tbp2hK+YFLaqtM2IGDNX42lCNImkf9kIN/hWZhrpr8c2+Ngggq6uN/YF5IDbSEzCHYFVl6IgSMNJjCeTXN49sDSQMDzCw0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757338207; c=relaxed/simple;
	bh=uZkE5PN+rBYlwHxbjCIEwnrk9YW/Tx8TPLEkX2I6cVo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QQmqv1vKl4eWkH6i7TWGoDd2aGkWuE/QtONhKxXUKn+16/KdXU0z+GO3oYYECyLBfpV2n8p8/6uJpE7HuwVU0WJAFuIcREvVrEPwIQBV+/u2IupED32hEsXTsMXDb1xGH0ae9El0K/c90kD0p4jY/wmiAMOhwRMOMBXk/feSDyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from [10.64.128.185] (unknown [193.43.9.250])
	(Authenticated sender: alekseevamo)
	by air.basealt.ru (Postfix) with ESMTPSA id 036482337B;
	Mon,  8 Sep 2025 16:24:29 +0300 (MSK)
Message-ID: <bb31a447-3092-4902-ba38-e5e16f1986dd@altlinux.org>
Date: Mon, 8 Sep 2025 17:24:31 +0400
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: alxvmr@altlinux.org
Subject: Re: [PATCH] fs/smb/client/fs_context: Add hostname option for CIFS
 module to work with domain-based dfs resources with Kerberos authentication
To: Steve French <smfrench@gmail.com>
Cc: pc@manguebit.com, linux-cifs@vger.kernel.org,
 Ivan Volchenko <ivolchenko86@gmail.com>, samba-technical@lists.samba.org,
 Tom Talpey <tom@talpey.com>, Vitaly Chikunov <vt@altlinux.org>
References: <20250516152201.201385-1-alxvmr@altlinux.org>
 <43os6kphihnry2wggqykiwmusz@pony.office.basealt.ru>
 <3d3160fd-e29d-495d-a02e-e28558cfec1a@altlinux.org>
 <CAH2r5mtG5pwFMRtu3EeXKPBdq0LJwjt84SbGtL0J4QuCg+AsgQ@mail.gmail.com>
 <CAH2r5msnTMCHJ9kZmFWCbUUUnejOLv8mzGussaidc3yj3nk+qQ@mail.gmail.com>
 <8f2ad82d-0dd4-4195-b414-59f25f859a9e@altlinux.org>
 <CAH2r5mvDa8E8NKNHevoWYARY_52DJ+WQX3oetYw-pwysMyAKYQ@mail.gmail.com>
Content-Language: en-US, ru
From: Maria Alexeeva <alxvmr@altlinux.org>
In-Reply-To: <CAH2r5mvDa8E8NKNHevoWYARY_52DJ+WQX3oetYw-pwysMyAKYQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Good day!

Could you please let me know if you have managed to find the messages 
with comments/feedback? This is important for us to make the 
corresponding changes to the proposed patches.

On 7/31/25 18:00, Steve French via samba-technical wrote:
> I don't have any strong opinion on: "dfs_server_hostname" vs
> "dfs_domain_hostname" whichever makes more sense.
> 
> I will look to see if I can find any more threads on this in earlier email
> 
> On Wed, Jul 30, 2025 at 11:54 AM Maria Alexeeva <alxvmr@altlinux.org> wrote:
>>
>> Steve,
>> It seems some of the discussion with review comments fell outside this
>> thread (I can only find vt@altlinux.org Vitaly Chikunov's remarks).
>> Could you please point me to where the rest of the feedback can be
>> found (e.g., about fixing the noisy warning the patch adds and
>> other comments)?
>>
>> An updated patch for fs/smb/client/fs_context has been prepared, renaming
>> the option to dfs_domain_hostname. There's suggestion to further rename
>> it to dfs_server_hostname - what are your thoughts on this?
>>
>> The patches will follow in subsequent messages.
>>
>> Thanks!
>>
>> On 7/25/25 02:50, Steve French via samba-technical wrote:
>>> Maria,
>>> Since this looks like it depends on a cifs-utils change, can you
>>> update your kernel patch with review comments (e.g. changing mount
>>> parm to "dfs_domain_hostname", and there were at least two others in
>>> the thread, e.g. fixing the noisy warning that the patch adds) and
>>> then show the cifs-utils change, so we can make the upcoming merge
>>> window.
>>>
>>> On Thu, Jul 24, 2025 at 5:14 PM Steve French <smfrench@gmail.com> wrote:
>>>>
>>>> I will update the mount parm name, similar to what Tom suggested to
>>>> "dfs_domain_hostname" to be less confusing.
>>>>
>>>> Let me know if you had a v2 of the patch with other changes
