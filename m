Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B92C433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Feb 2021 01:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B494C60231
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Feb 2021 01:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbhBXBJ4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Feb 2021 20:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234326AbhBXBFH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Feb 2021 20:05:07 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD0EC06174A
        for <linux-cifs@vger.kernel.org>; Tue, 23 Feb 2021 17:03:56 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id e7so554789lft.2
        for <linux-cifs@vger.kernel.org>; Tue, 23 Feb 2021 17:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=0UZWC8Llq3ubvES3WnPG/9yBD1k+cR96jK4XiaH7dQY=;
        b=me+3k/02Ab6quGYW3DwfuK6cd7F28DztPj4bAjgg5jNfw6cWcTUIscq+V019uDYSzD
         LzqnSG1KpNlADMRBCwp+drSIb/sNpDN7ndpk+K1txD7ZmOY0ju8L7CvNwIzV2NTl+TD6
         ove0DNOnsjQqZYsGKYHxKHytSs/RSwF5wJ7qb0/oxS76Z7H8wZ5lXWWXckkLTn9m4gFM
         asKxLcrS30nYuIdp76wWgmtoNOg+ANJB+HWueHbWO+GI0kmL0LjpI30p5ZQ0gXKhFPtY
         oHJ3mu5N8jTreSJ7QWN44Lp8O764iXsnvufOiwLSOaPem6oEi7sblJpUwmMKnfaL0yDB
         Hb3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=0UZWC8Llq3ubvES3WnPG/9yBD1k+cR96jK4XiaH7dQY=;
        b=i3C43v/vZ9pWAanAP/ITjyMHixEJ6ykoWbjW3Rz6oM2/+E0TF/RFdvOwuDTszmszdQ
         e1XjTtmuMc8FgNYQWBR6Y6YXfc4jbxCw06Ak03eRKik4EYNZXafyz6QaRIRKmq0CX1g8
         6hRpkUE4V+0J/XgYC1KfbMYC+dz0C+vVz7Qg+CJn2lio/YrZKNlBagQbhouOzrjq6QMT
         RmykPTdG51utLScoyxLIHe6/X3zjdszpzgrl1N5/Qa/lAAvZMhIAo1F+g5EYh0IKYSkd
         1GeJu0aHfZ6NjuNwE6PqVjb+cBo8eJ6G14Yu0KW8+ILZWA+Vz4ciy8WqNIOWsEVg5wzS
         yVkg==
X-Gm-Message-State: AOAM5303xTUtIvF+Vt/CZm/Lw7HVVCz+ZqHJLjsZlMiez72VB7S1x5z7
        v3HpTEisIFviGf3bZZAJsX6Oh3A/rKqtUMNJgcfLJJf70bVYRw==
X-Google-Smtp-Source: ABdhPJxwAjsAn6Jg1hdXOrwO4PZb69tV1MhTXhH8pbKEVtzgxYVJzj94WQnVFPgJJ5R4aidg5izMPt+QtzxgsZRft80=
X-Received: by 2002:a19:3f04:: with SMTP id m4mr2126322lfa.395.1614128634506;
 Tue, 23 Feb 2021 17:03:54 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5msdUQ=CVM6s7ENeH7SP-teYAOioOGq7zY5sDXZFrFYiCA@mail.gmail.com>
In-Reply-To: <CAH2r5msdUQ=CVM6s7ENeH7SP-teYAOioOGq7zY5sDXZFrFYiCA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 23 Feb 2021 19:03:43 -0600
Message-ID: <CAH2r5mv6Oo5UUMOyFmKO_6xmdXZvQa_TtmFjgdN_ZoBcgSbJkA@mail.gmail.com>
Subject: Re: [PATCH] convert revalidate of directories to using directory
 metadata cache timeout
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000e1c93105bc0a9b66"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000e1c93105bc0a9b66
Content-Type: text/plain; charset="UTF-8"

Updated version incorporates Ronnie's suggestion of leaving the
default (for directory caching) the same as it is today, 1 second, to
avoid
unnecessary risk.   Most users can safely improve performance by
mounting with acdirmax to a higher value (e.g. 60 seconds as NFS
defaults to).

nfs and cifs on Linux currently have a mount parameter "actimeo" to control
metadata (attribute) caching but cifs does not have additional mount
parameters to allow distinguishing between caching directory metadata
(e.g. needed to revalidate paths) and that for files.

Add new mount parameter "acdirmax" to allow caching metadata for
directories more loosely than file data.  NFS adjusts metadata
caching from acdirmin to acdirmax (and another two mount parms
for files) but to reduce complexity, it is safer to just introduce
the one mount parm to allow caching directories longer. The
defaults for acdirmax and actimeo (for cifs.ko) are conservative,
1 second (NFS defaults acdirmax to 60 seconds). For many workloads,
setting acdirmax to a higher value is safe and will improve
performance.  This patch leaves unchanged the default values
for caching metadata for files and directories but gives the
user more flexibility in adjusting them safely for their workload
via the new mount parm.

Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsfs.c     | 3 ++-
 fs/cifs/cifsglob.h   | 8 +++++++-
 fs/cifs/connect.c    | 2 ++
 fs/cifs/fs_context.c | 9 +++++++++
 fs/cifs/fs_context.h | 4 +++-
 5 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 6f33ff3f625f..4e0b0b26e844 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -637,8 +637,9 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
  seq_printf(s, ",snapshot=%llu", tcon->snapshot_time);
  if (tcon->handle_timeout)
  seq_printf(s, ",handletimeout=%u", tcon->handle_timeout);
- /* convert actimeo and display it in seconds */
+ /* convert actimeo and directory attribute timeout and display in seconds */
  seq_printf(s, ",actimeo=%lu", cifs_sb->ctx->actimeo / HZ);
+ seq_printf(s, ",acdirmax=%lu", cifs_sb->ctx->acdirmax / HZ);

  if (tcon->ses->chan_max > 1)
  seq_printf(s, ",multichannel,max_channels=%zu",
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index cd6dbeaf2166..a9dc39aee9f4 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2278,6 +2278,8 @@ compare_mount_options(struct super_block *sb,
struct cifs_mnt_data *mnt_data)

  if (old->ctx->actimeo != new->ctx->actimeo)
  return 0;
+ if (old->ctx->acdirmax != new->ctx->acdirmax)
+ return 0;

  return 1;
 }
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 7d04f2255624..555969c8d586 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -140,6 +140,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
  fsparam_u32("rsize", Opt_rsize),
  fsparam_u32("wsize", Opt_wsize),
  fsparam_u32("actimeo", Opt_actimeo),
+ fsparam_u32("acdirmax", Opt_acdirmax),
  fsparam_u32("echo_interval", Opt_echo_interval),
  fsparam_u32("max_credits", Opt_max_credits),
  fsparam_u32("handletimeout", Opt_handletimeout),
@@ -936,6 +937,13 @@ static int smb3_fs_context_parse_param(struct
fs_context *fc,
  goto cifs_parse_mount_err;
  }
  break;
+ case Opt_acdirmax:
+ ctx->acdirmax = HZ * result.uint_32;
+ if (ctx->acdirmax > CIFS_MAX_ACTIMEO) {
+ cifs_dbg(VFS, "acdirmax too large\n");
+ goto cifs_parse_mount_err;
+ }
+ break;
  case Opt_echo_interval:
  ctx->echo_interval = result.uint_32;
  break;
@@ -1362,6 +1370,7 @@ int smb3_init_fs_context(struct fs_context *fc)
  ctx->strict_io = true;

  ctx->actimeo = CIFS_DEF_ACTIMEO;
+ ctx->acdirmax = CIFS_DEF_ACTIMEO;

  /* Most clients set timeout to 0, allows server to use its default */
  ctx->handle_timeout = 0; /* See MS-SMB2 spec section 2.2.14.2.12 */
diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index 1c44a460e2c0..472372fec4e9 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -118,6 +118,7 @@ enum cifs_param {
  Opt_rsize,
  Opt_wsize,
  Opt_actimeo,
+ Opt_acdirmax,
  Opt_echo_interval,
  Opt_max_credits,
  Opt_snapshot,
@@ -232,7 +233,8 @@ struct smb3_fs_context {
  unsigned int wsize;
  unsigned int min_offload;
  bool sockopt_tcp_nodelay:1;
- unsigned long actimeo; /* attribute cache timeout (jiffies) */
+ unsigned long actimeo; /* attribute cache timeout for files (jiffies) */
+ unsigned long acdirmax; /* attribute cache timeout for directories
(jiffies) */
  struct smb_version_operations *ops;
  struct smb_version_values *vals;
  char *prepath;

On Tue, Feb 23, 2021 at 4:22 PM Steve French <smfrench@gmail.com> wrote:
>
> nfs and cifs on Linux currently have a mount parameter "actimeo" to
> control metadata (attribute) caching but cifs does not have additional
> mount parameters to allow distinguishing between caching directory
> metadata (e.g. needed to revalidate paths) and that for files.
>
> Add new mount parameter "acdirmax" to allow caching metadata for
> directories more loosely than file data.  NFS adjusts metadata
> caching from acdirmin to acdirmax (and another two mount parms
> for files) but to reduce complexity, it is safer to just introduce
> the one mount parm to allow caching directories longer (30 seconds
> vs. the 1 second default for file metadata) which is still more
> conservative than other Linux filesystems (e.g. NFS sets acdirmax
> to 60 seconds)
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--000000000000e1c93105bc0a9b66
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-Add-new-mount-parameter-acdirmax-to-allow-cachi.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Add-new-mount-parameter-acdirmax-to-allow-cachi.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kliqhf7x0>
X-Attachment-Id: f_kliqhf7x0

RnJvbSA1MDVkMjA0MTQ3OWY1NjhjNGY0YjlhMTcwYzQ4NGY4NjZiYzcyYzU3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjMgRmViIDIwMjEgMTU6NTA6NTcgLTA2MDAKU3ViamVjdDogW1BBVENIIDEv
Ml0gY2lmczogQWRkIG5ldyBtb3VudCBwYXJhbWV0ZXIgImFjZGlybWF4IiB0byBhbGxvdyBjYWNo
aW5nCiBkaXJlY3RvcnkgbWV0YWRhdGEKCm5mcyBhbmQgY2lmcyBvbiBMaW51eCBjdXJyZW50bHkg
aGF2ZSBhIG1vdW50IHBhcmFtZXRlciAiYWN0aW1lbyIgdG8gY29udHJvbAptZXRhZGF0YSAoYXR0
cmlidXRlKSBjYWNoaW5nIGJ1dCBjaWZzIGRvZXMgbm90IGhhdmUgYWRkaXRpb25hbCBtb3VudApw
YXJhbWV0ZXJzIHRvIGFsbG93IGRpc3Rpbmd1aXNoaW5nIGJldHdlZW4gY2FjaGluZyBkaXJlY3Rv
cnkgbWV0YWRhdGEKKGUuZy4gbmVlZGVkIHRvIHJldmFsaWRhdGUgcGF0aHMpIGFuZCB0aGF0IGZv
ciBmaWxlcy4KCkFkZCBuZXcgbW91bnQgcGFyYW1ldGVyICJhY2Rpcm1heCIgdG8gYWxsb3cgY2Fj
aGluZyBtZXRhZGF0YSBmb3IKZGlyZWN0b3JpZXMgbW9yZSBsb29zZWx5IHRoYW4gZmlsZSBkYXRh
LiAgTkZTIGFkanVzdHMgbWV0YWRhdGEKY2FjaGluZyBmcm9tIGFjZGlybWluIHRvIGFjZGlybWF4
IChhbmQgYW5vdGhlciB0d28gbW91bnQgcGFybXMKZm9yIGZpbGVzKSBidXQgdG8gcmVkdWNlIGNv
bXBsZXhpdHksIGl0IGlzIHNhZmVyIHRvIGp1c3QgaW50cm9kdWNlCnRoZSBvbmUgbW91bnQgcGFy
bSB0byBhbGxvdyBjYWNoaW5nIGRpcmVjdG9yaWVzIGxvbmdlci4gVGhlCmRlZmF1bHRzIGZvciBh
Y2Rpcm1heCBhbmQgYWN0aW1lbyAoZm9yIGNpZnMua28pIGFyZSBjb25zZXJ2YXRpdmUsCjEgc2Vj
b25kIChORlMgZGVmYXVsdHMgYWNkaXJtYXggdG8gNjAgc2Vjb25kcykuIEZvciBtYW55IHdvcmts
b2FkcywKc2V0dGluZyBhY2Rpcm1heCB0byBhIGhpZ2hlciB2YWx1ZSBpcyBzYWZlIGFuZCB3aWxs
IGltcHJvdmUKcGVyZm9ybWFuY2UuICBUaGlzIHBhdGNoIGxlYXZlcyB1bmNoYW5nZWQgdGhlIGRl
ZmF1bHQgdmFsdWVzCmZvciBjYWNoaW5nIG1ldGFkYXRhIGZvciBmaWxlcyBhbmQgZGlyZWN0b3Jp
ZXMgYnV0IGdpdmVzIHRoZQp1c2VyIG1vcmUgZmxleGliaWxpdHkgaW4gYWRqdXN0aW5nIHRoZW0g
c2FmZWx5IGZvciB0aGVpciB3b3JrbG9hZAp2aWEgdGhlIG5ldyBtb3VudCBwYXJtLgoKU2lnbmVk
LW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgpSZXZpZXdlZC1i
eTogUm9ubmllIFNhaGxiZXJnIDxsc2FobGJlckByZWRoYXQuY29tPgotLS0KIGZzL2NpZnMvY2lm
c2ZzLmMgICAgIHwgMyArKy0KIGZzL2NpZnMvY2lmc2dsb2IuaCAgIHwgOCArKysrKysrLQogZnMv
Y2lmcy9jb25uZWN0LmMgICAgfCAyICsrCiBmcy9jaWZzL2ZzX2NvbnRleHQuYyB8IDkgKysrKysr
KysrCiBmcy9jaWZzL2ZzX2NvbnRleHQuaCB8IDQgKysrLQogNSBmaWxlcyBjaGFuZ2VkLCAyMyBp
bnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2Zz
LmMgYi9mcy9jaWZzL2NpZnNmcy5jCmluZGV4IDZmMzNmZjNmNjI1Zi4uNGUwYjBiMjZlODQ0IDEw
MDY0NAotLS0gYS9mcy9jaWZzL2NpZnNmcy5jCisrKyBiL2ZzL2NpZnMvY2lmc2ZzLmMKQEAgLTYz
Nyw4ICs2MzcsOSBAQCBjaWZzX3Nob3dfb3B0aW9ucyhzdHJ1Y3Qgc2VxX2ZpbGUgKnMsIHN0cnVj
dCBkZW50cnkgKnJvb3QpCiAJCXNlcV9wcmludGYocywgIixzbmFwc2hvdD0lbGx1IiwgdGNvbi0+
c25hcHNob3RfdGltZSk7CiAJaWYgKHRjb24tPmhhbmRsZV90aW1lb3V0KQogCQlzZXFfcHJpbnRm
KHMsICIsaGFuZGxldGltZW91dD0ldSIsIHRjb24tPmhhbmRsZV90aW1lb3V0KTsKLQkvKiBjb252
ZXJ0IGFjdGltZW8gYW5kIGRpc3BsYXkgaXQgaW4gc2Vjb25kcyAqLworCS8qIGNvbnZlcnQgYWN0
aW1lbyBhbmQgZGlyZWN0b3J5IGF0dHJpYnV0ZSB0aW1lb3V0IGFuZCBkaXNwbGF5IGluIHNlY29u
ZHMgKi8KIAlzZXFfcHJpbnRmKHMsICIsYWN0aW1lbz0lbHUiLCBjaWZzX3NiLT5jdHgtPmFjdGlt
ZW8gLyBIWik7CisJc2VxX3ByaW50ZihzLCAiLGFjZGlybWF4PSVsdSIsIGNpZnNfc2ItPmN0eC0+
YWNkaXJtYXggLyBIWik7CiAKIAlpZiAodGNvbi0+c2VzLT5jaGFuX21heCA+IDEpCiAJCXNlcV9w
cmludGYocywgIixtdWx0aWNoYW5uZWwsbWF4X2NoYW5uZWxzPSV6dSIsCmRpZmYgLS1naXQgYS9m
cy9jaWZzL2Nvbm5lY3QuYyBiL2ZzL2NpZnMvY29ubmVjdC5jCmluZGV4IGNkNmRiZWFmMjE2Ni4u
YTlkYzM5YWVlOWY0IDEwMDY0NAotLS0gYS9mcy9jaWZzL2Nvbm5lY3QuYworKysgYi9mcy9jaWZz
L2Nvbm5lY3QuYwpAQCAtMjI3OCw2ICsyMjc4LDggQEAgY29tcGFyZV9tb3VudF9vcHRpb25zKHN0
cnVjdCBzdXBlcl9ibG9jayAqc2IsIHN0cnVjdCBjaWZzX21udF9kYXRhICptbnRfZGF0YSkKIAog
CWlmIChvbGQtPmN0eC0+YWN0aW1lbyAhPSBuZXctPmN0eC0+YWN0aW1lbykKIAkJcmV0dXJuIDA7
CisJaWYgKG9sZC0+Y3R4LT5hY2Rpcm1heCAhPSBuZXctPmN0eC0+YWNkaXJtYXgpCisJCXJldHVy
biAwOwogCiAJcmV0dXJuIDE7CiB9CmRpZmYgLS1naXQgYS9mcy9jaWZzL2ZzX2NvbnRleHQuYyBi
L2ZzL2NpZnMvZnNfY29udGV4dC5jCmluZGV4IDdkMDRmMjI1NTYyNC4uNTU1OTY5YzhkNTg2IDEw
MDY0NAotLS0gYS9mcy9jaWZzL2ZzX2NvbnRleHQuYworKysgYi9mcy9jaWZzL2ZzX2NvbnRleHQu
YwpAQCAtMTQwLDYgKzE0MCw3IEBAIGNvbnN0IHN0cnVjdCBmc19wYXJhbWV0ZXJfc3BlYyBzbWIz
X2ZzX3BhcmFtZXRlcnNbXSA9IHsKIAlmc3BhcmFtX3UzMigicnNpemUiLCBPcHRfcnNpemUpLAog
CWZzcGFyYW1fdTMyKCJ3c2l6ZSIsIE9wdF93c2l6ZSksCiAJZnNwYXJhbV91MzIoImFjdGltZW8i
LCBPcHRfYWN0aW1lbyksCisJZnNwYXJhbV91MzIoImFjZGlybWF4IiwgT3B0X2FjZGlybWF4KSwK
IAlmc3BhcmFtX3UzMigiZWNob19pbnRlcnZhbCIsIE9wdF9lY2hvX2ludGVydmFsKSwKIAlmc3Bh
cmFtX3UzMigibWF4X2NyZWRpdHMiLCBPcHRfbWF4X2NyZWRpdHMpLAogCWZzcGFyYW1fdTMyKCJo
YW5kbGV0aW1lb3V0IiwgT3B0X2hhbmRsZXRpbWVvdXQpLApAQCAtOTM2LDYgKzkzNywxMyBAQCBz
dGF0aWMgaW50IHNtYjNfZnNfY29udGV4dF9wYXJzZV9wYXJhbShzdHJ1Y3QgZnNfY29udGV4dCAq
ZmMsCiAJCQlnb3RvIGNpZnNfcGFyc2VfbW91bnRfZXJyOwogCQl9CiAJCWJyZWFrOworCWNhc2Ug
T3B0X2FjZGlybWF4OgorCQljdHgtPmFjZGlybWF4ID0gSFogKiByZXN1bHQudWludF8zMjsKKwkJ
aWYgKGN0eC0+YWNkaXJtYXggPiBDSUZTX01BWF9BQ1RJTUVPKSB7CisJCQljaWZzX2RiZyhWRlMs
ICJhY2Rpcm1heCB0b28gbGFyZ2VcbiIpOworCQkJZ290byBjaWZzX3BhcnNlX21vdW50X2VycjsK
KwkJfQorCQlicmVhazsKIAljYXNlIE9wdF9lY2hvX2ludGVydmFsOgogCQljdHgtPmVjaG9faW50
ZXJ2YWwgPSByZXN1bHQudWludF8zMjsKIAkJYnJlYWs7CkBAIC0xMzYyLDYgKzEzNzAsNyBAQCBp
bnQgc21iM19pbml0X2ZzX2NvbnRleHQoc3RydWN0IGZzX2NvbnRleHQgKmZjKQogCWN0eC0+c3Ry
aWN0X2lvID0gdHJ1ZTsKIAogCWN0eC0+YWN0aW1lbyA9IENJRlNfREVGX0FDVElNRU87CisJY3R4
LT5hY2Rpcm1heCA9IENJRlNfREVGX0FDVElNRU87CiAKIAkvKiBNb3N0IGNsaWVudHMgc2V0IHRp
bWVvdXQgdG8gMCwgYWxsb3dzIHNlcnZlciB0byB1c2UgaXRzIGRlZmF1bHQgKi8KIAljdHgtPmhh
bmRsZV90aW1lb3V0ID0gMDsgLyogU2VlIE1TLVNNQjIgc3BlYyBzZWN0aW9uIDIuMi4xNC4yLjEy
ICovCmRpZmYgLS1naXQgYS9mcy9jaWZzL2ZzX2NvbnRleHQuaCBiL2ZzL2NpZnMvZnNfY29udGV4
dC5oCmluZGV4IDFjNDRhNDYwZTJjMC4uNDcyMzcyZmVjNGU5IDEwMDY0NAotLS0gYS9mcy9jaWZz
L2ZzX2NvbnRleHQuaAorKysgYi9mcy9jaWZzL2ZzX2NvbnRleHQuaApAQCAtMTE4LDYgKzExOCw3
IEBAIGVudW0gY2lmc19wYXJhbSB7CiAJT3B0X3JzaXplLAogCU9wdF93c2l6ZSwKIAlPcHRfYWN0
aW1lbywKKwlPcHRfYWNkaXJtYXgsCiAJT3B0X2VjaG9faW50ZXJ2YWwsCiAJT3B0X21heF9jcmVk
aXRzLAogCU9wdF9zbmFwc2hvdCwKQEAgLTIzMiw3ICsyMzMsOCBAQCBzdHJ1Y3Qgc21iM19mc19j
b250ZXh0IHsKIAl1bnNpZ25lZCBpbnQgd3NpemU7CiAJdW5zaWduZWQgaW50IG1pbl9vZmZsb2Fk
OwogCWJvb2wgc29ja29wdF90Y3Bfbm9kZWxheToxOwotCXVuc2lnbmVkIGxvbmcgYWN0aW1lbzsg
LyogYXR0cmlidXRlIGNhY2hlIHRpbWVvdXQgKGppZmZpZXMpICovCisJdW5zaWduZWQgbG9uZyBh
Y3RpbWVvOyAvKiBhdHRyaWJ1dGUgY2FjaGUgdGltZW91dCBmb3IgZmlsZXMgKGppZmZpZXMpICov
CisJdW5zaWduZWQgbG9uZyBhY2Rpcm1heDsgLyogYXR0cmlidXRlIGNhY2hlIHRpbWVvdXQgZm9y
IGRpcmVjdG9yaWVzIChqaWZmaWVzKSAqLwogCXN0cnVjdCBzbWJfdmVyc2lvbl9vcGVyYXRpb25z
ICpvcHM7CiAJc3RydWN0IHNtYl92ZXJzaW9uX3ZhbHVlcyAqdmFsczsKIAljaGFyICpwcmVwYXRo
OwotLSAKMi4yNy4wCgo=
--000000000000e1c93105bc0a9b66
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-cifs-convert-revalidate-of-directories-to-using-dire.patch"
Content-Disposition: attachment; 
	filename="0002-cifs-convert-revalidate-of-directories-to-using-dire.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kliqhf831>
X-Attachment-Id: f_kliqhf831

RnJvbSAwNGRjZDY2MjI3ZmYzNjc4NGU2MTQxNzgyYWZjYzU1MDhiYWUxYmE2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjMgRmViIDIwMjEgMTY6MTY6MDkgLTA2MDAKU3ViamVjdDogW1BBVENIIDIv
Ml0gY2lmczogY29udmVydCByZXZhbGlkYXRlIG9mIGRpcmVjdG9yaWVzIHRvIHVzaW5nCiBkaXJl
Y3RvcnkgbWV0YWRhdGEgY2FjaGUgdGltZW91dAoKVGhlIG5ldyBvcHRpb25hbCBtb3VudCBwYXJt
LCAiYWNkaXJtYXgiIGFsbG93cyBjYWNoaW5nIHRoZSBtZXRhZGF0YQpmb3IgYSBkaXJlY3Rvcnkg
bG9uZ2VyIHRoYW4gZmlsZSBtZXRhZGF0YSwgd2hpY2ggY2FuIGJlIHZlcnkgaGVscGZ1bApmb3Ig
cGVyZm9ybWFuY2UuICBDb252ZXJ0IGNpZnNfaW5vZGVfbmVlZHNfcmV2YWwgdG8gY2hlY2sgYWNk
aXJtYXgKZm9yIHJldmFsaWRhdGluZyBkaXJlY3RvcnkgbWV0YWRhdGEgKGFjdGltZW8gaXMgY2hl
Y2tlZCBmb3IgZmlsZXMpCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1p
Y3Jvc29mdC5jb20+ClJldmlld2VkLWJ5OiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhh
dC5jb20+Ci0tLQogZnMvY2lmcy9pbm9kZS5jIHwgMjMgKysrKysrKysrKysrKysrKystLS0tLS0K
IDEgZmlsZSBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2ZzL2NpZnMvaW5vZGUuYyBiL2ZzL2NpZnMvaW5vZGUuYwppbmRleCBhODNiM2E4ZmZh
YWMuLmNmZDMxY2M0NTIwZiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9pbm9kZS5jCisrKyBiL2ZzL2Np
ZnMvaW5vZGUuYwpAQCAtMjE5OCwxMiArMjE5OCwyMyBAQCBjaWZzX2lub2RlX25lZWRzX3JldmFs
KHN0cnVjdCBpbm9kZSAqaW5vZGUpCiAJaWYgKCFsb29rdXBDYWNoZUVuYWJsZWQpCiAJCXJldHVy
biB0cnVlOwogCi0JaWYgKCFjaWZzX3NiLT5jdHgtPmFjdGltZW8pCi0JCXJldHVybiB0cnVlOwot
Ci0JaWYgKCF0aW1lX2luX3JhbmdlKGppZmZpZXMsIGNpZnNfaS0+dGltZSwKLQkJCQljaWZzX2kt
PnRpbWUgKyBjaWZzX3NiLT5jdHgtPmFjdGltZW8pKQotCQlyZXR1cm4gdHJ1ZTsKKwkvKgorCSAq
IGRlcGVuZGluZyBvbiBpbm9kZSB0eXBlLCBjaGVjayBpZiBhdHRyaWJ1dGUgY2FjaGluZyBkaXNh
YmxlZCBmb3IKKwkgKiBmaWxlcyBvciBkaXJlY3RvcmllcworCSAqLworCWlmIChTX0lTRElSKGlu
b2RlLT5pX21vZGUpKSB7CisJCWlmICghY2lmc19zYi0+Y3R4LT5hY2Rpcm1heCkKKwkJCXJldHVy
biB0cnVlOworCQlpZiAoIXRpbWVfaW5fcmFuZ2UoamlmZmllcywgY2lmc19pLT50aW1lLAorCQkJ
CSAgIGNpZnNfaS0+dGltZSArIGNpZnNfc2ItPmN0eC0+YWNkaXJtYXgpKQorCQkJcmV0dXJuIHRy
dWU7CisJfSBlbHNlIHsgLyogZmlsZSAqLworCQlpZiAoIWNpZnNfc2ItPmN0eC0+YWN0aW1lbykK
KwkJCXJldHVybiB0cnVlOworCQlpZiAoIXRpbWVfaW5fcmFuZ2UoamlmZmllcywgY2lmc19pLT50
aW1lLAorCQkJCSAgIGNpZnNfaS0+dGltZSArIGNpZnNfc2ItPmN0eC0+YWN0aW1lbykpCisJCQly
ZXR1cm4gdHJ1ZTsKKwl9CiAKIAkvKiBoYXJkbGlua2VkIGZpbGVzIHcvIG5vc2VydmVyaW5vIGdl
dCAic3BlY2lhbCIgdHJlYXRtZW50ICovCiAJaWYgKCEoY2lmc19zYi0+bW50X2NpZnNfZmxhZ3Mg
JiBDSUZTX01PVU5UX1NFUlZFUl9JTlVNKSAmJgotLSAKMi4yNy4wCgo=
--000000000000e1c93105bc0a9b66--
