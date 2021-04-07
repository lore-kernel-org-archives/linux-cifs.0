Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D242C433ED
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Apr 2021 14:58:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6628F6113D
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Apr 2021 14:58:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353135AbhDGO6V (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Apr 2021 10:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353202AbhDGO6V (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Apr 2021 10:58:21 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7FBC06175F
        for <linux-cifs@vger.kernel.org>; Wed,  7 Apr 2021 07:58:11 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id w10so7765201pgh.5
        for <linux-cifs@vger.kernel.org>; Wed, 07 Apr 2021 07:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YbjDlSu0zQ/dBU4plZvBojfFKCoHB2TazpgWoMBiaVo=;
        b=P4Ad3U8onFkGzWPmOTgnu2pW129YcPK0wGPkWsu/SlQJ9GJ62HiOevl8MxbR1arCDd
         n+xKUGXpMcAFqToiSt9G0G3wcv7z7xEcp9uM6GgRD5ditQHiGrGEOi4jiTZAqfavh8re
         Fiok02nY3T9N/zssIquRDfrBBZC4bYJuj43QResPlSS12hMrYKu1idbm8s435IpksA4W
         kNSMKtRggTt7PAVWgepoESTa0eHJbceQ234f7HeueYUTgvF7IQcrYfd/fI3MZUiEmTsD
         2Xs68ES4AdIVsTepqipFMzn0P5MY8xbjoCvqG3WbjfVtoScMvbnVhosFIP0Kh1brjfTf
         1QIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YbjDlSu0zQ/dBU4plZvBojfFKCoHB2TazpgWoMBiaVo=;
        b=QAwf45d4zCutB6ZDNIIG4stAlyxqngHKD0KplnipbDduTaZ193fEoMe5m43/zWYnry
         Tc3vawZB7tHGFmRWMXzJqdpnhAZxnOrqMbm52/zvisYhUWqvzQ5eKJO7yD3pKE7el5z6
         /QBXbqJgXQDIGoKUfX3LbK1Sy8ZjapBGeplVAbnnmPXURdo1n8ZAyeSNS6tfPwK19Hr/
         Ex8WnQ4d5TNdBfn9Jq0aWSBuuF3/+jSycg8lKTNXm1tFffSTNrCztefXWGbRHdFsDfK3
         0jURYO9Z5guJZE75JD7L3el3hu/CczlClS55jVQL+nUP3pnLD5U/HKf1SQaVJi5E+7Ww
         /ckg==
X-Gm-Message-State: AOAM530/2cEaHBNaCH0BjXrmcvccnLXmS3RN1zD9jvkv4MhT1zVCEMb+
        wLAFbnfkBFXIlgZjkxzyiW3VBD+wB7S1me6NmVY=
X-Google-Smtp-Source: ABdhPJwh1t0hijvxBQG62zBjcOtreoHs/Gn8qxpI++sjuft/avHkp7dtJOSAzaCs+AxB4W8tK/FhtezdwEhiwcVTfYg=
X-Received: by 2002:a63:54:: with SMTP id 81mr3750602pga.410.1617807490696;
 Wed, 07 Apr 2021 07:58:10 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0Y1NeC0jNTOtjhTtGRt0sfyhyxC=wNfMu1eqibe6qJbwA@mail.gmail.com>
 <CANT5p=pFU=1OKiBA0m0_Pqms4Vsxz7omEgvfDDAb8U3M4-3qbA@mail.gmail.com>
 <461d79c3-1b32-b0f8-157c-b5d4b25507d7@talpey.com> <CACdtm0agzeVRiQg1zZjm=jFrf-gSQ-+YGc1Zm1xN1Pd9tJia4Q@mail.gmail.com>
 <49874720-dc76-2660-17e7-f7157a9725d4@talpey.com> <CACdtm0Z5BfbHp8Y2nFLv0k854hDe6-j4xtYDP4oruKPOtxxz2Q@mail.gmail.com>
In-Reply-To: <CACdtm0Z5BfbHp8Y2nFLv0k854hDe6-j4xtYDP4oruKPOtxxz2Q@mail.gmail.com>
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Wed, 7 Apr 2021 20:27:58 +0530
Message-ID: <CACdtm0ZYHjHXt-n8xnRQgZ+ZdLw4XVdb_yCK3Q_QSG4SrK6_Lw@mail.gmail.com>
Subject: Re: cifs: Deferred close for files
To:     Tom Talpey <tom@talpey.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>, sribhat.msa@outlook.com,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Content-Type: multipart/mixed; boundary="000000000000cc66ed05bf6328c4"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000cc66ed05bf6328c4
Content-Type: text/plain; charset="UTF-8"

Hi All,

Have updated the patch.

patch v2:
1)  Close the file immediately during unlink of file.
2)  Update the reference count properly when deferred work is already scheduled.

Regards,
Rohith

On Thu, Mar 25, 2021 at 8:12 AM Rohith Surabattula
<rohiths.msft@gmail.com> wrote:
>
> >>> Hi Rohith,
> >>>
> >>> The changes look good at a high level.
> >>>
> >>> Just a few points worth checking:
> >>> 1. In cifs_open(), should be perform deferred close for certain cases
> >>> like O_DIRECT? AFAIK, O_DIRECT is just a hint to the filesystem to
> >>> perform less data caching. By deferring close, aren't we delaying
> >>> flushing dirty pages? @Steve French ?
> >>
> >> With O_DIRECT flag, data is not cached locally and will be sent to
> >> server immediately.
> >>
> >>> 2. I see that you're maintaining a new list of files for deferred
> >>> closing. Since there could be a large number of such files for a big
> >>> share with sufficient I/O, maybe we should think of a structure with
> >>> faster lookups (rb trees?).
> >>> I know we already have a bunch of linked lists in cifs.ko, and we need
> >>> to review perf impact for all those lists. But this one sounds like a
> >>> candidate for faster lookups.
> >>
> >> Entries will be added into this list only once file is closed and will
> >> remain for acregmax amount interval.
>
> >I think you mean once the "file descriptor" is closed, right? But now
> >that you mention it, caching the attributes sounds a lot like the
> >NFS close-to-open semantic, which is itself optional with the "nocto"
> >mount option.
>
> >Because some applications use close() to perform flush, there may be
> >some silent side effects as well. I don't see anything special in the
> >patch regarding this. Have you considered it?
> >The change to promptly close the handle on oplock or lease break looks
> >reasonable. The rewording in the patch description is better too.
>
> Yes, as the handle is closed immediately when oplock/lease breaks,
> will there be any
> silent side effects still?
>
> >>> What happens if the handle is durable or persistent, and the connection
> >>> to the server times out? Is the handle recovered, then closed?
> >>
> >> Do you mean when the session gets reconnected, the deferred handle
> >> will be recovered and closed?
>
> >Yes, because I expect the client to attempt to reclaim its handles upon
> >reconnection. I don't see any particular code change regarding this.
>
> >My question is, if there's a deferred close pending, should it do that,
> >or should it simply cut to the chase and close any such handle(s)?
>
> As the handles are persistent once the session gets reconnected,
> applications can reclaim
> the handle. So, i believe no need to close handles immediately until
> timeout(i.e acregmax interval)
>
> Regards,
> Rohith
>
> On Wed, Mar 24, 2021 at 7:50 PM Tom Talpey <tom@talpey.com> wrote:
> >
> > On 3/22/2021 1:07 PM, Rohith Surabattula wrote:
> > > On 3/11/2021 8:47 AM, Shyam Prasad N wrote:
> > >> Hi Rohith,
> > >>
> > >> The changes look good at a high level.
> > >>
> > >> Just a few points worth checking:
> > >> 1. In cifs_open(), should be perform deferred close for certain cases
> > >> like O_DIRECT? AFAIK, O_DIRECT is just a hint to the filesystem to
> > >> perform less data caching. By deferring close, aren't we delaying
> > >> flushing dirty pages? @Steve French ?
> > >
> > > With O_DIRECT flag, data is not cached locally and will be sent to
> > > server immediately.
> > >
> > >> 2. I see that you're maintaining a new list of files for deferred
> > >> closing. Since there could be a large number of such files for a big
> > >> share with sufficient I/O, maybe we should think of a structure with
> > >> faster lookups (rb trees?).
> > >> I know we already have a bunch of linked lists in cifs.ko, and we need
> > >> to review perf impact for all those lists. But this one sounds like a
> > >> candidate for faster lookups.
> > >
> > > Entries will be added into this list only once file is closed and will
> > > remain for acregmax amount interval.
> >
> > I think you mean once the "file descriptor" is closed, right? But now
> > that you mention it, caching the attributes sounds a lot like the
> > NFS close-to-open semantic, which is itself optional with the "nocto"
> > mount option.
> >
> > Because some applications use close() to perform flush, there may be
> > some silent side effects as well. I don't see anything special in the
> > patch regarding this. Have you considered it?
> >
> > > So,  Will this affect performance i.e during lookups ?
> > >
> > >> 3. Minor comment. Maybe change the field name oplock_deferred_close to
> > >> oplock_break_received?
> > >
> > > Addressed. Attached the patch.
> > >>
> > >> Regards,
> > >> Shyam
> > >
> > >> I wonder why the choice of 5 seconds? It seems to me a more natural
> > >> interval on the order of one or more of
> > >> - attribute cache timeout
> > >> - lease time
> > >> - echo_interval
> > >
> > > Yes, This sounds good. I modified the patch to defer by attribute
> > > cache timeout interval.
> > >
> > >> Also, this wording is rather confusing:
> > >
> > >>> When file is closed, SMB2 close request is not sent to server
> > >>> immediately and is deferred for 5 seconds interval. When file is
> > >>> reopened by same process for read or write, previous file handle
> > >>> can be used until oplock is held.
> > >
> > >> It's not a "previous" filehandle if it's open, and "can be used" is
> > >> a rather passive statement. A better wording may be "the filehandle
> > >> is reused".
> > >
> > >> And, "until oplock is held" is similarly awkward. Do you mean "*if*
> > >> an oplock is held", or "*provided" an oplock is held"?
> > >
> > >>> When same file is reopened by another client during 5 second
> > >>> interval, oplock break is sent by server and file is closed immediately
> > >>> if reference count is zero or else oplock is downgraded.
> > >
> > >> Only the second part of the sentence is relevant to the patch. Also,
> > >> what about lease break?
> > >
> > > Modified the patch.
> >
> > The change to promptly close the handle on oplock or lease break looks
> > reasonable. The rewording in the patch description is better too.
> >
> > >> What happens if the handle is durable or persistent, and the connection
> > >> to the server times out? Is the handle recovered, then closed?
> > >
> > > Do you mean when the session gets reconnected, the deferred handle
> > > will be recovered and closed?
> >
> > Yes, because I expect the client to attempt to reclaim its handles upon
> > reconnection. I don't see any particular code change regarding this.
> >
> > My question is, if there's a deferred close pending, should it do that,
> > or should it simply cut to the chase and close any such handle(s)?
> >
> > Tom.
> >
> > > Regards,
> > > Rohith
> > >
> > > On Thu, Mar 11, 2021 at 11:25 PM Tom Talpey <tom@talpey.com> wrote:
> > >>
> > >> On 3/11/2021 8:47 AM, Shyam Prasad N wrote:
> > >>> Hi Rohith,
> > >>>
> > >>> The changes look good at a high level.
> > >>>
> > >>> Just a few points worth checking:
> > >>> 1. In cifs_open(), should be perform deferred close for certain cases
> > >>> like O_DIRECT? AFAIK, O_DIRECT is just a hint to the filesystem to
> > >>> perform less data caching. By deferring close, aren't we delaying
> > >>> flushing dirty pages? @Steve French ?
> > >>> 2. I see that you're maintaining a new list of files for deferred
> > >>> closing. Since there could be a large number of such files for a big
> > >>> share with sufficient I/O, maybe we should think of a structure with
> > >>> faster lookups (rb trees?).
> > >>> I know we already have a bunch of linked lists in cifs.ko, and we need
> > >>> to review perf impact for all those lists. But this one sounds like a
> > >>> candidate for faster lookups.
> > >>> 3. Minor comment. Maybe change the field name oplock_deferred_close to
> > >>> oplock_break_received?
> > >>>
> > >>> Regards,
> > >>> Shyam
> > >>
> > >> I wonder why the choice of 5 seconds? It seems to me a more natural
> > >> interval on the order of one or more of
> > >> - attribute cache timeout
> > >> - lease time
> > >> - echo_interval
> > >>
> > >> Also, this wording is rather confusing:
> > >>
> > >>> When file is closed, SMB2 close request is not sent to server
> > >>> immediately and is deferred for 5 seconds interval. When file is
> > >>> reopened by same process for read or write, previous file handle
> > >>> can be used until oplock is held.
> > >>
> > >> It's not a "previous" filehandle if it's open, and "can be used" is
> > >> a rather passive statement. A better wording may be "the filehandle
> > >> is reused".
> > >>
> > >> And, "until oplock is held" is similarly awkward. Do you mean "*if*
> > >> an oplock is held", or "*provided" an oplock is held"?
> > >>
> > >>> When same file is reopened by another client during 5 second
> > >>> interval, oplock break is sent by server and file is closed immediately
> > >>> if reference count is zero or else oplock is downgraded.
> > >>
> > >> Only the second part of the sentence is relevant to the patch. Also,
> > >> what about lease break?
> > >>
> > >> What happens if the handle is durable or persistent, and the connection
> > >> to the server times out? Is the handle recovered, then closed?
> > >>
> > >> Tom.
> > >>
> > >>
> > >>> On Tue, Mar 9, 2021 at 2:41 PM Rohith Surabattula
> > >>> <rohiths.msft@gmail.com> wrote:
> > >>>>
> > >>>> Hi All,
> > >>>>
> > >>>> Please find the attached patch which will defer the close to server.
> > >>>> So, performance can be improved.
> > >>>>
> > >>>> i.e When file is open, write, close, open, read, close....
> > >>>> As close is deferred and oplock is held, cache will not be invalidated
> > >>>> and same handle can be used for second open.
> > >>>>
> > >>>> Please review the changes and let me know your thoughts.
> > >>>>
> > >>>> Regards,
> > >>>> Rohith
> > >>>
> > >>>
> > >>>

--000000000000cc66ed05bf6328c4
Content-Type: application/octet-stream; 
	name="0001-cifs-Deferred-close-for-files.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Deferred-close-for-files.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kn7kst5m0>
X-Attachment-Id: f_kn7kst5m0

RnJvbSBhN2JhMTJkYTI4MjQ1MTkwZDEzOWIzYWM2ZWYzMDM5NWM0OWU3M2QyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb2hpdGggU3VyYWJhdHR1bGEgPHJvaGl0aHNAbWljcm9zb2Z0
LmNvbT4KRGF0ZTogTW9uLCA4IE1hciAyMDIxIDE2OjI4OjA5ICswMDAwClN1YmplY3Q6IFtQQVRD
SF0gY2lmczogRGVmZXJyZWQgY2xvc2UgZm9yIGZpbGVzCgpXaGVuIGZpbGUgaXMgY2xvc2VkLCBT
TUIyIGNsb3NlIHJlcXVlc3QgaXMgbm90IHNlbnQgdG8gc2VydmVyCmltbWVkaWF0ZWx5IGFuZCBp
cyBkZWZlcnJlZCBmb3IgYWNyZWdtYXggZGVmaW5lZCBpbnRlcnZhbC4gV2hlbiBmaWxlIGlzCnJl
b3BlbmVkIGJ5IHNhbWUgcHJvY2VzcyBmb3IgcmVhZCBvciB3cml0ZSwgdGhlIGZpbGUgaGFuZGxl
CmlzIHJldXNlZCBpZiBhbiBvcGxvY2sgaXMgaGVsZC4KCldoZW4gY2xpZW50IHJlY2VpdmVzIGEg
b3Bsb2NrL2xlYXNlIGJyZWFrLCBmaWxlIGlzIGNsb3NlZCBpbW1lZGlhdGVseQppZiByZWZlcmVu
Y2UgY291bnQgaXMgemVybywgZWxzZSBvcGxvY2sgaXMgZG93bmdyYWRlZC4KClNpZ25lZC1vZmYt
Ynk6IFJvaGl0aCBTdXJhYmF0dHVsYSA8cm9oaXRoc0BtaWNyb3NvZnQuY29tPgpTaWduZWQtb2Zm
LWJ5OiBVYnVudHUgPGx4c21iYWRtaW5AdWJ1bnR1LXRlc3QubTNiZm5xYnFxaDNlemR1NXdzc3Vs
MnNhZmguYnguaW50ZXJuYWwuY2xvdWRhcHAubmV0PgotLS0KIGZzL2NpZnMvY2lmc2ZzLmMgICAg
fCAxMyArKysrKysrLQogZnMvY2lmcy9jaWZzZ2xvYi5oICB8IDE1ICsrKysrKysrKwogZnMvY2lm
cy9jaWZzcHJvdG8uaCB8IDEwICsrKysrKwogZnMvY2lmcy9jb25uZWN0LmMgICB8ICAxICsKIGZz
L2NpZnMvZmlsZS5jICAgICAgfCA3NCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrLS0KIGZzL2NpZnMvaW5vZGUuYyAgICAgfCAgMSArCiBmcy9jaWZzL21pc2MuYyAg
ICAgIHwgNjIgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwogNyBmaWxlcyBj
aGFuZ2VkLCAxNzMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9m
cy9jaWZzL2NpZnNmcy5jIGIvZnMvY2lmcy9jaWZzZnMuYwppbmRleCAwOTlhZDlmMzY2MGIuLjNh
NDI2ZWZiYTk0ZSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzZnMuYworKysgYi9mcy9jaWZzL2Np
ZnNmcy5jCkBAIC0xMzMsNiArMTMzLDcgQEAgc3RydWN0IHdvcmtxdWV1ZV9zdHJ1Y3QJKmNpZnNp
b2Rfd3E7CiBzdHJ1Y3Qgd29ya3F1ZXVlX3N0cnVjdAkqZGVjcnlwdF93cTsKIHN0cnVjdCB3b3Jr
cXVldWVfc3RydWN0CSpmaWxlaW5mb19wdXRfd3E7CiBzdHJ1Y3Qgd29ya3F1ZXVlX3N0cnVjdAkq
Y2lmc29wbG9ja2Rfd3E7CitzdHJ1Y3Qgd29ya3F1ZXVlX3N0cnVjdCAqZGVmZXJyZWRjbG9zZV93
cTsKIF9fdTMyIGNpZnNfbG9ja19zZWNyZXQ7CiAKIC8qCkBAIC0xNjA1LDkgKzE2MDYsMTYgQEAg
aW5pdF9jaWZzKHZvaWQpCiAJCWdvdG8gb3V0X2Rlc3Ryb3lfZmlsZWluZm9fcHV0X3dxOwogCX0K
IAorCWRlZmVycmVkY2xvc2Vfd3EgPSBhbGxvY193b3JrcXVldWUoImRlZmVycmVkY2xvc2UiLAor
CQkJCQkgICBXUV9GUkVFWkFCTEV8V1FfTUVNX1JFQ0xBSU0sIDApOworCWlmICghZGVmZXJyZWRj
bG9zZV93cSkgeworCQlyYyA9IC1FTk9NRU07CisJCWdvdG8gb3V0X2Rlc3Ryb3lfY2lmc29wbG9j
a2Rfd3E7CisJfQorCiAJcmMgPSBjaWZzX2ZzY2FjaGVfcmVnaXN0ZXIoKTsKIAlpZiAocmMpCi0J
CWdvdG8gb3V0X2Rlc3Ryb3lfY2lmc29wbG9ja2Rfd3E7CisJCWdvdG8gb3V0X2Rlc3Ryb3lfZGVm
ZXJyZWRjbG9zZV93cTsKIAogCXJjID0gY2lmc19pbml0X2lub2RlY2FjaGUoKTsKIAlpZiAocmMp
CkBAIC0xNjc1LDYgKzE2ODMsOCBAQCBpbml0X2NpZnModm9pZCkKIAljaWZzX2Rlc3Ryb3lfaW5v
ZGVjYWNoZSgpOwogb3V0X3VucmVnX2ZzY2FjaGU6CiAJY2lmc19mc2NhY2hlX3VucmVnaXN0ZXIo
KTsKK291dF9kZXN0cm95X2RlZmVycmVkY2xvc2Vfd3E6CisJZGVzdHJveV93b3JrcXVldWUoZGVm
ZXJyZWRjbG9zZV93cSk7CiBvdXRfZGVzdHJveV9jaWZzb3Bsb2NrZF93cToKIAlkZXN0cm95X3dv
cmtxdWV1ZShjaWZzb3Bsb2NrZF93cSk7CiBvdXRfZGVzdHJveV9maWxlaW5mb19wdXRfd3E6CkBA
IC0xNzA5LDYgKzE3MTksNyBAQCBleGl0X2NpZnModm9pZCkKIAljaWZzX2Rlc3Ryb3lfbWlkcygp
OwogCWNpZnNfZGVzdHJveV9pbm9kZWNhY2hlKCk7CiAJY2lmc19mc2NhY2hlX3VucmVnaXN0ZXIo
KTsKKwlkZXN0cm95X3dvcmtxdWV1ZShkZWZlcnJlZGNsb3NlX3dxKTsKIAlkZXN0cm95X3dvcmtx
dWV1ZShjaWZzb3Bsb2NrZF93cSk7CiAJZGVzdHJveV93b3JrcXVldWUoZGVjcnlwdF93cSk7CiAJ
ZGVzdHJveV93b3JrcXVldWUoZmlsZWluZm9fcHV0X3dxKTsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMv
Y2lmc2dsb2IuaCBiL2ZzL2NpZnMvY2lmc2dsb2IuaAppbmRleCAzMWZjODY5NWFiZDYuLjJmMGUy
MmFhZDg0MiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzZ2xvYi5oCisrKyBiL2ZzL2NpZnMvY2lm
c2dsb2IuaApAQCAtMTA5Nyw2ICsxMDk3LDggQEAgc3RydWN0IGNpZnNfdGNvbiB7CiAjaWZkZWYg
Q09ORklHX0NJRlNfU1dOX1VQQ0FMTAogCWJvb2wgdXNlX3dpdG5lc3M6MTsgLyogdXNlIHdpdG5l
c3MgcHJvdG9jb2wgKi8KICNlbmRpZgorCXN0cnVjdCBsaXN0X2hlYWQgZGVmZXJyZWRfY2xvc2Vz
OyAvKiBsaXN0IG9mIGRlZmVycmVkIGNsb3NlcyAqLworCXNwaW5sb2NrX3QgZGVmZXJyZWRfbG9j
azsgLyogcHJvdGVjdGlvbiBvbiBkZWZlcnJlZCBsaXN0ICovCiB9OwogCiAvKgpAQCAtMTE1NCw2
ICsxMTU2LDE0IEBAIHN0cnVjdCBjaWZzX3BlbmRpbmdfb3BlbiB7CiAJX191MzIgb3Bsb2NrOwog
fTsKIAorc3RydWN0IGNpZnNfZGVmZXJyZWRfY2xvc2UgeworCXN0cnVjdCBsaXN0X2hlYWQgZGxp
c3Q7CisJc3RydWN0IHRjb25fbGluayAqdGxpbms7CisJX191MTYgIG5ldGZpZDsKKwlfX3U2NCAg
cGVyc2lzdGVudF9maWQ7CisJX191NjQgIHZvbGF0aWxlX2ZpZDsKK307CisKIC8qCiAgKiBUaGlz
IGluZm8gaGFuZ3Mgb2ZmIHRoZSBjaWZzRmlsZUluZm8gc3RydWN0dXJlLCBwb2ludGVkIHRvIGJ5
IGxsaXN0LgogICogVGhpcyBpcyB1c2VkIHRvIHRyYWNrIGJ5dGUgc3RyZWFtIGxvY2tzIG9uIHRo
ZSBmaWxlCkBAIC0xMjQ4LDYgKzEyNTgsOSBAQCBzdHJ1Y3QgY2lmc0ZpbGVJbmZvIHsKIAlzdHJ1
Y3QgY2lmc19zZWFyY2hfaW5mbyBzcmNoX2luZjsKIAlzdHJ1Y3Qgd29ya19zdHJ1Y3Qgb3Bsb2Nr
X2JyZWFrOyAvKiB3b3JrIGZvciBvcGxvY2sgYnJlYWtzICovCiAJc3RydWN0IHdvcmtfc3RydWN0
IHB1dDsgLyogd29yayBmb3IgdGhlIGZpbmFsIHBhcnQgb2YgX3B1dCAqLworCXN0cnVjdCBkZWxh
eWVkX3dvcmsgZGVmZXJyZWQ7IC8qIGRlZmVycmVkIHdvcmsgZm9yIGNsb3NlICovCisJYm9vbCBv
cGxvY2tfYnJlYWtfcmVjZWl2ZWQ7IC8qIEZsYWcgdG8gaW5kaWNhdGUgb3Bsb2NrIGJyZWFrICov
CisJYm9vbCBkZWZlcnJlZF9zY2hlZHVsZWQ7IC8qIEZsYWcgdG8gaW5kaWNhdGUgZGVmZXJyZWQg
d29yayBpcyBzY2hlZHVsZWQgKi8KIH07CiAKIHN0cnVjdCBjaWZzX2lvX3Bhcm1zIHsKQEAgLTE4
OTIsMTIgKzE5MDUsMTQgQEAgR0xPQkFMX0VYVEVSTiBzcGlubG9ja190IGdpZHNpZGxvY2s7CiAK
IHZvaWQgY2lmc19vcGxvY2tfYnJlYWsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKTsKIHZvaWQg
Y2lmc19xdWV1ZV9vcGxvY2tfYnJlYWsoc3RydWN0IGNpZnNGaWxlSW5mbyAqY2ZpbGUpOwordm9p
ZCBzbWIyX2RlZmVycmVkX3dvcmtfY2xvc2Uoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKTsKIAog
ZXh0ZXJuIGNvbnN0IHN0cnVjdCBzbG93X3dvcmtfb3BzIGNpZnNfb3Bsb2NrX2JyZWFrX29wczsK
IGV4dGVybiBzdHJ1Y3Qgd29ya3F1ZXVlX3N0cnVjdCAqY2lmc2lvZF93cTsKIGV4dGVybiBzdHJ1
Y3Qgd29ya3F1ZXVlX3N0cnVjdCAqZGVjcnlwdF93cTsKIGV4dGVybiBzdHJ1Y3Qgd29ya3F1ZXVl
X3N0cnVjdCAqZmlsZWluZm9fcHV0X3dxOwogZXh0ZXJuIHN0cnVjdCB3b3JrcXVldWVfc3RydWN0
ICpjaWZzb3Bsb2NrZF93cTsKK2V4dGVybiBzdHJ1Y3Qgd29ya3F1ZXVlX3N0cnVjdCAqZGVmZXJy
ZWRjbG9zZV93cTsKIGV4dGVybiBfX3UzMiBjaWZzX2xvY2tfc2VjcmV0OwogCiBleHRlcm4gbWVt
cG9vbF90ICpjaWZzX21pZF9wb29scDsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc3Byb3RvLmgg
Yi9mcy9jaWZzL2NpZnNwcm90by5oCmluZGV4IDc1Y2U2Zjc0MmI4ZC4uZGFmYmQyMTMzNmE1IDEw
MDY0NAotLS0gYS9mcy9jaWZzL2NpZnNwcm90by5oCisrKyBiL2ZzL2NpZnMvY2lmc3Byb3RvLmgK
QEAgLTI1Niw2ICsyNTYsMTYgQEAgZXh0ZXJuIHZvaWQgY2lmc19hZGRfcGVuZGluZ19vcGVuX2xv
Y2tlZChzdHJ1Y3QgY2lmc19maWQgKmZpZCwKIAkJCQkJIHN0cnVjdCB0Y29uX2xpbmsgKnRsaW5r
LAogCQkJCQkgc3RydWN0IGNpZnNfcGVuZGluZ19vcGVuICpvcGVuKTsKIGV4dGVybiB2b2lkIGNp
ZnNfZGVsX3BlbmRpbmdfb3BlbihzdHJ1Y3QgY2lmc19wZW5kaW5nX29wZW4gKm9wZW4pOworCitl
eHRlcm4gYm9vbCBjaWZzX2lzX2RlZmVycmVkX2Nsb3NlKHN0cnVjdCBjaWZzRmlsZUluZm8gKmNm
aWxlLAorCQkJCXN0cnVjdCBjaWZzX2RlZmVycmVkX2Nsb3NlICoqZGNsb3NlKTsKKworZXh0ZXJu
IHZvaWQgY2lmc19hZGRfZGVmZXJyZWRfY2xvc2Uoc3RydWN0IGNpZnNGaWxlSW5mbyAqY2ZpbGUp
OworCitleHRlcm4gdm9pZCBjaWZzX2RlbF9kZWZlcnJlZF9jbG9zZShzdHJ1Y3QgY2lmc0ZpbGVJ
bmZvICpjZmlsZSk7CisKK2V4dGVybiB2b2lkIGNpZnNfY2xvc2VfZGVmZXJyZWRfZmlsZShzdHJ1
Y3QgY2lmc0lub2RlSW5mbyAqY2lmc19pbm9kZSk7CisKIGV4dGVybiBzdHJ1Y3QgVENQX1NlcnZl
cl9JbmZvICpjaWZzX2dldF90Y3Bfc2Vzc2lvbihzdHJ1Y3Qgc21iM19mc19jb250ZXh0ICpjdHgp
OwogZXh0ZXJuIHZvaWQgY2lmc19wdXRfdGNwX3Nlc3Npb24oc3RydWN0IFRDUF9TZXJ2ZXJfSW5m
byAqc2VydmVyLAogCQkJCSBpbnQgZnJvbV9yZWNvbm5lY3QpOwpkaWZmIC0tZ2l0IGEvZnMvY2lm
cy9jb25uZWN0LmMgYi9mcy9jaWZzL2Nvbm5lY3QuYwppbmRleCBlZWM4YTIwNTJkYTIuLjI4MDQ2
MzRkNDA0MCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jb25uZWN0LmMKKysrIGIvZnMvY2lmcy9jb25u
ZWN0LmMKQEAgLTIyMjgsNiArMjIyOCw3IEBAIGNpZnNfZ2V0X3Rjb24oc3RydWN0IGNpZnNfc2Vz
ICpzZXMsIHN0cnVjdCBzbWIzX2ZzX2NvbnRleHQgKmN0eCkKIAl0Y29uLT5ub2RlbGV0ZSA9IGN0
eC0+bm9kZWxldGU7CiAJdGNvbi0+bG9jYWxfbGVhc2UgPSBjdHgtPmxvY2FsX2xlYXNlOwogCUlO
SVRfTElTVF9IRUFEKCZ0Y29uLT5wZW5kaW5nX29wZW5zKTsKKwlJTklUX0xJU1RfSEVBRCgmdGNv
bi0+ZGVmZXJyZWRfY2xvc2VzKTsKIAogCXNwaW5fbG9jaygmY2lmc190Y3Bfc2VzX2xvY2spOwog
CWxpc3RfYWRkKCZ0Y29uLT50Y29uX2xpc3QsICZzZXMtPnRjb25fbGlzdCk7CmRpZmYgLS1naXQg
YS9mcy9jaWZzL2ZpbGUuYyBiL2ZzL2NpZnMvZmlsZS5jCmluZGV4IDI2ZGU0MzI5ZDE2MS4uNzgz
ZGNkZmZkZDVkIDEwMDY0NAotLS0gYS9mcy9jaWZzL2ZpbGUuYworKysgYi9mcy9jaWZzL2ZpbGUu
YwpAQCAtMzIxLDkgKzMyMSwxMiBAQCBjaWZzX25ld19maWxlaW5mbyhzdHJ1Y3QgY2lmc19maWQg
KmZpZCwgc3RydWN0IGZpbGUgKmZpbGUsCiAJY2ZpbGUtPmRlbnRyeSA9IGRnZXQoZGVudHJ5KTsK
IAljZmlsZS0+Zl9mbGFncyA9IGZpbGUtPmZfZmxhZ3M7CiAJY2ZpbGUtPmludmFsaWRIYW5kbGUg
PSBmYWxzZTsKKwljZmlsZS0+b3Bsb2NrX2JyZWFrX3JlY2VpdmVkID0gZmFsc2U7CisJY2ZpbGUt
PmRlZmVycmVkX3NjaGVkdWxlZCA9IGZhbHNlOwogCWNmaWxlLT50bGluayA9IGNpZnNfZ2V0X3Rs
aW5rKHRsaW5rKTsKIAlJTklUX1dPUksoJmNmaWxlLT5vcGxvY2tfYnJlYWssIGNpZnNfb3Bsb2Nr
X2JyZWFrKTsKIAlJTklUX1dPUksoJmNmaWxlLT5wdXQsIGNpZnNGaWxlSW5mb19wdXRfd29yayk7
CisJSU5JVF9ERUxBWUVEX1dPUksoJmNmaWxlLT5kZWZlcnJlZCwgc21iMl9kZWZlcnJlZF93b3Jr
X2Nsb3NlKTsKIAltdXRleF9pbml0KCZjZmlsZS0+ZmhfbXV0ZXgpOwogCXNwaW5fbG9ja19pbml0
KCZjZmlsZS0+ZmlsZV9pbmZvX2xvY2spOwogCkBAIC01NjIsNiArNTY1LDI0IEBAIGludCBjaWZz
X29wZW4oc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZpbGUpCiAJCQlmaWxlLT5m
X29wID0gJmNpZnNfZmlsZV9kaXJlY3Rfb3BzOwogCX0KIAorCXNwaW5fbG9jaygmdGNvbi0+ZGVm
ZXJyZWRfbG9jayk7CisJLyogR2V0IHRoZSBjYWNoZWQgaGFuZGxlIGFzIFNNQjIgY2xvc2UgaXMg
ZGVmZXJyZWQgKi8KKwlyYyA9IGNpZnNfZ2V0X3JlYWRhYmxlX3BhdGgodGNvbiwgZnVsbF9wYXRo
LCAmY2ZpbGUpOworCWlmIChyYyA9PSAwKSB7CisJCWlmIChmaWxlLT5mX2ZsYWdzID09IGNmaWxl
LT5mX2ZsYWdzKSB7CisJCQlmaWxlLT5wcml2YXRlX2RhdGEgPSBjZmlsZTsKKwkJCWNpZnNfZGVs
X2RlZmVycmVkX2Nsb3NlKGNmaWxlKTsKKwkJCXNwaW5fdW5sb2NrKCZ0Y29uLT5kZWZlcnJlZF9s
b2NrKTsKKwkJCWdvdG8gb3V0OworCQl9IGVsc2UgeworCQkJc3Bpbl91bmxvY2soJnRjb24tPmRl
ZmVycmVkX2xvY2spOworCQkJX2NpZnNGaWxlSW5mb19wdXQoY2ZpbGUsIHRydWUsIGZhbHNlKTsK
KwkJCWNpZnNfY2xvc2VfZGVmZXJyZWRfZmlsZShDSUZTX0koaW5vZGUpKTsKKwkJfQorCX0gZWxz
ZSB7CisJCXNwaW5fdW5sb2NrKCZ0Y29uLT5kZWZlcnJlZF9sb2NrKTsKKwl9CisKIAlpZiAoc2Vy
dmVyLT5vcGxvY2tzKQogCQlvcGxvY2sgPSBSRVFfT1BMT0NLOwogCWVsc2UKQEAgLTg0MiwxMSAr
ODYzLDQ1IEBAIGNpZnNfcmVvcGVuX2ZpbGUoc3RydWN0IGNpZnNGaWxlSW5mbyAqY2ZpbGUsIGJv
b2wgY2FuX2ZsdXNoKQogCXJldHVybiByYzsKIH0KIAordm9pZCBzbWIyX2RlZmVycmVkX3dvcmtf
Y2xvc2Uoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQoreworCXN0cnVjdCBjaWZzRmlsZUluZm8g
KmNmaWxlID0gY29udGFpbmVyX29mKHdvcmssCisJCQlzdHJ1Y3QgY2lmc0ZpbGVJbmZvLCBkZWZl
cnJlZC53b3JrKTsKKworCXNwaW5fbG9jaygmdGxpbmtfdGNvbihjZmlsZS0+dGxpbmspLT5kZWZl
cnJlZF9sb2NrKTsKKwljaWZzX2RlbF9kZWZlcnJlZF9jbG9zZShjZmlsZSk7CisJY2ZpbGUtPmRl
ZmVycmVkX3NjaGVkdWxlZCA9IGZhbHNlOworCXNwaW5fdW5sb2NrKCZ0bGlua190Y29uKGNmaWxl
LT50bGluayktPmRlZmVycmVkX2xvY2spOworCV9jaWZzRmlsZUluZm9fcHV0KGNmaWxlLCB0cnVl
LCBmYWxzZSk7Cit9CisKIGludCBjaWZzX2Nsb3NlKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVj
dCBmaWxlICpmaWxlKQogeworCXN0cnVjdCBjaWZzRmlsZUluZm8gKmNmaWxlOworCXN0cnVjdCBj
aWZzSW5vZGVJbmZvICpjaW5vZGUgPSBDSUZTX0koaW5vZGUpOworCXN0cnVjdCBjaWZzX3NiX2lu
Zm8gKmNpZnNfc2IgPSBDSUZTX1NCKGlub2RlLT5pX3NiKTsKKwogCWlmIChmaWxlLT5wcml2YXRl
X2RhdGEgIT0gTlVMTCkgewotCQlfY2lmc0ZpbGVJbmZvX3B1dChmaWxlLT5wcml2YXRlX2RhdGEs
IHRydWUsIGZhbHNlKTsKKwkJY2ZpbGUgPSBmaWxlLT5wcml2YXRlX2RhdGE7CiAJCWZpbGUtPnBy
aXZhdGVfZGF0YSA9IE5VTEw7CisJCWlmICgoY2lub2RlLT5vcGxvY2sgPT0gQ0lGU19DQUNIRV9S
SFdfRkxHKSB8fAorCQkgICAgKGNpbm9kZS0+b3Bsb2NrID09IENJRlNfQ0FDSEVfUkhfRkxHKSkg
eworCQkJc3Bpbl9sb2NrKCZ0bGlua190Y29uKGNmaWxlLT50bGluayktPmRlZmVycmVkX2xvY2sp
OworCQkJY2lmc19hZGRfZGVmZXJyZWRfY2xvc2UoY2ZpbGUpOworCQkJaWYgKGNmaWxlLT5kZWZl
cnJlZF9zY2hlZHVsZWQpIHsKKwkJCQltb2RfZGVsYXllZF93b3JrKGRlZmVycmVkY2xvc2Vfd3Es
ICZjZmlsZS0+ZGVmZXJyZWQsIGNpZnNfc2ItPmN0eC0+YWNyZWdtYXgpOworCQkJfSBlbHNlIHsK
KwkJCQkvKiBEZWZlcnJlZCBjbG9zZSBmb3IgZmlsZXMgKi8KKwkJCQlxdWV1ZV9kZWxheWVkX3dv
cmsoZGVmZXJyZWRjbG9zZV93cSwgJmNmaWxlLT5kZWZlcnJlZCwgY2lmc19zYi0+Y3R4LT5hY3Jl
Z21heCk7CisJCQkJY2ZpbGUtPmRlZmVycmVkX3NjaGVkdWxlZCA9IHRydWU7CisJCQkJc3Bpbl91
bmxvY2soJnRsaW5rX3Rjb24oY2ZpbGUtPnRsaW5rKS0+ZGVmZXJyZWRfbG9jayk7CisJCQkJcmV0
dXJuIDA7CisJCQl9CisJCQlzcGluX3VubG9jaygmdGxpbmtfdGNvbihjZmlsZS0+dGxpbmspLT5k
ZWZlcnJlZF9sb2NrKTsKKwkJCV9jaWZzRmlsZUluZm9fcHV0KGNmaWxlLCB0cnVlLCBmYWxzZSk7
CisJCX0gZWxzZSB7CisJCQlfY2lmc0ZpbGVJbmZvX3B1dChjZmlsZSwgdHJ1ZSwgZmFsc2UpOwor
CQl9CiAJfQogCiAJLyogcmV0dXJuIGNvZGUgZnJvbSB0aGUgLT5yZWxlYXNlIG9wIGlzIGFsd2F5
cyBpZ25vcmVkICovCkBAIC0xOTQzLDcgKzE5OTgsOCBAQCBzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpm
aW5kX3JlYWRhYmxlX2ZpbGUoc3RydWN0IGNpZnNJbm9kZUluZm8gKmNpZnNfaW5vZGUsCiAJCWlm
IChmc3VpZF9vbmx5ICYmICF1aWRfZXEob3Blbl9maWxlLT51aWQsIGN1cnJlbnRfZnN1aWQoKSkp
CiAJCQljb250aW51ZTsKIAkJaWYgKE9QRU5fRk1PREUob3Blbl9maWxlLT5mX2ZsYWdzKSAmIEZN
T0RFX1JFQUQpIHsKLQkJCWlmICghb3Blbl9maWxlLT5pbnZhbGlkSGFuZGxlKSB7CisJCQlpZiAo
KCFvcGVuX2ZpbGUtPmludmFsaWRIYW5kbGUpICYmCisJCQkJKCFvcGVuX2ZpbGUtPm9wbG9ja19i
cmVha19yZWNlaXZlZCkpIHsKIAkJCQkvKiBmb3VuZCBhIGdvb2QgZmlsZSAqLwogCQkJCS8qIGxv
Y2sgaXQgc28gaXQgd2lsbCBub3QgYmUgY2xvc2VkIG9uIHVzICovCiAJCQkJY2lmc0ZpbGVJbmZv
X2dldChvcGVuX2ZpbGUpOwpAQCAtNDc0Niw2ICs0ODAyLDggQEAgdm9pZCBjaWZzX29wbG9ja19i
cmVhayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAq
c2VydmVyID0gdGNvbi0+c2VzLT5zZXJ2ZXI7CiAJaW50IHJjID0gMDsKIAlib29sIHB1cmdlX2Nh
Y2hlID0gZmFsc2U7CisJYm9vbCBpc19kZWZlcnJlZCA9IGZhbHNlOworCXN0cnVjdCBjaWZzX2Rl
ZmVycmVkX2Nsb3NlICpkY2xvc2U7CiAKIAl3YWl0X29uX2JpdCgmY2lub2RlLT5mbGFncywgQ0lG
U19JTk9ERV9QRU5ESU5HX1dSSVRFUlMsCiAJCQlUQVNLX1VOSU5URVJSVVBUSUJMRSk7CkBAIC00
NzkzLDYgKzQ4NTEsMTggQEAgdm9pZCBjaWZzX29wbG9ja19icmVhayhzdHJ1Y3Qgd29ya19zdHJ1
Y3QgKndvcmspCiAJCWNpZnNfZGJnKEZZSSwgIk9wbG9jayByZWxlYXNlIHJjID0gJWRcbiIsIHJj
KTsKIAl9CiAJX2NpZnNGaWxlSW5mb19wdXQoY2ZpbGUsIGZhbHNlIC8qIGRvIG5vdCB3YWl0IGZv
ciBvdXJzZWxmICovLCBmYWxzZSk7CisJLyoKKwkgKiBXaGVuIG9wbG9jayBicmVhayBpcyByZWNl
aXZlZCBhbmQgdGhlcmUgYXJlIG5vIGFjdGl2ZQorCSAqIGZpbGUgaGFuZGxlcyBidXQgY2FjaGVk
LCB0aGVuIHNldCB0aGUgZmxhZyBvcGxvY2tfYnJlYWtfcmVjZWl2ZWQuCisJICogU28sIG5ldyBv
cGVuIHdpbGwgbm90IHVzZSBjYWNoZWQgaGFuZGxlLgorCSAqLworCXNwaW5fbG9jaygmdGxpbmtf
dGNvbihjZmlsZS0+dGxpbmspLT5kZWZlcnJlZF9sb2NrKTsKKwlpc19kZWZlcnJlZCA9IGNpZnNf
aXNfZGVmZXJyZWRfY2xvc2UoY2ZpbGUsICZkY2xvc2UpOworCWlmIChpc19kZWZlcnJlZCkgewor
CQljZmlsZS0+b3Bsb2NrX2JyZWFrX3JlY2VpdmVkID0gdHJ1ZTsKKwkJbW9kX2RlbGF5ZWRfd29y
ayhkZWZlcnJlZGNsb3NlX3dxLCAmY2ZpbGUtPmRlZmVycmVkLCAwKTsKKwl9CisJc3Bpbl91bmxv
Y2soJnRsaW5rX3Rjb24oY2ZpbGUtPnRsaW5rKS0+ZGVmZXJyZWRfbG9jayk7CiAJY2lmc19kb25l
X29wbG9ja19icmVhayhjaW5vZGUpOwogfQogCmRpZmYgLS1naXQgYS9mcy9jaWZzL2lub2RlLmMg
Yi9mcy9jaWZzL2lub2RlLmMKaW5kZXggZjJkZjQ0MjJlNTRhLi5jZTdkNzE3MzU1MGMgMTAwNjQ0
Ci0tLSBhL2ZzL2NpZnMvaW5vZGUuYworKysgYi9mcy9jaWZzL2lub2RlLmMKQEAgLTE2NDMsNiAr
MTY0Myw3IEBAIGludCBjaWZzX3VubGluayhzdHJ1Y3QgaW5vZGUgKmRpciwgc3RydWN0IGRlbnRy
eSAqZGVudHJ5KQogCQlnb3RvIHVubGlua19vdXQ7CiAJfQogCisJY2lmc19jbG9zZV9kZWZlcnJl
ZF9maWxlKENJRlNfSShpbm9kZSkpOwogCWlmIChjYXBfdW5peCh0Y29uLT5zZXMpICYmIChDSUZT
X1VOSVhfUE9TSVhfUEFUSF9PUFNfQ0FQICYKIAkJCQlsZTY0X3RvX2NwdSh0Y29uLT5mc1VuaXhJ
bmZvLkNhcGFiaWxpdHkpKSkgewogCQlyYyA9IENJRlNQT1NJWERlbEZpbGUoeGlkLCB0Y29uLCBm
dWxsX3BhdGgsCmRpZmYgLS1naXQgYS9mcy9jaWZzL21pc2MuYyBiL2ZzL2NpZnMvbWlzYy5jCmlu
ZGV4IDgyZTE3NjcyMGNhNi4uZmU1YTI0N2ExNDUzIDEwMDY0NAotLS0gYS9mcy9jaWZzL21pc2Mu
YworKysgYi9mcy9jaWZzL21pc2MuYwpAQCAtMTM2LDYgKzEzNiw3IEBAIHRjb25JbmZvQWxsb2Mo
dm9pZCkKIAlzcGluX2xvY2tfaW5pdCgmcmV0X2J1Zi0+c3RhdF9sb2NrKTsKIAlhdG9taWNfc2V0
KCZyZXRfYnVmLT5udW1fbG9jYWxfb3BlbnMsIDApOwogCWF0b21pY19zZXQoJnJldF9idWYtPm51
bV9yZW1vdGVfb3BlbnMsIDApOworCXNwaW5fbG9ja19pbml0KCZyZXRfYnVmLT5kZWZlcnJlZF9s
b2NrKTsKIAogCXJldHVybiByZXRfYnVmOwogfQpAQCAtNjcyLDYgKzY3Myw2NyBAQCBjaWZzX2Fk
ZF9wZW5kaW5nX29wZW4oc3RydWN0IGNpZnNfZmlkICpmaWQsIHN0cnVjdCB0Y29uX2xpbmsgKnRs
aW5rLAogCXNwaW5fdW5sb2NrKCZ0bGlua190Y29uKG9wZW4tPnRsaW5rKS0+b3Blbl9maWxlX2xv
Y2spOwogfQogCitib29sCitjaWZzX2lzX2RlZmVycmVkX2Nsb3NlKHN0cnVjdCBjaWZzRmlsZUlu
Zm8gKmNmaWxlLCBzdHJ1Y3QgY2lmc19kZWZlcnJlZF9jbG9zZSAqKnBkY2xvc2UpCit7CisJc3Ry
dWN0IGNpZnNfZGVmZXJyZWRfY2xvc2UgKmRjbG9zZTsKKworCWxpc3RfZm9yX2VhY2hfZW50cnko
ZGNsb3NlLCAmdGxpbmtfdGNvbihjZmlsZS0+dGxpbmspLT5kZWZlcnJlZF9jbG9zZXMsIGRsaXN0
KSB7CisJCWlmICgoZGNsb3NlLT5uZXRmaWQgPT0gY2ZpbGUtPmZpZC5uZXRmaWQpICYmCisJCQko
ZGNsb3NlLT5wZXJzaXN0ZW50X2ZpZCA9PSBjZmlsZS0+ZmlkLnBlcnNpc3RlbnRfZmlkKSAmJgor
CQkJKGRjbG9zZS0+dm9sYXRpbGVfZmlkID09IGNmaWxlLT5maWQudm9sYXRpbGVfZmlkKSkgewor
CQkJKnBkY2xvc2UgPSBkY2xvc2U7CisJCQlyZXR1cm4gdHJ1ZTsKKwkJfQorCX0KKwlyZXR1cm4g
ZmFsc2U7Cit9CisKK3ZvaWQKK2NpZnNfYWRkX2RlZmVycmVkX2Nsb3NlKHN0cnVjdCBjaWZzRmls
ZUluZm8gKmNmaWxlKQoreworCWJvb2wgaXNfZGVmZXJyZWQgPSBmYWxzZTsKKwlzdHJ1Y3QgY2lm
c19kZWZlcnJlZF9jbG9zZSAqZGNsb3NlOworCisJaXNfZGVmZXJyZWQgPSBjaWZzX2lzX2RlZmVy
cmVkX2Nsb3NlKGNmaWxlLCAmZGNsb3NlKTsKKwlpZiAoaXNfZGVmZXJyZWQpCisJCXJldHVybjsK
KworCWRjbG9zZSA9IGttYWxsb2Moc2l6ZW9mKHN0cnVjdCBjaWZzX2RlZmVycmVkX2Nsb3NlKSwg
R0ZQX0tFUk5FTCk7CisJZGNsb3NlLT50bGluayA9IGNmaWxlLT50bGluazsKKwlkY2xvc2UtPm5l
dGZpZCA9IGNmaWxlLT5maWQubmV0ZmlkOworCWRjbG9zZS0+cGVyc2lzdGVudF9maWQgPSBjZmls
ZS0+ZmlkLnBlcnNpc3RlbnRfZmlkOworCWRjbG9zZS0+dm9sYXRpbGVfZmlkID0gY2ZpbGUtPmZp
ZC52b2xhdGlsZV9maWQ7CisJbGlzdF9hZGRfdGFpbCgmZGNsb3NlLT5kbGlzdCwgJnRsaW5rX3Rj
b24oZGNsb3NlLT50bGluayktPmRlZmVycmVkX2Nsb3Nlcyk7Cit9CisKK3ZvaWQKK2NpZnNfZGVs
X2RlZmVycmVkX2Nsb3NlKHN0cnVjdCBjaWZzRmlsZUluZm8gKmNmaWxlKQoreworCWJvb2wgaXNf
ZGVmZXJyZWQgPSBmYWxzZTsKKwlzdHJ1Y3QgY2lmc19kZWZlcnJlZF9jbG9zZSAqZGNsb3NlOwor
CisJaXNfZGVmZXJyZWQgPSBjaWZzX2lzX2RlZmVycmVkX2Nsb3NlKGNmaWxlLCAmZGNsb3NlKTsK
KwlpZiAoIWlzX2RlZmVycmVkKQorCQlyZXR1cm47CisJbGlzdF9kZWwoJmRjbG9zZS0+ZGxpc3Qp
OworfQorCit2b2lkCitjaWZzX2Nsb3NlX2RlZmVycmVkX2ZpbGUoc3RydWN0IGNpZnNJbm9kZUlu
Zm8gKmNpZnNfaW5vZGUpCit7CisJc3RydWN0IGNpZnNGaWxlSW5mbyAqY2ZpbGUgPSBOVUxMOwor
CXN0cnVjdCBjaWZzX2RlZmVycmVkX2Nsb3NlICpkY2xvc2U7CisKKwlsaXN0X2Zvcl9lYWNoX2Vu
dHJ5KGNmaWxlLCAmY2lmc19pbm9kZS0+b3BlbkZpbGVMaXN0LCBmbGlzdCkgeworCQlzcGluX2xv
Y2soJnRsaW5rX3Rjb24oY2ZpbGUtPnRsaW5rKS0+ZGVmZXJyZWRfbG9jayk7CisJCWlmIChjaWZz
X2lzX2RlZmVycmVkX2Nsb3NlKGNmaWxlLCAmZGNsb3NlKSkgeworCQkJbW9kX2RlbGF5ZWRfd29y
ayhkZWZlcnJlZGNsb3NlX3dxLCAmY2ZpbGUtPmRlZmVycmVkLCAwKTsKKwkJfQorCQlzcGluX3Vu
bG9jaygmdGxpbmtfdGNvbihjZmlsZS0+dGxpbmspLT5kZWZlcnJlZF9sb2NrKTsKKwl9Cit9CisK
IC8qIHBhcnNlcyBERlMgcmVmZmVyYWwgVjMgc3RydWN0dXJlCiAgKiBjYWxsZXIgaXMgcmVzcG9u
c2libGUgZm9yIGZyZWVpbmcgdGFyZ2V0X25vZGVzCiAgKiByZXR1cm5zOgotLSAKMi4xNy4xCgo=
--000000000000cc66ed05bf6328c4--
