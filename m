Return-Path: <SRS0=+dfI=23=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F14EFC33C8C
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jan 2020 23:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 407002072E
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jan 2020 23:30:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="Xw35LGc1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgAFXa0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Jan 2020 18:30:26 -0500
Received: from mx.cjr.nz ([51.158.111.142]:14990 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbgAFXaZ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 6 Jan 2020 18:30:25 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 5EFB9808C0;
        Mon,  6 Jan 2020 23:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1578353422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LhoQnbRH1BTkNCbfmcERGQNm1fEvoRPEXB+ELthyG14=;
        b=Xw35LGc103ktbDGQvf6Mac3VT27Pk5dNKWPqKwnwpFCdPpd5UDoZy4h+lEUhhrjuoQxYu+
        eLJsd8oh7Kbms7fzrrkykmbmhW4NAjfhEntrtAnzoitOsdX3HMPoYMYj+URO2X7jNRqgVQ
        OaZNCOdfXQdz6q7bOy60zgM83qyi3VqFHOJBfIm+qcmhQE33hui1kf5CccyF0ftbBSk89j
        ynPJOQVcuuiWmkoNz/2fMI6cyyFUZLdZBkLfznhm00o9ZNd9E/jqmIKd0riqwHXHU3fVRL
        MUPfOWg67PBELGVPdacpDzj60ox3J7ZDHlF8s6YSzZ40/RYlBVFuldOjsNNXUw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: cifs.upcall requests ticket for wrong host when using dfs
In-Reply-To: <VE1PR02MB55503665681374E805CA7815F53C0@VE1PR02MB5550.eurprd02.prod.outlook.com>
References: <39643d7d-2abb-14d3-ced6-c394fab9a777@prodrive-technologies.com>
 <87png0boej.fsf@cjr.nz>
 <5260c45c-0a31-168d-f9db-83bb6bd4a2cf@prodrive-technologies.com>
 <878smoqouf.fsf@cjr.nz>
 <VE1PR02MB55503665681374E805CA7815F53C0@VE1PR02MB5550.eurprd02.prod.outlook.com>
Date:   Mon, 06 Jan 2020 20:30:18 -0300
Message-ID: <87k16417ud.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Martijn,

Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com> writes:

> Hi,
>
> Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com> writes:
>
>> I tried kernel 5.4.6, including this fix, but still no luck:
>> [   25.825075] CIFS: Attempting to mount //domain.com/common
>> [   27.127925] CIFS VFS:  BAD_NETWORK_NAME: \\domain.com\common
>> [   31.406697] CIFS: Attempting to mount //DC01.domain.com/common/Pd_Std
>> [   31.414527] srv rsp padded more than expected. Length 98 not 73 for cmd:1 mid:1
>> [   31.414533] Status code returned 0xc000006d STATUS_LOGON_FAILURE
>> [   31.414537] CIFS VFS: \\DC01.domain.com Send error in SessSetup = -13
>> [   31.414544] CIFS VFS: cifs_mount failed w/return code = -13
>> [   31.414590] CIFS: Attempting to mount //DC01.domain.com/common/Pd_Std
>> [   31.422410] Status code returned 0xc000006d STATUS_LOGON_FAILURE
>> [   31.422416] CIFS VFS: \\DC01.domain.com Send error in SessSetup = -13
>> [   31.422423] CIFS VFS: cifs_mount failed w/return code = -13
>>
>> Where 4.19 prints:
>> [  132.012498] CIFS: Attempting to mount //domain.com/common
>> [  132.183038] CIFS VFS: error -2 on ioctl to get interface list
>> [  132.344343] CIFS: Attempting to mount //nas01/common$/pd_std
>
>> Thanks for testing it.
>> 
>> Could you post dmesg output of both versions with debugging enabled as per
>> instructions in [1]?
>
> I attached the traces for kernel 4.19 and 5.4, I try to access the
> subdirectory after the '=====' separator in the log.  I looks like in
> the past a different sesInfo was passed to cifs_get_spnego_key().

Thanks for the logs!

I noticed that we're passing a wrong value for "ip=" down to cifs_mount():

[   58.731307] fs/cifs/cifs_spnego.c: key description = ver=0x2;host=DC01.Prodrive.nl;ip4=10.1.1.6;sec=krb5;uid=0x2713;creduid=0x2713;user=mdg;pid=0x60b

That is,

     10.1.1.6 -> str02
     10.1.1.14 -> DC01.Prodrive.nl

which means that ip option should be set to 10.1.1.14.

cifs_mount() will not attempt to resolve the hostname in case we have a
_valid_ ip address set in the mount options, so we end up connecting to
the wrong server (str02) and then failing to authenticate.

Well, we could simply set "devname" to the resolved target (str02) and
we're done with it, but the problem with that is that it will break DFS
failover - that is, we will not be able to retry the other targets in
the referral in case we failed to connect it in cifs_mount().

I'm not entirely sure if that's the problem you're facing, but could you
please try below changes?

Thanks,
Paulo

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 41957b82d796..606f26d862dc 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -120,17 +120,17 @@ cifs_build_devname(char *nodename, const char *prepath)
 
 
 /**
- * cifs_compose_mount_options	-	creates mount options for refferral
+ * cifs_compose_mount_options	-	creates mount options for referral
  * @sb_mountdata:	parent/root DFS mount options (template)
  * @fullpath:		full path in UNC format
- * @ref:		server's referral
+ * @ref:		optional server's referral
  * @devname:		optional pointer for saving device name
  *
  * creates mount options for submount based on template options sb_mountdata
  * and replacing unc,ip,prefixpath options with ones we've got form ref_unc.
  *
  * Returns: pointer to new mount options or ERR_PTR.
- * Caller is responcible for freeing retunrned value if it is not error.
+ * Caller is responsible for freeing returned value if it is not error.
  */
 char *cifs_compose_mount_options(const char *sb_mountdata,
 				   const char *fullpath,
@@ -150,18 +150,27 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 	if (sb_mountdata == NULL)
 		return ERR_PTR(-EINVAL);
 
-	if (strlen(fullpath) - ref->path_consumed) {
-		prepath = fullpath + ref->path_consumed;
-		/* skip initial delimiter */
-		if (*prepath == '/' || *prepath == '\\')
-			prepath++;
-	}
+	if (ref) {
+		if (strlen(fullpath) - ref->path_consumed) {
+			prepath = fullpath + ref->path_consumed;
+			/* skip initial delimiter */
+			if (*prepath == '/' || *prepath == '\\')
+				prepath++;
+		}
 
-	name = cifs_build_devname(ref->node_name, prepath);
-	if (IS_ERR(name)) {
-		rc = PTR_ERR(name);
-		name = NULL;
-		goto compose_mount_options_err;
+		name = cifs_build_devname(ref->node_name, prepath);
+		if (IS_ERR(name)) {
+			rc = PTR_ERR(name);
+			name = NULL;
+			goto compose_mount_options_err;
+		}
+	} else {
+		name = cifs_build_devname((char *)fullpath, NULL);
+		if (IS_ERR(name)) {
+			rc = PTR_ERR(name);
+			name = NULL;
+			goto compose_mount_options_err;
+		}
 	}
 
 	rc = dns_resolve_server_name_to_ip(name, &srvIP);
@@ -225,6 +234,8 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 
 	if (devname)
 		*devname = name;
+	else
+		kfree(name);
 
 	/*cifs_dbg(FYI, "%s: parent mountdata: %s\n", __func__, sb_mountdata);*/
 	/*cifs_dbg(FYI, "%s: submount mountdata: %s\n", __func__, mountdata );*/
@@ -241,23 +252,23 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 }
 
 /**
- * cifs_dfs_do_refmount - mounts specified path using provided refferal
+ * cifs_dfs_do_mount - mounts specified path using DFS full path
+ *
+ * Always pass down @fullpath to smb3_do_mount() so we can use the root server
+ * to perform failover in case we failed to connect to the first target in the
+ * referral.
+ *
  * @cifs_sb:		parent/root superblock
  * @fullpath:		full path in UNC format
- * @ref:		server's referral
  */
-static struct vfsmount *cifs_dfs_do_refmount(struct dentry *mntpt,
-		struct cifs_sb_info *cifs_sb,
-		const char *fullpath, const struct dfs_info3_param *ref)
+static struct vfsmount *cifs_dfs_do_mount(struct dentry *mntpt,
+					  struct cifs_sb_info *cifs_sb,
+					  const char *fullpath)
 {
 	struct vfsmount *mnt;
 	char *mountdata;
 	char *devname;
 
-	/*
-	 * Always pass down the DFS full path to smb3_do_mount() so we
-	 * can use it later for failover.
-	 */
 	devname = kstrndup(fullpath, strlen(fullpath), GFP_KERNEL);
 	if (!devname)
 		return ERR_PTR(-ENOMEM);
@@ -266,7 +277,7 @@ static struct vfsmount *cifs_dfs_do_refmount(struct dentry *mntpt,
 
 	/* strip first '\' from fullpath */
 	mountdata = cifs_compose_mount_options(cifs_sb->mountdata,
-					       fullpath + 1, ref, NULL);
+					       fullpath + 1, NULL, NULL);
 	if (IS_ERR(mountdata)) {
 		kfree(devname);
 		return (struct vfsmount *)mountdata;
@@ -278,28 +289,16 @@ static struct vfsmount *cifs_dfs_do_refmount(struct dentry *mntpt,
 	return mnt;
 }
 
-static void dump_referral(const struct dfs_info3_param *ref)
-{
-	cifs_dbg(FYI, "DFS: ref path: %s\n", ref->path_name);
-	cifs_dbg(FYI, "DFS: node path: %s\n", ref->node_name);
-	cifs_dbg(FYI, "DFS: fl: %d, srv_type: %d\n",
-		 ref->flags, ref->server_type);
-	cifs_dbg(FYI, "DFS: ref_flags: %d, path_consumed: %d\n",
-		 ref->ref_flag, ref->path_consumed);
-}
-
 /*
  * Create a vfsmount that we can automount
  */
 static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
 {
-	struct dfs_info3_param referral = {0};
 	struct cifs_sb_info *cifs_sb;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
 	char *full_path, *root_path;
 	unsigned int xid;
-	int len;
 	int rc;
 	struct vfsmount *mnt;
 
@@ -357,7 +356,7 @@ static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
 	if (!rc) {
 		rc = dfs_cache_find(xid, ses, cifs_sb->local_nls,
 				    cifs_remap(cifs_sb), full_path + 1,
-				    &referral, NULL);
+				    NULL, NULL);
 	}
 
 	free_xid(xid);
@@ -366,26 +365,16 @@ static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
 		mnt = ERR_PTR(rc);
 		goto free_root_path;
 	}
-
-	dump_referral(&referral);
-
-	len = strlen(referral.node_name);
-	if (len < 2) {
-		cifs_dbg(VFS, "%s: Net Address path too short: %s\n",
-			 __func__, referral.node_name);
-		mnt = ERR_PTR(-EINVAL);
-		goto free_dfs_ref;
-	}
 	/*
-	 * cifs_mount() will retry every available node server in case
-	 * of failures.
+	 * OK - we were able to get and cache a referral for @full_path.
+	 *
+	 * Now, pass it down to cifs_mount() and it will retry every available
+	 * node server in case of failures - no need to do it here.
 	 */
-	mnt = cifs_dfs_do_refmount(mntpt, cifs_sb, full_path, &referral);
-	cifs_dbg(FYI, "%s: cifs_dfs_do_refmount:%s , mnt:%p\n", __func__,
-		 referral.node_name, mnt);
+	mnt = cifs_dfs_do_mount(mntpt, cifs_sb, full_path);
+	cifs_dbg(FYI, "%s: cifs_dfs_do_mount:%s , mnt:%p\n", __func__,
+		 full_path + 1, mnt);
 
-free_dfs_ref:
-	free_dfs_info_param(&referral);
 free_root_path:
 	kfree(root_path);
 free_full_path:

