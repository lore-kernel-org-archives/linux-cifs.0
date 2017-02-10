From: Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>
Subject: Fix SMB2_TREE_CONNECT requests with the wrong TreeId
Date: Fri, 10 Feb 2017 18:44:14 +0100
Message-ID: <25f3edd0-3abf-f541-d7f8-54ae1dbac081@fbihome.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------CFCDF53D57E538DEB27BA2AF"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------CFCDF53D57E538DEB27BA2AF
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi everyone,

I'm having problems with CIFS connections to our NAS. The vendor
inspected the problem and claimed the Linux CIFS module doesn't follow
the specifications, which causes the instabilities + shutdown problems
with our LiMux clients in our SMB2+ tests.

Quoting http://msdn.microsoft.com/en-us/library/cc246529.aspx:

"TreeId (4 bytes): Uniquely identifies the tree connect for the
command. This MUST be 0 for the SMB2 TREE_CONNECT Request."

I applied the attached "warn" diff, which resulted in the (expected)
following stack trace (albeit for an old Ubuntu kernel), but otherwise
fixes the problem.

[ 1815.635274] ------------[ cut here ]------------
[ 1815.635294] WARNING: CPU: 1 PID: 65 at
/tmp/cifs-3.13.0-100.147-patched/smb2pdu.c:164
small_smb2_init+0x246/0x560 [cifs]()
[ 1815.635295] smb2_reconnect: SMB2_TREE_CONNECT with tid != 0
[ 1815.635296] Modules linked in: nls_iso8859_1 usb_storage arc4 md4
nls_utf8 cifs(OX) fscache kav4fs_oas(OX) redirfs(OX) dm_crypt rfcomm
bnep bluetooth x86_pkg_temp_thermal intel_powerclamp coretemp
snd_hda_codec_hdmi snd_hda_codec_realtek kvm_intel kvm joydev
snd_hda_intel snd_hda_codec snd_hwdep crc32_pclmul snd_pcm
snd_page_alloc serio_raw snd_seq_midi snd_seq_midi_event lpc_ich ipmi_si
snd_rawmidi snd_seq snd_seq_device snd_timer parport_pc ppdev snd shpchp
lp mac_hid soundcore parport hid_generic usbhid hid i915 i2c_algo_bit
drm_kms_helper ahci drm r8169 libahci psmouse mii wmi video
[ 1815.635327] CPU: 1 PID: 65 Comm: kworker/1:2 Tainted: G        W  OX
3.13.0-100-generic #147-Ubuntu
[ 1815.635328] Hardware name: Acer Veriton M4630G/Veriton M4630G, BIOS
P11-C1L                 04/10/2015
[ 1815.635344] Workqueue: cifsiod cifs_writev_complete [cifs]
[ 1815.635346]  00000286 00000286 f65edd68 c165dcd2 f65edda8 f8cd0f78
f65edd98 c105798e
[ 1815.635350]  f8cd102c f65eddc4 00000041 f8cd0f78 000000a4 f8cb1df6
f8cb1df6 f4347800
[ 1815.635353]  00000044 f4452c00 f65eddb0 c10579e3 00000009 f65edda8
f8cd102c f65eddc4
[ 1815.635357] Call Trace:
[ 1815.635362]  [<c165dcd2>] dump_stack+0x58/0x72
[ 1815.635366]  [<c105798e>] warn_slowpath_common+0x7e/0xa0
[ 1815.635378]  [<f8cb1df6>] ? small_smb2_init+0x246/0x560 [cifs]
[ 1815.635390]  [<f8cb1df6>] ? small_smb2_init+0x246/0x560 [cifs]
[ 1815.635392]  [<c10579e3>] warn_slowpath_fmt+0x33/0x40
[ 1815.635404]  [<f8cb1df6>] small_smb2_init+0x246/0x560 [cifs]
[ 1815.635416]  [<f8ca1b80>] ? cifs_strtoUTF16+0xc0/0xf0 [cifs]
[ 1815.635427]  [<f8cb17f9>] SMB2_tcon+0xb9/0x470 [cifs]
[ 1815.635438]  [<f8cb2580>] ? SMB2_negotiate+0x470/0x470 [cifs]
[ 1815.635449]  [<f8cb1fc5>] small_smb2_init+0x415/0x560 [cifs]
[ 1815.635452]  [<c1092ca0>] ? prepare_to_wait_event+0xd0/0xd0
[ 1815.635464]  [<f8cb45c4>] smb2_async_writev+0x34/0x1d0 [cifs]
[ 1815.635475]  [<f8c7a8ae>] ? cifs_writedata_release+0x1e/0x30 [cifs]
[ 1815.635478]  [<c112d547>] ? clear_page_dirty_for_io+0x57/0xe0
[ 1815.635488]  [<f8c7de3a>] cifs_writev_complete+0x1aa/0x270 [cifs]
[ 1815.635491]  [<c10702ba>] process_one_work+0x11a/0x3c0
[ 1815.635493]  [<c1070f49>] worker_thread+0xf9/0x380
[ 1815.635495]  [<c1070e50>] ? rescuer_thread+0x380/0x380
[ 1815.635497]  [<c10767cb>] kthread+0x9b/0xb0
[ 1815.635500]  [<c166c037>] ret_from_kernel_thread+0x1b/0x28
[ 1815.635503]  [<c1076730>] ? kthread_create_on_node+0x140/0x140
[ 1815.635504] ---[ end trace d45909fef64cdfda ]---
[ 1815.655889] cifs_vfs_err: 2516 callbacks suppressed
[ 1815.655893] CIFS VFS: cifs_invalidate_mapping: could not invalidate
inode d92e3798

I don't know if we want to zero tcon for new connections / reconnects.
The "warn" diff was tested by a colleague and "works for him".

Thanks,

Jan-Marek

P.S. The 2nd patch without the warning was just compile-tested.

--------------CFCDF53D57E538DEB27BA2AF
Content-Type: text/x-patch;
 name="tree_connect_with_warn.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tree_connect_with_warn.diff"

--- smb2pdu.c.orig	2017-01-20 19:58:34.581064153 +0100
+++ smb2pdu.c	2017-01-20 20:19:23.124772222 +0100
@@ -172,7 +172,14 @@
 		return rc;
 
 	if (smb2_command == SMB2_TREE_CONNECT)
+	{
+		if (tcon->tid != 0)
+		{
+			WARN(1, "%s: SMB2_TREE_CONNECT with tid != 0\n", __func__);
+			tcon->tid = 0;
+		}
 		return rc;
+	}
 
 	if (tcon->tidStatus == CifsExiting) {
 		/*



--------------CFCDF53D57E538DEB27BA2AF
Content-Type: text/x-patch;
 name="0001-Reset-TreeId-to-zero-on-SMB2_TREE_CONNECT.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-Reset-TreeId-to-zero-on-SMB2_TREE_CONNECT.patch"

>From 249ab089b1c83dfbe22a1a0b37395ccd394ae1ad Mon Sep 17 00:00:00 2001
From: Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>
Date: Fri, 10 Feb 2017 16:43:46 +0100
Subject: [PATCH] Reset TreeId to zero on SMB2_TREE_CONNECT

Currently the cifs module breaks the CIFS specs as described in
http://msdn.microsoft.com/en-us/library/cc246529.aspx:

"TreeId (4 bytes): Uniquely identifies the tree connect for the
command. This MUST be 0 for the SMB2 TREE_CONNECT Request."

Signed-off-by: Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 8745722..ad1b555 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -169,7 +169,10 @@
 		return rc;
 
 	if (smb2_command == SMB2_TREE_CONNECT)
+	{
+		tcon->tid = 0;
 		return rc;
+	}
 
 	if (tcon->tidStatus == CifsExiting) {
 		/*
-- 
1.9.1


--------------CFCDF53D57E538DEB27BA2AF--
