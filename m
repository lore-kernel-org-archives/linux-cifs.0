Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DF97EB64DC
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Jul 2023 13:26:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235217AbjGNNZ7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Jul 2023 09:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjGNNZ7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Jul 2023 09:25:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3541B6
        for <linux-cifs@vger.kernel.org>; Fri, 14 Jul 2023 06:25:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E99061D15
        for <linux-cifs@vger.kernel.org>; Fri, 14 Jul 2023 13:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991B8C433C9
        for <linux-cifs@vger.kernel.org>; Fri, 14 Jul 2023 13:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689341156;
        bh=UbbaI5tEgiitmSC5mrOaOqbTmZ7z0F9ywy6j65eSBsA=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=RWiBnm2s26o74Ex3l2GT/xO3DrNa7QFR8d9+VDIlVzhrP4AFZdinpu/Jrus+KdBxl
         zSuj8I2FWctVGEDHt68OsDRVqqYzGpXTZFZHzrh9+Jw4WzSiGjUBA3cBn2eU0P2FGU
         rctGaqY81l0hGDcY3WjMx5vkyw5BB91QeeGjR5WfxLFKjdtNLuYD0E1+7qoc2wqt2v
         hjaZC0LDcIbMQEBwoIyy6eKWQ5FMgJdoz80smNrncwr9zBn/GCBy4ksQAp/mQjYMUE
         nvcx0gTcGMmh3fL4cQ+XH+A/ViIIlf1UYFosQBS6b2z/DWQsMAiZLFXrafT0SvkEL6
         aR508BTDo7Nbg==
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-1b3c503af99so1494320fac.0
        for <linux-cifs@vger.kernel.org>; Fri, 14 Jul 2023 06:25:56 -0700 (PDT)
X-Gm-Message-State: ABy/qLakIR8jmAf1i2wXsOv2krjLOe28Q87Xt7BTgR/tQAYDUsfgJ6Pc
        zxNO3tXMW1F1aSzxsZAV+P0sbjmiTFGlLJOV02Y=
X-Google-Smtp-Source: APBJJlGIc/4qZRWSwUwsK9MdoNHKHNBbiRqfVFBRIc2BIKjGClIXgCyC+fNJpn6AMODoGoPxU8vv1sRMY183GYueOfU=
X-Received: by 2002:a05:6870:538e:b0:19f:9353:d9b0 with SMTP id
 h14-20020a056870538e00b0019f9353d9b0mr5775865oan.24.1689341155645; Fri, 14
 Jul 2023 06:25:55 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:4c7:0:b0:4e8:f6ff:2aab with HTTP; Fri, 14 Jul 2023
 06:25:55 -0700 (PDT)
In-Reply-To: <a16e9b83-415f-4a5f-a5a9-4e482a53a207@talpey.com>
References: <20230711123034.23856-1-linkinjeon@kernel.org> <cda0b3e1-840f-25f6-3147-65c7526fdd33@talpey.com>
 <CAKYAXd8_BLnOaFCpkau=u-EKcg_P1ktB3Ryg_6VirJeNDNtSxA@mail.gmail.com> <a16e9b83-415f-4a5f-a5a9-4e482a53a207@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 14 Jul 2023 22:25:55 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8i2S6zWE2XHmZhX_pRjb6cWU5Drz0XCwES2k+ZB8zAwQ@mail.gmail.com>
Message-ID: <CAKYAXd8i2S6zWE2XHmZhX_pRjb6cWU5Drz0XCwES2k+ZB8zAwQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: check if a mount point is crossed during path lookup
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, hyc.lee@gmail.com,
        atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-07-14 21:44 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 7/12/2023 7:40 PM, Namjae Jeon wrote:
>> 2023-07-13 2:23 GMT+09:00, Tom Talpey <tom@talpey.com>:
>>> On 7/11/2023 8:30 AM, Namjae Jeon wrote:
>>>> Since commit 74d7970febf7 ("ksmbd: fix racy issue from using ->d_parent
>>>> and ->d_name"),
>>>> ksmbd can not lookup cross mount points. If last component is a cross
>>>> mount point during path lookup, check if it is crossed to follow it
>>>> down.
>>>
>>> I actually thought not crossing mount points was intended, since
>>> semantics can shift if the crossing changes filesystems or fs types.
>>>
>>> Does this change somehow prevent walking out of a mount via embedded
>>> "/../" in the path? It's not obvious to me whether
>>> vfs_path_parent_lookup
>>> denies this.
>> Yes, LOOKUP_BENEATH flags protect to lookup out of share.
>>>
>>> Tom.
>>>
>>> I'm not familiar enough with the VFS protection, but does this
>> I have checked it before and now again. There is no problem.
>
> I'm still concerned about this. Crossing mount points in the server is
> completely invisible to the client, yet the semantics change radically.
Have you checked it with samba server ? This is exactly the same behavior
as samba server.

And users are also wanting exactly the same behavior as before.
https://github.com/namjaejeon/ksmbd/issues/436
>
> What if someone shares "/mnt", and proceeds to mount an ext4, a USB
> FAT32, a CD-Rom, and an NFS filesystem in subdirectories? The client
> has no clue, and will walk into them all, finding a very different
> world in each.
>
> How will Posix extensions work across this? Case sensitivity/preserving?
> Caching and locks/leases?
I didn't understand exactly your question.
And NFS also supports crossmnt, and we will be able to add 'crossmnt' parameter
in smb.conf and work crossmnt by default.

Thanks.
>
> Tom.
>> Thanks!
>>>>
>>>> Fixes: 74d7970febf7 ("ksmbd: fix racy issue from using ->d_parent and
>>>> ->d_name")
>>>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>>>> ---
>>>>    fs/smb/server/smb2pdu.c | 27 ++++++++++++--------
>>>>    fs/smb/server/vfs.c     | 56
>>>> +++++++++++++++++++++++------------------
>>>>    fs/smb/server/vfs.h     |  4 +--
>>>>    3 files changed, 49 insertions(+), 38 deletions(-)
>>>>
>>>> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
>>>> index cf8822103f50..ca276634fd58 100644
>>>> --- a/fs/smb/server/smb2pdu.c
>>>> +++ b/fs/smb/server/smb2pdu.c
>>>> @@ -2467,8 +2467,9 @@ static void smb2_update_xattrs(struct
>>>> ksmbd_tree_connect *tcon,
>>>>    	}
>>>>    }
>>>>
>>>> -static int smb2_creat(struct ksmbd_work *work, struct path *path, char
>>>> *name,
>>>> -		      int open_flags, umode_t posix_mode, bool is_dir)
>>>> +static int smb2_creat(struct ksmbd_work *work, struct path
>>>> *parent_path,
>>>> +		      struct path *path, char *name, int open_flags,
>>>> +		      umode_t posix_mode, bool is_dir)
>>>>    {
>>>>    	struct ksmbd_tree_connect *tcon = work->tcon;
>>>>    	struct ksmbd_share_config *share = tcon->share_conf;
>>>> @@ -2495,7 +2496,7 @@ static int smb2_creat(struct ksmbd_work *work,
>>>> struct path *path, char *name,
>>>>    			return rc;
>>>>    	}
>>>>
>>>> -	rc = ksmbd_vfs_kern_path_locked(work, name, 0, path, 0);
>>>> +	rc = ksmbd_vfs_kern_path_locked(work, name, 0, parent_path, path, 0);
>>>>    	if (rc) {
>>>>    		pr_err("cannot get linux path (%s), err = %d\n",
>>>>    		       name, rc);
>>>> @@ -2565,7 +2566,7 @@ int smb2_open(struct ksmbd_work *work)
>>>>    	struct ksmbd_tree_connect *tcon = work->tcon;
>>>>    	struct smb2_create_req *req;
>>>>    	struct smb2_create_rsp *rsp;
>>>> -	struct path path;
>>>> +	struct path path, parent_path;
>>>>    	struct ksmbd_share_config *share = tcon->share_conf;
>>>>    	struct ksmbd_file *fp = NULL;
>>>>    	struct file *filp = NULL;
>>>> @@ -2786,7 +2787,8 @@ int smb2_open(struct ksmbd_work *work)
>>>>    		goto err_out1;
>>>>    	}
>>>>
>>>> -	rc = ksmbd_vfs_kern_path_locked(work, name, LOOKUP_NO_SYMLINKS,
>>>> &path,
>>>> 1);
>>>> +	rc = ksmbd_vfs_kern_path_locked(work, name, LOOKUP_NO_SYMLINKS,
>>>> +					&parent_path, &path, 1);
>>>>    	if (!rc) {
>>>>    		file_present = true;
>>>>
>>>> @@ -2906,7 +2908,8 @@ int smb2_open(struct ksmbd_work *work)
>>>>
>>>>    	/*create file if not present */
>>>>    	if (!file_present) {
>>>> -		rc = smb2_creat(work, &path, name, open_flags, posix_mode,
>>>> +		rc = smb2_creat(work, &parent_path, &path, name, open_flags,
>>>> +				posix_mode,
>>>>    				req->CreateOptions & FILE_DIRECTORY_FILE_LE);
>>>>    		if (rc) {
>>>>    			if (rc == -ENOENT) {
>>>> @@ -3321,8 +3324,9 @@ int smb2_open(struct ksmbd_work *work)
>>>>
>>>>    err_out:
>>>>    	if (file_present || created) {
>>>> -		inode_unlock(d_inode(path.dentry->d_parent));
>>>> -		dput(path.dentry);
>>>> +		inode_unlock(d_inode(parent_path.dentry));
>>>> +		path_put(&path);
>>>> +		path_put(&parent_path);
>>>>    	}
>>>>    	ksmbd_revert_fsids(work);
>>>>    err_out1:
>>>> @@ -5545,7 +5549,7 @@ static int smb2_create_link(struct ksmbd_work
>>>> *work,
>>>>    			    struct nls_table *local_nls)
>>>>    {
>>>>    	char *link_name = NULL, *target_name = NULL, *pathname = NULL;
>>>> -	struct path path;
>>>> +	struct path path, parent_path;
>>>>    	bool file_present = false;
>>>>    	int rc;
>>>>
>>>> @@ -5575,7 +5579,7 @@ static int smb2_create_link(struct ksmbd_work
>>>> *work,
>>>>
>>>>    	ksmbd_debug(SMB, "target name is %s\n", target_name);
>>>>    	rc = ksmbd_vfs_kern_path_locked(work, link_name,
>>>> LOOKUP_NO_SYMLINKS,
>>>> -					&path, 0);
>>>> +					&parent_path, &path, 0);
>>>>    	if (rc) {
>>>>    		if (rc != -ENOENT)
>>>>    			goto out;
>>>> @@ -5605,8 +5609,9 @@ static int smb2_create_link(struct ksmbd_work
>>>> *work,
>>>>    		rc = -EINVAL;
>>>>    out:
>>>>    	if (file_present) {
>>>> -		inode_unlock(d_inode(path.dentry->d_parent));
>>>> +		inode_unlock(d_inode(parent_path.dentry));
>>>>    		path_put(&path);
>>>> +		path_put(&parent_path);
>>>>    	}
>>>>    	if (!IS_ERR(link_name))
>>>>    		kfree(link_name);
>>>> diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
>>>> index e35914457350..fd06d267de61 100644
>>>> --- a/fs/smb/server/vfs.c
>>>> +++ b/fs/smb/server/vfs.c
>>>> @@ -63,13 +63,13 @@ int ksmbd_vfs_lock_parent(struct dentry *parent,
>>>> struct dentry *child)
>>>>
>>>>    static int ksmbd_vfs_path_lookup_locked(struct ksmbd_share_config
>>>> *share_conf,
>>>>    					char *pathname, unsigned int flags,
>>>> +					struct path *parent_path,
>>>>    					struct path *path)
>>>>    {
>>>>    	struct qstr last;
>>>>    	struct filename *filename;
>>>>    	struct path *root_share_path = &share_conf->vfs_path;
>>>>    	int err, type;
>>>> -	struct path parent_path;
>>>>    	struct dentry *d;
>>>>
>>>>    	if (pathname[0] == '\0') {
>>>> @@ -84,7 +84,7 @@ static int ksmbd_vfs_path_lookup_locked(struct
>>>> ksmbd_share_config *share_conf,
>>>>    		return PTR_ERR(filename);
>>>>
>>>>    	err = vfs_path_parent_lookup(filename, flags,
>>>> -				     &parent_path, &last, &type,
>>>> +				     parent_path, &last, &type,
>>>>    				     root_share_path);
>>>>    	if (err) {
>>>>    		putname(filename);
>>>> @@ -92,13 +92,13 @@ static int ksmbd_vfs_path_lookup_locked(struct
>>>> ksmbd_share_config *share_conf,
>>>>    	}
>>>>
>>>>    	if (unlikely(type != LAST_NORM)) {
>>>> -		path_put(&parent_path);
>>>> +		path_put(parent_path);
>>>>    		putname(filename);
>>>>    		return -ENOENT;
>>>>    	}
>>>>
>>>> -	inode_lock_nested(parent_path.dentry->d_inode, I_MUTEX_PARENT);
>>>> -	d = lookup_one_qstr_excl(&last, parent_path.dentry, 0);
>>>> +	inode_lock_nested(parent_path->dentry->d_inode, I_MUTEX_PARENT);
>>>> +	d = lookup_one_qstr_excl(&last, parent_path->dentry, 0);
>>>>    	if (IS_ERR(d))
>>>>    		goto err_out;
>>>>
>>>> @@ -108,15 +108,20 @@ static int ksmbd_vfs_path_lookup_locked(struct
>>>> ksmbd_share_config *share_conf,
>>>>    	}
>>>>
>>>>    	path->dentry = d;
>>>> -	path->mnt = share_conf->vfs_path.mnt;
>>>> -	path_put(&parent_path);
>>>> -	putname(filename);
>>>> +	path->mnt = mntget(parent_path->mnt);
>>>> +
>>>> +	err = follow_down(path, 0);
>>>> +	if (err < 0) {
>>>> +		path_put(path);
>>>> +		goto err_out;
>>>> +	}
>>>>
>>>> +	putname(filename);
>>>>    	return 0;
>>>>
>>>>    err_out:
>>>> -	inode_unlock(parent_path.dentry->d_inode);
>>>> -	path_put(&parent_path);
>>>> +	inode_unlock(d_inode(parent_path->dentry));
>>>> +	path_put(parent_path);
>>>>    	putname(filename);
>>>>    	return -ENOENT;
>>>>    }
>>>> @@ -1194,14 +1199,14 @@ static int ksmbd_vfs_lookup_in_dir(const struct
>>>> path *dir, char *name,
>>>>     * Return:	0 on success, otherwise error
>>>>     */
>>>>    int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *name,
>>>> -			       unsigned int flags, struct path *path,
>>>> -			       bool caseless)
>>>> +			       unsigned int flags, struct path *parent_path,
>>>> +			       struct path *path, bool caseless)
>>>>    {
>>>>    	struct ksmbd_share_config *share_conf = work->tcon->share_conf;
>>>>    	int err;
>>>> -	struct path parent_path;
>>>>
>>>> -	err = ksmbd_vfs_path_lookup_locked(share_conf, name, flags, path);
>>>> +	err = ksmbd_vfs_path_lookup_locked(share_conf, name, flags,
>>>> parent_path,
>>>> +					   path);
>>>>    	if (!err)
>>>>    		return 0;
>>>>
>>>> @@ -1216,10 +1221,10 @@ int ksmbd_vfs_kern_path_locked(struct
>>>> ksmbd_work
>>>> *work, char *name,
>>>>    		path_len = strlen(filepath);
>>>>    		remain_len = path_len;
>>>>
>>>> -		parent_path = share_conf->vfs_path;
>>>> -		path_get(&parent_path);
>>>> +		*parent_path = share_conf->vfs_path;
>>>> +		path_get(parent_path);
>>>>
>>>> -		while (d_can_lookup(parent_path.dentry)) {
>>>> +		while (d_can_lookup(parent_path->dentry)) {
>>>>    			char *filename = filepath + path_len - remain_len;
>>>>    			char *next = strchrnul(filename, '/');
>>>>    			size_t filename_len = next - filename;
>>>> @@ -1228,7 +1233,7 @@ int ksmbd_vfs_kern_path_locked(struct ksmbd_work
>>>> *work, char *name,
>>>>    			if (filename_len == 0)
>>>>    				break;
>>>>
>>>> -			err = ksmbd_vfs_lookup_in_dir(&parent_path, filename,
>>>> +			err = ksmbd_vfs_lookup_in_dir(parent_path, filename,
>>>>    						      filename_len,
>>>>    						      work->conn->um);
>>>>    			if (err)
>>>> @@ -1245,8 +1250,8 @@ int ksmbd_vfs_kern_path_locked(struct ksmbd_work
>>>> *work, char *name,
>>>>    				goto out2;
>>>>    			else if (is_last)
>>>>    				goto out1;
>>>> -			path_put(&parent_path);
>>>> -			parent_path = *path;
>>>> +			path_put(parent_path);
>>>> +			*parent_path = *path;
>>>>
>>>>    			next[0] = '/';
>>>>    			remain_len -= filename_len + 1;
>>>> @@ -1254,16 +1259,17 @@ int ksmbd_vfs_kern_path_locked(struct
>>>> ksmbd_work
>>>> *work, char *name,
>>>>
>>>>    		err = -EINVAL;
>>>>    out2:
>>>> -		path_put(&parent_path);
>>>> +		path_put(parent_path);
>>>>    out1:
>>>>    		kfree(filepath);
>>>>    	}
>>>>
>>>>    	if (!err) {
>>>> -		err = ksmbd_vfs_lock_parent(parent_path.dentry, path->dentry);
>>>> -		if (err)
>>>> -			dput(path->dentry);
>>>> -		path_put(&parent_path);
>>>> +		err = ksmbd_vfs_lock_parent(parent_path->dentry, path->dentry);
>>>> +		if (err) {
>>>> +			path_put(path);
>>>> +			path_put(parent_path);
>>>> +		}
>>>>    	}
>>>>    	return err;
>>>>    }
>>>> diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
>>>> index 80039312c255..72f9fb4b48d1 100644
>>>> --- a/fs/smb/server/vfs.h
>>>> +++ b/fs/smb/server/vfs.h
>>>> @@ -115,8 +115,8 @@ int ksmbd_vfs_xattr_stream_name(char *stream_name,
>>>> char **xattr_stream_name,
>>>>    int ksmbd_vfs_remove_xattr(struct mnt_idmap *idmap,
>>>>    			   const struct path *path, char *attr_name);
>>>>    int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *name,
>>>> -			       unsigned int flags, struct path *path,
>>>> -			       bool caseless);
>>>> +			       unsigned int flags, struct path *parent_path,
>>>> +			       struct path *path, bool caseless);
>>>>    struct dentry *ksmbd_vfs_kern_path_create(struct ksmbd_work *work,
>>>>    					  const char *name,
>>>>    					  unsigned int flags,
>>>
>>
>
