Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97231130AFE
	for <linux-cifs@vger.kernel.org>; Wed,  8 May 2024 21:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715203498; cv=none; b=UY+uusaZNKZT/Weg+cY6XplXl4Taon+w3UpGE+B58xisIp6VllKeh6tjQwKnSuCKXr6ivOvof16yqVHDX+L6feCmUHkGkNC3RkBpQRBSdcBFDaLMCF1KeKb8YBnNkqxEgSy2oadijLGIPyHclCCw7NWIB99D+GoCf/fkU5VGAI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715203498; c=relaxed/simple;
	bh=aJ5Cf0/mPhbHg7slyLroqNEDcksca3tgbQDa3XXA/R0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=S4jDfO1a0u5JCGLq2/8dKltGQXeu3yy5t+h1Rq/cGxyUd8NywiiSzoAdaOTVJ+minlgR4e7Lq0UlCaw65weK4AdibIwOFyoMOfvOSZ5ak4zCSedmlu9mVLGpylpEnsrQtrCZeFG7HM+CHyorm9KpMnPX99Z5OLGRQB3SrDGzO94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PxxXKa30; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PxxXKa30"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2e3f6166e4aso3771181fa.1
        for <linux-cifs@vger.kernel.org>; Wed, 08 May 2024 14:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715203494; x=1715808294; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=t1NT3aB57EwYVGzadLVd3D1hR/8JcDDNz3Ic2r68uBo=;
        b=PxxXKa30qc8WsvbUhSKsHwXg6cpjCZ02jMt3Osw6a1jnhrJa4JTYrHxFChx+r7pKMa
         zEyxU+UgDa1/9VTXyZHT1+SwbTPfZ7HOZQxfb1zrRtnvT4qfgm4zRIGoBacaIrOpH58X
         I+5/PJhcTahjSzW1iRz+7klOuJeg5lcQb09nOM6fJjNb6EnH5v7ZNZ/9g6dE9jOiumMP
         oMbtEn5ZaxFfqgBPNl7xfYMXTZQb/LuRtWmUaqzIvX+cKUpqIgPwe78e5Dw+ZiO+bp3n
         nKCf+N8mcH6UF8RQbr0enjYpV2YLZTvCTEaoIqBMvl+WO2nV1RZvNLmmybv2qPk7P2Ny
         qpFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715203494; x=1715808294;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t1NT3aB57EwYVGzadLVd3D1hR/8JcDDNz3Ic2r68uBo=;
        b=QzRSJZHBlZ/YeJMBdf1xZ71FYaVOv7CLAdkIlN2qkzFMcp8jU+7O/EYOH0FOnsuMKo
         atQX2M2P2vlYTfI5m12UNDgEUtGaHebk4hnTz+3eRMUWOuY+KdEEu5R7N+QEGVlh8ytz
         9ntRnJg1H6jVNiz520/tEZmiaR/gY/IJaWn7z0z4G1LwcPG0jfftSLNMgGkxXkeuwX8h
         pph+qrka+04KfZNkDI26bk0ygkN/jO8/iaRGZPs6b/unpiY4FK/59R5rLhPbOR/T4XI7
         J6ZDgO5tOLQ8RGS9dIksyRHH1VHsVHeqzorq1jg4OACy5KCdEhkISSmyMULZL3RKLAau
         tA+w==
X-Gm-Message-State: AOJu0YzwgdmXRWIotjiXsFJ466ePbGaZMZeLOtKgU4smRt92xDxSSqnm
	OYtM4ZFl8sZZcG+YCyVvDACDkN7hpYxvZZttwC16V0SQUWrsapiK8qKVMZlQN5twWf0xHZmRlkT
	jbDqPCUYHtNfhYLqtZftyUXmqZIruSCkw
X-Google-Smtp-Source: AGHT+IGScbSG+WuPyFixVwU+ulF6BOcfnxDT7v6bdy/GspIEXskpnQcIYJc/BR71c2SWgHPpF2ooKfEZr1BnyLd5MzY=
X-Received: by 2002:a2e:2d12:0:b0:2e2:812:4c4 with SMTP id 38308e7fff4ca-2e447084dd1mr29677191fa.29.1715203494122;
 Wed, 08 May 2024 14:24:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 8 May 2024 16:24:43 -0500
Message-ID: <CAH2r5mvdQry6-Ba4bUYfDS0Wk3HxKwJ3tGMpWgyoNYPwmhjWMQ@mail.gmail.com>
Subject: ksmbd stuck open response
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

I saw an example in 6.9-rc6 where ksmbd was failing to send an open
response repeatedly (it showed up running test cifs/102

On the client I see the call one stuck SMB3.1.1 open request (never
returns) and call stack of:

[root@fedora29 ~]# cat /proc/5042/stack
[<0>] wait_for_response+0xd1/0x130 [cifs]
[<0>] compound_send_recv+0x68e/0x10b0 [cifs]
[<0>] cifs_send_recv+0x23/0x30 [cifs]
[<0>] SMB2_open+0x378/0xbd0 [cifs]
[<0>] smb2_open_file+0x171/0x560 [cifs]
[<0>] cifs_do_create.isra.0+0x471/0xd40 [cifs]
[<0>] cifs_atomic_open+0x382/0x780 [cifs]
[<0>] lookup_open.isra.0+0x6b0/0x930
[<0>] path_openat+0x491/0x10d0
[<0>] do_filp_open+0x144/0x250
[<0>] do_sys_openat2+0xe0/0x110
[<0>] __x64_sys_openat+0xc1/0x120
[<0>] do_syscall_64+0x78/0x180
[<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e

on the server I see lots of failure to send a message on the socket
every five seconds:
...
[Wed May  8 21:13:59 2024] ksmbd: Failed to send message: -11
[Wed May  8 21:14:04 2024] ksmbd: Failed to send message: -11
[Wed May  8 21:14:09 2024] ksmbd: Failed to send message: -11
[Wed May  8 21:14:14 2024] ksmbd: Failed to send message: -11
[Wed May  8 21:14:20 2024] ksmbd: Failed to send message: -11
[Wed May  8 21:14:25 2024] ksmbd: Failed to send message: -11
[Wed May  8 21:14:30 2024] ksmbd: Failed to send message: -11
[Wed May  8 21:14:35 2024] ksmbd: Failed to send message: -11
[Wed May  8 21:14:40 2024] ksmbd: Failed to send message: -11
[Wed May  8 21:14:45 2024] ksmbd: Failed to send message: -11

doing "ksmbd.control -s" did free that request but hangs on the server
(and subsequent requests on the client fail).  Nothing obvious in
dmesg on client or server, except the following (xfs bug?) which was
logged after the "ksmbd.control -s" on the server:

[24324.546128] Call Trace:
[24324.546130]  <TASK>
[24324.546134]  dump_stack_lvl+0x76/0xa0
[24324.546141]  dump_stack+0x10/0x20
[24324.546145]  xfs_error_report+0x4a/0x70 [xfs]
[24324.546298]  ? xfs_remove+0x175/0x300 [xfs]
[24324.546440]  xfs_trans_cancel+0x14b/0x170 [xfs]
[24324.546582]  xfs_remove+0x175/0x300 [xfs]
[24324.546724]  xfs_vn_unlink+0x53/0xb0 [xfs]
[24324.546866]  vfs_unlink+0x146/0x2e0
[24324.546872]  ksmbd_vfs_unlink+0xa9/0x140 [ksmbd]
[24324.546888]  ? __pfx_session_fd_check+0x10/0x10 [ksmbd]
[24324.546902]  __ksmbd_close_fd+0x2ba/0x2d0 [ksmbd]
[24324.546916]  ? _raw_spin_unlock+0xe/0x40
[24324.546920]  ? __pfx_session_fd_check+0x10/0x10 [ksmbd]
[24324.546936]  __close_file_table_ids+0x60/0xb0 [ksmbd]
[24324.546950]  ksmbd_destroy_file_table+0x22/0x60 [ksmbd]
[24324.546966]  ksmbd_session_destroy+0x5a/0x1b0 [ksmbd]
[24324.546984]  ksmbd_sessions_deregister+0x24c/0x270 [ksmbd]
[24324.547001]  ksmbd_server_terminate_conn+0x12/0x30 [ksmbd]
[24324.547016]  ksmbd_conn_handler_loop+0x203/0x370 [ksmbd]
[24324.547034]  ? __pfx_ksmbd_conn_handler_loop+0x10/0x10 [ksmbd]
[24324.547050]  kthread+0xe4/0x110
[24324.547054]  ? __pfx_kthread+0x10/0x10
[24324.547058]  ret_from_fork+0x47/0x70
[24324.547062]  ? __pfx_kthread+0x10/0x10
[24324.547065]  ret_from_fork_asm+0x1a/0x30
[24324.547070]  </TASK>


Any ideas?
-- 
Thanks,

Steve
