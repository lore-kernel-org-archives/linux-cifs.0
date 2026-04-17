Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9072235F18B
	for <linux-cifs@vger.kernel.org>; Fri, 17 Apr 2026 17:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776446693; cv=none; b=JbMV/CvBMb+I/sUtDGsq4R5vE8l/SrKQReOXud1Bc0dZwj++T5lnMrbIOHuBtlvbUVHhyxObkprqWMBL7I+i1xEUnNpWeKtAobTzedwmIUq023AsK2wViJRkgwIB4Cj6V0WFD2/scZJr++MFByM+L8Q4K9oTfqOQQdic963Hgac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776446693; c=relaxed/simple;
	bh=oDnZaa51m7FuZjaXLRYECa1UTadvUBScxVzdjFO5VD4=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=VdiITATQ9/hiGdDxMZxdzlbs9Fi5zhDo4yAl4Dh0LUO5VsRo1j3dges6tn3qdOz93//NPzIzaidKKmIxJJ9dHP5fDxUSqu+RiMJs3NtGRmIj5cJaA2uOgQWHPdfeuCOqDSzCCkFeseUxvrIIdwkGKp30GTSWzGGXjVIDw+gu48w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=NPAqDYsS; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="NPAqDYsS"
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 8D2A53F921
	for <linux-cifs@vger.kernel.org>; Fri, 17 Apr 2026 17:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1776446680;
	bh=VIeyA7PnV56DO91CYewm6P++vhCdev9nXK5swi33LHc=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type;
	b=NPAqDYsSkZwtiiY23Rf0UBUUbfbehSa0F3oTybRGn/lKiAnbFghv7D/mwA30DheD/
	 Ht/aVq0BmmKxnV1vj9wLPQrwwIwhQDRZAiH7IX/apXJtY2zshf/UmQc6H7LUtlGHXB
	 oojhiFD+GpXkJve9MEl0r1I2qNQdmHkpgz3nhEyqV9KC/7zaStybKSskrM+5KISBlq
	 9CHtvep3gMYuktw0dmw8R7BhY6QDngrJS0pHGi7s5WQes+zPWTLWuBeZRk6NIhqQR0
	 BBEIfK6X0KtsUz8+mvVyq5zRAWK5VuzKTBsBcDoCzneITs5g2vsM/W1CFB4bK0ZL8n
	 2NXh7squU8vGdkFfzbzD2o2aw9Luvwe/X2MZeShbEGSOgUAIw+IJN4bjdZjFoLW5mt
	 5DuwuxPDa20MHB1iuj2HFV7bmzpNloFuLL+5QkZ3FwLZUJ/NGSUBeXwU31wS5AaWsw
	 dVtgyxJFYRYlzSLkf1NSuY6o0JUWd7AKZcWdM6bteHOwBvOn1I3eQ6UA60J4GcNLOJ
	 Oaa/MeVXnRKY/POMbcuWaS0EBtvLABVYaEpjPQ3iQmG0xnhrEcS4sGZQg5aO1gcXwZ
	 o7rBgzZWG4dalz4Y6jqPFRI7JMRfVMx4HNvgSWOIUIaOD1i1JLg14hgMHb1bdHz24G
	 SA9MDIhT9tw1G2mFcy7hlxz4=
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48378df3469so6309605e9.1
        for <linux-cifs@vger.kernel.org>; Fri, 17 Apr 2026 10:24:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776446680; x=1777051480;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VIeyA7PnV56DO91CYewm6P++vhCdev9nXK5swi33LHc=;
        b=FD4siYBY93pMWqP/JmvZINFSsLAU1qNFasSevLXJHyfNdVLSJ1usBXlL6UmqicujfZ
         4a0WV6TUAhWnJTJQMSZZEjhCWVN1Z7wxa3upu0jBSRe4b/O9ODzMsJA1eEyTSXa0bB2y
         JOn4xwx67l+o3Utd+amJBv4vEPKORgrNAFKZeR9+Ovyzq5QlN+DhxrdjtHxJgnwPXuE8
         ewO8vmUf8TSNnP0lUIY+CIc0TclKr/ttfsDklLOTpbo/0OrSHVc8m4lH1y9KVN22VJ7O
         NHWH7L1EwRb2rmFeh9tyFVoJUBAxJTPuZ/U8YUV1RjKIcqBgzzFg3ROLpftHTYjyf5Oc
         RM8Q==
X-Gm-Message-State: AOJu0YwpoLaJrAc6QveN2t565Oze4I69fYDyoKhrl9iXFYthjr0Y7DYE
	D4PmlT3Cgt9wGBRcE0g6LHnPS90DcBWBrYmqCnbgXH7h8SNmAMOtKq22Jj6KN+xG/WoSVPjEZuF
	QXyw1A95+hi8awxottspD+uHNItBf3ITUzUPNTGYX40aREZYYvVIc2kBk+STOj3858WeBioTdTM
	koEatdbknW/HojkQ==
X-Gm-Gg: AeBDieuxSEkGXajakgZwG85uJXduuN/SXOWFTkHlbsAf3DhA0hMccN1Zme6nzO1k7h6
	PqB1NqGU7UAVK98lEpUrvp/U4u6QmneCkHDtFNQm6+wSh2ARURtY+VFoGA22xg3AZopQwzl8lx/
	kkXjNEG2/LluLoB+E8kEol8dNVixHptF/PegM4BFhKsqdBzRDKeDzvl0ExzAmjWvbU2///BO0Kp
	fmDwovVOtRY/bZlNrg7P4GoukrFF0PgWMWPiDFjgw58tQSphLWgn15WSg0pBONLQIXep/XkKZ1q
	X8olsEa6aKyEr1enLXE2hTiazO2x839fbrExUkcy7QrKSKyVRwFb4i4UaY2ho22Qgkj/4OyAf6L
	GUUTg5/v7jGVHWte/KwbQOWBpRUtS9bTsZAN0jVe6hmcRiUM=
X-Received: by 2002:a05:600c:c112:b0:486:fe83:861c with SMTP id 5b1f17b1804b1-488fb896910mr44528535e9.7.1776446679617;
        Fri, 17 Apr 2026 10:24:39 -0700 (PDT)
X-Received: by 2002:a05:600c:c112:b0:486:fe83:861c with SMTP id 5b1f17b1804b1-488fb896910mr44528125e9.7.1776446679180;
        Fri, 17 Apr 2026 10:24:39 -0700 (PDT)
Received: from [192.168.1.126] ([213.204.117.164])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc1070bfsm60376675e9.7.2026.04.17.10.24.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2026 10:24:38 -0700 (PDT)
Message-ID: <119442fa-7630-482f-ad0a-83c7f61f8786@canonical.com>
Date: Fri, 17 Apr 2026 20:24:37 +0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-cifs@vger.kernel.org
Cc: Steve French <sfrench@samba.org>
From: Ghadi Rahme <ghadi.rahme@canonical.com>
Subject: RFC: kernel NULL pointer dereference affecting stable
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

There is a kernel NULL pointer dereference affecting kernel 6.1 lts and 
5.15 lts. The bug happens in `find_ipc_from_server_path` when strcmp is 
called with `(*ses)->tcon_ipc` equal to NULL. This state can happen and 
has been observed to happen when the client disconnects from the server 
at the right time. Below is the stack trace:

  BUG: kernel NULL pointer dereference, address: 0000000000000050
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 1013dc64067 P4D 10125f65067 PUD 10125f64067 PMD 0
  Oops: 0000 [#1] SMP NOPTI
  CPU: 80 PID: 3913754 Comm: kworker/u256:1 Kdump: loaded Not tainted 
5.15.0-143-generic #153-Ubuntu
  Hardware name: Dell Inc. PowerEdge R760/09XV41, BIOS 2.3.5 09/10/2024
  Workqueue: cifs-dfscache refresh_cache_worker [cifs]
  RIP: 0010:strcasecmp+0x19/0x50
  Code: 01 84 c9 75 f1 c3 cc cc cc cc 0f 1f 80 00 00 00 00 49 89 f9 31 
ff 41 0f b6 04 39 0f b6 c8 89 c2 83 c2 20 f6 81 e0 39 89 85  01 <0f> b6 
0c 3e 0f b6 d2 0f 45 c2 89 ca 44 0f b6 c1 83 c2 20 41 f6 80
  RSP: 0018:ff4043e68aadb900 EFLAGS: 00010246
  RAX: 000000000000005c RBX: ff4043e68aadbc68 RCX: 000000000000005c
  RDX: 000000000000007c RSI: 0000000000000050 RDI: 0000000000000000
  RBP: ff4043e68aadb990 R08: 0000000000000064 R09: ff4043e68aadb91f
  R10: 0000000000000012 R11: 0000000000000000 R12: ff210c171f193c00
  R13: 0000000000000009 R14: 0000000000000008 R15: ff210d1d3f19a7c0
  FS:  0000000000000000(0000) GS:ff210d127fc00000(0000) 
knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000050 CR3: 0000011f2cc38005 CR4: 0000000000771ee0
  PKRU: 55555554
  Call Trace:
  <TASK>
  ? find_ipc_from_server_path+0xd9/0x110 [cifs]
  refresh_cache+0xf1/0x470 [cifs]
  ? in4_pton+0x7a/0x160
  ? kfree+0x1f7/0x250
  ? target_share_equal+0x198/0x210 [cifs]
  ? __refresh_tcon.isra.0+0x242/0x670 [cifs]
  ? kfree+0x1f7/0x250
  ? __refresh_tcon.isra.0+0x242/0x670 [cifs]
  ? cifs_put_tcon.part.0+0x39/0x220 [cifs]
  ? cifs_put_tcon+0x1c/0x30 [cifs]
  ? refresh_mounts+0x147/0x210 [cifs]
  refresh_cache_worker+0x1ac/0x300 [cifs]
  ? lock_timer_base+0x3b/0xd0
  process_one_work+0x228/0x3d0
  worker_thread+0x53/0x420
  ? process_one_work+0x3d0/0x3d0
  kthread+0x127/0x150
  ? set_kthread_struct+0x50/0x50
  ret_from_fork+0x1f/0x30
  </TASK>

The bug has been indirectly fixed upstream in commit 
6916881f443f67f6893b504fa2171468c8aed915 which remove 
`find_ipc_from_server_path`.

Backporting the upstream commit to 6.1 and 5.15 stable seems risky since 
it does not cleanly apply and requires extra commits to apply correctly.

Do the maintainers believe that going though and backporting this commit 
with any extra needed commits to 5.15 and 6.1 LTS is the correct way 
forward here?

I have already tested two solutions. The first one doesn't fully resolve 
the issue however it is simple, safe and massively narrow down the 
probability of the BUG occurring. The second is a bit more risky but 
fully resolves the issue and I achieved it by adding a few spinlocks.

I am not a fan of option 2 since I found a commit that directly dealt 
with a lock contention bug in CIFS by splitting one spin lock into many, 
and I would like not to add extra pressure on the spinlock in 5.15.

It was tested for days with no issues, however there is always a chance 
that it might introduce deadlocks. The deviation from upstream would 
also be greater with such a patch.

For Option 1 I had send a patch to stable 6.1 [1] and 5.15 [2], which 
was rejected due to deviating from upstream (See email thread of [2]).

So I guess my question for the maintainers is, is it worth the risk to 
backport commit 6916881f443f67f6893b504fa2171468c8aed915 to 6.1 and 5.15 
LTS with any needed extra commits with it, try again with option 1, or 
is the regression potential not worth fixing it in the LTS kernels?

I was asked in [3] to coordinate this with CIFS maintainers.

Thank you in advance.

[1] 
https://lore.kernel.org/stable/20260319144929.455978-1-ghadi.rahme@canonical.com/

[2] 
https://lore.kernel.org/stable/20260319144325.438788-1-ghadi.rahme@canonical.com/

[3] https://lore.kernel.org/stable/2026033136-refining-ladybug-08b0@gregkh/
