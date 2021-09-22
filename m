Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1886C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 04:59:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D38E660F9D
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 04:59:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbhIVFBF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 01:01:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229495AbhIVFBE (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 22 Sep 2021 01:01:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D415611ED
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 04:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632286775;
        bh=2wgexDd6n8G8+MedlDplBrickpVmUBl/SkZgbp1ZDVE=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=MFKbme69kzeQyh0h9BDNioXEIy+gc7m0uIWkJanzcSG1pd3ey4f6P/x9vFONz4PPf
         vaYaWcFPzLShC6M7sLlqQjRvZFksPePaCOm/El7/aHdRX9vZ+J74ZOCmMTBaFeMtiP
         o5RY0fyBqdmDXH2r6ROZWjtQtXfxXSXP2mZZ7BRxIZUBMntTQY0K1mi1aBEsY6s1yL
         +RkTL/81ucnatQY02f+DAmul2iIFZSBiw3p6O05BZmysRVt9hfX9e1XQG4szic8OsL
         N1SLSWv4nnvHvCN4VIQFURztG9CtFS/wH0Kg2pf5dh6eiEYPXa7ULCi3il4C0q7Fdd
         CY9M5pNhnJ5SQ==
Received: by mail-ot1-f44.google.com with SMTP id n65-20020a9d2047000000b00547334367efso1878886ota.1
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 21:59:35 -0700 (PDT)
X-Gm-Message-State: AOAM5319lXr5J56RMcWQbVj1Hww6RT31eylaq4U5tK2SmvCY0rf2/XGn
        9wLXPR1Z688cmvIkFFhZXrT4jINi4EmNPUCX5P4=
X-Google-Smtp-Source: ABdhPJwc7EaD/EhaN7BvSllS+c9Gxl+ydjqXSuPo8yfrAgqyFMrzskK074t0LYfKtqw+M0KCItzBw+IrI/zVLfBcIYY=
X-Received: by 2002:a9d:4705:: with SMTP id a5mr12288611otf.237.1632286774837;
 Tue, 21 Sep 2021 21:59:34 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Tue, 21 Sep 2021 21:59:34
 -0700 (PDT)
In-Reply-To: <dd7f6ca6-bef8-1f5e-53cc-83646c988e80@samba.org>
References: <20210921051933.626532-1-linkinjeon@kernel.org> <dd7f6ca6-bef8-1f5e-53cc-83646c988e80@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 22 Sep 2021 13:59:34 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8N1V6o4L4uF0a70qxmgQE=v1sO1Ha9GRsLLtNKziSJzg@mail.gmail.com>
Message-ID: <CAKYAXd8N1V6o4L4uF0a70qxmgQE=v1sO1Ha9GRsLLtNKziSJzg@mail.gmail.com>
Subject: Re: [PATCH v3] ksmbd: remove follow symlinks support
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Hyeoncheol Lee <hyc.lee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-21 16:33 GMT+09:00, Ralph Boehme <slow@samba.org>:
> Hi Namjae,
>
> excellent! One issue below.
>
> Am 21.09.21 um 07:19 schrieb Namjae Jeon:
>> Use  LOOKUP_NO_SYMLINKS flags for default lookup to prohibit the middle
>> of
>> symlink component lookup and remove follow symlinks parameter support.
>> We re-implement it as reparse point later.
>>
>> Test result:
>> smbclient -Ulinkinjeon%1234 //172.30.1.42/share -c
>> "get hacked/passwd passwd"
>> NT_STATUS_OBJECT_NAME_NOT_FOUND opening remote file \hacked\passwd
>>
>> Cc: Ralph B=C3=B6hme <slow@samba.org>
>> Cc: Steve French <smfrench@gmail.com>
>> Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>   v2:
>>    - reorganize path lookup in smb2_open to call only one
>>      ksmbd_vfs_kern_path().
>>   v3:
>>    - combine "ksmbd: use LOOKUP_NO_SYMLINKS flags for default lookup"
>>      patch into this patch.
>>
>>   fs/ksmbd/smb2pdu.c | 43 ++++++++++---------------------------------
>>   fs/ksmbd/vfs.c     | 32 +++++++++-----------------------
>>   2 files changed, 19 insertions(+), 56 deletions(-)
>>
>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> index 4399c399284b..baf7ce31d557 100644
>> --- a/fs/ksmbd/smb2pdu.c
>> +++ b/fs/ksmbd/smb2pdu.c
>> @@ -2660,13 +2660,9 @@ int smb2_open(struct ksmbd_work *work)
>>   		goto err_out1;
>>   	}
>>
>> -	if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE) {
>> -		/*
>> -		 * On delete request, instead of following up, need to
>> -		 * look the current entity
>> -		 */
>> -		rc =3D ksmbd_vfs_kern_path(name, 0, &path, 1);
>> -		if (!rc) {
>> +	rc =3D ksmbd_vfs_kern_path(name, LOOKUP_NO_SYMLINKS, &path, 1);
>> +	if (!rc) {
>> +		if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE) {
>>   			/*
>>   			 * If file exists with under flags, return access
>>   			 * denied error.
>> @@ -2685,25 +2681,10 @@ int smb2_open(struct ksmbd_work *work)
>>   				path_put(&path);
>>   				goto err_out;
>>   			}
>> -		}
>> -	} else {
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
>> -			rc =3D ksmbd_vfs_kern_path(name, 0, &path, 1);
>> -			if (!rc && d_is_symlink(path.dentry)) {
>> -				rc =3D -EACCES;
>> -				path_put(&path);
>> -				goto err_out;
>> -			}
>> +		} else if (d_is_symlink(path.dentry)) {
>> +			rc =3D -EACCES;
>> +			path_put(&path);
>> +			goto err_out;
>
> I wonder whether the d_is_symlink() check should be done *inside*
> ksmbd_vfs_kern_path()? The idea being having one function where the
> required semantics are implemented without bleeding logic stuff in the
> callers. ksmbd_vfs_kern_path() could simply return -ELOOP if *any* path
> component is a symlink.
>
> Then of course the question is how to handle this in some callers to
> make the decision what how to present the directory entry to the caller.
>
> For example in ksmbd_vfs_readdir_name() I'm not sure if we return file
> metadata from the link target.
Okay, I will check it, And Hyunchul is checking LOOKUP_BENEATH flags
now. If it work properly, such symlink check may not needed.
Thanks!
>
> Thanks!
> -slow
>
> --
> Ralph Boehme, Samba Team                 https://samba.org/
> SerNet Samba Team Lead      https://sernet.de/en/team-samba
>
>
