From: Leif Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: NULL pointer dereference in SMB2_tcon on 4.14-rc4
Date: Tue, 10 Oct 2017 18:16:47 -0400 (EDT)
Message-ID: <1267010345.14771631.1507673807855.JavaMail.zimbra@redhat.com>
References: <20171010200147.mdehq3aq64zvruvu@petr-dev3.eng.vmware.com> <CAN05THRn85aqJdTpks5GM_oARQcvPEzdUn+qkUyaRch5=_pXqQ@mail.gmail.com> <CA+i2_DfZ0D4W3U8-xkcegBnWYV-ooBUmR3ZdEq0EEA_fffZeHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: ronnie sahlberg <ronniesahlberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Petr Vandrovec <petr-vPk2MGR0e28uaRcfnNAh7A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+i2_DfZ0D4W3U8-xkcegBnWYV-ooBUmR3ZdEq0EEA_fffZeHw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Can you test this patch :
===
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6f0e6343c15e..6ff4c275ca9a 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1255,7 +1255,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
        struct smb2_tree_connect_req *req;
        struct smb2_tree_connect_rsp *rsp = NULL;
        struct kvec iov[2];
-       struct kvec rsp_iov;
+       struct kvec rsp_iov = { NULL, 0 };
        int rc = 0;
        int resp_buftype;
        int unc_path_len;
@@ -1315,6 +1315,8 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
        rc = SendReceive2(xid, ses, iov, 2, &resp_buftype, flags, &rsp_iov);
        cifs_small_buf_release(req);
        rsp = (struct smb2_tree_connect_rsp *)rsp_iov.iov_base;
+       if (rsp == NULL)
+               goto tcon_exit;
 
        if (rc != 0) {
                if (tcon) {
===

There are several places where SendReceive2 would return an error without setting rsp_iov, thus leaving it uninitialized.
I think this patch should work but please test it. If you can confirm it I will re-send it as a proper patch to the list.

(there was another similar issue not that long ago for the same thing. SendReceive2 returning an error and rsp being uninitialized.
we should audit the rest of smb2pdu.c if there are other instances as well.)


regards
Ronnie Sahlberg


----- Original Message -----
From: "Petr Vandrovec" <petr-vPk2MGR0e28uaRcfnNAh7A@public.gmane.org>
To: "ronnie sahlberg" <ronniesahlberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Sent: Wednesday, 11 October, 2017 9:02:18 AM
Subject: Re: NULL pointer dereference in SMB2_tcon on 4.14-rc4

On Tue, Oct 10, 2017 at 2:49 PM, ronnie sahlberg
<ronniesahlberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Another NULL pointer deref in an error path.
>
> Is it reproduceable ? I.e. can you reproduce at will  and verify a patch ?

Hi,
  yes, I can reproduce it at will.

It is triggered by trying to mount share that requires encryption.
Replacing target of goto in error path for rc != 0 with tcon_exit was
enough to stop crashes, and let me figure out what's wrong with
server...

Thanks, Petr

P.S.: Ronnie, you'll get this twice.  My first response was rejected
by vger as apparently gmail client on my cellphone sends html emails.

>
> On Wed, Oct 11, 2017 at 6:01 AM, Petr Vandrovec <petr-vPk2MGR0e28uaRcfnNAh7A@public.gmane.org> wrote:
>> Hi,
>>    I just installed today's Linux tree, and it seems that my environment
>> managed to render CIFS connection establishment unhappy:  negotiate failed with
>> -11 (EAGAIN), and after that SMB2_tcon dereferenced NULL pointer:
>>
>> 1374  tcon_error_exit:
>> 1375        if (rsp->hdr.sync_hdr.Status == STATUS_BAD_NETWORK_NAME) {   <<< rsp is NULL
>> 1376                cifs_dbg(VFS, "BAD_NETWORK_NAME: %s\n", tree);
>> 1377        }
>> 1378        goto tcon_exit;
>>
>> [   28.678303] No dialect specified on mount. Default has changed to a more secure dialect, SMB2.1 or later (e.g. SMB3), from CIFS (SMB1). To use the less secure SMB1 dialect to access old servers which do not support SMB3 (or SMB2.1) specify vers=1.0 on mount.
>> [   28.943404] CIFS VFS: validate protocol negotiate failed: -11
>> [   28.949625] BUG: unable to handle kernel NULL pointer dereference at 000000000000000c
>> [   28.957529] IP: SMB2_tcon+0x174/0x500 [cifs]
>> [   28.959620] PGD 0 P4D 0
>> [   28.959620] Oops: 0000 [#1] PREEMPT SMP
>> [   28.959620] Modules linked in: deflate twofish_generic twofish_avx_x86_64 twofish_x86_64_3way twofish_x86_64 twofish_common arc4 camellia_generic md4 rpcsec_gss_krb5 nls_iso8859_2 nfsv4 cifs nfs xt_REDIRECT nf_nat_redirect ccm fscache camellia_aesni_avx_x86_64 camellia_x86_64 serpent_avx_x86_64 serpent_sse2_x86_64 serpent_generic lrw blowfish_generic blowfish_x86_64 blowfish_common cast5_avx_x86_64 cast5_generic cast_common ablk_helper des_generic cmac xcbc rmd160 af_key xfrm_algo fuse vmw_vsock_vmci_transport vsock vmw_vmci iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c binfmt_misc snd_hda_codec_hdmi coretemp hwmon x86_pkg_temp_thermal snd_hda_codec_realtek uas crct10dif_pclmul snd_hda_codec_generic crc32_pclmul e1000e snd_hda_intel crc32c_int
 el
>> snd_hda_codec
>> [   29.031542]  ghash_clmulni_intel snd_hwdep ptp usb_storage pcbc input_leds dcdbas snd_hda_core snd_pcm_oss aesni_intel snd_mixer_oss aes_x86_64 sr_mod crypto_simd snd_pcm glue_helper cdrom cryptd i2c_i801 snd_timer tpm_tis mei_me tpm_tis_core mei sg snd tpm pps_core iTCO_wdt iTCO_vendor_support lpc_ich mfd_core nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables x_tables ipv6 crc_ccitt autofs4
>> [   29.072575] CPU: 7 PID: 5135 Comm: mount.cifs Not tainted 4.14.0-rc4-64-00055-ge543917e38f8 #5
>> [   29.072575] Hardware name: Dell Inc. Precision T3610/09M8Y8, BIOS A12 09/09/2016
>> [   29.072575] task: ffff880ffd809d80 task.stack: ffffc90000f14000
>> [   29.072575] RIP: 0010:SMB2_tcon+0x174/0x500 [cifs]
>> [   29.072575] RSP: 0018:ffffc90000f17c00 EFLAGS: 00010246
>> [   29.072575] RAX: ffff881001b0c101 RBX: 0000000000000000 RCX: 0000000000000000
>> [   29.072575] RDX: ffffc90000f17c20 RSI: ffff88106e9dc650 RDI: ffffea004006c300
>> [   29.072575] RBP: ffffc90000f17c80 R08: 000000000001c650 R09: ffffffffa064b1c1
>> [   29.072575] R10: ffffea004061d3c0 R11: ffff88106e403800 R12: ffff881001ad5c00
>> [   29.072575] R13: ffff8810061eefa0 R14: ffff880ff4b19400 R15: 00000000fffffff5
>> [   29.072575] FS:  00007fb2bd7e1740(0000) GS:ffff88106e9c0000(0000) knlGS:0000000000000000
>> [   29.072575] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   29.072575] CR2: 000000000000000c CR3: 0000000ffd9c9005 CR4: 00000000001606e0
>> [   29.072575] Call Trace:
>> [   29.072575]  ? get_dfs_path+0x189/0x260 [cifs]
>> [   29.072575]  get_dfs_path+0x189/0x260 [cifs]
>> [   29.072575]  expand_dfs_referral+0x133/0x2b0 [cifs]
>> [   29.072575]  ? tconInfoFree+0x4a/0xa0 [cifs]
>> [   29.072575]  ? cifs_get_tcon+0x35e/0x580 [cifs]
>> [   29.072575]  cifs_mount+0xc6b/0xe10 [cifs]
>> [   29.072575]  ? cifs_do_mount+0x134/0x5a0 [cifs]
>> [   29.072575]  cifs_do_mount+0x134/0x5a0 [cifs]
>> [   29.072575]  ? cpumask_next+0x16/0x20
>> [   29.072575]  ? pcpu_alloc+0x2cd/0x4f0
>> [   29.072575]  mount_fs+0x2b/0x150
>> [   29.072575]  vfs_kern_mount.part.7+0x4f/0x120
>> [   29.072575]  do_mount+0x5b2/0xca0
>> [   29.072575]  SyS_mount+0x50/0xd0
>> [   29.072575]  entry_SYSCALL_64_fastpath+0x1e/0xa9
>> [   29.072575] RIP: 0033:0x7fb2bd14823a
>> [   29.072575] RSP: 002b:00007fff85121678 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
>> [   29.072575] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fb2bd14823a
>> [   29.072575] RDX: 0000555e7d550fd5 RSI: 0000555e7d55101c RDI: 00007fff85121ef5
>> [   29.072575] RBP: 0000000000000001 R08: 0000555e7edae0f0 R09: 0000000000001010
>> [   29.072575] R10: 0000000000000006 R11: 0000000000000206 R12: 0000000000000000
>> [   29.072575] R13: 0000000000000004 R14: 0000000000000001 R15: 0000000000000000
>> [   29.072575] Code: fe ff 48 8b 7d 98 41 89 c7 e8 09 bb fe ff 45 85 ff 48 8b 4d a0 5a 74 4b 48 85 db 74 0e f0 ff 83 c8 05 00 00 80 8b d3 06 00 00 01 <81> 79 0c cc 00 00 c0 0f 84 eb 01 00 00 8b 7d 94
>> 48 89 ce e8 34
>> [   29.072575] RIP: SMB2_tcon+0x174/0x500 [cifs] RSP: ffffc90000f17c00
>> [   29.072575] CR2: 000000000000000c
>> [   29.078495] ---[ end trace 36f096a95567d971 ]---
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
