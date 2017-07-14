From: Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [BUG] cifs crashed kernel in ltp symlink test
Date: Fri, 14 Jul 2017 18:15:02 +0800
Message-ID: <20170714101502.GN2478@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi all,

Recently I've started running LTP tests with mysymlinks mount option
against a local mounted cifs, server is local samba share. And I've seen
cifs (v2, v2.1, v3.0) crashed kernel in symlink test. But it's not
reproduced everytime.

The LTP test that triggered the crash is "fs_racer", it's defined in
ltp/runtest/fs as

fs_racer fs_racer.sh -t 5

You can run it manually:

TMPDIR=/mnt/cifs /path/to/ltp/testcases/kernel/fs/racer/fs_racer.sh -t 5

Thanks,
Eryu

[14101.487210] CIFS VFS: Close unmatched open 
[14101.487490] CIFS VFS: Close unmatched open 
[14101.487901] BUG: unable to handle kernel NULL pointer dereference at 0000000000000fe2 
[14101.487931] IP: SMB2_open+0x5bc/0xb00 [cifs] 
[14101.487931] PGD 77ffb067  
[14101.487932] P4D 77ffb067  
[14101.487933] PUD 77ffa067  
[14101.487933] PMD 0  
[14101.487934]  
[14101.487935] Oops: 0000 [#1] SMP 
[14101.487936] Modules linked in: tun ext4 jbd2 mbcache snd_seq_dummy binfmt_misc arc4 md4 nls_utf8 cifs ccm dns_resolver loop snd_hda_codec_analog snd_hda_codec_generic snd_hda_intel snd_hda_codec coretemp snd_hda_core snd_hwdep kvm_intel snd_seq kvm snd_seq_device irqbypass snd_pcm iTCO_wdt hp_wmi mei_wdt iTCO_vendor_support snd_timer gpio_ich sparse_keymap rfkill snd pcspkr ppdev sg lpc_ich soundcore mei_me tpm_infineon wmi mei parport_pc shpchp parport acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sr_mod sd_mod cdrom ata_generic pata_acpi i915 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm ata_piix e1000e libata serio_raw ptp pps_core i2c_core floppy video 
[14101.487970] CPU: 0 PID: 18211 Comm: fs_racer_file_c Not tainted 4.12.0 #1 
[14101.487971] Hardware name: Hewlett-Packard  /2820h, BIOS 786F2 v01.53 08/27/2008 
[14101.487971] task: ffffa0643441bfc0 task.stack: ffffbfbeca38c000 
[14101.487984] RIP: 0010:SMB2_open+0x5bc/0xb00 [cifs] 
[14101.487985] RSP: 0018:ffffbfbeca38fa30 EFLAGS: 00010286 
[14101.487986] RAX: ffffa06433c43c01 RBX: 0000000000000fe2 RCX: 0000000001453825 
[14101.487986] RDX: 0000000001453824 RSI: ffffa06433c42000 RDI: ffffa0647a826480 
[14101.487987] RBP: ffffbfbeca38fb38 R08: 0000000000023370 R09: ffffffff89bade47 
[14101.487988] R10: ffffa0647e223370 R11: fffff13200cf1080 R12: ffffa06475c87000 
[14101.487989] R13: 00000000fffffe00 R14: ffffbfbeca38fb50 R15: ffffbfbeca38fb58 
[14101.487990] FS:  00007eff45e8b740(0000) GS:ffffa0647e200000(0000) knlGS:0000000000000000 
[14101.487991] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[14101.487991] CR2: 0000000000000fe2 CR3: 0000000072e54000 CR4: 00000000000006f0 
[14101.487992] Call Trace: 
[14101.488005]  ? cifsConvertToUTF16+0x1bb/0x380 [cifs] 
[14101.488018]  smb2_query_symlink+0xcd/0x270 [cifs] 
[14101.488029]  ? cifs_get_link+0x2a8/0x450 [cifs] 
[14101.488040]  ? cifs_get_link+0x2a8/0x450 [cifs] 
[14101.488044]  ? kmem_cache_alloc_trace+0x16c/0x1b0 
[14101.488055]  cifs_get_link+0xeb/0x450 [cifs] 
[14101.488058]  trailing_symlink+0x1f1/0x240 
[14101.488059]  path_openat+0xe6/0x13b0 
[14101.488061]  do_filp_open+0x91/0x100 
[14101.488063]  ? __alloc_fd+0x46/0x170 
[14101.488064]  do_sys_open+0x124/0x210 
[14101.488066]  SyS_open+0x1e/0x20 
[14101.488068]  do_syscall_64+0x67/0x150 
[14101.488070]  entry_SYSCALL64_slow_path+0x25/0x25 
[14101.488071] RIP: 0033:0x7eff455705a0 
[14101.488072] RSP: 002b:00007ffcbc19f9c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002 
[14101.488073] RAX: ffffffffffffffda RBX: 00000000023129a0 RCX: 00007eff455705a0 
[14101.488074] RDX: 00000000000001b6 RSI: 0000000000000441 RDI: 0000000002312080 
[14101.488075] RBP: 00007ffcbc19fa50 R08: 0000000000000020 R09: 0000000002312080 
[14101.488075] R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000000003 
[14101.488076] R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000000 
[14101.488077] Code: 7c 24 78 41 89 c5 e8 44 56 fe ff 45 85 ed 48 8b 9c 24 80 00 00 00 74 62 f0 41 ff 84 24 d0 05 00 00 4c 8b 74 24 48 4d 85 f6 74 1d <8b> 03 ba c0 00 40 01 48 89 df 0f c8 25 ff ff ff 00 48 8d 70 04  
[14101.488104] RIP: SMB2_open+0x5bc/0xb00 [cifs] RSP: ffffbfbeca38fa30 
[14101.488105] CR2: 0000000000000fe2 
[14101.488121] ---[ end trace 03e3a46b45d88003 ]--- 
[14101.488122] Kernel panic - not syncing: Fatal exception 
[14101.491292] Kernel Offset: 0x8a00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff) 
[14101.826884] ---[ end Kernel panic - not syncing: Fatal exception 
