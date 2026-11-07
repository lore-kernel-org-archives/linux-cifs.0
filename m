Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.215.180
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794053250;
	b=h1z6oB3D4m0tviiU2tRvPr9t8Z/LbMmqIl0ZlCS4sjukwcZht5xLyRsF4DBWiMPEkTXr
	 O8w08K2vYtGHiVlXptLVZ1Oxu5D/3lUz8GTcMrgCpZSUS0CKGnvbKfkF2RWKw3MEKWn6v
	 P2D2hBtECZ5NuIMTdeFnLTiDhrNFSgqTykLRoUecETC3HT8aG358dUlJ+hlLUhoYwCxXw
	 nVb6p2tlg85KUGSXrxO+afrs3ZC0LHWnk+i+q2qplbl5xzcOsD2PDhBeB5w/dNNyGj+mp
	 pxb4pjcPXR+VCxyUBCDy2oNVpHCvcuCIa4fQRBDOS0wc8hFyKLeLVAvdJnYbcMatv3g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794053250;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:MIME-Version:
	 Received:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=1rdrVop2F/xBL+Dl0XrFtXXTmIuBWqwrr6qaIFcS1ok=;
	b=mr2zQ8O1qNPeTam80ET+V5BQ5yJdjFv67fAi/B0Sk+Pe9EDNHYIXDNuN+fF6IzgnAmPm
	 pEbgdeysleJok3460zdVPUTzQOahXj+Gt6rHE6AM4SaqTHKg7lH55dW52LG5yIE6vBgzL
	 kRJ/1w/AQjJYNMQkIgRS6KbdeUOkva4VATIuk+IKLWH+rnYQ+0z06nDSw9IMyvHVmAJoO
	 rEOW0IrfwI1rpW03GZt0A1iwC17MGnzhpVZNjuXPFqCq46IMFLsBr8ACVrrms+He/OfOZ
	 fH7FLs+Cs6g1V/ss84MKQMQrdmqeEN9u9AhsRpkpfnUycFn6n2O94hs32Jef/DlTMXA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ekZb7bIA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.215.180
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11309606A326
	for <linux-cifs@vger.kernel.org>; Sat,  7 Nov 2026 12:07:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11309606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ekZb7bIA
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cc758830601so984531a12.2
        for <linux-cifs@vger.kernel.org>; Sat, 07 Nov 2026 04:07:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794053249; cv=none;
        d=google.com; s=arc-20260327;
        b=KCymHp3/R4dl05HNbeElJY/MwetbTgS/ePgdwNRiG+wTSJCuaSCp5XM9X8TcKw7l90
         ZtHz9aHLF25NJGcA9nR/CPabnIJ4rxVjN3ura2brf1B7Q6u2meYB0XY1F0NXvvWQeHHA
         N3EvmKYsIujSB/3ekHFqbxzReWEYey6XKsOSwtkWGP2giAKYT3QLQ21bAEjwVoB7DGLE
         g80j+wVYP05CQH/BxFLcbSm8fYLVqgIqrFPT6HjiHFAdi+JvQQOclSK5W83U2C+bApDG
         HV2xItM2SoJ+w8l/avBtn01CYl2/Y/F0YyP9dwjAa2RA3mAAGyrjVL+Fvrny4yGmiGpe
         JtsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=1rdrVop2F/xBL+Dl0XrFtXXTmIuBWqwrr6qaIFcS1ok=;
        fh=v6V3YA99mKSPIBDt49TXvo5ptZGQlN5SxHQ45Jxyfo0=;
        b=ZA2uNmaYxpv7EnMAr97RVio5VpVnRe4WFrZGSLvsnJpslEz/XN5+1PsAE6SfZB7sry
         Pe6BSML3E8V+jFlfXJdLUts2nY3Lt0oDzHi8N+VmrK0EU7CgBRUzA9wfOFIsnS0uiZ/P
         Zn3Dn1cKiGvV5moNxPQQ0/w7HUHJnmwg1+1KWHh8dma66RvE6Rq7G1nuEEM0681OoevD
         TxYyhcC1lHuBrBCJCIfLarmEKtcqcjiX3llNLLsrONZ8obz2d2hpf7bhpsZM6oX3u5xa
         9gYNr3AR7gcUOBr1JI/BmQ+P8rhVLVeztW2DYnFUYbHM10W/LXPEBBxUKt9RyueeXJw4
         GAGg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794053249; x=1794658049; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1rdrVop2F/xBL+Dl0XrFtXXTmIuBWqwrr6qaIFcS1ok=;
        b=ekZb7bIAK3dymEgq14mGmXgIWxGWGNW9iU+41Y44GeiXQOdKHg6xOcBYtyV5eAwUEx
         23owu5RfM0mkgpZNsuBt3FBV0NmZomJTJa1rqml+PG3zpQ8v0WeauNpDf90ulTK9bODt
         NeyI/jGNPPx+FsO3xXoziFxqx8BVt65Lgu9YwZVXNH4ga0Br65gq90wBdSL9nZdg95lj
         vKaDK7g5BLN9QnNHdldEZpFPR5RDB8sACDkbxf8Cb1Ww/ja9IfKseJUcPSY+e+VP+LOu
         Zvv+TdT+6gx1HG6z0WjX/0mR0rApKxjpKWjD2KQ9LAJbUS99L0F9026pzCQK+qwvXFQp
         YLlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794053249; x=1794658049;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=1rdrVop2F/xBL+Dl0XrFtXXTmIuBWqwrr6qaIFcS1ok=;
        b=P1zf+9zak8K3AAYAHvDtya0KAM9gNOnm/dplh4ui4SQd5kEvBg2DCeYNizxg/3wwut
         ZWAwHRKUsCMV2GqZWCWUD+gdAkH9bypFa/N0hQEiCuJ3WM7wk0D+EwhkDfEnD6xaU8b4
         zE177Y7lc883Ol4oaFUwyT3qR3y7T6V8l06d2U6nDOdH1YVpEyxZN7lCBdxTmKKsXA4r
         Unu7gCVNfVmMJV3ehvD9OxDOLuEY/eunVb1pAWwXEUudAxAfGGaE5ZopGNEC9N0uoom/
         4MZWAAfrHu+ppYRxf1N2KY80sxj/o8CZE6if/8W909QWRTYzU2DdV1vfeQxGAaJdjUKd
         noUQ==
X-Gm-Message-State: APuU4Z8KkDAPOvxbPDIPLg9K9IHBJzsQo5g8ACrUBHr18wzKN1RT8Z8+
	Ymo4WCTrjAZ7NO5My3w5Tk1vkwVJOfpZUqSuvrxsOID2reMVvfWnM+QS8lmjPKCQj0aAqUst9PG
	uFhvXh59CEAsjTVnDXv462Y/SitP8r5Xv8Q==
X-Gm-Gg: AYBFou30DJ7qKI4luh3D18BlPBvCNr8YMq91pM12qQvjEs3vdlr8Ri3w+CkDgd3K3th
	SfJTO2m24kaBn+OFRTw5pVdtZH+4pjRFtlqDr+B1DKohLWwMUVUiS2UUl4PUMfHGo8UNv1nc9Km
	7PWs6lB+U93OUNNRNkPLX/xjz9vawxzMuxV/WMIMO44OgUnYc71K8I0XmpfZByo8+6vmb9c//pE
	hiKtOtf5hEQ8wIDVPh8Dry/Art+i+8SG0NSeaZDIHM54yeiHSoj4LikF38i99upPb03jY+Ghh8O
	VJBAPxBg9amh5mJBB+1OseLDZfeyg7v0IHhe4oHqCvNhlPkEGsOwgBlNzXdoebUkntHoarP6h2H
	9v+1RvM/90bM4Ga7FD9qnJ2O/zXy1rNAXUms=
X-Received: by 2002:a05:6a21:7784:b0:3eb:8ae3:e1a8 with SMTP id
 adf61e73a8af0-3ebb2add3f6mr4895582637.72.1794053249294; Sat, 07 Nov 2026
 04:07:29 -0800 (PST)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 7 Nov 2026 04:07:28 -0800
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 7 Nov 2026 03:47:46 -0800
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Sat, 7 Nov 2026 03:09:15 -0800
From: Giuseppe Piscitelli <ooonea@gmail.com>
Date: Sat, 7 Nov 2026 04:07:28 -0800
X-Gm-Features: AclHuK-dK-9aS5P2WQeMKOmTItlV6aUxdFQ_QulnLXe5crrs1M8oQEmNs9wvEuo
Message-ID: <CACmoRBbDZR3eyEM65j73sWMS7A=T89z1QAvCP=+u0WGzZhwW6g@mail.gmail.com>
Subject: CIFS: mixed-access hardlink opens return EINVAL while a lease is held
To: linux-cifs@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"

Hello,

I can reproduce EINVAL when opening a hardlink for reading immediately after
writing the original name over SMB3.1.1. The same sequence fails against a
Samba share backed by ext4, so it does not require OpenZFS or Unicode names.

The client and server are in an isolated Ubuntu VM:
- kernel linux-image-7.0.0-42-generic 7.0.0-42.42, cifs module 2.59;
- cifs-utils 2:7.4-1ubuntu0.26.04.4;
- Samba 2:4.23.6+dfsg-1ubuntu2.2.

The ext4 control share permits guest writes, with "case sensitive = yes".
Samba is bound to loopback; the relevant configuration is:

    [global]
    interfaces = 127.0.0.1
    bind interfaces only = yes
    map to guest = Bad User
    server min protocol = SMB3
    [control]
    path = /var/tmp/care-cifs-control
    guest ok = yes
    read only = no
    case sensitive = yes

The share directory is writable by the guest account. The two mount variants
were "guest,vers=3.1.1" and "guest,vers=3.1.1,cache=none,actimeo=0".
Both retained the default closetimeo=1. No lease-disabling workaround was used.

The minimal operation sequence is:

    from pathlib import Path
    import os
    source = Path('/mnt/control/source')
    target = source.with_name('hardlink')
    source.write_bytes(b'link')
    os.link(source, target)
    target.read_bytes()  # openat(O_RDONLY|O_CLOEXEC) returns EINVAL

Each run used fresh names. With cache=none, the failure reproduces on ext4
and a case-sensitive, non-normalizing ZFS dataset. It also reproduces with
the default client cache on ext4. The server contains the correct hardlink.
A separate control fails while the source descriptor
is open, then reads the correct data after closing it and waiting 1.2 seconds;
I have not traced the exact time of the server-side handle close.

On ext4 with default client caching, read -> read and write -> write opens
succeed. Write -> read fails whether the original descriptor is still open
or has been closed.

Samba's lease diagnostics show the original name in the lease database, a
request for the hardlink name, and NT_STATUS_INVALID_PARAMETER. This matches
the filename comparison in source3/smbd/open.c:5889 (Samba 4.23.6), consistent
with the filename requirement in MS-SMB2 3.3.5.9.11 [1].

I found commit 262b73ef442e ("smb3 client: fix open hardlink on deferred close
file error"). Its reproducer uses matching open flags. Current Linux master
d48723711bae and cifs-next 51b4bf5fe7c9 still compare exact f_flags in
cifs_get_hardlink_path() (fs/smb/client/file.c:2238), while smb2_get_lease_key()
takes the key from the inode (fs/smb/client/smb2ops.c:3210). The mixed-access
sequence appears outside that earlier fix's guard.
This is source inspection only: I have not run either current upstream head,
and I am not claiming a particular regression commit.

The active-descriptor control also fails, so merely closing more deferred
handles would not address the whole observed case. Is there a pending fix
or a preferred approach for lease keys when hardlink names need different
access modes? I can provide the strace/server lease logs and the complete
access-mode control script.

[1] https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-smb2/fc4f8879-f295-4995-b71e-21f309d8d7c8

Thanks,
Giuseppe

Assisted-by: OpenAI Codex
