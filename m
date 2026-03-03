Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A877C191F84
	for <linux-cifs@vger.kernel.org>; Tue,  3 Mar 2026 00:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498490; cv=none; b=mS9R+TaS3x7oKt1oCgGBKhKetT1kA6/I/+Oboc8+WpFwgDvj5JVxIBcBZJScTvrPkob+nBYMPm3eSP3L5EzQBesDCnZrtd4uSAWtbHji0WZRE+20RT7+kIsjKCuegO8Na+NwNY+0Ps3CcQNf6lOEZt8HjtXfJIYiyOfcjPWPkMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498490; c=relaxed/simple;
	bh=0YHxYX348zwyIKd/azJMpxWZ5aHQvZUIVF4Cz+9xqKE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=bskayJy56kQfkQGnG/bG4IkazB8yTUEoGXarid6D3e+d0gjU0B4Ee4Z1wYrYVcuXk8zUQW0pwk6MDPNlQSsRRMeDGBVJjigwxMCDMc902G3wb6X8FrN1R0InBY6X/PzwdCkhqTVq2LfGBCQbDfajrS5aICK4fSD50iBD0Ikt/NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=math.lsu.edu; spf=pass smtp.mailfrom=math.lsu.edu; dkim=pass (2048-bit key) header.d=math.lsu.edu header.i=@math.lsu.edu header.b=CBFcaluK; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=math.lsu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=math.lsu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=math.lsu.edu header.i=@math.lsu.edu header.b="CBFcaluK"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-415d7461fa5so44131fac.2
        for <linux-cifs@vger.kernel.org>; Mon, 02 Mar 2026 16:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=math.lsu.edu; s=google; t=1772498486; x=1773103286; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3yGoz2Dlx4UbM7q1ZCmze9p4Q9867VyZ8uRtF35lnRE=;
        b=CBFcaluKTI62SzWrIrNnuG+wd3zBm9ZhXFjAEb5hFEuVJwKbjJ6EkU3gYLLA+E0pD3
         LfY9TdSE0CFas3Ri124KEnLwCCvk57oBAzOebt3Q9maYUMfzz/OUvA5Ka3+PgvsWS4JA
         QmEeFPPgVViU1c+5e4+l3auu5A+NQwvj0GMzg0xvG68mDXrFrGwlC6Z68Jc6AeEBknYA
         xxPuSrGco40/DQX7dm70jCz9sze/5JBRQzAWKQsn6pyy40vnhfwv9IsH0vxfcjmoR0Bg
         korSmeql41Q5lbOXTfNhoBCNY0L1gL2rQAfwLSlKiLYUcGkX/U5H7XZRraQgf0RgkprZ
         ayJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772498486; x=1773103286;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3yGoz2Dlx4UbM7q1ZCmze9p4Q9867VyZ8uRtF35lnRE=;
        b=nfOvpfNU2jKRSHvhZ7k7oV8IHwO+rYwP2xrJyfTmDKgu4+Etxw6LAcBSah9mA5opv2
         eHxmz2Hvsjl0S96u36h+yPofIKJMO3abRAM1WZ2gc6m+JTK63wFL+M+0P0LXM2pXr0aZ
         0bCCaekMbeyaxkUEmhSw/x/ykP4+0RoVidJz1kzpjYqPU2VzJfvuLM/HswY65tRkz1Y3
         BP7mzq5KxVa+UYo2GoMry5rpnm4iCIlsIqZyXxj/zCISuFSHBAjMrrDDPFYQrVqluc1y
         P8W/+X130KaZu1voQvhAe9gv1vHlXkV6+iW4GlsUcsKNN9XCsRLAUlaHDU7WJ4veJ7RS
         MbHw==
X-Forwarded-Encrypted: i=1; AJvYcCUoujqCCZ8xkkU5l/mv+kewmEik8SQEzhTzdN+NNS29sNAi4v5VcQKCc283B7ngDgZZsZQTIe4HqACg@vger.kernel.org
X-Gm-Message-State: AOJu0YyODtwNlhOCfhKiFnxtkpaQCXO8V7sW344782Pj6lg3mC8K6fk9
	Yss2+lAid60oQsdZePYih0wqxNJ6wIMKjDJP6qdWT5CEo4F9nHCJyQ2zfZb11zRN013mtS0MXwR
	mRF5j
X-Gm-Gg: ATEYQzyrHVIqnbp4bGb0T+D/4qS7iz4h/g8SJFk/7eZ8nBH2CD8erpGxrnZ2p15Zp2K
	t71L3UcDtRFDErle/tdEbpWo5rGbBIvckC8eFt+M7gjys5qXspirloPTAuoQofBej5pcHns1q7u
	9kXxLF1VKgm1zfln1yyh+INqA2kL5imu2mugPXD12uvNEsKIqWY39ikebdN9F1WQle4jHABvLzO
	1m1lOKdOXZ8UcuzG/UXhKOooUL5gwn6SX1dGlMde3CHNGzFsgMDCVbpmaEL2U9fJeJMEURMjEMX
	Zg2UN02sI2T3U9gRKyKYa/S/xgqhZYatUx/w7s85fpNnC7eDcuG7v0UFakCrqYwZteYvA7rivVU
	BB683boytdUzVaXIVbPCxNFeZD0E4skRJFAA977iA4XZM+QBpnAA5zDSCaqasE78kMeUXAZGP1m
	0DGhXT6qqbQj5wztbngqoH71/DyLKwb1YxQ4qItUHHCwTZcj7qkuuc/MMUEymN9z+vWR4kd1njd
	0k33EGrOx1FP5jj57Fmk4yidcuE8CKaDid4ejdivo6l9sxj1DrC5YKEG/skWw==
X-Received: by 2002:a05:6870:24c:b0:409:5ae6:319a with SMTP id 586e51a60fabf-41626da0300mr6963663fac.1.1772498486233;
        Mon, 02 Mar 2026 16:41:26 -0800 (PST)
Received: from ?IPV6:2620:105:b002:2100:538a:f89d:7c57:26a7? ([2620:105:b002:2100:538a:f89d:7c57:26a7])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4160cff1aacsm12768388fac.9.2026.03.02.16.41.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 16:41:25 -0800 (PST)
Message-ID: <63195a70-5978-4389-8016-6f2591d262d6@math.lsu.edu>
Date: Mon, 2 Mar 2026 18:41:23 -0600
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [Samba] SMB3 Unix Extensions - creating special files
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
Content-Language: en-US
From: Nikkos Svoboda <nsvoboda@math.lsu.edu>
In-Reply-To: <DB7PR05MB57711EF45DD1CFC24471B84BB17EA@DB7PR05MB5771.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


   Jumping in here briefly, I believe the "default" symlink style requested by the client mount options is now "symlink=native", which creates the 0-sized files with extended attributes on the server.

   I'd also like to know:  Is it intended to allow creation of "actual" symlinks on a supported server filesystem via unix 3.1.1 Extensions? The mount option "symlink=unix" (which creates "actual" symlinks on the server), when used with SMB 3.1.1 unix extensions, causes symlink creation to fail on the client with "Operation not supported" (client kernel 6.17, ubuntu 24.04). That mount option appears to be referred to as "SMB1 unix create symlink command" which I presume means it is limited to the SMB1 unix extensions.

   The archived e-mail conversation chain here (though it includes some outdated information) helped me to understand some of what the symlink= and reparse= mount options were intended for:
https://lwn.net/ml/all/20241007183650.aw3skuztljpgk2bs@pali/


----
Nikkos Svoboda


On 3/2/26 09:09, Matthew Richardson via samba wrote:
> Hi,
> 
> Just got back to testing this and wondering if these patches made it into ML?
> 
> I've tested with 6.17 (Ubuntu Noble standard kernel) and latest 6.19 (mainline) and am seeing odd behaviour where it is creating regular files with 'special' metadata rather than 'real' special files. (This might be a different issue of course!). Reading existing special files (created on 'real' fs) works fine.
> 
> I'm basically using the same config as in my original post - server is running 4.23.6 with the following config:
> 
> [global]
>      workgroup = WORKGROUP
>      security = user
>      map to guest = never
>      log level = 3
>      guest ok = no
>      smb3 unix extensions = yes
>      follow symlinks = yes
> 
> 
> [myshare]
>      path = /mnt/users
>      browsable = yes
>      writable = yes
>      read only = no
>      valid users = sambauser #uid/gid 1000
>      create mask = 0777
>      directory mask = 0777
> 
> Client is mounting as:
> 
> mount -t cifs //server.example.com/myshare /mnt/smb -o posix,vers=3.1.1,username=sambauser,pass=testing123
> 
> Reading existing special files created on real fs works fine:
> 
>> stat test_local
> 
> stat test_local
>    File: test_local -> test.txt
>    Size: 5               Blocks: 1          IO Block: 16384  symbolic link
> Device: 0,49    Inode: 1099511631046  Links: 1
> 
> I can then do:
> 
> touch foo
> ln -s foo foo_link
> 
>> stat foo_link
>    File: foo_link -> mnt/smb/foo
>    Size: 23              Blocks: 0          IO Block: 16384  symbolic link
> Device: 0,48    Inode: 1099511629531  Links: 1
> 
> However on 'real' filesystem:
>> stat foo_link
>    File: foo_link
>    Size: 0               Blocks: 0          IO Block: 4194304 regular empty file
> Device: 3ch/60d Inode: 1099511629531  Links: 1
> 
> getfattr -d x_link
> # file: x_link
> user.DOSATTRIB=0sAAAFAAUAAAARAAAAIAQAAJmcGa5UqtwB
> user.SmbReparse=0sDAAAoGgAAAAuAC4AAAAuAAAAAABvAHAAdAAvAGMAZQBwAGgALwBzAGMAcgBhAHQAYwBoAC8AdABlAHMAdAAvAHgAbwBwAHQALwBjAGUAcABoAC8AcwBjAHIAYQB0AGMAaAAvAHQAZQBzAHQALwB4AA==
> 
> Any suggestions appreciated as to what's going wrong - happy to provide network traces if that's needed.
> 
> Thanks,
> 
> Matthew
> 
> Matthew Richardson <m.richardson@ed.ac.uk> writes:
> 
>> I've just tried the 6.16 kernel from mainline (Linux vm-b
>> 6.16.0-061600-generic #202507272138 SMP PREEMPT_DYNAMIC Sun Jul 27
>> 22:00:36 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux) and while mkfifo works
>> again, ln -s is still giving 'operation not supported'.
> 
> Yes - mainline is still broken.  I'll send a fix soon to ML.
> The University of Edinburgh is a charitable body, registered in Scotland, with registration number SC005336. Is e buidheann carthannais a th’ ann an Oilthigh Dhùn Èideann, clàraichte an Alba, àireamh clàraidh SC005336.

