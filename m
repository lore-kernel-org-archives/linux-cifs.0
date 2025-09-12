Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFBB303C80
	for <linux-cifs@vger.kernel.org>; Fri, 12 Sep 2025 12:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757680326; cv=none; b=dIjDDpU8brOSIEl6f4zvhkFWPJ3ckao0KwV+h1pM7Q1UIN8bRlZloVrMV5jTrb+KMaFfrxHwp3FcYwdftC4LQrBSmDaSEa50pIMZlCfCmJGbXuUbOJ+Gc6eL9oR9U1AbU/TRG6rlOoVy9hcyk26RnL1bkXchLLyIVYG+xUeoRvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757680326; c=relaxed/simple;
	bh=p1OFMbDCsLhEakItfHscdodfLAFPaHjn8HQyM8oZ7Wo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gf1GwrB4pxItG4eAz/+sKrdYbYIw6ysS5QZH7Gm/I6l+jBt+mKcr9IDa16z85dpM4V+dxzmY2rPunGOak4b1OLRRWp3C3OGZAm7MWj0PL54dj+D1iNABgfCWu7c1/47GYfO4GRusi7lpjmrHghFZ4gnvIe9O90tZnsfRK3Bvmso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=B9BYRApQ; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="B9BYRApQ"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3e7643b0ab4so997181f8f.2
        for <linux-cifs@vger.kernel.org>; Fri, 12 Sep 2025 05:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757680322; x=1758285122; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MhU5riZeM03kztEpEaccWLxYizcvln+7evxjEjxZ7js=;
        b=B9BYRApQ7m0/13wCYKtBR4VOtX4E57ZMl/JmCykPuJ2NRQTliw97O7OZlinY85ASEY
         lW6FSO//24qXHN2tczxpyhCm8SnErcA8Ztb1mI4T2SMNOxdYLkBKESbGY2cwup5rJDqj
         70ae8gib/bIOr22ZQYLhqHqfMuheUzhjIsOYdnQaoaGbV2BJt86BkFo8E4DYq1MgqhvT
         W4vnC3mZT1jXeltSgLTJqPbxHuWxaY+5wUqy+9ShKytX+o68K82hdn0hs+HEwJj86Mf6
         1opaOtlDwI6Z5xvhPTqBVWyXhVC3htqZv/Fnt77t90ep3rhHZkgvuMsEJlCygNhJIycz
         UMKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757680322; x=1758285122;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MhU5riZeM03kztEpEaccWLxYizcvln+7evxjEjxZ7js=;
        b=ia5SXAYrMBghry3eWGYPiM/+ahl49G4shileoh9AOwE3h6TTDmAYVASPdtlklL8+MT
         iRJbwMJIpKk5hFsZVUBrO/zrAi5XZihGSyI6Fk9u0opAqcz8BiOxRZI4xF491mkVoEab
         PGIQPuZwuQsGOA2af/MOn5gShSXXDKKk6ng/Ebf9jkReNvyiyi17u5BWJzIj9YqA7m72
         DVybSTNZUz0hcCq7uruWDi7mo3q48BVDYQ4pje38xP+Z9s7/4KM5BJOIUEiKQGMedHIe
         UJAxR1lEsPAM44B1b6DOLdw+5c7Qn33YSRT0SaQahqDA9oYZYvejJkCVBK4oYFfio/7Z
         /HSw==
X-Forwarded-Encrypted: i=1; AJvYcCUiKAkRvcJJ9WkurLafmIz+ojjbZihT+QguBFUttyejc3TIk67fbXvspfmpzY5COrNF0SIhQ3FS4d0g@vger.kernel.org
X-Gm-Message-State: AOJu0YwqUgcZW+8RK4z4FglY1HgYIVkNgl+/LK88t8vC7GM5/+iwTyNm
	Aq3HXd0uqbMBAlh8xV97F/TNj0/BPs9UaecJBdBOqG46KpUvuymfXvEWjPkjdM5Q8m4J5R7qh9u
	IxFCZtrI=
X-Gm-Gg: ASbGnctFjVK2IfWYdDWU/8a9NcBdt01MkbOUU7lDXc5dUq0GTzffeUGjUo60grcxXdX
	6XHJe+cE7OOAzy/7XQb/AZOJziIP5K5lhQ2hMJhcC/6KGniUwMvW8ioKj1QKvHEhEH/xVurI1GM
	pWS4EYYmjwQb+YjfQYdWjNtedzl5pp391Mfx3W958wXpJPDGl/U9cScQMwgAxqj7fmd6vHuB06w
	zPufkez6Bova03wNOX5KnZKqsOm8mU5qNs8Lx7DWf/TLR8b6fbE8aN9UdkFRuncMSE1xbH795pl
	bFVGN89WlS0l+So1OBj7OeA3WACWq7t2QieoLBNAFxVsCMEXjTX+wGFbosJW2ksqeznZJGWooQr
	NH+t7/AYgsbjYIDqTHXmPOze2G/k1Ya6NM5oqt8rvq+/UOZCuwNHKkaUfqo2AOYpMW0XqCp+OlP
	pX+eOo+AuFQ1P66w==
X-Google-Smtp-Source: AGHT+IErpxtcpXC9FSZRV6ULpC/ZXj52/cQIDV28ADEsC4BJWAJuLtoXl2JOOCX5QofNoOSZcFshvg==
X-Received: by 2002:a05:6000:26c6:b0:3e7:4c93:18bc with SMTP id ffacd0b85a97d-3e765a092c1mr2365137f8f.49.1757680322543;
        Fri, 12 Sep 2025 05:32:02 -0700 (PDT)
Received: from ?IPV6:2804:7f0:bc02:9180:8dff:c7fe:5faf:7356? ([2804:7f0:bc02:9180:8dff:c7fe:5faf:7356])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c3a84a772sm47006505ad.70.2025.09.12.05.32.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 05:32:01 -0700 (PDT)
Message-ID: <356b6440-b333-47d8-b52d-4f5bbec4c046@suse.com>
Date: Fri, 12 Sep 2025 09:29:57 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: client: skip cifs_lookup on mkdir
To: Steve French <smfrench@gmail.com>, Stefan Metzmacher <metze@samba.org>
Cc: ematsumiya@suse.de, linux-cifs@vger.kernel.org,
 Bharath SM <bharathsm.hsk@gmail.com>
References: <20250909202749.2443617-1-henrique.carvalho@suse.com>
 <CAH2r5ms_Nr0qt=Ntg4dBNXxrPhCNdKPg5qWW1BhBkt281fw2yQ@mail.gmail.com>
 <CAH2r5muyRvOn_OgKimn05V8o-XDt8SVdDzVU7peRmT_KGNzdkQ@mail.gmail.com>
 <bdfb29eb-35ab-473c-be08-1e0857c3c96b@suse.com>
 <b4373c49-6c3e-40fd-b942-b7a967833eaa@samba.org>
 <CAH2r5msehyTqjT_bpsw_t6CqUM00ZSOWPWmbfBTBvT02Uno7pg@mail.gmail.com>
Content-Language: en-US
From: Henrique Carvalho <henrique.carvalho@suse.com>
In-Reply-To: <CAH2r5msehyTqjT_bpsw_t6CqUM00ZSOWPWmbfBTBvT02Uno7pg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 9/11/25 11:54 PM, Steve French wrote:
> I have confirmed that it is patch:  "smb: client: skip cifs_lookup on
> mkdir" which causes the generic/005 failure (and also an umount leak?
> that causes rmmod cifs to fail) but interestingly this patch does seem
> like the one that "fixes" (or at least works around) the generic/637
> (incorrect directory contents with dir leases and new file created)
> failure.
> 
> Let me know if updated version of this patch to test.
> 
> On Thu, Sep 11, 2025 at 8:55 AM Stefan Metzmacher <metze@samba.org> wrote:
>>
>> Hi Henrique,
>>
>> I'm also seeing problems with generic/005, before failing
>> it hangs a long time here:
>>
>> root@ub1704-166:~# ps axuf | grep D
>> USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
>> root         917  0.0  0.1  53408  3328 ?        Ssl  15:33   0:00 /usr/sbin/gssproxy -D
>> root        1037  0.0  0.2  10888  7508 ?        Ss   15:33   0:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
>> root       11704  0.0  0.0   2824  1636 pts/1    D+   15:49   0:00  |           |           \_ touch symlink_self
>> root       11720  0.0  0.0   9784  2564 pts/3    S+   15:50   0:00      \_ grep --color=auto D
>> root@ub1704-166:~# cat /proc/11704/stack
>> [<0>] wait_for_response+0x195/0x250 [cifs]
>> [<0>] compound_send_recv+0xb9d/0x2ac0 [cifs]
>> [<0>] cifs_send_recv+0x22/0x40 [cifs]
>> [<0>] SMB2_open+0x352/0x17b0 [cifs]
>> [<0>] smb3_query_mf_symlink+0x1c0/0x3a0 [cifs]
>> [<0>] check_mf_symlink+0x281/0x7a0 [cifs]
>> [<0>] cifs_get_fattr+0xc5f/0x21b0 [cifs]
>> [<0>] cifs_get_inode_info+0xad/0x460 [cifs]
>> [<0>] cifs_do_create.isra.0+0xe4c/0x2250 [cifs]
>> [<0>] cifs_atomic_open+0x4f5/0x1120 [cifs]
>> [<0>] path_openat+0x244e/0x47a0
>> [<0>] do_filp_open+0x1e3/0x440
>> [<0>] do_sys_openat2+0x100/0x190
>> [<0>] __x64_sys_openat+0x127/0x220
>> [<0>] x64_sys_call+0x1bce/0x2680
>> [<0>] do_syscall_64+0x7e/0x960
>> [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
>>
>> I'm using these mount options
>> -ousername=root,password=test,noperm,vers=3.1.1,mfsymlinks,actimeo=0
>>
>> I hope this helps tracking it down.
>>
>> metze

Thanks, metze and Steve,

Two notes from digging into this:

->lookup() does not seem to be able to distinguish mkdir vs symlink as
both arrive with the same flags. So the "skip cifs_lookup() on mkdir"
also affects symlink.

For most cases, this seems to work fine, but after `touch` on a
self-symlink the trace shows more creates than closes, leading to leaked
opens on the server. Does this make sense?

# cat /proc/fs/cifs/Stats | grep "Open files"
Open files: 4 total (local), 4 open on server

I'll rework the patch and post a v2 once I fix this.

-- 
Henrique
SUSE Labs
