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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 682AEC433E9
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Feb 2021 02:00:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D31D64EB4
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Feb 2021 02:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbhBICAL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Feb 2021 21:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbhBICAG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Feb 2021 21:00:06 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B042AC06178C
        for <linux-cifs@vger.kernel.org>; Mon,  8 Feb 2021 17:59:26 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id b187so16602575ybg.9
        for <linux-cifs@vger.kernel.org>; Mon, 08 Feb 2021 17:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wkFu6j20qT24lI/DQTQB7IOg0jmPYgUy5imafrfPnN0=;
        b=n6DYAuHGAa3dAjfVcT3dvaFLajX9uy2Vqz4JJqmGEo8UplGNbkW+Q6JbDZm8U84XWt
         BBtzN6HjHfF8cyeYcybmTbdeVpFPrDsUbgSlfN2WnhTsHEY0SWWeBLx3bTtqkVpg1EB1
         harOmReAlVDLoc+aYVdvRJd9MicQg3gD4f8B46x9puCt5/DI7T4TDYqBdhQ3HZnp2hqq
         2UimZHZ606KhmP5TDVG5Ryc/8Ptg6kDtsvHPCWbTzPGqs5VdYi9aUt9Fj591qdIxM8yn
         74mVUIjJNAJUf/jQUOlyWKdKvPg/aAPvbZoH4bJ4s/1y8xYqH/QxJV6/FahuHgnDCWeU
         7UTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wkFu6j20qT24lI/DQTQB7IOg0jmPYgUy5imafrfPnN0=;
        b=SMI1VDvEDkorY8iSJ5o20cnFsZQ9e8vlXyR9HsTvbf7xmjWMjQ2w4+yNEIbTnui1qn
         iCGZw08wYevLelnFL2Vvq1+KiBEUWv1Xb4do5QSvdDffYS3R7cLpVdL+SSi3MIpygeI9
         uvB2DGFq+wqUKFAw+v92ojiZbk/48a5dt4+Yn/6DQBrvJESkDWYXi69Onr25MI1GEBRv
         dBluhsi+uwvoHsrP0yYfBy4cmZXkO8hiCGeYY+Z1bH1KqQmdj3pfIx6GZULHwIrApZIp
         8DJGdI1fhpWG2pTYqE6Q/V4qe24W3bZTINm5CaBqksXrYFo9kOUK6hqxJZ6xvjCmiWj6
         PRZg==
X-Gm-Message-State: AOAM531fLLIgbJCeuw1B8foYrH2yn/wzu+OTzODRBaj7nFGI7F0QdyZP
        UkF5OvdgWUXk04WOn+IFtx/D4NByCsGuaKRomxMQp6RlejP+Ug==
X-Google-Smtp-Source: ABdhPJxISr25LakCbDH9fA5BaEBuoPa7fGLTIaBDM4aOhJ0VsrP7Yzf7AMA1GCefwj3wfdZNjLOZwF7wbGz244ZFg24=
X-Received: by 2002:a25:380e:: with SMTP id f14mr28874730yba.185.1612835965899;
 Mon, 08 Feb 2021 17:59:25 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=qrx1bKAcJGG=hGBkvwHjQWLgTH3kJ+g-YdZL0yfBtA9A@mail.gmail.com>
 <87mtwkno7q.fsf@suse.com>
In-Reply-To: <87mtwkno7q.fsf@suse.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 8 Feb 2021 17:59:15 -0800
Message-ID: <CANT5p=qeEBwivE_Fc-Y4gj17d9nkU+ROPnZL=0BD3v_yRNBFtA@mail.gmail.com>
Subject: Re: [PATCH 1/4] cifs: New optype for session operations.
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000d4dbd105badda271"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000d4dbd105badda271
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I had missed one check where CIFS_SESS_OP also had to be checked. Not
doing so would disable echoes and oplocks.
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index f19274857292..43331555fcc5 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -84,7 +84,7 @@ smb2_add_credits(struct TCP_Server_Info *server,
                pr_warn_once("server overflowed SMB3 credits\n");
        }
        server->in_flight--;
-       if (server->in_flight =3D=3D 0 && (optype & CIFS_OP_MASK) !=3D CIFS=
_NEG_OP)
+       if (server->in_flight =3D=3D 0 && (optype & CIFS_OP_MASK) !=3D
CIFS_NEG_OP && (optype & CIFS_OP_MASK) !=3D CIFS_SESS_OP)
                rc =3D change_conf(server);
        /*
         * Sometimes server returns 0 credits on oplock break ack - we need=
 to

Attaching a revised patch (one line correction in the old one).

Regards,
Shyam

On Thu, Feb 4, 2021 at 2:04 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
>
> LGTM
>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>


--=20
Regards,
Shyam

--000000000000d4dbd105badda271
Content-Type: application/octet-stream; 
	name="0001-cifs-New-optype-for-session-operations.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-New-optype-for-session-operations.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kkxcvrps0>
X-Attachment-Id: f_kkxcvrps0

RnJvbSAwZTYyMDEwZjFhZGE0YzQ4ZTU1NzEwZDM4NGRiYTQ1MzhmMTY2ZDhmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBXZWQsIDMgRmViIDIwMjEgMjI6NDk6NTIgLTA4MDAKU3ViamVjdDogW1BBVENIIDEv
NF0gY2lmczogTmV3IG9wdHlwZSBmb3Igc2Vzc2lvbiBvcGVyYXRpb25zLgoKV2UgdXNlZCB0byBz
aGFyZSB0aGUgQ0lGU19ORUdfT1AgZmxhZyBiZXR3ZWVuIG5lZ290aWF0ZSBhbmQKc2Vzc2lvbiBh
dXRoZW50aWNhdGlvbi4gVGhlcmUgd2FzIGFuIGFzc3VtcHRpb24gaW4gdGhlIGNvZGUgdGhhdApD
SUZTX05FR19PUCBpcyB1c2VkIGJ5IG5lZ290aWF0ZSBvbmx5LiBTbyBpbnRyb2N1ZGVkIENJRlNf
U0VTU19PUAphbmQgdXNlZCBpdCBmb3Igc2Vzc2lvbiBzZXR1cCBvcHR5cGVzLgoKU2lnbmVkLW9m
Zi1ieTogU2h5YW0gUHJhc2FkIE4gPHNwcmFzYWRAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZz
L2NpZnNnbG9iLmggIHwgMyArKy0KIGZzL2NpZnMvc21iMm9wcy5jICAgfCAyICstCiBmcy9jaWZz
L3NtYjJwZHUuYyAgIHwgMiArLQogZnMvY2lmcy90cmFuc3BvcnQuYyB8IDQgKystLQogNCBmaWxl
cyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
ZnMvY2lmcy9jaWZzZ2xvYi5oIGIvZnMvY2lmcy9jaWZzZ2xvYi5oCmluZGV4IDUwZmNiNjU5MjBl
OC4uMWExZjlmNGFlODBhIDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNnbG9iLmgKKysrIGIvZnMv
Y2lmcy9jaWZzZ2xvYi5oCkBAIC0xNzA0LDcgKzE3MDQsOCBAQCBzdGF0aWMgaW5saW5lIGJvb2wg
aXNfcmV0cnlhYmxlX2Vycm9yKGludCBlcnJvcikKICNkZWZpbmUgICBDSUZTX0VDSE9fT1AgICAg
ICAweDA4MCAgICAvKiBlY2hvIHJlcXVlc3QgKi8KICNkZWZpbmUgICBDSUZTX09CUkVBS19PUCAg
IDB4MDEwMCAgICAvKiBvcGxvY2sgYnJlYWsgcmVxdWVzdCAqLwogI2RlZmluZSAgIENJRlNfTkVH
X09QICAgICAgMHgwMjAwICAgIC8qIG5lZ290aWF0ZSByZXF1ZXN0ICovCi0jZGVmaW5lICAgQ0lG
U19PUF9NQVNLICAgICAweDAzODAgICAgLyogbWFzayByZXF1ZXN0IHR5cGUgKi8KKyNkZWZpbmUg
ICBDSUZTX1NFU1NfT1AgICAgIDB4MjAwMCAgICAvKiBzZXNzaW9uIHNldHVwIHJlcXVlc3QgKi8K
KyNkZWZpbmUgICBDSUZTX09QX01BU0sgICAgIDB4MjM4MCAgICAvKiBtYXNrIHJlcXVlc3QgdHlw
ZSAqLwogCiAjZGVmaW5lICAgQ0lGU19IQVNfQ1JFRElUUyAweDA0MDAgICAgLyogYWxyZWFkeSBo
YXMgY3JlZGl0cyAqLwogI2RlZmluZSAgIENJRlNfVFJBTlNGT1JNX1JFUSAweDA4MDAgICAgLyog
dHJhbnNmb3JtIHJlcXVlc3QgYmVmb3JlIHNlbmRpbmcgKi8KZGlmZiAtLWdpdCBhL2ZzL2NpZnMv
c21iMm9wcy5jIGIvZnMvY2lmcy9zbWIyb3BzLmMKaW5kZXggZjE5Mjc0ODU3MjkyLi40MzMzMTU1
NWZjYzUgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMm9wcy5jCisrKyBiL2ZzL2NpZnMvc21iMm9w
cy5jCkBAIC04NCw3ICs4NCw3IEBAIHNtYjJfYWRkX2NyZWRpdHMoc3RydWN0IFRDUF9TZXJ2ZXJf
SW5mbyAqc2VydmVyLAogCQlwcl93YXJuX29uY2UoInNlcnZlciBvdmVyZmxvd2VkIFNNQjMgY3Jl
ZGl0c1xuIik7CiAJfQogCXNlcnZlci0+aW5fZmxpZ2h0LS07Ci0JaWYgKHNlcnZlci0+aW5fZmxp
Z2h0ID09IDAgJiYgKG9wdHlwZSAmIENJRlNfT1BfTUFTSykgIT0gQ0lGU19ORUdfT1ApCisJaWYg
KHNlcnZlci0+aW5fZmxpZ2h0ID09IDAgJiYgKG9wdHlwZSAmIENJRlNfT1BfTUFTSykgIT0gQ0lG
U19ORUdfT1AgJiYgKG9wdHlwZSAmIENJRlNfT1BfTUFTSykgIT0gQ0lGU19TRVNTX09QKQogCQly
YyA9IGNoYW5nZV9jb25mKHNlcnZlcik7CiAJLyoKIAkgKiBTb21ldGltZXMgc2VydmVyIHJldHVy
bnMgMCBjcmVkaXRzIG9uIG9wbG9jayBicmVhayBhY2sgLSB3ZSBuZWVkIHRvCmRpZmYgLS1naXQg
YS9mcy9jaWZzL3NtYjJwZHUuYyBiL2ZzL2NpZnMvc21iMnBkdS5jCmluZGV4IGUxMzkxYmQ5Mjc2
OC4uNGJiYjYxMjZiMTRkIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuYworKysgYi9mcy9j
aWZzL3NtYjJwZHUuYwpAQCAtMTI2MSw3ICsxMjYxLDcgQEAgU01CMl9zZXNzX3NlbmRyZWNlaXZl
KHN0cnVjdCBTTUIyX3Nlc3NfZGF0YSAqc2Vzc19kYXRhKQogCQkJICAgIGNpZnNfc2VzX3NlcnZl
cihzZXNzX2RhdGEtPnNlcyksCiAJCQkgICAgJnJxc3QsCiAJCQkgICAgJnNlc3NfZGF0YS0+YnVm
MF90eXBlLAotCQkJICAgIENJRlNfTE9HX0VSUk9SIHwgQ0lGU19ORUdfT1AsICZyc3BfaW92KTsK
KwkJCSAgICBDSUZTX0xPR19FUlJPUiB8IENJRlNfU0VTU19PUCwgJnJzcF9pb3YpOwogCWNpZnNf
c21hbGxfYnVmX3JlbGVhc2Uoc2Vzc19kYXRhLT5pb3ZbMF0uaW92X2Jhc2UpOwogCW1lbWNweSgm
c2Vzc19kYXRhLT5pb3ZbMF0sICZyc3BfaW92LCBzaXplb2Yoc3RydWN0IGt2ZWMpKTsKIApkaWZm
IC0tZ2l0IGEvZnMvY2lmcy90cmFuc3BvcnQuYyBiL2ZzL2NpZnMvdHJhbnNwb3J0LmMKaW5kZXgg
NGEyYjgzNmViMDE3Li40MTIyM2E5ZWUwODYgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvdHJhbnNwb3J0
LmMKKysrIGIvZnMvY2lmcy90cmFuc3BvcnQuYwpAQCAtMTE3MSw3ICsxMTcxLDcgQEAgY29tcG91
bmRfc2VuZF9yZWN2KGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3NlcyAqc2Vz
LAogCS8qCiAJICogQ29tcG91bmRpbmcgaXMgbmV2ZXIgdXNlZCBkdXJpbmcgc2Vzc2lvbiBlc3Rh
Ymxpc2guCiAJICovCi0JaWYgKChzZXMtPnN0YXR1cyA9PSBDaWZzTmV3KSB8fCAob3B0eXBlICYg
Q0lGU19ORUdfT1ApKQorCWlmICgoc2VzLT5zdGF0dXMgPT0gQ2lmc05ldykgfHwgKG9wdHlwZSAm
IENJRlNfTkVHX09QKSB8fCAob3B0eXBlICYgQ0lGU19TRVNTX09QKSkKIAkJc21iMzExX3VwZGF0
ZV9wcmVhdXRoX2hhc2goc2VzLCBycXN0WzBdLnJxX2lvdiwKIAkJCQkJICAgcnFzdFswXS5ycV9u
dmVjKTsKIApAQCAtMTIzNiw3ICsxMjM2LDcgQEAgY29tcG91bmRfc2VuZF9yZWN2KGNvbnN0IHVu
c2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3NlcyAqc2VzLAogCS8qCiAJICogQ29tcG91bmRp
bmcgaXMgbmV2ZXIgdXNlZCBkdXJpbmcgc2Vzc2lvbiBlc3RhYmxpc2guCiAJICovCi0JaWYgKChz
ZXMtPnN0YXR1cyA9PSBDaWZzTmV3KSB8fCAob3B0eXBlICYgQ0lGU19ORUdfT1ApKSB7CisJaWYg
KChzZXMtPnN0YXR1cyA9PSBDaWZzTmV3KSB8fCAob3B0eXBlICYgQ0lGU19ORUdfT1ApIHx8IChv
cHR5cGUgJiBDSUZTX1NFU1NfT1ApKSB7CiAJCXN0cnVjdCBrdmVjIGlvdiA9IHsKIAkJCS5pb3Zf
YmFzZSA9IHJlc3BfaW92WzBdLmlvdl9iYXNlLAogCQkJLmlvdl9sZW4gPSByZXNwX2lvdlswXS5p
b3ZfbGVuCi0tIAoyLjI1LjEKCg==
--000000000000d4dbd105badda271--
