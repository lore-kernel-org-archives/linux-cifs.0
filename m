Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C613E5A2B
	for <linux-cifs@vger.kernel.org>; Wed,  5 Aug 2026 20:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785962355; cv=none; b=fVNNRJ/Auw7kVmTMGIBgZQwpklxA3GwmHK8GZRr6f5ftEJfAACT1RtDatS62vWC2krRG/Ho86bLIHVXjaC9cUN0S2dUL9o4WdSliKkfUWi7ZN493cEvAa3pMrGgbNGr/WOEMiqxYh6oig19v9qdy9vnWNT4/IE1v+w7QfIdro5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785962355; c=relaxed/simple;
	bh=wgmPbl249g52xA+Bddz1DQI/PvZaG1sW7t/AONKlZRU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y5TKm5+BjludZEFofj4ynsl0aVMhvAtiPKpiHFsW9NB2+1e8Tl8NtothUq2OW1NSmDIZ7nGKaJuKTgpo7kkU86nf2s1h/A0oZABu/Q8UCbaAdzQYcm/DzaM+PnC/oQTkmYV1hkKJthEGPAkX1BJqRQqxcuW6uxwLbT193bR2ySs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DOfBsdqV; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DOfBsdqV"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-9087fb771d3so8003396d6.0
        for <linux-cifs@vger.kernel.org>; Wed, 05 Aug 2026 13:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785962353; x=1786567153; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Zw8DFbXBvJTSlk1JDzDjVVwTGalImggl7IFcYr48eRg=;
        b=DOfBsdqV7Vlc0noPn4wkuNAGSlgfhyHokMIQqiV+Z04b2nzUuK6XBwryqUvDxeGbMv
         /XQh3E7sfCggG5m/WLCNouUNZJQhqiMDaunTZdKd5vDBgOcDuVz9eTWOQrIXImU7oAhM
         KiAIkw5bZJBZGPSIQOx222zadHMshDt+Pjshfj8CV1ge3V8B10dpfs1XlyefRIYOWAlX
         cCOsfQJmK8IspQP1/2BzCUgxzMCVH0XgXvXJNe1SU8inik3E0jok5859HWyinpORFctW
         Y7HEco4CmVc4r+cPux1pHAoDUMZMYRYebgtg9Z+/EMN9arxUgwwv4mx46561URa6cu/v
         C/Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785962353; x=1786567153;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zw8DFbXBvJTSlk1JDzDjVVwTGalImggl7IFcYr48eRg=;
        b=PuvNh62D+exG53Xgkv99YWuFYBmcBB2WOZ/fDzpTQC+cJQlPZLfeANXFoOQByAROEg
         spaPuHsQGmWGYK9q0iwWEM7FhodvDzc9b9bsd36dVvwltmtzB70XtjiGKzGxNSU4+6ap
         IZdCU2mTTTsiMOtn6+GznEGkH4Y6ivqJIiq3tcMrU/5mVpBC1J3kZWiEiqniJv6Sxhdg
         yW1df4JvqiUUkW5BUdhFWMPaY6r5/2PbQIHTolohHYOGH0OYXqs5sh77cPblKkF/xuH4
         APaYG3napf870aZ4Pueu2NrduegQ7qnwbvC4mRiKQtYNyA7hSFXWY7l2F5pwM8e9gTeY
         syoQ==
X-Gm-Message-State: AOJu0Ywy+ehAfchFyqoqd68f8jNbHsSZuXs1Am7JJvAVS58bvxvIrrFe
	5pdYBsP69yHk6W1rDyNf3TojYmv9sreUxMS/vqApIt9tn4NGctS20DqDLypVQg==
X-Gm-Gg: AR+sD12Rur9j4ZUh5V3tWV83EjDOGDjQ0lEkC0qBG7/gFGcAyRXkMyi8tt5ftTucd+T
	XDIFb/r3QjpDwsab8j/MdLwa+AN76CtblZ4zhf7/jnsjQo4hqGAf3KpnVkeSMlOaiVIvmPxdAHM
	RgE7Jss1r4FP+EmrWaIoPoId637OLvj0hPMNk8+K1sLqAvPuIzZI5a5mUzCawzpJ/4k72d7AoHs
	XVjdfJLLJRIR7StkkKgjbSZ0D/FL36KTNpqU2fiAXnmSQgqXqThu+Q+zrHYtSEHUkxe75Pmqv8w
	9oxoxzSCumgQ3P4miIVgniLzNQ3Msl+0hpsh5Rqq/D6nTtJdfYn6VoCVYWf5xhfex6CcINoSmLN
	BNPUXk1keGx6kFSpPdzWj1VXhV0e2TTcso+atziohKnybAjJjhWvpS5Cv1pV0cWaES4gtloJTts
	uIQU5UTp1ujHwNcp7F1KOzTUvgFH/50sShp8YgNGQwwxjwZsTKWyt0uwtRc1uPUmQnkXYX9cEkC
	2tBBsIBygXgw4wYIxVbL0EJLu03DkdcxoKkOKotJDB1AUrpl8KA0ub9ERb0shGD13IOiY6aB7Aj
	l8piVXHDQaVdi2SIL0HhuvbsGwJWl4o0LhTMY74Qiovtwxn2H1QNwDAKPQrsgoYjutw2ISCat/E
	=
X-Received: by 2002:a05:6214:411d:b0:8ef:e857:c9d6 with SMTP id 6a1803df08f44-90881367cfdmr104275256d6.22.1785962352669;
        Wed, 05 Aug 2026 13:39:12 -0700 (PDT)
Received: from aw4re.localdomain (d172-218-149-224.bchsia.telus.net. [172.218.149.224])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9088008e9aasm34130346d6.28.2026.08.05.13.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 13:39:11 -0700 (PDT)
From: Gustavo Nobrega <gustavofn@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: stfrench@microsoft.com
Subject: Per-entry WSL EA queries during readdir cause severe ls -la slowdown on high-latency links (6.12)
Date: Wed,  5 Aug 2026 13:39:00 -0700
Message-ID: <20260805203900.2930456-1-gustavofn@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Steve, linux-cifs,

I'm reporting what looks like a missing negative cache for WSL extended-
attribute queries during directory listing. On a high-latency link this turns
a 3ms operation into 21 seconds.

Environment
-----------
Client:  Linux 6.12.0-211.16.1.el10_2.0.1.x86_64 (RHEL 10.2)
Server:  Windows Server, SMB 3.1.1
Link:    site-to-site VPN between datacenters, ~76ms RTT
Share:   FTP landing zone, 511 subdirectories in the parent

Mount options:
  vers=3.1.1,cache=strict,upcall_target=app,uid=5000,forceuid,gid=5000,
  forcegid,file_mode=0664,dir_mode=0775,iocharset=utf8,soft,nounix,mapposix,
  reparse=nfs,nativesocket,symlink=native,rsize=4194304,wsize=4194304,
  acdirmax=300,acregmax=30

Symptom
-------
  # time ls -la /mnt/share > /dev/null
  real    0m39.031s

An identical mount of the same share from a 5.10 client completes in 0.003s.

/proc/fs/cifs/Stats after a single ls -la (511 entries):

  QueryDirectories: 3 total 0 failed
  Creates:        512 total 0 failed
  Closes:         512 total 0 failed
  QueryInfos:     511 total 0 failed

Enumeration itself is 3 round trips. The client then issues a compounded
create/query/close against every single entry.

Root cause
----------
smb3 tracepoints show what those per-entry queries actually are:

  ls-766626 [000] ..... smb3_cmd_err: sid=0x... tid=0x29 cmd=16 mid=40511 \
      status=0xc0000052 rc=-61

  $ grep -oP '(?<=status=)\S+' trace | sort | uniq -c
      268 0xc0000052
        1 0xc000019c
        1 0x80000006

0xc0000052 is STATUS_NO_EAS_ON_FILE, on cmd=16 (QUERY_INFO), 268 times in one
listing. The client is probing for the WSL EAs ($LXUID/$LXGID/$LXMOD/$LXDEV)
on every entry. The server has none and says so, every time, at 76ms per
round trip.

Notably the mount forces uid/gid, so any ownership data returned would be
discarded regardless.

Command distribution for the same listing:

  $ grep -oP '(?<=cmd=)\d+' trace | sort -n | uniq -c
      548 5    (CREATE)
      282 6    (CLOSE)
        6 14   (QUERY_DIRECTORY)
      553 16   (QUERY_INFO)

The CREATE/CLOSE imbalance suggests retries on top of the base cost.

Tracepoint event distribution for the same listing:

  $ grep -oP 'smb3_\w+(?=:)' trace | sort | uniq -c | sort -rn | head
      830 smb3_cmd_enter
      830 smb3_add_credits
      295 smb3_cmd_done
      292 smb3_waitff_credits
      277 smb3_enter
      276 smb3_exit_done
      270 smb3_cmd_err
        9 smb3_tcon_ref
        7 smb3_close_enter
        3 smb3_query_dir_enter

What doesn't help
-----------------
  noserverino          511 -> 271 queries, 39s -> 21s  (only thing that helped)
  symlink=none         no change
  reparse=wsl          no change
  vers=3.0             no change
  dir_cache_timeout    no change (set post-mount, so possibly not applied)

There is no mount option to disable the WSL EA probing. Checking the module's
parameter tables, wsl_query_ea/wsl_query_eas appear to be internal only.

Repeat listings within acdirmax=300 also take ~21s, which suggests the
negative result is not being cached per-inode.

Suggestion
----------
Two options that would each solve this:

1. Cache the negative EA result. If a file returns STATUS_NO_EAS_ON_FILE,
   don't re-probe it on every stat within the attribute cache window.
   Arguably worth caching per-tcon as well, since a server that has no WSL
   EAs anywhere is the common case against Windows.

2. Add a mount option to skip WSL EA queries entirely. Mounts that force
   uid/gid/file_mode discard the results anyway.

Happy to provide full tracepoint output, run patches, or test against other
dialects and servers. The reproducer is straightforward: any Windows share
with a few hundred entries over a link with meaningful latency.

Thanks,
Gustavo Nobrega
