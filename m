Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AC213DDAA
	for <linux-cifs@vger.kernel.org>; Wed, 20 Nov 2024 15:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732118099; cv=none; b=lCpcSAlKvNNo8BFe7XdWJQFCQ+IKvEDPHLVKbiSqFFRlM/8AiiT/xUPq1rsefffi70LeFffcqr6URPcdP/GqBQlQ0l2d7kU3c1v/BY4wHZjoIpAT5fH0e5TSXNULcA/lLRiaWXoMfIIqG999MCVEIzpowWblmhaP15P+jb8Xhx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732118099; c=relaxed/simple;
	bh=9oN+HWOGW+aLvpua78cbeU3K/Ek+W0ql097PEc25Q1w=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=F0rSGTy6moD3VviujbxhXX3xRRKy7t++Pf0nu08+BhEgOjmClw65qoFb+KB1c6IIAkc2w2ncWzq2nQWqVu2HkzNpenpXdRtfOyqQIhKL9o+wDmW4f/L+LjCvR5BHgsjShLgDC/8eZmm8lI+yRLhFysJIMjRUESXjfhJSveGEYQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TBmYgvvg; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TBmYgvvg"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-53c779ef19cso7094507e87.3
        for <linux-cifs@vger.kernel.org>; Wed, 20 Nov 2024 07:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732118096; x=1732722896; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=28z1hCfmqakC267HuB8NhImTV9sBB3ColUZvy1H2JCA=;
        b=TBmYgvvgiMGHE2YmLd2dyLRoIgsrWdlnIjFGZwwf6WvJQGaQIz8mOX22cF7eMXuTZc
         vJgvFnyDhuyXUqBMS3nr99Ap3HBDdgl5/zNVT1X3BodJDzAPhUF0jzph+JWRJOEtA9Tf
         Y0kbEVzU0iQtZvlVILnthlmX9u7Q/pifGwhM8oR3g9S2xMlumC8iP7uYxxf8ANYMOH+b
         y6seKw5oUFHvwZxeOfIDocTJaoRp9xZk4CnnU7AahDXj36hFA6pkMHJvmdqwNKgYe8wl
         RNeorOS7JmkOTabvWi94RUv4jnDQW4ZTXzxPjnQlGMTebzlAhCMZwzCRpzhJ0s+LWSjS
         yCJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732118096; x=1732722896;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=28z1hCfmqakC267HuB8NhImTV9sBB3ColUZvy1H2JCA=;
        b=bcmd1f9j3FZBHPENerMarihlACztWOWjbNs+KOImCpa9xTDCOL3u1tT174E/Id3//2
         D5jdXGP5pkman2uQ5apL4FR0WNOOZT0Uj+MccA/WWjlH7EZNoXhv94rCdc06BjUZw9sL
         FWPHEqwfR6g6qx4vjbkmE7uKm+pUKqK1kfh6qc7zEHn9w+BHxsfiKQIBAYy13NoFhY/d
         zLADqw69bUTmSNTU/7ht5nn8JyaOBtTO809g7eWzSHFKuj7snJoVf9Y5YQNnEhST0TCZ
         TqmNKNUIXaTvCjth/mq97KPVOGWBPhaNjEoy4ryKRWcn/Z+Id8zNRhxt/L6MpfTOwlpb
         XMIA==
X-Gm-Message-State: AOJu0YySKhRYIlBHIbl7kX7/i4T/QACrDlFG/sW5QKDLlYKt9PYi5iCO
	DcxHXKPkS6i6MQizNcc7B6CgsMKSXwzFmwOP7OMFL7jkDrppVDLgG/0Jlfs3JFPKXleq9wIAK8g
	Pit0bBkDlDK5Bt3qD4/22qeayE3gtRBo3
X-Google-Smtp-Source: AGHT+IEI6SxJcav9GIAc6D4zrPUSHdXDhhy3RAokGpZL+Ut3Y2FaXxf4+BC7JC/Lmzkq9Jhb5c+CrheWPOivlZ7o5kY=
X-Received: by 2002:ac2:4e04:0:b0:53d:a550:2885 with SMTP id
 2adb3069b0e04-53dc136b5e4mr1515163e87.47.1732118095709; Wed, 20 Nov 2024
 07:54:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 20 Nov 2024 09:54:45 -0600
Message-ID: <CAH2r5mtqcvbj4qnNJ-e8Oi9S55ObFyq23EhVV0XqpabaM-tx4A@mail.gmail.com>
Subject: Test improvements for cifs in current for-next
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

I tried a full test run of all xfstests to Windows (to see if any
additional tests now run) and noticed that with 16 recent patches in
for-next from a few days ago (there are now a few more changests in
for-next) improved multiple things compared to 6.12 mainline - and
fixed at least five xfstests: generic/436, 445, 499, 532, 706 and 707.
Test generic/596 looks like the only one that regressed (now returns
"chattr operation not supported setting flags on /mnt/test/596).  Any
ideas?  Does anyone else also see this?


bd24dab9c51a smb: Don't leak cfid when reconnect races with open_cached_dir
ac816a3e8f59 smb: client: handle max length for SMB symlinks
ea9a955b2370 smb: client: get rid of bounds check in SMB2_ioctl_init()
fe37d2e187a1 smb: client: improve compound padding in encryption
81624f46e4f0 fs/smb/client: implement chmod() for SMB3 POSIX Extensions
32c24729bf93 cifs: Recognize SFU char/block devices created by Windows
NFS server on Windows Server <<2012
66b50cbe1885 CIFS: New mount option for cifs.upcall namespace resolution
f1f1304427cf cifs: support mounting with alternate password to allow
password rotation
8b6cb80e6759 cifs: unlock on error in smb3_reconfigure()
cfe2318d5a31 cifs: during remount, make sure passwords are in sync
89c00c3afdd8 smb: cached directories can be more than root file handle
977b1865daab smb3: request handle caching when caching directories
343d7fe6df9e smb: client: fix use-after-free of signing key
7460bf441656 smb: client: Use str_yes_no() helper function
f69b0187f874 smb: client: memcpy() with surrounding object base address
6c9903c330ab cifs: Remove pre-historic unused CIFSSMBCopy
adc218676eef Linux 6.12

There are a few more changesets in for-next now, and I am
testing/rebasing/reviewing others as well that are not yet included in
for-next, but also let me know if any additional reviewed-by or
acked-by for patches.


-- 
Thanks,

Steve
