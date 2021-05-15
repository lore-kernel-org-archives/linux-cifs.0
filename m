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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF4BFC433B4
	for <linux-cifs@archiver.kernel.org>; Sat, 15 May 2021 15:00:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7150613C3
	for <linux-cifs@archiver.kernel.org>; Sat, 15 May 2021 15:00:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbhEOPBS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 15 May 2021 11:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbhEOPBR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 15 May 2021 11:01:17 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20958C061573
        for <linux-cifs@vger.kernel.org>; Sat, 15 May 2021 08:00:03 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id o8so1990001ljp.0
        for <linux-cifs@vger.kernel.org>; Sat, 15 May 2021 08:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pMMyClcUJOeSNMcvd8BH5YQcamE+0h/k+POuwu/tXAw=;
        b=oaVXNBgtWUvVvs6f0V+WnPSU/jDpB0XO0vUCZwNbtRchHW77K6oeTfS25Q7hT1n+Tu
         O0I7uBzm49pUs1qjyL7dQ1yg20HoidWGoY32of9rDAzVyCV72SBd/0qasdpjlHaYKRPQ
         +zfPMyK/GT4VUAI0e1Pj0HdabKtVTVM0q67WcUlP0TwI4DoMVKkfastwtthn+x90IC2D
         k5VnAZGVmiHCa4S7BMC8jhrCPX7WctMiXa0N5UiCaBCZuneRUEiPVLGFbqrjLMQtT9TN
         ApubBdPxPB2U5SsgO5zvcxS234qx8U/hEh0Ow0haHbOnmNVULEm17uFVSiLhtMNrJWG7
         qfmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pMMyClcUJOeSNMcvd8BH5YQcamE+0h/k+POuwu/tXAw=;
        b=Dx15DOne0pZiF591icuypHGAjkDJf+8xBV/h7T2paLMlBeoIgIelVSTGyZdMTqm+Mi
         FLrO17esouGurk4Uzg2XZBIT5MIzSqvfNFuuA2vM3f+HwPwMqjLJ9gUBm5XuuXy/pSwd
         uFz5OWjLMjAkr+JJ76bOvTYYEPW/WJ9lUS03/ciRbHWejUsLSCUjXuOgof2S+pLxP9K7
         jRi5urytFhvryZNxzlmMUNaOoR8WJCWbsaZLOBbfgRitl3k08128yt9lwzisP3m7Xh65
         1PRvjZajY8yNxhflWyq79TnfNLeAxeb1W7rn1R0MU505qEZ7FZGD1ddGpXIMySS34jrh
         LM+w==
X-Gm-Message-State: AOAM531zd+nn89mVqCxFxawjOJ9J3TFY7xy7Hx0+7l/pZm/84aITtE9h
        4Q8vT1UU23QnUHzBtzImx7pLWAG/WitY330JJx+g8nEZsfZXTQ==
X-Google-Smtp-Source: ABdhPJwCqsVi7+YVbq0LAAbculOuPkKIjDxNAO6E4+yC+RPRYzQPTkI07M9+poPeRBh1QleIcIqfnfCa5tlh/AVxDu4=
X-Received: by 2002:a2e:a41a:: with SMTP id p26mr42467350ljn.272.1621090801217;
 Sat, 15 May 2021 08:00:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210514125201.560775-1-mmakassikis@freebox.fr>
 <f053a063-c8e2-14c8-2c4f-a34c10c39fa1@samba.org> <CAKYAXd9xWW9VJ=EPrhgVUP+ES04zOnHcy4rkboAVYeOuE=bX=w@mail.gmail.com>
 <e03eb8d7-e964-5fa5-840d-9d3292d6d03f@samba.org> <CAKYAXd_64YRcho0Qnq+ccezVL7Tu2_9Jjb8PM+GDujZ9h8x6xw@mail.gmail.com>
 <d5f40ae9-ba89-3bad-1ed8-c4fe672bb0b9@samba.org> <CAKYAXd-faRr2HCMWsNXVLXWBgw_0ZmmorRY_3OOZuhwcxtd4CQ@mail.gmail.com>
In-Reply-To: <CAKYAXd-faRr2HCMWsNXVLXWBgw_0ZmmorRY_3OOZuhwcxtd4CQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 15 May 2021 09:59:50 -0500
Message-ID: <CAH2r5ms564JrVgXMc6==GauVXFak9+Xj8yFSW081tBHP5HgA5Q@mail.gmail.com>
Subject: Re: [Linux-cifsd-devel] [PATCH] cifsd: Do not use 0 as TreeID
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Stefan Metzmacher <metze@samba.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: multipart/mixed; boundary="0000000000005b16fa05c25f9d29"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000005b16fa05c25f9d29
Content-Type: text/plain; charset="UTF-8"

Patch attached to fix the problem with incorrect FileIDs for
compounded requests (on the client) - the problem pointed out by Metze

See MS-SMB2 3.2.4.1.4

"For an operation compounded with an SMB2 CREATE request, the FileId
field SHOULD be set to { 0xFFFFFFFFFFFFFFFF,
0xFFFFFFFFFFFFFFFF }.

On Sat, May 15, 2021 at 9:49 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> 2021-05-15 23:27 GMT+09:00, Stefan Metzmacher <metze@samba.org>:
> > Am 15.05.21 um 16:10 schrieb Namjae Jeon:
> >> 2021-05-15 17:57 GMT+09:00, Stefan Metzmacher <metze@samba.org>:
> >>>
> >>> Am 15.05.21 um 07:18 schrieb Namjae Jeon:
> >>>> 2021-05-14 22:11 GMT+09:00, Stefan Metzmacher via Linux-cifsd-devel
> >>>> <linux-cifsd-devel@lists.sourceforge.net>:
> >>>>>
> >>>>> Am 14.05.21 um 14:52 schrieb Marios Makassikis:
> >>>>>> Returning TreeID=0 is valid behaviour according to [MS-SMB2] 2.2.1.2:
> >>>>>>
> >>>>>>   TreeId (4 bytes): Uniquely identifies the tree connect for the
> >>>>>> command.
> >>>>>>   This MUST be 0 for the SMB2 TREE_CONNECT Request. The TreeId can be
> >>>>>>   any unsigned 32-bit integer that is received from a previous
> >>>>>>   SMB2 TREE_CONNECT Response. TreeId SHOULD be set to 0 for the
> >>>>>>   following commands:
> >>>>>>    [...]
> >>>>>>
> >>>>>> However, some client implementations reject it as invalid. Windows
> >>>>>> 7/10
> >>>>>> assigns ids starting from 1, and samba4 returns a random uint32_t
> >>>>>> which suggests there may be other clients that consider it is
> >>>>>> invalid behaviour.
> >>>>>>
> >>>>>> While here, simplify ksmbd_acquire_smb2_tid. 0xFFFF is a reserved
> >>>>>> value
> >>>>>> for CIFS/SMB1:
> >>>>>>   [MS-CIFS] 2.2.4.50.2
> >>>>>>
> >>>>>>   TID (2 bytes): The newly generated Tree ID, used in subsequent CIFS
> >>>>>>   client requests to refer to a resource relative to the
> >>>>>>   SMB_Data.Bytes.Path specified in the request. Most access to the
> >>>>>>   server requires a valid TID, whether the resource is password
> >>>>>>   protected or not. The value 0xFFFF is reserved; the server MUST NOT
> >>>>>>   return a TID value of 0xFFFF.
> >>>>>>
> >>>>>> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> >>>>>> ---
> >>>>>> Example library that treats zero TreeID as invalid:
> >>>>>>
> >>>>>> https://github.com/AgNO3/jcifs-ng/blob/master/src/main/java/jcifs/internal/smb2/tree/Smb2TreeConnectResponse.java#L201
> >>>>>>
> >>>>>>  mgmt/ksmbd_ida.c | 9 ++-------
> >>>>>>  1 file changed, 2 insertions(+), 7 deletions(-)
> >>>>>>
> >>>>>> diff --git a/mgmt/ksmbd_ida.c b/mgmt/ksmbd_ida.c
> >>>>>> index 7eb6476..34e0d2e 100644
> >>>>>> --- a/mgmt/ksmbd_ida.c
> >>>>>> +++ b/mgmt/ksmbd_ida.c
> >>>>>> @@ -13,19 +13,14 @@ static inline int __acquire_id(struct ida *ida,
> >>>>>> int
> >>>>>> from, int to)
> >>>>>>  #ifdef CONFIG_SMB_INSECURE_SERVER
> >>>>>>  int ksmbd_acquire_smb1_tid(struct ida *ida)
> >>>>>>  {
> >>>>>> -        return __acquire_id(ida, 0, 0xFFFF);
> >>>>>> +        return __acquire_id(ida, 1, 0xFFFF);
> >>>>>>  }
> >>>>>>  #endif
> >>>>>>
> >>>>>>  int ksmbd_acquire_smb2_tid(struct ida *ida)
> >>>>>>  {
> >>>>>> -        int id;
> >>>>>> +        return  __acquire_id(ida, 1, 0);
> >>>>>
> >>>>> I think that should be __acquire_id(ida, 1, 0xFFFFFFFF) (or a lower
> >>>>> constraint)
> >>>>>
> >>>>> 0xFFFFFFFF is used for compound requests to inherit the tree id from
> >>>>> the
> >>>>> previous request.
> >>>> Where is it defined in the specification ? As I know,
> >>>> SMB2_FLAGS_RELATED_OPERATIONS flags in smb header indicate inherit
> >>>> tree id in previous request.
> >>>
> >>> [MS-SMB2] 3.2.4.1.4 Sending Compounded Requests
> >>>
> >>> ...
> >>>
> >>>   The client MUST construct the subsequent request as it would do
> >>> normally.
> >>> For any subsequent
> >>>   requests the client MUST set SMB2_FLAGS_RELATED_OPERATIONS in the
> >>> Flags
> >>> field of the SMB2
> >>>   header to indicate that it is using the SessionId, TreeId, and FileId
> >>> supplied in the previous
> >>>   request (or generated by the server in processing that request). For
> >>> an
> >>> operation compounded
> >>>   with an SMB2 CREATE request, the FileId field SHOULD be set to {
> >>> 0xFFFFFFFFFFFFFFFF,
> >>>   0xFFFFFFFFFFFFFFFF }.
> >>>
> >>> This only explicitly talks about FileId and I'm not any client would do
> >>> that, but in theory it should be possible to
> >>> compound, the 2nd session setup request (of an anonymous authentication)
> >>> with a tree connect request
> >>> and an open.
> >>>
> >>> Which means it's the safest behavior for a server to avoid 0 and all F
> >>> as
> >>> valid id,
> >>> there're still enough ids to use....
> >>>
> >>> It also makes sure that we don't end up with very confusing network
> >>> captures.
> >> Okay, I have checked cifs client code like the following.
> >>
> >>         if (request_type & CHAINED_REQUEST) {
> >>                 if (!(request_type & END_OF_CHAIN)) {
> >>                         /* next 8-byte aligned request */
> >>                         *total_len = DIV_ROUND_UP(*total_len, 8) * 8;
> >>                         shdr->NextCommand = cpu_to_le32(*total_len);
> >>                 } else /* END_OF_CHAIN */
> >>                         shdr->NextCommand = 0;
> >>                 if (request_type & RELATED_REQUEST) {
> >>                         shdr->Flags |= SMB2_FLAGS_RELATED_OPERATIONS;
> >>                         /*
> >>                          * Related requests use info from previous read
> >> request
> >>                          * in chain.
> >>                          */
> >>                         shdr->SessionId = 0xFFFFFFFF;
> >>                         shdr->TreeId = 0xFFFFFFFF;
> >>                         req->PersistentFileId = 0xFFFFFFFF;
> >>                         req->VolatileFileId = 0xFFFFFFFF;
> >>                 }
> >
> > Which seems actually wrong and should be 0xFFFFFFFFFFFFFFFF for all but
> > TreeId...
> Oh that's right...
> >
> > metze
> >
> >
> >
>
>
> _______________________________________________
> Linux-cifsd-devel mailing list
> Linux-cifsd-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-cifsd-devel



-- 
Thanks,

Steve

--0000000000005b16fa05c25f9d29
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-incorrect-file-id-in-requests-compounded-with-o.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-incorrect-file-id-in-requests-compounded-with-o.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kopvk07y0>
X-Attachment-Id: f_kopvk07y0

RnJvbSBlYjY1Mjg2N2UwZDFmZjYwNjJmNGIwZTUwNGNkNDMwMTNjMTViZTU4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgMTUgTWF5IDIwMjEgMDk6NTI6MjIgLTA1MDAKU3ViamVjdDogW1BBVENIXSBT
TUIzOiBpbmNvcnJlY3QgZmlsZSBpZCBpbiByZXF1ZXN0cyBjb21wb3VuZGVkIHdpdGggb3BlbgoK
U2VlIE1TLVNNQjIgMy4yLjQuMS40LCBmaWxlIGlkcyBpbiBjb21wb3VuZGVkIHJlcXVlc3RzIHNo
b3VsZCBiZSBzZXQgdG8KMHhGRkZGRkZGRkZGRkZGRkZGICh3ZSB3ZXJlIHRyZWF0aW5nIGl0IGFz
IHUzMiBub3QgdTY0IGFuZCBzZXR0aW5nCml0IGluY29ycmVjdGx5KS4KClNpZ25lZC1vZmYtYnk6
IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KUmVwb3J0ZWQtYnk6IFN0ZWZh
biBNZXR6bWFjaGVyIDxtZXR6ZUBzYW1iYS5vcmc+Ci0tLQogZnMvY2lmcy9zbWIycGR1LmMgfCA2
ICsrKy0tLQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuYyBiL2ZzL2NpZnMvc21iMnBkdS5jCmluZGV4
IGE4YmY0MzE4NDc3My4uOWYyNGViODgyOTdhIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUu
YworKysgYi9mcy9jaWZzL3NtYjJwZHUuYwpAQCAtMzkwMCwxMCArMzkwMCwxMCBAQCBzbWIyX25l
d19yZWFkX3JlcSh2b2lkICoqYnVmLCB1bnNpZ25lZCBpbnQgKnRvdGFsX2xlbiwKIAkJCSAqIFJl
bGF0ZWQgcmVxdWVzdHMgdXNlIGluZm8gZnJvbSBwcmV2aW91cyByZWFkIHJlcXVlc3QKIAkJCSAq
IGluIGNoYWluLgogCQkJICovCi0JCQlzaGRyLT5TZXNzaW9uSWQgPSAweEZGRkZGRkZGOworCQkJ
c2hkci0+U2Vzc2lvbklkID0gMHhGRkZGRkZGRkZGRkZGRkZGOwogCQkJc2hkci0+VHJlZUlkID0g
MHhGRkZGRkZGRjsKLQkJCXJlcS0+UGVyc2lzdGVudEZpbGVJZCA9IDB4RkZGRkZGRkY7Ci0JCQly
ZXEtPlZvbGF0aWxlRmlsZUlkID0gMHhGRkZGRkZGRjsKKwkJCXJlcS0+UGVyc2lzdGVudEZpbGVJ
ZCA9IDB4RkZGRkZGRkZGRkZGRkZGRjsKKwkJCXJlcS0+Vm9sYXRpbGVGaWxlSWQgPSAweEZGRkZG
RkZGRkZGRkZGRkY7CiAJCX0KIAl9CiAJaWYgKHJlbWFpbmluZ19ieXRlcyA+IGlvX3Bhcm1zLT5s
ZW5ndGgpCi0tIAoyLjMwLjIKCg==
--0000000000005b16fa05c25f9d29--
