From: Steve French <smfrench@gmail.com>
Subject: Re: NULL pointer dereference in smb2_queryfs with v4.19.2
Date: Tue, 20 Nov 2018 14:14:25 -0600
Message-ID: <CAH2r5msw-4a1_zNVvvggCpXFjA+PLBt+Di8ygttS8OdC1iioEg@mail.gmail.com>
References: <9cdc7319-32f9-8349-a787-99d6ea973669@linux-ipv6.be>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
To: stijn@linux-ipv6.be
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9cdc7319-32f9-8349-a787-99d6ea973669@linux-ipv6.be>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Do you know if you are running with this patch (which was marked for stable)

commit 32a1fb36f6e50183871c2c1fcf5493c633e84732
Author: Ronnie Sahlberg <lsahlber@redhat.com>
Date:   Wed Oct 24 11:50:33 2018 +1000

    cifs: allow calling SMB2_xxx_free(NULL)

    Change these free functions to allow passing NULL as the argument and
    treat it as a no-op just like free(NULL) would.
    Or, if rqst->rq_iov is NULL.

    The second scenario could happen for smb2_queryfs() if the call
    to SMB2_query_info_init() fails and we go to qfs_exit to clean up
    and free all resources.
    In that case we have not yet assigned rqst[2].rq_iov and thus
    the rq_iov dereference in SMB2_close_free() will cause a NULL pointer
    dereference.

    Fixes:  1eb9fb52040f ("cifs: create SMB2_open_init()/SMB2_open_free() helper
s")

    Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
    Signed-off-by: Steve French <stfrench@microsoft.com>
    Reviewed-by: Aurelien Aptel <aaptel@suse.com>
    CC: Stable <stable@vger.kernel.org>
On Tue, Nov 20, 2018 at 9:38 AM Stijn Tintel <stijn@linux-ipv6.be> wrote:
>
> Hi,
>
> My machine just rebooted after the connection to the Samba server
> hosting a CIFS mount was lost. Kernel version 4.19.2. The oops was
> recorded in pstore:
>
> <3>[533816.847894] CIFS VFS: Server store has not responded in 120
> seconds. Reconnecting...
> <1>[533925.390079] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000000
> <6>[533925.390082] PGD 0 P4D 0
> <4>[533925.390085] Oops: 0000 [#1] PREEMPT SMP PTI
> <4>[533925.390087] CPU: 1 PID: 30794 Comm: sadc Tainted: P
> O      4.19.2-gentoo #1
> <4>[533925.390088] Hardware name: System manufacturer System Product
> Name/P9X79 WS, BIOS 4802 06/02/2015
> <4>[533925.390099] RIP: 0010:SMB2_close_free+0x8/0x10 [cifs]
> <4>[533925.390100] Code: 65 48 33 1c 25 28 00 00 00 75 09 48 83 c4 18 5b
> 5d 41 5c c3 e8 89 ac 29 e0 66 0f 1f 84 00 00 00 00 00 66 66 66 66 90 48
> 8b 07 <48> 8b 38 e9 50 8d fe ff 66 66 66 66 90 4c 8d 54 24 08 48 83 e4 f0
> <4>[533925.390101] RSP: 0018:ffffc9002c2dfbb8 EFLAGS: 00010246
> <4>[533925.390102] RAX: 0000000000000000 RBX: ffff880fae7e5800 RCX:
> 0000000000000000
> <4>[533925.390104] RDX: ffff880fdf521180 RSI: 0000000000000206 RDI:
> ffffc9002c2dfd68
> <4>[533925.390105] RBP: ffffc9002c2dfdf0 R08: 0000000000000000 R09:
> 00000000002503ee
> <4>[533925.390106] R10: ffffc9002c2dfbc0 R11: 00000000000f4240 R12:
> ffffc9002c2dfc50
> <4>[533925.390107] R13: ffff880fad03a200 R14: ffff880fdf521000 R15:
> 0000000000000000
> <4>[533925.390108] FS:  00007fb5cff85740(0000) GS:ffff88100f840000(0000)
> knlGS:0000000000000000
> <4>[533925.390109] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> <4>[533925.390110] CR2: 0000000000000000 CR3: 0000000118d32001 CR4:
> 00000000000626e0
> <4>[533925.390111] Call Trace:
> <4>[533925.390119]  smb2_queryfs+0x162/0x360 [cifs]
> <4>[533925.390124]  ? lookup_fast+0xc8/0x2d0
> <4>[533925.390126]  ? legitimize_path.isra.8+0x28/0x50
> <4>[533925.390127]  ? __vfs_getxattr+0x2a/0x70
> <4>[533925.390130]  ? get_vfs_caps_from_disk+0x65/0x170
> <4>[533925.390135]  ? cifs_statfs+0x97/0x1f0 [cifs]
> <4>[533925.390140]  ? smb2_set_next_command+0x60/0x60 [cifs]
> <4>[533925.390144]  cifs_statfs+0x97/0x1f0 [cifs]
> <4>[533925.390147]  statfs_by_dentry+0x42/0x60
> <4>[533925.390148]  vfs_statfs+0x16/0xc0
> <4>[533925.390150]  user_statfs+0x54/0xa0
> <4>[533925.390151]  __se_sys_statfs+0x25/0x60
> <4>[533925.390153]  do_syscall_64+0x5c/0x160
> <4>[533925.390156]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> <4>[533925.390158] RIP: 0033:0x7fb5cf8ca467
> <4>[533925.390159] Code: 2c 00 64 c7 00 16 00 00 00 b8 ff ff ff ff eb b8
> e8 6e 4f 02 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 b8 89 00 00 00
> 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d f1 e9 2c 00 f7 d8 64 89 01 48
> <4>[533925.390160] RSP: 002b:00007ffc47a0c7f8 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000089
> <4>[533925.390162] RAX: ffffffffffffffda RBX: 00007ffc47a0c9a0 RCX:
> 00007fb5cf8ca467
> <4>[533925.390163] RDX: 00007ffc47a0c9a9 RSI: 00007ffc47a0c800 RDI:
> 00007ffc47a0c9a0
> <4>[533925.390164] RBP: 00007ffc47a0c800 R08: 0000000000000000 R09:
> 000000000000000d
> <4>[533925.390165] R10: 00007fb5cfb9a560 R11: 0000000000000246 R12:
> 00007ffc47a0c8b0
> <4>[533925.390166] R13: 000000000000000b R14: 0000561829c584d4 R15:
> 00007ffc47a0c920
> <4>[533925.390167] Modules linked in: xt_nat hfsplus hfs msdos
> nfnetlink_queue nfnetlink_log cp210x usbserial squashfs cfg80211 drbg
> seqiv xfrm6_mode_tunnel xfrm4_mode_tunnel nvidia_uvm(PO) rfcomm
> xt_CHECKSUM iptable_mangle ipt_REJECT nf_reject_ipv4 xt_tcpudp devlink
> ebtable_filter ebtables ip6table_filter ip6_tables ipt_MASQUERADE
> nf_conntrack_netlink nfnetlink iptable_nat xt_addrtype iptable_filter
> ip_tables bpfilter xt_conntrack x_tables br_netfilter bridge stp llc
> arc4 md4 md5 xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4
> af_key cmac xfrm_algo nls_utf8 cifs ccm sctp bnep nvidia_drm(PO)
> algif_skcipher nvidia_modeset(PO) nls_iso8859_1 nls_cp437 vfat fat
> joydev amdkfd iTCO_wdt nvidia(PO) evdev iTCO_vendor_support uinput
> intel_rapl amdgpu snd_hda_codec_realtek x86_pkg_temp_thermal
> intel_powerclamp
> <4>[533925.390197]  snd_hda_codec_hdmi snd_hda_codec_generic
> crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel
> snd_usb_audio pcbc snd_hda_intel chash snd_usbmidi_lib aesni_intel
> snd_hda_codec snd_rawmidi gpu_sched snd_seq_device crypto_simd ttm
> snd_hda_core bcache btusb snd_hwdep drm_kms_helper btrtl cryptd snd_pcm
> btbcm uas glue_helper btintel crc64 drm snd_timer intel_cstate bluetooth
> drm_panel_orientation_quirks snd intel_uncore syscopyarea soundcore
> i2c_i801 efi_pstore wmi_bmof intel_rapl_perf efivars sysfillrect e1000e
> ecdh_generic sysimgblt lpc_ich mei_me fb_sys_fops button firewire_ohci
> sch_fq_codel nct6775 hwmon_vid coretemp openvswitch nsh nf_nat_ipv6
> nf_nat_ipv4 nf_conncount nf_nat nf_conntrack nf_defrag_ipv6
> nf_defrag_ipv4 vhost_net tun vhost tap kvm_intel kvm irqbypass msr cpuid
> <4>[533925.390226]  efivarfs virtio_ring virtio xts aes_x86_64 ecb cbc
> sha1_generic iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi
> bonding vxlan ip6_udp_tunnel udp_tunnel macvlan igb i2c_algo_bit dca
> e1000 fuse overlay nfs lockd grace sunrpc ext4 mbcache jbd2 fscrypto
> multipath linear raid10 raid1 raid0 dm_raid raid456 async_raid6_recov
> async_memcpy async_pq async_xor async_tx md_mod dm_snapshot dm_bufio
> dm_crypt dm_mirror dm_region_hash dm_log dm_mod hid_sony hid_samsung
> hid_petalynx hid_monterey hid_microsoft hid_logitech ff_memless
> hid_gyration hid_ezkey hid_cypress hid_chicony hid_cherry hid_belkin
> hid_apple hid_a4tech hid_generic usbhid ohci_pci ohci_hcd uhci_hcd hid
> arcmsr sr_mod cdrom sg usb_storage xhci_pci ehci_pci xhci_hcd ehci_hcd
> ptp usbcore firewire_core pps_core crc_itu_t usb_common
> <4>[533925.390259] CR2: 0000000000000000
> <4>[533925.390260] ---[ end trace 66b5055ad278750a ]---
>
> CIFS kernel options:
>
> CONFIG_CIFS=m
> # CONFIG_CIFS_STATS2 is not set
> # CONFIG_CIFS_ALLOW_INSECURE_LEGACY is not set
> # CONFIG_CIFS_UPCALL is not set
> CONFIG_CIFS_XATTR=y
> CONFIG_CIFS_POSIX=y
> CONFIG_CIFS_ACL=y
> CONFIG_CIFS_DEBUG=y
> # CONFIG_CIFS_DEBUG2 is not set
> # CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
> CONFIG_CIFS_DFS_UPCALL=y
> # CONFIG_CIFS_FSCACHE is not set
>
> Please include me when replying.
>
> Thanks,
> Stijn
>


-- 
Thanks,

Steve
