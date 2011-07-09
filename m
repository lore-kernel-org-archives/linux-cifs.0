From: Sven-Haegar Koch <haegar-DcL44mDNY06zQB+pC5nmwQ@public.gmane.org>
Subject: Re: 3.0-rc+git OOPS losetup on cifs
Date: Sat, 9 Jul 2011 03:21:10 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1107090250240.5791@aurora>
References: <alpine.DEB.2.02.1107042132500.18300@aurora> <4E155F6F.6070506@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Linux-Kernel-Mailinglist <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E155F6F.6070506-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 7 Jul 2011, Suresh Jayaraman wrote:

> On 07/05/2011 01:18 AM, Sven-Haegar Koch wrote:
> > Since a short while (I know it worked with 3.0-rc1) loopback-mounting an 
> > image on a samba server mounted with cifs oopses the kernel.
...
> I couldn't reproduce this with 3.0-rc6 with a smaller image file (1GB).
> But I see no relevant fixes between -rc5 and -rc6.
> 
> Can you try to reproduce the same problem with a smaller non-encrypted file?

I can, and it seems something even more fundamental.

Just trying to mount something from an IP where not even a samba is 
running (aka 127.0.0.1 in my last test) crashes my kernel.

# mount -t cifs //127.0.0.1/doesnotexist /mnt/tmp

It asks for a password, I enter some random chars and press return, and 
then the kernel crashes - as "usual" nothing written to the logs.

Screenshot:
https://www.sdinet.de/tmp/cifs/IMG_20110709_022949.jpg

System:
- Kernel 3.0-rc6+ 902daf6580cffe04721250fb71b5527a98718b11
- Thinkpad T60, 3GB RAM, Core Duo processor (not Core 2)
- 32bit Debian Unstable
- cifs-utils 2:4.9-1
- gcc 4.6.1-2
- binutils 2.21.52.20110707-1

Used .config available at 
https://www.sdinet.de/tmp/cifs/config-3.0-rc6+git



A different test this morning:

(Kernel 1-2 days older than above, but still 3.0-rc6+git-something)

# grep real-backups /etc/fstab
/192.168.10.98/backups /mnt/real-backups       cifs 
username=backups,password=**removed**,uid=1000,gid=0,file_mode=0664,dir_mode=0775,rw,noauto 
0 0

# mount /mnt/real-backups

Works without errors, but then a simple:


TRY 1, wanted to create a test image on the NAS:

# dd if=/dev/zero of=/mnt/real-backups/test.img bs=1024 count=100000

Crashes with the following, luckily now something in the logs:

BUG: unable to handle kernel paging request at 3423f000
IP: [<c121e664>] __percpu_counter_add+0x14/0xa0
*pdpt = 000000003472e001 *pde = 0000000000000000 
Oops: 0000 [#1] SMP 
Modules linked in: ecb cifs cpufreq_stats acpi_pad sbs sbshc container pci_slot fan hed binfmt_misc uinput fuse nfsd nfs lockd auth_rpcgss sunrpc af_packet softdog bsd_comp ppp_deflate ppp_async ppp_generic slhc crc_ccitt fbcon font bitblit softcursor usbnet hdaps input_polldev cpufreq_userspace cpufreq_ondemand acpi_cpufreq freq_table mperf hfsplus usb_storage tun ipv6 snd_hda_codec_analog r8169 smsdvb dvb_core snd_hda_intel snd_hda_codec arc4 thinkpad_acpi mii snd_hwdep rc_hauppauge ir_lirc_codec snd_pcm_oss snd_mixer_oss iwl3945 iwl_legacy lirc_dev snd_pcm ir_sony_decoder snd_seq_oss joydev ir_jvc_decoder radeon snd_seq_midi ttm snd_rawmidi mac80211 drm_kms_helper ir_rc6_decoder drm cfg80211 pcmcia snd_seq_midi_event ir_rc5_decoder smsusb smsmdtv snd_seq ir_nec_decoder processor battery
  psmouse fb rc_core yenta_socket fbdev i2c_algo_bit 8250_pnp i2c_i801 snd_timer snd_seq_device evdev snd cfbcopyarea cfbimgblt cfbfillrect button rng_core 8250 serial_core mac_hid parport_pc
  parp
rt nvram pcmcia_rsrc serio_raw pcmcia_core rfkill video ac soundcore snd_page_alloc cbc usbhid dm_crypt dm_mod raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 linear md_mod sg sr_mod cdrom sd_mod ata_generic pata_acpi uhci_hcd ahci libahci ata_piix thermal thermal_sys libata e1000e ehci_hcd scsi_mod usbcore [last unloaded: scsi_wait_scan]

Pid: 4025, comm: dd Not tainted 3.0.0-rc6-cut1+ #19 LENOVO 2007Y2U/2007Y2U
EIP: 0060:[<c121e664>] EFLAGS: 00010096 CPU: 1
EIP is at __percpu_counter_add+0x14/0xa0
EAX: 00000000 EBX: f48ed854 ECX: 00000000 EDX: 00000001
ESI: f7084120 EDI: 00000001 EBP: f452dd30 ESP: f452dd18
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process dd (pid: 4025, ti=f452c000 task=f52e0c00 task.ti=f452c000)
Stack:
 00000000 f4d99140 f7084120 f52e0c00 f7084120 00000001 f452dd44 c108def3
 00000010 f4d99140 f7084120 f452dd58 c108dfa1 f7084120 f4d99078 00000001
 f452dd60 c108d825 f452dd98 f9ed975e 00000014 00000000 f452dd80 c102765f
Call Trace:
 [<c108def3>] account_page_dirtied+0x63/0x90
 [<c108dfa1>] __set_page_dirty_nobuffers+0x81/0x120
 [<c108d825>] set_page_dirty+0x55/0x60
 [<f9ed975e>] cifs_write_end+0x6e/0x230 [cifs]
 [<c102765f>] ? __kunmap_atomic+0x5f/0x80
 [<c1086d0e>] generic_file_buffered_write+0x12e/0x1e0
 [<c1087b9e>] __generic_file_aio_write+0x25e/0x4b0
 [<c108c81f>] ? __alloc_pages_nodemask+0xdf/0x620
 [<c10a04ff>] ? handle_mm_fault+0xef/0x170
 [<c1087e4d>] generic_file_aio_write+0x5d/0xc0
 [<c10226e0>] ? vmalloc_sync_all+0x1e0/0x1e0
 [<f9ec60ca>] cifs_file_aio_write+0x2a/0x80 [cifs]
 [<c120fadd>] ? __copy_to_user_ll+0x5d/0x70
 [<c10b5d34>] do_sync_write+0xa4/0xe0
 [<c10b9b0c>] ? cp_new_stat64+0xdc/0xf0
 [<c10226e0>] ? vmalloc_sync_all+0x1e0/0x1e0
 [<c120f958>] ? __clear_user+0x28/0x40
 [<c10b6476>] vfs_write+0x86/0x160
 [<c10b5c90>] ? wait_on_retry_sync_kiocb+0x50/0x50
 [<c10b6758>] sys_write+0x38/0x70
 [<c135779c>] sysenter_do_call+0x12/0x2c
Code: e8 b2 75 13 00 31 c0 5b 5e 5d c3 8d 74 26 00 b8 f4 ff ff ff eb f1 90 55 89 e5 83 ec 18 89 5d f4 89 c3 89 7d fc 89 75 f8 8b 40 14 
<64> 8b 30 89 f7 c1 ff 1f 01 d6 89 45 f0 8b 45 08 11 cf 89 c2 c1 
EIP: [<c121e664>] __percpu_counter_add+0x14/0xa0 SS:ESP 0068:f452dd18
CR2: 000000003423f000
---[ end trace 498d2cb13a9e8833 ]---
------------[ cut here ]------------
WARNING: at kernel/softirq.c:159 local_bh_enable+0x60/0x90()
Hardware name: 2007Y2U
Modules linked in: ecb cifs cpufreq_stats acpi_pad sbs sbshc container pci_slot fan hed binfmt_misc uinput fuse nfsd nfs lockd auth_rpcgss sunrpc af_packet softdog bsd_comp ppp_deflate ppp_async ppp_generic slhc crc_ccitt fbcon font bitblit softcursor usbnet hdaps input_polldev cpufreq_userspace cpufreq_ondemand acpi_cpufreq freq_table mperf hfsplus usb_storage tun ipv6 snd_hda_codec_analog r8169 smsdvb dvb_core snd_hda_intel snd_hda_codec arc4 thinkpad_acpi mii snd_hwdep rc_hauppauge ir_lirc_codec snd_pcm_oss snd_mixer_oss iwl3945 iwl_legacy lirc_dev snd_pcm ir_sony_decoder snd_seq_oss joydev ir_jvc_decoder radeon snd_seq_midi ttm snd_rawmidi mac80211 drm_kms_helper ir_rc6_decoder drm cfg80211 pcmcia snd_seq_midi_event ir_rc5_decoder smsusb smsmdtv snd_seq ir_nec_decoder processor battery
  psmouse fb rc_core yenta_socket fbdev i2c_algo_bit 8250_pnp i2c_i801 snd_timer snd_seq_device evdev snd cfbcopyarea cfbimgblt cfbfillrect button rng_core 8250 serial_core mac_hid parport_pc
  parp
rt nvram pcmcia_rsrc serio_raw pcmcia_core rfkill video ac soundcore snd_page_alloc cbc usbhid dm_crypt dm_mod raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 linear md_mod sg sr_mod cdrom sd_mod ata_generic pata_acpi uhci_hcd ahci libahci ata_piix thermal thermal_sys libata e1000e ehci_hcd scsi_mod usbcore [last unloaded: scsi_wait_scan]
Pid: 4025, comm: dd Tainted: G      D     3.0.0-rc6-cut1+ #19
Call Trace:
 [<c1351a69>] ? printk+0x18/0x1a
 [<c10387fd>] warn_slowpath_common+0x6d/0xa0
 [<c103dc70>] ? local_bh_enable+0x60/0x90
 [<c103dc70>] ? local_bh_enable+0x60/0x90
 [<c103884d>] warn_slowpath_null+0x1d/0x20
 [<c103dc70>] local_bh_enable+0x60/0x90
 [<c12b6f10>] lock_sock_nested+0x30/0x40
 [<c12f75f6>] tcp_sendmsg+0x16/0xaa0
 [<c120d638>] ? string.isra.4+0x28/0xb0
 [<c120d944>] ? symbol_string.isra.8+0x64/0xa0
 [<c1317844>] inet_sendmsg+0x44/0xa0
 [<c12b4273>] sock_sendmsg+0xc3/0xf0
 [<c108bd10>] ? free_pages_prepare+0xd0/0x100
 [<c108d4bf>] ? __pagevec_free+0x1f/0x30
 [<c12b42cf>] kernel_sendmsg+0x2f/0x50
 [<f9ee3a6d>] smb_sendv+0xcd/0x310 [cifs]
 [<f9ee4667>] SendReceive2+0x147/0x2d0 [cifs]
 [<f9ee4824>] SendReceiveNoRsp+0x34/0x40 [cifs]
 [<f9eca856>] CIFSSMBClose+0x86/0x110 [cifs]
 [<f9eda1fa>] cifsFileInfo_put+0xba/0x1f0 [cifs]
 [<f9eda882>] cifs_close+0x12/0x20 [cifs]
 [<c10b79f8>] fput+0xb8/0x1e0
 [<c10b466f>] filp_close+0x4f/0x70
 [<c103b9f3>] put_files_struct+0x63/0xb0
 [<c103baca>] exit_files+0x3a/0x50
 [<c103c02e>] do_exit+0x54e/0x710
 [<c1004a94>] ? show_registers+0x84/0x1b0
 [<c1351a69>] ? printk+0x18/0x1a
 [<c1005830>] oops_end+0x70/0x90
 [<c1351a69>] ? printk+0x18/0x1a
 [<c1351403>] no_context+0x173/0x17b
 [<c1351526>] __bad_area_nosemaphore+0x11b/0x123
 [<c102d484>] ? update_cfs_load+0x204/0x2d0
 [<c1351575>] bad_area+0x33/0x39
 [<c10226e0>] ? vmalloc_sync_all+0x1e0/0x1e0
 [<c1022a44>] do_page_fault+0x364/0x3d0
 [<c108c81f>] ? __alloc_pages_nodemask+0xdf/0x620
 [<c10226e0>] ? vmalloc_sync_all+0x1e0/0x1e0
 [<c1357516>] error_code+0x5a/0x60
 [<c10226e0>] ? vmalloc_sync_all+0x1e0/0x1e0
 [<c121e664>] ? __percpu_counter_add+0x14/0xa0
 [<c108def3>] account_page_dirtied+0x63/0x90
 [<c108dfa1>] __set_page_dirty_nobuffers+0x81/0x120
 [<c108d825>] set_page_dirty+0x55/0x60
 [<f9ed975e>] cifs_write_end+0x6e/0x230 [cifs]
 [<c102765f>] ? __kunmap_atomic+0x5f/0x80
 [<c1086d0e>] generic_file_buffered_write+0x12e/0x1e0
 [<c1087b9e>] __generic_file_aio_write+0x25e/0x4b0
 [<c108c81f>] ? __alloc_pages_nodemask+0xdf/0x620
 [<c10a04ff>] ? handle_mm_fault+0xef/0x170
 [<c1087e4d>] generic_file_aio_write+0x5d/0xc0
 [<c10226e0>] ? vmalloc_sync_all+0x1e0/0x1e0
 [<f9ec60ca>] cifs_file_aio_write+0x2a/0x80 [cifs]
 [<c120fadd>] ? __copy_to_user_ll+0x5d/0x70
 [<c10b5d34>] do_sync_write+0xa4/0xe0
 [<c10b9b0c>] ? cp_new_stat64+0xdc/0xf0
 [<c10226e0>] ? vmalloc_sync_all+0x1e0/0x1e0
 [<c120f958>] ? __clear_user+0x28/0x40
 [<c10b6476>] vfs_write+0x86/0x160
 [<c10b5c90>] ? wait_on_retry_sync_kiocb+0x50/0x50
 [<c10b6758>] sys_write+0x38/0x70
 [<c135779c>] sysenter_do_call+0x12/0x2c
---[ end trace 498d2cb13a9e8834 ]---


TRY 2:

Reboot, mount again, then

# echo test >/mnt/real-backups/foo

Crash again, looks nearly the same (diff between above crash and the new 
one):

--- /tmp/cifs1.1.txt	2011-07-09 03:17:30.000000000 +0200
+++ /tmp/cifs2.1.txt	2011-07-09 03:17:33.000000000 +0200
@@ -1,54 +1,53 @@
 BUG: unable to handle kernel paging request at 3423f000
 IP: [<c121e664>] __percpu_counter_add+0x14/0xa0
-*pdpt = 000000003472e001 *pde = 0000000000000000 
+*pdpt = 00000000349c4001 *pde = 0000000000000000 
 Oops: 0000 [#1] SMP 
-Modules linked in: ecb cifs cpufreq_stats acpi_pad sbs sbshc container pci_slot fan hed binfmt_misc uinput fuse nfsd nfs lockd auth_rpcgss sunrpc af_packet softdog bsd_comp ppp_deflate ppp_async ppp_generic slhc crc_ccitt fbcon font bitblit softcursor usbnet hdaps input_polldev cpufreq_userspace cpufreq_ondemand acpi_cpufreq freq_table mperf hfsplus usb_storage tun ipv6 snd_hda_codec_analog r8169 smsdvb dvb_core snd_hda_intel snd_hda_codec arc4 thinkpad_acpi mii snd_hwdep rc_hauppauge ir_lirc_codec snd_pcm_oss snd_mixer_oss iwl3945 iwl_legacy lirc_dev snd_pcm ir_sony_decoder snd_seq_oss joydev ir_jvc_decoder radeon snd_seq_midi ttm snd_rawmidi mac80211 drm_kms_helper ir_rc6_decoder drm cfg80211 pcmcia snd_seq_midi_event ir_rc5_decoder smsusb smsmdtv snd_seq ir_nec_decoder processor batter
 y psmouse fb rc_core yenta_socket fbdev i2c_algo_bit 8250_pnp i2c_i801 snd_timer snd_seq_device evdev snd cfbcopyarea cfbimgblt cfbfillrect button rng_core 8250 serial_core mac_hid parport_p
 c parp
-rt nvram pcmcia_rsrc serio_raw pcmcia_core rfkill video ac soundcore snd_page_alloc cbc usbhid dm_crypt dm_mod raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 linear md_mod sg sr_mod cdrom sd_mod ata_generic pata_acpi uhci_hcd ahci libahci ata_piix thermal thermal_sys libata e1000e ehci_hcd scsi_mod usbcore [last unloaded: scsi_wait_scan]
+Modules linked in: ecb cifs cpufreq_stats acpi_pad sbs sbshc container pci_slot fan hed binfmt_misc uinput fuse nfsd nfs lockd auth_rpcgss sunrpc af_packet softdog bsd_comp ppp_deflate ppp_async ppp_generic slhc crc_ccitt fbcon font bitblit softcursor usbnet hdaps input_polldev cpufreq_userspace cpufreq_ondemand acpi_cpufreq freq_table mperf hfsplus usb_storage tun ipv6 smsdvb dvb_core rc_hauppauge snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep ir_lirc_codec snd_pcm_oss snd_mixer_oss snd_pcm lirc_dev r8169 ir_sony_decoder arc4 thinkpad_acpi ir_jvc_decoder snd_seq_oss mii iwl3945 iwl_legacy ir_rc6_decoder snd_seq_midi joydev radeon ttm snd_rawmidi mac80211 drm_kms_helper drm ir_rc5_decoder smsusb cfg80211 snd_seq_midi_event pcmcia smsmdtv fb snd_seq ir_nec_decoder rc_core snd_t
 imer snd_seq_device snd processor battery fbdev 8250_pnp yenta_socket rfkill i2c_algo_bit 8250 soundcore pcmcia_rsrc psmouse evdev serial_core cfbcopyarea cfbimgblt cfbfillrect serio_raw mac
 _hid p
+mcia_core i2c_i801 rng_core video nvram ac snd_page_alloc button parport_pc parport cbc usbhid dm_crypt dm_mod raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 linear md_mod sg sr_mod sd_mod cdrom ata_generic pata_acpi thermal thermal_sys ahci libahci ata_piix uhci_hcd libata scsi_mod ehci_hcd e1000e usbcore [last unloaded: scsi_wait_scan]
 
-Pid: 4025, comm: dd Not tainted 3.0.0-rc6-cut1+ #19 LENOVO 2007Y2U/2007Y2U
+Pid: 3979, comm: bash Not tainted 3.0.0-rc6-cut1+ #19 LENOVO 2007Y2U/2007Y2U
 EIP: 0060:[<c121e664>] EFLAGS: 00010096 CPU: 1
 EIP is at __percpu_counter_add+0x14/0xa0
-EAX: 00000000 EBX: f48ed854 ECX: 00000000 EDX: 00000001
-ESI: f7084120 EDI: 00000001 EBP: f452dd30 ESP: f452dd18
+EAX: 00000000 EBX: f4619e54 ECX: 00000000 EDX: 00000001
+ESI: f70e4580 EDI: 00000001 EBP: f475dd30 ESP: f475dd18
  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
-Process dd (pid: 4025, ti=f452c000 task=f52e0c00 task.ti=f452c000)
+78]: pam_unix(login:session): session closed for user root
+Process bash (pid: 3979, ti=f475c000 task=f4986810 task.ti=f475c000)
 Stack:
- 00000000 f4d99140 f7084120 f52e0c00 f7084120 00000001 f452dd44 c108def3
- 00000010 f4d99140 f7084120 f452dd58 c108dfa1 f7084120 f4d99078 00000001
- f452dd60 c108d825 f452dd98 f9ed975e 00000014 00000000 f452dd80 c102765f
+ 00000000 f4f91140 f70e4580 f4986810 f70e4580 00000001 f475dd44 c108def3
+ 00000010 f4f91140 f70e4580 f475dd58 c108dfa1 f70e4580 f4f91078 00000005
+ f475dd60 c108d825 f475dd98 f9ef975e 00000014 00000000 f475dd80 c102765f
 Call Trace:
  [<c108def3>] account_page_dirtied+0x63/0x90
  [<c108dfa1>] __set_page_dirty_nobuffers+0x81/0x120
  [<c108d825>] set_page_dirty+0x55/0x60
- [<f9ed975e>] cifs_write_end+0x6e/0x230 [cifs]
+ [<f9ef975e>] cifs_write_end+0x6e/0x230 [cifs]
  [<c102765f>] ? __kunmap_atomic+0x5f/0x80
  [<c1086d0e>] generic_file_buffered_write+0x12e/0x1e0
  [<c1087b9e>] __generic_file_aio_write+0x25e/0x4b0
- [<c108c81f>] ? __alloc_pages_nodemask+0xdf/0x620
- [<c10a04ff>] ? handle_mm_fault+0xef/0x170
+ [<c10be840>] ? acl_permission_check+0x70/0xa0
+ [<c109ca28>] ? __do_fault+0x3a8/0x4a0
  [<c1087e4d>] generic_file_aio_write+0x5d/0xc0
- [<c10226e0>] ? vmalloc_sync_all+0x1e0/0x1e0
- [<f9ec60ca>] cifs_file_aio_write+0x2a/0x80 [cifs]
- [<c120fadd>] ? __copy_to_user_ll+0x5d/0x70
+ [<f9ee60ca>] cifs_file_aio_write+0x2a/0x80 [cifs]
  [<c10b5d34>] do_sync_write+0xa4/0xe0
- [<c10b9b0c>] ? cp_new_stat64+0xdc/0xf0
  [<c10226e0>] ? vmalloc_sync_all+0x1e0/0x1e0
- [<c120f958>] ? __clear_user+0x28/0x40
+ [<c102286b>] ? do_page_fault+0x18b/0x3d0
  [<c10b6476>] vfs_write+0x86/0x160
+ [<c10c3348>] ? sys_dup3+0xc8/0x120
  [<c10b5c90>] ? wait_on_retry_sync_kiocb+0x50/0x50
  [<c10b6758>] sys_write+0x38/0x70
  [<c135779c>] sysenter_do_call+0x12/0x2c
 Code: e8 b2 75 13 00 31 c0 5b 5e 5d c3 8d 74 26 00 b8 f4 ff ff ff eb f1 90 55 89 e5 83 ec 18 89 5d f4 89 c3 89 7d fc 89 75 f8 8b 40 14 
 <64> 8b 30 89 f7 c1 ff 1f 01 d6 89 45 f0 8b 45 08 11 cf 89 c2 c1 
-EIP: [<c121e664>] __percpu_counter_add+0x14/0xa0 SS:ESP 0068:f452dd18
+EIP: [<c121e664>] __percpu_counter_add+0x14/0xa0 SS:ESP 0068:f475dd18
 CR2: 000000003423f000
----[ end trace 498d2cb13a9e8833 ]---
+---[ end trace 271550c8685c3e2d ]---
 ------------[ cut here ]------------
 WARNING: at kernel/softirq.c:159 local_bh_enable+0x60/0x90()
 Hardware name: 2007Y2U
-Modules linked in: ecb cifs cpufreq_stats acpi_pad sbs sbshc container pci_slot fan hed binfmt_misc uinput fuse nfsd nfs lockd auth_rpcgss sunrpc af_packet softdog bsd_comp ppp_deflate ppp_async ppp_generic slhc crc_ccitt fbcon font bitblit softcursor usbnet hdaps input_polldev cpufreq_userspace cpufreq_ondemand acpi_cpufreq freq_table mperf hfsplus usb_storage tun ipv6 snd_hda_codec_analog r8169 smsdvb dvb_core snd_hda_intel snd_hda_codec arc4 thinkpad_acpi mii snd_hwdep rc_hauppauge ir_lirc_codec snd_pcm_oss snd_mixer_oss iwl3945 iwl_legacy lirc_dev snd_pcm ir_sony_decoder snd_seq_oss joydev ir_jvc_decoder radeon snd_seq_midi ttm snd_rawmidi mac80211 drm_kms_helper ir_rc6_decoder drm cfg80211 pcmcia snd_seq_midi_event ir_rc5_decoder smsusb smsmdtv snd_seq ir_nec_decoder processor batter
 y psmouse fb rc_core yenta_socket fbdev i2c_algo_bit 8250_pnp i2c_i801 snd_timer snd_seq_device evdev snd cfbcopyarea cfbimgblt cfbfillrect button rng_core 8250 serial_core mac_hid parport_p
 c parp
-rt nvram pcmcia_rsrc serio_raw pcmcia_core rfkill video ac soundcore snd_page_alloc cbc usbhid dm_crypt dm_mod raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 linear md_mod sg sr_mod cdrom sd_mod ata_generic pata_acpi uhci_hcd ahci libahci ata_piix thermal thermal_sys libata e1000e ehci_hcd scsi_mod usbcore [last unloaded: scsi_wait_scan]
-Pid: 4025, comm: dd Tainted: G      D     3.0.0-rc6-cut1+ #19
+Modules linked in: ecb cifs cpufreq_stats acpi_pad sbs sbshc container pci_slot fan hed binfmt_misc uinput fuse nfsd nfs lockd auth_rpcgss sunrpc af_packet softdog bsd_comp ppp_deflate ppp_async ppp_generic slhc crc_ccitt fbcon font bitblit softcursor usbnet hdaps input_polldev cpufreq_userspace cpufreq_ondemand acpi_cpufreq freq_table mperf hfsplus usb_storage tun ipv6 smsdvb dvb_core rc_hauppauge snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep ir_lirc_codec snd_pcm_oss snd_mixer_oss snd_pcm lirc_dev r8169 ir_sony_decoder arc4 thinkpad_acpi ir_jvc_decoder snd_seq_oss mii iwl3945 iwl_legacy ir_rc6_decoder snd_seq_midi joydev radeon ttm snd_rawmidi mac80211 drm_kms_helper drm ir_rc5_decoder smsusb cfg80211 snd_seq_midi_event pcmcia smsmdtv fb snd_seq ir_nec_decoder rc_core snd_t
 imer snd_seq_device snd processor battery fbdev 8250_pnp yenta_socket rfkill i2c_algo_bit 8250 soundcore pcmcia_rsrc psmouse evdev serial_core cfbcopyarea cfbimgblt cfbfillrect serio_raw mac
 _hid p
+mcia_core i2c_i801 rng_core video nvram ac snd_page_alloc button parport_pc parport cbc usbhid dm_crypt dm_mod raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 linear md_mod sg sr_mod sd_mod cdrom ata_generic pata_acpi thermal thermal_sys ahci libahci ata_piix uhci_hcd libata scsi_mod ehci_hcd e1000e usbcore [last unloaded: scsi_wait_scan]
+Pid: 3979, comm: bash Tainted: G      D     3.0.0-rc6-cut1+ #19
 Call Trace:
  [<c1351a69>] ? printk+0x18/0x1a
  [<c10387fd>] warn_slowpath_common+0x6d/0xa0
@@ -65,12 +64,12 @@
  [<c108bd10>] ? free_pages_prepare+0xd0/0x100
  [<c108d4bf>] ? __pagevec_free+0x1f/0x30
  [<c12b42cf>] kernel_sendmsg+0x2f/0x50
- [<f9ee3a6d>] smb_sendv+0xcd/0x310 [cifs]
- [<f9ee4667>] SendReceive2+0x147/0x2d0 [cifs]
- [<f9ee4824>] SendReceiveNoRsp+0x34/0x40 [cifs]
- [<f9eca856>] CIFSSMBClose+0x86/0x110 [cifs]
- [<f9eda1fa>] cifsFileInfo_put+0xba/0x1f0 [cifs]
- [<f9eda882>] cifs_close+0x12/0x20 [cifs]
+ [<f9f03a6d>] smb_sendv+0xcd/0x310 [cifs]
+ [<f9f04667>] SendReceive2+0x147/0x2d0 [cifs]
+ [<f9f04824>] SendReceiveNoRsp+0x34/0x40 [cifs]
+ [<f9eea856>] CIFSSMBClose+0x86/0x110 [cifs]
+ [<f9efa1fa>] cifsFileInfo_put+0xba/0x1f0 [cifs]
+ [<f9efa882>] cifs_close+0x12/0x20 [cifs]
  [<c10b79f8>] fput+0xb8/0x1e0
  [<c10b466f>] filp_close+0x4f/0x70
  [<c103b9f3>] put_files_struct+0x63/0xb0
@@ -94,22 +93,20 @@
  [<c108def3>] account_page_dirtied+0x63/0x90
  [<c108dfa1>] __set_page_dirty_nobuffers+0x81/0x120
  [<c108d825>] set_page_dirty+0x55/0x60
- [<f9ed975e>] cifs_write_end+0x6e/0x230 [cifs]
+ [<f9ef975e>] cifs_write_end+0x6e/0x230 [cifs]
  [<c102765f>] ? __kunmap_atomic+0x5f/0x80
  [<c1086d0e>] generic_file_buffered_write+0x12e/0x1e0
  [<c1087b9e>] __generic_file_aio_write+0x25e/0x4b0
- [<c108c81f>] ? __alloc_pages_nodemask+0xdf/0x620
- [<c10a04ff>] ? handle_mm_fault+0xef/0x170
+ [<c10be840>] ? acl_permission_check+0x70/0xa0
+ [<c109ca28>] ? __do_fault+0x3a8/0x4a0
  [<c1087e4d>] generic_file_aio_write+0x5d/0xc0
- [<c10226e0>] ? vmalloc_sync_all+0x1e0/0x1e0
- [<f9ec60ca>] cifs_file_aio_write+0x2a/0x80 [cifs]
- [<c120fadd>] ? __copy_to_user_ll+0x5d/0x70
+ [<f9ee60ca>] cifs_file_aio_write+0x2a/0x80 [cifs]
  [<c10b5d34>] do_sync_write+0xa4/0xe0
- [<c10b9b0c>] ? cp_new_stat64+0xdc/0xf0
  [<c10226e0>] ? vmalloc_sync_all+0x1e0/0x1e0
- [<c120f958>] ? __clear_user+0x28/0x40
+ [<c102286b>] ? do_page_fault+0x18b/0x3d0
  [<c10b6476>] vfs_write+0x86/0x160
+ [<c10c3348>] ? sys_dup3+0xc8/0x120
  [<c10b5c90>] ? wait_on_retry_sync_kiocb+0x50/0x50
  [<c10b6758>] sys_write+0x38/0x70
  [<c135779c>] sysenter_do_call+0x12/0x2c
----[ end trace 498d2cb13a9e8834 ]---
+---[ end trace 271550c8685c3e2e ]---


Any idea how to debug this further?

Any additional infos I can supply?

As so simple things fail it may be something specific to my setup, 
otherwise there would have already been lots of reports of it.

(But I think I can exclude hardware problems as it works with the 2.6.39 
debian kernel)

c'ya
sven-haegar

-- 
Three may keep a secret, if two of them are dead.
- Ben F.
