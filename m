Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED894ECAAD8
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Sep 2022 23:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiIVXiB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Sep 2022 19:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiIVXiA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Sep 2022 19:38:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054F6DED4D
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 16:37:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1F12B80AEB
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 23:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D33C433C1
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 23:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663889876;
        bh=HlaGD5v5DjMwmQW4bkKklTyBQNLEqAT5Fwl7G0ADPeU=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=fqHlJqDhR/kUZ7DTgOrY0sqXcpLrICgUi7AKMryAJYFRcJjcm6+jdopjL7oTCFwWU
         wVdCEB/ZV4TmSF0rJjvrn0AWCO9OAIL5Xm6KOEW9VzwCQ+0bIeTLNdg35Wi5hYx7DE
         ojsWrpe6TlduSBqbtn4jztgvgebjyz6GJH/0xcwdt21Sst8g3k6B7cj1z8/Cu7SeHF
         wdS+5s6G4UzxKh2aDeAphEM7O/AzBKImu8T4RElDWUf7R9pDSXQAsYyOFWFl1bdS+9
         zoI8DUSxzqdI6P+7z3rIl1fLU5/31SFIRIexVGXGEeem1OkqwT+1tPojTrK9hs8nwl
         lpvMg1+TEgxTQ==
Received: by mail-ot1-f46.google.com with SMTP id 102-20020a9d0bef000000b0065a08449ab3so7285450oth.2
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 16:37:56 -0700 (PDT)
X-Gm-Message-State: ACrzQf2fDYVK5hWsCOOFsmzt9l2qJKS3RvA3xxgJ2HfpV2zuo/t6xEm0
        75RXLHeCq3RYGG9Aeyg+CT3Sy/ypb4KZS22JxOU=
X-Google-Smtp-Source: AMsMyM7T815cEbbooi6G21w6UnMZCri+qcNkQOyifwNVEZlR2Bn2iB8rayFVwYAf9APPApssRFWsNKQ2PjBm9l3lPOo=
X-Received: by 2002:a9d:da6:0:b0:655:dd4e:7afc with SMTP id
 35-20020a9d0da6000000b00655dd4e7afcmr2749760ots.339.1663889875469; Thu, 22
 Sep 2022 16:37:55 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Thu, 22 Sep 2022 16:37:54
 -0700 (PDT)
In-Reply-To: <7cf2749d-32ae-b947-f94f-f0875d1a646f@talpey.com>
References: <20220920132045.5055-1-linkinjeon@kernel.org> <20220920132045.5055-3-linkinjeon@kernel.org>
 <1799ec3e-5152-3dc9-1000-2f03396883c6@talpey.com> <CAKYAXd89K58kq8PXSP7CNrc2VsW5cVAFWtj-XpihWu-FkUt3ZQ@mail.gmail.com>
 <7cf2749d-32ae-b947-f94f-f0875d1a646f@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 23 Sep 2022 08:37:54 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_4wYJVm+K44gSywrs16VaXvfoYcOwqFvtcU8QNsFSC_g@mail.gmail.com>
Message-ID: <CAKYAXd_4wYJVm+K44gSywrs16VaXvfoYcOwqFvtcU8QNsFSC_g@mail.gmail.com>
Subject: Re: [PATCH 3/3] ksmbd: fill sids in SMB_FIND_FILE_POSIX_INFO response
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-23 7:28 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 9/20/2022 6:20 PM, Namjae Jeon wrote:
>> 2022-09-21 6:05 GMT+09:00, Tom Talpey <tom@talpey.com>:
>>> On 9/20/2022 9:20 AM, Namjae Jeon wrote:
>>>> This patch fill missing sids in SMB_FIND_FILE_POSIX_INFO response.
>>>>
>>>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>>>> ---
>>>>    fs/ksmbd/smb2pdu.c | 15 ++++++++++++---
>>>>    1 file changed, 12 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>>>> index 5c797cc09494..9dd6033bc4de 100644
>>>> --- a/fs/ksmbd/smb2pdu.c
>>>> +++ b/fs/ksmbd/smb2pdu.c
>>>> @@ -4717,6 +4717,9 @@ static int find_file_posix_info(struct
>>>> smb2_query_info_rsp *rsp,
>>>>    {
>>>>    	struct smb311_posix_qinfo *file_info;
>>>>    	struct inode *inode = file_inode(fp->filp);
>>>> +	struct user_namespace *user_ns = file_mnt_user_ns(fp->filp);
>>>> +	vfsuid_t vfsuid = i_uid_into_vfsuid(user_ns, inode);
>>>> +	vfsgid_t vfsgid = i_gid_into_vfsgid(user_ns, inode);
>>>>    	u64 time;
>>>>
>>>>    	file_info = (struct smb311_posix_qinfo *)rsp->Buffer;
>>>> @@ -4734,9 +4737,15 @@ static int find_file_posix_info(struct
>>>> smb2_query_info_rsp *rsp,
>>>>    	file_info->HardLinks = cpu_to_le32(inode->i_nlink);
>>>>    	file_info->Mode = cpu_to_le32(inode->i_mode & 0777);
>>>>    	file_info->DeviceId = cpu_to_le32(inode->i_rdev);
>>>> +
>>>> +	id_to_sid(from_kuid_munged(&init_user_ns, vfsuid_into_kuid(vfsuid)),
>>>> +		  SIDUNIX_USER, (struct smb_sid *)&file_info->Sids[0]);
>>>> +	id_to_sid(from_kgid_munged(&init_user_ns, vfsgid_into_kgid(vfsgid)),
>>>> +		  SIDUNIX_GROUP, (struct smb_sid *)&file_info->Sids[16]);
>>>> +
>>>>    	rsp->OutputBufferLength =
>>>> -		cpu_to_le32(sizeof(struct smb311_posix_qinfo));
>>>> -	inc_rfc1001_len(rsp_org, sizeof(struct smb311_posix_qinfo));
>>>> +		cpu_to_le32(sizeof(struct smb311_posix_qinfo) + 32);
>>>> +	inc_rfc1001_len(rsp_org, sizeof(struct smb311_posix_qinfo) + 32);
>>>
>>> These 32's, and the one just below, are really sizeof(sidbuffer), right?
>> Yes.
>>>
>>> Why code it as a raw number?
>> Sids is declared as flexible-array members.
>
> Ugh - worse than that. The smb311_posix_qinfo looks to have
> even more undefined payload:
When I checked the behavior of samba, I figured out that samba does
not return filename and filename_length. Only user/group sids... It
seems that the comment is probably wrong, but there is no
specification documentation and there is no way to check it except
packet analysis.
>
> 	u8     Sids[];
> 	/*
> 	 * var sized owner SID
> 	 * var sized group SID
> 	 * le32 filenamelength
> 	 * u8  filename[]
> 	 */
>
> This is pre-existing, nothing your patch should address, but
> does need attention before we attempt to standardize it!!
It can be more updated when standardization is completed, Anyway,
currently I am trying to match the behavior of samba. Please check if
v2 patch is a little better.

Thanks!
>
> MHO anyway.
>
> Tom.
>
>
>>>
>>> Tom.
>>>
>>>>    	return 0;
>>>>    }
>>>>
>>>> @@ -4858,7 +4867,7 @@ static int smb2_get_info_file(struct ksmbd_work
>>>> *work,
>>>>    			rc = -EOPNOTSUPP;
>>>>    		} else {
>>>>    			rc = find_file_posix_info(rsp, fp, work->response_buf);
>>>> -			file_infoclass_size = sizeof(struct smb311_posix_qinfo);
>>>> +			file_infoclass_size = sizeof(struct smb311_posix_qinfo) + 32;
>>>>    		}
>>>>    		break;
>>>>    	default:
>>>
>>
>
