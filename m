From: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Subject: Re: [PATCH 4.13 28/43] SMB3: Validate negotiate request must always
 be signed
Date: Thu, 18 Jan 2018 13:25:30 -0800
Message-ID: <47c8ba0a-f576-8ebe-1cb5-71ab80f77db7@csail.mit.edu>
References: <20171031095530.520746935@linuxfoundation.org>
 <20171031095531.633196173@linuxfoundation.org>
 <97340c9a-0ea2-0d3d-cf26-58c799d76cae@mageia.org>
 <20171101151803.GB31285@kroah.com>
 <4ba67095-4075-688f-d3fb-157847aee4d9@csail.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        lsahlber@redhat.com, pshilov@microsoft.com,
        linux-cifs@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Backlund <tmb@mageia.org>,
        Steve French <smfrench@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <4ba67095-4075-688f-d3fb-157847aee4d9@csail.mit.edu>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On 1/3/18 6:15 PM, Srivatsa S. Bhat wrote:
> On 11/1/17 8:18 AM, Greg Kroah-Hartman wrote:
>> On Tue, Oct 31, 2017 at 03:02:11PM +0200, Thomas Backlund wrote:
>>> Den 31.10.2017 kl. 11:55, skrev Greg Kroah-Hartman:
>>>> 4.13-stable review patch.  If anyone has any objections, please let me know.
>>>>
>>>> ------------------
>>>>
>>>> From: Steve French <smfrench@gmail.com>
>>>>
>>>> commit 4587eee04e2ac7ac3ac9fa2bc164fb6e548f99cd upstream.
>>>>
>>>> According to MS-SMB2 3.2.55 validate_negotiate request must
>>>> always be signed. Some Windows can fail the request if you send it unsigned
>>>>
>>>> See kernel bugzilla bug 197311
>>>>
>>>> Acked-by: Ronnie Sahlberg <lsahlber.redhat.com>
>>>> Signed-off-by: Steve French <smfrench@gmail.com>
>>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>>
>>>> ---
>>>>   fs/cifs/smb2pdu.c |    3 +++
>>>>   1 file changed, 3 insertions(+)
>>>>
>>>> --- a/fs/cifs/smb2pdu.c
>>>> +++ b/fs/cifs/smb2pdu.c
>>>> @@ -1963,6 +1963,9 @@ SMB2_ioctl(const unsigned int xid, struc
>>>>   	} else
>>>>   		iov[0].iov_len = get_rfc1002_length(req) + 4;
>>>> +	/* validate negotiate request must be signed - see MS-SMB2 3.2.5.5 */
>>>> +	if (opcode == FSCTL_VALIDATE_NEGOTIATE_INFO)
>>>> +		req->hdr.sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
>>>>   	rc = SendReceive2(xid, ses, iov, n_iov, &resp_buftype, flags, &rsp_iov);
>>>>   	cifs_small_buf_release(req);
>>>>
>>>>
>>>>
>>>
>>> This one needs to be backported to all stable kernels as the commit that
>>> introduced the regression:
>>> '
>>> 0603c96f3af50e2f9299fa410c224ab1d465e0f9
>>> SMB: Validate negotiate (to protect against downgrade) even if signing off
>>>
>>> is backported in stable trees as of: 4.9.53, 4.4.90, 3.18.73
>>
>> Oh wait, it breaks the builds on older kernels, that's why I didn't
>> apply it :)
>>
>> Can you provide me with a working backport?
>>
> 
> Hi Steve,
> 
> Is there a version of this fix available for stable kernels?
> 

Any thoughts on this?

Regards,
Srivatsa

> I tried applying this patch to 4.4.109 (and a similar one for 4.9.74),
> but it didn't fix the problem.  Instead, I actually got a NULL pointer
> dereference when I tried to mount an SMB3 share.
> 
> Here is the patch I tried on 4.4.109:
> 
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index f2ff60e..3963bd2 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1559,6 +1559,9 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
>         } else
>                 iov[0].iov_len = get_rfc1002_length(req) + 4;
>  
> +       /* validate negotiate request must be signed - see MS-SMB2 3.2.5.5 */
> +       if (opcode == FSCTL_VALIDATE_NEGOTIATE_INFO)
> +               req->hdr.Flags |= SMB2_FLAGS_SIGNED;
>  
>         rc = SendReceive2(xid, ses, iov, num_iovecs, &resp_buftype, 0);
>         rsp = (struct smb2_ioctl_rsp *)iov[0].iov_base;
> 
> 
> This results in the following NULL pointer dereference when I try
> mounting:
> 
> # mount -vvv -t cifs -o vers=3.0,credentials=.smbcred //<ip_addr>/TestSMB/ testdir
> 
> [   53.073057] BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
> [   53.073511] IP: [<ffffffff8138ee9a>] crypto_shash_setkey+0x1a/0xc0
> [   53.073973] PGD 0 
> [   53.074427] Oops: 0000 [#1] SMP 
> [   53.074946] Modules linked in: arc4(E) ecb(E) md4(E) cifs(E) dns_resolver(E) vmw_vsock_vmci_transport(E) vsock(E) hid_generic(E) usbhid(E) hid(E) xt_conntrack(E) mousedev(E) iptable_nat(E) nf_conntrack_ipv4(E) nf_defrag_ipv4(E) nf_nat_ipv4(E) nf_nat(E) iptable_filter(E) ip_tables(E) crc32c_intel(E) xt_LOG(E) nf_conntrack(E) jitterentropy_rng(E) hmac(E) sha256_ssse3(E) sha256_generic(E) drbg(E) vmw_balloon(E) ansi_cprng(E) aesni_intel(E) aes_x86_64(E) glue_helper(E) lrw(E) gf128mul(E) ablk_helper(E) cryptd(E) psmouse(E) evdev(E) uhci_hcd(E) ehci_pci(E) ehci_hcd(E) usbcore(E) intel_agp(E) usb_common(E) vmw_vmci(E) i2c_piix4(E) intel_gtt(E) nfit(E) battery(E) tpm_tis(E) tpm(E) ac(E) button(E) sch_fq_codel(E) autofs4(E)
> [   53.079435] CPU: 3 PID: 829 Comm: mount.cifs Tainted: G            E   4.4.109-possible-fix1+ #21
> [   53.079983] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/05/2016
> [   53.081086] task: ffff8800b4f41940 ti: ffff8800b92ac000 task.ti: ffff8800b92ac000
> [   53.081667] RIP: 0010:[<ffffffff8138ee9a>]  [<ffffffff8138ee9a>] crypto_shash_setkey+0x1a/0xc0
> [   53.082247] RSP: 0018:ffff8800b92af9a8  EFLAGS: 00010282
> [   53.082604] systemd-journald[284]: Compressed data object 721 -> 468 using XZ
> [   53.083419] RAX: ffff8800af5943c0 RBX: ffff8800b484a800 RCX: 00000000ffff0ec7
> [   53.084001] RDX: 0000000000000010 RSI: ffff8800b900af18 RDI: 0000000000000000
> [   53.084602] RBP: ffff8800b92af9e0 R08: ffff8800b92afb64 R09: 0000000000000000
> [   53.085184] R10: 3031322e3030312e R11: 00000000000007f5 R12: 0000000000000002
> [   53.085755] R13: 0000000000000000 R14: ffff8800b900af18 R15: 0000000000000010
> [   53.086333] FS:  00007fb659b45740(0000) GS:ffff88013fcc0000(0000) knlGS:0000000000000000
> [   53.086907] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   53.087480] CR2: 0000000000000050 CR3: 00000000b7970000 CR4: 00000000001606e0
> [   53.088107] Stack:
> [   53.088681]  ffff8800bba5d8c0 ffff8800b92afa08 ffff8800b484a800 0000000000000002
> [   53.089281]  ffff8800b92afac8 000008012400007d ffff8800b484a800 ffff8800b92afa50
> [   53.089871]  ffffffffa02194a6 ffff8800b92afb70 ffff8800af5943c0 ffff8800b7a2f800
> [   53.090457] Call Trace:
> [   53.091054]  [<ffffffffa02194a6>] smb3_calc_signature+0xb6/0x290 [cifs]
> [   53.091650]  [<ffffffffa0218b5b>] smb2_sign_rqst+0x2b/0x40 [cifs]
> [   53.092244]  [<ffffffffa0219981>] smb2_setup_request+0xd1/0x170 [cifs]
> [   53.092838]  [<ffffffffa02082a7>] SendReceive2+0xc7/0x450 [cifs]
> [   53.093435]  [<ffffffffa02057d5>] ? cifs_small_buf_get+0x15/0x30 [cifs]
> [   53.094030]  [<ffffffffa021b83f>] ? small_smb2_init+0xdf/0x200 [cifs]
> [   53.094616]  [<ffffffffa021d6d7>] SMB2_ioctl+0x147/0x310 [cifs]
> [   53.095203]  [<ffffffffa021d99e>] smb3_validate_negotiate+0xfe/0x2d0 [cifs]
> [   53.095792]  [<ffffffffa021b196>] SMB2_tcon+0x296/0x500 [cifs]
> [   53.096362]  [<ffffffff817d7b49>] ? _raw_spin_unlock_irqrestore+0x9/0x10
> [   53.096930]  [<ffffffffa01efe0b>] cifs_get_tcon+0x1bb/0x560 [cifs]
> [   53.097486]  [<ffffffffa01f2b10>] cifs_mount+0x690/0xde0 [cifs]
> [   53.098032]  [<ffffffff817d7b49>] ? _raw_spin_unlock_irqrestore+0x9/0x10
> [   53.098570]  [<ffffffffa01de6eb>] cifs_do_mount+0xcb/0x5a0 [cifs]
> [   53.099089]  [<ffffffff81193ef7>] ? alloc_pages_current+0x87/0x110
> [   53.099598]  [<ffffffff811b7b03>] mount_fs+0x33/0x160
> [   53.100091]  [<ffffffff811d1b62>] vfs_kern_mount+0x62/0x100
> [   53.100574]  [<ffffffff811d3f1b>] do_mount+0x21b/0xd30
> [   53.101050]  [<ffffffff81193ef7>] ? alloc_pages_current+0x87/0x110
> [   53.101511]  [<ffffffff811d4d47>] SyS_mount+0x87/0xd0
> [   53.101959]  [<ffffffff817d806e>] entry_SYSCALL_64_fastpath+0x12/0x71
> [   53.102400] Code: 89 e5 8b 12 e8 78 d2 04 00 31 c0 5d c3 0f 1f 40 00 55 48 89 e5 41 57 41 56 41 55 41 54 49 89 fd 53 49 89 f6 41 89 d7 48 83 ec 10 <4c> 8b 67 50 41 8b 5c 24 2c 48 85 de 75 14 41 ff 54 24 e8 48 83 
> [   53.103820] RIP  [<ffffffff8138ee9a>] crypto_shash_setkey+0x1a/0xc0
> [   53.104288]  RSP <ffff8800b92af9a8>
> [   53.104745] CR2: 0000000000000050
> [   53.105225] ---[ end trace fc2de0ad7f229314 ]---
> 
> 
> The CIFS config options enabled are:
> 
> CONFIG_CIFS=m
> CONFIG_CIFS_STATS=y
> CONFIG_CIFS_STATS2=y
> CONFIG_CIFS_WEAK_PW_HASH=y
> CONFIG_CIFS_UPCALL=y
> CONFIG_CIFS_XATTR=y
> CONFIG_CIFS_POSIX=y
> CONFIG_CIFS_ACL=y
> CONFIG_CIFS_DEBUG=y
> CONFIG_CIFS_DEBUG2=y
> CONFIG_CIFS_DFS_UPCALL=y
> CONFIG_CIFS_SMB2=y
> # CONFIG_CIFS_SMB311 is not set
> # CONFIG_CIFS_FSCACHE is not set
> 
> 
> The problem seems to be that crypto_shash_setkey() is called without
> calling smb3_crypto_shash_allocate() first.  So I looked up how mainline
> avoids this issue, and it looks like the following commit makes a call
> to generate_signingkey() even when server->sign == false, and this path
> eventually calls smb3_crytpto_shash_allocate()), thus avoiding the NULL
> pointer dereference.
> 
> cabfb3680f78 (CIFS: Enable encryption during session setup phase)
> 
> 
> So, I adopted this change, and now my resulting patch looks like this:
> 
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index f2ff60e..19cc92c 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -833,7 +833,7 @@ ssetup_exit:
>  
>         if (!rc) {
>                 mutex_lock(&server->srv_mutex);
> -               if (server->sign && server->ops->generate_signingkey) {
> +               if (server->ops->generate_signingkey) {
>                         rc = server->ops->generate_signingkey(ses);
>                         kfree(ses->auth_key.response);
>                         ses->auth_key.response = NULL;
> @@ -1559,6 +1559,9 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
>         } else
>                 iov[0].iov_len = get_rfc1002_length(req) + 4;
>  
> +       /* validate negotiate request must be signed - see MS-SMB2 3.2.5.5 */
> +       if (opcode == FSCTL_VALIDATE_NEGOTIATE_INFO)
> +               req->hdr.Flags |= SMB2_FLAGS_SIGNED;
>  
>         rc = SendReceive2(xid, ses, iov, num_iovecs, &resp_buftype, 0);
>         rsp = (struct smb2_ioctl_rsp *)iov[0].iov_base;
> 
> 
> 
> This fixes the NULL pointer dereference, but the mount still fails, but
> this time for a different reason -- due to STATUS_ACCESS_DENIED:
> 
> 
> # mount -vvv -t cifs -o vers=3.0,credentials=.smbcred //<ip_addr>/TestSMB/ testdir
> 
> mount.cifs kernel mount options: ip=<ip_addr>,unc=\\<ip_addr>\TestSMB,vers=3.0,user=srivatsa,pass=********
> mount error(5): Input/output error
> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
> 
> Here is the dmesg output:
> 
> [   48.192141] fs/cifs/cifsfs.c: Devname: //<ip_addr>/TestSMB/ flags: 0
> [   48.192178] address conversion returned 1 for <ip_addr>
> [   48.192205] fs/cifs/connect.c: Username: srivatsa
> [   48.192222] fs/cifs/connect.c: file mode: 0x1ed  dir mode: 0x1ed
> [   48.192280] fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 0 with uid: 0
> [   48.192302] fs/cifs/connect.c: UNC: \\<ip_addr>\TestSMB
> [   48.192335] fs/cifs/connect.c: Socket created
> [   48.192349] fs/cifs/connect.c: sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
> [   48.193453] fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 1 with uid: 0
> [   48.193462] fs/cifs/connect.c: Demultiplex PID: 829
> [   48.193492] fs/cifs/connect.c: Existing smb sess not found
> [   48.193510] fs/cifs/smb2pdu.c: Negotiate protocol
> [   48.193531] fs/cifs/transport.c: Sending smb: smb_len=102
> [   48.194301] fs/cifs/connect.c: RFC1002 header 0xaa
> [   48.194321] fs/cifs/smb2misc.c: smb2_check_message length: 0xae, smb_buf_length: 0xaa
> [   48.194349] fs/cifs/smb2misc.c: SMB2 data length 42 offset 128
> [   48.194367] fs/cifs/smb2misc.c: SMB2 len 174
> [   48.194393] fs/cifs/transport.c: cifs_sync_mid_result: cmd=0 mid=0 state=4
> [   48.194415] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
> [   48.194436] fs/cifs/smb2pdu.c: mode 0x1
> [   48.194448] fs/cifs/smb2pdu.c: negotiated smb3.0 dialect
> [   48.194466] fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
> [   48.194484] fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
> [   48.194502] fs/cifs/connect.c: Security Mode: 0x1 Capabilities: 0x300007 TimeAdjust: 0
> [   48.194525] fs/cifs/smb2pdu.c: Session Setup
> [   48.194539] fs/cifs/transport.c: Sending smb: smb_len=120
> [   48.194817] fs/cifs/connect.c: RFC1002 header 0x136
> [   48.194836] fs/cifs/smb2misc.c: smb2_check_message length: 0x13a, smb_buf_length: 0x136
> [   48.194859] fs/cifs/smb2misc.c: SMB2 data length 238 offset 72
> [   48.195306] fs/cifs/smb2misc.c: SMB2 len 314
> [   48.195740] fs/cifs/transport.c: cifs_sync_mid_result: cmd=1 mid=1 state=4
> [   48.196174] Status code returned 0xc0000016 STATUS_MORE_PROCESSING_REQUIRED
> [   48.196605] fs/cifs/smb2maperror.c: Mapping SMB2 status code -1073741802 to POSIX err -5
> [   48.197043] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
> [   48.210008] fs/cifs/transport.c: Sending smb: smb_len=412
> [   48.211625] fs/cifs/connect.c: RFC1002 header 0x48
> [   48.212060] fs/cifs/smb2misc.c: smb2_check_message length: 0x4c, smb_buf_length: 0x48
> [   48.212494] fs/cifs/smb2misc.c: SMB2 data length 0 offset 72
> [   48.212919] fs/cifs/smb2misc.c: SMB2 len 77
> [   48.213364] fs/cifs/smb2misc.c: Calculated size 77 length 76 mismatch mid 2
> [   48.213807] fs/cifs/transport.c: cifs_sync_mid_result: cmd=1 mid=2 state=4
> [   48.214242] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
> [   48.219385] fs/cifs/smb2pdu.c: SMB2/3 session established successfully
> [   48.219831] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 1) rc = 0
> [   48.220276] fs/cifs/connect.c: CIFS VFS: in cifs_get_tcon as Xid: 2 with uid: 0
> [   48.220724] fs/cifs/smb2pdu.c: TCON
> [   48.221182] fs/cifs/transport.c: Sending smb: smb_len=122
> [   48.221830] fs/cifs/connect.c: RFC1002 header 0x50
> [   48.222280] fs/cifs/smb2misc.c: smb2_check_message length: 0x54, smb_buf_length: 0x50
> [   48.222734] fs/cifs/smb2misc.c: SMB2 len 84
> [   48.223199] fs/cifs/transport.c: cifs_sync_mid_result: cmd=3 mid=3 state=4
> [   48.223656] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
> [   48.224107] fs/cifs/smb2pdu.c: connection to disk share
> [   48.224560] fs/cifs/smb2pdu.c: validate negotiate
> [   48.225015] fs/cifs/smb2pdu.c: SMB2 IOCTL
> [   48.225456] fs/cifs/transport.c: Sending smb: smb_len=146
> [   48.226049] fs/cifs/connect.c: RFC1002 header 0x49
> [   48.226498] fs/cifs/smb2misc.c: smb2_check_message length: 0x4d, smb_buf_length: 0x49
> [   48.226951] fs/cifs/smb2misc.c: SMB2 data length 0 offset 0
> [   48.227408] fs/cifs/smb2misc.c: SMB2 len 77
> [   48.227863] fs/cifs/transport.c: cifs_sync_mid_result: cmd=11 mid=4 state=4
> [   48.228318] Status code returned 0xc0000022 STATUS_ACCESS_DENIED
> [   48.228780] fs/cifs/smb2maperror.c: Mapping SMB2 status code -1073741790 to POSIX err -13
> [   48.229265] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
> [   48.229732] CIFS VFS: validate protocol negotiate failed: -13
> [   48.230197] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_tcon (xid = 2) rc = -5
> [   48.230681] fs/cifs/connect.c: Tcon rc = -5
> [   48.231150] fs/cifs/connect.c: build_unc_path_to_root: full_path=\\<ip_addr>\TestSMB
> [   48.231634] fs/cifs/connect.c: cifs_put_smb_ses: ses_count=1
> [   48.232101] fs/cifs/connect.c: CIFS VFS: in cifs_put_smb_ses as Xid: 3 with uid: 0
> [   48.232569] fs/cifs/smb2pdu.c: disconnect session ffff8800b9189e00
> [   48.233053] fs/cifs/transport.c: Sending smb: smb_len=68
> [   48.233651] fs/cifs/connect.c: RFC1002 header 0x44
> [   48.234116] fs/cifs/smb2misc.c: smb2_check_message length: 0x48, smb_buf_length: 0x44
> [   48.234585] fs/cifs/smb2misc.c: SMB2 len 72
> [   48.235063] fs/cifs/transport.c: cifs_sync_mid_result: cmd=2 mid=5 state=4
> [   48.235541] SendRcvNoRsp flags 64 rc 0
> [   48.236075] fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 0) rc = -5
> [   48.236556] CIFS VFS: cifs_mount failed w/return code = -5
> 
> 
> Any thoughts on what is the right fix for stable kernels? Mounting SMB3
> shares works great on mainline (v4.15-rc5). It also works on 4.4.109 if
> I pass the sec=ntlmsspi option to the mount command (as opposed to the
> default: sec=ntlmssp). Please let me know if you need any other info.
> 
> Thank you!
> 
> Regards,
> Srivatsa
>
