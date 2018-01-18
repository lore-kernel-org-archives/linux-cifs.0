From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Regression in SMB3 encryption
Date: Thu, 18 Jan 2018 11:47:33 -0600
Message-ID: <CAH2r5muBi0BAk08EWnmCkakyNRfkXDxu7AZm5tXkFNqW2n1fMw@mail.gmail.com>
References: <394032014.721382.1516242281388.JavaMail.zimbra@redhat.com>
 <1044636361.721617.1516242351557.JavaMail.zimbra@redhat.com> <CAH2r5muh2mzGRAbNDv6GW6KYTJ6NJc=FWQQCE0qhnurCWfxsHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muh2mzGRAbNDv6GW6KYTJ6NJc=FWQQCE0qhnurCWfxsHg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

What was the target server type?

On Thu, Jan 18, 2018 at 11:47 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I just tried some experiments with SMB3 (default kernel) mounts using
> cifs-2.6.git for-next ( 4.15-rc8 + the two big patch series, yours and
> the RDMA ones and the misc. fixes that are smaller) - mounted a Samba
> (4.7, current Fedora) share that required encryption, created some
> files, directories etc. - encryption seemed to work fine - didn't
> notice any problems - do you have a repro scenario?  any additional
> patches?  Do you see it with vanilla 4.15-rc8?
>
> On Wed, Jan 17, 2018 at 8:25 PM, Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>> List,
>>
>> There seems to be a regression in sfrench/for-next for smb3 encryption.
>>
>> It crashes with :
>>
>> [  684.452727] ------------[ cut here ]------------
>> [  684.452744] kernel BUG at ./include/linux/scatterlist.h:147!
>> [  684.453011] invalid opcode: 0000 [#1] SMP PTI
>> [  684.453037] Modules linked in: cmac arc4 md4 nls_utf8 cifs ccm dns_re=
solver nfsv3 nfs_acl nfs lockd grace fscache ip6t_rpfilter ip6t_REJECT nf_r=
eject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge =
stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_=
mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defr=
ag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_ra=
w iptable_security ebtable_filter ebtables ip6table_filter ip6_tables snd_h=
da_codec_generic virtio_console virtio_balloon crct10dif_pclmul crc32_pclmu=
l crc32c_intel ghash_clmulni_intel 8139too snd_hda_intel snd_hda_codec snd_=
hda_core snd_hwdep snd_seq snd_seq_device snd_pcm 8139cp snd_timer serio_ra=
w pcspkr i2c_piix4 mii virtio_pci virtio_ring virtio snd soundcore
>> [  684.453496]  auth_rpcgss sunrpc qxl drm_kms_helper ttm drm floppy qem=
u_fw_cfg ata_generic pata_acpi
>> [  684.453558] CPU: 1 PID: 914 Comm: mount.cifs Not tainted 4.15.0-rc8+ =
#8
>> [  684.453594] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BI=
OS 1.10.2-1.fc26 04/01/2014
>> [  684.453660] RIP: 0010:crypt_message+0x7ac/0x7e0 [cifs]
>> [  684.453699] RSP: 0018:ffffb0d440eb7920 EFLAGS: 00010246
>> [  684.453730] RAX: 0000000000000000 RBX: ffff8e58ed9f30c0 RCX: 00000000=
00000028
>> [  684.453768] RDX: ffff8e58f300b240 RSI: 0000000000000022 RDI: ffffb0d4=
c0eb79c8
>> [  684.453806] RBP: ffffb0d440eb7a20 R08: ffff8e58f300b240 R09: ffff8e58=
f300b240
>> [  684.453844] R10: 0000000000000001 R11: 0000000000000000 R12: 00000000=
00000001
>> [  684.453882] R13: ffffb0d440eb79c8 R14: 0000000000000058 R15: ffff8e58=
f300b2b8
>> [  684.453920] FS:  00007f753959d740(0000) GS:ffff8e58fb000000(0000) knl=
GS:0000000000000000
>> [  684.453963] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  684.453994] CR2: 00007f3b8c315000 CR3: 000000013856a001 CR4: 00000000=
003606e0
>> [  684.454035] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000=
00000000
>> [  684.454075] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000=
00000400
>> [  684.454117] Call Trace:
>> [  684.454163]  ? smb3_init_transform_rq+0x2af/0x380 [cifs]
>> [  684.454206]  smb3_init_transform_rq+0x2af/0x380 [cifs]
>> [  684.454263]  ? smb2_setup_request+0xf8/0x1b0 [cifs]
>> [  684.454308]  smb_send_rqst+0x46/0xb0 [cifs]
>> [  684.454343]  ? smb2_setup_request+0x107/0x1b0 [cifs]
>> [  684.454385]  cifs_send_recv+0xda/0x3a0 [cifs]
>> [  684.454423]  smb2_send_recv+0x139/0x250 [cifs]
>> [  684.454459]  ? _raw_spin_unlock+0x24/0x30
>> [  684.454497]  ? SMB2_tcon+0x180/0x5c0 [cifs]
>> [  684.454535]  SMB2_tcon+0x180/0x5c0 [cifs]
>> [  684.454577]  ? cifs_get_tcon+0x177/0x5b0 [cifs]
>> [  684.454613]  cifs_get_tcon+0x177/0x5b0 [cifs]
>> [  684.454651]  cifs_mount+0x6b8/0xee0 [cifs]
>> [  684.454687]  ? __lockdep_init_map+0x57/0x1d0
>> [  684.454725]  ? cifs_do_mount+0x16c/0x5f0 [cifs]
>> [  684.454768]  cifs_do_mount+0x16c/0x5f0 [cifs]
>> [  684.454797]  ? selinux_sb_copy_data+0x172/0x1d0
>> [  684.454828]  mount_fs+0x30/0x150
>> [  684.454853]  vfs_kern_mount.part.25+0x54/0x150
>> [  684.455928]  do_mount+0x620/0xd60
>> [  684.456987]  ? rcu_read_lock_sched_held+0x6b/0x80
>> [  684.458048]  ? kmem_cache_alloc_trace+0x273/0x2d0
>> [  684.459124]  ? copy_mount_options+0x28/0x230
>> [  684.460168]  SyS_mount+0x80/0xd0
>> [  684.461193]  entry_SYSCALL_64_fastpath+0x25/0x9c
>> [  684.462206] RIP: 0033:0x7f7538eb6cea
>> [  684.463185] RSP: 002b:00007fffb1b08bf8 EFLAGS: 00000202
>> [  684.463193] Code: 48 c7 c6 00 87 87 c0 48 c7 c7 64 52 88 c0 48 89 95 =
38 ff ff ff e8 05 21 fd ff b8 f4 ff ff ff 48 8b 95 38 ff ff ff e9 8b fe ff =
ff <0f> 0b 0f 0b e8 6b ea 84 d2 0f 0b 0f 0b 48 8b 0d 70 af bb d3 e9
>> [  684.466175] RIP: crypt_message+0x7ac/0x7e0 [cifs] RSP: ffffb0d440eb79=
20
>> [  684.467167] ---[ end trace b27c56cf9ad4130e ]---
>>
>>
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
