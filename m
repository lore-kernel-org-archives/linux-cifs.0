From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: 3.5.0-rc3 (approximately) oops on cifs mount
Date: Mon, 2 Jul 2012 19:21:07 -0500
Message-ID: <CAH2r5muEUANOjGCkP40LfFF3XtkKKtf9RAabzt-1H+xn1v5ccg@mail.gmail.com>
References: <CALCETrVOwRyrBXDu0G=JE3dtwmXFNV6dAEHVPXYoJfUf6s2==w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrVOwRyrBXDu0G=JE3dtwmXFNV6dAEHVPXYoJfUf6s2==w@mail.gmail.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Any recreation information?

On Mon, Jul 2, 2012 at 7:03 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> mount.cifs crashed my system, on something that's approximately
> 3.5.0-rc3.  (I could find out more precisely if needed.)
>
> pstore rocks, by the way.
>
> <5>[352905.852621] FS-Cache: Loaded
> <5>[352905.858346] FS-Cache: Netfs 'cifs' registered for caching
> <5>[352905.858401] Key type cifs.spnego registered
> <5>[352905.859016] CIFS: no cache= option specified, using
> "cache=loose". This default will change to "cache=strict" in 3.7.
> <4>[352905.862232] ------------[ cut here ]------------
> <2>[352905.862377] kernel BUG at kernel/workqueue.c:564!
> <4>[352905.862538] invalid opcode: 0000 [#1] SMP
> <4>[352905.862665] CPU 6
> <4>[352905.862759] Modules linked in: nls_utf8 cifs fscache tcp_lp
> fuse be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb4i cxgb4 cxgb3i
> libcxgbi cxgb3 mdio iscsi_tcp libiscsi_tcp tpm_infineon libiscsi
> scsi_transport_iscsi f71882fg ip6t_REJECT nf_conntrack_ipv6
> nf_defrag_ipv6 ip6table_filter ip6_tables snd_hda_codec_hdmi
> snd_hda_codec_realtek vfat fat btrfs zlib_deflate lzo_compress
> libcrc32c snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device
> snd_pcm joydev snd_timer e1000e snd coretemp crc32c_intel soundcore
> lpc_ich i2c_i801 serio_raw xhci_hcd pcspkr microcode mfd_core
> snd_page_alloc mei wmi vhost_net macvtap macvlan tun kvm_intel kvm
> uinput ipv6 xts gf128mul dm_crypt firewire_ohci firewire_core
> crc_itu_t radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last
> unloaded: scsi_wait_scan]
> <4>[352905.864936]
> <4>[352905.864985] Pid: 18609, comm: mount.cifs Not tainted
> 3.5.0-rc3-devel+ #435 MSI MS-7760/X79A-GD65 (8D) (MS-7760)
> Oops#1 Part3
> <4>[352905.865303] RIP: 0010:[<ffffffff8104d5b6>]
> [<ffffffff8104d5b6>] get_work_gcwq+0x31/0x3e
> <4>[352905.865552] RSP: 0018:ffff88010d26bb78  EFLAGS: 00010216
> <4>[352905.865717] RAX: ffff88021a9c5688 RBX: 00000000ffffffff RCX:
> 000000000000ea60
> <4>[352905.865941] RDX: ffff88021a9c5680 RSI: ffff88021a9c5680 RDI:
> 0000000000000011
> <4>[352905.866165] RBP: ffff88010d26bb78 R08: ffff880419d3e000 R09:
> 0000000000000001
> <4>[352905.866388] R10: 00000000000155c6 R11: 0000000000015578 R12:
> ffff880447fa1cc0
> <4>[352905.866611] R13: ffff88021a9c5680 R14: ffff88021a9c56a0 R15:
> 000000000000ea60
> <4>[352905.866836] FS:  00007ffc750a7740(0000)
> GS:ffff88045fd80000(0000) knlGS:0000000000000000
> <4>[352905.867087] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> <4>[352905.867267] CR2: 00000034362bdba0 CR3: 000000021a34e000 CR4:
> 00000000000407e0
> <4>[352905.867491] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> <4>[352905.867714] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> <4>[352905.867938] Process mount.cifs (pid: 18609, threadinfo
> ffff88010d26a000, task ffff88043db943e0)
> <4>[352905.868209] Stack:
> <4>[352905.868274]  ffff88010d26bbb8 ffffffff8104db9f ffff88021a9c5400
> ffff88021a9c5400
> <4>[352905.868504]  ffff88004aad8000 ffff8803c9034242 ffff8803f83d1400
> 000000000000000d
> <4>[352905.868735]  ffff88010d26bbc8 ffffffff8104e4f4 ffff88010d26bc98
> ffffffffa057a5da
> <4>[352905.868964] Call Trace:
> <4>[352905.869044]  [<ffffffff8104db9f>] queue_delayed_work_on+0x72/0xed
> <4>[352905.869234]  [<ffffffff8104e4f4>] queue_delayed_work+0x26/0x28
> <4>[352905.869420]  [<ffffffffa057a5da>] cifs_get_tcp_session+0x51f/0x597 [cifs]
> <4>[352905.869632]  [<ffffffffa057d1d2>] cifs_mount+0xf8/0x52d [cifs]
> <4>[352905.869812]  [<ffffffffa056fb3f>] ? cifs_do_mount+0x9c/0x427 [cifs]
> <4>[352905.870009]  [<ffffffffa056fb62>] cifs_do_mount+0xbf/0x427 [cifs]
> <4>[352905.870200]  [<ffffffff811e2bae>] ? selinux_sb_copy_data+0x192/0x1ab
> <4>[352905.870397]  [<ffffffff81104f25>] mount_fs+0x69/0x154
> <4>[352905.870555]  [<ffffffff810d809c>] ? __alloc_percpu+0x10/0x12
> <4>[352905.870732]  [<ffffffff81118ba4>] vfs_kern_mount+0x69/0xe3
> <4>[352905.870903]  [<ffffffff81119129>] do_kern_mount+0x4d/0xdf
> <4>[352905.871072]  [<ffffffff8111aa5c>] do_mount+0x69a/0x6fe
> <4>[352905.871233]  [<ffffffff810d3d66>] ? memdup_user+0x42/0x6a
> <4>[352905.871402]  [<ffffffff8111abd5>] sys_mount+0x8c/0xcd
> <4>[352905.871561]  [<ffffffff8146a9a2>] system_call_fastpath+0x16/0x1b
> <4>[352905.871765] Code: 66 66 90 48 8b 3f 40 f6 c7 04 74 09 40 80 e7
> 00 48 8b 07 eb 21 48 c1 ef 08 83 ff 09 74 16 83 ff 08 74 0a 3b 3d 30
> 8f a5 00 72 02 <0f> 0b e8 79 e8 ff ff eb 02 31 c0 5d c3 55 48 89 e5 66
> 66 66 66
> <1>[352905.872354] RIP  [<ffffffff8104d5b6>] get_work_gcwq+0x31/0x3e
> <4>[352905.872532]  RSP <ffff88010d26bb78>
> <4>[352905.951644] ---[ end trace d127dd774b14850e ]---
>
> --Andy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
