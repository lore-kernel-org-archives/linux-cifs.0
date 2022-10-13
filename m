Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81186C433FE
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Oct 2022 04:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiJMEsZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Oct 2022 00:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiJMEsY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 13 Oct 2022 00:48:24 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C78FEE896
        for <linux-cifs@vger.kernel.org>; Wed, 12 Oct 2022 21:48:22 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id v68so675113vsb.1
        for <linux-cifs@vger.kernel.org>; Wed, 12 Oct 2022 21:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qLqNd8IVr5E3i86CyGuRIKh+86ZP7ejlfYvOqWtIodM=;
        b=XL18uU6X0s4r7fNk6QYMLq1+pm1YJlCXZce9Kj5464+Xte0869P/21yqHzfT+hX0oI
         5aQ51iQ+Lm1ZNGLNEIYK2cOipGfJvho/tZOaNUjflV2Yq3JJofm5uYfxsy1ajrNm8Kpu
         0ByJ28KcOhUbiT5RdsDLDexarXJyLAI9bL6DBKVdnIYySgWMNnTFJOGe9CmgWBB5rYaR
         g7HHZpyfOYjLHeI4sYxjBNyd1J7hh5A+j6iq0Pg/TQygp2g9Emsu2PS7ARym9Pww2BD3
         65Id0Hp7DipnMohWoDoNPZQCRrZp4klpB0t1HSkaia2/LoHI3lH5zR1VzfOuvgxMOo/F
         oDJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qLqNd8IVr5E3i86CyGuRIKh+86ZP7ejlfYvOqWtIodM=;
        b=hmZFqR845OVwkfmLIdEzRvP6X3oKCWlSzFjFZ2Gcbngftyv1qlJT0lX8jbAIbj9Ew0
         5deYas5QMw2pJQ9W/djsYwnJqSssN6AArNAxC3D1i0w8WvCp5XtO8HbIlnTEh8v9roGv
         PddoZX6jHEt8MQh7a3RKkI2zS0U36hNc3eE0r1WyNQyfay8cGWBcDs7XdRXL8sZVkDBp
         E9i6E9hdoP4O2HYaRsVpaSR/Un7kORKfbNlt3V1qcM0s6SpfIChR6VNuJJIWB3fRTVdM
         jSOr7Wu2gQ2hU2fvxyV8WfazMbxUff84hSMr+IxjdtInMQtoyJAorwOS+8lgx3O+uBVU
         c6qg==
X-Gm-Message-State: ACrzQf1Q3YVSeoJjnGUjCj2RjBAZDcCeWCbSCIoiVGxkcPWkDk6lCQYM
        xzPR2oK6kBlktxURADWQnNkIKnIEfnBEtBSMtx36niH8
X-Google-Smtp-Source: AMsMyM5xEvLirn+o2J0FMqNeMTAKrDQAuuBwGc+k5gwOABsar4qMU0O6Q8egOjS/HbQmubXIgQ9eFLqHHWy/gxd2fxY=
X-Received: by 2002:a67:fc97:0:b0:3a6:d37e:e7a3 with SMTP id
 x23-20020a67fc97000000b003a6d37ee7a3mr15220175vsp.29.1665636500905; Wed, 12
 Oct 2022 21:48:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220918034354.17836-1-ematsumiya@suse.de>
In-Reply-To: <20220918034354.17836-1-ematsumiya@suse.de>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 12 Oct 2022 23:48:08 -0500
Message-ID: <CAH2r5muounmhTKzaMnBCmUHF52cXiBf7VPq4wMCHGAUnV9daUA@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: use ALIGN() and round_up() macros
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Content-Type: multipart/mixed; boundary="000000000000f6395a05eae3378e"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000f6395a05eae3378e
Content-Type: text/plain; charset="UTF-8"

updated version of the patch attached.  Shrunk slightly (e.g. removing
a few places where readability is only marginally improved but code is
exactly equivalent), but left in the conversions from ROUND_UP --->
ALIGN etc

tentatively merged into cifs-2.6.git for-next

Let me know if any objections or RB to add

On Sat, Sep 17, 2022 at 10:43 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> Improve code readability by using existing macros:
>
> Replace hardcoded alignment computations (e.g. (len + 7) & ~0x7) by
> ALIGN()/IS_ALIGNED() macros.
>
> Also replace (DIV_ROUND_UP(len, 8) * 8) with ALIGN(len, 8), which, if
> not optimized by the compiler, has the overhead of a multiplication
> and a division. Do the same for roundup() by replacing it by round_up()
> (division-less version, but requires the multiple to be a power of 2,
> which is always the case for us).
>
> And remove some unnecessary checks where !IS_ALIGNED() would fit, but
> calling round_up() directly is fine as it's a no-op if the value is
> already aligned.
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
> v2: drop performance claims, adjust commit title/message -- patch is the same
>
>  fs/cifs/cifssmb.c   |  7 +++---
>  fs/cifs/connect.c   | 11 ++++++--
>  fs/cifs/sess.c      | 18 +++++--------
>  fs/cifs/smb2inode.c |  4 +--
>  fs/cifs/smb2misc.c  |  2 +-
>  fs/cifs/smb2pdu.c   | 61 +++++++++++++++++++--------------------------
>  6 files changed, 47 insertions(+), 56 deletions(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 7aa91e272027..addf3fc62aef 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -2305,7 +2305,7 @@ int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tcon *pTcon,
>                                         remap);
>         }
>         rename_info->target_name_len = cpu_to_le32(2 * len_of_str);
> -       count = 12 /* sizeof(struct set_file_rename) */ + (2 * len_of_str);
> +       count = sizeof(struct set_file_rename) + (2 * len_of_str);
>         byte_count += count;
>         pSMB->DataCount = cpu_to_le16(count);
>         pSMB->TotalDataCount = pSMB->DataCount;
> @@ -2796,7 +2796,7 @@ CIFSSMBQuerySymLink(const unsigned int xid, struct cifs_tcon *tcon,
>                 cifs_dbg(FYI, "Invalid return data count on get reparse info ioctl\n");
>                 goto qreparse_out;
>         }
> -       end_of_smb = 2 + get_bcc(&pSMBr->hdr) + (char *)&pSMBr->ByteCount;
> +       end_of_smb = sizeof(__le16) + get_bcc(&pSMBr->hdr) + (char *)&pSMBr->ByteCount;
>         reparse_buf = (struct reparse_symlink_data *)
>                                 ((char *)&pSMBr->hdr.Protocol + data_offset);
>         if ((char *)reparse_buf >= end_of_smb) {
> @@ -3350,8 +3350,7 @@ validate_ntransact(char *buf, char **ppparm, char **ppdata,
>         pSMBr = (struct smb_com_ntransact_rsp *)buf;
>
>         bcc = get_bcc(&pSMBr->hdr);
> -       end_of_smb = 2 /* sizeof byte count */ + bcc +
> -                       (char *)&pSMBr->ByteCount;
> +       end_of_smb = sizeof(__le16) + bcc + (char *)&pSMBr->ByteCount;
>
>         data_offset = le32_to_cpu(pSMBr->DataOffset);
>         data_count = le32_to_cpu(pSMBr->DataCount);
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 7ae6f2c08153..8a26ba7fc707 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2831,9 +2831,12 @@ ip_rfc1001_connect(struct TCP_Server_Info *server)
>          * sessinit is sent but no second negprot
>          */
>         struct rfc1002_session_packet *ses_init_buf;
> +       unsigned int req_noscope_len;
>         struct smb_hdr *smb_buf;
> +
>         ses_init_buf = kzalloc(sizeof(struct rfc1002_session_packet),
>                                GFP_KERNEL);
> +
>         if (ses_init_buf) {
>                 ses_init_buf->trailer.session_req.called_len = 32;
>
> @@ -2869,8 +2872,12 @@ ip_rfc1001_connect(struct TCP_Server_Info *server)
>                 ses_init_buf->trailer.session_req.scope2 = 0;
>                 smb_buf = (struct smb_hdr *)ses_init_buf;
>
> -               /* sizeof RFC1002_SESSION_REQUEST with no scope */
> -               smb_buf->smb_buf_length = cpu_to_be32(0x81000044);
> +               /* sizeof RFC1002_SESSION_REQUEST with no scopes */
> +               req_noscope_len = sizeof(struct rfc1002_session_packet) - 2;
> +
> +               /* == cpu_to_be32(0x81000044) */
> +               smb_buf->smb_buf_length =
> +                       cpu_to_be32((RFC1002_SESSION_REQUEST << 24) | req_noscope_len);
>                 rc = smb_send(server, smb_buf, 0x44);
>                 kfree(ses_init_buf);
>                 /*
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 3af3b05b6c74..951874928d70 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -601,11 +601,6 @@ static void unicode_ssetup_strings(char **pbcc_area, struct cifs_ses *ses,
>         /* BB FIXME add check that strings total less
>         than 335 or will need to send them as arrays */
>
> -       /* unicode strings, must be word aligned before the call */
> -/*     if ((long) bcc_ptr % 2) {
> -               *bcc_ptr = 0;
> -               bcc_ptr++;
> -       } */
>         /* copy user */
>         if (ses->user_name == NULL) {
>                 /* null user mount */
> @@ -1318,7 +1313,7 @@ sess_auth_ntlmv2(struct sess_data *sess_data)
>         }
>
>         if (ses->capabilities & CAP_UNICODE) {
> -               if (sess_data->iov[0].iov_len % 2) {
> +               if (!IS_ALIGNED(sess_data->iov[0].iov_len, 2)) {
>                         *bcc_ptr = 0;
>                         bcc_ptr++;
>                 }
> @@ -1358,7 +1353,7 @@ sess_auth_ntlmv2(struct sess_data *sess_data)
>                 /* no string area to decode, do nothing */
>         } else if (smb_buf->Flags2 & SMBFLG2_UNICODE) {
>                 /* unicode string area must be word-aligned */
> -               if (((unsigned long) bcc_ptr - (unsigned long) smb_buf) % 2) {
> +               if (!IS_ALIGNED((unsigned long)bcc_ptr - (unsigned long)smb_buf, 2)) {
>                         ++bcc_ptr;
>                         --bytes_remaining;
>                 }
> @@ -1442,8 +1437,7 @@ sess_auth_kerberos(struct sess_data *sess_data)
>
>         if (ses->capabilities & CAP_UNICODE) {
>                 /* unicode strings must be word aligned */
> -               if ((sess_data->iov[0].iov_len
> -                       + sess_data->iov[1].iov_len) % 2) {
> +               if (!IS_ALIGNED(sess_data->iov[0].iov_len + sess_data->iov[1].iov_len, 2)) {
>                         *bcc_ptr = 0;
>                         bcc_ptr++;
>                 }
> @@ -1494,7 +1488,7 @@ sess_auth_kerberos(struct sess_data *sess_data)
>                 /* no string area to decode, do nothing */
>         } else if (smb_buf->Flags2 & SMBFLG2_UNICODE) {
>                 /* unicode string area must be word-aligned */
> -               if (((unsigned long) bcc_ptr - (unsigned long) smb_buf) % 2) {
> +               if (!IS_ALIGNED((unsigned long)bcc_ptr - (unsigned long)smb_buf, 2)) {
>                         ++bcc_ptr;
>                         --bytes_remaining;
>                 }
> @@ -1546,7 +1540,7 @@ _sess_auth_rawntlmssp_assemble_req(struct sess_data *sess_data)
>
>         bcc_ptr = sess_data->iov[2].iov_base;
>         /* unicode strings must be word aligned */
> -       if ((sess_data->iov[0].iov_len + sess_data->iov[1].iov_len) % 2) {
> +       if (!IS_ALIGNED(sess_data->iov[0].iov_len + sess_data->iov[1].iov_len, 2)) {
>                 *bcc_ptr = 0;
>                 bcc_ptr++;
>         }
> @@ -1747,7 +1741,7 @@ sess_auth_rawntlmssp_authenticate(struct sess_data *sess_data)
>                 /* no string area to decode, do nothing */
>         } else if (smb_buf->Flags2 & SMBFLG2_UNICODE) {
>                 /* unicode string area must be word-aligned */
> -               if (((unsigned long) bcc_ptr - (unsigned long) smb_buf) % 2) {
> +               if (!IS_ALIGNED((unsigned long)bcc_ptr - (unsigned long)smb_buf, 2)) {
>                         ++bcc_ptr;
>                         --bytes_remaining;
>                 }
> diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> index b83f59051b26..4eefbe574b82 100644
> --- a/fs/cifs/smb2inode.c
> +++ b/fs/cifs/smb2inode.c
> @@ -207,7 +207,7 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
>                 rqst[num_rqst].rq_iov = &vars->si_iov[0];
>                 rqst[num_rqst].rq_nvec = 1;
>
> -               size[0] = 1; /* sizeof __u8 See MS-FSCC section 2.4.11 */
> +               size[0] = sizeof(u8); /* See MS-FSCC section 2.4.11 */
>                 data[0] = &delete_pending[0];
>
>                 rc = SMB2_set_info_init(tcon, server,
> @@ -225,7 +225,7 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
>                 rqst[num_rqst].rq_iov = &vars->si_iov[0];
>                 rqst[num_rqst].rq_nvec = 1;
>
> -               size[0] = 8; /* sizeof __le64 */
> +               size[0] = sizeof(__le64);
>                 data[0] = ptr;
>
>                 rc = SMB2_set_info_init(tcon, server,
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index d73e5672aac4..258b01306d85 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -248,7 +248,7 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *server)
>                  * Some windows servers (win2016) will pad also the final
>                  * PDU in a compound to 8 bytes.
>                  */
> -               if (((calc_len + 7) & ~7) == len)
> +               if (ALIGN(calc_len, 8) == len)
>                         return 0;
>
>                 /*
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 6352ab32c7e7..5da0b596c8a0 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -466,15 +466,14 @@ build_signing_ctxt(struct smb2_signing_capabilities *pneg_ctxt)
>         /*
>          * Context Data length must be rounded to multiple of 8 for some servers
>          */
> -       pneg_ctxt->DataLength = cpu_to_le16(DIV_ROUND_UP(
> -                               sizeof(struct smb2_signing_capabilities) -
> -                               sizeof(struct smb2_neg_context) +
> -                               (num_algs * 2 /* sizeof u16 */), 8) * 8);
> +       pneg_ctxt->DataLength = cpu_to_le16(ALIGN(sizeof(struct smb2_signing_capabilities) -
> +                                           sizeof(struct smb2_neg_context) +
> +                                           (num_algs * sizeof(u16)), 8));
>         pneg_ctxt->SigningAlgorithmCount = cpu_to_le16(num_algs);
>         pneg_ctxt->SigningAlgorithms[0] = cpu_to_le16(SIGNING_ALG_AES_CMAC);
>
> -       ctxt_len += 2 /* sizeof le16 */ * num_algs;
> -       ctxt_len = DIV_ROUND_UP(ctxt_len, 8) * 8;
> +       ctxt_len += sizeof(__le16) * num_algs;
> +       ctxt_len = ALIGN(ctxt_len, 8);
>         return ctxt_len;
>         /* TBD add SIGNING_ALG_AES_GMAC and/or SIGNING_ALG_HMAC_SHA256 */
>  }
> @@ -511,8 +510,7 @@ build_netname_ctxt(struct smb2_netname_neg_context *pneg_ctxt, char *hostname)
>         /* copy up to max of first 100 bytes of server name to NetName field */
>         pneg_ctxt->DataLength = cpu_to_le16(2 * cifs_strtoUTF16(pneg_ctxt->NetName, hostname, 100, cp));
>         /* context size is DataLength + minimal smb2_neg_context */
> -       return DIV_ROUND_UP(le16_to_cpu(pneg_ctxt->DataLength) +
> -                       sizeof(struct smb2_neg_context), 8) * 8;
> +       return ALIGN(le16_to_cpu(pneg_ctxt->DataLength) + sizeof(struct smb2_neg_context), 8);
>  }
>
>  static void
> @@ -557,18 +555,18 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
>          * round up total_len of fixed part of SMB3 negotiate request to 8
>          * byte boundary before adding negotiate contexts
>          */
> -       *total_len = roundup(*total_len, 8);
> +       *total_len = ALIGN(*total_len, 8);
>
>         pneg_ctxt = (*total_len) + (char *)req;
>         req->NegotiateContextOffset = cpu_to_le32(*total_len);
>
>         build_preauth_ctxt((struct smb2_preauth_neg_context *)pneg_ctxt);
> -       ctxt_len = DIV_ROUND_UP(sizeof(struct smb2_preauth_neg_context), 8) * 8;
> +       ctxt_len = ALIGN(sizeof(struct smb2_preauth_neg_context), 8);
>         *total_len += ctxt_len;
>         pneg_ctxt += ctxt_len;
>
>         build_encrypt_ctxt((struct smb2_encryption_neg_context *)pneg_ctxt);
> -       ctxt_len = DIV_ROUND_UP(sizeof(struct smb2_encryption_neg_context), 8) * 8;
> +       ctxt_len = ALIGN(sizeof(struct smb2_encryption_neg_context), 8);
>         *total_len += ctxt_len;
>         pneg_ctxt += ctxt_len;
>
> @@ -595,9 +593,7 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
>         if (server->compress_algorithm) {
>                 build_compression_ctxt((struct smb2_compression_capabilities_context *)
>                                 pneg_ctxt);
> -               ctxt_len = DIV_ROUND_UP(
> -                       sizeof(struct smb2_compression_capabilities_context),
> -                               8) * 8;
> +               ctxt_len = ALIGN(sizeof(struct smb2_compression_capabilities_context), 8);
>                 *total_len += ctxt_len;
>                 pneg_ctxt += ctxt_len;
>                 neg_context_count++;
> @@ -780,7 +776,7 @@ static int smb311_decode_neg_context(struct smb2_negotiate_rsp *rsp,
>                 if (rc)
>                         break;
>                 /* offsets must be 8 byte aligned */
> -               clen = (clen + 7) & ~0x7;
> +               clen = ALIGN(clen, 8);
>                 offset += clen + sizeof(struct smb2_neg_context);
>                 len_of_ctxts -= clen;
>         }
> @@ -2413,7 +2409,7 @@ create_sd_buf(umode_t mode, bool set_owner, unsigned int *len)
>         unsigned int group_offset = 0;
>         struct smb3_acl acl;
>
> -       *len = roundup(sizeof(struct crt_sd_ctxt) + (sizeof(struct cifs_ace) * 4), 8);
> +       *len = round_up(sizeof(struct crt_sd_ctxt) + (sizeof(struct cifs_ace) * 4), 8);
>
>         if (set_owner) {
>                 /* sizeof(struct owner_group_sids) is already multiple of 8 so no need to round */
> @@ -2487,7 +2483,7 @@ create_sd_buf(umode_t mode, bool set_owner, unsigned int *len)
>         memcpy(aclptr, &acl, sizeof(struct smb3_acl));
>
>         buf->ccontext.DataLength = cpu_to_le32(ptr - (__u8 *)&buf->sd);
> -       *len = roundup(ptr - (__u8 *)buf, 8);
> +       *len = round_up((unsigned int)(ptr - (__u8 *)buf), 8);
>
>         return buf;
>  }
> @@ -2581,7 +2577,7 @@ alloc_path_with_tree_prefix(__le16 **out_path, int *out_size, int *out_len,
>          * final path needs to be 8-byte aligned as specified in
>          * MS-SMB2 2.2.13 SMB2 CREATE Request.
>          */
> -       *out_size = roundup(*out_len * sizeof(__le16), 8);
> +       *out_size = round_up(*out_len * sizeof(__le16), 8);
>         *out_path = kzalloc(*out_size + sizeof(__le16) /* null */, GFP_KERNEL);
>         if (!*out_path)
>                 return -ENOMEM;
> @@ -2687,20 +2683,17 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
>                 uni_path_len = (2 * UniStrnlen((wchar_t *)utf16_path, PATH_MAX)) + 2;
>                 /* MUST set path len (NameLength) to 0 opening root of share */
>                 req->NameLength = cpu_to_le16(uni_path_len - 2);
> -               if (uni_path_len % 8 != 0) {
> -                       copy_size = roundup(uni_path_len, 8);
> -                       copy_path = kzalloc(copy_size, GFP_KERNEL);
> -                       if (!copy_path) {
> -                               rc = -ENOMEM;
> -                               goto err_free_req;
> -                       }
> -                       memcpy((char *)copy_path, (const char *)utf16_path,
> -                              uni_path_len);
> -                       uni_path_len = copy_size;
> -                       /* free before overwriting resource */
> -                       kfree(utf16_path);
> -                       utf16_path = copy_path;
> +               copy_size = round_up(uni_path_len, 8);
> +               copy_path = kzalloc(copy_size, GFP_KERNEL);
> +               if (!copy_path) {
> +                       rc = -ENOMEM;
> +                       goto err_free_req;
>                 }
> +               memcpy((char *)copy_path, (const char *)utf16_path, uni_path_len);
> +               uni_path_len = copy_size;
> +               /* free before overwriting resource */
> +               kfree(utf16_path);
> +               utf16_path = copy_path;
>         }
>
>         iov[1].iov_len = uni_path_len;
> @@ -2826,9 +2819,7 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
>                 uni_path_len = (2 * UniStrnlen((wchar_t *)path, PATH_MAX)) + 2;
>                 /* MUST set path len (NameLength) to 0 opening root of share */
>                 req->NameLength = cpu_to_le16(uni_path_len - 2);
> -               copy_size = uni_path_len;
> -               if (copy_size % 8 != 0)
> -                       copy_size = roundup(copy_size, 8);
> +               copy_size = round_up(uni_path_len, 8);
>                 copy_path = kzalloc(copy_size, GFP_KERNEL);
>                 if (!copy_path)
>                         return -ENOMEM;
> @@ -4090,7 +4081,7 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
>         if (request_type & CHAINED_REQUEST) {
>                 if (!(request_type & END_OF_CHAIN)) {
>                         /* next 8-byte aligned request */
> -                       *total_len = DIV_ROUND_UP(*total_len, 8) * 8;
> +                       *total_len = ALIGN(*total_len, 8);
>                         shdr->NextCommand = cpu_to_le32(*total_len);
>                 } else /* END_OF_CHAIN */
>                         shdr->NextCommand = 0;
> --
> 2.35.3
>


-- 
Thanks,

Steve

--000000000000f6395a05eae3378e
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-use-ALIGN-and-round_up-macros.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-use-ALIGN-and-round_up-macros.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l96kxpub0>
X-Attachment-Id: f_l96kxpub0

RnJvbSBlYzc1YWY1YmQzY2UxODFjY2YxMmFhM2Q1Y2JjNGQ1ZmFjNGU5Y2FkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFbnpvIE1hdHN1bWl5YSA8ZW1hdHN1bWl5YUBzdXNlLmRlPgpE
YXRlOiBXZWQsIDEyIE9jdCAyMDIyIDIyOjUzOjA5IC0wNTAwClN1YmplY3Q6IFtQQVRDSF0gY2lm
czogdXNlIEFMSUdOKCkgYW5kIHJvdW5kX3VwKCkgbWFjcm9zCgpJbXByb3ZlIGNvZGUgcmVhZGFi
aWxpdHkgYnkgdXNpbmcgZXhpc3RpbmcgbWFjcm9zOgoKUmVwbGFjZSBoYXJkY29kZWQgYWxpZ25t
ZW50IGNvbXB1dGF0aW9ucyAoZS5nLiAobGVuICsgNykgJiB+MHg3KSBieQpBTElHTigpL0lTX0FM
SUdORUQoKSBtYWNyb3MuCgpBbHNvIHJlcGxhY2UgKERJVl9ST1VORF9VUChsZW4sIDgpICogOCkg
d2l0aCBBTElHTihsZW4sIDgpLCB3aGljaCwgaWYKbm90IG9wdGltaXplZCBieSB0aGUgY29tcGls
ZXIsIGhhcyB0aGUgb3ZlcmhlYWQgb2YgYSBtdWx0aXBsaWNhdGlvbgphbmQgYSBkaXZpc2lvbi4g
RG8gdGhlIHNhbWUgZm9yIHJvdW5kdXAoKSBieSByZXBsYWNpbmcgaXQgYnkgcm91bmRfdXAoKQoo
ZGl2aXNpb24tbGVzcyB2ZXJzaW9uLCBidXQgcmVxdWlyZXMgdGhlIG11bHRpcGxlIHRvIGJlIGEg
cG93ZXIgb2YgMiwKd2hpY2ggaXMgYWx3YXlzIHRoZSBjYXNlIGZvciB1cykuCgpBbmQgcmVtb3Zl
IHNvbWUgdW5uZWNlc3NhcnkgY2hlY2tzIHdoZXJlICFJU19BTElHTkVEKCkgd291bGQgZml0LCBi
dXQKY2FsbGluZyByb3VuZF91cCgpIGRpcmVjdGx5IGlzIGZpbmUgYXMgaXQncyBhIG5vLW9wIGlm
IHRoZSB2YWx1ZSBpcwphbHJlYWR5IGFsaWduZWQuCgpTaWduZWQtb2ZmLWJ5OiBFbnpvIE1hdHN1
bWl5YSA8ZW1hdHN1bWl5YUBzdXNlLmRlPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0
ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jaWZzc21iLmMgIHwgIDIgKy0KIGZz
L2NpZnMvY29ubmVjdC5jICB8IDExICsrKysrKystLQogZnMvY2lmcy9zZXNzLmMgICAgIHwgMTgg
KysrKystLS0tLS0tLS0KIGZzL2NpZnMvc21iMm1pc2MuYyB8ICAyICstCiBmcy9jaWZzL3NtYjJw
ZHUuYyAgfCA2MSArKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
CiA1IGZpbGVzIGNoYW5nZWQsIDQzIGluc2VydGlvbnMoKyksIDUxIGRlbGV0aW9ucygtKQoKZGlm
ZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc3NtYi5jIGIvZnMvY2lmcy9jaWZzc21iLmMKaW5kZXggN2E4
MDhlNDFiMWI4Li4xNzI0MDY2YzE1MzYgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc3NtYi5jCisr
KyBiL2ZzL2NpZnMvY2lmc3NtYi5jCkBAIC0yMzA1LDcgKzIzMDUsNyBAQCBpbnQgQ0lGU1NNQlJl
bmFtZU9wZW5GaWxlKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnBU
Y29uLAogCQkJCQlyZW1hcCk7CiAJfQogCXJlbmFtZV9pbmZvLT50YXJnZXRfbmFtZV9sZW4gPSBj
cHVfdG9fbGUzMigyICogbGVuX29mX3N0cik7Ci0JY291bnQgPSAxMiAvKiBzaXplb2Yoc3RydWN0
IHNldF9maWxlX3JlbmFtZSkgKi8gKyAoMiAqIGxlbl9vZl9zdHIpOworCWNvdW50ID0gc2l6ZW9m
KHN0cnVjdCBzZXRfZmlsZV9yZW5hbWUpICsgKDIgKiBsZW5fb2Zfc3RyKTsKIAlieXRlX2NvdW50
ICs9IGNvdW50OwogCXBTTUItPkRhdGFDb3VudCA9IGNwdV90b19sZTE2KGNvdW50KTsKIAlwU01C
LT5Ub3RhbERhdGFDb3VudCA9IHBTTUItPkRhdGFDb3VudDsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMv
Y29ubmVjdC5jIGIvZnMvY2lmcy9jb25uZWN0LmMKaW5kZXggZTE1ODI1N2RhMWNkLi5mZmIyOTE1
NzliYjkgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5jCisrKyBiL2ZzL2NpZnMvY29ubmVj
dC5jCkBAIC0yODMyLDkgKzI4MzIsMTIgQEAgaXBfcmZjMTAwMV9jb25uZWN0KHN0cnVjdCBUQ1Bf
U2VydmVyX0luZm8gKnNlcnZlcikKIAkgKiBzZXNzaW5pdCBpcyBzZW50IGJ1dCBubyBzZWNvbmQg
bmVncHJvdAogCSAqLwogCXN0cnVjdCByZmMxMDAyX3Nlc3Npb25fcGFja2V0ICpzZXNfaW5pdF9i
dWY7CisJdW5zaWduZWQgaW50IHJlcV9ub3Njb3BlX2xlbjsKIAlzdHJ1Y3Qgc21iX2hkciAqc21i
X2J1ZjsKKwogCXNlc19pbml0X2J1ZiA9IGt6YWxsb2Moc2l6ZW9mKHN0cnVjdCByZmMxMDAyX3Nl
c3Npb25fcGFja2V0KSwKIAkJCSAgICAgICBHRlBfS0VSTkVMKTsKKwogCWlmIChzZXNfaW5pdF9i
dWYpIHsKIAkJc2VzX2luaXRfYnVmLT50cmFpbGVyLnNlc3Npb25fcmVxLmNhbGxlZF9sZW4gPSAz
MjsKIApAQCAtMjg3MCw4ICsyODczLDEyIEBAIGlwX3JmYzEwMDFfY29ubmVjdChzdHJ1Y3QgVENQ
X1NlcnZlcl9JbmZvICpzZXJ2ZXIpCiAJCXNlc19pbml0X2J1Zi0+dHJhaWxlci5zZXNzaW9uX3Jl
cS5zY29wZTIgPSAwOwogCQlzbWJfYnVmID0gKHN0cnVjdCBzbWJfaGRyICopc2VzX2luaXRfYnVm
OwogCi0JCS8qIHNpemVvZiBSRkMxMDAyX1NFU1NJT05fUkVRVUVTVCB3aXRoIG5vIHNjb3BlICov
Ci0JCXNtYl9idWYtPnNtYl9idWZfbGVuZ3RoID0gY3B1X3RvX2JlMzIoMHg4MTAwMDA0NCk7CisJ
CS8qIHNpemVvZiBSRkMxMDAyX1NFU1NJT05fUkVRVUVTVCB3aXRoIG5vIHNjb3BlcyAqLworCQly
ZXFfbm9zY29wZV9sZW4gPSBzaXplb2Yoc3RydWN0IHJmYzEwMDJfc2Vzc2lvbl9wYWNrZXQpIC0g
MjsKKworCQkvKiA9PSBjcHVfdG9fYmUzMigweDgxMDAwMDQ0KSAqLworCQlzbWJfYnVmLT5zbWJf
YnVmX2xlbmd0aCA9CisJCQljcHVfdG9fYmUzMigoUkZDMTAwMl9TRVNTSU9OX1JFUVVFU1QgPDwg
MjQpIHwgcmVxX25vc2NvcGVfbGVuKTsKIAkJcmMgPSBzbWJfc2VuZChzZXJ2ZXIsIHNtYl9idWYs
IDB4NDQpOwogCQlrZnJlZShzZXNfaW5pdF9idWYpOwogCQkvKgpkaWZmIC0tZ2l0IGEvZnMvY2lm
cy9zZXNzLmMgYi9mcy9jaWZzL3Nlc3MuYwppbmRleCBmMWMzYzZkOTE0NmMuLmM5ZWRlYzcwODFk
ZSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zZXNzLmMKKysrIGIvZnMvY2lmcy9zZXNzLmMKQEAgLTYw
MSwxMSArNjAxLDYgQEAgc3RhdGljIHZvaWQgdW5pY29kZV9zc2V0dXBfc3RyaW5ncyhjaGFyICoq
cGJjY19hcmVhLCBzdHJ1Y3QgY2lmc19zZXMgKnNlcywKIAkvKiBCQiBGSVhNRSBhZGQgY2hlY2sg
dGhhdCBzdHJpbmdzIHRvdGFsIGxlc3MKIAl0aGFuIDMzNSBvciB3aWxsIG5lZWQgdG8gc2VuZCB0
aGVtIGFzIGFycmF5cyAqLwogCi0JLyogdW5pY29kZSBzdHJpbmdzLCBtdXN0IGJlIHdvcmQgYWxp
Z25lZCBiZWZvcmUgdGhlIGNhbGwgKi8KLS8qCWlmICgobG9uZykgYmNjX3B0ciAlIDIpCXsKLQkJ
KmJjY19wdHIgPSAwOwotCQliY2NfcHRyKys7Ci0JfSAqLwogCS8qIGNvcHkgdXNlciAqLwogCWlm
IChzZXMtPnVzZXJfbmFtZSA9PSBOVUxMKSB7CiAJCS8qIG51bGwgdXNlciBtb3VudCAqLwpAQCAt
MTMyNCw3ICsxMzE5LDcgQEAgc2Vzc19hdXRoX250bG12MihzdHJ1Y3Qgc2Vzc19kYXRhICpzZXNz
X2RhdGEpCiAJfQogCiAJaWYgKHNlcy0+Y2FwYWJpbGl0aWVzICYgQ0FQX1VOSUNPREUpIHsKLQkJ
aWYgKHNlc3NfZGF0YS0+aW92WzBdLmlvdl9sZW4gJSAyKSB7CisJCWlmICghSVNfQUxJR05FRChz
ZXNzX2RhdGEtPmlvdlswXS5pb3ZfbGVuLCAyKSkgewogCQkJKmJjY19wdHIgPSAwOwogCQkJYmNj
X3B0cisrOwogCQl9CkBAIC0xMzY0LDcgKzEzNTksNyBAQCBzZXNzX2F1dGhfbnRsbXYyKHN0cnVj
dCBzZXNzX2RhdGEgKnNlc3NfZGF0YSkKIAkJLyogbm8gc3RyaW5nIGFyZWEgdG8gZGVjb2RlLCBk
byBub3RoaW5nICovCiAJfSBlbHNlIGlmIChzbWJfYnVmLT5GbGFnczIgJiBTTUJGTEcyX1VOSUNP
REUpIHsKIAkJLyogdW5pY29kZSBzdHJpbmcgYXJlYSBtdXN0IGJlIHdvcmQtYWxpZ25lZCAqLwot
CQlpZiAoKCh1bnNpZ25lZCBsb25nKSBiY2NfcHRyIC0gKHVuc2lnbmVkIGxvbmcpIHNtYl9idWYp
ICUgMikgeworCQlpZiAoIUlTX0FMSUdORUQoKHVuc2lnbmVkIGxvbmcpYmNjX3B0ciAtICh1bnNp
Z25lZCBsb25nKXNtYl9idWYsIDIpKSB7CiAJCQkrK2JjY19wdHI7CiAJCQktLWJ5dGVzX3JlbWFp
bmluZzsKIAkJfQpAQCAtMTQ0OCw4ICsxNDQzLDcgQEAgc2Vzc19hdXRoX2tlcmJlcm9zKHN0cnVj
dCBzZXNzX2RhdGEgKnNlc3NfZGF0YSkKIAogCWlmIChzZXMtPmNhcGFiaWxpdGllcyAmIENBUF9V
TklDT0RFKSB7CiAJCS8qIHVuaWNvZGUgc3RyaW5ncyBtdXN0IGJlIHdvcmQgYWxpZ25lZCAqLwot
CQlpZiAoKHNlc3NfZGF0YS0+aW92WzBdLmlvdl9sZW4KLQkJCSsgc2Vzc19kYXRhLT5pb3ZbMV0u
aW92X2xlbikgJSAyKSB7CisJCWlmICghSVNfQUxJR05FRChzZXNzX2RhdGEtPmlvdlswXS5pb3Zf
bGVuICsgc2Vzc19kYXRhLT5pb3ZbMV0uaW92X2xlbiwgMikpIHsKIAkJCSpiY2NfcHRyID0gMDsK
IAkJCWJjY19wdHIrKzsKIAkJfQpAQCAtMTUwMCw3ICsxNDk0LDcgQEAgc2Vzc19hdXRoX2tlcmJl
cm9zKHN0cnVjdCBzZXNzX2RhdGEgKnNlc3NfZGF0YSkKIAkJLyogbm8gc3RyaW5nIGFyZWEgdG8g
ZGVjb2RlLCBkbyBub3RoaW5nICovCiAJfSBlbHNlIGlmIChzbWJfYnVmLT5GbGFnczIgJiBTTUJG
TEcyX1VOSUNPREUpIHsKIAkJLyogdW5pY29kZSBzdHJpbmcgYXJlYSBtdXN0IGJlIHdvcmQtYWxp
Z25lZCAqLwotCQlpZiAoKCh1bnNpZ25lZCBsb25nKSBiY2NfcHRyIC0gKHVuc2lnbmVkIGxvbmcp
IHNtYl9idWYpICUgMikgeworCQlpZiAoIUlTX0FMSUdORUQoKHVuc2lnbmVkIGxvbmcpYmNjX3B0
ciAtICh1bnNpZ25lZCBsb25nKXNtYl9idWYsIDIpKSB7CiAJCQkrK2JjY19wdHI7CiAJCQktLWJ5
dGVzX3JlbWFpbmluZzsKIAkJfQpAQCAtMTU1Miw3ICsxNTQ2LDcgQEAgX3Nlc3NfYXV0aF9yYXdu
dGxtc3NwX2Fzc2VtYmxlX3JlcShzdHJ1Y3Qgc2Vzc19kYXRhICpzZXNzX2RhdGEpCiAKIAliY2Nf
cHRyID0gc2Vzc19kYXRhLT5pb3ZbMl0uaW92X2Jhc2U7CiAJLyogdW5pY29kZSBzdHJpbmdzIG11
c3QgYmUgd29yZCBhbGlnbmVkICovCi0JaWYgKChzZXNzX2RhdGEtPmlvdlswXS5pb3ZfbGVuICsg
c2Vzc19kYXRhLT5pb3ZbMV0uaW92X2xlbikgJSAyKSB7CisJaWYgKCFJU19BTElHTkVEKHNlc3Nf
ZGF0YS0+aW92WzBdLmlvdl9sZW4gKyBzZXNzX2RhdGEtPmlvdlsxXS5pb3ZfbGVuLCAyKSkgewog
CQkqYmNjX3B0ciA9IDA7CiAJCWJjY19wdHIrKzsKIAl9CkBAIC0xNzUzLDcgKzE3NDcsNyBAQCBz
ZXNzX2F1dGhfcmF3bnRsbXNzcF9hdXRoZW50aWNhdGUoc3RydWN0IHNlc3NfZGF0YSAqc2Vzc19k
YXRhKQogCQkvKiBubyBzdHJpbmcgYXJlYSB0byBkZWNvZGUsIGRvIG5vdGhpbmcgKi8KIAl9IGVs
c2UgaWYgKHNtYl9idWYtPkZsYWdzMiAmIFNNQkZMRzJfVU5JQ09ERSkgewogCQkvKiB1bmljb2Rl
IHN0cmluZyBhcmVhIG11c3QgYmUgd29yZC1hbGlnbmVkICovCi0JCWlmICgoKHVuc2lnbmVkIGxv
bmcpIGJjY19wdHIgLSAodW5zaWduZWQgbG9uZykgc21iX2J1ZikgJSAyKSB7CisJCWlmICghSVNf
QUxJR05FRCgodW5zaWduZWQgbG9uZyliY2NfcHRyIC0gKHVuc2lnbmVkIGxvbmcpc21iX2J1Ziwg
MikpIHsKIAkJCSsrYmNjX3B0cjsKIAkJCS0tYnl0ZXNfcmVtYWluaW5nOwogCQl9CmRpZmYgLS1n
aXQgYS9mcy9jaWZzL3NtYjJtaXNjLmMgYi9mcy9jaWZzL3NtYjJtaXNjLmMKaW5kZXggN2RiNWMw
OWVjY2ViLi5hMzg3MjA0Nzc5NjYgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMm1pc2MuYworKysg
Yi9mcy9jaWZzL3NtYjJtaXNjLmMKQEAgLTI0OCw3ICsyNDgsNyBAQCBzbWIyX2NoZWNrX21lc3Nh
Z2UoY2hhciAqYnVmLCB1bnNpZ25lZCBpbnQgbGVuLCBzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpz
ZXJ2ZXIpCiAJCSAqIFNvbWUgd2luZG93cyBzZXJ2ZXJzICh3aW4yMDE2KSB3aWxsIHBhZCBhbHNv
IHRoZSBmaW5hbAogCQkgKiBQRFUgaW4gYSBjb21wb3VuZCB0byA4IGJ5dGVzLgogCQkgKi8KLQkJ
aWYgKCgoY2FsY19sZW4gKyA3KSAmIH43KSA9PSBsZW4pCisJCWlmIChBTElHTihjYWxjX2xlbiwg
OCkgPT0gbGVuKQogCQkJcmV0dXJuIDA7CiAKIAkJLyoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21i
MnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1LmMKaW5kZXggYTNiNzdkZjI4NDhjLi42ZmU1NGVkNzY5
NmMgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5jCisrKyBiL2ZzL2NpZnMvc21iMnBkdS5j
CkBAIC00NjYsMTUgKzQ2NiwxNCBAQCBidWlsZF9zaWduaW5nX2N0eHQoc3RydWN0IHNtYjJfc2ln
bmluZ19jYXBhYmlsaXRpZXMgKnBuZWdfY3R4dCkKIAkvKgogCSAqIENvbnRleHQgRGF0YSBsZW5n
dGggbXVzdCBiZSByb3VuZGVkIHRvIG11bHRpcGxlIG9mIDggZm9yIHNvbWUgc2VydmVycwogCSAq
LwotCXBuZWdfY3R4dC0+RGF0YUxlbmd0aCA9IGNwdV90b19sZTE2KERJVl9ST1VORF9VUCgKLQkJ
CQlzaXplb2Yoc3RydWN0IHNtYjJfc2lnbmluZ19jYXBhYmlsaXRpZXMpIC0KLQkJCQlzaXplb2Yo
c3RydWN0IHNtYjJfbmVnX2NvbnRleHQpICsKLQkJCQkobnVtX2FsZ3MgKiAyIC8qIHNpemVvZiB1
MTYgKi8pLCA4KSAqIDgpOworCXBuZWdfY3R4dC0+RGF0YUxlbmd0aCA9IGNwdV90b19sZTE2KEFM
SUdOKHNpemVvZihzdHJ1Y3Qgc21iMl9zaWduaW5nX2NhcGFiaWxpdGllcykgLQorCQkJCQkgICAg
c2l6ZW9mKHN0cnVjdCBzbWIyX25lZ19jb250ZXh0KSArCisJCQkJCSAgICAobnVtX2FsZ3MgKiBz
aXplb2YodTE2KSksIDgpKTsKIAlwbmVnX2N0eHQtPlNpZ25pbmdBbGdvcml0aG1Db3VudCA9IGNw
dV90b19sZTE2KG51bV9hbGdzKTsKIAlwbmVnX2N0eHQtPlNpZ25pbmdBbGdvcml0aG1zWzBdID0g
Y3B1X3RvX2xlMTYoU0lHTklOR19BTEdfQUVTX0NNQUMpOwogCi0JY3R4dF9sZW4gKz0gMiAvKiBz
aXplb2YgbGUxNiAqLyAqIG51bV9hbGdzOwotCWN0eHRfbGVuID0gRElWX1JPVU5EX1VQKGN0eHRf
bGVuLCA4KSAqIDg7CisJY3R4dF9sZW4gKz0gc2l6ZW9mKF9fbGUxNikgKiBudW1fYWxnczsKKwlj
dHh0X2xlbiA9IEFMSUdOKGN0eHRfbGVuLCA4KTsKIAlyZXR1cm4gY3R4dF9sZW47CiAJLyogVEJE
IGFkZCBTSUdOSU5HX0FMR19BRVNfR01BQyBhbmQvb3IgU0lHTklOR19BTEdfSE1BQ19TSEEyNTYg
Ki8KIH0KQEAgLTUxMSw4ICs1MTAsNyBAQCBidWlsZF9uZXRuYW1lX2N0eHQoc3RydWN0IHNtYjJf
bmV0bmFtZV9uZWdfY29udGV4dCAqcG5lZ19jdHh0LCBjaGFyICpob3N0bmFtZSkKIAkvKiBjb3B5
IHVwIHRvIG1heCBvZiBmaXJzdCAxMDAgYnl0ZXMgb2Ygc2VydmVyIG5hbWUgdG8gTmV0TmFtZSBm
aWVsZCAqLwogCXBuZWdfY3R4dC0+RGF0YUxlbmd0aCA9IGNwdV90b19sZTE2KDIgKiBjaWZzX3N0
cnRvVVRGMTYocG5lZ19jdHh0LT5OZXROYW1lLCBob3N0bmFtZSwgMTAwLCBjcCkpOwogCS8qIGNv
bnRleHQgc2l6ZSBpcyBEYXRhTGVuZ3RoICsgbWluaW1hbCBzbWIyX25lZ19jb250ZXh0ICovCi0J
cmV0dXJuIERJVl9ST1VORF9VUChsZTE2X3RvX2NwdShwbmVnX2N0eHQtPkRhdGFMZW5ndGgpICsK
LQkJCXNpemVvZihzdHJ1Y3Qgc21iMl9uZWdfY29udGV4dCksIDgpICogODsKKwlyZXR1cm4gQUxJ
R04obGUxNl90b19jcHUocG5lZ19jdHh0LT5EYXRhTGVuZ3RoKSArIHNpemVvZihzdHJ1Y3Qgc21i
Ml9uZWdfY29udGV4dCksIDgpOwogfQogCiBzdGF0aWMgdm9pZApAQCAtNTU3LDE4ICs1NTUsMTgg
QEAgYXNzZW1ibGVfbmVnX2NvbnRleHRzKHN0cnVjdCBzbWIyX25lZ290aWF0ZV9yZXEgKnJlcSwK
IAkgKiByb3VuZCB1cCB0b3RhbF9sZW4gb2YgZml4ZWQgcGFydCBvZiBTTUIzIG5lZ290aWF0ZSBy
ZXF1ZXN0IHRvIDgKIAkgKiBieXRlIGJvdW5kYXJ5IGJlZm9yZSBhZGRpbmcgbmVnb3RpYXRlIGNv
bnRleHRzCiAJICovCi0JKnRvdGFsX2xlbiA9IHJvdW5kdXAoKnRvdGFsX2xlbiwgOCk7CisJKnRv
dGFsX2xlbiA9IEFMSUdOKCp0b3RhbF9sZW4sIDgpOwogCiAJcG5lZ19jdHh0ID0gKCp0b3RhbF9s
ZW4pICsgKGNoYXIgKilyZXE7CiAJcmVxLT5OZWdvdGlhdGVDb250ZXh0T2Zmc2V0ID0gY3B1X3Rv
X2xlMzIoKnRvdGFsX2xlbik7CiAKIAlidWlsZF9wcmVhdXRoX2N0eHQoKHN0cnVjdCBzbWIyX3By
ZWF1dGhfbmVnX2NvbnRleHQgKilwbmVnX2N0eHQpOwotCWN0eHRfbGVuID0gRElWX1JPVU5EX1VQ
KHNpemVvZihzdHJ1Y3Qgc21iMl9wcmVhdXRoX25lZ19jb250ZXh0KSwgOCkgKiA4OworCWN0eHRf
bGVuID0gQUxJR04oc2l6ZW9mKHN0cnVjdCBzbWIyX3ByZWF1dGhfbmVnX2NvbnRleHQpLCA4KTsK
IAkqdG90YWxfbGVuICs9IGN0eHRfbGVuOwogCXBuZWdfY3R4dCArPSBjdHh0X2xlbjsKIAogCWJ1
aWxkX2VuY3J5cHRfY3R4dCgoc3RydWN0IHNtYjJfZW5jcnlwdGlvbl9uZWdfY29udGV4dCAqKXBu
ZWdfY3R4dCk7Ci0JY3R4dF9sZW4gPSBESVZfUk9VTkRfVVAoc2l6ZW9mKHN0cnVjdCBzbWIyX2Vu
Y3J5cHRpb25fbmVnX2NvbnRleHQpLCA4KSAqIDg7CisJY3R4dF9sZW4gPSBBTElHTihzaXplb2Yo
c3RydWN0IHNtYjJfZW5jcnlwdGlvbl9uZWdfY29udGV4dCksIDgpOwogCSp0b3RhbF9sZW4gKz0g
Y3R4dF9sZW47CiAJcG5lZ19jdHh0ICs9IGN0eHRfbGVuOwogCkBAIC01OTUsOSArNTkzLDcgQEAg
YXNzZW1ibGVfbmVnX2NvbnRleHRzKHN0cnVjdCBzbWIyX25lZ290aWF0ZV9yZXEgKnJlcSwKIAlp
ZiAoc2VydmVyLT5jb21wcmVzc19hbGdvcml0aG0pIHsKIAkJYnVpbGRfY29tcHJlc3Npb25fY3R4
dCgoc3RydWN0IHNtYjJfY29tcHJlc3Npb25fY2FwYWJpbGl0aWVzX2NvbnRleHQgKikKIAkJCQlw
bmVnX2N0eHQpOwotCQljdHh0X2xlbiA9IERJVl9ST1VORF9VUCgKLQkJCXNpemVvZihzdHJ1Y3Qg
c21iMl9jb21wcmVzc2lvbl9jYXBhYmlsaXRpZXNfY29udGV4dCksCi0JCQkJOCkgKiA4OworCQlj
dHh0X2xlbiA9IEFMSUdOKHNpemVvZihzdHJ1Y3Qgc21iMl9jb21wcmVzc2lvbl9jYXBhYmlsaXRp
ZXNfY29udGV4dCksIDgpOwogCQkqdG90YWxfbGVuICs9IGN0eHRfbGVuOwogCQlwbmVnX2N0eHQg
Kz0gY3R4dF9sZW47CiAJCW5lZ19jb250ZXh0X2NvdW50Kys7CkBAIC03ODAsNyArNzc2LDcgQEAg
c3RhdGljIGludCBzbWIzMTFfZGVjb2RlX25lZ19jb250ZXh0KHN0cnVjdCBzbWIyX25lZ290aWF0
ZV9yc3AgKnJzcCwKIAkJaWYgKHJjKQogCQkJYnJlYWs7CiAJCS8qIG9mZnNldHMgbXVzdCBiZSA4
IGJ5dGUgYWxpZ25lZCAqLwotCQljbGVuID0gKGNsZW4gKyA3KSAmIH4weDc7CisJCWNsZW4gPSBB
TElHTihjbGVuLCA4KTsKIAkJb2Zmc2V0ICs9IGNsZW4gKyBzaXplb2Yoc3RydWN0IHNtYjJfbmVn
X2NvbnRleHQpOwogCQlsZW5fb2ZfY3R4dHMgLT0gY2xlbjsKIAl9CkBAIC0yNDI2LDcgKzI0MjIs
NyBAQCBjcmVhdGVfc2RfYnVmKHVtb2RlX3QgbW9kZSwgYm9vbCBzZXRfb3duZXIsIHVuc2lnbmVk
IGludCAqbGVuKQogCXVuc2lnbmVkIGludCBncm91cF9vZmZzZXQgPSAwOwogCXN0cnVjdCBzbWIz
X2FjbCBhY2w7CiAKLQkqbGVuID0gcm91bmR1cChzaXplb2Yoc3RydWN0IGNydF9zZF9jdHh0KSAr
IChzaXplb2Yoc3RydWN0IGNpZnNfYWNlKSAqIDQpLCA4KTsKKwkqbGVuID0gcm91bmRfdXAoc2l6
ZW9mKHN0cnVjdCBjcnRfc2RfY3R4dCkgKyAoc2l6ZW9mKHN0cnVjdCBjaWZzX2FjZSkgKiA0KSwg
OCk7CiAKIAlpZiAoc2V0X293bmVyKSB7CiAJCS8qIHNpemVvZihzdHJ1Y3Qgb3duZXJfZ3JvdXBf
c2lkcykgaXMgYWxyZWFkeSBtdWx0aXBsZSBvZiA4IHNvIG5vIG5lZWQgdG8gcm91bmQgKi8KQEAg
LTI1MDAsNyArMjQ5Niw3IEBAIGNyZWF0ZV9zZF9idWYodW1vZGVfdCBtb2RlLCBib29sIHNldF9v
d25lciwgdW5zaWduZWQgaW50ICpsZW4pCiAJbWVtY3B5KGFjbHB0ciwgJmFjbCwgc2l6ZW9mKHN0
cnVjdCBzbWIzX2FjbCkpOwogCiAJYnVmLT5jY29udGV4dC5EYXRhTGVuZ3RoID0gY3B1X3RvX2xl
MzIocHRyIC0gKF9fdTggKikmYnVmLT5zZCk7Ci0JKmxlbiA9IHJvdW5kdXAocHRyIC0gKF9fdTgg
KilidWYsIDgpOworCSpsZW4gPSByb3VuZF91cCgodW5zaWduZWQgaW50KShwdHIgLSAoX191OCAq
KWJ1ZiksIDgpOwogCiAJcmV0dXJuIGJ1ZjsKIH0KQEAgLTI1OTQsNyArMjU5MCw3IEBAIGFsbG9j
X3BhdGhfd2l0aF90cmVlX3ByZWZpeChfX2xlMTYgKipvdXRfcGF0aCwgaW50ICpvdXRfc2l6ZSwg
aW50ICpvdXRfbGVuLAogCSAqIGZpbmFsIHBhdGggbmVlZHMgdG8gYmUgOC1ieXRlIGFsaWduZWQg
YXMgc3BlY2lmaWVkIGluCiAJICogTVMtU01CMiAyLjIuMTMgU01CMiBDUkVBVEUgUmVxdWVzdC4K
IAkgKi8KLQkqb3V0X3NpemUgPSByb3VuZHVwKCpvdXRfbGVuICogc2l6ZW9mKF9fbGUxNiksIDgp
OworCSpvdXRfc2l6ZSA9IHJvdW5kX3VwKCpvdXRfbGVuICogc2l6ZW9mKF9fbGUxNiksIDgpOwog
CSpvdXRfcGF0aCA9IGt6YWxsb2MoKm91dF9zaXplICsgc2l6ZW9mKF9fbGUxNikgLyogbnVsbCAq
LywgR0ZQX0tFUk5FTCk7CiAJaWYgKCEqb3V0X3BhdGgpCiAJCXJldHVybiAtRU5PTUVNOwpAQCAt
MjcwMCwyMCArMjY5NiwxNyBAQCBpbnQgc21iMzExX3Bvc2l4X21rZGlyKGNvbnN0IHVuc2lnbmVk
IGludCB4aWQsIHN0cnVjdCBpbm9kZSAqaW5vZGUsCiAJCXVuaV9wYXRoX2xlbiA9ICgyICogVW5p
U3Rybmxlbigod2NoYXJfdCAqKXV0ZjE2X3BhdGgsIFBBVEhfTUFYKSkgKyAyOwogCQkvKiBNVVNU
IHNldCBwYXRoIGxlbiAoTmFtZUxlbmd0aCkgdG8gMCBvcGVuaW5nIHJvb3Qgb2Ygc2hhcmUgKi8K
IAkJcmVxLT5OYW1lTGVuZ3RoID0gY3B1X3RvX2xlMTYodW5pX3BhdGhfbGVuIC0gMik7Ci0JCWlm
ICh1bmlfcGF0aF9sZW4gJSA4ICE9IDApIHsKLQkJCWNvcHlfc2l6ZSA9IHJvdW5kdXAodW5pX3Bh
dGhfbGVuLCA4KTsKLQkJCWNvcHlfcGF0aCA9IGt6YWxsb2MoY29weV9zaXplLCBHRlBfS0VSTkVM
KTsKLQkJCWlmICghY29weV9wYXRoKSB7Ci0JCQkJcmMgPSAtRU5PTUVNOwotCQkJCWdvdG8gZXJy
X2ZyZWVfcmVxOwotCQkJfQotCQkJbWVtY3B5KChjaGFyICopY29weV9wYXRoLCAoY29uc3QgY2hh
ciAqKXV0ZjE2X3BhdGgsCi0JCQkgICAgICAgdW5pX3BhdGhfbGVuKTsKLQkJCXVuaV9wYXRoX2xl
biA9IGNvcHlfc2l6ZTsKLQkJCS8qIGZyZWUgYmVmb3JlIG92ZXJ3cml0aW5nIHJlc291cmNlICov
Ci0JCQlrZnJlZSh1dGYxNl9wYXRoKTsKLQkJCXV0ZjE2X3BhdGggPSBjb3B5X3BhdGg7CisJCWNv
cHlfc2l6ZSA9IHJvdW5kX3VwKHVuaV9wYXRoX2xlbiwgOCk7CisJCWNvcHlfcGF0aCA9IGt6YWxs
b2MoY29weV9zaXplLCBHRlBfS0VSTkVMKTsKKwkJaWYgKCFjb3B5X3BhdGgpIHsKKwkJCXJjID0g
LUVOT01FTTsKKwkJCWdvdG8gZXJyX2ZyZWVfcmVxOwogCQl9CisJCW1lbWNweSgoY2hhciAqKWNv
cHlfcGF0aCwgKGNvbnN0IGNoYXIgKil1dGYxNl9wYXRoLCB1bmlfcGF0aF9sZW4pOworCQl1bmlf
cGF0aF9sZW4gPSBjb3B5X3NpemU7CisJCS8qIGZyZWUgYmVmb3JlIG92ZXJ3cml0aW5nIHJlc291
cmNlICovCisJCWtmcmVlKHV0ZjE2X3BhdGgpOworCQl1dGYxNl9wYXRoID0gY29weV9wYXRoOwog
CX0KIAogCWlvdlsxXS5pb3ZfbGVuID0gdW5pX3BhdGhfbGVuOwpAQCAtMjgzOSw5ICsyODMyLDcg
QEAgU01CMl9vcGVuX2luaXQoc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwgc3RydWN0IFRDUF9TZXJ2
ZXJfSW5mbyAqc2VydmVyLAogCQl1bmlfcGF0aF9sZW4gPSAoMiAqIFVuaVN0cm5sZW4oKHdjaGFy
X3QgKilwYXRoLCBQQVRIX01BWCkpICsgMjsKIAkJLyogTVVTVCBzZXQgcGF0aCBsZW4gKE5hbWVM
ZW5ndGgpIHRvIDAgb3BlbmluZyByb290IG9mIHNoYXJlICovCiAJCXJlcS0+TmFtZUxlbmd0aCA9
IGNwdV90b19sZTE2KHVuaV9wYXRoX2xlbiAtIDIpOwotCQljb3B5X3NpemUgPSB1bmlfcGF0aF9s
ZW47Ci0JCWlmIChjb3B5X3NpemUgJSA4ICE9IDApCi0JCQljb3B5X3NpemUgPSByb3VuZHVwKGNv
cHlfc2l6ZSwgOCk7CisJCWNvcHlfc2l6ZSA9IHJvdW5kX3VwKHVuaV9wYXRoX2xlbiwgOCk7CiAJ
CWNvcHlfcGF0aCA9IGt6YWxsb2MoY29weV9zaXplLCBHRlBfS0VSTkVMKTsKIAkJaWYgKCFjb3B5
X3BhdGgpCiAJCQlyZXR1cm4gLUVOT01FTTsKQEAgLTQxMDMsNyArNDA5NCw3IEBAIHNtYjJfbmV3
X3JlYWRfcmVxKHZvaWQgKipidWYsIHVuc2lnbmVkIGludCAqdG90YWxfbGVuLAogCWlmIChyZXF1
ZXN0X3R5cGUgJiBDSEFJTkVEX1JFUVVFU1QpIHsKIAkJaWYgKCEocmVxdWVzdF90eXBlICYgRU5E
X09GX0NIQUlOKSkgewogCQkJLyogbmV4dCA4LWJ5dGUgYWxpZ25lZCByZXF1ZXN0ICovCi0JCQkq
dG90YWxfbGVuID0gRElWX1JPVU5EX1VQKCp0b3RhbF9sZW4sIDgpICogODsKKwkJCSp0b3RhbF9s
ZW4gPSBBTElHTigqdG90YWxfbGVuLCA4KTsKIAkJCXNoZHItPk5leHRDb21tYW5kID0gY3B1X3Rv
X2xlMzIoKnRvdGFsX2xlbik7CiAJCX0gZWxzZSAvKiBFTkRfT0ZfQ0hBSU4gKi8KIAkJCXNoZHIt
Pk5leHRDb21tYW5kID0gMDsKLS0gCjIuMzQuMQoK
--000000000000f6395a05eae3378e--
