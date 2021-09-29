Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FF5BC433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 12:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CC2C613D1
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 12:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343852AbhI2MmY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 08:42:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343839AbhI2MmX (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 29 Sep 2021 08:42:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 726DB613D1
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 12:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632919242;
        bh=WAbuSeeljgQVxBKW8Hq6GZXpQg54YdsJLtq4+cRhcao=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Q/ZsRZbY7vndITZXdJGl3XjGLID/8pMX/MedrdNk2qc+hg5sDz8e6fU6v76Hw/Qnk
         BdsJkwcDlN18lVYw766FAcpzcOxJN8xkg8KCLzTpAkwnfE2Qx7sTXUlyQcLIwZKaEd
         Xo2i42MfYYsBEI/2xGeUAQUl0tx2O05VWjQIShpBj2oXBzNBrwtjBD/v6+lxCzyRHP
         1OpzqzmfVPp6QLATnY43JnErjgXpiTS7awlIpC9NGX+1TOjjgEhWc4PowFnUUZebVD
         kcU0FKjqZWCPvtDDvXPG8TbPDKH51NNRLtpstQd85ghBOvKZLa7zMhTY8E53zqQ7Ot
         VOU2apwtaNlIA==
Received: by mail-oi1-f172.google.com with SMTP id s69so2656375oie.13
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 05:40:42 -0700 (PDT)
X-Gm-Message-State: AOAM531jjlrFfY+AWZU97bW/MTv/WCIwWOcHOTNvm1FQzZfaWFhj/EcT
        zltZ3yppHvhEmMVKvQ8p4dQ/SPP/+a/iK/u1cHQ=
X-Google-Smtp-Source: ABdhPJzeYOUonZQA5Bq4HxnVuPL+kWk/XOrCPIjfBYNP6KA9p4jLH4kTNMo6pJWC1BwIbQQitTd9WvAeH5gwA+smQHY=
X-Received: by 2002:a05:6808:21a7:: with SMTP id be39mr7723764oib.138.1632919241757;
 Wed, 29 Sep 2021 05:40:41 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Wed, 29 Sep 2021 05:40:41
 -0700 (PDT)
In-Reply-To: <7f120930-27d1-831c-4697-2d41769da14d@talpey.com>
References: <20210924150616.926503-1-hyc.lee@gmail.com> <7f120930-27d1-831c-4697-2d41769da14d@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 29 Sep 2021 21:40:41 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-aC9Zfc-tsN_VSABELFdhFfE7y28gX3_B-yoTzyqCviw@mail.gmail.com>
Message-ID: <CAKYAXd-aC9Zfc-tsN_VSABELFdhFfE7y28gX3_B-yoTzyqCviw@mail.gmail.com>
Subject: Re: [PATCH v4] ksmbd: use LOOKUP_BENEATH to prevent the out of share access
To:     Tom Talpey <tom@talpey.com>
Cc:     Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Ralph Boehme <slow@samba.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-29 0:18 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 9/24/2021 11:06 AM, Hyunchul Lee wrote:
>> instead of removing '..' in a given path, call
>> kern_path with LOOKUP_BENEATH flag to prevent
>> the out of share access.
>>
>> ran various test on this:
>> smb2-cat-async smb://127.0.0.1/homes/../out_of_share
>> smb2-cat-async smb://127.0.0.1/homes/foo/../../out_of_share
>> smbclient //127.0.0.1/homes -c "mkdir ../foo2"
>> smbclient //127.0.0.1/homes -c "rename bar ../bar"
>>
>> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> Cc: Ralph Boehme <slow@samba.org>
>> Cc: Steve French <smfrench@gmail.com>
>> Cc: Namjae Jeon <linkinjeon@kernel.org>
>> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
>> ---
>> Changes from v1:
>>   - pass path of file that is relative to share to ksmbd vfs functions.
>> Changes from v2:
>>   - fix smbtorture smb2.streams.rename, smb2.streams.rename2 failure.
>> Changes from v3:
>>   - fix uninitialized variable free in ksmbd_vfs_kern_path.
>>
>>   fs/ksmbd/misc.c    | 100 ++++++-----------------------
>>   fs/ksmbd/misc.h    |   7 +-
>>   fs/ksmbd/smb2pdu.c |  74 ++++++++-------------
>>   fs/ksmbd/vfs.c     | 156 ++++++++++++++++++++++++---------------------
>>   fs/ksmbd/vfs.h     |   9 ++-
>>   5 files changed, 140 insertions(+), 206 deletions(-)
>>
>> diff --git a/fs/ksmbd/misc.c b/fs/ksmbd/misc.c
>> index 3eac3c01749f..6a19f4bc692d 100644
>> --- a/fs/ksmbd/misc.c
>> +++ b/fs/ksmbd/misc.c
>> @@ -158,25 +158,21 @@ int parse_stream_name(char *filename, char
>> **stream_name, int *s_type)
>>    * Return : windows path string or error
>>    */
>>
>> -char *convert_to_nt_pathname(char *filename, char *sharepath)
>> +char *convert_to_nt_pathname(char *filename)
>>   {
>>   	char *ab_pathname;
>> -	int len, name_len;
>>
>> -	name_len = strlen(filename);
>> -	ab_pathname = kmalloc(name_len, GFP_KERNEL);
>> -	if (!ab_pathname)
>> -		return NULL;
>> -
>> -	ab_pathname[0] = '\\';
>> -	ab_pathname[1] = '\0';
>> +	if (strlen(filename) == 0) {
>> +		ab_pathname = kmalloc(2, GFP_KERNEL);
>> +		ab_pathname[0] = '\\';
>> +		ab_pathname[1] = '\0';
>
> This converts the empty filename to "\" - the volume root!?
"\" is relative to the share. i.e. the share root.

>
>> +	} else {
>> +		ab_pathname = kstrdup(filename, GFP_KERNEL);
>> +		if (!ab_pathname)
>> +			return NULL;
>>
>> -	len = strlen(sharepath);
>> -	if (!strncmp(filename, sharepath, len) && name_len != len) {
>> -		strscpy(ab_pathname, &filename[len], name_len);
>>   		ksmbd_conv_path_to_windows(ab_pathname);
>>   	}
>> -
>>   	return ab_pathname;
>>   }
>>
>> @@ -191,77 +187,19 @@ int get_nlink(struct kstat *st)
>>   	return nlink;
>>   }
>>
>> -char *ksmbd_conv_path_to_unix(char *path)
>> +void ksmbd_conv_path_to_unix(char *path)
>>   {
>> -	size_t path_len, remain_path_len, out_path_len;
>> -	char *out_path, *out_next;
>> -	int i, pre_dotdot_cnt = 0, slash_cnt = 0;
>> -	bool is_last;
>> -
>>   	strreplace(path, '\\', '/');
>> -	path_len = strlen(path);
>> -	remain_path_len = path_len;
>> -	if (path_len == 0)
>> -		return ERR_PTR(-EINVAL);
>> -
>> -	out_path = kzalloc(path_len + 2, GFP_KERNEL);
>> -	if (!out_path)
>> -		return ERR_PTR(-ENOMEM);
>> -	out_path_len = 0;
>> -	out_next = out_path;
>> -
>> -	do {
>> -		char *name = path + path_len - remain_path_len;
>> -		char *next = strchrnul(name, '/');
>> -		size_t name_len = next - name;
>> -
>> -		is_last = !next[0];
>> -		if (name_len == 2 && name[0] == '.' && name[1] == '.') {
>> -			pre_dotdot_cnt++;
>> -			/* handle the case that path ends with "/.." */
>> -			if (is_last)
>> -				goto follow_dotdot;
>> -		} else {
>> -			if (pre_dotdot_cnt) {
>> -follow_dotdot:
>> -				slash_cnt = 0;
>> -				for (i = out_path_len - 1; i >= 0; i--) {
>> -					if (out_path[i] == '/' &&
>> -					    ++slash_cnt == pre_dotdot_cnt + 1)
>> -						break;
>> -				}
>> -
>> -				if (i < 0 &&
>> -				    slash_cnt != pre_dotdot_cnt) {
>> -					kfree(out_path);
>> -					return ERR_PTR(-EINVAL);
>> -				}
>> -
>> -				out_next = &out_path[i+1];
>> -				*out_next = '\0';
>> -				out_path_len = i + 1;
>> -
>> -			}
>> -
>> -			if (name_len != 0 &&
>> -			    !(name_len == 1 && name[0] == '.') &&
>> -			    !(name_len == 2 && name[0] == '.' && name[1] == '.')) {
>> -				next[0] = '\0';
>> -				sprintf(out_next, "%s/", name);
>> -				out_next += name_len + 1;
>> -				out_path_len += name_len + 1;
>> -				next[0] = '/';
>> -			}
>> -			pre_dotdot_cnt = 0;
>> -		}
>> +}
>>
>> -		remain_path_len -= name_len + 1;
>> -	} while (!is_last);
>> +void ksmbd_strip_last_slash(char *path)
>> +{
>> +	int len = strlen(path);
>>
>> -	if (out_path_len > 0)
>> -		out_path[out_path_len-1] = '\0';
>> -	path[path_len] = '\0';
>> -	return out_path;
>> +	while (len && path[len - 1] == '/') {
>> +		path[len - 1] = '\0';
>> +		len--;
>> +	}
>
> I guess it's intentional that "/////////" will be compacted to "/",
> but the open-coded nature of all this really troubles me.
>
>>   }
>>
>>   void ksmbd_conv_path_to_windows(char *path)
>> @@ -298,7 +236,7 @@ char *ksmbd_extract_sharename(char *treename)
>>    *
>>    * Return:	converted name on success, otherwise NULL
>>    */
>> -char *convert_to_unix_name(struct ksmbd_share_config *share, char *name)
>> +char *convert_to_unix_name(struct ksmbd_share_config *share, const char
>> *name)
>>   {
>>   	int no_slash = 0, name_len, path_len;
>>   	char *new_name;
>> diff --git a/fs/ksmbd/misc.h b/fs/ksmbd/misc.h
>> index b7b10139ada2..253366bd0951 100644
>> --- a/fs/ksmbd/misc.h
>> +++ b/fs/ksmbd/misc.h
>> @@ -14,12 +14,13 @@ struct ksmbd_file;
>>   int match_pattern(const char *str, size_t len, const char *pattern);
>>   int ksmbd_validate_filename(char *filename);
>>   int parse_stream_name(char *filename, char **stream_name, int *s_type);
>> -char *convert_to_nt_pathname(char *filename, char *sharepath);
>> +char *convert_to_nt_pathname(char *filename);
>>   int get_nlink(struct kstat *st);
>> -char *ksmbd_conv_path_to_unix(char *path);
>> +void ksmbd_conv_path_to_unix(char *path);
>> +void ksmbd_strip_last_slash(char *path);
>>   void ksmbd_conv_path_to_windows(char *path);
>>   char *ksmbd_extract_sharename(char *treename);
>> -char *convert_to_unix_name(struct ksmbd_share_config *share, char
>> *name);
>> +char *convert_to_unix_name(struct ksmbd_share_config *share, const char
>> *name);
>>
>>   #define KSMBD_DIR_INFO_ALIGNMENT	8
>>   struct ksmbd_dir_info;
>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> index 378e0b4a216d..4c799fef9883 100644
>> --- a/fs/ksmbd/smb2pdu.c
>> +++ b/fs/ksmbd/smb2pdu.c
>> @@ -643,7 +643,7 @@ static char *
>>   smb2_get_name(struct ksmbd_share_config *share, const char *src,
>>   	      const int maxlen, struct nls_table *local_nls)
>>   {
>> -	char *name, *norm_name, *unixname;
>> +	char *name;
>>
>>   	name = smb_strndup_from_utf16(src, maxlen, 1, local_nls);
>>   	if (IS_ERR(name)) {
>> @@ -651,23 +651,9 @@ smb2_get_name(struct ksmbd_share_config *share, const
>> char *src,
>>   		return name;
>>   	}
>>
>> -	/* change it to absolute unix name */
>> -	norm_name = ksmbd_conv_path_to_unix(name);
>> -	if (IS_ERR(norm_name)) {
>> -		kfree(name);
>> -		return norm_name;
>> -	}
>> -	kfree(name);
>> -
>> -	unixname = convert_to_unix_name(share, norm_name);
>> -	kfree(norm_name);
>> -	if (!unixname) {
>> -		pr_err("can not convert absolute name\n");
>> -		return ERR_PTR(-ENOMEM);
>> -	}
>> -
>> -	ksmbd_debug(SMB, "absolute name = %s\n", unixname);
>> -	return unixname;
>> +	ksmbd_conv_path_to_unix(name);
>> +	ksmbd_strip_last_slash(name);
>> +	return name;
>>   }
>>
>>   int setup_async_work(struct ksmbd_work *work, void (*fn)(void **), void
>> **arg)
>> @@ -2412,7 +2398,7 @@ static int smb2_creat(struct ksmbd_work *work,
>> struct path *path, char *name,
>>   			return rc;
>>   	}
>>
>> -	rc = ksmbd_vfs_kern_path(name, 0, path, 0);
>> +	rc = ksmbd_vfs_kern_path(work, name, 0, path, 0);
>>   	if (rc) {
>>   		pr_err("cannot get linux path (%s), err = %d\n",
>>   		       name, rc);
>> @@ -2487,7 +2473,7 @@ int smb2_open(struct ksmbd_work *work)
>>   	struct oplock_info *opinfo;
>>   	__le32 *next_ptr = NULL;
>>   	int req_op_level = 0, open_flags = 0, may_flags = 0, file_info = 0;
>> -	int rc = 0, len = 0;
>> +	int rc = 0;
>>   	int contxt_cnt = 0, query_disk_id = 0;
>>   	int maximal_access_ctxt = 0, posix_ctxt = 0;
>>   	int s_type = 0;
>> @@ -2559,17 +2545,11 @@ int smb2_open(struct ksmbd_work *work)
>>   			goto err_out1;
>>   		}
>>   	} else {
>> -		len = strlen(share->path);
>> -		ksmbd_debug(SMB, "share path len %d\n", len);
>> -		name = kmalloc(len + 1, GFP_KERNEL);
>> +		name = kstrdup("", GFP_KERNEL);
>
> This kstrdup's the empty string! Surely, this means to copy the sharepath?
>
>>   		if (!name) {
>> -			rsp->hdr.Status = STATUS_NO_MEMORY;
>>   			rc = -ENOMEM;
>>   			goto err_out1;
>>   		}
>> -
>> -		memcpy(name, share->path, len);
>> -		*(name + len) = '\0';
>>   	}
>>
>>   	req_op_level = req->RequestedOplockLevel;
>> @@ -2692,7 +2672,7 @@ int smb2_open(struct ksmbd_work *work)
>>   		goto err_out1;
>>   	}
>>
>> -	rc = ksmbd_vfs_kern_path(name, LOOKUP_NO_SYMLINKS, &path, 1);
>> +	rc = ksmbd_vfs_kern_path(work, name, LOOKUP_NO_SYMLINKS, &path, 1);
>>   	if (!rc) {
>>   		if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE) {
>>   			/*
>> @@ -2721,11 +2701,8 @@ int smb2_open(struct ksmbd_work *work)
>>   	}
>>
>>   	if (rc) {
>> -		if (rc == -EACCES) {
>> -			ksmbd_debug(SMB,
>> -				    "User does not have right permission\n");
>> +		if (rc != -ENOENT)
>>   			goto err_out;
>> -		}
>>   		ksmbd_debug(SMB, "can not get linux path for %s, rc = %d\n",
>>   			    name, rc);
>>   		rc = 0;
>> @@ -3229,7 +3206,7 @@ int smb2_open(struct ksmbd_work *work)
>>   			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
>>   		else if (rc == -EOPNOTSUPP)
>>   			rsp->hdr.Status = STATUS_NOT_SUPPORTED;
>> -		else if (rc == -EACCES || rc == -ESTALE)
>> +		else if (rc == -EACCES || rc == -ESTALE || rc == -EXDEV)
>>   			rsp->hdr.Status = STATUS_ACCESS_DENIED;
>>   		else if (rc == -ENOENT)
>>   			rsp->hdr.Status = STATUS_OBJECT_NAME_INVALID;
>> @@ -4345,8 +4322,7 @@ static int get_file_all_info(struct ksmbd_work
>> *work,
>>   		return -EACCES;
>>   	}
>>
>> -	filename = convert_to_nt_pathname(fp->filename,
>> -					  work->tcon->share_conf->path);
>> +	filename = convert_to_nt_pathname(fp->filename);
>>   	if (!filename)
>>   		return -ENOMEM;
>>
>> @@ -4801,7 +4777,7 @@ static int smb2_get_info_filesystem(struct
>> ksmbd_work *work,
>>   	int rc = 0, len;
>>   	int fs_infoclass_size = 0;
>>
>> -	rc = ksmbd_vfs_kern_path(share->path, LOOKUP_NO_SYMLINKS, &path, 0);
>> +	rc = kern_path(share->path, LOOKUP_NO_SYMLINKS, &path);
>>   	if (rc) {
>>   		pr_err("cannot create vfs path\n");
>>   		return -EIO;
>> @@ -5350,7 +5326,7 @@ static int smb2_rename(struct ksmbd_work *work,
>>   			goto out;
>>
>>   		len = strlen(new_name);
>> -		if (new_name[len - 1] != '/') {
>> +		if (len > 0 && new_name[len - 1] != '/') {
>>   			pr_err("not allow base filename in rename\n");
>>   			rc = -ESHARE;
>>   			goto out;
>> @@ -5378,11 +5354,14 @@ static int smb2_rename(struct ksmbd_work *work,
>>   	}
>>
>>   	ksmbd_debug(SMB, "new name %s\n", new_name);
>> -	rc = ksmbd_vfs_kern_path(new_name, LOOKUP_NO_SYMLINKS, &path, 1);
>> -	if (rc)
>> +	rc = ksmbd_vfs_kern_path(work, new_name, LOOKUP_NO_SYMLINKS, &path, 1);
>> +	if (rc) {
>> +		if (rc != -ENOENT)
>> +			goto out;
>>   		file_present = false;
>> -	else
>> +	} else {
>>   		path_put(&path);
>> +	}
>>
>>   	if (ksmbd_share_veto_filename(share, new_name)) {
>>   		rc = -ENOENT;
>> @@ -5456,11 +5435,14 @@ static int smb2_create_link(struct ksmbd_work
>> *work,
>>   	}
>>
>>   	ksmbd_debug(SMB, "target name is %s\n", target_name);
>> -	rc = ksmbd_vfs_kern_path(link_name, LOOKUP_NO_SYMLINKS, &path, 0);
>> -	if (rc)
>> +	rc = ksmbd_vfs_kern_path(work, link_name, LOOKUP_NO_SYMLINKS, &path,
>> 0);
>> +	if (rc) {
>> +		if (rc != -ENOENT)
>> +			goto out;
>>   		file_present = false;
>> -	else
>> +	} else {
>>   		path_put(&path);
>> +	}
>>
>>   	if (file_info->ReplaceIfExists) {
>>   		if (file_present) {
>> @@ -5618,7 +5600,7 @@ static int set_file_allocation_info(struct
>> ksmbd_work *work,
>>   		 * inode size is retained by backup inode size.
>>   		 */
>>   		size = i_size_read(inode);
>> -		rc = ksmbd_vfs_truncate(work, NULL, fp, alloc_blks * 512);
>> +		rc = ksmbd_vfs_truncate(work, fp, alloc_blks * 512);
>>   		if (rc) {
>>   			pr_err("truncate failed! filename : %s, err %d\n",
>>   			       fp->filename, rc);
>> @@ -5653,7 +5635,7 @@ static int set_end_of_file_info(struct ksmbd_work
>> *work, struct ksmbd_file *fp,
>>   	if (inode->i_sb->s_magic != MSDOS_SUPER_MAGIC) {
>>   		ksmbd_debug(SMB, "filename : %s truncated to newsize %lld\n",
>>   			    fp->filename, newsize);
>> -		rc = ksmbd_vfs_truncate(work, NULL, fp, newsize);
>> +		rc = ksmbd_vfs_truncate(work, fp, newsize);
>>   		if (rc) {
>>   			ksmbd_debug(SMB, "truncate failed! filename : %s err %d\n",
>>   				    fp->filename, rc);
>> @@ -5975,7 +5957,7 @@ int smb2_set_info(struct ksmbd_work *work)
>>   	return 0;
>>
>>   err_out:
>> -	if (rc == -EACCES || rc == -EPERM)
>> +	if (rc == -EACCES || rc == -EPERM || rc == -EXDEV)
>>   		rsp->hdr.Status = STATUS_ACCESS_DENIED;
>>   	else if (rc == -EINVAL)
>>   		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
>> diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
>> index 3733e4944c1d..b41954294d38 100644
>> --- a/fs/ksmbd/vfs.c
>> +++ b/fs/ksmbd/vfs.c
>> @@ -19,6 +19,8 @@
>>   #include <linux/sched/xacct.h>
>>   #include <linux/crc32c.h>
>>
>> +#include "../internal.h"	/* for vfs_path_lookup */
>> +
>>   #include "glob.h"
>>   #include "oplock.h"
>>   #include "connection.h"
>> @@ -44,7 +46,6 @@ static char *extract_last_component(char *path)
>>   		p++;
>>   	} else {
>>   		p = NULL;
>> -		pr_err("Invalid path %s\n", path);
>>   	}
>>   	return p;
>>   }
>> @@ -155,7 +156,7 @@ int ksmbd_vfs_query_maximal_access(struct
>> user_namespace *user_ns,
>>   /**
>>    * ksmbd_vfs_create() - vfs helper for smb create file
>>    * @work:	work
>> - * @name:	file name
>> + * @name:	file name that is relative to share
>>    * @mode:	file create mode
>>    *
>>    * Return:	0 on success, otherwise error
>> @@ -166,7 +167,8 @@ int ksmbd_vfs_create(struct ksmbd_work *work, const
>> char *name, umode_t mode)
>>   	struct dentry *dentry;
>>   	int err;
>>
>> -	dentry = kern_path_create(AT_FDCWD, name, &path, LOOKUP_NO_SYMLINKS);
>> +	dentry = ksmbd_vfs_kern_path_create(work, name,
>> +					    LOOKUP_NO_SYMLINKS, &path);
>>   	if (IS_ERR(dentry)) {
>>   		err = PTR_ERR(dentry);
>>   		if (err != -ENOENT)
>> @@ -191,7 +193,7 @@ int ksmbd_vfs_create(struct ksmbd_work *work, const
>> char *name, umode_t mode)
>>   /**
>>    * ksmbd_vfs_mkdir() - vfs helper for smb create directory
>>    * @work:	work
>> - * @name:	directory name
>> + * @name:	directory name that is relative to share
>>    * @mode:	directory create mode
>>    *
>>    * Return:	0 on success, otherwise error
>> @@ -203,8 +205,9 @@ int ksmbd_vfs_mkdir(struct ksmbd_work *work, const
>> char *name, umode_t mode)
>>   	struct dentry *dentry;
>>   	int err;
>>
>> -	dentry = kern_path_create(AT_FDCWD, name, &path,
>> -				  LOOKUP_NO_SYMLINKS | LOOKUP_DIRECTORY);
>> +	dentry = ksmbd_vfs_kern_path_create(work, name,
>> +					    LOOKUP_NO_SYMLINKS | LOOKUP_DIRECTORY,
>> +					    &path);
>>   	if (IS_ERR(dentry)) {
>>   		err = PTR_ERR(dentry);
>>   		if (err != -EEXIST)
>> @@ -579,7 +582,7 @@ int ksmbd_vfs_fsync(struct ksmbd_work *work, u64 fid,
>> u64 p_id)
>>
>>   /**
>>    * ksmbd_vfs_remove_file() - vfs helper for smb rmdir or unlink
>> - * @name:	absolute directory or file name
>> + * @name:	directory or file name that is relative to share
>>    *
>>    * Return:	0 on success, otherwise error
>>    */
>> @@ -593,7 +596,7 @@ int ksmbd_vfs_remove_file(struct ksmbd_work *work,
>> char *name)
>>   	if (ksmbd_override_fsids(work))
>>   		return -ENOMEM;
>>
>> -	err = kern_path(name, LOOKUP_NO_SYMLINKS, &path);
>> +	err = ksmbd_vfs_kern_path(work, name, LOOKUP_NO_SYMLINKS, &path,
>> false);
>>   	if (err) {
>>   		ksmbd_debug(VFS, "can't get %s, err %d\n", name, err);
>>   		ksmbd_revert_fsids(work);
>> @@ -638,7 +641,7 @@ int ksmbd_vfs_remove_file(struct ksmbd_work *work,
>> char *name)
>>   /**
>>    * ksmbd_vfs_link() - vfs helper for creating smb hardlink
>>    * @oldname:	source file name
>> - * @newname:	hardlink name
>> + * @newname:	hardlink name that is relative to share
>>    *
>>    * Return:	0 on success, otherwise error
>>    */
>> @@ -659,8 +662,9 @@ int ksmbd_vfs_link(struct ksmbd_work *work, const char
>> *oldname,
>>   		goto out1;
>>   	}
>>
>> -	dentry = kern_path_create(AT_FDCWD, newname, &newpath,
>> -				  LOOKUP_NO_SYMLINKS | LOOKUP_REVAL);
>> +	dentry = ksmbd_vfs_kern_path_create(work, newname,
>> +					    LOOKUP_NO_SYMLINKS | LOOKUP_REVAL,
>> +					    &newpath);
>>   	if (IS_ERR(dentry)) {
>>   		err = PTR_ERR(dentry);
>>   		pr_err("path create err for %s, err %d\n", newname, err);
>> @@ -781,14 +785,17 @@ int ksmbd_vfs_fp_rename(struct ksmbd_work *work,
>> struct ksmbd_file *fp,
>>   	int err;
>>
>>   	dst_name = extract_last_component(newname);
>> -	if (!dst_name)
>> -		return -EINVAL;
>> +	if (!dst_name) {
>> +		dst_name = newname;
>> +		newname = "";
>> +	}
>>
>>   	src_dent_parent = dget_parent(fp->filp->f_path.dentry);
>>   	src_dent = fp->filp->f_path.dentry;
>>
>> -	err = kern_path(newname, LOOKUP_NO_SYMLINKS | LOOKUP_DIRECTORY,
>> -			&dst_path);
>> +	err = ksmbd_vfs_kern_path(work, newname,
>> +				  LOOKUP_NO_SYMLINKS | LOOKUP_DIRECTORY,
>> +				  &dst_path, false);
>>   	if (err) {
>>   		ksmbd_debug(VFS, "Cannot get path for %s [%d]\n", newname, err);
>>   		goto out;
>> @@ -834,61 +841,43 @@ int ksmbd_vfs_fp_rename(struct ksmbd_work *work,
>> struct ksmbd_file *fp,
>>   /**
>>    * ksmbd_vfs_truncate() - vfs helper for smb file truncate
>>    * @work:	work
>> - * @name:	old filename
>>    * @fid:	file id of old file
>>    * @size:	truncate to given size
>>    *
>>    * Return:	0 on success, otherwise error
>>    */
>> -int ksmbd_vfs_truncate(struct ksmbd_work *work, const char *name,
>> +int ksmbd_vfs_truncate(struct ksmbd_work *work,
>>   		       struct ksmbd_file *fp, loff_t size)
>>   {
>> -	struct path path;
>>   	int err = 0;
>> +	struct file *filp;
>>
>> -	if (name) {
>> -		err = kern_path(name, LOOKUP_NO_SYMLINKS, &path);
>> -		if (err) {
>> -			pr_err("cannot get linux path for %s, err %d\n",
>> -			       name, err);
>> -			return err;
>> -		}
>> -		err = vfs_truncate(&path, size);
>> -		if (err)
>> -			pr_err("truncate failed for %s err %d\n",
>> -			       name, err);
>> -		path_put(&path);
>> -	} else {
>> -		struct file *filp;
>> -
>> -		filp = fp->filp;
>> -
>> -		/* Do we need to break any of a levelII oplock? */
>> -		smb_break_all_levII_oplock(work, fp, 1);
>> +	filp = fp->filp;
>>
>> -		if (!work->tcon->posix_extensions) {
>> -			struct inode *inode = file_inode(filp);
>> +	/* Do we need to break any of a levelII oplock? */
>> +	smb_break_all_levII_oplock(work, fp, 1);
>>
>> -			if (size < inode->i_size) {
>> -				err = check_lock_range(filp, size,
>> -						       inode->i_size - 1, WRITE);
>> -			} else {
>> -				err = check_lock_range(filp, inode->i_size,
>> -						       size - 1, WRITE);
>> -			}
>> +	if (!work->tcon->posix_extensions) {
>> +		struct inode *inode = file_inode(filp);
>>
>> -			if (err) {
>> -				pr_err("failed due to lock\n");
>> -				return -EAGAIN;
>> -			}
>> +		if (size < inode->i_size) {
>> +			err = check_lock_range(filp, size,
>> +					       inode->i_size - 1, WRITE);
>> +		} else {
>> +			err = check_lock_range(filp, inode->i_size,
>> +					       size - 1, WRITE);
>>   		}
>>
>> -		err = vfs_truncate(&filp->f_path, size);
>> -		if (err)
>> -			pr_err("truncate failed for filename : %s err %d\n",
>> -			       fp->filename, err);
>> +		if (err) {
>> +			pr_err("failed due to lock\n");
>> +			return -EAGAIN;
>> +		}
>>   	}
>>
>> +	err = vfs_truncate(&filp->f_path, size);
>> +	if (err)
>> +		pr_err("truncate failed for filename : %s err %d\n",
>> +		       fp->filename, err);
>>   	return err;
>>   }
>>
>> @@ -1206,22 +1195,25 @@ static int ksmbd_vfs_lookup_in_dir(struct path
>> *dir, char *name, size_t namelen)
>>
>>   /**
>>    * ksmbd_vfs_kern_path() - lookup a file and get path info
>> - * @name:	name of file for lookup
>> + * @name:	file path that is relative to share
>>    * @flags:	lookup flags
>>    * @path:	if lookup succeed, return path info
>>    * @caseless:	caseless filename lookup
>>    *
>>    * Return:	0 on success, otherwise error
>>    */
>> -int ksmbd_vfs_kern_path(char *name, unsigned int flags, struct path
>> *path,
>> -			bool caseless)
>> +int ksmbd_vfs_kern_path(struct ksmbd_work *work, char *name,
>> +			unsigned int flags, struct path *path, bool caseless)
>>   {
>> +	struct ksmbd_share_config *share_conf = work->tcon->share_conf;
>>   	int err;
>>
>> -	if (name[0] != '/')
>> -		return -EINVAL;
>> -
>> -	err = kern_path(name, flags, path);
>> +	flags |= LOOKUP_BENEATH;
>> +	err = vfs_path_lookup(share_conf->vfs_path.dentry,
>> +			      share_conf->vfs_path.mnt,
>> +			      name,
>> +			      flags,
>> +			      path);
>>   	if (!err)
>>   		return 0;
>>
>> @@ -1235,11 +1227,10 @@ int ksmbd_vfs_kern_path(char *name, unsigned int
>> flags, struct path *path,
>>   			return -ENOMEM;
>>
>>   		path_len = strlen(filepath);
>> -		remain_len = path_len - 1;
>> +		remain_len = path_len;
>>
>> -		err = kern_path("/", flags, &parent);
>> -		if (err)
>> -			goto out;
>> +		parent = share_conf->vfs_path;
>> +		path_get(&parent);
>>
>>   		while (d_can_lookup(parent.dentry)) {
>>   			char *filename = filepath + path_len - remain_len;
>> @@ -1252,21 +1243,21 @@ int ksmbd_vfs_kern_path(char *name, unsigned int
>> flags, struct path *path,
>>
>>   			err = ksmbd_vfs_lookup_in_dir(&parent, filename,
>>   						      filename_len);
>> -			if (err) {
>> -				path_put(&parent);
>> +			path_put(&parent);
>> +			if (err)
>>   				goto out;
>> -			}
>>
>> -			path_put(&parent);
>>   			next[0] = '\0';
>>
>> -			err = kern_path(filepath, flags, &parent);
>> +			err = vfs_path_lookup(share_conf->vfs_path.dentry,
>> +					      share_conf->vfs_path.mnt,
>> +					      filepath,
>> +					      flags,
>> +					      &parent);
>>   			if (err)
>>   				goto out;
>> -
>> -			if (is_last) {
>> -				path->mnt = parent.mnt;
>> -				path->dentry = parent.dentry;
>> +			else if (is_last) {
>> +				*path = parent;
>>   				goto out;
>>   			}
>>
>> @@ -1282,6 +1273,23 @@ int ksmbd_vfs_kern_path(char *name, unsigned int
>> flags, struct path *path,
>>   	return err;
>>   }
>>
>> +struct dentry *ksmbd_vfs_kern_path_create(struct ksmbd_work *work,
>> +					  const char *name,
>> +					  unsigned int flags,
>> +					  struct path *path)
>> +{
>> +	char *abs_name;
>> +	struct dentry *dent;
>> +
>> +	abs_name = convert_to_unix_name(work->tcon->share_conf, name);
>> +	if (!abs_name)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	dent = kern_path_create(AT_FDCWD, abs_name, path, flags);
>> +	kfree(abs_name);
>> +	return dent;
>> +}
>> +
>>   int ksmbd_vfs_remove_acl_xattrs(struct user_namespace *user_ns,
>>   				struct dentry *dentry)
>>   {
>> diff --git a/fs/ksmbd/vfs.h b/fs/ksmbd/vfs.h
>> index 85db50abdb24..7b1dcaa3fbdc 100644
>> --- a/fs/ksmbd/vfs.h
>> +++ b/fs/ksmbd/vfs.h
>> @@ -126,7 +126,7 @@ int ksmbd_vfs_link(struct ksmbd_work *work,
>>   int ksmbd_vfs_getattr(struct path *path, struct kstat *stat);
>>   int ksmbd_vfs_fp_rename(struct ksmbd_work *work, struct ksmbd_file *fp,
>>   			char *newname);
>> -int ksmbd_vfs_truncate(struct ksmbd_work *work, const char *name,
>> +int ksmbd_vfs_truncate(struct ksmbd_work *work,
>>   		       struct ksmbd_file *fp, loff_t size);
>>   struct srv_copychunk;
>>   int ksmbd_vfs_copy_file_ranges(struct ksmbd_work *work,
>> @@ -152,8 +152,13 @@ int ksmbd_vfs_xattr_stream_name(char *stream_name,
>> char **xattr_stream_name,
>>   				size_t *xattr_stream_name_size, int s_type);
>>   int ksmbd_vfs_remove_xattr(struct user_namespace *user_ns,
>>   			   struct dentry *dentry, char *attr_name);
>> -int ksmbd_vfs_kern_path(char *name, unsigned int flags, struct path
>> *path,
>> +int ksmbd_vfs_kern_path(struct ksmbd_work *work,
>> +			char *name, unsigned int flags, struct path *path,
>>   			bool caseless);
>> +struct dentry *ksmbd_vfs_kern_path_create(struct ksmbd_work *work,
>> +					  const char *name,
>> +					  unsigned int flags,
>> +					  struct path *path);
>>   int ksmbd_vfs_empty_dir(struct ksmbd_file *fp);
>>   void ksmbd_vfs_set_fadvise(struct file *filp, __le32 option);
>>   int ksmbd_vfs_zero_data(struct ksmbd_work *work, struct ksmbd_file *fp,
>>
>
