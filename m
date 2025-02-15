Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802391624D4
	for <linux-cifs@vger.kernel.org>; Sat, 15 Feb 2025 23:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739661506; cv=none; b=LId/ithw7YQU/MWpNpgIyA8RZvSMutsCX/G4Dmvxil4//9icDkUylLo0MGPdlERE4Yr+mvaXcWwzFl3aqB02EkBRm55fF7zNIREtMiIhb4L12kD8zg9HCzQwHqC7CZOWfXwHZLbIkAf0iBIvfoJMsyyOyw5JadOT1JWf2XHbifQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739661506; c=relaxed/simple;
	bh=Mg6YznIZuYmP3Rbtj2ujaw6IkgNkKZEy2Lryy0xPRWs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=CVASnu5S83koMBEXyWLmEfSEYgorztTBkbnVE9WqsKDADKt0RE5pKu8tqbXFwtwOuGbyov4Au/GbvZlqJCeze+kYwjGgObTDA97Of/KvMlQp4JlVNcPib29Z24mS4lponOYYzSNBkmmB6TWu7sCJyAZp1a/FhCkw3GfiS7AI2NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=glUtLW0C; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="glUtLW0C"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-2bca6017608so391550fac.0
        for <linux-cifs@vger.kernel.org>; Sat, 15 Feb 2025 15:18:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739661503; x=1740266303; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pP341ZSJlcbVHWaRZPK9i0q6hHwuLrXg3ZS7ou7uOug=;
        b=glUtLW0C43SyAUtK/H8ziHIEmMetpWjccgOo2YqWmprKlmdAwtEfOGI1mMZBPN3cQt
         Pj4ewAph9ezycfG2V8LSXFyAxe7XKqG8bAs5vOWPl3UCoNzM3HCvFXI07E7J0clPJuvl
         pdniq/lhqU9CxN0uoAJZ+WttvkgmFt1dcPxWZdb92n4JD20id8qpQgFHmrLLjFK0PeFc
         xf23eMl3nQL0EU4AgJ6adrAbzYta18OGhunGSaGrzKzJfTHCYAwo7XR19eJv1OTsoayW
         R/GeiU7luZU17hGCONtT8Vh0BN9DREpfIXK/44dHOsnDMjaJEo8DNJL5L+m28mA9vXc4
         dmFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739661503; x=1740266303;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pP341ZSJlcbVHWaRZPK9i0q6hHwuLrXg3ZS7ou7uOug=;
        b=QgcJBobBC6mMm2BRwxkq1lG/TzYt76P7iIpMGMzxzk5Lv8agja76knPTiQ6/3junZ8
         w3X26fJC2gHlgqBoLdNI4qCSJaULZvNEqCkQzqooKD0QUQIlGOgkTfbXJfk7TXXPg1VP
         s8NsLDTDElXs760J0vkxiw/9C9KthYFMShv9lRt4INJfigqloUTWTerMiundFSPYO8Wl
         8lH/vD9QNtggFDumTnBjnPix+A5/SX6X+p3kojYRMficXK9XEurEuEeGymIVM9x8Z/6m
         p4Ygy2J2LRT07yQqe8WIZDvPFgn+10MnQt1qAfihrON7QyVmvn+abPT6Q7NYPLrv3UTW
         NpAg==
X-Gm-Message-State: AOJu0YwlR/i+NFeBMaCEAAwNrK8/3NUdIai06cFkKfrsWaECb0pnD8/k
	PWFbv4iBkvzLShSI6SXXiVcEJRyddOd+nlJQ/0dVR40Ouv8JLKhTGU7CUceilP2JEBjGDUrVbS3
	o+wS8X05ADoiBkpEjXpSz5do24YY5nm2Dilk=
X-Gm-Gg: ASbGncup2pyKVNfUFi5906fAtqjn3ruI+1tqtwagVSwpCOLDSX+lH48HuBK6rETrCy2
	oi8P978hYthDNI98YutqFOiz42DIVku0Iboe4TS87Z3tUmuBSKlrX/i015O7L6d4ONECUQBOGf9
	HbDA/voYQYKhlSfALXvUeO+bka9YwvmA==
X-Google-Smtp-Source: AGHT+IFcNdj0WIutekcLsQG4pztOrGb/Dkx3uSKMx2A7K7y5ixbLDEHbpPrkOq63Z2K6jVZ94d1ytLdNoO8wH4NBfHc=
X-Received: by 2002:a05:6870:3282:b0:27b:55af:ca2b with SMTP id
 586e51a60fabf-2bc99a9316fmr2068954fac.11.1739661503283; Sat, 15 Feb 2025
 15:18:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Robert Fayz <robert.fayz@gmail.com>
Date: Sat, 15 Feb 2025 18:18:10 -0500
X-Gm-Features: AWEUYZn6aMF61FxIxiBUwgRwB4wFH0FjlntGc3FVEGal1mAqqbQBpfyHd3q8vLI
Message-ID: <CAFm7LrPvRY3m_E=Lbc5d6JrR-XtXFQf4uzEbDPKqN4_9mzfPsA@mail.gmail.com>
Subject: CIFS Troubleshooting
To: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

I hope it's still okay to ask for assistance here.

I have a NVIDIA Shield Pro 2019 that has a samba server built in and
is sharing a Western Digital external hard drive.  The client with an
issue is an x86 laptop PC from Asus.  The linux distro I'm running on
the client side is CachyOS (x86-v3 optimized arch linux).

The shares from the NVIDIA Shield mount fine, and are visible and I
can browse them fine.  In fact, I've never had trouble so far with
upstream writes from the client to the server.  It's only downstream
transfers from the server the client that eventually fail if the file
size is large enough to need a few minutes to transfer.  Infrequently,
my entire desktop will lock up, suggesting a kernel panic, but it's a
rare and I don't have steps that reliably cause it to happen.  (Well,
it happens every time if I use vers=2.0 in the mounting configuration,
but that is not the default configuration or my current mount
configuration).

If I initiate a copy from the terminal, the error message I get is:

cp: error reading '<filename>': Resource temporarily unavailable

These problems *does* happen with kernels:
6.13.2-arch1-1.1-g14
6.13.2-2-cachyos
6.12.13-1-cachyos-lts

The problem *does not* happen with kernel:
6.6.77-1-lts66
Windows 11 (I dual boot)

The shares are configured in /etc/fstab as:
//192.168.50.144/internal /cifs/nvidia-internal cifs
credentials=/etc/samba/credentials/nvidia,defaults,noperm,noauto,vers=3.1.1,x-systemd.automount
0 0
//192.168.50.144/NVIDIA-EXT /cifs/nvidia-external cifs
credentials=/etc/samba/credentials/nvidia,defaults,noperm,noauto,vers=3.1.1,x-systemd.automount
0 0

System Summary (client)
OS: CachyOS x86_64
Host: ROG Strix G733CX_G733CX (1.0)
Kernel: Linux 6.13.2-arch1-1.1-g14
mount.cifs version: 7.2
Server: NVIDIA Shield Pro 2019 (Android with NVIDIA Experience 9.2) (I
don't know how to get the samba version it uses)

Display Internal CIFS Data Structures for Debugging
---------------------------------------------------
CIFS Version 2.45
Features: DFS,FSCACHE,SMB_DIRECT,STATS,DEBUG,ALLOW_INSECURE_LEGACY,CIFS_POSIX,UPCALL(SPNEGO),XATTR,ACL,WITNESS
CIFSMaxBufSize: 16384
Active VFS Requests: 0

Servers:
1) ConnectionId: 0x1 Hostname: 192.168.50.144
ClientGUID: 29CCE1FB-2026-B248-936A-62E6D7F1B286
Number of credits: 510,1,1 Dialect 0x311
Server capabilities: 0x300047
TCP status: 1 Instance: 1
Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 Net namespace: 4026531840
In Send: 0 In MaxReq Wait: 0
Compression: disabled on mount

       Sessions:
       1) Address: 192.168.50.144 Uses: 2 Capability: 0x300047 Session
Status: 1
       Security type: RawNTLMSSP  SessionId: 0x25610bd5
       User: 0 Cred User: 0

       Shares:
       0) IPC: \\192.168.50.144\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
       PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0
       Share Capabilities: None        Share Flags: 0x0
       tid: 0x936d9aad Maximal Access: 0x1f00a9

       1) \\192.168.50.144\internal Mounts: 1 DevInfo: 0x20 Attributes: 0x1002f
       PathComponentMax: 255 Status: 1 type: DISK Serial Number: 0x234ded5c
       Share Capabilities: None Aligned, Partition Aligned,    Share Flags: 0x0
       tid: 0xff04e9b7 Optimal sector size: 0x200      Maximal Access: 0x1f01ff

       2) \\192.168.50.144\NVIDIA-EXT Mounts: 1 DevInfo: 0x20
Attributes: 0x1002f
       PathComponentMax: 255 Status: 1 type: DISK Serial Number: 0x41638684
       Share Capabilities: None Aligned, Partition Aligned,    Share Flags: 0x0
       tid: 0x94f5fbbb Optimal sector size: 0x200      Maximal Access: 0x1f01ff


       MIDs:
--

Witness registrations:
