From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mount.cifs hangs when connecting
Date: Thu, 18 Apr 2013 13:10:28 -0500
Message-ID: <CAH2r5msviOzZDj+kubsoVq1a9spDmpDn8NQuB+c=AjgymLC--Q@mail.gmail.com>
References: <CAJV-E0rWpTK08u3bFszkEHL69qEm0noh=LLmUmo_kY5aTxyORw@mail.gmail.com>
	<1366296016.6759.2.camel@localhost>
	<CAJV-E0qB3u4pcLf-zG45cCchonRMi30_Skn-XwC_ZLctzoBW4Q@mail.gmail.com>
	<1366299506.6759.5.camel@localhost>
	<CAH2r5muOTECmyi9DemPfhFLcKXwbP-pWxYtUuwaJzqU8XAtgGw@mail.gmail.com>
	<CAJV-E0pggon=o_i47Bcy+G97VeLpgwq7uNBU_Rs0LF=HB=s-sg@mail.gmail.com>
	<CAJV-E0oOQUJ0US9Lxah19rnBs9t4a9sUseQisgiGWfAcnKqV+g@mail.gmail.com>
	<CAJV-E0qFK+6n2yP4BkWM=eoZd5LpWGy8TQQRFu4YyCPgdg_5cA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Taualii <dtaualii-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJV-E0qFK+6n2yP4BkWM=eoZd5LpWGy8TQQRFu4YyCPgdg_5cA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I thought that the link included referenced loading md5 not tcrypt?

On Thu, Apr 18, 2013 at 1:05 PM, Daniel Taualii <dtaualii-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Everything works if I provide a username.  I didn't specify a username
> in my /etc/fstab file and it hung.  Everything else hung after that
> and couldn't be killed.  I found this:
> https://github.com/rear/rear/issues/149 which pointed to tcrypt not
> being loaded.  I used: modbprobe tcrypt and it said it was temporarily
> unavailable.  I decided to add a username to fstab and restart the
> machine.  Everything mounts and mounts after reboot work and don't
> hang.
>
> I appreciate your help.
>
> On Thu, Apr 18, 2013 at 11:45 AM, Daniel Taualii <dtaualii-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Here is a more complete kern.log snippet:
>>
>> Apr 18 08:09:29 daniel kernel: [  156.124023] CIFS VFS: could not
>> allocate crypto hmacmd5
>> Apr 18 08:09:29 daniel kernel: [  156.124025]
>> Apr 18 08:09:29 daniel kernel: [  156.124028] CIFS VFS: could not
>> setup hash structures rc -110
>> Apr 18 08:09:29 daniel kernel: [  156.124048] CIFS VFS: could not
>> allocate crypto hmacmd5
>> Apr 18 08:09:29 daniel kernel: [  156.124050]
>> Apr 18 08:09:29 daniel kernel: [  156.124052] CIFS VFS: could not
>> setup hash structures rc -110
>> Apr 18 08:09:29 daniel kernel: [  156.124068] CIFS VFS: could not
>> allocate crypto hmacmd5
>> Apr 18 08:09:29 daniel kernel: [  156.124069]
>> Apr 18 08:09:29 daniel kernel: [  156.124070] CIFS VFS: could not
>> setup hash structures rc -110
>> Apr 18 08:09:29 daniel kernel: [  156.124095] BUG: unable to handle
>> kernel NULL pointer dereference at 0000000000000008
>> Apr 18 08:09:29 daniel kernel: [  156.124098] IP: [<ffffffff812deb2b>]
>> crypto_larval_kill+0x2b/0x90
>> Apr 18 08:09:29 daniel kernel: [  156.124104] PGD 226547067 PUD 22669f067 PMD 0
>> Apr 18 08:09:29 daniel kernel: [  156.124108] Oops: 0002 [#1] SMP
>> Apr 18 08:09:29 daniel kernel: [  156.124110] CPU 2
>> Apr 18 08:09:29 daniel kernel: [  156.124111] Modules linked in:
>> vmnet(O) vsock(O) vmci(O) vmmon(O) ip6table_filter ip6_tables
>> ebtable_nat ebtables ipt_MASQUERADE
>> Apr 18 08:09:29 daniel kernel: [  156.124118] CIFS VFS: cifs_mount
>> failed w/return code = -110
>> Apr 18 08:09:29 daniel kernel: [  156.124120]  iptable_nat nf_nat
>> nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
>> xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables
>> bridge stp kvm_intel kvm bnep rfcomm binfmt_misc nfsd ext2
>> snd_hda_codec_hdmi uvcvideo joydev videodev v4l2_compat_ioctl32 arc4
>> tpm_infineon snd_hda_codec_idt dm_multipath nvidia(P) snd_hda_intel
>> snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi
>> snd_seq_midi_event snd_seq snd_timer snd_seq_device snd iwlwifi btusb
>> bluetooth mac80211 hp_wmi sparse_keymap soundcore cfg80211
>> snd_page_alloc mei(C) psmouse serio_raw mac_hid ppdev mxm_wmi
>> parport_pc tpm_tis hp_accel lis3lv02d input_polldev wmi nfs lockd
>> fscache auth_rpcgss nfs_acl sunrpc cryptoloop lp parport nls_utf8 cifs
>> dm_crypt vesafb usbhid hid video firewire_ohci e1000e firewire_core
>> crc_itu_t sdhci_pci sdhci
>> Apr 18 08:09:29 daniel kernel: [  156.124168]
>> Apr 18 08:09:29 daniel kernel: [  156.124171] Pid: 640, comm:
>> mount.cifs Tainted: P         C O 3.2.0-40-generic #64-Ubuntu
>> Hewlett-Packard HP EliteBook 8760w/1630
>> Apr 18 08:09:29 daniel kernel: [  156.124175] RIP:
>> 0010:[<ffffffff812deb2b>]  [<ffffffff812deb2b>]
>> crypto_larval_kill+0x2b/0x90
>> Apr 18 08:09:29 daniel kernel: [  156.124178] RSP:
>> 0018:ffff8801eccbfb68  EFLAGS: 00010296
>> Apr 18 08:09:29 daniel kernel: [  156.124180] RAX: dead000000200200
>> RBX: ffff88022ac00800 RCX: 0000000000000003
>> Apr 18 08:09:29 daniel kernel: [  156.124181] RDX: 0000000000000000
>> RSI: 000000000000001f RDI: ffffffff81c63b80
>> Apr 18 08:09:29 daniel kernel: [  156.124182] RBP: ffff8801eccbfb78
>> R08: 0000000000000000 R09: 0000000000000000
>> Apr 18 08:09:29 daniel kernel: [  156.124184] R10: 0000000000000000
>> R11: 0000000000000001 R12: fffffffffffffffe
>> Apr 18 08:09:29 daniel kernel: [  156.124185] R13: ffffffffa00fd168
>> R14: 0000000000000000 R15: ffff88021e5fae00
>> Apr 18 08:09:29 daniel kernel: [  156.124187] FS:
>> 00007f0f3af31700(0000) GS:ffff88023dc80000(0000)
>> knlGS:0000000000000000
>> Apr 18 08:09:29 daniel kernel: [  156.124188] CS:  0010 DS: 0000 ES:
>> 0000 CR0: 000000008005003b
>> Apr 18 08:09:29 daniel kernel: [  156.124190] CR2: 0000000000000008
>> CR3: 00000001eccea000 CR4: 00000000000406e0
>> Apr 18 08:09:29 daniel kernel: [  156.124191] DR0: 0000000000000000
>> DR1: 0000000000000000 DR2: 0000000000000000
>> Apr 18 08:09:29 daniel kernel: [  156.124193] DR3: 0000000000000000
>> DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Apr 18 08:09:29 daniel kernel: [  156.124195] Process mount.cifs (pid:
>> 640, threadinfo ffff8801eccbe000, task ffff88021e5fae00)
>> Apr 18 08:09:29 daniel kernel: [  156.124196] Stack:
>> Apr 18 08:09:29 daniel kernel: [  156.124197]  ffff88022ac00800
>> fffffffffffffffe ffff8801eccbfb98 ffffffff812df38b
>> Apr 18 08:09:29 daniel kernel: [  156.124200]  ffffffff81838480
>> 0000000000000000 ffff8801eccbfbe8 ffffffff812df5cd
>> Apr 18 08:09:29 daniel kernel: [  156.124202]  ffff8801eccbfc08
>> ffffffffa00e1a86 ffff8801eccbfc08 ffff88022af43800
>> Apr 18 08:09:29 daniel kernel: [  156.124205] Call Trace:
>> Apr 18 08:09:29 daniel kernel: [  156.124209]  [<ffffffff812df38b>]
>> crypto_alg_mod_lookup+0x6b/0x90
>> Apr 18 08:09:29 daniel kernel: [  156.124212]  [<ffffffff812df5cd>]
>> crypto_alloc_tfm+0x6d/0xe0
>> Apr 18 08:09:29 daniel kernel: [  156.124222]  [<ffffffffa00e1a86>] ?
>> cifs_convert_address+0x46/0x120 [cifs]
>> Apr 18 08:09:29 daniel kernel: [  156.124226]  [<ffffffff812e64f9>]
>> crypto_alloc_shash+0x19/0x20
>> Apr 18 08:09:29 daniel kernel: [  156.124249]  [<ffffffffa00e7361>]
>> cifs_crypto_shash_allocate+0x21/0x1a0 [cifs]
>> Apr 18 08:09:29 daniel kernel: [  156.124255]  [<ffffffffa00cde06>]
>> cifs_get_tcp_session+0x126/0x6a0 [cifs]
>> Apr 18 08:09:29 daniel kernel: [  156.124261]  [<ffffffffa00d300d>]
>> cifs_mount+0x8d/0x5f0 [cifs]
>> Apr 18 08:09:29 daniel kernel: [  156.124266]  [<ffffffffa00c0961>] ?
>> cifs_do_mount+0x91/0x280 [cifs]
>> Apr 18 08:09:29 daniel kernel: [  156.124271]  [<ffffffffa00c0985>]
>> cifs_do_mount+0xb5/0x280 [cifs]
>> Apr 18 08:09:29 daniel kernel: [  156.124278]  [<ffffffff8117d2d3>]
>> mount_fs+0x43/0x1b0
>> Apr 18 08:09:29 daniel kernel: [  156.124282]  [<ffffffff81197c1a>]
>> vfs_kern_mount+0x6a/0xc0
>> Apr 18 08:09:29 daniel kernel: [  156.124286]  [<ffffffff81199124>]
>> do_kern_mount+0x54/0x110
>> Apr 18 08:09:29 daniel kernel: [  156.124288]  [<ffffffff8119ac84>]
>> do_mount+0x1a4/0x260
>> Apr 18 08:09:29 daniel kernel: [  156.124291]  [<ffffffff8119b160>]
>> sys_mount+0x90/0xe0
>> Apr 18 08:09:29 daniel kernel: [  156.124294]  [<ffffffff81666a82>]
>> system_call_fastpath+0x16/0x1b
>> Apr 18 08:09:29 daniel kernel: [  156.124295] Code: 55 48 89 e5 53 48
>> 83 ec 08 66 66 66 66 90 48 89 fb 48 c7 c7 80 3b c6 81 e8 03 ec 37 00
>> 48 8b 13 48 8b 43 08 48 c7 c7 80 3b c6 81 <48> 89 42 08 48 89 10 48 b8
>> 00 01 10 00 00 00 ad de 48 ba 00 02
>> Apr 18 08:09:29 daniel kernel: [  156.124313] RIP
>> [<ffffffff812deb2b>] crypto_larval_kill+0x2b/0x90
>> Apr 18 08:09:29 daniel kernel: [  156.124316]  RSP <ffff8801eccbfb68>
>> Apr 18 08:09:29 daniel kernel: [  156.124317] CR2: 0000000000000008
>> Apr 18 08:09:29 daniel kernel: [  156.124319] ---[ end trace
>> 570761f9a42dd7fd ]---
>>
>> On Thu, Apr 18, 2013 at 10:21 AM, Daniel Taualii <dtaualii-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> I must be doing something wrong:
>>>
>>> root@daniel:tmp# gdb /lib/modules/3.2.0-40-generic/kernel/fs/cifs/cifs.ko
>>> GNU gdb (Ubuntu/Linaro 7.4-2012.04-0ubuntu2.1) 7.4-2012.04
>>> Copyright (C) 2012 Free Software Foundation, Inc.
>>> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
>>> This is free software: you are free to change and redistribute it.
>>> There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
>>> and "show warranty" for details.
>>> This GDB was configured as "x86_64-linux-gnu".
>>> For bug reporting instructions, please see:
>>> <http://bugs.launchpad.net/gdb-linaro/>...
>>> Reading symbols from
>>> /lib/modules/3.2.0-40-generic/kernel/fs/cifs/cifs.ko...(no debugging
>>> symbols found)...done.
>>> (gdb) list *(crypto_larval_kill+0x2b)
>>> No symbol table is loaded.  Use the "file" command.
>>>
>>> I don't know which crypto file to look in
>>>
>>> others are having this problem:
>>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1114673
>>>
>>>
>>> On Thu, Apr 18, 2013 at 9:50 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>> If 110 is ETIMEDOUT, cifs isn't likely to have returned this directly
>>>> (although on SMB2 mounts it could be mapped) so problems with build of
>>>> the crypto libraries seems more likely as you suggested.
>>>>
>>>> On Thu, Apr 18, 2013 at 10:38 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>>>> On Thu, 2013-04-18 at 09:14 -0600, Daniel Taualii wrote:
>>>>>> http://pastebin.com/nW1utsYB
>>>>>
>>>>> From the pastebin,
>>>>>
>>>>> [  156.124070] CIFS VFS: could not setup hash structures rc -110
>>>>> [  156.124095] BUG: unable to handle kernel NULL pointer dereference at
>>>>> 0000000000000008
>>>>> [  156.124098] IP: [<ffffffff812deb2b>] crypto_larval_kill+0x2b/0x90
>>>>> [  156.124104] PGD 226547067 PUD 22669f067 PMD 0
>>>>> [  156.124108] Oops: 0002 [#1] SMP
>>>>> [  156.124110] CPU 2
>>>>> [  156.124111] Modules linked in: vmnet(O) vsock(O) vmci(O) vmmon(O)
>>>>> ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE
>>>>>
>>>>> You seem to have had an Oops.
>>>>> The message "CIFS VFS: could not setup hash structures rc -110" suggests
>>>>> that there was a problem enabling the crypto structures which are used
>>>>> for the hashing of the passwords and signing of packets.
>>>>>
>>>>> Can you please provide the entire Oops message along with a few lines
>>>>> which preceed it since it should contain the reason why we were not able
>>>>> to allocate the structure.
>>>>>
>>>>> Sachin Prabhu
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>>
>>>>
>>>> --
>>>> Thanks,
>>>>
>>>> Steve



-- 
Thanks,

Steve
