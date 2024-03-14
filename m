Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DFB13FFC
	for <linux-cifs@vger.kernel.org>; Thu, 14 Mar 2024 23:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710460056; cv=none; b=di+D1vkRiCQ2sNz2PkEleZp/U8Zx5MS/yPNDvdc7csrVwK1pbgR+7QBHtoDa1WUjSy9eUWHmIHCzW2jKTAvyoK1gsU6wIVY3cogmN4b1qvvxK4QP/7h+VwdcxP6gGoyyqwx0+it/KeNcrPplvsT0UUZY3TZzsiC3+ONPHxYZXYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710460056; c=relaxed/simple;
	bh=xC45Bb4a3dmdnIJ0vIzzxsMmhIG8y+WilTWYO4nQ/eA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=JaxeWi463PqEX7HNJNcpBtZT1Vwlj64rOTqJAZNAjP8HMA8f1BWaINQc62vvnTPmuciLslhBH4Nx1fxlguxY1+FFHkW/y4WgmfBB13fSA3cbxhzy4RrVDwb+mN0nO4s+tNiFPMNcf4X61sYh9AsOFb4fY5b3S8kc+fuIYubl5bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I98+5n1F; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I98+5n1F"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-512ed314881so1395653e87.2
        for <linux-cifs@vger.kernel.org>; Thu, 14 Mar 2024 16:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710460052; x=1711064852; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0iVItpnFQluoBoOPkj1VI8rK2Hyc44DmMMqpPJeZdvQ=;
        b=I98+5n1FfdG2JHwzOz7op9ZGn6MM1uTufMT02Y0ZAeRjnLnfaDrKmVheCN/DPGeJ6E
         VpqgAC4kbmdolAsZ3yXWa0lFikbtT3HfaY6KjP3sPiGDc9U/Q+aGagil4UWswG2hkUMh
         ELuP5eMTa4LgYMEAHFpqPKJRcEs74Td0711O99BV2s7FAo4yi9R3L1gB/5ni0liYB1s+
         uCA+mjyNPPYYVk+VNHr4poEdUJihp+a/lD6/9KT1tovj8NQ/DipAm1GcXDgfDJYdxIOq
         Efc/Lr0JTOi65CIqIU6tFeGzJ210s/hWh8iLcGXYDG/V20iNFQKRrl/U2aI/OLuejbbf
         5CsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710460052; x=1711064852;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0iVItpnFQluoBoOPkj1VI8rK2Hyc44DmMMqpPJeZdvQ=;
        b=d+SyCm4Tmhdu3V40xIB7wG81ldBGCNAYsr5w+fX61Hw87QpMRYleC41j14V9JNiuFa
         JWf8Wt+SGtVhbMDujsBGZtzK23BZIYO1LZAl5JNxJa47o13mxeBlz1vopL739DkldL1h
         Ac1UlZbkYhh9cRME7J8bzxfKfRlVX7DyDPOY22pAMkLGqoJUN4+ZFuy/HbRUhsAGde54
         an3rPh4f98bZih1Hkp8xuftxk/n+RcVC/SLufBAPqK0NPvhSPJJoOhvVMhB0MtwwVN6I
         kytP2e2bg61PTPeSPMvovyPw7iNCT5FF6nrVljoxVrRnTeeAm3M7T+SD8ic+HD02YAMP
         Z50w==
X-Gm-Message-State: AOJu0Yy9QdN6ln9NxiXk2lyxLLyAaXHpEtGixkIb60sIPdXzTYOxUnDI
	69Fd+5s43ATzwPCxU9suExzPnprec2v9tYdl0YhrlVlQcTJGc7zlbutJkhNFR8+mLhc/V7xdOYJ
	XpruQoT1bDs+IewMFJTpbLlJsKedRHamyHK5eCA==
X-Google-Smtp-Source: AGHT+IH4RESBKugn+rIAkdAYsBYbefi0NbyPax/0WF9L+akE0KRyPIPoR6YncCL317ADLz2gDoG7H9Ul8M1HiSerLGc=
X-Received: by 2002:a19:ca07:0:b0:513:d08e:4105 with SMTP id
 a7-20020a19ca07000000b00513d08e4105mr2338455lfg.24.1710460051825; Thu, 14 Mar
 2024 16:47:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 14 Mar 2024 18:47:20 -0500
Message-ID: <CAH2r5mt7f14ro=chmg8VmjCaad1ZaFmhx91+iNgM-pBCOhq_yQ@mail.gmail.com>
Subject: testing progress
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

With the current patches in for-next including Bharath's updated
deferred close patch, I see improvements in the test runs.

I did see this warning during test generic/132 (run to Windows) in the
broad test run, but so far everything is passing for the main test
group (there are two tests to debug that fail in the azure test target
test group) that need to be debugged

Mar 14 18:03:04 fedora29 kernel: ------------[ cut here ]------------
Mar 14 18:03:04 fedora29 kernel: BUG: Dentry
00000000e744dbca{i=6000000019c6c,n=/}  still in use (2) [unmount of
cifs cifs]
Mar 14 18:03:04 fedora29 kernel: WARNING: CPU: 0 PID: 21735 at
fs/dcache.c:1524 umount_check+0xc3/0xf0
Mar 14 18:03:04 fedora29 kernel: Modules linked in: cifs ccm cmac
nls_utf8 cifs_arc4 nls_ucs2_utils cifs_md4 rpcsec_gss_krb5 auth_rpcgss
nfsv4 dns_resolver nfs lockd grace netfs nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6
ipt_REJECT nf_reject_ipv4 xt_conntrack ebtable_nat ip6table_nat
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat
iptable_mangle iptable_raw iptable_security nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 ip_set nfnetlink ebtable_filter ebtables
ip6table_filter ip6_tables iptable_filter sunrpc kvm_intel kvm
irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
sha512_ssse3 bochs drm_vram_helper sha1_ssse3 drm_ttm_helper ttm
drm_kms_helper drm floppy virtio_balloon ip_tables xfs virtio_net
crc32c_intel net_failover sha256_ssse3 virtio_blk virtio_console
failover qemu_fw_cfg [last unloaded: cifs]
Mar 14 18:03:04 fedora29 kernel: CPU: 0 PID: 21735 Comm: kworker/0:0
Not tainted 6.8.0 #1
Mar 14 18:03:04 fedora29 kernel: Hardware name: Red Hat KVM, BIOS
1.16.1-1.el9 04/01/2014
Mar 14 18:03:04 fedora29 kernel: Workqueue: deferredclose
smb2_deferred_work_close [cifs]
Mar 14 18:03:04 fedora29 kernel: RIP: 0010:umount_check+0xc3/0xf0
Mar 14 18:03:04 fedora29 kernel: Code: db 74 0d 48 8d 7b 40 e8 0b 96
f5 ff 48 8b 53 40 41 55 4d 89 f1 45 89 e0 48 89 e9 48 89 ee 48 c7 c7
80 c4 b9 b1 e8 8d 8c a6 ff <0f> 0b 58 31 c0 5b 5d 41 5c 41 5d 41 5e c3
cc cc cc cc 41 83 fc 01
Mar 14 18:03:04 fedora29 kernel: RSP: 0018:ff1100011c5879f8 EFLAGS: 00010282
Mar 14 18:03:04 fedora29 kernel: RAX: dffffc0000000000 RBX:
ff1100010e869c80 RCX: 0000000000000027
Mar 14 18:03:04 fedora29 kernel: RDX: 0000000000000027 RSI:
0000000000000004 RDI: ff110004cb0319c8
Mar 14 18:03:04 fedora29 kernel: RBP: ff11000121e43490 R08:
ffffffffb040852e R09: ffe21c0099606339
Mar 14 18:03:04 fedora29 kernel: R10: ff110004cb0319cb R11:
0000000000000001 R12: 0000000000000002
Mar 14 18:03:04 fedora29 kernel: R13: ff1100012aee2668 R14:
ffffffffc1c5c0c0 R15: ffffffffc1ba09e0
Mar 14 18:03:04 fedora29 kernel: FS:  0000000000000000(0000)
GS:ff110004cb000000(0000) knlGS:0000000000000000
Mar 14 18:03:04 fedora29 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Mar 14 18:03:04 fedora29 kernel: CR2: 00007fc34296e1f8 CR3:
00000000a4660004 CR4: 0000000000371ef0
Mar 14 18:03:04 fedora29 kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Mar 14 18:03:04 fedora29 kernel: DR3: 0000000000000000 DR6:
00000000fffe0ff0 DR7: 0000000000000400
Mar 14 18:03:04 fedora29 kernel: Call Trace:
Mar 14 18:03:04 fedora29 kernel: <TASK>
Mar 14 18:03:04 fedora29 kernel: ? __warn+0xa4/0x200
Mar 14 18:03:04 fedora29 kernel: ? umount_check+0xc3/0xf0
Mar 14 18:03:04 fedora29 kernel: ? report_bug+0x1d4/0x1e0
Mar 14 18:03:04 fedora29 kernel: ? handle_bug+0x42/0x80
Mar 14 18:03:04 fedora29 kernel: ? exc_invalid_op+0x18/0x50
Mar 14 18:03:04 fedora29 kernel: ? asm_exc_invalid_op+0x1a/0x20
Mar 14 18:03:04 fedora29 kernel: ? irq_work_claim+0x1e/0x40
Mar 14 18:03:04 fedora29 kernel: ? umount_check+0xc3/0xf0
Mar 14 18:03:04 fedora29 kernel: ? umount_check+0xc3/0xf0
Mar 14 18:03:04 fedora29 kernel: ? __pfx_umount_check+0x10/0x10
Mar 14 18:03:04 fedora29 kernel: d_walk+0x72/0x4e0
Mar 14 18:03:04 fedora29 kernel: ? d_walk+0x58/0x4e0
Mar 14 18:03:04 fedora29 kernel: shrink_dcache_for_umount+0x64/0x210
Mar 14 18:03:04 fedora29 kernel: generic_shutdown_super+0x4a/0x1c0
Mar 14 18:03:04 fedora29 kernel: kill_anon_super+0x22/0x40
Mar 14 18:03:04 fedora29 kernel: cifs_kill_sb+0x78/0x90 [cifs]
Mar 14 18:03:04 fedora29 kernel: deactivate_locked_super+0x69/0xf0
Mar 14 18:03:04 fedora29 kernel: cifsFileInfo_put_final+0x25a/0x290 [cifs]
Mar 14 18:03:04 fedora29 kernel: _cifsFileInfo_put+0x448/0x7b0 [cifs]
Mar 14 18:03:04 fedora29 kernel: ? __pfx__cifsFileInfo_put+0x10/0x10 [cifs]
Mar 14 18:03:04 fedora29 kernel: ? lock_release+0x1c7/0x390
Mar 14 18:03:04 fedora29 kernel: ? do_raw_spin_unlock+0x9c/0x100
Mar 14 18:03:04 fedora29 kernel: ? _raw_spin_unlock+0x23/0x40
Mar 14 18:03:04 fedora29 kernel: process_one_work+0x49b/0xbb0




-- 
Thanks,

Steve
