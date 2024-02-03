Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3723B13AC0
	for <linux-cifs@vger.kernel.org>; Sat,  3 Feb 2024 22:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.63.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707000972; cv=none; b=WsTEKb/1c6margzpShcQ/s3TMZtMJpxaRl08nvo0a6Vqqjad48iTL3Q3EwbBriOZa9WmKaTJYU4DVjVUCinqv1cpOhSTuw7bFpz5q80bAPTzVfwnWf599XCK7PBinJNPA0fObpP2GGRdXknXbGtYEPKIQC2Dxof++9VAmEoiFZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707000972; c=relaxed/simple;
	bh=PwgPWnkLVZled+tYovuN8BYLpSoA/sa6lODw7vunpm8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=n0OkL2vJDjbfGMKP8TUWg3f1TJ2E8zqk3DNO5Lixj404hC/2j0AECMq9cBojnOC7cqkH4QkA8jvbYLlIsM19tDsqSF8keOXkVpOIdZOoqlmgNK0rBT5qswM0zPU2Y3L9jQPKfDGhAeaRAiFMV5CU/eXUgWELGBTjDoCe/Fh6auc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rd10.de; spf=pass smtp.mailfrom=rd10.de; dkim=pass (2048-bit key) header.d=rd10.de header.i=@rd10.de header.b=J5SMMx5d; arc=none smtp.client-ip=188.68.63.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rd10.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rd10.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rd10.de header.i=@rd10.de header.b="J5SMMx5d"
Received: from mors-relay-2502.netcup.net (localhost [127.0.0.1])
	by mors-relay-2502.netcup.net (Postfix) with ESMTPS id 4TS79D0W6Xz5ylm
	for <linux-cifs@vger.kernel.org>; Sat,  3 Feb 2024 23:48:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rd10.de; s=key2;
	t=1707000528; bh=PwgPWnkLVZled+tYovuN8BYLpSoA/sa6lODw7vunpm8=;
	h=Date:From:Subject:To:From;
	b=J5SMMx5drvBVMDTiPoBjCvqmrl2KB2LVgBGDFIvT4yitB40cJKG3M4lg4RW7y1CoF
	 hiXE+5bUdxMiy+7aFIzzyZYweQkIqEvQYTnXxgC5e3P9WrXPEhs8M7wA+Fj2Q46Qv9
	 CDMHVfRImvEXuPk1Ib3onBv6e5efWqmIuIA9VdG3S+pAeZOiLLWPUMhC+SFflvK5Mt
	 hkc2uRAo9tjZkpIb13EZ5fkjM2fdjB2Fh6T/YU7Qrafjfy5kNuV0Rrz+eSF6lCjMBL
	 3krn/2/Bm1g/0Tj3gMAvbzBQ7L/KmiUxy/yEwmYIT7q34E1mVimwu4LRGi8xXjGOl+
	 z19qOErQ+G2/A==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-2502.netcup.net (Postfix) with ESMTPS id 4TS79C6vzkz4xYf
	for <linux-cifs@vger.kernel.org>; Sat,  3 Feb 2024 23:48:47 +0100 (CET)
Received: from mx2eb1.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4TS79C5C2xz8svC
	for <linux-cifs@vger.kernel.org>; Sat,  3 Feb 2024 23:48:47 +0100 (CET)
Received: from [192.168.115.138] (unknown [62.27.244.140])
	by mx2eb1.netcup.net (Postfix) with ESMTPSA id 3DC731007EB
	for <linux-cifs@vger.kernel.org>; Sat,  3 Feb 2024 23:48:43 +0100 (CET)
Authentication-Results: mx2eb1;
        spf=pass (sender IP is 62.27.244.140) smtp.mailfrom=rdiez-2006@rd10.de smtp.helo=[192.168.115.138]
Received-SPF: pass (mx2eb1: connection is authenticated)
Message-ID: <428ab7ba-0960-4e5e-a4ab-290dac58f45b@rd10.de>
Date: Sat, 3 Feb 2024 23:48:42 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB
From: "R. Diez" <rdiez-2006@rd10.de>
Subject: How to automatically drop unresponsive CIFS /SMB connections
To: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <170700052347.24372.17255394097938511916@mx2eb1.netcup.net>
X-Rspamd-Queue-Id: 3DC731007EB
X-Rspamd-Server: rspamd-worker-8404
X-NC-CID: 5MUOYGKUfvpdhiP6W2GOCU3D0MVX5f4kTuXHohPy

Hi all:

I have been mounting Windows shares for years with this script, which just boils down to "sudo mount -t cifs":

https://github.com/rdiez/Tools/blob/master/MountWindowsShares/mount-windows-shares-sudo.sh

I noticed under Linux that some applications (like Emacs), the desktop's file manager (like Caja) or even the whole desktop sometimes hang for a number of seconds. It is very annoying. It turns out the reason is that the hanging software is trying to look at a file or a directory on an unresponsive CIFS / SMB mount.

The easiest way to reproduce this issue is from outside the office: I start the VPN, connect to the Windows shares, and then tear down the VPN.

I have tried mount option "echo_interval=4", but that does not really help. The Kernel does seem to notice more quickly that the connection has become unresponsive:

Feb 03 23:24:37 rdiez4 kernel: CIFS: VFS: \\192.168.1.3 has not responded in 12 seconds. Reconnecting...

The trouble is, it tries to reconnect automatically. That means that the next application which attempts to access something under the unresponsive mount will hang again. I think the pauses last 10 seconds, it must be hard-coded in the CIFS Kernel code. If the application retries itself, or tries to look at more than 1 file before failing the whole operation, then the time adds up accordingly. If the shell's current directory is on such a failing path, it bugs you for a while.

What I need is for the connection to automatically drop when it becomes unresponsive, and do not retry to connect again.

Alternatively, applications should fail immediately if a connection has been deemed unresponsive in the meantime, and hasn't been successfully re-established yet.

Is there a way to achieve that behaviour?

Thanks in advance,
   rdiez
