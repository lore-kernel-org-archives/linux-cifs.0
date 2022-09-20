Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D7ABC54EE9
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Sep 2022 22:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiITWAr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Sep 2022 18:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiITWAq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Sep 2022 18:00:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2922A273
        for <linux-cifs@vger.kernel.org>; Tue, 20 Sep 2022 15:00:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CB5DECE1AB7
        for <linux-cifs@vger.kernel.org>; Tue, 20 Sep 2022 22:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1C4C433B5
        for <linux-cifs@vger.kernel.org>; Tue, 20 Sep 2022 22:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663711242;
        bh=jEORZiUVm4bFT3KBFUVeEEN4LbiohKxNdEr5Fe4k7DQ=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=UbsH7Z3vdQQy/GXB+m9hTXiGg4UsrKeppPupSTjRGAEmF46MUYxG8PODE86UzHmBd
         w0/VD5WVrjO2uqR3jnGVGMGYSowGIxEofkcSWq4YOsmOlmq6WuRE71gACjmRNrOgug
         P2ow+8/KDvWKYbEk8SshH0VI/um+M7UFyDVItvKerJZ+Dh439S4uqWotz3AWwoUTMl
         Kp0Y2yHgJD7u8TnWgkJ8LVoMkeb6xOVO84dPTlq5IL3IBRJDi0sXTfKJsbuJyA+Ohu
         6JP+KScunNlKNFd3oZr8qwkoJIpGnh02mjDvfmQ/RgN9yxqlYHoIS4D/UPp1m4zmm8
         8wByJf/lltV6Q==
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-12b542cb1d3so6294274fac.13
        for <linux-cifs@vger.kernel.org>; Tue, 20 Sep 2022 15:00:42 -0700 (PDT)
X-Gm-Message-State: ACrzQf0suAbuTomgCKdWoyjj3OzgOqHiKPqeUo9gywU4fAJ87RO0I0+W
        4QHVk1ZtmBH8l61voE0i4ZP6dOARgRdAg14uooc=
X-Google-Smtp-Source: AMsMyM43ULiiUpw7C0lc6yztwDI094+wjDxaYkmbeOh1TrJ7lp8y3DkluONmmPspFCO81l3kq78081AJKMjHRpyOrGI=
X-Received: by 2002:a05:6870:9a26:b0:12d:7e1:e9c7 with SMTP id
 fo38-20020a0568709a2600b0012d07e1e9c7mr3445384oab.257.1663711241170; Tue, 20
 Sep 2022 15:00:41 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Tue, 20 Sep 2022 15:00:40
 -0700 (PDT)
In-Reply-To: <37a76dc7-da11-f3d5-4727-92ab19a66c0a@talpey.com>
References: <20220920132045.5055-1-linkinjeon@kernel.org> <37a76dc7-da11-f3d5-4727-92ab19a66c0a@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 21 Sep 2022 07:00:40 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8NcPPd8c5j04r8_HEusCkvwatCGBWrjT+CEz2Xux0e-Q@mail.gmail.com>
Message-ID: <CAKYAXd8NcPPd8c5j04r8_HEusCkvwatCGBWrjT+CEz2Xux0e-Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] ksmbd: change security id to the one samba used for
 posix extension
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-21 5:56 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 9/20/2022 9:20 AM, Namjae Jeon wrote:
>> Samba set SIDOWNER and SIDUNIX_GROUP in create posix context and
>> set SIDUNIX_USER/GROUP in other sids for posix extension.
>> This patch change security id to the one samba used.
>>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>   fs/ksmbd/oplock.c  | 6 +++---
>>   fs/ksmbd/smb2pdu.c | 4 ++--
>>   fs/ksmbd/smb2pdu.h | 4 ++--
>>   3 files changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
>> index 2e56dac1fa6e..c26f02086783 100644
>> --- a/fs/ksmbd/oplock.c
>> +++ b/fs/ksmbd/oplock.c
>> @@ -1616,7 +1616,7 @@ void create_posix_rsp_buf(char *cc, struct
>> ksmbd_file *fp)
>>   	memset(buf, 0, sizeof(struct create_posix_rsp));
>>   	buf->ccontext.DataOffset = cpu_to_le16(offsetof
>>   			(struct create_posix_rsp, nlink));
>> -	buf->ccontext.DataLength = cpu_to_le32(52);
>> +	buf->ccontext.DataLength = cpu_to_le32(56);
>
> "56" is a weird thing to code here. Can it be expressed as an
> offsetof or some sort of sizeof, for clarity and robustness?
I'll add a comment above this code.
>
>>   	buf->ccontext.NameOffset = cpu_to_le16(offsetof
>>   			(struct create_posix_rsp, Name));
>>   	buf->ccontext.NameLength = cpu_to_le16(POSIX_CTXT_DATA_LEN);
>> @@ -1642,9 +1642,9 @@ void create_posix_rsp_buf(char *cc, struct
>> ksmbd_file *fp)
>>   	buf->reparse_tag = cpu_to_le32(fp->volatile_id);
>>   	buf->mode = cpu_to_le32(inode->i_mode);
>>   	id_to_sid(from_kuid_munged(&init_user_ns, vfsuid_into_kuid(vfsuid)),
>> -		  SIDNFS_USER, (struct smb_sid *)&buf->SidBuffer[0]);
>> +		  SIDOWNER, (struct smb_sid *)&buf->SidBuffer[0]);
>>   	id_to_sid(from_kgid_munged(&init_user_ns, vfsgid_into_kgid(vfsgid)),
>> -		  SIDNFS_GROUP, (struct smb_sid *)&buf->SidBuffer[20]);
>> +		  SIDUNIX_GROUP, (struct smb_sid *)&buf->SidBuffer[28]);
>
> Same comment for "28". offsetof(2 shorts and a sid), right?
Ditto.
>
>>   }
>>
>>   /*
>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> index f33a04e9e458..bc6c7ce17ea8 100644
>> --- a/fs/ksmbd/smb2pdu.c
>> +++ b/fs/ksmbd/smb2pdu.c
>> @@ -3573,9 +3573,9 @@ static int smb2_populate_readdir_entry(struct
>> ksmbd_conn *conn, int info_level,
>>   		if (d_info->hide_dot_file && d_info->name[0] == '.')
>>   			posix_info->DosAttributes |= FILE_ATTRIBUTE_HIDDEN_LE;
>>   		id_to_sid(from_kuid_munged(&init_user_ns, ksmbd_kstat->kstat->uid),
>> -			  SIDNFS_USER, (struct smb_sid *)&posix_info->SidBuffer[0]);
>> +			  SIDUNIX_USER, (struct smb_sid *)&posix_info->SidBuffer[0]);
>>   		id_to_sid(from_kgid_munged(&init_user_ns, ksmbd_kstat->kstat->gid),
>> -			  SIDNFS_GROUP, (struct smb_sid *)&posix_info->SidBuffer[20]);
>> +			  SIDUNIX_GROUP, (struct smb_sid *)&posix_info->SidBuffer[16]);
>
> And for "16", although now I'm also confused why it's 4 *less* than
> before.
Ditto.
>
>
>>   		memcpy(posix_info->name, conv_name, conv_len);
>>   		posix_info->name_len = cpu_to_le32(conv_len);
>>   		posix_info->NextEntryOffset = cpu_to_le32(next_entry_offset);
>> diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
>> index af455278d005..32c525bf790a 100644
>> --- a/fs/ksmbd/smb2pdu.h
>> +++ b/fs/ksmbd/smb2pdu.h
>> @@ -158,7 +158,7 @@ struct create_posix_rsp {
>>   	__le32 nlink;
>>   	__le32 reparse_tag;
>>   	__le32 mode;
>> -	u8 SidBuffer[40];
>> +	u8 SidBuffer[44];
>>   } __packed;
>>
>>   struct smb2_buffer_desc_v1 {
>> @@ -439,7 +439,7 @@ struct smb2_posix_info {
>>   	__le32 HardLinks;
>>   	__le32 ReparseTag;
>>   	__le32 Mode;
>> -	u8 SidBuffer[40];
>> +	u8 SidBuffer[32];
>
> Ok, so it's one buffer, which contains 2 sids? Ick.
Yes.

Thanks for your review!
>
>>   	__le32 name_len;
>>   	u8 name[1];
>>   	/*
>
