Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB482C19F2D
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Aug 2022 06:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiHKGCV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Aug 2022 02:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233681AbiHKGCT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Aug 2022 02:02:19 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0993E7392F
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 23:02:16 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id b124so17290395vsc.9
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 23:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=GkGNUgbYRqRZabnfX0pk4rZzwlULD0+LXWt8GFOT9bw=;
        b=ITZDf7c1uSXKGB4qna1Kj2zTsgm37lV/vZ7rWSrecGfrro2rgHKb85JWdygadA8//1
         6oSWv7Dn99RaBj+YLflAYgiLEG+uymEC0Bx951A4O9rGLBzNvJxfSD4PxVTi6tRA89Og
         1ASMJj4PXCs3Em9Iyefv9nC2qSr3InUjh5XoJsSks363cKuiIEoqyDnZVksO0r4gxqAm
         VJYVcLhsrEueiHXomfnIopfdr8Dv/jrc/1ENFn2bCg3aWx9+Eo4c1Uq4VgIxuBCoZesJ
         BHVAmEqq9hhS1nQ665tnOUXM6XtWK0h5PKm8kn+1lGuRJoQynS5e1HSknn5SoOtsCPej
         OIfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=GkGNUgbYRqRZabnfX0pk4rZzwlULD0+LXWt8GFOT9bw=;
        b=YiPwa5UWgSpj6j4/8xI37hLIRptmaqM0pphR5L375W65NN8rJOURG1BXPi8lvgybKB
         /AD0ase7hVtQFEaBpfQxSDX46qEosIHdY6wNTDcsUDZv3h7PHxCJ7uBBtD2UQW2qznhW
         dFQrRej8RG1VVknvGOgrE6Ag4F+VCkSFjvdyuT8OWWYa2+EpjlKihxJ858K00c81fAmB
         49jXacYVQF2Fuz02Mu+CLANpY5Gta5H90dHtjx1jwp5pMSoQf3uQhfmFODZwHMBz4Vp9
         wh8F0bc/81uM7sHzREYa3b0W80msX2XJOC8kcButRlIa/QicNqKjncyzeWwiuZWWI1pm
         zDhA==
X-Gm-Message-State: ACgBeo22tvA54m7/qXb3ulUKxGB5GD+hW1mk4Ijm/xr39vJvLdeX47F4
        eL7Q5nd/vljZHV+Wlum8QqgrIMWevYxAGbEyDFFa2SK0ut2Z9w==
X-Google-Smtp-Source: AA6agR792SaEyMyBu2O6lN05VfglAMLwPyAhmxrMWrECU1OTAAXUIW7monLNNGcihucBhYWuOcwcnVmuOdkXC1fn7CI=
X-Received: by 2002:a67:fc06:0:b0:388:955d:2535 with SMTP id
 o6-20020a67fc06000000b00388955d2535mr9809797vsq.6.1660197734860; Wed, 10 Aug
 2022 23:02:14 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 11 Aug 2022 01:02:03 -0500
Message-ID: <CAH2r5msJ6=LfoyGWyi94o+Z1FcJFdxpcLyPRz9K9gK5SpvPCUQ@mail.gmail.com>
Subject: [PATCH][SMB3 client] allow deferred close timeout to be configurable
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     rohiths msft <rohiths.msft@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000003e687e05e5f0e8da"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000003e687e05e5f0e8da
Content-Type: text/plain; charset="UTF-8"

Deferred close can be a very useful feature for very safely
allowing caching data for read, and for minimizing the number
of reopens needed for a file that is repeatedly opened and
close but there are workloads where its default (1 second,
similar to actimeo/acregmax) is too small.

Allow the user to configure the amount of time we can
defer sending the final smb3 close when we have a
handle lease on the file (rather than forcing it to depend
on 1 second or actimeo which is often unrelated).

Adds new mount parameter "closetime=" which is the maximum
number of seconds we can wait before sending an SMB3
close when we have a handle lease for it.  Default value
is unchanged at 1 second.

-- 
Thanks,

Steve

--0000000000003e687e05e5f0e8da
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-allow-deferred-close-timeout-to-be-configurable.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-allow-deferred-close-timeout-to-be-configurable.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l6omuw9z0>
X-Attachment-Id: f_l6omuw9z0

RnJvbSA0NjRlZmQ0ZmVjMWVlZDVkMzRhMDk1M2MyM2RlYTk1MWI5ZjUyOGIxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMTEgQXVnIDIwMjIgMDA6NTM6MDAgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhbGxvdyBkZWZlcnJlZCBjbG9zZSB0aW1lb3V0IHRvIGJlIGNvbmZpZ3VyYWJsZQoKRGVm
ZXJyZWQgY2xvc2UgY2FuIGJlIGEgdmVyeSB1c2VmdWwgZmVhdHVyZSBmb3IgYWxsb3dpbmcKY2Fj
aGluZyBkYXRhIGZvciByZWFkLCBhbmQgZm9yIG1pbmltaXppbmcgdGhlIG51bWJlciBvZgpyZW9w
ZW5zIG5lZWRlZCBmb3IgYSBmaWxlIHRoYXQgaXMgcmVwZWF0ZWRseSBvcGVuZWQgYW5kCmNsb3Nl
IGJ1dCB0aGVyZSBhcmUgd29ya2xvYWRzIHdoZXJlIGl0cyBkZWZhdWx0ICgxIHNlY29uZCwKc2lt
aWxhciB0byBhY3RpbWVvL2FjcmVnbWF4KSBpcyB0b28gc21hbGwuCgpBbGxvdyB0aGUgdXNlciB0
byBjb25maWd1cmUgdGhlIGFtb3VudCBvZiB0aW1lIHdlIGNhbgpkZWZlciBzZW5kaW5nIHRoZSBm
aW5hbCBzbWIzIGNsb3NlIHdoZW4gd2UgaGF2ZSBhCmhhbmRsZSBsZWFzZSBvbiB0aGUgZmlsZSAo
cmF0aGVyIHRoYW4gZm9yY2luZyBpdCB0byBkZXBlbmQKb24gMSBzZWNvbmQgb3IgYWN0aW1lbyB3
aGljaCBpcyBvZnRlbiB1bnJlbGF0ZWQpLgoKQWRkcyBuZXcgbW91bnQgcGFyYW1ldGVyICJjbG9z
ZXRpbWU9IiB3aGljaCBpcyB0aGUgbWF4aW11bQpudW1iZXIgb2Ygc2Vjb25kcyB3ZSBjYW4gd2Fp
dCBiZWZvcmUgc2VuZGluZyBhbiBTTUIzCmNsb3NlIHdoZW4gd2UgaGF2ZSBhIGhhbmRsZSBsZWFz
ZSBmb3IgaXQuICBEZWZhdWx0IHZhbHVlCmlzIHVuY2hhbmdlZCBhdCAxIHNlY29uZC4KClNpZ25l
ZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9j
aWZzL2NpZnNmcy5jICAgICB8IDIgKysKIGZzL2NpZnMvY29ubmVjdC5jICAgIHwgMiArKwogZnMv
Y2lmcy9maWxlLmMgICAgICAgfCA0ICsrLS0KIGZzL2NpZnMvZnNfY29udGV4dC5jIHwgOSArKysr
KysrKysKIGZzL2NpZnMvZnNfY29udGV4dC5oIHwgMyArKysKIDUgZmlsZXMgY2hhbmdlZCwgMTgg
aW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNm
cy5jIGIvZnMvY2lmcy9jaWZzZnMuYwppbmRleCA5NDVmYjA4M2NlYTcuLmFmNjExNGUxN2ZiNSAx
MDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzZnMuYworKysgYi9mcy9jaWZzL2NpZnNmcy5jCkBAIC02
OTMsNiArNjkzLDggQEAgY2lmc19zaG93X29wdGlvbnMoc3RydWN0IHNlcV9maWxlICpzLCBzdHJ1
Y3QgZGVudHJ5ICpyb290KQogCQlzZXFfcHJpbnRmKHMsICIsYWNkaXJtYXg9JWx1IiwgY2lmc19z
Yi0+Y3R4LT5hY2Rpcm1heCAvIEhaKTsKIAkJc2VxX3ByaW50ZihzLCAiLGFjcmVnbWF4PSVsdSIs
IGNpZnNfc2ItPmN0eC0+YWNyZWdtYXggLyBIWik7CiAJfQorCWlmIChjaWZzX3NiLT5jdHgtPmNs
b3NldGltZW8gIT0gY2lmc19zYi0+Y3R4LT5hY3JlZ21heCkKKwkJc2VxX3ByaW50ZihzLCAiLGNs
b3NldGltZW89JWx1IiwgY2lmc19zYi0+Y3R4LT5jbG9zZXRpbWVvIC8gSFopOwogCiAJaWYgKHRj
b24tPnNlcy0+Y2hhbl9tYXggPiAxKQogCQlzZXFfcHJpbnRmKHMsICIsbXVsdGljaGFubmVsLG1h
eF9jaGFubmVscz0lenUiLApkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jb25uZWN0LmMgYi9mcy9jaWZz
L2Nvbm5lY3QuYwppbmRleCA3ZjIwNWE5YTJkZTQuLjkxMTFjMDI1YmNiOCAxMDA2NDQKLS0tIGEv
ZnMvY2lmcy9jb25uZWN0LmMKKysrIGIvZnMvY2lmcy9jb25uZWN0LmMKQEAgLTI2ODEsNiArMjY4
MSw4IEBAIGNvbXBhcmVfbW91bnRfb3B0aW9ucyhzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLCBzdHJ1
Y3QgY2lmc19tbnRfZGF0YSAqbW50X2RhdGEpCiAJCXJldHVybiAwOwogCWlmIChvbGQtPmN0eC0+
YWNkaXJtYXggIT0gbmV3LT5jdHgtPmFjZGlybWF4KQogCQlyZXR1cm4gMDsKKwlpZiAob2xkLT5j
dHgtPmNsb3NldGltZW8gIT0gbmV3LT5jdHgtPmNsb3NldGltZW8pCisJCXJldHVybiAwOwogCiAJ
cmV0dXJuIDE7CiB9CmRpZmYgLS1naXQgYS9mcy9jaWZzL2ZpbGUuYyBiL2ZzL2NpZnMvZmlsZS5j
CmluZGV4IDQyZjI2MzlhMWE2Ni4uMmM1ZWFlN2QzMWY0IDEwMDY0NAotLS0gYS9mcy9jaWZzL2Zp
bGUuYworKysgYi9mcy9jaWZzL2ZpbGUuYwpAQCAtOTY0LDEyICs5NjQsMTIgQEAgaW50IGNpZnNf
Y2xvc2Uoc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZpbGUpCiAJCQkJICogU28s
IEluY3JlYXNlIHRoZSByZWYgY291bnQgdG8gYXZvaWQgdXNlLWFmdGVyLWZyZWUuCiAJCQkJICov
CiAJCQkJaWYgKCFtb2RfZGVsYXllZF93b3JrKGRlZmVycmVkY2xvc2Vfd3EsCi0JCQkJCQkmY2Zp
bGUtPmRlZmVycmVkLCBjaWZzX3NiLT5jdHgtPmFjcmVnbWF4KSkKKwkJCQkJCSZjZmlsZS0+ZGVm
ZXJyZWQsIGNpZnNfc2ItPmN0eC0+Y2xvc2V0aW1lbykpCiAJCQkJCWNpZnNGaWxlSW5mb19nZXQo
Y2ZpbGUpOwogCQkJfSBlbHNlIHsKIAkJCQkvKiBEZWZlcnJlZCBjbG9zZSBmb3IgZmlsZXMgKi8K
IAkJCQlxdWV1ZV9kZWxheWVkX3dvcmsoZGVmZXJyZWRjbG9zZV93cSwKLQkJCQkJCSZjZmlsZS0+
ZGVmZXJyZWQsIGNpZnNfc2ItPmN0eC0+YWNyZWdtYXgpOworCQkJCQkJJmNmaWxlLT5kZWZlcnJl
ZCwgY2lmc19zYi0+Y3R4LT5jbG9zZXRpbWVvKTsKIAkJCQljZmlsZS0+ZGVmZXJyZWRfY2xvc2Vf
c2NoZWR1bGVkID0gdHJ1ZTsKIAkJCQlzcGluX3VubG9jaygmY2lub2RlLT5kZWZlcnJlZF9sb2Nr
KTsKIAkJCQlyZXR1cm4gMDsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvZnNfY29udGV4dC5jIGIvZnMv
Y2lmcy9mc19jb250ZXh0LmMKaW5kZXggOGRjMGQ5MjNlZjZhLi4yOGEzMzljNTdiZWIgMTAwNjQ0
Ci0tLSBhL2ZzL2NpZnMvZnNfY29udGV4dC5jCisrKyBiL2ZzL2NpZnMvZnNfY29udGV4dC5jCkBA
IC0xNDcsNiArMTQ3LDcgQEAgY29uc3Qgc3RydWN0IGZzX3BhcmFtZXRlcl9zcGVjIHNtYjNfZnNf
cGFyYW1ldGVyc1tdID0gewogCWZzcGFyYW1fdTMyKCJhY3RpbWVvIiwgT3B0X2FjdGltZW8pLAog
CWZzcGFyYW1fdTMyKCJhY2Rpcm1heCIsIE9wdF9hY2Rpcm1heCksCiAJZnNwYXJhbV91MzIoImFj
cmVnbWF4IiwgT3B0X2FjcmVnbWF4KSwKKwlmc3BhcmFtX3UzMigiY2xvc2V0aW1lbyIsIE9wdF9j
bG9zZXRpbWVvKSwKIAlmc3BhcmFtX3UzMigiZWNob19pbnRlcnZhbCIsIE9wdF9lY2hvX2ludGVy
dmFsKSwKIAlmc3BhcmFtX3UzMigibWF4X2NyZWRpdHMiLCBPcHRfbWF4X2NyZWRpdHMpLAogCWZz
cGFyYW1fdTMyKCJoYW5kbGV0aW1lb3V0IiwgT3B0X2hhbmRsZXRpbWVvdXQpLApAQCAtMTA3NCw2
ICsxMDc1LDEzIEBAIHN0YXRpYyBpbnQgc21iM19mc19jb250ZXh0X3BhcnNlX3BhcmFtKHN0cnVj
dCBmc19jb250ZXh0ICpmYywKIAkJfQogCQljdHgtPmFjZGlybWF4ID0gY3R4LT5hY3JlZ21heCA9
IEhaICogcmVzdWx0LnVpbnRfMzI7CiAJCWJyZWFrOworCWNhc2UgT3B0X2Nsb3NldGltZW86CisJ
CWN0eC0+Y2xvc2V0aW1lbyA9IEhaICogcmVzdWx0LnVpbnRfMzI7CisJCWlmIChjdHgtPmNsb3Nl
dGltZW8gPiBDSUZTX01BWF9BQ1RJTUVPKSB7CisJCQljaWZzX2Vycm9yZihmYywgImNsb3NldGlt
ZW8gdG9vIGxhcmdlXG4iKTsKKwkJCWdvdG8gY2lmc19wYXJzZV9tb3VudF9lcnI7CisJCX0KKwkJ
YnJlYWs7CiAJY2FzZSBPcHRfZWNob19pbnRlcnZhbDoKIAkJY3R4LT5lY2hvX2ludGVydmFsID0g
cmVzdWx0LnVpbnRfMzI7CiAJCWJyZWFrOwpAQCAtMTUyMSw2ICsxNTI5LDcgQEAgaW50IHNtYjNf
aW5pdF9mc19jb250ZXh0KHN0cnVjdCBmc19jb250ZXh0ICpmYykKIAogCWN0eC0+YWNyZWdtYXgg
PSBDSUZTX0RFRl9BQ1RJTUVPOwogCWN0eC0+YWNkaXJtYXggPSBDSUZTX0RFRl9BQ1RJTUVPOwor
CWN0eC0+Y2xvc2V0aW1lbyA9IENJRlNfREVGX0FDVElNRU87CiAKIAkvKiBNb3N0IGNsaWVudHMg
c2V0IHRpbWVvdXQgdG8gMCwgYWxsb3dzIHNlcnZlciB0byB1c2UgaXRzIGRlZmF1bHQgKi8KIAlj
dHgtPmhhbmRsZV90aW1lb3V0ID0gMDsgLyogU2VlIE1TLVNNQjIgc3BlYyBzZWN0aW9uIDIuMi4x
NC4yLjEyICovCmRpZmYgLS1naXQgYS9mcy9jaWZzL2ZzX2NvbnRleHQuaCBiL2ZzL2NpZnMvZnNf
Y29udGV4dC5oCmluZGV4IDVmMDkzY2I3ZTliOS4uOTI3YTVmMmY5OTE5IDEwMDY0NAotLS0gYS9m
cy9jaWZzL2ZzX2NvbnRleHQuaAorKysgYi9mcy9jaWZzL2ZzX2NvbnRleHQuaApAQCAtMTI1LDYg
KzEyNSw3IEBAIGVudW0gY2lmc19wYXJhbSB7CiAJT3B0X2FjdGltZW8sCiAJT3B0X2FjZGlybWF4
LAogCU9wdF9hY3JlZ21heCwKKwlPcHRfY2xvc2V0aW1lbywKIAlPcHRfZWNob19pbnRlcnZhbCwK
IAlPcHRfbWF4X2NyZWRpdHMsCiAJT3B0X3NuYXBzaG90LApAQCAtMjQ3LDYgKzI0OCw4IEBAIHN0
cnVjdCBzbWIzX2ZzX2NvbnRleHQgewogCS8qIGF0dHJpYnV0ZSBjYWNoZSB0aW1lbW91dCBmb3Ig
ZmlsZXMgYW5kIGRpcmVjdG9yaWVzIGluIGppZmZpZXMgKi8KIAl1bnNpZ25lZCBsb25nIGFjcmVn
bWF4OwogCXVuc2lnbmVkIGxvbmcgYWNkaXJtYXg7CisJLyogdGltZW91dCBmb3IgZGVmZXJyZWQg
Y2xvc2Ugb2YgZmlsZXMgaW4gamlmZmllcyAqLworCXVuc2lnbmVkIGxvbmcgY2xvc2V0aW1lbzsK
IAlzdHJ1Y3Qgc21iX3ZlcnNpb25fb3BlcmF0aW9ucyAqb3BzOwogCXN0cnVjdCBzbWJfdmVyc2lv
bl92YWx1ZXMgKnZhbHM7CiAJY2hhciAqcHJlcGF0aDsKLS0gCjIuMzQuMQoK
--0000000000003e687e05e5f0e8da--
