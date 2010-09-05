From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: 2.6.36-rc3 NULL pointer dereference
 crypto_destroy_tfm+0x50/0x70
Date: Sun, 5 Sep 2010 08:45:04 -0400
Message-ID: <20100905084504.7dae4e13@tlielax.poochiereds.net>
References: <AANLkTinM5N-MOO9fZT9+P3YARwWrfGS+ZFdHGHEoybqs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Hendry <andrew.hendry-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinM5N-MOO9fZT9+P3YARwWrfGS+ZFdHGHEoybqs-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 5 Sep 2010 18:30:46 +1000
Andrew Hendry <andrew.hendry-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Started hitting this since rc3.
> 
> System has 6 cifs mounts from the one server, during shutdown they get
> unmounted and gives this error.
> If manually unmounting one at a time with a gap inbetween it doesn't
> seem to happen.
> 
> config attached.
> 
> [  114.092803] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000108
> [  114.092831] IP: [<ffffffff81254990>] crypto_destroy_tfm+0x50/0x70
> [  114.092843] PGD 211b37067 PUD 211b66067 PMD 0
> [  114.092852] Oops: 0000 [#1] PREEMPT SMP
> [  114.092860] last sysfs file:
> /sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.0/uevent
> [  114.092869] CPU 6
> [  114.092872] Modules linked in: nls_cp437 cifs fbcon tileblit font
> bitblit softcursor binfmt_misc kvm_intel kvm snd_hda_codec_via
> snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss
> nouveau snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi
> snd_seq_midi_event snd_seq snd_timer snd_seq_device ttm psmouse snd
> serio_raw drm_kms_helper soundcore snd_page_alloc drm asus_atk0110
> i2c_algo_bit video output usbhid hid ahci r8169 mii libahci
> pata_jmicron
> [  114.092961]
> [  114.092965] Pid: 1601, comm: umount Not tainted 2.6.36-rc3 #17
> P7P55D-E PRO/System Product Name
> [  114.092974] RIP: 0010:[<ffffffff81254990>]  [<ffffffff81254990>]
> crypto_destroy_tfm+0x50/0x70
> [  114.092984] RSP: 0018:ffff88021e7ddd58  EFLAGS: 00010246
> [  114.092990] RAX: ffff88021e7ddfd8 RBX: ffff8802365945a0 RCX: 0000000000000001
> [  114.092997] RDX: 0000000000000000 RSI: ffff8802365945a8 RDI: ffff8802365945a0
> [  114.093004] RBP: ffff88021e7ddd78 R08: 0000000000000000 R09: 0000000000000000
> [  114.093011] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [  114.093018] R13: 0000000000000fd4 R14: ffff88023296b800 R15: ffff880215685a00
> [  114.093025] FS:  00007fdb1f0dc740(0000) GS:ffff880001ec0000(0000)
> knlGS:0000000000000000
> [  114.093033] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  114.093039] CR2: 0000000000000108 CR3: 0000000232c90000 CR4: 00000000000006e0
> [  114.093046] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  114.093053] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  114.093061] Process umount (pid: 1601, threadinfo ffff88021e7dc000,
> task ffff880215685a00)
> [  114.093068] Stack:
> [  114.093071]  ffff88021e7ddd78 ffffffff81521b1e ffff8802336fda00
> ffff8802336fda00
> [  114.093082] <0> ffff88021e7ddd98 ffffffffa02bc166 ffff88021e7ddd98
> ffff8802336fd800
> [  114.093094] <0> ffff88021e7dddc8 ffffffffa02a356f ffff88021e7dddc8
> ffff880232b72e00
> [  114.093108] Call Trace:
> [  114.093114]  [<ffffffff81521b1e>] ? sub_preempt_count+0xe/0xd0
> [  114.093125]  [<ffffffffa02bc166>] cifs_crypto_shash_release+0x26/0x60 [cifs]
> [  114.093136]  [<ffffffffa02a356f>] cifs_put_smb_ses+0x8f/0x130 [cifs]
> [  114.093146]  [<ffffffffa02a36c5>] cifs_put_tcon+0xb5/0x110 [cifs]
> [  114.093156]  [<ffffffffa02a373e>] cifs_umount+0x1e/0x50 [cifs]
> [  114.093164]  [<ffffffffa0297950>] cifs_put_super+0x50/0x100 [cifs]
> [  114.093172]  [<ffffffff81140b86>] generic_shutdown_super+0x56/0xe0
> [  114.093179]  [<ffffffff81140c76>] kill_anon_super+0x16/0x60
> [  114.093186]  [<ffffffff811413d5>] deactivate_locked_super+0x45/0x60
> [  114.093194]  [<ffffffff8114224a>] deactivate_super+0x4a/0x70
> [  114.093202]  [<ffffffff8115ac36>] mntput_no_expire+0xd6/0x150
> [  114.093208]  [<ffffffff8115b028>] sys_umount+0x78/0x3a0
> [  114.093216]  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> [  114.093222] Code: 00 74 28 48 89 f7 e8 30 fd ff ff 4c 89 e7 e8 88
> ff ff ff 48 89 df e8 00 c5 ea ff 48 8b 5d f0 4c 8b 65 f8 c9 c3 66 0f
> 1f 44 00 00 <49> 8b 84 24 08 01 00 00 48 85 c0 74 cb 48 89 f7 48 89 75
> e8 ff
> [  114.093312] RIP  [<ffffffff81254990>] crypto_destroy_tfm+0x50/0x70
> [  114.093320]  RSP <ffff88021e7ddd58>
> [  114.093324] CR2: 0000000000000108
> [  114.103240] ---[ end trace 8a50aaf11c4eba15 ]---
> [  114.103263] ------------[ cut here ]------------
> [  114.103270] WARNING: at kernel/exit.c:899 do_exit+0x746/0x830()
> [  114.103277] Hardware name: System Product Name
> [  114.103283] Modules linked in: nls_cp437 cifs fbcon tileblit font
> bitblit softcursor binfmt_misc kvm_intel kvm snd_hda_codec_via
> snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss
> nouveau snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi
> snd_seq_midi_event snd_seq snd_timer snd_seq_device ttm psmouse snd
> serio_raw drm_kms_helper soundcore snd_page_alloc drm asus_atk0110
> i2c_algo_bit video output usbhid hid ahci r8169 mii libahci
> pata_jmicron
> [  114.103421] Pid: 1601, comm: umount Tainted: G      D     2.6.36-rc3 #17
> [  114.103430] Call Trace:
> [  114.103438]  [<ffffffff8105a30f>] warn_slowpath_common+0x7f/0xc0
> [  114.103448]  [<ffffffff8105a36a>] warn_slowpath_null+0x1a/0x20
> [  114.103457]  [<ffffffff8105dbf6>] do_exit+0x746/0x830
> [  114.103466]  [<ffffffff8151e0ba>] ? _raw_spin_unlock_irqrestore+0x4a/0x50
> [  114.103477]  [<ffffffff8105b485>] ? kmsg_dump+0x145/0x160
> [  114.103487]  [<ffffffff8151f6ff>] oops_end+0xaf/0xf0
> [  114.103497]  [<ffffffff810376cb>] no_context+0xfb/0x260
> [  114.103506]  [<ffffffff81037955>] __bad_area_nosemaphore+0x125/0x1e0
> [  114.103517]  [<ffffffff81037a7e>] bad_area+0x4e/0x60
> [  114.103527]  [<ffffffff81521a85>] do_page_fault+0x345/0x3d0
> [  114.103539]  [<ffffffff8151ea45>] page_fault+0x25/0x30
> [  114.103550]  [<ffffffff81254990>] ? crypto_destroy_tfm+0x50/0x70
> [  114.103562]  [<ffffffff81521bee>] ? add_preempt_count+0xe/0xd0
> [  114.103574]  [<ffffffff81521b1e>] ? sub_preempt_count+0xe/0xd0
> [  114.103589]  [<ffffffffa02bc166>] cifs_crypto_shash_release+0x26/0x60 [cifs]
> [  114.103603]  [<ffffffffa02a356f>] cifs_put_smb_ses+0x8f/0x130 [cifs]
> [  114.103614]  [<ffffffffa02a36c5>] cifs_put_tcon+0xb5/0x110 [cifs]
> [  114.103626]  [<ffffffffa02a373e>] cifs_umount+0x1e/0x50 [cifs]
> [  114.103679]  [<ffffffffa0297950>] cifs_put_super+0x50/0x100 [cifs]
> [  114.103695]  [<ffffffff81140b86>] generic_shutdown_super+0x56/0xe0
> [  114.103704]  [<ffffffff81140c76>] kill_anon_super+0x16/0x60
> [  114.103713]  [<ffffffff811413d5>] deactivate_locked_super+0x45/0x60
> [  114.103723]  [<ffffffff8114224a>] deactivate_super+0x4a/0x70
> [  114.103733]  [<ffffffff8115ac36>] mntput_no_expire+0xd6/0x150
> [  114.103743]  [<ffffffff8115b028>] sys_umount+0x78/0x3a0
> [  114.103752]  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> [  114.103761] ---[ end trace 8a50aaf11c4eba16 ]---

Known bug. It's the main reason that I've proposed backing out the
patches to convert cifs to use the kernel crypto routines until they
can be reviewed.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
