Return-Path: <SRS0=7CLT=4Q=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0451C3F2D0
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Feb 2020 07:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C31A2222C2
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Feb 2020 07:37:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XrUzCYst"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgB1Hhw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Feb 2020 02:37:52 -0500
Received: from mail-il1-f172.google.com ([209.85.166.172]:36399 "EHLO
        mail-il1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbgB1Hhw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Feb 2020 02:37:52 -0500
Received: by mail-il1-f172.google.com with SMTP id b15so1941992iln.3
        for <linux-cifs@vger.kernel.org>; Thu, 27 Feb 2020 23:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=vZQ4talGgQI8D4R1iExDotvUYjS2fG1VjucQIRpKGBY=;
        b=XrUzCYstOfYMGCG6ykazloS4kNlIrJLoawezZUlD6bo+Nao4N3RdzWiuWtIFK5Jn0B
         F2+8HbeQoOLZ8rEzCMu4cjFMpqGfdoGgfHM+oOGPWls8Yezar+gLIo2zjREeX/3eXxmS
         4kfmI0azn+g0emC3E/xEX8WlTv+ea41EnOr6JjtNsvy3qxW8XBLR0ipuPDmOT9nWCwh1
         0xNOem1jpvUg3og9Wf4M1uQEdNXN8MeOusPrhyFfrtL6rYBqxIeBDlJ1Nq6fm8xfeiP2
         2DBW2+f2vU5X9dPraDDfYY+rY9aCfPCl3xj7swvHLpw8MyXskXN8IfVaEh2M56vjJgFd
         mN2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=vZQ4talGgQI8D4R1iExDotvUYjS2fG1VjucQIRpKGBY=;
        b=PsQF1NtOwCLe/zyw6jKDxc1PhpErWRSWXbeyzFkj/UDcp3F4wMkL8VQjOnPa61OeEi
         VZRwHLBnDhdm2Ws7f5FFhpt0b16sfLlgTNnl0phKbFX4TFMQIMw902F8sDF5lFAqjCv0
         3hLRsVDmiVp9Aq7JX+nuwF9M7m2FiXyzyXagLkKkZYXJJOmusj1elF8N1wS5sc4NzCbv
         8A/I78/JpyGUsmrzoXTvl4Ctfpog8DpYKspEYNQcUIAA802vUipYWjwfnw4jTrzZ1H+M
         hTmqM4v5CjJitP9wdeMmNr9RDzA0zax+EUSVtH80lkooO5TWSJOu+H9fMOTS10ShT1nu
         t+2g==
X-Gm-Message-State: APjAAAW6JLcu5kJHDIEPTBVkK9gW7YS6Gzmcwc6zveJUn7vP0GaLeLT5
        nBvixSp2mDnbiUdBB6mvvCBQkNTR3lhp3XzD+3KDdApK
X-Google-Smtp-Source: APXvYqwaF3AZbCUz6N3VthQSheiHXJ1nIzflxbnICKiY8i/MJm/+ISpXAI4c8csDGdAtX3RyCnkwbuw6pYj4kK1qvwo=
X-Received: by 2002:a92:d642:: with SMTP id x2mr3147241ilp.169.1582875470998;
 Thu, 27 Feb 2020 23:37:50 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 28 Feb 2020 01:37:40 -0600
Message-ID: <CAH2r5mt8Zg5ZT4hCKQr2J-Z3pZXpgYA9Gbv18VzPkWB3B7ZXwg@mail.gmail.com>
Subject: [CIFS][PATCH] print warning once if mounting with vers=1.0
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000002e2a7f059f9deada"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000002e2a7f059f9deada
Content-Type: text/plain; charset="UTF-8"

    We really, really don't want people using insecure dialects
    unless they realize what they are doing ...

    Add print once warning if mounting with vers=1.0 (older SMB1/CIFS
    dialect) instead of the default (SMB2.1 or later, typically
    SMB3.1.1).

-- 
Thanks,

Steve

--0000000000002e2a7f059f9deada
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-print-warning-once-if-mounting-with-vers-1.0.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-print-warning-once-if-mounting-with-vers-1.0.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k75v6fd50>
X-Attachment-Id: f_k75v6fd50

RnJvbSBhNDEzZjMyNzRkMjcwMjA5ZjlmNjIzYmNhMzAxZGJiOGE3NzJkZjYzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMjggRmViIDIwMjAgMDE6MzI6MzcgLTA2MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBwcmludCB3YXJuaW5nIG9uY2UgaWYgbW91bnRpbmcgd2l0aCB2ZXJzPTEuMAoKV2UgcmVh
bGx5LCByZWFsbHkgZG9uJ3Qgd2FudCBwZW9wbGUgdXNpbmcgaW5zZWN1cmUgZGlhbGVjdHMKdW5s
ZXNzIHRoZXkgcmVhbGl6ZSB3aGF0IHRoZXkgYXJlIGRvaW5nIC4uLgoKQWRkIHByaW50IG9uY2Ug
d2FybmluZyBpZiBtb3VudGluZyB3aXRoIHZlcnM9MS4wIChvbGRlciBTTUIxL0NJRlMKZGlhbGVj
dCkgaW5zdGVhZCBvZiB0aGUgZGVmYXVsdCAoU01CMi4xIG9yIGxhdGVyLCB0eXBpY2FsbHkKU01C
My4xLjEpLgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQu
Y29tPgotLS0KIGZzL2NpZnMvY29ubmVjdC5jIHwgMyArKysKIDEgZmlsZSBjaGFuZ2VkLCAzIGlu
c2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2Nvbm5lY3QuYyBiL2ZzL2NpZnMvY29u
bmVjdC5jCmluZGV4IGY0ZDEyYjc5Y2VlZC4uMjc1NzdkNzFkOTQyIDEwMDY0NAotLS0gYS9mcy9j
aWZzL2Nvbm5lY3QuYworKysgYi9mcy9jaWZzL2Nvbm5lY3QuYwpAQCAtMTQ3MSw2ICsxNDcxLDkg
QEAgY2lmc19wYXJzZV9zbWJfdmVyc2lvbihjaGFyICp2YWx1ZSwgc3RydWN0IHNtYl92b2wgKnZv
bCwgYm9vbCBpc19zbWIzKQogCQkJY2lmc19kYmcoVkZTLCAidmVycz0xLjAgKGNpZnMpIG5vdCBw
ZXJtaXR0ZWQgd2hlbiBtb3VudGluZyB3aXRoIHNtYjNcbiIpOwogCQkJcmV0dXJuIDE7CiAJCX0K
KwkJcHJpbnRrX29uY2UoS0VSTl9XQVJOSU5HICJVc2Ugb2YgdGhlIGxlc3Mgc2VjdXJlIGRpYWxl
Y3QgIgorCQkJICAgInZlcnM9MS4wIGlzIG5vdCByZWNvbW1lbmRlZCB1bmxlc3MgcmVxdWlyZWQg
Zm9yICIKKwkJCSAgICJhY2Nlc3MgdG8gdmVyeSBvbGQgc2VydmVyc1xuIik7CiAJCXZvbC0+b3Bz
ID0gJnNtYjFfb3BlcmF0aW9uczsKIAkJdm9sLT52YWxzID0gJnNtYjFfdmFsdWVzOwogCQlicmVh
azsKLS0gCjIuMjAuMQoK
--0000000000002e2a7f059f9deada--
