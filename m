Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39521C19F2A
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Aug 2022 17:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236281AbiHKRMK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Aug 2022 13:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235597AbiHKRLv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Aug 2022 13:11:51 -0400
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0879B40BFA
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 09:48:28 -0700 (PDT)
Received: by mail-vk1-xa34.google.com with SMTP id c22so9218472vko.7
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 09:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=3XVsQHQGR0DHza7jcRSgEArgoZR+VswMTqq+tNwVaDQ=;
        b=AF4YyL/E2k/js8AnXXU3t8f1zm13TggJjSsgXItSzVqrOlOeVavW+NxX7FXiGlg6jj
         CMbD3JekBs1qd+LbOzpjbpV7w4I6bOGe0bcgh8aHwolLAMEPWHGARzECrcDtHZmbRaPb
         6QMSQw6D4KUTsQldn6omx8e1yctZx8Ta2W4F3hACal/dPZzR5u/3sJ7c6Ltb5ZKmXvsI
         h22EvLv85+Djy6OLCMI/cybb4sbBtpVEbTsF3RzkPiV/xa41BHd5IyXf8FY7zMJCVOgJ
         D5q+0l9tXyQONc/crppyyKttiBGw0ijtOvlD20ykKSlvUvFt2GfF6IVmPFlTu4nWv3sb
         1/Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=3XVsQHQGR0DHza7jcRSgEArgoZR+VswMTqq+tNwVaDQ=;
        b=uG2E9U5Avv7BaQo5EVXMN+NaPl1Wo13DDA9l3j368iJVJFc0pfgiw48SH1bHua0eKt
         IlpqKnGwm7xXXDOYgJgGUHBhOGrDfPX9mF41kgusUVD+IEefX+ge0e+N+IC9G9n6jiGe
         rbiGPg1f6sGy/hhfNW4E2u1Yqm1pXKZfH9CPGjjHRH/fDaB/jLrn9vyqOJAnFf9oKsLS
         kvcn4qQV06ZXyhKHl4iKwVG/hQGIL/T72NeLJI48fwixO5Vm3bk7mpQveTQkrn79eUPX
         JchDOd81lFLQcyRG8wsImbewhruOLQTr7M4es7QmaFD3JOArVzgZF2sc43R4mM2LEcJs
         pQDQ==
X-Gm-Message-State: ACgBeo3Wq+s+taefg1Vz/fMum1Wju+XB5hpvom9vvISbWl4FzTwjtsqI
        RnxgjrnAo1RI+bV1sKaXgUcPXAk0R3oQ9/XPbuA=
X-Google-Smtp-Source: AA6agR5GlpfoyVl6WhdERwpyGkNKJ/8ze0FDRkL9gX6I8dBfV6BVjlOQZyx4m4eJa5x9zB5eopAe65Nss2o5hdKH/js=
X-Received: by 2002:a1f:9407:0:b0:377:668e:c2a0 with SMTP id
 w7-20020a1f9407000000b00377668ec2a0mr3522vkd.38.1660236507296; Thu, 11 Aug
 2022 09:48:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msJ6=LfoyGWyi94o+Z1FcJFdxpcLyPRz9K9gK5SpvPCUQ@mail.gmail.com>
 <87zggasr6o.fsf@cjr.nz> <CAH2r5mviEtcCQa1Pbyf6OeQKQ8dzJrK+BQE61qaGk6rQUaGH4A@mail.gmail.com>
 <87wnbesql0.fsf@cjr.nz>
In-Reply-To: <87wnbesql0.fsf@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 11 Aug 2022 11:48:16 -0500
Message-ID: <CAH2r5muf+h+tdR6k3wgyhY52hz9BUSBCs1hzC1V434ddt0ovxw@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] allow deferred close timeout to be configurable
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Bharath S M <bharathsm@microsoft.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: multipart/mixed; boundary="00000000000042d16905e5f9ef01"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000042d16905e5f9ef01
Content-Type: text/plain; charset="UTF-8"

The "jiffies vs. seconds" in comment was the only suggestion I didn't include.
See updated patch v2 (attached), I made minor updates.  Added the
Suggested-by from Bharath. Moved the defines for default/max to
different name with SMB3 (and in fs_context.h) since it is an smb3
feature (so not confused with cifs).  I increased the default to 5
seconds (although that is still lower than some other clients - it
should help perf.  As you suggested, unconditionally print the value
used on the mount.
for some workloads).

On Thu, Aug 11, 2022 at 11:16 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Steve French <smfrench@gmail.com> writes:
>
> > Will fix the typos thanks.
>
> Thanks.
>
> > There are a couple of minor differences from Bharath's earlier patch e.g.
> >
> > "closetimeo" rather than "dclosetimeo" (I am ok if you prefer the longer name),
> > and also this mount option is printed in list of mount options if set.
>
> Both look good to me.  I personally don't care much about naming,
> though.



-- 
Thanks,

Steve

--00000000000042d16905e5f9ef01
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-allow-deferred-close-timeout-to-be-configurable.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-allow-deferred-close-timeout-to-be-configurable.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l6p9xxba0>
X-Attachment-Id: f_l6p9xxba0

RnJvbSBhNmY0YjA1N2YwNDcyNGY4ODQzMWM2MjRiMzViMGFhMWU5YTc2MTI1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMTEgQXVnIDIwMjIgMDA6NTM6MDAgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhbGxvdyBkZWZlcnJlZCBjbG9zZSB0aW1lb3V0IHRvIGJlIGNvbmZpZ3VyYWJsZQoKRGVm
ZXJyZWQgY2xvc2UgY2FuIGJlIGEgdmVyeSB1c2VmdWwgZmVhdHVyZSBmb3IgYWxsb3dpbmcKY2Fj
aGluZyBkYXRhIGZvciByZWFkLCBhbmQgZm9yIG1pbmltaXppbmcgdGhlIG51bWJlciBvZgpyZW9w
ZW5zIG5lZWRlZCBmb3IgYSBmaWxlIHRoYXQgaXMgcmVwZWF0ZWRseSBvcGVuZWQgYW5kCmNsb3Nl
IGJ1dCB0aGVyZSBhcmUgd29ya2xvYWRzIHdoZXJlIGl0cyBkZWZhdWx0ICgxIHNlY29uZCwKc2lt
aWxhciB0byBhY3RpbWVvL2FjcmVnbWF4KSBpcyBtdWNoIHRvbyBzbWFsbC4KCkFsbG93IHRoZSB1
c2VyIHRvIGNvbmZpZ3VyZSB0aGUgYW1vdW50IG9mIHRpbWUgd2UgY2FuCmRlZmVyIHNlbmRpbmcg
dGhlIGZpbmFsIHNtYjMgY2xvc2Ugd2hlbiB3ZSBoYXZlIGEKaGFuZGxlIGxlYXNlIG9uIHRoZSBm
aWxlIChyYXRoZXIgdGhhbiBmb3JjaW5nIGl0IHRvIGRlcGVuZApvbiB2YWx1ZSBvZiBhY3RpbWVv
IHdoaWNoIGlzIG9mdGVuIHVucmVsYXRlZCwgYW5kIGxlc3Mgc2FmZSkuCgpBZGRzIG5ldyBtb3Vu
dCBwYXJhbWV0ZXIgImNsb3NldGltZW89IiB3aGljaCBpcyB0aGUgbWF4aW11bQpudW1iZXIgb2Yg
c2Vjb25kcyB3ZSBjYW4gd2FpdCBiZWZvcmUgc2VuZGluZyBhbiBTTUIzCmNsb3NlIHdoZW4gd2Ug
aGF2ZSBhIGhhbmRsZSBsZWFzZSBmb3IgaXQuICBEZWZhdWx0IHZhbHVlCmFsc28gaXMgc2V0IHRv
IHNsaWdodGx5IGxhcmdlciBhdCA1IHNlY29uZHMgKGFsdGhvdWdoIHNvbWUKb3RoZXIgY2xpZW50
cyB1c2UgbGFyZ2VyIGRlZmF1bHQgdGhpcyBzaG91bGQgc3RpbGwgaGVscCkuCgpSZXZpZXdlZC1i
eTogU2h5YW0gUHJhc2FkIE4gPHNwcmFzYWRAbWljcm9zb2Z0LmNvbT4KU3VnZ2VzdGVkLWJ5OiBC
aGFyYXRoIFNNIDxiaGFyYXRoc21AbWljcm9zb2Z0LmNvbT4KUmV2aWV3ZWQtYnk6IFBhdWxvIEFs
Y2FudGFyYSAoU1VTRSkgPHBjQGNqci5uej4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxz
dGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY2lmc2ZzLmMgICAgIHwgMSArCiBm
cy9jaWZzL2Nvbm5lY3QuYyAgICB8IDIgKysKIGZzL2NpZnMvZmlsZS5jICAgICAgIHwgNCArKy0t
CiBmcy9jaWZzL2ZzX2NvbnRleHQuYyB8IDkgKysrKysrKysrCiBmcy9jaWZzL2ZzX2NvbnRleHQu
aCB8IDggKysrKysrKysKIDUgZmlsZXMgY2hhbmdlZCwgMjIgaW5zZXJ0aW9ucygrKSwgMiBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNmcy5jIGIvZnMvY2lmcy9jaWZzZnMu
YwppbmRleCA5NDVmYjA4M2NlYTcuLmY1NGQ4YmYyNzMyYSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9j
aWZzZnMuYworKysgYi9mcy9jaWZzL2NpZnNmcy5jCkBAIC02OTMsNiArNjkzLDcgQEAgY2lmc19z
aG93X29wdGlvbnMoc3RydWN0IHNlcV9maWxlICpzLCBzdHJ1Y3QgZGVudHJ5ICpyb290KQogCQlz
ZXFfcHJpbnRmKHMsICIsYWNkaXJtYXg9JWx1IiwgY2lmc19zYi0+Y3R4LT5hY2Rpcm1heCAvIEha
KTsKIAkJc2VxX3ByaW50ZihzLCAiLGFjcmVnbWF4PSVsdSIsIGNpZnNfc2ItPmN0eC0+YWNyZWdt
YXggLyBIWik7CiAJfQorCXNlcV9wcmludGYocywgIixjbG9zZXRpbWVvPSVsdSIsIGNpZnNfc2It
PmN0eC0+Y2xvc2V0aW1lbyAvIEhaKTsKIAogCWlmICh0Y29uLT5zZXMtPmNoYW5fbWF4ID4gMSkK
IAkJc2VxX3ByaW50ZihzLCAiLG11bHRpY2hhbm5lbCxtYXhfY2hhbm5lbHM9JXp1IiwKZGlmZiAt
LWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9jb25uZWN0LmMKaW5kZXggN2YyMDVh
OWEyZGU0Li45MTExYzAyNWJjYjggMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5jCisrKyBi
L2ZzL2NpZnMvY29ubmVjdC5jCkBAIC0yNjgxLDYgKzI2ODEsOCBAQCBjb21wYXJlX21vdW50X29w
dGlvbnMoc3RydWN0IHN1cGVyX2Jsb2NrICpzYiwgc3RydWN0IGNpZnNfbW50X2RhdGEgKm1udF9k
YXRhKQogCQlyZXR1cm4gMDsKIAlpZiAob2xkLT5jdHgtPmFjZGlybWF4ICE9IG5ldy0+Y3R4LT5h
Y2Rpcm1heCkKIAkJcmV0dXJuIDA7CisJaWYgKG9sZC0+Y3R4LT5jbG9zZXRpbWVvICE9IG5ldy0+
Y3R4LT5jbG9zZXRpbWVvKQorCQlyZXR1cm4gMDsKIAogCXJldHVybiAxOwogfQpkaWZmIC0tZ2l0
IGEvZnMvY2lmcy9maWxlLmMgYi9mcy9jaWZzL2ZpbGUuYwppbmRleCA0MmYyNjM5YTFhNjYuLjJj
NWVhZTdkMzFmNCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9maWxlLmMKKysrIGIvZnMvY2lmcy9maWxl
LmMKQEAgLTk2NCwxMiArOTY0LDEyIEBAIGludCBjaWZzX2Nsb3NlKHN0cnVjdCBpbm9kZSAqaW5v
ZGUsIHN0cnVjdCBmaWxlICpmaWxlKQogCQkJCSAqIFNvLCBJbmNyZWFzZSB0aGUgcmVmIGNvdW50
IHRvIGF2b2lkIHVzZS1hZnRlci1mcmVlLgogCQkJCSAqLwogCQkJCWlmICghbW9kX2RlbGF5ZWRf
d29yayhkZWZlcnJlZGNsb3NlX3dxLAotCQkJCQkJJmNmaWxlLT5kZWZlcnJlZCwgY2lmc19zYi0+
Y3R4LT5hY3JlZ21heCkpCisJCQkJCQkmY2ZpbGUtPmRlZmVycmVkLCBjaWZzX3NiLT5jdHgtPmNs
b3NldGltZW8pKQogCQkJCQljaWZzRmlsZUluZm9fZ2V0KGNmaWxlKTsKIAkJCX0gZWxzZSB7CiAJ
CQkJLyogRGVmZXJyZWQgY2xvc2UgZm9yIGZpbGVzICovCiAJCQkJcXVldWVfZGVsYXllZF93b3Jr
KGRlZmVycmVkY2xvc2Vfd3EsCi0JCQkJCQkmY2ZpbGUtPmRlZmVycmVkLCBjaWZzX3NiLT5jdHgt
PmFjcmVnbWF4KTsKKwkJCQkJCSZjZmlsZS0+ZGVmZXJyZWQsIGNpZnNfc2ItPmN0eC0+Y2xvc2V0
aW1lbyk7CiAJCQkJY2ZpbGUtPmRlZmVycmVkX2Nsb3NlX3NjaGVkdWxlZCA9IHRydWU7CiAJCQkJ
c3Bpbl91bmxvY2soJmNpbm9kZS0+ZGVmZXJyZWRfbG9jayk7CiAJCQkJcmV0dXJuIDA7CmRpZmYg
LS1naXQgYS9mcy9jaWZzL2ZzX2NvbnRleHQuYyBiL2ZzL2NpZnMvZnNfY29udGV4dC5jCmluZGV4
IDhkYzBkOTIzZWY2YS4uMGUxM2RlYzg2YjI1IDEwMDY0NAotLS0gYS9mcy9jaWZzL2ZzX2NvbnRl
eHQuYworKysgYi9mcy9jaWZzL2ZzX2NvbnRleHQuYwpAQCAtMTQ3LDYgKzE0Nyw3IEBAIGNvbnN0
IHN0cnVjdCBmc19wYXJhbWV0ZXJfc3BlYyBzbWIzX2ZzX3BhcmFtZXRlcnNbXSA9IHsKIAlmc3Bh
cmFtX3UzMigiYWN0aW1lbyIsIE9wdF9hY3RpbWVvKSwKIAlmc3BhcmFtX3UzMigiYWNkaXJtYXgi
LCBPcHRfYWNkaXJtYXgpLAogCWZzcGFyYW1fdTMyKCJhY3JlZ21heCIsIE9wdF9hY3JlZ21heCks
CisJZnNwYXJhbV91MzIoImNsb3NldGltZW8iLCBPcHRfY2xvc2V0aW1lbyksCiAJZnNwYXJhbV91
MzIoImVjaG9faW50ZXJ2YWwiLCBPcHRfZWNob19pbnRlcnZhbCksCiAJZnNwYXJhbV91MzIoIm1h
eF9jcmVkaXRzIiwgT3B0X21heF9jcmVkaXRzKSwKIAlmc3BhcmFtX3UzMigiaGFuZGxldGltZW91
dCIsIE9wdF9oYW5kbGV0aW1lb3V0KSwKQEAgLTEwNzQsNiArMTA3NSwxMyBAQCBzdGF0aWMgaW50
IHNtYjNfZnNfY29udGV4dF9wYXJzZV9wYXJhbShzdHJ1Y3QgZnNfY29udGV4dCAqZmMsCiAJCX0K
IAkJY3R4LT5hY2Rpcm1heCA9IGN0eC0+YWNyZWdtYXggPSBIWiAqIHJlc3VsdC51aW50XzMyOwog
CQlicmVhazsKKwljYXNlIE9wdF9jbG9zZXRpbWVvOgorCQljdHgtPmNsb3NldGltZW8gPSBIWiAq
IHJlc3VsdC51aW50XzMyOworCQlpZiAoY3R4LT5jbG9zZXRpbWVvID4gU01CM19NQVhfRENMT1NF
VElNRU8pIHsKKwkJCWNpZnNfZXJyb3JmKGZjLCAiY2xvc2V0aW1lbyB0b28gbGFyZ2VcbiIpOwor
CQkJZ290byBjaWZzX3BhcnNlX21vdW50X2VycjsKKwkJfQorCQlicmVhazsKIAljYXNlIE9wdF9l
Y2hvX2ludGVydmFsOgogCQljdHgtPmVjaG9faW50ZXJ2YWwgPSByZXN1bHQudWludF8zMjsKIAkJ
YnJlYWs7CkBAIC0xNTIxLDYgKzE1MjksNyBAQCBpbnQgc21iM19pbml0X2ZzX2NvbnRleHQoc3Ry
dWN0IGZzX2NvbnRleHQgKmZjKQogCiAJY3R4LT5hY3JlZ21heCA9IENJRlNfREVGX0FDVElNRU87
CiAJY3R4LT5hY2Rpcm1heCA9IENJRlNfREVGX0FDVElNRU87CisJY3R4LT5jbG9zZXRpbWVvID0g
U01CM19ERUZfRENMT1NFVElNRU87CiAKIAkvKiBNb3N0IGNsaWVudHMgc2V0IHRpbWVvdXQgdG8g
MCwgYWxsb3dzIHNlcnZlciB0byB1c2UgaXRzIGRlZmF1bHQgKi8KIAljdHgtPmhhbmRsZV90aW1l
b3V0ID0gMDsgLyogU2VlIE1TLVNNQjIgc3BlYyBzZWN0aW9uIDIuMi4xNC4yLjEyICovCmRpZmYg
LS1naXQgYS9mcy9jaWZzL2ZzX2NvbnRleHQuaCBiL2ZzL2NpZnMvZnNfY29udGV4dC5oCmluZGV4
IDVmMDkzY2I3ZTliOS4uYmJhZWU0YzIyODFmIDEwMDY0NAotLS0gYS9mcy9jaWZzL2ZzX2NvbnRl
eHQuaAorKysgYi9mcy9jaWZzL2ZzX2NvbnRleHQuaApAQCAtMTI1LDYgKzEyNSw3IEBAIGVudW0g
Y2lmc19wYXJhbSB7CiAJT3B0X2FjdGltZW8sCiAJT3B0X2FjZGlybWF4LAogCU9wdF9hY3JlZ21h
eCwKKwlPcHRfY2xvc2V0aW1lbywKIAlPcHRfZWNob19pbnRlcnZhbCwKIAlPcHRfbWF4X2NyZWRp
dHMsCiAJT3B0X3NuYXBzaG90LApAQCAtMjQ3LDYgKzI0OCw4IEBAIHN0cnVjdCBzbWIzX2ZzX2Nv
bnRleHQgewogCS8qIGF0dHJpYnV0ZSBjYWNoZSB0aW1lbW91dCBmb3IgZmlsZXMgYW5kIGRpcmVj
dG9yaWVzIGluIGppZmZpZXMgKi8KIAl1bnNpZ25lZCBsb25nIGFjcmVnbWF4OwogCXVuc2lnbmVk
IGxvbmcgYWNkaXJtYXg7CisJLyogdGltZW91dCBmb3IgZGVmZXJyZWQgY2xvc2Ugb2YgZmlsZXMg
aW4gamlmZmllcyAqLworCXVuc2lnbmVkIGxvbmcgY2xvc2V0aW1lbzsKIAlzdHJ1Y3Qgc21iX3Zl
cnNpb25fb3BlcmF0aW9ucyAqb3BzOwogCXN0cnVjdCBzbWJfdmVyc2lvbl92YWx1ZXMgKnZhbHM7
CiAJY2hhciAqcHJlcGF0aDsKQEAgLTI3OSw0ICsyODIsOSBAQCBzdGF0aWMgaW5saW5lIHN0cnVj
dCBzbWIzX2ZzX2NvbnRleHQgKnNtYjNfZmMyY29udGV4dChjb25zdCBzdHJ1Y3QgZnNfY29udGV4
dCAqZgogZXh0ZXJuIGludCBzbWIzX2ZzX2NvbnRleHRfZHVwKHN0cnVjdCBzbWIzX2ZzX2NvbnRl
eHQgKm5ld19jdHgsIHN0cnVjdCBzbWIzX2ZzX2NvbnRleHQgKmN0eCk7CiBleHRlcm4gdm9pZCBz
bWIzX3VwZGF0ZV9tbnRfZmxhZ3Moc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYik7CiAKKy8q
CisgKiBtYXggZGVmZXJyZWQgY2xvc2UgdGltZW91dCAoamlmZmllcykgLSAyXjMwCisgKi8KKyNk
ZWZpbmUgU01CM19NQVhfRENMT1NFVElNRU8gKDEgPDwgMzApCisjZGVmaW5lIFNNQjNfREVGX0RD
TE9TRVRJTUVPICg1ICogSFopIC8qIENhbiBpbmNyZWFzZSBsYXRlciwgb3RoZXIgY2xpZW50cyB1
c2UgbGFyZ2VyICovCiAjZW5kaWYKLS0gCjIuMzQuMQoK
--00000000000042d16905e5f9ef01--
