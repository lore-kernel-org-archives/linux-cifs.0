Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4504B16FF37
	for <linux-cifs@vger.kernel.org>; Thu, 26 Jun 2025 03:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750906970; cv=none; b=dw/euM2cxTB8inju3HxOfnxGjNR79dtxzbEaocrtLY7GGqlS18Dlu8ppbgo+wd8esKh4YIw+dNJ8xzJeZWMI4XPdq+3tMfbGunr90W9K8iGw1WoxSTd5o+PnUDWKB9u6f8yHVrcuMb6y5VJ1m/IbRq9LjRt6zAS+c8amxCaPBAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750906970; c=relaxed/simple;
	bh=SQcdcyl9o5wWbnm1mAJPCy/RsddzvmozxD3KN9d0ZTY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=JDhM1tdJxhLoDmZlSwIcBQlZ5K75erQUFroYE2pYLWQVK/y1ZAB6Za89J2BCdsZigApOiG7ae2Ns35LAwJQCQru2ml8LVgBZ71d4Vn3pi9mUYDYsZ3fsTvfZdqojcUM3mFBFOShjVOJ362bevDTRv3TJBeyHe46V/RLDuIsDwT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KUuG0tYV; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KUuG0tYV"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6facf4d8ea8so3894426d6.0
        for <linux-cifs@vger.kernel.org>; Wed, 25 Jun 2025 20:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750906968; x=1751511768; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wQ42CS5KYL5wHFVSKUUqc6a6f47Y/qj53rAM2BAsz7A=;
        b=KUuG0tYViQIabap02vANgde4ywfdOxX7RsNjOMcOr5kSGYt+Ry3JnDKXNCndvEOdDz
         OkLD32nsegEsO0nouprwJnV3lmqfuOBVpS5iNOWctlQbGjP33HTvOQnPXa8cE/fpBSQk
         mzfVz1MXH0/WFAsXMZFItmj4e+YcnMijfQPtnl8VIXcTnSwfIXusDLcSxCw4ASqZQWAW
         UTTRIWDhYEPJsLXVahhRJQu2y7IS6vLc49d0UzlqBa27w8W26L8pdX2VBP0PcLK97Zb1
         fpYaNAIj5IrUyYO19/DOApqLkHNXQJ4kLktdC28HcjrVMuR5ZaSq3LnI0AD/RNHXDQco
         o92Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750906968; x=1751511768;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wQ42CS5KYL5wHFVSKUUqc6a6f47Y/qj53rAM2BAsz7A=;
        b=qJZl7P22PL4zfDJGuRwRk6bETUbzAuGghM8ewOeuWyAvagl8ncP3nFtbZXWq3ef95c
         SMtnGeQIHwgxxhqG65QukWKMQdfE2Q2bZdDOqQTE5NXmXHlzAMRSurKoPTB/fh5f6lJm
         awlbq/g0gaZk8iksIs6+iZh1At7VzhEnagwQ3MSSMNFDQsSr448CE8sdzx+g3rAIeLd+
         SdFf/0W+B/Dp6Sce52iQGOpBWmaGVLxEfp6DZ4KPtE1XRbLpRAnLDxpAEpznTOE2tGmC
         FfM5b9Z/+Dk9A/wVEAL8BA8HHe1dujIuSSPIUSl0c+nfjMidrkFqcvioqbxmZjboIjFt
         Jn7Q==
X-Gm-Message-State: AOJu0YwO+eO7Ww843D7HlnPnMX4K7zSriSoLtV0buOmS8al8Ib5/ppk1
	/NU5fdR1fKLTGQy6mklMuMGeQsGTYUqOMxjHa5Q7yGReaWNBRy/426E7e21QDkxlguv8e8fiz6t
	9m3JM/PvHoJ317TULdGR/aT6IwNfX+rs=
X-Gm-Gg: ASbGncvbwN7bLKhKgGZpCwJpJuVO/YBZxd9fhvmrz1z9YklByAb5UiHut7Miex2n+zD
	LRvpYvebHNJ6OoPmABwrfuXHZd9c48n2L/30EbzNOh8zzi5gcns+sPS7mDK1Jvk0H2B85KDoDk4
	UqyH1Xa6e8IP4bi9mrvp8/MynzsJqr4LLgUaYIp74dMi7a5M0+QRxRoqMBWL0lL5uQYisCnffXz
	sLs1A==
X-Google-Smtp-Source: AGHT+IEmUOWIIEzsIxioptWljk5samfFYMNFOMp/cYwfDAutr3A0JxcOCMeNm2QKGADbcCSPO9kJOP1uJ1s0KwMpr6M=
X-Received: by 2002:a05:6214:2525:b0:6ef:3de:5ff7 with SMTP id
 6a1803df08f44-6fd74cade41mr40045296d6.15.1750906968055; Wed, 25 Jun 2025
 20:02:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 25 Jun 2025 22:02:36 -0500
X-Gm-Features: Ac12FXw0PQ5n4LhdfepEsqtVY5quKq6R4kePS1En1XK1uvvZdmZnLXQfhhdpG9o
Message-ID: <CAH2r5mvHYB91=HU2NMUbinpXTWzKq82RXhRMiAPwSa-u5c6x7g@mail.gmail.com>
Subject: build warning with [PATCH] smb: client: set missing retry flag in
 cifs_readv callback
To: Paulo Alcantara <pc@manguebit.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, David Howells <dhowells@redhat.com>, 
	Shyam Prasad <nspmangalore@gmail.com>
Content-Type: text/plain; charset="UTF-8"

I get the following build warning with the patch:

connect.c:144:1: warning: context imbalance in
'cifs_signal_cifsd_for_reconnect' - wrong count at exit


commit 8596d54298d3170badcfda1175499ad3af240d09 (HEAD -> for-next,
tmp-fn-6-25-25)
Author: Paulo Alcantara <pc@manguebit.org>
Date:   Wed Jun 18 15:22:27 2025 -0300

    smb: client: set missing retry flag in cifs_readv_callback()

    Set NETFS_SREQ_NEED_RETRY flag to tell netfslib that the subreq needs
    to be retried.

    Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
    Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
    Signed-off-by: David Howells <dhowells@redhat.com>
    Cc: Steve French <sfrench@samba.org>
    Cc: linux-cifs@vger.kernel.org
    Cc: netfs@lists.linux.dev
    Signed-off-by: Steve French <stfrench@microsoft.com>

It is built on:

50fa8c47b1e4 (HEAD -> for-next) smb: client: set missing retry flag in
smb2_writev_callback()
37743a9b6195 netfs: Fix ref leak on inserted extra subreq in write retry
3a335ade2c4e netfs: Fix looping in wait functions
827cb4d8a936 netfs: Provide helpers to perform NETFS_RREQ_IN_PROGRESS
flag wangling
cf9167613953 netfs: Put double put of request
0f05eeb631a6 netfs: Fix hang due to missing case in final DIO read
result collection
3556a6e915cf smb: client: fix potential deadlock when reconnecting channels
e97f9540ce00 smb: client: remove \t from TP_printk statements
1944f6ab4967 smb: client: let smbd_post_send_iter() respect the peers
max_send_size and transmit all data
ff8abbd248c1 smb: client: fix regression with native SMB symlinks
86731a2a651e (tag: v6.16-rc3) Linux 6.16-rc3



-- 
Thanks,

Steve
