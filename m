Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9D36C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 10:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8AE760F13
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 10:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240387AbhIWKnh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Sep 2021 06:43:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240314AbhIWKnh (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 23 Sep 2021 06:43:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF84A60F13
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 10:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632393725;
        bh=WI2BZBrDyd57CVK561nFNYqQ7uruojhZNHuswCp3eSM=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=EzaVDO+1EBjsaHOvdDKsuTcVh++Od5XGl45yVx3czfO0bppUfNMiiBdARp4NliFpm
         v2oRI0sOFrebvJbC7tBuw9rwqUWDr4mLIT39h5CH60Qsgziz7R6Ay1uMJGbBRqs9Cr
         o4f2IQVNefI4POMdR4fHC/QJl/B8YHP0RpL7YowzPO8cbsQg9sKm5Vta4UaAD/0wpW
         UuloB0QDkwJ88c9W42zbhhy9+hf/k8FUU+Ap9cmBHS/RnjMv3mZpzIR7j/uq2NgDcP
         HLjIsb4kLYYroYWvHY3EIZKv8xkIlcrOi88gKqIGv+2LBs9KgzY21+S1ar6gc2+MBL
         /YVn/DMx9KEBA==
Received: by mail-ot1-f52.google.com with SMTP id 5-20020a9d0685000000b0054706d7b8e5so7941150otx.3
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 03:42:05 -0700 (PDT)
X-Gm-Message-State: AOAM5311kgrgKUeT19HOH3WPJyWgAaMd608qr2A2ip6rl8HdhgGiRh95
        h/cbUBVXUsxnp6MwOAZOLQftk1KoZhzuoCRyEnA=
X-Google-Smtp-Source: ABdhPJznsRmFgo61MyXvpawkmI29xHZTg0YGVpXr5fa811bW1xuHRahJU9p58q7EruLD21DfFP3n0Ktigv3hf+EbwZ4=
X-Received: by 2002:a05:6830:24a8:: with SMTP id v8mr3527683ots.185.1632393724992;
 Thu, 23 Sep 2021 03:42:04 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Thu, 23 Sep 2021 03:42:04
 -0700 (PDT)
In-Reply-To: <20210923092459.740044-1-hyc.lee@gmail.com>
References: <20210923092459.740044-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 23 Sep 2021 19:42:04 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8ES8cC=uzeXtEyhsywVkfPuviTft=67zf-1PW7McAqbw@mail.gmail.com>
Message-ID: <CAKYAXd8ES8cC=uzeXtEyhsywVkfPuviTft=67zf-1PW7McAqbw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: use LOOKUP_BENEATH to prevent the out of share access
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Ralph Boehme <slow@samba.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-23 18:24 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> instead of removing '..' in a given path, call
> kern_path with LOOKUP_BENEATH flag to prevent
> the out of share access.
>
> ran various test on this:
> smb2-cat-async smb://127.0.0.1/homes/../out_of_share
> smb2-cat-async smb://127.0.0.1/homes/foo/../../out_of_share
> smbclient //127.0.0.1/homes -c "mkdir ../foo2"
> smbclient //127.0.0.1/homes -c "rename bar ../bar"
>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph Boehme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> ---
>  fs/ksmbd/misc.c    | 76 ++++++----------------------------------------
>  fs/ksmbd/misc.h    |  3 +-
>  fs/ksmbd/smb2pdu.c | 51 ++++++++++++++-----------------
>  fs/ksmbd/vfs.c     | 67 +++++++++++++++++++++++++---------------
>  fs/ksmbd/vfs.h     |  3 +-
>  5 files changed, 78 insertions(+), 122 deletions(-)
>
> diff --git a/fs/ksmbd/misc.c b/fs/ksmbd/misc.c
> index 3eac3c01749f..0b307ca28a19 100644
> --- a/fs/ksmbd/misc.c
> +++ b/fs/ksmbd/misc.c
> @@ -191,77 +191,19 @@ int get_nlink(struct kstat *st)
>  	return nlink;
>  }
>
> -char *ksmbd_conv_path_to_unix(char *path)
> +void ksmbd_conv_path_to_unix(char *path)
>  {
> -	size_t path_len, remain_path_len, out_path_len;
> -	char *out_path, *out_next;
> -	int i, pre_dotdot_cnt = 0, slash_cnt = 0;
> -	bool is_last;
> -
>  	strreplace(path, '\\', '/');
> -	path_len = strlen(path);
> -	remain_path_len = path_len;
> -	if (path_len == 0)
> -		return ERR_PTR(-EINVAL);
> -
> -	out_path = kzalloc(path_len + 2, GFP_KERNEL);
> -	if (!out_path)
> -		return ERR_PTR(-ENOMEM);
> -	out_path_len = 0;
> -	out_next = out_path;
> -
> -	do {
> -		char *name = path + path_len - remain_path_len;
> -		char *next = strchrnul(name, '/');
> -		size_t name_len = next - name;
> -
> -		is_last = !next[0];
> -		if (name_len == 2 && name[0] == '.' && name[1] == '.') {
> -			pre_dotdot_cnt++;
> -			/* handle the case that path ends with "/.." */
> -			if (is_last)
> -				goto follow_dotdot;
> -		} else {
> -			if (pre_dotdot_cnt) {
> -follow_dotdot:
> -				slash_cnt = 0;
> -				for (i = out_path_len - 1; i >= 0; i--) {
> -					if (out_path[i] == '/' &&
> -					    ++slash_cnt == pre_dotdot_cnt + 1)
> -						break;
> -				}
> -
> -				if (i < 0 &&
> -				    slash_cnt != pre_dotdot_cnt) {
> -					kfree(out_path);
> -					return ERR_PTR(-EINVAL);
> -				}
> -
> -				out_next = &out_path[i+1];
> -				*out_next = '\0';
> -				out_path_len = i + 1;
> -
> -			}
> -
> -			if (name_len != 0 &&
> -			    !(name_len == 1 && name[0] == '.') &&
> -			    !(name_len == 2 && name[0] == '.' && name[1] == '.')) {
> -				next[0] = '\0';
> -				sprintf(out_next, "%s/", name);
> -				out_next += name_len + 1;
> -				out_path_len += name_len + 1;
> -				next[0] = '/';
> -			}
> -			pre_dotdot_cnt = 0;
> -		}
> +}
>
> -		remain_path_len -= name_len + 1;
> -	} while (!is_last);
> +void ksmbd_strip_last_slash(char *path)
> +{
> +	int len = strlen(path);
>
> -	if (out_path_len > 0)
> -		out_path[out_path_len-1] = '\0';
> -	path[path_len] = '\0';
> -	return out_path;
> +	while (len && path[len - 1] == '/') {
> +		path[len - 1] = '\0';
> +		len--;
> +	}
>  }
>
>  void ksmbd_conv_path_to_windows(char *path)
> diff --git a/fs/ksmbd/misc.h b/fs/ksmbd/misc.h
> index b7b10139ada2..af8717d4d85b 100644
> --- a/fs/ksmbd/misc.h
> +++ b/fs/ksmbd/misc.h
> @@ -16,7 +16,8 @@ int ksmbd_validate_filename(char *filename);
>  int parse_stream_name(char *filename, char **stream_name, int *s_type);
>  char *convert_to_nt_pathname(char *filename, char *sharepath);
>  int get_nlink(struct kstat *st);
> -char *ksmbd_conv_path_to_unix(char *path);
> +void ksmbd_conv_path_to_unix(char *path);
> +void ksmbd_strip_last_slash(char *path);
>  void ksmbd_conv_path_to_windows(char *path);
>  char *ksmbd_extract_sharename(char *treename);
>  char *convert_to_unix_name(struct ksmbd_share_config *share, char *name);
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index a4b237d4042b..7c5d205bdb22 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -642,7 +642,7 @@ static char *
>  smb2_get_name(struct ksmbd_share_config *share, const char *src,
>  	      const int maxlen, struct nls_table *local_nls)
>  {
> -	char *name, *norm_name, *unixname;
> +	char *name, *unixname;
>
>  	name = smb_strndup_from_utf16(src, maxlen, 1, local_nls);
>  	if (IS_ERR(name)) {
> @@ -651,15 +651,11 @@ smb2_get_name(struct ksmbd_share_config *share, const
> char *src,
>  	}
>
>  	/* change it to absolute unix name */
> -	norm_name = ksmbd_conv_path_to_unix(name);
> -	if (IS_ERR(norm_name)) {
> -		kfree(name);
> -		return norm_name;
> -	}
> -	kfree(name);
> +	ksmbd_conv_path_to_unix(name);
> +	ksmbd_strip_last_slash(name);
>
> -	unixname = convert_to_unix_name(share, norm_name);
> -	kfree(norm_name);
> +	unixname = convert_to_unix_name(share, name);
> +	kfree(name);
>  	if (!unixname) {
>  		pr_err("can not convert absolute name\n");
>  		return ERR_PTR(-ENOMEM);
> @@ -2412,7 +2408,7 @@ static int smb2_creat(struct ksmbd_work *work, struct
> path *path, char *name,
>  			return rc;
>  	}
>
> -	rc = ksmbd_vfs_kern_path(name, 0, path, 0);
> +	rc = ksmbd_vfs_kern_path(work, name, 0, path, 0);
>  	if (rc) {
>  		pr_err("cannot get linux path (%s), err = %d\n",
>  		       name, rc);
> @@ -2487,7 +2483,7 @@ int smb2_open(struct ksmbd_work *work)
>  	struct oplock_info *opinfo;
>  	__le32 *next_ptr = NULL;
>  	int req_op_level = 0, open_flags = 0, may_flags = 0, file_info = 0;
> -	int rc = 0, len = 0;
> +	int rc = 0;
>  	int contxt_cnt = 0, query_disk_id = 0;
>  	int maximal_access_ctxt = 0, posix_ctxt = 0;
>  	int s_type = 0;
> @@ -2559,17 +2555,12 @@ int smb2_open(struct ksmbd_work *work)
>  			goto err_out1;
>  		}
>  	} else {
> -		len = strlen(share->path);
> -		ksmbd_debug(SMB, "share path len %d\n", len);
> -		name = kmalloc(len + 1, GFP_KERNEL);
> +		name = kstrdup(share->path, GFP_KERNEL);
>  		if (!name) {
>  			rsp->hdr.Status = STATUS_NO_MEMORY;
>  			rc = -ENOMEM;
>  			goto err_out1;
>  		}
> -
> -		memcpy(name, share->path, len);
> -		*(name + len) = '\0';
>  	}
>
>  	req_op_level = req->RequestedOplockLevel;
> @@ -2692,7 +2683,7 @@ int smb2_open(struct ksmbd_work *work)
>  		goto err_out1;
>  	}
>
> -	rc = ksmbd_vfs_kern_path(name, LOOKUP_NO_SYMLINKS, &path, 1);
> +	rc = ksmbd_vfs_kern_path(work, name, LOOKUP_NO_SYMLINKS, &path, 1);
>  	if (!rc) {
>  		if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE) {
>  			/*
> @@ -2721,7 +2712,7 @@ int smb2_open(struct ksmbd_work *work)
>  	}
>
>  	if (rc) {
> -		if (rc == -EACCES) {
> +		if (rc != -ENOENT) {
>  			ksmbd_debug(SMB,
>  				    "User does not have right permission\n");
>  			goto err_out;
> @@ -3229,7 +3220,7 @@ int smb2_open(struct ksmbd_work *work)
>  			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
>  		else if (rc == -EOPNOTSUPP)
>  			rsp->hdr.Status = STATUS_NOT_SUPPORTED;
> -		else if (rc == -EACCES || rc == -ESTALE)
> +		else if (rc == -EACCES || rc == -ESTALE || rc == -EXDEV)
>  			rsp->hdr.Status = STATUS_ACCESS_DENIED;
>  		else if (rc == -ENOENT)
>  			rsp->hdr.Status = STATUS_OBJECT_NAME_INVALID;
> @@ -4801,7 +4792,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work
> *work,
>  	int rc = 0, len;
>  	int fs_infoclass_size = 0;
>
> -	rc = ksmbd_vfs_kern_path(share->path, LOOKUP_NO_SYMLINKS, &path, 0);
> +	rc = ksmbd_vfs_kern_path(work, share->path, LOOKUP_NO_SYMLINKS, &path,
> 0);
>  	if (rc) {
>  		pr_err("cannot create vfs path\n");
>  		return -EIO;
> @@ -5378,10 +5369,12 @@ static int smb2_rename(struct ksmbd_work *work,
>  	}
>
>  	ksmbd_debug(SMB, "new name %s\n", new_name);
> -	rc = ksmbd_vfs_kern_path(new_name, LOOKUP_NO_SYMLINKS, &path, 1);
> -	if (rc)
> +	rc = ksmbd_vfs_kern_path(work, new_name, LOOKUP_NO_SYMLINKS, &path, 1);
> +	if (rc) {
> +		if (rc != -ENOENT)
> +			goto out;
>  		file_present = false;
> -	else
> +	} else
>  		path_put(&path);
>
>  	if (ksmbd_share_veto_filename(share, new_name)) {
> @@ -5456,10 +5449,12 @@ static int smb2_create_link(struct ksmbd_work
> *work,
>  	}
>
>  	ksmbd_debug(SMB, "target name is %s\n", target_name);
> -	rc = ksmbd_vfs_kern_path(link_name, LOOKUP_NO_SYMLINKS, &path, 0);
> -	if (rc)
> +	rc = ksmbd_vfs_kern_path(work, link_name, LOOKUP_NO_SYMLINKS, &path, 0);
> +	if (rc) {
> +		if (rc != -ENOENT)
> +			goto out;
>  		file_present = false;
> -	else
> +	} else
>  		path_put(&path);
>
>  	if (file_info->ReplaceIfExists) {
> @@ -5975,7 +5970,7 @@ int smb2_set_info(struct ksmbd_work *work)
>  	return 0;
>
>  err_out:
> -	if (rc == -EACCES || rc == -EPERM)
> +	if (rc == -EACCES || rc == -EPERM || rc == -EXDEV)
>  		rsp->hdr.Status = STATUS_ACCESS_DENIED;
>  	else if (rc == -EINVAL)
>  		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
> diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
> index 3733e4944c1d..c5ff3d1e1ca4 100644
> --- a/fs/ksmbd/vfs.c
> +++ b/fs/ksmbd/vfs.c
> @@ -19,6 +19,8 @@
>  #include <linux/sched/xacct.h>
>  #include <linux/crc32c.h>
>
> +#include "../internal.h"	/* for vfs_path_lookup */
> +
>  #include "glob.h"
>  #include "oplock.h"
>  #include "connection.h"
> @@ -1213,33 +1215,48 @@ static int ksmbd_vfs_lookup_in_dir(struct path *dir,
> char *name, size_t namelen)
>   *
>   * Return:	0 on success, otherwise error
>   */
> -int ksmbd_vfs_kern_path(char *name, unsigned int flags, struct path *path,
> -			bool caseless)
> +int ksmbd_vfs_kern_path(struct ksmbd_work *work, char *name,
> +			unsigned int flags, struct path *path, bool caseless)
>  {
> +	struct ksmbd_share_config *share_conf = work->tcon->share_conf;
> +	char *filepath;
>  	int err;
>
> -	if (name[0] != '/')
> +	/* name must start with the share path */
> +	if (strlen(name) < share_conf->path_sz ||
> +	    strncmp(name, share_conf->path, share_conf->path_sz) != 0)
>  		return -EINVAL;
> +	else if (strlen(name) == share_conf->path_sz) {
> +		*path = share_conf->vfs_path;
> +		path_get(path);
> +		return 0;
> +	}
> +
> +	filepath = kstrdup(name + share_conf->path_sz + 1,
It seems to be for skipping the share path. When converting name, we
don't need append   path name given from request to share path if we
use vfs_path_lookup(). we can also optimize convert_to_nt_pathname()
function if share path is not included in name.

Thanks!
> +			   GFP_KERNEL);
> +	if (!filepath)
> +		return -ENOMEM;
>
> -	err = kern_path(name, flags, path);
> -	if (!err)
> +	flags |= LOOKUP_BENEATH;
> +	err = vfs_path_lookup(share_conf->vfs_path.dentry,
> +			      share_conf->vfs_path.mnt,
> +			      filepath,
> +			      flags,
> +			      path);
> +	if (!err) {
> +		kfree(filepath);
>  		return 0;
> +	}
>
>  	if (caseless) {
> -		char *filepath;
>  		struct path parent;
>  		size_t path_len, remain_len;
>
> -		filepath = kstrdup(name, GFP_KERNEL);
> -		if (!filepath)
> -			return -ENOMEM;
> -
>  		path_len = strlen(filepath);
> -		remain_len = path_len - 1;
> +		remain_len = path_len;
>
> -		err = kern_path("/", flags, &parent);
> -		if (err)
> -			goto out;
> +		parent = share_conf->vfs_path;
> +		path_get(&parent);
>
>  		while (d_can_lookup(parent.dentry)) {
>  			char *filename = filepath + path_len - remain_len;
> @@ -1252,21 +1269,21 @@ int ksmbd_vfs_kern_path(char *name, unsigned int
> flags, struct path *path,
>
>  			err = ksmbd_vfs_lookup_in_dir(&parent, filename,
>  						      filename_len);
> -			if (err) {
> -				path_put(&parent);
> +			path_put(&parent);
> +			if (err)
>  				goto out;
> -			}
>
> -			path_put(&parent);
>  			next[0] = '\0';
>
> -			err = kern_path(filepath, flags, &parent);
> +			err = vfs_path_lookup(share_conf->vfs_path.dentry,
> +					      share_conf->vfs_path.mnt,
> +					      filepath,
> +					      flags,
> +					      &parent);
>  			if (err)
>  				goto out;
> -
> -			if (is_last) {
> -				path->mnt = parent.mnt;
> -				path->dentry = parent.dentry;
> +			else if (is_last) {
> +				*path = parent;
>  				goto out;
>  			}
>
> @@ -1276,9 +1293,9 @@ int ksmbd_vfs_kern_path(char *name, unsigned int
> flags, struct path *path,
>
>  		path_put(&parent);
>  		err = -EINVAL;
> -out:
> -		kfree(filepath);
>  	}
> +out:
> +	kfree(filepath);
>  	return err;
>  }
>
> diff --git a/fs/ksmbd/vfs.h b/fs/ksmbd/vfs.h
> index 85db50abdb24..7089c39e9271 100644
> --- a/fs/ksmbd/vfs.h
> +++ b/fs/ksmbd/vfs.h
> @@ -152,7 +152,8 @@ int ksmbd_vfs_xattr_stream_name(char *stream_name, char
> **xattr_stream_name,
>  				size_t *xattr_stream_name_size, int s_type);
>  int ksmbd_vfs_remove_xattr(struct user_namespace *user_ns,
>  			   struct dentry *dentry, char *attr_name);
> -int ksmbd_vfs_kern_path(char *name, unsigned int flags, struct path *path,
> +int ksmbd_vfs_kern_path(struct ksmbd_work *work,
> +			char *name, unsigned int flags, struct path *path,
>  			bool caseless);
>  int ksmbd_vfs_empty_dir(struct ksmbd_file *fp);
>  void ksmbd_vfs_set_fadvise(struct file *filp, __le32 option);
> --
> 2.25.1
>
>
