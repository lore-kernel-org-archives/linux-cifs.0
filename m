Received: from smtp-fw-9105.amazon.com (smtp-fw-9105.amazon.com [207.171.188.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3E2161314;
	Wed, 26 Jun 2024 22:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719439782; cv=none; b=KZzuj0eP6z5HMuDA83BhSpl5LqxP7GToqJtyTKTtXZ94gtgX0sdG5UEP73H9tMYt1SGIKd958Rr+0EXdbsi7fvHPAWyjXKKzAFaGaAXdaBse3WQ1QdGaJ4ZjCgxD5UdkjPgHD6ghC2Mvdb+Gi0zj/XJLUP/hMM+0l0tZFRE7rDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719439782; c=relaxed/simple;
	bh=D+xB+Oi0C/651HEhU4vnKsWEvAYNxnowoeczPnfuge8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SKpU2s5iVrAnQLkqnmbWkZK6ZBjlThPUTnASaZxdK8sOCCgMtsjUhWQKeQtVro0m6GCM5hzBmVoOMq3Nc8hE8VHKhiIXUz5TuRzuUC+OtqG5lyXWIqy6dR58uOiT6cAdktRVfTKpRWYi9GpKdoc//0ntXuVAn83dnEPZtooGaM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=F5hrMTnc; arc=none smtp.client-ip=207.171.188.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="F5hrMTnc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1719439781; x=1750975781;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=k2U/Quw9quDUuxjD/Ez0XhBxQTb9c1A8Jt95/hczzEA=;
  b=F5hrMTncgYUAS9UtVEVs1pOAIFxIX0VYXRj2zDlSxPeA5ZWMmYymCTs9
   ufzRPSpaGQrBOtO2tnsf/EVEJcZWAR/72cppmxvfayI3jhTKnlOuPvO6j
   EOhVw2KdDqPaPOcgz+v2KtM2jao86AeAJt6SAaOWvguJU+I847FjskABj
   U=;
X-IronPort-AV: E=Sophos;i="6.08,268,1712620800"; 
   d="scan'208";a="736401105"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9105.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2024 22:09:34 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.10.100:54606]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.38.49:2525] with esmtp (Farcaster)
 id 6f2afe75-9bd4-4525-bd75-69512c316589; Wed, 26 Jun 2024 22:09:32 +0000 (UTC)
X-Farcaster-Flow-ID: 6f2afe75-9bd4-4525-bd75-69512c316589
Received: from EX19D026EUB004.ant.amazon.com (10.252.61.64) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Wed, 26 Jun 2024 22:09:32 +0000
Received: from 3c06303d853a (10.106.178.24) by EX19D026EUB004.ant.amazon.com
 (10.252.61.64) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.34; Wed, 26 Jun
 2024 22:09:29 +0000
Date: Wed, 26 Jun 2024 15:09:24 -0700
From: Andrew Paniakin <apanyaki@amazon.com>
To: Christian Heusel <christian@heusel.eu>
CC: <pc@cjr.nz>, <stfrench@microsoft.com>, <sashal@kernel.org>,
	<pc@manguebit.com>, <regressions@lists.linux.dev>, <stable@vger.kernel.org>,
	<linux-cifs@vger.kernel.org>, <abuehaze@amazon.com>, <simbarb@amazon.com>,
	<benh@amazon.com>
Subject: Re: [REGRESSION][BISECTED][STABLE] Commit 60e3318e3e900 in
 stable/linux-6.1.y breaks cifs client failover to another server in DFS
 namespace
Message-ID: <ZnyRlEUqgZ_m_pu-@3c06303d853a>
References: <ZnMkNzmitQdP9OIC@3c06303d853a.ant.amazon.com>
 <Znmz-Pzi4UrZxlR0@3c06303d853a.ant.amazon.com>
 <210b1da5-6b22-4dd9-a25f-8b24ba4723d4@heusel.eu>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <210b1da5-6b22-4dd9-a25f-8b24ba4723d4@heusel.eu>
X-ClientProxiedBy: EX19D041UWB001.ant.amazon.com (10.13.139.132) To
 EX19D026EUB004.ant.amazon.com (10.252.61.64)

On 25/06/2024, Christian Heusel wrote:
> On 24/06/24 10:59AM, Andrew Paniakin wrote:
> > On 19/06/2024, Andrew Paniakin wrote:
> > > Commit 60e3318e3e900 ("cifs: use fs_context for automounts") was
> > > released in v6.1.54 and broke the failover when one of the servers
> > > inside DFS becomes unavailable. We reproduced the problem on the EC2
> > > instances of different types. Reverting aforementioned commint on top of
> > > the latest stable verison v6.1.94 helps to resolve the problem.
> > > 
> > > Earliest working version is v6.2-rc1. There were two big merges of CIFS fixes:
> > > [1] and [2]. We would like to ask for the help to investigate this problem and
> > > if some of those patches need to be backported. Also, is it safe to just revert
> > > problematic commit until proper fixes/backports will be available?
> > > 
> > > We will help to do testing and confirm if fix works, but let me also list the
> > > steps we used to reproduce the problem if it will help to identify the problem:
> > > 1. Create Active Directory domain eg. 'corp.fsxtest.local' in AWS Directory
> > > Service with:
> > > - three AWS FSX file systems filesystem1..filesystem3
> > > - three Windows servers; They have DFS installed as per
> > >   https://learn.microsoft.com/en-us/windows-server/storage/dfs-namespaces/dfs-overview:
> > >     - dfs-srv1: EC2AMAZ-2EGTM59
> > >     - dfs-srv2: EC2AMAZ-1N36PRD
> > >     - dfs-srv3: EC2AMAZ-0PAUH2U 
> > > 
> > >  2. Create DFS namespace eg. 'dfs-namespace' in Windows server 2008 mode
> > >  and three folders targets in it:
> > > - referral-a mapped to filesystem1.corp.local
> > > - referral-b mapped to filesystem2.corp.local
> > > - referral-c mapped to filesystem3.corp.local
> > > - local folders dfs-srv1..dfs-srv3 in C:\DFSRoots\dfs-namespace of every
> > >   Windows server. This helps to quickly define underlying server when
> > >   DFS is mounted.
> > > 
> > > 3. Enabled cifs debug logs:
> > > ```
> > > echo 'module cifs +p' > /sys/kernel/debug/dynamic_debug/control
> > > echo 'file fs/cifs/* +p' > /sys/kernel/debug/dynamic_debug/control
> > > echo 7 > /proc/fs/cifs/cifsFYI
> > > ```
> > > 
> > > 4. Mount DFS namespace on Amazon Linux 2023 instance running any vanilla
> > > kernel v6.1.54+:
> > > ```
> > > dmesg -c &>/dev/null
> > > cd /mnt
> > > mount -t cifs -o cred=/mnt/creds,echo_interval=5 \
> > >     //corp.fsxtest.local/dfs-namespace \
> > >     ./dfs-namespace
> > > ```
> > > 
> > > 5. List DFS root, it's also required to avoid recursive mounts that happen
> > > during regular 'ls' run:
> > > ```
> > > sh -c 'ls dfs-namespace'
> > > dfs-srv2  referral-a  referral-b
> > > ```
> > > 
> > > The DFS server is EC2AMAZ-1N36PRD, it's also listed in mount:
> > > ```
> > > [root@ip-172-31-2-82 mnt]# mount | grep dfs
> > > //corp.fsxtest.local/dfs-namespace on /mnt/dfs-namespace type cifs (rw,relatime,vers=3.1.1,cache=strict,username=Admin,domain=corp.fsxtest.local,uid=0,noforceuid,gid=0,noforcegid,addr=172.31.11.26,file_mode=0755,dir_mode=0755,soft,nounix,mapposix,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=5,actimeo=1,closetimeo=1)
> > > //EC2AMAZ-1N36PRD.corp.fsxtest.local/dfs-namespace/referral-a on /mnt/dfs-namespace/referral-a type cifs (rw,relatime,vers=3.1.1,cache=strict,username=Admin,domain=corp.fsxtest.local,uid=0,noforceuid,gid=0,noforcegid,addr=172.31.12.80,file_mode=0755,dir_mode=0755,soft,nounix,mapposix,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=5,actimeo=1,closetimeo=1)
> > > ```
> > > 
> > > List files in first folder:
> > > ```
> > > sh -c 'ls dfs-namespace/referral-a'
> > > filea.txt.txt
> > > ```
> > > 
> > > 6. Shutdown DFS server-2.
> > > List DFS root again, server changed from dfs-srv2 to dfs-srv1 EC2AMAZ-2EGTM59:
> > > ```
> > > sh -c 'ls dfs-namespace'
> > > dfs-srv1  referral-a  referral-b
> > > ```
> > > 
> > > 7. Try to list files in another folder, this causes ls to fail with error:
> > > ```
> > > sh -c 'ls dfs-namespace/referral-b'
> > > ls: cannot access 'dfs-namespace/referral-b': No route to host```
> > > 
> > > Sometimes it's also 'Operation now in progress' error.
> > > 
> > > mount shows the same output:
> > > ```
> > > //corp.fsxtest.local/dfs-namespace on /mnt/dfs-namespace type cifs (rw,relatime,vers=3.1.1,cache=strict,username=Admin,domain=corp.fsxtest.local,uid=0,noforceuid,gid=0,noforcegid,addr=172.31.11.26,file_mode=0755,dir_mode=0755,soft,nounix,mapposix,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=5,actimeo=1,closetimeo=1)
> > > //EC2AMAZ-1N36PRD.corp.fsxtest.local/dfs-namespace/referral-a on /mnt/dfs-namespace/referral-a type cifs (rw,relatime,vers=3.1.1,cache=strict,username=Admin,domain=corp.fsxtest.local,uid=0,noforceuid,gid=0,noforcegid,addr=172.31.12.80,file_mode=0755,dir_mode=0755,soft,nounix,mapposix,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=5,actimeo=1,closetimeo=1)
> > > ```
> > > 
> > > I also attached kernel debug logs from this test.
> > > 
> > > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=851f657a86421
> > > [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0a924817d2ed9
> > > 
> > > Reported-by: Andrei Paniakin <apanyaki@amazon.com>
> > > Bisected-by: Simba Bonga <simbarb@amazon.com>
> > > ---
> > > 
> > > #regzbot introduced: v6.1.54..v6.2-rc1
> > 
> > 
> > Friendly reminder, did anyone had a chance to look into this report?
> > 
> 
> It seems like so far nobody had a chance to look into this report 🤔
> 
> If I understand the report correctly the regression is specific for the
> current 6.1.y stable series, so also not much the CIFS devs themselves
> can do. Maybe the stable team missed the report with the plethora of
> mail that they get.. I'll change the subject to make this more prominent
> for them.
> 
> I think a good next step would be to bisect to the commit that fixed the
> relevant issue somewhere between v6.1.54..v6.2-rc1 so the stable team
> knows what needs backporting .. You can do that somewhat like so[0]:
> 
>   $ git bisect start --term-new=fixed --term-old=unfixed
>   $ git bisect fixed v6.2-rc1
>   $ git bisect unfixed v6.1
> 
> Then you just need to carry around the commit that broke the behaviour
> for you (which could be quite some work). Maybe others also have better
> ideas on how to approach that.
> 
> A revert may be a bit more complicated as the breaking commit in seems
> to be a dependency for a commit that fixes something:
> 
>     efc0b0bcffcba ("smb: propagate error code of extract_sharename()")
>     Fixes: 70431bfd825d ("cifs: Support fscache indexing rewrite")
> 
> Cheers,
> chris
> 
> [0]: https://stackoverflow.com/a/17153598
> 
> #regzbot introduced: 062eacf57ad91b5c272f89dc964fd6dd9715ea7d
> #regzbot summary: cifs: broken failover for server inside DFS

Bisection showed that 7ad54b98fc1f ("cifs: use origin fullpath for
automounts") is a first good commit. Applying it on top of 6.1.94 fixed
the reported problem. It also passed Amazon Linux kernel regression
tests when applied on top of our latest kernel 6.1. Since the code in
6.1.92 is a bit different I updated the original patch:

From: Paulo Alcantara <pc@cjr.nz>
Date: Sun, 18 Dec 2022 14:37:32 -0300
Subject: [PATCH] cifs: use origin fullpath for automounts

commit 7ad54b98fc1f141cfb70cfe2a3d6def5a85169ff upstream.

Use TCP_Server_Info::origin_fullpath instead of cifs_tcon::tree_name
when building source paths for automounts as it will be useful for
domain-based DFS referrals where the connections and referrals would
get either re-used from the cache or re-created when chasing the dfs
link.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Andrew Paniakin <apanyaki@amazon.com>
---
 fs/smb/client/cifs_dfs_ref.c | 34 ++++++++++++++++++++++++++++++++--
 fs/smb/client/cifsproto.h    | 18 ++++++++++++++++++
 fs/smb/client/dir.c          | 21 +++++++++++++++------
 3 files changed, 65 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/cifs_dfs_ref.c b/fs/smb/client/cifs_dfs_ref.c
index 020e71fe1454e..876f9a43a99db 100644
--- a/fs/smb/client/cifs_dfs_ref.c
+++ b/fs/smb/client/cifs_dfs_ref.c
@@ -258,6 +258,31 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 	goto compose_mount_options_out;
 }
 
+static int set_dest_addr(struct smb3_fs_context *ctx, const char *full_path)
+{
+	struct sockaddr *addr = (struct sockaddr *)&ctx->dstaddr;
+	char *str_addr = NULL;
+	int rc;
+
+	rc = dns_resolve_server_name_to_ip(full_path, &str_addr, NULL);
+	if (rc < 0)
+		goto out;
+
+	rc = cifs_convert_address(addr, str_addr, strlen(str_addr));
+	if (!rc) {
+		cifs_dbg(FYI, "%s: failed to convert ip address\n", __func__);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	cifs_set_port(addr, ctx->port);
+	rc = 0;
+
+out:
+	kfree(str_addr);
+	return rc;
+}
+
 /*
  * Create a vfsmount that we can automount
  */
@@ -295,8 +320,7 @@ static struct vfsmount *cifs_dfs_do_automount(struct path *path)
 	ctx = smb3_fc2context(fc);
 
 	page = alloc_dentry_path();
-	/* always use tree name prefix */
-	full_path = build_path_from_dentry_optional_prefix(mntpt, page, true);
+	full_path = dfs_get_automount_devname(mntpt, page);
 	if (IS_ERR(full_path)) {
 		mnt = ERR_CAST(full_path);
 		goto out;
@@ -315,6 +339,12 @@ static struct vfsmount *cifs_dfs_do_automount(struct path *path)
 		goto out;
 	}
 
+	rc = set_dest_addr(ctx, full_path);
+	if (rc) {
+		mnt = ERR_PTR(rc);
+		goto out;
+	}
+
 	rc = smb3_parse_devname(full_path, ctx);
 	if (!rc)
 		mnt = fc_mount(fc);
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index f37e4da0fe405..6dbc9afd67281 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -57,8 +57,26 @@ extern void exit_cifs_idmap(void);
 extern int init_cifs_spnego(void);
 extern void exit_cifs_spnego(void);
 extern const char *build_path_from_dentry(struct dentry *, void *);
+char *__build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page,
+					       const char *tree, int tree_len,
+					       bool prefix);
 extern char *build_path_from_dentry_optional_prefix(struct dentry *direntry,
 						    void *page, bool prefix);
+static inline char *dfs_get_automount_devname(struct dentry *dentry, void *page)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_sb);
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	struct TCP_Server_Info *server = tcon->ses->server;
+
+	if (unlikely(!server->origin_fullpath))
+		return ERR_PTR(-EREMOTE);
+
+	return __build_path_from_dentry_optional_prefix(dentry, page,
+							server->origin_fullpath,
+							strlen(server->origin_fullpath),
+							true);
+}
+
 static inline void *alloc_dentry_path(void)
 {
 	return __getname();
diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 863c7bc3db86f..477302157ab3d 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -78,14 +78,13 @@ build_path_from_dentry(struct dentry *direntry, void *page)
 						      prefix);
 }
 
-char *
-build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page,
-				       bool prefix)
+char *__build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page,
+					       const char *tree, int tree_len,
+					       bool prefix)
 {
 	int dfsplen;
 	int pplen = 0;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
-	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 	char dirsep = CIFS_DIR_SEP(cifs_sb);
 	char *s;
 
@@ -93,7 +92,7 @@ build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page,
 		return ERR_PTR(-ENOMEM);
 
 	if (prefix)
-		dfsplen = strnlen(tcon->tree_name, MAX_TREE_SIZE + 1);
+		dfsplen = strnlen(tree, tree_len + 1);
 	else
 		dfsplen = 0;
 
@@ -123,7 +122,7 @@ build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page,
 	}
 	if (dfsplen) {
 		s -= dfsplen;
-		memcpy(s, tcon->tree_name, dfsplen);
+		memcpy(s, tree, dfsplen);
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) {
 			int i;
 			for (i = 0; i < dfsplen; i++) {
@@ -135,6 +134,16 @@ build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page,
 	return s;
 }
 
+char *build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page,
+					     bool prefix)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+
+	return __build_path_from_dentry_optional_prefix(direntry, page, tcon->tree_name,
+							MAX_TREE_SIZE, prefix);
+}
+
 /*
  * Don't allow path components longer than the server max.
  * Don't allow the separator character in a path component.
-- 
2.40.1

