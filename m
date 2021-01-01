Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D8FC433DB
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Jan 2021 03:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFB35207A3
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Jan 2021 03:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbhAADgR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 31 Dec 2020 22:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbhAADgR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 31 Dec 2020 22:36:17 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03851C061573
        for <linux-cifs@vger.kernel.org>; Thu, 31 Dec 2020 19:35:36 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id s26so47282989lfc.8
        for <linux-cifs@vger.kernel.org>; Thu, 31 Dec 2020 19:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=PzHWKB4oDEBjEu6qHGV4isGKa2Be4k1zGdzgyHO/+VY=;
        b=dEoobE5dHGfPSqWJrINMYeXidcOfNakHe9l4MO0lWgRDMQ8DG/u9FIYBK/sGfk/aUP
         P4XRcC/dAZq0aan63GEXprhW3kdAnnKCdDn6NwdNLXJfGhfYYKcpvIzesrDyitFXn4Ji
         5x3Kd9htmeo5DbaZ/ZX1nAvFtmOtCIjYBOBXd19r9HoFbOf7jxqngRyyQTAkHqTKGx7m
         puPGiZNob9XjWQq03AE8nGSrYr15dhrUn6F+RZ3VZBdKI8EkNnOEh5EoOKBHjNlD40lQ
         dYQN4XzYMEATCvyLVnXBVG6QAq0t073GKJ/E3VTxP4UKUcBNGVUCAoePNJerVGtNdJhP
         IJ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=PzHWKB4oDEBjEu6qHGV4isGKa2Be4k1zGdzgyHO/+VY=;
        b=dQJ5+OK2v8JXTyU0erHpKjEpoi1VPFRkhjfSLENZT1Z0v5B5w9AoGoP3PBAKBl64ur
         fS1C6mN90sFxUt6XXhxO/X1LxGcU+/A+EOG5WhY4qr0hV6ojpCDW0cDvDzxhwjc48Se2
         sPFUyO4JzLJCjqPIASuV1iS20BgX2lFRQuD+X2SOyWCMXwoyjxEoxKi91cc4KJ9Gt4Jv
         qYbCZsfuqI4bG3TKN1actFYD5u2kI/4qBGbrbZQxV9Cl9UmE4lzsCq7yBfqmRSUyyv6f
         ZZ4VmgruZxN10kricpSUsM/oux4Axsra7MNiI788jkIgNTVvy4kIYPUm2s49DzelfZBz
         FhHA==
X-Gm-Message-State: AOAM533LisibayQICcdUKFw3UsS/avVcF79keKardFo1Zo32aZcOOEuq
        tS+oC3Fhw+u0VbITA0a7FaeDeaznoNecAJSuMD0=
X-Google-Smtp-Source: ABdhPJwpmjucyqwt8MdFj8Jsi/3/U31nqDlYbPn9PqDTTFpG0RpYQjxcfAOBC1sbUdglYcx1yZQXzTgLnCzAYm7LSh4=
X-Received: by 2002:a2e:87cb:: with SMTP id v11mr28773359ljj.218.1609472134510;
 Thu, 31 Dec 2020 19:35:34 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 31 Dec 2020 21:35:23 -0600
Message-ID: <CAH2r5msH3LZuF69UFcfgtG7XXurMDc=-Ab7Ct4XwfARR8d+wRA@mail.gmail.com>
Subject: [PATCH][SMB3] allow files to be created with backslash in file name
To:     Xiaoli Feng <xifeng@redhat.com>, CIFS <linux-cifs@vger.kernel.org>
Cc:     samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000da8d4405b7ce6e47"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000da8d4405b7ce6e47
Content-Type: text/plain; charset="UTF-8"

Backslash is reserved in Windows (and SMB2/SMB3 by default) but
allowed in POSIX so must be remapped when POSIX extensions are
not enabled.

The default mapping for SMB3 mounts ("SFM") allows mapping backslash
(ie 0x5C in UTF8) to 0xF026 in UCS-2 (using the Unicode remapping
range reserved for these characters), but this was not mapped by
cifs.ko (unlike asterisk, greater than, question mark etc).  This patch
fixes that to allow creating files and directories with backslash
in the file or directory name.

Before this patch:
   touch "/mnt2/filewith\slash"
would return
   touch: setting times of '/mnt2/filewith\slash': Invalid argument

With the patch touch and mkdir with the backslash in the name works.

This problem was found while debugging xfstest 453 - see
    https://bugzilla.kernel.org/show_bug.cgi?id=210961

This patch may be even more important to Samba, as alternative ways of
storing these files can create more problems. Interestingly Samba
server reports local files with backslashes in them over the wire
without remapping, even though these are illegal in SMB3 which would
cause confusion on the client(s).  Has anyone tried Windows mounting
to Samba and viewing files with locally created Linux files that
include these reserved characters (presumably Windows clients won't
like it either)?

This patch does allow creating/viewing files with remotely with '\' in
the file name from Linux (cifs.ko) but does not completely fix xfstest
453 kernel (more investigation of this test is needed).  Test 453
creates filenames with 'horrifying'
(using their term) sequences of arbitrary bytes in file names.

Reported-by: Xiaoli Feng <xifeng@redhat.com>

-- 
Thanks,

Steve

--000000000000da8d4405b7ce6e47
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-allow-files-to-be-created-with-backslash-in-fil.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-allow-files-to-be-created-with-backslash-in-fil.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kjdpv0vx0>
X-Attachment-Id: f_kjdpv0vx0

RnJvbSAwMzU5Njg0MWQ0MTE5ODQwNTQ4Njc2YTliNmQ5MTY1ODBiYWE2MThjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMzEgRGVjIDIwMjAgMjE6MTI6MTkgLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhbGxvdyBmaWxlcyB0byBiZSBjcmVhdGVkIHdpdGggYmFja3NsYXNoIGluIGZpbGUgbmFt
ZQoKQmFja3NsYXNoIGlzIHJlc2VydmVkIGluIFdpbmRvd3MgKGFuZCBTTUIyL1NNQjMgYnkgZGVm
YXVsdCkgYnV0CmFsbG93ZWQgaW4gUE9TSVggc28gbXVzdCBiZSByZW1hcHBlZCB3aGVuIFBPU0lY
IGV4dGVuc2lvbnMgYXJlCm5vdCBlbmFibGVkLgoKVGhlIGRlZmF1bHQgbWFwcGluZyBmb3IgU01C
MyBtb3VudHMgKCJTRk0iKSBhbGxvd3MgbWFwcGluZyBiYWNrc2xhc2gKKGllIDB4NUMgaW4gVVRG
OCkgdG8gMHhGMDI2IGluIFVDUy0yICh1c2luZyB0aGUgVW5pY29kZSByZW1hcHBpbmcKcmFuZ2Ug
cmVzZXJ2ZWQgZm9yIHRoZXNlIGNoYXJhY3RlcnMpLCBidXQgdGhpcyB3YXMgbm90IG1hcHBlZCBi
eQpjaWZzLmtvICh1bmxpa2UgYXN0ZXJpc2ssIGdyZWF0ZXIgdGhhbiwgcXVlc3Rpb24gbWFyayBl
dGMpLiAgVGhpcyBwYXRjaApmaXhlcyB0aGF0IHRvIGFsbG93IGNyZWF0aW5nIGZpbGVzIGFuZCBk
aXJlY3RvcmllcyB3aXRoIGJhY2tzbGFzaAppbiB0aGUgZmlsZSBvciBkaXJlY3RvcnkgbmFtZS4K
CkJlZm9yZSB0aGlzIHBhdGNoOgogICB0b3VjaCAiL21udDIvZmlsZXdpdGhcc2xhc2giCndvdWxk
IHJldHVybgogICB0b3VjaDogc2V0dGluZyB0aW1lcyBvZiAnL21udDIvZmlsZXdpdGhcc2xhc2gn
OiBJbnZhbGlkIGFyZ3VtZW50CgpXaXRoIHRoZSBwYXRjaCB0b3VjaCBhbmQgbWtkaXIgd2l0aCB0
aGUgYmFja3NsYXNoIGluIHRoZSBuYW1lIHdvcmtzLgoKVGhpcyBwcm9ibGVtIHdhcyBmb3VuZCB3
aGlsZSBkZWJ1Z2dpbmcKICAgIGh0dHBzOi8vYnVnemlsbGEua2VybmVsLm9yZy9zaG93X2J1Zy5j
Z2k/aWQ9MjEwOTYxCgpSZXBvcnRlZC1ieTogWGlhb2xpIEZlbmcgPHhpZmVuZ0ByZWRoYXQuY29t
PgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0t
LQogZnMvY2lmcy9jaWZzX3VuaWNvZGUuYyB8ICA2ICsrKysrKwogZnMvY2lmcy9kaXIuYyAgICAg
ICAgICB8IDEwICsrKysrKysrLS0KIDIgZmlsZXMgY2hhbmdlZCwgMTQgaW5zZXJ0aW9ucygrKSwg
MiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNfdW5pY29kZS5jIGIvZnMv
Y2lmcy9jaWZzX3VuaWNvZGUuYwppbmRleCA5YmQwM2EyMzEwMzIuLmE2NTMxMGM4N2RiNCAxMDA2
NDQKLS0tIGEvZnMvY2lmcy9jaWZzX3VuaWNvZGUuYworKysgYi9mcy9jaWZzL2NpZnNfdW5pY29k
ZS5jCkBAIC05OCw2ICs5OCw5IEBAIGNvbnZlcnRfc2ZtX2NoYXIoY29uc3QgX191MTYgc3JjX2No
YXIsIGNoYXIgKnRhcmdldCkKIAljYXNlIFNGTV9QRVJJT0Q6CiAJCSp0YXJnZXQgPSAnLic7CiAJ
CWJyZWFrOworCWNhc2UgU0ZNX1NMQVNIOgorCQkqdGFyZ2V0ID0gJ1xcJzsKKwkJYnJlYWs7CiAJ
ZGVmYXVsdDoKIAkJcmV0dXJuIGZhbHNlOwogCX0KQEAgLTQzMSw2ICs0MzQsOSBAQCBzdGF0aWMg
X19sZTE2IGNvbnZlcnRfdG9fc2ZtX2NoYXIoY2hhciBzcmNfY2hhciwgYm9vbCBlbmRfb2Zfc3Ry
aW5nKQogCWNhc2UgJ3wnOgogCQlkZXN0X2NoYXIgPSBjcHVfdG9fbGUxNihTRk1fUElQRSk7CiAJ
CWJyZWFrOworCWNhc2UgJ1xcJzoKKwkJZGVzdF9jaGFyID0gY3B1X3RvX2xlMTYoU0ZNX1NMQVNI
KTsKKwkJYnJlYWs7CiAJY2FzZSAnLic6CiAJCWlmIChlbmRfb2Zfc3RyaW5nKQogCQkJZGVzdF9j
aGFyID0gY3B1X3RvX2xlMTYoU0ZNX1BFUklPRCk7CmRpZmYgLS1naXQgYS9mcy9jaWZzL2Rpci5j
IGIvZnMvY2lmcy9kaXIuYwppbmRleCA2ODkwMGYxNjI5YmYuLjYyY2M1ODllMzNjZCAxMDA2NDQK
LS0tIGEvZnMvY2lmcy9kaXIuYworKysgYi9mcy9jaWZzL2Rpci5jCkBAIC0yMDgsOCArMjA4LDE0
IEBAIGNoZWNrX25hbWUoc3RydWN0IGRlbnRyeSAqZGlyZW50cnksIHN0cnVjdCBjaWZzX3Rjb24g
KnRjb24pCiAJCSAgICAgZGlyZW50cnktPmRfbmFtZS5sZW4gPgogCQkgICAgIGxlMzJfdG9fY3B1
KHRjb24tPmZzQXR0ckluZm8uTWF4UGF0aE5hbWVDb21wb25lbnRMZW5ndGgpKSkKIAkJcmV0dXJu
IC1FTkFNRVRPT0xPTkc7Ci0KLQlpZiAoIShjaWZzX3NiLT5tbnRfY2lmc19mbGFncyAmIENJRlNf
TU9VTlRfUE9TSVhfUEFUSFMpKSB7CisJLyoKKwkgKiBJZiBQT1NJWCBleHRlbnNpb25zIG5lZ290
aWF0ZWQgb3IgaWYgbWFwcGluZyByZXNlcnZlZCBjaGFyYWN0ZXJzCisJICogKHZpYSBTRk0sIHRo
ZSBkZWZhdWx0IG9uIG1vc3QgbW91bnRzIGN1cnJlbnRseSwgdGhlbiAnXCcgaXMKKwkgKiByZW1h
cHBlZCBvbiB0aGUgd2lyZSBpbnRvIHRoZSBVbmljb2RlIHJlc2VydmVkIHJhbmdlLCAweEYwMjYp
IHRoZW4KKwkgKiBkbyBub3QgbmVlZCB0byByZWplY3QgZ2V0L3NldCByZXF1ZXN0cyB3aXRoIGJh
Y2tzbGFzaCBpbiBwYXRoCisJICovCisJaWYgKCEoY2lmc19zYi0+bW50X2NpZnNfZmxhZ3MgJiBD
SUZTX01PVU5UX1BPU0lYX1BBVEhTKSAmJgorCSAgICAhKGNpZnNfc2ItPm1udF9jaWZzX2ZsYWdz
ICYgQ0lGU19NT1VOVF9NQVBfU0ZNX0NIUikpIHsKIAkJZm9yIChpID0gMDsgaSA8IGRpcmVudHJ5
LT5kX25hbWUubGVuOyBpKyspIHsKIAkJCWlmIChkaXJlbnRyeS0+ZF9uYW1lLm5hbWVbaV0gPT0g
J1xcJykgewogCQkJCWNpZnNfZGJnKEZZSSwgIkludmFsaWQgZmlsZSBuYW1lXG4iKTsKLS0gCjIu
MjcuMAoK
--000000000000da8d4405b7ce6e47--
