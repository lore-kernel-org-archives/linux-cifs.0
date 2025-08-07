Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0C47FBA1;
	Thu,  7 Aug 2025 06:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754548455; cv=none; b=XP035xEVMBnH6DBz8GKbxUn0a2WGAhZ2bJOXiPd65XxvaSuJ6XYR96p+XHgL3x9SIRKOcA0mc9vqYm7eN9uXdy+nmV+C1kY0ITHAZlER6X7nLmW0zkStcnlYxGjvEvSd73r/ZXn/zfbWgxsToObfzRd0FWxlPcOiGpDcoo0iJck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754548455; c=relaxed/simple;
	bh=UjscG/f9w/2r0yDEV6yPKlGTZFmkRTD7hlJ1kWJElOA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DPfDPPVgQZ13LkdMIaeQ7EUMiN89Gi1d4PxpBU7u/FQXzKxIenl0szdWGiZdSAsw4hgdYuW5ZkTDLVK4Spp8ENDA1vyZ3eoXawJJmBAASdPd2d7g0fNNkL53FVoHZwM7pKT5hsb8eFEjp2ETxWztoiYcyhWBEURG9G0J5TIC0Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=mKOysCdZ; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="mKOysCdZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=4PYhJMOgL7UT34jKf7wQ9jfZ7uVU4Nj0jCuf6TOrS74=; b=mKOysCdZeZWTNWqLf+Bzadz+LE
	hdmbiLb63rsYliFWxPtKDoUUg6CcLLEWaSuDAu2YSMWmCuv1jkj3Gb+hPepJqDkGPXXJBJX/9z/Sw
	hoK4ukr1QftYWALNwtqTlFqPP8AbsjFeE/BSN2fp3ZOO6UsQkLZCcQsgo7O+2HI7I/rkidPzN0Or6
	H+UIzYyIxT8LlG5uItHzfTCnqbODRWOIXmnOq6EFXC+zuyuFwzUEqsPvX5t/mO+XHqZky725Chrjk
	D69wqPxo7Xm3iKxAIRWgU/8yD/NNOwIPJ/VGeDFzhYHQxXlnGNoeADpK3DmxIDYQ7yZvjpQXsvcSR
	B/MfOVWoZS+ZE+7/YxVNiXeU3+G+oerk+i6zBHY9hwt4abM5tC0PlsKqISq0wbeQr5ZrD7sk+eNiq
	u/5FJ/lAvsdOOj1aLtmcfoZAlqYgWgIaieLsS9Q3UFPLvJA6AeIJdnzP9PUqXr/voemVIXvISguAO
	xI+M4mrE4SHponVJAgdmBWRx;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ujuCX-001Vb4-1w;
	Thu, 07 Aug 2025 06:34:09 +0000
Message-ID: <df4905fb-933e-4055-8363-d6427515773b@samba.org>
Date: Thu, 7 Aug 2025 08:34:09 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Using smatch and sparse together (Re: [PATCH next] smb: client: Fix
 use after free in send_done())
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
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <a1a0046c-f47f-4e8a-ae3c-85db58a6cb2f@suswa.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 06.08.25 um 16:39 schrieb Dan Carpenter:
> On Wed, Aug 06, 2025 at 04:17:41PM +0200, Stefan Metzmacher wrote:
>>>> What was the test that triggered the problem?
>>>> Or did you only noticed it by looking at the code?
>>>
>>> This was a Smatch static checker warning.  You need to have the cross
>>> function DB to detect it.
>>
>> Ok, I'll try to integrate it into my build flow...
>>
>> Does it replace sparse or does it run in addition?
> 
> In addition.  I find the Sparse endianness checks especially useful.
> 
>> If it replaces sparse I guess a small script would
>> run them both?
>>
>> $ cat mychecker.sh:
>> #!/bin/bash
>> set -e
>> sparse $@
>> smatch $@
>>
>> And maybe all others from
>> https://gautammenghani.com/linux,/c/2022/05/19/static-analysis-tools-linux-kernel.html

I'm using this now:

$ cat custom-checker.sh
#!/bin/bash

set -e

which sparse > /dev/null 2>&1 && {
         sparse -Winit-cstring -Wsparse-error $@
}

which smatch > /dev/null 2>&1 && {
         smatch -p=kernel --fatal-checks $@
}

$ cat build-fs-smb.sh
make modules_prepare
make -j16 M=fs/smb CF=-D__CHECK_ENDIAN__ W=1ce C=1 KBUILD_MODPOST_WARN=1 KCFLAGS="-Wfatal-errors" CHECK="$(pwd)/custom-checker.sh" $@


I'm currently getting these warnings:

client/sess.c:436 cifs_chan_update_iface() warn: iterator used outside loop: 'iface'
client/sess.c:444 cifs_chan_update_iface() warn: iterator used outside loop: 'iface'
client/inode.c:1703 cifs_root_iget() warn: passing zero to 'ERR_PTR'
client/inode.c:2295 cifs_mkdir() warn: passing zero to 'ERR_PTR'
server/smb2pdu.c:3754 smb2_open() warn: Function too hairy.  No more merges.
server/smb2pdu.c:3754 smb2_open() parse error: Function too hairy.  Giving up. 18 seconds

Is there a way to use --fatal-checks but turn the 'too hairy' and maybe others into a warning only?
Something like -Wno-error=... in gcc.

Or at least turn this into an error:
client/smbdirect.c:292 send_done() error: dereferencing freed memory 'request' (line 290)
Without --fatal-checks smatch still returns 0.

While this returns an error (without --fatal-checks):
server/smb2pdu.c:3754 smb2_open() warn: Function too hairy.  No more merges.
server/smb2pdu.c:3754 smb2_open() parse error: Function too hairy.  Giving up. 8 seconds

Currently I typically use git rebase -i and then have some like this

exec bash build-fs-smb.sh C=0
pick 123456 my first patch
exec bash build-fs-smb.sh
pick 654321 my 2nd patch
exec bash build-fs-smb.sh

So I force C=0 on the initial run in order to avoid hitting the fatal Function too hairy
and it then works with my default of C=1 if I don't change fs/smb/server/smb2pdu.c
(or with --fatal-checks and other file that has a warning)

I'd actually prefer to use --fatal-checks and C=1 in all cases
in order to notice problems I'm introducing...

>> How often do I need to run smatch_scripts/build_kernel_data.sh on the whole kernel?
> 
> The cross function database is really useful for just information
> purposes and looking at how functions are called.  You probably
> would need to rebuild it four or five times to get useful
> information, unfortunately.  I rebuild my every night on the latest
> linux-next.

I have the following files generated on a fast machine:

$ ls -alrt smatch_*
-rw-r----- 1 metze metze     303104 Aug  6 15:42 smatch_db.sqlite.new
-rw-rw-r-- 1 metze metze    3107065 Aug  6 16:37 smatch_compile.warns
-rw-rw-r-- 1 metze metze 2848012813 Aug  6 16:37 smatch_warns.txt
-rw-rw-r-- 1 metze metze 6016192672 Aug  6 16:38 smatch_warns.txt.sql
-rw-rw-r-- 1 metze metze 4202917492 Aug  6 16:39 smatch_warns.txt.caller_info
-rw-r--r-- 1 metze metze 8757637120 Aug  6 16:57 smatch_db.sqlite

I copied them all to my laptop where I develop my patches
and was able to reproduce the error :-)

Do I need copy all of these or is smatch_db.sqlite enough?

Would it be possible that you share your generated file(s)
via a download, that might be useful for a lot of people.

Anyway thanks for all the hints so far:-)
metze

