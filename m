Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E87C6FA82
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Sep 2022 22:20:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbiITWUs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Sep 2022 18:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiITWUn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Sep 2022 18:20:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F295AA27
        for <linux-cifs@vger.kernel.org>; Tue, 20 Sep 2022 15:20:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13D0DB82D47
        for <linux-cifs@vger.kernel.org>; Tue, 20 Sep 2022 22:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8D0C433C1
        for <linux-cifs@vger.kernel.org>; Tue, 20 Sep 2022 22:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663712434;
        bh=iMqAsjV24q5QVeS+EAWIOPsAKE9jXTTr8nE970Ytf1M=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=OVaA8H0eCoVArRn3jx4lU6Lr8N2XbxEx+61R9nejZTuRn0KN+a82RWQ1rROGtiddV
         NFyWLcRHfrvxfoMppWbNfmnStbB9ar6h2sQ8ezbWBd34QE1DEDP5xZT54ar3LL5/wN
         uJYpV6IRrEdl9GW/ntHbt7Xl0g6RZZLygmFoTEUaYrgSiWKni+kECiBM7wA8cwfyvM
         g+2orVTYFD2TurWEOC/9mmRAGYLZL1G5uwCmvPH/VP6gsXRV3xwadqjXCbZZkeCWTl
         vTZgMAAPg8ATqAFPWvlY7bMVG1kePgVCeHb2w2oKsXQLTUfo5/unCydoSPuCViaa4Q
         7T2j3owDtK4Nw==
Received: by mail-oi1-f175.google.com with SMTP id o64so5613381oib.12
        for <linux-cifs@vger.kernel.org>; Tue, 20 Sep 2022 15:20:34 -0700 (PDT)
X-Gm-Message-State: ACrzQf2JwwOpXZsZjhkAh5aWCnuVmgoIgtnbYGLm9BZep231uSBx2A+m
        o10AXabuRB9XoCFHsKyXM/LlK8GOUXxC0B7ymwQ=
X-Google-Smtp-Source: AMsMyM7SEeMhhytmGcftSBaql9qjVfHe7G5xqx768j7gPANBICRdoJMVjXGVsC0po9IgyLATH2v83A4G9+lPeCy6irQ=
X-Received: by 2002:a05:6808:23d5:b0:350:4f5c:143f with SMTP id
 bq21-20020a05680823d500b003504f5c143fmr2738956oib.257.1663712433650; Tue, 20
 Sep 2022 15:20:33 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Tue, 20 Sep 2022 15:20:33
 -0700 (PDT)
In-Reply-To: <1799ec3e-5152-3dc9-1000-2f03396883c6@talpey.com>
References: <20220920132045.5055-1-linkinjeon@kernel.org> <20220920132045.5055-3-linkinjeon@kernel.org>
 <1799ec3e-5152-3dc9-1000-2f03396883c6@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 21 Sep 2022 07:20:33 +0900
X-Gmail-Original-Message-ID: <CAKYAXd89K58kq8PXSP7CNrc2VsW5cVAFWtj-XpihWu-FkUt3ZQ@mail.gmail.com>
Message-ID: <CAKYAXd89K58kq8PXSP7CNrc2VsW5cVAFWtj-XpihWu-FkUt3ZQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] ksmbd: fill sids in SMB_FIND_FILE_POSIX_INFO response
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-21 6:05 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 9/20/2022 9:20 AM, Namjae Jeon wrote:
>> This patch fill missing sids in SMB_FIND_FILE_POSIX_INFO response.
>>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>   fs/ksmbd/smb2pdu.c | 15 ++++++++++++---
>>   1 file changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> index 5c797cc09494..9dd6033bc4de 100644
>> --- a/fs/ksmbd/smb2pdu.c
>> +++ b/fs/ksmbd/smb2pdu.c
>> @@ -4717,6 +4717,9 @@ static int find_file_posix_info(struct
>> smb2_query_info_rsp *rsp,
>>   {
>>   	struct smb311_posix_qinfo *file_info;
>>   	struct inode *inode = file_inode(fp->filp);
>> +	struct user_namespace *user_ns = file_mnt_user_ns(fp->filp);
>> +	vfsuid_t vfsuid = i_uid_into_vfsuid(user_ns, inode);
>> +	vfsgid_t vfsgid = i_gid_into_vfsgid(user_ns, inode);
>>   	u64 time;
>>
>>   	file_info = (struct smb311_posix_qinfo *)rsp->Buffer;
>> @@ -4734,9 +4737,15 @@ static int find_file_posix_info(struct
>> smb2_query_info_rsp *rsp,
>>   	file_info->HardLinks = cpu_to_le32(inode->i_nlink);
>>   	file_info->Mode = cpu_to_le32(inode->i_mode & 0777);
>>   	file_info->DeviceId = cpu_to_le32(inode->i_rdev);
>> +
>> +	id_to_sid(from_kuid_munged(&init_user_ns, vfsuid_into_kuid(vfsuid)),
>> +		  SIDUNIX_USER, (struct smb_sid *)&file_info->Sids[0]);
>> +	id_to_sid(from_kgid_munged(&init_user_ns, vfsgid_into_kgid(vfsgid)),
>> +		  SIDUNIX_GROUP, (struct smb_sid *)&file_info->Sids[16]);
>> +
>>   	rsp->OutputBufferLength =
>> -		cpu_to_le32(sizeof(struct smb311_posix_qinfo));
>> -	inc_rfc1001_len(rsp_org, sizeof(struct smb311_posix_qinfo));
>> +		cpu_to_le32(sizeof(struct smb311_posix_qinfo) + 32);
>> +	inc_rfc1001_len(rsp_org, sizeof(struct smb311_posix_qinfo) + 32);
>
> These 32's, and the one just below, are really sizeof(sidbuffer), right?
Yes.
>
> Why code it as a raw number?
Sids is declared as flexible-array members.
>
> Tom.
>
>>   	return 0;
>>   }
>>
>> @@ -4858,7 +4867,7 @@ static int smb2_get_info_file(struct ksmbd_work
>> *work,
>>   			rc = -EOPNOTSUPP;
>>   		} else {
>>   			rc = find_file_posix_info(rsp, fp, work->response_buf);
>> -			file_infoclass_size = sizeof(struct smb311_posix_qinfo);
>> +			file_infoclass_size = sizeof(struct smb311_posix_qinfo) + 32;
>>   		}
>>   		break;
>>   	default:
>
