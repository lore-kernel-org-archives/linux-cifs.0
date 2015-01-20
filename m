From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [BUG REPORT] BUG: soft lockup - CPU#1 stuck for 23s! [mount.cifs:17511]
Date: Mon, 19 Jan 2015 20:50:07 -0600
Message-ID: <CAH2r5mt4nNTUpBZgq2xR5hgEYYvOqDpigTfVuHprW2rRj8hjTA@mail.gmail.com>
References: <6D317A699782EA4DB9A0E6266C92196969F6280B@SZXEMA501-MBS.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Xuzhichuang <xuzhichuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6D317A699782EA4DB9A0E6266C92196969F6280B-tJwL4pWccCbVoO+7gWNeMAK1hpo4iccwjNknBlVQO8k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jan 19, 2015 at 6:05 AM, Xuzhichuang <xuzhichuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> w=
rote:
> Hi, all
>
> Description of problem:
>
> Our system has two cpus and 3072MB memory, when we mounting cifs file=
system concurrently(total six mount.cifs processes), cpu0 and cpu1 are =
all stuck! It=E2=80=99s always easy to reproduce this bug.
>
> Linux kernel version: 3.0.58
> cifs module version: 1.74
>
> messages:
>
> [49294.720520] CIFS VFS: default security mechanism requested.  The d=
efault security mechanism will be upgraded from ntlm to ntlmv2 in kerne=
l release 3.1
> [49294.977650] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49294.978272] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49294.980141] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49294.988143] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49294.988341] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49294.988645] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.000729] CIFS VFS: cifs_mount failed w/return code =3D -13
> [49295.007294] CIFS VFS: Send error in SessSetup =3D -11
> [49295.007309] CIFS VFS: Send error in SessSetup =3D -11
> [49295.007319] CIFS VFS: Send error in SessSetup =3D -11
> [49295.007434] CIFS VFS: Send error in SessSetup =3D -11
> [49295.007443] CIFS VFS: Send error in SessSetup =3D -11
> [49295.007556] CIFS VFS: Send error in SessSetup =3D -11
> [49295.007564] CIFS VFS: Send error in SessSetup =3D -11
> [49295.007677] CIFS VFS: Send error in SessSetup =3D -11
> [49295.007686] CIFS VFS: Send error in SessSetup =3D -11
> [49295.007799] CIFS VFS: Send error in SessSetup =3D -11
> [49295.007808] CIFS VFS: Send error in SessSetup =3D -11
> [49295.007920] CIFS VFS: Send error in SessSetup =3D -11
> [49295.007944] CIFS VFS: Send error in SessSetup =3D -11
> [49295.008042] CIFS VFS: Send error in SessSetup =3D -11
> [49295.008066] CIFS VFS: Send error in SessSetup =3D -11
> [49295.008164] CIFS VFS: Send error in SessSetup =3D -11
> [49295.008189] CIFS VFS: Send error in SessSetup =3D -11
> [49295.008286] CIFS VFS: Send error in SessSetup =3D -11
> [49295.008310] CIFS VFS: Send error in SessSetup =3D -11
> [49295.008407] CIFS VFS: Send error in SessSetup =3D -11
> [49295.008432] CIFS VFS: Send error in SessSetup =3D -11
> [49295.008529] CIFS VFS: Send error in SessSetup =3D -11
> [49295.008553] CIFS VFS: Send error in SessSetup =3D -11
> [49295.008651] CIFS VFS: Send error in SessSetup =3D -11
> [49295.008675] CIFS VFS: Send error in SessSetup =3D -11
> [49295.008773] CIFS VFS: Send error in SessSetup =3D -11
> [49295.008797] CIFS VFS: Send error in SessSetup =3D -11
> [49295.008901] CIFS VFS: Send error in SessSetup =3D -11
> [49295.008947] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.009022] CIFS VFS: Send error in SessSetup =3D -11
> [49295.009143] CIFS VFS: Send error in SessSetup =3D -11
> [49295.009267] CIFS VFS: Send error in SessSetup =3D -11
> [49295.009315] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.010219] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.011357] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.014757] CIFS VFS: cifs_mount failed w/return code =3D -112
> [49295.016148] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.016495] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.016564] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.016928] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.017292] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.017369] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.017717] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.018051] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.018396] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.018737] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.019075] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.019406] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.019766] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.020113] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.020450] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.020799] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.021166] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.021502] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.028924] CIFS VFS: cifs_mount failed w/return code =3D -112
> [49295.029464] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.029965] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.030402] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.030851] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.031293] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.031651] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.032029] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.032406] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.032744] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.033385] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.033821] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.036267] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.036369] CIFS VFS: cifs_mount failed w/return code =3D -11
> [49295.097896] CIFS VFS: Send error in QFSAttributeInfo =3D -11
> [49295.106393] CIFS VFS: Send error in QFSAttributeInfo =3D -6
> [49320.116054] BUG: soft lockup - CPU#0 stuck for 22s! [mount.cifs:17=
452]
> [49320.116056] Modules linked in: des_generic ecb md4 md5 nls_utf8 ci=
fs(X) ip6table_filter ip6_tables pciback xencow(N) vni_notify vhost_net=
 macvtap macvlan tun netbk blkbk blktap2 blktap domctl blkback_pagemap =
gntdev evtchn ipmi_devintf dm_multipath ocfs2_dlmfs(N) ocfs2_stack_o2cb=
(N) ocfs2_dlm(N) ocfs2_nodemanager(N) ipmi_si ocfs2_stackglue(N) iscsi_=
tcp libiscsi_tcp libiscsi configfs scsi_transport_iscsi af_packet iptab=
le_filter ip_tables x_tables nfnetlink_queue nfnetlink kbox(PN) brcompa=
t(N) openvswitch(N) ipmi_msghandler xen_scsibk xenbus_be vhba(N) nf_con=
ntrack_tftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 loop dm_mod a=
ta_generic ipv6 ipv6_lib ata_piix ahci libahci rtc_cmos serio_raw tg3 8=
250_pnp i7core_edac iTCO_wdt button pcspkr iTCO_vendor_support i2c_i801=
 libata i2c_core sg edac_core shpchp pci_hotplug 8250 serial_core ext3 =
jbd mbcache usbhid hid uhci_hcd sd_mod crc_t10dif ehci_hcd usbcore usb_=
common processor thermal_sys hwmon scsi_dh_alua scsi_dh_rdac scsi_dh_hp=
_sw scsi_dh_emc scsi_dh xenblk cdrom xennet mptsas mptscsih mptbase scs=
i_transport_sas scsi_mod
> [49320.116116] Supported: Yes, External
> [49320.116117] CPU 0
> [49320.116118] Modules linked in: des_generic ecb md4 md5 nls_utf8 ci=
fs(X) ip6table_filter ip6_tables pciback xencow(N) vni_notify vhost_net=
 macvtap macvlan tun netbk blkbk blktap2 blktap domctl blkback_pagemap =
gntdev evtchn ipmi_devintf dm_multipath ocfs2_dlmfs(N) ocfs2_stack_o2cb=
(N) ocfs2_dlm(N) ocfs2_nodemanager(N) ipmi_si ocfs2_stackglue(N) iscsi_=
tcp libiscsi_tcp libiscsi configfs scsi_transport_iscsi af_packet iptab=
le_filter ip_tables x_tables nfnetlink_queue nfnetlink kbox(PN) brcompa=
t(N) openvswitch(N) ipmi_msghandler xen_scsibk xenbus_be vhba(N) nf_con=
ntrack_tftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 loop dm_mod a=
ta_generic ipv6 ipv6_lib ata_piix ahci libahci rtc_cmos serio_raw tg3 8=
250_pnp i7core_edac iTCO_wdt button pcspkr iTCO_vendor_support i2c_i801=
 libata i2c_core sg edac_core shpchp pci_hotplug 8250 serial_core ext3 =
jbd mbcache usbhid hid uhci_hcd sd_mod crc_t10dif ehci_hcd usbcore usb_=
common processor thermal_sys hwmon scsi_dh_alua scsi_dh_rdac scsi_dh_hp=
_sw scsi_dh_emc scsi_dh xenblk cdrom xennet mptsas mptscsih mptbase scs=
i_transport_sas scsi_mod
> [49320.116166] Supported: Yes, External
> [49320.116167]
> [49320.116169] Pid: 17452, comm: mount.cifs Tainted: P        W  NX 3=
=2E0.58-0.6.6-xen #1 Huawei Technologies Co., Ltd. Tecal BH620         =
  /BC01NTSA
> [49320.116174] RIP: e030:[<ffffffffa0911b5a>]  [<ffffffffa0911b5a>] c=
ifs_strtoUCS+0x5a/0xc0 [cifs]
> [49320.116185] RSP: e02b:ffff8800a3bc3bc8  EFLAGS: 00000286
> [49320.116187] RAX: 0000000000000001 RBX: 0000000000000002 RCX: 00000=
0000000002e
> [49320.116189] RDX: 000000000000002e RSI: 0000000000000ffe RDI: ffff8=
800b003ad83
> [49320.116191] RBP: 0000000000000ffe R08: ffffffff804356c0 R09: 00000=
0000000002e
> [49320.116193] R10: 0000000000007f00 R11: 0000000000000001 R12: ffff8=
800b003ad83
> [49320.116194] R13: ffffffffa0943000 R14: ffff88008614848a R15: ffff8=
800a3bc3bde
> [49320.116201] FS:  00007fa44207b700(0000) GS:ffff8800bcc00000(0000) =
knlGS:0000000000000000
> [49320.116203] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> [49320.116205] CR2: 00007f60bc663000 CR3: 00000000a3bbf000 CR4: 00000=
00000002660
> [49320.116207] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> [49320.116209] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000=
00000000400
> [49320.116211] Process mount.cifs (pid: 17452, threadinfo ffff8800a3b=
c2000, task ffff8800a3b48140)
> [49320.116213] Stack:
> [49320.116226]  ffff8800a3bc3c08 ffffffff800307c3 002e8800b11f7198 ff=
ff880086148440
> [49320.116229]  ffff8800b1065e00 0000000000001000 ffff8800b003ad81 ff=
ff88008614848a
> [49320.116232]  ffffffffa0943000 ffffffffa0911d0a ffff8800a3bc3c90 43=
bd43bda08eeb6b
> [49320.116235] Call Trace:
> [49320.116271]  [<ffffffffa0911d0a>] cifsConvertToUCS+0x14a/0x170 [ci=
fs]
> [49320.116290]  [<ffffffffa08f6473>] CIFSGetDFSRefer+0x123/0x380 [cif=
s]
> [49320.116300]  [<ffffffffa08fd22f>] expand_dfs_referral+0x8f/0x1c0 [=
cifs]
> [49320.116312]  [<ffffffffa08ffb8b>] cifs_mount+0x30b/0x600 [cifs]
> [49320.116324]  [<ffffffffa08ee20e>] cifs_do_mount+0xde/0x260 [cifs]
> [49320.116332]  [<ffffffff8012b6fe>] mount_fs+0x4e/0x1a0
> [49320.116339]  [<ffffffff80147765>] vfs_kern_mount+0x65/0xd0
> [49320.116344]  [<ffffffff80148333>] do_kern_mount+0x53/0x110
> [49320.116348]  [<ffffffff8014a3fd>] do_mount+0x21d/0x260
> [49320.116352]  [<ffffffff8014a500>] sys_mount+0xc0/0xf0
> [49320.116359]  [<ffffffff80401ef3>] system_call_fastpath+0x16/0x1b
> [49320.116366]  [<00007fa4417c17aa>] 0x7fa4417c17a9
> [49320.116367] Code: 90 0f b7 44 24 16 48 63 d3 83 c3 01 29 cd 66 41 =
89 04 56 74 3c 49 01 f4 41 80 3c 24 00 74 32 89 ee 4c 89 fa 4c 89 e7 41=
 ff 55 18
> 85>[49320.116396]  c0 89 c1 48 63 f0 7f cd 8b 05 97 d4 01 00 85 c0 75=
 37 66 c7
> [49320.116404] Call Trace:
> [49320.116453]  [<ffffffffa0911d0a>] cifsConvertToUCS+0x14a/0x170 [ci=
fs]
> [49320.116471]  [<ffffffffa08f6473>] CIFSGetDFSRefer+0x123/0x380 [cif=
s]
> [49320.116481]  [<ffffffffa08fd22f>] expand_dfs_referral+0x8f/0x1c0 [=
cifs]
> [49320.116493]  [<ffffffffa08ffb8b>] cifs_mount+0x30b/0x600 [cifs]
> [49320.116505]  [<ffffffffa08ee20e>] cifs_do_mount+0xde/0x260 [cifs]
> [49320.116509]  [<ffffffff8012b6fe>] mount_fs+0x4e/0x1a0
> [49320.116513]  [<ffffffff80147765>] vfs_kern_mount+0x65/0xd0
> [49320.116516]  [<ffffffff80148333>] do_kern_mount+0x53/0x110
> [49320.116519]  [<ffffffff8014a3fd>] do_mount+0x21d/0x260
> [49320.116523]  [<ffffffff8014a500>] sys_mount+0xc0/0xf0
> [49320.116526]  [<ffffffff80401ef3>] system_call_fastpath+0x16/0x1b
> [49320.116531]  [<00007fa4417c17aa>] 0x7fa4417c17a9
> [49320.144061] BUG: soft lockup - CPU#1 stuck for 22s! [mount.cifs:17=
511]
> [49320.144063] Modules linked in: des_generic ecb md4 md5 nls_utf8 ci=
fs(X) ip6table_filter ip6_tables pciback xencow(N) vni_notify vhost_net=
 macvtap macvlan tun netbk blkbk blktap2 blktap domctl blkback_pagemap =
gntdev evtchn ipmi_devintf dm_multipath ocfs2_dlmfs(N) ocfs2_stack_o2cb=
(N) ocfs2_dlm(N) ocfs2_nodemanager(N) ipmi_si ocfs2_stackglue(N) iscsi_=
tcp libiscsi_tcp libiscsi configfs scsi_transport_iscsi af_packet iptab=
le_filter ip_tables x_tables nfnetlink_queue nfnetlink kbox(PN) brcompa=
t(N) openvswitch(N) ipmi_msghandler xen_scsibk xenbus_be vhba(N) nf_con=
ntrack_tftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 loop dm_mod a=
ta_generic ipv6 ipv6_lib ata_piix ahci libahci rtc_cmos serio_raw tg3 8=
250_pnp i7core_edac iTCO_wdt button pcspkr iTCO_vendor_support i2c_i801=
 libata i2c_core sg edac_core shpchp pci_hotplug 8250 serial_core ext3 =
jbd mbcache usbhid hid uhci_hcd sd_mod crc_t10dif ehci_hcd usbcore usb_=
common processor thermal_sys hwmon scsi_dh_alua scsi_dh_rdac scsi_dh_hp=
_sw scsi_dh_emc scsi_dh xenblk cdrom xennet mptsas mptscsih mptbase scs=
i_transport_sas scsi_mod
> [49320.144114] Supported: Yes, External
> [49320.144115] CPU 1
> [49320.144116] Modules linked in: des_generic ecb md4 md5 nls_utf8 ci=
fs(X) ip6table_filter ip6_tables pciback xencow(N) vni_notify vhost_net=
 macvtap macvlan tun netbk blkbk blktap2 blktap domctl blkback_pagemap =
gntdev evtchn ipmi_devintf dm_multipath ocfs2_dlmfs(N) ocfs2_stack_o2cb=
(N) ocfs2_dlm(N) ocfs2_nodemanager(N) ipmi_si ocfs2_stackglue(N) iscsi_=
tcp libiscsi_tcp libiscsi configfs scsi_transport_iscsi af_packet iptab=
le_filter ip_tables x_tables nfnetlink_queue nfnetlink kbox(PN) brcompa=
t(N) openvswitch(N) ipmi_msghandler xen_scsibk xenbus_be vhba(N) nf_con=
ntrack_tftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 loop dm_mod a=
ta_generic ipv6 ipv6_lib ata_piix ahci libahci rtc_cmos serio_raw tg3 8=
250_pnp i7core_edac iTCO_wdt button pcspkr iTCO_vendor_support i2c_i801=
 libata i2c_core sg edac_core shpchp pci_hotplug 8250 serial_core ext3 =
jbd mbcache usbhid hid uhci_hcd sd_mod crc_t10dif ehci_hcd usbcore usb_=
common processor thermal_sys hwmon scsi_dh_alua scsi_dh_rdac scsi_dh_hp=
_sw scsi_dh_emc scsi_dh xenblk cdrom xennet mptsas mptscsih mptbase scs=
i_transport_sas scsi_mod
> [49320.144163] Supported: Yes, External
> [49320.144164]
> [49320.144166] Pid: 17511, comm: mount.cifs Tainted: P        W  NX 3=
=2E0.58-0.6.6-xen #1 Huawei Technologies Co., Ltd. Tecal BH620         =
  /BC01NTSA
> [49320.144170] RIP: e030:[<ffffffffa090e2e8>]  [<ffffffffa090e2e8>] c=
ifs_buf_get+0x48/0x60 [cifs]
> [49320.144179] RSP: e02b:ffff8800a3b97c18  EFLAGS: 00000202
> [49320.144181] RAX: ffff880086280ac0 RBX: 0000000000000000 RCX: 00000=
00000000003
> [49320.144183] RDX: 0000000000000000 RSI: 0000000000011200 RDI: ffff8=
800860aa040
> [49320.144185] RBP: 0000000000000000 R08: ffff8800a3b97c88 R09: 00000=
00000000000
> [49320.144186] R10: 0000000000007f00 R11: ffffffff800db420 R12: 00000=
00000000032
> [49320.144188] R13: ffff8800a3b97c88 R14: ffff8800a3b97c90 R15: 00000=
0000000000f
> [49320.144194] FS:  00007f1da6763700(0000) GS:ffff8800bcd00000(0000) =
knlGS:0000000000000000
> [49320.144196] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> [49320.144198] CR2: 00007f60bc663000 CR3: 0000000086228000 CR4: 00000=
00000002660
> [49320.144200] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> [49320.144202] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000=
00000000400
> [49320.144204] Process mount.cifs (pid: 17511, threadinfo ffff8800a3b=
96000, task ffff8800a3b94740)
> [49320.144206] Stack:
> [49320.144217]  000000000000000f ffffffffa08eeb45 ffff8800afb1e800 00=
000000fffffff5
> [49320.144220]  ffff8800afb1e800 ffff8800ac2cbce1 000000000000001a ff=
ffffffa0943000
> [49320.144223]  ffff8800a3b97c88 ffffffffa08f63d9 ffffffffa0943000 ff=
ff8800a3b97d1c
> [49320.144226] Call Trace:
> [49320.144247]  [<ffffffffa08eeb45>] smb_init+0x75/0xc0 [cifs]
> [49320.144255]  [<ffffffffa08f63d9>] CIFSGetDFSRefer+0x89/0x380 [cifs=
]
> [49320.144265]  [<ffffffffa08fd22f>] expand_dfs_referral+0x8f/0x1c0 [=
cifs]
> [49320.144277]  [<ffffffffa08ffb8b>] cifs_mount+0x30b/0x600 [cifs]
> [49320.144289]  [<ffffffffa08ee20e>] cifs_do_mount+0xde/0x260 [cifs]
> [49320.144294]  [<ffffffff8012b6fe>] mount_fs+0x4e/0x1a0
> [49320.144299]  [<ffffffff80147765>] vfs_kern_mount+0x65/0xd0
> [49320.144302]  [<ffffffff80148333>] do_kern_mount+0x53/0x110
> [49320.144306]  [<ffffffff8014a3fd>] do_mount+0x21d/0x260
> [49320.144309]  [<ffffffff8014a500>] sys_mount+0xc0/0xf0
> [49320.144313]  [<ffffffff80401ef3>] system_call_fastpath+0x16/0x1b
> [49320.144319]  [<00007f1da5ea97aa>] 0x7f1da5ea97a9
> [49320.144320] Code: 00 00 00 00 48 c7 40 08 00 00 00 00 48 c7 40 10 =
00 00 00 00 48 c7 40 18 00 00 00 00 48 c7 40 20 00 00 00 00 f0 ff 05 e0=
 17 02 00 <f0> ff 05 dd 17 02 00 48 83 c4 08 c3 66 66 66 2e 0f 1f 84 00=
 00
> [49320.144361] Call Trace:
> [49320.144377]  [<ffffffffa08eeb45>] smb_init+0x75/0xc0 [cifs]
> [49320.144384]  [<ffffffffa08f63d9>] CIFSGetDFSRefer+0x89/0x380 [cifs=
]
> [49320.144394]  [<ffffffffa08fd22f>] expand_dfs_referral+0x8f/0x1c0 [=
cifs]
> [49320.144407]  [<ffffffffa08ffb8b>] cifs_mount+0x30b/0x600 [cifs]
> [49320.144418]  [<ffffffffa08ee20e>] cifs_do_mount+0xde/0x260 [cifs]
> [49320.144423]  [<ffffffff8012b6fe>] mount_fs+0x4e/0x1a0
> [49320.144426]  [<ffffffff80147765>] vfs_kern_mount+0x65/0xd0
> [49320.144430]  [<ffffffff80148333>] do_kern_mount+0x53/0x110
> [49320.144433]  [<ffffffff8014a3fd>] do_mount+0x21d/0x260
> [49320.144436]  [<ffffffff8014a500>] sys_mount+0xc0/0xf0
> [49320.144440]  [<ffffffff80401ef3>] system_call_fastpath+0x16/0x1b
> [49320.144444]  [<00007f1da5ea97aa>] 0x7f1da5ea97a9
> [49348.116055] BUG: soft lockup - CPU#0 stuck for 23s! [mount.cifs:17=
452]
> [49348.116057] Modules linked in: des_generic ecb md4 md5 nls_utf8 ci=
fs(X) ip6table_filter ip6_tables pciback xencow(N) vni_notify vhost_net=
 macvtap macvlan tun netbk blkbk blktap2 blktap domctl blkback_pagemap =
gntdev evtchn ipmi_devintf dm_multipath ocfs2_dlmfs(N) ocfs2_stack_o2cb=
(N) ocfs2_dlm(N) ocfs2_nodemanager(N) ipmi_si ocfs2_stackglue(N) iscsi_=
tcp libiscsi_tcp libiscsi configfs scsi_transport_iscsi af_packet iptab=
le_filter ip_tables x_tables nfnetlink_queue nfnetlink kbox(PN) brcompa=
t(N) openvswitch(N) ipmi_msghandler xen_scsibk xenbus_be vhba(N) nf_con=
ntrack_tftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 loop dm_mod a=
ta_generic ipv6 ipv6_lib ata_piix ahci libahci rtc_cmos serio_raw tg3 8=
250_pnp i7core_edac iTCO_wdt button pcspkr iTCO_vendor_support i2c_i801=
 libata i2c_core sg edac_core shpchp pci_hotplug 8250 serial_core ext3 =
jbd mbcache usbhid hid uhci_hcd sd_mod crc_t10dif ehci_hcd usbcore usb_=
common processor thermal_sys hwmon scsi_dh_alua scsi_dh_rdac scsi_dh_hp=
_sw scsi_dh_emc scsi_dh xenblk cdrom xennet mptsas mptscsih mptbase scs=
i_transport_sas scsi_mod
> [49348.116105] Supported: Yes, External
> [49348.116106] CPU 0
> [49348.116107] Modules linked in: des_generic ecb md4 md5 nls_utf8 ci=
fs(X) ip6table_filter ip6_tables pciback xencow(N) vni_notify vhost_net=
 macvtap macvlan tun netbk blkbk blktap2 blktap domctl blkback_pagemap =
gntdev evtchn ipmi_devintf dm_multipath ocfs2_dlmfs(N) ocfs2_stack_o2cb=
(N) ocfs2_dlm(N) ocfs2_nodemanager(N) ipmi_si ocfs2_stackglue(N) iscsi_=
tcp libiscsi_tcp libiscsi configfs scsi_transport_iscsi af_packet iptab=
le_filter ip_tables x_tables nfnetlink_queue nfnetlink kbox(PN) brcompa=
t(N) openvswitch(N) ipmi_msghandler xen_scsibk xenbus_be vhba(N) nf_con=
ntrack_tftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 loop dm_mod a=
ta_generic ipv6 ipv6_lib ata_piix ahci libahci rtc_cmos serio_raw tg3 8=
250_pnp i7core_edac iTCO_wdt button pcspkr iTCO_vendor_support i2c_i801=
 libata i2c_core sg edac_core shpchp pci_hotplug 8250 serial_core ext3 =
jbd mbcache usbhid hid uhci_hcd sd_mod crc_t10dif ehci_hcd usbcore usb_=
common processor thermal_sys hwmon scsi_dh_alua scsi_dh_rdac scsi_dh_hp=
_sw scsi_dh_emc scsi_dh xenblk cdrom xennet mptsas mptscsih mptbase scs=
i_transport_sas scsi_mod
> [49348.116154] Supported: Yes, External
> [49348.116155]
> [49348.116157] Pid: 17452, comm: mount.cifs Tainted: P        W  NX 3=
=2E0.58-0.6.6-xen #1 Huawei Technologies Co., Ltd. Tecal BH620         =
  /BC01NTSA
> [49348.116161] RIP: e030:[<ffffffff8000322a>]  [<ffffffff8000322a>] 0=
xffffffff80003229
> [49348.116166] RSP: e02b:ffff8800a3bc3bf8  EFLAGS: 00000246
> [49348.116168] RAX: 0000000000040001 RBX: 00000000fffffff5 RCX: fffff=
fff8000322a
> [49348.116170] RDX: 0000000071707adf RSI: 0000000000000000 RDI: 00000=
00000000000
> [49348.116171] RBP: ffff8800b1065e00 R08: ffff8800b11f7158 R09: 00000=
00000000000
> [49348.116173] R10: 0000000000007f00 R11: 0000000000000246 R12: ffff8=
80086148440
> [49348.116175] R13: 0000000000000000 R14: ffff8800a3bc3c9c R15: ffff8=
80086148440
> [49348.116181] FS:  00007fa44207b700(0000) GS:ffff8800bcc00000(0000) =
knlGS:0000000000000000
> [49348.116183] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> [49348.116184] CR2: 00007f60bc663000 CR3: 00000000a3bbf000 CR4: 00000=
00000002660
> [49348.116187] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> [49348.116189] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000=
00000000400
> [49348.116191] Process mount.cifs (pid: 17452, threadinfo ffff8800a3b=
c2000, task ffff8800a3b48140)
> [49348.116192] Stack:
> [49348.116203]  0000000000000001 0000000000000000 ffffffff802dd8e9 ff=
ffffffa090ffe7
> [49348.116206]  ffff8800a3bc3c90 8f3b8f3ba08eeb6b ffff8800b11f7000 00=
00000000000020
> [49348.116209]  ffff8800b1065e00 ffff8800b003ad81 0000000000000008 ff=
ffffffa0943000
> [49348.116212] Call Trace:
> [49348.116224]  [<ffffffff802dd8e9>] force_evtchn_callback+0x9/0x10
> [49348.116232]  [<ffffffffa090ffe7>] SendReceive+0x267/0x3a0 [cifs]
> [49348.116252]  [<ffffffffa08f6596>] CIFSGetDFSRefer+0x246/0x380 [cif=
s]
> [49348.116263]  [<ffffffffa08fd22f>] expand_dfs_referral+0x8f/0x1c0 [=
cifs]
> [49348.116275]  [<ffffffffa08ffb8b>] cifs_mount+0x30b/0x600 [cifs]
> [49348.116287]  [<ffffffffa08ee20e>] cifs_do_mount+0xde/0x260 [cifs]
> [49348.116291]  [<ffffffff8012b6fe>] mount_fs+0x4e/0x1a0
> [49348.116295]  [<ffffffff80147765>] vfs_kern_mount+0x65/0xd0
> [49348.116298]  [<ffffffff80148333>] do_kern_mount+0x53/0x110
> [49348.116302]  [<ffffffff8014a3fd>] do_mount+0x21d/0x260
> [49348.116305]  [<ffffffff8014a500>] sys_mount+0xc0/0xf0
> [49348.116309]  [<ffffffff80401ef3>] system_call_fastpath+0x16/0x1b
> [49348.116314]  [<00007fa4417c17aa>] 0x7fa4417c17a9
> [49348.116315] Code: cc 51 41 53 b8 10 00 00 00 0f 05 41 5b 59 c3 cc =
cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 51 41 53 b8 11 00 00=
 00 0f 05
> [49348.116344]  5b 59 c3 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc=
 cc cc
> [49348.116359] Call Trace:
> [49348.116364]  [<ffffffff802dd8e9>] force_evtchn_callback+0x9/0x10
> [49348.116371]  [<ffffffffa090ffe7>] SendReceive+0x267/0x3a0 [cifs]
> [49348.116389]  [<ffffffffa08f6596>] CIFSGetDFSRefer+0x246/0x380 [cif=
s]
> [49348.116427]  [<ffffffffa08fd22f>] expand_dfs_referral+0x8f/0x1c0 [=
cifs]
> [49348.116439]  [<ffffffffa08ffb8b>] cifs_mount+0x30b/0x600 [cifs]
> [49348.116451]  [<ffffffffa08ee20e>] cifs_do_mount+0xde/0x260 [cifs]
> [49348.116456]  [<ffffffff8012b6fe>] mount_fs+0x4e/0x1a0
> [49348.116459]  [<ffffffff80147765>] vfs_kern_mount+0x65/0xd0
> [49348.116462]  [<ffffffff80148333>] do_kern_mount+0x53/0x110
> [49348.116466]  [<ffffffff8014a3fd>] do_mount+0x21d/0x260
> [49348.116469]  [<ffffffff8014a500>] sys_mount+0xc0/0xf0
> [49348.116472]  [<ffffffff80401ef3>] system_call_fastpath+0x16/0x1b
> [49348.116477]  [<00007fa4417c17aa>] 0x7fa4417c17a9
> [49348.144061] BUG: soft lockup - CPU#1 stuck for 23s! [mount.cifs:17=
511]
> [49348.144063] Modules linked in: des_generic ecb md4 md5 nls_utf8 ci=
fs(X) ip6table_filter ip6_tables pciback xencow(N) vni_notify vhost_net=
 macvtap macvlan tun netbk blkbk blktap2 blktap domctl blkback_pagemap =
gntdev evtchn ipmi_devintf dm_multipath ocfs2_dlmfs(N) ocfs2_stack_o2cb=
(N) ocfs2_dlm(N) ocfs2_nodemanager(N) ipmi_si ocfs2_stackglue(N) iscsi_=
tcp libiscsi_tcp libiscsi configfs scsi_transport_iscsi af_packet iptab=
le_filter ip_tables x_tables nfnetlink_queue nfnetlink kbox(PN) brcompa=
t(N) openvswitch(N) ipmi_msghandler xen_scsibk xenbus_be vhba(N) nf_con=
ntrack_tftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 loop dm_mod a=
ta_generic ipv6 ipv6_lib ata_piix ahci libahci rtc_cmos serio_raw tg3 8=
250_pnp i7core_edac iTCO_wdt button pcspkr iTCO_vendor_support i2c_i801=
 libata i2c_core sg edac_core shpchp pci_hotplug 8250 serial_core ext3 =
jbd mbcache usbhid hid uhci_hcd sd_mod crc_t10dif ehci_hcd usbcore usb_=
common processor thermal_sys hwmon scsi_dh_alua scsi_dh_rdac scsi_dh_hp=
_sw scsi_dh_emc scsi_dh xenblk cdrom xennet mptsas mptscsih mptbase scs=
i_transport_sas scsi_mod
> [49348.144111] Supported: Yes, External
> [49348.144112] CPU 1
> [49348.144113] Modules linked in: des_generic ecb md4 md5 nls_utf8 ci=
fs(X) ip6table_filter ip6_tables pciback xencow(N) vni_notify vhost_net=
 macvtap macvlan tun netbk blkbk blktap2 blktap domctl blkback_pagemap =
gntdev evtchn ipmi_devintf dm_multipath ocfs2_dlmfs(N) ocfs2_stack_o2cb=
(N) ocfs2_dlm(N) ocfs2_nodemanager(N) ipmi_si ocfs2_stackglue(N) iscsi_=
tcp libiscsi_tcp libiscsi configfs scsi_transport_iscsi af_packet iptab=
le_filter ip_tables x_tables nfnetlink_queue nfnetlink kbox(PN) brcompa=
t(N) openvswitch(N) ipmi_msghandler xen_scsibk xenbus_be vhba(N) nf_con=
ntrack_tftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 loop dm_mod a=
ta_generic ipv6 ipv6_lib ata_piix ahci libahci rtc_cmos serio_raw tg3 8=
250_pnp i7core_edac iTCO_wdt button pcspkr iTCO_vendor_support i2c_i801=
 libata i2c_core sg edac_core shpchp pci_hotplug 8250 serial_core ext3 =
jbd mbcache usbhid hid uhci_hcd sd_mod crc_t10dif ehci_hcd usbcore usb_=
common processor thermal_sys hwmon scsi_dh_alua scsi_dh_rdac scsi_dh_hp=
_sw scsi_dh_emc scsi_dh xenblk cdrom xennet mptsas mptscsih mptbase scs=
i_transport_sas scsi_mod
> [49348.144160] Supported: Yes, External
> [49348.144161]
> [49348.144163] Pid: 17511, comm: mount.cifs Tainted: P        W  NX 3=
=2E0.58-0.6.6-xen #1 Huawei Technologies Co., Ltd. Tecal BH620         =
  /BC01NTSA
> [49348.144166] RIP: e030:[<ffffffff803fa1d4>]  [<ffffffff803fa1d4>] _=
raw_spin_lock+0x14/0xa0
> [49348.144173] RSP: e02b:ffff8800a3b97b68  EFLAGS: 00000286
> [49348.144175] RAX: 00000000951b951b RBX: ffffffffa092faac RCX: ffff8=
80086280ac0
> [49348.144177] RDX: ffff880086280ac0 RSI: 0000000000000000 RDI: fffff=
fffa092faac
> [49348.144178] RBP: ffff8800afb1e800 R08: ffff8800a3b97c9c R09: 00000=
00000000000
> [49348.144180] R10: 0000000000007f00 R11: 0000000000000001 R12: ffff8=
80086280ac0
> [49348.144182] R13: 0000000000000000 R14: ffff8800b154c000 R15: ffff8=
80086280ac0
> [49348.144187] FS:  00007f1da6763700(0000) GS:ffff8800bcd00000(0000) =
knlGS:0000000000000000
> [49348.144189] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> [49348.144191] CR2: 00007f60bc663000 CR3: 0000000086228000 CR4: 00000=
00000002660
> [49348.144193] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> [49348.144195] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000=
00000000400
> [49348.144197] Process mount.cifs (pid: 17511, threadinfo ffff8800a3b=
96000, task ffff8800a3b94740)
> [49348.144199] Stack:
> [49348.144210]  ffff8800a3b17f40 0000000000011250 ffff8800b154c194 ff=
ff8800afb1e800
> [49348.144213]  ffff880086280ac0 ffffffffa090f2d1 ffff8800a3b97bde 00=
000000a0941012
> [49348.144215]  0000000000000000 0000006500000001 000000000000000e ff=
ffffffa0911b5a
> [49348.144218] Call Trace:
> [49348.144229]  [<ffffffffa090f2d1>] wait_for_free_request+0x31/0x1c0=
 [cifs]
> [49348.144249]  [<ffffffffa090fdef>] SendReceive+0x6f/0x3a0 [cifs]
> [49348.144267]  [<ffffffffa08f6596>] CIFSGetDFSRefer+0x246/0x380 [cif=
s]
> [49348.144277]  [<ffffffffa08fd22f>] expand_dfs_referral+0x8f/0x1c0 [=
cifs]
> [49348.144289]  [<ffffffffa08ffb8b>] cifs_mount+0x30b/0x600 [cifs]
> [49348.144300]  [<ffffffffa08ee20e>] cifs_do_mount+0xde/0x260 [cifs]
> [49348.144305]  [<ffffffff8012b6fe>] mount_fs+0x4e/0x1a0
> [49348.144309]  [<ffffffff80147765>] vfs_kern_mount+0x65/0xd0
> [49348.144312]  [<ffffffff80148333>] do_kern_mount+0x53/0x110
> [49348.144316]  [<ffffffff8014a3fd>] do_mount+0x21d/0x260
> [49348.144319]  [<ffffffff8014a500>] sys_mount+0xc0/0xf0
> [49348.144323]  [<ffffffff80401ef3>] system_call_fastpath+0x16/0x1b
> [49348.144328]  [<00007f1da5ea97aa>] 0x7f1da5ea97a9
> [49348.144329] Code: 6c 24 30 48 83 c4 38 c3 66 66 66 66 66 66 2e 0f =
1f 84 00 00 00 00 00 41 54 b8 00 00 01 00 55 53 48 89 fb 48 83 ec 10 f0=
 0f c1 07 <0f> a4 c1 10 66 39 c8 0f 94 c2 84 d2 89 44 24 0c 75 62 4c 8d=
 64
> [49348.144371] Call Trace:
> [49348.144378]  [<ffffffffa090f2d1>] wait_for_free_request+0x31/0x1c0=
 [cifs]
> [49348.144397]  [<ffffffffa090fdef>] SendReceive+0x6f/0x3a0 [cifs]
> [49348.144414]  [<ffffffffa08f6596>] CIFSGetDFSRefer+0x246/0x380 [cif=
s]
> [49348.144424]  [<ffffffffa08fd22f>] expand_dfs_referral+0x8f/0x1c0 [=
cifs]
> [49348.144436]  [<ffffffffa08ffb8b>] cifs_mount+0x30b/0x600 [cifs]
> [49348.144448]  [<ffffffffa08ee20e>] cifs_do_mount+0xde/0x260 [cifs]
> [49348.144452]  [<ffffffff8012b6fe>] mount_fs+0x4e/0x1a0
> [49348.144456]  [<ffffffff80147765>] vfs_kern_mount+0x65/0xd0
> [49348.144459]  [<ffffffff80148333>] do_kern_mount+0x53/0x110
> [49348.144462]  [<ffffffff8014a3fd>] do_mount+0x21d/0x260
> [49348.144466]  [<ffffffff8014a500>] sys_mount+0xc0/0xf0
> [49348.144469]  [<ffffffff80401ef3>] system_call_fastpath+0x16/0x1b
> [49348.144474]  [<00007f1da5ea97aa>] 0x7f1da5ea97a9
> [49355.133051] INFO: rcu_sched_state detected stall on CPU 1 (t=3D150=
00 jiffies)
> [49355.133051] sending NMI to all CPUs:
> [49355.133051] NMI backtrace for cpu 1
> [49355.133051] CPU 1
> [49355.133051] Modules linked in: des_generic ecb md4 md5 nls_utf8 ci=
fs(X) ip6table_filter ip6_tables pciback xencow(N) vni_notify vhost_net=
 macvtap macvlan tun netbk blkbk blktap2 blktap domctl blkback_pagemap =
gntdev evtchn ipmi_devintf dm_multipath ocfs2_dlmfs(N) ocfs2_stack_o2cb=
(N) ocfs2_dlm(N) ocfs2_nodemanager(N) ipmi_si ocfs2_stackglue(N) iscsi_=
tcp libiscsi_tcp libiscsi configfs scsi_transport_iscsi af_packet iptab=
le_filter ip_tables x_tables nfnetlink_queue nfnetlink kbox(PN) brcompa=
t(N) openvswitch(N) ipmi_msghandler xen_scsibk xenbus_be vhba(N) nf_con=
ntrack_tftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 loop dm_mod a=
ta_generic ipv6 ipv6_lib ata_piix ahci libahci rtc_cmos serio_raw tg3 8=
250_pnp i7core_edac iTCO_wdt button pcspkr iTCO_vendor_support i2c_i801=
 libata i2c_core sg edac_core shpchp pci_hotplug 8250 serial_core ext3 =
jbd mbcache usbhid hid uhci_hcd sd_mod crc_t10dif ehci_hcd usbcore usb_=
common processor thermal_sys hwmon scsi_dh_alua scsi_dh_rdac scsi_dh_hp=
_sw scsi_dh_emc scsi_dh xenblk cdrom xennet mptsas mptscsih mptbase scs=
i_transport_sas scsi_mod
> [49355.133051] Supported: Yes, External
> [49355.133051]
> [49355.133051] Pid: 17511, comm: mount.cifs Tainted: P        W  NX 3=
=2E0.58-0.6.6-xen #1 Huawei Technologies Co., Ltd. Tecal BH620         =
  /BC01NTSA
> [49355.133051] RIP: e030:[<ffffffff8000330a>]  [<ffffffff8000330a>] 0=
xffffffff80003309
> [49355.133051] RSP: e02b:ffff8800bcd03ce0  EFLAGS: 00000046
> [49355.133051] RAX: 0000000000000000 RBX: 0000000000000001 RCX: fffff=
fff8000330a
> [49355.133051] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 00000=
0000000000b
> [49355.133051] RBP: ffffffff80718360 R08: 0000000000000200 R09: fffff=
fff80718360
> [49355.133051] R10: 0000000000000006 R11: 0000000000000246 R12: 00000=
00000000002
> [49355.133051] R13: ffffffff80718360 R14: ffff8800bcd076c0 R15: ffff8=
800bcd03e38
> [49355.133051] FS:  00007f1da6763700(0000) GS:ffff8800bcd00000(0000) =
knlGS:0000000000000000
> [49355.133051] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> [49355.133051] CR2: 00007f60bc663000 CR3: 0000000086228000 CR4: 00000=
00000002660
> [49355.133051] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> [49355.133051] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000=
00000000400
> [49355.133051] Process mount.cifs (pid: 17511, threadinfo ffff8800a3b=
96000, task ffff8800a3b94740)
> [49355.133051] Stack:
> [49355.133051]  00000000ffffffff 0000000000000001 ffffffff802dde5c ff=
ff8800bcd03d08
> [49355.133051]  0000000000000000 ffffffff80718360 ffffffff800181ba ff=
ffffff80718360
> [49355.133051]  0000000000000000 ffffffff806cac00 ffffffff806cad00 ff=
ffffff80078e30
> [49355.133051] Call Trace:
> [49355.133051]  [<ffffffff802dde5c>] notify_remote_via_ipi+0x4c/0xa0
> [49355.133051]  [<ffffffff800181ba>] xen_send_IPI_mask+0x3a/0x70
> [49355.133051]  [<ffffffff8001832a>] arch_trigger_all_cpu_backtrace+0=
x8a/0xd0
> [49355.133051]  [<ffffffff800acad9>] __rcu_pending+0x139/0x260
> [49355.133051]  [<ffffffff800acc5f>] rcu_check_callbacks+0x5f/0x110
> [49355.133051]  [<ffffffff8005526f>] update_process_times+0x3f/0x80
> [49355.133051]  [<ffffffff80078e8b>] tick_sched_timer+0x5b/0xc0
> [49355.133051]  [<ffffffff8006c9fe>] __run_hrtimer+0xde/0x1d0
> [49355.133051]  [<ffffffff8006cd67>] hrtimer_interrupt+0xe7/0x270
> [49355.133051]  [<ffffffff802e43d7>] timer_interrupt+0x27/0x100
> [49355.133051]  [<ffffffff800a5fb2>] handle_irq_event_percpu+0x62/0x1=
c0
> [49355.133051]  [<ffffffff800a8c52>] handle_percpu_irq+0x42/0x80
> [49355.133051]  [<ffffffff8000840a>] handle_irq+0x1a/0x30
> [49355.133051]  [<ffffffff802de34f>] evtchn_do_upcall+0x1bf/0x2e0
> [49355.133051]  [<ffffffff804024de>] do_hypervisor_callback+0x1e/0x30
> [49355.133051]  [<ffffffff8000322a>] 0xffffffff80003229
> [49355.133051]  [<ffffffff802dd8e9>] force_evtchn_callback+0x9/0x10
> [49355.133051]  [<ffffffffa090ffe7>] SendReceive+0x267/0x3a0 [cifs]
> [49355.133051]  [<ffffffffa08f6596>] CIFSGetDFSRefer+0x246/0x380 [cif=
s]
> [49355.133051]  [<ffffffffa08fd22f>] expand_dfs_referral+0x8f/0x1c0 [=
cifs]
> [49355.133051]  [<ffffffffa08ffb8b>] cifs_mount+0x30b/0x600 [cifs]
> [49355.133051]  [<ffffffffa08ee20e>] cifs_do_mount+0xde/0x260 [cifs]
> [49355.133051]  [<ffffffff8012b6fe>] mount_fs+0x4e/0x1a0
> [49355.133051]  [<ffffffff80147765>] vfs_kern_mount+0x65/0xd0
> [49355.133051]  [<ffffffff80148333>] do_kern_mount+0x53/0x110
> [49355.133051]  [<ffffffff8014a3fd>] do_mount+0x21d/0x260
> [49355.133051]  [<ffffffff8014a500>] sys_mount+0xc0/0xf0
> [49355.133051]  [<ffffffff80401ef3>] system_call_fastpath+0x16/0x1b
> [49355.133051]  [<00007f1da5ea97aa>] 0x7f1da5ea97a9
> [49355.133051] Code: cc 51 41 53 50 b8 17 00 00 00 0f 05 5b 59 c3 cc =
cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 51 41 53 b8 18 00 00=
 00 0f 05
> [49355.133051]  5b 59 c3 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc=
 cc cc
> [49355.133051] Call Trace:
> [49355.133051]  [<ffffffff802dde5c>] notify_remote_via_ipi+0x4c/0xa0
> [49355.133051]  [<ffffffff800181ba>] xen_send_IPI_mask+0x3a/0x70
> [49355.133051]  [<ffffffff8001832a>] arch_trigger_all_cpu_backtrace+0=
x8a/0xd0
> [49355.133051]  [<ffffffff800acad9>] __rcu_pending+0x139/0x260
> [49355.133051]  [<ffffffff800acc5f>] rcu_check_callbacks+0x5f/0x110
> [49355.133051]  [<ffffffff8005526f>] update_process_times+0x3f/0x80
> [49355.133051]  [<ffffffff80078e8b>] tick_sched_timer+0x5b/0xc0
> [49355.133051]  [<ffffffff8006c9fe>] __run_hrtimer+0xde/0x1d0
> [49355.133051]  [<ffffffff8006cd67>] hrtimer_interrupt+0xe7/0x270
> [49355.133051]  [<ffffffff802e43d7>] timer_interrupt+0x27/0x100
> [49355.133051]  [<ffffffff800a5fb2>] handle_irq_event_percpu+0x62/0x1=
c0
> [49355.133051]  [<ffffffff800a8c52>] handle_percpu_irq+0x42/0x80
> [49355.133051]  [<ffffffff8000840a>] handle_irq+0x1a/0x30
> [49355.133051]  [<ffffffff802de34f>] evtchn_do_upcall+0x1bf/0x2e0
> [49355.133051]  [<ffffffff804024de>] do_hypervisor_callback+0x1e/0x30
> [49355.133051]  [<ffffffff8000322a>] 0xffffffff80003229
> [49355.133051]  [<ffffffff802dd8e9>] force_evtchn_callback+0x9/0x10
> [49355.133051]  [<ffffffffa090ffe7>] SendReceive+0x267/0x3a0 [cifs]
> [49355.133051]  [<ffffffffa08f6596>] CIFSGetDFSRefer+0x246/0x380 [cif=
s]
> [49355.133051]  [<ffffffffa08fd22f>] expand_dfs_referral+0x8f/0x1c0 [=
cifs]
> [49355.133051]  [<ffffffffa08ffb8b>] cifs_mount+0x30b/0x600 [cifs]
> [49355.133051]  [<ffffffffa08ee20e>] cifs_do_mount+0xde/0x260 [cifs]
> [49355.133051]  [<ffffffff8012b6fe>] mount_fs+0x4e/0x1a0
> [49355.133051]  [<ffffffff80147765>] vfs_kern_mount+0x65/0xd0
> [49355.133051]  [<ffffffff80148333>] do_kern_mount+0x53/0x110
> [49355.133051]  [<ffffffff8014a3fd>] do_mount+0x21d/0x260
> [49355.133051]  [<ffffffff8014a500>] sys_mount+0xc0/0xf0
> [49355.133051]  [<ffffffff80401ef3>] system_call_fastpath+0x16/0x1b
> [49355.133051]  [<00007f1da5ea97aa>] 0x7f1da5ea97a9
> [49355.133462] NMI backtrace for cpu 0
> [49355.133463] CPU 0
> [49355.133464] Modules linked in: des_generic ecb md4 md5 nls_utf8 ci=
fs(X) ip6table_filter ip6_tables pciback xencow(N) vni_notify vhost_net=
 macvtap macvlan tun netbk blkbk blktap2 blktap domctl blkback_pagemap =
gntdev evtchn ipmi_devintf dm_multipath ocfs2_dlmfs(N) ocfs2_stack_o2cb=
(N) ocfs2_dlm(N) ocfs2_nodemanager(N) ipmi_si ocfs2_stackglue(N) iscsi_=
tcp libiscsi_tcp libiscsi configfs scsi_transport_iscsi af_packet iptab=
le_filter ip_tables x_tables nfnetlink_queue nfnetlink kbox(PN) brcompa=
t(N) openvswitch(N) ipmi_msghandler xen_scsibk xenbus_be vhba(N) nf_con=
ntrack_tftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 loop dm_mod a=
ta_generic ipv6 ipv6_lib ata_piix ahci libahci rtc_cmos serio_raw tg3 8=
250_pnp i7core_edac iTCO_wdt button pcspkr iTCO_vendor_support i2c_i801=
 libata i2c_core sg edac_core shpchp pci_hotplug 8250 serial_core ext3 =
jbd mbcache usbhid hid uhci_hcd sd_mod crc_t10dif ehci_hcd usbcore usb_=
common processor thermal_sys hwmon scsi_dh_alua scsi_dh_rdac scsi_dh_hp=
_sw scsi_dh_emc scsi_dh xenblk cdrom xennet mptsas mptscsih mptbase scs=
i_transport_sas scsi_mod
> [49355.133497] Supported: Yes, External
> [49355.133498]
> [49355.133500] Pid: 17452, comm: mount.cifs Tainted: P        W  NX 3=
=2E0.58-0.6.6-xen #1 Huawei Technologies Co., Ltd. Tecal BH620         =
  /BC01NTSA
> [49355.133503] RIP: e030:[<ffffffff803f8323>]  [<ffffffff803f8323>] m=
utex_lock+0x13/0x40
> [49355.133508] RSP: e02b:ffff8800a3bc3c00  EFLAGS: 00000246
> [49355.133509] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000=
00084407062
> [49355.133511] RDX: 0000000000000000 RSI: 0000000070637063 RDI: ffff8=
800b11f7198
> [49355.133513] RBP: ffff8800b11f7198 R08: ffff8800a3bc3c9c R09: 00000=
00000000000
> [49355.133514] R10: 0000000000007f00 R11: 0000000000000001 R12: ffff8=
80086148440
> [49355.133516] R13: 0000000000000000 R14: ffff8800a3bc3c9c R15: ffff8=
80086148440
> [49355.133521] FS:  00007fa44207b700(0000) GS:ffff8800bcc00000(0000) =
knlGS:0000000000000000
> [49355.133523] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> [49355.133525] CR2: 00007f60bc663000 CR3: 00000000a3bbf000 CR4: 00000=
00000002660
> [49355.133527] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> [49355.133528] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000=
00000000400
> [49355.133530] Process mount.cifs (pid: 17452, threadinfo ffff8800a3b=
c2000, task ffff8800a3b48140)
> [49355.133532] Stack:
> [49355.133533]  0000000000000000 ffff8800b1065e00 ffffffffa090fe30 ff=
ff8800a3bc3c90
> [49355.133535]  70617061a08eeb6b ffff8800b11f7000 0000000000000020 ff=
ff8800b1065e00
> [49355.133537]  ffff8800b003ad81 0000000000000008 ffffffffa0943000 ff=
ff8800a3bc3c88
> [49355.133539] Call Trace:
> [49355.133548]  [<ffffffffa090fe30>] SendReceive+0xb0/0x3a0 [cifs]
> [49355.133567]  [<ffffffffa08f6596>] CIFSGetDFSRefer+0x246/0x380 [cif=
s]
> [49355.133577]  [<ffffffffa08fd22f>] expand_dfs_referral+0x8f/0x1c0 [=
cifs]
> [49355.133589]  [<ffffffffa08ffb8b>] cifs_mount+0x30b/0x600 [cifs]
> [49355.133600]  [<ffffffffa08ee20e>] cifs_do_mount+0xde/0x260 [cifs]
> [49355.133605]  [<ffffffff8012b6fe>] mount_fs+0x4e/0x1a0
> [49355.133608]  [<ffffffff80147765>] vfs_kern_mount+0x65/0xd0
> [49355.133611]  [<ffffffff80148333>] do_kern_mount+0x53/0x110
> [49355.133614]  [<ffffffff8014a3fd>] do_mount+0x21d/0x260
> [49355.133617]  [<ffffffff8014a500>] sys_mount+0xc0/0xf0
> [49355.133620]  [<ffffffff80401ef3>] system_call_fastpath+0x16/0x1b
> [49355.133625]  [<00007fa4417c17aa>] 0x7fa4417c17a9
> [49355.133626] Code: 4c 8b 74 24 60 48 83 c4 68 c3 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 48 83 ec 10 48 89 6c 24 08 48 89 1c 24 48 89 fd=
 f0 ff 0f
> 9>[49355.133634]  05 e8 36 05 00 00 65 48 8b 04 25 00 54 00 00 48 89 =
45 20 48
> [49355.133638] Call Trace:
> [49355.133644]  [<ffffffffa090fe30>] SendReceive+0xb0/0x3a0 [cifs]
> [49355.133662]  [<ffffffffa08f6596>] CIFSGetDFSRefer+0x246/0x380 [cif=
s]
> [49355.133671]  [<ffffffffa08fd22f>] expand_dfs_referral+0x8f/0x1c0 [=
cifs]
> [49355.133683]  [<ffffffffa08ffb8b>] cifs_mount+0x30b/0x600 [cifs]
> [49355.133694]  [<ffffffffa08ee20e>] cifs_do_mount+0xde/0x260 [cifs]
> [49355.133699]  [<ffffffff8012b6fe>] mount_fs+0x4e/0x1a0
> [49355.133702]  [<ffffffff80147765>] vfs_kern_mount+0x65/0xd0
> [49355.133705]  [<ffffffff80148333>] do_kern_mount+0x53/0x110
> [49355.133708]  [<ffffffff8014a3fd>] do_mount+0x21d/0x260
> [49355.133711]  [<ffffffff8014a500>] sys_mount+0xc0/0xf0
> [49355.133714]  [<ffffffff80401ef3>] system_call_fastpath+0x16/0x1b
> [49355.133718]  [<00007fa4417c17aa>] 0x7fa4417c17a9
> [49380.116054] BUG: soft lockup - CPU#0 stuck for 22s! [mount.cifs:17=
452]
> [49380.116055] Modules linked in: des_generic ecb md4 md5 nls_utf8 ci=
fs(X) ip6table_filter ip6_tables pciback xencow(N) vni_notify vhost_net=
 macvtap macvlan tun netbk blkbk blktap2 blktap domctl blkback_pagemap =
gntdev evtchn ipmi_devintf dm_multipath ocfs2_dlmfs(N) ocfs2_stack_o2cb=
(N) ocfs2_dlm(N) ocfs2_nodemanager(N) ipmi_si ocfs2_stackglue(N) iscsi_=
tcp libiscsi_tcp libiscsi configfs scsi_transport_iscsi af_packet iptab=
le_filter ip_tables x_tables nfnetlink_queue nfnetlink kbox(PN) brcompa=
t(N) openvswitch(N) ipmi_msghandler xen_scsibk xenbus_be vhba(N) nf_con=
ntrack_tftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 loop dm_mod a=
ta_generic ipv6 ipv6_lib ata_piix ahci libahci rtc_cmos serio_raw tg3 8=
250_pnp i7core_edac iTCO_wdt button pcspkr iTCO_vendor_support i2c_i801=
 libata i2c_core sg edac_core shpchp pci_hotplug 8250 serial_core ext3 =
jbd mbcache usbhid hid uhci_hcd sd_mod crc_t10dif ehci_hcd usbcore usb_=
common processor thermal_sys hwmon scsi_dh_alua scsi_dh_rdac scsi_dh_hp=
_sw scsi_dh_emc scsi_dh xenblk cdrom xennet mptsas mptscsih mptbase scs=
i_transport_sas scsi_mod
> [49380.116103] Supported: Yes, External
> [49380.116105] CPU 0
> [49380.116106] Modules linked in: des_generic ecb md4 md5 nls_utf8 ci=
fs(X) ip6table_filter ip6_tables pciback xencow(N) vni_notify vhost_net=
 macvtap macvlan tun netbk blkbk blktap2 blktap domctl blkback_pagemap =
gntdev evtchn ipmi_devintf dm_multipath ocfs2_dlmfs(N) ocfs2_stack_o2cb=
(N) ocfs2_dlm(N) ocfs2_nodemanager(N) ipmi_si ocfs2_stackglue(N) iscsi_=
tcp libiscsi_tcp libiscsi configfs scsi_transport_iscsi af_packet iptab=
le_filter ip_tables x_tables nfnetlink_queue nfnetlink kbox(PN) brcompa=
t(N) openvswitch(N) ipmi_msghandler xen_scsibk xenbus_be vhba(N) nf_con=
ntrack_tftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 loop dm_mod a=
ta_generic ipv6 ipv6_lib ata_piix ahci libahci rtc_cmos serio_raw tg3 8=
250_pnp i7core_edac iTCO_wdt button pcspkr iTCO_vendor_support i2c_i801=
 libata i2c_core sg edac_core shpchp pci_hotplug 8250 serial_core ext3 =
jbd mbcache usbhid hid uhci_hcd sd_mod crc_t10dif ehci_hcd usbcore usb_=
common processor thermal_sys hwmon scsi_dh_alua scsi_dh_rdac scsi_dh_hp=
_sw scsi_dh_emc scsi_dh xenblk cdrom xennet mptsas mptscsih mptbase scs=
i_transport_sas scsi_mod
> [49380.116153] Supported: Yes, External
> [49380.116154]
> [49380.116156] Pid: 17452, comm: mount.cifs Tainted: P        W  NX 3=
=2E0.58-0.6.6-xen #1 Huawei Technologies Co., Ltd. Tecal BH620         =
  /BC01NTSA
> [49380.116159] RIP: e030:[<ffffffffa090dfb1>]  [<ffffffffa090dfb1>] h=
eader_assemble+0x21/0x260 [cifs]
> [49380.116168] RSP: e02b:ffff8800a3bc3bf8  EFLAGS: 00010246
> [49380.116170] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000=
00000000008
> [49380.116172] RDX: ffff8800a3b48140 RSI: 0000000000000032 RDI: ffff8=
80086148500
> [49380.116173] RBP: ffff880086148440 R08: ffff8800a3bc3c88 R09: 00000=
00000000000
> [49380.116175] R10: 0000000000007f00 R11: ffffffff800db420 R12: 00000=
00000000000
> [49380.116177] R13: ffff8800a3bc3c88 R14: 000000000000000f R15: 00000=
0000000000f
> [49380.116182] FS:  00007fa44207b700(0000) GS:ffff8800bcc00000(0000) =
knlGS:0000000000000000
> [49380.116185] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> [49380.116186] CR2: 00007f60bc663000 CR3: 00000000a3bbf000 CR4: 00000=
00000002660
> [49380.116188] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> [49380.116190] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000=
00000000400
> [49380.116193] Process mount.cifs (pid: 17452, threadinfo ffff8800a3b=
c2000, task ffff8800a3b48140)
> [49380.116194] Stack:
> [49380.116205]  0000000000000000 0000000000000000 0000000000000032 ff=
ff8800a3bc3c88
> [49380.116208]  ffff8800a3bc3c90 ffffffffa08eeb6b ffff8800b1065e00 00=
000000fffffff5
> [49380.116211]  ffff8800b1065e00 ffff8800b003ad81 0000000000000008 ff=
ffffffa0943000
> [49380.116213] Call Trace:
> [49380.116233]  [<ffffffffa08eeb6b>] smb_init+0x9b/0xc0 [cifs]
> [49380.116241]  [<ffffffffa08f63d9>] CIFSGetDFSRefer+0x89/0x380 [cifs=
]
> [49380.116251]  [<ffffffffa08fd22f>] expand_dfs_referral+0x8f/0x1c0 [=
cifs]
> [49380.116263]  [<ffffffffa08ffb8b>] cifs_mount+0x30b/0x600 [cifs]
> [49380.116275]  [<ffffffffa08ee20e>] cifs_do_mount+0xde/0x260 [cifs]
> [49380.116280]  [<ffffffff8012b6fe>] mount_fs+0x4e/0x1a0
> [49380.116284]  [<ffffffff80147765>] vfs_kern_mount+0x65/0xd0
> [49380.116287]  [<ffffffff80148333>] do_kern_mount+0x53/0x110
> [49380.116290]  [<ffffffff8014a3fd>] do_mount+0x21d/0x260
> [49380.116294]  [<ffffffff8014a500>] sys_mount+0xc0/0xf0
> [49380.116298]  [<ffffffff80401ef3>] system_call_fastpath+0x16/0x1b
> [49380.116303]  [<00007fa4417c17aa>] 0x7fa4417c17a9
> [49380.116304] Code: ae df e9 52 ff ff ff 0f 1f 00 41 56 31 c0 41 89 =
ce b9 20 00 00 00 41 55 41 54 49 89 d4 65 48 8b 14 25 00 54 00 00 55 48=
 89 fd 53 <f3> 48 ab c6 45 04 ff c6 45 05 53 43 8d 44 36 23 c6 45 06 4d=
 c6
> [49380.116346] Call Trace:
> [49380.116362]  [<ffffffffa08eeb6b>] smb_init+0x9b/0xc0 [cifs]
> [49380.116370]  [<ffffffffa08f63d9>] CIFSGetDFSRefer+0x89/0x380 [cifs=
]
> [49380.116379]  [<ffffffffa08fd22f>] expand_dfs_referral+0x8f/0x1c0 [=
cifs]
> [49380.116391]  [<ffffffffa08ffb8b>] cifs_mount+0x30b/0x600 [cifs]
> [49380.116432]  [<ffffffffa08ee20e>] cifs_do_mount+0xde/0x260 [cifs]
> [49380.116437]  [<ffffffff8012b6fe>] mount_fs+0x4e/0x1a0
> [49380.116440]  [<ffffffff80147765>] vfs_kern_mount+0x65/0xd0
> [49380.116443]  [<ffffffff80148333>] do_kern_mount+0x53/0x110
> [49380.116446]  [<ffffffff8014a3fd>] do_mount+0x21d/0x260
> [49380.116450]  [<ffffffff8014a500>] sys_mount+0xc0/0xf0
> [49380.116453]  [<ffffffff80401ef3>] system_call_fastpath+0x16/0x1b
> [49380.116458]  [<00007fa4417c17aa>] 0x7fa4417c17a9
> [49380.144061] BUG: soft lockup - CPU#1 stuck for 22s! [mount.cifs:17=
511]
> [49380.144063] Modules linked in: des_generic ecb md4 md5 nls_utf8 ci=
fs(X) ip6table_filter ip6_tables pciback xencow(N) vni_notify vhost_net=
 macvtap macvlan tun netbk blkbk blktap2 blktap domctl blkback_pagemap =
gntdev evtchn ipmi_devintf dm_multipath ocfs2_dlmfs(N) ocfs2_stack_o2cb=
(N) ocfs2_dlm(N) ocfs2_nodemanager(N) ipmi_si ocfs2_stackglue(N) iscsi_=
tcp libiscsi_tcp libiscsi configfs scsi_transport_iscsi af_packet iptab=
le_filter ip_tables x_tables nfnetlink_queue nfnetlink kbox(PN) brcompa=
t(N) openvswitch(N) ipmi_msghandler xen_scsibk xenbus_be vhba(N) nf_con=
ntrack_tftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 loop dm_mod a=
ta_generic ipv6 ipv6_lib ata_piix ahci libahci rtc_cmos serio_raw tg3 8=
250_pnp i7core_edac iTCO_wdt button pcspkr iTCO_vendor_support i2c_i801=
 libata i2c_core sg edac_core shpchp pci_hotplug 8250 serial_core ext3 =
jbd mbcache usbhid hid uhci_hcd sd_mod crc_t10dif ehci_hcd usbcore usb_=
common processor thermal_sys hwmon scsi_dh_alua scsi_dh_rdac scsi_dh_hp=
_sw scsi_dh_emc scsi_dh xenblk cdrom xennet mptsas mptscsih mptbase scs=
i_transport_sas scsi_mod
> [49380.144110] Supported: Yes, External
> [49380.144112] CPU 1
> [49380.144113] Modules linked in: des_generic ecb md4 md5 nls_utf8 ci=
fs(X) ip6table_filter ip6_tables pciback xencow(N) vni_notify vhost_net=
 macvtap macvlan tun netbk blkbk blktap2 blktap domctl blkback_pagemap =
gntdev evtchn ipmi_devintf dm_multipath ocfs2_dlmfs(N) ocfs2_stack_o2cb=
(N) ocfs2_dlm(N) ocfs2_nodemanager(N) ipmi_si ocfs2_stackglue(N) iscsi_=
tcp libiscsi_tcp libiscsi configfs scsi_transport_iscsi af_packet iptab=
le_filter ip_tables x_tables nfnetlink_queue nfnetlink kbox(PN) brcompa=
t(N) openvswitch(N) ipmi_msghandler xen_scsibk xenbus_be vhba(N) nf_con=
ntrack_tftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 loop dm_mod a=
ta_generic ipv6 ipv6_lib ata_piix ahci libahci rtc_cmos serio_raw tg3 8=
250_pnp i7core_edac iTCO_wdt button pcspkr iTCO_vendor_support i2c_i801=
 libata i2c_core sg edac_core shpchp pci_hotplug 8250 serial_core ext3 =
jbd mbcache usbhid hid uhci_hcd sd_mod crc_t10dif ehci_hcd usbcore usb_=
common processor thermal_sys hwmon scsi_dh_alua scsi_dh_rdac scsi_dh_hp=
_sw scsi_dh_emc scsi_dh xenblk cdrom xennet mptsas mptscsih mptbase scs=
i_transport_sas scsi_mod
> [49380.144159] Supported: Yes, External
> [49380.144161]
> [49380.144162] Pid: 17511, comm: mount.cifs Tainted: P        W  NX 3=
=2E0.58-0.6.6-xen #1 Huawei Technologies Co., Ltd. Tecal BH620         =
  /BC01NTSA
> [49380.144166] RIP: e030:[<ffffffffa090db6b>]  [<ffffffffa090db6b>] G=
etNextMid+0xbb/0x100 [cifs]
> [49380.144174] RSP: e02b:ffff8800a3b97c48  EFLAGS: 00000206
> [49380.144176] RAX: ffff8800b154c180 RBX: ffff8800b154c000 RCX: 00000=
00000005cae
> [49380.144178] RDX: ffff8800a3b94701 RSI: ffff8800b154c180 RDI: ffff8=
800b154c180
> [49380.144180] RBP: 000000000000db8e R08: 000000000000db8d R09: 00000=
00000000000
> [49380.144182] R10: 0000000000007f00 R11: ffffffff800db420 R12: ffff8=
800ac2cbce1
> [49380.144183] R13: 000000000000001a R14: ffffffffa0943000 R15: ffff8=
800a3b97c88
> [49380.144189] FS:  00007f1da6763700(0000) GS:ffff8800bcd00000(0000) =
knlGS:0000000000000000
> [49380.144191] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> [49380.144192] CR2: 00007f60bc663000 CR3: 0000000086228000 CR4: 00000=
00000002660
> [49380.144194] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> [49380.144196] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000=
00000000400
> [49380.144199] Process mount.cifs (pid: 17511, threadinfo ffff8800a3b=
96000, task ffff8800a3b94740)
> [49380.144200] Stack:
> [49380.144211]  000000000000001a ffff880086280ac0 ffff8800afb1e800 ff=
ffffffa08f63f1
> [49380.144213]  ffffffffa0943000 ffff8800a3b97d1c ffff8800a3b97d10 ff=
ff88000000001a
> [49380.144216]  ffff880086280ac0 ffff880086280ac0 ffff8800af182da0 00=
000000ac2cb5a0
> [49380.144219] Call Trace:
> [49380.144238]  [<ffffffffa08f63f1>] CIFSGetDFSRefer+0xa1/0x380 [cifs=
]
> [49380.144248]  [<ffffffffa08fd22f>] expand_dfs_referral+0x8f/0x1c0 [=
cifs]
> [49380.144261]  [<ffffffffa08ffb8b>] cifs_mount+0x30b/0x600 [cifs]
> [49380.144272]  [<ffffffffa08ee20e>] cifs_do_mount+0xde/0x260 [cifs]
> [49380.144277]  [<ffffffff8012b6fe>] mount_fs+0x4e/0x1a0
> [49380.144281]  [<ffffffff80147765>] vfs_kern_mount+0x65/0xd0
> [49380.144284]  [<ffffffff80148333>] do_kern_mount+0x53/0x110
> [49380.144288]  [<ffffffff8014a3fd>] do_mount+0x21d/0x260
> [49380.144291]  [<ffffffff8014a500>] sys_mount+0xc0/0xf0
> [49380.144295]  [<ffffffff80401ef3>] system_call_fastpath+0x16/0x1b
> [49380.144300]  [<00007f1da5ea97aa>] 0x7f1da5ea97a9
> [49380.144302] Code: 00 00 76 09 c7 43 34 03 00 00 00 89 cd 84 c0 74 =
12 8d 41 01 66 41 39 c0 66 89 83 f8 01 00 00 75 8f 31 ed f0 66 ff 05 41=
 1f 02 00 <8b> 35 3b 1f 02 00 0f a4 f2 10 66 39 d6 0f 95 c0 84 c0 74 0c=
 48
> [49380.144344] Call Trace:
> [49380.144360]  [<ffffffffa08f63f1>] CIFSGetDFSRefer+0xa1/0x380 [cifs=
]
> [49380.144370]  [<ffffffffa08fd22f>] expand_dfs_referral+0x8f/0x1c0 [=
cifs]
> [49380.144382]  [<ffffffffa08ffb8b>] cifs_mount+0x30b/0x600 [cifs]
> [49380.144394]  [<ffffffffa08ee20e>] cifs_do_mount+0xde/0x260 [cifs]
> [49380.144398]  [<ffffffff8012b6fe>] mount_fs+0x4e/0x1a0
> [49380.144402]  [<ffffffff80147765>] vfs_kern_mount+0x65/0xd0
> [49380.144405]  [<ffffffff80148333>] do_kern_mount+0x53/0x110
> [49380.144408]  [<ffffffff8014a3fd>] do_mount+0x21d/0x260
> [49380.144412]  [<ffffffff8014a500>] sys_mount+0xc0/0xf0
> [49380.144415]  [<ffffffff80401ef3>] system_call_fastpath+0x16/0x1b
> [49380.144420]  [<00007f1da5ea97aa>] 0x7f1da5ea97a9
> [49408.116055] BUG: soft lockup - CPU#0 stuck for 22s! [mount.cifs:17=
452]
> [49408.116057] Modules linked in: des_generic ecb md4 md5 nls_utf8 ci=
fs(X) ip6table_filter ip6_tables pciback xencow(N) vni_notify vhost_net=
 macvtap macvlan tun netbk blkbk blktap2 blktap domctl blkback_pagemap =
gntdev evtchn ipmi_devintf dm_multipath ocfs2_dlmfs(N) ocfs2_stack_o2cb=
(N) ocfs2_dlm(N) ocfs2_nodemanager(N) ipmi_si ocfs2_stackglue(N) iscsi_=
tcp libiscsi_tcp libiscsi configfs scsi_transport_iscsi af_packet iptab=
le_filter ip_tables x_tables nfnetlink_queue nfnetlink kbox(PN) brcompa=
t(N) openvswitch(N) ipmi_msghandler xen_scsibk xenbus_be vhba(N) nf_con=
ntrack_tftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 loop dm_mod a=
ta_generic ipv6 ipv6_lib ata_piix ahci libahci rtc_cmos serio_raw tg3 8=
250_pnp i7core_edac iTCO_wdt button pcspkr iTCO_vendor_support i2c_i801=
 libata i2c_core sg edac_core shpchp pci_hotplug 8250 serial_core ext3 =
jbd mbcache usbhid hid uhci_hcd sd_mod crc_t10dif ehci_hcd usbcore usb_=
common processor thermal_sys hwmon scsi_dh_alua scsi_dh_rdac scsi_dh_hp=
_sw scsi_dh_emc scsi_dh xenblk cdrom xennet mptsas mptscsih mptbase scs=
i_transport_sas scsi_mod
> [49408.116104] Supported: Yes, External
> [49408.116106] CPU 0
> [49408.116107] Modules linked in: des_generic ecb md4 md5 nls_utf8 ci=
fs(X) ip6table_filter ip6_tables pciback xencow(N) vni_notify vhost_net=
 macvtap macvlan tun netbk blkbk blktap2 blktap domctl blkback_pagemap =
gntdev evtchn ipmi_devintf dm_multipath ocfs2_dlmfs(N) ocfs2_stack_o2cb=
(N) ocfs2_dlm(N) ocfs2_nodemanager(N) ipmi_si ocfs2_stackglue(N) iscsi_=
tcp libiscsi_tcp libiscsi configfs scsi_transport_iscsi af_packet iptab=
le_filter ip_tables x_tables nfnetlink_queue nfnetlink kbox(PN) brcompa=
t(N) openvswitch(N) ipmi_msghandler xen_scsibk xenbus_be vhba(N) nf_con=
ntrack_tftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 loop dm_mod a=
ta_generic ipv6 ipv6_lib ata_piix ahci libahci rtc_cmos serio_raw tg3 8=
250_pnp i7core_edac iTCO_wdt button pcspkr iTCO_vendor_support i2c_i801=
 libata i2c_core sg edac_core shpchp pci_hotplug 8250 serial_core ext3 =
jbd mbcache usbhid hid uhci_hcd sd_mod crc_t10dif ehci_hcd usbcore usb_=
common processor thermal_sys hwmon scsi_dh_alua scsi_dh_rdac scsi_dh_hp=
_sw scsi_dh_emc scsi_dh xenblk cdrom xennet mptsas mptscsih mptbase scs=
i_transport_sas scsi_mod
> [49408.116154] Supported: Yes, External
> [49408.116155]
> [49408.116157] Pid: 17452, comm: mount.cifs Tainted: P        W  NX 3=
=2E0.58-0.6.6-xen #1 Huawei Technologies Co., Ltd. Tecal BH620         =
  /BC01NTSA
> [49408.116160] RIP: e030:[<ffffffff8000322a>]  [<ffffffff8000322a>] 0=
xffffffff80003229
> [49408.116165] RSP: e02b:ffff8800a3bc3bf8  EFLAGS: 00000246
> [49408.116167] RAX: 0000000000040001 RBX: 00000000fffffff5 RCX: fffff=
fff8000322a
> [49408.116169] RDX: 0000000071707bc1 RSI: 0000000000000000 RDI: 00000=
00000000000
> [49408.116171] RBP: ffff8800b1065e00 R08: ffff8800b11f7158 R09: 00000=
00000000000
> [49408.116173] R10: 0000000000007f00 R11: 0000000000000246 R12: ffff8=
80086148440
> [49408.116175] R13: 0000000000000000 R14: ffff8800a3bc3c9c R15: ffff8=
80086148440
> [49408.116180] FS:  00007fa44207b700(0000) GS:ffff8800bcc00000(0000) =
knlGS:0000000000000000
> [49408.116182] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> [49408.116184] CR2: 00007f60bc663000 CR3: 00000000a3bbf000 CR4: 00000=
00000002660
> [49408.116186] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> [49408.116188] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000=
00000000400
> [49408.116190] Process mount.cifs (pid: 17452, threadinfo ffff8800a3b=
c2000, task ffff8800a3b48140)
> [49408.116192] Stack:
> [49408.116202]  0000000000000001 0000000000000000 ffffffff802dd8e9 ff=
ffffffa090ffe7
> [49408.116205]  ffff8800a3bc3c90 50445044a08eeb6b ffff8800b11f7000 00=
00000000000020
> [49408.116208]  ffff8800b1065e00 ffff8800b003ad81 0000000000000008 ff=
ffffffa0943000
> [49408.116211] Call Trace:
> [49408.116219]  [<ffffffff802dd8e9>] force_evtchn_callback+0x9/0x10
> [49408.116227]  [<ffffffffa090ffe7>] SendReceive+0x267/0x3a0 [cifs]
> [49408.116247]  [<ffffffffa08f6596>] CIFSGetDFSRefer+0x246/0x380 [cif=
s]
> [49408.116257]  [<ffffffffa08fd22f>] expand_dfs_referral+0x8f/0x1c0 [=
cifs]
> [49408.116269]  [<ffffffffa08ffb8b>] cifs_mount+0x30b/0x600 [cifs]
> [49408.116281]  [<ffffffffa08ee20e>] cifs_do_mount+0xde/0x260 [cifs]
> [49408.116286]  [<ffffffff8012b6fe>] mount_fs+0x4e/0x1a0
> [49408.116290]  [<ffffffff80147765>] vfs_kern_mount+0x65/0xd0
> [49408.116293]  [<ffffffff80148333>] do_kern_mount+0x53/0x110
> [49408.116296]  [<ffffffff8014a3fd>] do_mount+0x21d/0x260
> [49408.116300]  [<ffffffff8014a500>] sys_mount+0xc0/0xf0
> [49408.116304]  [<ffffffff80401ef3>] system_call_fastpath+0x16/0x1b
> [49408.116309]  [<00007fa4417c17aa>] 0x7fa4417c17a9
> [49408.116310] Code: cc 51 41 53 b8 10 00 00 00 0f 05 41 5b 59 c3 cc =
cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 51 41 53 b8 11 00 00=
 00 0f 05
> [49408.116338]  5b 59 c3 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc=
 cc cc
> [49408.116353] Call Trace:
> [49408.116359]  [<ffffffff802dd8e9>] force_evtchn_callback+0x9/0x10
> [49408.116366]  [<ffffffffa090ffe7>] SendReceive+0x267/0x3a0 [cifs]
> [49408.116383]  [<ffffffffa08f6596>] CIFSGetDFSRefer+0x246/0x380 [cif=
s]
> [49408.116422]  [<ffffffffa08fd22f>] expand_dfs_referral+0x8f/0x1c0 [=
cifs]
> [49408.116434]  [<ffffffffa08ffb8b>] cifs_mount+0x30b/0x600 [cifs]
> [49408.116446]  [<ffffffffa08ee20e>] cifs_do_mount+0xde/0x260 [cifs]
> [49408.116450]  [<ffffffff8012b6fe>] mount_fs+0x4e/0x1a0
> [49408.116454]  [<ffffffff80147765>] vfs_kern_mount+0x65/0xd0
> [49408.116457]  [<ffffffff80148333>] do_kern_mount+0x53/0x110
> [49408.116460]  [<ffffffff8014a3fd>] do_mount+0x21d/0x260
> [49408.116464]  [<ffffffff8014a500>] sys_mount+0xc0/0xf0
> [49408.116467]  [<ffffffff80401ef3>] system_call_fastpath+0x16/0x1b
> [49408.116472]  [<00007fa4417c17aa>] 0x7fa4417c17a9
> [49408.144061] BUG: soft lockup - CPU#1 stuck for 22s! [mount.cifs:17=
511]
> [49408.144063] Modules linked in: des_generic ecb md4 md5 nls_utf8 ci=
fs(X) ip6table_filter ip6_tables pciback xencow(N) vni_notify vhost_net=
 macvtap macvlan tun netbk blkbk blktap2 blktap domctl blkback_pagemap =
gntdev evtchn ipmi_devintf dm_multipath ocfs2_dlmfs(N) ocfs2_stack_o2cb=
(N) ocfs2_dlm(N) ocfs2_nodemanager(N) ipmi_si ocfs2_stackglue(N) iscsi_=
tcp libiscsi_tcp libiscsi configfs scsi_transport_iscsi af_packet iptab=
le_filter ip_tables x_tables nfnetlink_queue nfnetlink kbox(PN) brcompa=
t(N) openvswitch(N) ipmi_msghandler xen_scsibk xenbus_be vhba(N) nf_con=
ntrack_tftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 loop dm_mod a=
ta_generic ipv6 ipv6_lib ata_piix ahci libahci rtc_cmos serio_raw tg3 8=
250_pnp i7core_edac iTCO_wdt button pcspkr iTCO_vendor_support i2c_i801=
 libata i2c_core sg edac_core shpchp pci_hotplug 8250 serial_core ext3 =
jbd mbcache usbhid hid uhci_hcd sd_mod crc_t10dif ehci_hcd usbcore usb_=
common processor thermal_sys hwmon scsi_dh_alua scsi_dh_rdac scsi_dh_hp=
_sw scsi_dh_emc scsi_dh xenblk cdrom xennet mptsas mptscsih mptbase scs=
i_transport_sas scsi_mod
> [49408.144111] Supported: Yes, External
> [49408.144112] CPU 1
> [49408.144113] Modules linked in: des_generic ecb md4 md5 nls_utf8 ci=
fs(X) ip6table_filter ip6_tables pciback xencow(N) vni_notify vhost_net=
 macvtap macvlan tun netbk blkbk blktap2 blktap domctl blkback_pagemap =
gntdev evtchn ipmi_devintf dm_multipath ocfs2_dlmfs(N) ocfs2_stack_o2cb=
(N) ocfs2_dlm(N) ocfs2_nodemanager(N) ipmi_si ocfs2_stackglue(N) iscsi_=
tcp libiscsi_tcp libiscsi configfs scsi_transport_iscsi af_packet iptab=
le_filter ip_tables x_tables nfnetlink_queue nfnetlink kbox(PN) brcompa=
t(N) openvswitch(N) ipmi_msghandler xen_scsibk xenbus_be vhba(N) nf_con=
ntrack_tftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 loop dm_mod a=
ta_generic ipv6 ipv6_lib ata_piix ahci libahci rtc_cmos serio_raw tg3 8=
250_pnp i7core_edac iTCO_wdt button pcspkr iTCO_vendor_support i2c_i801=
 libata i2c_core sg edac_core shpchp pci_hotplug 8250 serial_core ext3 =
jbd mbcache usbhid hid uhci_hcd sd_mod crc_t10dif ehci_hcd usbcore usb_=
common processor thermal_sys hwmon scsi_dh_alua scsi_dh_rdac scsi_dh_hp=
_sw scsi_dh_emc scsi_dh xenblk cdrom xennet mptsas mptscsih mptbase scs=
i_transport_sas scsi_mod
> [49408.144160] Supported: Yes, External
> [49408.144161]
> [49408.144162] Pid: 17511, comm: mount.cifs Tainted: P        W  NX 3=
=2E0.58-0.6.6-xen #1 Huawei Technologies Co., Ltd. Tecal BH620         =
  /BC01NTSA
> [49408.144166] RIP: e030:[<ffffffff801a6be0>]  [<ffffffff801a6be0>] u=
tf8_to_utf32+0x90/0xc0
> [49408.144172] RSP: e02b:ffff8800a3b97b98  EFLAGS: 00000206
> [49408.144174] RAX: ffff880086280ac0 RBX: ffff8800a3b97bb4 RCX: fffff=
fffa0943000
> [49408.144175] RDX: 000000000000005c RSI: 0000000000001000 RDI: ffff8=
800ac2cbce1
> [49408.144177] RBP: 0000000000001000 R08: ffffffff804356c0 R09: 00000=
0000000005c
> [49408.144179] R10: 0000000000007f00 R11: 0000000000000001 R12: ffff8=
800ac2cbce1
> [49408.144181] R13: ffffffffa0943000 R14: ffff880086280b0a R15: ffff8=
800a3b97bde
> [49408.144186] FS:  00007f1da6763700(0000) GS:ffff8800bcd00000(0000) =
knlGS:0000000000000000
> [49408.144188] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> [49408.144190] CR2: 00007f60bc663000 CR3: 0000000086228000 CR4: 00000=
00000002660
> [49408.144192] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> [49408.144194] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000=
00000000400
> [49408.144196] Process mount.cifs (pid: 17511, threadinfo ffff8800a3b=
96000, task ffff8800a3b94740)
> [49408.144198] Stack:
> [49408.144208]  ffff8800a3b97bde ffffffffa0941012 0000000000000000 00=
00000000000001
> [49408.144211]  0000000000000000 ffffffffa0911b5a ffff8800a3b97c08 ff=
ffffff800307c3
> [49408.144214]  00658800afb1e800 ffff880086280ac0 ffff8800afb1e800 00=
00000000001000
> [49408.144217] Call Trace:
> [49408.144223]  [<ffffffffa0941012>] char2uni+0x12/0x40 [nls_utf8]
> [49408.144232]  [<ffffffffa0911b5a>] cifs_strtoUCS+0x5a/0xc0 [cifs]
> [49408.144252]  [<ffffffffa0911d0a>] cifsConvertToUCS+0x14a/0x170 [ci=
fs]
> [49408.144270]  [<ffffffffa08f6473>] CIFSGetDFSRefer+0x123/0x380 [cif=
s]
> [49408.144280]  [<ffffffffa08fd22f>] expand_dfs_referral+0x8f/0x1c0 [=
cifs]
> [49408.144292]  [<ffffffffa08ffb8b>] cifs_mount+0x30b/0x600 [cifs]
> [49408.144304]  [<ffffffffa08ee20e>] cifs_do_mount+0xde/0x260 [cifs]
> [49408.144308]  [<ffffffff8012b6fe>] mount_fs+0x4e/0x1a0
> [49408.144312]  [<ffffffff80147765>] vfs_kern_mount+0x65/0xd0
> [49408.144315]  [<ffffffff80148333>] do_kern_mount+0x53/0x110
> [49408.144319]  [<ffffffff8014a3fd>] do_mount+0x21d/0x260
> [49408.144322]  [<ffffffff8014a500>] sys_mount+0xc0/0xf0
> [49408.144326]  [<ffffffff80401ef3>] system_call_fastpath+0x16/0x1b
> [49408.144331]  [<00007f1da5ea97aa>] 0x7f1da5ea97a9
> [49408.144332] Code: 1f 49 83 c2 01 41 0f b6 02 83 c0 80 0f b6 f8 40 =
f6 c7 c0 75 0b 49 83 c0 20 41 8b 08 85 c9 75 c3 41 bb ff ff ff ff 44 89=
 d8 5b c3 <4c> 89 c9 49 23 48 10 49 39 48 18 77 e8 48 81 f9 ff ff 10 00=
 77
> [49408.144374] Call Trace:
> [49408.144378]  [<ffffffffa0941012>] char2uni+0x12/0x40 [nls_utf8]
> [49408.144385]  [<ffffffffa0911b5a>] cifs_strtoUCS+0x5a/0xc0 [cifs]
> [49408.144405]  [<ffffffffa0911d0a>] cifsConvertToUCS+0x14a/0x170 [ci=
fs]
> [49408.144423]  [<ffffffffa08f6473>] CIFSGetDFSRefer+0x123/0x380 [cif=
s]
> [49408.144433]  [<ffffffffa08fd22f>] expand_dfs_referral+0x8f/0x1c0 [=
cifs]
> [49408.144445]  [<ffffffffa08ffb8b>] cifs_mount+0x30b/0x600 [cifs]
> [49408.144457]  [<ffffffffa08ee20e>] cifs_do_mount+0xde/0x260 [cifs]
> [49408.144461]  [<ffffffff8012b6fe>] mount_fs+0x4e/0x1a0
> [49408.144464]  [<ffffffff80147765>] vfs_kern_mount+0x65/0xd0
> [49408.144468]  [<ffffffff80148333>] do_kern_mount+0x53/0x110
> [49408.144471]  [<ffffffff8014a3fd>] do_mount+0x21d/0x260
> [49408.144474]  [<ffffffff8014a500>] sys_mount+0xc0/0xf0
> [49408.144478]  [<ffffffff80401ef3>] system_call_fastpath+0x16/0x1b
> [49408.144482]  [<00007f1da5ea97aa>] 0x7f1da5ea97a9
>
>
> By analysis, we find the mount.cifs process runs infinite loops in th=
e function of CIFSGetDFSRefer, as the function SendReceive always retur=
n error code EAGAIN, results in the function CIFSGetDFSRefer always got=
o the label getDFSRetry.
>
> int CIFSGetDFSRefer(const int xid, struct cifs_ses *ses,
>                    const unsigned char *searchName,
>                    struct dfs_info3_param **target_nodes,
>                    unsigned int *num_of_nodes,
>                    const struct nls_table *nls_codepage, int remap)
> {
> /* TRANS2_GET_DFS_REFERRAL */
>          TRANSACTION2_GET_DFS_REFER_REQ *pSMB =3D NULL;
>          TRANSACTION2_GET_DFS_REFER_RSP *pSMBr =3D NULL;
>          int rc =3D 0;
>           ......
>          if (ses =3D=3D NULL)
>                    return -ENODEV;
> getDFSRetry:
>          rc =3D smb_init(SMB_COM_TRANSACTION2, 15, NULL, (void **) &p=
SMB,
>                          (void **) &pSMBr);
>          if (rc)
>                    return rc;
>
>          /* server pointer checked in called function,
>          but should never be null here anyway */
>          pSMB->hdr.Mid =3D GetNextMid(ses->server);
>          pSMB->hdr.Tid =3D ses->ipc_tid;
>          =E2=80=A6=E2=80=A6.
>          if (ses->server) {
>                    if (ses->server->sec_mode &
>                       (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
>                             pSMB->hdr.Flags2 |=3D SMBFLG2_SECURITY_SI=
GNATURE;
>          }
>
>          pSMB->hdr.Uid =3D ses->Suid;
>            ......
>          pSMB->ByteCount =3D cpu_to_le16(byte_count);
>
>          rc =3D SendReceive(xid, ses, (struct smb_hdr *) pSMB,
>                             (struct smb_hdr *) pSMBr, &bytes_returned=
, 0);-------------------> this function always return error code EAGAIN
>          if (rc) {
>                    cFYI(1, "Send error in GetDFSRefer =3D %d", rc);
>                    goto GetDFSRefExit;
>          }
>          rc =3D validate_t2((struct smb_t2_rsp *)pSMBr);
>
>          /* BB Also check if enough total bytes returned? */
>          if (rc || get_bcc(&pSMBr->hdr) < 17) {
>                    rc =3D -EIO;      /* bad smb */
>                    goto GetDFSRefExit;
>          }
>
>          cFYI(1, "Decoding GetDFSRefer response BCC: %d  Offset %d",
>                                      get_bcc(&pSMBr->hdr),
>                                      le16_to_cpu(pSMBr->t2.DataOffset=
));
>
>          /* parse returned result into more usable form */
>          rc =3D parse_DFS_referrals(pSMBr, num_of_nodes,
>                                      target_nodes, nls_codepage, rema=
p,
>                                      searchName);
>
> GetDFSRefExit:
>          cifs_buf_release(pSMB);
>
>          if (rc =3D=3D -EAGAIN)
>                    goto getDFSRetry;
>
>          return rc;
> }
>
> The function SendReceive returns EAGAIN because the cifs tcp server s=
tatus is CifsNeedReconnect, so the function allocate_mid which the func=
tion SendReceive calls returns EAGAIN.
>
> static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
>                             struct mid_q_entry **ppmidQ)
> {
>          if (ses->server->tcpStatus =3D=3D CifsExiting) {
>                    return -ENOENT;
>          }
>
>          if (ses->server->tcpStatus =3D=3D CifsNeedReconnect) {
>                    cFYI(1, "tcp session dead - return to caller to re=
try");
>                    return -EAGAIN;
>          }
>
>          if (ses->status !=3D CifsGood) {
>                    /* check if SMB session is bad because we are sett=
ing it up */
>                    if ((in_buf->Command !=3D SMB_COM_SESSION_SETUP_AN=
DX) &&
>                             (in_buf->Command !=3D SMB_COM_NEGOTIATE))
>                             return -EAGAIN;
>                    /* else ok - we are setting up session */
>          }
>          *ppmidQ =3D AllocMidQEntry(in_buf, ses->server);
>          if (*ppmidQ =3D=3D NULL)
>                    return -ENOMEM;
>          spin_lock(&GlobalMid_Lock);
>          list_add_tail(&(*ppmidQ)->qhead, &ses->server->pending_mid_q=
);
>          spin_unlock(&GlobalMid_Lock);
>          return 0;
> }
>
> Normally the cifs module will create one cifsd thread when mounted, t=
his thread will be in charge of the situation when the cifs server tcp =
status becomes to CifsNeedReconnect.
>
> Howerer, as all of the CPUs are in infinite loops, it can=E2=80=99t b=
e able to run the thread cifsd, so the cifs tcp server status is always=
 CifsNeedReconnect.
>
> When I add msleep() function before the code =E2=80=9Cgoto getDFSRetr=
y=E2=80=9D , CPUs are not stuck anymore.
>
> if (rc =3D=3D -EAGAIN){
>          msleep(3000);
>          goto getDFSRetry;
> }
>
> Following is the test scripts to reproduce this bug:
>
> Process 1=EF=BC=9A
>
> #!/bin/sh
> mkdir -p /mnt/cifs
> while [ 1 ]
> do
>     mount.cifs //9.1.0.143/img/123456 /mnt/cifs/ -o ro,username=3Dxxx=
x,passwd=3Dxxxx,directio,
>     umount /mnt/cifs
> done

Have you tried this on a more recent kernel - the way we handle EAGAIN
changed in the
3.7 kernel (and later) and it looks like EAGAIN would have been
handled differently for your case.

Do you actually have a DFS referral in this share?



--=20
Thanks,

Steve
