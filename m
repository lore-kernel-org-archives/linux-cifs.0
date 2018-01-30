From: "Srivatsa S. Bhat" <srivatsa-EfZU8u+QLuPpgkiH4x7ZXw@public.gmane.org>
Subject: Re: [PATCH 4.13 28/43] SMB3: Validate negotiate request must always
 be signed
Date: Mon, 29 Jan 2018 19:31:50 -0800
Message-ID: <727c61d2-29c4-57e1-7567-5ff589e3310a@csail.mit.edu>
References: <20171031095530.520746935@linuxfoundation.org>
 <20171031095531.633196173@linuxfoundation.org>
 <97340c9a-0ea2-0d3d-cf26-58c799d76cae@mageia.org>
 <20171101151803.GB31285@kroah.com>
 <4ba67095-4075-688f-d3fb-157847aee4d9@csail.mit.edu>
 <47c8ba0a-f576-8ebe-1cb5-71ab80f77db7@csail.mit.edu>
 <87lggux9rp.fsf@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>,
        Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
        Thomas Backlund <tmb-odJJhXpcy38dnm+yROfE0A@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87lggux9rp.fsf-IBi9RG/b67k@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Aurélien,

On 1/19/18 5:23 AM, Aurélien Aptel wrote:
> Hi,
> 
> "Srivatsa S. Bhat" <srivatsa-EfZU8u+QLuPpgkiH4x7ZXw@public.gmane.org> writes:
>>> Any thoughts on what is the right fix for stable kernels? Mounting SMB3
>>> shares works great on mainline (v4.15-rc5). It also works on 4.4.109 if
>>> I pass the sec=ntlmsspi option to the mount command (as opposed to the
>>> default: sec=ntlmssp). Please let me know if you need any other info.
> 
> Make sure you have (in that order):
> 
> db3b5474f462 ("CIFS: Fix NULL pointer deref on SMB2_tcon() failure")
> fe83bebc0522 ("SMB: fix leak of validate negotiate info response buffer")
> a2d9daad1d2d ("SMB: fix validate negotiate info uninitialised memory use")
> 4587eee04e2a ("SMB3: Validate negotiate request must always be signed")
> a821df3f1af7 ("cifs: fix NULL deref in SMB2_read")
> 
> Does enabling CIFS_SMB311 changes anything?
> 

Thank you for looking into this. I tried applying these patches on top 
of 4.4.113 and 4.9.78, but that didn't fix the problem on either kernel,
with or without CONFIG_CIFS_SMB311 enabled.

(By the way, shouldn't these patches be applied to stable kernels anyway?
I was a bit surprised that none of them are present in 4.4.113 and 4.9.78).

> I also suspect some things assume encryption patches are in.
> 

Do you happen to know which patches they might be? In any case, I'm using
the latest (unmodified) 4.4 and 4.9 stable kernels, so I hope the necessary
support is already present in them.

The 5 patches you suggested above needed a bit of fixup by hand for 4.4.113,
so I have shared my combined patch below for reference, which applies
cleanly on top of 4.4.113. (The same patch applies on 4.9.78 as well, with
some minor line-number differences).

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index f2ff60e..92abb8b9 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -519,7 +519,7 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 {
 	int rc = 0;
 	struct validate_negotiate_info_req vneg_inbuf;
-	struct validate_negotiate_info_rsp *pneg_rsp;
+	struct validate_negotiate_info_rsp *pneg_rsp = NULL;
 	u32 rsplen;
 
 	cifs_dbg(FYI, "validate negotiate\n");
@@ -575,8 +575,9 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 			 rsplen);
 
 		/* relax check since Mac returns max bufsize allowed on ioctl */
-		if (rsplen > CIFSMaxBufSize)
-			return -EIO;
+		if ((rsplen > CIFSMaxBufSize)
+			|| (rsplen < sizeof(struct validate_negotiate_info_rsp)))
+			goto err_rsp_free;
 	}
 
 	/* check validate negotiate info response matches what we got earlier */
@@ -595,10 +596,13 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 
 	/* validate negotiate successful */
 	cifs_dbg(FYI, "validate negotiate info successful\n");
+	kfree(pneg_rsp);
 	return 0;
 
 vneg_out:
 	cifs_dbg(VFS, "protocol revalidation - security settings mismatch\n");
+err_rsp_free:
+	kfree(pneg_rsp);
 	return -EIO;
 }
 
@@ -1042,7 +1046,7 @@ tcon_exit:
 	return rc;
 
 tcon_error_exit:
-	if (rsp->hdr.Status == STATUS_BAD_NETWORK_NAME) {
+	if (rsp && rsp->hdr.Status == STATUS_BAD_NETWORK_NAME) {
 		cifs_dbg(VFS, "BAD_NETWORK_NAME: %s\n", tree);
 	}
 	goto tcon_exit;
@@ -1559,6 +1563,9 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	} else
 		iov[0].iov_len = get_rfc1002_length(req) + 4;
 
+	/* validate negotiate request must be signed - see MS-SMB2 3.2.5.5 */
+	if (opcode == FSCTL_VALIDATE_NEGOTIATE_INFO)
+		req->hdr.Flags |= SMB2_FLAGS_SIGNED;
 
 	rc = SendReceive2(xid, ses, iov, num_iovecs, &resp_buftype, 0);
 	rsp = (struct smb2_ioctl_rsp *)iov[0].iov_base;
@@ -2159,23 +2166,22 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 
 	rsp = (struct smb2_read_rsp *)iov[0].iov_base;
 
-	if (rsp->hdr.Status == STATUS_END_OF_FILE) {
+	if (rc) {
+		if (rc != -ENODATA) {
+			cifs_stats_fail_inc(io_parms->tcon, SMB2_READ_HE);
+			cifs_dbg(VFS, "Send error in read = %d\n", rc);
+		}
 		free_rsp_buf(resp_buftype, iov[0].iov_base);
-		return 0;
+		return rc == -ENODATA ? 0 : rc;
 	}
 
-	if (rc) {
-		cifs_stats_fail_inc(io_parms->tcon, SMB2_READ_HE);
-		cifs_dbg(VFS, "Send error in read = %d\n", rc);
-	} else {
-		*nbytes = le32_to_cpu(rsp->DataLength);
-		if ((*nbytes > CIFS_MAX_MSGSIZE) ||
-		    (*nbytes > io_parms->length)) {
-			cifs_dbg(FYI, "bad length %d for count %d\n",
-				 *nbytes, io_parms->length);
-			rc = -EIO;
-			*nbytes = 0;
-		}
+	*nbytes = le32_to_cpu(rsp->DataLength);
+	if ((*nbytes > CIFS_MAX_MSGSIZE) ||
+	    (*nbytes > io_parms->length)) {
+		cifs_dbg(FYI, "bad length %d for count %d\n",
+			 *nbytes, io_parms->length);
+		rc = -EIO;
+		*nbytes = 0;
 	}
 
 	if (*buf) {



With this patch (and CONFIG_CIFS_SMB311 enabled), the 4.4.113 kernel crashes as
shown below when I try:

# mount -vvv -t cifs -o vers=3.0,credentials=.smbcred //<ip_addr>/TestSMB/ testdir

[   14.638907] BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
[   14.638940] IP: [<ffffffff8139221a>] crypto_shash_setkey+0x1a/0xc0
[   14.638964] PGD 0 
[   14.638972] Oops: 0000 [#1] SMP 
[   14.638985] Modules linked in: arc4(E) ecb(E) md4(E) cifs(E) dns_resolver(E) vmw_vsock_vmci_transport(E) vsock(E) xt_conntrack(E) iptable_nat(E) nf_conntrack_ipv4(E) nf_defrag_ipv4(E) nf_nat_ipv4(E) nf_nat(E) iptable_filter(E) ip_tables(E) xt_LOG(E) nf_conntrack(E) hid_generic(E) usbhid(E) hid(E) mousedev(E) crc32c_intel(E) jitterentropy_rng(E) hmac(E) sha256_ssse3(E) sha256_generic(E) uhci_hcd(E) drbg(E) ansi_cprng(E) aesni_intel(E) ehci_pci(E) aes_x86_64(E) glue_helper(E) ehci_hcd(E) lrw(E) gf128mul(E) usbcore(E) ablk_helper(E) psmouse(E) cryptd(E) vmw_balloon(E) evdev(E) intel_agp(E) vmw_vmci(E) usb_common(E) i2c_piix4(E) intel_gtt(E) nfit(E) battery(E) tpm_tis(E) tpm(E) ac(E) button(E) sch_fq_codel(E) autofs4(E)
[   14.639237] CPU: 0 PID: 841 Comm: mount.cifs Tainted: G            E   4.4.113-fixes-smb311+ #33
[   14.639263] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/05/2016
[   14.639294] task: ffff8800ae811440 ti: ffff8800b9d4c000 task.ti: ffff8800b9d4c000
[   14.639315] RIP: 0010:[<ffffffff8139221a>]  [<ffffffff8139221a>] crypto_shash_setkey+0x1a/0xc0
[   14.639343] RSP: 0018:ffff8800b9d4f9a8  EFLAGS: 00010282
[   14.639358] RAX: ffff88013305d580 RBX: ffff8800ba2ed000 RCX: 00000000fffee93f
[   14.639379] RDX: 0000000000000010 RSI: ffff8800b9f58d18 RDI: 0000000000000000
[   14.639399] RBP: ffff8800b9d4f9e0 R08: ffff8800b9d4fb64 R09: 0000000000000000
[   14.639420] R10: 3036312e3130312e R11: 424d53747365545c R12: 0000000000000002
[   14.639440] R13: 0000000000000000 R14: ffff8800b9f58d18 R15: 0000000000000010
[   14.639461] FS:  00007f02bcb74740(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
[   14.639484] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   14.639501] CR2: 0000000000000050 CR3: 00000000ae9f8000 CR4: 0000000000160670
[   14.639558] Stack:
[   14.639566]  ffff8800b66789c0 ffff8800b9d4fa08 ffff8800ba2ed000 0000000000000002
[   14.639592]  ffff8800b9d4fac8 00000c0094000029 ffff8800ba2ed000 ffff8800b9d4fa50
[   14.639618]  ffffffffa02594f6 ffff8800b9d4fb70 ffff88013305d580 0000000000000002
[   14.639644] Call Trace:
[   14.639669]  [<ffffffffa02594f6>] smb3_calc_signature+0xb6/0x290 [cifs]
[   14.639699]  [<ffffffffa0258bab>] smb2_sign_rqst+0x2b/0x40 [cifs]
[   14.639726]  [<ffffffffa02599d1>] smb2_setup_request+0xd1/0x170 [cifs]
[   14.640347]  [<ffffffffa0248be7>] SendReceive2+0xc7/0x450 [cifs]
[   14.640958]  [<ffffffffa02461b5>] ? cifs_small_buf_get+0x15/0x30 [cifs]
[   14.641582]  [<ffffffffa025b89f>] ? small_smb2_init+0xdf/0x200 [cifs]
[   14.642172]  [<ffffffffa025d867>] SMB2_ioctl+0x147/0x310 [cifs]
[   14.642753]  [<ffffffffa025db37>] smb3_validate_negotiate+0x107/0x2e0 [cifs]
[   14.643336]  [<ffffffffa025b1eb>] SMB2_tcon+0x29b/0x510 [cifs]
[   14.643921]  [<ffffffffa0230c5b>] cifs_get_tcon+0x1bb/0x560 [cifs]
[   14.644501]  [<ffffffffa02335f0>] cifs_mount+0x690/0xde0 [cifs]
[   14.645061]  [<ffffffffa021f6eb>] cifs_do_mount+0xcb/0x5a0 [cifs]
[   14.645618]  [<ffffffff81196057>] ? alloc_pages_current+0x87/0x110
[   14.646149]  [<ffffffff811baa83>] mount_fs+0x33/0x160
[   14.646663]  [<ffffffff811d4b22>] vfs_kern_mount+0x62/0x100
[   14.647163]  [<ffffffff811d6edb>] do_mount+0x21b/0xd30
[   14.647653]  [<ffffffff81196057>] ? alloc_pages_current+0x87/0x110
[   14.648128]  [<ffffffff811d7d07>] SyS_mount+0x87/0xd0
[   14.648591]  [<ffffffff817db31b>] entry_SYSCALL_64_fastpath+0x18/0x93
[   14.649047] Code: 89 e5 8b 12 e8 a8 cd 04 00 31 c0 5d c3 0f 1f 40 00 55 48 89 e5 41 57 41 56 41 55 41 54 49 89 fd 53 49 89 f6 41 89 d7 48 83 ec 10 <4c> 8b 67 50 41 8b 5c 24 2c 48 85 de 75 14 41 ff 54 24 e8 48 83 
[   14.650496] RIP  [<ffffffff8139221a>] crypto_shash_setkey+0x1a/0xc0
[   14.650953]  RSP <ffff8800b9d4f9a8>
[   14.651397] CR2: 0000000000000050
[   14.651861] ---[ end trace c98f651d4ccb0d7d ]---


Regards,
Srivatsa
