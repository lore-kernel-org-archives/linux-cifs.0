Return-Path: <SRS0=e9ua=QV=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38535C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Feb 2019 07:27:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 051112229F
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Feb 2019 07:27:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GztnXlJa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfBNH1y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Feb 2019 02:27:54 -0500
Received: from mail-pg1-f178.google.com ([209.85.215.178]:38324 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfBNH1y (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Feb 2019 02:27:54 -0500
Received: by mail-pg1-f178.google.com with SMTP id m2so336658pgl.5
        for <linux-cifs@vger.kernel.org>; Wed, 13 Feb 2019 23:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=A4RKlfnNA8gomgGeYQ82znM5hzIISejlfMCR7mEDAd4=;
        b=GztnXlJaY3vXMGRyTSbHsbkoQd/JAXzEOs0o7kHvRHd+tbSYWW+KinTJsZzVoj9L2D
         4zXKToMILbJEhyG8eCdf8qVcaFsIlGYKu18aLu5pSItBZ6Hlz+q/fllMdBY9RvebkliR
         cfLkn0v7IaW+RSovc1aY/eeje66yPEILODoTsu1mjb9rO0314J4HF+OHlB6DJFxN6Lcu
         eE4QNIttn2TGSVNf7E0dINXMLW0bJh6PrQjGoPzQcZNnGgJcB7JJjC86eKicfcJhgxUT
         l65EbI+PQIE+uyQnA9yZYnWwdRgrFbROo9iOqRQel8jXYr/ZtOOunRXHZvIZkbiA4N3b
         OS4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=A4RKlfnNA8gomgGeYQ82znM5hzIISejlfMCR7mEDAd4=;
        b=t3sqtbdUkeGrufEtPwwGjw7gDAPBBCyXLKCVTzaK5ku6/eKqNVJ9yEtV+UT2wZtoQ2
         adej3iSDKhsnUJ5uGA2pftrW1INCl13fuCGfgKmgPfwNgYSaGqf3uztNhQBb1480QYNT
         o3mKRudeE7UW0Nf1BX0QpTn1vLl+eBLyvpa0xJUFlRTojr7/GI3XHOXWTnGs7ldbT6f8
         t5LMvSHvvGY6GlahiAIIRRKdDn+lPAMEttY3tN2NMgWB/Rde8v6USEBfJ0Y6YWrTGgNq
         zbZ6jjhVgEID/rXSBFZXNAHCmD3vzu0GacAfsG13dQ8OfupM89aeqXbqyjBITfaylBUI
         qu1Q==
X-Gm-Message-State: AHQUAuaPSQ8Gk7TZunL3W1mXVDypszEfqcE19q8bkGBnWDuMpDgX0fLq
        8WiCyV6U3rSsdDET4Nr7zEkrIh32Ch3gsDaG+IdwSw==
X-Google-Smtp-Source: AHgI3IYxWuvwAzlwy27p8abka5ubtFuLj3qGsQsosHFglxk4qOq9E3zZKwkL85aMKvhygADhtFfxBKk8SEHX8/NOy64=
X-Received: by 2002:a62:12d5:: with SMTP id 82mr2570891pfs.255.1550129272763;
 Wed, 13 Feb 2019 23:27:52 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 14 Feb 2019 01:27:41 -0600
Message-ID: <CAH2r5muwi0BSpU7jujroojVNM6qO8pRO_mXTBA4TpSsp2Cd=5A@mail.gmail.com>
Subject: [SMB3][PATCH] request more credits during session setup
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000a9406a0581d5989d"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000a9406a0581d5989d
Content-Type: text/plain; charset="UTF-8"

We only request significantly more credits (during mount) on first
session setup so we typically end up with from 43-49 credits available
when mount completes - which is not enough for a large I/O to complete
(if started soon after mount).  We need > 64 credits.   Solve this by
requesting more than 2 credits on tree connect.

After mount (before this patch):
43 credits (not enough for a 4MB I/O)

After mount (with this patch)
105 credits (which is good, enough for two large I/Os to be issued
immediately after mount)


-- 
Thanks,

Steve

--000000000000a9406a0581d5989d
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-request-more-credits-on-tree-connect.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-request-more-credits-on-tree-connect.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_js4aug2i0>
X-Attachment-Id: f_js4aug2i0

RnJvbSAzNzU4MDg5ODNjNjNlMjVmOGUwZDA1ZWZmYWI4NmIwZjM2YTAyNGI3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMTQgRmViIDIwMTkgMDE6MTk6MDIgLTA2MDAKU3ViamVjdDogW1BBVENIIDEv
Ml0gc21iMzogcmVxdWVzdCBtb3JlIGNyZWRpdHMgb24gdHJlZSBjb25uZWN0CgpJZiB3ZSB0cnkg
bGFyZ2UgSS9PIChyZWFkIG9yIHdyaXRlKSBpbW1lZGlhdGVseSBhZnRlciBtb3VudAp3ZSB3b24n
dCB0eXBpY2FsbHkgaGF2ZSBlbm91Z2ggY3JlZGl0cyBiZWNhdXNlIHdlIG9ubHkgcmVxdWVzdAps
YXJnZSBhbW91bnRzIG9mIGNyZWRpdHMgb24gdGhlIGZpcnN0IHNlc3Npb24gc2V0dXAuICBTbyBp
ZgpsYXJnZSBJL08gaXMgYXR0ZW1wdGVkIHNvb24gYWZ0ZXIgbW91bnQgd2Ugd2lsbCB0eXBpY2Fs
bHkgb25seQpoYXZlIGFib3V0IDQzIGNyZWRpdHMgcmF0aGVyIHRoYW4gMTA1IGNyZWRpdHMgKHdp
dGggdGhpcyBwYXRjaCkKYXZhaWxhYmxlIGZvciB0aGUgbGFyZ2UgaS9vICh3aGljaCBuZWVkcyA2
NCBjcmVkaXRzIG1pbmltdW0pLgoKVGhpcyBwYXRjaCByZXF1ZXN0cyBtb3JlIGNyZWRpdHMgZHVy
aW5nIHRyZWUgY29ubmVjdCwgd2hpY2gKaGVscHMgZW5zdXJlIHRoYXQgd2UgaGF2ZSBlbm91Z2gg
Y3JlZGl0cyB3aGVuIG1vdW50IGNvbXBsZXRlcwooYmV0d2VlbiB0aGVzZSByZXF1ZXN0cyBhbmQg
dGhlIGZpcnN0IHNlc3Npb24gc2V0dXApIGluIG9yZGVyCiB0byBzdGFydCBsYXJnZSBJL08gaW1t
ZWRpYXRlbHkgYWZ0ZXIgbW91bnQgaWYgbmVlZGVkLgotLS0KIGZzL2NpZnMvc21iMnBkdS5jIHwg
MyArKysKIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9mcy9j
aWZzL3NtYjJwZHUuYyBiL2ZzL2NpZnMvc21iMnBkdS5jCmluZGV4IGUzZjA3NzVmOTc2NS4uNDlj
Mjg0M2IxYmNmIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuYworKysgYi9mcy9jaWZzL3Nt
YjJwZHUuYwpAQCAtMTYyMCw2ICsxNjIwLDkgQEAgU01CMl90Y29uKGNvbnN0IHVuc2lnbmVkIGlu
dCB4aWQsIHN0cnVjdCBjaWZzX3NlcyAqc2VzLCBjb25zdCBjaGFyICp0cmVlLAogCXJxc3QucnFf
aW92ID0gaW92OwogCXJxc3QucnFfbnZlYyA9IDI7CiAKKwkvKiBOZWVkIDY0IGZvciBtYXggc2l6
ZSB3cml0ZSBzbyBhc2sgZm9yIG1vcmUgaW4gY2FzZSBub3QgdGhlcmUgeWV0ICovCisJcmVxLT5z
eW5jX2hkci5DcmVkaXRSZXF1ZXN0ID0gY3B1X3RvX2xlMTYoNjQpOworCiAJcmMgPSBjaWZzX3Nl
bmRfcmVjdih4aWQsIHNlcywgJnJxc3QsICZyZXNwX2J1ZnR5cGUsIGZsYWdzLCAmcnNwX2lvdik7
CiAJY2lmc19zbWFsbF9idWZfcmVsZWFzZShyZXEpOwogCXJzcCA9IChzdHJ1Y3Qgc21iMl90cmVl
X2Nvbm5lY3RfcnNwICopcnNwX2lvdi5pb3ZfYmFzZTsKLS0gCjIuMTcuMQoK
--000000000000a9406a0581d5989d--
