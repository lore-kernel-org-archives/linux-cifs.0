Received: from bumble.birch.relay.mailchannels.net (bumble.birch.relay.mailchannels.net [23.83.209.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E2D3750D6
	for <linux-cifs@vger.kernel.org>; Tue,  3 Mar 2026 02:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.209.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772504962; cv=pass; b=IvHMPxgCdVFPoHoXsYo5JP7Ksc7JYWag1A95drgP/Rbr6Yc8TsgUvivljOQklNMyCUuGfcfPQew/cLJ1QhI3r8mgCgArMUS3UmWLW0PDXuvMf8ER11K5rE1NgSNrFAJy2sXkbmWOknLEkj0Ec8SKLkttGhl7SnqtrLrabrIa+kI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772504962; c=relaxed/simple;
	bh=yCiCKf9oe9wzot7oht6wH4q5G7otN4FMbakyeFhJOOM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:References:
	 In-Reply-To:Content-Type; b=E2BWPWTUcW3KgGWE1xi8CJVDCbBID+dHVmkYp1YZvEFq6297uEcFONYZ+Ksi/F8Xg8w41Fuw+yl8GDcRY6okzCuurkaSEWltpMxnbDtXkeVr17ghrOVIxriZWR91vPPpQsPdwr+GydXZ8kZS5fegT3hQghthZznH/JcVPTlE1ug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jdlh.com; spf=pass smtp.mailfrom=jdlh.com; dkim=pass (2048-bit key) header.d=jdlh.com header.i=@jdlh.com header.b=oY6sYzNl; arc=pass smtp.client-ip=23.83.209.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jdlh.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jdlh.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jdlh.com header.i=@jdlh.com header.b="oY6sYzNl"
X-Sender-Id: dreamhost|x-authsender|jdlh@jdlh.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 65B734C29DA;
	Tue, 03 Mar 2026 02:29:15 +0000 (UTC)
Received: from pdx1-sub0-mail-a229.dreamhost.com (trex-green-9.trex.outbound.svc.cluster.local [100.110.51.5])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 086DF4C2B2B;
	Tue, 03 Mar 2026 02:29:15 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1772504955;
	b=eKBwBD569dH0HOU+aolLe1XXL6G46aInXAZLhHFZn/qM/nYxdmRG2UUI8t/yl+UaIu2SfI
	cNCCt3tVB5uCUDwBHcJDgbTHgygFaReuDDTzhupgbisDvuTiHW3AaVG8so6j3mos2YfKH1
	cJzUxSDnZXsx6QZPBah878clZXP6OTCIZjqHNGttAXReOpKUIzQY7qOsQ87hEDVPGfXh+k
	gg917N3uepEFWuZQCuJkLeKMkr9k8hhbUHdJUx4bHhfHl0RXeR9lNTpntki/VZqIiKFeZD
	HuwSKYuSnwxM9Lw4AF2oAxayiXi6H0icDH3MLNQMTsFLU5aur1xC5JafCKIA8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1772504955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jGLHVoLsBWeVHaXAmSLrm5cX7jvF7AZ+mAcltvSRzX4=;
	b=Op6Rx0sPvMzdQY4UBpRtQ2kJy5V3DBW06tnLIM2z8EOYgh1hC7v26BvTjc2FZvdqQ9rR/H
	kJRBODtcSiurhPtttOLqQu6ydhXyGBx7xkGi/mXdJ+6NhsKHnf3iJ1wx61GhPEeaoLNP35
	+WKDx4z0UT9KrKmFf8Pe45kr4hWqe2zz8ZmgoJ6OWM2Y+cKMNGyry8qJWJy5n2EW/dCIcT
	Zpf6LCk5jl6hrz7KxvC4AKj74eTpXDBld1ZSUYXL0Ld0lR4KoantnJKb6TCqDhbVD0vgTo
	9dCN6UUhkRcIvhAnGVuo0OcdoJYpa/r3LOFV/E8w8qctgwTyeZAj/909g6aEZA==
ARC-Authentication-Results: i=1;
	rspamd-6fbd58c58b-mlnxq;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=list+samba@jdlh.com
X-Sender-Id: dreamhost|x-authsender|jdlh@jdlh.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|jdlh@jdlh.com
X-MailChannels-Auth-Id: dreamhost
X-Hook-Snatch: 1bc725a57facb897_1772504955297_894840921
X-MC-Loop-Signature: 1772504955297:3352777250
X-MC-Ingress-Time: 1772504955296
Received: from pdx1-sub0-mail-a229.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.110.51.5 (trex/7.1.3);
	Tue, 03 Mar 2026 02:29:15 +0000
Received: from [192.168.0.214] (107-190-30-52.cpe.teksavvy.com [107.190.30.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jdlh@jdlh.com)
	by pdx1-sub0-mail-a229.dreamhost.com (Postfix) with ESMTPSA id 4fQ09k5jhdzV5;
	Mon,  2 Mar 2026 18:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jdlh.com;
	s=dreamhost; t=1772504954;
	bh=jGLHVoLsBWeVHaXAmSLrm5cX7jvF7AZ+mAcltvSRzX4=;
	h=Date:From:Subject:To:Content-Type:Content-Transfer-Encoding;
	b=oY6sYzNlHHV7qs7EG1WspbxY/V+uvTiWOy4lttz6evgbFcCYAr2PGO7Ao4MX6pJPM
	 4PgRQ9cuqCZjxjHfU4EOy/4HpwMBMzeb/bpjWaMq7OudR4+xWy9/swSyJwh7r4cNft
	 rYu/L5D13i3Sve5ggeciEdc7cDLao2pquxgGiy46gJS3hy+brw7ub9k0mqj1ZNE009
	 0LI0rmYyI/FJDLvbG9lDn2FXVa51kR2tAvA+YbVGGqHg8riEUVOG/41wD9kturq7IE
	 zDR1xys9kM9rB1Sj47TBKrlw9FJGmq1spk4I7mTi0KRW4+aiqa2jTGHWY0e5lzhyY/
	 +dIPTbx5sYDoQ==
Message-ID: <c7d6dab4-40c6-4a62-9b29-c3f9828c89e1@jdlh.com>
Date: Mon, 2 Mar 2026 18:29:14 -0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jim DeLaHunt <list+samba@jdlh.com>
Subject: Re: [Samba] SMB3 Unix Extensions - creating special files
To: samba@lists.samba.org, linux-cifs@vger.kernel.org
References: <1124e7cd-6a46-40a6-9f44-b7664a66654b@ed.ac.uk>
 <7082aea3-b28b-4ef5-9b5c-64d5d8b78cbc@samba.org>
 <a4a32c8e-3b7f-4748-8c50-48f18e8980b9@ed.ac.uk>
 <45403dd0-b481-431b-8641-234978e48b1b@samba.org>
 <4d0f156024f06daf3e0c3794c3fed854@manguebit.org>
 <dbb8e4be-6e90-4ab7-a2d3-52daad3fff2d@ed.ac.uk>
 <b35e6347503b65febbd0cbec69e52ab1@manguebit.org>
 <CAH2r5mt_9GcPqg+v9QLXEroKJ9RQZ1MwtpPgprU+xHOSksiWqw@mail.gmail.com>
 <0e9ebf38-6aa6-4498-a2cc-726b9c84aa4f@ed.ac.uk>
 <1ee7cccb5fc35163cd8d0ed7777b37c0@manguebit.org>
 <DB7PR05MB57711EF45DD1CFC24471B84BB17EA@DB7PR05MB5771.eurprd05.prod.outlook.com>
 <63195a70-5978-4389-8016-6f2591d262d6@math.lsu.edu>
 <901186d6-ade6-4949-9a1e-773c082cc5cf@samba.org>
Content-Language: en-CA
In-Reply-To: <901186d6-ade6-4949-9a1e-773c082cc5cf@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2026-03-02 17:13, Jeremy Allison via samba wrote:

> On 3/2/26 4:41 PM, Nikkos Svoboda via samba wrote:
>>
>>    Jumping in here briefly, I believe the "default" symlink style 
>> requested by the client mount options is now "symlink=native", which 
>> creates the 0-sized files with extended attributes on the server.
>>
>>    I'd also like to know:  Is it intended to allow creation of 
>> "actual" symlinks on a supported server filesystem via unix 3.1.1 
>> Extensions? The mount option "symlink=unix" (which creates "actual" 
>> symlinks on the server), when used with SMB 3.1.1 unix extensions, 
>> causes symlink creation to fail on the client with "Operation not 
>> supported" (client kernel 6.17, ubuntu 24.04). That mount option 
>> appears to be referred to as "SMB1 unix create symlink command" which 
>> I presume means it is limited to the SMB1 unix extensions.
>>
>>    The archived e-mail conversation chain here (though it includes 
>> some outdated information) helped me to understand some of what the 
>> symlink= and reparse= mount options were intended for:
>> https://lwn.net/ml/all/20241007183650.aw3skuztljpgk2bs@pali/
>
> The goal (at least when I was involved with this effort) was to
> explicitly *ban* SMB3 UNIX extensions ever from creating server-side
> symlinks.
>
> Such activities are inherently unsafe and a source of many, many
> CVE's.

The SMB3 behaviour with server-side symlinks baffled and obstructed me 
greatly, when I switched from connecting my Mac client to the file 
server via AFP to connecting via SMB.

I think there is a conceptual difference here. I think the Samba 
documentation doesn't do a great job of making it explicit. This can 
result in people talking past each other when it comes to symlinks (and 
filename normalisation, and more).

I regard the files on the filesystem as the primary and long-lived 
asset. I regard the filesystem as some sort of idealised POSIX 
behaviour, including symlinks for internal references from one part of 
the served content to another. The data content lasts decades. In that 
time, the server file system may be Linux ext2, then Linux ext3, then 
ZFS. The clients may connect via AFP, or NFS, or SMB. What I want from 
every file access system is to present the server file system transparently.

In contrast, I think the baseline Samba mindset is that the SMB 
presentation of the server content is the primary asset. The presented 
filesystem is some sort of idealised Windows network server. The 
contents of the server filesystem are opaque. The physical files on the 
server should only be accessed via SMB, not by AFP or NFS or by software 
running natively on the server.

If the contents of the server filesystem are opaque, it is 
understandable that SMB might represent what look like symlinks to the 
client as SMB-specific Minshall+French format files. It is 
understandable to SMB might regard server-side symlinks as inherently 
unsafe.

If I could find a way to explain these different conceptual models in 
the Samba wiki, and link from the SMB3 Unix extensions documentation to 
that explanation, I feel I might help other people who are looking for 
the same transparency from SMB which I am. But I have the feeling that 
the conceptual difference is so implicit that there is not a good place 
in the existing structure to put it.

Best regards,
      —Jim DeLaHunt


-- 
.   --Jim DeLaHunt     http://blog.jdlh.com/ (http://jdlh.com/)
       Vancouver, B.C., Canada

