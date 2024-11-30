Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B234184F;
	Sat, 30 Nov 2024 09:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732958491; cv=none; b=uBlAEK9KBNbKttyeaSF+M/nXW1z2PR6abRrb8YkYr8ISVZjXZ6ETYAtVnmE6hHfqmkeQ+2hqu44rActnPnKTZRe57MsKcOM4FO3kNlZdCJEOClTAlRfje439hmaXK08ltiBaXDx2fFVhhC0VicWJGPB1tJztef0A/lt30f0iOvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732958491; c=relaxed/simple;
	bh=B6Kp42DdMx7o2F9q1ZZWxAakwpNvbdugbjjugcx6Ajg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RGt0mY0jTfTT758V1iIRoik8PghQ8ZRjCm03YR+UWsANKEWhYlcTxKInS2evbkFy8zHLNkmnQBMuL6jz114tFxnbuXmiYjb8wJFWoF1BiNuIACsV/6gPlVXYWXw9bCu16LjsKpNJ+Nhan2ZkKOkWVsE6BHeH7F3lk+5UXovBodo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FrRANzgx; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FrRANzgx"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-aa55da18f89so388874966b.0;
        Sat, 30 Nov 2024 01:21:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732958488; x=1733563288; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wBGn31dHy/ezVGkqd5PyJ56mr5MWJzEdxUSwMzGNmOs=;
        b=FrRANzgxIMsMsPC9V2WAf1ywxZbfJpH/y88d50I/yOx6zMp0IJd6g2n5CVdfd6tBa9
         GabrxrgLYpusqe0dQmc2T4yjzl5M+1AQJs6mQXR0dunIwwzce8rvuNE1VPIpNo0Q3XG1
         AEfXkHpmhjmvS+/8rY/LSzEoyNt3JhQjF1ZulVe4V1CPOxRrHifseFHDr5kpY6dxBVE1
         P4BER5VSsyi5CDWHX3rtMY1V5ljU7zrxKPAqTcAYhdfLlsWG9MoDRM318vtDtlr+KtyD
         cmNaSWUtks9POY2ObIJeTk7wJAlFw/wzg2i4q2BcMgFJkiTwTHGVbVCr0B1dAsATcrkn
         IH2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732958488; x=1733563288;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wBGn31dHy/ezVGkqd5PyJ56mr5MWJzEdxUSwMzGNmOs=;
        b=hbjP+R993ni0EHTEpfGRhSHdLM2UMdTHNlqdVYCu57LjmPrU031EypbMi33tIjILVB
         Zj2m1Dvi/itLzVr4pBnjoCpKqcz/+6VN4v+lIsRNzfC1dIGND6k7A/1WLihPUJ9zfBCp
         prk6y9B+Ly8PvB8MXGxgugWIWxM4AdSgxtSA+1qefTtH8JDmpJX1jnKrgQo4uI2Gu5bT
         Y6+66TJ178mZc8oGL/+2sZMQtv9HjzZ9GdvmtQORpCaG+HyxjcFM3O3foUV0NLt0JJCH
         lMox+EF95XpKHqfflCMnGSpXEndOe/Nz4M9XjLxTdzmXHuYhbhmtCi+fsIHl4PHXA3+z
         sCXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQv6a65bx6JqaKqL87n0RixfkdTluCd019wMApjIrOGm1X0UuX3lEvjJKEjqh1yVDOqmt3yD/wuksL@vger.kernel.org
X-Gm-Message-State: AOJu0Yzm+7YnjFnHrbaQkKEkQ9k6oFfKjwzwkklqTjQMZL+/nj9wURrl
	c9jFJQeHbeD0UDX9IV7EAvrTHon5eHUzAPvpA5Hpn39S3oK1OUtPhUo1XwyZ
X-Gm-Gg: ASbGncsVoFAf2IzwpI+zSJmi6gJmqj7Ie8BgzqIuHTM+TEvV97OBhwEk/AqyLE2ELMx
	Q9ZpgR+47hEfWcN+dENCJZLUvFF41PHGv2pSCt6QQzhg2FDtDTrckC/gqkc4/4dDmNIReSmwaZp
	IaK4HCP43KbABnsvTULwZv4DO4H9ntWZ4aE3d18TSBnAjnA1U9rNZ/bgi/RsIjhsL/4JLjYbENs
	YAMZwnzoW3z4IPUEmPKXEPm6zJQFx46QdP+wqhwKDhkTNNVGV98DIHlhYN7pCy8XNrJCxhQZgon
	IUvaDoRmRg==
X-Google-Smtp-Source: AGHT+IEfNkerElY5P7dfL7r2pI4qGlf/ZrmDqu682/tZx+T8mPpiQtoSwrEXrOtIzIPIRKRsEQk/hQ==
X-Received: by 2002:a17:906:318a:b0:a9a:b70:2a92 with SMTP id a640c23a62f3a-aa580f0daf7mr1173951266b.16.1732958487565;
        Sat, 30 Nov 2024 01:21:27 -0800 (PST)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa59990a825sm258686666b.153.2024.11.30.01.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Nov 2024 01:21:26 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 0FBAFBE2EE7; Sat, 30 Nov 2024 10:21:26 +0100 (CET)
Date: Sat, 30 Nov 2024 10:21:26 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: gregkh@linuxfoundation.org, Paulo Alcantara <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>, Michael <mk-debian@galax.is>
Cc: stable@vger.kernel.org, regressions@lists.linux.dev,
	linux-cifs@vger.kernel.org
Subject: backporting 24a9799aa8ef ("smb: client: fix UAF in
 smb2_reconnect_server()") to older stable series (was: Re: FAILED: patch
 "[PATCH] smb: client: fix UAF in  smb2_reconnect_server()" failed to apply
 to 6.1-stable tree)
Message-ID: <Z0rZFrZ0Cz3LJEbI@eldamar.lan>
References: <2024040834-magazine-audience-8aa4@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024040834-magazine-audience-8aa4@gregkh>

Hi Paulo, hi Steve,

On Mon, Apr 08, 2024 at 12:19:35PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 6.1-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> To reproduce the conflict and resubmit, you may use the following commands:
> 
> git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
> git checkout FETCH_HEAD
> git cherry-pick -x 24a9799aa8efecd0eb55a75e35f9d8e6400063aa
> # <resolve conflicts, build, test, etc.>
> git commit -s
> git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2024040834-magazine-audience-8aa4@gregkh' --subject-prefix 'PATCH 6.1.y' HEAD^..
> 
> Possible dependencies:
> 
> 24a9799aa8ef ("smb: client: fix UAF in smb2_reconnect_server()")
> 7257bcf3bdc7 ("cifs: cifs_chan_is_iface_active should be called with chan_lock held")
> 27e1fd343f80 ("cifs: after disabling multichannel, mark tcon for reconnect")
> fa1d0508bdd4 ("cifs: account for primary channel in the interface list")
> a6d8fb54a515 ("cifs: distribute channels across interfaces based on speed")
> c37ed2d7d098 ("smb: client: remove extra @chan_count check in __cifs_put_smb_ses()")
> ff7d80a9f271 ("cifs: fix session state transition to avoid use-after-free issue")
> 38c8a9a52082 ("smb: move client and server files to common directory fs/smb")
> 943fb67b0902 ("cifs: missing lock when updating session status")
> bc962159e8e3 ("cifs: avoid race conditions with parallel reconnects")
> 1bcd548d935a ("cifs: prevent data race in cifs_reconnect_tcon()")
> e77978de4765 ("cifs: update ip_addr for ses only for primary chan setup")
> 3c0070f54b31 ("cifs: prevent data race in smb2_reconnect()")
> 05844bd661d9 ("cifs: print last update time for interface list")
> 25cf01b7c920 ("cifs: set correct status of tcon ipc when reconnecting")
> abdb1742a312 ("cifs: get rid of mount options string parsing")
> 9fd29a5bae6e ("cifs: use fs_context for automounts")

In Debian we got a report yhsy in s CIFS (DFS) infrastructure and
after mounting at some point later but reproducible they are able to
trigger within few minutes a system hang with a trace:

CIFS: VFS: \\SOME.SERVER.FQDN cifs_put_smb_ses: Session Logoff failure rc=-11
CIFS: VFS: \\(null) cifs_put_smb_ses: Session Logoff failure rc=-11
list_del corruption, ffff966536fe7800->next is NULL
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:49!
invalid opcode: 0000 [#1] PREEMPT SMP PTI
CPU: 6 PID: 2498151 Comm: kworker/6:9 Tainted: G           OE      6.1.0-23-amd64 #1  Debian 6.1.99-1
Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 2.9.0 12/06/2019
Workqueue: events delayed_mntput
RIP: 0010:__list_del_entry_valid.cold+0xf/0x6f
Code: c7 c7 88 3c fa a0 e8 90 a0 fe ff 0f 0b 48 c7 c7 60 3c fa a0 e8 82 a0 fe ff 0f 0b 48 89 fe 48 c7 c7 70 3d fa a0 e8 71 a0 fe ff <0f> 0b 48 89 d1 48 c7 c7 90 3e fa a0 48 89 c2 e8 5d a0 fe ff 0f 0b
RSP: 0018:ffffad83a63f7dd0 EFLAGS: 00010246
RAX: 0000000000000033 RBX: ffff966536fe7800 RCX: 0000000000000027
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff965e7f8e03a0
RBP: 00000000142d66a6 R08: 0000000000000000 R09: ffffad83a63f7c68
R10: 0000000000000003 R11: ffff966ebff11be0 R12: 00000000fffffff5
R13: ffff966536fe7000 R14: ffff966536fe7020 R15: ffffffffa1770b88
FS:  0000000000000000(0000) GS:ffff965e7f8c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe35dbcb7b0 CR3: 0000000f36c10001 CR4: 00000000000606e0
Call Trace:
 <TASK>
 ? __die_body.cold+0x1a/0x1f
 ? die+0x2a/0x50
 ? do_trap+0xc5/0x110
 ? __list_del_entry_valid.cold+0xf/0x6f
 ? do_error_trap+0x6a/0x90
 ? __list_del_entry_valid.cold+0xf/0x6f
 ? exc_invalid_op+0x4c/0x60
 ? __list_del_entry_valid.cold+0xf/0x6f
 ? asm_exc_invalid_op+0x16/0x20
 ? __list_del_entry_valid.cold+0xf/0x6f
 cifs_put_smb_ses+0xbb/0x3e0 [cifs]
 mount_group_release+0x82/0xa0 [cifs]
 cifs_umount+0x88/0xa0 [cifs]
 deactivate_locked_super+0x2f/0xa0
 cleanup_mnt+0xbd/0x150
 delayed_mntput+0x28/0x40
 process_one_work+0x1c7/0x380
 worker_thread+0x4d/0x380
 ? rescuer_thread+0x3a0/0x3a0
 kthread+0xda/0x100
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x22/0x30
 </TASK>
Modules linked in: bluetooth jitterentropy_rng drbg ansi_cprng ecdh_generic rfkill ecc overlay isofs cmac nls_utf8 cifs cifs_arc4 cifs_md4 rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache netfs tls beegfs(OE) rpcrdma rdma_ucm ib_iser rdma_cm iw_cm ib_cm libiscsi scsi_transport_iscsi rdma_rxe ib_uverbs ip6_udp_tunnel udp_tunnel ib_core nft_chain_nat xt_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nft_compat nf_tables nfnetlink intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel ipmi_ssif binfmt_misc kvm irqbypass ghash_clmulni_intel sha512_ssse3 sha512_generic sha256_ssse3 sha1_ssse3 aesni_intel crypto_simd cryptd rapl dcdbas mgag200 intel_cstate joydev evdev drm_shmem_helper intel_uncore iTCO_wdt ipmi_si drm_kms_helper mei_me intel_pmc_bxt ipmi_devintf iTCO_vendor_support pcspkr i2c_algo_bit mei ipmi_msghandler watchdog sg acpi_power_meter button nfsd auth_rpcgss nfs_acl lockd grace sunrpc drm fuse loop efi_pstore configfs
 ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 dm_mod hid_generic usbhid hid sd_mod t10_pi sr_mod cdrom crc64_rocksoft crc64 crc_t10dif crct10dif_generic ahci libahci crct10dif_pclmul crct10dif_common crc32_pclmul libata ehci_pci bnx2x ehci_hcd megaraid_sas usbcore scsi_mod lpc_ich usb_common mdio libcrc32c crc32c_generic scsi_common crc32c_intel wmi
---[ end trace 0000000000000000 ]---
RIP: 0010:__list_del_entry_valid.cold+0xf/0x6f
Code: c7 c7 88 3c fa a0 e8 90 a0 fe ff 0f 0b 48 c7 c7 60 3c fa a0 e8 82 a0 fe ff 0f 0b 48 89 fe 48 c7 c7 70 3d fa a0 e8 71 a0 fe ff <0f> 0b 48 89 d1 48 c7 c7 90 3e fa a0 48 89 c2 e8 5d a0 fe ff 0f 0b
RSP: 0018:ffffad83a63f7dd0 EFLAGS: 00010246
RAX: 0000000000000033 RBX: ffff966536fe7800 RCX: 0000000000000027
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff965e7f8e03a0
RBP: 00000000142d66a6 R08: 0000000000000000 R09: ffffad83a63f7c68
R10: 0000000000000003 R11: ffff966ebff11be0 R12: 00000000fffffff5
R13: ffff966536fe7000 R14: ffff966536fe7020 R15: ffffffffa1770b88
FS:  0000000000000000(0000) GS:ffff965e7f8c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe35dbcb7b0 CR3: 0000000f36c10001 CR4: 00000000000606e0
note: kworker/6:9[2498151] exited with preempt_count 1

Michael, did a manual backport of 24a9799aa8ef ("smb: client: fix UAF
in smb2_reconnect_server()") which seems in fact to solve the issue.

Michael, can you please post your backport here for review from Paulo
and Steve?

Regards,
Salvatore
