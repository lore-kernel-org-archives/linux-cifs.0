Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D393220F50
	for <linux-cifs@vger.kernel.org>; Sun, 17 Aug 2025 14:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755440006; cv=none; b=bYZGVXY0Fn4pOhs4KQy1+I3zBbM8pJMziaIoY6ldysUeYhpheKE1+6qPI62BUM3Gjl1p1QbbBEiLwbBrNDrdHD582Hner0EOPv5sDWTWHoTR/NnxVbYLIc4owhRyexpcb4AqTgG1gCKSvruYg8PljLjNA0Br36UmoQ1/TDCyDPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755440006; c=relaxed/simple;
	bh=xxUzSFNMrY6OtVqT/srD704cnTWvm7Bl0+LDCAmhBwg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HE3JiPFj75BuUCq6wKLFXGO2xu5EbYs0r7CfGpZAbxHDB97oJtgcHc8uptQqgdRJa+SngPWaLb6+yLzk7wQu4NXoq5V0YZH2YGICeulKtN9LwmqRdRLh78maqNsRye1tj0zTNJbAa6SRsB++B1f2XfYTcC9PWC0PinH28yXQ9mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N+FPa7R/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N+FPa7R/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755440003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=9UJFMr/bvImnkz1jqScdSY4U5W7zX30JVrvt90VXP54=;
	b=N+FPa7R/SqYmD77ox2Jks8R1r9CQUBPZDd/UxZx4sKpet/Rui0g8wTw5oMMfzE1s2EbD78
	siyle4Eqwk5IG7UBltJs7XYW7FO5qUhcZVg/a6ZA5rQmWEyJ6Te//Jx88q//e8l8aJcLwf
	cIBgOZA8GCHv3jTZxlznQtMIB2T/krY=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-zJG20uNrMSybXfBsACEZ_g-1; Sun, 17 Aug 2025 10:13:20 -0400
X-MC-Unique: zJG20uNrMSybXfBsACEZ_g-1
X-Mimecast-MFC-AGG-ID: zJG20uNrMSybXfBsACEZ_g_1755439999
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b471758845dso2817429a12.3
        for <linux-cifs@vger.kernel.org>; Sun, 17 Aug 2025 07:13:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755439999; x=1756044799;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9UJFMr/bvImnkz1jqScdSY4U5W7zX30JVrvt90VXP54=;
        b=vpIsvOBKfjt3cm9PBv9EUMmlFCUNZHR7NX3q1+DRth541f85BZgi8SBvXDqVN10XZg
         1K7oCxl/VvD4FWDINVC5vTdIKBqh7fSXmEFAwv/EyMVFYvAz4DWhM752YuQn70R1Y9Ad
         Dvd1HLoflsL2+3WosEmKbKC8l31Y01xr3eQe94IN45EbZj86sebVBPYXbTo4teFFNxql
         geTNJtAzzVy/9Jz6ZBq9/EGTOWIlXCB4t9pX54u4IlwG21UTS/jttvxr09HsqkRNVR7/
         F+OnMyw7h1EWhckrGMglBEspmWHJrkcke++i6u7sMmuSHyTI7YrrrCMDAFxjnGcGfJVR
         C6Vg==
X-Gm-Message-State: AOJu0YwpRQXDACUC5Rz+Hn2muOFym/6Z02mgVonhL/bZ6NSQpOB1CucM
	ZOav8K4jd54sAex/+137VpWXSjL936Kelm7XXWVnPCWaZu98+LcvtgiyPPFdNxIUPmCATS1U5Ne
	UpQmj/zLEgvNujKF/i/qN8L93wJfhXkByyfpsRJx7ztOVeS8zpIIvINmL922PmjpS1F/EBA65uK
	wBF3X+Pf8HV+KGYNnygxsFTZ8UdC7SCG77WTC8cVTPXm4=
X-Gm-Gg: ASbGncv2fyxEpHJtYZIFB0Vt9ERy2qCqk0sLfLCiwCmV7O/5CjcLE8uu3V+xLQNUSrM
	NeSjDBictHo047EpEuMskRJclMQAvnqTCZyvJR942vmmyXNDHMYAkvkDQAXVAOqQZO8wCQcZeBX
	BYCnQqRim/sOvETcBln1U+VrSkI6S6t3NsjhAbVSgnGuMJ8Fx5PZkLDyJhui1GIPn+UlBToWFRK
	TEMtMrOEbsqkjRvNACSDFyCZx/4jPgXr4MK5wvXKte4xm1rzBNYz4Mc9bno3cia5gZWjtOnzTcm
	msGunEkxV7OPDO2nep2ghkzS35hT+goABFFwnD5UOHKo3f1Kbm852WPjzWWn2lveWm3r49uFpsX
	Vb5Xe
X-Received: by 2002:a17:902:d2ce:b0:23f:d861:bd4a with SMTP id d9443c01a7336-2446d89d24dmr112023675ad.27.1755439994142;
        Sun, 17 Aug 2025 07:13:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHl/MT+x18LNEUFZ0WfNPzVQO31ha1MfclnxriMZYq662L4ffIJcvLlhBiPQgd6hfD09C84/g==
X-Received: by 2002:a17:902:d2ce:b0:23f:d861:bd4a with SMTP id d9443c01a7336-2446d89d24dmr112023165ad.27.1755439993042;
        Sun, 17 Aug 2025 07:13:13 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446ca9dc27sm56429985ad.13.2025.08.17.07.13.11
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 07:13:12 -0700 (PDT)
Date: Sun, 17 Aug 2025 22:13:09 +0800
From: Zorro Lang <zlang@redhat.com>
To: linux-cifs@vger.kernel.org
Subject: [fstests generic/478] OFD lock testing be stuck on cifs
Message-ID: <20250817141309.bqoti4r2s57d3zkc@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Recently, I always hit fstests' generic/478 be stuck on cifs [1]. More
informations are as [2], the t_ofd_locks testing is stuck. But it can
be killed by (kill 987167). I'm not familiar with cifs, just try to
do a regression test before releasing fstests. Can anyone help to check
if it's a cifs bug? Or if I should skip this test case on cifs?

Thanks,
Zorro

[1]
FSTYP         -- cifs
PLATFORM      -- Linux/x86_64 dell-xxxx-xxx 6.17.0-rc1+ #1 SMP PREEMPT_DYNAMIC Sat Aug 16 02:11:39 EDT 2025
MKFS_OPTIONS  -- //dell-xxxx-xxx.xxxx.xxx.xxx.xxxx.redhat.com/SCRATCH_dev
MOUNT_OPTIONS -- -o vers=3.11,mfsymlinks,username=root,password=redhat -o context=system_u:object_r:root_t:s0 //dell-xxxx-xxx.xxxx.xxx.xxx.xxxx.redhat.com/SCRATCH_dev /mnt/xfstests/scratch/cifs-client

generic/478
[nothing more output]

[2]
[root@dell-r640-040 ~]# ps -ef|grep 986641
root      986641    8236  0 Aug16 ?        00:00:00 /bin/bash ./check generic/478
root      986882  986641  0 Aug16 ?        00:00:00 /bin/bash /var/lib/xfstests/tests/generic/478
root      989190  989139  0 09:56 pts/0    00:00:00 grep --color=auto 986641
[root@dell-r640-040 ~]# ps -ef|grep 986882
root      986882  986641  0 Aug16 ?        00:00:00 /bin/bash /var/lib/xfstests/tests/generic/478
root      987167  986882  0 Aug16 ?        00:00:00 /var/lib/xfstests/src/t_ofd_locks -s -w -o 0 -l 10 -W -P -K 0x2e94ba83 /mnt/xfstests/test/cifs-client/testfile
root      989192  989139  0 09:57 pts/0    00:00:00 grep --color=auto 986882
[root@dell-r640-040 ~]# ps aux|grep ofd
root      987167  0.0  0.0   3624  1716 ?        S    Aug16   0:00 /var/lib/xfstests/src/t_ofd_locks -s -w -o 0 -l 10 -W -P -K 0x2e94ba83 /mnt/xfstests/test/cifs-client/testfile
root      989194  0.0  0.0   6388  2196 pts/0    S+   09:57   0:00 grep --color=auto ofd
[root@dell-r640-040 ~]# cat /proc/987167/sta
stack   stat    statm   status  
[root@dell-r640-040 ~]# cat /proc/987167/stack
[<0>] cifs_lock_add_if+0x1ac/0x2d0 [cifs]
[<0>] cifs_setlk+0x18c/0x400 [cifs]
[<0>] cifs_lock+0x12a/0x4e0 [cifs]
[<0>] fcntl_setlk+0x176/0x3f0
[<0>] do_fcntl+0x515/0x640
[<0>] __x64_sys_fcntl+0x80/0x110
[<0>] do_syscall_64+0x7f/0x980
[<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
[root@dell-r640-040 ~]# dmesg
[ 2679.340526] run fstests generic/478 at 2025-08-16 03:04:46
[ 2679.502409] sched: DL replenish lagged too much
[113755.975871] sysrq: Show Blocked State

