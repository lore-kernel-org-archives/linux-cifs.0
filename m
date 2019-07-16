Return-Path: <SRS0=queM=VN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41DAC76188
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Jul 2019 05:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B3302145D
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Jul 2019 05:35:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gOa+ZIeD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfGPFf7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Jul 2019 01:35:59 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45663 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbfGPFf6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 Jul 2019 01:35:58 -0400
Received: by mail-pf1-f194.google.com with SMTP id r1so8505242pfq.12
        for <linux-cifs@vger.kernel.org>; Mon, 15 Jul 2019 22:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a9v6/mXlovRfwGYytZrfYJ4/zsQ5RBJFzIGj/RXrMkU=;
        b=gOa+ZIeDd3CiQiuN4i/79OYXADNYjPyTfvxiv1dCsoGKcV5xyCjb/EINvns9WunQna
         e4+YkJej1fkQctfX1FifXooIbDP7VO+hutw3/L5jwmNpPc6CXCweCpl1w6rfVZIsMKM+
         o9IKTe/hES4EklbxgSXGVhF4jgnm6Dl7Cek1C3oiUtLNmuV0EdohNc+8/hRaqMSCAAw3
         CQR+Bas7RfnePSQhrHeYefyEaVU7+LdfTPcDJG7jZ5PsIoNJGR7+1bJtzAsICboP0wEP
         j2Pf27nAYh8rVn1x4K0wQXIxsWDuLgWPEAC7pSmeUU1SSbY6piGSH1VyOSgzMe6heMTS
         TGcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a9v6/mXlovRfwGYytZrfYJ4/zsQ5RBJFzIGj/RXrMkU=;
        b=SJ9Nn8pmW+7Jq67BtXpuaSrlX2iyO1i51WK6FhTAa14Zqos5i4aDpykq9MMI/nqzKA
         yQBySSvoXXGSzttZg78RzzUttbaJN0gPzWDmCB6qKOlT0mXm637Tcy+j97lN/l5VqDEN
         6HSeiNtBEmdFKkFb95/e3T5gUrHJ4KLSOnuNDnHb0X3BuBkCxaPNbl2sqkseeSbWB1oM
         dpkA0JZTvq62csAWutoPO4V+RdSKptXBQS16C82rsaJ6NHNskfOsVdXIqHs9Dc1CkCHI
         D0HzhuzKTSXYNOPocoECBjbO81oiq31+Bw00GOHh/U/q6S92KfiofUhnwTvb3n+npTBp
         EpsA==
X-Gm-Message-State: APjAAAXRGiD3UaW57hX8yZDK16416pzW+9yvLE6w+L2QBy9JWFR3IkES
        7ODvrbiS/w7Xkl0ghwdUtofftQEos32fJDvDMqI=
X-Google-Smtp-Source: APXvYqxXFMr/e2zIqdh8qVTo1FtqVYIHSBVjAwme5YmCz/ps1054fPvTkU1bR8oGnzR/AsPydbsd/YyU9mfX7tcCzBU=
X-Received: by 2002:a65:6454:: with SMTP id s20mr31314936pgv.15.1563255357027;
 Mon, 15 Jul 2019 22:35:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190621000252.22432-1-lsahlber@redhat.com>
In-Reply-To: <20190621000252.22432-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 16 Jul 2019 00:35:45 -0500
Message-ID: <CAH2r5mu-tSvW9e0fwnK5qxZ66xhAO6vsNS-K51w=c5iLgo0wmQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: add mount option to encode xattr names as hexadecimal
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000003fe081058dc5c0d7"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000003fe081058dc5c0d7
Content-Type: text/plain; charset="UTF-8"

Updated patch to fix minor compile warning and to rebase it on current for-next


On Thu, Jun 20, 2019 at 7:03 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> We store xattrs as Extended Attributes for SMB.
> Some servers treat the EA names as case-insensitive as well as converting them to all upper-case.
>
> This addresses that issue by adding a new mount option to convert all EA names to/from
> hexadecimal representation.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifs_fs_sb.h |  1 +
>  fs/cifs/cifsfs.c     |  3 +++
>  fs/cifs/cifsglob.h   |  3 ++-
>  fs/cifs/connect.c    |  7 +++++++
>  fs/cifs/smb2ops.c    | 58 ++++++++++++++++++++++++++++++++++++++++------------
>  5 files changed, 58 insertions(+), 14 deletions(-)
>
> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
> index ed49222abecb..11fb5f4d2b0e 100644
> --- a/fs/cifs/cifs_fs_sb.h
> +++ b/fs/cifs/cifs_fs_sb.h
> @@ -52,6 +52,7 @@
>  #define CIFS_MOUNT_UID_FROM_ACL 0x2000000 /* try to get UID via special SID */
>  #define CIFS_MOUNT_NO_HANDLE_CACHE 0x4000000 /* disable caching dir handles */
>  #define CIFS_MOUNT_NO_DFS 0x8000000 /* disable DFS resolving */
> +#define CIFS_MOUNT_ENCODED_XATTR  0x10000000 /* encode the xattr names */
>
>  struct cifs_sb_info {
>         struct rb_root tlink_tree;
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index d06edebf3a73..c3c837ee3c4e 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -471,6 +471,9 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
>         else
>                 seq_puts(s, ",noforcegid");
>
> +       if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_ENCODED_XATTR)
> +               seq_puts(s, ",endodedxattr");
> +
>         cifs_show_address(s, tcon->ses->server);
>
>         if (!tcon->unix_ext)
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 4777b3c4a92c..b479207f7f74 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -585,6 +585,7 @@ struct smb_vol {
>         bool resilient:1; /* noresilient not required since not fored for CA */
>         bool domainauto:1;
>         bool rdma:1;
> +       bool encoded_xattr:1;
>         unsigned int bsize;
>         unsigned int rsize;
>         unsigned int wsize;
> @@ -617,7 +618,7 @@ struct smb_vol {
>                          CIFS_MOUNT_FSCACHE | CIFS_MOUNT_MF_SYMLINKS | \
>                          CIFS_MOUNT_MULTIUSER | CIFS_MOUNT_STRICT_IO | \
>                          CIFS_MOUNT_CIFS_BACKUPUID | CIFS_MOUNT_CIFS_BACKUPGID | \
> -                        CIFS_MOUNT_NO_DFS)
> +                        CIFS_MOUNT_NO_DFS|CIFS_MOUNT_ENCODED_XATTR)
>
>  /**
>   * Generic VFS superblock mount flags (s_flags) to consider when
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 51f272377ae1..f955b28a9b38 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -97,6 +97,7 @@ enum {
>         Opt_persistent, Opt_nopersistent,
>         Opt_resilient, Opt_noresilient,
>         Opt_domainauto, Opt_rdma,
> +       Opt_encodedxattr,
>
>         /* Mount options which take numeric value */
>         Opt_backupuid, Opt_backupgid, Opt_uid,
> @@ -194,6 +195,7 @@ static const match_table_t cifs_mount_option_tokens = {
>         { Opt_noresilient, "noresilienthandles"},
>         { Opt_domainauto, "domainauto"},
>         { Opt_rdma, "rdma"},
> +       { Opt_encodedxattr, "encodedxattr" },
>
>         { Opt_backupuid, "backupuid=%s" },
>         { Opt_backupgid, "backupgid=%s" },
> @@ -1911,6 +1913,9 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>                 case Opt_rdma:
>                         vol->rdma = true;
>                         break;
> +               case Opt_encodedxattr:
> +                       vol->encoded_xattr = 1;
> +                       break;
>
>                 /* Numeric Values */
>                 case Opt_backupuid:
> @@ -3986,6 +3991,8 @@ int cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
>                 cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_OVERR_UID;
>         if (pvolume_info->override_gid)
>                 cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_OVERR_GID;
> +       if (pvolume_info->encoded_xattr)
> +               cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_ENCODED_XATTR;
>         if (pvolume_info->dynperm)
>                 cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DYNPERM;
>         if (pvolume_info->fsc)
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 376577cc4159..e2684a6627bb 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -891,7 +891,8 @@ smb2_query_file_info(const unsigned int xid, struct cifs_tcon *tcon,
>  static ssize_t
>  move_smb2_ea_to_cifs(char *dst, size_t dst_size,
>                      struct smb2_file_full_ea_info *src, size_t src_size,
> -                    const unsigned char *ea_name)
> +                    const unsigned char *ea_name,
> +                    struct cifs_sb_info *cifs_sb)
>  {
>         int rc = 0;
>         unsigned int ea_name_len = ea_name ? strlen(ea_name) : 0;
> @@ -905,6 +906,18 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
>                 value = &src->ea_data[src->ea_name_length + 1];
>                 value_len = (size_t)le16_to_cpu(src->ea_value_length);
>
> +               if (cifs_sb->mnt_cifs_flags | CIFS_MOUNT_ENCODED_XATTR) {
> +                       if (name_len & 0x01) {
> +                               rc = -EINVAL;
> +                               goto out;
> +                       }
> +                       name_len = name_len / 2;
> +                       if (hex2bin(name, name, name_len)) {
> +                               rc = -EINVAL;
> +                               goto out;
> +                       }
> +               }
> +
>                 if (name_len == 0)
>                         break;
>
> @@ -1018,7 +1031,8 @@ smb2_query_eas(const unsigned int xid, struct cifs_tcon *tcon,
>         info = (struct smb2_file_full_ea_info *)(
>                         le16_to_cpu(rsp->OutputBufferOffset) + (char *)rsp);
>         rc = move_smb2_ea_to_cifs(ea_data, buf_size, info,
> -                       le32_to_cpu(rsp->OutputBufferLength), ea_name);
> +                                 le32_to_cpu(rsp->OutputBufferLength),
> +                                 ea_name, cifs_sb);
>
>   qeas_exit:
>         kfree(utf16_path);
> @@ -1029,13 +1043,14 @@ smb2_query_eas(const unsigned int xid, struct cifs_tcon *tcon,
>
>  static int
>  smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
> -           const char *path, const char *ea_name, const void *ea_value,
> +           const char *path, const char *name, const void *ea_value,
>             const __u16 ea_value_len, const struct nls_table *nls_codepage,
>             struct cifs_sb_info *cifs_sb)
>  {
>         struct cifs_ses *ses = tcon->ses;
>         __le16 *utf16_path = NULL;
> -       int ea_name_len = strlen(ea_name);
> +       char *ea_name = (char *)name;
> +       int ea_name_len = strlen(name);
>         int flags = 0;
>         int len;
>         struct smb_rqst rqst[3];
> @@ -1050,21 +1065,36 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
>         void *data[1];
>         struct smb2_file_full_ea_info *ea = NULL;
>         struct kvec close_iov[1];
> -       int rc;
> +       int i, rc;
> +
> +       memset(rqst, 0, sizeof(rqst));
> +       resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
> +       memset(rsp_iov, 0, sizeof(rsp_iov));
>
>         if (smb3_encryption_required(tcon))
>                 flags |= CIFS_TRANSFORM_REQ;
>
> -       if (ea_name_len > 255)
> -               return -EINVAL;
> +       /* Do we need to encode the name in hex ? */
> +       if (cifs_sb->mnt_cifs_flags | CIFS_MOUNT_ENCODED_XATTR) {
> +               ea_name = kzalloc(ea_name_len * 2 + 1, GFP_KERNEL);
> +               if (ea_name == NULL) {
> +                       rc = -ENOMEM;
> +                       goto sea_exit;
> +               }
> +               bin2hex(ea_name, name, ea_name_len);
> +               ea_name_len = 2 * ea_name_len;
> +       }
>
> -       utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
> -       if (!utf16_path)
> -               return -ENOMEM;
> +       if (ea_name_len > 255) {
> +               rc = -EINVAL;
> +               goto sea_exit;
> +       }
>
> -       memset(rqst, 0, sizeof(rqst));
> -       resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
> -       memset(rsp_iov, 0, sizeof(rsp_iov));
> +       utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
> +       if (!utf16_path) {
> +               rc = -ENOMEM;
> +               goto sea_exit;
> +       }
>
>         if (ses->server->ops->query_all_EAs) {
>                 if (!ea_value) {
> @@ -1137,6 +1167,8 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
>                                 resp_buftype, rsp_iov);
>
>   sea_exit:
> +       if (cifs_sb->mnt_cifs_flags | CIFS_MOUNT_ENCODED_XATTR)
> +               kfree(ea_name);
>         kfree(ea);
>         kfree(utf16_path);
>         SMB2_open_free(&rqst[0]);
> --
> 2.13.6
>


-- 
Thanks,

Steve

--0000000000003fe081058dc5c0d7
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0005-smb3-add-mount-option-to-encode-xattr-names-as-hexad.patch"
Content-Disposition: attachment; 
	filename="0005-smb3-add-mount-option-to-encode-xattr-names-as-hexad.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jy5dv1ha0>
X-Attachment-Id: f_jy5dv1ha0

RnJvbSA4ZWU1MmE4YWQxZGFiYzNlNDgwMmNmYjA2NGEwMDI1YzJjZDBlZWM2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+
CkRhdGU6IFR1ZSwgMTYgSnVsIDIwMTkgMDA6MjU6MTYgLTA1MDAKU3ViamVjdDogW1BBVENIIDUv
NV0gc21iMzogYWRkIG1vdW50IG9wdGlvbiB0byBlbmNvZGUgeGF0dHIgbmFtZXMgYXMKIGhleGFk
ZWNpbWFsCgpXZSBzdG9yZSB4YXR0cnMgYXMgRXh0ZW5kZWQgQXR0cmlidXRlcyBmb3IgU01CLgpT
b21lIHNlcnZlcnMgdHJlYXQgdGhlIEVBIG5hbWVzIGFzIGNhc2UtaW5zZW5zaXRpdmUgYXMgd2Vs
bAphcyBjb252ZXJ0aW5nIHRoZW0gdG8gYWxsIHVwcGVyLWNhc2UuCgpUaGlzIGFkZHJlc3NlcyB0
aGF0IGlzc3VlIGJ5IGFkZGluZyBhIG5ldyBtb3VudCBvcHRpb24gdG8gY29udmVydAphbGwgRUEg
bmFtZXMgdG8vZnJvbSBoZXhhZGVjaW1hbCByZXByZXNlbnRhdGlvbi4KCkZpeGVzIHhmc3Rlc3Qg
Z2VuZXJpYy81MzMgdG8gV2luZG93cyBzZXJ2ZXJzCgpTaWduZWQtb2ZmLWJ5OiBSb25uaWUgU2Fo
bGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+Ci0tLQogZnMvY2lmcy9jaWZzX2ZzX3NiLmggfCAg
MSArCiBmcy9jaWZzL2NpZnNmcy5jICAgICB8ICAzICsrKwogZnMvY2lmcy9jaWZzZ2xvYi5oICAg
fCAgNCArKystCiBmcy9jaWZzL2Nvbm5lY3QuYyAgICB8ICA4ICsrKysrKy0KIGZzL2NpZnMvc21i
Mm9wcy5jICAgIHwgNTYgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0t
LS0KIDUgZmlsZXMgY2hhbmdlZCwgNTggaW5zZXJ0aW9ucygrKSwgMTQgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzX2ZzX3NiLmggYi9mcy9jaWZzL2NpZnNfZnNfc2IuaApp
bmRleCBiMzI2ZDJjYTM3NjUuLjkwZTIxOTJkYWVmZiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZz
X2ZzX3NiLmgKKysrIGIvZnMvY2lmcy9jaWZzX2ZzX3NiLmgKQEAgLTUzLDYgKzUzLDcgQEAKICNk
ZWZpbmUgQ0lGU19NT1VOVF9OT19IQU5ETEVfQ0FDSEUgMHg0MDAwMDAwIC8qIGRpc2FibGUgY2Fj
aGluZyBkaXIgaGFuZGxlcyAqLwogI2RlZmluZSBDSUZTX01PVU5UX05PX0RGUyAweDgwMDAwMDAg
LyogZGlzYWJsZSBERlMgcmVzb2x2aW5nICovCiAjZGVmaW5lIENJRlNfTU9VTlRfTU9ERV9GUk9N
X1NJRCAweDEwMDAwMDAwIC8qIHJldHJpZXZlIG1vZGUgZnJvbSBzcGVjaWFsIEFDRSAqLworI2Rl
ZmluZSBDSUZTX01PVU5UX0VOQ09ERURfWEFUVFIgMHgyMDAwMDAwMCAvKiBlbmNvZGUgdGhlIHhh
dHRyIG5hbWVzICovCiAKIHN0cnVjdCBjaWZzX3NiX2luZm8gewogCXN0cnVjdCByYl9yb290IHRs
aW5rX3RyZWU7CmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNmcy5jIGIvZnMvY2lmcy9jaWZzZnMu
YwppbmRleCAwZWU2M2FjNGVmNzIuLjMyMGM3YTZmZDMxOCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9j
aWZzZnMuYworKysgYi9mcy9jaWZzL2NpZnNmcy5jCkBAIC00NzEsNiArNDcxLDkgQEAgY2lmc19z
aG93X29wdGlvbnMoc3RydWN0IHNlcV9maWxlICpzLCBzdHJ1Y3QgZGVudHJ5ICpyb290KQogCWVs
c2UKIAkJc2VxX3B1dHMocywgIixub2ZvcmNlZ2lkIik7CiAKKwlpZiAoY2lmc19zYi0+bW50X2Np
ZnNfZmxhZ3MgJiBDSUZTX01PVU5UX0VOQ09ERURfWEFUVFIpCisJCXNlcV9wdXRzKHMsICIsZW5k
b2RlZHhhdHRyIik7CisKIAljaWZzX3Nob3dfYWRkcmVzcyhzLCB0Y29uLT5zZXMtPnNlcnZlcik7
CiAKIAlpZiAoIXRjb24tPnVuaXhfZXh0KQpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzZ2xvYi5o
IGIvZnMvY2lmcy9jaWZzZ2xvYi5oCmluZGV4IGZlNjEwZTdlMzY3MC4uOGM3ZWE3MzM5NDdiIDEw
MDY0NAotLS0gYS9mcy9jaWZzL2NpZnNnbG9iLmgKKysrIGIvZnMvY2lmcy9jaWZzZ2xvYi5oCkBA
IC01ODYsNiArNTg2LDcgQEAgc3RydWN0IHNtYl92b2wgewogCWJvb2wgcmVzaWxpZW50OjE7IC8q
IG5vcmVzaWxpZW50IG5vdCByZXF1aXJlZCBzaW5jZSBub3QgZm9yZWQgZm9yIENBICovCiAJYm9v
bCBkb21haW5hdXRvOjE7CiAJYm9vbCByZG1hOjE7CisJYm9vbCBlbmNvZGVkX3hhdHRyOjE7CiAJ
dW5zaWduZWQgaW50IGJzaXplOwogCXVuc2lnbmVkIGludCByc2l6ZTsKIAl1bnNpZ25lZCBpbnQg
d3NpemU7CkBAIC02MjAsNyArNjIxLDggQEAgc3RydWN0IHNtYl92b2wgewogCQkJIENJRlNfTU9V
TlRfTVVMVElVU0VSIHwgQ0lGU19NT1VOVF9TVFJJQ1RfSU8gfCBcCiAJCQkgQ0lGU19NT1VOVF9D
SUZTX0JBQ0tVUFVJRCB8IENJRlNfTU9VTlRfQ0lGU19CQUNLVVBHSUQgfCBcCiAJCQkgQ0lGU19N
T1VOVF9VSURfRlJPTV9BQ0wgfCBDSUZTX01PVU5UX05PX0hBTkRMRV9DQUNIRSB8IFwKLQkJCSBD
SUZTX01PVU5UX05PX0RGUyB8IENJRlNfTU9VTlRfTU9ERV9GUk9NX1NJRCkKKwkJCSBDSUZTX01P
VU5UX05PX0RGUyB8IENJRlNfTU9VTlRfTU9ERV9GUk9NX1NJRCB8IFwKKwkJCSBDSUZTX01PVU5U
X0VOQ09ERURfWEFUVFIpCiAKIC8qKgogICogR2VuZXJpYyBWRlMgc3VwZXJibG9jayBtb3VudCBm
bGFncyAoc19mbGFncykgdG8gY29uc2lkZXIgd2hlbgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jb25u
ZWN0LmMgYi9mcy9jaWZzL2Nvbm5lY3QuYwppbmRleCA2MzMxYzRmOTNiNTkuLjM1ZGZjNDEyMzcw
YiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jb25uZWN0LmMKKysrIGIvZnMvY2lmcy9jb25uZWN0LmMK
QEAgLTk3LDcgKzk3LDcgQEAgZW51bSB7CiAJT3B0X3BlcnNpc3RlbnQsIE9wdF9ub3BlcnNpc3Rl
bnQsCiAJT3B0X3Jlc2lsaWVudCwgT3B0X25vcmVzaWxpZW50LAogCU9wdF9kb21haW5hdXRvLCBP
cHRfcmRtYSwgT3B0X21vZGVzaWQsCi0JT3B0X2NvbXByZXNzLAorCU9wdF9jb21wcmVzcywgT3B0
X2VuY29kZWR4YXR0ciwKIAogCS8qIE1vdW50IG9wdGlvbnMgd2hpY2ggdGFrZSBudW1lcmljIHZh
bHVlICovCiAJT3B0X2JhY2t1cHVpZCwgT3B0X2JhY2t1cGdpZCwgT3B0X3VpZCwKQEAgLTE5Niw2
ICsxOTYsNyBAQCBzdGF0aWMgY29uc3QgbWF0Y2hfdGFibGVfdCBjaWZzX21vdW50X29wdGlvbl90
b2tlbnMgPSB7CiAJeyBPcHRfbm9yZXNpbGllbnQsICJub3Jlc2lsaWVudGhhbmRsZXMifSwKIAl7
IE9wdF9kb21haW5hdXRvLCAiZG9tYWluYXV0byJ9LAogCXsgT3B0X3JkbWEsICJyZG1hIn0sCisJ
eyBPcHRfZW5jb2RlZHhhdHRyLCAiZW5jb2RlZHhhdHRyIiB9LAogCiAJeyBPcHRfYmFja3VwdWlk
LCAiYmFja3VwdWlkPSVzIiB9LAogCXsgT3B0X2JhY2t1cGdpZCwgImJhY2t1cGdpZD0lcyIgfSwK
QEAgLTE5MjIsNiArMTkyMyw5IEBAIGNpZnNfcGFyc2VfbW91bnRfb3B0aW9ucyhjb25zdCBjaGFy
ICptb3VudGRhdGEsIGNvbnN0IGNoYXIgKmRldm5hbWUsCiAJCQljaWZzX2RiZyhWRlMsCiAJCQkJ
IlNNQjMgY29tcHJlc3Npb24gc3VwcG9ydCBpcyBleHBlcmltZW50YWxcbiIpOwogCQkJYnJlYWs7
CisJCWNhc2UgT3B0X2VuY29kZWR4YXR0cjoKKwkJCXZvbC0+ZW5jb2RlZF94YXR0ciA9IDE7CisJ
CQlicmVhazsKIAogCQkvKiBOdW1lcmljIFZhbHVlcyAqLwogCQljYXNlIE9wdF9iYWNrdXB1aWQ6
CkBAIC00MDA0LDYgKzQwMDgsOCBAQCBpbnQgY2lmc19zZXR1cF9jaWZzX3NiKHN0cnVjdCBzbWJf
dm9sICpwdm9sdW1lX2luZm8sCiAJCWNpZnNfc2ItPm1udF9jaWZzX2ZsYWdzIHw9IENJRlNfTU9V
TlRfT1ZFUlJfVUlEOwogCWlmIChwdm9sdW1lX2luZm8tPm92ZXJyaWRlX2dpZCkKIAkJY2lmc19z
Yi0+bW50X2NpZnNfZmxhZ3MgfD0gQ0lGU19NT1VOVF9PVkVSUl9HSUQ7CisJaWYgKHB2b2x1bWVf
aW5mby0+ZW5jb2RlZF94YXR0cikKKwkJY2lmc19zYi0+bW50X2NpZnNfZmxhZ3MgfD0gQ0lGU19N
T1VOVF9FTkNPREVEX1hBVFRSOwogCWlmIChwdm9sdW1lX2luZm8tPmR5bnBlcm0pCiAJCWNpZnNf
c2ItPm1udF9jaWZzX2ZsYWdzIHw9IENJRlNfTU9VTlRfRFlOUEVSTTsKIAlpZiAocHZvbHVtZV9p
bmZvLT5mc2MpCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJvcHMuYyBiL2ZzL2NpZnMvc21iMm9w
cy5jCmluZGV4IDBjZGM0ZTQ3Y2E4Ny4uNmNiNGRlZjExZWJlIDEwMDY0NAotLS0gYS9mcy9jaWZz
L3NtYjJvcHMuYworKysgYi9mcy9jaWZzL3NtYjJvcHMuYwpAQCAtODc4LDcgKzg3OCw4IEBAIHNt
YjJfcXVlcnlfZmlsZV9pbmZvKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rj
b24gKnRjb24sCiBzdGF0aWMgc3NpemVfdAogbW92ZV9zbWIyX2VhX3RvX2NpZnMoY2hhciAqZHN0
LCBzaXplX3QgZHN0X3NpemUsCiAJCSAgICAgc3RydWN0IHNtYjJfZmlsZV9mdWxsX2VhX2luZm8g
KnNyYywgc2l6ZV90IHNyY19zaXplLAotCQkgICAgIGNvbnN0IHVuc2lnbmVkIGNoYXIgKmVhX25h
bWUpCisJCSAgICAgY29uc3QgdW5zaWduZWQgY2hhciAqZWFfbmFtZSwKKwkJICAgICBzdHJ1Y3Qg
Y2lmc19zYl9pbmZvICpjaWZzX3NiKQogewogCWludCByYyA9IDA7CiAJdW5zaWduZWQgaW50IGVh
X25hbWVfbGVuID0gZWFfbmFtZSA/IHN0cmxlbihlYV9uYW1lKSA6IDA7CkBAIC04OTIsNiArODkz
LDE4IEBAIG1vdmVfc21iMl9lYV90b19jaWZzKGNoYXIgKmRzdCwgc2l6ZV90IGRzdF9zaXplLAog
CQl2YWx1ZSA9ICZzcmMtPmVhX2RhdGFbc3JjLT5lYV9uYW1lX2xlbmd0aCArIDFdOwogCQl2YWx1
ZV9sZW4gPSAoc2l6ZV90KWxlMTZfdG9fY3B1KHNyYy0+ZWFfdmFsdWVfbGVuZ3RoKTsKIAorCQlp
ZiAoY2lmc19zYi0+bW50X2NpZnNfZmxhZ3MgfCBDSUZTX01PVU5UX0VOQ09ERURfWEFUVFIpIHsK
KwkJCWlmIChuYW1lX2xlbiAmIDB4MDEpIHsKKwkJCQlyYyA9IC1FSU5WQUw7CisJCQkJZ290byBv
dXQ7CisJCQl9CisJCQluYW1lX2xlbiA9IG5hbWVfbGVuIC8gMjsKKwkJCWlmIChoZXgyYmluKG5h
bWUsIG5hbWUsIG5hbWVfbGVuKSkgeworCQkJCXJjID0gLUVJTlZBTDsKKwkJCQlnb3RvIG91dDsK
KwkJCX0KKwkJfQorCiAJCWlmIChuYW1lX2xlbiA9PSAwKQogCQkJYnJlYWs7CiAKQEAgLTEwMDUs
NyArMTAxOCw4IEBAIHNtYjJfcXVlcnlfZWFzKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVj
dCBjaWZzX3Rjb24gKnRjb24sCiAJaW5mbyA9IChzdHJ1Y3Qgc21iMl9maWxlX2Z1bGxfZWFfaW5m
byAqKSgKIAkJCWxlMTZfdG9fY3B1KHJzcC0+T3V0cHV0QnVmZmVyT2Zmc2V0KSArIChjaGFyICop
cnNwKTsKIAlyYyA9IG1vdmVfc21iMl9lYV90b19jaWZzKGVhX2RhdGEsIGJ1Zl9zaXplLCBpbmZv
LAotCQkJbGUzMl90b19jcHUocnNwLT5PdXRwdXRCdWZmZXJMZW5ndGgpLCBlYV9uYW1lKTsKKwkJ
CQkgIGxlMzJfdG9fY3B1KHJzcC0+T3V0cHV0QnVmZmVyTGVuZ3RoKSwKKwkJCQkgIGVhX25hbWUs
IGNpZnNfc2IpOwogCiAgcWVhc19leGl0OgogCWtmcmVlKHV0ZjE2X3BhdGgpOwpAQCAtMTAxNiwx
MyArMTAzMCwxNCBAQCBzbWIyX3F1ZXJ5X2Vhcyhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1
Y3QgY2lmc190Y29uICp0Y29uLAogCiBzdGF0aWMgaW50CiBzbWIyX3NldF9lYShjb25zdCB1bnNp
Z25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAotCSAgICBjb25zdCBjaGFyICpw
YXRoLCBjb25zdCBjaGFyICplYV9uYW1lLCBjb25zdCB2b2lkICplYV92YWx1ZSwKKwkgICAgY29u
c3QgY2hhciAqcGF0aCwgY29uc3QgY2hhciAqbmFtZSwgY29uc3Qgdm9pZCAqZWFfdmFsdWUsCiAJ
ICAgIGNvbnN0IF9fdTE2IGVhX3ZhbHVlX2xlbiwgY29uc3Qgc3RydWN0IG5sc190YWJsZSAqbmxz
X2NvZGVwYWdlLAogCSAgICBzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiKQogewogCXN0cnVj
dCBjaWZzX3NlcyAqc2VzID0gdGNvbi0+c2VzOwogCV9fbGUxNiAqdXRmMTZfcGF0aCA9IE5VTEw7
Ci0JaW50IGVhX25hbWVfbGVuID0gc3RybGVuKGVhX25hbWUpOworCWNoYXIgKmVhX25hbWUgPSAo
Y2hhciAqKW5hbWU7CisJaW50IGVhX25hbWVfbGVuID0gc3RybGVuKG5hbWUpOwogCWludCBmbGFn
cyA9IDA7CiAJaW50IGxlbjsKIAlzdHJ1Y3Qgc21iX3Jxc3QgcnFzdFszXTsKQEAgLTEwMzksMTkg
KzEwNTQsMzQgQEAgc21iMl9zZXRfZWEoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNp
ZnNfdGNvbiAqdGNvbiwKIAlzdHJ1Y3Qga3ZlYyBjbG9zZV9pb3ZbMV07CiAJaW50IHJjOwogCisJ
bWVtc2V0KHJxc3QsIDAsIHNpemVvZihycXN0KSk7CisJcmVzcF9idWZ0eXBlWzBdID0gcmVzcF9i
dWZ0eXBlWzFdID0gcmVzcF9idWZ0eXBlWzJdID0gQ0lGU19OT19CVUZGRVI7CisJbWVtc2V0KHJz
cF9pb3YsIDAsIHNpemVvZihyc3BfaW92KSk7CisKIAlpZiAoc21iM19lbmNyeXB0aW9uX3JlcXVp
cmVkKHRjb24pKQogCQlmbGFncyB8PSBDSUZTX1RSQU5TRk9STV9SRVE7CiAKLQlpZiAoZWFfbmFt
ZV9sZW4gPiAyNTUpCi0JCXJldHVybiAtRUlOVkFMOworCS8qIERvIHdlIG5lZWQgdG8gZW5jb2Rl
IHRoZSBuYW1lIGluIGhleCA/ICovCisJaWYgKGNpZnNfc2ItPm1udF9jaWZzX2ZsYWdzIHwgQ0lG
U19NT1VOVF9FTkNPREVEX1hBVFRSKSB7CisJCWVhX25hbWUgPSBremFsbG9jKGVhX25hbWVfbGVu
ICogMiArIDEsIEdGUF9LRVJORUwpOworCQlpZiAoZWFfbmFtZSA9PSBOVUxMKSB7CisJCQlyYyA9
IC1FTk9NRU07CisJCQlnb3RvIHNlYV9leGl0OworCQl9CisJCWJpbjJoZXgoZWFfbmFtZSwgbmFt
ZSwgZWFfbmFtZV9sZW4pOworCQllYV9uYW1lX2xlbiA9IDIgKiBlYV9uYW1lX2xlbjsKKwl9CiAK
LQl1dGYxNl9wYXRoID0gY2lmc19jb252ZXJ0X3BhdGhfdG9fdXRmMTYocGF0aCwgY2lmc19zYik7
Ci0JaWYgKCF1dGYxNl9wYXRoKQotCQlyZXR1cm4gLUVOT01FTTsKKwlpZiAoZWFfbmFtZV9sZW4g
PiAyNTUpIHsKKwkJcmMgPSAtRUlOVkFMOworCQlnb3RvIHNlYV9leGl0OworCX0KIAotCW1lbXNl
dChycXN0LCAwLCBzaXplb2YocnFzdCkpOwotCXJlc3BfYnVmdHlwZVswXSA9IHJlc3BfYnVmdHlw
ZVsxXSA9IHJlc3BfYnVmdHlwZVsyXSA9IENJRlNfTk9fQlVGRkVSOwotCW1lbXNldChyc3BfaW92
LCAwLCBzaXplb2YocnNwX2lvdikpOworCXV0ZjE2X3BhdGggPSBjaWZzX2NvbnZlcnRfcGF0aF90
b191dGYxNihwYXRoLCBjaWZzX3NiKTsKKwlpZiAoIXV0ZjE2X3BhdGgpIHsKKwkJcmMgPSAtRU5P
TUVNOworCQlnb3RvIHNlYV9leGl0OworCX0KIAogCWlmIChzZXMtPnNlcnZlci0+b3BzLT5xdWVy
eV9hbGxfRUFzKSB7CiAJCWlmICghZWFfdmFsdWUpIHsKQEAgLTExMjQsNiArMTE1NCw4IEBAIHNt
YjJfc2V0X2VhKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24s
CiAJCQkJcmVzcF9idWZ0eXBlLCByc3BfaW92KTsKIAogIHNlYV9leGl0OgorCWlmIChjaWZzX3Ni
LT5tbnRfY2lmc19mbGFncyB8IENJRlNfTU9VTlRfRU5DT0RFRF9YQVRUUikKKwkJa2ZyZWUoZWFf
bmFtZSk7CiAJa2ZyZWUoZWEpOwogCWtmcmVlKHV0ZjE2X3BhdGgpOwogCVNNQjJfb3Blbl9mcmVl
KCZycXN0WzBdKTsKLS0gCjIuMjAuMQoK
--0000000000003fe081058dc5c0d7--
