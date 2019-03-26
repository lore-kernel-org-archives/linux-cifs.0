Return-Path: <SRS0=KOHi=R5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD784C43381
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Mar 2019 05:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96EC120828
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Mar 2019 05:39:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jwgs6SWR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfCZFjU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Mar 2019 01:39:20 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:39805 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbfCZFjT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 26 Mar 2019 01:39:19 -0400
Received: by mail-pg1-f171.google.com with SMTP id k3so4019579pga.6
        for <linux-cifs@vger.kernel.org>; Mon, 25 Mar 2019 22:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=elsXBbk1LfyEYkdCb5vuOfeN72A9fcQwCW1I7/Chw1s=;
        b=Jwgs6SWR+SnDcppQJd4+2wAalugNMk0H18VR3rHtkuATu1ED3OJkRYV7ADVG5qxgVm
         TxXz5UxmLC1EOuC68rYG/C7X2z+HmDCVLKL2QIfAnLuqcwTkt/MQsmOskEtjiylP3RjV
         EsE5sDLoBGfNhjCRv2P0ruIk6hgj/eyTaZCAsrOMqC3DWqlQn30FWqv65rIflotq2jsA
         9XejSlp/PYM48vC7KhykOuFZKe4FPnTaSndePNOfZCCIUoicsath40Bgsu/3Fc1o9jBg
         iBu7FVgV32HIHSZ0D+e0y2iWv56B24ygTaAYCdTEu3XDFGh7DkEPZH/wjOUGYzh4cIGO
         yQ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=elsXBbk1LfyEYkdCb5vuOfeN72A9fcQwCW1I7/Chw1s=;
        b=YkNi19UtCYLiYxD0QREpRLgupZL6d1ktMaZoLMLgCHfi6IQyf6WeDI75zsRj/bWyw6
         utYelnOqtGJR6KxhDw+Tqbaowh3+pbvbB3DCKniqV1aWHzWxbJycymU+bDVUp16eis4y
         4Rn0HrEWAP4pwO42G38NC1Uib1+X/dkh6c0kcRJ6+hp7cAMFZwIg7Ez70cxMOgLvE9O5
         WfF8JwiEeuyajg0KnLiTjlt1z3EH+SXiy9xsyhKSzCal5njppJlHsgGGLZZGntI/wz+e
         BR2Ru2DD/Zi/AXozyRujWHKFlVWkwx85Ab/AQCyzrTmPwyrOgNaYBQu4/4S4TciVxblM
         IZXQ==
X-Gm-Message-State: APjAAAW3bDiFt9K8Px3xUzzqPN8ot0Pu9aAi3mIqaFXPBGdQQjvBZTzx
        eZnHEwp0Fk+TTS+pUCBlGefZiVLV7U3Zumr/mU+xhSDH
X-Google-Smtp-Source: APXvYqyeSBkLGyOJTWbgPLVjyUdT/xasRk9XdvGvD549GBil1QUBK1WyBE6u23zYYB9JNQTIoOGRk72KBjVkupxkWGY=
X-Received: by 2002:a63:31ce:: with SMTP id x197mr27336224pgx.69.1553578758514;
 Mon, 25 Mar 2019 22:39:18 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 26 Mar 2019 00:39:07 -0500
Message-ID: <CAH2r5ms+oJ8PpAbsmTmRDqoS4C=dcNV=xYv3tMWnoigA5JqFsA@mail.gmail.com>
Subject: [RFC][PATCH] Track time spent in each command
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="0000000000000854e60584f8be61"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000000854e60584f8be61
Content-Type: text/plain; charset="UTF-8"

I created a small experimental patch (leveraging the existing code for
the slow command check we already have in mid processing) to track the
total time per SMB2/SMB3 command.   Seems like it could be useful -
here is sample output (see below) from running seven xfstests to
generate the stats (these stats require CONFIG_CIFS_STATS2 to be
compiled as do the slow command counters).   I wanted to keep the
patch small and low risk so this seemed like the best place to capture
it.    This could be helpful in calculating average time per command
(and perhaps help isolate performance problems, and isolate what is
really causing slowdowns).   As with other counters: "echo 0 >
/proc/fs/cifs/Stats" resets them.   The new stats counters start at
the line "Total time spent processing each command"

Thoughts?

$ cat /proc/fs/cifs/Stats
Resources in use
CIFS Session: 1
Share (unique mount targets): 3
SMB Request/Response Buffer: 1 Pool size: 5
SMB Small Req/Resp Buffer: 2 Pool size: 30
Total Large 60864 Small 1165977 Allocations
Operations (MIDs): 1

0 session 0 share reconnects
Total vfs operations: 280236 maximum at one time: 3
Total time spent processing each command
cmd: 0 jiffies: 0 seconds 0
cmd: 1 jiffies: 2 seconds 0
cmd: 2 jiffies: 0 seconds 0
cmd: 3 jiffies: 1 seconds 0
cmd: 4 jiffies: 1 seconds 0
cmd: 5 jiffies: 6212 seconds 24
cmd: 6 jiffies: 3993 seconds 15
cmd: 7 jiffies: 135 seconds 0
cmd: 8 jiffies: 83 seconds 0
cmd: 9 jiffies: 44 seconds 0
cmd: 10 jiffies: 0 seconds 0
cmd: 11 jiffies: 1 seconds 0
cmd: 12 jiffies: 0 seconds 0
cmd: 13 jiffies: 0 seconds 0
cmd: 14 jiffies: 47 seconds 0
cmd: 15 jiffies: 0 seconds 0
cmd: 16 jiffies: 1890 seconds 7
cmd: 17 jiffies: 1368 seconds 5
cmd: 18 jiffies: 0 seconds 0

1) \\localhost\btrfs-scratch
SMBs: 42255
Bytes read: 25379425  Bytes written: 53689661
Open files: 1 total (local), 1 open on server
TreeConnects: 1 total 0 failed
TreeDisconnects: 0 total 0 failed
Creates: 14012 total 0 failed
Closes: 14009 total 0 failed
Flushes: 27 total 0 failed
Reads: 41 total 0 failed
Writes: 112 total 0 failed
Locks: 0 total 0 failed
IOCTLs: 2 total 1 failed
QueryDirectories: 28 total 0 failed
ChangeNotifies: 0 total 0 failed
QueryInfos: 11312 total 0 failed
SetInfos: 2711 total 0 failed
OplockBreaks: 0 sent 0 failed
2) \\localhost\btrfs
SMBs: 77
Bytes read: 282  Bytes written: 94
Open files: 0 total (local), 0 open on server
TreeConnects: 1 total 0 failed
TreeDisconnects: 0 total 0 failed
Creates: 23 total 0 failed
Closes: 21 total 0 failed
Flushes: 0 total 0 failed
Reads: 3 total 0 failed
Writes: 1 total 0 failed
Locks: 0 total 0 failed

-- 
Thanks,

Steve

--0000000000000854e60584f8be61
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-track-total-time-spent-per-command.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-track-total-time-spent-per-command.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jtpchliv0>
X-Attachment-Id: f_jtpchliv0

RnJvbSAzZjFlYTQzNzExY2M4Mjk4MjYzMzIzYTI1ZTI2MjI3Y2JiMjI4NzNkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjYgTWFyIDIwMTkgMDA6MzI6MzEgLTA1MDAKU3ViamVjdDogW1BBVENIXSBT
TUIzOiB0cmFjayB0b3RhbCB0aW1lIHNwZW50IHBlciBjb21tYW5kCgpUaGlzIGFsbG93cyB1cyB0
byBjYWxjdWxhdGUgYXZlcmFnZSB0aW1lIHNwZW50IGluIGVhY2ggU01CMi9TTUIzIGNvbW1hbmQg
YW5kCmFsc28gaGVscHMgZGV0ZXJtaW5lIHdoZXJlIGJvdHRsZW5lY2tzIGNvdWxkIGJlLgoKU2ln
bmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZz
L2NpZnMvY2lmc19kZWJ1Zy5jIHwgOSArKysrKysrKy0KIGZzL2NpZnMvY2lmc2dsb2IuaCAgIHwg
MyArKy0KIGZzL2NpZnMvdHJhbnNwb3J0LmMgIHwgMyArKysKIDMgZmlsZXMgY2hhbmdlZCwgMTMg
aW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNf
ZGVidWcuYyBiL2ZzL2NpZnMvY2lmc19kZWJ1Zy5jCmluZGV4IDEzYzEyODhiMDRhNy4uOGZjZmM3
NzcwZWJiIDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNfZGVidWcuYworKysgYi9mcy9jaWZzL2Np
ZnNfZGVidWcuYwpAQCAtNDYyLDggKzQ2MiwxMCBAQCBzdGF0aWMgc3NpemVfdCBjaWZzX3N0YXRz
X3Byb2Nfd3JpdGUoc3RydWN0IGZpbGUgKmZpbGUsCiAJCQlzZXJ2ZXIgPSBsaXN0X2VudHJ5KHRt
cDEsIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8sCiAJCQkJCSAgICB0Y3Bfc2VzX2xpc3QpOwogI2lm
ZGVmIENPTkZJR19DSUZTX1NUQVRTMgotCQkJZm9yIChpID0gMDsgaSA8IE5VTUJFUl9PRl9TTUIy
X0NPTU1BTkRTOyBpKyspCisJCQlmb3IgKGkgPSAwOyBpIDwgTlVNQkVSX09GX1NNQjJfQ09NTUFO
RFM7IGkrKykgewogCQkJCWF0b21pY19zZXQoJnNlcnZlci0+c21iMnNsb3djbWRbaV0sIDApOwor
CQkJCXNlcnZlci0+dGltZV9wZXJfY21kW2ldID0gMDsKKwkJCX0KICNlbmRpZiAvKiBDT05GSUdf
Q0lGU19TVEFUUzIgKi8KIAkJCWxpc3RfZm9yX2VhY2godG1wMiwgJnNlcnZlci0+c21iX3Nlc19s
aXN0KSB7CiAJCQkJc2VzID0gbGlzdF9lbnRyeSh0bXAyLCBzdHJ1Y3QgY2lmc19zZXMsCkBAIC01
MzEsNiArNTMzLDExIEBAIHN0YXRpYyBpbnQgY2lmc19zdGF0c19wcm9jX3Nob3coc3RydWN0IHNl
cV9maWxlICptLCB2b2lkICp2KQogCQlzZXJ2ZXIgPSBsaXN0X2VudHJ5KHRtcDEsIHN0cnVjdCBU
Q1BfU2VydmVyX0luZm8sCiAJCQkJICAgIHRjcF9zZXNfbGlzdCk7CiAjaWZkZWYgQ09ORklHX0NJ
RlNfU1RBVFMyCisJCXNlcV9wcmludGYobSwgIlRvdGFsIHRpbWUgc3BlbnQgcHJvY2Vzc2luZyBl
YWNoIGNvbW1hbmRcbiIpOworCQlmb3IgKGogPSAwOyBqIDwgTlVNQkVSX09GX1NNQjJfQ09NTUFO
RFM7IGorKykKKwkJCXNlcV9wcmludGYobSwgImNtZDogJWQgamlmZmllczogJWxsdSBzZWNvbmRz
ICVsbHVcbiIsIGosCisJCQkJc2VydmVyLT50aW1lX3Blcl9jbWRbal0sCisJCQkJc2VydmVyLT50
aW1lX3Blcl9jbWRbal0vSFopOwogCQlmb3IgKGogPSAwOyBqIDwgTlVNQkVSX09GX1NNQjJfQ09N
TUFORFM7IGorKykKIAkJCWlmIChhdG9taWNfcmVhZCgmc2VydmVyLT5zbWIyc2xvd2NtZFtqXSkp
CiAJCQkJc2VxX3ByaW50ZihtLCAiJWQgc2xvdyByZXNwb25zZXMgZnJvbSAlcyBmb3IgY29tbWFu
ZCAlZFxuIiwKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2dsb2IuaCBiL2ZzL2NpZnMvY2lmc2ds
b2IuaAppbmRleCAzOGZlYWU4MTJiNDcuLjcyMzI3ODhmZmZjMCAxMDA2NDQKLS0tIGEvZnMvY2lm
cy9jaWZzZ2xvYi5oCisrKyBiL2ZzL2NpZnMvY2lmc2dsb2IuaApAQCAtMTgsNyArMTgsNyBAQAog
ICovCiAjaWZuZGVmIF9DSUZTX0dMT0JfSAogI2RlZmluZSBfQ0lGU19HTE9CX0gKLQorI2RlZmlu
ZSBDT05GSUdfQ0lGU19TVEFUUzIgMSAvKiBCQiBSRU1PVkVNRSAqLwogI2luY2x1ZGUgPGxpbnV4
L2luLmg+CiAjaW5jbHVkZSA8bGludXgvaW42Lmg+CiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPgpA
QCAtNzA4LDYgKzcwOCw3IEBAIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gewogCWF0b21pY190IGlu
X3NlbmQ7IC8qIHJlcXVlc3RzIHRyeWluZyB0byBzZW5kICovCiAJYXRvbWljX3QgbnVtX3dhaXRl
cnM7ICAgLyogYmxvY2tlZCB3YWl0aW5nIHRvIGdldCBpbiBzZW5kcmVjdiAqLwogCWF0b21pY190
IHNtYjJzbG93Y21kW05VTUJFUl9PRl9TTUIyX0NPTU1BTkRTXTsgLyogY291bnQgcmVzcHMgPiAx
IHNlYyAqLworCV9fdTY0IHRpbWVfcGVyX2NtZFtOVU1CRVJfT0ZfU01CMl9DT01NQU5EU107IC8q
IHRvdGFsIHRpbWUgcGVyIGNtZCAqLwogI2VuZGlmIC8qIFNUQVRTMiAqLwogCXVuc2lnbmVkIGlu
dAltYXhfcmVhZDsKIAl1bnNpZ25lZCBpbnQJbWF4X3dyaXRlOwpkaWZmIC0tZ2l0IGEvZnMvY2lm
cy90cmFuc3BvcnQuYyBiL2ZzL2NpZnMvdHJhbnNwb3J0LmMKaW5kZXggMWRlOGU5OTZlNTY2Li4w
YzdmMjY0NDAzYmQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvdHJhbnNwb3J0LmMKKysrIGIvZnMvY2lm
cy90cmFuc3BvcnQuYwpAQCAtMTE0LDYgKzExNCw5IEBAIERlbGV0ZU1pZFFFbnRyeShzdHJ1Y3Qg
bWlkX3FfZW50cnkgKm1pZEVudHJ5KQogCQljaWZzX3NtYWxsX2J1Zl9yZWxlYXNlKG1pZEVudHJ5
LT5yZXNwX2J1Zik7CiAjaWZkZWYgQ09ORklHX0NJRlNfU1RBVFMyCiAJbm93ID0gamlmZmllczsK
KwlpZiAobGUxNl90b19jcHUobWlkRW50cnktPmNvbW1hbmQpIDwgTlVNQkVSX09GX1NNQjJfQ09N
TUFORFMpCisJCW1pZEVudHJ5LT5zZXJ2ZXItPnRpbWVfcGVyX2NtZFtsZTE2X3RvX2NwdShtaWRF
bnRyeS0+Y29tbWFuZCldCisJCQkrPSAobm93IC0gbWlkRW50cnktPndoZW5fYWxsb2MpOwogCS8q
CiAJICogY29tbWFuZHMgdGFraW5nIGxvbmdlciB0aGFuIG9uZSBzZWNvbmQgKGRlZmF1bHQpIGNh
biBiZSBpbmRpY2F0aW9ucwogCSAqIHRoYXQgc29tZXRoaW5nIGlzIHdyb25nLCB1bmxlc3MgaXQg
aXMgcXVpdGUgYSBzbG93IGxpbmsgb3IgYSB2ZXJ5Ci0tIAoyLjE3LjEKCg==
--0000000000000854e60584f8be61--
