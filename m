From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: CIFS related seg fault (v2.6.37)
Date: Thu, 20 Jan 2011 10:15:24 +0530
Message-ID: <4D37BDE4.1000104@suse.de>
References: <AANLkTikp0=w7k+PsUCQVQwxnZMLsp3F7a3rEDQAas20G@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Peter Teoh <htmldeveloper-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikp0=w7k+PsUCQVQwxnZMLsp3F7a3rEDQAas20G-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

(Cc linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)

On 01/20/2011 07:05 AM, Peter Teoh wrote:
> Filed a bug today:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=27082
> 
> Version of kernel (linus git tree synced):   v2.6.37-3737-g0c21e3a
> 
> Output of dmesg summarized here:
> 
> [ 7273.369563] ------------[ cut here ]------------
> [ 7273.369575] kernel BUG at fs/dcache.c:1358!

Looks like the issue is already fixed in VFS (see discussion):
	http://thread.gmane.org/gmane.linux.kernel.cifs/2284

Jeff: Looks like the issue is reproducible with 2.6.37 too.. Any idea
which is the commit that fixes this problem and whether it has been
marked for -stable?

> [ 7273.369582] invalid opcode: 0000 [#1] SMP
> [ 7273.369590] last sysfs file:
> /sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0/rfkill0/state
> [ 7273.369598] Modules linked in: nls_cp437 cifs vga16fb vgastate
> isofs udf crc_itu_t usbhid i915 binfmt_misc drm_kms_helper drm
> i2c_algo_bit ppdev bridge stp bnep kvm_intel kvm xfs exportfs lp
> parport snd_hda_codec_conexant arc4 snd_hda_intel snd_hda_codec iwlagn
> snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy pcmcia iwlcore
> snd_seq_oss snd_seq_midi video thinkpad_acpi mac80211 snd_rawmidi
> tpm_tis yenta_socket pcmcia_rsrc pcmcia_core tpm tpm_bios nvram
> psmouse snd_seq_midi_event intel_agp intel_gtt output serio_raw
> snd_seq snd_timer snd_seq_device cfg80211 agpgart iTCO_wdt
> iTCO_vendor_support snd pcspkr soundcore snd_page_alloc reiserfs
> e1000e
> [ 7273.369732]
> [ 7273.369740] Pid: 12963, comm: unzip Not tainted 2.6.37+ #4 7440A82/7440A82
> [ 7273.369748] EIP: 0060:[<c021e902>] EFLAGS: 00210286 CPU: 1
> [ 7273.369763] EIP is at d_set_d_op+0x52/0x60
> [ 7273.369769] EAX: f4ada400 EBX: 00000000 ECX: fcdfc5c0 EDX: fcdfc5c0
> [ 7273.369775] ESI: cff344ac EDI: f2263a00 EBP: f10c7dbc ESP: f10c7dbc
> [ 7273.369782]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [ 7273.369790] Process unzip (pid: 12963, ti=f10c6000 task=ce833f20
> task.ti=f10c6000)
> [ 7273.369795] Stack:
> [ 7273.369799]  f10c7e64 fcde60ed f4540a00 00000109 f10c7e56 f10c7e56
> f10c7e50 f22a9380
> [ 7273.369816]  fce2ffe0 00000000 f10c7e56 000081a4 f4ada400 e4f1a62c
> 00000109 c0000000
> [ 7273.369833]  f4540e00 f21ca000 f2263a00 f450a480 f22a9380 00000005
> 00000080 e4f1a62c
> [ 7273.369849] Call Trace:
> [ 7273.369870]  [<fcde60ed>] cifs_create+0x59d/0x800 [cifs]
> [ 7273.369882]  [<c0216165>] ? generic_permission+0x25/0xc0
> [ 7273.369895]  [<fcdd41b0>] ? cifs_permission+0x0/0x70 [cifs]
> [ 7273.369907]  [<fcdd41f6>] ? cifs_permission+0x46/0x70 [cifs]
> [ 7273.369919]  [<c0301940>] ? security_inode_permission+0x20/0x30
> [ 7273.369929]  [<c0217202>] vfs_create+0x92/0xb0
> [ 7273.369937]  [<c0218710>] do_last+0x240/0x2c0
> [ 7273.369946]  [<c021a7a6>] do_filp_open+0x366/0x670
> [ 7273.369959]  [<c020b14d>] do_sys_open+0x6d/0x110
> [ 7273.369968]  [<c020b25e>] sys_open+0x2e/0x40
> [ 7273.369976]  [<c010301c>] sysenter_do_call+0x12/0x28
> [ 7273.369981] Code: 10 00 00 8b 4a 08 85 c9 74 06 81 08 00 20 00 00
> 8b 0a 85 c9 74 06 81 08 00 40 00 00 8b 52 0c 85 d2 74 06 81 08 00 80
> 00 00 5d c3 <0f> 0b eb fe 66 90 0f 0b eb fe 8d 74 26 00 55 89 e5 53 3e
> 8d 74
> [ 7273.370075] EIP: [<c021e902>] d_set_d_op+0x52/0x60 SS:ESP 0068:f10c7dbc
> 
> Further info is in the bugzilla site.
> 
> Thanks.
> 
> --



-- 
Suresh Jayaraman
