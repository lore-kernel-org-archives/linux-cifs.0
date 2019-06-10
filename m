Return-Path: <SRS0=PPE7=UJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05E99C43218
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Jun 2019 17:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD84B207E0
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Jun 2019 17:54:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YNP+VrnW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388724AbfFJRyR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 10 Jun 2019 13:54:17 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46226 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388108AbfFJRyR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 10 Jun 2019 13:54:17 -0400
Received: by mail-pf1-f194.google.com with SMTP id 81so5715667pfy.13;
        Mon, 10 Jun 2019 10:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=03588xnN9VAdFMdxVUq0SeKeUm0IisKQ3nwy+hYL6SE=;
        b=YNP+VrnWm3x5oZjfBWjnnm673S0hUL1qibo8VdHcCoAVEnM12aFc5BH1yylspHAcGu
         IR/aiTbLetTb3U0BITevAJA+MOC5dPqaccVSfTBanWkCkotVGEg/b9t0cF/nH9PZigp6
         sI5cu+CJzyrHpdgLJjqsczOy8HPDYunsCVnqnKH4izuoJeRIS21SCMnuJfbzLzAjievn
         P1uJUo6LH/0GQvzirJf43kZBvxrI513t5l6A9d2MarZELX9P57yE9hEzhgiRsUNDhqnI
         ijNKUUiG+ugmox4rqGu4lUKjquWqWs0oT1fczZTK1rUgt9dwVBbSxZWzG+fmZ/ermug8
         eQJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=03588xnN9VAdFMdxVUq0SeKeUm0IisKQ3nwy+hYL6SE=;
        b=hFf/HE0qvfgbOYPiZdc2ZRRNJxi5rfTO60m6bTh4cDclA+Ue9Pd7m17ZHKVRacgudY
         3CoOe25uoVXIUyCrOmEsAxpkD5eQd5sIElEXKt9jGmRbbJx3s/mOlIszlXlYai8wHA2o
         jUAJZadkbzwqMALrL0mLTrm8yHlLv5wz+8+dxTqKr3O09+UYdlyvrnxxjWSIexOzBev8
         x0e7TP+JNu//wNO6pJoTMxrnUZqFDfoBUkZLeubenzL9f1zTl0pIxXaVRaFnhq2FTYZz
         Ye6hLhFHiOJ1EA7Hn3mPWalEKRlaSDZ12doIF7pq/RubUmHGPcVORf75jaw/vh1FOtAv
         tLwA==
X-Gm-Message-State: APjAAAUSqt+27CSXNJ1pbBiWAV8SzzLtCNZ4MfqnwiYlPPo++VqEAN4S
        08sZz7Wr6wvwSErAvt/1Sj5pVr1AKbirbqg5Ypc8Sw==
X-Google-Smtp-Source: APXvYqwy1q0IN22QHBPrCUspB+uP/0wvrDm+Jbbn0IX9Y142PfVuB0nbTa2CdzADRaAFf3L9WnlvTY4TdlRdvW4QjtQ=
X-Received: by 2002:a17:90a:2385:: with SMTP id g5mr23016877pje.12.1560189255986;
 Mon, 10 Jun 2019 10:54:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190609115509.26260-1-ard.biesheuvel@linaro.org>
 <20190609115509.26260-8-ard.biesheuvel@linaro.org> <CAH2r5mvQmY8onx6y2Y1aJOuWP9AsK52EJ=cXiJ7hdYPWrLp6uA@mail.gmail.com>
 <20190610161736.GB63833@gmail.com>
In-Reply-To: <20190610161736.GB63833@gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 10 Jun 2019 12:54:04 -0500
Message-ID: <CAH2r5mu+87PZEZTMKsaFKDg9Z4i4axB6g9BA8JW823dFKWmSuQ@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] fs: cifs: switch to RC4 library interface
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        CIFS <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>
Content-Type: multipart/mixed; boundary="00000000000062eb17058afbdeb6"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000062eb17058afbdeb6
Content-Type: text/plain; charset="UTF-8"

On Mon, Jun 10, 2019 at 11:17 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> Hi Steve,
>
> On Sun, Jun 09, 2019 at 05:03:25PM -0500, Steve French wrote:
> > Probably harmless to change this code path (build_ntlmssp_auth_blob is
> > called at session negotiation time so shouldn't have much of a
> > performance impact).
> >
> > On the other hand if we can find optimizations in the encryption and
> > signing paths, that would be really helpful.   There was a lot of
> > focus on encryption performance at SambaXP last week.
> >
> > Andreas from Redhat gave a talk on the improvements in Samba with TLS
> > implementation of AES-GCM.   I added the cifs client implementation of
> > AES-GCM and notice it is now faster to encrypt packets than sign them
> > (performance is about 2 to 3 times faster now with GCM).
> >
> > On Sun, Jun 9, 2019 at 6:57 AM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > >
> > > The CIFS code uses the sync skcipher API to invoke the ecb(arc4) skcipher,
> > > of which only a single generic C code implementation exists. This means
> > > that going through all the trouble of using scatterlists etc buys us
> > > very little, and we're better off just invoking the arc4 library directly.
>
> This patch only changes RC4 encryption, and to be clear it actually *improves*
> the performance of the RC4 encryption, since it removes unnecessary
> abstractions.  I'd really hope that people wouldn't care either way, though,
> since RC4 is insecure and should not be used.
>
> Also it seems that fs/cifs/ supports AES-CCM but not AES-GCM?
>
> /* pneg_ctxt->Ciphers[0] = SMB2_ENCRYPTION_AES128_GCM;*/ /* not supported yet */
>         pneg_ctxt->Ciphers[0] = SMB2_ENCRYPTION_AES128_CCM;
>
> AES-GCM is usually faster than AES-CCM, so if you want to improve performance,
> switching from CCM to GCM would do that.
>
> - Eric

Yes - when I tested the GCM code in cifs.ko last week (the two patches
are currently
in the cifs-2.6.git for-next branch and thus in linux-next and are
attached), I was astounded
at the improvement - encryption with GCM is now faster than signing,
and copy is more
than twice as fast as encryption was before with CCM (assuming a fast
enough network so
that the network is not the bottleneck).  We see more benefit in the write path
(copy to server) than the read path (copy from server) but even the
read path gets
80% benefit in my tests, and with the addition of multichannel support
in the next
few months, we should see copy from server on SMB3.1.1 mounts
improving even more.

Any other ideas how to improve the encryption or signing in the read
or write path
in cifs.ko would be appreciated.   We still are slower than Windows, probably in
part due to holding mutexes longer in sending the frame across the network
(including signing or encryption) which limits parallelism somewhat.

-- 
Thanks,

Steve

--00000000000062eb17058afbdeb6
Content-Type: application/octet-stream; 
	name="0001-SMB3-Add-SMB3.1.1-GCM-to-negotiated-crypto-algorigth.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-Add-SMB3.1.1-GCM-to-negotiated-crypto-algorigth.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jwqoc1me0>
X-Attachment-Id: f_jwqoc1me0

RnJvbSAyNDI3N2FiYjhiZDgwYWFlYTY2YjdlZGQ1NWI0ZWE4MGRjNjQ4ZGIzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgNyBKdW4gMjAxOSAwODo1OTo0MCAtMDUwMApTdWJqZWN0OiBbUEFUQ0ggMS8y
XSBTTUIzOiBBZGQgU01CMy4xLjEgR0NNIHRvIG5lZ290aWF0ZWQgY3J5cHRvIGFsZ29yaWd0aG1z
CgpHQ00gaXMgZmFzdGVyLiBSZXF1ZXN0IGl0IGR1cmluZyBuZWdvdGlhdGUgcHJvdG9jb2wuCkZv
bGxvd29uIHBhdGNoIHdpbGwgYWRkIGNhbGxvdXRzIHRvIEdDTSBjcnlwdG8KClNpZ25lZC1vZmYt
Ynk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KUmV2aWV3ZWQtYnk6IFJv
bm5pZSBTYWhsYmVyZyA8bHNhaGxiZXJAcmVkaGF0LmNvbT4KLS0tCiBmcy9jaWZzL3NtYjJvcHMu
YyB8IDQgKystLQogZnMvY2lmcy9zbWIycGR1LmMgfCA4ICsrKystLS0tCiBmcy9jaWZzL3NtYjJw
ZHUuaCB8IDQgKystLQogMyBmaWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDggZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIyb3BzLmMgYi9mcy9jaWZzL3NtYjJvcHMu
YwppbmRleCBlOTIxZTY1MTE3MjguLjdmYTk1OTI5YzhmYyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9z
bWIyb3BzLmMKKysrIGIvZnMvY2lmcy9zbWIyb3BzLmMKQEAgLTMzMzMsNyArMzMzMyw3IEBAIGZp
bGxfdHJhbnNmb3JtX2hkcihzdHJ1Y3Qgc21iMl90cmFuc2Zvcm1faGRyICp0cl9oZHIsIHVuc2ln
bmVkIGludCBvcmlnX2xlbiwKIAl0cl9oZHItPlByb3RvY29sSWQgPSBTTUIyX1RSQU5TRk9STV9Q
Uk9UT19OVU07CiAJdHJfaGRyLT5PcmlnaW5hbE1lc3NhZ2VTaXplID0gY3B1X3RvX2xlMzIob3Jp
Z19sZW4pOwogCXRyX2hkci0+RmxhZ3MgPSBjcHVfdG9fbGUxNigweDAxKTsKLQlnZXRfcmFuZG9t
X2J5dGVzKCZ0cl9oZHItPk5vbmNlLCBTTUIzX0FFUzEyOENNTV9OT05DRSk7CisJZ2V0X3JhbmRv
bV9ieXRlcygmdHJfaGRyLT5Ob25jZSwgU01CM19BRVMxMjhDQ01fTk9OQ0UpOwogCW1lbWNweSgm
dHJfaGRyLT5TZXNzaW9uSWQsICZzaGRyLT5TZXNzaW9uSWQsIDgpOwogfQogCkBAIC0zNDkyLDcg
KzM0OTIsNyBAQCBjcnlwdF9tZXNzYWdlKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwg
aW50IG51bV9ycXN0LAogCQlnb3RvIGZyZWVfc2c7CiAJfQogCWl2WzBdID0gMzsKLQltZW1jcHko
aXYgKyAxLCAoY2hhciAqKXRyX2hkci0+Tm9uY2UsIFNNQjNfQUVTMTI4Q01NX05PTkNFKTsKKwlt
ZW1jcHkoaXYgKyAxLCAoY2hhciAqKXRyX2hkci0+Tm9uY2UsIFNNQjNfQUVTMTI4Q0NNX05PTkNF
KTsKIAogCWFlYWRfcmVxdWVzdF9zZXRfY3J5cHQocmVxLCBzZywgc2csIGNyeXB0X2xlbiwgaXYp
OwogCWFlYWRfcmVxdWVzdF9zZXRfYWQocmVxLCBhc3NvY19kYXRhX2xlbik7CmRpZmYgLS1naXQg
YS9mcy9jaWZzL3NtYjJwZHUuYyBiL2ZzL2NpZnMvc21iMnBkdS5jCmluZGV4IGFiOGRjNzNkMjI4
Mi4uYWIzMzAwYTM5MDcxIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuYworKysgYi9mcy9j
aWZzL3NtYjJwZHUuYwpAQCAtNDg5LDEwICs0ODksMTAgQEAgc3RhdGljIHZvaWQKIGJ1aWxkX2Vu
Y3J5cHRfY3R4dChzdHJ1Y3Qgc21iMl9lbmNyeXB0aW9uX25lZ19jb250ZXh0ICpwbmVnX2N0eHQp
CiB7CiAJcG5lZ19jdHh0LT5Db250ZXh0VHlwZSA9IFNNQjJfRU5DUllQVElPTl9DQVBBQklMSVRJ
RVM7Ci0JcG5lZ19jdHh0LT5EYXRhTGVuZ3RoID0gY3B1X3RvX2xlMTYoNCk7IC8qIENpcGhlciBD
b3VudCArIGxlMTYgY2lwaGVyICovCi0JcG5lZ19jdHh0LT5DaXBoZXJDb3VudCA9IGNwdV90b19s
ZTE2KDEpOwotLyogcG5lZ19jdHh0LT5DaXBoZXJzWzBdID0gU01CMl9FTkNSWVBUSU9OX0FFUzEy
OF9HQ007Ki8gLyogbm90IHN1cHBvcnRlZCB5ZXQgKi8KLQlwbmVnX2N0eHQtPkNpcGhlcnNbMF0g
PSBTTUIyX0VOQ1JZUFRJT05fQUVTMTI4X0NDTTsKKwlwbmVnX2N0eHQtPkRhdGFMZW5ndGggPSBj
cHVfdG9fbGUxNig2KTsgLyogQ2lwaGVyIENvdW50ICsgdHdvIGNpcGhlcnMgKi8KKwlwbmVnX2N0
eHQtPkNpcGhlckNvdW50ID0gY3B1X3RvX2xlMTYoMik7CisJcG5lZ19jdHh0LT5DaXBoZXJzWzBd
ID0gU01CMl9FTkNSWVBUSU9OX0FFUzEyOF9HQ007CisJcG5lZ19jdHh0LT5DaXBoZXJzWzFdID0g
U01CMl9FTkNSWVBUSU9OX0FFUzEyOF9DQ007CiB9CiAKIHN0YXRpYyB2b2lkCmRpZmYgLS1naXQg
YS9mcy9jaWZzL3NtYjJwZHUuaCBiL2ZzL2NpZnMvc21iMnBkdS5oCmluZGV4IGM3ZDU4MTNiZWJk
OC4uZDNhNjRjZjgxMmQ5IDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuaAorKysgYi9mcy9j
aWZzL3NtYjJwZHUuaApAQCAtMTIzLDcgKzEyMyw3IEBAIHN0cnVjdCBzbWIyX3N5bmNfcGR1IHsK
IAlfX2xlMTYgU3RydWN0dXJlU2l6ZTI7IC8qIHNpemUgb2Ygd2N0IGFyZWEgKHZhcmllcywgcmVx
dWVzdCBzcGVjaWZpYykgKi8KIH0gX19wYWNrZWQ7CiAKLSNkZWZpbmUgU01CM19BRVMxMjhDTU1f
Tk9OQ0UgMTEKKyNkZWZpbmUgU01CM19BRVMxMjhDQ01fTk9OQ0UgMTEKICNkZWZpbmUgU01CM19B
RVMxMjhHQ01fTk9OQ0UgMTIKIAogc3RydWN0IHNtYjJfdHJhbnNmb3JtX2hkciB7CkBAIC0yOTMs
NyArMjkzLDcgQEAgc3RydWN0IHNtYjJfZW5jcnlwdGlvbl9uZWdfY29udGV4dCB7CiAJX19sZTE2
CURhdGFMZW5ndGg7CiAJX19sZTMyCVJlc2VydmVkOwogCV9fbGUxNglDaXBoZXJDb3VudDsgLyog
QUVTLTEyOC1HQ00gYW5kIEFFUy0xMjgtQ0NNICovCi0JX19sZTE2CUNpcGhlcnNbMV07IC8qIENp
cGhlcnNbMF0gc2luY2Ugb25seSBvbmUgdXNlZCBub3cgKi8KKwlfX2xlMTYJQ2lwaGVyc1syXTsK
IH0gX19wYWNrZWQ7CiAKIC8qIFNlZSBNUy1TTUIyIDIuMi4zLjEuMyAqLwotLSAKMi4xNy4xLndp
bmRvd3MuMgoK
--00000000000062eb17058afbdeb6
Content-Type: application/octet-stream; 
	name="0002-Add-SMB3.1.1-GCM-crypto-to-the-encrypt-and-decrypt-f.patch"
Content-Disposition: attachment; 
	filename="0002-Add-SMB3.1.1-GCM-crypto-to-the-encrypt-and-decrypt-f.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jwqoc1mt1>
X-Attachment-Id: f_jwqoc1mt1

RnJvbSAxMjBhZTg1YzBlMDQxZDVjNmVkMmNhNWFkYjM3MDIyNmJkZDk4NGUxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgNyBKdW4gMjAxOSAxNToxNjoxMCAtMDUwMApTdWJqZWN0OiBbUEFUQ0ggMi8y
XSBBZGQgU01CMy4xLjEgR0NNIGNyeXB0byB0byB0aGUgZW5jcnlwdCBhbmQgZGVjcnlwdAogZnVu
Y3Rpb25zCgpTTUIzLjEuMSBHQ00gcGVyZm9ybXMgbXVjaCBiZXR0ZXIgdGhhbiB0aGUgb2xkZXIg
Q0NNIGRlZmF1bHQ6Cm1vcmUgdGhhbiB0d2ljZSBhcyBmYXN0IGluIHRoZSB3cml0ZSBwYXRjaCAo
Y29weSB0byB0aGUgU2FtYmEKc2VydmVyIG9uIGxvY2FsaG9zdCBmb3IgZXhhbXBsZSkgYW5kIDgw
JSBmYXN0ZXIgb24gdGhlIHJlYWQKcGF0Y2ggKGNvcHkgZnJvbSB0aGUgc2VydmVyKS4KClNpZ25l
ZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KUmV2aWV3ZWQt
Ynk6IFJvbm5pZSBTYWhsYmVyZyA8bHNhaGxiZXJAcmVkaGF0LmNvbT4KLS0tCiBmcy9jaWZzL3Nt
YjJvcHMuYyAgICAgICB8IDE4ICsrKysrKysrKysrKystLS0tLQogZnMvY2lmcy9zbWIydHJhbnNw
b3J0LmMgfCAxMCArKysrKysrKy0tCiAyIGZpbGVzIGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKyks
IDcgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIyb3BzLmMgYi9mcy9jaWZz
L3NtYjJvcHMuYwppbmRleCA3ZmE5NTkyOWM4ZmMuLmE4ZTI4Yjk1NWM2OSAxMDA2NDQKLS0tIGEv
ZnMvY2lmcy9zbWIyb3BzLmMKKysrIGIvZnMvY2lmcy9zbWIyb3BzLmMKQEAgLTMzMjQsNyArMzMy
NCw3IEBAIHNtYjJfZGlyX25lZWRzX2Nsb3NlKHN0cnVjdCBjaWZzRmlsZUluZm8gKmNmaWxlKQog
CiBzdGF0aWMgdm9pZAogZmlsbF90cmFuc2Zvcm1faGRyKHN0cnVjdCBzbWIyX3RyYW5zZm9ybV9o
ZHIgKnRyX2hkciwgdW5zaWduZWQgaW50IG9yaWdfbGVuLAotCQkgICBzdHJ1Y3Qgc21iX3Jxc3Qg
Km9sZF9ycSkKKwkJICAgc3RydWN0IHNtYl9ycXN0ICpvbGRfcnEsIHN0cnVjdCBUQ1BfU2VydmVy
X0luZm8gKnNlcnZlcikKIHsKIAlzdHJ1Y3Qgc21iMl9zeW5jX2hkciAqc2hkciA9CiAJCQkoc3Ry
dWN0IHNtYjJfc3luY19oZHIgKilvbGRfcnEtPnJxX2lvdlswXS5pb3ZfYmFzZTsKQEAgLTMzMzMs
NyArMzMzMywxMCBAQCBmaWxsX3RyYW5zZm9ybV9oZHIoc3RydWN0IHNtYjJfdHJhbnNmb3JtX2hk
ciAqdHJfaGRyLCB1bnNpZ25lZCBpbnQgb3JpZ19sZW4sCiAJdHJfaGRyLT5Qcm90b2NvbElkID0g
U01CMl9UUkFOU0ZPUk1fUFJPVE9fTlVNOwogCXRyX2hkci0+T3JpZ2luYWxNZXNzYWdlU2l6ZSA9
IGNwdV90b19sZTMyKG9yaWdfbGVuKTsKIAl0cl9oZHItPkZsYWdzID0gY3B1X3RvX2xlMTYoMHgw
MSk7Ci0JZ2V0X3JhbmRvbV9ieXRlcygmdHJfaGRyLT5Ob25jZSwgU01CM19BRVMxMjhDQ01fTk9O
Q0UpOworCWlmIChzZXJ2ZXItPmNpcGhlcl90eXBlID09IFNNQjJfRU5DUllQVElPTl9BRVMxMjhf
R0NNKQorCQlnZXRfcmFuZG9tX2J5dGVzKCZ0cl9oZHItPk5vbmNlLCBTTUIzX0FFUzEyOEdDTV9O
T05DRSk7CisJZWxzZQorCQlnZXRfcmFuZG9tX2J5dGVzKCZ0cl9oZHItPk5vbmNlLCBTTUIzX0FF
UzEyOENDTV9OT05DRSk7CiAJbWVtY3B5KCZ0cl9oZHItPlNlc3Npb25JZCwgJnNoZHItPlNlc3Np
b25JZCwgOCk7CiB9CiAKQEAgLTM0OTEsOCArMzQ5NCwxMyBAQCBjcnlwdF9tZXNzYWdlKHN0cnVj
dCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwgaW50IG51bV9ycXN0LAogCQlyYyA9IC1FTk9NRU07
CiAJCWdvdG8gZnJlZV9zZzsKIAl9Ci0JaXZbMF0gPSAzOwotCW1lbWNweShpdiArIDEsIChjaGFy
ICopdHJfaGRyLT5Ob25jZSwgU01CM19BRVMxMjhDQ01fTk9OQ0UpOworCisJaWYgKHNlcnZlci0+
Y2lwaGVyX3R5cGUgPT0gU01CMl9FTkNSWVBUSU9OX0FFUzEyOF9HQ00pCisJCW1lbWNweShpdiwg
KGNoYXIgKil0cl9oZHItPk5vbmNlLCBTTUIzX0FFUzEyOEdDTV9OT05DRSk7CisJZWxzZSB7CisJ
CWl2WzBdID0gMzsKKwkJbWVtY3B5KGl2ICsgMSwgKGNoYXIgKil0cl9oZHItPk5vbmNlLCBTTUIz
X0FFUzEyOENDTV9OT05DRSk7CisJfQogCiAJYWVhZF9yZXF1ZXN0X3NldF9jcnlwdChyZXEsIHNn
LCBzZywgY3J5cHRfbGVuLCBpdik7CiAJYWVhZF9yZXF1ZXN0X3NldF9hZChyZXEsIGFzc29jX2Rh
dGFfbGVuKTsKQEAgLTM1OTIsNyArMzYwMCw3IEBAIHNtYjNfaW5pdF90cmFuc2Zvcm1fcnEoc3Ry
dWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyLCBpbnQgbnVtX3Jxc3QsCiAJfQogCiAJLyogZmls
bCB0aGUgMXN0IGlvdiB3aXRoIGEgdHJhbnNmb3JtIGhlYWRlciAqLwotCWZpbGxfdHJhbnNmb3Jt
X2hkcih0cl9oZHIsIG9yaWdfbGVuLCBvbGRfcnEpOworCWZpbGxfdHJhbnNmb3JtX2hkcih0cl9o
ZHIsIG9yaWdfbGVuLCBvbGRfcnEsIHNlcnZlcik7CiAKIAlyYyA9IGNyeXB0X21lc3NhZ2Uoc2Vy
dmVyLCBudW1fcnFzdCwgbmV3X3JxLCAxKTsKIAljaWZzX2RiZyhGWUksICJFbmNyeXB0IG1lc3Nh
Z2UgcmV0dXJuZWQgJWRcbiIsIHJjKTsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnRyYW5zcG9y
dC5jIGIvZnMvY2lmcy9zbWIydHJhbnNwb3J0LmMKaW5kZXggZDExODE1NzI3NThiLi4xY2NiY2Y5
YzJjM2IgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnRyYW5zcG9ydC5jCisrKyBiL2ZzL2NpZnMv
c21iMnRyYW5zcG9ydC5jCkBAIC03MzQsNyArNzM0LDEwIEBAIHNtYjNfY3J5cHRvX2FlYWRfYWxs
b2NhdGUoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKQogCXN0cnVjdCBjcnlwdG9fYWVh
ZCAqdGZtOwogCiAJaWYgKCFzZXJ2ZXItPnNlY21lY2guY2NtYWVzZW5jcnlwdCkgewotCQl0Zm0g
PSBjcnlwdG9fYWxsb2NfYWVhZCgiY2NtKGFlcykiLCAwLCAwKTsKKwkJaWYgKHNlcnZlci0+Y2lw
aGVyX3R5cGUgPT0gU01CMl9FTkNSWVBUSU9OX0FFUzEyOF9HQ00pCisJCQl0Zm0gPSBjcnlwdG9f
YWxsb2NfYWVhZCgiZ2NtKGFlcykiLCAwLCAwKTsKKwkJZWxzZQorCQkJdGZtID0gY3J5cHRvX2Fs
bG9jX2FlYWQoImNjbShhZXMpIiwgMCwgMCk7CiAJCWlmIChJU19FUlIodGZtKSkgewogCQkJY2lm
c19kYmcoVkZTLCAiJXM6IEZhaWxlZCB0byBhbGxvYyBlbmNyeXB0IGFlYWRcbiIsCiAJCQkJIF9f
ZnVuY19fKTsKQEAgLTc0NCw3ICs3NDcsMTAgQEAgc21iM19jcnlwdG9fYWVhZF9hbGxvY2F0ZShz
dHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIpCiAJfQogCiAJaWYgKCFzZXJ2ZXItPnNlY21l
Y2guY2NtYWVzZGVjcnlwdCkgewotCQl0Zm0gPSBjcnlwdG9fYWxsb2NfYWVhZCgiY2NtKGFlcyki
LCAwLCAwKTsKKwkJaWYgKHNlcnZlci0+Y2lwaGVyX3R5cGUgPT0gU01CMl9FTkNSWVBUSU9OX0FF
UzEyOF9HQ00pCisJCQl0Zm0gPSBjcnlwdG9fYWxsb2NfYWVhZCgiZ2NtKGFlcykiLCAwLCAwKTsK
KwkJZWxzZQorCQkJdGZtID0gY3J5cHRvX2FsbG9jX2FlYWQoImNjbShhZXMpIiwgMCwgMCk7CiAJ
CWlmIChJU19FUlIodGZtKSkgewogCQkJY3J5cHRvX2ZyZWVfYWVhZChzZXJ2ZXItPnNlY21lY2gu
Y2NtYWVzZW5jcnlwdCk7CiAJCQlzZXJ2ZXItPnNlY21lY2guY2NtYWVzZW5jcnlwdCA9IE5VTEw7
Ci0tIAoyLjE3LjEud2luZG93cy4yCgo=
--00000000000062eb17058afbdeb6--
