Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC9E3C433B4
	for <linux-cifs@archiver.kernel.org>; Sun, 11 Apr 2021 12:19:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF8C461006
	for <linux-cifs@archiver.kernel.org>; Sun, 11 Apr 2021 12:19:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235445AbhDKMUD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 11 Apr 2021 08:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhDKMUC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 11 Apr 2021 08:20:02 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4958FC061574
        for <linux-cifs@vger.kernel.org>; Sun, 11 Apr 2021 05:19:46 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id i190so7334842pfc.12
        for <linux-cifs@vger.kernel.org>; Sun, 11 Apr 2021 05:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=udoM2BRHiJB4D4NR41fYbxnHISR3yi2fwQE6yTdTRl0=;
        b=uhRh9/fdYCVvU9CHJwQ3j9TWzgceiQ+ETGbZde40H2Qe4udyFy+0CVk6F86otDkeAW
         rrOij7jeVt8IcX6Xtg5OOHz9C3lU9UOmYj8VMpb0OuryziO5WFHV1BAuC9CiPw10X52l
         0pulSwZjJ01hNA1nQMoixCI1Cf7BPMsgwWzfE3isMcek44jvWaYd8PppPFVFkAzCLnPR
         pi4Z45Xri10lkUOSb/ZMnhl9GtQAaVIrlw3hpT7jSXAmqdv8cMz6C3IRh7VKFPWcSS++
         Q/3rTqpEsn1M3NAVnnyX+nc8OJRxHUB2lIdNLW294n991cZ/kIQ2tQpHXGoAC4vTk2Je
         7q8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=udoM2BRHiJB4D4NR41fYbxnHISR3yi2fwQE6yTdTRl0=;
        b=Fy7c/LiF7KNV7SBoR6LxuIdLkVHhyrM+/vjKW3zj8EkTcob44j4JPVkgXR+33hWVIU
         8RJeBO0UwFCJM1NhK3VE9eBSpeY1AOkPeUQHc8qSOpMztckkZBaEdP8NK5b5MZPrpDqS
         A1FnC54+Epd0h/90HkfNynwbb+wYyVFBUyH/Inmf2D1Yhd7EHNlC3/mBIpkYnP5DKl/B
         dJ4EzOOAPFGxO9DEWG6bewmVuDIRfsSXICiBWThxQeG2P7T65C+C3392Ep3z1BfWKuW3
         EQAlHO2U6isiUH+hAQ6miSU5mUNf3Zob7fYRFiSCGvsYsfFsMDZUf6sPIrTves+g3tTR
         UqxA==
X-Gm-Message-State: AOAM531jdVvaY4QIzsKDqk5Gu7tTtjezZUm7S8Ne3oyspvCWpeIfT6jw
        +2f1A0v5Wn5bJxh8ruulsjFxn5lbBQzBoNcsWC4=
X-Google-Smtp-Source: ABdhPJy+jDaezPJCwk99E2KgWQ+q2fRYAjKNQMJCPmMhgaLzppuK3mEVB0dfPPYCp3J34zpX/nA9BrtNd4mAmxZdAE0=
X-Received: by 2002:a63:9dcb:: with SMTP id i194mr21047590pgd.87.1618143585612;
 Sun, 11 Apr 2021 05:19:45 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0Y1NeC0jNTOtjhTtGRt0sfyhyxC=wNfMu1eqibe6qJbwA@mail.gmail.com>
 <CANT5p=pFU=1OKiBA0m0_Pqms4Vsxz7omEgvfDDAb8U3M4-3qbA@mail.gmail.com>
 <461d79c3-1b32-b0f8-157c-b5d4b25507d7@talpey.com> <CACdtm0agzeVRiQg1zZjm=jFrf-gSQ-+YGc1Zm1xN1Pd9tJia4Q@mail.gmail.com>
 <49874720-dc76-2660-17e7-f7157a9725d4@talpey.com> <CACdtm0Z5BfbHp8Y2nFLv0k854hDe6-j4xtYDP4oruKPOtxxz2Q@mail.gmail.com>
 <CACdtm0ZYHjHXt-n8xnRQgZ+ZdLw4XVdb_yCK3Q_QSG4SrK6_Lw@mail.gmail.com>
In-Reply-To: <CACdtm0ZYHjHXt-n8xnRQgZ+ZdLw4XVdb_yCK3Q_QSG4SrK6_Lw@mail.gmail.com>
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Sun, 11 Apr 2021 17:49:34 +0530
Message-ID: <CACdtm0YhpOW+7-ELLOk97utOikU-06Zccwq-2HK+h3aFumnedg@mail.gmail.com>
Subject: Re: cifs: Deferred close for files
To:     Tom Talpey <tom@talpey.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>, sribhat.msa@outlook.com,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Content-Type: multipart/mixed; boundary="0000000000009dd5e005bfb169b0"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000009dd5e005bfb169b0
Content-Type: text/plain; charset="UTF-8"

Hi All,

Have updated the patch with some optimizations.

Patch V3:
Moved the deferred file list and lock from TCON to inode structures.

Regards,
Rohith

On Wed, Apr 7, 2021 at 8:27 PM Rohith Surabattula
<rohiths.msft@gmail.com> wrote:
>
> Hi All,
>
> Have updated the patch.
>
> patch v2:
> 1)  Close the file immediately during unlink of file.
> 2)  Update the reference count properly when deferred work is already scheduled.
>
> Regards,
> Rohith
>
> On Thu, Mar 25, 2021 at 8:12 AM Rohith Surabattula
> <rohiths.msft@gmail.com> wrote:
> >
> > >>> Hi Rohith,
> > >>>
> > >>> The changes look good at a high level.
> > >>>
> > >>> Just a few points worth checking:
> > >>> 1. In cifs_open(), should be perform deferred close for certain cases
> > >>> like O_DIRECT? AFAIK, O_DIRECT is just a hint to the filesystem to
> > >>> perform less data caching. By deferring close, aren't we delaying
> > >>> flushing dirty pages? @Steve French ?
> > >>
> > >> With O_DIRECT flag, data is not cached locally and will be sent to
> > >> server immediately.
> > >>
> > >>> 2. I see that you're maintaining a new list of files for deferred
> > >>> closing. Since there could be a large number of such files for a big
> > >>> share with sufficient I/O, maybe we should think of a structure with
> > >>> faster lookups (rb trees?).
> > >>> I know we already have a bunch of linked lists in cifs.ko, and we need
> > >>> to review perf impact for all those lists. But this one sounds like a
> > >>> candidate for faster lookups.
> > >>
> > >> Entries will be added into this list only once file is closed and will
> > >> remain for acregmax amount interval.
> >
> > >I think you mean once the "file descriptor" is closed, right? But now
> > >that you mention it, caching the attributes sounds a lot like the
> > >NFS close-to-open semantic, which is itself optional with the "nocto"
> > >mount option.
> >
> > >Because some applications use close() to perform flush, there may be
> > >some silent side effects as well. I don't see anything special in the
> > >patch regarding this. Have you considered it?
> > >The change to promptly close the handle on oplock or lease break looks
> > >reasonable. The rewording in the patch description is better too.
> >
> > Yes, as the handle is closed immediately when oplock/lease breaks,
> > will there be any
> > silent side effects still?
> >
> > >>> What happens if the handle is durable or persistent, and the connection
> > >>> to the server times out? Is the handle recovered, then closed?
> > >>
> > >> Do you mean when the session gets reconnected, the deferred handle
> > >> will be recovered and closed?
> >
> > >Yes, because I expect the client to attempt to reclaim its handles upon
> > >reconnection. I don't see any particular code change regarding this.
> >
> > >My question is, if there's a deferred close pending, should it do that,
> > >or should it simply cut to the chase and close any such handle(s)?
> >
> > As the handles are persistent once the session gets reconnected,
> > applications can reclaim
> > the handle. So, i believe no need to close handles immediately until
> > timeout(i.e acregmax interval)
> >
> > Regards,
> > Rohith
> >
> > On Wed, Mar 24, 2021 at 7:50 PM Tom Talpey <tom@talpey.com> wrote:
> > >
> > > On 3/22/2021 1:07 PM, Rohith Surabattula wrote:
> > > > On 3/11/2021 8:47 AM, Shyam Prasad N wrote:
> > > >> Hi Rohith,
> > > >>
> > > >> The changes look good at a high level.
> > > >>
> > > >> Just a few points worth checking:
> > > >> 1. In cifs_open(), should be perform deferred close for certain cases
> > > >> like O_DIRECT? AFAIK, O_DIRECT is just a hint to the filesystem to
> > > >> perform less data caching. By deferring close, aren't we delaying
> > > >> flushing dirty pages? @Steve French ?
> > > >
> > > > With O_DIRECT flag, data is not cached locally and will be sent to
> > > > server immediately.
> > > >
> > > >> 2. I see that you're maintaining a new list of files for deferred
> > > >> closing. Since there could be a large number of such files for a big
> > > >> share with sufficient I/O, maybe we should think of a structure with
> > > >> faster lookups (rb trees?).
> > > >> I know we already have a bunch of linked lists in cifs.ko, and we need
> > > >> to review perf impact for all those lists. But this one sounds like a
> > > >> candidate for faster lookups.
> > > >
> > > > Entries will be added into this list only once file is closed and will
> > > > remain for acregmax amount interval.
> > >
> > > I think you mean once the "file descriptor" is closed, right? But now
> > > that you mention it, caching the attributes sounds a lot like the
> > > NFS close-to-open semantic, which is itself optional with the "nocto"
> > > mount option.
> > >
> > > Because some applications use close() to perform flush, there may be
> > > some silent side effects as well. I don't see anything special in the
> > > patch regarding this. Have you considered it?
> > >
> > > > So,  Will this affect performance i.e during lookups ?
> > > >
> > > >> 3. Minor comment. Maybe change the field name oplock_deferred_close to
> > > >> oplock_break_received?
> > > >
> > > > Addressed. Attached the patch.
> > > >>
> > > >> Regards,
> > > >> Shyam
> > > >
> > > >> I wonder why the choice of 5 seconds? It seems to me a more natural
> > > >> interval on the order of one or more of
> > > >> - attribute cache timeout
> > > >> - lease time
> > > >> - echo_interval
> > > >
> > > > Yes, This sounds good. I modified the patch to defer by attribute
> > > > cache timeout interval.
> > > >
> > > >> Also, this wording is rather confusing:
> > > >
> > > >>> When file is closed, SMB2 close request is not sent to server
> > > >>> immediately and is deferred for 5 seconds interval. When file is
> > > >>> reopened by same process for read or write, previous file handle
> > > >>> can be used until oplock is held.
> > > >
> > > >> It's not a "previous" filehandle if it's open, and "can be used" is
> > > >> a rather passive statement. A better wording may be "the filehandle
> > > >> is reused".
> > > >
> > > >> And, "until oplock is held" is similarly awkward. Do you mean "*if*
> > > >> an oplock is held", or "*provided" an oplock is held"?
> > > >
> > > >>> When same file is reopened by another client during 5 second
> > > >>> interval, oplock break is sent by server and file is closed immediately
> > > >>> if reference count is zero or else oplock is downgraded.
> > > >
> > > >> Only the second part of the sentence is relevant to the patch. Also,
> > > >> what about lease break?
> > > >
> > > > Modified the patch.
> > >
> > > The change to promptly close the handle on oplock or lease break looks
> > > reasonable. The rewording in the patch description is better too.
> > >
> > > >> What happens if the handle is durable or persistent, and the connection
> > > >> to the server times out? Is the handle recovered, then closed?
> > > >
> > > > Do you mean when the session gets reconnected, the deferred handle
> > > > will be recovered and closed?
> > >
> > > Yes, because I expect the client to attempt to reclaim its handles upon
> > > reconnection. I don't see any particular code change regarding this.
> > >
> > > My question is, if there's a deferred close pending, should it do that,
> > > or should it simply cut to the chase and close any such handle(s)?
> > >
> > > Tom.
> > >
> > > > Regards,
> > > > Rohith
> > > >
> > > > On Thu, Mar 11, 2021 at 11:25 PM Tom Talpey <tom@talpey.com> wrote:
> > > >>
> > > >> On 3/11/2021 8:47 AM, Shyam Prasad N wrote:
> > > >>> Hi Rohith,
> > > >>>
> > > >>> The changes look good at a high level.
> > > >>>
> > > >>> Just a few points worth checking:
> > > >>> 1. In cifs_open(), should be perform deferred close for certain cases
> > > >>> like O_DIRECT? AFAIK, O_DIRECT is just a hint to the filesystem to
> > > >>> perform less data caching. By deferring close, aren't we delaying
> > > >>> flushing dirty pages? @Steve French ?
> > > >>> 2. I see that you're maintaining a new list of files for deferred
> > > >>> closing. Since there could be a large number of such files for a big
> > > >>> share with sufficient I/O, maybe we should think of a structure with
> > > >>> faster lookups (rb trees?).
> > > >>> I know we already have a bunch of linked lists in cifs.ko, and we need
> > > >>> to review perf impact for all those lists. But this one sounds like a
> > > >>> candidate for faster lookups.
> > > >>> 3. Minor comment. Maybe change the field name oplock_deferred_close to
> > > >>> oplock_break_received?
> > > >>>
> > > >>> Regards,
> > > >>> Shyam
> > > >>
> > > >> I wonder why the choice of 5 seconds? It seems to me a more natural
> > > >> interval on the order of one or more of
> > > >> - attribute cache timeout
> > > >> - lease time
> > > >> - echo_interval
> > > >>
> > > >> Also, this wording is rather confusing:
> > > >>
> > > >>> When file is closed, SMB2 close request is not sent to server
> > > >>> immediately and is deferred for 5 seconds interval. When file is
> > > >>> reopened by same process for read or write, previous file handle
> > > >>> can be used until oplock is held.
> > > >>
> > > >> It's not a "previous" filehandle if it's open, and "can be used" is
> > > >> a rather passive statement. A better wording may be "the filehandle
> > > >> is reused".
> > > >>
> > > >> And, "until oplock is held" is similarly awkward. Do you mean "*if*
> > > >> an oplock is held", or "*provided" an oplock is held"?
> > > >>
> > > >>> When same file is reopened by another client during 5 second
> > > >>> interval, oplock break is sent by server and file is closed immediately
> > > >>> if reference count is zero or else oplock is downgraded.
> > > >>
> > > >> Only the second part of the sentence is relevant to the patch. Also,
> > > >> what about lease break?
> > > >>
> > > >> What happens if the handle is durable or persistent, and the connection
> > > >> to the server times out? Is the handle recovered, then closed?
> > > >>
> > > >> Tom.
> > > >>
> > > >>
> > > >>> On Tue, Mar 9, 2021 at 2:41 PM Rohith Surabattula
> > > >>> <rohiths.msft@gmail.com> wrote:
> > > >>>>
> > > >>>> Hi All,
> > > >>>>
> > > >>>> Please find the attached patch which will defer the close to server.
> > > >>>> So, performance can be improved.
> > > >>>>
> > > >>>> i.e When file is open, write, close, open, read, close....
> > > >>>> As close is deferred and oplock is held, cache will not be invalidated
> > > >>>> and same handle can be used for second open.
> > > >>>>
> > > >>>> Please review the changes and let me know your thoughts.
> > > >>>>
> > > >>>> Regards,
> > > >>>> Rohith
> > > >>>
> > > >>>
> > > >>>

--0000000000009dd5e005bfb169b0
Content-Type: application/octet-stream; 
	name="0001-cifs-Deferred-close-for-files.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Deferred-close-for-files.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_knd4wilz0>
X-Attachment-Id: f_knd4wilz0

RnJvbSBmZWRmNjg3YjI3ZjFjODAxNTZkNTk4M2ViNmE2MThkMWFhNDQxZjM0IE1vbiBTZXAgMTcg
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
ZnMvY2lmc2ZzLmMgICAgfCAxNSArKysrKysrLQogZnMvY2lmcy9jaWZzZ2xvYi5oICB8IDE2ICsr
KysrKysrKwogZnMvY2lmcy9jaWZzcHJvdG8uaCB8IDExICsrKysrKwogZnMvY2lmcy9maWxlLmMg
ICAgICB8IDg0ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLQog
ZnMvY2lmcy9pbm9kZS5jICAgICB8ICAxICsKIGZzL2NpZnMvbWlzYy5jICAgICAgfCA2MiArKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIDYgZmlsZXMgY2hhbmdlZCwgMTg2IGluc2Vy
dGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzZnMuYyBi
L2ZzL2NpZnMvY2lmc2ZzLmMKaW5kZXggMDk5YWQ5ZjM2NjBiLi4zNWNmNTE4MTBjYmYgMTAwNjQ0
Ci0tLSBhL2ZzL2NpZnMvY2lmc2ZzLmMKKysrIGIvZnMvY2lmcy9jaWZzZnMuYwpAQCAtMTMzLDYg
KzEzMyw3IEBAIHN0cnVjdCB3b3JrcXVldWVfc3RydWN0CSpjaWZzaW9kX3dxOwogc3RydWN0IHdv
cmtxdWV1ZV9zdHJ1Y3QJKmRlY3J5cHRfd3E7CiBzdHJ1Y3Qgd29ya3F1ZXVlX3N0cnVjdAkqZmls
ZWluZm9fcHV0X3dxOwogc3RydWN0IHdvcmtxdWV1ZV9zdHJ1Y3QJKmNpZnNvcGxvY2tkX3dxOwor
c3RydWN0IHdvcmtxdWV1ZV9zdHJ1Y3QgKmRlZmVycmVkY2xvc2Vfd3E7CiBfX3UzMiBjaWZzX2xv
Y2tfc2VjcmV0OwogCiAvKgpAQCAtMzY0LDYgKzM2NSw4IEBAIGNpZnNfYWxsb2NfaW5vZGUoc3Ry
dWN0IHN1cGVyX2Jsb2NrICpzYikKIAkvKiBjaWZzX2lub2RlLT52ZnNfaW5vZGUuaV9mbGFncyA9
IFNfTk9BVElNRSB8IFNfTk9DTVRJTUU7ICovCiAJSU5JVF9MSVNUX0hFQUQoJmNpZnNfaW5vZGUt
Pm9wZW5GaWxlTGlzdCk7CiAJSU5JVF9MSVNUX0hFQUQoJmNpZnNfaW5vZGUtPmxsaXN0KTsKKwlJ
TklUX0xJU1RfSEVBRCgmY2lmc19pbm9kZS0+ZGVmZXJyZWRfY2xvc2VzKTsKKwlzcGluX2xvY2tf
aW5pdCgmY2lmc19pbm9kZS0+ZGVmZXJyZWRfbG9jayk7CiAJcmV0dXJuICZjaWZzX2lub2RlLT52
ZnNfaW5vZGU7CiB9CiAKQEAgLTE2MDUsOSArMTYwOCwxNiBAQCBpbml0X2NpZnModm9pZCkKIAkJ
Z290byBvdXRfZGVzdHJveV9maWxlaW5mb19wdXRfd3E7CiAJfQogCisJZGVmZXJyZWRjbG9zZV93
cSA9IGFsbG9jX3dvcmtxdWV1ZSgiZGVmZXJyZWRjbG9zZSIsCisJCQkJCSAgIFdRX0ZSRUVaQUJM
RXxXUV9NRU1fUkVDTEFJTSwgMCk7CisJaWYgKCFkZWZlcnJlZGNsb3NlX3dxKSB7CisJCXJjID0g
LUVOT01FTTsKKwkJZ290byBvdXRfZGVzdHJveV9jaWZzb3Bsb2NrZF93cTsKKwl9CisKIAlyYyA9
IGNpZnNfZnNjYWNoZV9yZWdpc3RlcigpOwogCWlmIChyYykKLQkJZ290byBvdXRfZGVzdHJveV9j
aWZzb3Bsb2NrZF93cTsKKwkJZ290byBvdXRfZGVzdHJveV9kZWZlcnJlZGNsb3NlX3dxOwogCiAJ
cmMgPSBjaWZzX2luaXRfaW5vZGVjYWNoZSgpOwogCWlmIChyYykKQEAgLTE2NzUsNiArMTY4NSw4
IEBAIGluaXRfY2lmcyh2b2lkKQogCWNpZnNfZGVzdHJveV9pbm9kZWNhY2hlKCk7CiBvdXRfdW5y
ZWdfZnNjYWNoZToKIAljaWZzX2ZzY2FjaGVfdW5yZWdpc3RlcigpOworb3V0X2Rlc3Ryb3lfZGVm
ZXJyZWRjbG9zZV93cToKKwlkZXN0cm95X3dvcmtxdWV1ZShkZWZlcnJlZGNsb3NlX3dxKTsKIG91
dF9kZXN0cm95X2NpZnNvcGxvY2tkX3dxOgogCWRlc3Ryb3lfd29ya3F1ZXVlKGNpZnNvcGxvY2tk
X3dxKTsKIG91dF9kZXN0cm95X2ZpbGVpbmZvX3B1dF93cToKQEAgLTE3MDksNiArMTcyMSw3IEBA
IGV4aXRfY2lmcyh2b2lkKQogCWNpZnNfZGVzdHJveV9taWRzKCk7CiAJY2lmc19kZXN0cm95X2lu
b2RlY2FjaGUoKTsKIAljaWZzX2ZzY2FjaGVfdW5yZWdpc3RlcigpOworCWRlc3Ryb3lfd29ya3F1
ZXVlKGRlZmVycmVkY2xvc2Vfd3EpOwogCWRlc3Ryb3lfd29ya3F1ZXVlKGNpZnNvcGxvY2tkX3dx
KTsKIAlkZXN0cm95X3dvcmtxdWV1ZShkZWNyeXB0X3dxKTsKIAlkZXN0cm95X3dvcmtxdWV1ZShm
aWxlaW5mb19wdXRfd3EpOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzZ2xvYi5oIGIvZnMvY2lm
cy9jaWZzZ2xvYi5oCmluZGV4IDMxZmM4Njk1YWJkNi4uYTZjNmM3ZDI1N2ViIDEwMDY0NAotLS0g
YS9mcy9jaWZzL2NpZnNnbG9iLmgKKysrIGIvZnMvY2lmcy9jaWZzZ2xvYi5oCkBAIC0xMTU0LDYg
KzExNTQsMTQgQEAgc3RydWN0IGNpZnNfcGVuZGluZ19vcGVuIHsKIAlfX3UzMiBvcGxvY2s7CiB9
OwogCitzdHJ1Y3QgY2lmc19kZWZlcnJlZF9jbG9zZSB7CisJc3RydWN0IGxpc3RfaGVhZCBkbGlz
dDsKKwlzdHJ1Y3QgdGNvbl9saW5rICp0bGluazsKKwlfX3UxNiAgbmV0ZmlkOworCV9fdTY0ICBw
ZXJzaXN0ZW50X2ZpZDsKKwlfX3U2NCAgdm9sYXRpbGVfZmlkOworfTsKKwogLyoKICAqIFRoaXMg
aW5mbyBoYW5ncyBvZmYgdGhlIGNpZnNGaWxlSW5mbyBzdHJ1Y3R1cmUsIHBvaW50ZWQgdG8gYnkg
bGxpc3QuCiAgKiBUaGlzIGlzIHVzZWQgdG8gdHJhY2sgYnl0ZSBzdHJlYW0gbG9ja3Mgb24gdGhl
IGZpbGUKQEAgLTEyNDgsNiArMTI1Niw5IEBAIHN0cnVjdCBjaWZzRmlsZUluZm8gewogCXN0cnVj
dCBjaWZzX3NlYXJjaF9pbmZvIHNyY2hfaW5mOwogCXN0cnVjdCB3b3JrX3N0cnVjdCBvcGxvY2tf
YnJlYWs7IC8qIHdvcmsgZm9yIG9wbG9jayBicmVha3MgKi8KIAlzdHJ1Y3Qgd29ya19zdHJ1Y3Qg
cHV0OyAvKiB3b3JrIGZvciB0aGUgZmluYWwgcGFydCBvZiBfcHV0ICovCisJc3RydWN0IGRlbGF5
ZWRfd29yayBkZWZlcnJlZDsKKwlib29sIG9wbG9ja19icmVha19yZWNlaXZlZDsgLyogRmxhZyB0
byBpbmRpY2F0ZSBvcGxvY2sgYnJlYWsgKi8KKwlib29sIGRlZmVycmVkX3NjaGVkdWxlZDsKIH07
CiAKIHN0cnVjdCBjaWZzX2lvX3Bhcm1zIHsKQEAgLTEzOTYsNiArMTQwNyw3IEBAIHN0cnVjdCBj
aWZzSW5vZGVJbmZvIHsKICNkZWZpbmUgQ0lGU19JTk9fREVMRVRFX1BFTkRJTkcJCSAgKDMpIC8q
IGRlbGV0ZSBwZW5kaW5nIG9uIHNlcnZlciAqLwogI2RlZmluZSBDSUZTX0lOT19JTlZBTElEX01B
UFBJTkcJICAoNCkgLyogcGFnZWNhY2hlIGlzIGludmFsaWQgKi8KICNkZWZpbmUgQ0lGU19JTk9f
TE9DSwkJCSAgKDUpIC8qIGxvY2sgYml0IGZvciBzeW5jaHJvbml6YXRpb24gKi8KKyNkZWZpbmUg
Q0lGU19JTk9fTU9ESUZJRURfQVRUUiAgICAgICAgICAgICg2KSAvKiBJbmRpY2F0ZSBjaGFuZ2Ug
aW4gbXRpbWUvY3RpbWUgKi8KIAl1bnNpZ25lZCBsb25nIGZsYWdzOwogCXNwaW5sb2NrX3Qgd3Jp
dGVyc19sb2NrOwogCXVuc2lnbmVkIGludCB3cml0ZXJzOwkJLyogTnVtYmVyIG9mIHdyaXRlcnMg
b24gdGhpcyBpbm9kZSAqLwpAQCAtMTQwOCw2ICsxNDIwLDggQEAgc3RydWN0IGNpZnNJbm9kZUlu
Zm8gewogCXN0cnVjdCBmc2NhY2hlX2Nvb2tpZSAqZnNjYWNoZTsKICNlbmRpZgogCXN0cnVjdCBp
bm9kZSB2ZnNfaW5vZGU7CisJc3RydWN0IGxpc3RfaGVhZCBkZWZlcnJlZF9jbG9zZXM7IC8qIGxp
c3Qgb2YgZGVmZXJyZWQgY2xvc2VzICovCisJc3BpbmxvY2tfdCBkZWZlcnJlZF9sb2NrOyAvKiBw
cm90ZWN0aW9uIG9uIGRlZmVycmVkIGxpc3QgKi8KIH07CiAKIHN0YXRpYyBpbmxpbmUgc3RydWN0
IGNpZnNJbm9kZUluZm8gKgpAQCAtMTg5MiwxMiArMTkwNiwxNCBAQCBHTE9CQUxfRVhURVJOIHNw
aW5sb2NrX3QgZ2lkc2lkbG9jazsKIAogdm9pZCBjaWZzX29wbG9ja19icmVhayhzdHJ1Y3Qgd29y
a19zdHJ1Y3QgKndvcmspOwogdm9pZCBjaWZzX3F1ZXVlX29wbG9ja19icmVhayhzdHJ1Y3QgY2lm
c0ZpbGVJbmZvICpjZmlsZSk7Cit2b2lkIHNtYjJfZGVmZXJyZWRfd29ya19jbG9zZShzdHJ1Y3Qg
d29ya19zdHJ1Y3QgKndvcmspOwogCiBleHRlcm4gY29uc3Qgc3RydWN0IHNsb3dfd29ya19vcHMg
Y2lmc19vcGxvY2tfYnJlYWtfb3BzOwogZXh0ZXJuIHN0cnVjdCB3b3JrcXVldWVfc3RydWN0ICpj
aWZzaW9kX3dxOwogZXh0ZXJuIHN0cnVjdCB3b3JrcXVldWVfc3RydWN0ICpkZWNyeXB0X3dxOwog
ZXh0ZXJuIHN0cnVjdCB3b3JrcXVldWVfc3RydWN0ICpmaWxlaW5mb19wdXRfd3E7CiBleHRlcm4g
c3RydWN0IHdvcmtxdWV1ZV9zdHJ1Y3QgKmNpZnNvcGxvY2tkX3dxOworZXh0ZXJuIHN0cnVjdCB3
b3JrcXVldWVfc3RydWN0ICpkZWZlcnJlZGNsb3NlX3dxOwogZXh0ZXJuIF9fdTMyIGNpZnNfbG9j
a19zZWNyZXQ7CiAKIGV4dGVybiBtZW1wb29sX3QgKmNpZnNfbWlkX3Bvb2xwOwpkaWZmIC0tZ2l0
IGEvZnMvY2lmcy9jaWZzcHJvdG8uaCBiL2ZzL2NpZnMvY2lmc3Byb3RvLmgKaW5kZXggNzVjZTZm
NzQyYjhkLi5lMmU1NmUxZjY2ZjUgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc3Byb3RvLmgKKysr
IGIvZnMvY2lmcy9jaWZzcHJvdG8uaApAQCAtMjU2LDYgKzI1NiwxNyBAQCBleHRlcm4gdm9pZCBj
aWZzX2FkZF9wZW5kaW5nX29wZW5fbG9ja2VkKHN0cnVjdCBjaWZzX2ZpZCAqZmlkLAogCQkJCQkg
c3RydWN0IHRjb25fbGluayAqdGxpbmssCiAJCQkJCSBzdHJ1Y3QgY2lmc19wZW5kaW5nX29wZW4g
Km9wZW4pOwogZXh0ZXJuIHZvaWQgY2lmc19kZWxfcGVuZGluZ19vcGVuKHN0cnVjdCBjaWZzX3Bl
bmRpbmdfb3BlbiAqb3Blbik7CisKK2V4dGVybiBib29sIGNpZnNfaXNfZGVmZXJyZWRfY2xvc2Uo
c3RydWN0IGNpZnNGaWxlSW5mbyAqY2ZpbGUsCisJCQkJc3RydWN0IGNpZnNfZGVmZXJyZWRfY2xv
c2UgKipkY2xvc2UpOworCitleHRlcm4gdm9pZCBjaWZzX2FkZF9kZWZlcnJlZF9jbG9zZShzdHJ1
Y3QgY2lmc0ZpbGVJbmZvICpjZmlsZSwKKwkJCQlzdHJ1Y3QgY2lmc19kZWZlcnJlZF9jbG9zZSAq
ZGNsb3NlKTsKKworZXh0ZXJuIHZvaWQgY2lmc19kZWxfZGVmZXJyZWRfY2xvc2Uoc3RydWN0IGNp
ZnNGaWxlSW5mbyAqY2ZpbGUpOworCitleHRlcm4gdm9pZCBjaWZzX2Nsb3NlX2RlZmVycmVkX2Zp
bGUoc3RydWN0IGNpZnNJbm9kZUluZm8gKmNpZnNfaW5vZGUpOworCiBleHRlcm4gc3RydWN0IFRD
UF9TZXJ2ZXJfSW5mbyAqY2lmc19nZXRfdGNwX3Nlc3Npb24oc3RydWN0IHNtYjNfZnNfY29udGV4
dCAqY3R4KTsKIGV4dGVybiB2b2lkIGNpZnNfcHV0X3RjcF9zZXNzaW9uKHN0cnVjdCBUQ1BfU2Vy
dmVyX0luZm8gKnNlcnZlciwKIAkJCQkgaW50IGZyb21fcmVjb25uZWN0KTsKZGlmZiAtLWdpdCBh
L2ZzL2NpZnMvZmlsZS5jIGIvZnMvY2lmcy9maWxlLmMKaW5kZXggMjZkZTQzMjlkMTYxLi43NDRj
Y2U5MzU3YmEgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvZmlsZS5jCisrKyBiL2ZzL2NpZnMvZmlsZS5j
CkBAIC0zMjEsOSArMzIxLDEyIEBAIGNpZnNfbmV3X2ZpbGVpbmZvKHN0cnVjdCBjaWZzX2ZpZCAq
ZmlkLCBzdHJ1Y3QgZmlsZSAqZmlsZSwKIAljZmlsZS0+ZGVudHJ5ID0gZGdldChkZW50cnkpOwog
CWNmaWxlLT5mX2ZsYWdzID0gZmlsZS0+Zl9mbGFnczsKIAljZmlsZS0+aW52YWxpZEhhbmRsZSA9
IGZhbHNlOworCWNmaWxlLT5vcGxvY2tfYnJlYWtfcmVjZWl2ZWQgPSBmYWxzZTsKKwljZmlsZS0+
ZGVmZXJyZWRfc2NoZWR1bGVkID0gZmFsc2U7CiAJY2ZpbGUtPnRsaW5rID0gY2lmc19nZXRfdGxp
bmsodGxpbmspOwogCUlOSVRfV09SSygmY2ZpbGUtPm9wbG9ja19icmVhaywgY2lmc19vcGxvY2tf
YnJlYWspOwogCUlOSVRfV09SSygmY2ZpbGUtPnB1dCwgY2lmc0ZpbGVJbmZvX3B1dF93b3JrKTsK
KwlJTklUX0RFTEFZRURfV09SSygmY2ZpbGUtPmRlZmVycmVkLCBzbWIyX2RlZmVycmVkX3dvcmtf
Y2xvc2UpOwogCW11dGV4X2luaXQoJmNmaWxlLT5maF9tdXRleCk7CiAJc3Bpbl9sb2NrX2luaXQo
JmNmaWxlLT5maWxlX2luZm9fbG9jayk7CiAKQEAgLTU2Miw2ICs1NjUsMjMgQEAgaW50IGNpZnNf
b3BlbihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkKIAkJCWZpbGUtPmZf
b3AgPSAmY2lmc19maWxlX2RpcmVjdF9vcHM7CiAJfQogCisJc3Bpbl9sb2NrKCZDSUZTX0koaW5v
ZGUpLT5kZWZlcnJlZF9sb2NrKTsKKwkvKiBHZXQgdGhlIGNhY2hlZCBoYW5kbGUgYXMgU01CMiBj
bG9zZSBpcyBkZWZlcnJlZCAqLworCXJjID0gY2lmc19nZXRfcmVhZGFibGVfcGF0aCh0Y29uLCBm
dWxsX3BhdGgsICZjZmlsZSk7CisJaWYgKHJjID09IDApIHsKKwkJaWYgKGZpbGUtPmZfZmxhZ3Mg
PT0gY2ZpbGUtPmZfZmxhZ3MpIHsKKwkJCWZpbGUtPnByaXZhdGVfZGF0YSA9IGNmaWxlOworCQkJ
Y2lmc19kZWxfZGVmZXJyZWRfY2xvc2UoY2ZpbGUpOworCQkJc3Bpbl91bmxvY2soJkNJRlNfSShp
bm9kZSktPmRlZmVycmVkX2xvY2spOworCQkJZ290byBvdXQ7CisJCX0gZWxzZSB7CisJCQlzcGlu
X3VubG9jaygmQ0lGU19JKGlub2RlKS0+ZGVmZXJyZWRfbG9jayk7CisJCQlfY2lmc0ZpbGVJbmZv
X3B1dChjZmlsZSwgdHJ1ZSwgZmFsc2UpOworCQl9CisJfSBlbHNlIHsKKwkJc3Bpbl91bmxvY2so
JkNJRlNfSShpbm9kZSktPmRlZmVycmVkX2xvY2spOworCX0KKwogCWlmIChzZXJ2ZXItPm9wbG9j
a3MpCiAJCW9wbG9jayA9IFJFUV9PUExPQ0s7CiAJZWxzZQpAQCAtODQyLDExICs4NjIsNTIgQEAg
Y2lmc19yZW9wZW5fZmlsZShzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpjZmlsZSwgYm9vbCBjYW5fZmx1
c2gpCiAJcmV0dXJuIHJjOwogfQogCit2b2lkIHNtYjJfZGVmZXJyZWRfd29ya19jbG9zZShzdHJ1
Y3Qgd29ya19zdHJ1Y3QgKndvcmspCit7CisJc3RydWN0IGNpZnNGaWxlSW5mbyAqY2ZpbGUgPSBj
b250YWluZXJfb2Yod29yaywKKwkJCXN0cnVjdCBjaWZzRmlsZUluZm8sIGRlZmVycmVkLndvcmsp
OworCisJc3Bpbl9sb2NrKCZDSUZTX0koZF9pbm9kZShjZmlsZS0+ZGVudHJ5KSktPmRlZmVycmVk
X2xvY2spOworCWNpZnNfZGVsX2RlZmVycmVkX2Nsb3NlKGNmaWxlKTsKKwljZmlsZS0+ZGVmZXJy
ZWRfc2NoZWR1bGVkID0gZmFsc2U7CisJc3Bpbl91bmxvY2soJkNJRlNfSShkX2lub2RlKGNmaWxl
LT5kZW50cnkpKS0+ZGVmZXJyZWRfbG9jayk7CisJX2NpZnNGaWxlSW5mb19wdXQoY2ZpbGUsIHRy
dWUsIGZhbHNlKTsKK30KKwogaW50IGNpZnNfY2xvc2Uoc3RydWN0IGlub2RlICppbm9kZSwgc3Ry
dWN0IGZpbGUgKmZpbGUpCiB7CisJc3RydWN0IGNpZnNGaWxlSW5mbyAqY2ZpbGU7CisJc3RydWN0
IGNpZnNJbm9kZUluZm8gKmNpbm9kZSA9IENJRlNfSShpbm9kZSk7CisJc3RydWN0IGNpZnNfc2Jf
aW5mbyAqY2lmc19zYiA9IENJRlNfU0IoaW5vZGUtPmlfc2IpOworCXN0cnVjdCBjaWZzX2RlZmVy
cmVkX2Nsb3NlICpkY2xvc2U7CisKIAlpZiAoZmlsZS0+cHJpdmF0ZV9kYXRhICE9IE5VTEwpIHsK
LQkJX2NpZnNGaWxlSW5mb19wdXQoZmlsZS0+cHJpdmF0ZV9kYXRhLCB0cnVlLCBmYWxzZSk7CisJ
CWNmaWxlID0gZmlsZS0+cHJpdmF0ZV9kYXRhOwogCQlmaWxlLT5wcml2YXRlX2RhdGEgPSBOVUxM
OworCQlkY2xvc2UgPSBrbWFsbG9jKHNpemVvZihzdHJ1Y3QgY2lmc19kZWZlcnJlZF9jbG9zZSks
IEdGUF9LRVJORUwpOworCQlpZiAoKGNpbm9kZS0+b3Bsb2NrID09IENJRlNfQ0FDSEVfUkhXX0ZM
RykgJiYKKwkJICAgIGRjbG9zZSkgeworCQkJaWYgKHRlc3RfYml0KENJRlNfSU5PX01PRElGSUVE
X0FUVFIsICZjaW5vZGUtPmZsYWdzKSkKKwkJCQlpbm9kZS0+aV9jdGltZSA9IGlub2RlLT5pX210
aW1lID0gY3VycmVudF90aW1lKGlub2RlKTsKKwkJCXNwaW5fbG9jaygmQ0lGU19JKGRfaW5vZGUo
Y2ZpbGUtPmRlbnRyeSkpLT5kZWZlcnJlZF9sb2NrKTsKKwkJCWNpZnNfYWRkX2RlZmVycmVkX2Ns
b3NlKGNmaWxlLCBkY2xvc2UpOworCQkJaWYgKGNmaWxlLT5kZWZlcnJlZF9zY2hlZHVsZWQpIHsK
KwkJCQltb2RfZGVsYXllZF93b3JrKGRlZmVycmVkY2xvc2Vfd3EsCisJCQkJCQkmY2ZpbGUtPmRl
ZmVycmVkLCBjaWZzX3NiLT5jdHgtPmFjcmVnbWF4KTsKKwkJCX0gZWxzZSB7CisJCQkJLyogRGVm
ZXJyZWQgY2xvc2UgZm9yIGZpbGVzICovCisJCQkJcXVldWVfZGVsYXllZF93b3JrKGRlZmVycmVk
Y2xvc2Vfd3EsCisJCQkJCQkmY2ZpbGUtPmRlZmVycmVkLCBjaWZzX3NiLT5jdHgtPmFjcmVnbWF4
KTsKKwkJCQljZmlsZS0+ZGVmZXJyZWRfc2NoZWR1bGVkID0gdHJ1ZTsKKwkJCQlzcGluX3VubG9j
aygmQ0lGU19JKGRfaW5vZGUoY2ZpbGUtPmRlbnRyeSkpLT5kZWZlcnJlZF9sb2NrKTsKKwkJCQly
ZXR1cm4gMDsKKwkJCX0KKwkJCXNwaW5fdW5sb2NrKCZDSUZTX0koZF9pbm9kZShjZmlsZS0+ZGVu
dHJ5KSktPmRlZmVycmVkX2xvY2spOworCQkJX2NpZnNGaWxlSW5mb19wdXQoY2ZpbGUsIHRydWUs
IGZhbHNlKTsKKwkJfSBlbHNlIHsKKwkJCV9jaWZzRmlsZUluZm9fcHV0KGNmaWxlLCB0cnVlLCBm
YWxzZSk7CisJCQlrZnJlZShkY2xvc2UpOworCQl9CiAJfQogCiAJLyogcmV0dXJuIGNvZGUgZnJv
bSB0aGUgLT5yZWxlYXNlIG9wIGlzIGFsd2F5cyBpZ25vcmVkICovCkBAIC0xOTQzLDcgKzIwMDQs
OCBAQCBzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpmaW5kX3JlYWRhYmxlX2ZpbGUoc3RydWN0IGNpZnNJ
bm9kZUluZm8gKmNpZnNfaW5vZGUsCiAJCWlmIChmc3VpZF9vbmx5ICYmICF1aWRfZXEob3Blbl9m
aWxlLT51aWQsIGN1cnJlbnRfZnN1aWQoKSkpCiAJCQljb250aW51ZTsKIAkJaWYgKE9QRU5fRk1P
REUob3Blbl9maWxlLT5mX2ZsYWdzKSAmIEZNT0RFX1JFQUQpIHsKLQkJCWlmICghb3Blbl9maWxl
LT5pbnZhbGlkSGFuZGxlKSB7CisJCQlpZiAoKCFvcGVuX2ZpbGUtPmludmFsaWRIYW5kbGUpICYm
CisJCQkJKCFvcGVuX2ZpbGUtPm9wbG9ja19icmVha19yZWNlaXZlZCkpIHsKIAkJCQkvKiBmb3Vu
ZCBhIGdvb2QgZmlsZSAqLwogCQkJCS8qIGxvY2sgaXQgc28gaXQgd2lsbCBub3QgYmUgY2xvc2Vk
IG9uIHVzICovCiAJCQkJY2lmc0ZpbGVJbmZvX2dldChvcGVuX2ZpbGUpOwpAQCAtMjQ3OCw2ICsy
NTQwLDggQEAgc3RhdGljIGludCBjaWZzX3dyaXRlcGFnZXMoc3RydWN0IGFkZHJlc3Nfc3BhY2Ug
Km1hcHBpbmcsCiAJaWYgKGNmaWxlKQogCQljaWZzRmlsZUluZm9fcHV0KGNmaWxlKTsKIAlmcmVl
X3hpZCh4aWQpOworCS8qIEluZGljYXRpb24gdG8gdXBkYXRlIGN0aW1lIGFuZCBtdGltZSBhcyBj
bG9zZSBpcyBkZWZlcnJlZCAqLworCXNldF9iaXQoQ0lGU19JTk9fTU9ESUZJRURfQVRUUiwgJkNJ
RlNfSShpbm9kZSktPmZsYWdzKTsKIAlyZXR1cm4gcmM7CiB9CiAKQEAgLTI1ODYsNiArMjY1MCw4
IEBAIHN0YXRpYyBpbnQgY2lmc193cml0ZV9lbmQoc3RydWN0IGZpbGUgKmZpbGUsIHN0cnVjdCBh
ZGRyZXNzX3NwYWNlICptYXBwaW5nLAogCiAJdW5sb2NrX3BhZ2UocGFnZSk7CiAJcHV0X3BhZ2Uo
cGFnZSk7CisJLyogSW5kaWNhdGlvbiB0byB1cGRhdGUgY3RpbWUgYW5kIG10aW1lIGFzIGNsb3Nl
IGlzIGRlZmVycmVkICovCisJc2V0X2JpdChDSUZTX0lOT19NT0RJRklFRF9BVFRSLCAmQ0lGU19J
KGlub2RlKS0+ZmxhZ3MpOwogCiAJcmV0dXJuIHJjOwogfQpAQCAtNDc0Niw2ICs0ODEyLDggQEAg
dm9pZCBjaWZzX29wbG9ja19icmVhayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJc3RydWN0
IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyID0gdGNvbi0+c2VzLT5zZXJ2ZXI7CiAJaW50IHJjID0g
MDsKIAlib29sIHB1cmdlX2NhY2hlID0gZmFsc2U7CisJYm9vbCBpc19kZWZlcnJlZCA9IGZhbHNl
OworCXN0cnVjdCBjaWZzX2RlZmVycmVkX2Nsb3NlICpkY2xvc2U7CiAKIAl3YWl0X29uX2JpdCgm
Y2lub2RlLT5mbGFncywgQ0lGU19JTk9ERV9QRU5ESU5HX1dSSVRFUlMsCiAJCQlUQVNLX1VOSU5U
RVJSVVBUSUJMRSk7CkBAIC00NzkzLDYgKzQ4NjEsMTggQEAgdm9pZCBjaWZzX29wbG9ja19icmVh
ayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJCWNpZnNfZGJnKEZZSSwgIk9wbG9jayByZWxl
YXNlIHJjID0gJWRcbiIsIHJjKTsKIAl9CiAJX2NpZnNGaWxlSW5mb19wdXQoY2ZpbGUsIGZhbHNl
IC8qIGRvIG5vdCB3YWl0IGZvciBvdXJzZWxmICovLCBmYWxzZSk7CisJLyoKKwkgKiBXaGVuIG9w
bG9jayBicmVhayBpcyByZWNlaXZlZCBhbmQgdGhlcmUgYXJlIG5vIGFjdGl2ZQorCSAqIGZpbGUg
aGFuZGxlcyBidXQgY2FjaGVkLCB0aGVuIHNldCB0aGUgZmxhZyBvcGxvY2tfYnJlYWtfcmVjZWl2
ZWQuCisJICogU28sIG5ldyBvcGVuIHdpbGwgbm90IHVzZSBjYWNoZWQgaGFuZGxlLgorCSAqLwor
CXNwaW5fbG9jaygmQ0lGU19JKGRfaW5vZGUoY2ZpbGUtPmRlbnRyeSkpLT5kZWZlcnJlZF9sb2Nr
KTsKKwlpc19kZWZlcnJlZCA9IGNpZnNfaXNfZGVmZXJyZWRfY2xvc2UoY2ZpbGUsICZkY2xvc2Up
OworCWlmIChpc19kZWZlcnJlZCkgeworCQljZmlsZS0+b3Bsb2NrX2JyZWFrX3JlY2VpdmVkID0g
dHJ1ZTsKKwkJbW9kX2RlbGF5ZWRfd29yayhkZWZlcnJlZGNsb3NlX3dxLCAmY2ZpbGUtPmRlZmVy
cmVkLCAwKTsKKwl9CisJc3Bpbl91bmxvY2soJkNJRlNfSShkX2lub2RlKGNmaWxlLT5kZW50cnkp
KS0+ZGVmZXJyZWRfbG9jayk7CiAJY2lmc19kb25lX29wbG9ja19icmVhayhjaW5vZGUpOwogfQog
CmRpZmYgLS1naXQgYS9mcy9jaWZzL2lub2RlLmMgYi9mcy9jaWZzL2lub2RlLmMKaW5kZXggZjJk
ZjQ0MjJlNTRhLi5jZTdkNzE3MzU1MGMgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvaW5vZGUuYworKysg
Yi9mcy9jaWZzL2lub2RlLmMKQEAgLTE2NDMsNiArMTY0Myw3IEBAIGludCBjaWZzX3VubGluayhz
dHJ1Y3QgaW5vZGUgKmRpciwgc3RydWN0IGRlbnRyeSAqZGVudHJ5KQogCQlnb3RvIHVubGlua19v
dXQ7CiAJfQogCisJY2lmc19jbG9zZV9kZWZlcnJlZF9maWxlKENJRlNfSShpbm9kZSkpOwogCWlm
IChjYXBfdW5peCh0Y29uLT5zZXMpICYmIChDSUZTX1VOSVhfUE9TSVhfUEFUSF9PUFNfQ0FQICYK
IAkJCQlsZTY0X3RvX2NwdSh0Y29uLT5mc1VuaXhJbmZvLkNhcGFiaWxpdHkpKSkgewogCQlyYyA9
IENJRlNQT1NJWERlbEZpbGUoeGlkLCB0Y29uLCBmdWxsX3BhdGgsCmRpZmYgLS1naXQgYS9mcy9j
aWZzL21pc2MuYyBiL2ZzL2NpZnMvbWlzYy5jCmluZGV4IDgyZTE3NjcyMGNhNi4uNTg5Mjc0OGIz
NGU2IDEwMDY0NAotLS0gYS9mcy9jaWZzL21pc2MuYworKysgYi9mcy9jaWZzL21pc2MuYwpAQCAt
NjcyLDYgKzY3Miw2OCBAQCBjaWZzX2FkZF9wZW5kaW5nX29wZW4oc3RydWN0IGNpZnNfZmlkICpm
aWQsIHN0cnVjdCB0Y29uX2xpbmsgKnRsaW5rLAogCXNwaW5fdW5sb2NrKCZ0bGlua190Y29uKG9w
ZW4tPnRsaW5rKS0+b3Blbl9maWxlX2xvY2spOwogfQogCitib29sCitjaWZzX2lzX2RlZmVycmVk
X2Nsb3NlKHN0cnVjdCBjaWZzRmlsZUluZm8gKmNmaWxlLCBzdHJ1Y3QgY2lmc19kZWZlcnJlZF9j
bG9zZSAqKnBkY2xvc2UpCit7CisJc3RydWN0IGNpZnNfZGVmZXJyZWRfY2xvc2UgKmRjbG9zZTsK
KworCWxpc3RfZm9yX2VhY2hfZW50cnkoZGNsb3NlLCAmQ0lGU19JKGRfaW5vZGUoY2ZpbGUtPmRl
bnRyeSkpLT5kZWZlcnJlZF9jbG9zZXMsIGRsaXN0KSB7CisJCWlmICgoZGNsb3NlLT5uZXRmaWQg
PT0gY2ZpbGUtPmZpZC5uZXRmaWQpICYmCisJCQkoZGNsb3NlLT5wZXJzaXN0ZW50X2ZpZCA9PSBj
ZmlsZS0+ZmlkLnBlcnNpc3RlbnRfZmlkKSAmJgorCQkJKGRjbG9zZS0+dm9sYXRpbGVfZmlkID09
IGNmaWxlLT5maWQudm9sYXRpbGVfZmlkKSkgeworCQkJKnBkY2xvc2UgPSBkY2xvc2U7CisJCQly
ZXR1cm4gdHJ1ZTsKKwkJfQorCX0KKwlyZXR1cm4gZmFsc2U7Cit9CisKK3ZvaWQKK2NpZnNfYWRk
X2RlZmVycmVkX2Nsb3NlKHN0cnVjdCBjaWZzRmlsZUluZm8gKmNmaWxlLCBzdHJ1Y3QgY2lmc19k
ZWZlcnJlZF9jbG9zZSAqZGNsb3NlKQoreworCWJvb2wgaXNfZGVmZXJyZWQgPSBmYWxzZTsKKwlz
dHJ1Y3QgY2lmc19kZWZlcnJlZF9jbG9zZSAqcGRjbG9zZTsKKworCWlzX2RlZmVycmVkID0gY2lm
c19pc19kZWZlcnJlZF9jbG9zZShjZmlsZSwgJnBkY2xvc2UpOworCWlmIChpc19kZWZlcnJlZCkg
eworCQlrZnJlZShkY2xvc2UpOworCQlyZXR1cm47CisJfQorCisJZGNsb3NlLT50bGluayA9IGNm
aWxlLT50bGluazsKKwlkY2xvc2UtPm5ldGZpZCA9IGNmaWxlLT5maWQubmV0ZmlkOworCWRjbG9z
ZS0+cGVyc2lzdGVudF9maWQgPSBjZmlsZS0+ZmlkLnBlcnNpc3RlbnRfZmlkOworCWRjbG9zZS0+
dm9sYXRpbGVfZmlkID0gY2ZpbGUtPmZpZC52b2xhdGlsZV9maWQ7CisJbGlzdF9hZGRfdGFpbCgm
ZGNsb3NlLT5kbGlzdCwgJkNJRlNfSShkX2lub2RlKGNmaWxlLT5kZW50cnkpKS0+ZGVmZXJyZWRf
Y2xvc2VzKTsKK30KKwordm9pZAorY2lmc19kZWxfZGVmZXJyZWRfY2xvc2Uoc3RydWN0IGNpZnNG
aWxlSW5mbyAqY2ZpbGUpCit7CisJYm9vbCBpc19kZWZlcnJlZCA9IGZhbHNlOworCXN0cnVjdCBj
aWZzX2RlZmVycmVkX2Nsb3NlICpkY2xvc2U7CisKKwlpc19kZWZlcnJlZCA9IGNpZnNfaXNfZGVm
ZXJyZWRfY2xvc2UoY2ZpbGUsICZkY2xvc2UpOworCWlmICghaXNfZGVmZXJyZWQpCisJCXJldHVy
bjsKKwlsaXN0X2RlbCgmZGNsb3NlLT5kbGlzdCk7CisJa2ZyZWUoZGNsb3NlKTsKK30KKwordm9p
ZAorY2lmc19jbG9zZV9kZWZlcnJlZF9maWxlKHN0cnVjdCBjaWZzSW5vZGVJbmZvICpjaWZzX2lu
b2RlKQoreworCXN0cnVjdCBjaWZzRmlsZUluZm8gKmNmaWxlID0gTlVMTDsKKwlzdHJ1Y3QgY2lm
c19kZWZlcnJlZF9jbG9zZSAqZGNsb3NlOworCisJbGlzdF9mb3JfZWFjaF9lbnRyeShjZmlsZSwg
JmNpZnNfaW5vZGUtPm9wZW5GaWxlTGlzdCwgZmxpc3QpIHsKKwkJc3Bpbl9sb2NrKCZDSUZTX0ko
ZF9pbm9kZShjZmlsZS0+ZGVudHJ5KSktPmRlZmVycmVkX2xvY2spOworCQlpZiAoY2lmc19pc19k
ZWZlcnJlZF9jbG9zZShjZmlsZSwgJmRjbG9zZSkpCisJCQltb2RfZGVsYXllZF93b3JrKGRlZmVy
cmVkY2xvc2Vfd3EsICZjZmlsZS0+ZGVmZXJyZWQsIDApOworCQlzcGluX3VubG9jaygmQ0lGU19J
KGRfaW5vZGUoY2ZpbGUtPmRlbnRyeSkpLT5kZWZlcnJlZF9sb2NrKTsKKwl9Cit9CisKIC8qIHBh
cnNlcyBERlMgcmVmZmVyYWwgVjMgc3RydWN0dXJlCiAgKiBjYWxsZXIgaXMgcmVzcG9uc2libGUg
Zm9yIGZyZWVpbmcgdGFyZ2V0X25vZGVzCiAgKiByZXR1cm5zOgotLSAKMi4xNy4xCgo=
--0000000000009dd5e005bfb169b0--
