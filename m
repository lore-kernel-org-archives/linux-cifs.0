Return-Path: <SRS0=AEBP=RP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78C93C43381
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Mar 2019 06:48:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B5FC2147C
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Mar 2019 06:48:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nvENbqSN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfCLGsW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Mar 2019 02:48:22 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:43661 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfCLGsV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Mar 2019 02:48:21 -0400
Received: by mail-pf1-f178.google.com with SMTP id q17so1107011pfh.10
        for <linux-cifs@vger.kernel.org>; Mon, 11 Mar 2019 23:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=8m1D54tuRSoZ+icsMp+oG548NnlbDkDou5YNP2pg43Q=;
        b=nvENbqSNZ2H+EIjWoZvv2vZT0/G0STw02ZsrMZnab6a+oO7vNjou+/NF0IIruAfZv0
         X7tukyBQxUXthcsr11UVg9BWtaXM1YkwV3Lc9CzzsQ4Uo1LIHeLavA9NVTT+t/um7l8p
         LdYspDevIK/+4VUOliRXTK08V4Q7KGtW9+YjaIuQIJ0m+yf3Hf8dRpYbzDGWyfj8gK3l
         akqwzXVbfXDaas7DE9QQDjPriy5tygo19LhkQfcTLn2LaMiY31+HYUUE4xZ8yTyq1mL1
         pr2GRX5yptUDDyWOZaScRyDWVF3seMaLBncw4qxwt9vaB2yzO4I3gGTzpvLUfaj6RMQ6
         kwCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=8m1D54tuRSoZ+icsMp+oG548NnlbDkDou5YNP2pg43Q=;
        b=Q/mip5LdcFgH1DI1OUXLh6pAFOM73P+DHlBL5NPf7z5JaRnEeqHt8DsTZ3FtvaNX4W
         0RBVPQoxlXbiSWtyAvjl/5Qy+Lhx+AEZQNk1uf99lODOKhOWb/2lOf5hayT3nYR0zATQ
         EEMatMJt+aK+d63OnSVCoeSZPHFB8+YOnqpy8BuhC2B1zr6PmTvCW11Z/qHJ11thKytw
         KWd2c5mVDhCFbH7bYcQzRYQD1iErdxJpMDaH5Esv6gNFS5+iYIALYLVjPxJcLAf7jTlu
         iaVO21cwsYGnUa9fcqyjpjVKbSOsZyjrzhlkE7XA+Lmb5SHB7sSygYN5H1ymuLVrYwk1
         prUQ==
X-Gm-Message-State: APjAAAWqbT5x4rAQPlWUvT0haZ1wiFJae0+gh496aLhb5gMydbmEuAaq
        Qn7NmyYtfRPx1XWSpzG5cBXcVso0QP6CY8EQac8MQ5EE
X-Google-Smtp-Source: APXvYqwNPG3Xv9DhBYuE5tYOTsssmwz6Hdunl0yTqlAdjTxmWCwz+NMB81V2csky3FWCnhR5Sm1bUd40D8+RBiMiPRQ=
X-Received: by 2002:a62:5385:: with SMTP id h127mr36469858pfb.10.1552373300142;
 Mon, 11 Mar 2019 23:48:20 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 12 Mar 2019 01:48:08 -0500
Message-ID: <CAH2r5msYoxFjc-H=xw5L+-q3ZCoLAaAei=QjjAVF4dj=Ymepmg@mail.gmail.com>
Subject: [PATCH] smb: Display volume serial number for shares in /proc/fs/cifs/DebugData
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000001d41bd0583e01369"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000001d41bd0583e01369
Content-Type: text/plain; charset="UTF-8"

Can be helpful for debugging

Add volume serial number to /proc/fs/cifs/DebugData info on each share e.g.:

    Shares:
    0) IPC: \\localhost\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
    PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0
    Share Capabilities: None    Share Flags: 0x0
    tid: 0xf13518ce    Maximal Access: 0x1f00a9

    1) \\localhost\scratch Mounts: 1 DevInfo: 0x20 Attributes: 0x1006f
    PathComponentMax: 255 Status: 1 type: DISK Serial Number: 0xd50e5aa0
    Share Capabilities: None Aligned, Partition Aligned,    Share Flags: 0x0
    tid: 0xb792fd24    Optimal sector size: 0x200    Maximal Access: 0x1f01ff


-- 
Thanks,

Steve

--0000000000001d41bd0583e01369
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-display-volume-serial-number-for-shares-in-proc.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-display-volume-serial-number-for-shares-in-proc.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jt5eruy40>
X-Attachment-Id: f_jt5eruy40

RnJvbSBiNmYwYjEwNDgyYWM2ZDJhMWI5NjhiNzM2ZGU1YzA0OWM2MGY4MjkxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMTIgTWFyIDIwMTkgMDE6Mjk6MDMgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBkaXNwbGF5IHZvbHVtZSBzZXJpYWwgbnVtYmVyIGZvciBzaGFyZXMgaW4KIC9wcm9jL2Zz
L2NpZnMvRGVidWdEYXRhCgpJdCBjYW4gYmUgaGVscGZ1bCBmb3IgZGVidWdnaW5nLiAgQWNjb3Jk
aW5nIHRvIE1TLUZTQ0M6CgoiQSAzMi1iaXQgdW5zaWduZWQgaW50ZWdlciB0aGF0IGNvbnRhaW5z
IHRoZSBzZXJpYWwgbnVtYmVyIG9mIHRoZQp2b2x1bWUuIFRoZSBzZXJpYWwgbnVtYmVyIGlzIGFu
IG9wYXF1ZSB2YWx1ZSBnZW5lcmF0ZWQgYnkgdGhlIGZpbGUKc3lzdGVtIGF0IGZvcm1hdCB0aW1l
IgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgot
LS0KIGZzL2NpZnMvY2lmc19kZWJ1Zy5jIHwgMyArKysKIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2Vy
dGlvbnMoKykKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNfZGVidWcuYyBiL2ZzL2NpZnMvY2lm
c19kZWJ1Zy5jCmluZGV4IGZhZWIxNDUyY2MyZC4uMTNjMTI4OGIwNGE3IDEwMDY0NAotLS0gYS9m
cy9jaWZzL2NpZnNfZGVidWcuYworKysgYi9mcy9jaWZzL2NpZnNfZGVidWcuYwpAQCAtMTE1LDYg
KzExNSw5IEBAIHN0YXRpYyB2b2lkIGNpZnNfZGVidWdfdGNvbihzdHJ1Y3Qgc2VxX2ZpbGUgKm0s
IHN0cnVjdCBjaWZzX3Rjb24gKnRjb24pCiAJCXNlcV9wdXRzKG0sICIgdHlwZTogQ0RST00gIik7
CiAJZWxzZQogCQlzZXFfcHJpbnRmKG0sICIgdHlwZTogJWQgIiwgZGV2X3R5cGUpOworCisJc2Vx
X3ByaW50ZihtLCAiU2VyaWFsIE51bWJlcjogMHgleCIsIHRjb24tPnZvbF9zZXJpYWxfbnVtYmVy
KTsKKwogCWlmICgodGNvbi0+c2VhbCkgfHwKIAkgICAgKHRjb24tPnNlcy0+c2Vzc2lvbl9mbGFn
cyAmIFNNQjJfU0VTU0lPTl9GTEFHX0VOQ1JZUFRfREFUQSkgfHwKIAkgICAgKHRjb24tPnNoYXJl
X2ZsYWdzICYgU0hJMTAwNV9GTEFHU19FTkNSWVBUX0RBVEEpKQotLSAKMi4xNy4xCgo=
--0000000000001d41bd0583e01369--
