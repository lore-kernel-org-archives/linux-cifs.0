Return-Path: <SRS0=6FgL=DG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AE66C47423
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Sep 2020 12:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D41E6206F7
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Sep 2020 12:02:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bWD5YCX9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730862AbgI2MCr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 29 Sep 2020 08:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730434AbgI2MCp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 29 Sep 2020 08:02:45 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A67CC0613D0
        for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2020 05:02:45 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id b142so3420443ybg.9
        for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2020 05:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=tLroqAYdv2jxKi//H15FPsKjdKB9FjRYhpRKrLPnET8=;
        b=bWD5YCX9zUT7SEtqf0ySCyYmCOJpzQgX5FpvROJxqI0hMcJcud7X+J6tTExfM/lrWS
         E8Mj5oaZCwbNcPhH3hWYKlCfgG9x+Hhbcw8PM92y2Vvm9/F37Li+cukLiUvO7SIdg92w
         FJIRXdjp/u3tmQMBCXh2KOXAwYEmbR1teycZsZP1Uiwj6Bh+oF+5XMD8atpPYGVWwBiw
         0H7wj1zaMQ3bG18HQR3wQlxaBSAVqHQb3Ku/OYhkZfkhj11WPl6gORsRQrPtSLwvX64v
         1rgkVGG+UutvDiCt1J4zoSjC1Qta0TsQmBt/jhrGv4w2HOYI9n5tUkt0cjG3etTbbwVr
         OCEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=tLroqAYdv2jxKi//H15FPsKjdKB9FjRYhpRKrLPnET8=;
        b=ZZC29dyXrrE1M9trDCMulMg+i0fUXPrwibY8tkZq7LueU6rrU4B65XMNGrLjwq/h3u
         SgIl7NAUnVlEe5E7KlyZrNrj63wX1RDT+8c5I5skU0/pF4UtbNCUk7CdW7Bria0z1+EK
         ARTyhyYE4uMGF2a8CrjmbUkgG9KADBNYrqcR9w23J6JDKfH1+q2eA40xdO6UT8aYV0Qu
         mnjSuk8zNdsH1AS7jPLcF+E0pj/egAZtSOwRuvLBl+PUYi6VvIU3YhWMEaFrcsEjnPU5
         M3xivqQeihV6jsRAuQNfMEQ4LyBVnwvydPvpNwXJpbD872JFUeU82fQYBrMCkij7mC1j
         WiSg==
X-Gm-Message-State: AOAM530XSNUHu1rAB3qviimtUZfoZZY/AEpDru1R4soQNsJ0tvmXGyhv
        Ejm4lL6/W8SPoGAd5Stn9x0vo0LuJdPydBzn5v4=
X-Google-Smtp-Source: ABdhPJzpsRvI3dqoHovMjPo0p46Ng9ZzK0laXRKErZF2V6epyH9nuynz32bRu9FX2IxmcdPDKpOh7uI/P0+qlgi8ekk=
X-Received: by 2002:a25:ac58:: with SMTP id r24mr5044838ybd.3.1601380963449;
 Tue, 29 Sep 2020 05:02:43 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 29 Sep 2020 17:32:32 +0530
Message-ID: <CANT5p=ojR_Aac4bWSBqb3_FmzzjA6sHQBdN5z4o6c4nFDKmNDQ@mail.gmail.com>
Subject: [PATCH] cifs: Return the appropriate error in cifs_sb_tlink instead
 of a generic error.
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com,
        rohiths.msft@gmail.com
Content-Type: multipart/mixed; boundary="0000000000007a1f4805b0728f81"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000007a1f4805b0728f81
Content-Type: text/plain; charset="UTF-8"

Hi Steve,

Please find the attached patch for fixing the issue of returning hard
coded EACCES when a new tcon needs to be established. This bug affects
only the multiuser scenario.

I've tested out this fix for a few scenarios:
1. User already has valid krb5 tickets, and mount is attempted.
2. User doesn't have krb5 tickets, and mount is attempted.
3. User has expired krb5 tickets, and mount is attempted.
4. The share is already mounted, and the mount point is accessed as
another user who does not have valid krb5 tickets.
5. Same as 4, but created another session as same user (to validate
the case of existing tcon).

Please review the changes.

-- 
-Shyam

--0000000000007a1f4805b0728f81
Content-Type: application/octet-stream; 
	name="0001-cifs-Return-the-appropriate-error-in-cifs_sb_tlink.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Return-the-appropriate-error-in-cifs_sb_tlink.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kfntgb980>
X-Attachment-Id: f_kfntgb980

RnJvbSBmNjM0YjkzMmU0ODBmNzY3NDNmYzljNGYxY2FiNTUwMGVlZmZmODk4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBUdWUsIDI5IFNlcCAyMDIwIDAwOjA2OjQzIC0wNzAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogUmV0dXJuIHRoZSBhcHByb3ByaWF0ZSBlcnJvciBpbiBjaWZzX3NiX3RsaW5rIGluc3Rl
YWQKIG9mIGEgZ2VuZXJpYyBlcnJvci4KCkN1cnJlbnRseSwgY2lmc19zYl90bGluayByZXR1cm5z
IGEgZml4ZWQgZXJybm8gRUFDQ0VTIHdoZW4gaXQKZmFpbHMgZm9yIG1vc3QgcmVhc29ucy4gVGhp
cyBlbmRzIHVwIG1hc2tpbmcgdGhlIGVycm9yIHJldHVybmVkCmJ5IGNpZnNfY29uc3RydWN0X3Rj
b24sIHdoaWNoIHdpbGwgaGF2ZSBhIG1vcmUgbWVhbmluZ2Z1bCBlcnJvcgpmb3IgdGhlIGZhaWx1
cmUuCgpPbmUgb2YgdGhlIGNhc2VzIHdoZXJlIHRoaXMgYmVoYXZpb3VyIGlzIGNvbmZ1c2luZyBp
cyB3aGVyZSBhCm5ldyB0Y29uIG5lZWRzIHRvIGJlIGNvbnN0cnVjdGVkLCBidXQgaXQgZmFpbHMg
ZHVlIHRvCmV4cGlyZWQga2V5cy4gY2lmc19jb25zdHJ1Y3RfdGNvbiB0aGVuIHJldHVybnMgRU5P
S0VZLApidXQgd2UgZW5kIHVwIHJldHVybmluZyBhIEVBQ0NFUyB0byB0aGUgdXNlci4KClNpZ25l
ZC1vZmYtYnk6IFNoeWFtIFByYXNhZCBOIDxzcHJhc2FkQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMv
Y2lmcy9jb25uZWN0LmMgfCA2ICsrKystLQogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygr
KSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2Nvbm5lY3QuYyBiL2ZzL2Np
ZnMvY29ubmVjdC5jCmluZGV4IDFhM2I3NzkzMDk1ZS4uNWZkYTc2ZjQxNDA0IDEwMDY0NAotLS0g
YS9mcy9jaWZzL2Nvbm5lY3QuYworKysgYi9mcy9jaWZzL2Nvbm5lY3QuYwpAQCAtNTQ3NSw4ICs1
NDc1LDkgQEAgY2lmc19zYl90bGluayhzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiKQogCiAJ
CS8qIHJldHVybiBlcnJvciBpZiB3ZSB0cmllZCB0aGlzIGFscmVhZHkgcmVjZW50bHkgKi8KIAkJ
aWYgKHRpbWVfYmVmb3JlKGppZmZpZXMsIHRsaW5rLT50bF90aW1lICsgVExJTktfRVJST1JfRVhQ
SVJFKSkgeworCQkJbmV3dGxpbmsgPSAoc3RydWN0IHRjb25fbGluayAqKSB0bGluay0+dGxfdGNv
bjsKIAkJCWNpZnNfcHV0X3RsaW5rKHRsaW5rKTsKLQkJCXJldHVybiBFUlJfUFRSKC1FQUNDRVMp
OworCQkJcmV0dXJuIG5ld3RsaW5rOwogCQl9CiAKIAkJaWYgKHRlc3RfYW5kX3NldF9iaXQoVENP
Tl9MSU5LX1BFTkRJTkcsICZ0bGluay0+dGxfZmxhZ3MpKQpAQCAtNTQ4OCw4ICs1NDg5LDkgQEAg
Y2lmc19zYl90bGluayhzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiKQogCXdha2VfdXBfYml0
KCZ0bGluay0+dGxfZmxhZ3MsIFRDT05fTElOS19QRU5ESU5HKTsKIAogCWlmIChJU19FUlIodGxp
bmstPnRsX3Rjb24pKSB7CisJCW5ld3RsaW5rID0gKHN0cnVjdCB0Y29uX2xpbmsgKikgdGxpbmst
PnRsX3Rjb247CiAJCWNpZnNfcHV0X3RsaW5rKHRsaW5rKTsKLQkJcmV0dXJuIEVSUl9QVFIoLUVB
Q0NFUyk7CisJCXJldHVybiBuZXd0bGluazsKIAl9CiAKIAlyZXR1cm4gdGxpbms7Ci0tIAoyLjI1
LjEKCg==
--0000000000007a1f4805b0728f81--
