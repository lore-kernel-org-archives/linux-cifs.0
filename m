Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75C4250E7
	for <linux-cifs@vger.kernel.org>; Fri,  5 Jan 2024 10:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="dZ0xZuk9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=RjGmijxcsbrG9Vb7GmVvaQYXaZLzedozYzWz5ySxSb4=; b=dZ0xZuk9BaG0KfylYGsWyjBIDk
	Rf7HjAnY4Hj0zqI80hKSmHaSFbZjCZl0VyYH9kLk7CcX1PdvbKOxtRllsSl+oiBWpyW2zTKu096Mx
	E4fdrP3kbuwQCNo9LJK8ABmlXNOlWWwKABuzZ02RF3VhIbx0LO5DSgf6F/MpBAC1bHLe0oAO8jaVL
	qODu8AR1h+wa+Fa6mKYBr71FczAncK4VXQEpT7yhbVuUBoVN+yaFMPttBzZJFZweB0ilNPieOo+Ww
	MRH/KbWq7YddxXSWT0gi6zR58zDOoX7lHcptNBvdXjLaGLLwAcKjLSjPKf6dt9uqRj/FLQQESQtAu
	PuJfw3k84FNpuFLpqnKqAcVAW9r4mX4P3GK+rJQOm+uO09U0VdIJ02iGJPnUHN5h1mk175AeK9SSN
	uYNcZy5ACWOWJtmw5JmizWn8wE7UIKyt7Z5zOSn2hjpvjIRN/Ib25eNOMKfHJRNxvE0t4LbWcmnzq
	2U8TaRW4TQknHMCTQY5CVGI5;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1rLgzu-006aas-0d;
	Fri, 05 Jan 2024 10:00:14 +0000
Message-ID: <242e196c-dc38-49d2-a213-e703c3b4e647@samba.org>
Date: Fri, 5 Jan 2024 11:00:13 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] smb: client: retry compound request without reusing
 lease
Content-Language: en-US, de-DE
To: Shyam Prasad N <nspmangalore@gmail.com>, Tom Talpey <tom@talpey.com>
Cc: Paulo Alcantara <pc@manguebit.com>,
 Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, sprasad@microsoft.com,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 sfrench@samba.org, Meetakshi Setiya <msetiya@microsoft.com>,
 bharathsm.hsk@gmail.com
References: <20231229143521.44880-1-meetakshisetiyaoss@gmail.com>
 <20231229143521.44880-2-meetakshisetiyaoss@gmail.com>
 <7e61ce96ef41bdaf26ac765eda224381@manguebit.com>
 <CAFTVevWC-6S-fbDupfUugEOh_gP-1xrNuZpD15Of9zW5G9BuDQ@mail.gmail.com>
 <c618ab330758fcba46f4a0a6e4158414@manguebit.com>
 <62eb08fb-b27f-4c95-ab29-ac838f24d70f@talpey.com>
 <CANT5p=qqUbqbedW+ccdSQz2q1N-NNA-kqw4y8xSrfdOdbjAyjg@mail.gmail.com>
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CANT5p=qqUbqbedW+ccdSQz2q1N-NNA-kqw4y8xSrfdOdbjAyjg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 05.01.24 um 10:39 schrieb Shyam Prasad N via samba-technical:
> On Fri, Jan 5, 2024 at 2:39 AM Tom Talpey <tom@talpey.com> wrote:
>>
>> On 1/3/2024 9:37 AM, Paulo Alcantara wrote:
>>> Meetakshi Setiya <meetakshisetiyaoss@gmail.com> writes:
>>>
>>>> As per the discussion with Tom on the previous version of the changes, I
>>>> conferred with Shyam and Steve about possible workarounds and this seemed like a
>>>> choice which did the job without much perf drawbacks and code changes. One
>>>> highlighted difference between the two could be that in the previous
>>>> version, lease
>>>> would not be reused for any file with hardlinks at all, even though the inode
>>>> may hold the correct lease for that particular file. The current changes
>>>> would take care of this by sending the lease at least once, irrespective of the
>>>> number of hardlinks.
>>>
>>> Thanks for the explanation.  However, the code change size is no excuse
>>> for providing workarounds rather than the actual fix.
>>
>> I have to agree. And it really isn't much of a workaround either.
>>
> 
> The original problem, i.e. compound operations like
> unlink/rename/setsize not sending a lease key is very prevalent on the
> field.
> Unfortunately, fixing that exposed this problem with hard links.
> So Steve suggested getting this fix to a shape where it's fixing the
> original problem, even if it means that it does not fix it for the
> case of where there are open handles to multiple hard links to the
> same file.
> Only thing we need to be careful of is that it does not make things
> worse for other workloads.
> 
>>> A possible way to handle such case would be keeping a list of
>>> pathname:lease_key pairs inside the inode, so in smb2_compound_op() you
>>> could look up the lease key by using @dentry.  I'm not sure if there's a
>>> better way to handle it as I haven't looked into it further.
>>
> 
> This seems like a reasonable change to make. That will make sure that
> we stick to what the protocol recommends.
> I'm not sure that this change will be a simple one. There could be
> several places where we make an assumption that the lease is
> associated with an inode, and not a link.
> 
> And I'm not yet fully convinced that the spec itself is doing the
> right thing by tying the lease with the link, rather than the file.
> Shouldn't the lease protect the data of the file, and not the link
> itself? If opening two links to the same file with two different lease
> keys end up breaking each other's leases, what's the point?

I guess the reason for making the lease key per path on
the client is that the client can't know about possible hardlinks
before opening the file, but that open wants to use a leasekey...
Or a "stat" open that won't any lease needs to be done first,
which doubles the roundtrip for every open.

And hard links are not that common...

Maybe choosing und using a new leasekey would be the
way to start with and when a hardlink is detected
the open on the hardlink is closed again and retried
with the former lease key, which would also upgrade it again.

But sharing the handle lease for two pathnames seems wrong,
as the idea of the handle lease is to cache the patchname on the client.

While sharing the RW lease between two hardlinks would be desired.

metze
