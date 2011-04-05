From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Repeatable crash in 2.6.38 related to O_DIRECT
Date: Tue, 5 Apr 2011 18:33:11 -0500
Message-ID: <BANLkTikH4o9aGJD2m+d9n3G=o6fwJBZfnA@mail.gmail.com>
References: <4D9B9BB0.3030604@candelatech.com>
	<20110405162609.6776e264@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110405162609.6776e264-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Apr 5, 2011 at 6:26 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, 05 Apr 2011 15:46:08 -0700
> Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> wrote:
>
>> When we try to create files with O_DIRECT on cifs file systems,
>> we get a repeatable crash in 2.6.38.2 (plus hacks, but no hacks to
>> cifs)
>>
>> It crashes in cifsFileInfo_put, probably because cif_file->dentry
>> is NULL, but I'm still working on confirming that.
>>
>> Assuming that is the cause, any ideas on how to go about fixing
>> this properly?
>>
>> (gdb) l *(cifsFileInfo_put+0x10)
>> 0xfd59 is in cifsFileInfo_put (/home/greearb/git/linux-2.6.dev.38.y/=
fs/cifs/file.c:287).
>> 282 =A0 =A0* the filehandle out on the server. Must be called withou=
t holding
>> 283 =A0 =A0* cifs_file_list_lock.
>> 284 =A0 =A0*/
>> 285 =A0 void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
>> 286 =A0 {
>> 287 =A0 =A0 =A0 =A0 =A0 struct inode *inode =3D cifs_file->dentry->d=
_inode;
>> 288 =A0 =A0 =A0 =A0 =A0 struct cifsTconInfo *tcon =3D tlink_tcon(cif=
s_file->tlink);
>> 289 =A0 =A0 =A0 =A0 =A0 struct cifsInodeInfo *cifsi =3D CIFS_I(inode=
);
>> 290 =A0 =A0 =A0 =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(ino=
de->i_sb);
>> 291 =A0 =A0 =A0 =A0 =A0 struct cifsLockInfo *li, *tmp;
>>
>>
>> BUG: unable to handle kernel NULL pointer dereference at 0000001c
>> IP: [<f993e265>] cifsFileInfo_put+0x10/0x1b1 [cifs]
>> *pde =3D 7efaa067
>> Oops: 0000 [#1] SMP
>> last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:03:00.0/n=
et/wlan0/flags
>> Modules linked in: md4 nls_utf8 cifs xt_CT iptable_raw ipt_addrtype =
xt_DSCP xt_dscp xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_i=
prange xt_hashlimit
>> xt_connmark veth cryptd aes_i586 aes_generic xt_TPROXY nf_tproxy_cor=
e xt_socket ip6_tables nf_defrag_ipv6 xt_connlimit 8021q garp stp llc f=
use macvlan pktgen
>> coretemp hwmon nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 uin=
put arc4 ecb ath9k snd_hda_codec_realtek mac80211 snd_hda_intel snd_hda=
_codec ath9k_common
>> snd_hwdep snd_seq ath9k_hw snd_seq_device ath snd_pcm cfg80211 micro=
code snd_timer iTCO_wdt i2c_i801 iTCO_vendor_support snd r8169 pcspkr s=
erio_raw soundcore
>> mii snd_page_alloc i915 drm_kms_helper drm i2c_algo_bit video [last =
unloaded: ipt_addrtype]
>>
>> Pid: 18514, comm: btserver Tainted: P =A0 =A0 =A0 =A0 =A0 =A02.6.38-=
wl+ #53 To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O=
=2EE.M.
>> EIP: 0060:[<f993e265>] EFLAGS: 00010292 CPU: 1
>> EIP is at cifsFileInfo_put+0x10/0x1b1 [cifs]
>> EAX: 00000000 EBX: 00000000 ECX: f993e583 EDX: f086d540
>> ESI: 00000008 EDI: e65302d4 EBP: f1e9bdbc ESP: f1e9bda8
>> =A0 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>> Process btserver (pid: 18514, ti=3Df1e9a000 task=3Df4e7d280 task.ti=3D=
f1e9a000)
>> Stack:
>> =A0 00000000 00000000 f086d540 00000008 e65302d4 f1e9bdc8 f993e599 f=
086d540
>> =A0 f1e9bdec c04e39a7 f06fe300 f086d548 e65302d4 eee5b780 ffffffea e=
65302d4
>> =A0 00000000 f1e9be0c c04e1486 eee5b780 f06fe300 00000000 eee5b780 f=
1e9beec
>> Call Trace:
>> =A0 [<f993e599>] cifs_close+0x16/0x25 [cifs]
>> =A0 [<c04e39a7>] fput+0xf4/0x170
>> =A0 [<c04e1486>] __dentry_open+0x19b/0x21c
>> =A0 [<c04e163a>] lookup_instantiate_filp+0x70/0x8c
>> =A0 [<c04e0e60>] ? generic_file_open+0x0/0x58
>> =A0 [<c04e0e60>] ? generic_file_open+0x0/0x58
>> =A0 [<f993ca91>] cifs_lookup+0x2af/0x38f [cifs]
>> =A0 [<c04eaae5>] d_alloc_and_lookup+0x3d/0x54
>> =A0 [<c04ead6e>] __lookup_hash+0x6a/0x71
>> =A0 [<c04ebe0d>] do_last+0xb3/0x243
>> =A0 [<c04ed69a>] do_filp_open+0x25f/0x4a9
>> =A0 [<c04d566e>] ? __slab_alloc.clone.4+0xc6/0x203
>> =A0 [<c07e20fa>] ? _raw_spin_unlock+0x22/0x25
>> =A0 [<c04e11fd>] do_sys_open+0x49/0xc9
>> =A0 [<c04ea73a>] ? path_put+0x1a/0x1d
>> =A0 [<c04e12c9>] sys_open+0x23/0x2b
>> =A0 [<c040315c>] sysenter_do_call+0x12/0x38
>> Code: b3 4e 95 f9 68 72 4f 95 f9 e8 c4 1a ea c6 83 c4 14 8d 65 f4 31=
 c0 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 08 3e 8d 74 26 00 89 c3 <8b>=
 40 1c 8b 78 20 8b 43
>> 24 8b 40 1c 89 45 f0 8b 47 10 8b 80 8c
>> EIP: [<f993e265>] cifsFileInfo_put+0x10/0x1b1 [cifs] SS:ESP 0068:f1e=
9bda8
>> CR2: 000000000000001c
>> ---[ end trace db4167a97eeb41b3 ]---
>>
>
> Does the attached patch fix it? It's probably stable material if so..=
=2E
>
> FWIW, cifs doesn't handle O_DIRECT at all.

To get the equivalent, mount cifs with "forcedirectio"

At some point we should add support for the flag.


--=20
Thanks,

Steve
