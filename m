Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42630C433ED
	for <linux-cifs@archiver.kernel.org>; Wed, 19 May 2021 12:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2093B60249
	for <linux-cifs@archiver.kernel.org>; Wed, 19 May 2021 12:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353023AbhESMDc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 19 May 2021 08:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239768AbhESMDc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 19 May 2021 08:03:32 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF367C06175F
        for <linux-cifs@vger.kernel.org>; Wed, 19 May 2021 05:02:12 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id c14so17737548ybr.5
        for <linux-cifs@vger.kernel.org>; Wed, 19 May 2021 05:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KJG0HcSzBoMDG9rogc5fPN2qcj3rrBt8+sJcJx+wkwM=;
        b=IeHnNrSQZUcqtCkK6sCxK2tJDy7GSyN3uChr4AqFIxqsaswnOGC5LYnxFiI0X0GMN0
         iIX/0J8Fb3SOd2JXOkZZpg1HZ3eTd04vVOVOTo5vVUehjdJl7aB2LGrAdWjbCE8KuNui
         wohSl1GlyuKxNZVKS+/pQIf9+3NudWGluter0eP+tQIiWuAPnqnqHvhhwD85QL4g7bec
         oOBZ0GKdsjzZ0gPRlAOPet8hgy/Yh4adp+EhcA3kDQIGa0tzcQZpLOND/0PWjz+FBBzX
         bCcay8Z29l9fMqR5Om+uuLuW4f7i6HxUhViwCeyCD0hC2R+RzfdVrHvs0GDWLoeedVI1
         HZcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KJG0HcSzBoMDG9rogc5fPN2qcj3rrBt8+sJcJx+wkwM=;
        b=avEqqN+72WHMYKdzWoSEePnd5jO0zbmwye+WAAkp5Q2P4QRPLz38ovYOuo3NELABgb
         C4EPjeGjy9QJ+y8I85/krINlRSy9GeZkcfAoxAirJr6mMaTtntkxzs2m/o1LlcpWkJoi
         vWsx8BK7mP7onNz6ffPedaXDZwv5W2xus4Lanlg0dv48U4j+II1otDVk++Q+AtS+dpur
         fLa6R8hLe3+YuWhGKZIWqYY0A8LRK8Are/55xt/uslyCiTfTHByGnlGfoyONF10P/DUK
         CwC+IC0s5ij5eOYTMB6NZXW+fEola0J+HBRaWtTIHA+VY5Mc8hwHuNT0Vwt1kYkZvOg2
         1Iww==
X-Gm-Message-State: AOAM533QLwrd2J+TEws7r2rETQN2Iqqk5mQ/ZI02icAQzpj/l1Hkd6ms
        1/zIw7OKD0VBpVegYpDY7kUtDDfwY0IEvasx2uw=
X-Google-Smtp-Source: ABdhPJzCNJv0JOCYMk2XFbyoGL9KINiL5YS+I/uA5hS7WEEEaPJkZHyaQIFXlx8LHwDJOv9JLFarAkJ6PhqZWY7Sluc=
X-Received: by 2002:a05:6902:1147:: with SMTP id p7mr14469974ybu.3.1621425732090;
 Wed, 19 May 2021 05:02:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210514125201.560775-1-mmakassikis@freebox.fr>
 <f053a063-c8e2-14c8-2c4f-a34c10c39fa1@samba.org> <CAKYAXd9xWW9VJ=EPrhgVUP+ES04zOnHcy4rkboAVYeOuE=bX=w@mail.gmail.com>
 <e03eb8d7-e964-5fa5-840d-9d3292d6d03f@samba.org> <CAKYAXd_64YRcho0Qnq+ccezVL7Tu2_9Jjb8PM+GDujZ9h8x6xw@mail.gmail.com>
 <d5f40ae9-ba89-3bad-1ed8-c4fe672bb0b9@samba.org> <CAKYAXd-faRr2HCMWsNXVLXWBgw_0ZmmorRY_3OOZuhwcxtd4CQ@mail.gmail.com>
 <CAH2r5ms564JrVgXMc6==GauVXFak9+Xj8yFSW081tBHP5HgA5Q@mail.gmail.com>
In-Reply-To: <CAH2r5ms564JrVgXMc6==GauVXFak9+Xj8yFSW081tBHP5HgA5Q@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 19 May 2021 17:32:01 +0530
Message-ID: <CANT5p=pj9ybE=Fiy55fzJLGXQq1B8HJ31_ZDhtRenmOnDpHzrw@mail.gmail.com>
Subject: Re: [Linux-cifsd-devel] [PATCH] cifsd: Do not use 0 as TreeID
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Stefan Metzmacher <metze@samba.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The fix looks good to me.
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>

On Sun, May 16, 2021 at 3:48 AM Steve French <smfrench@gmail.com> wrote:
>
> Patch attached to fix the problem with incorrect FileIDs for
> compounded requests (on the client) - the problem pointed out by Metze
>
> See MS-SMB2 3.2.4.1.4
>
> "For an operation compounded with an SMB2 CREATE request, the FileId
> field SHOULD be set to { 0xFFFFFFFFFFFFFFFF,
> 0xFFFFFFFFFFFFFFFF }.
>
> On Sat, May 15, 2021 at 9:49 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
> >
> > 2021-05-15 23:27 GMT+09:00, Stefan Metzmacher <metze@samba.org>:
> > > Am 15.05.21 um 16:10 schrieb Namjae Jeon:
> > >> 2021-05-15 17:57 GMT+09:00, Stefan Metzmacher <metze@samba.org>:
> > >>>
> > >>> Am 15.05.21 um 07:18 schrieb Namjae Jeon:
> > >>>> 2021-05-14 22:11 GMT+09:00, Stefan Metzmacher via Linux-cifsd-devel
> > >>>> <linux-cifsd-devel@lists.sourceforge.net>:
> > >>>>>
> > >>>>> Am 14.05.21 um 14:52 schrieb Marios Makassikis:
> > >>>>>> Returning TreeID=0 is valid behaviour according to [MS-SMB2] 2.2.1.2:
> > >>>>>>
> > >>>>>>   TreeId (4 bytes): Uniquely identifies the tree connect for the
> > >>>>>> command.
> > >>>>>>   This MUST be 0 for the SMB2 TREE_CONNECT Request. The TreeId can be
> > >>>>>>   any unsigned 32-bit integer that is received from a previous
> > >>>>>>   SMB2 TREE_CONNECT Response. TreeId SHOULD be set to 0 for the
> > >>>>>>   following commands:
> > >>>>>>    [...]
> > >>>>>>
> > >>>>>> However, some client implementations reject it as invalid. Windows
> > >>>>>> 7/10
> > >>>>>> assigns ids starting from 1, and samba4 returns a random uint32_t
> > >>>>>> which suggests there may be other clients that consider it is
> > >>>>>> invalid behaviour.
> > >>>>>>
> > >>>>>> While here, simplify ksmbd_acquire_smb2_tid. 0xFFFF is a reserved
> > >>>>>> value
> > >>>>>> for CIFS/SMB1:
> > >>>>>>   [MS-CIFS] 2.2.4.50.2
> > >>>>>>
> > >>>>>>   TID (2 bytes): The newly generated Tree ID, used in subsequent CIFS
> > >>>>>>   client requests to refer to a resource relative to the
> > >>>>>>   SMB_Data.Bytes.Path specified in the request. Most access to the
> > >>>>>>   server requires a valid TID, whether the resource is password
> > >>>>>>   protected or not. The value 0xFFFF is reserved; the server MUST NOT
> > >>>>>>   return a TID value of 0xFFFF.
> > >>>>>>
> > >>>>>> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> > >>>>>> ---
> > >>>>>> Example library that treats zero TreeID as invalid:
> > >>>>>>
> > >>>>>> https://github.com/AgNO3/jcifs-ng/blob/master/src/main/java/jcifs/internal/smb2/tree/Smb2TreeConnectResponse.java#L201
> > >>>>>>
> > >>>>>>  mgmt/ksmbd_ida.c | 9 ++-------
> > >>>>>>  1 file changed, 2 insertions(+), 7 deletions(-)
> > >>>>>>
> > >>>>>> diff --git a/mgmt/ksmbd_ida.c b/mgmt/ksmbd_ida.c
> > >>>>>> index 7eb6476..34e0d2e 100644
> > >>>>>> --- a/mgmt/ksmbd_ida.c
> > >>>>>> +++ b/mgmt/ksmbd_ida.c
> > >>>>>> @@ -13,19 +13,14 @@ static inline int __acquire_id(struct ida *ida,
> > >>>>>> int
> > >>>>>> from, int to)
> > >>>>>>  #ifdef CONFIG_SMB_INSECURE_SERVER
> > >>>>>>  int ksmbd_acquire_smb1_tid(struct ida *ida)
> > >>>>>>  {
> > >>>>>> -        return __acquire_id(ida, 0, 0xFFFF);
> > >>>>>> +        return __acquire_id(ida, 1, 0xFFFF);
> > >>>>>>  }
> > >>>>>>  #endif
> > >>>>>>
> > >>>>>>  int ksmbd_acquire_smb2_tid(struct ida *ida)
> > >>>>>>  {
> > >>>>>> -        int id;
> > >>>>>> +        return  __acquire_id(ida, 1, 0);
> > >>>>>
> > >>>>> I think that should be __acquire_id(ida, 1, 0xFFFFFFFF) (or a lower
> > >>>>> constraint)
> > >>>>>
> > >>>>> 0xFFFFFFFF is used for compound requests to inherit the tree id from
> > >>>>> the
> > >>>>> previous request.
> > >>>> Where is it defined in the specification ? As I know,
> > >>>> SMB2_FLAGS_RELATED_OPERATIONS flags in smb header indicate inherit
> > >>>> tree id in previous request.
> > >>>
> > >>> [MS-SMB2] 3.2.4.1.4 Sending Compounded Requests
> > >>>
> > >>> ...
> > >>>
> > >>>   The client MUST construct the subsequent request as it would do
> > >>> normally.
> > >>> For any subsequent
> > >>>   requests the client MUST set SMB2_FLAGS_RELATED_OPERATIONS in the
> > >>> Flags
> > >>> field of the SMB2
> > >>>   header to indicate that it is using the SessionId, TreeId, and FileId
> > >>> supplied in the previous
> > >>>   request (or generated by the server in processing that request). For
> > >>> an
> > >>> operation compounded
> > >>>   with an SMB2 CREATE request, the FileId field SHOULD be set to {
> > >>> 0xFFFFFFFFFFFFFFFF,
> > >>>   0xFFFFFFFFFFFFFFFF }.
> > >>>
> > >>> This only explicitly talks about FileId and I'm not any client would do
> > >>> that, but in theory it should be possible to
> > >>> compound, the 2nd session setup request (of an anonymous authentication)
> > >>> with a tree connect request
> > >>> and an open.
> > >>>
> > >>> Which means it's the safest behavior for a server to avoid 0 and all F
> > >>> as
> > >>> valid id,
> > >>> there're still enough ids to use....
> > >>>
> > >>> It also makes sure that we don't end up with very confusing network
> > >>> captures.
> > >> Okay, I have checked cifs client code like the following.
> > >>
> > >>         if (request_type & CHAINED_REQUEST) {
> > >>                 if (!(request_type & END_OF_CHAIN)) {
> > >>                         /* next 8-byte aligned request */
> > >>                         *total_len = DIV_ROUND_UP(*total_len, 8) * 8;
> > >>                         shdr->NextCommand = cpu_to_le32(*total_len);
> > >>                 } else /* END_OF_CHAIN */
> > >>                         shdr->NextCommand = 0;
> > >>                 if (request_type & RELATED_REQUEST) {
> > >>                         shdr->Flags |= SMB2_FLAGS_RELATED_OPERATIONS;
> > >>                         /*
> > >>                          * Related requests use info from previous read
> > >> request
> > >>                          * in chain.
> > >>                          */
> > >>                         shdr->SessionId = 0xFFFFFFFF;
> > >>                         shdr->TreeId = 0xFFFFFFFF;
> > >>                         req->PersistentFileId = 0xFFFFFFFF;
> > >>                         req->VolatileFileId = 0xFFFFFFFF;
> > >>                 }
> > >
> > > Which seems actually wrong and should be 0xFFFFFFFFFFFFFFFF for all but
> > > TreeId...
> > Oh that's right...
> > >
> > > metze
> > >
> > >
> > >
> >
> >
> > _______________________________________________
> > Linux-cifsd-devel mailing list
> > Linux-cifsd-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/linux-cifsd-devel
>
>
>
> --
> Thanks,
>
> Steve



-- 
Regards,
Shyam
