Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A68C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 15:57:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F12B561159
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 15:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238594AbhITP6k (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 11:58:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234405AbhITP6j (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 20 Sep 2021 11:58:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E356610FB
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 15:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632153432;
        bh=jGrSml6hSnZQGmZ92U5hUVWUWjVR2Y2WUtcat8RM5bI=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=doBwhQi4KVRbUCvIl+5g1EvVw2P6OibSdDI+xcKNmWTK2CaV0ialdx5s/6EOD5WmL
         cWzYUxs+a0nNOWM8GF2ggtS/2Lp8QX27TdzVitdytk1CQzEuAo77kEJWRPElueDee6
         uhswc4tq+2rZYLFV7IdC5QWep7WzAVFLOyS2H6xid85sHvc7VciZC4FoOreznARTNd
         RrN2QczreeUonmmbOhSEPsY3f8gbYYO9ozsQvq0GFT3m52gWqzbB4NnNAkyPn+zwga
         T8K0VMCLUG24CdjaPgyQttAg13jxn+qNddeAO2EkxogH2TH3Yx1GV4mfibPmu4ejmf
         qLhL5XNwoN+iw==
Received: by mail-oo1-f47.google.com with SMTP id p22-20020a4a8156000000b002a8c9ea1858so2066117oog.11
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 08:57:12 -0700 (PDT)
X-Gm-Message-State: AOAM533PTJpNh/V83/2UC2LmAfYRiIyAxl0SkrZPzUR0Y4Dx84DXP9s9
        oVyGZiPZWu43io6BSBvFB9euy5QZBLMoYk5IpeM=
X-Google-Smtp-Source: ABdhPJxnqzTTTXmwKKCShGd2VrgVFSNg++StybxNI+6zbKg6hnySfr8wYlKiWV5E9MVK/IsxtI4iMASGRWGBH0Ll8YI=
X-Received: by 2002:a4a:b78c:: with SMTP id a12mr7545866oop.58.1632153431998;
 Mon, 20 Sep 2021 08:57:11 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Mon, 20 Sep 2021 08:57:11
 -0700 (PDT)
In-Reply-To: <6e8b6c79-3394-f39c-8e1b-06b3c2950a28@samba.org>
References: <20210920065613.5506-1-linkinjeon@kernel.org> <6e8b6c79-3394-f39c-8e1b-06b3c2950a28@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 21 Sep 2021 00:57:11 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9Re_iHpwKq4t4GUibKo8g_D3QB1rzBOYiTvv5dLhdvsw@mail.gmail.com>
Message-ID: <CAKYAXd9Re_iHpwKq4t4GUibKo8g_D3QB1rzBOYiTvv5dLhdvsw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: remove follow symlinks support
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-20 22:57 GMT+09:00, Ralph Boehme <slow@samba.org>:
> Hi Namjae,
>
> Am 20.09.21 um 08:56 schrieb Namjae Jeon:
>> This patch remove symlink support that can be vulnerable, and we
>> re-implement it as reparse point later.
>>
>> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> Cc: Ralph B=C3=B6hme <slow@samba.org>
>> Cc: Steve French <smfrench@gmail.com>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>   fs/ksmbd/smb2pdu.c | 55 ++++++++++------------------------------------
>>   fs/ksmbd/vfs.c     | 50 +++++++++--------------------------------
>>   2 files changed, 21 insertions(+), 84 deletions(-)
>>
>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> index afc508c2656d..911c5e97678d 100644
>> --- a/fs/ksmbd/smb2pdu.c
>> +++ b/fs/ksmbd/smb2pdu.c
>> @@ -2661,17 +2661,7 @@ int smb2_open(struct ksmbd_work *work)
>>   	}
>>
>>   	if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE) {
>> -		if (test_share_config_flag(work->tcon->share_conf,
>> -					   KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS)) {
>> -			/*
>> -			 * On delete request, instead of following up, need to
>> -			 * look the current entity
>> -			 */
>> -			rc =3D ksmbd_vfs_kern_path(name, 0, &path, 1);
>> -		} else {
>> -			rc =3D ksmbd_vfs_kern_path(name, LOOKUP_NO_SYMLINKS, &path, 1);
>> -		}
>> -
>> +		rc =3D ksmbd_vfs_kern_path(name, LOOKUP_NO_SYMLINKS, &path, 1);
>>   		if (!rc) {
>>   			/*
>>   			 * If file exists with under flags, return access
>> @@ -2693,24 +2683,11 @@ int smb2_open(struct ksmbd_work *work)
>>   			}
>>   		}
>>   	} else {
>> -		if (test_share_config_flag(work->tcon->share_conf,
>> -					   KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS)) {
>> -			/*
>> -			 * Use LOOKUP_FOLLOW to follow the path of
>> -			 * symlink in path buildup
>> -			 */
>> -			rc =3D ksmbd_vfs_kern_path(name, LOOKUP_FOLLOW, &path, 1);
>> -			if (rc) { /* Case for broken link ?*/
>> -				rc =3D ksmbd_vfs_kern_path(name, 0, &path, 1);
>> -			}
>> -		} else {
>> -			rc =3D ksmbd_vfs_kern_path(name, LOOKUP_NO_SYMLINKS,
>> -						 &path, 1);
>> -			if (!rc && d_is_symlink(path.dentry)) {
>> -				rc =3D -EACCES;
>> -				path_put(&path);
>> -				goto err_out;
>> -			}
>> +		rc =3D ksmbd_vfs_kern_path(name, LOOKUP_NO_SYMLINKS, &path, 1);
>> +		if (!rc && d_is_symlink(path.dentry)) {
>> +			rc =3D -EACCES;
>> +			path_put(&path);
>> +			goto err_out;
>
> why the the check for d_is_symlink()? Wouldn't ksmbd_vfs_kern_path()
> just return -ELOOP if a path component is a symlink? Hence I guess the
> below if (rc) where we handle EACCESS should be expanded to handle ELOOP.
ksmbd_vfs_kern_path() doesn't return -ELOOP if last component is a
symlink. So need to check it using d_is_symlink().
>
> I guess I would also refactor the
>
> if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE)
>
> logic in a previous commit to change the codeflow so there's only one
> call to ksmbd_vfs_kern_path().
Right. Will do it on v2.
>
>>   		}
>>   	}
>>
>> @@ -4795,12 +4772,8 @@ static int smb2_get_info_filesystem(struct
>> ksmbd_work *work,
>>   	struct path path;
>>   	int rc =3D 0, len;
>>   	int fs_infoclass_size =3D 0;
>> -	int lookup_flags =3D LOOKUP_NO_SYMLINKS;
>>
>> -	if (test_share_config_flag(share, KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
>> -		lookup_flags =3D LOOKUP_FOLLOW;
>> -
>> -	rc =3D ksmbd_vfs_kern_path(share->path, lookup_flags, &path, 0);
>> +	rc =3D ksmbd_vfs_kern_path(share->path, LOOKUP_NO_SYMLINKS, &path, 0);
>>   	if (rc) {
>>   		pr_err("cannot create vfs path\n");
>>   		return -EIO;
>
> why doesn't this return rc?
This is not related with this patch. If needed, we can fix it on another pa=
tch.
As I remember, To return STATUS_UNEXPECTED_IO_ERROR error?
>
>> @@ -5307,7 +5280,7 @@ static int smb2_rename(struct ksmbd_work *work,
>>   	char *pathname =3D NULL;
>>   	struct path path;
>>   	bool file_present =3D true;
>> -	int rc, lookup_flags =3D LOOKUP_NO_SYMLINKS;
>> +	int rc;
>>
>>   	ksmbd_debug(SMB, "setting FILE_RENAME_INFO\n");
>>   	pathname =3D kmalloc(PATH_MAX, GFP_KERNEL);
>> @@ -5376,11 +5349,8 @@ static int smb2_rename(struct ksmbd_work *work,
>>   		goto out;
>>   	}
>>
>> -	if (test_share_config_flag(share, KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
>> -		lookup_flags =3D LOOKUP_FOLLOW;
>> -
>>   	ksmbd_debug(SMB, "new name %s\n", new_name);
>> -	rc =3D ksmbd_vfs_kern_path(new_name, lookup_flags, &path, 1);
>> +	rc =3D ksmbd_vfs_kern_path(new_name, LOOKUP_NO_SYMLINKS, &path, 1);
>>   	if (rc)
>>   		file_present =3D false;
>
> I guess this should handle ELOOP?
I have answered above. ksmbd_vfs_kern_path doesn't return it.
>
>>   	else
>> @@ -5430,7 +5400,7 @@ static int smb2_create_link(struct ksmbd_work
>> *work,
>>   	char *link_name =3D NULL, *target_name =3D NULL, *pathname =3D NULL;
>>   	struct path path;
>>   	bool file_present =3D true;
>> -	int rc, lookup_flags =3D LOOKUP_NO_SYMLINKS;
>> +	int rc;
>>
>>   	if (buf_len < sizeof(struct smb2_file_link_info) +
>>   			le32_to_cpu(file_info->FileNameLength))
>> @@ -5457,11 +5427,8 @@ static int smb2_create_link(struct ksmbd_work
>> *work,
>>   		goto out;
>>   	}
>>
>> -	if (test_share_config_flag(share, KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
>> -		lookup_flags =3D LOOKUP_FOLLOW;
>> -
>>   	ksmbd_debug(SMB, "target name is %s\n", target_name);
>> -	rc =3D ksmbd_vfs_kern_path(link_name, lookup_flags, &path, 0);
>> +	rc =3D ksmbd_vfs_kern_path(link_name, LOOKUP_NO_SYMLINKS, &path, 0);
>>   	if (rc)
>>   		file_present =3D false;
>
> same here?
ditto.
>
> Other then that: lgtm. Oh, besides, guess this needs an accomanying
> change to ksmbd-tools?
Yes. It is needed, but I will change ksmbd-tools also after this patch
is applied.

Thanks for your review!
>
> Cheers!
> -slow
>
> --
> Ralph Boehme, Samba Team                 https://samba.org/
> SerNet Samba Team Lead      https://sernet.de/en/team-samba
>
>
