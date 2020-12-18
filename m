Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF64CC4361B
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Dec 2020 19:36:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84B9923B27
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Dec 2020 19:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgLRTgm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Dec 2020 14:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbgLRTgl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 18 Dec 2020 14:36:41 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC92FC0617A7;
        Fri, 18 Dec 2020 11:36:00 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id a9so8338703lfh.2;
        Fri, 18 Dec 2020 11:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yw53UT/eieeA1AJz4iXhi2WdwBQWsYKnPTtlVvAF2dg=;
        b=EeM2VL4N5S5/q3EgaYcz0R0WR2s6ivEiz53NWd0EkwdnWw/5RS8dZDEYBlMFztWDxo
         XG4zxA2sS+Y+ocXLSHpbyK2KcKoyHTEQL1QaSsXqrCJFYVGbbybadGr4uerZKA/kxv99
         X0S5XcDbrL5asksaGF+4NEdf33f7PClw0H4aMccuASl905N/49TGC6ehcf9IKml2ApYw
         6/lqmvWUaILs23C7I76hsP6Lhyt2uwUJFVVXwkB1EweG6Js7eaZzPFHXlENxW3UyA85h
         lprSkuk23M8Dn+y8DMTJon4t0VMADhVY6dsvJGsnWmjylGSJtj+7ICEWnrmrTXJcb8lQ
         xnew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yw53UT/eieeA1AJz4iXhi2WdwBQWsYKnPTtlVvAF2dg=;
        b=lG/eTXVxvLTO5ebliWe+YiuQKbldaArGR3/J6a1ZA/Kcjt3052DNHqGojGIjBYo8da
         Rbn2vs3MQt/E71q9XZ6w/NOs+e+2H0N6wP5FxA4kTAVL/eMfggv7raFztUpEiyAgXOZZ
         IcSVREbzjfXnrChp7xShemSqh+CbaxeXUcgVVOUWIJeIz7Mqak0YocOHgjAe6wlDUIDf
         M/rdc8XhcJjVTN/yWg50psGPMPyOPjqry0VCycPfaMmED/R/uiggY0HRnWPINV073/PK
         ffkgG+WTPNcstveyzsdd3lQtWF32EbhPyUgDb6Mdinp9C2JVeDY4M9KGLXWnj8KvBmXH
         j0RQ==
X-Gm-Message-State: AOAM533qMlcopGuqWUd5b80+nBa4MwCGGY8kaRK/9Ia1YChgnGJbXrOD
        ruRmh4fpoaU8hy+mKUAj4cfKaAVnvMliOAzmLbk=
X-Google-Smtp-Source: ABdhPJz4gafoIDMPIg4PXfwLUXpdWBdXaQ6c5P12Xc+5mQiv6inwtarTrG/1bfEE9XyhnaKMzFbP7Trt8LopthsNwwM=
X-Received: by 2002:ac2:5547:: with SMTP id l7mr2002350lfk.313.1608320159286;
 Fri, 18 Dec 2020 11:35:59 -0800 (PST)
MIME-Version: 1.0
References: <20201027204226.26906-1-pboris@amazon.com> <20201217205808.14756-1-pboris@amazon.com>
In-Reply-To: <20201217205808.14756-1-pboris@amazon.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 18 Dec 2020 13:35:47 -0600
Message-ID: <CAH2r5mtNztcQPMEusuPv-DBMK+rR3-hbs1=y2Ls_jxO2xj7vAA@mail.gmail.com>
Subject: Re: [PATCH 2/2] Add SMB 2 support for getting and setting SACLs
To:     Boris Protopopov <pboris@amazon.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, samjonas@amazon.com
Content-Type: multipart/mixed; boundary="000000000000c7a2a805b6c23712"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000c7a2a805b6c23712
Content-Type: text/plain; charset="UTF-8"

Lightly updated the patch to shrink patch2 by naming a variable the
same in patch 1, to avoid a rename of a local variable in patch2.  And
fixed one trivial checkpatch warning, and a trivial rebase issue.

Tentatively merged into cifs-2.6.git for-next pending more review(s)
and also the usual regression testing.

On Thu, Dec 17, 2020 at 3:00 PM Boris Protopopov <pboris@amazon.com> wrote:
>
> Fix passing of the additional security info via version
> operations. Force new open when getting SACL and avoid
> reuse of files that were previously open without
> sufficient privileges to access SACLs.
>
> Signed-off-by: Boris Protopopov <pboris@amazon.com>
> ---
>
> After further testing, I found that the security info was not being
> passed correctly to opts->get_acl and opts->get_acl_by_fid(). Also,
> it turned out that files open for read were being used to fetch
> SACL without proper privileges. This patch fixes these issues, and
> is meant to be squashed (comments dropped) with the earlier patch.
>
> fs/cifs/cifsacl.c | 10 +++++-----
>  fs/cifs/smb2ops.c |  4 ++--
>  fs/cifs/smb2pdu.c |  4 +++-
>  fs/cifs/xattr.c   | 10 ++++------
>  4 files changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index 353394d9ada8..6baa121952ce 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -1245,7 +1245,7 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
>         int rc = 0;
>         struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
>         struct smb_version_operations *ops;
> -       const u32 unused = 0;
> +       const u32 info = 0;
>
>         cifs_dbg(NOISY, "converting ACL to mode for %s\n", path);
>
> @@ -1255,9 +1255,9 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
>         ops = tlink_tcon(tlink)->ses->server->ops;
>
>         if (pfid && (ops->get_acl_by_fid))
> -               pntsd = ops->get_acl_by_fid(cifs_sb, pfid, &acllen, unused);
> +               pntsd = ops->get_acl_by_fid(cifs_sb, pfid, &acllen, info);
>         else if (ops->get_acl)
> -               pntsd = ops->get_acl(cifs_sb, inode, path, &acllen, unused);
> +               pntsd = ops->get_acl(cifs_sb, inode, path, &acllen, info);
>         else {
>                 cifs_put_tlink(tlink);
>                 return -EOPNOTSUPP;
> @@ -1295,7 +1295,7 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 nmode,
>         struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
>         struct smb_version_operations *ops;
>         bool mode_from_sid, id_from_sid;
> -       const u32 unused = 0;
> +       const u32 info = 0;
>
>         if (IS_ERR(tlink))
>                 return PTR_ERR(tlink);
> @@ -1311,7 +1311,7 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 nmode,
>                 return -EOPNOTSUPP;
>         }
>
> -       pntsd = ops->get_acl(cifs_sb, inode, path, &secdesclen, unused);
> +       pntsd = ops->get_acl(cifs_sb, inode, path, &secdesclen, info);
>         if (IS_ERR(pntsd)) {
>                 rc = PTR_ERR(pntsd);
>                 cifs_dbg(VFS, "%s: error %d getting sec desc\n", __func__, rc);
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index d28a29728fb1..f5e198860c16 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -3315,9 +3315,9 @@ get_smb2_acl(struct cifs_sb_info *cifs_sb,
>         struct cifs_ntsd *pntsd = NULL;
>         struct cifsFileInfo *open_file = NULL;
>
> -       if (inode)
> +       if (inode && !(info & SACL_SECINFO))
>                 open_file = find_readable_file(CIFS_I(inode), true);
> -       if (!open_file)
> +       if (!open_file || (info & SACL_SECINFO))
>                 return get_smb2_acl_by_path(cifs_sb, path, pacllen, info);
>
>         pntsd = get_smb2_acl_by_fid(cifs_sb, &open_file->fid, pacllen, info);
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 0aeb63694306..b207e1eb6803 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -3472,8 +3472,10 @@ SMB311_posix_query_info(const unsigned int xid, struct cifs_tcon *tcon,
>  int
>  SMB2_query_acl(const unsigned int xid, struct cifs_tcon *tcon,
>                u64 persistent_fid, u64 volatile_fid,
> -              void **data, u32 *plen, u32 additional_info)
> +              void **data, u32 *plen, u32 extra_info)
>  {
> +       __u32 additional_info = OWNER_SECINFO | GROUP_SECINFO | DACL_SECINFO |
> +                               extra_info;
>         *plen = 0;
>
>         return query_info(xid, tcon, persistent_fid, volatile_fid,
> diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
> index 9318a2acf4ee..6b658a1172ef 100644
> --- a/fs/cifs/xattr.c
> +++ b/fs/cifs/xattr.c
> @@ -340,21 +340,19 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
>                  * fetch owner, DACL, and SACL if asked for full descriptor,
>                  * fetch owner and DACL otherwise
>                  */
> -               u32 acllen, additional_info = 0;
> +               u32 acllen, extra_info;
>                 struct cifs_ntsd *pacl;
>
>                 if (pTcon->ses->server->ops->get_acl == NULL)
>                         goto out; /* rc already EOPNOTSUPP */
>
>                 if (handler->flags == XATTR_CIFS_NTSD_FULL) {
> -                       additional_info = OWNER_SECINFO | GROUP_SECINFO |
> -                               DACL_SECINFO | SACL_SECINFO;
> +                       extra_info = SACL_SECINFO;
>                 } else {
> -                       additional_info = OWNER_SECINFO | GROUP_SECINFO |
> -                               DACL_SECINFO;
> +                       extra_info = 0;
>                 }
>                 pacl = pTcon->ses->server->ops->get_acl(cifs_sb,
> -                               inode, full_path, &acllen, additional_info);
> +                               inode, full_path, &acllen, extra_info);
>                 if (IS_ERR(pacl)) {
>                         rc = PTR_ERR(pacl);
>                         cifs_dbg(VFS, "%s: error %zd getting sec desc\n",
> --
> 2.18.4
>


-- 
Thanks,

Steve

--000000000000c7a2a805b6c23712
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-Add-support-for-getting-and-setting-SACLs.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-Add-support-for-getting-and-setting-SACLs.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kiuo9ru00>
X-Attachment-Id: f_kiuo9ru00

RnJvbSBkNDJkMGMwMzM0ZWY5MTgzMTBiMTE4MThjMTgwNTYyNGMwZWU5NDQwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCb3JpcyBQcm90b3BvcG92IDxwYm9yaXNAYW1hem9uLmNvbT4K
RGF0ZTogRnJpLCAxOCBEZWMgMjAyMCAxMTozMDoxMiAtMDYwMApTdWJqZWN0OiBbUEFUQ0ggMS8y
XSBTTUIzOiBBZGQgc3VwcG9ydCBmb3IgZ2V0dGluZyBhbmQgc2V0dGluZyBTQUNMcwoKQWRkIFNZ
U1RFTV9TRUNVUklUWSBhY2Nlc3MgZmxhZyBhbmQgdXNlIHdpdGggc21iMiB3aGVuIG9wZW5pbmcK
ZmlsZXMgZm9yIGdldHRpbmcvc2V0dGluZyBTQUNMcy4gQWRkICJzeXN0ZW0uY2lmc19udHNkX2Z1
bGwiCmV4dGVuZGVkIGF0dHJpYnV0ZSB0byBhbGxvdyB1c2VyLXNwYWNlIGFjY2VzcyB0byB0aGUg
ZnVuY3Rpb25hbGl0eS4KQXZvaWQgbXVsdGlwbGUgc2VydmVyIGNhbGxzIHdoZW4gc2V0dGluZyBv
d25lciwgREFDTCwgYW5kIFNBQ0wuCgpTaWduZWQtb2ZmLWJ5OiBCb3JpcyBQcm90b3BvcG92IDxw
Ym9yaXNAYW1hem9uLmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBt
aWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY2lmc2FjbC5jICAgfCAxNSArKysrLS0tLQogZnMv
Y2lmcy9jaWZzZ2xvYi5oICB8ICA0ICstLQogZnMvY2lmcy9jaWZzcGR1LmggICB8ICAyICsrCiBm
cy9jaWZzL2NpZnNwcm90by5oIHwgIDQgKy0tCiBmcy9jaWZzL3NtYjJvcHMuYyAgIHwgMzEgKysr
KysrKysrKy0tLS0tLS0KIGZzL2NpZnMvc21iMnBkdS5jICAgfCAgNSArKy0KIGZzL2NpZnMvc21i
MnByb3RvLmggfCAgNCArLS0KIGZzL2NpZnMveGF0dHIuYyAgICAgfCA4MyArKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0KIDggZmlsZXMgY2hhbmdlZCwgMTAwIGlu
c2VydGlvbnMoKyksIDQ4IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2Fj
bC5jIGIvZnMvY2lmcy9jaWZzYWNsLmMKaW5kZXggMmYyMWY4OTg3MWNjLi4yYzkwNTFmNWU4NmEg
MTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc2FjbC5jCisrKyBiL2ZzL2NpZnMvY2lmc2FjbC5jCkBA
IC0xMTk1LDcgKzExOTUsOCBAQCBzdGF0aWMgaW50IGJ1aWxkX3NlY19kZXNjKHN0cnVjdCBjaWZz
X250c2QgKnBudHNkLCBzdHJ1Y3QgY2lmc19udHNkICpwbm50c2QsCiB9CiAKIHN0cnVjdCBjaWZz
X250c2QgKmdldF9jaWZzX2FjbF9ieV9maWQoc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwK
LQkJY29uc3Qgc3RydWN0IGNpZnNfZmlkICpjaWZzZmlkLCB1MzIgKnBhY2xsZW4pCisJCQkJICAg
ICAgY29uc3Qgc3RydWN0IGNpZnNfZmlkICpjaWZzZmlkLCB1MzIgKnBhY2xsZW4sCisJCQkJICAg
ICAgdTMyIF9fbWF5YmVfdW51c2VkIHVudXNlZCkKIHsKIAlzdHJ1Y3QgY2lmc19udHNkICpwbnRz
ZCA9IE5VTEw7CiAJdW5zaWduZWQgaW50IHhpZDsKQEAgLTEyNjMsNyArMTI2NCw3IEBAIHN0YXRp
YyBzdHJ1Y3QgY2lmc19udHNkICpnZXRfY2lmc19hY2xfYnlfcGF0aChzdHJ1Y3QgY2lmc19zYl9p
bmZvICpjaWZzX3NiLAogLyogUmV0cmlldmUgYW4gQUNMIGZyb20gdGhlIHNlcnZlciAqLwogc3Ry
dWN0IGNpZnNfbnRzZCAqZ2V0X2NpZnNfYWNsKHN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2Is
CiAJCQkJICAgICAgc3RydWN0IGlub2RlICppbm9kZSwgY29uc3QgY2hhciAqcGF0aCwKLQkJCQkg
ICAgICB1MzIgKnBhY2xsZW4pCisJCQkgICAgICAgdTMyICpwYWNsbGVuLCB1MzIgaW5mbykKIHsK
IAlzdHJ1Y3QgY2lmc19udHNkICpwbnRzZCA9IE5VTEw7CiAJc3RydWN0IGNpZnNGaWxlSW5mbyAq
b3Blbl9maWxlID0gTlVMTDsKQEAgLTEyNzMsNyArMTI3NCw3IEBAIHN0cnVjdCBjaWZzX250c2Qg
KmdldF9jaWZzX2FjbChzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiLAogCWlmICghb3Blbl9m
aWxlKQogCQlyZXR1cm4gZ2V0X2NpZnNfYWNsX2J5X3BhdGgoY2lmc19zYiwgcGF0aCwgcGFjbGxl
bik7CiAKLQlwbnRzZCA9IGdldF9jaWZzX2FjbF9ieV9maWQoY2lmc19zYiwgJm9wZW5fZmlsZS0+
ZmlkLCBwYWNsbGVuKTsKKwlwbnRzZCA9IGdldF9jaWZzX2FjbF9ieV9maWQoY2lmc19zYiwgJm9w
ZW5fZmlsZS0+ZmlkLCBwYWNsbGVuLCBpbmZvKTsKIAljaWZzRmlsZUluZm9fcHV0KG9wZW5fZmls
ZSk7CiAJcmV0dXJuIHBudHNkOwogfQpAQCAtMTMzOCw2ICsxMzM5LDcgQEAgY2lmc19hY2xfdG9f
ZmF0dHIoc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwgc3RydWN0IGNpZnNfZmF0dHIgKmZh
dHRyLAogCWludCByYyA9IDA7CiAJc3RydWN0IHRjb25fbGluayAqdGxpbmsgPSBjaWZzX3NiX3Rs
aW5rKGNpZnNfc2IpOwogCXN0cnVjdCBzbWJfdmVyc2lvbl9vcGVyYXRpb25zICpvcHM7CisJY29u
c3QgdTMyIGluZm8gPSAwOwogCiAJY2lmc19kYmcoTk9JU1ksICJjb252ZXJ0aW5nIEFDTCB0byBt
b2RlIGZvciAlc1xuIiwgcGF0aCk7CiAKQEAgLTEzNDcsOSArMTM0OSw5IEBAIGNpZnNfYWNsX3Rv
X2ZhdHRyKHN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2IsIHN0cnVjdCBjaWZzX2ZhdHRyICpm
YXR0ciwKIAlvcHMgPSB0bGlua190Y29uKHRsaW5rKS0+c2VzLT5zZXJ2ZXItPm9wczsKIAogCWlm
IChwZmlkICYmIChvcHMtPmdldF9hY2xfYnlfZmlkKSkKLQkJcG50c2QgPSBvcHMtPmdldF9hY2xf
YnlfZmlkKGNpZnNfc2IsIHBmaWQsICZhY2xsZW4pOworCQlwbnRzZCA9IG9wcy0+Z2V0X2FjbF9i
eV9maWQoY2lmc19zYiwgcGZpZCwgJmFjbGxlbiwgaW5mbyk7CiAJZWxzZSBpZiAob3BzLT5nZXRf
YWNsKQotCQlwbnRzZCA9IG9wcy0+Z2V0X2FjbChjaWZzX3NiLCBpbm9kZSwgcGF0aCwgJmFjbGxl
bik7CisJCXBudHNkID0gb3BzLT5nZXRfYWNsKGNpZnNfc2IsIGlub2RlLCBwYXRoLCAmYWNsbGVu
LCBpbmZvKTsKIAllbHNlIHsKIAkJY2lmc19wdXRfdGxpbmsodGxpbmspOwogCQlyZXR1cm4gLUVP
UE5PVFNVUFA7CkBAIC0xMzg4LDYgKzEzOTAsNyBAQCBpZF9tb2RlX3RvX2NpZnNfYWNsKHN0cnVj
dCBpbm9kZSAqaW5vZGUsIGNvbnN0IGNoYXIgKnBhdGgsIF9fdTY0ICpwbm1vZGUsCiAJc3RydWN0
IHRjb25fbGluayAqdGxpbmsgPSBjaWZzX3NiX3RsaW5rKGNpZnNfc2IpOwogCXN0cnVjdCBzbWJf
dmVyc2lvbl9vcGVyYXRpb25zICpvcHM7CiAJYm9vbCBtb2RlX2Zyb21fc2lkLCBpZF9mcm9tX3Np
ZDsKKwljb25zdCB1MzIgaW5mbyA9IDA7CiAKIAlpZiAoSVNfRVJSKHRsaW5rKSkKIAkJcmV0dXJu
IFBUUl9FUlIodGxpbmspOwpAQCAtMTQwMyw3ICsxNDA2LDcgQEAgaWRfbW9kZV90b19jaWZzX2Fj
bChzdHJ1Y3QgaW5vZGUgKmlub2RlLCBjb25zdCBjaGFyICpwYXRoLCBfX3U2NCAqcG5tb2RlLAog
CQlyZXR1cm4gLUVPUE5PVFNVUFA7CiAJfQogCi0JcG50c2QgPSBvcHMtPmdldF9hY2woY2lmc19z
YiwgaW5vZGUsIHBhdGgsICZzZWNkZXNjbGVuKTsKKwlwbnRzZCA9IG9wcy0+Z2V0X2FjbChjaWZz
X3NiLCBpbm9kZSwgcGF0aCwgJnNlY2Rlc2NsZW4sIGluZm8pOwogCWlmIChJU19FUlIocG50c2Qp
KSB7CiAJCXJjID0gUFRSX0VSUihwbnRzZCk7CiAJCWNpZnNfZGJnKFZGUywgIiVzOiBlcnJvciAl
ZCBnZXR0aW5nIHNlYyBkZXNjXG4iLCBfX2Z1bmNfXywgcmMpOwpkaWZmIC0tZ2l0IGEvZnMvY2lm
cy9jaWZzZ2xvYi5oIGIvZnMvY2lmcy9jaWZzZ2xvYi5oCmluZGV4IDcyMGQwZjZhOTgyZC4uNTBm
Y2I2NTkyMGU4IDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNnbG9iLmgKKysrIGIvZnMvY2lmcy9j
aWZzZ2xvYi5oCkBAIC00NTYsOSArNDU2LDkgQEAgc3RydWN0IHNtYl92ZXJzaW9uX29wZXJhdGlv
bnMgewogCQkJY29uc3QgY2hhciAqLCBjb25zdCB2b2lkICosIGNvbnN0IF9fdTE2LAogCQkJY29u
c3Qgc3RydWN0IG5sc190YWJsZSAqLCBzdHJ1Y3QgY2lmc19zYl9pbmZvICopOwogCXN0cnVjdCBj
aWZzX250c2QgKiAoKmdldF9hY2wpKHN0cnVjdCBjaWZzX3NiX2luZm8gKiwgc3RydWN0IGlub2Rl
ICosCi0JCQljb25zdCBjaGFyICosIHUzMiAqKTsKKwkJCWNvbnN0IGNoYXIgKiwgdTMyICosIHUz
Mik7CiAJc3RydWN0IGNpZnNfbnRzZCAqICgqZ2V0X2FjbF9ieV9maWQpKHN0cnVjdCBjaWZzX3Ni
X2luZm8gKiwKLQkJCWNvbnN0IHN0cnVjdCBjaWZzX2ZpZCAqLCB1MzIgKik7CisJCQljb25zdCBz
dHJ1Y3QgY2lmc19maWQgKiwgdTMyICosIHUzMik7CiAJaW50ICgqc2V0X2FjbCkoc3RydWN0IGNp
ZnNfbnRzZCAqLCBfX3UzMiwgc3RydWN0IGlub2RlICosIGNvbnN0IGNoYXIgKiwKIAkJCWludCk7
CiAJLyogd3JpdGVwYWdlcyByZXRyeSBzaXplICovCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNw
ZHUuaCBiL2ZzL2NpZnMvY2lmc3BkdS5oCmluZGV4IGNlNTExODNlY2FmNC4uNjRmZTVhNDdiNWU4
IDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNwZHUuaAorKysgYi9mcy9jaWZzL2NpZnNwZHUuaApA
QCAtMjQwLDYgKzI0MCw4IEBACiAjZGVmaW5lIFNZTkNIUk9OSVpFICAgICAgICAgICAweDAwMTAw
MDAwICAvKiBUaGUgZmlsZSBoYW5kbGUgY2FuIHdhaXRlZCBvbiB0byAqLwogCQkJCQkgIC8qIHN5
bmNocm9uaXplIHdpdGggdGhlIGNvbXBsZXRpb24gICovCiAJCQkJCSAgLyogb2YgYW4gaW5wdXQv
b3V0cHV0IHJlcXVlc3QgICAgICAgKi8KKyNkZWZpbmUgU1lTVEVNX1NFQ1VSSVRZICAgICAgIDB4
MDEwMDAwMDAgIC8qIFRoZSBzeXN0ZW0gYWNjZXNzIGNvbnRyb2wgbGlzdCAgICovCisJCQkJCSAg
LyogY2FuIGJlIHJlYWQgYW5kIGNoYW5nZWQgICAgICAgICAgKi8KICNkZWZpbmUgR0VORVJJQ19B
TEwgICAgICAgICAgIDB4MTAwMDAwMDAKICNkZWZpbmUgR0VORVJJQ19FWEVDVVRFICAgICAgIDB4
MjAwMDAwMDAKICNkZWZpbmUgR0VORVJJQ19XUklURSAgICAgICAgIDB4NDAwMDAwMDAKZGlmZiAt
LWdpdCBhL2ZzL2NpZnMvY2lmc3Byb3RvLmggYi9mcy9jaWZzL2NpZnNwcm90by5oCmluZGV4IGJk
MWM5YjAzODU2OC4uMzQwZmY4MWVlODdiIDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNwcm90by5o
CisrKyBiL2ZzL2NpZnMvY2lmc3Byb3RvLmgKQEAgLTIxOCw5ICsyMTgsOSBAQCBleHRlcm4gaW50
IGNpZnNfYWNsX3RvX2ZhdHRyKHN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2IsCiBleHRlcm4g
aW50IGlkX21vZGVfdG9fY2lmc19hY2woc3RydWN0IGlub2RlICppbm9kZSwgY29uc3QgY2hhciAq
cGF0aCwgX191NjQgKnBubW9kZSwKIAkJCQkJa3VpZF90IHVpZCwga2dpZF90IGdpZCk7CiBleHRl
cm4gc3RydWN0IGNpZnNfbnRzZCAqZ2V0X2NpZnNfYWNsKHN0cnVjdCBjaWZzX3NiX2luZm8gKiwg
c3RydWN0IGlub2RlICosCi0JCQkJCWNvbnN0IGNoYXIgKiwgdTMyICopOworCQkJCSAgICAgIGNv
bnN0IGNoYXIgKiwgdTMyICosIHUzMik7CiBleHRlcm4gc3RydWN0IGNpZnNfbnRzZCAqZ2V0X2Np
ZnNfYWNsX2J5X2ZpZChzdHJ1Y3QgY2lmc19zYl9pbmZvICosCi0JCQkJCQljb25zdCBzdHJ1Y3Qg
Y2lmc19maWQgKiwgdTMyICopOworCQkJCWNvbnN0IHN0cnVjdCBjaWZzX2ZpZCAqLCB1MzIgKiwg
dTMyKTsKIGV4dGVybiBpbnQgc2V0X2NpZnNfYWNsKHN0cnVjdCBjaWZzX250c2QgKiwgX191MzIs
IHN0cnVjdCBpbm9kZSAqLAogCQkJCWNvbnN0IGNoYXIgKiwgaW50KTsKIGV4dGVybiB1bnNpZ25l
ZCBpbnQgc2V0dXBfYXV0aHVzZXJzX0FDRShzdHJ1Y3QgY2lmc19hY2UgKnBhY2UpOwpkaWZmIC0t
Z2l0IGEvZnMvY2lmcy9zbWIyb3BzLmMgYi9mcy9jaWZzL3NtYjJvcHMuYwppbmRleCA5NDljZDEx
NzcxNDcuLjRhMTc2MTEzOWUwMCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIyb3BzLmMKKysrIGIv
ZnMvY2lmcy9zbWIyb3BzLmMKQEAgLTMyMTQsNyArMzIxNCw3IEBAIHNtYjJfcXVlcnlfcmVwYXJz
ZV90YWcoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAog
c3RhdGljIHN0cnVjdCBjaWZzX250c2QgKgogZ2V0X3NtYjJfYWNsX2J5X2ZpZChzdHJ1Y3QgY2lm
c19zYl9pbmZvICpjaWZzX3NiLAotCQljb25zdCBzdHJ1Y3QgY2lmc19maWQgKmNpZnNmaWQsIHUz
MiAqcGFjbGxlbikKKwkJICAgIGNvbnN0IHN0cnVjdCBjaWZzX2ZpZCAqY2lmc2ZpZCwgdTMyICpw
YWNsbGVuLCB1MzIgaW5mbykKIHsKIAlzdHJ1Y3QgY2lmc19udHNkICpwbnRzZCA9IE5VTEw7CiAJ
dW5zaWduZWQgaW50IHhpZDsKQEAgLTMyMjgsNyArMzIyOCw4IEBAIGdldF9zbWIyX2FjbF9ieV9m
aWQoc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwKIAljaWZzX2RiZyhGWUksICJ0cnlpbmcg
dG8gZ2V0IGFjbFxuIik7CiAKIAlyYyA9IFNNQjJfcXVlcnlfYWNsKHhpZCwgdGxpbmtfdGNvbih0
bGluayksIGNpZnNmaWQtPnBlcnNpc3RlbnRfZmlkLAotCQkJICAgIGNpZnNmaWQtPnZvbGF0aWxl
X2ZpZCwgKHZvaWQgKiopJnBudHNkLCBwYWNsbGVuKTsKKwkJCSAgICBjaWZzZmlkLT52b2xhdGls
ZV9maWQsICh2b2lkICoqKSZwbnRzZCwgcGFjbGxlbiwKKwkJCSAgICBpbmZvKTsKIAlmcmVlX3hp
ZCh4aWQpOwogCiAJY2lmc19wdXRfdGxpbmsodGxpbmspOwpAQCAtMzI0Miw3ICszMjQzLDcgQEAg
Z2V0X3NtYjJfYWNsX2J5X2ZpZChzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiLAogCiBzdGF0
aWMgc3RydWN0IGNpZnNfbnRzZCAqCiBnZXRfc21iMl9hY2xfYnlfcGF0aChzdHJ1Y3QgY2lmc19z
Yl9pbmZvICpjaWZzX3NiLAotCQljb25zdCBjaGFyICpwYXRoLCB1MzIgKnBhY2xsZW4pCisJCSAg
ICAgY29uc3QgY2hhciAqcGF0aCwgdTMyICpwYWNsbGVuLCB1MzIgaW5mbykKIHsKIAlzdHJ1Y3Qg
Y2lmc19udHNkICpwbnRzZCA9IE5VTEw7CiAJdTggb3Bsb2NrID0gU01CMl9PUExPQ0tfTEVWRUxf
Tk9ORTsKQEAgLTMyODAsMTIgKzMyODEsMTYgQEAgZ2V0X3NtYjJfYWNsX2J5X3BhdGgoc3RydWN0
IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwKIAlvcGFybXMuZmlkID0gJmZpZDsKIAlvcGFybXMucmVj
b25uZWN0ID0gZmFsc2U7CiAKKwlpZiAoaW5mbyAmIFNBQ0xfU0VDSU5GTykKKwkJb3Bhcm1zLmRl
c2lyZWRfYWNjZXNzIHw9IFNZU1RFTV9TRUNVUklUWTsKKwogCXJjID0gU01CMl9vcGVuKHhpZCwg
Jm9wYXJtcywgdXRmMTZfcGF0aCwgJm9wbG9jaywgTlVMTCwgTlVMTCwgTlVMTCwKIAkJICAgICAg
IE5VTEwpOwogCWtmcmVlKHV0ZjE2X3BhdGgpOwogCWlmICghcmMpIHsKIAkJcmMgPSBTTUIyX3F1
ZXJ5X2FjbCh4aWQsIHRsaW5rX3Rjb24odGxpbmspLCBmaWQucGVyc2lzdGVudF9maWQsCi0JCQkg
ICAgZmlkLnZvbGF0aWxlX2ZpZCwgKHZvaWQgKiopJnBudHNkLCBwYWNsbGVuKTsKKwkJCQkgICAg
ZmlkLnZvbGF0aWxlX2ZpZCwgKHZvaWQgKiopJnBudHNkLCBwYWNsbGVuLAorCQkJCSAgICBpbmZv
KTsKIAkJU01CMl9jbG9zZSh4aWQsIHRjb24sIGZpZC5wZXJzaXN0ZW50X2ZpZCwgZmlkLnZvbGF0
aWxlX2ZpZCk7CiAJfQogCkBAIC0zMzE5LDEwICszMzI0LDEyIEBAIHNldF9zbWIyX2FjbChzdHJ1
Y3QgY2lmc19udHNkICpwbm50c2QsIF9fdTMyIGFjbGxlbiwKIAl0Y29uID0gdGxpbmtfdGNvbih0
bGluayk7CiAJeGlkID0gZ2V0X3hpZCgpOwogCi0JaWYgKGFjbGZsYWcgPT0gQ0lGU19BQ0xfT1dO
RVIgfHwgYWNsZmxhZyA9PSBDSUZTX0FDTF9HUk9VUCkKLQkJYWNjZXNzX2ZsYWdzID0gV1JJVEVf
T1dORVI7Ci0JZWxzZQotCQlhY2Nlc3NfZmxhZ3MgPSBXUklURV9EQUM7CisJaWYgKGFjbGZsYWcg
JiBDSUZTX0FDTF9PV05FUiB8fCBhY2xmbGFnICYgQ0lGU19BQ0xfR1JPVVApCisJCWFjY2Vzc19m
bGFncyB8PSBXUklURV9PV05FUjsKKwlpZiAoYWNsZmxhZyAmIENJRlNfQUNMX1NBQ0wpCisJCWFj
Y2Vzc19mbGFncyB8PSBTWVNURU1fU0VDVVJJVFk7CisJaWYgKGFjbGZsYWcgJiBDSUZTX0FDTF9E
QUNMKQorCQlhY2Nlc3NfZmxhZ3MgfD0gV1JJVEVfREFDOwogCiAJdXRmMTZfcGF0aCA9IGNpZnNf
Y29udmVydF9wYXRoX3RvX3V0ZjE2KHBhdGgsIGNpZnNfc2IpOwogCWlmICghdXRmMTZfcGF0aCkg
ewpAQCAtMzM1Niw4ICszMzYzLDggQEAgc2V0X3NtYjJfYWNsKHN0cnVjdCBjaWZzX250c2QgKnBu
bnRzZCwgX191MzIgYWNsbGVuLAogLyogUmV0cmlldmUgYW4gQUNMIGZyb20gdGhlIHNlcnZlciAq
Lwogc3RhdGljIHN0cnVjdCBjaWZzX250c2QgKgogZ2V0X3NtYjJfYWNsKHN0cnVjdCBjaWZzX3Ni
X2luZm8gKmNpZnNfc2IsCi0JCQkJICAgICAgc3RydWN0IGlub2RlICppbm9kZSwgY29uc3QgY2hh
ciAqcGF0aCwKLQkJCQkgICAgICB1MzIgKnBhY2xsZW4pCisJICAgICBzdHJ1Y3QgaW5vZGUgKmlu
b2RlLCBjb25zdCBjaGFyICpwYXRoLAorCSAgICAgdTMyICpwYWNsbGVuLCB1MzIgaW5mbykKIHsK
IAlzdHJ1Y3QgY2lmc19udHNkICpwbnRzZCA9IE5VTEw7CiAJc3RydWN0IGNpZnNGaWxlSW5mbyAq
b3Blbl9maWxlID0gTlVMTDsKQEAgLTMzNjUsOSArMzM3Miw5IEBAIGdldF9zbWIyX2FjbChzdHJ1
Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiLAogCWlmIChpbm9kZSkKIAkJb3Blbl9maWxlID0gZmlu
ZF9yZWFkYWJsZV9maWxlKENJRlNfSShpbm9kZSksIHRydWUpOwogCWlmICghb3Blbl9maWxlKQot
CQlyZXR1cm4gZ2V0X3NtYjJfYWNsX2J5X3BhdGgoY2lmc19zYiwgcGF0aCwgcGFjbGxlbik7CisJ
CXJldHVybiBnZXRfc21iMl9hY2xfYnlfcGF0aChjaWZzX3NiLCBwYXRoLCBwYWNsbGVuLCBpbmZv
KTsKIAotCXBudHNkID0gZ2V0X3NtYjJfYWNsX2J5X2ZpZChjaWZzX3NiLCAmb3Blbl9maWxlLT5m
aWQsIHBhY2xsZW4pOworCXBudHNkID0gZ2V0X3NtYjJfYWNsX2J5X2ZpZChjaWZzX3NiLCAmb3Bl
bl9maWxlLT5maWQsIHBhY2xsZW4sIGluZm8pOwogCWNpZnNGaWxlSW5mb19wdXQob3Blbl9maWxl
KTsKIAlyZXR1cm4gcG50c2Q7CiB9CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuYyBiL2Zz
L2NpZnMvc21iMnBkdS5jCmluZGV4IGZjMDZjNzYyZmJiZi4uMjAyZDg3NDJkMTQ5IDEwMDY0NAot
LS0gYS9mcy9jaWZzL3NtYjJwZHUuYworKysgYi9mcy9jaWZzL3NtYjJwZHUuYwpAQCAtMzQ3OSwx
MCArMzQ3OSw5IEBAIFNNQjMxMV9wb3NpeF9xdWVyeV9pbmZvKGNvbnN0IHVuc2lnbmVkIGludCB4
aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAKIGludAogU01CMl9xdWVyeV9hY2woY29uc3Qg
dW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKLQkJdTY0IHBlcnNpc3Rl
bnRfZmlkLCB1NjQgdm9sYXRpbGVfZmlkLAotCQl2b2lkICoqZGF0YSwgdTMyICpwbGVuKQorCSAg
ICAgICB1NjQgcGVyc2lzdGVudF9maWQsIHU2NCB2b2xhdGlsZV9maWQsCisJICAgICAgIHZvaWQg
KipkYXRhLCB1MzIgKnBsZW4sIHUzMiBhZGRpdGlvbmFsX2luZm8pCiB7Ci0JX191MzIgYWRkaXRp
b25hbF9pbmZvID0gT1dORVJfU0VDSU5GTyB8IEdST1VQX1NFQ0lORk8gfCBEQUNMX1NFQ0lORk87
CiAJKnBsZW4gPSAwOwogCiAJcmV0dXJuIHF1ZXJ5X2luZm8oeGlkLCB0Y29uLCBwZXJzaXN0ZW50
X2ZpZCwgdm9sYXRpbGVfZmlkLApkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIycHJvdG8uaCBiL2Zz
L2NpZnMvc21iMnByb3RvLmgKaW5kZXggZDQxMTA0NDdlZTNhLi45NTY1ZTI3NjgxYTUgMTAwNjQ0
Ci0tLSBhL2ZzL2NpZnMvc21iMnByb3RvLmgKKysrIGIvZnMvY2lmcy9zbWIycHJvdG8uaApAQCAt
MjAwLDggKzIwMCw4IEBAIGV4dGVybiBpbnQgU01CMl9xdWVyeV9pbmZvX2luaXQoc3RydWN0IGNp
ZnNfdGNvbiAqdGNvbiwKIAkJCQlzaXplX3QgaW5wdXRfbGVuLCB2b2lkICppbnB1dCk7CiBleHRl
cm4gdm9pZCBTTUIyX3F1ZXJ5X2luZm9fZnJlZShzdHJ1Y3Qgc21iX3Jxc3QgKnJxc3QpOwogZXh0
ZXJuIGludCBTTUIyX3F1ZXJ5X2FjbChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lm
c190Y29uICp0Y29uLAotCQkJICAgdTY0IHBlcnNpc3RlbnRfZmlsZV9pZCwgdTY0IHZvbGF0aWxl
X2ZpbGVfaWQsCi0JCQkgICB2b2lkICoqZGF0YSwgdW5zaWduZWQgaW50ICpwbGVuKTsKKwkJCSAg
dTY0IHBlcnNpc3RlbnRfZmlsZV9pZCwgdTY0IHZvbGF0aWxlX2ZpbGVfaWQsCisJCQkgIHZvaWQg
KipkYXRhLCB1bnNpZ25lZCBpbnQgKnBsZW4sIHUzMiBpbmZvKTsKIGV4dGVybiBpbnQgU01CMl9n
ZXRfc3J2X251bShjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29u
LAogCQkJICAgIHU2NCBwZXJzaXN0ZW50X2ZpZCwgdTY0IHZvbGF0aWxlX2ZpZCwKIAkJCSAgICBf
X2xlNjQgKnVuaXF1ZWlkKTsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMveGF0dHIuYyBiL2ZzL2NpZnMv
eGF0dHIuYwppbmRleCBiODI5OTE3M2VhN2UuLjkzMThhMmFjZjRlZSAxMDA2NDQKLS0tIGEvZnMv
Y2lmcy94YXR0ci5jCisrKyBiL2ZzL2NpZnMveGF0dHIuYwpAQCAtMzQsNiArMzQsNyBAQAogI2Rl
ZmluZSBNQVhfRUFfVkFMVUVfU0laRSBDSUZTTWF4QnVmU2l6ZQogI2RlZmluZSBDSUZTX1hBVFRS
X0NJRlNfQUNMICJzeXN0ZW0uY2lmc19hY2wiIC8qIERBQ0wgb25seSAqLwogI2RlZmluZSBDSUZT
X1hBVFRSX0NJRlNfTlRTRCAic3lzdGVtLmNpZnNfbnRzZCIgLyogb3duZXIgcGx1cyBEQUNMICov
CisjZGVmaW5lIENJRlNfWEFUVFJfQ0lGU19OVFNEX0ZVTEwgInN5c3RlbS5jaWZzX250c2RfZnVs
bCIgLyogb3duZXIvREFDTC9TQUNMICovCiAjZGVmaW5lIENJRlNfWEFUVFJfQVRUUklCICJjaWZz
LmRvc2F0dHJpYiIgIC8qIGZ1bGwgbmFtZTogdXNlci5jaWZzLmRvc2F0dHJpYiAqLwogI2RlZmlu
ZSBDSUZTX1hBVFRSX0NSRUFURVRJTUUgImNpZnMuY3JlYXRpb250aW1lIiAgLyogdXNlci5jaWZz
LmNyZWF0aW9udGltZSAqLwogLyoKQEAgLTQzLDEyICs0NCwxMyBAQAogICovCiAjZGVmaW5lIFNN
QjNfWEFUVFJfQ0lGU19BQ0wgInN5c3RlbS5zbWIzX2FjbCIgLyogREFDTCBvbmx5ICovCiAjZGVm
aW5lIFNNQjNfWEFUVFJfQ0lGU19OVFNEICJzeXN0ZW0uc21iM19udHNkIiAvKiBvd25lciBwbHVz
IERBQ0wgKi8KKyNkZWZpbmUgU01CM19YQVRUUl9DSUZTX05UU0RfRlVMTCAic3lzdGVtLnNtYjNf
bnRzZF9mdWxsIiAvKiBvd25lci9EQUNML1NBQ0wgKi8KICNkZWZpbmUgU01CM19YQVRUUl9BVFRS
SUIgInNtYjMuZG9zYXR0cmliIiAgLyogZnVsbCBuYW1lOiB1c2VyLnNtYjMuZG9zYXR0cmliICov
CiAjZGVmaW5lIFNNQjNfWEFUVFJfQ1JFQVRFVElNRSAic21iMy5jcmVhdGlvbnRpbWUiICAvKiB1
c2VyLnNtYjMuY3JlYXRpb250aW1lICovCiAvKiBCQiBuZWVkIHRvIGFkZCBzZXJ2ZXIgKFNhbWJh
IGUuZykgc3VwcG9ydCBmb3Igc2VjdXJpdHkgYW5kIHRydXN0ZWQgcHJlZml4ICovCiAKIGVudW0g
eyBYQVRUUl9VU0VSLCBYQVRUUl9DSUZTX0FDTCwgWEFUVFJfQUNMX0FDQ0VTUywgWEFUVFJfQUNM
X0RFRkFVTFQsCi0JWEFUVFJfQ0lGU19OVFNEIH07CisJWEFUVFJfQ0lGU19OVFNELCBYQVRUUl9D
SUZTX05UU0RfRlVMTCB9OwogCiBzdGF0aWMgaW50IGNpZnNfYXR0cmliX3NldCh1bnNpZ25lZCBp
bnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICpwVGNvbiwKIAkJCSAgIHN0cnVjdCBpbm9kZSAqaW5v
ZGUsIGNoYXIgKmZ1bGxfcGF0aCwKQEAgLTE2NCw3ICsxNjYsOCBAQCBzdGF0aWMgaW50IGNpZnNf
eGF0dHJfc2V0KGNvbnN0IHN0cnVjdCB4YXR0cl9oYW5kbGVyICpoYW5kbGVyLAogCQlicmVhazsK
IAogCWNhc2UgWEFUVFJfQ0lGU19BQ0w6Ci0JY2FzZSBYQVRUUl9DSUZTX05UU0Q6IHsKKwljYXNl
IFhBVFRSX0NJRlNfTlRTRDoKKwljYXNlIFhBVFRSX0NJRlNfTlRTRF9GVUxMOiB7CiAJCXN0cnVj
dCBjaWZzX250c2QgKnBhY2w7CiAKIAkJaWYgKCF2YWx1ZSkKQEAgLTE3NCwyMyArMTc3LDI3IEBA
IHN0YXRpYyBpbnQgY2lmc194YXR0cl9zZXQoY29uc3Qgc3RydWN0IHhhdHRyX2hhbmRsZXIgKmhh
bmRsZXIsCiAJCQlyYyA9IC1FTk9NRU07CiAJCX0gZWxzZSB7CiAJCQltZW1jcHkocGFjbCwgdmFs
dWUsIHNpemUpOwotCQkJaWYgKHZhbHVlICYmCi0JCQkgICAgcFRjb24tPnNlcy0+c2VydmVyLT5v
cHMtPnNldF9hY2wpIHsKKwkJCWlmIChwVGNvbi0+c2VzLT5zZXJ2ZXItPm9wcy0+c2V0X2FjbCkg
eworCQkJCWludCBhY2xmbGFncyA9IDA7CiAJCQkJcmMgPSAwOwotCQkJCWlmIChoYW5kbGVyLT5m
bGFncyA9PSBYQVRUUl9DSUZTX05UU0QpIHsKLQkJCQkJLyogc2V0IG93bmVyIGFuZCBEQUNMICov
Ci0JCQkJCXJjID0gcFRjb24tPnNlcy0+c2VydmVyLT5vcHMtPnNldF9hY2woCi0JCQkJCQkJcGFj
bCwgc2l6ZSwgaW5vZGUsCi0JCQkJCQkJZnVsbF9wYXRoLAotCQkJCQkJCUNJRlNfQUNMX09XTkVS
KTsKLQkJCQl9Ci0JCQkJaWYgKHJjID09IDApIHsKLQkJCQkJLyogc2V0IERBQ0wgKi8KLQkJCQkJ
cmMgPSBwVGNvbi0+c2VzLT5zZXJ2ZXItPm9wcy0+c2V0X2FjbCgKLQkJCQkJCQlwYWNsLCBzaXpl
LCBpbm9kZSwKLQkJCQkJCQlmdWxsX3BhdGgsCi0JCQkJCQkJQ0lGU19BQ0xfREFDTCk7CisKKwkJ
CQlzd2l0Y2ggKGhhbmRsZXItPmZsYWdzKSB7CisJCQkJY2FzZSBYQVRUUl9DSUZTX05UU0RfRlVM
TDoKKwkJCQkJYWNsZmxhZ3MgPSAoQ0lGU19BQ0xfT1dORVIgfAorCQkJCQkJICAgIENJRlNfQUNM
X0RBQ0wgfAorCQkJCQkJICAgIENJRlNfQUNMX1NBQ0wpOworCQkJCQlicmVhazsKKwkJCQljYXNl
IFhBVFRSX0NJRlNfTlRTRDoKKwkJCQkJYWNsZmxhZ3MgPSAoQ0lGU19BQ0xfT1dORVIgfAorCQkJ
CQkJICAgIENJRlNfQUNMX0RBQ0wpOworCQkJCQlicmVhazsKKwkJCQljYXNlIFhBVFRSX0NJRlNf
QUNMOgorCQkJCWRlZmF1bHQ6CisJCQkJCWFjbGZsYWdzID0gQ0lGU19BQ0xfREFDTDsKIAkJCQl9
CisKKwkJCQlyYyA9IHBUY29uLT5zZXMtPnNlcnZlci0+b3BzLT5zZXRfYWNsKHBhY2wsCisJCQkJ
CXNpemUsIGlub2RlLCBmdWxsX3BhdGgsIGFjbGZsYWdzKTsKIAkJCX0gZWxzZSB7CiAJCQkJcmMg
PSAtRU9QTk9UU1VQUDsKIAkJCX0KQEAgLTMyNywxNiArMzM0LDI3IEBAIHN0YXRpYyBpbnQgY2lm
c194YXR0cl9nZXQoY29uc3Qgc3RydWN0IHhhdHRyX2hhbmRsZXIgKmhhbmRsZXIsCiAJCWJyZWFr
OwogCiAJY2FzZSBYQVRUUl9DSUZTX0FDTDoKLQljYXNlIFhBVFRSX0NJRlNfTlRTRDogewotCQkv
KiB0aGUgd2hvbGUgbnRzZCBpcyBmZXRjaGVkIHJlZ2FyZGxlc3MgKi8KLQkJdTMyIGFjbGxlbjsK
KwljYXNlIFhBVFRSX0NJRlNfTlRTRDoKKwljYXNlIFhBVFRSX0NJRlNfTlRTRF9GVUxMOiB7CisJ
CS8qCisJCSAqIGZldGNoIG93bmVyLCBEQUNMLCBhbmQgU0FDTCBpZiBhc2tlZCBmb3IgZnVsbCBk
ZXNjcmlwdG9yLAorCQkgKiBmZXRjaCBvd25lciBhbmQgREFDTCBvdGhlcndpc2UKKwkJICovCisJ
CXUzMiBhY2xsZW4sIGFkZGl0aW9uYWxfaW5mbyA9IDA7CiAJCXN0cnVjdCBjaWZzX250c2QgKnBh
Y2w7CiAKIAkJaWYgKHBUY29uLT5zZXMtPnNlcnZlci0+b3BzLT5nZXRfYWNsID09IE5VTEwpCiAJ
CQlnb3RvIG91dDsgLyogcmMgYWxyZWFkeSBFT1BOT1RTVVBQICovCiAKKwkJaWYgKGhhbmRsZXIt
PmZsYWdzID09IFhBVFRSX0NJRlNfTlRTRF9GVUxMKSB7CisJCQlhZGRpdGlvbmFsX2luZm8gPSBP
V05FUl9TRUNJTkZPIHwgR1JPVVBfU0VDSU5GTyB8CisJCQkJREFDTF9TRUNJTkZPIHwgU0FDTF9T
RUNJTkZPOworCQl9IGVsc2UgeworCQkJYWRkaXRpb25hbF9pbmZvID0gT1dORVJfU0VDSU5GTyB8
IEdST1VQX1NFQ0lORk8gfAorCQkJCURBQ0xfU0VDSU5GTzsKKwkJfQogCQlwYWNsID0gcFRjb24t
PnNlcy0+c2VydmVyLT5vcHMtPmdldF9hY2woY2lmc19zYiwKLQkJCQlpbm9kZSwgZnVsbF9wYXRo
LCAmYWNsbGVuKTsKKwkJCQlpbm9kZSwgZnVsbF9wYXRoLCAmYWNsbGVuLCBhZGRpdGlvbmFsX2lu
Zm8pOwogCQlpZiAoSVNfRVJSKHBhY2wpKSB7CiAJCQlyYyA9IFBUUl9FUlIocGFjbCk7CiAJCQlj
aWZzX2RiZyhWRlMsICIlczogZXJyb3IgJXpkIGdldHRpbmcgc2VjIGRlc2NcbiIsCkBAIC00ODYs
NiArNTA0LDI3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgeGF0dHJfaGFuZGxlciBzbWIzX250c2Rf
eGF0dHJfaGFuZGxlciA9IHsKIAkuc2V0ID0gY2lmc194YXR0cl9zZXQsCiB9OwogCitzdGF0aWMg
Y29uc3Qgc3RydWN0IHhhdHRyX2hhbmRsZXIgY2lmc19jaWZzX250c2RfZnVsbF94YXR0cl9oYW5k
bGVyID0geworCS5uYW1lID0gQ0lGU19YQVRUUl9DSUZTX05UU0RfRlVMTCwKKwkuZmxhZ3MgPSBY
QVRUUl9DSUZTX05UU0RfRlVMTCwKKwkuZ2V0ID0gY2lmc194YXR0cl9nZXQsCisJLnNldCA9IGNp
ZnNfeGF0dHJfc2V0LAorfTsKKworLyoKKyAqIEFsdGhvdWdoIHRoaXMgaXMganVzdCBhbiBhbGlh
cyBmb3IgdGhlIGFib3ZlLCBuZWVkIHRvIG1vdmUgYXdheSBmcm9tCisgKiBjb25mdXNpbmcgdXNl
cnMgYW5kIHVzaW5nIHRoZSAyMCB5ZWFyIG9sZCB0ZXJtICdjaWZzJyB3aGVuIGl0IGlzIG5vCisg
KiBsb25nZXIgc2VjdXJlIGFuZCB3YXMgcmVwbGFjZWQgYnkgU01CMi9TTUIzIGEgbG9uZyB0aW1l
IGFnbywgYW5kCisgKiBTTUIzIGFuZCBsYXRlciBhcmUgaGlnaGx5IHNlY3VyZS4KKyAqLworc3Rh
dGljIGNvbnN0IHN0cnVjdCB4YXR0cl9oYW5kbGVyIHNtYjNfbnRzZF9mdWxsX3hhdHRyX2hhbmRs
ZXIgPSB7CisJLm5hbWUgPSBTTUIzX1hBVFRSX0NJRlNfTlRTRF9GVUxMLAorCS5mbGFncyA9IFhB
VFRSX0NJRlNfTlRTRF9GVUxMLAorCS5nZXQgPSBjaWZzX3hhdHRyX2dldCwKKwkuc2V0ID0gY2lm
c194YXR0cl9zZXQsCit9OworCisKIHN0YXRpYyBjb25zdCBzdHJ1Y3QgeGF0dHJfaGFuZGxlciBj
aWZzX3Bvc2l4X2FjbF9hY2Nlc3NfeGF0dHJfaGFuZGxlciA9IHsKIAkubmFtZSA9IFhBVFRSX05B
TUVfUE9TSVhfQUNMX0FDQ0VTUywKIAkuZmxhZ3MgPSBYQVRUUl9BQ0xfQUNDRVNTLApAQCAtNTA3
LDYgKzU0Niw4IEBAIGNvbnN0IHN0cnVjdCB4YXR0cl9oYW5kbGVyICpjaWZzX3hhdHRyX2hhbmRs
ZXJzW10gPSB7CiAJJnNtYjNfYWNsX3hhdHRyX2hhbmRsZXIsIC8qIGFsaWFzIGZvciBhYm92ZSBz
aW5jZSBhdm9pZGluZyAiY2lmcyIgKi8KIAkmY2lmc19jaWZzX250c2RfeGF0dHJfaGFuZGxlciwK
IAkmc21iM19udHNkX3hhdHRyX2hhbmRsZXIsIC8qIGFsaWFzIGZvciBhYm92ZSBzaW5jZSBhdm9p
ZGluZyAiY2lmcyIgKi8KKwkmY2lmc19jaWZzX250c2RfZnVsbF94YXR0cl9oYW5kbGVyLAorCSZz
bWIzX250c2RfZnVsbF94YXR0cl9oYW5kbGVyLCAvKiBhbGlhcyBmb3IgYWJvdmUgc2luY2UgYXZv
aWRpbmcgImNpZnMiICovCiAJJmNpZnNfcG9zaXhfYWNsX2FjY2Vzc194YXR0cl9oYW5kbGVyLAog
CSZjaWZzX3Bvc2l4X2FjbF9kZWZhdWx0X3hhdHRyX2hhbmRsZXIsCiAJTlVMTAotLSAKMi4yNy4w
Cgo=
--000000000000c7a2a805b6c23712
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-Add-SMB-2-support-for-getting-and-setting-SACLs.patch"
Content-Disposition: attachment; 
	filename="0002-Add-SMB-2-support-for-getting-and-setting-SACLs.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kiuo9ru81>
X-Attachment-Id: f_kiuo9ru81

RnJvbSBlMWUzZTM1YWU1ODRjNDQxNjA2YWUxYzMwNWRkMzc3YTg0YjdiNTFmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCb3JpcyBQcm90b3BvcG92IDxwYm9yaXNAYW1hem9uLmNvbT4K
RGF0ZTogVGh1LCAxNyBEZWMgMjAyMCAyMDo1ODowOCArMDAwMApTdWJqZWN0OiBbUEFUQ0ggMi8y
XSBBZGQgU01CIDIgc3VwcG9ydCBmb3IgZ2V0dGluZyBhbmQgc2V0dGluZyBTQUNMcwoKRml4IHBh
c3Npbmcgb2YgdGhlIGFkZGl0aW9uYWwgc2VjdXJpdHkgaW5mbyB2aWEgdmVyc2lvbgpvcGVyYXRp
b25zLiBGb3JjZSBuZXcgb3BlbiB3aGVuIGdldHRpbmcgU0FDTCBhbmQgYXZvaWQKcmV1c2Ugb2Yg
ZmlsZXMgdGhhdCB3ZXJlIHByZXZpb3VzbHkgb3BlbiB3aXRob3V0CnN1ZmZpY2llbnQgcHJpdmls
ZWdlcyB0byBhY2Nlc3MgU0FDTHMuCgpTaWduZWQtb2ZmLWJ5OiBCb3JpcyBQcm90b3BvcG92IDxw
Ym9yaXNAYW1hem9uLmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBt
aWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY2lmc2FjbC5jIHwgMTAgKysrKystLS0tLQogZnMv
Y2lmcy9zbWIyb3BzLmMgfCAgNCArKy0tCiBmcy9jaWZzL3NtYjJwZHUuYyB8ICA0ICsrKy0KIGZz
L2NpZnMveGF0dHIuYyAgIHwgMTAgKysrKy0tLS0tLQogNCBmaWxlcyBjaGFuZ2VkLCAxNCBpbnNl
cnRpb25zKCspLCAxNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJvcHMu
YyBiL2ZzL2NpZnMvc21iMm9wcy5jCmluZGV4IDRhMTc2MTEzOWUwMC4uZjE5Mjc0ODU3MjkyIDEw
MDY0NAotLS0gYS9mcy9jaWZzL3NtYjJvcHMuYworKysgYi9mcy9jaWZzL3NtYjJvcHMuYwpAQCAt
MzM2OSw5ICszMzY5LDkgQEAgZ2V0X3NtYjJfYWNsKHN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNf
c2IsCiAJc3RydWN0IGNpZnNfbnRzZCAqcG50c2QgPSBOVUxMOwogCXN0cnVjdCBjaWZzRmlsZUlu
Zm8gKm9wZW5fZmlsZSA9IE5VTEw7CiAKLQlpZiAoaW5vZGUpCisJaWYgKGlub2RlICYmICEoaW5m
byAmIFNBQ0xfU0VDSU5GTykpCiAJCW9wZW5fZmlsZSA9IGZpbmRfcmVhZGFibGVfZmlsZShDSUZT
X0koaW5vZGUpLCB0cnVlKTsKLQlpZiAoIW9wZW5fZmlsZSkKKwlpZiAoIW9wZW5fZmlsZSB8fCAo
aW5mbyAmIFNBQ0xfU0VDSU5GTykpCiAJCXJldHVybiBnZXRfc21iMl9hY2xfYnlfcGF0aChjaWZz
X3NiLCBwYXRoLCBwYWNsbGVuLCBpbmZvKTsKIAogCXBudHNkID0gZ2V0X3NtYjJfYWNsX2J5X2Zp
ZChjaWZzX3NiLCAmb3Blbl9maWxlLT5maWQsIHBhY2xsZW4sIGluZm8pOwpkaWZmIC0tZ2l0IGEv
ZnMvY2lmcy9zbWIycGR1LmMgYi9mcy9jaWZzL3NtYjJwZHUuYwppbmRleCAyMDJkODc0MmQxNDku
LjA2N2ViNDRjN2JhYSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycGR1LmMKKysrIGIvZnMvY2lm
cy9zbWIycGR1LmMKQEAgLTM0ODAsOCArMzQ4MCwxMCBAQCBTTUIzMTFfcG9zaXhfcXVlcnlfaW5m
byhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogaW50CiBT
TUIyX3F1ZXJ5X2FjbChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0
Y29uLAogCSAgICAgICB1NjQgcGVyc2lzdGVudF9maWQsIHU2NCB2b2xhdGlsZV9maWQsCi0JICAg
ICAgIHZvaWQgKipkYXRhLCB1MzIgKnBsZW4sIHUzMiBhZGRpdGlvbmFsX2luZm8pCisJICAgICAg
IHZvaWQgKipkYXRhLCB1MzIgKnBsZW4sIHUzMiBleHRyYV9pbmZvKQogeworCV9fdTMyIGFkZGl0
aW9uYWxfaW5mbyA9IE9XTkVSX1NFQ0lORk8gfCBHUk9VUF9TRUNJTkZPIHwgREFDTF9TRUNJTkZP
IHwKKwkJCQlleHRyYV9pbmZvOwogCSpwbGVuID0gMDsKIAogCXJldHVybiBxdWVyeV9pbmZvKHhp
ZCwgdGNvbiwgcGVyc2lzdGVudF9maWQsIHZvbGF0aWxlX2ZpZCwKZGlmZiAtLWdpdCBhL2ZzL2Np
ZnMveGF0dHIuYyBiL2ZzL2NpZnMveGF0dHIuYwppbmRleCA5MzE4YTJhY2Y0ZWUuLjZiNjU4YTEx
NzJlZiAxMDA2NDQKLS0tIGEvZnMvY2lmcy94YXR0ci5jCisrKyBiL2ZzL2NpZnMveGF0dHIuYwpA
QCAtMzQwLDIxICszNDAsMTkgQEAgc3RhdGljIGludCBjaWZzX3hhdHRyX2dldChjb25zdCBzdHJ1
Y3QgeGF0dHJfaGFuZGxlciAqaGFuZGxlciwKIAkJICogZmV0Y2ggb3duZXIsIERBQ0wsIGFuZCBT
QUNMIGlmIGFza2VkIGZvciBmdWxsIGRlc2NyaXB0b3IsCiAJCSAqIGZldGNoIG93bmVyIGFuZCBE
QUNMIG90aGVyd2lzZQogCQkgKi8KLQkJdTMyIGFjbGxlbiwgYWRkaXRpb25hbF9pbmZvID0gMDsK
KwkJdTMyIGFjbGxlbiwgZXh0cmFfaW5mbzsKIAkJc3RydWN0IGNpZnNfbnRzZCAqcGFjbDsKIAog
CQlpZiAocFRjb24tPnNlcy0+c2VydmVyLT5vcHMtPmdldF9hY2wgPT0gTlVMTCkKIAkJCWdvdG8g
b3V0OyAvKiByYyBhbHJlYWR5IEVPUE5PVFNVUFAgKi8KIAogCQlpZiAoaGFuZGxlci0+ZmxhZ3Mg
PT0gWEFUVFJfQ0lGU19OVFNEX0ZVTEwpIHsKLQkJCWFkZGl0aW9uYWxfaW5mbyA9IE9XTkVSX1NF
Q0lORk8gfCBHUk9VUF9TRUNJTkZPIHwKLQkJCQlEQUNMX1NFQ0lORk8gfCBTQUNMX1NFQ0lORk87
CisJCQlleHRyYV9pbmZvID0gU0FDTF9TRUNJTkZPOwogCQl9IGVsc2UgewotCQkJYWRkaXRpb25h
bF9pbmZvID0gT1dORVJfU0VDSU5GTyB8IEdST1VQX1NFQ0lORk8gfAotCQkJCURBQ0xfU0VDSU5G
TzsKKwkJCWV4dHJhX2luZm8gPSAwOwogCQl9CiAJCXBhY2wgPSBwVGNvbi0+c2VzLT5zZXJ2ZXIt
Pm9wcy0+Z2V0X2FjbChjaWZzX3NiLAotCQkJCWlub2RlLCBmdWxsX3BhdGgsICZhY2xsZW4sIGFk
ZGl0aW9uYWxfaW5mbyk7CisJCQkJaW5vZGUsIGZ1bGxfcGF0aCwgJmFjbGxlbiwgZXh0cmFfaW5m
byk7CiAJCWlmIChJU19FUlIocGFjbCkpIHsKIAkJCXJjID0gUFRSX0VSUihwYWNsKTsKIAkJCWNp
ZnNfZGJnKFZGUywgIiVzOiBlcnJvciAlemQgZ2V0dGluZyBzZWMgZGVzY1xuIiwKLS0gCjIuMjcu
MAoK
--000000000000c7a2a805b6c23712--
