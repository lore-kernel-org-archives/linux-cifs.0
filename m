From: "Robin P. Blanchard" <robin.blanchard@gmail.com>
Subject: Re: Fwd: NULL pointer dereference in smb2_queryfs with v4.19.2
Date: Wed, 28 Nov 2018 07:58:56 -0600
Message-ID: <CAJUwKM1FrC6x+b6pzAgb1CpM77KQ=UzzDRNXdb0BvmZp927_Ag@mail.gmail.com>
References: <9cdc7319-32f9-8349-a787-99d6ea973669@linux-ipv6.be>
 <CAH2r5msw-4a1_zNVvvggCpXFjA+PLBt+Di8ygttS8OdC1iioEg@mail.gmail.com>
 <CAH2r5mtdVym1jo3Ph3+onKqPuZbFdM_yORDAmgeMoUmxH_Z+uw@mail.gmail.com>
 <20181123194303.GJ1917@sasha-vm> <CAH2r5mv3qPELGK+myL2=1cAaE78N1b9uZOtgMBLpuCPn=0U4cg@mail.gmail.com>
 <20181124055125.GN1917@sasha-vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <smfrench@gmail.com>, stable@vger.kernel.org,
        samba-technical@lists.samba.org, linux-cifs@vger.kernel.org,
        stijn@linux-ipv6.be, ronniesahlberg@gmail.com
To: sashal@kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20181124055125.GN1917@sasha-vm>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

I receive a similar OOPS on 4.19.2 (have updated to 4.19.5 and will
continue to monitor):

Oops: 0000 [#2] SMP PTI
CPU: 3 PID: 15929 Comm: python Kdump: loaded Tainted: G D
4.19.2-1.el7.elrepo.x86_64 #1
Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop
Reference Platform, BIOS 6.00 09/21/2015
RIP: 0010:SMB2_query_info_free+0xc/0x20 [cifs]
Code: c7 c7 b8 6d 63 a0 31 c0 e8 5f 88 ae e0 44 8b 54 24 30 eb d8 66
2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 8b 07 48 89 e5 <48> 8b
38 e8 ac 15 fe ff 5d c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
RSP: 0018:ffffc90001f43b80 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffc90001f43d10 RCX: 0000000000000006
RDX: 0000000000000000 RSI: 0000000000000086 RDI: ffffc90001f43d38
RBP: ffffc90001f43b80 R08: 0000000000000000 R09: 00000000003b5f65
R10: 0000000000000001 R11: 0000000000aaaaaa R12: ffff880424dd5800
R13: ffffc90001f43bf0 R14: ffff880169abdc00 R15: 0000000000000000
FS: 00007f56e1f36740(0000) GS:ffff88042fac0000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000036402006 CR4: 00000000001606e0
Call Trace:
smb2_queryfs+0x13a/0x310 [cifs]
? up+0x32/0x4c
? vprintk_emit+0xc3/0x260
? vprintk_default+0x29/0x50
? vprintk_func+0x44/0xe0
cifs_statfs+0xb2/0x2a0 [cifs]
statfs_by_dentry+0xa1/0x120
vfs_statfs+0x1b/0xc0
user_statfs+0x58/0xa0
__do_sys_statfs+0x27/0x60
__x64_sys_statfs+0x16/0x20
do_syscall_64+0x60/0x190
entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f56e0d59787
Code: 2d 00 64 c7 00 16 00 00 00 b8 ff ff ff ff c3 48 8b 15 fd 66 2d
00 f7 d8 64 89 02 48 83 c8 ff c3 0f 1f 00 b8 89 00 00 00 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 8b 0d d9 66 2d 00 f7 d8 64 89 01 48
RSP: 002b:00007ffc18f00108 EFLAGS: 00000202 ORIG_RAX: 0000000000000089
RAX: ffffffffffffffda RBX: 00007f56da1423b4 RCX: 00007f56e0d59787
RDX: 00007f56e1d22068 RSI: 00007ffc18f00110 RDI: 00007f56da1423b4
RBP: 00007f56e1e000d0 R08: 00007f56da1423b4 R09: 00007ffc18f00020
R10: 0000000000000000 R11: 0000000000000202 R12: 00007f56e1ef4240
R13: 00007ffc18f00280 R14: 00007f56da13d410 R15: 00007f56e1ef55f0
Modules linked in: sha512_ssse3 sha512_generic cmac nls_utf8 cifs ccm
dns_resolver nfsv3 nfs_acl nfs lockd grace fscache binfmt_misc
ip6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6
xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute ip6table_nat
nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw iptable_nat
nf_nat_ipv4 nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
libcrc32c iptable_mangle iptable_security iptable_raw ebtable_filter
ebtables  ip6table_filter ip6_tables iptable_filter
vmw_vsock_vmci_transport vsock sb_edac crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel pcbc aesni_intel crypto_simd cryptd glue_helper
intel_rapl_perf vmw_balloon joydev input_leds pcspkr vmw_vmci sg
i2c_piix4 auth_rpcgss sunrpc tcp_bbr sch_fq ip_tables ext4 mbcache
jbd2
sr_mod cdrom ata_generic pata_acpi sd_mod crc32c_intel vmwgfx
serio_raw drm_kms_helper syscopyarea sysfillrect vmxnet3 sysimgblt
fb_sys_fops ttm ata_piix drm vmw_pvscsi libata dm_mirror
dm_region_hash dm_log dm_mod
Dumping ftrace buffer:
(ftrace buffer empty)
CR2: 0000000000000000
---[ end trace 796e5580f5f00736 ]---
RIP: 0010:SMB2_query_info_free+0xc/0x20 [cifs]
Code: c7 c7 b8 6d 63 a0 31 c0 e8 5f 88 ae e0 44 8b 54 24 30 eb d8 66
2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 8b 07 48 89 e5 <48> 8b
38 e8 ac 15 fe ff 5d c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
RSP: 0018:ffffc90002b13b80 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffc90002b13d10 RCX: 0000000000000006
RDX: 0000000000000000 RSI: 0000000000000086 RDI: ffffc90002b13d38
RBP: ffffc90002b13b80 R08: 0000000000000000 R09: 00000000000056a6
R10: 0000000000000007 R11: 00000000000056a5 R12: ffff880424dd5800
R13: ffffc90002b13bf0 R14: ffff880169abdc00 R15: 0000000000000000
FS: 00007f56e1f36740(0000) GS:ffff88042fac0000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000036402006 CR4: 00000000001606e0
On Sat, Nov 24, 2018 at 3:02 AM Sasha Levin <sashal@kernel.org> wrote:
>
> On Fri, Nov 23, 2018 at 05:21:09PM -0600, Steve French wrote:
> >---------- Forwarded message ---------
> >From: Sasha Levin <sashal@kernel.org>
> >Date: Fri, Nov 23, 2018 at 1:43 PM
> >Subject: Re: NULL pointer dereference in smb2_queryfs with v4.19.2
> >To: Steve French <smfrench@gmail.com>
> >Cc: <stijn@linux-ipv6.be>, Stable <stable@vger.kernel.org>, CIFS
> ><linux-cifs@vger.kernel.org>, samba-technical
> ><samba-technical@lists.samba.org>
> >
> >
> >On Tue, Nov 20, 2018 at 02:16:15PM -0600, Steve French wrote:
> >>At first glance it looks like it is missing from the 4.19 stable tree
> >>On Tue, Nov 20, 2018 at 2:14 PM Steve French <smfrench@gmail.com> wrote:
> >>>
> >>> Do you know if you are running with this patch (which was marked for stable)
> >
> >
> >> This commit depends on ba8ca116854 ("cifs: create helpers for
> >>SMB2_set_info_init/free()") which is not marked for stable and is not
> >>trivial.
> >>
> >> If anyone wants to send a backport I'd be happy to queue this patch up.
> >
> >That should not be needed.
> >The dependency you mention - "create helpers for
> >SMB2_set_info_init/free..." is already in 4.19 and is the patch which
> >the stable patch requested ("allow calling SMB2_xxx_free...") fixes.
>
> Hm, it's not in 4.19 - it was merged during the 4.20 merge window.
>
> --
> Thanks,
> Sasha
