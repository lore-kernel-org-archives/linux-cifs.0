From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [4.11-rc6 bug] fstests generic/010 crashes cifs 2.0/2.1/3.0 mounts
Date: Mon, 10 Apr 2017 23:26:34 -0500
Message-ID: <CAH2r5muDb-1GfCEtNz2FvZbRnMvsEyJmv8OOp27h4fKgr4Dp0Q@mail.gmail.com>
References: <20170410044446.GC22845@eguan.usersys.redhat.com>
 <CAKywueQMB_T=FXdKsRC6txbGYVpbZbWQFScuvzas75WzoJbahA@mail.gmail.com> <1491859976.8507.6.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1491859976.8507.6.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged pavel's version into cifs-2.6.git for-next and added cc: stable

On Mon, Apr 10, 2017 at 4:32 PM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, 2017-04-10 at 13:18 -0700, Pavel Shilovsky wrote:
>> 2017-04-09 21:44 GMT-07:00 Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> > Hi all,
>> >
>> > Starting from 4.11-rc6 kernel, I noticed fstests generic/010 would
>> > crash
>> > cifs v2.0/2.1/3.0 mounts, I was testing with local mount linux
>> > samba
>> > server.
>> >
>> > [  324.109085] run fstests generic/010 at 2017-04-09 17:39:05
>> > [  324.245779] BUG: unable to handle kernel NULL pointer
>> > dereference at           (null)
>> > [  324.254532] IP: cifs_discard_remaining_data+0x12/0x70 [cifs]
>> > [  324.260843] PGD 0
>> > [  324.260844]
>> > [  324.264741] Oops: 0000 [#1] SMP
>> > [  324.268241] Modules linked in: cmac arc4 md4 nls_utf8 cifs ccm
>> > dns_resolver binfmt_misc intel_rapl x86_pkg_temp_thermal
>> > intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul
>> > crc32_pclmul ghash_clmulni_intel pcbc aesni_intel cdc_ether nfsd
>> > crypto_simd iTCO_wdt glue_helper usbnet cryptd iTCO_vendor_support
>> > gpio_ich ipmi_ssif mii wmi ipmi_si sg pcspkr ie31200_edac
>> > ipmi_devintf edac_core shpchp i2c_i801 ipmi_msghandler lpc_ich
>> > auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c
>> > sr_mod cdrom sd_mod ata_generic pata_acpi mgag200 i2c_algo_bit
>> > drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm
>> > e1000e drm ata_piix libata ptp crc32c_intel pps_core i2c_core
>> > dm_mirror dm_region_hash dm_log dm_mod
>> > [  324.339637] CPU: 0 PID: 25782 Comm: cifsd Not tainted 4.11.0-rc6
>> > #1
>> > [  324.346627] Hardware name: IBM IBM System X3250 M4 -[2583AC1]-
>> > /00D3729, BIOS -[JQE164AUS-1.07]- 12/09/2013
>> > [  324.357399] task: ffff999d307fc380 task.stack: ffffb01f490e8000
>> > [  324.364010] RIP: 0010:cifs_discard_remaining_data+0x12/0x70
>> > [cifs]
>> > [  324.370904] RSP: 0018:ffffb01f490ebdf8 EFLAGS: 00010246
>> > [  324.376732] RAX: 00000000ffffffc3 RBX: ffff999d31185480 RCX:
>> > 0000000000000d50
>> > [  324.384691] RDX: 0000000000000d50 RSI: 0000000000000000 RDI:
>> > ffff999cac4a0800
>> > [  324.392651] RBP: ffffb01f490ebe08 R08: 0000000000071888 R09:
>> > 0000000000000077
>> > [  324.400611] R10: 0000000000038c44 R11: 0000000000081840 R12:
>> > 0000000000000004
>> > [  324.408569] R13: ffff999c7e815100 R14: ffff999c7e815100 R15:
>> > 000000000000004d
>> > [  324.416529] FS:  0000000000000000(0000)
>> > GS:ffff999d3fc00000(0000) knlGS:0000000000000000
>> > [  324.425556] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> > [  324.431965] CR2: 0000000000000000 CR3: 00000001a6809000 CR4:
>> > 00000000001406f0
>> > [  324.439924] Call Trace:
>> > [  324.442657]  cifs_readv_discard+0x1e/0x40 [cifs]
>> > [  324.447812]  cifs_readv_receive+0xd6/0x560 [cifs]
>> > [  324.453056]  cifs_demultiplex_thread+0x66f/0xa70 [cifs]
>> > [  324.458887]  kthread+0x101/0x140
>> > [  324.462491]  ? cifs_handle_standard+0x130/0x130 [cifs]
>> > [  324.468222]  ? kthread_park+0x90/0x90
>> > [  324.472306]  ? do_syscall_64+0x67/0x180
>> > [  324.476584]  ret_from_fork+0x2c/0x40
>> > [  324.480570] Code: 05 55 39 d4 e9 50 fe ff ff e8 3b 2a 07 d4 90
>> > 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 41 54 41
>> > bc 04 00 00 00 53 <8b> 06 48 89 fb 44 2b a7 38 03 00 00 0f c8 25 ff
>> > ff ff 00 41 01
>> > [  324.501642] RIP: cifs_discard_remaining_data+0x12/0x70 [cifs]
>> > RSP: ffffb01f490ebdf8
>> > [  324.510182] CR2: 0000000000000000
>> > [  324.513879] ---[ end trace 754f09c6094faa76 ]---
>> > [  324.519028] Kernel panic - not syncing: Fatal exception
>> > [  324.524889] Kernel Offset: 0x13600000 from 0xffffffff81000000
>> > (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
>> > [  324.536921] ---[ end Kernel panic - not syncing: Fatal exception
>> >
>> > And I bisected this to
>> >
>> > commit 38bd49064a1ecb67baad33598e3d824448ab11ec
>> > Author: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > Date:   Fri Mar 3 15:41:38 2017 -0800
>> >
>> >     Handle mismatched open calls
>> >
>> >     A signal can interrupt a SendReceive call which result in
>> > incoming
>> >     responses to the call being ignored. This is a problem for
>> > calls such as
>> >     open which results in the successful response being ignored.
>> > This
>> >     results in an open file resource on the server.
>> >
>> >     The patch looks into responses which were cancelled after being
>> > sent and
>> >     in case of successful open closes the open fids.
>> >
>> >     For this patch, the check is only done in SendReceive2()
>> >
>> >     RH-bz: 1403319
>> >
>> >     Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> >     Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>> >     Cc: Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>> >
>> > I was able to reproduce this crash with cifs2.0/2.1 mounts manually
>> > and
>> > it was easy to hit. Though I haven't seen it with cifs 3.0 mount in
>> > my
>> > manual test, I did see v3.0 crash in my auto tests. If you need
>> > more
>> > info please let me know.
>> >
>> > Thanks,
>> > Eryu
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-
>> > cifs" in
>> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> Hi Eryu,
>>
>> Thank for reporting this. I ended up with a fix for the problem (see
>> patch attached).
>>
>> Sachin, can you please review the patch?
>
> Hello Pavel,
>
> I had sent another version of the patch which fixes the problem but it
> ended up being sent privately to Steve.
>
> I like your version better.
>
> Acked-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
>
>>
>> --
>> Best regards,
>> Pavel Shilovsky
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
