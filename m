Return-Path: <SRS0=LBnX=RC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7188EC43381
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 03:28:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 255CA20830
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 03:28:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SI1r2Qkw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbfB0D2t (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Feb 2019 22:28:49 -0500
Received: from mail-pl1-f177.google.com ([209.85.214.177]:34722 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729128AbfB0D2t (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 26 Feb 2019 22:28:49 -0500
Received: by mail-pl1-f177.google.com with SMTP id d15so7285183plr.1
        for <linux-cifs@vger.kernel.org>; Tue, 26 Feb 2019 19:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=9x+V0Y+MBnP+xr+Z3KAURtrZoia9c/dZnrGbX/yYHEk=;
        b=SI1r2QkwfS65+fSpNV6B3AhTDM6ww9oqm18EGCnCAhzjy6wJ8jTW85HR5oxKg88KSZ
         gYtoym06M1WgziPIDEHiOklSCaD3rLpe5598Jlhp21ykv5K46x+NOqsGbRSJ2Vl2MATL
         yaNCDLlgtyINPOsZu1QVSwGjWNkDgc73rBfJyOkC/cmHYF56Nu3dEEvElsk8EaR9YMpY
         vSqPDbb3WfVbRxfBN2qr6nJaiFUCov1tbWkR1ti5br4/t1JfC2u66LCg9XwywX8DagmW
         yMjVO6bMb8kLCK0TlJ5TisWj4mcJ9S2eJhE37aNOOrnpHyWYhOOPYnjFGsLXOyGK6Cwd
         p6Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=9x+V0Y+MBnP+xr+Z3KAURtrZoia9c/dZnrGbX/yYHEk=;
        b=piDn0nhSKOxogOpnKH2gRk+zRfnmalBdXzsSWkKIDgEBEiJueuEzZDbnKdMG8erpIf
         ShLyZ+Jd4Y6t/oFk7S7qwYozDzN0EuBBPOSjpaGZkoEQoGJsZoXX3Et8XCe0+HIVEkgu
         RMhnHDKm0UEqDxNg4c5IlEqC/VO7mqxS9f2yo8AOBVUqP8x2waxRRO7UKx4xbjNNLl5E
         vaQUjSSXT95xlmNvro79uEuwmqqD4Os5thNnfSQDAgSbbR/qG8ft16DKiHFPwYBPYHkS
         MC4kGk9rlvdnbDSrqe3njI0y76pUOX/acvei4GU/hZ9es0qhfiqVXdjs68jKM79ypWTv
         NA1g==
X-Gm-Message-State: AHQUAuYf9qp+Q1tZHdeWShqCww866Z5Lvn0VNB+KIn8XKNK46INvY9he
        BCwRD94k3SSQLzdDAMrOkTAhCa4Ur+4RYKB1Fu/ybNYz
X-Google-Smtp-Source: AHgI3IbZcQc85q9gdHgj+0bYCUN6Mzy6ke3XN28aIt7TigEl3V6AEt1qLBTGtzKTicX8e4NPi6AzNdG1Pvzqk2BLA8A=
X-Received: by 2002:a17:902:e090:: with SMTP id cb16mr28823040plb.32.1551238127172;
 Tue, 26 Feb 2019 19:28:47 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 26 Feb 2019 21:28:35 -0600
Message-ID: <CAH2r5mt_bKGxNVCchmwCo-J7T_WqZRW+HXsn=V7c57_s6cBgxA@mail.gmail.com>
Subject: [PATCH] Add a dynamic tracepoint for smb3_cmd_enter
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000885cb20582d7c5e5"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000885cb20582d7c5e5
Content-Type: text/plain; charset="UTF-8"

Allow tracing before sending a command (add an smb3_cmd_enter)
on the wire - this allows us to look in much more detail at response
times (between request and response).

See below sample output from doing

    trace-cmd record -e smb3*cmd*

in one window and then "trace-cmd show" in another

#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
           mkdir-22002 [001] .... 25557.965367: smb3_cmd_enter:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=5 mid=28
           mkdir-22002 [001] .... 25557.965370: smb3_cmd_enter:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=16 mid=29
           mkdir-22002 [001] .... 25557.965371: smb3_cmd_enter:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=6 mid=30
           mkdir-22002 [002] .... 25557.972623: smb3_cmd_done:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=5 mid=28
           mkdir-22002 [002] .... 25557.972625: smb3_cmd_done:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=16 mid=29
           mkdir-22002 [002] .... 25557.972626: smb3_cmd_done:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=6 mid=30
              rm-22003 [001] .... 25563.125131: smb3_cmd_enter:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=5 mid=31
              rm-22003 [001] .... 25563.125134: smb3_cmd_enter:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=16 mid=32
              rm-22003 [001] .... 25563.125135: smb3_cmd_enter:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=6 mid=33
              rm-22003 [001] .... 25563.134590: smb3_cmd_err:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=5 mid=31 status=0xc0000034 rc=-2
              rm-22003 [001] .... 25563.134643: smb3_cmd_enter:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=5 mid=34
              rm-22003 [001] .... 25563.134645: smb3_cmd_enter:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=16 mid=35
              rm-22003 [001] .... 25563.134646: smb3_cmd_enter:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=6 mid=36
              rm-22003 [001] .... 25563.138544: smb3_cmd_err:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=5 mid=34 status=0xc0000034 rc=-2
              dd-22004 [005] .... 25567.863084: smb3_cmd_enter:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=5 mid=37
              dd-22004 [005] .... 25567.869415: smb3_cmd_done:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=5 mid=37
              dd-22004 [005] .... 25567.869424: smb3_cmd_enter:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=16 mid=38
              dd-22004 [005] .... 25567.870319: smb3_cmd_done:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=16 mid=38
              dd-22004 [005] .... 25567.870369: smb3_cmd_enter:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=17 mid=39
              dd-22004 [005] .... 25567.871073: smb3_cmd_done:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=17 mid=39
              dd-22004 [005] .... 25567.871094: smb3_cmd_enter:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=5 mid=40
              dd-22004 [005] .... 25567.871095: smb3_cmd_enter:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=17 mid=41
              dd-22004 [005] .... 25567.871096: smb3_cmd_enter:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=6 mid=42
              dd-22004 [006] .... 25567.882760: smb3_cmd_done:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=5 mid=40
              dd-22004 [006] .... 25567.882763: smb3_cmd_done:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=17 mid=41
              dd-22004 [006] .... 25567.882764: smb3_cmd_done:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=6 mid=42
              dd-22004 [006] .... 25567.882876: smb3_cmd_enter:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=9 mid=43
           cifsd-21979 [007] .... 25567.884150: smb3_cmd_done:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=9 mid=43
              dd-22004 [006] .... 25567.884278: smb3_cmd_enter:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=9 mid=44
           cifsd-21979 [007] .... 25567.885189: smb3_cmd_done:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=9 mid=44
              dd-22004 [006] .... 25567.885299: smb3_cmd_enter:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=9 mid=45
           cifsd-21979 [007] .... 25567.886174: smb3_cmd_done:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=9 mid=45
              dd-22004 [006] .... 25567.886283: smb3_cmd_enter:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=9 mid=46
           cifsd-21979 [007] .... 25567.887145: smb3_cmd_done:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=9 mid=46
              dd-22004 [006] .... 25567.887269: smb3_cmd_enter:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=6 mid=47
              dd-22004 [006] .... 25567.889631: smb3_cmd_done:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=6 mid=47
              ls-22009 [005] .... 25613.476023: smb3_cmd_enter:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=16 mid=48
              ls-22009 [005] .... 25613.477997: smb3_cmd_done:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=16 mid=48
              ls-22009 [005] .... 25613.478067: smb3_cmd_enter:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=5 mid=49
              ls-22009 [006] .... 25613.485037: smb3_cmd_done:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=5 mid=49
              ls-22009 [006] .... 25613.485048: smb3_cmd_enter:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=14 mid=50
              ls-22009 [006] .... 25613.490983: smb3_cmd_done:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=14 mid=50
              ls-22009 [006] .... 25613.491151: smb3_cmd_enter:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=14 mid=51
              ls-22009 [006] .... 25613.491898: smb3_cmd_err:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=14 mid=51 status=0x80000006 rc=-61
              ls-22009 [006] .... 25613.491947: smb3_cmd_enter:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=6 mid=52
              ls-22009 [006] .... 25613.494271: smb3_cmd_done:
sid=0xf3f1eab7 tid=0xe3c55496 cmd=6 mid=52


-- 
Thanks,

Steve

--000000000000885cb20582d7c5e5
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-dynamic-trace-point-for-smb3_cmd_enter.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-dynamic-trace-point-for-smb3_cmd_enter.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jsmn4b1t0>
X-Attachment-Id: f_jsmn4b1t0

RnJvbSA1OWExNjRiMjU2NTZkMDA5ZDk0MjMyNWUxYWJhNDA3NGE5NzU5MmYzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjYgRmViIDIwMTkgMjE6MjY6MjAgLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhZGQgZHluYW1pYyB0cmFjZSBwb2ludCBmb3Igc21iM19jbWRfZW50ZXIKCkFkZCB0cmFj
ZXBvaW50IGJlZm9yZSBzZW5kaW5nIGFuIFNNQjMgY29tbWFuZCBvbiB0aGUgd2lyZSAoaWUgYWRk
CmFuIHNtYjNfY21kX2VudGVyIHRyYWNlcG9pbnQpLiBUaGlzIGFsbG93cyB1cyB0byBsb29rIGlu
IG11Y2gKbW9yZSBkZXRhaWwgYXQgcmVzcG9uc2UgdGltZXMgKGJldHdlZW4gcmVxdWVzdCBhbmQg
cmVzcG9uc2UpLgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3Nv
ZnQuY29tPgotLS0KIGZzL2NpZnMvc21iMnRyYW5zcG9ydC5jIHwgMyArKysKIGZzL2NpZnMvdHJh
Y2UuaCAgICAgICAgIHwgMSArCiAyIGZpbGVzIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKQoKZGlm
ZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnRyYW5zcG9ydC5jIGIvZnMvY2lmcy9zbWIydHJhbnNwb3J0
LmMKaW5kZXggNTYwOWMwYjhkNWZlLi45YjFjZmQzZWQ1MmQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMv
c21iMnRyYW5zcG9ydC5jCisrKyBiL2ZzL2NpZnMvc21iMnRyYW5zcG9ydC5jCkBAIC02MDAsNiAr
NjAwLDggQEAgc21iMl9taWRfZW50cnlfYWxsb2MoY29uc3Qgc3RydWN0IHNtYjJfc3luY19oZHIg
KnNoZHIsCiAKIAlhdG9taWNfaW5jKCZtaWRDb3VudCk7CiAJdGVtcC0+bWlkX3N0YXRlID0gTUlE
X1JFUVVFU1RfQUxMT0NBVEVEOworCXRyYWNlX3NtYjNfY21kX2VudGVyKHNoZHItPlRyZWVJZCwg
c2hkci0+U2Vzc2lvbklkLAorCQlsZTE2X3RvX2NwdShzaGRyLT5Db21tYW5kKSwgdGVtcC0+bWlk
KTsKIAlyZXR1cm4gdGVtcDsKIH0KIApAQCAtNjM0LDYgKzYzNiw3IEBAIHNtYjJfZ2V0X21pZF9l
bnRyeShzdHJ1Y3QgY2lmc19zZXMgKnNlcywgc3RydWN0IHNtYjJfc3luY19oZHIgKnNoZHIsCiAJ
c3Bpbl9sb2NrKCZHbG9iYWxNaWRfTG9jayk7CiAJbGlzdF9hZGRfdGFpbCgmKCptaWQpLT5xaGVh
ZCwgJnNlcy0+c2VydmVyLT5wZW5kaW5nX21pZF9xKTsKIAlzcGluX3VubG9jaygmR2xvYmFsTWlk
X0xvY2spOworCiAJcmV0dXJuIDA7CiB9CiAKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvdHJhY2UuaCBi
L2ZzL2NpZnMvdHJhY2UuaAppbmRleCBiNjM1MmI2OGYxOGIuLjJhMGJlM2UxOTI3ZiAxMDA2NDQK
LS0tIGEvZnMvY2lmcy90cmFjZS5oCisrKyBiL2ZzL2NpZnMvdHJhY2UuaApAQCAtMjc1LDYgKzI3
NSw3IEBAIERFRklORV9FVkVOVChzbWIzX2NtZF9kb25lX2NsYXNzLCBzbWIzXyMjbmFtZSwgICAg
XAogCQlfX3U2NAltaWQpLAkJCVwKIAlUUF9BUkdTKHRpZCwgc2VzaWQsIGNtZCwgbWlkKSkKIAor
REVGSU5FX1NNQjNfQ01EX0RPTkVfRVZFTlQoY21kX2VudGVyKTsKIERFRklORV9TTUIzX0NNRF9E
T05FX0VWRU5UKGNtZF9kb25lKTsKIERFRklORV9TTUIzX0NNRF9ET05FX0VWRU5UKHNlc19leHBp
cmVkKTsKIAotLSAKMi4xNy4xCgo=
--000000000000885cb20582d7c5e5--
