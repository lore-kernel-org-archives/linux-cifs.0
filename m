Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F56AC433DB
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Jan 2021 03:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B105764E00
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Jan 2021 03:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhA2DpT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Jan 2021 22:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhA2DpS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Jan 2021 22:45:18 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DABC061573
        for <linux-cifs@vger.kernel.org>; Thu, 28 Jan 2021 19:44:37 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id m22so10572274lfg.5
        for <linux-cifs@vger.kernel.org>; Thu, 28 Jan 2021 19:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=8udyT3BcMxT6mSw0BNcjrdpUFUQkm64PYmtNRAXOD1c=;
        b=jR+UTsN/ZNXUdK0O1nDIjIleef5YWfeMbfO5tkoNyfuivO0mGBgk0hsTrNdmCYRQw5
         1awHA6Tra0VrfNwPLLyeIUTKPnAh+ECE83PrrF8EU+TItuqwaO5+e3DJbnBZ5rs87+2K
         NedJT7AOboBDGGi3SLKopkjqYooDw/M5UfJdIfRKgBLNkgzlI8z3QTurtIKSQuZL+CW4
         o3Rrpf8ZoKmTGxC1qWEGAOi4P1UrgbWkvE1Tn0tyxc0Y+nlpc0Gt1EE7h4zKrkpCYjA0
         Z0Y2AGc7fTn4X/IGRd2Rg6bwgAZLJXO/y969tj+bVYCnWHyAFOmtz7X+qn0e039R3TjC
         EI9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=8udyT3BcMxT6mSw0BNcjrdpUFUQkm64PYmtNRAXOD1c=;
        b=MCnXPjcj0DpIxCU1Mz6h4Ge3P9vLr9is1qPqKuf3HrI20Gp91M8Wl63fhpUMotsAT3
         IP4lF0DMhjnbnJEzL3RMJ/Ahd6UAvXFuv+Nv3wnrAGMaSSYHwNtb/jp5VT4VomjzyMfg
         xduYpaTOiFR+wrCF6HiYEFqGAXxz8eHiL/U7JYmiB9orrdYeBe/8xsaycdDvIvxggH1H
         sEjOAOoVcgHeqU7UBTNtoWPvesZXQb2g+07dJoznNdEjBvcvD2Ev508LO+xmjfPSQYlR
         0ESQCuBn/OdN6+B+x4ttmSK4pyA86ycv/gadO/C6DhvuSCDzGgD7ehnk93TMi60aMLIE
         6onw==
X-Gm-Message-State: AOAM532pOjMzDJ2zHbSiZIQoKFgyUuh8KMZbUnRknSKoQKDC0txXfrdy
        au5n6cvoGUU8eKlaoGSGxp8prq3MDDlySgsGWzH21qdC2l7nuQ==
X-Google-Smtp-Source: ABdhPJx/W7F1dvhk+PMLGeTiIgCqrkceirMS0aURjfeHqFXwSzvamDdiclFODIXo+ddKz5UQusH60kr7tsPvjt5muXw=
X-Received: by 2002:a05:6512:3254:: with SMTP id c20mr1138847lfr.282.1611891875585;
 Thu, 28 Jan 2021 19:44:35 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 28 Jan 2021 21:44:24 -0600
Message-ID: <CAH2r5mtDTSFSXeoOvowsDv0yBjQ-xnpz7XUVBoVC2-8u4CBFfg@mail.gmail.com>
Subject: [PATCH] cifs: fix dfs domain referrals
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>
Content-Type: multipart/mixed; boundary="000000000000a9692905ba01d21f"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000a9692905ba01d21f
Content-Type: text/plain; charset="UTF-8"

Lightly updated patch from Ronnie/Paulo tentatively merged to
cifs-2.6.git for-next (still waiting on the 2nd half of this - to fix
DFS links, but this should fix some DFS problems - see below).

The new mount API requires additional changes to how DFS
is handled. Additional testing of DFS uncovered problems
with domain based DFS referrals (a follow on patch addresses
DFS links) which this patch addresses.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/cifs_dfs_ref.c | 12 ++++++++----
 fs/cifs/cifsfs.c       |  2 +-
 fs/cifs/cifsproto.h    |  6 ++++--
 fs/cifs/connect.c      | 32 ++++++++++++++++++++++++++------
 fs/cifs/dfs_cache.c    |  8 +++++---
 fs/cifs/fs_context.c   | 31 +++++++++++++++++++++++++++++++
 6 files changed, 75 insertions(+), 16 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index e4c6ae47a796..6b1ce4efb591 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -133,8 +133,9 @@ cifs_build_devname(char *nodename, const char *prepath)
  * Caller is responsible for freeing returned value if it is not error.
  */
 char *cifs_compose_mount_options(const char *sb_mountdata,
-    const char *fullpath,
-    const struct dfs_info3_param *ref)
+ const char *fullpath,
+ const struct dfs_info3_param *ref,
+ char **devname)
 {
  int rc;
  char *name;
@@ -231,7 +232,10 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
  strcat(mountdata, "ip=");
  strcat(mountdata, srvIP);

- kfree(name);
+ if (devname)
+ *devname = name;
+ else
+ kfree(name);

  /*cifs_dbg(FYI, "%s: parent mountdata: %s\n", __func__, sb_mountdata);*/
  /*cifs_dbg(FYI, "%s: submount mountdata: %s\n", __func__, mountdata );*/
@@ -278,7 +282,7 @@ static struct vfsmount *cifs_dfs_do_mount(struct
dentry *mntpt,

  /* strip first '\' from fullpath */
  mountdata = cifs_compose_mount_options(cifs_sb->ctx->mount_options,
-        fullpath + 1, NULL);
+        fullpath + 1, NULL, NULL);
  if (IS_ERR(mountdata)) {
  kfree(devname);
  return (struct vfsmount *)mountdata;
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index ce0d0037fd0a..e46da536ed33 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -822,7 +822,7 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
  goto out;
  }

- rc = cifs_setup_volume_info(cifs_sb->ctx);
+ rc = cifs_setup_volume_info(cifs_sb->ctx, NULL, old_ctx->UNC);
  if (rc) {
  root = ERR_PTR(rc);
  goto out;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 340ff81ee87b..32f7a013402e 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -78,7 +78,8 @@ extern char *cifs_build_path_to_root(struct
smb3_fs_context *ctx,
       int add_treename);
 extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
 extern char *cifs_compose_mount_options(const char *sb_mountdata,
- const char *fullpath, const struct dfs_info3_param *ref);
+ const char *fullpath, const struct dfs_info3_param *ref,
+ char **devname);
 /* extern void renew_parental_timestamps(struct dentry *direntry);*/
 extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
  struct TCP_Server_Info *server);
@@ -89,6 +90,7 @@ extern void cifs_wake_up_task(struct mid_q_entry *mid);
 extern int cifs_handle_standard(struct TCP_Server_Info *server,
  struct mid_q_entry *mid);
 extern int smb3_parse_devname(const char *devname, struct
smb3_fs_context *ctx);
+extern int smb3_parse_opt(const char *options, const char *key, char **val);
 extern bool cifs_match_ipaddr(struct sockaddr *srcaddr, struct sockaddr *rhs);
 extern int cifs_discard_remaining_data(struct TCP_Server_Info *server);
 extern int cifs_call_async(struct TCP_Server_Info *server,
@@ -549,7 +551,7 @@ extern int SMBencrypt(unsigned char *passwd, const
unsigned char *c8,
  unsigned char *p24);

 extern int
-cifs_setup_volume_info(struct smb3_fs_context *ctx);
+cifs_setup_volume_info(struct smb3_fs_context *ctx, const char
*mntopts, const char *devname);

 extern struct TCP_Server_Info *
 cifs_find_tcp_session(struct smb3_fs_context *ctx);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c8ef24bac94f..10fe6d6d2dee 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2972,17 +2972,20 @@ expand_dfs_referral(const unsigned int xid,
struct cifs_ses *ses,
  rc = dfs_cache_find(xid, ses, cifs_sb->local_nls, cifs_remap(cifs_sb),
      ref_path, &referral, NULL);
  if (!rc) {
+ char *fake_devname = NULL;
+
  mdata = cifs_compose_mount_options(cifs_sb->ctx->mount_options,
-    full_path + 1, &referral);
+    full_path + 1, &referral,
+    &fake_devname);
  free_dfs_info_param(&referral);

  if (IS_ERR(mdata)) {
  rc = PTR_ERR(mdata);
  mdata = NULL;
  } else {
- smb3_cleanup_fs_context_contents(ctx);
- rc = cifs_setup_volume_info(ctx);
+ rc = cifs_setup_volume_info(ctx, mdata, fake_devname);
  }
+ kfree(fake_devname);
  kfree(cifs_sb->ctx->mount_options);
  cifs_sb->ctx->mount_options = mdata;
  }
@@ -3036,6 +3039,7 @@ static int setup_dfs_tgt_conn(const char *path,
const char *full_path,
  struct dfs_info3_param ref = {0};
  char *mdata = NULL;
  struct smb3_fs_context fake_ctx = {NULL};
+ char *fake_devname = NULL;

  cifs_dbg(FYI, "%s: dfs path: %s\n", __func__, path);

@@ -3044,16 +3048,18 @@ static int setup_dfs_tgt_conn(const char
*path, const char *full_path,
  return rc;

  mdata = cifs_compose_mount_options(cifs_sb->ctx->mount_options,
-    full_path + 1, &ref);
+    full_path + 1, &ref,
+    &fake_devname);
  free_dfs_info_param(&ref);

  if (IS_ERR(mdata)) {
  rc = PTR_ERR(mdata);
  mdata = NULL;
  } else
- rc = cifs_setup_volume_info(&fake_ctx);
+ rc = cifs_setup_volume_info(&fake_ctx, mdata, fake_devname);

  kfree(mdata);
+ kfree(fake_devname);

  if (!rc) {
  /*
@@ -3122,10 +3128,24 @@ static int do_dfs_failover(const char *path,
const char *full_path, struct cifs_
  * we should pass a clone of the original context?
  */
 int
-cifs_setup_volume_info(struct smb3_fs_context *ctx)
+cifs_setup_volume_info(struct smb3_fs_context *ctx, const char
*mntopts, const char *devname)
 {
  int rc = 0;

+ smb3_parse_devname(devname, ctx);
+
+ if (mntopts) {
+ char *ip;
+
+ cifs_dbg(FYI, "%s: mntopts=%s\n", __func__, mntopts);
+ rc = smb3_parse_opt(mntopts, "ip", &ip);
+ if (!rc && !cifs_convert_address((struct sockaddr *)&ctx->dstaddr, ip,
+ strlen(ip))) {
+ cifs_dbg(VFS, "%s: failed to convert ip address\n", __func__);
+ return -EINVAL;
+ }
+ }
+
  if (ctx->nullauth) {
  cifs_dbg(FYI, "Anonymous login\n");
  kfree(ctx->username);
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 0fdb0de7ff86..4950ab0486ae 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1417,7 +1417,7 @@ static struct cifs_ses *find_root_ses(struct vol_info *vi,
  int rc;
  struct cache_entry *ce;
  struct dfs_info3_param ref = {0};
- char *mdata = NULL;
+ char *mdata = NULL, *devname = NULL;
  struct TCP_Server_Info *server;
  struct cifs_ses *ses;
  struct smb3_fs_context ctx = {NULL};
@@ -1444,7 +1444,8 @@ static struct cifs_ses *find_root_ses(struct vol_info *vi,

  up_read(&htable_rw_lock);

- mdata = cifs_compose_mount_options(vi->mntdata, rpath, &ref);
+ mdata = cifs_compose_mount_options(vi->mntdata, rpath, &ref,
+    &devname);
  free_dfs_info_param(&ref);

  if (IS_ERR(mdata)) {
@@ -1453,7 +1454,7 @@ static struct cifs_ses *find_root_ses(struct vol_info *vi,
  goto out;
  }

- rc = cifs_setup_volume_info(&ctx);
+ rc = cifs_setup_volume_info(&ctx, NULL, devname);

  if (rc) {
  ses = ERR_PTR(rc);
@@ -1472,6 +1473,7 @@ static struct cifs_ses *find_root_ses(struct vol_info *vi,
  smb3_cleanup_fs_context_contents(&ctx);
  kfree(mdata);
  kfree(rpath);
+ kfree(devname);

  return ses;
 }
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 27354417e988..5111aadfdb6b 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -401,6 +401,37 @@ cifs_parse_smb_version(char *value, struct
smb3_fs_context *ctx, bool is_smb3)
  return 0;
 }

+int smb3_parse_opt(const char *options, const char *key, char **val)
+{
+ int rc = -ENOENT;
+ char *opts, *orig, *p;
+
+ orig = opts = kstrdup(options, GFP_KERNEL);
+ if (!opts)
+ return -ENOMEM;
+
+ while ((p = strsep(&opts, ","))) {
+ char *nval;
+
+ if (!*p)
+ continue;
+ if (strncasecmp(p, key, strlen(key)))
+ continue;
+ nval = strchr(p, '=');
+ if (nval) {
+ if (nval == p)
+ continue;
+ *nval++ = 0;
+ *val = kstrndup(nval, strlen(nval), GFP_KERNEL);
+ rc = !*val ? -ENOMEM : 0;
+ goto out;
+ }
+ }
+out:
+ kfree(orig);
+ return rc;
+}
+
 /*
  * Parse a devname into substrings and populate the ctx->UNC and ctx->prepath
  * fields with the result. Returns 0 on success and an error otherwise
--


-- 
Thanks,

Steve

--000000000000a9692905ba01d21f
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-dfs-domain-referrals.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-dfs-domain-referrals.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kkhqqror0>
X-Attachment-Id: f_kkhqqror0

RnJvbSAwZDQ4NzNmOWFhNGZmOGZjMWQ2M2E1NzU1Mzk1Yjc5NGQzMmNlMDQ2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+
CkRhdGU6IFRodSwgMjggSmFuIDIwMjEgMjE6MzU6MTAgLTA2MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBmaXggZGZzIGRvbWFpbiByZWZlcnJhbHMKClRoZSBuZXcgbW91bnQgQVBJIHJlcXVpcmVz
IGFkZGl0aW9uYWwgY2hhbmdlcyB0byBob3cgREZTCmlzIGhhbmRsZWQuIEFkZGl0aW9uYWwgdGVz
dGluZyBvZiBERlMgdW5jb3ZlcmVkIHByb2JsZW1zCndpdGggZG9tYWluIGJhc2VkIERGUyByZWZl
cnJhbHMgKGEgZm9sbG93IG9uIHBhdGNoIGFkZHJlc3NlcwpERlMgbGlua3MpIHdoaWNoIHRoaXMg
cGF0Y2ggYWRkcmVzc2VzLgoKU2lnbmVkLW9mZi1ieTogUm9ubmllIFNhaGxiZXJnIDxsc2FobGJl
ckByZWRoYXQuY29tPgpTaWduZWQtb2ZmLWJ5OiBQYXVsbyBBbGNhbnRhcmEgKFNVU0UpIDxwY0Bj
anIubno+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNv
bT4KLS0tCiBmcy9jaWZzL2NpZnNfZGZzX3JlZi5jIHwgMTIgKysrKysrKystLS0tCiBmcy9jaWZz
L2NpZnNmcy5jICAgICAgIHwgIDIgKy0KIGZzL2NpZnMvY2lmc3Byb3RvLmggICAgfCAgNiArKysr
LS0KIGZzL2NpZnMvY29ubmVjdC5jICAgICAgfCAzMiArKysrKysrKysrKysrKysrKysrKysrKysr
Ky0tLS0tLQogZnMvY2lmcy9kZnNfY2FjaGUuYyAgICB8ICA4ICsrKysrLS0tCiBmcy9jaWZzL2Zz
X2NvbnRleHQuYyAgIHwgMzEgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwogNiBmaWxl
cyBjaGFuZ2VkLCA3NSBpbnNlcnRpb25zKCspLCAxNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9mcy9jaWZzL2NpZnNfZGZzX3JlZi5jIGIvZnMvY2lmcy9jaWZzX2Rmc19yZWYuYwppbmRleCBl
NGM2YWU0N2E3OTYuLjZiMWNlNGVmYjU5MSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzX2Rmc19y
ZWYuYworKysgYi9mcy9jaWZzL2NpZnNfZGZzX3JlZi5jCkBAIC0xMzMsOCArMTMzLDkgQEAgY2lm
c19idWlsZF9kZXZuYW1lKGNoYXIgKm5vZGVuYW1lLCBjb25zdCBjaGFyICpwcmVwYXRoKQogICog
Q2FsbGVyIGlzIHJlc3BvbnNpYmxlIGZvciBmcmVlaW5nIHJldHVybmVkIHZhbHVlIGlmIGl0IGlz
IG5vdCBlcnJvci4KICAqLwogY2hhciAqY2lmc19jb21wb3NlX21vdW50X29wdGlvbnMoY29uc3Qg
Y2hhciAqc2JfbW91bnRkYXRhLAotCQkJCSAgIGNvbnN0IGNoYXIgKmZ1bGxwYXRoLAotCQkJCSAg
IGNvbnN0IHN0cnVjdCBkZnNfaW5mbzNfcGFyYW0gKnJlZikKKwkJCQkgY29uc3QgY2hhciAqZnVs
bHBhdGgsCisJCQkJIGNvbnN0IHN0cnVjdCBkZnNfaW5mbzNfcGFyYW0gKnJlZiwKKwkJCQkgY2hh
ciAqKmRldm5hbWUpCiB7CiAJaW50IHJjOwogCWNoYXIgKm5hbWU7CkBAIC0yMzEsNyArMjMyLDEw
IEBAIGNoYXIgKmNpZnNfY29tcG9zZV9tb3VudF9vcHRpb25zKGNvbnN0IGNoYXIgKnNiX21vdW50
ZGF0YSwKIAlzdHJjYXQobW91bnRkYXRhLCAiaXA9Iik7CiAJc3RyY2F0KG1vdW50ZGF0YSwgc3J2
SVApOwogCi0Ja2ZyZWUobmFtZSk7CisJaWYgKGRldm5hbWUpCisJCSpkZXZuYW1lID0gbmFtZTsK
KwllbHNlCisJCWtmcmVlKG5hbWUpOwogCiAJLypjaWZzX2RiZyhGWUksICIlczogcGFyZW50IG1v
dW50ZGF0YTogJXNcbiIsIF9fZnVuY19fLCBzYl9tb3VudGRhdGEpOyovCiAJLypjaWZzX2RiZyhG
WUksICIlczogc3VibW91bnQgbW91bnRkYXRhOiAlc1xuIiwgX19mdW5jX18sIG1vdW50ZGF0YSAp
OyovCkBAIC0yNzgsNyArMjgyLDcgQEAgc3RhdGljIHN0cnVjdCB2ZnNtb3VudCAqY2lmc19kZnNf
ZG9fbW91bnQoc3RydWN0IGRlbnRyeSAqbW50cHQsCiAKIAkvKiBzdHJpcCBmaXJzdCAnXCcgZnJv
bSBmdWxscGF0aCAqLwogCW1vdW50ZGF0YSA9IGNpZnNfY29tcG9zZV9tb3VudF9vcHRpb25zKGNp
ZnNfc2ItPmN0eC0+bW91bnRfb3B0aW9ucywKLQkJCQkJICAgICAgIGZ1bGxwYXRoICsgMSwgTlVM
TCk7CisJCQkJCSAgICAgICBmdWxscGF0aCArIDEsIE5VTEwsIE5VTEwpOwogCWlmIChJU19FUlIo
bW91bnRkYXRhKSkgewogCQlrZnJlZShkZXZuYW1lKTsKIAkJcmV0dXJuIChzdHJ1Y3QgdmZzbW91
bnQgKiltb3VudGRhdGE7CmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNmcy5jIGIvZnMvY2lmcy9j
aWZzZnMuYwppbmRleCBjZTBkMDAzN2ZkMGEuLmU0NmRhNTM2ZWQzMyAxMDA2NDQKLS0tIGEvZnMv
Y2lmcy9jaWZzZnMuYworKysgYi9mcy9jaWZzL2NpZnNmcy5jCkBAIC04MjIsNyArODIyLDcgQEAg
Y2lmc19zbWIzX2RvX21vdW50KHN0cnVjdCBmaWxlX3N5c3RlbV90eXBlICpmc190eXBlLAogCQln
b3RvIG91dDsKIAl9CiAKLQlyYyA9IGNpZnNfc2V0dXBfdm9sdW1lX2luZm8oY2lmc19zYi0+Y3R4
KTsKKwlyYyA9IGNpZnNfc2V0dXBfdm9sdW1lX2luZm8oY2lmc19zYi0+Y3R4LCBOVUxMLCBvbGRf
Y3R4LT5VTkMpOwogCWlmIChyYykgewogCQlyb290ID0gRVJSX1BUUihyYyk7CiAJCWdvdG8gb3V0
OwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzcHJvdG8uaCBiL2ZzL2NpZnMvY2lmc3Byb3RvLmgK
aW5kZXggMzQwZmY4MWVlODdiLi4zMmY3YTAxMzQwMmUgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lm
c3Byb3RvLmgKKysrIGIvZnMvY2lmcy9jaWZzcHJvdG8uaApAQCAtNzgsNyArNzgsOCBAQCBleHRl
cm4gY2hhciAqY2lmc19idWlsZF9wYXRoX3RvX3Jvb3Qoc3RydWN0IHNtYjNfZnNfY29udGV4dCAq
Y3R4LAogCQkJCSAgICAgaW50IGFkZF90cmVlbmFtZSk7CiBleHRlcm4gY2hhciAqYnVpbGRfd2ls
ZGNhcmRfcGF0aF9mcm9tX2RlbnRyeShzdHJ1Y3QgZGVudHJ5ICpkaXJlbnRyeSk7CiBleHRlcm4g
Y2hhciAqY2lmc19jb21wb3NlX21vdW50X29wdGlvbnMoY29uc3QgY2hhciAqc2JfbW91bnRkYXRh
LAotCQljb25zdCBjaGFyICpmdWxscGF0aCwgY29uc3Qgc3RydWN0IGRmc19pbmZvM19wYXJhbSAq
cmVmKTsKKwkJY29uc3QgY2hhciAqZnVsbHBhdGgsIGNvbnN0IHN0cnVjdCBkZnNfaW5mbzNfcGFy
YW0gKnJlZiwKKwkJY2hhciAqKmRldm5hbWUpOwogLyogZXh0ZXJuIHZvaWQgcmVuZXdfcGFyZW50
YWxfdGltZXN0YW1wcyhzdHJ1Y3QgZGVudHJ5ICpkaXJlbnRyeSk7Ki8KIGV4dGVybiBzdHJ1Y3Qg
bWlkX3FfZW50cnkgKkFsbG9jTWlkUUVudHJ5KGNvbnN0IHN0cnVjdCBzbWJfaGRyICpzbWJfYnVm
ZmVyLAogCQkJCQlzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIpOwpAQCAtODksNiArOTAs
NyBAQCBleHRlcm4gdm9pZCBjaWZzX3dha2VfdXBfdGFzayhzdHJ1Y3QgbWlkX3FfZW50cnkgKm1p
ZCk7CiBleHRlcm4gaW50IGNpZnNfaGFuZGxlX3N0YW5kYXJkKHN0cnVjdCBUQ1BfU2VydmVyX0lu
Zm8gKnNlcnZlciwKIAkJCQlzdHJ1Y3QgbWlkX3FfZW50cnkgKm1pZCk7CiBleHRlcm4gaW50IHNt
YjNfcGFyc2VfZGV2bmFtZShjb25zdCBjaGFyICpkZXZuYW1lLCBzdHJ1Y3Qgc21iM19mc19jb250
ZXh0ICpjdHgpOworZXh0ZXJuIGludCBzbWIzX3BhcnNlX29wdChjb25zdCBjaGFyICpvcHRpb25z
LCBjb25zdCBjaGFyICprZXksIGNoYXIgKip2YWwpOwogZXh0ZXJuIGJvb2wgY2lmc19tYXRjaF9p
cGFkZHIoc3RydWN0IHNvY2thZGRyICpzcmNhZGRyLCBzdHJ1Y3Qgc29ja2FkZHIgKnJocyk7CiBl
eHRlcm4gaW50IGNpZnNfZGlzY2FyZF9yZW1haW5pbmdfZGF0YShzdHJ1Y3QgVENQX1NlcnZlcl9J
bmZvICpzZXJ2ZXIpOwogZXh0ZXJuIGludCBjaWZzX2NhbGxfYXN5bmMoc3RydWN0IFRDUF9TZXJ2
ZXJfSW5mbyAqc2VydmVyLApAQCAtNTQ5LDcgKzU1MSw3IEBAIGV4dGVybiBpbnQgU01CZW5jcnlw
dCh1bnNpZ25lZCBjaGFyICpwYXNzd2QsIGNvbnN0IHVuc2lnbmVkIGNoYXIgKmM4LAogCQkJdW5z
aWduZWQgY2hhciAqcDI0KTsKIAogZXh0ZXJuIGludAotY2lmc19zZXR1cF92b2x1bWVfaW5mbyhz
dHJ1Y3Qgc21iM19mc19jb250ZXh0ICpjdHgpOworY2lmc19zZXR1cF92b2x1bWVfaW5mbyhzdHJ1
Y3Qgc21iM19mc19jb250ZXh0ICpjdHgsIGNvbnN0IGNoYXIgKm1udG9wdHMsIGNvbnN0IGNoYXIg
KmRldm5hbWUpOwogCiBleHRlcm4gc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqCiBjaWZzX2ZpbmRf
dGNwX3Nlc3Npb24oc3RydWN0IHNtYjNfZnNfY29udGV4dCAqY3R4KTsKZGlmZiAtLWdpdCBhL2Zz
L2NpZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9jb25uZWN0LmMKaW5kZXggYzhlZjI0YmFjOTRmLi4x
MGZlNmQ2ZDJkZWUgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5jCisrKyBiL2ZzL2NpZnMv
Y29ubmVjdC5jCkBAIC0yOTcyLDE3ICsyOTcyLDIwIEBAIGV4cGFuZF9kZnNfcmVmZXJyYWwoY29u
c3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfc2VzICpzZXMsCiAJcmMgPSBkZnNfY2Fj
aGVfZmluZCh4aWQsIHNlcywgY2lmc19zYi0+bG9jYWxfbmxzLCBjaWZzX3JlbWFwKGNpZnNfc2Ip
LAogCQkJICAgIHJlZl9wYXRoLCAmcmVmZXJyYWwsIE5VTEwpOwogCWlmICghcmMpIHsKKwkJY2hh
ciAqZmFrZV9kZXZuYW1lID0gTlVMTDsKKwogCQltZGF0YSA9IGNpZnNfY29tcG9zZV9tb3VudF9v
cHRpb25zKGNpZnNfc2ItPmN0eC0+bW91bnRfb3B0aW9ucywKLQkJCQkJCSAgIGZ1bGxfcGF0aCAr
IDEsICZyZWZlcnJhbCk7CisJCQkJCQkgICBmdWxsX3BhdGggKyAxLCAmcmVmZXJyYWwsCisJCQkJ
CQkgICAmZmFrZV9kZXZuYW1lKTsKIAkJZnJlZV9kZnNfaW5mb19wYXJhbSgmcmVmZXJyYWwpOwog
CiAJCWlmIChJU19FUlIobWRhdGEpKSB7CiAJCQlyYyA9IFBUUl9FUlIobWRhdGEpOwogCQkJbWRh
dGEgPSBOVUxMOwogCQl9IGVsc2UgewotCQkJc21iM19jbGVhbnVwX2ZzX2NvbnRleHRfY29udGVu
dHMoY3R4KTsKLQkJCXJjID0gY2lmc19zZXR1cF92b2x1bWVfaW5mbyhjdHgpOworCQkJcmMgPSBj
aWZzX3NldHVwX3ZvbHVtZV9pbmZvKGN0eCwgbWRhdGEsIGZha2VfZGV2bmFtZSk7CiAJCX0KKwkJ
a2ZyZWUoZmFrZV9kZXZuYW1lKTsKIAkJa2ZyZWUoY2lmc19zYi0+Y3R4LT5tb3VudF9vcHRpb25z
KTsKIAkJY2lmc19zYi0+Y3R4LT5tb3VudF9vcHRpb25zID0gbWRhdGE7CiAJfQpAQCAtMzAzNiw2
ICszMDM5LDcgQEAgc3RhdGljIGludCBzZXR1cF9kZnNfdGd0X2Nvbm4oY29uc3QgY2hhciAqcGF0
aCwgY29uc3QgY2hhciAqZnVsbF9wYXRoLAogCXN0cnVjdCBkZnNfaW5mbzNfcGFyYW0gcmVmID0g
ezB9OwogCWNoYXIgKm1kYXRhID0gTlVMTDsKIAlzdHJ1Y3Qgc21iM19mc19jb250ZXh0IGZha2Vf
Y3R4ID0ge05VTEx9OworCWNoYXIgKmZha2VfZGV2bmFtZSA9IE5VTEw7CiAKIAljaWZzX2RiZyhG
WUksICIlczogZGZzIHBhdGg6ICVzXG4iLCBfX2Z1bmNfXywgcGF0aCk7CiAKQEAgLTMwNDQsMTYg
KzMwNDgsMTggQEAgc3RhdGljIGludCBzZXR1cF9kZnNfdGd0X2Nvbm4oY29uc3QgY2hhciAqcGF0
aCwgY29uc3QgY2hhciAqZnVsbF9wYXRoLAogCQlyZXR1cm4gcmM7CiAKIAltZGF0YSA9IGNpZnNf
Y29tcG9zZV9tb3VudF9vcHRpb25zKGNpZnNfc2ItPmN0eC0+bW91bnRfb3B0aW9ucywKLQkJCQkJ
ICAgZnVsbF9wYXRoICsgMSwgJnJlZik7CisJCQkJCSAgIGZ1bGxfcGF0aCArIDEsICZyZWYsCisJ
CQkJCSAgICZmYWtlX2Rldm5hbWUpOwogCWZyZWVfZGZzX2luZm9fcGFyYW0oJnJlZik7CiAKIAlp
ZiAoSVNfRVJSKG1kYXRhKSkgewogCQlyYyA9IFBUUl9FUlIobWRhdGEpOwogCQltZGF0YSA9IE5V
TEw7CiAJfSBlbHNlCi0JCXJjID0gY2lmc19zZXR1cF92b2x1bWVfaW5mbygmZmFrZV9jdHgpOwor
CQlyYyA9IGNpZnNfc2V0dXBfdm9sdW1lX2luZm8oJmZha2VfY3R4LCBtZGF0YSwgZmFrZV9kZXZu
YW1lKTsKIAogCWtmcmVlKG1kYXRhKTsKKwlrZnJlZShmYWtlX2Rldm5hbWUpOwogCiAJaWYgKCFy
YykgewogCQkvKgpAQCAtMzEyMiwxMCArMzEyOCwyNCBAQCBzdGF0aWMgaW50IGRvX2Rmc19mYWls
b3Zlcihjb25zdCBjaGFyICpwYXRoLCBjb25zdCBjaGFyICpmdWxsX3BhdGgsIHN0cnVjdCBjaWZz
XwogICogd2Ugc2hvdWxkIHBhc3MgYSBjbG9uZSBvZiB0aGUgb3JpZ2luYWwgY29udGV4dD8KICAq
LwogaW50Ci1jaWZzX3NldHVwX3ZvbHVtZV9pbmZvKHN0cnVjdCBzbWIzX2ZzX2NvbnRleHQgKmN0
eCkKK2NpZnNfc2V0dXBfdm9sdW1lX2luZm8oc3RydWN0IHNtYjNfZnNfY29udGV4dCAqY3R4LCBj
b25zdCBjaGFyICptbnRvcHRzLCBjb25zdCBjaGFyICpkZXZuYW1lKQogewogCWludCByYyA9IDA7
CiAKKwlzbWIzX3BhcnNlX2Rldm5hbWUoZGV2bmFtZSwgY3R4KTsKKworCWlmIChtbnRvcHRzKSB7
CisJCWNoYXIgKmlwOworCisJCWNpZnNfZGJnKEZZSSwgIiVzOiBtbnRvcHRzPSVzXG4iLCBfX2Z1
bmNfXywgbW50b3B0cyk7CisJCXJjID0gc21iM19wYXJzZV9vcHQobW50b3B0cywgImlwIiwgJmlw
KTsKKwkJaWYgKCFyYyAmJiAhY2lmc19jb252ZXJ0X2FkZHJlc3MoKHN0cnVjdCBzb2NrYWRkciAq
KSZjdHgtPmRzdGFkZHIsIGlwLAorCQkJCQkJIHN0cmxlbihpcCkpKSB7CisJCQljaWZzX2RiZyhW
RlMsICIlczogZmFpbGVkIHRvIGNvbnZlcnQgaXAgYWRkcmVzc1xuIiwgX19mdW5jX18pOworCQkJ
cmV0dXJuIC1FSU5WQUw7CisJCX0KKwl9CisKIAlpZiAoY3R4LT5udWxsYXV0aCkgewogCQljaWZz
X2RiZyhGWUksICJBbm9ueW1vdXMgbG9naW5cbiIpOwogCQlrZnJlZShjdHgtPnVzZXJuYW1lKTsK
ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvZGZzX2NhY2hlLmMgYi9mcy9jaWZzL2Rmc19jYWNoZS5jCmlu
ZGV4IDBmZGIwZGU3ZmY4Ni4uNDk1MGFiMDQ4NmFlIDEwMDY0NAotLS0gYS9mcy9jaWZzL2Rmc19j
YWNoZS5jCisrKyBiL2ZzL2NpZnMvZGZzX2NhY2hlLmMKQEAgLTE0MTcsNyArMTQxNyw3IEBAIHN0
YXRpYyBzdHJ1Y3QgY2lmc19zZXMgKmZpbmRfcm9vdF9zZXMoc3RydWN0IHZvbF9pbmZvICp2aSwK
IAlpbnQgcmM7CiAJc3RydWN0IGNhY2hlX2VudHJ5ICpjZTsKIAlzdHJ1Y3QgZGZzX2luZm8zX3Bh
cmFtIHJlZiA9IHswfTsKLQljaGFyICptZGF0YSA9IE5VTEw7CisJY2hhciAqbWRhdGEgPSBOVUxM
LCAqZGV2bmFtZSA9IE5VTEw7CiAJc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyOwogCXN0
cnVjdCBjaWZzX3NlcyAqc2VzOwogCXN0cnVjdCBzbWIzX2ZzX2NvbnRleHQgY3R4ID0ge05VTEx9
OwpAQCAtMTQ0NCw3ICsxNDQ0LDggQEAgc3RhdGljIHN0cnVjdCBjaWZzX3NlcyAqZmluZF9yb290
X3NlcyhzdHJ1Y3Qgdm9sX2luZm8gKnZpLAogCiAJdXBfcmVhZCgmaHRhYmxlX3J3X2xvY2spOwog
Ci0JbWRhdGEgPSBjaWZzX2NvbXBvc2VfbW91bnRfb3B0aW9ucyh2aS0+bW50ZGF0YSwgcnBhdGgs
ICZyZWYpOworCW1kYXRhID0gY2lmc19jb21wb3NlX21vdW50X29wdGlvbnModmktPm1udGRhdGEs
IHJwYXRoLCAmcmVmLAorCQkJCQkgICAmZGV2bmFtZSk7CiAJZnJlZV9kZnNfaW5mb19wYXJhbSgm
cmVmKTsKIAogCWlmIChJU19FUlIobWRhdGEpKSB7CkBAIC0xNDUzLDcgKzE0NTQsNyBAQCBzdGF0
aWMgc3RydWN0IGNpZnNfc2VzICpmaW5kX3Jvb3Rfc2VzKHN0cnVjdCB2b2xfaW5mbyAqdmksCiAJ
CWdvdG8gb3V0OwogCX0KIAotCXJjID0gY2lmc19zZXR1cF92b2x1bWVfaW5mbygmY3R4KTsKKwly
YyA9IGNpZnNfc2V0dXBfdm9sdW1lX2luZm8oJmN0eCwgTlVMTCwgZGV2bmFtZSk7CiAKIAlpZiAo
cmMpIHsKIAkJc2VzID0gRVJSX1BUUihyYyk7CkBAIC0xNDcyLDYgKzE0NzMsNyBAQCBzdGF0aWMg
c3RydWN0IGNpZnNfc2VzICpmaW5kX3Jvb3Rfc2VzKHN0cnVjdCB2b2xfaW5mbyAqdmksCiAJc21i
M19jbGVhbnVwX2ZzX2NvbnRleHRfY29udGVudHMoJmN0eCk7CiAJa2ZyZWUobWRhdGEpOwogCWtm
cmVlKHJwYXRoKTsKKwlrZnJlZShkZXZuYW1lKTsKIAogCXJldHVybiBzZXM7CiB9CmRpZmYgLS1n
aXQgYS9mcy9jaWZzL2ZzX2NvbnRleHQuYyBiL2ZzL2NpZnMvZnNfY29udGV4dC5jCmluZGV4IDI3
MzU0NDE3ZTk4OC4uNTExMWFhZGZkYjZiIDEwMDY0NAotLS0gYS9mcy9jaWZzL2ZzX2NvbnRleHQu
YworKysgYi9mcy9jaWZzL2ZzX2NvbnRleHQuYwpAQCAtNDAxLDYgKzQwMSwzNyBAQCBjaWZzX3Bh
cnNlX3NtYl92ZXJzaW9uKGNoYXIgKnZhbHVlLCBzdHJ1Y3Qgc21iM19mc19jb250ZXh0ICpjdHgs
IGJvb2wgaXNfc21iMykKIAlyZXR1cm4gMDsKIH0KIAoraW50IHNtYjNfcGFyc2Vfb3B0KGNvbnN0
IGNoYXIgKm9wdGlvbnMsIGNvbnN0IGNoYXIgKmtleSwgY2hhciAqKnZhbCkKK3sKKwlpbnQgcmMg
PSAtRU5PRU5UOworCWNoYXIgKm9wdHMsICpvcmlnLCAqcDsKKworCW9yaWcgPSBvcHRzID0ga3N0
cmR1cChvcHRpb25zLCBHRlBfS0VSTkVMKTsKKwlpZiAoIW9wdHMpCisJCXJldHVybiAtRU5PTUVN
OworCisJd2hpbGUgKChwID0gc3Ryc2VwKCZvcHRzLCAiLCIpKSkgeworCQljaGFyICpudmFsOwor
CisJCWlmICghKnApCisJCQljb250aW51ZTsKKwkJaWYgKHN0cm5jYXNlY21wKHAsIGtleSwgc3Ry
bGVuKGtleSkpKQorCQkJY29udGludWU7CisJCW52YWwgPSBzdHJjaHIocCwgJz0nKTsKKwkJaWYg
KG52YWwpIHsKKwkJCWlmIChudmFsID09IHApCisJCQkJY29udGludWU7CisJCQkqbnZhbCsrID0g
MDsKKwkJCSp2YWwgPSBrc3RybmR1cChudmFsLCBzdHJsZW4obnZhbCksIEdGUF9LRVJORUwpOwor
CQkJcmMgPSAhKnZhbCA/IC1FTk9NRU0gOiAwOworCQkJZ290byBvdXQ7CisJCX0KKwl9CitvdXQ6
CisJa2ZyZWUob3JpZyk7CisJcmV0dXJuIHJjOworfQorCiAvKgogICogUGFyc2UgYSBkZXZuYW1l
IGludG8gc3Vic3RyaW5ncyBhbmQgcG9wdWxhdGUgdGhlIGN0eC0+VU5DIGFuZCBjdHgtPnByZXBh
dGgKICAqIGZpZWxkcyB3aXRoIHRoZSByZXN1bHQuIFJldHVybnMgMCBvbiBzdWNjZXNzIGFuZCBh
biBlcnJvciBvdGhlcndpc2UKLS0gCjIuMjcuMAoK
--000000000000a9692905ba01d21f--
