Return-Path: <SRS0=mIXx=TJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C19E6C04AAF
	for <linux-cifs@archiver.kernel.org>; Thu,  9 May 2019 05:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E7D6216C4
	for <linux-cifs@archiver.kernel.org>; Thu,  9 May 2019 05:13:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hrp1Pmba"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfEIFNf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 May 2019 01:13:35 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35282 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726742AbfEIFNe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 May 2019 01:13:34 -0400
Received: by mail-pl1-f194.google.com with SMTP id g5so530373plt.2;
        Wed, 08 May 2019 22:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yuCGWaZawC6e5tOYZFofXl3aeHSrghEpAOU1s/BFsdc=;
        b=Hrp1PmbaLPtS9fbE0/CGeKTZI/EIn4EA5m+XJRYvsgf5dHQ7R8ivIDnhI6aGMz0gxL
         gF7edDzyboOA60wUo6BI4C4vKeJCI8OcYICAVer0m6uH0cERN151bvFA+yBQxNK7Jyqg
         482j4S5kMIzA/mQT20miMRrsqLhoXDuN3I2M1vuEXk6sIawkQdadqGu4xOtqREi0XmH3
         m+uQK+kuKnpBxUNYP8LHx5lKIdGH6D9A9eY1lkqoTnFm3pirvCC7bGnck3f5RObNMb8l
         S+Ia1UWNVysJykVW7csVEe5hpVuV6jQRMM6wXAPJbZI/LCTAcDVIaL3/xAS3wz1qMyPf
         nqhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yuCGWaZawC6e5tOYZFofXl3aeHSrghEpAOU1s/BFsdc=;
        b=nZUS1AEc1FEIrgEuAd27Fknv+DRstgDvBGix9d4VQx35P2WBobV2BmGmiMFZw2m92o
         LhX1RCE+Tcoj1gY/3dY6yVqUdiOOaINRdn4ossdEBliVUQNynbydVVdmg+AUF0VNK9KH
         IMwbzG7/UcVYwtcspQFTw1yorKDdgv6L3CpyFoZIqGQPx02EyWMKduqYgTo35UL8E2Ww
         L3UGV4MJ4QaIViFDuBylHBeJlOKnHZWktH0u2SmiqbJfUOpD4JUbIr7cefOWYKtJBitD
         apfqlguIt25XgskjZob//yUJX1ZiuK+qSOcIyWbWf1oSvvb8OnEmpH7h6J8ZODQjICtN
         4zEA==
X-Gm-Message-State: APjAAAXuXlPdixbxK+MUk6uUdirGP1BqoMgt1OLxVfskpver0DSlowOZ
        +V14DNz+V5UGNatG9k9Xro1dBrXZID/7M4CtPsDTVg==
X-Google-Smtp-Source: APXvYqyD2aJHd1cJJ6r72Epxqy9ujLUygKV41XtfCKxsd+qHs7MgnAgcjeZgL9msBHdr6RMhxlY6grub4FsN/mMFgnI=
X-Received: by 2002:a17:902:8609:: with SMTP id f9mr2507252plo.32.1557378813282;
 Wed, 08 May 2019 22:13:33 -0700 (PDT)
MIME-Version: 1.0
References: <1557344185-18457-1-git-send-email-kernel@probst.it>
In-Reply-To: <1557344185-18457-1-git-send-email-kernel@probst.it>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 9 May 2019 00:13:21 -0500
Message-ID: <CAH2r5muXo6WcBg70KcnNPZtjgqy4njqRMgKY-z4yfmGG-4yRrQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix checkpatch warnings and normalize strings
To:     Christoph Probst <kernel@probst.it>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000f33b0105886d82fe"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000f33b0105886d82fe
Content-Type: text/plain; charset="UTF-8"

Merged into cifs-2.6.git for-next with minor cleanup.  I also
(ironically) had to change the patch title since
checkpatch complained about mentioning "checkpatch" in the patch name.

Also FYI - since it didn't merge cleanly, I had to add one of the
changes manually as a distinct patch. See attached.


On Wed, May 8, 2019 at 2:37 PM Christoph Probst via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> Fix checkpatch warnings/errors in smb2ops.c except "LONG_LINE". Add missing
> linebreaks, indentings, __func__. Remove void-returns, unneeded braces.
>
> Add SPDX License Header.
>
> Add missing "\n" and capitalize first letter in some cifs_dbg() strings.
>
> Signed-off-by: Christoph Probst <kernel@probst.it>
> ---
>  fs/cifs/smb2ops.c | 46 +++++++++++++++++++++++-----------------------
>  1 file changed, 23 insertions(+), 23 deletions(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index c36ff0d..9bda7e5 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   *  SMB2 version specific operations
>   *
> @@ -282,7 +283,7 @@ smb2_find_mid(struct TCP_Server_Info *server, char *buf)
>         __u64 wire_mid = le64_to_cpu(shdr->MessageId);
>
>         if (shdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM) {
> -               cifs_dbg(VFS, "encrypted frame parsing not supported yet");
> +               cifs_dbg(VFS, "Encrypted frame parsing not supported yet\n");
>                 return NULL;
>         }
>
> @@ -324,6 +325,7 @@ static int
>  smb2_negotiate(const unsigned int xid, struct cifs_ses *ses)
>  {
>         int rc;
> +
>         ses->server->CurrentMid = 0;
>         rc = SMB2_negotiate(xid, ses);
>         /* BB we probably don't need to retry with modern servers */
> @@ -789,8 +791,6 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon)
>                 SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
>         else
>                 close_shroot(&tcon->crfid);
> -
> -       return;
>  }
>
>  static void
> @@ -818,7 +818,6 @@ smb2_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon)
>         SMB2_QFS_attr(xid, tcon, fid.persistent_fid, fid.volatile_fid,
>                         FS_DEVICE_INFORMATION);
>         SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
> -       return;
>  }
>
>  static int
> @@ -906,9 +905,8 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
>                 value = &src->ea_data[src->ea_name_length + 1];
>                 value_len = (size_t)le16_to_cpu(src->ea_value_length);
>
> -               if (name_len == 0) {
> +               if (name_len == 0)
>                         break;
> -               }
>
>                 if (src_size < 8 + name_len + 1 + value_len) {
>                         cifs_dbg(FYI, "EA entry goes beyond length of list\n");
> @@ -1161,6 +1159,7 @@ static void
>  smb2_clear_stats(struct cifs_tcon *tcon)
>  {
>         int i;
> +
>         for (i = 0; i < NUMBER_OF_SMB2_COMMANDS; i++) {
>                 atomic_set(&tcon->stats.smb2_stats.smb2_com_sent[i], 0);
>                 atomic_set(&tcon->stats.smb2_stats.smb2_com_failed[i], 0);
> @@ -1501,7 +1500,7 @@ smb2_copychunk_range(const unsigned int xid,
>         if (pcchunk == NULL)
>                 return -ENOMEM;
>
> -       cifs_dbg(FYI, "in smb2_copychunk_range - about to call request res key\n");
> +       cifs_dbg(FYI, "%s: about to call request res key\n", __func__);
>         /* Request a key from the server to identify the source of the copy */
>         rc = SMB2_request_res_key(xid, tlink_tcon(srcfile->tlink),
>                                 srcfile->fid.persistent_fid,
> @@ -1621,6 +1620,7 @@ static unsigned int
>  smb2_read_data_offset(char *buf)
>  {
>         struct smb2_read_rsp *rsp = (struct smb2_read_rsp *)buf;
> +
>         return rsp->DataOffset;
>  }
>
> @@ -1749,7 +1749,7 @@ smb2_duplicate_extents(const unsigned int xid,
>         dup_ext_buf.SourceFileOffset = cpu_to_le64(src_off);
>         dup_ext_buf.TargetFileOffset = cpu_to_le64(dest_off);
>         dup_ext_buf.ByteCount = cpu_to_le64(len);
> -       cifs_dbg(FYI, "duplicate extents: src off %lld dst off %lld len %lld",
> +       cifs_dbg(FYI, "Duplicate extents: src off %lld dst off %lld len %lld\n",
>                 src_off, dest_off, len);
>
>         rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
> @@ -1766,7 +1766,7 @@ smb2_duplicate_extents(const unsigned int xid,
>                         &ret_data_len);
>
>         if (ret_data_len > 0)
> -               cifs_dbg(FYI, "non-zero response length in duplicate extents");
> +               cifs_dbg(FYI, "Non-zero response length in duplicate extents\n");
>
>  duplicate_extents_out:
>         return rc;
> @@ -1947,9 +1947,9 @@ smb2_close_dir(const unsigned int xid, struct cifs_tcon *tcon,
>  }
>
>  /*
> -* If we negotiate SMB2 protocol and get STATUS_PENDING - update
> -* the number of credits and return true. Otherwise - return false.
> -*/
> + * If we negotiate SMB2 protocol and get STATUS_PENDING - update
> + * the number of credits and return true. Otherwise - return false.
> + */
>  static bool
>  smb2_is_status_pending(char *buf, struct TCP_Server_Info *server)
>  {
> @@ -2270,7 +2270,7 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
>         struct get_dfs_referral_rsp *dfs_rsp = NULL;
>         u32 dfs_req_size = 0, dfs_rsp_size = 0;
>
> -       cifs_dbg(FYI, "smb2_get_dfs_refer path <%s>\n", search_name);
> +       cifs_dbg(FYI, "%s: path: %s\n", __func__, search_name);
>
>         /*
>          * Try to use the IPC tcon, otherwise just use any
> @@ -2324,7 +2324,7 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
>
>         if (rc) {
>                 if ((rc != -ENOENT) && (rc != -EOPNOTSUPP))
> -                       cifs_dbg(VFS, "ioctl error in smb2_get_dfs_refer rc=%d\n", rc);
> +                       cifs_dbg(VFS, "ioctl error in %s rc=%d\n", __func__, rc);
>                 goto out;
>         }
>
> @@ -2333,7 +2333,7 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
>                                  nls_codepage, remap, search_name,
>                                  true /* is_unicode */);
>         if (rc) {
> -               cifs_dbg(VFS, "parse error in smb2_get_dfs_refer rc=%d\n", rc);
> +               cifs_dbg(VFS, "parse error in %s rc=%d\n", __func__, rc);
>                 goto out;
>         }
>
> @@ -2629,7 +2629,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
>         inode = d_inode(cfile->dentry);
>         cifsi = CIFS_I(inode);
>
> -        trace_smb3_zero_enter(xid, cfile->fid.persistent_fid, tcon->tid,
> +       trace_smb3_zero_enter(xid, cfile->fid.persistent_fid, tcon->tid,
>                               ses->Suid, offset, len);
>
>
> @@ -2655,7 +2655,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
>                 return rc;
>         }
>
> -       cifs_dbg(FYI, "offset %lld len %lld", offset, len);
> +       cifs_dbg(FYI, "Offset %lld len %lld\n", offset, len);
>
>         fsctl_buf.FileOffset = cpu_to_le64(offset);
>         fsctl_buf.BeyondFinalZero = cpu_to_le64(offset + len);
> @@ -2744,7 +2744,7 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
>                 return rc;
>         }
>
> -       cifs_dbg(FYI, "offset %lld len %lld", offset, len);
> +       cifs_dbg(FYI, "Offset %lld len %lld\n", offset, len);
>
>         fsctl_buf.FileOffset = cpu_to_le64(offset);
>         fsctl_buf.BeyondFinalZero = cpu_to_le64(offset + len);
> @@ -3237,7 +3237,7 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
>
>         req = aead_request_alloc(tfm, GFP_KERNEL);
>         if (!req) {
> -               cifs_dbg(VFS, "%s: Failed to alloc aead request", __func__);
> +               cifs_dbg(VFS, "%s: Failed to alloc aead request\n", __func__);
>                 return -ENOMEM;
>         }
>
> @@ -3248,7 +3248,7 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
>
>         sg = init_sg(num_rqst, rqst, sign);
>         if (!sg) {
> -               cifs_dbg(VFS, "%s: Failed to init sg", __func__);
> +               cifs_dbg(VFS, "%s: Failed to init sg\n", __func__);
>                 rc = -ENOMEM;
>                 goto free_req;
>         }
> @@ -3256,7 +3256,7 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
>         iv_len = crypto_aead_ivsize(tfm);
>         iv = kzalloc(iv_len, GFP_KERNEL);
>         if (!iv) {
> -               cifs_dbg(VFS, "%s: Failed to alloc IV", __func__);
> +               cifs_dbg(VFS, "%s: Failed to alloc IV\n", __func__);
>                 rc = -ENOMEM;
>                 goto free_sg;
>         }
> @@ -3364,7 +3364,7 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, int num_rqst,
>         fill_transform_hdr(tr_hdr, orig_len, old_rq);
>
>         rc = crypt_message(server, num_rqst, new_rq, 1);
> -       cifs_dbg(FYI, "encrypt message returned %d", rc);
> +       cifs_dbg(FYI, "Encrypt message returned %d\n", rc);
>         if (rc)
>                 goto err_free;
>
> @@ -3405,7 +3405,7 @@ decrypt_raw_data(struct TCP_Server_Info *server, char *buf,
>         rqst.rq_tailsz = (page_data_size % PAGE_SIZE) ? : PAGE_SIZE;
>
>         rc = crypt_message(server, 1, &rqst, 0);
> -       cifs_dbg(FYI, "decrypt message returned %d\n", rc);
> +       cifs_dbg(FYI, "Decrypt message returned %d\n", rc);
>
>         if (rc)
>                 return rc;
> --
> 2.1.4
>
>


-- 
Thanks,

Steve

--000000000000f33b0105886d82fe
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-trivial-cleanup-to-smb2ops.c.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-trivial-cleanup-to-smb2ops.c.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jvg731n40>
X-Attachment-Id: f_jvg731n40

RnJvbSBmYjdjMzcxOTdlMzE3N2FmYzk5MmNjNDZhZDRhNDU3MGZlMjk3OTAxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgOSBNYXkgMjAxOSAwMDowOTozNyAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IHRyaXZpYWwgY2xlYW51cCB0byBzbWIyb3BzLmMKCk1pbm9yIGNsZWFudXAgLSBlLmcuIG1p
c3NpbmcgXG4gYXQgZW5kIG9mIGRlYnVnIHN0YXRlbWVudC4KClJlcG9ydGVkLWJ5OiBDaHJpc3Rv
cGggUHJvYnN0IDxrZXJuZWxAcHJvYnN0Lml0PgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2gg
PHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIyb3BzLmMgfCAyICstCiAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQg
YS9mcy9jaWZzL3NtYjJvcHMuYyBiL2ZzL2NpZnMvc21iMm9wcy5jCmluZGV4IDQ2NjU1NGNkZmY0
Yi4uNTQyYjUwYzBiMjkyIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJvcHMuYworKysgYi9mcy9j
aWZzL3NtYjJvcHMuYwpAQCAtMjc1OSw3ICsyNzU5LDcgQEAgc3RhdGljIGxvbmcgc21iM196ZXJv
X3JhbmdlKHN0cnVjdCBmaWxlICpmaWxlLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkJcmV0
dXJuIHJjOwogCQl9CiAKLQljaWZzX2RiZyhGWUksICJvZmZzZXQgJWxsZCBsZW4gJWxsZCIsIG9m
ZnNldCwgbGVuKTsKKwljaWZzX2RiZyhGWUksICJPZmZzZXQgJWxsZCBsZW4gJWxsZFxuIiwgb2Zm
c2V0LCBsZW4pOwogCiAJZnNjdGxfYnVmLkZpbGVPZmZzZXQgPSBjcHVfdG9fbGU2NChvZmZzZXQp
OwogCWZzY3RsX2J1Zi5CZXlvbmRGaW5hbFplcm8gPSBjcHVfdG9fbGU2NChvZmZzZXQgKyBsZW4p
OwotLSAKMi4yMC4xCgo=
--000000000000f33b0105886d82fe--
