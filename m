From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: How to deal with such hanging processes?
Date: Sat, 28 Jan 2012 07:30:21 -0500
Message-ID: <20120128073021.4eca547e@tlielax.poochiereds.net>
References: <201201272133.35986@laptok.ed.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?B?xYF1a2FzeiBNYcWba28=?= <masko-/XNhcdyn+gCn9IrpMBEE/Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201201272133.35986-D2Dg4Jie/XezyIjkdXusMg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 27 Jan 2012 21:33:35 +0100
=C5=81ukasz Ma=C5=9Bko <masko-/XNhcdyn+gCn9IrpMBEE/Q@public.gmane.org> wrote:

> I have a Welland ME-752GNS NAS storage. it is capable to serve the fi=
les=20
> only using FTP or CIFS protocol. To quickly transfer data I'm using F=
TP, but=20
> if I want to mount the disk fot instance to browse my images or watch=
=20
> movies, I'm forced to use cifs.
>=20
> It seems to work, but not too well. First, I realise, that my problem=
s come=20
> mainly from poor CIFS implementation in the NAS firmware, but since i=
t is=20
> the only one I have now and I cannot afford to change it, I must some=
how=20
> live with it. The main problem is that quite often something happens =
with=20
> the data transfer. First, it results in such entries in dmesg and log=
s:
>=20
> [ 5743.489573] CIFS VFS: ignoring corrupt resume name
> [ 5743.553028] CIFS VFS: ignoring corrupt resume name
> [ 5743.652823] CIFS VFS: ignoring corrupt resume name
> [ 5744.822936] CIFS VFS: ignoring corrupt resume name
> [ 5758.608685] CIFS VFS: ignoring corrupt resume name
> [ 5770.010003] CIFS VFS: ignoring corrupt resume name
> [ 5792.937939] CIFS VFS: Send error in read =3D -512
> [ 5792.938948] CIFS VFS: No task to wake, unknown frame received! Num=
Mids 2
> [ 5792.938958] Received Data is: : dump of 37 bytes of data at 0xf4f4=
b6c0
> [ 5792.938974]  60000000 424d53ff 0000a4a4 c0018000 . . . ` \xfffffff=
f S M B=20
> =C2=A4 =C2=A4 . . . . . =C5=94
> [ 5792.938988]  00000000 00000000 00000000 2e130006 . . . . . . . . .=
 . . .=20
> . . . .
> [ 5792.938996]  67950002 00000012 . . . g .
>=20
> Especially that part with "CIFS VFS: ignoring corrupt resume name" is=
=20
> happening very often, but it is not causing any major problems.
> Then, but not always, a process which is performing data transfer han=
gs and=20
> I'm getting the following errors:
>=20
> [ 6120.569517] INFO: task kio_file:12029 blocked for more than 120 se=
conds.
> [ 6120.569521] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" dis=
ables=20
> this message.
> [ 6120.569525] kio_file        D e417bc30     0 12029   6037 0x000000=
04
> [ 6120.569533]  e417bcb4 00000086 e417bc30 e417bc30 e417bc38 31a0b404=
=20
> 00000559 00000000
> [ 6120.569543]  c0724a80 e417bc58 c0724a80 f6707a80 f60ab180 f0c539c0=
=20
> 00000020 00000000
> [ 6120.569552]  e427e3c0 e5602938 00000020 e560293c 000003b7 00000010=
=20
> c0664940 e417bcb4
> [ 6120.569561] Call Trace:
> [ 6120.569575]  [<c0174f6c>] ? ktime_get_ts+0xdc/0x110
> [ 6120.569583]  [<c04eadc0>] schedule+0x30/0x50
> [ 6120.569588]  [<c04eae53>] io_schedule+0x73/0xb0
> [ 6120.569594]  [<c01d93c8>] sleep_on_page+0x8/0x10
> [ 6120.569599]  [<c04eb4d7>] __wait_on_bit_lock+0x47/0x90
> [ 6120.569604]  [<c01d93c0>] ? __lock_page+0x80/0x80
> [ 6120.569609]  [<c01d93b6>] __lock_page+0x76/0x80
> [ 6120.569616]  [<c016c2e0>] ? autoremove_wake_function+0x40/0x40
> [ 6120.569623]  [<c024ad6d>] __generic_file_splice_read+0x52d/0x550
> [ 6120.569630]  [<c03f535c>] ? sock_alloc_send_pskb+0x15c/0x290
> [ 6120.569636]  [<c03f94bb>] ? __alloc_skb+0x5b/0x210
> [ 6120.569640]  [<c03f535c>] ? sock_alloc_send_pskb+0x15c/0x290
> [ 6120.569647]  [<c03018fd>] ? _copy_from_user+0x3d/0x60
> [ 6120.569652]  [<c03f8f27>] ? skb_queue_tail+0x37/0x50
> [ 6120.569659]  [<c0484150>] ? unix_stream_sendmsg+0x3d0/0x420
> [ 6120.569665]  [<c0249600>] ? page_cache_pipe_buf_release+0x20/0x20
> [ 6120.569671]  [<c024ae24>] generic_file_splice_read+0x94/0x100
> [ 6120.569677]  [<c024ad90>] ? __generic_file_splice_read+0x550/0x550
> [ 6120.569682]  [<c02498f0>] do_splice_to+0x60/0x80
> [ 6120.569687]  [<c0249b2e>] splice_direct_to_actor+0xae/0x1d0
> [ 6120.569692]  [<c0249860>] ? do_splice_from+0x80/0x80
> [ 6120.569698]  [<c024afcd>] do_splice_direct+0x4d/0x70
> [ 6120.569705]  [<c02252e1>] do_sendfile+0x181/0x220
> [ 6120.569710]  [<c0226053>] sys_sendfile64+0x53/0xc0
> [ 6120.569716]  [<c04f391f>] sysenter_do_call+0x12/0x28
>=20

The process here is stuck waiting for the page lock on a page. Quite
possibly that page is part of a file on a cifs filesystems.

> I'm unable to kill this process and it prevents the share from being=20
> unmounted:
>=20
> $ ps ax | grep kio_file
> 12029 ?        D      0:00 kdeinit4: kio_file [kdeinit] file=20
> local:/home/users/ed/tmp/ksocket-ed/klauncherTi6038.slave-socket=20
> local:/home/users/ed/tmp/ksocket-ed/dolphinU11997.slave-socket
>=20

Right. D state is uninterruptible sleep, and you won't be able to kill
it until it wakes up and comes out of kernel space.

> So far I've learned, that I can do such combination: first, I can umo=
unt=20
> this share with -l (lazy) option, but the process in question still e=
xists.=20
> Second, I can turn the NAS off, wait for a moment and turn it on agai=
n (I'm=20
> not 100% sure if the restart of NAS is a must here, but it is working=
) and=20
> reload the cifs.ko module. As a result, the process is gone and I can=
 keep=20
> on working. Till the problem occurs again...
>=20
> I'm using PLD Linux (which is probably not important). I have a vanil=
la=20
> kernel, right now it is 3.2.2 but the same happened since 2.6.x (the =
only=20
> improve after changing to 3.2. is a big performance jump). I have cif=
s-
> utils-5.2 installed and I'm loading the cifs.ko module with the follo=
wing=20
> parameters:
>=20
> echo_retries=3D1 cifs_max_pending=3D2
>=20
> cifs_max_pending=3D2 is the most important, the higher the value, the=
 more=20
> often the problem occurs and 2 is the smallest possible.
>=20
> Is there anything I can do in the side of my Linux box in such situat=
ion? I=20
> cannot upgrade the NAS firmware for I have the latest version and pro=
bably=20
> no newer will be released (it is closed-source). I cannot get rid of =
this=20
> NAS either. At least for some time. The best would be of course to ma=
ke cifs=20
> work with my NAS anyway, but it's up to You, for I have not enough kn=
owledge=20
> about it.

The way to deal with them is to solve the problem that causes them to
hang in the first place. Once they're stuck like that, there's really
little you can do until the page lock is released. The messages from
the ring buffer suggest that the server is sending corrupt replies to
the requests. A network capture might help confirm that.

Is this the same NAS that requests a maxmpx of 1? If so, the fact that
cifs sends more than one request a time to this server might be the
ultimate cause.

Obviously the server should handle that situation without corrupting
its replies, but cifs is clearly broken in this regard and shouldn't be
sending more than one request at a time to such a server. I doubt
there's anything you can do until Steve fixes that bug.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
