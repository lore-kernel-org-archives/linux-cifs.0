From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: don't call cifs_lookup from atomic open with a
 hashed negative dentry
Date: Sun, 4 Nov 2012 23:59:04 -0600
Message-ID: <CAH2r5msMwx7nRN_XwoWjwmZeC4d2NrojYZvfNwOuiT8=vzOwhg@mail.gmail.com>
References: <1350780282-10385-1-git-send-email-jlayton@redhat.com>
	<20121026081621.21b5832f@tlielax.poochiereds.net>
	<1351615111.3038.9.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351615111.3038.9.camel@localhost>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patch and the version of this patch in Jeff's tree have a fairly
obvious compile warning (you inserted a line of code ---before-- a
variable declaration nested in a block).  Would make it easier if you
fixed that and I could rebase my tree on Jeff's updated branch

CC [M]  fs/cifs/dir.o
fs/cifs/dir.c: In function =91cifs_atomic_open=92:
fs/cifs/dir.c:408:3: warning: ISO C90 forbids mixed declarations and
code [-Wdeclaration-after-
statement]


On Tue, Oct 30, 2012 at 11:38 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>
> On Fri, 2012-10-26 at 08:16 -0400, Jeff Layton wrote:
> > On Sat, 20 Oct 2012 20:44:42 -0400
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > > The following oops was reported by Vit Zahradka. The BUG is this =
in
> > > __d_rehash():
> > >
> > >     BUG_ON(!d_unhashed(entry));
> > >
> > > :kernel BUG at fs/dcache.c:2138!
> > > :invalid opcode: 0000 [#1] SMP
> > > :Modules linked in: fuse ebtable_nat ebtables ipt_MASQUERADE ipta=
ble_nat
> > > nf_nat des_generic xt_CHECKSUM iptable_mangle md4 bridge stp llc =
nls_utf8
> > > cifs dns_resolver fscache lockd sunrpc rfcomm bnep be2iscsi
> > > iscsi_boot_sysfs bnx2i cnic uio cxgb4i cxgb4 cxgb3i cxgb3 mdio li=
bcxgbi
> > > ib_iser rdma_cm ib_addr iw_cm ib_cm ib_sa ib_mad ib_core iscsi_tc=
p
> > > libiscsi_tcp libiscsi scsi_transport_iscsi ip6t_REJECT nf_conntra=
ck_ipv6
> > > nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_de=
frag_ipv4
> > > xt_state nf_conntrack snd_hda_codec_conexant btusb bluetooth snd_=
hda_intel
> > > snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm thinkpad_a=
cpi
> > > snd_page_alloc arc4 snd_timer iwldvm mac80211 iwlwifi cfg80211 uv=
cvideo
> > > videobuf2_vmalloc videobuf2_memops videobuf2_core videodev snd me=
dia rfkill
> > > soundcore i2c_i801 mei r592 memstick iTCO_wdt iTCO_vendor_support=
 lpc_ich
> > > tg3 coretemp microcode ppdev parport_pc parport vhost_net tun mac=
vtap
> > > macvlan kvm_intel kvm uinput binfmt_misc firewire_oh
> > > :ci firewire_core crc_itu_t sdhci_pci sdhci mmc_core yenta_socket=
 wmi video
> > > radeon i2c_algo_bit drm_kms_helper ttm drm i2c_core
> > > :Pid: 2219, comm: eclipse Not tainted 3.6.1-1.fc17.i686 #1 LENOVO
> > > 27326FG/27326FG
> > > :EIP: 0060:[<c0557577>] EFLAGS: 00010282 CPU: 1
> > > :EIP is at __d_rehash+0x57/0x60
> > > :EAX: ee641c80 EBX: 0000096a ECX: f7338208 EDX: f7338208
> > > :ESI: fffffffe EDI: f6339f60 EBP: f0481d84 ESP: f0481d80
> > > : DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> > > :CR0: 8005003b CR2: 06567f84 CR3: 30710000 CR4: 000027d0
> > > :DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> > > :DR6: ffff0ff0 DR7: 00000400
> > > :Process eclipse (pid: 2219, ti=3Df0480000 task=3Df0490c90 task.t=
i=3Df0480000)
> > > :Stack:
> > > : 0000096a f0481d90 c05575b2 ee641c80 f0481d9c c05575da 00000000 =
f0481dd8
> > > : f9c01e32 f0734000 00004213 00000000 f0734000 f0481df4 f11ce600 =
00004213
> > > : f6b07c60 00000000 00000000 f0481ef8 ee641c80 ef1781e0 f0481e20 =
f9c01f52
> > > :Call Trace:
> > > : [<c05575b2>] _d_rehash+0x32/0x40
> > > : [<c05575da>] d_rehash+0x1a/0x30
> > > : [<f9c01e32>] cifs_lookup+0x212/0x300 [cifs]
> > > : [<f9c01f52>] cifs_atomic_open+0x32/0x200 [cifs]
> > > : [<c05584bf>] ? d_lookup+0x2f/0x50
> > > : [<c055074c>] do_last+0x42c/0xbd0
> > > : [<c054dd8c>] ? link_path_walk+0x1dc/0x750
> > > : [<c0550f8d>] path_openat+0x9d/0x3b0
> > > : [<c046d47f>] ? wake_up_state+0xf/0x20
> > > : [<c0490ed2>] ? wake_futex+0x32/0x50
> > > : [<c046fcb5>] ? __dequeue_entity+0x25/0x40
> > > : [<c0551481>] do_filp_open+0x31/0x80
> > > : [<c055bdfc>] ? alloc_fd+0x3c/0xe0
> > > : [<c054c970>] ? getname_flags+0x40/0xd0
> > > : [<c0542885>] do_sys_open+0xe5/0x1c0
> > > : [<c05429d0>] sys_openat+0x30/0x40
> > > : [<c095addf>] sysenter_do_call+0x12/0x28
> > > :Code: 48 08 74 03 89 59 04 f6 c3 01 89 50 0c 75 20 f6 02 01 74 1=
9 83 cb 01
> > > 89 1a 0f ba 32 00 5b 5d c3 f3 90 8b 0a 80 e1 01 75 f7 eb b9 <0f> =
0b 0f 0b
> > > 0f 0b 8d 76 00 55 89 e5 53 66 66 66 66 90 8b 0d fc
> > > :EIP: [<c0557577>] __d_rehash+0x57/0x60 SS:ESP 0068:f0481d80
> > >
> > > I think what happened is something like the following:
> > >
> > > openat() was called on the file without O_CREAT. A negative dentr=
y was
> > > already in the cache, and was successfully revalidated. At that p=
oint a
> > > hashed, negative dentry was passed to cifs_atomic_open. Since O_C=
REAT
> > > wasn't set, it punted it over to cifs_lookup which did a lookup a=
nd then
> > > tried to rehash the result and tripped over the bug.
> > >
> > > Fix this by simply returning -ENOENT in this case instead of call=
ing
> > > cifs_lookup. For the longer term, I think cifs_atomic_open could =
use
> > > some cleanup. There is probably no reason to limit atomic opens t=
o the
> > > O_CREAT case.
> > >
> > > Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> # 3.6.x
> > > Reported-and-Tested-by: Vit Zahradka <vit.zahradka-IWqWACnzNjzrBKCeMvbIDA@public.gmane.org>
> > > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > ---
> >
> > Steve,
> >
> > It turns out that Marcus has hit an issue with this patch in place =
that
> > we don't fully understand yet:
> >
> >     https://bugzilla.redhat.com/show_bug.cgi?id=3D867344#c25
> >
> > I've asked Sachin to take a look, but it might be best to hold off =
on
> > pushing this to Linus until we understand the problem there.
>
> The problem here is that we will always receive a dentry without an
> associated inode. The difference is that some of these dentries are
> hashed ie. a negative lookup and some of these aren't hashed ie.
> cifs_lookup() is expected to lookup the inode details, update the den=
try
> and hash it. This patch ends up returning -ENOENT for every open call=
ed
> which doesn't have the O_CREAT flag set and whose dentry hasn't been
> cached yet.
>
> I will be sending another patch which fixes this problem shortly.
>
> Sachin Prabhu
>



--
Thanks,

Steve
