Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5492F35970
	for <linux-cifs@vger.kernel.org>; Wed, 11 Jun 2025 14:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749653631; cv=none; b=c0DpJ6IDYDYBy5IYIFXzQxg3/CgDtvGkwtM/vrY2kSGc5xpagbXRe8D25aWyMxrFxYxbLbowvTVl3yMv2sutcg9EAs573P/jCTn62kkxdp+RM6fEWJZ8huXmqqqR6Z0On9/pcKXzGWu8igoYBoYGFHxkAGQm8HKYbZ7ZfKaZCgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749653631; c=relaxed/simple;
	bh=7pqvXKg+eAGnWOGMfSyxw69H8xuwKtDHhZCiiztrhws=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=HDzBm2o8UWgDS+dEyWqWh3+J4+hkGtXAVKltW9XjMWEaPOn0jIrwpf2BuYrNn2YM2QHuBuxbXNSzlsGEBv2iQOpivjMD+r3LWXwY+0OnNDLeeDOpYc8MjUYtVL+ImLL+f22H3vL0LYK3Qwr0tBheCn4IiCT70Htlg+Dd2mkKMx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OvLkAhgQ; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OvLkAhgQ"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-32a72cb7e4dso62295471fa.0
        for <linux-cifs@vger.kernel.org>; Wed, 11 Jun 2025 07:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749653627; x=1750258427; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EixwbtilCdYG7q9Ug2lZrBIZ4Qp+Oiwja0dBXnRM91w=;
        b=OvLkAhgQKwfIg5zRrgalTY51ir8Ck31NpV04lThepxYWAmdE9W6tAezgcN6oamJIVV
         nabJIeKRpGCSFbLZTH8uIDS2MR/Ko0spHtkCIpecTVke0V0oYiyCXxaURHPKIHDV/xsH
         sa2kMpFXmb/Q+oYQ1Fd6rY5p1o3fRBBnQNPn2D4ER1R8ZhuQOXAUBY0xzcwuuAWyrOlk
         50V/8v8Kp3+pWWNuLBpYe8sEfCkBaUcy65vGxf7IwWbD8m2OMidj7V6jyWAdxe6IJLYr
         a6lTITKiEHcZcpt+QgBnsOPbG6BtiTwowm/w23DkawLkzdWsamvzNynV7H1SPdZu77Jd
         j0Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749653627; x=1750258427;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EixwbtilCdYG7q9Ug2lZrBIZ4Qp+Oiwja0dBXnRM91w=;
        b=fJLBOSATK+aMDT+8WZFBYsADSUyfNvEKuK3QiDILuWDskNetrAWCr5y0wegNGfo5Lj
         5/gBqc+0FLuR67UAuNWJcxlE5Cv06bxDVKSBV7Qez3i+yX/iAIVvdUZ3+CvOUMOffBd6
         /hN5Oa4GQDAvKlCL63RuA4eN3EQSxNOUV7F414A/0kTi0KNSYn+uQhEMejavpzIpgbMo
         8rBet23YunuyVY3ucX/mKHcC9kbScp/+qGGnQ/A/VFA8Q8G/rwW3QvsRVhPEBaOMUbSk
         ytfoAYEJjAVcU9A/WZnf5AZ3jtandgLcfpcSNdm4RYrKgnUyLyS1LOaA+0j0445SAStX
         nDVg==
X-Forwarded-Encrypted: i=1; AJvYcCUA+/5AMf1goQ8WmmveY9uRMnfietlI/shmIwEUNr1W0oYWZuENGR4GOJIVS8WWq7CjNRH2dHoeNZxz@vger.kernel.org
X-Gm-Message-State: AOJu0YwNWLNzf8vp/B9ExH1TfSxMeB1gXGUCHpjJ2QRnDm7C7G8+HyN8
	7rLBNYeNtpeUnCbmRyiVnuDHxKqgDNMqmZObETvCuxphh98soXnt3eW/VxXaB0akL0KiP5WMAce
	PszEaby/SejO1cvUXb1NGSlGn0OYgjSw5HGav
X-Gm-Gg: ASbGncsJDmsFdRXL5CNlLiHfzTUYpSEh0GeW0cTa9duxhQEix0Jv49tOQa8SmZgg4pU
	6pZBos8+2ajpbxXtByjPYMoYmqzO2RYKScIAfMBArO65dDh9ba83LMrITjzx7E1GkikoD3NWBLT
	yfenLxAD5qk5n8OjjiFUItpAsyBwgKqaJg0hiRoQ13WN5NRFVnysC5+NjJP294bazgbkxzNkzt+
	60=
X-Google-Smtp-Source: AGHT+IHayKtdvwNsbLJGG06aq+EXMqKfVKgO+acP9C26JkGlBCPIfG6kwusQ2XD/8Fw0QmAovvdXnC6hinU5RjwfNkE=
X-Received: by 2002:a05:651c:1542:b0:32b:2d5a:c50c with SMTP id
 38308e7fff4ca-32b2d5ac6c2mr3057881fa.36.1749653627178; Wed, 11 Jun 2025
 07:53:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 11 Jun 2025 09:53:38 -0500
X-Gm-Features: AX0GCFu6bxvCHS5GhpYfsiqccNr07gLG4spItqDUixUqSqsV28caA7VpHT8CSvQ
Message-ID: <CAH2r5muQB8CgN7r8SE8okujV2rpvQoKYAP=yD95a_R1hLjKWqA@mail.gmail.com>
Subject: netfs hang in xfstest generic/013
To: David Howells <dhowells@redhat.com>, CIFS <linux-cifs@vger.kernel.org>
Cc: Paulo Alcantara <pc@manguebit.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"

I saw a hang in xfstest generic/013 once today (with 6.16-rc1 and a
directory lease patch from Bharath and the fix for the readdir
regression from Neil which look unrelated to the hang).

http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/5/builds/487/steps/29/logs/stdio

There were no requests in flight, and the share worked fine (could
e.g. ls /mnt/test) but fsstress was hung so looks like a locking leak,
or lock ordering issue with netfs. Any thoughts?

root@fedora29:~# cat /proc/fs/cifs/open_files
# Version:1
# Format:
# <tree id> <ses id> <persistent fid> <flags> <count> <pid> <uid>
<filename> <mid>
0x5 0x234211540000091 0x5c5698c8 0xc000 2 32005 0
f24XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 6928



root@fedora29:~# ps 32005
    PID TTY      STAT   TIME COMMAND
  32005 ?        Dl     0:01 ./ltp/fsstress -p 20 -r -v -m 8 -n 1000
-d /mnt/test/fsstress.31810.2

root@fedora29:~# cat /proc/32005/stack
[<0>] netfs_wait_for_request+0x100/0x2e0 [netfs]
[<0>] netfs_unbuffered_read_iter_locked+0x87e/0x9d0 [netfs]
[<0>] netfs_unbuffered_read_iter+0x6d/0x90 [netfs]
[<0>] vfs_read+0x46a/0x590
[<0>] ksys_read+0xb6/0x140
[<0>] do_syscall_64+0x75/0x3a0
[<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e


--
Thanks,

Steve
