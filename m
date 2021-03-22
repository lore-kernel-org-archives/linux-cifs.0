Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D101C433C1
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Mar 2021 17:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C6C76146D
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Mar 2021 17:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbhCVRIS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Mar 2021 13:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbhCVRHq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 Mar 2021 13:07:46 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699C5C061574
        for <linux-cifs@vger.kernel.org>; Mon, 22 Mar 2021 10:07:46 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so8860616pjg.5
        for <linux-cifs@vger.kernel.org>; Mon, 22 Mar 2021 10:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ybVBfopsm7B6m67FKzgN/wCGXUWOQ4WM84KXTpHVwdw=;
        b=pC6YlvMd7K58dLiCEGn8vWxzQmVsVv13VNVOJqbFi1/Sn0UX7MheobWOc3GFOkAhiY
         nqa6BGePW1CPtTIdT7+SbYB+jN2BVyw4pLOC1PXS59lFx1W8DzC8z7GuojSfK3aDTPWN
         b0l8wscXImCyRWCdPFVtzag7kAswQW+fSlM93QUvXA5FjbbGwvaioIGT7Wnog/AUUq/o
         9oO2gf3mXMQa7KJ75+r/1X4PfXydzOvelj+THF8gj2NjB9BLo/2bYmG7kVyarGCiO2M4
         1war02cEsfGStYpueT1ss547uoFii9stJfM1zMl/Ka8ePOMSAIjOx6JhabEf/tTrAmEj
         yHow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ybVBfopsm7B6m67FKzgN/wCGXUWOQ4WM84KXTpHVwdw=;
        b=QZZDNPoQPJvMqvQUue/vvf1I+ZVzGNNTI74/xjo8cu5jGy1x3wdbwT5FWciTDYof9t
         gf2mO/c3aaurUiVgE3f5PJurOKJ1726WYcxSTPFRnyo5Iyz1wBQGMeOZtGOsYmMgysNO
         hDCbQa2iJD3l5RSrj7l2rKrmYizhkw0myhIoDUf0O2WfSV/GLAx0AN6/jMMdXYn8cxQ7
         WQjOdk0wIjqB+gn/OKC2OryTufqW9G52vKANKO2qt4bDOZxLMwqOLg3v678wkROI7EVK
         oiWLXO9MsAzZGVciY1sqebYqRwi/ACvhv30Cz4aeYEKLgeNqbx/cDfmWOM/YqDaFmZID
         QVwA==
X-Gm-Message-State: AOAM530eVbNbPn1zDYXrQCir9Taq+7sg877wRw5byRQcRwD9S7iJwQcB
        H5zwenA1uwM61SeJY2ze+K2LImbni0QxPg/Tf+U=
X-Google-Smtp-Source: ABdhPJwPuaos6W99Ms3t4E9j/+nYSZru+rjR/D/FXJeQNrEwUXQ0mmOUNGH0kn1nsmk6ICNi7ZtgmuQXkKSCgDKNS5I=
X-Received: by 2002:a17:90a:1708:: with SMTP id z8mr57217pjd.49.1616432865924;
 Mon, 22 Mar 2021 10:07:45 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0Y1NeC0jNTOtjhTtGRt0sfyhyxC=wNfMu1eqibe6qJbwA@mail.gmail.com>
 <CANT5p=pFU=1OKiBA0m0_Pqms4Vsxz7omEgvfDDAb8U3M4-3qbA@mail.gmail.com> <461d79c3-1b32-b0f8-157c-b5d4b25507d7@talpey.com>
In-Reply-To: <461d79c3-1b32-b0f8-157c-b5d4b25507d7@talpey.com>
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Mon, 22 Mar 2021 22:37:34 +0530
Message-ID: <CACdtm0agzeVRiQg1zZjm=jFrf-gSQ-+YGc1Zm1xN1Pd9tJia4Q@mail.gmail.com>
Subject: Re: cifs: Deferred close for files
To:     Tom Talpey <tom@talpey.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>, sribhat.msa@outlook.com,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Content-Type: multipart/mixed; boundary="000000000000c73c5505be231a83"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000c73c5505be231a83
Content-Type: text/plain; charset="UTF-8"

On 3/11/2021 8:47 AM, Shyam Prasad N wrote:
> Hi Rohith,
>
> The changes look good at a high level.
>
> Just a few points worth checking:
> 1. In cifs_open(), should be perform deferred close for certain cases
> like O_DIRECT? AFAIK, O_DIRECT is just a hint to the filesystem to
> perform less data caching. By deferring close, aren't we delaying
> flushing dirty pages? @Steve French ?

With O_DIRECT flag, data is not cached locally and will be sent to
server immediately.

> 2. I see that you're maintaining a new list of files for deferred
> closing. Since there could be a large number of such files for a big
> share with sufficient I/O, maybe we should think of a structure with
> faster lookups (rb trees?).
> I know we already have a bunch of linked lists in cifs.ko, and we need
> to review perf impact for all those lists. But this one sounds like a
> candidate for faster lookups.

Entries will be added into this list only once file is closed and will
remain for acregmax amount interval.
So,  Will this affect performance i.e during lookups ?

> 3. Minor comment. Maybe change the field name oplock_deferred_close to
> oplock_break_received?

Addressed. Attached the patch.
>
> Regards,
> Shyam

>I wonder why the choice of 5 seconds? It seems to me a more natural
>interval on the order of one or more of
>- attribute cache timeout
>- lease time
>- echo_interval

Yes, This sounds good. I modified the patch to defer by attribute
cache timeout interval.

>Also, this wording is rather confusing:

>> When file is closed, SMB2 close request is not sent to server
>> immediately and is deferred for 5 seconds interval. When file is
>> reopened by same process for read or write, previous file handle
>> can be used until oplock is held.

>It's not a "previous" filehandle if it's open, and "can be used" is
>a rather passive statement. A better wording may be "the filehandle
>is reused".

>And, "until oplock is held" is similarly awkward. Do you mean "*if*
>an oplock is held", or "*provided" an oplock is held"?

>> When same file is reopened by another client during 5 second
>> interval, oplock break is sent by server and file is closed immediately
>> if reference count is zero or else oplock is downgraded.

>Only the second part of the sentence is relevant to the patch. Also,
>what about lease break?

Modified the patch.

>What happens if the handle is durable or persistent, and the connection
>to the server times out? Is the handle recovered, then closed?

Do you mean when the session gets reconnected, the deferred handle
will be recovered and closed?

Regards,
Rohith

On Thu, Mar 11, 2021 at 11:25 PM Tom Talpey <tom@talpey.com> wrote:
>
> On 3/11/2021 8:47 AM, Shyam Prasad N wrote:
> > Hi Rohith,
> >
> > The changes look good at a high level.
> >
> > Just a few points worth checking:
> > 1. In cifs_open(), should be perform deferred close for certain cases
> > like O_DIRECT? AFAIK, O_DIRECT is just a hint to the filesystem to
> > perform less data caching. By deferring close, aren't we delaying
> > flushing dirty pages? @Steve French ?
> > 2. I see that you're maintaining a new list of files for deferred
> > closing. Since there could be a large number of such files for a big
> > share with sufficient I/O, maybe we should think of a structure with
> > faster lookups (rb trees?).
> > I know we already have a bunch of linked lists in cifs.ko, and we need
> > to review perf impact for all those lists. But this one sounds like a
> > candidate for faster lookups.
> > 3. Minor comment. Maybe change the field name oplock_deferred_close to
> > oplock_break_received?
> >
> > Regards,
> > Shyam
>
> I wonder why the choice of 5 seconds? It seems to me a more natural
> interval on the order of one or more of
> - attribute cache timeout
> - lease time
> - echo_interval
>
> Also, this wording is rather confusing:
>
> > When file is closed, SMB2 close request is not sent to server
> > immediately and is deferred for 5 seconds interval. When file is
> > reopened by same process for read or write, previous file handle
> > can be used until oplock is held.
>
> It's not a "previous" filehandle if it's open, and "can be used" is
> a rather passive statement. A better wording may be "the filehandle
> is reused".
>
> And, "until oplock is held" is similarly awkward. Do you mean "*if*
> an oplock is held", or "*provided" an oplock is held"?
>
> > When same file is reopened by another client during 5 second
> > interval, oplock break is sent by server and file is closed immediately
> > if reference count is zero or else oplock is downgraded.
>
> Only the second part of the sentence is relevant to the patch. Also,
> what about lease break?
>
> What happens if the handle is durable or persistent, and the connection
> to the server times out? Is the handle recovered, then closed?
>
> Tom.
>
>
> > On Tue, Mar 9, 2021 at 2:41 PM Rohith Surabattula
> > <rohiths.msft@gmail.com> wrote:
> >>
> >> Hi All,
> >>
> >> Please find the attached patch which will defer the close to server.
> >> So, performance can be improved.
> >>
> >> i.e When file is open, write, close, open, read, close....
> >> As close is deferred and oplock is held, cache will not be invalidated
> >> and same handle can be used for second open.
> >>
> >> Please review the changes and let me know your thoughts.
> >>
> >> Regards,
> >> Rohith
> >
> >
> >

--000000000000c73c5505be231a83
Content-Type: application/octet-stream; 
	name="0001-cifs-Deferred-close-for-files.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Deferred-close-for-files.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kmkud08u0>
X-Attachment-Id: f_kmkud08u0

RnJvbSBjYTQyY2YwMzg4YzE5NGU4MzVlNDE0YjU4MTE0NDNiM2EyN2RlNGRlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb2hpdGggU3VyYWJhdHR1bGEgPHJvaGl0aHNAbWljcm9zb2Z0
LmNvbT4KRGF0ZTogTW9uLCA4IE1hciAyMDIxIDE2OjI4OjA5ICswMDAwClN1YmplY3Q6IFtQQVRD
SF0gY2lmczogRGVmZXJyZWQgY2xvc2UgZm9yIGZpbGVzCgpXaGVuIGZpbGUgaXMgY2xvc2VkLCBT
TUIyIGNsb3NlIHJlcXVlc3QgaXMgbm90IHNlbnQgdG8gc2VydmVyCmltbWVkaWF0ZWx5IGFuZCBp
cyBkZWZlcnJlZCBmb3IgYWNyZWdtYXggZGVmaW5lZCBpbnRlcnZhbC4gV2hlbiBmaWxlIGlzCnJl
b3BlbmVkIGJ5IHNhbWUgcHJvY2VzcyBmb3IgcmVhZCBvciB3cml0ZSwgdGhlIGZpbGUgaGFuZGxl
CmlzIHJldXNlZCBpZiBhbiBvcGxvY2sgaXMgaGVsZC4KCldoZW4gY2xpZW50IHJlY2VpdmVzIGEg
b3Bsb2NrL2xlYXNlIGJyZWFrLCBmaWxlIGlzIGNsb3NlZCBpbW1lZGlhdGVseQppZiByZWZlcmVu
Y2UgY291bnQgaXMgemVybywgZWxzZSBvcGxvY2sgaXMgZG93bmdyYWRlZC4KClNpZ25lZC1vZmYt
Ynk6IFJvaGl0aCBTdXJhYmF0dHVsYSA8cm9oaXRoc0BtaWNyb3NvZnQuY29tPgotLS0KIGZzL2Np
ZnMvY2lmc2ZzLmMgICAgfCAxMyArKysrKysrKystCiBmcy9jaWZzL2NpZnNnbG9iLmggIHwgMTIg
KysrKysrKysrCiBmcy9jaWZzL2NpZnNwcm90by5oIHwgIDggKysrKysrCiBmcy9jaWZzL2Nvbm5l
Y3QuYyAgIHwgIDEgKwogZnMvY2lmcy9maWxlLmMgICAgICB8IDYzICsrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKystLQogZnMvY2lmcy9taXNjLmMgICAgICB8IDQ3ICsr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwogNiBmaWxlcyBjaGFuZ2VkLCAxNDEgaW5z
ZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNmcy5j
IGIvZnMvY2lmcy9jaWZzZnMuYwppbmRleCAwOTlhZDlmMzY2MGIuLjNhNDI2ZWZiYTk0ZSAxMDA2
NDQKLS0tIGEvZnMvY2lmcy9jaWZzZnMuYworKysgYi9mcy9jaWZzL2NpZnNmcy5jCkBAIC0xMzMs
NiArMTMzLDcgQEAgc3RydWN0IHdvcmtxdWV1ZV9zdHJ1Y3QJKmNpZnNpb2Rfd3E7CiBzdHJ1Y3Qg
d29ya3F1ZXVlX3N0cnVjdAkqZGVjcnlwdF93cTsKIHN0cnVjdCB3b3JrcXVldWVfc3RydWN0CSpm
aWxlaW5mb19wdXRfd3E7CiBzdHJ1Y3Qgd29ya3F1ZXVlX3N0cnVjdAkqY2lmc29wbG9ja2Rfd3E7
CitzdHJ1Y3Qgd29ya3F1ZXVlX3N0cnVjdCAqZGVmZXJyZWRjbG9zZV93cTsKIF9fdTMyIGNpZnNf
bG9ja19zZWNyZXQ7CiAKIC8qCkBAIC0xNjA1LDkgKzE2MDYsMTYgQEAgaW5pdF9jaWZzKHZvaWQp
CiAJCWdvdG8gb3V0X2Rlc3Ryb3lfZmlsZWluZm9fcHV0X3dxOwogCX0KIAorCWRlZmVycmVkY2xv
c2Vfd3EgPSBhbGxvY193b3JrcXVldWUoImRlZmVycmVkY2xvc2UiLAorCQkJCQkgICBXUV9GUkVF
WkFCTEV8V1FfTUVNX1JFQ0xBSU0sIDApOworCWlmICghZGVmZXJyZWRjbG9zZV93cSkgeworCQly
YyA9IC1FTk9NRU07CisJCWdvdG8gb3V0X2Rlc3Ryb3lfY2lmc29wbG9ja2Rfd3E7CisJfQorCiAJ
cmMgPSBjaWZzX2ZzY2FjaGVfcmVnaXN0ZXIoKTsKIAlpZiAocmMpCi0JCWdvdG8gb3V0X2Rlc3Ry
b3lfY2lmc29wbG9ja2Rfd3E7CisJCWdvdG8gb3V0X2Rlc3Ryb3lfZGVmZXJyZWRjbG9zZV93cTsK
IAogCXJjID0gY2lmc19pbml0X2lub2RlY2FjaGUoKTsKIAlpZiAocmMpCkBAIC0xNjc1LDYgKzE2
ODMsOCBAQCBpbml0X2NpZnModm9pZCkKIAljaWZzX2Rlc3Ryb3lfaW5vZGVjYWNoZSgpOwogb3V0
X3VucmVnX2ZzY2FjaGU6CiAJY2lmc19mc2NhY2hlX3VucmVnaXN0ZXIoKTsKK291dF9kZXN0cm95
X2RlZmVycmVkY2xvc2Vfd3E6CisJZGVzdHJveV93b3JrcXVldWUoZGVmZXJyZWRjbG9zZV93cSk7
CiBvdXRfZGVzdHJveV9jaWZzb3Bsb2NrZF93cToKIAlkZXN0cm95X3dvcmtxdWV1ZShjaWZzb3Bs
b2NrZF93cSk7CiBvdXRfZGVzdHJveV9maWxlaW5mb19wdXRfd3E6CkBAIC0xNzA5LDYgKzE3MTks
NyBAQCBleGl0X2NpZnModm9pZCkKIAljaWZzX2Rlc3Ryb3lfbWlkcygpOwogCWNpZnNfZGVzdHJv
eV9pbm9kZWNhY2hlKCk7CiAJY2lmc19mc2NhY2hlX3VucmVnaXN0ZXIoKTsKKwlkZXN0cm95X3dv
cmtxdWV1ZShkZWZlcnJlZGNsb3NlX3dxKTsKIAlkZXN0cm95X3dvcmtxdWV1ZShjaWZzb3Bsb2Nr
ZF93cSk7CiAJZGVzdHJveV93b3JrcXVldWUoZGVjcnlwdF93cSk7CiAJZGVzdHJveV93b3JrcXVl
dWUoZmlsZWluZm9fcHV0X3dxKTsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2dsb2IuaCBiL2Zz
L2NpZnMvY2lmc2dsb2IuaAppbmRleCAzMWZjODY5NWFiZDYuLjQ4ODU4ZTMxYjc0NiAxMDA2NDQK
LS0tIGEvZnMvY2lmcy9jaWZzZ2xvYi5oCisrKyBiL2ZzL2NpZnMvY2lmc2dsb2IuaApAQCAtMTA5
Nyw2ICsxMDk3LDggQEAgc3RydWN0IGNpZnNfdGNvbiB7CiAjaWZkZWYgQ09ORklHX0NJRlNfU1dO
X1VQQ0FMTAogCWJvb2wgdXNlX3dpdG5lc3M6MTsgLyogdXNlIHdpdG5lc3MgcHJvdG9jb2wgKi8K
ICNlbmRpZgorCXN0cnVjdCBsaXN0X2hlYWQgZGVmZXJyZWRfY2xvc2VzOyAvKiBsaXN0IG9mIGRl
ZmVycmVkIGNsb3NlcyAqLworCXNwaW5sb2NrX3QgZGVmZXJyZWRfbG9jazsgLyogcHJvdGVjdGlv
biBvbiBkZWZlcnJlZCBsaXN0ICovCiB9OwogCiAvKgpAQCAtMTE1NCw2ICsxMTU2LDE0IEBAIHN0
cnVjdCBjaWZzX3BlbmRpbmdfb3BlbiB7CiAJX191MzIgb3Bsb2NrOwogfTsKIAorc3RydWN0IGNp
ZnNfZGVmZXJyZWRfY2xvc2UgeworCXN0cnVjdCBsaXN0X2hlYWQgZGxpc3Q7CisJc3RydWN0IHRj
b25fbGluayAqdGxpbms7CisJX191MTYgIG5ldGZpZDsKKwlfX3U2NCAgcGVyc2lzdGVudF9maWQ7
CisJX191NjQgIHZvbGF0aWxlX2ZpZDsKK307CisKIC8qCiAgKiBUaGlzIGluZm8gaGFuZ3Mgb2Zm
IHRoZSBjaWZzRmlsZUluZm8gc3RydWN0dXJlLCBwb2ludGVkIHRvIGJ5IGxsaXN0LgogICogVGhp
cyBpcyB1c2VkIHRvIHRyYWNrIGJ5dGUgc3RyZWFtIGxvY2tzIG9uIHRoZSBmaWxlCkBAIC0xMjQ4
LDYgKzEyNTgsNyBAQCBzdHJ1Y3QgY2lmc0ZpbGVJbmZvIHsKIAlzdHJ1Y3QgY2lmc19zZWFyY2hf
aW5mbyBzcmNoX2luZjsKIAlzdHJ1Y3Qgd29ya19zdHJ1Y3Qgb3Bsb2NrX2JyZWFrOyAvKiB3b3Jr
IGZvciBvcGxvY2sgYnJlYWtzICovCiAJc3RydWN0IHdvcmtfc3RydWN0IHB1dDsgLyogd29yayBm
b3IgdGhlIGZpbmFsIHBhcnQgb2YgX3B1dCAqLworCWJvb2wgb3Bsb2NrX2JyZWFrX3JlY2VpdmVk
OyAvKiBGbGFnIHRvIGluZGljYXRlIG9wbG9jayBicmVhayAqLwogfTsKIAogc3RydWN0IGNpZnNf
aW9fcGFybXMgewpAQCAtMTg5OCw2ICsxOTA5LDcgQEAgZXh0ZXJuIHN0cnVjdCB3b3JrcXVldWVf
c3RydWN0ICpjaWZzaW9kX3dxOwogZXh0ZXJuIHN0cnVjdCB3b3JrcXVldWVfc3RydWN0ICpkZWNy
eXB0X3dxOwogZXh0ZXJuIHN0cnVjdCB3b3JrcXVldWVfc3RydWN0ICpmaWxlaW5mb19wdXRfd3E7
CiBleHRlcm4gc3RydWN0IHdvcmtxdWV1ZV9zdHJ1Y3QgKmNpZnNvcGxvY2tkX3dxOworZXh0ZXJu
IHN0cnVjdCB3b3JrcXVldWVfc3RydWN0ICpkZWZlcnJlZGNsb3NlX3dxOwogZXh0ZXJuIF9fdTMy
IGNpZnNfbG9ja19zZWNyZXQ7CiAKIGV4dGVybiBtZW1wb29sX3QgKmNpZnNfbWlkX3Bvb2xwOwpk
aWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzcHJvdG8uaCBiL2ZzL2NpZnMvY2lmc3Byb3RvLmgKaW5k
ZXggNzVjZTZmNzQyYjhkLi5hMzViNTk5ZDUzYTUgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc3By
b3RvLmgKKysrIGIvZnMvY2lmcy9jaWZzcHJvdG8uaApAQCAtMjU2LDYgKzI1NiwxNCBAQCBleHRl
cm4gdm9pZCBjaWZzX2FkZF9wZW5kaW5nX29wZW5fbG9ja2VkKHN0cnVjdCBjaWZzX2ZpZCAqZmlk
LAogCQkJCQkgc3RydWN0IHRjb25fbGluayAqdGxpbmssCiAJCQkJCSBzdHJ1Y3QgY2lmc19wZW5k
aW5nX29wZW4gKm9wZW4pOwogZXh0ZXJuIHZvaWQgY2lmc19kZWxfcGVuZGluZ19vcGVuKHN0cnVj
dCBjaWZzX3BlbmRpbmdfb3BlbiAqb3Blbik7CisKK2V4dGVybiBib29sIGNpZnNfaXNfZGVmZXJy
ZWRfY2xvc2Uoc3RydWN0IGNpZnNGaWxlSW5mbyAqY2ZpbGUsCisJCQkJc3RydWN0IGNpZnNfZGVm
ZXJyZWRfY2xvc2UgKipkY2xvc2UpOworCitleHRlcm4gdm9pZCBjaWZzX2FkZF9kZWZlcnJlZF9j
bG9zZShzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpjZmlsZSk7CisKK2V4dGVybiB2b2lkIGNpZnNfZGVs
X2RlZmVycmVkX2Nsb3NlKHN0cnVjdCBjaWZzRmlsZUluZm8gKmNmaWxlKTsKKwogZXh0ZXJuIHN0
cnVjdCBUQ1BfU2VydmVyX0luZm8gKmNpZnNfZ2V0X3RjcF9zZXNzaW9uKHN0cnVjdCBzbWIzX2Zz
X2NvbnRleHQgKmN0eCk7CiBleHRlcm4gdm9pZCBjaWZzX3B1dF90Y3Bfc2Vzc2lvbihzdHJ1Y3Qg
VENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsCiAJCQkJIGludCBmcm9tX3JlY29ubmVjdCk7CmRpZmYg
LS1naXQgYS9mcy9jaWZzL2Nvbm5lY3QuYyBiL2ZzL2NpZnMvY29ubmVjdC5jCmluZGV4IGVlYzhh
MjA1MmRhMi4uMjgwNDYzNGQ0MDQwIDEwMDY0NAotLS0gYS9mcy9jaWZzL2Nvbm5lY3QuYworKysg
Yi9mcy9jaWZzL2Nvbm5lY3QuYwpAQCAtMjIyOCw2ICsyMjI4LDcgQEAgY2lmc19nZXRfdGNvbihz
dHJ1Y3QgY2lmc19zZXMgKnNlcywgc3RydWN0IHNtYjNfZnNfY29udGV4dCAqY3R4KQogCXRjb24t
Pm5vZGVsZXRlID0gY3R4LT5ub2RlbGV0ZTsKIAl0Y29uLT5sb2NhbF9sZWFzZSA9IGN0eC0+bG9j
YWxfbGVhc2U7CiAJSU5JVF9MSVNUX0hFQUQoJnRjb24tPnBlbmRpbmdfb3BlbnMpOworCUlOSVRf
TElTVF9IRUFEKCZ0Y29uLT5kZWZlcnJlZF9jbG9zZXMpOwogCiAJc3Bpbl9sb2NrKCZjaWZzX3Rj
cF9zZXNfbG9jayk7CiAJbGlzdF9hZGQoJnRjb24tPnRjb25fbGlzdCwgJnNlcy0+dGNvbl9saXN0
KTsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvZmlsZS5jIGIvZnMvY2lmcy9maWxlLmMKaW5kZXggMjZk
ZTQzMjlkMTYxLi41YzE0MGRiZTlhNmIgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvZmlsZS5jCisrKyBi
L2ZzL2NpZnMvZmlsZS5jCkBAIC0zMjEsNiArMzIxLDcgQEAgY2lmc19uZXdfZmlsZWluZm8oc3Ry
dWN0IGNpZnNfZmlkICpmaWQsIHN0cnVjdCBmaWxlICpmaWxlLAogCWNmaWxlLT5kZW50cnkgPSBk
Z2V0KGRlbnRyeSk7CiAJY2ZpbGUtPmZfZmxhZ3MgPSBmaWxlLT5mX2ZsYWdzOwogCWNmaWxlLT5p
bnZhbGlkSGFuZGxlID0gZmFsc2U7CisJY2ZpbGUtPm9wbG9ja19icmVha19yZWNlaXZlZCA9IGZh
bHNlOwogCWNmaWxlLT50bGluayA9IGNpZnNfZ2V0X3RsaW5rKHRsaW5rKTsKIAlJTklUX1dPUkso
JmNmaWxlLT5vcGxvY2tfYnJlYWssIGNpZnNfb3Bsb2NrX2JyZWFrKTsKIAlJTklUX1dPUksoJmNm
aWxlLT5wdXQsIGNpZnNGaWxlSW5mb19wdXRfd29yayk7CkBAIC01NjIsNiArNTYzLDE3IEBAIGlu
dCBjaWZzX29wZW4oc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZpbGUpCiAJCQlm
aWxlLT5mX29wID0gJmNpZnNfZmlsZV9kaXJlY3Rfb3BzOwogCX0KIAorCXNwaW5fbG9jaygmdGNv
bi0+ZGVmZXJyZWRfbG9jayk7CisJLyogR2V0IHRoZSBjYWNoZWQgaGFuZGxlIGFzIFNNQjIgY2xv
c2UgaXMgZGVmZXJyZWQgKi8KKwlyYyA9IGNpZnNfZ2V0X3JlYWRhYmxlX3BhdGgodGNvbiwgZnVs
bF9wYXRoLCAmY2ZpbGUpOworCWlmIChyYyA9PSAwKSB7CisJCWZpbGUtPnByaXZhdGVfZGF0YSA9
IGNmaWxlOworCQljaWZzX2RlbF9kZWZlcnJlZF9jbG9zZShjZmlsZSk7CisJCXNwaW5fdW5sb2Nr
KCZ0Y29uLT5kZWZlcnJlZF9sb2NrKTsKKwkJZ290byBvdXQ7CisJfQorCXNwaW5fdW5sb2NrKCZ0
Y29uLT5kZWZlcnJlZF9sb2NrKTsKKwogCWlmIChzZXJ2ZXItPm9wbG9ja3MpCiAJCW9wbG9jayA9
IFJFUV9PUExPQ0s7CiAJZWxzZQpAQCAtODQyLDExICs4NTQsNDUgQEAgY2lmc19yZW9wZW5fZmls
ZShzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpjZmlsZSwgYm9vbCBjYW5fZmx1c2gpCiAJcmV0dXJuIHJj
OwogfQogCitzdHJ1Y3Qgc21iMl9kZWZlcnJlZF93b3JrIHsKKwlzdHJ1Y3QgZGVsYXllZF93b3Jr
IGRlZmVycmVkOworCXN0cnVjdCBjaWZzRmlsZUluZm8gKmNmaWxlOworfTsKKwordm9pZCBzbWIy
X2RlZmVycmVkX3dvcmtfY2xvc2Uoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQoreworCXN0cnVj
dCBzbWIyX2RlZmVycmVkX3dvcmsgKmR3b3JrID0gY29udGFpbmVyX29mKHdvcmssCisJCQlzdHJ1
Y3Qgc21iMl9kZWZlcnJlZF93b3JrLCBkZWZlcnJlZC53b3JrKTsKKworCXNwaW5fbG9jaygmdGxp
bmtfdGNvbihkd29yay0+Y2ZpbGUtPnRsaW5rKS0+ZGVmZXJyZWRfbG9jayk7CisJY2lmc19kZWxf
ZGVmZXJyZWRfY2xvc2UoZHdvcmstPmNmaWxlKTsKKwlzcGluX3VubG9jaygmdGxpbmtfdGNvbihk
d29yay0+Y2ZpbGUtPnRsaW5rKS0+ZGVmZXJyZWRfbG9jayk7CisJX2NpZnNGaWxlSW5mb19wdXQo
ZHdvcmstPmNmaWxlLCB0cnVlLCBmYWxzZSk7Cit9CisKIGludCBjaWZzX2Nsb3NlKHN0cnVjdCBp
bm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlKQogeworCXN0cnVjdCBzbWIyX2RlZmVycmVk
X3dvcmsgKmR3b3JrOworCXN0cnVjdCBjaWZzSW5vZGVJbmZvICpjaW5vZGUgPSBDSUZTX0koaW5v
ZGUpOworCXN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2IgPSBDSUZTX1NCKGlub2RlLT5pX3Ni
KTsKKworCWR3b3JrID0ga21hbGxvYyhzaXplb2Yoc3RydWN0IHNtYjJfZGVmZXJyZWRfd29yayks
IEdGUF9LRVJORUwpOworCisJSU5JVF9ERUxBWUVEX1dPUksoJmR3b3JrLT5kZWZlcnJlZCwgc21i
Ml9kZWZlcnJlZF93b3JrX2Nsb3NlKTsKKwogCWlmIChmaWxlLT5wcml2YXRlX2RhdGEgIT0gTlVM
TCkgewotCQlfY2lmc0ZpbGVJbmZvX3B1dChmaWxlLT5wcml2YXRlX2RhdGEsIHRydWUsIGZhbHNl
KTsKKwkJZHdvcmstPmNmaWxlID0gZmlsZS0+cHJpdmF0ZV9kYXRhOwogCQlmaWxlLT5wcml2YXRl
X2RhdGEgPSBOVUxMOworCQlpZiAoKGNpbm9kZS0+b3Bsb2NrID09IENJRlNfQ0FDSEVfUkhXX0ZM
RykgfHwKKwkJICAgIChjaW5vZGUtPm9wbG9jayA9PSBDSUZTX0NBQ0hFX1JIX0ZMRykpIHsKKwkJ
CXNwaW5fbG9jaygmdGxpbmtfdGNvbihkd29yay0+Y2ZpbGUtPnRsaW5rKS0+ZGVmZXJyZWRfbG9j
ayk7CisJCQljaWZzX2FkZF9kZWZlcnJlZF9jbG9zZShkd29yay0+Y2ZpbGUpOworCQkJc3Bpbl91
bmxvY2soJnRsaW5rX3Rjb24oZHdvcmstPmNmaWxlLT50bGluayktPmRlZmVycmVkX2xvY2spOwor
CQkJLyogRGVmZXJyZWQgY2xvc2UgZm9yIGZpbGVzICovCisJCQlxdWV1ZV9kZWxheWVkX3dvcmso
ZGVmZXJyZWRjbG9zZV93cSwgJmR3b3JrLT5kZWZlcnJlZCwgY2lmc19zYi0+Y3R4LT5hY3JlZ21h
eCk7CisJCX0gZWxzZSB7CisJCQlfY2lmc0ZpbGVJbmZvX3B1dChkd29yay0+Y2ZpbGUsIHRydWUs
IGZhbHNlKTsKKwkJfQogCX0KIAogCS8qIHJldHVybiBjb2RlIGZyb20gdGhlIC0+cmVsZWFzZSBv
cCBpcyBhbHdheXMgaWdub3JlZCAqLwpAQCAtMTk0Myw3ICsxOTg5LDggQEAgc3RydWN0IGNpZnNG
aWxlSW5mbyAqZmluZF9yZWFkYWJsZV9maWxlKHN0cnVjdCBjaWZzSW5vZGVJbmZvICpjaWZzX2lu
b2RlLAogCQlpZiAoZnN1aWRfb25seSAmJiAhdWlkX2VxKG9wZW5fZmlsZS0+dWlkLCBjdXJyZW50
X2ZzdWlkKCkpKQogCQkJY29udGludWU7CiAJCWlmIChPUEVOX0ZNT0RFKG9wZW5fZmlsZS0+Zl9m
bGFncykgJiBGTU9ERV9SRUFEKSB7Ci0JCQlpZiAoIW9wZW5fZmlsZS0+aW52YWxpZEhhbmRsZSkg
eworCQkJaWYgKCghb3Blbl9maWxlLT5pbnZhbGlkSGFuZGxlKSAmJgorCQkJCSghb3Blbl9maWxl
LT5vcGxvY2tfYnJlYWtfcmVjZWl2ZWQpKSB7CiAJCQkJLyogZm91bmQgYSBnb29kIGZpbGUgKi8K
IAkJCQkvKiBsb2NrIGl0IHNvIGl0IHdpbGwgbm90IGJlIGNsb3NlZCBvbiB1cyAqLwogCQkJCWNp
ZnNGaWxlSW5mb19nZXQob3Blbl9maWxlKTsKQEAgLTQ3NDYsNiArNDc5Myw4IEBAIHZvaWQgY2lm
c19vcGxvY2tfYnJlYWsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQogCXN0cnVjdCBUQ1BfU2Vy
dmVyX0luZm8gKnNlcnZlciA9IHRjb24tPnNlcy0+c2VydmVyOwogCWludCByYyA9IDA7CiAJYm9v
bCBwdXJnZV9jYWNoZSA9IGZhbHNlOworCWJvb2wgaXNfZGVmZXJyZWQgPSBmYWxzZTsKKwlzdHJ1
Y3QgY2lmc19kZWZlcnJlZF9jbG9zZSAqZGNsb3NlOwogCiAJd2FpdF9vbl9iaXQoJmNpbm9kZS0+
ZmxhZ3MsIENJRlNfSU5PREVfUEVORElOR19XUklURVJTLAogCQkJVEFTS19VTklOVEVSUlVQVElC
TEUpOwpAQCAtNDc5Myw2ICs0ODQyLDE2IEBAIHZvaWQgY2lmc19vcGxvY2tfYnJlYWsoc3RydWN0
IHdvcmtfc3RydWN0ICp3b3JrKQogCQljaWZzX2RiZyhGWUksICJPcGxvY2sgcmVsZWFzZSByYyA9
ICVkXG4iLCByYyk7CiAJfQogCV9jaWZzRmlsZUluZm9fcHV0KGNmaWxlLCBmYWxzZSAvKiBkbyBu
b3Qgd2FpdCBmb3Igb3Vyc2VsZiAqLywgZmFsc2UpOworCS8qCisJICogV2hlbiBvcGxvY2sgYnJl
YWsgaXMgcmVjZWl2ZWQgYW5kIHRoZXJlIGFyZSBubyBhY3RpdmUKKwkgKiBmaWxlIGhhbmRsZXMg
YnV0IGNhY2hlZCwgdGhlbiBzZXQgdGhlIGZsYWcgb3Bsb2NrX2JyZWFrX3JlY2VpdmVkLgorCSAq
IFNvLCBuZXcgb3BlbiB3aWxsIG5vdCB1c2UgY2FjaGVkIGhhbmRsZS4KKwkgKi8KKwlzcGluX2xv
Y2soJnRsaW5rX3Rjb24oY2ZpbGUtPnRsaW5rKS0+ZGVmZXJyZWRfbG9jayk7CisJaXNfZGVmZXJy
ZWQgPSBjaWZzX2lzX2RlZmVycmVkX2Nsb3NlKGNmaWxlLCAmZGNsb3NlKTsKKwlpZiAoaXNfZGVm
ZXJyZWQpCisJCWNmaWxlLT5vcGxvY2tfYnJlYWtfcmVjZWl2ZWQgPSB0cnVlOworCXNwaW5fdW5s
b2NrKCZ0bGlua190Y29uKGNmaWxlLT50bGluayktPmRlZmVycmVkX2xvY2spOwogCWNpZnNfZG9u
ZV9vcGxvY2tfYnJlYWsoY2lub2RlKTsKIH0KIApkaWZmIC0tZ2l0IGEvZnMvY2lmcy9taXNjLmMg
Yi9mcy9jaWZzL21pc2MuYwppbmRleCA4MmUxNzY3MjBjYTYuLjI5OGNjOGI1NDg1NyAxMDA2NDQK
LS0tIGEvZnMvY2lmcy9taXNjLmMKKysrIGIvZnMvY2lmcy9taXNjLmMKQEAgLTEzNiw2ICsxMzYs
NyBAQCB0Y29uSW5mb0FsbG9jKHZvaWQpCiAJc3Bpbl9sb2NrX2luaXQoJnJldF9idWYtPnN0YXRf
bG9jayk7CiAJYXRvbWljX3NldCgmcmV0X2J1Zi0+bnVtX2xvY2FsX29wZW5zLCAwKTsKIAlhdG9t
aWNfc2V0KCZyZXRfYnVmLT5udW1fcmVtb3RlX29wZW5zLCAwKTsKKwlzcGluX2xvY2tfaW5pdCgm
cmV0X2J1Zi0+ZGVmZXJyZWRfbG9jayk7CiAKIAlyZXR1cm4gcmV0X2J1ZjsKIH0KQEAgLTY3Miw2
ICs2NzMsNTIgQEAgY2lmc19hZGRfcGVuZGluZ19vcGVuKHN0cnVjdCBjaWZzX2ZpZCAqZmlkLCBz
dHJ1Y3QgdGNvbl9saW5rICp0bGluaywKIAlzcGluX3VubG9jaygmdGxpbmtfdGNvbihvcGVuLT50
bGluayktPm9wZW5fZmlsZV9sb2NrKTsKIH0KIAorYm9vbAorY2lmc19pc19kZWZlcnJlZF9jbG9z
ZShzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpjZmlsZSwgc3RydWN0IGNpZnNfZGVmZXJyZWRfY2xvc2Ug
KipwZGNsb3NlKQoreworCXN0cnVjdCBjaWZzX2RlZmVycmVkX2Nsb3NlICpkY2xvc2U7CisKKwls
aXN0X2Zvcl9lYWNoX2VudHJ5KGRjbG9zZSwgJnRsaW5rX3Rjb24oY2ZpbGUtPnRsaW5rKS0+ZGVm
ZXJyZWRfY2xvc2VzLCBkbGlzdCkgeworCQlpZiAoKGRjbG9zZS0+bmV0ZmlkID09IGNmaWxlLT5m
aWQubmV0ZmlkKSAmJgorCQkJKGRjbG9zZS0+cGVyc2lzdGVudF9maWQgPT0gY2ZpbGUtPmZpZC5w
ZXJzaXN0ZW50X2ZpZCkgJiYKKwkJCShkY2xvc2UtPnZvbGF0aWxlX2ZpZCA9PSBjZmlsZS0+Zmlk
LnZvbGF0aWxlX2ZpZCkpIHsKKwkJCSpwZGNsb3NlID0gZGNsb3NlOworCQkJcmV0dXJuIHRydWU7
CisJCX0KKwl9CisJcmV0dXJuIGZhbHNlOworfQorCit2b2lkCitjaWZzX2FkZF9kZWZlcnJlZF9j
bG9zZShzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpjZmlsZSkKK3sKKwlib29sIGlzX2RlZmVycmVkID0g
ZmFsc2U7CisJc3RydWN0IGNpZnNfZGVmZXJyZWRfY2xvc2UgKmRjbG9zZTsKKworCWlzX2RlZmVy
cmVkID0gY2lmc19pc19kZWZlcnJlZF9jbG9zZShjZmlsZSwgJmRjbG9zZSk7CisJaWYgKGlzX2Rl
ZmVycmVkKQorCQlyZXR1cm47CisKKwlkY2xvc2UgPSBrbWFsbG9jKHNpemVvZihzdHJ1Y3QgY2lm
c19kZWZlcnJlZF9jbG9zZSksIEdGUF9LRVJORUwpOworCWRjbG9zZS0+dGxpbmsgPSBjZmlsZS0+
dGxpbms7CisJZGNsb3NlLT5uZXRmaWQgPSBjZmlsZS0+ZmlkLm5ldGZpZDsKKwlkY2xvc2UtPnBl
cnNpc3RlbnRfZmlkID0gY2ZpbGUtPmZpZC5wZXJzaXN0ZW50X2ZpZDsKKwlkY2xvc2UtPnZvbGF0
aWxlX2ZpZCA9IGNmaWxlLT5maWQudm9sYXRpbGVfZmlkOworCWxpc3RfYWRkX3RhaWwoJmRjbG9z
ZS0+ZGxpc3QsICZ0bGlua190Y29uKGRjbG9zZS0+dGxpbmspLT5kZWZlcnJlZF9jbG9zZXMpOwor
fQorCit2b2lkCitjaWZzX2RlbF9kZWZlcnJlZF9jbG9zZShzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpj
ZmlsZSkKK3sKKwlib29sIGlzX2RlZmVycmVkID0gZmFsc2U7CisJc3RydWN0IGNpZnNfZGVmZXJy
ZWRfY2xvc2UgKmRjbG9zZTsKKworCWlzX2RlZmVycmVkID0gY2lmc19pc19kZWZlcnJlZF9jbG9z
ZShjZmlsZSwgJmRjbG9zZSk7CisJaWYgKCFpc19kZWZlcnJlZCkKKwkJcmV0dXJuOworCWxpc3Rf
ZGVsKCZkY2xvc2UtPmRsaXN0KTsKK30KKwogLyogcGFyc2VzIERGUyByZWZmZXJhbCBWMyBzdHJ1
Y3R1cmUKICAqIGNhbGxlciBpcyByZXNwb25zaWJsZSBmb3IgZnJlZWluZyB0YXJnZXRfbm9kZXMK
ICAqIHJldHVybnM6Ci0tIAoyLjI1LjEKCg==
--000000000000c73c5505be231a83--
