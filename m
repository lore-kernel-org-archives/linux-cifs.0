Received: from mail-ej2-f42.google.com (mail-ej2-f42.google.com [74.125.228.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99053783AE
	for <linux-cifs@vger.kernel.org>; Sat,  3 Oct 2026 11:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791027438; cv=pass; b=DrOvwf/96eh3t4pBeykHcte5wE0tT3Huo98WtD/URlNTAUahT6M/GjV+kxtzWI6k2EkZBblJPB1geBjxbh7nRTSLxiXmK17nqy5UXuue4BZRmuzmZv/zmOlX4GcyRkYYtm9v5OJN9wz5/iJkFjjVaaKoPPdxiQY/00Kj8PMxtt8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791027438; c=relaxed/simple;
	bh=R30RLgG+gM28K7oHHwmHUF1w6IRgcZbGcZokNFxAe1M=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=LVG6E33a0PDJrYTniXist1CcVvr/ZB7XuX0J6XfJiL/MM2op17HzwAndtIOa5QNIq/cmvKW77O/Se8garnCUcjTE5f6+I7fDl9J4iABjGxLZ4/KYsRw9aoydTWw2e7VD2a5Er3k4mQwVoqDpEuL/K6qEv78seH/NgpUbOxakAl4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T3TL0Tyo; arc=pass smtp.client-ip=74.125.228.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T3TL0Tyo"
Received: by mail-ej2-f42.google.com with SMTP id a640c23a62f3a-c2e7c1d9202so12650766b.3
        for <linux-cifs@vger.kernel.org>; Sat, 03 Oct 2026 04:37:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791027435; cv=none;
        d=google.com; s=arc-20260327;
        b=qvneVwTasamJfzE3kGPD2ghp+XAr7Kroivvt2IaLp7xazR1RpGOarJtAzW+0jKscZm
         jSH5RYYofrQlHRQ0TD8USiAM+n4SezeLi12sbHgSAhNEzLtRgqERPqCxg+brPfKvtuwC
         Lun+VwPGvmAjOefkUxmyd/csO0LsHIkSKefoA/GWmiSAKWIZtykAtkHvPKnb1caWt1Tx
         MvItLs/0HEsAMPq0npL5PDlabtopoQyApWcZSof5Fh4IZTTcqnfiE5on2wMToI8mGdd8
         dJDiDtosXeh0b3Dg3ZnJfuM9rvNc2/0He57gUiBYodeaiFGO+FVCskZ+DDazcKe23wlI
         eGcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=mqPhaubsGC3NUNNcfIqDLzzzs8uBtSALODJLCqdlGHg=;
        fh=nh5z2XFNYekkaGrk2U+gKrNIRf/dv3ilXEyA8K5VBTc=;
        b=oZo2WWaWp65c1wPgt/4vZN5rW/z8D1EGtWs0o6LZr1DymyAWgZjGdd+hjXUB8DTgGS
         K9lPHrkHKC+GIUTst4t9+F/mx0UlnB3BxP10uX/YF5q2bM7P+7SVfrjVHD9dlOeFKg0b
         D4HtUGiNg5ptJmPrC4ZusAtl8gIYZytlWK7lk0vfImIsRizIEGaHBR1iWMqPUyY7Pi0B
         WsjITndxC2DB6aWmLoIZpA07YSAN4QpKIKRu+46ftAo70mOIhDLWtlYfx+KM7BTZ29jc
         YY3H7zTyW2MwGw0dMactRb1McIe7jVDevMTQZOYao2tkO8LfWzr0z39BQKawXvn+TCtn
         5pQw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791027435; x=1791632235; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mqPhaubsGC3NUNNcfIqDLzzzs8uBtSALODJLCqdlGHg=;
        b=T3TL0TyoyQT6/KWgRtW3NBHjwoCu971U4s2Uj5t95NPq4/28l13qsz9/ryXh6KO5nj
         f2oQ+KS22q7ROrEa9FKzm6ZbJendsTC+U40cOupRsp9v5ouQ6qs383mJlqc2l+aF2bmE
         Qbj6T2StmO/b/kOR5hN95YSraiBfZuWK8hHb/wqJyCcgcaC+tseJ8ZK97rQErFnyDlDs
         lFSAXnu0KijdoDmKx+rK2g5iPyuFqsgeRcgRVUUwDusxesZuwU+8mSVESAbGLxYf/R8X
         mOAtjia52t6q/6J0ITowCC/b3x435YF4ZG71zOh/qiN5AMN8AWNmNCPgs9UdONCzEXw9
         FahQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791027435; x=1791632235;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mqPhaubsGC3NUNNcfIqDLzzzs8uBtSALODJLCqdlGHg=;
        b=hG6bnjuZ7/hhYUC1JqQnHBzVUTb+HDQGO2uszj1EL2viczssi7EPxL/L0TJuGnbkJ6
         YDZHGh9dV+zdPL4bHzU+9USYGCTitXKo8rMn8Eteqh9muaRhV/EDdC3MW6rRTZiQDONl
         vlRE6UTNHKYISpldpsLfxp0IqGFj3th5N9TEJZveIFz9uezJiuDel2GdW1e4YVYbvT6d
         KeOCanLiLEwB7R9oHPvr38G0AJI/GnCOTpKuprUQMG4FofJEhRxGebU9l/kU1D4Qt4yH
         YRZ9NGXMRwbQ6pftWCihChh4p1bVKePQBghv90NM7U/ejVBPwY/qRekk2JZ5Uc3jIF38
         L2og==
X-Gm-Message-State: AFuF++nBIUp2KSp3fGl7IXxh/g/TsMoXyFOCKvhqLk+WRvgQholexCMl
	Yv1tBXGG64JAPtgfS8MUgBKwPCoVcsGp04f/2Nnk/V9+IZJ4mw4EsqvPEuerGJWeXX5mqARRN5w
	r+UC8rWOdySvO2UhjcdIsLQD29QlPN7tCdwBZ
X-Gm-Gg: AYBFou1jOlDBVO9Ir0Lid/MQnVDbb8IEzv133BXVk9zJWI4rMWilUrY3aJngQof+TSI
	r747jIUTMfiLUxwr7Ik1mZWY1UdUldVg0Wm1w2Wa4DPo43h3rXSMnVXT2dDWnEHWv+MPJblsrHM
	HGp+xmtzexsul5NgONGAKuEqVLtZfoiclF+UaxI1xV4yuJ0tP3lrrPHTvA/fIPNAjRGboD4hyn7
	uYN8GrEtEk0YEb7vOlFaCfeETX6SL7dBswI+Wc1+gpkvxwjXia4bCoS5FyoIlV7B/nqsDEWxYJi
	UwFYVAy6EddqSZccJCbxb2dLyU32T1vy5QrfNgP7j6j03U+V9WAf9nHXBwMwPSzLMFa0uM3RqBM
	JRViSpzEtPxJwu0R31Ks=
X-Received: by 2002:a17:907:6d28:b0:c29:6de8:d143 with SMTP id
 a640c23a62f3a-c2e4adda15amr457273466b.19.1791027434800; Sat, 03 Oct 2026
 04:37:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Tea La Forgia <tealaforgia+alias@gmail.com>
Date: Sat, 3 Oct 2026 13:36:37 +0200
X-Gm-Features: AclHuK_u2jCyFCr1nXxTorB5J23MVo2OyH4fSDIQwOY8Iza6CUD5i4K_r9hZN30
Message-ID: <CA+i7WArBKHotAcKVS8iYZp0qBK2rRvuuCw=YHEoyM0TUfvbONw@mail.gmail.com>
Subject: ksmbd: second session setup on same connection fails
To: linkinjeon@kernel.org, smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

I would like to report a problem with ksmbd that I did not have with
Samba's smbd.

Summary
-------
Two related symptoms, both involving repeated SMB2 SESSION_SETUP
requests on an already established TCP connection that ksmbd rejects
with -28 (-ENOSPC):

1. A Windows client can access my share normally from non-elevated
programs, but any program started as Administrator fails to access the
same server. The elevated process uses a different logon session and
tries to set up a new SMB session on the already established TCP
connection. ksmbd rejects it with -28; the client sees
STATUS_INSUFFICIENT_RESOURCES.

2. With "oplocks = yes" on the share, Windows Explorer hangs for more
than one minute when browsing a folder. The log shows the same pattern
(see below). With "oplocks = no" the hang does not occur.

Environment
-----------
Server: Arch Linux, kernel 7.2.8-1-cachyos-server, ksmbd-tools 3.5.6,
IP 10.1.2.1
Client: Windows 11 Enterprise 26H2, IP 10.1.3.1

Steps (problem 1)
-----------------
1. From a non-elevated process, connect with explicit credentials (net
use Z: \\10.1.2.1\SSD /user:tea /persistent:yes). Works: session
setup, tree connect to IPC$ and "SSD" succeed, directory listing
works.
2. From an elevated process (like CrystalDiskMark), access the same
server. Fails.

If the elevated process connects first it works, and the non-elevated
one then fails (and vice versa); it only depends on which session is
established first on the connection.

Details (problem 2, oplocks = yes)
----------------------------------
Timeline from the ksmbd debug log while browsing a folder in Explorer:
- Normal traffic first: create / query info / close, plus two SMB2
change-notify requests answered with an interim async response.
- About 8 seconds later the client sends hundreds of SESSION_SETUP
requests (NTLMSSP negotiate, SecurityBufferLength 178) on the same
connection. Each one fails with "Failed to process 1 [-28]", and the
credits requested grow to 65 per request.
- Then the log is silent for about 56 seconds. This is the freeze seen
in Explorer.
- After that ksmbd logs "Cancel pending async requests on releasing
connection" (the client gave up and closed the connection). On the new
connection everything works immediately, including a directory lease
being granted ("lease granted on() lease state 0x3").

I do not know whether the oplock/lease is the direct cause or whether
it only changes how Windows behaves (for example by triggering the
extra session setups). I cannot tell from my side whether another
process on the client (elevated or not) was involved in the extra
session setups.

Relevant ksmbd debug output:
- elevated case: https://www.laforgia.xyz/ksmbd/ksmbd-admin.log
https://www.laforgia.xyz/ksmbd/ksmbd-admin.pcapng
- oplocks case: https://www.laforgia.xyz/ksmbd/ksmbd-oplocks.log
https://www.laforgia.xyz/ksmbd/ksmbd-oplocks.pcapng
Note: the filter used is ip.addr == 10.1.3.1 and ip.addr == 10.1.2.1
and not tcp.port == 22, so it might include traffic other than SMB.

What I tried (no change)
------------------------
- EnableLinkedConnections set to 0 and 1 on Windows
- server multi channel support yes/no, smb direct yes/no, smb2 leases yes/no
- oplocks = no avoids problem 2, but problem 1 remains

I am not sure whether this is a bug in ksmbd's handling of multiple
sessions on one connection or something in my setup, so I would
appreciate any pointers. I can test patches and provide more logs or a
packet capture.

ksmbd.conf:
[global]
server string = Tea-SURFACE
netbios name = Tea-SURFACE
server min protocol = SMB3
interfaces = enp0s20u1u3 wg0 lo
bind interfaces only = yes
server multi channel support = no / yes
smb direct = no / yes
server smb encrypt = off
smb2 leases = no / yes
store dos attributes = no
[SSD]
path = /srv/ssd
comment = Tea-SURFACE SSD
browseable = yes
writeable = yes
read only = no
force user = tea
force group = tea
create mask = 0644
directory mask = 0755
hide dot files = yes
oplocks = no / yes
strict locking = no

Thanks,
-- 
Tea La Forgia
