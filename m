Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E54C4338F
	for <linux-cifs@archiver.kernel.org>; Mon, 16 Aug 2021 23:31:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F6E660E78
	for <linux-cifs@archiver.kernel.org>; Mon, 16 Aug 2021 23:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234095AbhHPXbc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 16 Aug 2021 19:31:32 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:47047 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbhHPXbc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 16 Aug 2021 19:31:32 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210816233058epoutp029fa22423a0a70bb034a69879984c1f97~b7Vlk_pDe3249732497epoutp02M
        for <linux-cifs@vger.kernel.org>; Mon, 16 Aug 2021 23:30:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210816233058epoutp029fa22423a0a70bb034a69879984c1f97~b7Vlk_pDe3249732497epoutp02M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1629156658;
        bh=oMGoORu0fEQdFn7+bX3L7x/uvMdJv5ICgmo5zUOBjKM=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=dKfF2bVl0xxLLxfr7ibcDxqDxtq8cCZByBwySUXmT1WYu1uND5LPPFsYqpfTFf0t0
         ksnsbLTI4dMb0HtS8/bt9t3MT+dGqqunFkRszNY/5nmtvpg5ISPyQWa66W+OS0YxcH
         eHsI3oeXPQ4Oc/Xf8yaS/Ehe16mqcRnKNcWV55XA=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20210816233058epcas1p45673ca7832486ae20e21803faf40d4e0~b7VlOmhAp3052830528epcas1p4j;
        Mon, 16 Aug 2021 23:30:58 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.166]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4GpVlh65yWz4x9Q7; Mon, 16 Aug
        2021 23:30:56 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        ED.8A.09551.F25FA116; Tue, 17 Aug 2021 08:30:55 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210816233055epcas1p2b01f111bd9504ff7023b6fd8385354e6~b7Vi0FElG1544115441epcas1p2F;
        Mon, 16 Aug 2021 23:30:55 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210816233055epsmtrp2a45d9453950304d0f1c8088fdc08c1af~b7VizVOZc1441914419epsmtrp2w;
        Mon, 16 Aug 2021 23:30:55 +0000 (GMT)
X-AuditID: b6c32a36-2b3ff7000000254f-0d-611af52fde36
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        71.7F.32548.F25FA116; Tue, 17 Aug 2021 08:30:55 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210816233055epsmtip13632fdb422d787fc90420b178a835460~b7Vilj1ua0543205432epsmtip1g;
        Mon, 16 Aug 2021 23:30:55 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Christian Brauner'" <brauner@kernel.org>
Cc:     "'Sergey Senozhatsky'" <senozhatsky@chromium.org>,
        "'David Sterba'" <dsterba@suse.com>,
        "'Christian Brauner'" <christian.brauner@ubuntu.com>,
        "'Steve French'" <stfrench@microsoft.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Hyunchul Lee'" <hyc.lee@gmail.com>, <linux-cifs@vger.kernel.org>
In-Reply-To: <20210816115605.178441-1-brauner@kernel.org>
Subject: RE: [PATCH] ksmbd: fix lookup on idmapped mounts
Date:   Tue, 17 Aug 2021 08:30:55 +0900
Message-ID: <008d01d792f6$c2735f30$475a1d90$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFlJa7+H2Vr1qkTH9rCACD+U5nFJwIkQDPJrEp8x/A=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOJsWRmVeSWpSXmKPExsWy7bCmrq7+V6lEg6W7LSxeH/7EaLH1W6LF
        hR+NTBanJyxisrh2/z27xYv/u5gtdm9cxGZxa+J8NgcOj9kNF1k8ds66y+6xeYWWx6ZVnWwe
        rTv+snus33KVxePBpDeMHp83yQVwROXYZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpa
        mCsp5CXmptoqufgE6Lpl5gAdpqRQlphTChQKSCwuVtK3synKLy1JVcjILy6xVUotSMkpMDQo
        0CtOzC0uzUvXS87PtTI0MDAyBapMyMnYO/0UW8GV6Ip7kzayNTBu8Oxi5OSQEDCRODNjD1MX
        IxeHkMAORomp3f/ZQRJCAp8YJa50m0AkPjNKbFtxhwWmY+3deYwQiV2MEifuNrBAdLxglLjw
        pBrEZhPQlfj3Zz8biC0ioCdxdMMuFpAGZoFNTBIt83pZuxg5ODgFLCXaOnhAaoSBzIOnljOB
        2CwCqhK7fu9mAynhBYqv3VMPEuYVEJQ4OfMJ2CpmAXmJ7W/nMEPcoyDx8+kyVohVVhL/FjYz
        QtSISMzubGMGWSshsIND4n1DPyNEg4tE36MJUM8IS7w6voUdwpaS+PxuLxuEXS5x4uQvJgi7
        RmLDvH3sIPdICBhL9LwoATGZBTQl1u/Sh6hQlNj5ey7UWj6Jd197WCGqeSU62oQgSlQl+i4d
        hhooLdHV/oF9AqPSLCSPzULy2CwkD8xCWLaAkWUVo1hqQXFuemqxYYERckxvYgSnWC2zHYyT
        3n7QO8TIxMF4iFGCg1lJhFedQypRiDclsbIqtSg/vqg0J7X4EKMpMKQnMkuJJucDk3xeSbyh
        qZGxsbGFiZm5mamxkjjvt9ivCUIC6YklqdmpqQWpRTB9TBycUg1Mss23NVn0HGWcFlaLbPu7
        cE7TH8vcZVG/JbX37jj05Oy9G+9VzJrnVO+XfRr5LP7HraRVWo0ebzSNww54RPDkGwc17i0/
        52P7cG+2Tn/lpJVLWHtv7E+ZV2prvStmYlzBi7vzPW4Gii2weiq9rId7w2n2o3yL7hQFrA9R
        slte1H7tYubERuMWHe5nK28f95GQT7kj93jOx03eE0JfPrGs3JiZqfrq+j9LYbv80/p/mf4E
        Vi1fpTLNwovvlqXjQ+XTXH+ZjCxy5y4uMSgR+vuBK1g6acE0lyX9xecOz654wL9dx8vzlaq9
        T/DzzoXRXt+FlQ+tnLMjx95k2eHVTNU7X304ni5tXdz5cea5vKO1SizFGYmGWsxFxYkAOtt+
        iToEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsWy7bCSnK7+V6lEgwszRSxeH/7EaLH1W6LF
        hR+NTBanJyxisrh2/z27xYv/u5gtdm9cxGZxa+J8NgcOj9kNF1k8ds66y+6xeYWWx6ZVnWwe
        rTv+snus33KVxePBpDeMHp83yQVwRHHZpKTmZJalFunbJXBl7J1+iq3gSnTFvUkb2RoYN3h2
        MXJySAiYSKy9O48RxBYS2MEosW6vAURcWuLYiTPMXYwcQLawxOHDxV2MXEAlzxglFv1Yyw5S
        wyagK/Hvz342EFtEQE/i6IZdLCBFzALbmCTOXP3CCtHRxSixtu82C8gkTgFLibYOHpAGYSDz
        4KnlTCA2i4CqxK7fu9lASniB4mv31IOEeQUEJU7OfALWyQw0v20j2JnMAvIS29/OYYY4U0Hi
        59NlrBAnWEn8W9gMVSMiMbuzjXkCo/AsJJNmIUyahWTSLCQdCxhZVjFKphYU56bnFhsWGOWl
        lusVJ+YWl+al6yXn525iBMealtYOxj2rPugdYmTiYDzEKMHBrCTCq84hlSjEm5JYWZValB9f
        VJqTWnyIUZqDRUmc90LXyXghgfTEktTs1NSC1CKYLBMHp1QDk+8tQ7Zk9oM2rosVJ/6YHPpi
        1YyHlSnbnjL/st4hJV/tkiN1J3yz7wr5j+o615Ymz19S0LDzK/easFKmEqVHdx40PHNwVYgw
        lF6T7Gp1t4n7Zl71+rgke1VZizYj29+fNj8V7Fe76yFT/WvzLo5V7n9nhj15N2HC7jeqv18l
        H/2eZrxxaeBCE/Z/Yo/nGD6bUXpFW6L64u7o7ef0/R2u3tdb/km7u2JCedH+pgl8eexGTopu
        r5mWTp5W8N3szK/33/5r71t+QEGxkLnwRqyiRfr0d7qbSj7d7DgSEf/xR86ueOHrxZrN9Se3
        2q8r/mGXGO5idWdd4DKF59cndr9xCX/I+Uuq2XV5VvKUghtXPyuxFGckGmoxFxUnAgBN/aIv
        JAMAAA==
X-CMS-MailID: 20210816233055epcas1p2b01f111bd9504ff7023b6fd8385354e6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210816115835epcas1p410fb2a768b1af42d2458027de74dcd3c
References: <CGME20210816115835epcas1p410fb2a768b1af42d2458027de74dcd3c@epcas1p4.samsung.com>
        <20210816115605.178441-1-brauner@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> From: Christian Brauner <christian.brauner@ubuntu.com>
> 
> It's great that the new in-kernel ksmbd server will support idmapped mounts out of the box! However,
> lookup is currently broken. Lookup helpers such as lookup_one_len() call inode_permission() internally
> to ensure that the caller is privileged over the inode of the base dentry they are trying to lookup
> under. So the permission checking here is currently wrong.
> 
> Linux v5.15 will gain a new lookup helper lookup_one() that does take idmappings into account. I've
> added it as part of my patch series to make btrfs support idmapped mounts. The new helper is in linux-
> next as part of David's (Sterba) btrfs for-next branch as commit c972214c133b ("namei: add mapping
> aware lookup helper").
> 
> I've said it before during one of my first reviews: I would very much recommend adding fstests to [1].
> It already seems to have very rudimentary cifs support. There is a completely generic idmapped mount
> testsuite that supports idmapped mounts.
> 
> [1]: https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/
> Cc: Steve French <stfrench@microsoft.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Namjae Jeon <namjae.jeon@samsung.com>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: David Sterba <dsterba@suse.com>
> Cc: linux-cifs@vger.kernel.org
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
Hi Christian,

> I merged David's for-next tree into cifsd-next to test this. I did only compile test this. If someone
> gives me a clear set of instructions how to test ksmbd on my local machine I can at least try to cut
> some time out of my week to do more reviews. (I'd especially like to see acl behavior with ksmbd.)

There is "How to run ksmbd" section in patch cover letter.
 https://lkml.org/lkml/2021/8/5/54

Let me know if it doesn't work well even if you try to run it with this step.
And We will also check whether your patch work fine.

> 
> One more thing, the tree for ksmbd was very hard to find. I had to do a lot archeology to end up at:
> 
> git://git.samba.org/ksmbd.git
This is also in the patch cover letter. See "Mailing list and repositories" section.
I think that you can use :
    https://github.com/namjaejeon/smb3-kernel/tree/ksmbd-v7-series

> 
> Would be appreciated if this tree could be reflected in MAINTAINERS or somewhere else. The github
> repos with the broken out patches/module aren't really that helpful.
Okay, I will add git address of ksmbd in MAINTAINERS on next spin.

> 
> Thanks!
> Christian
Really thanks for your review and I will apply this patch after checking it.

> ---
>  fs/ksmbd/smb2pdu.c | 18 +++++++++++-------
>  fs/ksmbd/vfs.c     | 43 ++++++++++++++++++++++++-------------------
>  fs/ksmbd/vfs.h     |  3 ++-
>  3 files changed, 37 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c index 636570ecfa31..9a1a9a024714 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -3539,9 +3539,9 @@ static int process_query_dir_entries(struct smb2_query_dir_private *priv)
>  			return -EINVAL;
> 
>  		lock_dir(priv->dir_fp);
> -		dent = lookup_one_len(priv->d_info->name,
> -				      priv->dir_fp->filp->f_path.dentry,
> -				      priv->d_info->name_len);
> +		dent = lookup_one(user_ns, priv->d_info->name,
> +				  priv->dir_fp->filp->f_path.dentry,
> +				  priv->d_info->name_len);
>  		unlock_dir(priv->dir_fp);
> 
>  		if (IS_ERR(dent)) {
> @@ -5242,7 +5242,9 @@ int smb2_echo(struct ksmbd_work *work)
>  	return 0;
>  }
> 
> -static int smb2_rename(struct ksmbd_work *work, struct ksmbd_file *fp,
> +static int smb2_rename(struct ksmbd_work *work,
> +		       struct ksmbd_file *fp,
> +		       struct user_namespace *user_ns,
>  		       struct smb2_file_rename_info *file_info,
>  		       struct nls_table *local_nls)
>  {
> @@ -5306,7 +5308,7 @@ static int smb2_rename(struct ksmbd_work *work, struct ksmbd_file *fp,
>  		if (rc)
>  			goto out;
> 
> -		rc = ksmbd_vfs_setxattr(file_mnt_user_ns(fp->filp),
> +		rc = ksmbd_vfs_setxattr(user_ns,
>  					fp->filp->f_path.dentry,
>  					xattr_stream_name,
>  					NULL, 0, 0);
> @@ -5620,6 +5622,7 @@ static int set_end_of_file_info(struct ksmbd_work *work, struct ksmbd_file *fp,
> static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file *fp,
>  			   char *buf)
>  {
> +	struct user_namespace *user_ns;
>  	struct ksmbd_file *parent_fp;
>  	struct dentry *parent;
>  	struct dentry *dentry = fp->filp->f_path.dentry; @@ -5633,8 +5636,9 @@ static int
> set_rename_info(struct ksmbd_work *work, struct ksmbd_file *fp,
>  	if (ksmbd_stream_fd(fp))
>  		goto next;
> 
> +	user_ns = file_mnt_user_ns(fp->filp);
>  	parent = dget_parent(dentry);
> -	ret = ksmbd_vfs_lock_parent(parent, dentry);
> +	ret = ksmbd_vfs_lock_parent(user_ns, parent, dentry);
>  	if (ret) {
>  		dput(parent);
>  		return ret;
> @@ -5651,7 +5655,7 @@ static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file *fp,
>  		}
>  	}
>  next:
> -	return smb2_rename(work, fp,
> +	return smb2_rename(work, fp, user_ns,
>  			   (struct smb2_file_rename_info *)buf,
>  			   work->sess->conn->local_nls);
>  }
> diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c index 612c52d7a01b..8000ea3ade10 100644
> --- a/fs/ksmbd/vfs.c
> +++ b/fs/ksmbd/vfs.c
> @@ -69,14 +69,15 @@ static void ksmbd_vfs_inherit_owner(struct ksmbd_work *work,
>   *
>   * the reference count of @parent isn't incremented.
>   */
> -int ksmbd_vfs_lock_parent(struct dentry *parent, struct dentry *child)
> +int ksmbd_vfs_lock_parent(struct user_namespace *user_ns, struct dentry *parent,
> +			  struct dentry *child)
>  {
>  	struct dentry *dentry;
>  	int ret = 0;
> 
>  	inode_lock_nested(d_inode(parent), I_MUTEX_PARENT);
> -	dentry = lookup_one_len(child->d_name.name, parent,
> -				child->d_name.len);
> +	dentry = lookup_one(user_ns, child->d_name.name, parent,
> +			    child->d_name.len);
>  	if (IS_ERR(dentry)) {
>  		ret = PTR_ERR(dentry);
>  		goto out_err;
> @@ -102,7 +103,7 @@ int ksmbd_vfs_may_delete(struct user_namespace *user_ns,
>  	int ret;
> 
>  	parent = dget_parent(dentry);
> -	ret = ksmbd_vfs_lock_parent(parent, dentry);
> +	ret = ksmbd_vfs_lock_parent(user_ns, parent, dentry);
>  	if (ret) {
>  		dput(parent);
>  		return ret;
> @@ -137,7 +138,7 @@ int ksmbd_vfs_query_maximal_access(struct user_namespace *user_ns,
>  		*daccess |= FILE_EXECUTE_LE;
> 
>  	parent = dget_parent(dentry);
> -	ret = ksmbd_vfs_lock_parent(parent, dentry);
> +	ret = ksmbd_vfs_lock_parent(user_ns, parent, dentry);
>  	if (ret) {
>  		dput(parent);
>  		return ret;
> @@ -197,6 +198,7 @@ int ksmbd_vfs_create(struct ksmbd_work *work, const char *name, umode_t mode)
>   */
>  int ksmbd_vfs_mkdir(struct ksmbd_work *work, const char *name, umode_t mode)  {
> +	struct user_namespace *user_ns;
>  	struct path path;
>  	struct dentry *dentry;
>  	int err;
> @@ -210,16 +212,16 @@ int ksmbd_vfs_mkdir(struct ksmbd_work *work, const char *name, umode_t mode)
>  		return err;
>  	}
> 
> +	user_ns = mnt_user_ns(path.mnt);
>  	mode |= S_IFDIR;
> -	err = vfs_mkdir(mnt_user_ns(path.mnt), d_inode(path.dentry),
> -			dentry, mode);
> +	err = vfs_mkdir(user_ns, d_inode(path.dentry), dentry, mode);
>  	if (err) {
>  		goto out;
>  	} else if (d_unhashed(dentry)) {
>  		struct dentry *d;
> 
> -		d = lookup_one_len(dentry->d_name.name, dentry->d_parent,
> -				   dentry->d_name.len);
> +		d = lookup_one(user_ns, dentry->d_name.name, dentry->d_parent,
> +			       dentry->d_name.len);
>  		if (IS_ERR(d)) {
>  			err = PTR_ERR(d);
>  			goto out;
> @@ -582,6 +584,7 @@ int ksmbd_vfs_fsync(struct ksmbd_work *work, u64 fid, u64 p_id)
>   */
>  int ksmbd_vfs_remove_file(struct ksmbd_work *work, char *name)  {
> +	struct user_namespace *user_ns;
>  	struct path path;
>  	struct dentry *parent;
>  	int err;
> @@ -601,8 +604,9 @@ int ksmbd_vfs_remove_file(struct ksmbd_work *work, char *name)
>  		return err;
>  	}
> 
> +	user_ns = mnt_user_ns(path.mnt);
>  	parent = dget_parent(path.dentry);
> -	err = ksmbd_vfs_lock_parent(parent, path.dentry);
> +	err = ksmbd_vfs_lock_parent(user_ns, parent, path.dentry);
>  	if (err) {
>  		dput(parent);
>  		path_put(&path);
> @@ -616,14 +620,12 @@ int ksmbd_vfs_remove_file(struct ksmbd_work *work, char *name)
>  	}
> 
>  	if (S_ISDIR(d_inode(path.dentry)->i_mode)) {
> -		err = vfs_rmdir(mnt_user_ns(path.mnt), d_inode(parent),
> -				path.dentry);
> +		err = vfs_rmdir(user_ns, d_inode(parent), path.dentry);
>  		if (err && err != -ENOTEMPTY)
>  			ksmbd_debug(VFS, "%s: rmdir failed, err %d\n", name,
>  				    err);
>  	} else {
> -		err = vfs_unlink(mnt_user_ns(path.mnt), d_inode(parent),
> -				 path.dentry, NULL);
> +		err = vfs_unlink(user_ns, d_inode(parent), path.dentry, NULL);
>  		if (err)
>  			ksmbd_debug(VFS, "%s: unlink failed, err %d\n", name,
>  				    err);
> @@ -748,7 +750,8 @@ static int __ksmbd_vfs_rename(struct ksmbd_work *work,
>  	if (ksmbd_override_fsids(work))
>  		return -ENOMEM;
> 
> -	dst_dent = lookup_one_len(dst_name, dst_dent_parent, strlen(dst_name));
> +	dst_dent = lookup_one(dst_user_ns, dst_name, dst_dent_parent,
> +			      strlen(dst_name));
>  	err = PTR_ERR(dst_dent);
>  	if (IS_ERR(dst_dent)) {
>  		pr_err("lookup failed %s [%d]\n", dst_name, err); @@ -779,6 +782,7 @@ static int
> __ksmbd_vfs_rename(struct ksmbd_work *work,  int ksmbd_vfs_fp_rename(struct ksmbd_work *work, struct
> ksmbd_file *fp,
>  			char *newname)
>  {
> +	struct user_namespace *user_ns;
>  	struct path dst_path;
>  	struct dentry *src_dent_parent, *dst_dent_parent;
>  	struct dentry *src_dent, *trap_dent, *src_child; @@ -808,8 +812,9 @@ int
> ksmbd_vfs_fp_rename(struct ksmbd_work *work, struct ksmbd_file *fp,
>  	trap_dent = lock_rename(src_dent_parent, dst_dent_parent);
>  	dget(src_dent);
>  	dget(dst_dent_parent);
> -	src_child = lookup_one_len(src_dent->d_name.name, src_dent_parent,
> -				   src_dent->d_name.len);
> +	user_ns = file_mnt_user_ns(fp->filp);
> +	src_child = lookup_one(user_ns, src_dent->d_name.name, src_dent_parent,
> +			       src_dent->d_name.len);
>  	if (IS_ERR(src_child)) {
>  		err = PTR_ERR(src_child);
>  		goto out_lock;
> @@ -823,7 +828,7 @@ int ksmbd_vfs_fp_rename(struct ksmbd_work *work, struct ksmbd_file *fp,
>  	dput(src_child);
> 
>  	err = __ksmbd_vfs_rename(work,
> -				 file_mnt_user_ns(fp->filp),
> +				 user_ns,
>  				 src_dent_parent,
>  				 src_dent,
>  				 mnt_user_ns(dst_path.mnt),
> @@ -1109,7 +1114,7 @@ int ksmbd_vfs_unlink(struct user_namespace *user_ns,  {
>  	int err = 0;
> 
> -	err = ksmbd_vfs_lock_parent(dir, dentry);
> +	err = ksmbd_vfs_lock_parent(user_ns, dir, dentry);
>  	if (err)
>  		return err;
>  	dget(dentry);
> diff --git a/fs/ksmbd/vfs.h b/fs/ksmbd/vfs.h index cb0cba0d5d07..85db50abdb24 100644
> --- a/fs/ksmbd/vfs.h
> +++ b/fs/ksmbd/vfs.h
> @@ -107,7 +107,8 @@ struct ksmbd_kstat {
>  	__le32			file_attributes;
>  };
> 
> -int ksmbd_vfs_lock_parent(struct dentry *parent, struct dentry *child);
> +int ksmbd_vfs_lock_parent(struct user_namespace *user_ns, struct dentry *parent,
> +			  struct dentry *child);
>  int ksmbd_vfs_may_delete(struct user_namespace *user_ns, struct dentry *dentry);  int
> ksmbd_vfs_query_maximal_access(struct user_namespace *user_ns,
>  				   struct dentry *dentry, __le32 *daccess);
> 
> base-commit: 456af438ad490bac7ed954cb929bcec1df7f0c82
> --
> 2.30.2


