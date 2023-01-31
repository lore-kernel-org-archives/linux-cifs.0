Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECCF4C636D3
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Jan 2023 01:44:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjAaBoD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Jan 2023 20:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjAaBoA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Jan 2023 20:44:00 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2416218168
        for <linux-cifs@vger.kernel.org>; Mon, 30 Jan 2023 17:43:54 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id br9so22053435lfb.4
        for <linux-cifs@vger.kernel.org>; Mon, 30 Jan 2023 17:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PvVBNXFKcDVmnF0G8dxRma1Qf+R9GPrNRRCeXY5fE3w=;
        b=YMmTw2qRcQe5z41FZSDgZnKIsQYeAzEfQEED77X2TuTcgh6rhmqdnwLNjHZo4glAf4
         0U4TYD4dvxqu1SZVPCe1P7TPOEM6hbLCBnzo8zQqpzTq0mI9csJjsD9XVBnPlzi4FiaC
         b/8PrgoKKedtTArW6s5ihWo5150uA7dsWSWJMGIhgCCzAg1VawqyGUwEFYVRbPVVAwYI
         6ZCs2Iv3qI7YlhZuSb4FH/7374BehZnbt66Qx/+MjOJwNXDcW8adr58eXlqK+vvRVRdh
         W1K+IzUdiO7iTgZalpk3bkxGEVs1OW3nJ7o32amoGR4Gn8KF6E66c7z7uETspoy74hL3
         PIZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PvVBNXFKcDVmnF0G8dxRma1Qf+R9GPrNRRCeXY5fE3w=;
        b=uO2UEts4PXQnNMWguiZg3S9PjmHY4rKCMSLir1i2D9jnJhS3/ziSrcjPrVJft47YBm
         VvipJS7Rvk7Hh7LtqS9dbtBHN4mLIh57KtQ+iQQBaJoBdJfHAjOtWwCeOGZC8c8Lrq42
         NCK9eq+gIZVmkjgAqXb8opIzF/urhRHkhakn64RRlIWL10Ap6hb+a07nur1yvD6oxYG7
         YSsHkLJgz5FfLFiLe+NL1ucYiv2c/uTP5W0FEKgXOiIIgSFGiiqHj/rSA8eyQmzOh+86
         y+JqdY7UmqTU/0Jb0JTYyjpjDIEkuE8JDqbQHY1GXYLLvpVYEf9xBeIzKAHkorgJzloJ
         1VRQ==
X-Gm-Message-State: AFqh2kqJ3q9rad/FWDlpXCJ0eciSN1UHR+bZpqc3aNfPH3hIwlh5nYCd
        J/matrmNjuABML/cfvNjSHc4409gMuiSCWCzu71W4+zqaLY=
X-Google-Smtp-Source: AMrXdXtc/rriuVa07q0HHHVNpXa2U2h2W1RMxTVW/jnSy2BkPj3F/3E5/aVVv264QyJHzI59nhTz8B1RcRoKmIFoV6M=
X-Received: by 2002:a19:f602:0:b0:4ca:f757:6c91 with SMTP id
 x2-20020a19f602000000b004caf7576c91mr3454005lfe.92.1675129431859; Mon, 30 Jan
 2023 17:43:51 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 30 Jan 2023 19:43:40 -0600
Message-ID: <CAH2r5mvrsr8Gh0oA=8C+d8EEue1Hsx2OMqr9hQntejRo=H31dg@mail.gmail.com>
Subject: cifs: fix indentation in make menuconfig options
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     David Howells <dhowells@redhat.com>
Content-Type: multipart/mixed; boundary="000000000000bd6d3805f385760c"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000bd6d3805f385760c
Content-Type: text/plain; charset="UTF-8"

The options that are displayed for the smb3.1.1/cifs client
    in "make menuconfig" are confusing because some of them are
    not indented making them not appear to be related to cifs.ko
    Fix that by adding an if/endif (similar to what ceph and 9pm did)
    if fs/cifs/Kconfig

    Suggested-by: David Howells <dhowells@redhat.com>
    Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 1e021c0b0653..bbf63a9eb927 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -175,6 +175,8 @@ config CIFS_NFSD_EXPORT
        help
          Allows NFS server to export a CIFS mounted share (nfsd over cifs)

+if CIFS
+
 config CIFS_SMB_DIRECT
        bool "SMB Direct support"
        depends on CIFS=m && INFINIBAND && INFINIBAND_ADDR_TRANS ||
CIFS=y && INFINIBAND=y && INFINIBAND_ADDR_TRANS=y
@@ -198,3 +200,5 @@ config CIFS_ROOT
          Enables root file system support over SMB protocol.

          Most people say N here.
+
+endif


-- 
Thanks,

Steve

--000000000000bd6d3805f385760c
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-indentation-in-make-menuconfig-options.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-indentation-in-make-menuconfig-options.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ldjksyci0>
X-Attachment-Id: f_ldjksyci0

RnJvbSBlOGM3MThlNGNjNWRlMmRlNDU2NDkyMTQ3ZmE1Y2FjMjA2NjBmYTdlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMzAgSmFuIDIwMjMgMTk6MzI6NTIgLTA2MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBmaXggaW5kZW50YXRpb24gaW4gbWFrZSBtZW51Y29uZmlnIG9wdGlvbnMKClRoZSBvcHRp
b25zIHRoYXQgYXJlIGRpc3BsYXllZCBmb3IgdGhlIHNtYjMuMS4xL2NpZnMgY2xpZW50CmluICJt
YWtlIG1lbnVjb25maWciIGFyZSBjb25mdXNpbmcgYmVjYXVzZSBzb21lIG9mIHRoZW0gYXJlCm5v
dCBpbmRlbnRlZCBtYWtpbmcgdGhlbSBub3QgYXBwZWFyIHRvIGJlIHJlbGF0ZWQgdG8gY2lmcy5r
bwpGaXggdGhhdCBieSBhZGRpbmcgYW4gaWYvZW5kaWYgKHNpbWlsYXIgdG8gd2hhdCBjZXBoIGFu
ZCA5cG0gZGlkKQppZiBmcy9jaWZzL0tjb25maWcKClN1Z2dlc3RlZC1ieTogRGF2aWQgSG93ZWxs
cyA8ZGhvd2VsbHNAcmVkaGF0LmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZy
ZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvS2NvbmZpZyB8IDQgKysrKwogMSBmaWxl
IGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvS2NvbmZpZyBi
L2ZzL2NpZnMvS2NvbmZpZwppbmRleCAxZTAyMWMwYjA2NTMuLmJiZjYzYTllYjkyNyAxMDA2NDQK
LS0tIGEvZnMvY2lmcy9LY29uZmlnCisrKyBiL2ZzL2NpZnMvS2NvbmZpZwpAQCAtMTc1LDYgKzE3
NSw4IEBAIGNvbmZpZyBDSUZTX05GU0RfRVhQT1JUCiAJaGVscAogCSAgQWxsb3dzIE5GUyBzZXJ2
ZXIgdG8gZXhwb3J0IGEgQ0lGUyBtb3VudGVkIHNoYXJlIChuZnNkIG92ZXIgY2lmcykKIAoraWYg
Q0lGUworCiBjb25maWcgQ0lGU19TTUJfRElSRUNUCiAJYm9vbCAiU01CIERpcmVjdCBzdXBwb3J0
IgogCWRlcGVuZHMgb24gQ0lGUz1tICYmIElORklOSUJBTkQgJiYgSU5GSU5JQkFORF9BRERSX1RS
QU5TIHx8IENJRlM9eSAmJiBJTkZJTklCQU5EPXkgJiYgSU5GSU5JQkFORF9BRERSX1RSQU5TPXkK
QEAgLTE5OCwzICsyMDAsNSBAQCBjb25maWcgQ0lGU19ST09UCiAJICBFbmFibGVzIHJvb3QgZmls
ZSBzeXN0ZW0gc3VwcG9ydCBvdmVyIFNNQiBwcm90b2NvbC4KIAogCSAgTW9zdCBwZW9wbGUgc2F5
IE4gaGVyZS4KKworZW5kaWYKLS0gCjIuMzQuMQoK
--000000000000bd6d3805f385760c--
