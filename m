Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100EE1E882F
	for <linux-cifs@vger.kernel.org>; Fri, 21 Mar 2025 03:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742527621; cv=none; b=tjqGBQcSC8CyMqQ1tZ1TTtvFtu2RPVLBuxuYQ51mzJiAHOJMbHHGyiXST62MGftOjJQdC394dvZdGY73m4fXHTDUN2ecmnYGFkOgTetXy30UwxZKW+vzEXR8PWr40jeZQ00WGagqq+EM4fZ28ukQVAKRqSwkczrLwDtDWVUhCYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742527621; c=relaxed/simple;
	bh=vCll+OPN/ZitKiMlYwWIsrTEc6ej8Lf+xlrVAa6BicY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=TZncS8+Ic75Ob27AzmAefWBl2U7U025Zp6n8sahNDH2TRrnffDfFJSPZx3M0+tPcEHoVhyrY2j4WTEkNInjxwHlUka0ui+vbxfc2SANyq5Xj1QYcpqgV4lCF1qufhq/90asrQ2fB8vpH/xq1EV80fHLV+n2r6L60jDfXo2CXXMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iJDX1jHr; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iJDX1jHr"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-548430564d9so1505232e87.2
        for <linux-cifs@vger.kernel.org>; Thu, 20 Mar 2025 20:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742527615; x=1743132415; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wA2OZYBfLfTLh/B6hyQDA0W5xVRP21n02pD10wgFKiQ=;
        b=iJDX1jHrL5ZU6Yy5Z2e+oBZIyot0W0QCkSWVbrFkGuCNTFsn6PAG29DBge2A4WswtI
         CdC6hsYOP5TqOOGQ1fAPGilfhz8Sai5BleEkksbRj8vfoDnP+Gqj3wWlXx+N5AJOdsYh
         FMNnMV472VsRu9fVulEmUHwJqoflSFTttSICCXWAupfapmduar/Mg/mC4GTxPPL8aI1Q
         o7F+qvqxfPNsnoKXg78mNIrnObHd9Q73ZEReOUMdvEDeyfni0H0aDzJe35VZyLTApTEb
         z7wJbu571AKSTr76QGco+hn/rB9QXi8sjKNSwj3FPBiJ86OMls5446pxKHtsSKHz42oS
         55SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742527615; x=1743132415;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wA2OZYBfLfTLh/B6hyQDA0W5xVRP21n02pD10wgFKiQ=;
        b=Bkz3ey3lmZj6+y/6KUto0uZ2yptyQq6abS9/1cmVMAFF0iH40ogdS6K3JayWRpB68v
         qJTKaELm1njYDdqbUupwvsQU25mWghCxRoV2Zi5FhZLWOADniv5aP44DYZksiLTAwqBo
         naVlkKYpj/xQWJgU4A8HWcnGaymHP6be/yO7aHDyKDNQsBnnvQZ14BQsdc82UJnFDyFC
         qR+1mGRpfRvGpvkQibsPITVsTgH9nC2eszYnuxtESipmKFtiqatwDchMuHHgfrH7kyrU
         VFo8Ts1xsFDVHbyTB/yg3qJPpZZblQ5P5YDo2y12jglzVZZ+vyRQvMh6c8pNESEgnO9F
         QmPw==
X-Forwarded-Encrypted: i=1; AJvYcCU2rE55+AxWPQOzW370eO6zLPySJ738fgzg3kk6sSfe/hGkt/wBM50MbvezhR1iXvBpYI/BMgaVhinS@vger.kernel.org
X-Gm-Message-State: AOJu0YzOaGFaiT7Wmf9LjtvdTnQkLqYRQ6V2cFClm1B16zfqWSNW9ejH
	LceS2YaViTFW4g4EvxNU99GwnnQHUgIEXzV8cm14KGX9EbO5Mczpf+3y5VG04jJ/BFNW7Bdb7om
	n/KPLFtMZXQwcCkpRCXGn2hebGh8=
X-Gm-Gg: ASbGncvUsOV4QcYiibQK3eco+D6OQD18QI11/rvmK0+POmVfyBWTaOOT6PWIbc1uYSJ
	fXrImDs0dZ5aoMgi3pbZtTOOc8dsloxnQI0LeAxC1jj+Y2W3A4WWyWEFIW9pYBUUhIURic7O0Ca
	uextHI5cFa5U74SY94mdN6bYo5QZsomuttxiKSTzA//GUKCoxCOfDDNftTbtg=
X-Google-Smtp-Source: AGHT+IFmcnR5S9gteSIdT5qXoUENuc2A2Kt3CUkTEBdy7BPEAMuU7Ab4QJp/mH1FsEdP7a+y/GyO9oQzwo+F2NMrHr4=
X-Received: by 2002:a05:6512:3b98:b0:545:576:cbd2 with SMTP id
 2adb3069b0e04-54ad6479e3bmr405890e87.10.1742527614839; Thu, 20 Mar 2025
 20:26:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 20 Mar 2025 22:26:43 -0500
X-Gm-Features: AQ5f1JrhLT8hfdwAGxQ2OWQJ3LqM-TpPsD6_SQclzYdMO7LGCPq1VbaOAIquRmk
Message-ID: <CAH2r5muHk=mUQo_SPk3DdzC7=0VCNiS3fDtotHxYUkT746RP=w@mail.gmail.com>
Subject: xfstest results
To: David Howells <dhowells@redhat.com>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

With the first four netfs patches + 6.14-rc7 running our standard
regression tests to Azure with multichannel, I saw a couple of
unexpected failures.

23dbb8c5ffaf netfs: Fix netfs_unbuffered_read() to return ssize_t
rather than int
78067c2bd7f9 netfs: Fix rolling_buffer_load_from_ra() to not clear mark bits
6be938f6c265 netfs: Call `invalidate_cache` only if implemented
5fb49e95f2c2 netfs: Fix collection of results during pause when
collection offloaded

See:
http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/5/builds/403

Test generic/604
+/mnt/scratch/48: No such file or directory

and also test generic/738

    +/data/xfstests-dev/tests/generic/738: line 31: /mnt/scratch/48:
No such file or directory
    +/data/xfstests-dev/tests/generic/738: line 31: /mnt/scratch/48:
No such file or directory
    +/data/xfstests-dev/tests/generic/738: line 31: /mnt/scratch/48:
No such file or directory
    +/data/xfstests-dev/tests/generic/738: line 31: /mnt/scratch/48:
No such file or directory
    +/data/xfstests-dev/tests/generic/738: line 31: /mnt/scratch/48:
No such file or directory

But with all six current netfs patches (including the two additional below):
68109110fec1 netfs: Fix wait/wake to be consistent about the waitqueue used
4f8443992c8c netfs: Fix the request's work item to not require a ref

http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/5/builds/404

I see a hang early on e.g. in cifs/100 then in cifs/103 (and all
following cifs/105 generic/001 etc).  I don't see anything useful in
/var/log/messages

I don't see anything suspicious in /proc/fs/cifs/DebugData but in
/proc/fs/cifs/Stats I do see it shows a session reconnect, and I do
see a suspicious number of open files (which oddly enough is created
by an earlier test, before the hang cifs/100)

          Open files: 1 total (local), -2 open on server

root@fedora29:~# cat /proc/fs/cifs/open_files
# Version:1
# Format:
# <tree id> <ses id> <persistent fid> <flags> <count> <pid> <uid>
<filename> <mid>
0x5 0x792a00b20000a11 0x56ce090b 0x8001 2 5497 0 big-file 23

I will also try a more general test run to see if I can reproduce
anything useful with those


-- 
Thanks,

Steve
