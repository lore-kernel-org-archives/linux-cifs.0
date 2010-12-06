From: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
Subject: Kernel oops on 2.6.37-rc3, accessing remote DFS links
Date: Mon, 6 Dec 2010 12:58:38 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012061247180.31332@awakenings.cable.ziggo.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

While troubleshooting a DFS issue, I hit a kernel panic:

foxdft13 = DFS root
foxdft08 = file server, serving "Global" share

# mount -t cifs //foxdft13.fox.local/company /mnt/bla/ -o 
credentials=/creds,sec=ntlmv2,dom=fox
# ls -la /mnt/bla/Global/

  fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 603 with 
uid: 0
  fs/cifs/inode.c: Revalidate: \\foxdft13.fox.local\company\Global inode 
0xe289aaac count 1 dentry: 0xda8c53b8 d_time 151744140 jiffies 151765235
  fs/cifs/inode.c: Getting info on \\foxdft13.fox.local\company\Global
  fs/cifs/transport.c: For smb_command 50
  fs/cifs/transport.c: Sending smb:  total_len 148
  fs/cifs/connect.c: rfc1002 length 0x27
  fs/cifs/connect.c: invalid transact2 word count
  Status code returned 0xc0000257 NT_STATUS_PATH_NOT_COVERED
  fs/cifs/netmisc.c: Mapping smb error code 3 to POSIX err -66
  fs/cifs/cifssmb.c: Send error in QPathInfo = -66
  fs/cifs/inode.c: creating fake fattr for DFS referral
  fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 62
  fs/cifs/inode.c: cifs_revalidate_cache: invalidating inode 62 mapping
  fs/cifs/inode.c: inode 0xe289aaac old_time=151744140 new_time=151765237
  fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 603) rc 
= 0
  fs/cifs/cifs_dfs_ref.c: in cifs_dfs_follow_mountpoint
  fs/cifs/cifs_dfs_ref.c: CIFS VFS: in cifs_dfs_follow_mountpoint as Xid: 
604 with uid: 0
  fs/cifs/cifssmb.c: In GetDFSRefer the path 
\foxdft13.fox.local\company\Global
  fs/cifs/transport.c: For smb_command 50
  fs/cifs/transport.c: Sending smb:  total_len 144
  fs/cifs/connect.c: rfc1002 length 0x124
  fs/cifs/cifssmb.c: Decoding GetDFSRefer response BCC: 233  Offset 56
  fs/cifs/cifssmb.c: num_referrals: 1 dfs flags: 0x2 ...

  fs/cifs/cifs_dfs_ref.c: DFS: ref path: \foxdft13.fox.local\company\Global
  fs/cifs/cifs_dfs_ref.c: DFS: node path: \foxdft08\company\Global
  fs/cifs/cifs_dfs_ref.c: DFS: fl: 2, srv_type: 0
  fs/cifs/cifs_dfs_ref.c: DFS: ref_flags: 0, path_consumed: 34
  fs/cifs/dns_resolve.c: dns_resolve_server_name_to_ip: resolved: foxdft08 
to 10.0.0.72
  fs/cifs/cifsfs.c: Devname: \\foxdft08\company flags: 0
  fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 605 with uid: 0
  fs/cifs/connect.c: Domain name set
  fs/cifs/connect.c: prefix path /Global
  fs/cifs/connect.c: Username: vmtest
  fs/cifs/connect.c: UNC: \\foxdft08\company ip: 10.0.0.72
  fs/cifs/connect.c: Existing tcp session with server found
  fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 606 with uid: 0
  fs/cifs/connect.c: Existing smb sess found (status=1)
  fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 606) rc = 0
  fs/cifs/connect.c: file mode: 0x1ed  dir mode: 0x1ed
  fs/cifs/connect.c: Found match on UNC path
  fs/cifs/connect.c: cifs_put_smb_ses: ses_count=2

  fs/cifs/cifssmb.c: In QFSDeviceInfo
  fs/cifs/transport.c: For smb_command 50
  fs/cifs/transport.c: Sending smb:  total_len 72
  fs/cifs/connect.c: rfc1002 length 0x44
  fs/cifs/cifssmb.c: In QFSAttributeInfo
  fs/cifs/transport.c: For smb_command 50
  fs/cifs/transport.c: Sending smb:  total_len 72
  fs/cifs/connect.c: rfc1002 length 0x50
  BUG: unable to handle kernel NULL pointer dereference at 0000001c
  IP: [<f909e327>] cifs_sb_master_tcon+0x3/0x7 [cifs]
  *pde = 00000000
  Oops: 0000 [#2] SMP
  last sysfs file: /sys/devices/virtual/bdi/cifs-183/uevent
  Modules linked in: cifs hmac nls_utf8 nls_base xfs exportfs loop 
parport_pc snd_pcm parport tpm_tis tpm tpm_bios snd_timer snd soundcore 
psmouse snd_page_alloc pcspkr evdev serio_raw i2c_piix4 shpchp i2c_core 
pci_hotplug ac container processor thermal_sys button ext3 jbd mbcache 
sd_mod crc_t10dif ide_cd_mod cdrom ata_generic ata_piix libata floppy 
e1000 mptspi piix mptscsih mptbase scsi_transport_spi ide_core scsi_mod 
[last unloaded: cifs]

  Pid: 1504, comm: ls Tainted: G      D     2.6.37-rc3 #1 440BX Desktop 
Reference Platform/VMware Virtual Platform
  EIP: 0060:[<f909e327>] EFLAGS: 00010292 CPU: 2
  EIP is at cifs_sb_master_tcon+0x3/0x7 [cifs]
  EAX: 00000000 EBX: f7031400 ECX: 00000000 EDX: 00000000
  ESI: 00000000 EDI: f70c4000 EBP: f70c4000 ESP: f37c7d30
   DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
  Process ls (pid: 1504, ti=f37c6000 task=f50a69a0 task.ti=f37c6000)
  Stack:
   f90aa3ab 0000004c 00000007 f4380000 f7031400 00000000 f7031100 f70c4000
   f90a2a79 f70c5200 c127c977 f72affff f501b600 0000025d ef110540 f72a6718
   f70c5e00 00000000 ef110540 f50a69a0 f50a69a0 f70c4174 f72a6728 00007d9c
  Call Trace:
   [<f90aa3ab>] ? cifs_build_path_to_root+0x17/0xe5 [cifs]
   [<f90a2a79>] ? cifs_mount+0x19f0/0x1e3f [cifs]
   [<c127c977>] ? _raw_spin_lock_bh+0x8/0x1e
   [<f90958f9>] ? cifs_do_mount+0x110/0x247 [cifs]
   [<f90957e9>] ? cifs_do_mount+0x0/0x247 [cifs]
   [<c10b8331>] ? vfs_kern_mount+0x9f/0x185
   [<f90b4c03>] ? cifs_dfs_follow_mountpoint+0x233/0x3cc [cifs]
   [<c10bebab>] ? do_follow_link+0xb6/0x1b1
   [<c10bef38>] ? link_path_walk+0x292/0x372
   [<c10bf0da>] ? path_walk+0x4f/0xae
   [<c10bf20b>] ? do_path_lookup+0x1f/0x69
   [<c10bfaa8>] ? user_path_at+0x37/0x5f
   [<c1098b0d>] ? vma_prio_tree_insert+0x17/0x2d
   [<c10b99b1>] ? vfs_fstatat+0x2a/0x50
   [<c10b9a18>] ? vfs_lstat+0x13/0x15
   [<c10b9a29>] ? sys_lstat64+0xf/0x23
   [<c1052a6c>] ? sys_futex+0xfe/0x112
   [<c10b503c>] ? filp_close+0x4e/0x54
   [<c127f339>] ? do_page_fault+0x0/0x36b
   [<c1002f9f>] ? sysenter_do_call+0x12/0x28
  Code: c8 59 5f 39 ee 0f 8c 49 ff ff ff 8b 44 24 60 65 33 05 14 00 00 00 
74 05 e8 3f 0c f9 c7 83 c4 64 5b 5e 5f 5d c3 90 90 90 8b 40 08 <8b> 40 1c 
c3 55 89 c5 83 3d a4 47 3b c1 00 57 89 d7 56 89 ce 53
  EIP: [<f909e327>] cifs_sb_master_tcon+0x3/0x7 [cifs] SS:ESP 0068:f37c7d30
  CR2: 000000000000001c
  ---[ end trace 9642afdeb896e709 ]---

Any ideas?

Regards,

-- 
Robbert
