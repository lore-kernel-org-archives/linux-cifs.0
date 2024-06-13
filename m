Received: from eproxy.izw-berlin.de (eproxy.izw-berlin.de [62.141.164.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F053213D60A
	for <linux-cifs@vger.kernel.org>; Thu, 13 Jun 2024 08:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.141.164.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718268992; cv=none; b=NDDslV7gMNdjwS0GQnwAP1lQa5Efry0oyIjgc7C4w8CBGfGMhCC4WJvMy5rJGh+tsqB3iVx2rGuc1RiSeIcxCoEsy7OK6YvQ1DX5/yuR3TH+TrrYDBv6weFcf9aatmLa8P0nB89uu6EfKUP4ZmaHiqiHEdU2P9nJ1JtGhoIQmSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718268992; c=relaxed/simple;
	bh=mgyN9UBu23+689Oo+s44hCAf7pV1cezAttHT6cBns7I=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=QXmR8lIHa13l/lYQ0cCgTSWEzM0Imm0ozETy9PSUxlPXXH5gv1BUheVy4r7GAnCg7Q3Wk7I7WRzUy3OiwdWX/3uFOOChhTlhWbYWKAbuABqygn/J8umgeUM6gusmQ74+9TZESwmIeA1U0K2XTTDWVeSQqkPFcuxnUimzJjg39HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=izw-berlin.de; spf=pass smtp.mailfrom=izw-berlin.de; dkim=pass (1024-bit key) header.d=izw-berlin.de header.i=@izw-berlin.de header.b=sDdSRllX; arc=none smtp.client-ip=62.141.164.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=izw-berlin.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=izw-berlin.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=izw-berlin.de header.i=@izw-berlin.de header.b="sDdSRllX"
Received: from izw-mail-3.izw-berlin.local ([192.168.2.11]) by eproxy.izw-berlin.de over TLS secured channel with Microsoft SMTPSVC(10.0.14393.4169);
	 Thu, 13 Jun 2024 10:56:27 +0200
DKIM-Signature: v=1; a=rsa-sha256; d=izw-berlin.de; s=p2024; c=simple/simple;
	t=1718268987; h=from:subject:to:date:message-id;
	bh=mgyN9UBu23+689Oo+s44hCAf7pV1cezAttHT6cBns7I=;
	b=sDdSRllXoA8B5QOWeIofSgiEUI9orLhtPcL6OphGfst0SzD6AMUSxaZq/gSkkyHVVMVcaQKhLIm
	ZC0OtaCOTC13YN6fNxyYVuvAc80WJPRGGsQEnARkSiubcZYbva54GTZBmiyF5LWgyA5zLB/VeoXdd
	w21shukgnA0NUYMIr+Q=
Received: from izw-mail-3.izw-berlin.local (192.168.2.11) by
 izw-mail-3.izw-berlin.local (192.168.2.11) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 13 Jun 2024 10:56:27 +0200
Received: from izw-mail-3.izw-berlin.local ([192.168.2.11]) by
 izw-mail-3.izw-berlin.local ([192.168.2.11]) with mapi id 15.01.2507.039;
 Thu, 13 Jun 2024 10:56:27 +0200
From: "Heckmann, Ilja" <heckmann@izw-berlin.de>
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Crash when attempting to run executables from a share
Thread-Topic: Crash when attempting to run executables from a share
Thread-Index: AQHavW8Ky8Tb0XLDMU+8so5wDYPmrA==
Date: Thu, 13 Jun 2024 08:56:27 +0000
Message-ID: <55a38b4f4da449bb9da403d4f58847c5@izw-berlin.de>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginalArrivalTime: 13 Jun 2024 08:56:27.0730 (UTC) FILETIME=[93AA9320:01DABD6F]

With certain combinations of settings both on the server and the client, tr=
ying
to run an executable from a Samba share results in a crash (I pasted an exa=
mple
from the journal at the end). To reproduce it, try to run any executable fr=
om a
mounted share, e.g. even an empty Bash script will do:

$ echo '#!/bin/bash' > /mnt/share/test.sh
$ chmod +x /mnt/share/test.sh
$ /mnt/share/test.sh
exec: Failed to execute process '/mnt/smbt/test.sh', unknown error number 5

Software versions:
- Client: Fedora 39, ("Linux server 6.6.9-200.fc39.x86_64"), although I alr=
eady
  noticed this problem about a year ago.
- Server: CentOS 7.9.2009 with Samba 4.10.16, AlmaLinux 8.10 with Samba 4.1=
9.4

The options that seem to be related are the value of "cache" on the client =
and
whether "oplocks" are on or off on the server. These are the results of tes=
ting
different combinations:

- When mounting with "cache=3Dloose", the problem never occurs, regardless =
of the
  value of "oplocks" in the smb.conf
- With "cache=3Dnone", the crash always happens, no matter the value of "op=
locks"
- But when mounting with "cache=3Dstrict" (or without specifying the option=
 at
  all), the crash occurs with "oplocks =3D yes", and doesn't with "oplocks =
=3D no"

For completeness, this is how the share is mounted in fstab:

//remote/share  /mnt/share  smb3  _netdev,noauto,multiuser,mfsymlinks,sec=
=3Dkrb5,user=3D$user,domain=3D$domain,x-systemd.automount  0 0


This is what the smb.conf looks like, without the (hopefully) irrelevant
domain membership and printing settings:
---------------------------------
[global]
case sensitive =3D yes
delete readonly =3D yes
map acl inherit =3D yes
vfs objects =3D acl_xattr
oplocks =3D no
level2 oplocks =3D no
min protocol =3D SMB2

[share]
path =3D /data/share
read only =3D no
acl_xattr:ignore system acl =3D yes
---------------------------------


And here is a crash record from the journal:
---------------------------------------------------------------------------=
-----
Jun 13 10:08:13 server kernel: ------------[ cut here ]------------
Jun 13 10:08:13 server kernel: WARNING: CPU: 121 PID: 3906695 at fs/smb/cli=
ent/file.c:3341 cifs_limit_bvec_su bset.constprop.0+0xf2/0x130 [cifs]
Jun 13 10:08:13 server kernel: Modules linked in: ib_core nls_utf8 cifs cif=
s_arc4 nls_ucs2_utils cifs_md4 dns _resolver fscache netfs nf_conntrack_net=
link nfnetlink_acct wireguard curve25519_x86_64 libcurve25519_generic ip6_u=
dp_tunnel udp _tunnel cfg80211 binfmt_misc nft_fib_inet nft_fib_ipv4 nft_fi=
b_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_re ject nf=
t_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set=
 nf_tables nfnetlink qrtr vfat fat intel_rapl_msr intel_rapl_common amd64_e=
dac edac_mce_amd dell_wmi ledtrig_audio kvm_amd sparse_keymap rfkill ipmi_s=
sif video kvm irqbypass dell_smbios dcdbas rapl dell_wmi_descriptor wmi_bmo=
f acpi_cpufreq pcspkr acpi_ipmi ipmi_si ptdma ipmi_devintf i2c_piix4 k10tem=
p ipmi_msghandler acpi_power_meter auth_rpcgss sunrpc fuse loop zram xfs cr=
ct10dif_pclmul crc32_pclmul qede crc32c_intel polyval_c lmulni polyval_gene=
ric ghash_clmulni_intel qed sha512_ssse3 sha256_ssse3 sha1_ssse3 tg3 mgag20=
0 megaraid_sas i2c_algo_bit ccp cr c8 sp5100_tco wmi scsi_dh_rdac scsi_dh_e=
mc
Jun 13 10:08:13 server kernel:  scsi_dh_alua dm_multipath
Jun 13 10:08:13 server kernel: CPU: 121 PID: 3906695 Comm: fish Tainted: G =
       W          6.6.9-200.fc39.x86_64 #1
Jun 13 10:08:13 server kernel: Hardware name: Dell Inc. PowerEdge R7525/059=
0KW, BIOS 2.12.4 07/26/2023
Jun 13 10:08:13 server kernel: RIP: 0010:cifs_limit_bvec_subset.constprop.0=
+0xf2/0x130 [cifs]
Jun 13 10:08:13 server kernel: Code: 41 8b 44 01 08 49 0f 46 db 48 39 d8 48=
 0f 47 c3 83 c7 01 83 c2 01 48 01 c1 48 29 c6 75 c4 41 89 3a 48 89 c8 5b e9=
 ae a8 2a c3 <0f> 0b 31 c9 48 89 c8 e9 a2 a8 2a c3 31 c9 31 ff 41 89 3a 48 =
89 c8
Jun 13 10:08:13 server kernel: RSP: 0018:ffffc90056d0bcc0 EFLAGS: 00010297
Jun 13 10:08:13 server kernel: RAX: ffff88c08373ab98 RBX: ffff88c08373ab40 =
RCX: 0000000000000100
Jun 13 10:08:13 server kernel: RDX: ffffc90056d0bd0c RSI: 0000000000000100 =
RDI: ffff88c08373ab98
Jun 13 10:08:13 server kernel: RBP: ffff88ab5ead6800 R08: 0000000000000001 =
R09: 0000000000000040
Jun 13 10:08:13 server kernel: R10: ffff88c08373ab40 R11: 0000000000000001 =
R12: ffff88e42e0c2400
Jun 13 10:08:13 server kernel: R13: 0000000000000100 R14: ffff88c0d3eade00 =
R15: 0000000000000000
Jun 13 10:08:13 server kernel: FS:  00007f475f6e4740(0000) GS:ffff88caffd40=
000(0000) knlGS:0000000000000000
Jun 13 10:08:13 server kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000800=
50033
Jun 13 10:08:13 server kernel: CR2: 00005572688872a0 CR3: 00000015eb622000 =
CR4: 0000000000350ee0
Jun 13 10:08:13 server kernel: Call Trace:
Jun 13 10:08:13 server kernel:  <TASK>
Jun 13 10:08:13 server kernel:  ? cifs_limit_bvec_subset.constprop.0+0xf2/0=
x130 [cifs]
Jun 13 10:08:13 server kernel:  ? __warn+0x81/0x130
Jun 13 10:08:13 server kernel:  ? cifs_limit_bvec_subset.constprop.0+0xf2/0=
x130 [cifs]
Jun 13 10:08:13 server kernel:  ? report_bug+0x171/0x1a0
Jun 13 10:08:13 server kernel:  ? handle_bug+0x3c/0x80
Jun 13 10:08:13 server kernel:  ? exc_invalid_op+0x17/0x70
Jun 13 10:08:13 server kernel:  ? asm_exc_invalid_op+0x1a/0x20
Jun 13 10:08:13 server kernel:  ? cifs_limit_bvec_subset.constprop.0+0xf2/0=
x130 [cifs]
Jun 13 10:08:13 server kernel:  cifs_send_async_read+0x12a/0x530 [cifs]
Jun 13 10:08:13 server kernel:  __cifs_readv+0x244/0x440 [cifs]
Jun 13 10:08:13 server kernel:  __kernel_read+0x137/0x2e0
Jun 13 10:08:13 server kernel:  bprm_execve+0x225/0x650
Jun 13 10:08:13 server kernel:  do_execveat_common.isra.0+0x1ad/0x250
Jun 13 10:08:13 server kernel:  __x64_sys_execve+0x36/0x40
Jun 13 10:08:13 server kernel:  do_syscall_64+0x60/0x90
Jun 13 10:08:13 server kernel:  ? srso_return_thunk+0x5/0x10
Jun 13 10:08:13 server kernel:  ? exc_page_fault+0x7f/0x180
Jun 13 10:08:13 server kernel:  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
Jun 13 10:08:13 server kernel: RIP: 0033:0x7f475f21b52b
Jun 13 10:08:13 server kernel: Code: 0f 1e fa 48 8b 05 ad 9a 0f 00 48 8b 10=
 e9 0d 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 f3 0f 1e fa b8 3b 00=
 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d d5 98 0f 00 f7 d8 64 89 =
01 48
Jun 13 10:08:13 server kernel: RSP: 002b:00007ffea9484b68 EFLAGS: 00000246 =
ORIG_RAX: 000000000000003b
Jun 13 10:08:13 server kernel: RAX: ffffffffffffffda RBX: 00005572691924c0 =
RCX: 00007f475f21b52b
Jun 13 10:08:13 server kernel: RDX: 000055726917d720 RSI: 00005572691924c0 =
RDI: 000055726918c490
Jun 13 10:08:13 server kernel: RBP: 00007ffea9484fd0 R08: 0000000000000000 =
R09: 00007f475f6e4740
Jun 13 10:08:13 server kernel: R10: 0000000000000008 R11: 0000000000000246 =
R12: 000055726917d720
Jun 13 10:08:13 server kernel: R13: 0000000000000000 R14: 0000000000000000 =
R15: 000055726918c490
Jun 13 10:08:13 server kernel:  </TASK>
Jun 13 10:08:13 server kernel: ---[ end trace 0000000000000000 ]---
Jun 13 10:08:14 server abrt-dump-journal-oops[3580]: abrt-dump-journal-oops=
: Found oopses: 1
Jun 13 10:08:14 server abrt-dump-journal-oops[3580]: abrt-dump-journal-oops=
: Creating problem directories
Jun 13 10:08:14 server abrt-server[3906703]: Deleting problem directory oop=
s-2024-06-13-10:08:14-3580-0 (dup of oops-2023-09-26-08:23:20-3349-0)
Jun 13 10:08:14 server abrt-notification[3906710]: System encountered a non=
-fatal error in cifs_limit_bvec_subset()
Jun 13 10:08:15 server abrt-dump-journal-oops[3580]: Reported 1 kernel oops=
es to Abrt
