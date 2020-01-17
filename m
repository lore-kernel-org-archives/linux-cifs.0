Return-Path: <SRS0=TaZu=3G=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53CFFC33CAF
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jan 2020 02:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDA852064C
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jan 2020 02:25:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P5u9vqiq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388565AbgAQCZT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Jan 2020 21:25:19 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:33466 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730284AbgAQCZT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Jan 2020 21:25:19 -0500
Received: by mail-io1-f67.google.com with SMTP id z8so24312489ioh.0;
        Thu, 16 Jan 2020 18:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1aG+Zq8Z/5/vLaonWtDgCF09ewKx5tAm60B66Be5FPg=;
        b=P5u9vqiqLG1zsnti7aCFWCautfTh3Zm/2kcW92LzAtM4NGzk12LfLCnOG5kXI5JQAh
         4zT+6sTZF3QAk+YlvrbkqfUB5r9ZsGAPYq8o+XuASS5DJJCI3sqlfuUqQI0LNvjivZMc
         AwEEPwPfFZ4tmwiQp6Gti03wvvG85+pG0365PgfIwESYg3p8KMTjgb5hVNTzZMEIJnFY
         BoO40k1HoqUm5fnVFGyyMv2uuhWcpNJOL8pb5e0WJOexD+pN8otUKM353X8CK4JX+372
         qCuF/SoUrUGsnSUFxZjjRREtYwXVBOLZ3Mh7M4/l8/f2AxVsNRuqrLq+rljFwocabfL/
         UZgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1aG+Zq8Z/5/vLaonWtDgCF09ewKx5tAm60B66Be5FPg=;
        b=nE3l0QQtN9+yLArhHsYZlG+FZCoGoWez91dduYrxkkGAb1dSAD5OVRYb71KC+vSb+c
         l9NxZFIQI2rWMV5QWbdb3WpScPdAlLzpif8lNZEdz64kl63Rh01HLdwdxJSS80iEWW4m
         NMFOw4X81DFULTh0sLW0sdLvF/JSjAlkC/9w87z4njqA0eAdIf54mMSBz0TgXa6pRhdg
         yZz+PrxYwUD6LjUd2P4jLPg1mfwcn78qwIu3ZV17kbytHXmaK01W9rOKN6wb5TtI6+eK
         VaI0EAOi0bjn5wjhgUds/0zbZSO3AnY6NyWbfAYcJNPmd/NSDxBYXnEOcYitTaABGjMP
         mojg==
X-Gm-Message-State: APjAAAWZSL7wYiiYQsna+9VKOp87pQI3jagN/+m3K9oTnKRi/kOUzk9/
        PVejb6d+3ynuT3edIyHekJc/4k9TZWtoZmrWgUk=
X-Google-Smtp-Source: APXvYqy9Jz1ItLcWlR20Wv8trbIhRGLOfd2syRA6Zz42YUGHSAT0R/XGGTMkA8YadKBVR1JuftIooJX1vq+CJdbidwc=
X-Received: by 2002:a02:2446:: with SMTP id q6mr30465004jae.78.1579227917969;
 Thu, 16 Jan 2020 18:25:17 -0800 (PST)
MIME-Version: 1.0
References: <20191219165250.2875-1-bprotopopov@hotmail.com>
In-Reply-To: <20191219165250.2875-1-bprotopopov@hotmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 16 Jan 2020 20:25:04 -0600
Message-ID: <CAH2r5muGF51LgNe3hgGrdA-D5YivGDXQ_hZUKzaVn1V9EX2XBg@mail.gmail.com>
Subject: Re: [PATCH] Add support for setting owner info, dos attributes, and
 create time
To:     Boris Protopopov <boris.v.protopopov@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, sblbir@amazon.com,
        Boris Protopopov <bprotopopov@hotmail.com>,
        Steve French <sfrench@samba.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000001226ea059c4ca73d"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000001226ea059c4ca73d
Content-Type: text/plain; charset="UTF-8"

updated patch to fix minor endian errors and remerged into cifs-2.6.git for-next


On Thu, Dec 19, 2019 at 10:53 AM Boris Protopopov
<boris.v.protopopov@gmail.com> wrote:
>
> Add extended attribute "system.cifs_ntsd" (and alias "system.smb3_ntsd")
> to allow for setting owner and DACL in the security descriptor. This is in
> addition to the existing "system.cifs_acl" and "system.smb3_acl" attributes
> that allow for setting DACL only. Add support for setting creation time and
> dos attributes using set_file_info() calls to complement the existing
> support for getting these attributes via query_path_info() calls.
>
> Signed-off-by: Boris Protopopov <bprotopopov@hotmail.com>
> ---
>  fs/cifs/xattr.c | 128 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 117 insertions(+), 11 deletions(-)
>
> diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
> index 9076150758d8..c41856e6fa22 100644
> --- a/fs/cifs/xattr.c
> +++ b/fs/cifs/xattr.c
> @@ -32,7 +32,8 @@
>  #include "cifs_unicode.h"
>
>  #define MAX_EA_VALUE_SIZE CIFSMaxBufSize
> -#define CIFS_XATTR_CIFS_ACL "system.cifs_acl"
> +#define CIFS_XATTR_CIFS_ACL "system.cifs_acl" /* DACL only */
> +#define CIFS_XATTR_CIFS_NTSD "system.cifs_ntsd" /* owner plus DACL */
>  #define CIFS_XATTR_ATTRIB "cifs.dosattrib"  /* full name: user.cifs.dosattrib */
>  #define CIFS_XATTR_CREATETIME "cifs.creationtime"  /* user.cifs.creationtime */
>  /*
> @@ -40,12 +41,62 @@
>   * confusing users and using the 20+ year old term 'cifs' when it is no longer
>   * secure, replaced by SMB2 (then even more highly secure SMB3) many years ago
>   */
> -#define SMB3_XATTR_CIFS_ACL "system.smb3_acl"
> +#define SMB3_XATTR_CIFS_ACL "system.smb3_acl" /* DACL only */
> +#define SMB3_XATTR_CIFS_NTSD "system.smb3_ntsd" /* owner plus DACL */
>  #define SMB3_XATTR_ATTRIB "smb3.dosattrib"  /* full name: user.smb3.dosattrib */
>  #define SMB3_XATTR_CREATETIME "smb3.creationtime"  /* user.smb3.creationtime */
>  /* BB need to add server (Samba e.g) support for security and trusted prefix */
>
> -enum { XATTR_USER, XATTR_CIFS_ACL, XATTR_ACL_ACCESS, XATTR_ACL_DEFAULT };
> +enum { XATTR_USER, XATTR_CIFS_ACL, XATTR_ACL_ACCESS, XATTR_ACL_DEFAULT,
> +       XATTR_CIFS_NTSD };
> +
> +static int cifs_attrib_set(unsigned int xid, struct cifs_tcon *pTcon,
> +                          struct inode *inode, char *full_path,
> +                          const void *value, size_t size)
> +{
> +       ssize_t rc = -EOPNOTSUPP;
> +       __u32 *pattrib = (__u32 *)value;
> +       __u32 attrib;
> +       FILE_BASIC_INFO info_buf;
> +
> +       if ((value == NULL) || (size != sizeof(__u32)))
> +               return -ERANGE;
> +
> +       memset(&info_buf, 0, sizeof(info_buf));
> +       info_buf.Attributes = attrib = cpu_to_le32(*pattrib);
> +
> +       if (pTcon->ses->server->ops->set_file_info)
> +               rc = pTcon->ses->server->ops->set_file_info(inode, full_path,
> +                               &info_buf, xid);
> +       if (rc == 0)
> +               CIFS_I(inode)->cifsAttrs = attrib;
> +
> +       return rc;
> +}
> +
> +static int cifs_creation_time_set(unsigned int xid, struct cifs_tcon *pTcon,
> +                                 struct inode *inode, char *full_path,
> +                                 const void *value, size_t size)
> +{
> +       ssize_t rc = -EOPNOTSUPP;
> +       __u64 *pcreation_time = (__u64 *)value;
> +       __u64 creation_time;
> +       FILE_BASIC_INFO info_buf;
> +
> +       if ((value == NULL) || (size != sizeof(__u64)))
> +               return -ERANGE;
> +
> +       memset(&info_buf, 0, sizeof(info_buf));
> +       info_buf.CreationTime = creation_time = cpu_to_le64(*pcreation_time);
> +
> +       if (pTcon->ses->server->ops->set_file_info)
> +               rc = pTcon->ses->server->ops->set_file_info(inode, full_path,
> +                               &info_buf, xid);
> +       if (rc == 0)
> +               CIFS_I(inode)->createtime = creation_time;
> +
> +       return rc;
> +}
>
>  static int cifs_xattr_set(const struct xattr_handler *handler,
>                           struct dentry *dentry, struct inode *inode,
> @@ -86,6 +137,23 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
>
>         switch (handler->flags) {
>         case XATTR_USER:
> +               cifs_dbg(FYI, "%s:setting user xattr %s\n", __func__, name);
> +               if ((strcmp(name, CIFS_XATTR_ATTRIB) == 0) ||
> +                   (strcmp(name, SMB3_XATTR_ATTRIB) == 0)) {
> +                       rc = cifs_attrib_set(xid, pTcon, inode, full_path,
> +                                       value, size);
> +                       if (rc == 0) /* force revalidate of the inode */
> +                               CIFS_I(inode)->time = 0;
> +                       break;
> +               } else if ((strcmp(name, CIFS_XATTR_CREATETIME) == 0) ||
> +                          (strcmp(name, SMB3_XATTR_CREATETIME) == 0)) {
> +                       rc = cifs_creation_time_set(xid, pTcon, inode,
> +                                       full_path, value, size);
> +                       if (rc == 0) /* force revalidate of the inode */
> +                               CIFS_I(inode)->time = 0;
> +                       break;
> +               }
> +
>                 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
>                         goto out;
>
> @@ -95,7 +163,8 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
>                                 cifs_sb->local_nls, cifs_sb);
>                 break;
>
> -       case XATTR_CIFS_ACL: {
> +       case XATTR_CIFS_ACL:
> +       case XATTR_CIFS_NTSD: {
>                 struct cifs_ntsd *pacl;
>
>                 if (!value)
> @@ -106,12 +175,25 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
>                 } else {
>                         memcpy(pacl, value, size);
>                         if (value &&
> -                           pTcon->ses->server->ops->set_acl)
> -                               rc = pTcon->ses->server->ops->set_acl(pacl,
> -                                               size, inode,
> -                                               full_path, CIFS_ACL_DACL);
> -                       else
> +                           pTcon->ses->server->ops->set_acl) {
> +                               rc = 0;
> +                               if (handler->flags == XATTR_CIFS_NTSD) {
> +                                       /* set owner and DACL */
> +                                       rc = pTcon->ses->server->ops->set_acl(
> +                                                       pacl, size, inode,
> +                                                       full_path,
> +                                                       CIFS_ACL_OWNER);
> +                               }
> +                               if (rc == 0) {
> +                                       /* set DACL */
> +                                       rc = pTcon->ses->server->ops->set_acl(
> +                                                       pacl, size, inode,
> +                                                       full_path,
> +                                                       CIFS_ACL_DACL);
> +                               }
> +                       } else {
>                                 rc = -EOPNOTSUPP;
> +                       }
>                         if (rc == 0) /* force revalidate of the inode */
>                                 CIFS_I(inode)->time = 0;
>                         kfree(pacl);
> @@ -179,7 +261,7 @@ static int cifs_creation_time_get(struct dentry *dentry, struct inode *inode,
>                                   void *value, size_t size)
>  {
>         ssize_t rc;
> -       __u64 * pcreatetime;
> +       __u64 *pcreatetime;
>
>         rc = cifs_revalidate_dentry_attr(dentry);
>         if (rc)
> @@ -244,7 +326,9 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
>                                 full_path, name, value, size, cifs_sb);
>                 break;
>
> -       case XATTR_CIFS_ACL: {
> +       case XATTR_CIFS_ACL:
> +       case XATTR_CIFS_NTSD: {
> +               /* the whole ntsd is fetched regardless */
>                 u32 acllen;
>                 struct cifs_ntsd *pacl;
>
> @@ -382,6 +466,26 @@ static const struct xattr_handler smb3_acl_xattr_handler = {
>         .set = cifs_xattr_set,
>  };
>
> +static const struct xattr_handler cifs_cifs_ntsd_xattr_handler = {
> +       .name = CIFS_XATTR_CIFS_NTSD,
> +       .flags = XATTR_CIFS_NTSD,
> +       .get = cifs_xattr_get,
> +       .set = cifs_xattr_set,
> +};
> +
> +/*
> + * Although this is just an alias for the above, need to move away from
> + * confusing users and using the 20 year old term 'cifs' when it is no
> + * longer secure and was replaced by SMB2/SMB3 a long time ago, and
> + * SMB3 and later are highly secure.
> + */
> +static const struct xattr_handler smb3_ntsd_xattr_handler = {
> +       .name = SMB3_XATTR_CIFS_NTSD,
> +       .flags = XATTR_CIFS_NTSD,
> +       .get = cifs_xattr_get,
> +       .set = cifs_xattr_set,
> +};
> +
>  static const struct xattr_handler cifs_posix_acl_access_xattr_handler = {
>         .name = XATTR_NAME_POSIX_ACL_ACCESS,
>         .flags = XATTR_ACL_ACCESS,
> @@ -401,6 +505,8 @@ const struct xattr_handler *cifs_xattr_handlers[] = {
>         &cifs_os2_xattr_handler,
>         &cifs_cifs_acl_xattr_handler,
>         &smb3_acl_xattr_handler, /* alias for above since avoiding "cifs" */
> +       &cifs_cifs_ntsd_xattr_handler,
> +       &smb3_ntsd_xattr_handler, /* alias for above since avoiding "cifs" */
>         &cifs_posix_acl_access_xattr_handler,
>         &cifs_posix_acl_default_xattr_handler,
>         NULL
> --
> 2.14.5
>


-- 
Thanks,

Steve

--0000000000001226ea059c4ca73d
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-CIFS-Add-support-for-setting-owner-info-dos-attribut.patch"
Content-Disposition: attachment; 
	filename="0001-CIFS-Add-support-for-setting-owner-info-dos-attribut.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k5hjin5k0>
X-Attachment-Id: f_k5hjin5k0

RnJvbSBmZjRkZGRjZjUwZDIwNjM3M2IyOTE0Y2Y3MmY0NTlhNzAwMzBhYjkyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCb3JpcyBQcm90b3BvcG92IDxicHJvdG9wb3BvdkBob3RtYWls
LmNvbT4KRGF0ZTogVGh1LCAxOSBEZWMgMjAxOSAxNjo1Mjo1MCArMDAwMApTdWJqZWN0OiBbUEFU
Q0ggMS8zXSBDSUZTOiBBZGQgc3VwcG9ydCBmb3Igc2V0dGluZyBvd25lciBpbmZvLCBkb3MgYXR0
cmlidXRlcywKIGFuZCBjcmVhdGUgdGltZQoKVGhpcyBpcyBuZWVkZWQgZm9yIGJhY2t1cC9yZXN0
b3JlIHNjZW5hcmlvcyBhbW9uZyBvdGhlcnMuCgpBZGQgZXh0ZW5kZWQgYXR0cmlidXRlICJzeXN0
ZW0uY2lmc19udHNkIiAoYW5kIGFsaWFzICJzeXN0ZW0uc21iM19udHNkIikKdG8gYWxsb3cgZm9y
IHNldHRpbmcgb3duZXIgYW5kIERBQ0wgaW4gdGhlIHNlY3VyaXR5IGRlc2NyaXB0b3IuIFRoaXMg
aXMgaW4KYWRkaXRpb24gdG8gdGhlIGV4aXN0aW5nICJzeXN0ZW0uY2lmc19hY2wiIGFuZCAic3lz
dGVtLnNtYjNfYWNsIiBhdHRyaWJ1dGVzCnRoYXQgYWxsb3cgZm9yIHNldHRpbmcgREFDTCBvbmx5
LiBBZGQgc3VwcG9ydCBmb3Igc2V0dGluZyBjcmVhdGlvbiB0aW1lIGFuZApkb3MgYXR0cmlidXRl
cyB1c2luZyBzZXRfZmlsZV9pbmZvKCkgY2FsbHMgdG8gY29tcGxlbWVudCB0aGUgZXhpc3RpbmcK
c3VwcG9ydCBmb3IgZ2V0dGluZyB0aGVzZSBhdHRyaWJ1dGVzIHZpYSBxdWVyeV9wYXRoX2luZm8o
KSBjYWxscy4KClNpZ25lZC1vZmYtYnk6IEJvcmlzIFByb3RvcG9wb3YgPGJwcm90b3BvcG92QGhv
dG1haWwuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29m
dC5jb20+Ci0tLQogZnMvY2lmcy94YXR0ci5jIHwgMTI4ICsrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKystLS0tLQogMSBmaWxlIGNoYW5nZWQsIDExNyBpbnNlcnRpb25z
KCspLCAxMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3hhdHRyLmMgYi9mcy9j
aWZzL3hhdHRyLmMKaW5kZXggZGI0YmE4ZjYwNzdlLi40MTQyYzk1OTlmNjggMTAwNjQ0Ci0tLSBh
L2ZzL2NpZnMveGF0dHIuYworKysgYi9mcy9jaWZzL3hhdHRyLmMKQEAgLTMyLDcgKzMyLDggQEAK
ICNpbmNsdWRlICJjaWZzX3VuaWNvZGUuaCIKIAogI2RlZmluZSBNQVhfRUFfVkFMVUVfU0laRSBD
SUZTTWF4QnVmU2l6ZQotI2RlZmluZSBDSUZTX1hBVFRSX0NJRlNfQUNMICJzeXN0ZW0uY2lmc19h
Y2wiCisjZGVmaW5lIENJRlNfWEFUVFJfQ0lGU19BQ0wgInN5c3RlbS5jaWZzX2FjbCIgLyogREFD
TCBvbmx5ICovCisjZGVmaW5lIENJRlNfWEFUVFJfQ0lGU19OVFNEICJzeXN0ZW0uY2lmc19udHNk
IiAvKiBvd25lciBwbHVzIERBQ0wgKi8KICNkZWZpbmUgQ0lGU19YQVRUUl9BVFRSSUIgImNpZnMu
ZG9zYXR0cmliIiAgLyogZnVsbCBuYW1lOiB1c2VyLmNpZnMuZG9zYXR0cmliICovCiAjZGVmaW5l
IENJRlNfWEFUVFJfQ1JFQVRFVElNRSAiY2lmcy5jcmVhdGlvbnRpbWUiICAvKiB1c2VyLmNpZnMu
Y3JlYXRpb250aW1lICovCiAvKgpAQCAtNDAsMTIgKzQxLDYyIEBACiAgKiBjb25mdXNpbmcgdXNl
cnMgYW5kIHVzaW5nIHRoZSAyMCsgeWVhciBvbGQgdGVybSAnY2lmcycgd2hlbiBpdCBpcyBubyBs
b25nZXIKICAqIHNlY3VyZSwgcmVwbGFjZWQgYnkgU01CMiAodGhlbiBldmVuIG1vcmUgaGlnaGx5
IHNlY3VyZSBTTUIzKSBtYW55IHllYXJzIGFnbwogICovCi0jZGVmaW5lIFNNQjNfWEFUVFJfQ0lG
U19BQ0wgInN5c3RlbS5zbWIzX2FjbCIKKyNkZWZpbmUgU01CM19YQVRUUl9DSUZTX0FDTCAic3lz
dGVtLnNtYjNfYWNsIiAvKiBEQUNMIG9ubHkgKi8KKyNkZWZpbmUgU01CM19YQVRUUl9DSUZTX05U
U0QgInN5c3RlbS5zbWIzX250c2QiIC8qIG93bmVyIHBsdXMgREFDTCAqLwogI2RlZmluZSBTTUIz
X1hBVFRSX0FUVFJJQiAic21iMy5kb3NhdHRyaWIiICAvKiBmdWxsIG5hbWU6IHVzZXIuc21iMy5k
b3NhdHRyaWIgKi8KICNkZWZpbmUgU01CM19YQVRUUl9DUkVBVEVUSU1FICJzbWIzLmNyZWF0aW9u
dGltZSIgIC8qIHVzZXIuc21iMy5jcmVhdGlvbnRpbWUgKi8KIC8qIEJCIG5lZWQgdG8gYWRkIHNl
cnZlciAoU2FtYmEgZS5nKSBzdXBwb3J0IGZvciBzZWN1cml0eSBhbmQgdHJ1c3RlZCBwcmVmaXgg
Ki8KIAotZW51bSB7IFhBVFRSX1VTRVIsIFhBVFRSX0NJRlNfQUNMLCBYQVRUUl9BQ0xfQUNDRVNT
LCBYQVRUUl9BQ0xfREVGQVVMVCB9OworZW51bSB7IFhBVFRSX1VTRVIsIFhBVFRSX0NJRlNfQUNM
LCBYQVRUUl9BQ0xfQUNDRVNTLCBYQVRUUl9BQ0xfREVGQVVMVCwKKwlYQVRUUl9DSUZTX05UU0Qg
fTsKKworc3RhdGljIGludCBjaWZzX2F0dHJpYl9zZXQodW5zaWduZWQgaW50IHhpZCwgc3RydWN0
IGNpZnNfdGNvbiAqcFRjb24sCisJCQkgICBzdHJ1Y3QgaW5vZGUgKmlub2RlLCBjaGFyICpmdWxs
X3BhdGgsCisJCQkgICBjb25zdCB2b2lkICp2YWx1ZSwgc2l6ZV90IHNpemUpCit7CisJc3NpemVf
dCByYyA9IC1FT1BOT1RTVVBQOworCV9fdTMyICpwYXR0cmliID0gKF9fdTMyICopdmFsdWU7CisJ
X191MzIgYXR0cmliOworCUZJTEVfQkFTSUNfSU5GTyBpbmZvX2J1ZjsKKworCWlmICgodmFsdWUg
PT0gTlVMTCkgfHwgKHNpemUgIT0gc2l6ZW9mKF9fdTMyKSkpCisJCXJldHVybiAtRVJBTkdFOwor
CisJbWVtc2V0KCZpbmZvX2J1ZiwgMCwgc2l6ZW9mKGluZm9fYnVmKSk7CisJYXR0cmliID0gKnBh
dHRyaWI7CisJaW5mb19idWYuQXR0cmlidXRlcyA9IGNwdV90b19sZTMyKGF0dHJpYik7CisJaWYg
KHBUY29uLT5zZXMtPnNlcnZlci0+b3BzLT5zZXRfZmlsZV9pbmZvKQorCQlyYyA9IHBUY29uLT5z
ZXMtPnNlcnZlci0+b3BzLT5zZXRfZmlsZV9pbmZvKGlub2RlLCBmdWxsX3BhdGgsCisJCQkJJmlu
Zm9fYnVmLCB4aWQpOworCWlmIChyYyA9PSAwKQorCQlDSUZTX0koaW5vZGUpLT5jaWZzQXR0cnMg
PSBhdHRyaWI7CisKKwlyZXR1cm4gcmM7Cit9CisKK3N0YXRpYyBpbnQgY2lmc19jcmVhdGlvbl90
aW1lX3NldCh1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICpwVGNvbiwKKwkJCQkg
IHN0cnVjdCBpbm9kZSAqaW5vZGUsIGNoYXIgKmZ1bGxfcGF0aCwKKwkJCQkgIGNvbnN0IHZvaWQg
KnZhbHVlLCBzaXplX3Qgc2l6ZSkKK3sKKwlzc2l6ZV90IHJjID0gLUVPUE5PVFNVUFA7CisJX191
NjQgKnBjcmVhdGlvbl90aW1lID0gKF9fdTY0ICopdmFsdWU7CisJX191NjQgY3JlYXRpb25fdGlt
ZTsKKwlGSUxFX0JBU0lDX0lORk8gaW5mb19idWY7CisKKwlpZiAoKHZhbHVlID09IE5VTEwpIHx8
IChzaXplICE9IHNpemVvZihfX3U2NCkpKQorCQlyZXR1cm4gLUVSQU5HRTsKKworCW1lbXNldCgm
aW5mb19idWYsIDAsIHNpemVvZihpbmZvX2J1ZikpOworCWNyZWF0aW9uX3RpbWUgPSAqcGNyZWF0
aW9uX3RpbWU7CisJaW5mb19idWYuQ3JlYXRpb25UaW1lID0gY3B1X3RvX2xlNjQoY3JlYXRpb25f
dGltZSk7CisJaWYgKHBUY29uLT5zZXMtPnNlcnZlci0+b3BzLT5zZXRfZmlsZV9pbmZvKQorCQly
YyA9IHBUY29uLT5zZXMtPnNlcnZlci0+b3BzLT5zZXRfZmlsZV9pbmZvKGlub2RlLCBmdWxsX3Bh
dGgsCisJCQkJJmluZm9fYnVmLCB4aWQpOworCWlmIChyYyA9PSAwKQorCQlDSUZTX0koaW5vZGUp
LT5jcmVhdGV0aW1lID0gY3JlYXRpb25fdGltZTsKKworCXJldHVybiByYzsKK30KIAogc3RhdGlj
IGludCBjaWZzX3hhdHRyX3NldChjb25zdCBzdHJ1Y3QgeGF0dHJfaGFuZGxlciAqaGFuZGxlciwK
IAkJCSAgc3RydWN0IGRlbnRyeSAqZGVudHJ5LCBzdHJ1Y3QgaW5vZGUgKmlub2RlLApAQCAtODYs
NiArMTM3LDIzIEBAIHN0YXRpYyBpbnQgY2lmc194YXR0cl9zZXQoY29uc3Qgc3RydWN0IHhhdHRy
X2hhbmRsZXIgKmhhbmRsZXIsCiAKIAlzd2l0Y2ggKGhhbmRsZXItPmZsYWdzKSB7CiAJY2FzZSBY
QVRUUl9VU0VSOgorCQljaWZzX2RiZyhGWUksICIlczpzZXR0aW5nIHVzZXIgeGF0dHIgJXNcbiIs
IF9fZnVuY19fLCBuYW1lKTsKKwkJaWYgKChzdHJjbXAobmFtZSwgQ0lGU19YQVRUUl9BVFRSSUIp
ID09IDApIHx8CisJCSAgICAoc3RyY21wKG5hbWUsIFNNQjNfWEFUVFJfQVRUUklCKSA9PSAwKSkg
eworCQkJcmMgPSBjaWZzX2F0dHJpYl9zZXQoeGlkLCBwVGNvbiwgaW5vZGUsIGZ1bGxfcGF0aCwK
KwkJCQkJdmFsdWUsIHNpemUpOworCQkJaWYgKHJjID09IDApIC8qIGZvcmNlIHJldmFsaWRhdGUg
b2YgdGhlIGlub2RlICovCisJCQkJQ0lGU19JKGlub2RlKS0+dGltZSA9IDA7CisJCQlicmVhazsK
KwkJfSBlbHNlIGlmICgoc3RyY21wKG5hbWUsIENJRlNfWEFUVFJfQ1JFQVRFVElNRSkgPT0gMCkg
fHwKKwkJCSAgIChzdHJjbXAobmFtZSwgU01CM19YQVRUUl9DUkVBVEVUSU1FKSA9PSAwKSkgewor
CQkJcmMgPSBjaWZzX2NyZWF0aW9uX3RpbWVfc2V0KHhpZCwgcFRjb24sIGlub2RlLAorCQkJCQlm
dWxsX3BhdGgsIHZhbHVlLCBzaXplKTsKKwkJCWlmIChyYyA9PSAwKSAvKiBmb3JjZSByZXZhbGlk
YXRlIG9mIHRoZSBpbm9kZSAqLworCQkJCUNJRlNfSShpbm9kZSktPnRpbWUgPSAwOworCQkJYnJl
YWs7CisJCX0KKwogCQlpZiAoY2lmc19zYi0+bW50X2NpZnNfZmxhZ3MgJiBDSUZTX01PVU5UX05P
X1hBVFRSKQogCQkJZ290byBvdXQ7CiAKQEAgLTk1LDcgKzE2Myw4IEBAIHN0YXRpYyBpbnQgY2lm
c194YXR0cl9zZXQoY29uc3Qgc3RydWN0IHhhdHRyX2hhbmRsZXIgKmhhbmRsZXIsCiAJCQkJY2lm
c19zYi0+bG9jYWxfbmxzLCBjaWZzX3NiKTsKIAkJYnJlYWs7CiAKLQljYXNlIFhBVFRSX0NJRlNf
QUNMOiB7CisJY2FzZSBYQVRUUl9DSUZTX0FDTDoKKwljYXNlIFhBVFRSX0NJRlNfTlRTRDogewog
CQlzdHJ1Y3QgY2lmc19udHNkICpwYWNsOwogCiAJCWlmICghdmFsdWUpCkBAIC0xMDYsMTIgKzE3
NSwyNSBAQCBzdGF0aWMgaW50IGNpZnNfeGF0dHJfc2V0KGNvbnN0IHN0cnVjdCB4YXR0cl9oYW5k
bGVyICpoYW5kbGVyLAogCQl9IGVsc2UgewogCQkJbWVtY3B5KHBhY2wsIHZhbHVlLCBzaXplKTsK
IAkJCWlmICh2YWx1ZSAmJgotCQkJICAgIHBUY29uLT5zZXMtPnNlcnZlci0+b3BzLT5zZXRfYWNs
KQotCQkJCXJjID0gcFRjb24tPnNlcy0+c2VydmVyLT5vcHMtPnNldF9hY2wocGFjbCwKLQkJCQkJ
CXNpemUsIGlub2RlLAotCQkJCQkJZnVsbF9wYXRoLCBDSUZTX0FDTF9EQUNMKTsKLQkJCWVsc2UK
KwkJCSAgICBwVGNvbi0+c2VzLT5zZXJ2ZXItPm9wcy0+c2V0X2FjbCkgeworCQkJCXJjID0gMDsK
KwkJCQlpZiAoaGFuZGxlci0+ZmxhZ3MgPT0gWEFUVFJfQ0lGU19OVFNEKSB7CisJCQkJCS8qIHNl
dCBvd25lciBhbmQgREFDTCAqLworCQkJCQlyYyA9IHBUY29uLT5zZXMtPnNlcnZlci0+b3BzLT5z
ZXRfYWNsKAorCQkJCQkJCXBhY2wsIHNpemUsIGlub2RlLAorCQkJCQkJCWZ1bGxfcGF0aCwKKwkJ
CQkJCQlDSUZTX0FDTF9PV05FUik7CisJCQkJfQorCQkJCWlmIChyYyA9PSAwKSB7CisJCQkJCS8q
IHNldCBEQUNMICovCisJCQkJCXJjID0gcFRjb24tPnNlcy0+c2VydmVyLT5vcHMtPnNldF9hY2wo
CisJCQkJCQkJcGFjbCwgc2l6ZSwgaW5vZGUsCisJCQkJCQkJZnVsbF9wYXRoLAorCQkJCQkJCUNJ
RlNfQUNMX0RBQ0wpOworCQkJCX0KKwkJCX0gZWxzZSB7CiAJCQkJcmMgPSAtRU9QTk9UU1VQUDsK
KwkJCX0KIAkJCWlmIChyYyA9PSAwKSAvKiBmb3JjZSByZXZhbGlkYXRlIG9mIHRoZSBpbm9kZSAq
LwogCQkJCUNJRlNfSShpbm9kZSktPnRpbWUgPSAwOwogCQkJa2ZyZWUocGFjbCk7CkBAIC0xNzks
NyArMjYxLDcgQEAgc3RhdGljIGludCBjaWZzX2NyZWF0aW9uX3RpbWVfZ2V0KHN0cnVjdCBkZW50
cnkgKmRlbnRyeSwgc3RydWN0IGlub2RlICppbm9kZSwKIAkJCQkgIHZvaWQgKnZhbHVlLCBzaXpl
X3Qgc2l6ZSkKIHsKIAlzc2l6ZV90IHJjOwotCV9fdTY0ICogcGNyZWF0ZXRpbWU7CisJX191NjQg
KnBjcmVhdGV0aW1lOwogCiAJcmMgPSBjaWZzX3JldmFsaWRhdGVfZGVudHJ5X2F0dHIoZGVudHJ5
KTsKIAlpZiAocmMpCkBAIC0yNDQsNyArMzI2LDkgQEAgc3RhdGljIGludCBjaWZzX3hhdHRyX2dl
dChjb25zdCBzdHJ1Y3QgeGF0dHJfaGFuZGxlciAqaGFuZGxlciwKIAkJCQlmdWxsX3BhdGgsIG5h
bWUsIHZhbHVlLCBzaXplLCBjaWZzX3NiKTsKIAkJYnJlYWs7CiAKLQljYXNlIFhBVFRSX0NJRlNf
QUNMOiB7CisJY2FzZSBYQVRUUl9DSUZTX0FDTDoKKwljYXNlIFhBVFRSX0NJRlNfTlRTRDogewor
CQkvKiB0aGUgd2hvbGUgbnRzZCBpcyBmZXRjaGVkIHJlZ2FyZGxlc3MgKi8KIAkJdTMyIGFjbGxl
bjsKIAkJc3RydWN0IGNpZnNfbnRzZCAqcGFjbDsKIApAQCAtMzgyLDYgKzQ2NiwyNiBAQCBzdGF0
aWMgY29uc3Qgc3RydWN0IHhhdHRyX2hhbmRsZXIgc21iM19hY2xfeGF0dHJfaGFuZGxlciA9IHsK
IAkuc2V0ID0gY2lmc194YXR0cl9zZXQsCiB9OwogCitzdGF0aWMgY29uc3Qgc3RydWN0IHhhdHRy
X2hhbmRsZXIgY2lmc19jaWZzX250c2RfeGF0dHJfaGFuZGxlciA9IHsKKwkubmFtZSA9IENJRlNf
WEFUVFJfQ0lGU19OVFNELAorCS5mbGFncyA9IFhBVFRSX0NJRlNfTlRTRCwKKwkuZ2V0ID0gY2lm
c194YXR0cl9nZXQsCisJLnNldCA9IGNpZnNfeGF0dHJfc2V0LAorfTsKKworLyoKKyAqIEFsdGhv
dWdoIHRoaXMgaXMganVzdCBhbiBhbGlhcyBmb3IgdGhlIGFib3ZlLCBuZWVkIHRvIG1vdmUgYXdh
eSBmcm9tCisgKiBjb25mdXNpbmcgdXNlcnMgYW5kIHVzaW5nIHRoZSAyMCB5ZWFyIG9sZCB0ZXJt
ICdjaWZzJyB3aGVuIGl0IGlzIG5vCisgKiBsb25nZXIgc2VjdXJlIGFuZCB3YXMgcmVwbGFjZWQg
YnkgU01CMi9TTUIzIGEgbG9uZyB0aW1lIGFnbywgYW5kCisgKiBTTUIzIGFuZCBsYXRlciBhcmUg
aGlnaGx5IHNlY3VyZS4KKyAqLworc3RhdGljIGNvbnN0IHN0cnVjdCB4YXR0cl9oYW5kbGVyIHNt
YjNfbnRzZF94YXR0cl9oYW5kbGVyID0geworCS5uYW1lID0gU01CM19YQVRUUl9DSUZTX05UU0Qs
CisJLmZsYWdzID0gWEFUVFJfQ0lGU19OVFNELAorCS5nZXQgPSBjaWZzX3hhdHRyX2dldCwKKwku
c2V0ID0gY2lmc194YXR0cl9zZXQsCit9OworCiBzdGF0aWMgY29uc3Qgc3RydWN0IHhhdHRyX2hh
bmRsZXIgY2lmc19wb3NpeF9hY2xfYWNjZXNzX3hhdHRyX2hhbmRsZXIgPSB7CiAJLm5hbWUgPSBY
QVRUUl9OQU1FX1BPU0lYX0FDTF9BQ0NFU1MsCiAJLmZsYWdzID0gWEFUVFJfQUNMX0FDQ0VTUywK
QEAgLTQwMSw2ICs1MDUsOCBAQCBjb25zdCBzdHJ1Y3QgeGF0dHJfaGFuZGxlciAqY2lmc194YXR0
cl9oYW5kbGVyc1tdID0gewogCSZjaWZzX29zMl94YXR0cl9oYW5kbGVyLAogCSZjaWZzX2NpZnNf
YWNsX3hhdHRyX2hhbmRsZXIsCiAJJnNtYjNfYWNsX3hhdHRyX2hhbmRsZXIsIC8qIGFsaWFzIGZv
ciBhYm92ZSBzaW5jZSBhdm9pZGluZyAiY2lmcyIgKi8KKwkmY2lmc19jaWZzX250c2RfeGF0dHJf
aGFuZGxlciwKKwkmc21iM19udHNkX3hhdHRyX2hhbmRsZXIsIC8qIGFsaWFzIGZvciBhYm92ZSBz
aW5jZSBhdm9pZGluZyAiY2lmcyIgKi8KIAkmY2lmc19wb3NpeF9hY2xfYWNjZXNzX3hhdHRyX2hh
bmRsZXIsCiAJJmNpZnNfcG9zaXhfYWNsX2RlZmF1bHRfeGF0dHJfaGFuZGxlciwKIAlOVUxMCi0t
IAoyLjI0LjEKCg==
--0000000000001226ea059c4ca73d--
