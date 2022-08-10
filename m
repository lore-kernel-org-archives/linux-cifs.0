Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60EFCC00140
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Aug 2022 08:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbiHJIAu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Aug 2022 04:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbiHJIAq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Aug 2022 04:00:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485C17172E
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 01:00:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3F1CB81AFA
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 08:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95ED8C433D6
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 08:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660118442;
        bh=Dyx3JtVOKhwabPhHga71HmPo6IkEikBKRPU9WfyPE2o=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=obMB/8dBc+aLNqzIpGFh56t1UqfEtXSEE1FdBYP0KfwLgk9MYJK53GAuIZt9gP8qs
         0e7euQz1EBoSsdRNU2inxemj0/J8GzQcqVwiyPeBCHxBxqSaJJoBV5neg/GicbQ87D
         oUaijWFpEQCaT45l9+MxYKGfAQC0FF2MfAG3Y8bFiotI307DogekrFeUzeWsS2x3o2
         ep+cqB57D/Vkb22ol6lEgivkBssPIULmb+8BPrmQEcZza5621Euj0S9S9BQ6OATsNB
         mHxThE+btao1osDF7qV39ADDs8vBck24MUO1Y7vcz3QGN9Z+2Pr7+GcnKHGUo8bRFC
         VMxhsYtUeNEdA==
Received: by mail-ot1-f51.google.com with SMTP id l5-20020a05683004a500b0063707ff8244so3580577otd.12
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 01:00:42 -0700 (PDT)
X-Gm-Message-State: ACgBeo0F5qKjskZMi1AZpXJb/o0m8f+Wo4LJ1+zOALo8cccQUvUDQexF
        QEuMQGwFZjooOer3LY74lv0QLbeVDFAat9QYaHE=
X-Google-Smtp-Source: AA6agR58KACZkxHkFiI/6CLjlRV0h/e2aFbNeyJUG45mBLAkgrZZpAtKGJPQaSN8RX/BkRq//TZqyz70y7nGtrbra/s=
X-Received: by 2002:a9d:5619:0:b0:617:3dd:f32b with SMTP id
 e25-20020a9d5619000000b0061703ddf32bmr9874755oti.187.1660118441725; Wed, 10
 Aug 2022 01:00:41 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Wed, 10 Aug 2022 01:00:41
 -0700 (PDT)
In-Reply-To: <CAKYAXd8vXKY2mp58zc3epFxS7Pp4AZ+ggKh0Rv-rXCLAaQAW1w@mail.gmail.com>
References: <20220810010446.9229-1-hyc.lee@gmail.com> <CAKYAXd8vXKY2mp58zc3epFxS7Pp4AZ+ggKh0Rv-rXCLAaQAW1w@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 10 Aug 2022 17:00:41 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9vaV2dqt=OBP2B_gWHmG16ZYwe0Gts2xxjJto3PuZk6Q@mail.gmail.com>
Message-ID: <CAKYAXd9vaV2dqt=OBP2B_gWHmG16ZYwe0Gts2xxjJto3PuZk6Q@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: remove unnecessary generic_fillattr in smb2_open
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-08-10 16:58 GMT+09:00, Namjae Jeon <linkinjeon@kernel.org>:
> 2022-08-10 10:04 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
>> Move the call of ksmbd_vfs_getattr above the place
>> where stat is needed, and remove unnecessary
>> the call of generic_fillattr.
>>
>> This patch fixes wrong AllocationSize of SMB2_CREATE
>> response. Because ext4 updates inode->i_blocks only
>> when disk space is allocated, generic_fillattr does
>> not set stat.blocks properly for delayed allocation.
> So what causes delay allocation between the lines you moved this code?
And how can I reproduce problem and make sure that it is improved?
>
>> But ext4 returns the blocks that include the delayed
>> allocation blocks when getattr is called.
>>
>> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
>> ---
>> Changes from v1:
>>  - Update the commit description.
>>
>>  fs/ksmbd/smb2pdu.c | 15 ++++++---------
>>  1 file changed, 6 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> index e6f4ccc12f49..7b4bd0d81133 100644
>> --- a/fs/ksmbd/smb2pdu.c
>> +++ b/fs/ksmbd/smb2pdu.c
>> @@ -3022,12 +3022,6 @@ int smb2_open(struct ksmbd_work *work)
>>  	list_add(&fp->node, &fp->f_ci->m_fp_list);
>>  	write_unlock(&fp->f_ci->m_lock);
>>
>> -	rc = ksmbd_vfs_getattr(&path, &stat);
>> -	if (rc) {
>> -		generic_fillattr(user_ns, d_inode(path.dentry), &stat);
>> -		rc = 0;
>> -	}
>> -
>>  	/* Check delete pending among previous fp before oplock break */
>>  	if (ksmbd_inode_pending_delete(fp)) {
>>  		rc = -EBUSY;
>> @@ -3114,6 +3108,12 @@ int smb2_open(struct ksmbd_work *work)
>>  		}
>>  	}
>>
>> +	rc = ksmbd_vfs_getattr(&path, &stat);
>> +	if (rc) {
>> +		generic_fillattr(user_ns, d_inode(path.dentry), &stat);
>> +		rc = 0;
>> +	}
>> +
>>  	if (stat.result_mask & STATX_BTIME)
>>  		fp->create_time = ksmbd_UnixTimeToNT(stat.btime);
>>  	else
>> @@ -3129,9 +3129,6 @@ int smb2_open(struct ksmbd_work *work)
>>
>>  	memcpy(fp->client_guid, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE);
>>
>> -	generic_fillattr(user_ns, file_inode(fp->filp),
>> -			 &stat);
>> -
>>  	rsp->StructureSize = cpu_to_le16(89);
>>  	rcu_read_lock();
>>  	opinfo = rcu_dereference(fp->f_opinfo);
>> --
>> 2.17.1
>>
>>
>
