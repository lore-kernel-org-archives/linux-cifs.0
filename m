Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 387DCC433ED
	for <linux-cifs@archiver.kernel.org>; Sat, 15 May 2021 14:49:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02F59613BC
	for <linux-cifs@archiver.kernel.org>; Sat, 15 May 2021 14:48:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbhEOOuL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 15 May 2021 10:50:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231386AbhEOOuJ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 15 May 2021 10:50:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21022613C1
        for <linux-cifs@vger.kernel.org>; Sat, 15 May 2021 14:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621090135;
        bh=BOqCLL18Le1LbJoXjCkMn6mDHQ7clov02vdfrf7m8GU=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=fbMd6kwgFxxbvSQnXN8ACi3XYq7qCG8m0tC3eonnNkhgx/JpD7OjTIZpmTfD3NfdH
         zI79JQNBJcN1Kyb9EoENQVAt/QD9E7G0nPpnl3VniE0U8m8IlwJZ9F5tRrCCECRDQA
         DQ6RDpKC5SYd/84jiuU6mb9smVgs5O0WU3ro8Wn2u5XiL/4gTrCJQYMz9H6Iy/RFVR
         yZRQNim7biE0/x0tuc82ODREUZJX+CzNpiWilNBH44ikxhh5jkgyFBJZwnRY0aH8tj
         AS3U9BoWR/BxxwsVaML/MYI+Yd4Kh9V2MMzHqSYSK0/6RIzMDB4Y4QXit3ApYHgSDz
         Ldg0fLCGJaW4Q==
Received: by mail-ot1-f42.google.com with SMTP id t10-20020a05683022eab0290304ed8bc759so1794434otc.12
        for <linux-cifs@vger.kernel.org>; Sat, 15 May 2021 07:48:55 -0700 (PDT)
X-Gm-Message-State: AOAM533VO7LkN2GQo28v7D5jCIli7e4wi5yLOjgmsuHEAvuDhVi+vjIf
        Tka6Eu9lVDlZ2U7jTGGHKop0WtpSUaGTy9fFJWE=
X-Google-Smtp-Source: ABdhPJywVvU57Q/Rod1bd3R2TSkvgDMH/zeCwQfrkaJcTZ3lhGkmQ03IQVfyUMidqXMMTsJeSjNh0jv2O/ZXGitQ8Rg=
X-Received: by 2002:a9d:7cd8:: with SMTP id r24mr31973510otn.90.1621090134474;
 Sat, 15 May 2021 07:48:54 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:4443:0:0:0:0:0 with HTTP; Sat, 15 May 2021 07:48:54
 -0700 (PDT)
In-Reply-To: <d5f40ae9-ba89-3bad-1ed8-c4fe672bb0b9@samba.org>
References: <20210514125201.560775-1-mmakassikis@freebox.fr>
 <f053a063-c8e2-14c8-2c4f-a34c10c39fa1@samba.org> <CAKYAXd9xWW9VJ=EPrhgVUP+ES04zOnHcy4rkboAVYeOuE=bX=w@mail.gmail.com>
 <e03eb8d7-e964-5fa5-840d-9d3292d6d03f@samba.org> <CAKYAXd_64YRcho0Qnq+ccezVL7Tu2_9Jjb8PM+GDujZ9h8x6xw@mail.gmail.com>
 <d5f40ae9-ba89-3bad-1ed8-c4fe672bb0b9@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 15 May 2021 23:48:54 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-faRr2HCMWsNXVLXWBgw_0ZmmorRY_3OOZuhwcxtd4CQ@mail.gmail.com>
Message-ID: <CAKYAXd-faRr2HCMWsNXVLXWBgw_0ZmmorRY_3OOZuhwcxtd4CQ@mail.gmail.com>
Subject: Re: [Linux-cifsd-devel] [PATCH] cifsd: Do not use 0 as TreeID
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Marios Makassikis <mmakassikis@freebox.fr>,
        linux-cifsd-devel@lists.sourceforge.net,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-05-15 23:27 GMT+09:00, Stefan Metzmacher <metze@samba.org>:
> Am 15.05.21 um 16:10 schrieb Namjae Jeon:
>> 2021-05-15 17:57 GMT+09:00, Stefan Metzmacher <metze@samba.org>:
>>>
>>> Am 15.05.21 um 07:18 schrieb Namjae Jeon:
>>>> 2021-05-14 22:11 GMT+09:00, Stefan Metzmacher via Linux-cifsd-devel
>>>> <linux-cifsd-devel@lists.sourceforge.net>:
>>>>>
>>>>> Am 14.05.21 um 14:52 schrieb Marios Makassikis:
>>>>>> Returning TreeID=0 is valid behaviour according to [MS-SMB2] 2.2.1.2:
>>>>>>
>>>>>>   TreeId (4 bytes): Uniquely identifies the tree connect for the
>>>>>> command.
>>>>>>   This MUST be 0 for the SMB2 TREE_CONNECT Request. The TreeId can be
>>>>>>   any unsigned 32-bit integer that is received from a previous
>>>>>>   SMB2 TREE_CONNECT Response. TreeId SHOULD be set to 0 for the
>>>>>>   following commands:
>>>>>>    [...]
>>>>>>
>>>>>> However, some client implementations reject it as invalid. Windows
>>>>>> 7/10
>>>>>> assigns ids starting from 1, and samba4 returns a random uint32_t
>>>>>> which suggests there may be other clients that consider it is
>>>>>> invalid behaviour.
>>>>>>
>>>>>> While here, simplify ksmbd_acquire_smb2_tid. 0xFFFF is a reserved
>>>>>> value
>>>>>> for CIFS/SMB1:
>>>>>>   [MS-CIFS] 2.2.4.50.2
>>>>>>
>>>>>>   TID (2 bytes): The newly generated Tree ID, used in subsequent CIFS
>>>>>>   client requests to refer to a resource relative to the
>>>>>>   SMB_Data.Bytes.Path specified in the request. Most access to the
>>>>>>   server requires a valid TID, whether the resource is password
>>>>>>   protected or not. The value 0xFFFF is reserved; the server MUST NOT
>>>>>>   return a TID value of 0xFFFF.
>>>>>>
>>>>>> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
>>>>>> ---
>>>>>> Example library that treats zero TreeID as invalid:
>>>>>>
>>>>>> https://github.com/AgNO3/jcifs-ng/blob/master/src/main/java/jcifs/internal/smb2/tree/Smb2TreeConnectResponse.java#L201
>>>>>>
>>>>>>  mgmt/ksmbd_ida.c | 9 ++-------
>>>>>>  1 file changed, 2 insertions(+), 7 deletions(-)
>>>>>>
>>>>>> diff --git a/mgmt/ksmbd_ida.c b/mgmt/ksmbd_ida.c
>>>>>> index 7eb6476..34e0d2e 100644
>>>>>> --- a/mgmt/ksmbd_ida.c
>>>>>> +++ b/mgmt/ksmbd_ida.c
>>>>>> @@ -13,19 +13,14 @@ static inline int __acquire_id(struct ida *ida,
>>>>>> int
>>>>>> from, int to)
>>>>>>  #ifdef CONFIG_SMB_INSECURE_SERVER
>>>>>>  int ksmbd_acquire_smb1_tid(struct ida *ida)
>>>>>>  {
>>>>>> -	return __acquire_id(ida, 0, 0xFFFF);
>>>>>> +	return __acquire_id(ida, 1, 0xFFFF);
>>>>>>  }
>>>>>>  #endif
>>>>>>
>>>>>>  int ksmbd_acquire_smb2_tid(struct ida *ida)
>>>>>>  {
>>>>>> -	int id;
>>>>>> +	return  __acquire_id(ida, 1, 0);
>>>>>
>>>>> I think that should be __acquire_id(ida, 1, 0xFFFFFFFF) (or a lower
>>>>> constraint)
>>>>>
>>>>> 0xFFFFFFFF is used for compound requests to inherit the tree id from
>>>>> the
>>>>> previous request.
>>>> Where is it defined in the specification ? As I know,
>>>> SMB2_FLAGS_RELATED_OPERATIONS flags in smb header indicate inherit
>>>> tree id in previous request.
>>>
>>> [MS-SMB2] 3.2.4.1.4 Sending Compounded Requests
>>>
>>> ...
>>>
>>>   The client MUST construct the subsequent request as it would do
>>> normally.
>>> For any subsequent
>>>   requests the client MUST set SMB2_FLAGS_RELATED_OPERATIONS in the
>>> Flags
>>> field of the SMB2
>>>   header to indicate that it is using the SessionId, TreeId, and FileId
>>> supplied in the previous
>>>   request (or generated by the server in processing that request). For
>>> an
>>> operation compounded
>>>   with an SMB2 CREATE request, the FileId field SHOULD be set to {
>>> 0xFFFFFFFFFFFFFFFF,
>>>   0xFFFFFFFFFFFFFFFF }.
>>>
>>> This only explicitly talks about FileId and I'm not any client would do
>>> that, but in theory it should be possible to
>>> compound, the 2nd session setup request (of an anonymous authentication)
>>> with a tree connect request
>>> and an open.
>>>
>>> Which means it's the safest behavior for a server to avoid 0 and all F
>>> as
>>> valid id,
>>> there're still enough ids to use....
>>>
>>> It also makes sure that we don't end up with very confusing network
>>> captures.
>> Okay, I have checked cifs client code like the following.
>>
>>         if (request_type & CHAINED_REQUEST) {
>>                 if (!(request_type & END_OF_CHAIN)) {
>>                         /* next 8-byte aligned request */
>>                         *total_len = DIV_ROUND_UP(*total_len, 8) * 8;
>>                         shdr->NextCommand = cpu_to_le32(*total_len);
>>                 } else /* END_OF_CHAIN */
>>                         shdr->NextCommand = 0;
>>                 if (request_type & RELATED_REQUEST) {
>>                         shdr->Flags |= SMB2_FLAGS_RELATED_OPERATIONS;
>>                         /*
>>                          * Related requests use info from previous read
>> request
>>                          * in chain.
>>                          */
>>                         shdr->SessionId = 0xFFFFFFFF;
>>                         shdr->TreeId = 0xFFFFFFFF;
>>                         req->PersistentFileId = 0xFFFFFFFF;
>>                         req->VolatileFileId = 0xFFFFFFFF;
>>                 }
>
> Which seems actually wrong and should be 0xFFFFFFFFFFFFFFFF for all but
> TreeId...
Oh that's right...
>
> metze
>
>
>
