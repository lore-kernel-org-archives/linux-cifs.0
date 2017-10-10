From: ronnie sahlberg <ronniesahlberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NULL pointer dereference in SMB2_tcon on 4.14-rc4
Date: Wed, 11 Oct 2017 07:49:59 +1000
Message-ID: <CAN05THRn85aqJdTpks5GM_oARQcvPEzdUn+qkUyaRch5=_pXqQ@mail.gmail.com>
References: <20171010200147.mdehq3aq64zvruvu@petr-dev3.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Petr Vandrovec <petr-vPk2MGR0e28uaRcfnNAh7A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171010200147.mdehq3aq64zvruvu-WbvboCQVrrgDIl+Cyo8nDyLysJ1jNyTM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Another NULL pointer deref in an error path.

Is it reproduceable ? I.e. can you reproduce at will  and verify a patch ?


On Wed, Oct 11, 2017 at 6:01 AM, Petr Vandrovec <petr-vPk2MGR0e28uaRcfnNAh7A@public.gmane.org> wrote=
:
> Hi,
>    I just installed today's Linux tree, and it seems that my environment
> managed to render CIFS connection establishment unhappy:  negotiate faile=
d with
> -11 (EAGAIN), and after that SMB2_tcon dereferenced NULL pointer:
>
> 1374  tcon_error_exit:
> 1375        if (rsp->hdr.sync_hdr.Status =3D=3D STATUS_BAD_NETWORK_NAME) =
{   <<< rsp is NULL
> 1376                cifs_dbg(VFS, "BAD_NETWORK_NAME: %s\n", tree);
> 1377        }
> 1378        goto tcon_exit;
>
> [   28.678303] No dialect specified on mount. Default has changed to a mo=
re secure dialect, SMB2.1 or later (e.g. SMB3), from CIFS (SMB1). To use th=
e less secure SMB1 dialect to access old servers which do not support SMB3 =
(or SMB2.1) specify vers=3D1.0 on mount.
> [   28.943404] CIFS VFS: validate protocol negotiate failed: -11
> [   28.949625] BUG: unable to handle kernel NULL pointer dereference at 0=
00000000000000c
> [   28.957529] IP: SMB2_tcon+0x174/0x500 [cifs]
> [   28.959620] PGD 0 P4D 0
> [   28.959620] Oops: 0000 [#1] PREEMPT SMP
> [   28.959620] Modules linked in: deflate twofish_generic twofish_avx_x86=
_64 twofish_x86_64_3way twofish_x86_64 twofish_common arc4 camellia_generic=
 md4 rpcsec_gss_krb5 nls_iso8859_2 nfsv4 cifs nfs xt_REDIRECT nf_nat_redire=
ct ccm fscache camellia_aesni_avx_x86_64 camellia_x86_64 serpent_avx_x86_64=
 serpent_sse2_x86_64 serpent_generic lrw blowfish_generic blowfish_x86_64 b=
lowfish_common cast5_avx_x86_64 cast5_generic cast_common ablk_helper des_g=
eneric cmac xcbc rmd160 af_key xfrm_algo fuse vmw_vsock_vmci_transport vsoc=
k vmw_vmci iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat =
nf_conntrack libcrc32c binfmt_misc snd_hda_codec_hdmi coretemp hwmon x86_pk=
g_temp_thermal snd_hda_codec_realtek uas crct10dif_pclmul snd_hda_codec_gen=
eric crc32_pclmul e1000e snd_hda_intel crc32c_intel
> snd_hda_codec
> [   29.031542]  ghash_clmulni_intel snd_hwdep ptp usb_storage pcbc input_=
leds dcdbas snd_hda_core snd_pcm_oss aesni_intel snd_mixer_oss aes_x86_64 s=
r_mod crypto_simd snd_pcm glue_helper cdrom cryptd i2c_i801 snd_timer tpm_t=
is mei_me tpm_tis_core mei sg snd tpm pps_core iTCO_wdt iTCO_vendor_support=
 lpc_ich mfd_core nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables x_t=
ables ipv6 crc_ccitt autofs4
> [   29.072575] CPU: 7 PID: 5135 Comm: mount.cifs Not tainted 4.14.0-rc4-6=
4-00055-ge543917e38f8 #5
> [   29.072575] Hardware name: Dell Inc. Precision T3610/09M8Y8, BIOS A12 =
09/09/2016
> [   29.072575] task: ffff880ffd809d80 task.stack: ffffc90000f14000
> [   29.072575] RIP: 0010:SMB2_tcon+0x174/0x500 [cifs]
> [   29.072575] RSP: 0018:ffffc90000f17c00 EFLAGS: 00010246
> [   29.072575] RAX: ffff881001b0c101 RBX: 0000000000000000 RCX: 000000000=
0000000
> [   29.072575] RDX: ffffc90000f17c20 RSI: ffff88106e9dc650 RDI: ffffea004=
006c300
> [   29.072575] RBP: ffffc90000f17c80 R08: 000000000001c650 R09: ffffffffa=
064b1c1
> [   29.072575] R10: ffffea004061d3c0 R11: ffff88106e403800 R12: ffff88100=
1ad5c00
> [   29.072575] R13: ffff8810061eefa0 R14: ffff880ff4b19400 R15: 00000000f=
ffffff5
> [   29.072575] FS:  00007fb2bd7e1740(0000) GS:ffff88106e9c0000(0000) knlG=
S:0000000000000000
> [   29.072575] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   29.072575] CR2: 000000000000000c CR3: 0000000ffd9c9005 CR4: 000000000=
01606e0
> [   29.072575] Call Trace:
> [   29.072575]  ? get_dfs_path+0x189/0x260 [cifs]
> [   29.072575]  get_dfs_path+0x189/0x260 [cifs]
> [   29.072575]  expand_dfs_referral+0x133/0x2b0 [cifs]
> [   29.072575]  ? tconInfoFree+0x4a/0xa0 [cifs]
> [   29.072575]  ? cifs_get_tcon+0x35e/0x580 [cifs]
> [   29.072575]  cifs_mount+0xc6b/0xe10 [cifs]
> [   29.072575]  ? cifs_do_mount+0x134/0x5a0 [cifs]
> [   29.072575]  cifs_do_mount+0x134/0x5a0 [cifs]
> [   29.072575]  ? cpumask_next+0x16/0x20
> [   29.072575]  ? pcpu_alloc+0x2cd/0x4f0
> [   29.072575]  mount_fs+0x2b/0x150
> [   29.072575]  vfs_kern_mount.part.7+0x4f/0x120
> [   29.072575]  do_mount+0x5b2/0xca0
> [   29.072575]  SyS_mount+0x50/0xd0
> [   29.072575]  entry_SYSCALL_64_fastpath+0x1e/0xa9
> [   29.072575] RIP: 0033:0x7fb2bd14823a
> [   29.072575] RSP: 002b:00007fff85121678 EFLAGS: 00000206 ORIG_RAX: 0000=
0000000000a5
> [   29.072575] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fb2b=
d14823a
> [   29.072575] RDX: 0000555e7d550fd5 RSI: 0000555e7d55101c RDI: 00007fff8=
5121ef5
> [   29.072575] RBP: 0000000000000001 R08: 0000555e7edae0f0 R09: 000000000=
0001010
> [   29.072575] R10: 0000000000000006 R11: 0000000000000206 R12: 000000000=
0000000
> [   29.072575] R13: 0000000000000004 R14: 0000000000000001 R15: 000000000=
0000000
> [   29.072575] Code: fe ff 48 8b 7d 98 41 89 c7 e8 09 bb fe ff 45 85 ff 4=
8 8b 4d a0 5a 74 4b 48 85 db 74 0e f0 ff 83 c8 05 00 00 80 8b d3 06 00 00 0=
1 <81> 79 0c cc 00 00 c0 0f 84 eb 01 00 00 8b 7d 94
> 48 89 ce e8 34
> [   29.072575] RIP: SMB2_tcon+0x174/0x500 [cifs] RSP: ffffc90000f17c00
> [   29.072575] CR2: 000000000000000c
> [   29.078495] ---[ end trace 36f096a95567d971 ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
