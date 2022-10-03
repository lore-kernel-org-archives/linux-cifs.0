Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD1C1C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Oct 2022 22:32:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiJCWcp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Oct 2022 18:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiJCWco (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Oct 2022 18:32:44 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7A3558E6
        for <linux-cifs@vger.kernel.org>; Mon,  3 Oct 2022 15:32:43 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id h64so7776325vsc.3
        for <linux-cifs@vger.kernel.org>; Mon, 03 Oct 2022 15:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=PAD6z10S+uhF3Q1isULC78ZSymOnn/HEPAa3oLH8X6s=;
        b=cvhzZaEqY2NB5LL9re53pZpeLuMjR4uUGz0isbcJp1rh/CxtGskEh0QiJiMvAxZTov
         zvzPE85ryAN4j1YFtGYvzdFBBOHfr+DpS8MQQOV/jlczpVDrfPnxDYUm7nITBDmsZVxm
         OPQ+ih5saTpt6oYz8/BTw8n701L14Hl+vbg+PMgyda0jTeuP39YaoyGGwJaObAZW8eop
         DA+O1W6qmSWQo0krE4uq8W843CHZwGRW1ij88jJ1vand+96dYaW81QE9mmwnHVSLo48U
         wzUvaW4GxSCDfssMhjiYwnnzMaQykFe5DZniJmwJwFD3O3ImdXVk/JlYVB+2vvgybb9p
         ZSEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=PAD6z10S+uhF3Q1isULC78ZSymOnn/HEPAa3oLH8X6s=;
        b=IAQriFXo8EpV/CdmEoL79e5kRPezQQTDvk2ETdQU+ohoktIMgLC75F5hjqoy/gFFAT
         hf+EpZfMbUw7+f5BZB9Yq0Ko/oVI9oaKeUEcSkn5tPRFF2KUmcwsWBROvIcUIXtXxA2H
         kck5UGuNFwHG8EOpr4yGjxLmiq44WgW65fqQtt51hBZUlcgqknmMtDNH2j+Kt5K7qXf/
         VU/LMBSK5f4J7sh0x5I10jP1k0ENf6KDQ3riSfKLX3dtvHFB+GSgruMRmKby1+G+ZBdW
         WPQ9pKxBfaYGHAvtYWn2iRYZCs9yRINI2nqPDT7zUeANw5djMTQf1bww/l0Wpv4aDDTf
         6BGA==
X-Gm-Message-State: ACrzQf3mtU6dJ1ZKturO1z225Z2bquw6LrSyQ63nN7Av4ZK6kDhaVFaf
        F+WGRgb7XHXhOd/4JQxc/ZCLQH7kJBVNjXZtWKn89+42
X-Google-Smtp-Source: AMsMyM48tWMS5+rl/mINg2zXZRXKnyMmV1slGwd6zQd93hTZzdFPcnraruNsNToRp3CCCcbCrFMu8m4HIVek871DWKo=
X-Received: by 2002:a05:6102:215a:b0:39a:c2c6:cc5d with SMTP id
 h26-20020a056102215a00b0039ac2c6cc5dmr9133575vsg.61.1664836362717; Mon, 03
 Oct 2022 15:32:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvS6_AXjbK8sY_dEWUbmtRjodSYEtxeNz_NST9+EyC96A@mail.gmail.com>
 <df473fde-e79d-ae90-37bb-3a3869d3aa9a@talpey.com> <CAH2r5msDX4eaGuyine__ePtOTRoSBDjiUN_dthaHpiA9UKm0yg@mail.gmail.com>
 <d7bf66c8-0695-a239-4bfb-d234241479ac@talpey.com>
In-Reply-To: <d7bf66c8-0695-a239-4bfb-d234241479ac@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 3 Oct 2022 17:32:30 -0500
Message-ID: <CAH2r5mtyshZWxN9nycxyu-_mDsJBkmFP_JMJZCm5RL_FP+3bmA@mail.gmail.com>
Subject: Re: [PATCH][smb3 client] log less confusing message on multichannel
 mounts to Samba when no interfaces returned
To:     Tom Talpey <tom@talpey.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="0000000000000272af05ea28ec3b"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000000272af05ea28ec3b
Content-Type: text/plain; charset="UTF-8"

updated patch to:
1) log the server name for this message
2) only log on mount (not every ten minutes)

See attached

On Mon, Oct 3, 2022 at 9:21 AM Tom Talpey <tom@talpey.com> wrote:
>
> On 10/3/2022 12:38 AM, Steve French wrote:
> > On Sat, Oct 1, 2022 at 6:22 PM Tom Talpey <tom@talpey.com> wrote:
> >>
> >> On 10/1/2022 12:54 PM, Steve French wrote:
> >>> Some servers can return an empty network interface list so, unless
> >>> multichannel is requested, no need to log an error for this, and
> >>> when multichannel is requested on mount but no interfaces, log
> >>> something less confusing.  For this case change
> >>>      parse_server_interfaces: malformed interface info
> >>> to
> >>>      empty network interface list returned by server
> >>
> >> Will this spam the log if it happens on every MC refresh (10 mins)?
> >> It might be helpful to identify the servername, too.
> >
> > Yes - I just noticed that in this case (multichannel mount to Samba
> > where no valid interfaces) we log it every ten minutes.
> > Maybe best way to fix this is to change it to a log once error (with
> > server name is fine with me) since it is probably legal to return an
> > empty list (so not serious enough to be worth logging every ten
> > minutes) and in theory server could fix its interfaces later.
>
> Ten minutes is the default recommended polling interval in the doc.
>
> While it's odd, it's not prevented by the protocol. I could guess
> that a server running in a namespace might return strange things
> as devices came and went, for example.
>
> It's not an error, so the message is purely informational. It is
> useful though. Is it possible to suppress the logging if the
> message *doesn't* change, but otherwise emit new ones? That might
> require some per-server fiddling to avoid multiple servers flipping
> the message.
>
> A boolean or bit in the server struct? A little ugly for the purpose,
> but surfacing multichannel events - especially ones that prevent it
> from happening - seems worthwhile.
>
> Tom.
>
>
> Tom.
>
>
> >>> Cc: <stable@vger.kernel.org>
> >>> Signed-off-by: Steve French <stfrench@microsoft.com>
> >>>
> >>> See attached patch
> >>>
> >
> >
> >



-- 
Thanks,

Steve

--0000000000000272af05ea28ec3b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-do-not-log-confusing-message-when-server-return.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-do-not-log-confusing-message-when-server-return.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l8tckpry0>
X-Attachment-Id: f_l8tckpry0

RnJvbSA5NTI2NzJmNTdmM2Q5NGE2MzFjYTg5MGU5NmJmNzA3NDBjMzY3NThiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMyBPY3QgMjAyMiAxNzoyNTo0MSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGRvIG5vdCBsb2cgY29uZnVzaW5nIG1lc3NhZ2Ugd2hlbiBzZXJ2ZXIgcmV0dXJucyBubyAK
IG5ldHdvcmsgaW50ZXJmYWNlcwoKU29tZSBzZXJ2ZXJzIGNhbiByZXR1cm4gYW4gZW1wdHkgbmV0
d29yayBpbnRlcmZhY2UgbGlzdCBzbywgdW5sZXNzCm11bHRpY2hhbm5lbCBpcyByZXF1ZXN0ZWQs
IG5vIG5lZWQgdG8gbG9nIGFuIGVycm9yIGZvciB0aGlzLCBhbmQKd2hlbiBtdWx0aWNoYW5uZWwg
aXMgcmVxdWVzdGVkIG9uIG1vdW50IGJ1dCBubyBpbnRlcmZhY2VzLCBsb2cKc29tZXRoaW5nIGxl
c3MgY29uZnVzaW5nLiAgRm9yIHRoaXMgY2FzZSBjaGFuZ2UKICAgcGFyc2Vfc2VydmVyX2ludGVy
ZmFjZXM6IG1hbGZvcm1lZCBpbnRlcmZhY2UgaW5mbwp0bwogICBlbXB0eSBuZXR3b3JrIGludGVy
ZmFjZSBsaXN0IHJldHVybmVkIGJ5IHNlcnZlciBsb2NhbGhvc3QKCkFsc28gZG8gbm90IHJlbG9n
IHRoaXMgZXJyb3IgZXZlcnkgdGVuIG1pbnV0ZXMgKG9ubHkgbG9nIG9uIG1vdW50LCBvbmNlKQoK
Q2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2gg
PHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jaWZzcHJvdG8uaCB8ICAyICst
CiBmcy9jaWZzL2Nvbm5lY3QuYyAgIHwgIDIgKy0KIGZzL2NpZnMvc21iMm9wcy5jICAgfCAxNiAr
KysrKysrKystLS0tLS0tCiAzIGZpbGVzIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDkgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzcHJvdG8uaCBiL2ZzL2NpZnMvY2lm
c3Byb3RvLmgKaW5kZXggZjVhZGNiOGVhMDRkLi44NGVjNzFiZGZhY2QgMTAwNjQ0Ci0tLSBhL2Zz
L2NpZnMvY2lmc3Byb3RvLmgKKysrIGIvZnMvY2lmcy9jaWZzcHJvdG8uaApAQCAtNjM4LDcgKzYz
OCw3IEBAIGNpZnNfY2hhbl9pc19pZmFjZV9hY3RpdmUoc3RydWN0IGNpZnNfc2VzICpzZXMsCiBp
bnQKIGNpZnNfY2hhbl91cGRhdGVfaWZhY2Uoc3RydWN0IGNpZnNfc2VzICpzZXMsIHN0cnVjdCBU
Q1BfU2VydmVyX0luZm8gKnNlcnZlcik7CiBpbnQKLVNNQjNfcmVxdWVzdF9pbnRlcmZhY2VzKGNv
bnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24pOworU01CM19yZXF1
ZXN0X2ludGVyZmFjZXMoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAq
dGNvbiwgYm9vbCBpbl9tb3VudCk7CiAKIHZvaWQgZXh0cmFjdF91bmNfaG9zdG5hbWUoY29uc3Qg
Y2hhciAqdW5jLCBjb25zdCBjaGFyICoqaCwgc2l6ZV90ICpsZW4pOwogaW50IGNvcHlfcGF0aF9u
YW1lKGNoYXIgKmRzdCwgY29uc3QgY2hhciAqc3JjKTsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29u
bmVjdC5jIGIvZnMvY2lmcy9jb25uZWN0LmMKaW5kZXggYWQ4MWQ3ZDQzZWFmLi45M2U1OWIzYjM2
YzcgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5jCisrKyBiL2ZzL2NpZnMvY29ubmVjdC5j
CkBAIC0xNTUsNyArMTU1LDcgQEAgc3RhdGljIHZvaWQgc21iMl9xdWVyeV9zZXJ2ZXJfaW50ZXJm
YWNlcyhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJLyoKIAkgKiBxdWVyeSBzZXJ2ZXIgbmV0
d29yayBpbnRlcmZhY2VzLCBpbiBjYXNlIHRoZXkgY2hhbmdlCiAJICovCi0JcmMgPSBTTUIzX3Jl
cXVlc3RfaW50ZXJmYWNlcygwLCB0Y29uKTsKKwlyYyA9IFNNQjNfcmVxdWVzdF9pbnRlcmZhY2Vz
KDAsIHRjb24sIGZhbHNlKTsKIAlpZiAocmMpIHsKIAkJY2lmc19kYmcoRllJLCAiJXM6IGZhaWxl
ZCB0byBxdWVyeSBzZXJ2ZXIgaW50ZXJmYWNlczogJWRcbiIsCiAJCQkJX19mdW5jX18sIHJjKTsK
ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMm9wcy5jIGIvZnMvY2lmcy9zbWIyb3BzLmMKaW5kZXgg
ZWY4OGY5NTMwMmY2Li5iMGQ5MzE4ODYzMWUgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMm9wcy5j
CisrKyBiL2ZzL2NpZnMvc21iMm9wcy5jCkBAIC01MTIsOCArNTEyLDcgQEAgc21iM19uZWdvdGlh
dGVfcnNpemUoc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwgc3RydWN0IHNtYjNfZnNfY29udGV4dCAq
Y3R4KQogCiBzdGF0aWMgaW50CiBwYXJzZV9zZXJ2ZXJfaW50ZXJmYWNlcyhzdHJ1Y3QgbmV0d29y
a19pbnRlcmZhY2VfaW5mb19pb2N0bF9yc3AgKmJ1ZiwKLQkJCXNpemVfdCBidWZfbGVuLAotCQkJ
c3RydWN0IGNpZnNfc2VzICpzZXMpCisJCQlzaXplX3QgYnVmX2xlbiwgc3RydWN0IGNpZnNfc2Vz
ICpzZXMsIGJvb2wgaW5fbW91bnQpCiB7CiAJc3RydWN0IG5ldHdvcmtfaW50ZXJmYWNlX2luZm9f
aW9jdGxfcnNwICpwOwogCXN0cnVjdCBzb2NrYWRkcl9pbiAqYWRkcjQ7CkBAIC01NDgsOCArNTQ3
LDExIEBAIHBhcnNlX3NlcnZlcl9pbnRlcmZhY2VzKHN0cnVjdCBuZXR3b3JrX2ludGVyZmFjZV9p
bmZvX2lvY3RsX3JzcCAqYnVmLAogCSAqIHdoaWNoIHdvdWxkIG9ubHkgYmUgYSBwcm9ibGVtIGlm
IHdlIHdlcmUgcmVxdWVzdGluZyBtdWx0aWNoYW5uZWwKIAkgKi8KIAlpZiAoYnl0ZXNfbGVmdCA9
PSAwKSB7Ci0JCWlmIChzZXMtPmNoYW5fbWF4ID4gMSkKLQkJCWNpZnNfZGJnKFZGUywgImVtcHR5
IG5ldHdvcmsgaW50ZXJmYWNlIGxpc3QgcmV0dXJuZWQgYnkgc2VydmVyXG4iKTsKKwkJLyogYXZv
aWQgc3BhbW1pbmcgbG9ncyBldmVyeSAxMCBtaW51dGVzLCBzbyBsb2cgb25seSBpbiBtb3VudCAq
LworCQlpZiAoKHNlcy0+Y2hhbl9tYXggPiAxKSAmJiBpbl9tb3VudCkKKwkJCWNpZnNfZGJnKFZG
UywKKwkJCQkgImVtcHR5IG5ldHdvcmsgaW50ZXJmYWNlIGxpc3QgcmV0dXJuZWQgYnkgc2VydmVy
ICVzXG4iLAorCQkJCSBzZXMtPnNlcnZlci0+aG9zdG5hbWUpOwogCQlyYyA9IC1FSU5WQUw7CiAJ
CWdvdG8gb3V0OwogCX0KQEAgLTY4NCw3ICs2ODYsNyBAQCBwYXJzZV9zZXJ2ZXJfaW50ZXJmYWNl
cyhzdHJ1Y3QgbmV0d29ya19pbnRlcmZhY2VfaW5mb19pb2N0bF9yc3AgKmJ1ZiwKIH0KIAogaW50
Ci1TTUIzX3JlcXVlc3RfaW50ZXJmYWNlcyhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3Qg
Y2lmc190Y29uICp0Y29uKQorU01CM19yZXF1ZXN0X2ludGVyZmFjZXMoY29uc3QgdW5zaWduZWQg
aW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwgYm9vbCBpbl9tb3VudCkKIHsKIAlpbnQg
cmM7CiAJdW5zaWduZWQgaW50IHJldF9kYXRhX2xlbiA9IDA7CkBAIC03MDQsNyArNzA2LDcgQEAg
U01CM19yZXF1ZXN0X2ludGVyZmFjZXMoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNp
ZnNfdGNvbiAqdGNvbikKIAkJZ290byBvdXQ7CiAJfQogCi0JcmMgPSBwYXJzZV9zZXJ2ZXJfaW50
ZXJmYWNlcyhvdXRfYnVmLCByZXRfZGF0YV9sZW4sIHNlcyk7CisJcmMgPSBwYXJzZV9zZXJ2ZXJf
aW50ZXJmYWNlcyhvdXRfYnVmLCByZXRfZGF0YV9sZW4sIHNlcywgaW5fbW91bnQpOwogCWlmIChy
YykKIAkJZ290byBvdXQ7CiAKQEAgLTc0MCw3ICs3NDIsNyBAQCBzbWIzX3Fmc190Y29uKGNvbnN0
IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJaWYgKHJjKQogCQly
ZXR1cm47CiAKLQlTTUIzX3JlcXVlc3RfaW50ZXJmYWNlcyh4aWQsIHRjb24pOworCVNNQjNfcmVx
dWVzdF9pbnRlcmZhY2VzKHhpZCwgdGNvbiwgdHJ1ZSAvKiBjYWxsZWQgZHVyaW5nICBtb3VudCAq
Lyk7CiAKIAlTTUIyX1FGU19hdHRyKHhpZCwgdGNvbiwgZmlkLnBlcnNpc3RlbnRfZmlkLCBmaWQu
dm9sYXRpbGVfZmlkLAogCQkJRlNfQVRUUklCVVRFX0lORk9STUFUSU9OKTsKLS0gCjIuMzQuMQoK
--0000000000000272af05ea28ec3b--
