Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61EE6C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 14:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 484EA60F9E
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 14:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233486AbhIUOYo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 10:24:44 -0400
Received: from p3plsmtpa07-01.prod.phx3.secureserver.net ([173.201.192.230]:42276
        "EHLO p3plsmtpa07-01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233461AbhIUOYo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 21 Sep 2021 10:24:44 -0400
Received: from [192.168.0.100] ([173.76.240.186])
        by :SMTPAUTH: with ESMTPSA
        id SgfzmbVKJeK1DSgfzmZ9vW; Tue, 21 Sep 2021 07:23:16 -0700
X-CMAE-Analysis: v=2.4 cv=HP8Gqqhv c=1 sm=1 tr=0 ts=6149ead4
 a=jWrLioA5F7WmVvax94MGYQ==:117 a=jWrLioA5F7WmVvax94MGYQ==:17
 a=IkcTkHD0fZMA:10 a=pGLkceISAAAA:8 a=hGzw-44bAAAA:8 a=VwQbUJbxAAAA:8
 a=L6e78o0o4C5zqyY93q4A:9 a=QEXdDO2ut3YA:10 a=HvKuF1_PTVFglORKqfwH:22
 a=AjGcO6oz07-iQ99wixmX:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH v2 1/4] ksmbd: add request buffer validation in
 smb2_set_info
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?Q?Ralph_B=c3=b6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>
References: <20210919021315.642856-1-linkinjeon@kernel.org>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <890f7c14-b0b9-12e1-8d2e-e1ca5fb9c2d5@talpey.com>
Date:   Tue, 21 Sep 2021 10:23:15 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210919021315.642856-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfDQt4j2zZL01/5onToP4Sk9WU+TTVvIxOXxV8Gtefd7qK+YgdDfTecVvLAZIN3L76ie6C3lC4oxLPfcfQCjB5VdXsOB3QokD+tn6hcuGa2fYG2GZXc2p
 znROPWYe534O//YtJDnLVig5JRZhwx8doVF2Jw8nomrwWTLPn6gycUfdGWu1gN4YvPzL1ylDuQVlBg43/+0CmDuHiqbq9++EJMIbKOQ1PiqYz8zvhLT8f61f
 OqM8xIrhWnHN5tVGpUSV8Fo9zBXlztyyxdA658jLoW6lYGHFiT5lBaq6ZVVtmYWVk7ZAs0YNIGvHtdQg2R9QYA==
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/18/2021 10:13 PM, Namjae Jeon wrote:
> Add buffer validation in smb2_set_info.
> 
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph Böhme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   fs/ksmbd/smb2pdu.c | 113 +++++++++++++++++++++++++++++++++++----------
>   fs/ksmbd/smb2pdu.h |   9 ++++
>   2 files changed, 97 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 46e0275a77a8..7763f69e1ae8 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -2107,17 +2107,23 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
>    * smb2_set_ea() - handler for setting extended attributes using set
>    *		info command
>    * @eabuf:	set info command buffer
> + * @buf_len:	set info command buffer length
>    * @path:	dentry path for get ea
>    *
>    * Return:	0 on success, otherwise error
>    */
> -static int smb2_set_ea(struct smb2_ea_info *eabuf, struct path *path)
> +static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
> +		       struct path *path)
>   {
>   	struct user_namespace *user_ns = mnt_user_ns(path->mnt);
>   	char *attr_name = NULL, *value;
>   	int rc = 0;
>   	int next = 0;
>   
> +	if (buf_len < sizeof(struct smb2_ea_info) + eabuf->EaNameLength +
> +			le16_to_cpu(eabuf->EaValueLength))
> +		return -EINVAL;

How certain is it that EaNameLength and EaValueLength are sane? One
might imagine a forged packet with various combinations of invalid
values, which arithmetically satisfy the above check...

> +
>   	attr_name = kmalloc(XATTR_NAME_MAX + 1, GFP_KERNEL);
>   	if (!attr_name)
>   		return -ENOMEM;
> @@ -2181,7 +2187,13 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, struct path *path)
>   
>   next:
>   		next = le32_to_cpu(eabuf->NextEntryOffset);
> +		if (next == 0 || buf_len < next)
> +			break;
> +		buf_len -= next;

Because buf_len is unsigned int and next is signed int, these compares
are risky. I think "next" should also be unsigned, but if not, testing
it for negative values before these checks is important.

In the many changes below, buf_len is passed in as signed. Those should
be consistent with the same criteria. It pays to be paranoid everywhere!

Tom.

>   		eabuf = (struct smb2_ea_info *)((char *)eabuf + next);
> +		if (next < eabuf->EaNameLength + le16_to_cpu(eabuf->EaValueLength))
> +			break;
> +
>   	} while (next != 0);
>   
>   	kfree(attr_name);
> @@ -2790,7 +2802,9 @@ int smb2_open(struct ksmbd_work *work)
>   		created = true;
>   		user_ns = mnt_user_ns(path.mnt);
>   		if (ea_buf) {
> -			rc = smb2_set_ea(&ea_buf->ea, &path);
> +			rc = smb2_set_ea(&ea_buf->ea,
> +					 le32_to_cpu(ea_buf->ccontext.DataLength),
> +					 &path);

Again, is DataLength verified?

>   			if (rc == -EOPNOTSUPP)
>   				rc = 0;
>   			else if (rc)
> @@ -5375,7 +5389,7 @@ static int smb2_rename(struct ksmbd_work *work,
>   static int smb2_create_link(struct ksmbd_work *work,
>   			    struct ksmbd_share_config *share,
>   			    struct smb2_file_link_info *file_info,
> -			    struct file *filp,
> +			    int buf_len, struct file *filp,
>   			    struct nls_table *local_nls)
>   {
>   	char *link_name = NULL, *target_name = NULL, *pathname = NULL;
> @@ -5383,6 +5397,10 @@ static int smb2_create_link(struct ksmbd_work *work,
>   	bool file_present = true;
>   	int rc;
>   
> +	if (buf_len < sizeof(struct smb2_file_link_info) +
> +			le32_to_cpu(file_info->FileNameLength))
> +		return -EINVAL;
> +
>   	ksmbd_debug(SMB, "setting FILE_LINK_INFORMATION\n");
>   	pathname = kmalloc(PATH_MAX, GFP_KERNEL);
>   	if (!pathname)
> @@ -5442,7 +5460,7 @@ static int smb2_create_link(struct ksmbd_work *work,
>   static int set_file_basic_info(struct ksmbd_file *fp, char *buf,
>   			       struct ksmbd_share_config *share)
>   {
> -	struct smb2_file_all_info *file_info;
> +	struct smb2_file_basic_info *file_info;
>   	struct iattr attrs;
>   	struct timespec64 ctime;
>   	struct file *filp;
> @@ -5453,7 +5471,7 @@ static int set_file_basic_info(struct ksmbd_file *fp, char *buf,
>   	if (!(fp->daccess & FILE_WRITE_ATTRIBUTES_LE))
>   		return -EACCES;
>   
> -	file_info = (struct smb2_file_all_info *)buf;
> +	file_info = (struct smb2_file_basic_info *)buf;
>   	attrs.ia_valid = 0;
>   	filp = fp->filp;
>   	inode = file_inode(filp);
> @@ -5619,7 +5637,8 @@ static int set_end_of_file_info(struct ksmbd_work *work, struct ksmbd_file *fp,
>   }
>   
>   static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file *fp,
> -			   char *buf)
> +			   struct smb2_file_rename_info *rename_info,
> +			   int buf_len)
>   {
>   	struct user_namespace *user_ns;
>   	struct ksmbd_file *parent_fp;
> @@ -5632,6 +5651,10 @@ static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file *fp,
>   		return -EACCES;
>   	}
>   
> +	if (buf_len < sizeof(struct smb2_file_rename_info) +
> +			le32_to_cpu(rename_info->FileNameLength))
> +		return -EINVAL;
> +
>   	user_ns = file_mnt_user_ns(fp->filp);
>   	if (ksmbd_stream_fd(fp))
>   		goto next;
> @@ -5654,8 +5677,7 @@ static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file *fp,
>   		}
>   	}
>   next:
> -	return smb2_rename(work, fp, user_ns,
> -			   (struct smb2_file_rename_info *)buf,
> +	return smb2_rename(work, fp, user_ns, rename_info,
>   			   work->sess->conn->local_nls);
>   }
>   
> @@ -5741,40 +5763,71 @@ static int set_file_mode_info(struct ksmbd_file *fp, char *buf)
>    * TODO: need to implement an error handling for STATUS_INFO_LENGTH_MISMATCH
>    */
>   static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
> -			      int info_class, char *buf,
> +			      struct smb2_set_info_req *req,
>   			      struct ksmbd_share_config *share)
>   {
> -	switch (info_class) {
> +	int buf_len = le32_to_cpu(req->BufferLength);
> +
> +	switch (req->FileInfoClass) {
>   	case FILE_BASIC_INFORMATION:
> -		return set_file_basic_info(fp, buf, share);
> +	{
> +		if (buf_len < sizeof(struct smb2_file_basic_info))
> +			return -EINVAL;
>   
> +		return set_file_basic_info(fp, req->Buffer, share);
> +	}
>   	case FILE_ALLOCATION_INFORMATION:
> -		return set_file_allocation_info(work, fp, buf);
> +	{
> +		if (buf_len < sizeof(struct smb2_file_alloc_info))
> +			return -EINVAL;
>   
> +		return set_file_allocation_info(work, fp, req->Buffer);
> +	}
>   	case FILE_END_OF_FILE_INFORMATION:
> -		return set_end_of_file_info(work, fp, buf);
> +	{
> +		if (buf_len < sizeof(struct smb2_file_eof_info))
> +			return -EINVAL;
>   
> +		return set_end_of_file_info(work, fp, req->Buffer);
> +	}
>   	case FILE_RENAME_INFORMATION:
> +	{
>   		if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
>   			ksmbd_debug(SMB,
>   				    "User does not have write permission\n");
>   			return -EACCES;
>   		}
> -		return set_rename_info(work, fp, buf);
>   
> +		if (buf_len < sizeof(struct smb2_file_rename_info))
> +			return -EINVAL;
> +
> +		return set_rename_info(work, fp,
> +				       (struct smb2_file_rename_info *)req->Buffer,
> +				       buf_len);
> +	}
>   	case FILE_LINK_INFORMATION:
> +	{
> +		if (buf_len < sizeof(struct smb2_file_link_info))
> +			return -EINVAL;
> +
>   		return smb2_create_link(work, work->tcon->share_conf,
> -					(struct smb2_file_link_info *)buf, fp->filp,
> +					(struct smb2_file_link_info *)req->Buffer,
> +					buf_len, fp->filp,
>   					work->sess->conn->local_nls);
> -
> +	}
>   	case FILE_DISPOSITION_INFORMATION:
> +	{
>   		if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
>   			ksmbd_debug(SMB,
>   				    "User does not have write permission\n");
>   			return -EACCES;
>   		}
> -		return set_file_disposition_info(fp, buf);
>   
> +		if (buf_len < sizeof(struct smb2_file_disposition_info))
> +			return -EINVAL;
> +
> +		return set_file_disposition_info(fp, req->Buffer);
> +	}
>   	case FILE_FULL_EA_INFORMATION:
>   	{
>   		if (!(fp->daccess & FILE_WRITE_EA_LE)) {
> @@ -5783,18 +5836,29 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
>   			return -EACCES;
>   		}
>   
> -		return smb2_set_ea((struct smb2_ea_info *)buf,
> -				   &fp->filp->f_path);
> -	}
> +		if (buf_len < sizeof(struct smb2_ea_info))
> +			return -EINVAL;
>   
> +		return smb2_set_ea((struct smb2_ea_info *)req->Buffer,
> +				   buf_len, &fp->filp->f_path);
> +	}
>   	case FILE_POSITION_INFORMATION:
> -		return set_file_position_info(fp, buf);
> +	{
> +		if (buf_len < sizeof(struct smb2_file_pos_info))
> +			return -EINVAL;
>   
> +		return set_file_position_info(fp, req->Buffer);
> +	}
>   	case FILE_MODE_INFORMATION:
> -		return set_file_mode_info(fp, buf);
> +	{
> +		if (buf_len < sizeof(struct smb2_file_mode_info))
> +			return -EINVAL;
> +
> +		return set_file_mode_info(fp, req->Buffer);
> +	}
>   	}
>   
> -	pr_err("Unimplemented Fileinfoclass :%d\n", info_class);
> +	pr_err("Unimplemented Fileinfoclass :%d\n", req->FileInfoClass);
>   	return -EOPNOTSUPP;
>   }
>   
> @@ -5855,8 +5919,7 @@ int smb2_set_info(struct ksmbd_work *work)
>   	switch (req->InfoType) {
>   	case SMB2_O_INFO_FILE:
>   		ksmbd_debug(SMB, "GOT SMB2_O_INFO_FILE\n");
> -		rc = smb2_set_info_file(work, fp, req->FileInfoClass,
> -					req->Buffer, work->tcon->share_conf);
> +		rc = smb2_set_info_file(work, fp, req, work->tcon->share_conf);
>   		break;
>   	case SMB2_O_INFO_SECURITY:
>   		ksmbd_debug(SMB, "GOT SMB2_O_INFO_SECURITY\n");
> diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
> index bcec845b03f3..261825d06391 100644
> --- a/fs/ksmbd/smb2pdu.h
> +++ b/fs/ksmbd/smb2pdu.h
> @@ -1464,6 +1464,15 @@ struct smb2_file_all_info { /* data block encoding of response to level 18 */
>   	char   FileName[1];
>   } __packed; /* level 18 Query */
>   
> +struct smb2_file_basic_info { /* data block encoding of response to level 18 */
> +	__le64 CreationTime;	/* Beginning of FILE_BASIC_INFO equivalent */
> +	__le64 LastAccessTime;
> +	__le64 LastWriteTime;
> +	__le64 ChangeTime;
> +	__le32 Attributes;
> +	__u32  Pad1;		/* End of FILE_BASIC_INFO_INFO equivalent */
> +} __packed;
> +
>   struct smb2_file_alt_name_info {
>   	__le32 FileNameLength;
>   	char FileName[0];
> 
