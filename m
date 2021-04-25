Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81411C433ED
	for <linux-cifs@archiver.kernel.org>; Sun, 25 Apr 2021 16:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44A5A611F0
	for <linux-cifs@archiver.kernel.org>; Sun, 25 Apr 2021 16:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhDYQvC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 25 Apr 2021 12:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbhDYQvB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 25 Apr 2021 12:51:01 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC98C061574
        for <linux-cifs@vger.kernel.org>; Sun, 25 Apr 2021 09:50:20 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id o5so28187793ljc.1
        for <linux-cifs@vger.kernel.org>; Sun, 25 Apr 2021 09:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4bW0RSPu7R1CwwoCh0XAQByxkgMnNhHnCbpMU4Yoo+M=;
        b=vNuhCDwi9bqtXr4jK6jv5EQ49JX3qugmxun8mK6z85EyL10HC3TRA1UE6+TYUkk2Oy
         GAWjJN4KeqHmxE4tAzPR3KAkEk5/odr0ylbXgDggf6+HAyni96eeeT5PPqQWWDVSQYE3
         aTgbX9SYTvH0ajYqwnMTiVXmJtsMwUt+Y/Bavay7Z80q/CQxjWJ2zOwrUYB9kdtz2Vam
         dKNYzmVIt8tsI6nsNHuL9RvTnq8vWVjQeZTcbfdNY2FYU+2ReuDGMu2766A6TZNTBJJ+
         BfcH88x8GDhEohKKahsJnU21TojVEaGRm4ziA2K3iYIaShulDhE9nzJQb4JudehRCTDE
         4rbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4bW0RSPu7R1CwwoCh0XAQByxkgMnNhHnCbpMU4Yoo+M=;
        b=Qs/k8t2oVQndw6muu/gDSFg6T4pvekI1VyvQhE9EVVnFAkife60WbLT4uQEOAm0vDt
         nYTbD8NkH91PoBlK67zUevgOgxP+mUbpYq9r/kHY2+jqmN7p4CyW4SR0PYEZ5J9rHNmC
         ZFHkBFczXQcx15z2dXOSSnKeGEumVp46NMVGqrKY6npdxIWKaT/vegFkI05lq5jxG57j
         rUsqZiWMZjXnXP5wkNAxVSBXoRtHTKNKERJhZUKoh/3XTyhJjnENHvm4Z+sUvZrX3s29
         T2ef2Zx1SzmLAEu7B5krJWcnb5DHSHLIQhi/3YNkCtKoHsOgs104PD4vkiwRjPOlaNu4
         PiCg==
X-Gm-Message-State: AOAM533zSBGLWdPt4VKh4VZBLDVJUd6avmQG2FWrNHx4C4hzUZ3xQnIA
        wvtPCmXKt70PTfi0bcxw7RxJ6pn8IpT+ETTOJWg=
X-Google-Smtp-Source: ABdhPJylaheH2OZVClINoMuoaY597wdy6bhjtAX0nct/OAQyWDY3CoY2dkc2MsxUpZr0OSvxghik0iltvOBNkFZOf04=
X-Received: by 2002:a2e:9094:: with SMTP id l20mr9999183ljg.272.1619369418444;
 Sun, 25 Apr 2021 09:50:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvfMfgGimkmC9nQxvOMt=2E7S1=dA33MJaszy5NHE2zxQ@mail.gmail.com>
 <20210425020946.GG235567@casper.infradead.org> <CAH2r5mui+DSj0RzgcGy+EVeg7VXEwd9fanAPNdBS+NSSiv9+Ug@mail.gmail.com>
In-Reply-To: <CAH2r5mui+DSj0RzgcGy+EVeg7VXEwd9fanAPNdBS+NSSiv9+Ug@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 25 Apr 2021 11:50:07 -0500
Message-ID: <CAH2r5msv6PtzSMVv1uVY983rKzdLvfL06T5OeTiU8eLyoMjL_A@mail.gmail.com>
Subject: Re: [PATCH] smb3: add rasize mount parameter to improve performance
 of readahead
To:     Matthew Wilcox <willy@infradead.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>,
        David Howells <dhowells@redhat.com>
Content-Type: multipart/mixed; boundary="000000000000f26f7905c0ced2b3"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000f26f7905c0ced2b3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Updated patch attached. It does seem to help - just tried an experiment

      dd if=3D/mnt/test/1GBfile of=3D/dev/null bs=3D1M count=3D1024

to the same server, same share and compared mounting with rasize=3D6MB
vs. default (1MB to Azure)

(rw,relatime,vers=3D3.1.1,cache=3Dstrict,username=3Dlinuxsmb3testsharesmc,u=
id=3D0,noforceuid,gid=3D0,noforcegid,addr=3D20.150.70.104,file_mode=3D0777,=
dir_mode=3D0777,soft,persistenthandles,nounix,serverino,mapposix,mfsymlinks=
,nostrictsync,rsize=3D1048576,wsize=3D1048576,bsize=3D1048576,echo_interval=
=3D60,actimeo=3D1,multichannel,max_channels=3D2)

Got 391 MB/s  with rasize=3D6MB, much faster than default (which ends up
as 1MB with current code) of 163MB/s






# dd if=3D/mnt/test/394.29520 of=3D/dev/null bs=3D1M count=3D1024 ; dd
if=3D/mnt/scratch/394.29520 of=3D/mnt/test/junk1 bs=3D1M count=3D1024 ;dd
if=3D/mnt/test/394.29520 of=3D/dev/null bs=3D1M count=3D1024 ; dd
if=3D/mnt/scratch/394.29520 of=3D/mnt/test/junk1 bs=3D1M count=3D1024 ;
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 4.06764 s, 264 MB/s
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 12.5912 s, 85.3 MB/s
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 3.0573 s, 351 MB/s
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 8.58283 s, 125 MB/s

On Sat, Apr 24, 2021 at 9:36 PM Steve French <smfrench@gmail.com> wrote:
>
> Yep - good catch.  It is missing part of my patch :(
>
> Ugh
>
> Will need to rerun and get real numbers
>
> On Sat, Apr 24, 2021 at 9:10 PM Matthew Wilcox <willy@infradead.org> wrot=
e:
> >
> > On Sat, Apr 24, 2021 at 02:27:11PM -0500, Steve French wrote:
> > > Using the buildbot test systems, this resulted in an average improvem=
ent
> > > of 14% to the Windows server test target for the first 12 tests I
> > > tried (no multichannel)
> > > changing to 12MB rasize (read ahead size).   Similarly increasing the
> > > rasize to 12MB to Azure (this time with multichannel, 4 channels)
> > > improved performance 37%
> > >
> > > Note that Ceph had already introduced a mount parameter "rasize" to
> > > allow controlling this.  Add mount parameter "rasize" to cifs.ko to
> > > allow control of read ahead (rasize defaults to 4MB which is typicall=
y
> > > what it used to default to to the many servers whose rsize was that).
> >
> > I think something was missing from this patch -- I see you parse it and
> > set it in the mount context, but I don't see where it then gets used to
> > actually affect readahead.
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

--000000000000f26f7905c0ced2b3
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-rasize-mount-parameter-to-improve-readahead.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-rasize-mount-parameter-to-improve-readahead.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_knxepwdh0>
X-Attachment-Id: f_knxepwdh0

RnJvbSA0ZDc5NzQyOTJjZWM0MzMwOWEwYWFkOTJmNzZmZGU0NGJiMWJhZmQzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgMjQgQXByIDIwMjEgMjE6NDY6MjMgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhZGQgcmFzaXplIG1vdW50IHBhcmFtZXRlciB0byBpbXByb3ZlIHJlYWRhaGVhZAogcGVy
Zm9ybWFuY2UKCkluIHNvbWUgY2FzZXMgcmVhZGFoZWFkIG9mIG1vcmUgdGhhbiB0aGUgcmVhZCBz
aXplIGNhbiBoZWxwCih0byBhbGxvdyBwYXJhbGxlbCBpL28gb2YgcmVhZCBhaGVhZCB3aGljaCBj
YW4gaW1wcm92ZSBwZXJmb3JtYW5jZSkuCgpDZXBoIGludHJvZHVjZWQgYSBtb3VudCBwYXJhbWV0
ZXIgInJhc2l6ZSIgdG8gYWxsb3cgY29udHJvbGxpbmcgdGhpcy4KQWRkIG1vdW50IHBhcmFtZXRl
ciAicmFzaXplIiB0byBhbGxvdyBjb250cm9sIG9mIGFtb3VudCBvZiByZWFkYWhlYWQKcmVxdWVz
dGVkIG9mIHRoZSBzZXJ2ZXIuIElmIHJhc2l6ZSBub3Qgc2V0LCByYXNpemUgZGVmYXVsdHMgdG8K
bmVnb3RpYXRlZCByc2l6ZSBhcyBiZWZvcmUuCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2gg
PHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jaWZzZnMuYyAgICAgfCAgOSAr
KysrKysrLS0KIGZzL2NpZnMvZnNfY29udGV4dC5jIHwgMjUgKysrKysrKysrKysrKysrKysrKysr
KysrLQogZnMvY2lmcy9mc19jb250ZXh0LmggfCAgMiArKwogMyBmaWxlcyBjaGFuZ2VkLCAzMyBp
bnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2Zz
LmMgYi9mcy9jaWZzL2NpZnNmcy5jCmluZGV4IDM5ZjQ4ODlhMDM2Yi4uNWYyYzEzOTE0M2E3IDEw
MDY0NAotLS0gYS9mcy9jaWZzL2NpZnNmcy5jCisrKyBiL2ZzL2NpZnMvY2lmc2ZzLmMKQEAgLTIx
Nyw4ICsyMTcsMTEgQEAgY2lmc19yZWFkX3N1cGVyKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IpCiAJ
cmMgPSBzdXBlcl9zZXR1cF9iZGkoc2IpOwogCWlmIChyYykKIAkJZ290byBvdXRfbm9fcm9vdDsK
LQkvKiB0dW5lIHJlYWRhaGVhZCBhY2NvcmRpbmcgdG8gcnNpemUgKi8KLQlzYi0+c19iZGktPnJh
X3BhZ2VzID0gY2lmc19zYi0+Y3R4LT5yc2l6ZSAvIFBBR0VfU0laRTsKKwkvKiB0dW5lIHJlYWRh
aGVhZCBhY2NvcmRpbmcgdG8gcnNpemUgaWYgcmVhZGFoZWFkIHNpemUgbm90IHNldCBvbiBtb3Vu
dCAqLworCWlmIChjaWZzX3NiLT5jdHgtPnJhc2l6ZSkKKwkJc2ItPnNfYmRpLT5yYV9wYWdlcyA9
IGNpZnNfc2ItPmN0eC0+cmFzaXplIC8gUEFHRV9TSVpFOworCWVsc2UKKwkJc2ItPnNfYmRpLT5y
YV9wYWdlcyA9IGNpZnNfc2ItPmN0eC0+cnNpemUgLyBQQUdFX1NJWkU7CiAKIAlzYi0+c19ibG9j
a3NpemUgPSBDSUZTX01BWF9NU0dTSVpFOwogCXNiLT5zX2Jsb2Nrc2l6ZV9iaXRzID0gMTQ7CS8q
IGRlZmF1bHQgMioqMTQgPSBDSUZTX01BWF9NU0dTSVpFICovCkBAIC02NDksNiArNjUyLDggQEAg
Y2lmc19zaG93X29wdGlvbnMoc3RydWN0IHNlcV9maWxlICpzLCBzdHJ1Y3QgZGVudHJ5ICpyb290
KQogCXNlcV9wcmludGYocywgIixyc2l6ZT0ldSIsIGNpZnNfc2ItPmN0eC0+cnNpemUpOwogCXNl
cV9wcmludGYocywgIix3c2l6ZT0ldSIsIGNpZnNfc2ItPmN0eC0+d3NpemUpOwogCXNlcV9wcmlu
dGYocywgIixic2l6ZT0ldSIsIGNpZnNfc2ItPmN0eC0+YnNpemUpOworCWlmIChjaWZzX3NiLT5j
dHgtPnJhc2l6ZSkKKwkJc2VxX3ByaW50ZihzLCAiLHJhc2l6ZT0ldSIsIGNpZnNfc2ItPmN0eC0+
cmFzaXplKTsKIAlpZiAodGNvbi0+c2VzLT5zZXJ2ZXItPm1pbl9vZmZsb2FkKQogCQlzZXFfcHJp
bnRmKHMsICIsZXNpemU9JXUiLCB0Y29uLT5zZXMtPnNlcnZlci0+bWluX29mZmxvYWQpOwogCXNl
cV9wcmludGYocywgIixlY2hvX2ludGVydmFsPSVsdSIsCmRpZmYgLS1naXQgYS9mcy9jaWZzL2Zz
X2NvbnRleHQuYyBiL2ZzL2NpZnMvZnNfY29udGV4dC5jCmluZGV4IDc0NzU4ZTk1NDAzNS4uM2Uw
ZDAxNjg0OWUzIDEwMDY0NAotLS0gYS9mcy9jaWZzL2ZzX2NvbnRleHQuYworKysgYi9mcy9jaWZz
L2ZzX2NvbnRleHQuYwpAQCAtMTM3LDYgKzEzNyw3IEBAIGNvbnN0IHN0cnVjdCBmc19wYXJhbWV0
ZXJfc3BlYyBzbWIzX2ZzX3BhcmFtZXRlcnNbXSA9IHsKIAlmc3BhcmFtX3UzMigibWluX2VuY19v
ZmZsb2FkIiwgT3B0X21pbl9lbmNfb2ZmbG9hZCksCiAJZnNwYXJhbV91MzIoImVzaXplIiwgT3B0
X21pbl9lbmNfb2ZmbG9hZCksCiAJZnNwYXJhbV91MzIoImJzaXplIiwgT3B0X2Jsb2Nrc2l6ZSks
CisJZnNwYXJhbV91MzIoInJhc2l6ZSIsIE9wdF9yYXNpemUpLAogCWZzcGFyYW1fdTMyKCJyc2l6
ZSIsIE9wdF9yc2l6ZSksCiAJZnNwYXJhbV91MzIoIndzaXplIiwgT3B0X3dzaXplKSwKIAlmc3Bh
cmFtX3UzMigiYWN0aW1lbyIsIE9wdF9hY3RpbWVvKSwKQEAgLTk0MSw2ICs5NDIsMjYgQEAgc3Rh
dGljIGludCBzbWIzX2ZzX2NvbnRleHRfcGFyc2VfcGFyYW0oc3RydWN0IGZzX2NvbnRleHQgKmZj
LAogCQljdHgtPmJzaXplID0gcmVzdWx0LnVpbnRfMzI7CiAJCWN0eC0+Z290X2JzaXplID0gdHJ1
ZTsKIAkJYnJlYWs7CisJY2FzZSBPcHRfcmFzaXplOgorCQkvKgorCQkgKiByZWFkYWhlYWQgc2l6
ZSByZWFsaXN0aWNhbGx5IHNob3VsZCBuZXZlciBuZWVkIHRvIGJlCisJCSAqIGxlc3MgdGhhbiAx
TSAoQ0lGU19ERUZBVUxUX0lPU0laRSkgb3IgZ3JlYXRlciB0aGFuIDMyTQorCQkgKiAocGVyaGFw
cyBhbiBleGNlcHRpb24gc2hvdWxkIGJlIGNvbnNpZGVyZWQgaW4gdGhlCisJCSAqIGZvciB0aGUg
Y2FzZSBvZiBhIGxhcmdlIG51bWJlciBvZiBjaGFubmVscworCQkgKiB3aGVuIG11bHRpY2hhbm5l
bCBpcyBuZWdvdGlhdGVkKSBzaW5jZSB0aGF0IHdvdWxkIGxlYWQKKwkJICogdG8gcGxlbnR5IG9m
IHBhcmFsbGVsIEkvTyBpbiBmbGlnaHQgdG8gdGhlIHNlcnZlci4KKwkJICogTm90ZSB0aGF0IHNt
YWxsZXIgcmVhZCBhaGVhZCBzaXplcyB3b3VsZAorCQkgKiBodXJ0IHBlcmZvcm1hbmNlIG9mIGNv
bW1vbiB0b29scyBsaWtlIGNwIGFuZCBzY3AKKwkJICogd2hpY2ggb2Z0ZW4gdHJpZ2dlciBzZXF1
ZW50aWFsIGkvbyB3aXRoIHJlYWQgYWhlYWQKKwkJICovCisJCWlmICgocmVzdWx0LnVpbnRfMzIg
PiAoOCAqIFNNQjNfREVGQVVMVF9JT1NJWkUpKSB8fAorCQkgICAgKHJlc3VsdC51aW50XzMyIDwg
Q0lGU19ERUZBVUxUX0lPU0laRSkpIHsKKwkJCWNpZnNfZXJyb3JmKGZjLCAiJXM6IEludmFsaWQg
cmFzaXplICVkIHZzLiAlZFxuIiwKKwkJCQlfX2Z1bmNfXywgcmVzdWx0LnVpbnRfMzIsIFNNQjNf
REVGQVVMVF9JT1NJWkUpOworCQkJZ290byBjaWZzX3BhcnNlX21vdW50X2VycjsKKwkJfQorCQlj
dHgtPnJhc2l6ZSA9IHJlc3VsdC51aW50XzMyOworCQlicmVhazsKIAljYXNlIE9wdF9yc2l6ZToK
IAkJY3R4LT5yc2l6ZSA9IHJlc3VsdC51aW50XzMyOwogCQljdHgtPmdvdF9yc2l6ZSA9IHRydWU7
CkBAIC0xMzc3LDcgKzEzOTgsOSBAQCBpbnQgc21iM19pbml0X2ZzX2NvbnRleHQoc3RydWN0IGZz
X2NvbnRleHQgKmZjKQogCWN0eC0+Y3JlZF91aWQgPSBjdXJyZW50X3VpZCgpOwogCWN0eC0+bGlu
dXhfdWlkID0gY3VycmVudF91aWQoKTsKIAljdHgtPmxpbnV4X2dpZCA9IGN1cnJlbnRfZ2lkKCk7
Ci0JY3R4LT5ic2l6ZSA9IDEwMjQgKiAxMDI0OyAvKiBjYW4gaW1wcm92ZSBjcCBwZXJmb3JtYW5j
ZSBzaWduaWZpY2FudGx5ICovCisJLyogQnkgZGVmYXVsdCA0TUIgcmVhZCBhaGVhZCBzaXplLCAx
TUIgYmxvY2sgc2l6ZSAqLworCWN0eC0+YnNpemUgPSBDSUZTX0RFRkFVTFRfSU9TSVpFOyAvKiBj
YW4gaW1wcm92ZSBjcCBwZXJmb3JtYW5jZSBzaWduaWZpY2FudGx5ICovCisJY3R4LT5yYXNpemUg
PSAwOyAvKiAwID0gdXNlIGRlZmF1bHQgKGllIG5lZ290aWF0ZWQgcnNpemUpIGZvciByZWFkIGFo
ZWFkIHBhZ2VzICovCiAKIAkvKgogCSAqIGRlZmF1bHQgdG8gU0ZNIHN0eWxlIHJlbWFwcGluZyBv
ZiBzZXZlbiByZXNlcnZlZCBjaGFyYWN0ZXJzCmRpZmYgLS1naXQgYS9mcy9jaWZzL2ZzX2NvbnRl
eHQuaCBiL2ZzL2NpZnMvZnNfY29udGV4dC5oCmluZGV4IDU2ZDdhNzVlMjM5MC4uMmE3MWM4ZTQx
MWFjIDEwMDY0NAotLS0gYS9mcy9jaWZzL2ZzX2NvbnRleHQuaAorKysgYi9mcy9jaWZzL2ZzX2Nv
bnRleHQuaApAQCAtMTIwLDYgKzEyMCw3IEBAIGVudW0gY2lmc19wYXJhbSB7CiAJT3B0X2Rpcm1v
ZGUsCiAJT3B0X21pbl9lbmNfb2ZmbG9hZCwKIAlPcHRfYmxvY2tzaXplLAorCU9wdF9yYXNpemUs
CiAJT3B0X3JzaXplLAogCU9wdF93c2l6ZSwKIAlPcHRfYWN0aW1lbywKQEAgLTIzNSw2ICsyMzYs
NyBAQCBzdHJ1Y3Qgc21iM19mc19jb250ZXh0IHsKIAkvKiByZXVzZSBleGlzdGluZyBndWlkIGZv
ciBtdWx0aWNoYW5uZWwgKi8KIAl1OCBjbGllbnRfZ3VpZFtTTUIyX0NMSUVOVF9HVUlEX1NJWkVd
OwogCXVuc2lnbmVkIGludCBic2l6ZTsKKwl1bnNpZ25lZCBpbnQgcmFzaXplOwogCXVuc2lnbmVk
IGludCByc2l6ZTsKIAl1bnNpZ25lZCBpbnQgd3NpemU7CiAJdW5zaWduZWQgaW50IG1pbl9vZmZs
b2FkOwotLSAKMi4yNy4wCgo=
--000000000000f26f7905c0ced2b3--
