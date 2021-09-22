Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F13BC433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 03:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7836861178
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 03:40:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhIVDlv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 23:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230054AbhIVDlu (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 21 Sep 2021 23:41:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F2B6611C9
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 03:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632282021;
        bh=5qdfUbzU/D83juDcA8dR0S2UGoReYJi4LWDJJGn6G/I=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=fhEx2rBKm5RmdZvKBMhFSVfla+IFTkkRhk5D/k8aR07wl7KiIyLR/kFArA+ShqJLv
         RG2/nrjqRm1gQ7rU/N1+wF9qbez/JKdCj428FpUByHDHFxWf+M1I5vgF9fYZRqFeHS
         BEiRBbWHDfmgTXidkGoK56bAKn44WBZAKWuyp/SSUzQHzW37qG+yxJZqMtKYNmZ9jU
         FrpDeIRCE6XkEdO6itx0yo621YDQhAxmtXyvf8zat1Gyr8wC35CcGP4pT0bIPRmG+S
         NoRqPJRCzW0TFCK2ULuLGibXQPDkxvojH1EBWegwq1n0Pb3z0aSi7B8kR/ZmvXNWUI
         Cb66FLggJ0+bQ==
Received: by mail-ot1-f45.google.com with SMTP id l7-20020a0568302b0700b0051c0181deebso1545768otv.12
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 20:40:21 -0700 (PDT)
X-Gm-Message-State: AOAM533aGyEpe5i0P91TR2j3jRwMleOA772h3yT3OX6x+CW77VykgYju
        3htGM4jKQXV77ljiBL0ILVG9UTslmggAe+T45Ms=
X-Google-Smtp-Source: ABdhPJz3jiQZ1MIk+ZDvC/JQ/Jy1MW7yvucaBaSVPuyNlxlgF4k6dMk8v0Dc2W0KbmjhXHMdYfMRftV4XmAelF9Pzck=
X-Received: by 2002:a05:6830:2050:: with SMTP id f16mr5217840otp.185.1632282020600;
 Tue, 21 Sep 2021 20:40:20 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Tue, 21 Sep 2021 20:40:20
 -0700 (PDT)
In-Reply-To: <CAKYAXd-FLBQ9hTmP6xPi2zNveD4nj3UNKPvGKHfGvba+11Kzqg@mail.gmail.com>
References: <20210919021315.642856-1-linkinjeon@kernel.org>
 <890f7c14-b0b9-12e1-8d2e-e1ca5fb9c2d5@talpey.com> <CAKYAXd-FLBQ9hTmP6xPi2zNveD4nj3UNKPvGKHfGvba+11Kzqg@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 22 Sep 2021 12:40:20 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8z7w_E7hCqhrCQnjdfPc_cx5apQkZfWjhaE3L3i3rDhA@mail.gmail.com>
Message-ID: <CAKYAXd8z7w_E7hCqhrCQnjdfPc_cx5apQkZfWjhaE3L3i3rDhA@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] ksmbd: add request buffer validation in smb2_set_info
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-22 11:31 GMT+09:00, Namjae Jeon <linkinjeon@kernel.org>:
> 2021-09-21 23:23 GMT+09:00, Tom Talpey <tom@talpey.com>:
>> On 9/18/2021 10:13 PM, Namjae Jeon wrote:
>>> Add buffer validation in smb2_set_info.
>>>
>>> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>>> Cc: Ralph B=C3=B6hme <slow@samba.org>
>>> Cc: Steve French <smfrench@gmail.com>
>>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>>> ---
>>>   fs/ksmbd/smb2pdu.c | 113 +++++++++++++++++++++++++++++++++++---------=
-
>>>   fs/ksmbd/smb2pdu.h |   9 ++++
>>>   2 files changed, 97 insertions(+), 25 deletions(-)
>>>
>>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>>> index 46e0275a77a8..7763f69e1ae8 100644
>>> --- a/fs/ksmbd/smb2pdu.c
>>> +++ b/fs/ksmbd/smb2pdu.c
>>> @@ -2107,17 +2107,23 @@ static noinline int create_smb2_pipe(struct
>>> ksmbd_work *work)
>>>    * smb2_set_ea() - handler for setting extended attributes using set
>>>    *		info command
>>>    * @eabuf:	set info command buffer
>>> + * @buf_len:	set info command buffer length
>>>    * @path:	dentry path for get ea
>>>    *
>>>    * Return:	0 on success, otherwise error
>>>    */
>>> -static int smb2_set_ea(struct smb2_ea_info *eabuf, struct path *path)
>>> +static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int
>>> buf_len,
>>> +		       struct path *path)
>>>   {
>>>   	struct user_namespace *user_ns =3D mnt_user_ns(path->mnt);
>>>   	char *attr_name =3D NULL, *value;
>>>   	int rc =3D 0;
>>>   	int next =3D 0;
>>>
>>> +	if (buf_len < sizeof(struct smb2_ea_info) + eabuf->EaNameLength +
>>> +			le16_to_cpu(eabuf->EaValueLength))
>>> +		return -EINVAL;
>>
>> How certain is it that EaNameLength and EaValueLength are sane? One
>> might imagine a forged packet with various combinations of invalid
>> values, which arithmetically satisfy the above check...
> Sorry, I didn't fully understand what you pointed out. Could you
> please elaborate more ?

Maybe, You are saying we need the below check?
@@ -2577,6 +2581,12 @@ int smb2_open(struct ksmbd_work *work)
 			goto err_out1;
 		} else if (context) {
 			ea_buf =3D (struct create_ea_buf_req *)context;
+			if (le16_to_cpu(context->DataOffset) +
+			    le32_to_cpu(context->DataLength) <
+			    sizeof(struct create_ea_buf_req)) {
+				rc =3D -EINVAL;
+				goto err_out1;
+			}

This check is in create context patch.
(https://marc.info/?l=3Dlinux-cifs&m=3D163227401430586&w=3D2)
>
>>
>>> +
>>>   	attr_name =3D kmalloc(XATTR_NAME_MAX + 1, GFP_KERNEL);
>>>   	if (!attr_name)
>>>   		return -ENOMEM;
>>> @@ -2181,7 +2187,13 @@ static int smb2_set_ea(struct smb2_ea_info
>>> *eabuf,
>>> struct path *path)
>>>
>>>   next:
>>>   		next =3D le32_to_cpu(eabuf->NextEntryOffset);
>>> +		if (next =3D=3D 0 || buf_len < next)
>>> +			break;
>>> +		buf_len -=3D next;
>>
>> Because buf_len is unsigned int and next is signed int, these compares
>> are risky. I think "next" should also be unsigned, but if not, testing
>> it for negative values before these checks is important.
>>
>> In the many changes below, buf_len is passed in as signed. Those should
>> be consistent with the same criteria. It pays to be paranoid everywhere!
> Okay, I will update it on next version.
>>
>> Tom.
>>
>>>   		eabuf =3D (struct smb2_ea_info *)((char *)eabuf + next);
>>> +		if (next < eabuf->EaNameLength + le16_to_cpu(eabuf->EaValueLength))
>>> +			break;
>>> +
>>>   	} while (next !=3D 0);
>>>
>>>   	kfree(attr_name);
>>> @@ -2790,7 +2802,9 @@ int smb2_open(struct ksmbd_work *work)
>>>   		created =3D true;
>>>   		user_ns =3D mnt_user_ns(path.mnt);
>>>   		if (ea_buf) {
>>> -			rc =3D smb2_set_ea(&ea_buf->ea, &path);
>>> +			rc =3D smb2_set_ea(&ea_buf->ea,
>>> +					 le32_to_cpu(ea_buf->ccontext.DataLength),
>>> +					 &path);
>>
>> Again, is DataLength verified?
> This field is checked by create context validation patch.
> See: https://marc.info/?l=3Dlinux-cifs&m=3D163227401430586&w=3D2
>>
>>>   			if (rc =3D=3D -EOPNOTSUPP)
>>>   				rc =3D 0;
>>>   			else if (rc)
>>> @@ -5375,7 +5389,7 @@ static int smb2_rename(struct ksmbd_work *work,
>>>   static int smb2_create_link(struct ksmbd_work *work,
>>>   			    struct ksmbd_share_config *share,
>>>   			    struct smb2_file_link_info *file_info,
>>> -			    struct file *filp,
>>> +			    int buf_len, struct file *filp,
>>>   			    struct nls_table *local_nls)
>>>   {
>>>   	char *link_name =3D NULL, *target_name =3D NULL, *pathname =3D NULL;
>>> @@ -5383,6 +5397,10 @@ static int smb2_create_link(struct ksmbd_work
>>> *work,
>>>   	bool file_present =3D true;
>>>   	int rc;
>>>
>>> +	if (buf_len < sizeof(struct smb2_file_link_info) +
>>> +			le32_to_cpu(file_info->FileNameLength))
>>> +		return -EINVAL;
>>> +
>>>   	ksmbd_debug(SMB, "setting FILE_LINK_INFORMATION\n");
>>>   	pathname =3D kmalloc(PATH_MAX, GFP_KERNEL);
>>>   	if (!pathname)
>>> @@ -5442,7 +5460,7 @@ static int smb2_create_link(struct ksmbd_work
>>> *work,
>>>   static int set_file_basic_info(struct ksmbd_file *fp, char *buf,
>>>   			       struct ksmbd_share_config *share)
>>>   {
>>> -	struct smb2_file_all_info *file_info;
>>> +	struct smb2_file_basic_info *file_info;
>>>   	struct iattr attrs;
>>>   	struct timespec64 ctime;
>>>   	struct file *filp;
>>> @@ -5453,7 +5471,7 @@ static int set_file_basic_info(struct ksmbd_file
>>> *fp, char *buf,
>>>   	if (!(fp->daccess & FILE_WRITE_ATTRIBUTES_LE))
>>>   		return -EACCES;
>>>
>>> -	file_info =3D (struct smb2_file_all_info *)buf;
>>> +	file_info =3D (struct smb2_file_basic_info *)buf;
>>>   	attrs.ia_valid =3D 0;
>>>   	filp =3D fp->filp;
>>>   	inode =3D file_inode(filp);
>>> @@ -5619,7 +5637,8 @@ static int set_end_of_file_info(struct ksmbd_work
>>> *work, struct ksmbd_file *fp,
>>>   }
>>>
>>>   static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file
>>> *fp,
>>> -			   char *buf)
>>> +			   struct smb2_file_rename_info *rename_info,
>>> +			   int buf_len)
>>>   {
>>>   	struct user_namespace *user_ns;
>>>   	struct ksmbd_file *parent_fp;
>>> @@ -5632,6 +5651,10 @@ static int set_rename_info(struct ksmbd_work
>>> *work,
>>> struct ksmbd_file *fp,
>>>   		return -EACCES;
>>>   	}
>>>
>>> +	if (buf_len < sizeof(struct smb2_file_rename_info) +
>>> +			le32_to_cpu(rename_info->FileNameLength))
>>> +		return -EINVAL;
>>> +
>>>   	user_ns =3D file_mnt_user_ns(fp->filp);
>>>   	if (ksmbd_stream_fd(fp))
>>>   		goto next;
>>> @@ -5654,8 +5677,7 @@ static int set_rename_info(struct ksmbd_work
>>> *work,
>>> struct ksmbd_file *fp,
>>>   		}
>>>   	}
>>>   next:
>>> -	return smb2_rename(work, fp, user_ns,
>>> -			   (struct smb2_file_rename_info *)buf,
>>> +	return smb2_rename(work, fp, user_ns, rename_info,
>>>   			   work->sess->conn->local_nls);
>>>   }
>>>
>>> @@ -5741,40 +5763,71 @@ static int set_file_mode_info(struct ksmbd_file
>>> *fp, char *buf)
>>>    * TODO: need to implement an error handling for
>>> STATUS_INFO_LENGTH_MISMATCH
>>>    */
>>>   static int smb2_set_info_file(struct ksmbd_work *work, struct
>>> ksmbd_file
>>> *fp,
>>> -			      int info_class, char *buf,
>>> +			      struct smb2_set_info_req *req,
>>>   			      struct ksmbd_share_config *share)
>>>   {
>>> -	switch (info_class) {
>>> +	int buf_len =3D le32_to_cpu(req->BufferLength);
>>> +
>>> +	switch (req->FileInfoClass) {
>>>   	case FILE_BASIC_INFORMATION:
>>> -		return set_file_basic_info(fp, buf, share);
>>> +	{
>>> +		if (buf_len < sizeof(struct smb2_file_basic_info))
>>> +			return -EINVAL;
>>>
>>> +		return set_file_basic_info(fp, req->Buffer, share);
>>> +	}
>>>   	case FILE_ALLOCATION_INFORMATION:
>>> -		return set_file_allocation_info(work, fp, buf);
>>> +	{
>>> +		if (buf_len < sizeof(struct smb2_file_alloc_info))
>>> +			return -EINVAL;
>>>
>>> +		return set_file_allocation_info(work, fp, req->Buffer);
>>> +	}
>>>   	case FILE_END_OF_FILE_INFORMATION:
>>> -		return set_end_of_file_info(work, fp, buf);
>>> +	{
>>> +		if (buf_len < sizeof(struct smb2_file_eof_info))
>>> +			return -EINVAL;
>>>
>>> +		return set_end_of_file_info(work, fp, req->Buffer);
>>> +	}
>>>   	case FILE_RENAME_INFORMATION:
>>> +	{
>>>   		if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)=
)
>>> {
>>>   			ksmbd_debug(SMB,
>>>   				    "User does not have write permission\n");
>>>   			return -EACCES;
>>>   		}
>>> -		return set_rename_info(work, fp, buf);
>>>
>>> +		if (buf_len < sizeof(struct smb2_file_rename_info))
>>> +			return -EINVAL;
>>> +
>>> +		return set_rename_info(work, fp,
>>> +				       (struct smb2_file_rename_info *)req->Buffer,
>>> +				       buf_len);
>>> +	}
>>>   	case FILE_LINK_INFORMATION:
>>> +	{
>>> +		if (buf_len < sizeof(struct smb2_file_link_info))
>>> +			return -EINVAL;
>>> +
>>>   		return smb2_create_link(work, work->tcon->share_conf,
>>> -					(struct smb2_file_link_info *)buf, fp->filp,
>>> +					(struct smb2_file_link_info *)req->Buffer,
>>> +					buf_len, fp->filp,
>>>   					work->sess->conn->local_nls);
>>> -
>>> +	}
>>>   	case FILE_DISPOSITION_INFORMATION:
>>> +	{
>>>   		if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)=
)
>>> {
>>>   			ksmbd_debug(SMB,
>>>   				    "User does not have write permission\n");
>>>   			return -EACCES;
>>>   		}
>>> -		return set_file_disposition_info(fp, buf);
>>>
>>> +		if (buf_len < sizeof(struct smb2_file_disposition_info))
>>> +			return -EINVAL;
>>> +
>>> +		return set_file_disposition_info(fp, req->Buffer);
>>> +	}
>>>   	case FILE_FULL_EA_INFORMATION:
>>>   	{
>>>   		if (!(fp->daccess & FILE_WRITE_EA_LE)) {
>>> @@ -5783,18 +5836,29 @@ static int smb2_set_info_file(struct ksmbd_work
>>> *work, struct ksmbd_file *fp,
>>>   			return -EACCES;
>>>   		}
>>>
>>> -		return smb2_set_ea((struct smb2_ea_info *)buf,
>>> -				   &fp->filp->f_path);
>>> -	}
>>> +		if (buf_len < sizeof(struct smb2_ea_info))
>>> +			return -EINVAL;
>>>
>>> +		return smb2_set_ea((struct smb2_ea_info *)req->Buffer,
>>> +				   buf_len, &fp->filp->f_path);
>>> +	}
>>>   	case FILE_POSITION_INFORMATION:
>>> -		return set_file_position_info(fp, buf);
>>> +	{
>>> +		if (buf_len < sizeof(struct smb2_file_pos_info))
>>> +			return -EINVAL;
>>>
>>> +		return set_file_position_info(fp, req->Buffer);
>>> +	}
>>>   	case FILE_MODE_INFORMATION:
>>> -		return set_file_mode_info(fp, buf);
>>> +	{
>>> +		if (buf_len < sizeof(struct smb2_file_mode_info))
>>> +			return -EINVAL;
>>> +
>>> +		return set_file_mode_info(fp, req->Buffer);
>>> +	}
>>>   	}
>>>
>>> -	pr_err("Unimplemented Fileinfoclass :%d\n", info_class);
>>> +	pr_err("Unimplemented Fileinfoclass :%d\n", req->FileInfoClass);
>>>   	return -EOPNOTSUPP;
>>>   }
>>>
>>> @@ -5855,8 +5919,7 @@ int smb2_set_info(struct ksmbd_work *work)
>>>   	switch (req->InfoType) {
>>>   	case SMB2_O_INFO_FILE:
>>>   		ksmbd_debug(SMB, "GOT SMB2_O_INFO_FILE\n");
>>> -		rc =3D smb2_set_info_file(work, fp, req->FileInfoClass,
>>> -					req->Buffer, work->tcon->share_conf);
>>> +		rc =3D smb2_set_info_file(work, fp, req, work->tcon->share_conf);
>>>   		break;
>>>   	case SMB2_O_INFO_SECURITY:
>>>   		ksmbd_debug(SMB, "GOT SMB2_O_INFO_SECURITY\n");
>>> diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
>>> index bcec845b03f3..261825d06391 100644
>>> --- a/fs/ksmbd/smb2pdu.h
>>> +++ b/fs/ksmbd/smb2pdu.h
>>> @@ -1464,6 +1464,15 @@ struct smb2_file_all_info { /* data block
>>> encoding
>>> of response to level 18 */
>>>   	char   FileName[1];
>>>   } __packed; /* level 18 Query */
>>>
>>> +struct smb2_file_basic_info { /* data block encoding of response to
>>> level
>>> 18 */
>>> +	__le64 CreationTime;	/* Beginning of FILE_BASIC_INFO equivalent */
>>> +	__le64 LastAccessTime;
>>> +	__le64 LastWriteTime;
>>> +	__le64 ChangeTime;
>>> +	__le32 Attributes;
>>> +	__u32  Pad1;		/* End of FILE_BASIC_INFO_INFO equivalent */
>>> +} __packed;
>>> +
>>>   struct smb2_file_alt_name_info {
>>>   	__le32 FileNameLength;
>>>   	char FileName[0];
>>>
>>
>
