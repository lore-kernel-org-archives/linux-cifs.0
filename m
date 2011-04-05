From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Repeatable crash in 2.6.38 related to O_DIRECT
Date: Tue, 05 Apr 2011 15:46:08 -0700
Message-ID: <4D9B9BB0.3030604@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When we try to create files with O_DIRECT on cifs file systems,
we get a repeatable crash in 2.6.38.2 (plus hacks, but no hacks to
cifs)

It crashes in cifsFileInfo_put, probably because cif_file->dentry
is NULL, but I'm still working on confirming that.

Assuming that is the cause, any ideas on how to go about fixing
this properly?

(gdb) l *(cifsFileInfo_put+0x10)
0xfd59 is in cifsFileInfo_put (/home/greearb/git/linux-2.6.dev.38.y/fs/cifs/file.c:287).
282	 * the filehandle out on the server. Must be called without holding
283	 * cifs_file_list_lock.
284	 */
285	void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
286	{
287		struct inode *inode = cifs_file->dentry->d_inode;
288		struct cifsTconInfo *tcon = tlink_tcon(cifs_file->tlink);
289		struct cifsInodeInfo *cifsi = CIFS_I(inode);
290		struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
291		struct cifsLockInfo *li, *tmp;


BUG: unable to handle kernel NULL pointer dereference at 0000001c
IP: [<f993e265>] cifsFileInfo_put+0x10/0x1b1 [cifs]
*pde = 7efaa067
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:03:00.0/net/wlan0/flags
Modules linked in: md4 nls_utf8 cifs xt_CT iptable_raw ipt_addrtype xt_DSCP xt_dscp xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_iprange xt_hashlimit 
xt_connmark veth cryptd aes_i586 aes_generic xt_TPROXY nf_tproxy_core xt_socket ip6_tables nf_defrag_ipv6 xt_connlimit 8021q garp stp llc fuse macvlan pktgen 
coretemp hwmon nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput arc4 ecb ath9k snd_hda_codec_realtek mac80211 snd_hda_intel snd_hda_codec ath9k_common 
snd_hwdep snd_seq ath9k_hw snd_seq_device ath snd_pcm cfg80211 microcode snd_timer iTCO_wdt i2c_i801 iTCO_vendor_support snd r8169 pcspkr serio_raw soundcore 
mii snd_page_alloc i915 drm_kms_helper drm i2c_algo_bit video [last unloaded: ipt_addrtype]

Pid: 18514, comm: btserver Tainted: P            2.6.38-wl+ #53 To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M.
EIP: 0060:[<f993e265>] EFLAGS: 00010292 CPU: 1
EIP is at cifsFileInfo_put+0x10/0x1b1 [cifs]
EAX: 00000000 EBX: 00000000 ECX: f993e583 EDX: f086d540
ESI: 00000008 EDI: e65302d4 EBP: f1e9bdbc ESP: f1e9bda8
  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process btserver (pid: 18514, ti=f1e9a000 task=f4e7d280 task.ti=f1e9a000)
Stack:
  00000000 00000000 f086d540 00000008 e65302d4 f1e9bdc8 f993e599 f086d540
  f1e9bdec c04e39a7 f06fe300 f086d548 e65302d4 eee5b780 ffffffea e65302d4
  00000000 f1e9be0c c04e1486 eee5b780 f06fe300 00000000 eee5b780 f1e9beec
Call Trace:
  [<f993e599>] cifs_close+0x16/0x25 [cifs]
  [<c04e39a7>] fput+0xf4/0x170
  [<c04e1486>] __dentry_open+0x19b/0x21c
  [<c04e163a>] lookup_instantiate_filp+0x70/0x8c
  [<c04e0e60>] ? generic_file_open+0x0/0x58
  [<c04e0e60>] ? generic_file_open+0x0/0x58
  [<f993ca91>] cifs_lookup+0x2af/0x38f [cifs]
  [<c04eaae5>] d_alloc_and_lookup+0x3d/0x54
  [<c04ead6e>] __lookup_hash+0x6a/0x71
  [<c04ebe0d>] do_last+0xb3/0x243
  [<c04ed69a>] do_filp_open+0x25f/0x4a9
  [<c04d566e>] ? __slab_alloc.clone.4+0xc6/0x203
  [<c07e20fa>] ? _raw_spin_unlock+0x22/0x25
  [<c04e11fd>] do_sys_open+0x49/0xc9
  [<c04ea73a>] ? path_put+0x1a/0x1d
  [<c04e12c9>] sys_open+0x23/0x2b
  [<c040315c>] sysenter_do_call+0x12/0x38
Code: b3 4e 95 f9 68 72 4f 95 f9 e8 c4 1a ea c6 83 c4 14 8d 65 f4 31 c0 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 08 3e 8d 74 26 00 89 c3 <8b> 40 1c 8b 78 20 8b 43 
24 8b 40 1c 89 45 f0 8b 47 10 8b 80 8c
EIP: [<f993e265>] cifsFileInfo_put+0x10/0x1b1 [cifs] SS:ESP 0068:f1e9bda8
CR2: 000000000000001c
---[ end trace db4167a97eeb41b3 ]---

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
