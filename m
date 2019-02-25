Return-Path: <SRS0=eDtx=RA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D53CC43381
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 06:16:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E49632084D
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 06:16:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bxhDUa7N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfBYGQ3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Feb 2019 01:16:29 -0500
Received: from mail-pl1-f172.google.com ([209.85.214.172]:33036 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbfBYGQ3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Feb 2019 01:16:29 -0500
Received: by mail-pl1-f172.google.com with SMTP id y10so4001935plp.0
        for <linux-cifs@vger.kernel.org>; Sun, 24 Feb 2019 22:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=6mmLeXtT8/RuAbBQ1vwRKDNY4Ut9CixfNLNiQZQwWN4=;
        b=bxhDUa7Neut812vEktqf0jMJ6HvM9DHzqZH7MUSJijbnPhbvHJalhNvSf2BeQXXp+4
         sBs9Ck22I7A7yc3cIuEEvbnRVdzOMnAZbaS/TonH8zLXvId3N7bhWALmgmk62o8eqFgg
         C5vjoVqL6RrCttVAk4Wp23q9xskMJ6pmb7qxIQc3nLj2DbfJNMseCij9WNrh335mbdVL
         8hiiSMg9C0c1olK4u8y1jFD3hm3Z2ptELn6W0pAOrx1yYWUKHsfcYaekTjJ5tggU90UX
         Sc/uqxY3ciqp2xnmSxtXZhUhQJGTo8rosCOiDwJwLK1b4HZ+egFjQbcPEtNvL37pRI5T
         G/Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=6mmLeXtT8/RuAbBQ1vwRKDNY4Ut9CixfNLNiQZQwWN4=;
        b=bD8daFKcVenoYhk5lfCzP21aILXBuIAASOBwrdYYjoDwauv94Cm7FR1MGRXDoQJvFy
         q1mrQGifwhcNr6GiNlKwrCrl2qsXzfjatbNR/NGiQoAyjISI5spHzeKAHOwmeKXPAm1x
         QTkkzkoDre35+kmYkpRnYLSSiL6t2pMCv924Ppu3HjLH3IuCG46O+PH1Vik+3VmX7RJ5
         60+UXZMcu9byQEqBv12JAR5+EY8ToqaeU2QqZ1xjjLdSZQmfUQrmaWW8sFragnZUEaed
         EXk9cNslzGpQb5rg9rNDgyJFdkKnBeeZh9PxTD7hURym7SaMI0l9LBrChfKoq8tc4/sK
         v/Jg==
X-Gm-Message-State: AHQUAuZ24BCZ0sdagnQJjB67MpAeK8AASCIaYwsznxBRrEUqumXzu/S8
        mxEcZ5QYzl9won5PNDCFfRiUEjYIt23mXCVdVmyuR/L6
X-Google-Smtp-Source: AHgI3IY6i2YcFW1WgKLdfn8dDyoSKL/uI7gZEDPId0gKWNza5KSywfYW4ZKIpv6JQcLqbr4EdL0tg0VQ69ynwYk++Ns=
X-Received: by 2002:a17:902:468:: with SMTP id 95mr17800652ple.73.1551075388319;
 Sun, 24 Feb 2019 22:16:28 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 25 Feb 2019 00:16:17 -0600
Message-ID: <CAH2r5muUaKUvvUO_Nt9PrNgFvOkBed=Emt94oXSBvmswk6RnPg@mail.gmail.com>
Subject: [PATCH] Add tracepoints for query_dir
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000008a91b40582b1e1ae"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000008a91b40582b1e1ae
Content-Type: text/plain; charset="UTF-8"

Adds two tracepoints - one for query_dir done (no err) and one for
query_dir_err (no more files, or error on query dir)

e.g.

In one window:
# trace-cmd record -e smb3_query_dir*
Hit Ctrl^C to stop recording

In another window do an ls /mnt

And then  do:

# trace-cmd show
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
              ls-27625 [006] .... 74313.708032: smb3_query_dir_done:
xid=20 sid=0xaf0a6274 tid=0x9f398492 fid=0x7a50dd5a offset=0x0
len=0x13
              ls-27625 [006] .... 74313.708713: smb3_query_dir_err:
 xid=21 sid=0xaf0a6274 tid=0x9f398492 fid=0x7a50dd5a offset=0x0
len=0x0 rc=0

Patch attached

-- 
Thanks,

Steve

--0000000000008a91b40582b1e1ae
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-tracepoints-for-query-dir.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-tracepoints-for-query-dir.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jsjy7zkx0>
X-Attachment-Id: f_jsjy7zkx0

RnJvbSBjNWNkN2NmMTc2YzkzM2NiNzEyMjkwNmQ1NzI1ZDlmOTU5OGUyZWUzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMjUgRmViIDIwMTkgMDA6MTE6NDMgLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhZGQgdHJhY2Vwb2ludHMgZm9yIHF1ZXJ5IGRpcgoKQWRkcyB0d28gdHJhY2Vwb2ludHMg
LSBvbmUgZm9yIHF1ZXJ5X2RpciBkb25lIChubyBlcnIpIGFuZCBvbmUgZm9yIHF1ZXJ5X2Rpcl9l
cnIgKG5vIG1vcmUgZmlsZXMsIG9yIGVycm9yIG9uIHF1ZXJ5IGRpcikKClNhbnBsZSBvdXRwdXQ6
CgpUbyBzdGFydCB0aGUgdHJhY2UgaW4gb25lIHdpbmRvdzoKICAgICAgIHRyYWNlLWNtZCByZWNv
cmQgLWUgc21iM19xdWVyeV9kaXIqCgpUaGVuIGluIGFub3RoZXIgd2luZG93IGFmdGVyIGRvaW5n
IGFuCiAgICAgICBscyAvbW50CgpWaWV3IHRoZSB0cmFjZSBvdXRwdXQgYnk6CgogICAgICAgIHRy
YWNlLWNtZCBzaG93CgpTYW1wbGUgb3V0cHV0IChub3RlIHRoYXQgdGhlICJlcnJvciIgaW4gbm8g
bW9yZSBmaWxlcywgc28gaXMgcmM9MCkKICAgICAgICBscy0yNzYyNSBbMDA2XSAuLi4uIDc0MzEz
LjcwODAzMjogc21iM19xdWVyeV9kaXJfZG9uZTogeGlkPTIwIHNpZD0weGFmMGE2Mjc0IHRpZD0w
eDlmMzk4NDkyIGZpZD0weDdhNTBkZDVhIG9mZnNldD0weDAgbGVuPTB4MTMKICAgICAgICBscy0y
NzYyNSBbMDA2XSAuLi4uIDc0MzEzLjcwODcxMzogc21iM19xdWVyeV9kaXJfZXJyOiAgICAgeGlk
PTIxIHNpZD0weGFmMGE2Mjc0IHRpZD0weDlmMzk4NDkyIGZpZD0weDdhNTBkZDVhIG9mZnNldD0w
eDAgbGVuPTB4MCByYz0wCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1p
Y3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIycGR1LmMgfCA0ICsrKysKIGZzL2NpZnMvdHJh
Y2UuaCAgIHwgMiArKwogMiBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKykKCmRpZmYgLS1n
aXQgYS9mcy9jaWZzL3NtYjJwZHUuYyBiL2ZzL2NpZnMvc21iMnBkdS5jCmluZGV4IDY0ZTE3MjYz
M2JjNC4uYjZlMmExZjQwMDc4IDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuYworKysgYi9m
cy9jaWZzL3NtYjJwZHUuYwpAQCAtMzg5Niw5ICszODk2LDEzIEBAIFNNQjJfcXVlcnlfZGlyZWN0
b3J5KGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJZWxz
ZQogCQljaWZzX2RiZyhWRlMsICJpbGxlZ2FsIHNlYXJjaCBidWZmZXIgdHlwZVxuIik7CiAKKwl0
cmFjZV9zbWIzX3F1ZXJ5X2Rpcl9kb25lKHhpZCwgcGVyc2lzdGVudF9maWQsIHRjb24tPnRpZCwK
KwkJCXRjb24tPnNlcy0+U3VpZCwgaW5kZXgsIHNyY2hfaW5mLT5lbnRyaWVzX2luX2J1ZmZlcik7
CiAJcmV0dXJuIHJjOwogCiBxZGlyX2V4aXQ6CisJdHJhY2Vfc21iM19xdWVyeV9kaXJfZXJyKHhp
ZCwgcGVyc2lzdGVudF9maWQsIHRjb24tPnRpZCwKKwkJCXRjb24tPnNlcy0+U3VpZCwgaW5kZXgs
IDAsIHJjKTsKIAlmcmVlX3JzcF9idWYocmVzcF9idWZ0eXBlLCByc3ApOwogCXJldHVybiByYzsK
IH0KZGlmZiAtLWdpdCBhL2ZzL2NpZnMvdHJhY2UuaCBiL2ZzL2NpZnMvdHJhY2UuaAppbmRleCA1
OWJlNDgyMDY5MzIuLmJmNGY0M2Y2ODkzYiAxMDA2NDQKLS0tIGEvZnMvY2lmcy90cmFjZS5oCisr
KyBiL2ZzL2NpZnMvdHJhY2UuaApAQCAtNTgsNiArNTgsNyBAQCBERUZJTkVfRVZFTlQoc21iM19y
d19lcnJfY2xhc3MsIHNtYjNfIyNuYW1lLCAgICBcCiAKIERFRklORV9TTUIzX1JXX0VSUl9FVkVO
VCh3cml0ZV9lcnIpOwogREVGSU5FX1NNQjNfUldfRVJSX0VWRU5UKHJlYWRfZXJyKTsKK0RFRklO
RV9TTUIzX1JXX0VSUl9FVkVOVChxdWVyeV9kaXJfZXJyKTsKIAogCiAvKiBGb3IgbG9nZ2luZyBz
dWNjZXNzZnVsIHJlYWQgb3Igd3JpdGUgKi8KQEAgLTEwMiw2ICsxMDMsNyBAQCBERUZJTkVfRVZF
TlQoc21iM19yd19kb25lX2NsYXNzLCBzbWIzXyMjbmFtZSwgICBcCiAKIERFRklORV9TTUIzX1JX
X0RPTkVfRVZFTlQod3JpdGVfZG9uZSk7CiBERUZJTkVfU01CM19SV19ET05FX0VWRU5UKHJlYWRf
ZG9uZSk7CitERUZJTkVfU01CM19SV19ET05FX0VWRU5UKHF1ZXJ5X2Rpcl9kb25lKTsKIAogLyoK
ICAqIEZvciBoYW5kbGUgYmFzZWQgY2FsbHMgb3RoZXIgdGhhbiByZWFkIGFuZCB3cml0ZSwgYW5k
IGdldC9zZXQgaW5mbwotLSAKMi4xNy4xCgo=
--0000000000008a91b40582b1e1ae--
