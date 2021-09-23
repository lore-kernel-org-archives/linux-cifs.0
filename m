Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A24C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 19:24:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBD5A6124D
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 19:24:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242914AbhIWT0M (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Sep 2021 15:26:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242923AbhIWT0M (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 23 Sep 2021 15:26:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E73346124E
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 19:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632425079;
        bh=sJXVxqjazhuLXaOjBPqoM7W0Afp+yEGUSvj06OiwDhA=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=qjcElFab/6MTmfDoLJ1x6X380zdQ1xlghhNkXTK379n4MBkFsU960g88+C2MpmFs/
         USe8f9eUVTAkh15IB5ZoCnkHqqGJmWEpkVjWgC5EJRPmJU4MazO6oHM6VLb8hzoSqR
         swE4ZICZaqfgQvSC03smaOQHcD7W3ueym6MGM20/RbCCe89v8J/VuLTHnHcutvdQnr
         wXVnVbgLo2b0+ZITLI6wR+pe4H6a9ldKPxfwaM4MO2tk3bbnbVE43y6PNxgHfqS0o9
         IWcYWshWbAlhgxtkeGE1d7bPIACccRfvKiauTZYCp0ABpaTdWbeFMQq1MG4J2KhvQG
         5DDr23EGrIjQg==
Received: by mail-ot1-f44.google.com with SMTP id g62-20020a9d2dc4000000b0054752cfbc59so4291695otb.1
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 12:24:39 -0700 (PDT)
X-Gm-Message-State: AOAM531lOjiV5sLfmJbLrJWp6vUlaKRaIZh5PUDgjadQaQqxPIynXzCr
        l7BaKNUMbEG5TMKTNOi9ipnZG6OZ9Kg8b+303mM=
X-Google-Smtp-Source: ABdhPJzFLn/q8GrVmfL+k5bsGYoXFByUPt3dI5TX6wD4m/vLximS25ITEf9uNR8GdlYjC6R2fkcKIvP0DX/KuGK4TGc=
X-Received: by 2002:a9d:729d:: with SMTP id t29mr329888otj.61.1632425079309;
 Thu, 23 Sep 2021 12:24:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Thu, 23 Sep 2021 12:24:38
 -0700 (PDT)
In-Reply-To: <e8902c30-268b-4a4c-9959-6cf0fb67cb53@talpey.com>
References: <20210923034855.612832-1-linkinjeon@kernel.org> <e8902c30-268b-4a4c-9959-6cf0fb67cb53@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 24 Sep 2021 04:24:38 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_0VwP4tEybX=KavRpWnzTVQrCdUUFhGOp-uWXogrLm9g@mail.gmail.com>
Message-ID: <CAKYAXd_0VwP4tEybX=KavRpWnzTVQrCdUUFhGOp-uWXogrLm9g@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: add the check to vaildate if stream protocol
 length exceeds maximum value
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

2021-09-24 0:05 GMT+09:00, Tom Talpey <tom@talpey.com>:
>
>
> On 9/22/2021 11:48 PM, Namjae Jeon wrote:
>> This patch add MAX_STREAM_PROT_LEN macro and check if stream protocol
>> length exceeds maximum value in ksmbd_pdu_size_has_room().
>>
>> Cc: Tom Talpey <tom@talpey.com>
>> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> Cc: Ralph B=C3=B6hme <slow@samba.org>
>> Cc: Steve French <smfrench@gmail.com>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>   fs/ksmbd/smb_common.c | 3 ++-
>>   fs/ksmbd/smb_common.h | 2 ++
>>   2 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
>> index 5901b2884c60..ebc835ab414c 100644
>> --- a/fs/ksmbd/smb_common.c
>> +++ b/fs/ksmbd/smb_common.c
>> @@ -274,7 +274,8 @@ int ksmbd_init_smb_server(struct ksmbd_work *work)
>>
>>   bool ksmbd_pdu_size_has_room(unsigned int pdu)
>>   {
>> -	return (pdu >=3D KSMBD_MIN_SUPPORTED_HEADER_SIZE - 4);
>> +	return (pdu >=3D KSMBD_MIN_SUPPORTED_HEADER_SIZE - 4 &&
>> +		pdu <=3D MAX_STREAM_PROT_LEN);
>
> Incorrect. If the pdu is already 2^24-1 bytes long, there is no "room".
>
> I don't think  a "<" fixes this either. One byte isn't sufficient to
> allow any significant addition, in all likelihood.
>
> What, exactly, is this check protecting?
Ah, Sorry, The function name and comment seems to create a
misunderstood. It is to check the min/max size of pdu. If pdu size is
bigger than maximum stream protocol length (0x00FFFFFF), ksmbd don't
handle such invalid requests.

>
> Tom.
>
>>   }
>>
>>   int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int
>> info_level,
>> diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
>> index 994abede27e9..10b8d7224dfa 100644
>> --- a/fs/ksmbd/smb_common.h
>> +++ b/fs/ksmbd/smb_common.h
>> @@ -48,6 +48,8 @@
>>   #define CIFS_DEFAULT_IOSIZE	(64 * 1024)
>>   #define MAX_CIFS_SMALL_BUFFER_SIZE 448 /* big enough for most */
>>
>> +#define MAX_STREAM_PROT_LEN	0x00FFFFFF
>> +
>>   /* Responses when opening a file. */
>>   #define F_SUPERSEDED	0
>>   #define F_OPENED	1
>>
>
