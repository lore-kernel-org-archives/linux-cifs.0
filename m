Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F47DC433FE
	for <linux-cifs@archiver.kernel.org>; Wed, 12 Oct 2022 04:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiJLEc4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 12 Oct 2022 00:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJLEcz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 12 Oct 2022 00:32:55 -0400
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4944816A4
        for <linux-cifs@vger.kernel.org>; Tue, 11 Oct 2022 21:32:54 -0700 (PDT)
Received: by mail-vk1-xa35.google.com with SMTP id a66so5050139vkc.3
        for <linux-cifs@vger.kernel.org>; Tue, 11 Oct 2022 21:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Di8xCF6TO0Gd3i2FmdDYcyv6RFWtKtZLf8fTnEOU/Bk=;
        b=ju/EJA5Z8QcNY+fxSb7zY94rmJPwUzftKPnZzkiotY5cNUBsBKpHmVdjztm+nwhEJD
         TuPFxs//UYKkdmLGgAo9g/Cl16lJhiYKkUwmYQ5t0GPDAC6/S2rTTmtyFzENyEgZ+CEJ
         yBJzHVaxLPKvXBfeSXDDrC4NnvP+t6abbRFnujz9aoqdopvLV+Zqs+X9DKFquiQ8paSL
         /zBMcicDBKo4SuBMMAoaBhcSGYTOu9jYONUEpIkGVOp3W0ey5i9k4Civyi3BlLCm66xl
         RtV0NySchedEYXQYvTngGoqxP0HVFcJu0FNGnF6L7G4c9fqVaXFZtXGY0bn5bebI4xOt
         mDPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Di8xCF6TO0Gd3i2FmdDYcyv6RFWtKtZLf8fTnEOU/Bk=;
        b=7sQdpD7vCjdI2cd4k/P9mZR4V3kQd7Rb1YyP5F+98AYBL+XjpzD32AZ44boJkAf5WD
         8+ByGn5Ga7nIkJRmuhzl0WNMsvvrsBXLFU10SUGsCBeyQhiPFi+XI68zo6cnkvKYVmgG
         NtaG3w8ACCjGhni/sxsdeQ+PkinC5Uokp3h/5+ZF3EQH+LP1BeTeCDRWFuWzcCHU0oie
         g8tLA6aIly0iP0woPNTx+HJlCcGZyEe4bEQI2WOEiyDD2sMBXSdZiBbXptNI3idT8Ed5
         f2wUf6i/rNUf7bSVqjzUpronP7dQet43FFi0uaRdXH6vBCCoRlrQv/se62Cy5cxG7izL
         Pp2A==
X-Gm-Message-State: ACrzQf24vZ9CdXIsGyJUYUAAGxPL4BDm9wlQGStmwDmT88IRKPvaQc4R
        +dicW9jV4qoQBn6NAO5YoCQmjfngOWosSGs57gdr16ow
X-Google-Smtp-Source: AMsMyM7+faC63KBJnCY6qH9SBk/LOSzE76EXO6NwcTsW4zjhCOUZyJWpJbGV1yY9Mai00VwmYxw1Av92i0IyaL1zx9Q=
X-Received: by 2002:a1f:d583:0:b0:3aa:9112:570f with SMTP id
 m125-20020a1fd583000000b003aa9112570fmr12451017vkg.3.1665549173606; Tue, 11
 Oct 2022 21:32:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvS6_AXjbK8sY_dEWUbmtRjodSYEtxeNz_NST9+EyC96A@mail.gmail.com>
 <df473fde-e79d-ae90-37bb-3a3869d3aa9a@talpey.com> <CAH2r5msDX4eaGuyine__ePtOTRoSBDjiUN_dthaHpiA9UKm0yg@mail.gmail.com>
 <d7bf66c8-0695-a239-4bfb-d234241479ac@talpey.com> <CAH2r5mtyshZWxN9nycxyu-_mDsJBkmFP_JMJZCm5RL_FP+3bmA@mail.gmail.com>
 <CAH2r5muv++9HAyCMfxuez8DakR=1-kkGYpGNVF=TE86FvsUkBA@mail.gmail.com> <f2452332-c85b-ef7d-7f96-de097e0594b0@talpey.com>
In-Reply-To: <f2452332-c85b-ef7d-7f96-de097e0594b0@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 11 Oct 2022 23:32:42 -0500
Message-ID: <CAH2r5muOo4yq9aQpxO_UQhDe79brJ7O8fEW+73cEKPv-OOHDJQ@mail.gmail.com>
Subject: Re: [PATCH][smb3 client] log less confusing message on multichannel
 mounts to Samba when no interfaces returned
To:     Tom Talpey <tom@talpey.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000d9a75f05eacee28a"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000d9a75f05eacee28a
Content-Type: text/plain; charset="UTF-8"

message updated as suggested

    multichannel not available
    empty network interface returned by server localhost

See attached

On Tue, Oct 11, 2022 at 2:40 PM Tom Talpey <tom@talpey.com> wrote:
>
> In the patch:
>
> > +     /*
> > +      * Samba server e.g. can return an empty interface list in some cases,
> > +      * which would only be a problem if we were requesting multichannel
> > +      */
> > +     if (bytes_left == 0) {
> > +             /* avoid spamming logs every 10 minutes, so log only in mount */
> > +             if ((ses->chan_max > 1) && in_mount)
> > +                     cifs_dbg(VFS,
> > +                              "empty network interface list returned by server %s\n",
> > +                              ses->server->hostname);
> > +             rc = -EINVAL;
> > +             goto out;
> > +     }
>
>
>
> This logs the server name, but it might be confusing to the
> admin since the mount does not actually fail. Perhaps add some
> words to the effect of "multichannel not available"?
>
> Acked-by: Tom Talpey <tom@talpey.com>
>
> On 10/3/2022 6:36 PM, Steve French wrote:
> > attached wrong patch - resending
> >
> >
> > On Mon, Oct 3, 2022 at 5:32 PM Steve French <smfrench@gmail.com> wrote:
> >>
> >> updated patch to:
> >> 1) log the server name for this message
> >> 2) only log on mount (not every ten minutes)
> >>
> >> See attached
> >>
> >> On Mon, Oct 3, 2022 at 9:21 AM Tom Talpey <tom@talpey.com> wrote:
> >>>
> >>> On 10/3/2022 12:38 AM, Steve French wrote:
> >>>> On Sat, Oct 1, 2022 at 6:22 PM Tom Talpey <tom@talpey.com> wrote:
> >>>>>
> >>>>> On 10/1/2022 12:54 PM, Steve French wrote:
> >>>>>> Some servers can return an empty network interface list so, unless
> >>>>>> multichannel is requested, no need to log an error for this, and
> >>>>>> when multichannel is requested on mount but no interfaces, log
> >>>>>> something less confusing.  For this case change
> >>>>>>       parse_server_interfaces: malformed interface info
> >>>>>> to
> >>>>>>       empty network interface list returned by server
> >>>>>
> >>>>> Will this spam the log if it happens on every MC refresh (10 mins)?
> >>>>> It might be helpful to identify the servername, too.
> >>>>
> >>>> Yes - I just noticed that in this case (multichannel mount to Samba
> >>>> where no valid interfaces) we log it every ten minutes.
> >>>> Maybe best way to fix this is to change it to a log once error (with
> >>>> server name is fine with me) since it is probably legal to return an
> >>>> empty list (so not serious enough to be worth logging every ten
> >>>> minutes) and in theory server could fix its interfaces later.
> >>>
> >>> Ten minutes is the default recommended polling interval in the doc.
> >>>
> >>> While it's odd, it's not prevented by the protocol. I could guess
> >>> that a server running in a namespace might return strange things
> >>> as devices came and went, for example.
> >>>
> >>> It's not an error, so the message is purely informational. It is
> >>> useful though. Is it possible to suppress the logging if the
> >>> message *doesn't* change, but otherwise emit new ones? That might
> >>> require some per-server fiddling to avoid multiple servers flipping
> >>> the message.
> >>>
> >>> A boolean or bit in the server struct? A little ugly for the purpose,
> >>> but surfacing multichannel events - especially ones that prevent it
> >>> from happening - seems worthwhile.
> >>>
> >>> Tom.
> >>>
> >>>
> >>> Tom.
> >>>
> >>>
> >>>>>> Cc: <stable@vger.kernel.org>
> >>>>>> Signed-off-by: Steve French <stfrench@microsoft.com>
> >>>>>>
> >>>>>> See attached patch
> >>>>>>
> >>>>
> >>>>
> >>>>
> >>
> >>
> >>
> >> --
> >> Thanks,
> >>
> >> Steve
> >
> >
> >



-- 
Thanks,

Steve

--000000000000d9a75f05eacee28a
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-clarify-multichannel-warning.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-clarify-multichannel-warning.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l954yq3w0>
X-Attachment-Id: f_l954yq3w0

RnJvbSA2YzAzYTRkZDgwNzNjMjEzZDExM2MzOWM4MzlhYTMyOTVhMjA5YWY2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMTEgT2N0IDIwMjIgMjM6MjY6MzMgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBjbGFyaWZ5IG11bHRpY2hhbm5lbCB3YXJuaW5nCgpXaGVuIHNlcnZlciBkb2VzIG5vdCBy
ZXR1cm4gbmV0d29yayBpbnRlcmZhY2VzLCBjbGFyaWZ5IHRoZQptZXNzYWdlIHRvIGluZGljYXRl
IHRoYXQgIm11bHRpY2hhbm5lbCBub3QgYXZhaWxhYmxlIiBub3QganVzdAp0aGF0ICJlbXB0eSBu
ZXR3b3JrIGludGVyZmFjZSByZXR1cm5lZCBieSBzZXJ2ZXIgLi4uIgoKU3VnZ2VzdGVkLWJ5OiBU
b20gVGFscGV5IDx0b21AdGFscGV5LmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxz
dGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvc21iMm9wcy5jIHwgMyArKy0KIDEg
ZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQg
YS9mcy9jaWZzL3NtYjJvcHMuYyBiL2ZzL2NpZnMvc21iMm9wcy5jCmluZGV4IDUxODcyNTBjNWY2
Ni4uOWVkNGRhZWY2NzcwIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJvcHMuYworKysgYi9mcy9j
aWZzL3NtYjJvcHMuYwpAQCAtNTUwLDcgKzU1MCw4IEBAIHBhcnNlX3NlcnZlcl9pbnRlcmZhY2Vz
KHN0cnVjdCBuZXR3b3JrX2ludGVyZmFjZV9pbmZvX2lvY3RsX3JzcCAqYnVmLAogCQkvKiBhdm9p
ZCBzcGFtbWluZyBsb2dzIGV2ZXJ5IDEwIG1pbnV0ZXMsIHNvIGxvZyBvbmx5IGluIG1vdW50ICov
CiAJCWlmICgoc2VzLT5jaGFuX21heCA+IDEpICYmIGluX21vdW50KQogCQkJY2lmc19kYmcoVkZT
LAotCQkJCSAiZW1wdHkgbmV0d29yayBpbnRlcmZhY2UgbGlzdCByZXR1cm5lZCBieSBzZXJ2ZXIg
JXNcbiIsCisJCQkJICJtdWx0aWNoYW5uZWwgbm90IGF2YWlsYWJsZVxuIgorCQkJCSAiRW1wdHkg
bmV0d29yayBpbnRlcmZhY2UgbGlzdCByZXR1cm5lZCBieSBzZXJ2ZXIgJXNcbiIsCiAJCQkJIHNl
cy0+c2VydmVyLT5ob3N0bmFtZSk7CiAJCXJjID0gLUVJTlZBTDsKIAkJZ290byBvdXQ7Ci0tIAoy
LjM0LjEKCg==
--000000000000d9a75f05eacee28a--
