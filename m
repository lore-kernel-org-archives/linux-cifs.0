Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13E63AFCE1
	for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 23:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787872134; cv=pass; b=loRY4a29CC5sNOt5J3N4zCRUEptARRu4WJNmoE7CNDd7hu+qwO1ALR/0F2EMRiBQvem8Est3ZidB4hP21BUY/Wg+e1IoQ8Phd2tdbIqBly4u7jcVkLIn1ZkP/5o2srLcV07IAS2442+Bb9ymuaKnSvrtgwELNUgUy3Wh8oLe03g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787872134; c=relaxed/simple;
	bh=QE5r8Hefclm76uVhId1kbMmsj7Fs1WnSDJQ72lFByhs=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=DqNIkppfVi2lZGJV35md5nI/2nPpB6mmVKpgbor+SOf0+ymh3h3ehBrYIi/ZdLxRxdvbCblWS57lXFC7YbZX4ORARGmXyZxEtccSUhfsoYLxvni2VUm4NaNPzqEjYfC7XeMJSWaeUcGh1FaWvKf2IBQ1MVPv4CH+R/26OtcT230=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=MzrwqrSM; arc=pass smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="MzrwqrSM"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2d715f4a587so5812935ad.2
        for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 16:08:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787872132; cv=none;
        d=google.com; s=arc-20260327;
        b=gqReT40g+jb39kEVXBYTFuts5Gb19xt41qZvSMLNn9GYM5lEO9NsAjpAFLgzbyZtXy
         h0yUFQu66NE+pLbRgSxCX9BSqMYi4UrdlJNAC6Tqb9176o1/x1MmCD0TOxVnY+hHWXCw
         nSdnRxlPnfKPBxQXUdnnlV1DJY0nTW8bWjNC067IZvBT3RmtR40l3Be8a5RPjpa0s+Qz
         uPYC1TMfxjFPeoK7Vu8jMYhxptYhTiZkYzAR1jr8U8qDu9NWr/4pr8vVwHfzUNQopi6/
         ZBxThurlbnUUdf7Q5tz8lK3iYJjqKHgYptWE9svY8QFqmgSjBf1UxiV8dpO5q3oTDp+V
         xLog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=JdtPX2uer4IOAQhgeqeDxfMKbOSrBGipE39HlDMAV7Y=;
        fh=XaQQkVMfr858OYuZERUuLQG6EHb9BSG+s1p3hLFFjdg=;
        b=RbtecLVsSO0Uh6zo+jUL6NDW8ZLbf2Dr7IKRded5epIvUMvPB4LAoCSmf43x7EiWL9
         N3TYv8iz7WEqjoD9m8KPg1sk+CYd1m2jzEiLmcGA+PsmzPmEV+pwE1v3u3T0dsg+Qhuu
         LwrsBCqcPSmkQP9ANH+24d7f3pEsNJvD/jL/t1xkYN67tU7Tt8S8Mq8iFuZQlbx1AzAC
         vAF4Qu3RlnA29XDACpL2/UkaxwL/6Cyp6oFar6eat/bV/C3zYxbtTxI1NgHuwkgFXg9M
         TmiIdV8kF/JrhprzCz6m36+phEdk+0eRcIR/3hF+NdyW5td/Au2CyzLP+BU4MZcvzBKr
         9FPA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1787872132; x=1788476932; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JdtPX2uer4IOAQhgeqeDxfMKbOSrBGipE39HlDMAV7Y=;
        b=MzrwqrSMJuh1MCLtMwBFoLtEj8HIT2tiVoE4pFY5qBN/YJW+qjRRpA3WDjqyrFc+wc
         uZUGzc8k+VHe/SA7RE2JfnKPh66Zg8N9SPLJrkb8Gi1gpvscxjMZ6K1E0hBvtsEmlp7n
         +NBoWrjFREqpUAixvJOHJpVXz+8/8sh6CIWiPiVQEEk7XGezwJTzqmHullWeEL2UpMQR
         YDlD70oq+N+ZDrU9E+0XlZ3018QL0nOPrO3TBYP7etEp4l1cOO9ldkSltDUWh3RVXWhZ
         8EMQGmNeR0Ya0Ma5fivmIpPZdClK/audSCbdY/v3tLXJ8UDm1dpVsvhKuJJJ6Gumkc3Z
         1dlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787872132; x=1788476932;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=JdtPX2uer4IOAQhgeqeDxfMKbOSrBGipE39HlDMAV7Y=;
        b=NMe+PyMBxpfQQdKmAQ0+bD32nPWHYQOChAlVSFipi2AVLP2/TnmUj3pTJ4G9iGcl73
         6VAKkUKSJdwpogtIez2dPdcTxOTE5i2HEpviTcFsW2vxK7cuQti8pT358xDc2P35VwjT
         6PKTHhJhMoMTtpeZArEr7KRCnqJV6aYAsU9uX+lvsbe6BwFjJ2PZsDA6HGveR4y1djUS
         HXhJES06KKq3ICAQbto4jL2dKqWiIgYp1+KuD0ACr2Xrtc7pzxQ2FYuLv9TSkfa4hRCo
         wYGWc/qGuN+CmJIHI4mOTL1FdPN8ty4M6aXFCBAhRUoGM8LXveWHB7A0JB50aXQwWCbt
         rS0A==
X-Forwarded-Encrypted: i=1; AHgh+Rpvigqx5WSvHOuHwxtV3eHdQQyJysrRO3TVX1WNFsrPF5+G8HmhOeRaPRR4UTGmbs9P+B3I3cE1RDkT@vger.kernel.org
X-Gm-Message-State: AFuF++mlBYWYabzaP/lohal1evja7aM5fO/TeZnteVU9vNPygGG/BAkm
	Z74ISEUa4AvgG4pTNv4KB6H+GN/b3c5YIr1Xz3S/fwJ+73JMwkgpF/Ebvxy5t/Glzv3sMGWIddp
	3G4kG+UybMmFe2xdFC6EcFifxZf9qx3xYQ5hBSO8w
X-Gm-Gg: AR+sD10bV0NUhQXqAj2i4bFIemFCXEqBzo8uBkGxt6/+8d7PZe5wmwZb1tq4NwDvbpG
	SLrjIOIYfXzY1LC6AJCdQ1ltcU9h1weXA65/Rk2uKeCVqac4zHHB8PG0XmUrYeOLns7hWag2B5q
	e63GYuc0GuRSm5d3wmnXp+bn1tSGwjWsfFU4HdhXBVknK2bMKLZD1pf9m4G/hhymncZrUCeHBA2
	uXjajOt39FXPsIjwue+y3vpV2LrF4lZ+LJFGSDeFmMPIKQ+8Tx0ukvA3Yy5jMbbQoj68LSlF+4d
	ZvkHd8jcLdYQZZ5L7SbQ2ARaezwoNMrwGNa5Uau7y0OpzsAPIfqI+rXl3bFbaSuFNo1EXwp2Rm0
	nO7gUB5PD+F4MZHUI8YJiToF2BsgmUuKC
X-Received: by 2002:a17:90b:39ac:b0:38e:6f90:eabd with SMTP id
 98e67ed59e1d1-396d0ea5451mr3577011a91.5.1787872131206; Thu, 27 Aug 2026
 16:08:51 -0700 (PDT)
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 27 Aug 2026 23:08:50 +0000
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 27 Aug 2026 23:08:50 +0000
From: Farhad Alemi <farhad.alemi@berkeley.edu>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 27 Aug 2026 23:08:50 +0000
X-Gm-Features: AcwNN1VbtQ_TKORfhlFpdsm_n8MBcq9xHZjdMpqeltBevAURlMvwXQR-2yvryik
Message-ID: <CA+0ovCjUB=g+56ZCrT4MPfWjqBJX_CO=vfp12JLOrh7B53uVWQ@mail.gmail.com>
Subject: [BUG] ksmbd: use-after-free on iface_list from the netdev notifier
To: Namjae Jeon <linkinjeon@kernel.org>, Namjae Jeon <linkinjeon@samba.org>, 
	Steve French <smfrench@gmail.com>, Steve French <sfrench@samba.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>
Cc: falemi@asu.edu, linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello Namjae Jeon, Namjae Jeon,

While fuzzing Linux 7.1-rc5 with syzkaller, as part of research at ASU's
SEFCOM lab, we hit the crash below. Crash reports can be found here:

  https://github.com/farhad-alemi/public_bug_reports/tree/main/117-ksmbd-unlocked-iface_list-uaf-netdev-event/

  refcount_t: addition on 0; use-after-free.
  WARNING: lib/refcount.c:25 at refcount_warn_saturate+0x9f/0x110
lib/refcount.c:25, CPU#1: kworker/u8:3/9983
  Modules linked in:
  CPU: 1 UID: 0 PID: 9983 Comm: kworker/u8:3 Not tainted 7.1.0-rc5 #1
PREEMPT(full)
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
1.16.3-debian-1.16.3-2 04/01/2014
  Workqueue: netns cleanup_net
  RIP: 0010:refcount_warn_saturate+0x9f/0x110 lib/refcount.c:25
  Code: eb 66 85 db 74 3e 83 fb 01 75 4c e8 db 45 27 fd 48 8d 3d 04 03
1a 0b 67 48 0f b9 3a eb 4a e8 c8 45 27 fd 48 8d 3d 01 03 1a 0b <67> 48
0f b9 3a eb 37 e8 b5 45 27 fd 48 8d 3d fe 02 1a 0b 67 48 0f

Our reproducer.c is available upon request.

Happy to test a patch if that would help.

Regards,
