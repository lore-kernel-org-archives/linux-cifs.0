Return-Path: <SRS0=HHpq=RQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CB57C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Mar 2019 05:03:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D9392077B
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Mar 2019 05:03:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H+nGcymR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbfCMFDS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Mar 2019 01:03:18 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:33939 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfCMFDS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Mar 2019 01:03:18 -0400
Received: by mail-pg1-f173.google.com with SMTP id v12so655233pgq.1
        for <linux-cifs@vger.kernel.org>; Tue, 12 Mar 2019 22:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ouIVhzxejaXLFpyttrQBQLkOou9D7aoPJR10dQDk7Cc=;
        b=H+nGcymRfAG8tSHFOmOk58olshybyJfO2e4qwWOd3Zd7fiFEHLW5ksYt2oVj4NTj9+
         c0aZ378byN2GEcruA8m2fwgYxKFQPZLnO3VoJZp60d3BvroaAEOzZtkYv+l7pcLgy6Cx
         /CiLOc9gLUM+fAsU1EXKwscNxf3z+HqOd2doslsTcO2ubSGHMce9GlgbjX0PaJFCK2t+
         CcCjiThMWCifOf0FhNPzcRtJ0PhBYY9rR1eWSZ1fb3pXp8cwr8hv1WmtBIjluMsENqZ/
         ptgaX7J+0Nk+8XBkruRxH8zrPENiQ6o8vxCKmG/L5hHwQOvJDxaSNMXmn/I5F6r5N4Gy
         bHCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ouIVhzxejaXLFpyttrQBQLkOou9D7aoPJR10dQDk7Cc=;
        b=g7iVnxVTqC3o/LuyAnQxY3Dk9AdIaPEtgZYUPd25mo7j2/9XW6e4mP9Ghq9XSXwvnB
         ZcSCNjeuNAcoSrb9lQ/xjZKpr6CDe0fA2G5XRqPh1wsWRqqoRRSirTPBlRqa+MmB/Pqq
         uqkkEZUE2qLWAeH88pFzHUgO4qPouYbaa7KXA0l4VOekZ4n9Sy/ZjBLqHcKpJK/hZ6Lw
         il+DkJTKxz2/kmMul3jKXiTgPw1Uhwe1RblJ8EoYjIIyBhpEwUDV5xBRUs9qPeZugXnD
         z3ibffsi7V3mg1dwfp4sG+dH9IzyetuJZsTxNagB0iYUOX8P1rUAYNtZvWhUP0cmIIB0
         MlMw==
X-Gm-Message-State: APjAAAV+PsH1MvTJXmVwh0yZ9p0e3FiBCjyBO7L128PzYJiJSaKAFwMK
        oSuvB71wTij06HPdQJm+vYxkQZbhoqvg6SS5QgUcnj9o
X-Google-Smtp-Source: APXvYqwBG9Up/erHcb+GenV+x0Mkj+h66XOa0gqnsDhJeUKPMuMbgn/nfGveXW3rJDINaKffR0DtaEOyZ4CONrSEZx8=
X-Received: by 2002:a63:974a:: with SMTP id d10mr26387667pgo.344.1552453396112;
 Tue, 12 Mar 2019 22:03:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muY3xgVW03Mi8N-c4wyZFikzTeZgLDEuGLoXFXNZ-wFHA@mail.gmail.com>
 <CAKywueR9-_yYVA4YfycxfH_jog0xQKhgoQeFG6nhLws4TLC8Tg@mail.gmail.com>
 <CAH2r5mv+6N=p183kFpYnFGo7ixcu1TkCjBvWnct=1M91kH3_WA@mail.gmail.com>
 <CAH2r5mv2Cp8YseCF1rz0dH8tvPYZ1+dCykupzVv_S81f2gPMJg@mail.gmail.com>
 <CAN05THQt3se9xsbhKOsA4ZxhuZpe_SnkTAisTP0AnpKsb-jfOQ@mail.gmail.com>
 <CAH2r5mvVA6Ov2sL-crNgeT91MeLeAZTJtNW6dZSnhh=ATzvjTQ@mail.gmail.com> <CAKywueR=hkkkPHeR-jfj21bbcvgOBP6Y-QaHPP7wB4Neyk5mMQ@mail.gmail.com>
In-Reply-To: <CAKywueR=hkkkPHeR-jfj21bbcvgOBP6Y-QaHPP7wB4Neyk5mMQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 13 Mar 2019 00:03:04 -0500
Message-ID: <CAH2r5msK48GgjKgJWJf0QA1N6ZV_+3fShmJJSBbmQ87Kk30+mw@mail.gmail.com>
Subject: Re: [PATCH][SMB3] Add various dynamic tracepoints for compounded operations
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000003bd7110583f2b981"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000003bd7110583f2b981
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Version 3 of the patch attached.   Sample output below:
(trace-cmd  record -e *query_info_co* -e smb3_hardlink* -e
smb3_rename* -e smb3_set_eof* -e smb3_set_info_co* -e smb3_mkdir* -e
smb3_delete* -e smb3_rmdir*)

           mkdir-17927 [003] .... 447434.636544:
smb3_query_info_compound_enter: xid=3D7 sid=3D0x7dc5fd6f tid=3D0xc7968732
path=3D\newdir
           mkdir-17927 [003] .... 447434.637240:
smb3_query_info_compound_err: xid=3D7 sid=3D0x7dc5fd6f tid=3D0xc7968732
rc=3D-2
           mkdir-17942 [000] .... 447446.807606:
smb3_query_info_compound_enter: xid=3D8 sid=3D0x7dc5fd6f tid=3D0xc7968732
path=3D\newdir
           mkdir-17942 [000] .... 447446.808233:
smb3_query_info_compound_err: xid=3D8 sid=3D0x7dc5fd6f tid=3D0xc7968732
rc=3D-2
           mkdir-17942 [000] .... 447446.808251: smb3_mkdir_enter:
xid=3D9 sid=3D0x7dc5fd6f tid=3D0xc7968732 path=3D\newdir
           mkdir-17942 [000] .... 447446.809161: smb3_mkdir_done:
xid=3D9 sid=3D0x7dc5fd6f tid=3D0xc7968732
           mkdir-17942 [000] .... 447446.809178:
smb3_query_info_compound_enter: xid=3D9 sid=3D0x7dc5fd6f tid=3D0xc7968732
path=3D\newdir
           mkdir-17942 [000] .... 447446.809979:
smb3_query_info_compound_done: xid=3D9 sid=3D0x7dc5fd6f tid=3D0xc7968732
           rmdir-17943 [001] .... 447451.374029:
smb3_query_info_compound_enter: xid=3D10 sid=3D0x7dc5fd6f tid=3D0xc7968732
path=3D\baddir
           rmdir-17943 [001] .... 447451.379621:
smb3_query_info_compound_err: xid=3D10 sid=3D0x7dc5fd6f tid=3D0xc7968732
rc=3D-2
           rmdir-17944 [001] .... 447456.088795:
smb3_query_info_compound_enter: xid=3D11 sid=3D0x7dc5fd6f tid=3D0xc7968732
path=3D\newdir
           rmdir-17944 [001] .... 447456.089615:
smb3_query_info_compound_done: xid=3D11 sid=3D0x7dc5fd6f tid=3D0xc7968732
           rmdir-17944 [001] .... 447456.089640: smb3_rmdir_enter:
xid=3D12 sid=3D0x7dc5fd6f tid=3D0xc7968732 path=3D\newdir
           rmdir-17944 [001] .... 447456.090651: smb3_rmdir_done:
xid=3D12 sid=3D0x7dc5fd6f tid=3D0xc7968732
           touch-17945 [006] .... 447460.575789:
smb3_set_info_compound_enter: xid=3D14 sid=3D0x7dc5fd6f tid=3D0xc7968732
path=3D\file
           touch-17945 [006] .... 447460.576571:
smb3_set_info_compound_done: xid=3D14 sid=3D0x7dc5fd6f tid=3D0xc7968732
              ln-17946 [001] .... 447468.254480:
smb3_query_info_compound_enter: xid=3D16 sid=3D0x7dc5fd6f tid=3D0xc7968732
path=3D\linkedfile
              ln-17946 [001] .... 447468.255082:
smb3_query_info_compound_err: xid=3D16 sid=3D0x7dc5fd6f tid=3D0xc7968732
rc=3D-2
              ln-17946 [001] .... 447468.255118:
smb3_query_info_compound_enter: xid=3D17 sid=3D0x7dc5fd6f tid=3D0xc7968732
path=3D\file
              ln-17946 [001] .... 447468.255715:
smb3_query_info_compound_done: xid=3D17 sid=3D0x7dc5fd6f tid=3D0xc7968732
              ln-17946 [001] .... 447468.255760:
smb3_query_info_compound_enter: xid=3D18 sid=3D0x7dc5fd6f tid=3D0xc7968732
path=3D\linkedfile
              ln-17946 [001] .... 447468.256254:
smb3_query_info_compound_err: xid=3D18 sid=3D0x7dc5fd6f tid=3D0xc7968732
rc=3D-2
              ln-17946 [001] .... 447468.256277: smb3_hardlink_enter:
xid=3D19 sid=3D0x7dc5fd6f tid=3D0xc7968732 path=3D\file
              ln-17946 [001] .... 447468.256954: smb3_hardlink_done:
xid=3D19 sid=3D0x7dc5fd6f tid=3D0xc7968732
           gmain-2225  [004] .... 447468.257130:
smb3_query_info_compound_enter: xid=3D20 sid=3D0x7dc5fd6f tid=3D0xc7968732
path=3D\linkedfile
           gmain-2225  [005] .... 447468.257788:
smb3_query_info_compound_done: xid=3D20 sid=3D0x7dc5fd6f tid=3D0xc7968732

On Tue, Mar 12, 2019 at 4:51 PM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> I actually like the idea proposed in the patch: this way we will be
> able to track logical operations better. In a case we need a deeper
> logging we already have mid traces which contains MID, TID, SID and
> CMD - everything you need to trace individual SMB packet regardless of
> whether it is a part of compounding chain or not.
>
> Now in order to match both logical operation and SMB packets traces we
> need something common - like XID. Currently we do not propagate XID
> down to the transport layer, let's do that - this way we can trace
> individual system call from the very beginning to the completeness on
> every layer inside cifs.ko.
>
> =D0=B2=D1=82, 12 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 00:19, Steve Fre=
nch <smfrench@gmail.com>:
> >
> > The general feeling I am getting from tracing the compounding is that
> > we have to have the more granular tracing available
> > (similar to this patch), and also (with followon patch) add noisier
> > optional trace points lower down (that are generic) that we turn on
> > less frequently (in particular when the filename is not good enough
> > and we must have the xid - even if it makes the trace very noisy)
> >
> >
> > On Tue, Mar 12, 2019 at 1:06 AM ronnie sahlberg
> > <ronniesahlberg@gmail.com> wrote:
> > >
> > > Hmm.
> > >
> > > I don't think this is the wrong layer to add the tracing.
> > > Instead of adding the tracing in say smb2_compound_op(), where we
> > > create the compound,
> > > I think it will be better to add the tracing down in the leaf
> > > functions, i.e. down in SMB2_open_init(), SMB2_query_info_init(), ...
> > >
> > > That way we know that we will always have tracing for all opens/close=
s/...
> > >
> > > But then what to do about the trace_smb3_..._err()/trace_smb3_..._don=
e() calls ?
> > > These I think should be moved down and handled inside compound_send_r=
ecv().
> > > That way we can have one single place where we call the appropriate
> > > _err()/_done() functions
> > > and we know that we will catch every single completed function.
> > >
> > > I.e. just put it in a single place instead of in every single call-si=
te.
> > > In compound_send_recv we can just loop over all the responses, cast i=
t
> > > to a smb2_hdr structure, looka at both the command code as well as th=
e
> > > status code and call the appropriate xys_err() or xyz_done() function=
s
> > > as needed.
> > >
> > > Let me show an example of what I mean for a open/query/close compound=
 :
> > >
> > > trace_smb3_open_enter(xid=3D5, filename=3D"foo", ...)   from SMB2_ope=
n_init()
> > > trace_smb3_query_info_enter(xid=3D5,... ) from SMB2_query_info_init()
> > > trace_smb3_close_enter(xid=3D5, ...) from SMB2_close_init()
> > > (maybe have additional tracing in compound_send_recv() that we are
> > > about to send xid=3D5 to the wire)
> > > trace_smb3_open_done(xid=3D5, ...) from compound_send_recv()
> > > trace_smb3_query_info_done(xid=3D5, ...) from compound_send_recv()
> > > trace_smb3_close_done(xid=3D5, ...) from compound_send_recv()
> > >
>
> As pointed above we already have a similar tracing inside
> compound_send_recv and other transport layer functions - command level
> tracing. The only problem is that we do not log failure cases when we
> didn't send the packet - we only log server responses in
> map_smb2_to_linux_error. This is another area of the tracing where a
> fix is needed.
>
> --
> Best regards,
> Pavel Shilovsky



--=20
Thanks,

Steve

--0000000000003bd7110583f2b981
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-Add-dynamic-trace-points-for-various-compounded.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-Add-dynamic-trace-points-for-various-compounded.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jt6qns2a0>
X-Attachment-Id: f_jt6qns2a0

RnJvbSBmZTNjZmMyNTJiZTk4NTdjMTYwOTczZTQ5OWMzYmRkNzQyOGUzYzk2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTMgTWFyIDIwMTkgMDA6MDI6NDcgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBBZGQgZHluYW1pYyB0cmFjZSBwb2ludHMgZm9yIHZhcmlvdXMgY29tcG91bmRlZCAgc21i
Mwogb3BzCgpBZGRzIHRyYWNlIHBvaW50cyBmb3IgZW50ZXIgYW5kIGV4aXQgKGRvbmUgdnMuIGVy
cm9yKSBmb3I6CgoJY29tcG91bmRlZCBxdWVyeSBhbmQgc2V0aW5mbywgaGFyZGxpbmssIHJlbmFt
ZSwKCW1rZGlyLCBybWRpciwgc2V0X2VvZiwgZGVsZXRlICh1bmxpbmspCgpTaWduZWQtb2ZmLWJ5
OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIy
aW5vZGUuYyB8ICA3MiArKysrKysrKysrKysrKysrKysrKysrKysrLS0KIGZzL2NpZnMvdHJhY2Uu
aCAgICAgfCAxMTcgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysK
IDIgZmlsZXMgY2hhbmdlZCwgMTg1IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvZnMvY2lmcy9zbWIyaW5vZGUuYyBiL2ZzL2NpZnMvc21iMmlub2RlLmMKaW5kZXgg
YjZlMDdlMmVlZDEwLi4yNzg0MDVkMjZjNDcgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMmlub2Rl
LmMKKysrIGIvZnMvY2lmcy9zbWIyaW5vZGUuYwpAQCAtMzcsNiArMzcsMTYgQEAKICNpbmNsdWRl
ICJzbWIycGR1LmgiCiAjaW5jbHVkZSAic21iMnByb3RvLmgiCiAKK3N0YXRpYyB2b2lkCitmcmVl
X3NldF9pbmZfY29tcG91bmQoc3RydWN0IHNtYl9ycXN0ICpycXN0KQoreworCWlmIChycXN0WzFd
LnJxX2lvdikKKwkJU01CMl9zZXRfaW5mb19mcmVlKCZycXN0WzFdKTsKKwlpZiAocnFzdFsyXS5y
cV9pb3YpCisJCVNNQjJfY2xvc2VfZnJlZSgmcnFzdFsyXSk7Cit9CisKKwogc3RhdGljIGludAog
c21iMl9jb21wb3VuZF9vcChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29u
ICp0Y29uLAogCQkgc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwgY29uc3QgY2hhciAqZnVs
bF9wYXRoLApAQCAtMTEyLDE0ICsxMjIsMTggQEAgc21iMl9jb21wb3VuZF9vcChjb25zdCB1bnNp
Z25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkJCQkgIFBBVEhfTUFYICog
MiwgMCwgTlVMTCk7CiAJCXNtYjJfc2V0X25leHRfY29tbWFuZCh0Y29uLCAmcnFzdFtudW1fcnFz
dF0pOwogCQlzbWIyX3NldF9yZWxhdGVkKCZycXN0W251bV9ycXN0KytdKTsKKwkJdHJhY2Vfc21i
M19xdWVyeV9pbmZvX2NvbXBvdW5kX2VudGVyKHhpZCwgc2VzLT5TdWlkLCB0Y29uLT50aWQsCisJ
CQkJCQkgICAgIGZ1bGxfcGF0aCk7CiAJCWJyZWFrOwogCWNhc2UgU01CMl9PUF9ERUxFVEU6CisJ
CXRyYWNlX3NtYjNfZGVsZXRlX2VudGVyKHhpZCwgc2VzLT5TdWlkLCB0Y29uLT50aWQsIGZ1bGxf
cGF0aCk7CiAJCWJyZWFrOwogCWNhc2UgU01CMl9PUF9NS0RJUjoKIAkJLyoKIAkJICogRGlyZWN0
b3JpZXMgYXJlIGNyZWF0ZWQgdGhyb3VnaCBwYXJhbWV0ZXJzIGluIHRoZQogCQkgKiBTTUIyX29w
ZW4oKSBjYWxsLgogCQkgKi8KKwkJdHJhY2Vfc21iM19ta2Rpcl9lbnRlcih4aWQsIHNlcy0+U3Vp
ZCwgdGNvbi0+dGlkLCBmdWxsX3BhdGgpOwogCQlicmVhazsKIAljYXNlIFNNQjJfT1BfUk1ESVI6
CiAJCW1lbXNldCgmc2lfaW92LCAwLCBzaXplb2Yoc2lfaW92KSk7CkBAIC0xMzUsNiArMTQ5LDcg
QEAgc21iMl9jb21wb3VuZF9vcChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190
Y29uICp0Y29uLAogCQkJCQlTTUIyX09fSU5GT19GSUxFLCAwLCBkYXRhLCBzaXplKTsKIAkJc21i
Ml9zZXRfbmV4dF9jb21tYW5kKHRjb24sICZycXN0W251bV9ycXN0XSk7CiAJCXNtYjJfc2V0X3Jl
bGF0ZWQoJnJxc3RbbnVtX3Jxc3QrK10pOworCQl0cmFjZV9zbWIzX3JtZGlyX2VudGVyKHhpZCwg
c2VzLT5TdWlkLCB0Y29uLT50aWQsIGZ1bGxfcGF0aCk7CiAJCWJyZWFrOwogCWNhc2UgU01CMl9P
UF9TRVRfRU9GOgogCQltZW1zZXQoJnNpX2lvdiwgMCwgc2l6ZW9mKHNpX2lvdikpOwpAQCAtMTUw
LDYgKzE2NSw3IEBAIHNtYjJfY29tcG91bmRfb3AoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3Ry
dWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJCQkJU01CMl9PX0lORk9fRklMRSwgMCwgZGF0YSwgc2l6
ZSk7CiAJCXNtYjJfc2V0X25leHRfY29tbWFuZCh0Y29uLCAmcnFzdFtudW1fcnFzdF0pOwogCQlz
bWIyX3NldF9yZWxhdGVkKCZycXN0W251bV9ycXN0KytdKTsKKwkJdHJhY2Vfc21iM19zZXRfZW9m
X2VudGVyKHhpZCwgc2VzLT5TdWlkLCB0Y29uLT50aWQsIGZ1bGxfcGF0aCk7CiAJCWJyZWFrOwog
CWNhc2UgU01CMl9PUF9TRVRfSU5GTzoKIAkJbWVtc2V0KCZzaV9pb3YsIDAsIHNpemVvZihzaV9p
b3YpKTsKQEAgLTE2Niw2ICsxODIsOCBAQCBzbWIyX2NvbXBvdW5kX29wKGNvbnN0IHVuc2lnbmVk
IGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCQkJCVNNQjJfT19JTkZPX0ZJTEUs
IDAsIGRhdGEsIHNpemUpOwogCQlzbWIyX3NldF9uZXh0X2NvbW1hbmQodGNvbiwgJnJxc3RbbnVt
X3Jxc3RdKTsKIAkJc21iMl9zZXRfcmVsYXRlZCgmcnFzdFtudW1fcnFzdCsrXSk7CisJCXRyYWNl
X3NtYjNfc2V0X2luZm9fY29tcG91bmRfZW50ZXIoeGlkLCBzZXMtPlN1aWQsIHRjb24tPnRpZCwK
KwkJCQkJCSAgIGZ1bGxfcGF0aCk7CiAJCWJyZWFrOwogCWNhc2UgU01CMl9PUF9SRU5BTUU6CiAJ
CW1lbXNldCgmc2lfaW92LCAwLCBzaXplb2Yoc2lfaW92KSk7CkBAIC0xOTAsNiArMjA4LDcgQEAg
c21iMl9jb21wb3VuZF9vcChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29u
ICp0Y29uLAogCQkJCQlTTUIyX09fSU5GT19GSUxFLCAwLCBkYXRhLCBzaXplKTsKIAkJc21iMl9z
ZXRfbmV4dF9jb21tYW5kKHRjb24sICZycXN0W251bV9ycXN0XSk7CiAJCXNtYjJfc2V0X3JlbGF0
ZWQoJnJxc3RbbnVtX3Jxc3QrK10pOworCQl0cmFjZV9zbWIzX3JlbmFtZV9lbnRlcih4aWQsIHNl
cy0+U3VpZCwgdGNvbi0+dGlkLCBmdWxsX3BhdGgpOwogCQlicmVhazsKIAljYXNlIFNNQjJfT1Bf
SEFSRExJTks6CiAJCW1lbXNldCgmc2lfaW92LCAwLCBzaXplb2Yoc2lfaW92KSk7CkBAIC0yMTQs
NiArMjMzLDcgQEAgc21iMl9jb21wb3VuZF9vcChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1
Y3QgY2lmc190Y29uICp0Y29uLAogCQkJCQlTTUIyX09fSU5GT19GSUxFLCAwLCBkYXRhLCBzaXpl
KTsKIAkJc21iMl9zZXRfbmV4dF9jb21tYW5kKHRjb24sICZycXN0W251bV9ycXN0XSk7CiAJCXNt
YjJfc2V0X3JlbGF0ZWQoJnJxc3RbbnVtX3Jxc3QrK10pOworCQl0cmFjZV9zbWIzX2hhcmRsaW5r
X2VudGVyKHhpZCwgc2VzLT5TdWlkLCB0Y29uLT50aWQsIGZ1bGxfcGF0aCk7CiAJCWJyZWFrOwog
CWRlZmF1bHQ6CiAJCWNpZnNfZGJnKFZGUywgIkludmFsaWQgY29tbWFuZFxuIik7CkBAIC0yNTIs
MjEgKzI3Miw2NSBAQCBzbWIyX2NvbXBvdW5kX29wKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0
cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCQlTTUIyX3F1ZXJ5X2luZm9fZnJlZSgmcnFzdFsxXSk7
CiAJCWlmIChycXN0WzJdLnJxX2lvdikKIAkJCVNNQjJfY2xvc2VfZnJlZSgmcnFzdFsyXSk7CisJ
CWlmIChyYykKKwkJCXRyYWNlX3NtYjNfcXVlcnlfaW5mb19jb21wb3VuZF9lcnIoeGlkLCAgc2Vz
LT5TdWlkLAorCQkJCQkJdGNvbi0+dGlkLCByYyk7CisJCWVsc2UKKwkJCXRyYWNlX3NtYjNfcXVl
cnlfaW5mb19jb21wb3VuZF9kb25lKHhpZCwgc2VzLT5TdWlkLAorCQkJCQkJdGNvbi0+dGlkKTsK
IAkJYnJlYWs7CiAJY2FzZSBTTUIyX09QX0RFTEVURToKKwkJaWYgKHJjKQorCQkJdHJhY2Vfc21i
M19kZWxldGVfZXJyKHhpZCwgIHNlcy0+U3VpZCwgdGNvbi0+dGlkLCByYyk7CisJCWVsc2UKKwkJ
CXRyYWNlX3NtYjNfZGVsZXRlX2RvbmUoeGlkLCBzZXMtPlN1aWQsIHRjb24tPnRpZCk7CisJCWlm
IChycXN0WzFdLnJxX2lvdikKKwkJCVNNQjJfY2xvc2VfZnJlZSgmcnFzdFsxXSk7CisJCWJyZWFr
OwogCWNhc2UgU01CMl9PUF9NS0RJUjoKKwkJaWYgKHJjKQorCQkJdHJhY2Vfc21iM19ta2Rpcl9l
cnIoeGlkLCAgc2VzLT5TdWlkLCB0Y29uLT50aWQsIHJjKTsKKwkJZWxzZQorCQkJdHJhY2Vfc21i
M19ta2Rpcl9kb25lKHhpZCwgc2VzLT5TdWlkLCB0Y29uLT50aWQpOwogCQlpZiAocnFzdFsxXS5y
cV9pb3YpCiAJCQlTTUIyX2Nsb3NlX2ZyZWUoJnJxc3RbMV0pOwogCQlicmVhazsKIAljYXNlIFNN
QjJfT1BfSEFSRExJTks6CisJCWlmIChyYykKKwkJCXRyYWNlX3NtYjNfaGFyZGxpbmtfZXJyKHhp
ZCwgIHNlcy0+U3VpZCwgdGNvbi0+dGlkLCByYyk7CisJCWVsc2UKKwkJCXRyYWNlX3NtYjNfaGFy
ZGxpbmtfZG9uZSh4aWQsIHNlcy0+U3VpZCwgdGNvbi0+dGlkKTsKKwkJZnJlZV9zZXRfaW5mX2Nv
bXBvdW5kKHJxc3QpOworCQlicmVhazsKIAljYXNlIFNNQjJfT1BfUkVOQU1FOgorCQlpZiAocmMp
CisJCQl0cmFjZV9zbWIzX3JlbmFtZV9lcnIoeGlkLCAgc2VzLT5TdWlkLCB0Y29uLT50aWQsIHJj
KTsKKwkJZWxzZQorCQkJdHJhY2Vfc21iM19yZW5hbWVfZG9uZSh4aWQsIHNlcy0+U3VpZCwgdGNv
bi0+dGlkKTsKKwkJZnJlZV9zZXRfaW5mX2NvbXBvdW5kKHJxc3QpOworCQlicmVhazsKIAljYXNl
IFNNQjJfT1BfUk1ESVI6CisJCWlmIChyYykKKwkJCXRyYWNlX3NtYjNfcm1kaXJfZXJyKHhpZCwg
IHNlcy0+U3VpZCwgdGNvbi0+dGlkLCByYyk7CisJCWVsc2UKKwkJCXRyYWNlX3NtYjNfcm1kaXJf
ZG9uZSh4aWQsIHNlcy0+U3VpZCwgdGNvbi0+dGlkKTsKKwkJZnJlZV9zZXRfaW5mX2NvbXBvdW5k
KHJxc3QpOworCQlicmVhazsKIAljYXNlIFNNQjJfT1BfU0VUX0VPRjoKKwkJaWYgKHJjKQorCQkJ
dHJhY2Vfc21iM19zZXRfZW9mX2Vycih4aWQsICBzZXMtPlN1aWQsIHRjb24tPnRpZCwgcmMpOwor
CQllbHNlCisJCQl0cmFjZV9zbWIzX3NldF9lb2ZfZG9uZSh4aWQsIHNlcy0+U3VpZCwgdGNvbi0+
dGlkKTsKKwkJZnJlZV9zZXRfaW5mX2NvbXBvdW5kKHJxc3QpOworCQlicmVhazsKIAljYXNlIFNN
QjJfT1BfU0VUX0lORk86Ci0JCWlmIChycXN0WzFdLnJxX2lvdikKLQkJCVNNQjJfc2V0X2luZm9f
ZnJlZSgmcnFzdFsxXSk7Ci0JCWlmIChycXN0WzJdLnJxX2lvdikKLQkJCVNNQjJfY2xvc2VfZnJl
ZSgmcnFzdFsyXSk7CisJCWlmIChyYykKKwkJCXRyYWNlX3NtYjNfc2V0X2luZm9fY29tcG91bmRf
ZXJyKHhpZCwgIHNlcy0+U3VpZCwKKwkJCQkJCXRjb24tPnRpZCwgcmMpOworCQllbHNlCisJCQl0
cmFjZV9zbWIzX3NldF9pbmZvX2NvbXBvdW5kX2RvbmUoeGlkLCBzZXMtPlN1aWQsCisJCQkJCQl0
Y29uLT50aWQpOworCQlmcmVlX3NldF9pbmZfY29tcG91bmQocnFzdCk7CiAJCWJyZWFrOwogCX0K
IAlmcmVlX3JzcF9idWYocmVzcF9idWZ0eXBlWzBdLCByc3BfaW92WzBdLmlvdl9iYXNlKTsKZGlm
ZiAtLWdpdCBhL2ZzL2NpZnMvdHJhY2UuaCBiL2ZzL2NpZnMvdHJhY2UuaAppbmRleCBjNzhlOTZj
NGNjNTMuLjMwYmY1MWM3ZThmZSAxMDA2NDQKLS0tIGEvZnMvY2lmcy90cmFjZS5oCisrKyBiL2Zz
L2NpZnMvdHJhY2UuaApAQCAtMjQyLDYgKzI0MiwxMjMgQEAgREVGSU5FX1NNQjNfSU5GX0VSUl9F
VkVOVChxdWVyeV9pbmZvX2Vycik7CiBERUZJTkVfU01CM19JTkZfRVJSX0VWRU5UKHNldF9pbmZv
X2Vycik7CiBERUZJTkVfU01CM19JTkZfRVJSX0VWRU5UKGZzY3RsX2Vycik7CiAKK0RFQ0xBUkVf
RVZFTlRfQ0xBU1Moc21iM19pbmZfY29tcG91bmRfZW50ZXJfY2xhc3MsCisJVFBfUFJPVE8odW5z
aWduZWQgaW50IHhpZCwKKwkJX191MzIJdGlkLAorCQlfX3U2NAlzZXNpZCwKKwkJY29uc3QgY2hh
ciAqZnVsbF9wYXRoKSwKKwlUUF9BUkdTKHhpZCwgdGlkLCBzZXNpZCwgZnVsbF9wYXRoKSwKKwlU
UF9TVFJVQ1RfX2VudHJ5KAorCQlfX2ZpZWxkKHVuc2lnbmVkIGludCwgeGlkKQorCQlfX2ZpZWxk
KF9fdTMyLCB0aWQpCisJCV9fZmllbGQoX191NjQsIHNlc2lkKQorCQlfX3N0cmluZyhwYXRoLCBm
dWxsX3BhdGgpCisJKSwKKwlUUF9mYXN0X2Fzc2lnbigKKwkJX19lbnRyeS0+eGlkID0geGlkOwor
CQlfX2VudHJ5LT50aWQgPSB0aWQ7CisJCV9fZW50cnktPnNlc2lkID0gc2VzaWQ7CisJCV9fYXNz
aWduX3N0cihwYXRoLCBmdWxsX3BhdGgpOworCSksCisJVFBfcHJpbnRrKCJ4aWQ9JXUgc2lkPTB4
JWxseCB0aWQ9MHgleCBwYXRoPSVzIiwKKwkJX19lbnRyeS0+eGlkLCBfX2VudHJ5LT5zZXNpZCwg
X19lbnRyeS0+dGlkLAorCQlfX2dldF9zdHIocGF0aCkpCispCisKKyNkZWZpbmUgREVGSU5FX1NN
QjNfSU5GX0NPTVBPVU5EX0VOVEVSX0VWRU5UKG5hbWUpICAgICBcCitERUZJTkVfRVZFTlQoc21i
M19pbmZfY29tcG91bmRfZW50ZXJfY2xhc3MsIHNtYjNfIyNuYW1lLCAgICBcCisJVFBfUFJPVE8o
dW5zaWduZWQgaW50IHhpZCwJCVwKKwkJX191MzIJdGlkLAkJCVwKKwkJX191NjQJc2VzaWQsCQkJ
XAorCQljb25zdCBjaGFyICpmdWxsX3BhdGgpLAkJXAorCVRQX0FSR1MoeGlkLCB0aWQsIHNlc2lk
LCBmdWxsX3BhdGgpKQorCitERUZJTkVfU01CM19JTkZfQ09NUE9VTkRfRU5URVJfRVZFTlQocXVl
cnlfaW5mb19jb21wb3VuZF9lbnRlcik7CitERUZJTkVfU01CM19JTkZfQ09NUE9VTkRfRU5URVJf
RVZFTlQoaGFyZGxpbmtfZW50ZXIpOworREVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VOVEVSX0VW
RU5UKHJlbmFtZV9lbnRlcik7CitERUZJTkVfU01CM19JTkZfQ09NUE9VTkRfRU5URVJfRVZFTlQo
cm1kaXJfZW50ZXIpOworREVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VOVEVSX0VWRU5UKHNldF9l
b2ZfZW50ZXIpOworREVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VOVEVSX0VWRU5UKHNldF9pbmZv
X2NvbXBvdW5kX2VudGVyKTsKK0RFRklORV9TTUIzX0lORl9DT01QT1VORF9FTlRFUl9FVkVOVChk
ZWxldGVfZW50ZXIpOworREVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VOVEVSX0VWRU5UKG1rZGly
X2VudGVyKTsKKworCitERUNMQVJFX0VWRU5UX0NMQVNTKHNtYjNfaW5mX2NvbXBvdW5kX2RvbmVf
Y2xhc3MsCisJVFBfUFJPVE8odW5zaWduZWQgaW50IHhpZCwKKwkJX191MzIJdGlkLAorCQlfX3U2
NAlzZXNpZCksCisJVFBfQVJHUyh4aWQsIHRpZCwgc2VzaWQpLAorCVRQX1NUUlVDVF9fZW50cnko
CisJCV9fZmllbGQodW5zaWduZWQgaW50LCB4aWQpCisJCV9fZmllbGQoX191MzIsIHRpZCkKKwkJ
X19maWVsZChfX3U2NCwgc2VzaWQpCisJKSwKKwlUUF9mYXN0X2Fzc2lnbigKKwkJX19lbnRyeS0+
eGlkID0geGlkOworCQlfX2VudHJ5LT50aWQgPSB0aWQ7CisJCV9fZW50cnktPnNlc2lkID0gc2Vz
aWQ7CisJKSwKKwlUUF9wcmludGsoInhpZD0ldSBzaWQ9MHglbGx4IHRpZD0weCV4IiwKKwkJX19l
bnRyeS0+eGlkLCBfX2VudHJ5LT5zZXNpZCwgX19lbnRyeS0+dGlkKQorKQorCisjZGVmaW5lIERF
RklORV9TTUIzX0lORl9DT01QT1VORF9ET05FX0VWRU5UKG5hbWUpICAgICBcCitERUZJTkVfRVZF
TlQoc21iM19pbmZfY29tcG91bmRfZG9uZV9jbGFzcywgc21iM18jI25hbWUsICAgIFwKKwlUUF9Q
Uk9UTyh1bnNpZ25lZCBpbnQgeGlkLAkJXAorCQlfX3UzMgl0aWQsCQkJXAorCQlfX3U2NAlzZXNp
ZCksCQkJXAorCVRQX0FSR1MoeGlkLCB0aWQsIHNlc2lkKSkKKworREVGSU5FX1NNQjNfSU5GX0NP
TVBPVU5EX0RPTkVfRVZFTlQocXVlcnlfaW5mb19jb21wb3VuZF9kb25lKTsKK0RFRklORV9TTUIz
X0lORl9DT01QT1VORF9ET05FX0VWRU5UKGhhcmRsaW5rX2RvbmUpOworREVGSU5FX1NNQjNfSU5G
X0NPTVBPVU5EX0RPTkVfRVZFTlQocmVuYW1lX2RvbmUpOworREVGSU5FX1NNQjNfSU5GX0NPTVBP
VU5EX0RPTkVfRVZFTlQocm1kaXJfZG9uZSk7CitERUZJTkVfU01CM19JTkZfQ09NUE9VTkRfRE9O
RV9FVkVOVChzZXRfZW9mX2RvbmUpOworREVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0RPTkVfRVZF
TlQoc2V0X2luZm9fY29tcG91bmRfZG9uZSk7CitERUZJTkVfU01CM19JTkZfQ09NUE9VTkRfRE9O
RV9FVkVOVChkZWxldGVfZG9uZSk7CitERUZJTkVfU01CM19JTkZfQ09NUE9VTkRfRE9ORV9FVkVO
VChta2Rpcl9kb25lKTsKKworCitERUNMQVJFX0VWRU5UX0NMQVNTKHNtYjNfaW5mX2NvbXBvdW5k
X2Vycl9jbGFzcywKKwlUUF9QUk9UTyh1bnNpZ25lZCBpbnQgeGlkLAorCQlfX3UzMgl0aWQsCisJ
CV9fdTY0CXNlc2lkLAorCQlpbnQJcmMpLAorCVRQX0FSR1MoeGlkLCB0aWQsIHNlc2lkLCByYyks
CisJVFBfU1RSVUNUX19lbnRyeSgKKwkJX19maWVsZCh1bnNpZ25lZCBpbnQsIHhpZCkKKwkJX19m
aWVsZChfX3UzMiwgdGlkKQorCQlfX2ZpZWxkKF9fdTY0LCBzZXNpZCkKKwkJX19maWVsZChpbnQs
IHJjKQorCSksCisJVFBfZmFzdF9hc3NpZ24oCisJCV9fZW50cnktPnhpZCA9IHhpZDsKKwkJX19l
bnRyeS0+dGlkID0gdGlkOworCQlfX2VudHJ5LT5zZXNpZCA9IHNlc2lkOworCQlfX2VudHJ5LT5y
YyA9IHJjOworCSksCisJVFBfcHJpbnRrKCJ4aWQ9JXUgc2lkPTB4JWxseCB0aWQ9MHgleCByYz0l
ZCIsCisJCV9fZW50cnktPnhpZCwgX19lbnRyeS0+c2VzaWQsIF9fZW50cnktPnRpZCwKKwkJX19l
bnRyeS0+cmMpCispCisKKyNkZWZpbmUgREVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VSUl9FVkVO
VChuYW1lKSAgICAgXAorREVGSU5FX0VWRU5UKHNtYjNfaW5mX2NvbXBvdW5kX2Vycl9jbGFzcywg
c21iM18jI25hbWUsICAgIFwKKwlUUF9QUk9UTyh1bnNpZ25lZCBpbnQgeGlkLAkJXAorCQlfX3Uz
Mgl0aWQsCQkJXAorCQlfX3U2NAlzZXNpZCwJCQlcCisJCWludCByYyksCQkJXAorCVRQX0FSR1Mo
eGlkLCB0aWQsIHNlc2lkLCByYykpCisKK0RFRklORV9TTUIzX0lORl9DT01QT1VORF9FUlJfRVZF
TlQocXVlcnlfaW5mb19jb21wb3VuZF9lcnIpOworREVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VS
Ul9FVkVOVChoYXJkbGlua19lcnIpOworREVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VSUl9FVkVO
VChyZW5hbWVfZXJyKTsKK0RFRklORV9TTUIzX0lORl9DT01QT1VORF9FUlJfRVZFTlQocm1kaXJf
ZXJyKTsKK0RFRklORV9TTUIzX0lORl9DT01QT1VORF9FUlJfRVZFTlQoc2V0X2VvZl9lcnIpOwor
REVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VSUl9FVkVOVChzZXRfaW5mb19jb21wb3VuZF9lcnIp
OworREVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VSUl9FVkVOVChta2Rpcl9lcnIpOworREVGSU5F
X1NNQjNfSU5GX0NPTVBPVU5EX0VSUl9FVkVOVChkZWxldGVfZXJyKTsKKwogLyoKICAqIEZvciBs
b2dnaW5nIFNNQjMgU3RhdHVzIGNvZGUgYW5kIENvbW1hbmQgZm9yIHJlc3BvbnNlcyB3aGljaCBy
ZXR1cm4gZXJyb3JzCiAgKi8KLS0gCjIuMTcuMQoK
--0000000000003bd7110583f2b981--
