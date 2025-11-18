Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3C52E1F11
	for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 23:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763509601; cv=none; b=BEwj3cUKd6pwCHlYRyha4FFqlvPKr/ullQczCBfgXOGdZCeEMFDzjI5bv0GCjsevKH8BZuPhE2WjiwO0/C4eL3Sp93De4WLN7vvilRIPAUc1kccMWRHth2oPUALL01Jt9weEgZvb2HrBAO5JPnWlWFJmFg+t1NnpwSVsC9HwKt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763509601; c=relaxed/simple;
	bh=H+8xJsORw2Eaj4gBclqD1FoD0OoCRieluUA32NwEed0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=I+2f00FzDEns/Rh8YZlr1/zh9piTCViaR+mPs1xU1oZKKoYnXNN/3aGh8lKeY62rYZhtEwgenidyvvBKVLTuzE4lhNRxkWxjQvTTRUkol6BbMidxRQbQ3/VrVYWVMi0HoSAcLydpmdKZZZlsoOCxHDlJWSJc/AZG1miWZwbvlr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MTfSKpJR; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MTfSKpJR"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-882475d8851so64361286d6.2
        for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 15:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763509598; x=1764114398; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=O4Qy67r0WsvsoCb54DNk1kfuGqNvxmypCWDAzg4loaw=;
        b=MTfSKpJR3YYUHIUquwB+5tBAAmXALaLhLNuXNvGeMJI1nBlmwALE3QXRF5nUErWLbe
         REYKoJKYSvn54kJMrqlP8A4oPlqWYPfYBGdh2ZzL+1p43zfBpQxBDUP1ho1kasKnpYL6
         1NtLMHcxliMKAl38ulnUOxv2WRMVvbr9e4y+W4VaGjbj0+CnlcNx6ZyIM+ZuP00/Q8gn
         DDSM/MVP1VdkmuZ3UpD5Vyv+FkXJpK0ZkYYYdmA/pwbHu7bsHXMSQDEdU6kzFhlKsS+m
         7vFIqgksLC5JffrsmGsNxopIqURT+qOYNtYpy2B9eBUA5dcmkeg3g88f0Bta868Z52Zx
         DuzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763509598; x=1764114398;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O4Qy67r0WsvsoCb54DNk1kfuGqNvxmypCWDAzg4loaw=;
        b=Mc1t6ksjjB+5nX1mZlLi1yEpW4zOXZzFMyTuy1jEDWR7bpVsvqbYADatS4ZsupCCGG
         S+GD2iMXTO01BZdCsv1Ka1P+HqsaGfIiyJtDcDGo0gPnT/OxoJHCBipv5wl2CHy0h/aY
         Zf95yPjQRfjtSzssuONT70haMQfwaPLrw5fKiHX1fKvbciwEawt5xXG+VWjUPZs/tVfX
         brlnrKB5MJiegpM2XFxpL6b0NLTcMXCeldaIMIuCedwwWy5OcgVAX8vkabYN8NWw1Uat
         WyQ/S5eoyshfT0wHolNOt9ErlfXAhxE51S4qtIjvAl5WxePQgWMzn93++VrUoLPJQv6v
         nRVg==
X-Forwarded-Encrypted: i=1; AJvYcCUzhZQZX0Ed3kan6Nwtjz5R1PzsqcOI0XuHHMVl9C6i4DCD4DzAs/JKE8WAV4VYxWsTA+YY1ES3N/8B@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+2iAm18yfOSNbwK8j+jO5T0zUWQ30oURyfYBXeuZF1BGI25Q+
	2zFFJ2P5MQS+3Xx78mna8lOZ4yzFgXrIF1zhTMptPIVC3VeO9znueZnLbIOXHZulDPAZUu15s1E
	mHQpR6TId4Ht5VdSdJFrwpOr5KdxCWXJMsR4s
X-Gm-Gg: ASbGnct/LwkSUQclPAgcgY2MugJ2G6JJkU6tQ6JHMDCwFhphXwEYyvir3FbEtDawYUK
	tHZR8tDAFbSas7O0UCbdN0UolSX/S1IGLVDTtahvkVsSBBs7J83vfWsOw01wS/C3iP/aLiPgZY1
	iBfsIB2aC8MXVWyqcQ/KpPdne4yI7tr25tRXuJOAF/Tv3Ci1fQDAYlcm/+ArpCMmw0W1kUxTdYR
	7BUHqwXvscza7/MEb+07oKc27NbMgiHvl39zggLrdYk8RkXWJSYRc6F10VL4fllnNH6Wl8GEoiE
	+FPvY0TWwqdvB3PtI9ac7//nx+Avu4jYmMf6sI9MP+rKqjpeSp8yMmyQpgtxZCUpnepCIECdoVl
	jj5YtlqvY0vMoCxhuKqwtTGpbugufKmDY9j2abwTl/DAVf7SD7iSybuuWeXswuFLH3jWKvhWjAn
	KBENTNiRFqRA==
X-Google-Smtp-Source: AGHT+IG1ybOUdC7NN5Ug1UYt3LymjIoXH27sZabYuk+bt5UoSaUVuB3KSoG3Fr2rH+PMf+JTR3LdGVMgzaN9/xcxqRE=
X-Received: by 2002:a05:6214:1c0f:b0:880:42a7:772c with SMTP id
 6a1803df08f44-8845fd509b9mr8167666d6.54.1763509598402; Tue, 18 Nov 2025
 15:46:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 18 Nov 2025 17:46:26 -0600
X-Gm-Features: AWmQ_blhXXnq12LEDM8AAVYpXJJg1iJQCsyTVfTojMoJ-I7DESkhUkPL7KvhKXI
Message-ID: <CAH2r5ms6CEykTOCFyJ4GVx2hBGX3EzrtNwgE4z+2_+LuYASRAg@mail.gmail.com>
Subject: Multichannel mount failures to Samba depending on IP address (single
 channel works)
To: Shyam Prasad <nspmangalore@gmail.com>, CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"

Saw an interesting multichannel failure scenario to Samba today:

Samba server smb.conf has
   "server multi channel support = yes"
in the [global] section but it does not include a line for
"interfaces" (uses the default)

On localhost, mounting to current Samba from Linux (tried various
versions of cifs.ko so does not appear to be a recent regression),
noticed:

1) mount -t cifs //locahost/share /mnt                                    worked
2) mount -t cifs //localhost/share /mnt -o multichannel          failed
3) mount -t cifs //127.0.0.1/share /mnt                                   worked
4) mount -t cifs //127.0.0.1/share /mnt -o multichannel          failed
5) mount -t cifs //192.168.1.190/share /mnt -o multichannel   worked

When mounting with "localhost" or "127.0.0.1" as the server name (non
multichannel) note that it does not show [CONNECTED] in
/proc/fs/cifs/DebugData

Server interfaces: 3 Last updated: 3 seconds ago
1) Speed: 1Gbps
Capabilities: None
IPv4: 192.168.1.198
Weight (cur,total): (0,1)
Allocated channels: 0

2) Speed: 1Gbps
Capabilities: None
IPv6: 2603:8080:2200:13fc:c82b:b16f:52c8:2329
Weight (cur,total): (0,1)
Allocated channels: 0

3) Speed: 1Gbps
Capabilities: None
IPv6: 2603:8080:2200:13fc:5b60:a7d6:77d7:72cc
Weight (cur,total): (0,1)
Allocated channels: 0

Note that when mounting to "192.168.1.190" (non-multichannel) it only
shows two instead of three interfaces (not sure why it drops one of
the IPv6 ones) but it does correctly show [CONNECTED]

Server interfaces: 2 Last updated: 1 seconds ago
1) Speed: 1Gbps
Capabilities: None
IPv4: 192.168.1.198
Weight (cur,total): (1,1)
Allocated channels: 1
[CONNECTED]

2) Speed: 1Gbps
Capabilities: None
IPv6: 2603:8080:2200:13fc:5b60:a7d6:77d7:72cc
Weight (cur,total): (0,1)
Allocated channels: 0

The mount failures with multichannel to 127.0.0.1 are weird - the
first negprot/sessionsetup/tcon works fine but the second negprot then
sessionsetup fails with the server returning with
"STATUS_SESSION_DELETED" which seems strange (since the session is
valid, and channel one session setup worked fine).  Any idea if this
is a Samba server bug?

Presumably the workaround is to add an "interfaces" line to smb.conf
to force it to return 127.0.0.1 as a valid interface, but this still
seems like it could be a server bug.  And quite confusing to users (as
"Resource temporarily unavailable" won't make sense to them since
single channel works fine) Any thoughts?

And log messages are unlikely to help the user figure out the server
config (or bug) issue.

[12421.964837] CIFS: Attempting to mount //localhost/test
[12422.032199] CIFS: VFS: \\localhost Send error in SessSetup = -11
[12422.032234] CIFS: VFS: failed to open extra channel on
iface:192.168.1.198 rc=-11
[12422.137163] CIFS: successfully opened new channel on
iface:2603:8080:2200:13fc:c82b:b16f:52c8:2329
[12422.137401] CIFS: VFS: reconnect tcon failed rc = -11

Thoughts?

-- 
Thanks,

Steve
