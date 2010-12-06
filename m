From: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
Subject: Re: [PATCH] cifs: allow calling cifs_build_path_to_root on incomplete
 cifs_sb
Date: Mon, 06 Dec 2010 22:39:37 +0100
Message-ID: <4CFD5819.60609@exx.nl>
References: <20101206070846.1f2c35d4@tlielax.poochiereds.net>	<1291637703-10989-1-git-send-email-jlayton@redhat.com>	<4CFD35A2.7080407@exx.nl> <20101206143423.74d8e236@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101206143423.74d8e236-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hey Jeff,

This patch fixes the oops, and the remote DFS link is readable. Great!

Thanks!
Robbert

Op 6-12-2010 20:34, Jeff Layton schreef:
> On Mon, 06 Dec 2010 20:12:34 +0100
> Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org> wrote:
> 
>> Hi Jeff,
>>
>> Op 6-12-2010 13:15, Jeff Layton schreef:
>>> It's possible that cifs_mount will call cifs_build_path_to_root on a
>>> newly instantiated cifs_sb. In that case, it's likely that the
>>> master_tlink pointer has not yet been instantiated.
>>>
>>> Fix this by having cifs_build_path_to_root take a cifsTconInfo pointer
>>> as well, and have the caller pass that in.
>>
>> I still get an oops on 2.6.37-rc4-git5 with the patch applied:
>>
>>  BUG: unable to handle kernel NULL pointer dereference at 0000001c
>>  IP: [<f8fd533b>] cifs_sb_master_tcon+0x3/0x7 [cifs]
>>  *pde = 00000000
>>  Oops: 0000 [#1] SMP
>>  last sysfs file: /sys/devices/virtual/bdi/cifs-2/uevent
>>  Modules linked in: hmac nls_utf8 cifs nls_base xfs exportfs loop
>> snd_pcm parport_pc parport tpm_tis tpm tpm_bios snd_timer snd soundcore
>> snd_page_alloc psmouse evdev pcspkr serio_raw i2c_piix4 i2c_core shpchp
>> container pci_hotplug processor thermal_sys ac button ext3 jbd mbcache
>> sd_mod crc_t10dif ide_cd_mod cdrom ata_generic ata_piix libata floppy
>> e1000 mptspi mptscsih mptbase scsi_transport_spi scsi_mod piix ide_core
>> [last unloaded: scsi_wait_scan]
>>
>>  Pid: 1362, comm: ls Not tainted 2.6.37-rc4-git5 #2 440BX Desktop
>> Reference Platform/VMware Virtual Platform
>>  EIP: 0060:[<f8fd533b>] EFLAGS: 00010286 CPU: 0
>>  EIP is at cifs_sb_master_tcon+0x3/0x7 [cifs]
>>  EAX: 00000000 EBX: f7156800 ECX: 40000040 EDX: 00000002
>>  ESI: f7156800 EDI: f7156a00 EBP: 00000000 ESP: f72fddb0
>>   DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
>>  Process ls (pid: 1362, ti=f72fc000 task=f71379e0 task.ti=f72fc000)
>>  Stack:
>>   f8fe14f3 002c80d0 00000000 f7156a00 f7156800 00000000 00000000 f8fcc96b
>>   0000007f f7156838 f5073d80 f50ac840 f8ff9f30 f8fcc7fd f522b000 c10b8301
>>   f50ac900 f5073d80 00000000 f50ac900 f50ac900 f72fded4 00000000 f8febc6f
>>  Call Trace:
>>   [<f8fe14f3>] ? cifs_root_iget+0x1e/0x13f [cifs]
>>   [<f8fcc96b>] ? cifs_do_mount+0x16e/0x247 [cifs]
>>   [<f8fcc7fd>] ? cifs_do_mount+0x0/0x247 [cifs]
>>   [<c10b8301>] ? vfs_kern_mount+0x9f/0x185
>>   [<f8febc6f>] ? cifs_dfs_follow_mountpoint+0x233/0x3cc [cifs]
>>   [<c10bec73>] ? do_follow_link+0xb6/0x1b1
>>   [<c10bf000>] ? link_path_walk+0x292/0x372
>>   [<c10bf1a2>] ? path_walk+0x4f/0xae
>>   [<c10bf2d3>] ? do_path_lookup+0x1f/0x69
>>   [<c10bfb70>] ? user_path_at+0x37/0x5f
>>   [<c1098af9>] ? vma_prio_tree_insert+0x17/0x2d
>>   [<c10b9981>] ? vfs_fstatat+0x2a/0x50
>>   [<c10b99e8>] ? vfs_lstat+0x13/0x15
>>   [<c10b99f9>] ? sys_lstat64+0xf/0x23
>>   [<c1052a04>] ? sys_futex+0xfe/0x112
>>   [<c10b500c>] ? filp_close+0x4e/0x54
>>   [<c127f54f>] ? do_page_fault+0x0/0x36b
>>   [<c1002f9f>] ? sysenter_do_call+0x12/0x28
>>  Code: c8 59 5f 39 ee 0f 8c 49 ff ff ff 8b 44 24 60 65 33 05 14 00 00 00
>> 74 05 e8 ef 9b 05 c8 83 c4 64 5b 5e 5f 5d c3 90 90 90 8b 40 08 <8b> 40
>> 1c c3 55 89 c5 83 3d a4 47 3b c1 00 57 89 d7 56 89 ce 53
>>  EIP: [<f8fd533b>] cifs_sb_master_tcon+0x3/0x7 [cifs] SS:ESP 0068:f72fddb0
>>  CR2: 000000000000001c
>>  ---[ end trace 61b6103d05293c43 ]---
>>
>> Regards,
>> Robbert
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Interesting...does this (untested) patch fix it? It may have to be "wiggled" into
> place depending on your tree. If so, I'm surprised no one has tripped
> over this before...
> 
> ----------------[snip]--------------------
> 
> cifs: fix check of error return from is_path_accessable
> 
> This function will return 0 if everything went ok.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/connect.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index bee397f..9fbe7c5 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2836,7 +2836,7 @@ remote_path_check:
>  			goto mount_fail_check;
>  		}
>  		rc = is_path_accessible(xid, tcon, cifs_sb, full_path);
> -		if (rc != -EREMOTE) {
> +		if (rc != 0 && rc != -EREMOTE) {
>  			kfree(full_path);
>  			goto mount_fail_check;
>  		}
