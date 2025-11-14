Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2DAB661
	for <linux-cifs@vger.kernel.org>; Fri, 14 Nov 2025 09:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763112492; cv=none; b=Kivw5viznK4mCv5sThG0MGB59qFM8UooZrGohx0rYzDXEjTHZvNr94smU/c7muaikqEiiNVJN2M8DCO7YPlK0nA9dOsDAxpORoxy/llEPElBbUAoEMCbOsJwlf1/oTkzvvQ/7gWc/ANTQLwHWj1X9nHs/9jn0c5PAYhBWEPQlO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763112492; c=relaxed/simple;
	bh=esXq5wxECpsNWfI9vaYmWtYiFRr/tUzw6coisR+VX0A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I4NOiI1uvAb8h2TysmIZpXsVbFXYqoNsAf37BlQV85O5D1SPwF3d6raHfySLkKSy6cYh5ba9gw5x7Se2ekd1rdHzJ2hvP6FtK+cB7tVUKYHLA5DsaiEk3nbwUOi2gtOhk7b0R+nlc1XrqyP/wHcxhUxuF41KD9ncWQBTyGVIcHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DYzSuRxS; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DYzSuRxS"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b7291af7190so261008566b.3
        for <linux-cifs@vger.kernel.org>; Fri, 14 Nov 2025 01:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763112485; x=1763717285; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yHr4Mn3mU7OuZEQfB9+HTk6+fkEhAgx1NJ45L//3rj0=;
        b=DYzSuRxSLIJhbMZYdCWoYtdk7Cu4hgirf/7iRLMqyOe7RtePhsKRIPORUzgRmwj7Cz
         IlBCyIAd88YhpMJLAewxqkHvyW7S3bHEIQVqEXqPH9K3OMPO3Tymd3OY8OGDfcuLTLcE
         uQEwXdA+zbVu5bqhaASMrd2RY+PQN4evQZ86qB9epQmIdE3PWsLJooTye5nut+SRTCjw
         0DwlTr3g3VidgqbwOubFVEfyUp6ulrKVDUzjZWOwyb2HHqM8c+I5g0GpCcVPCGPe4kTc
         dib7/AvuZhS+aJt1apsg4JvzPr3xyTH5SD9eV4bJSKoZzdOVOm6CNFRlrFyVwQGhuDly
         0aYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763112485; x=1763717285;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yHr4Mn3mU7OuZEQfB9+HTk6+fkEhAgx1NJ45L//3rj0=;
        b=Tt+KSodZ/nId4x6n0gHZNYwdnukiDCE6zXeepuZF2ke5rPd1aUr54RTdVqvGkvEUDK
         Ukm7KlaoLFpMGk7AlBdr4k9C/H2vQP0wSSdUmCRxkPTNbcQY+LREhescFUN6i+la287N
         0cKFNFWjzd4wI15SF0yXTh22kC7q3p0rqvcTvJ7c+lkujcGnSGKBIqjLdZCiLiR9De0U
         P6GPvbZUHYYcvzhSdQNhcOsYfgzIG8V3sbDFjo7BR0aeHu72WMSYObuO3TKB8XSLIwc6
         jRJ1J0oMcMGpOgnJscMv8ZhXCPk/SMNutE2WQkUdu+GSZr7DemlzfREgAVizPGRSGsxs
         SjDA==
X-Forwarded-Encrypted: i=1; AJvYcCVXGylOZt/qnrjKP9WhlPvjvGQl0hDiNqEr3qcF3K5rhyJ8y6jK1C/EwVi4kWQ46GlFstzeU5dUmEPN@vger.kernel.org
X-Gm-Message-State: AOJu0YxKpDm0fEkOErCYqDFXAIq6HEMFUNFBOLibQXpUFtUJ2ZLfPQd1
	CneFLisnD3TITuEFzm+c2a/nk69t+uVQISQOllx+44T5iPzUkUaVrjw8pt6RVV0o75cT/TvFnm4
	KGkT4kvM7+9uwVbeCLVmtE8PkFLJWBh0=
X-Gm-Gg: ASbGncvClSPHQatY6Cf0kfGqXn5JCmSkl/sRB9mtCXlTAH1jzpXXCyw0tViD/nokBWw
	ebIALWHUBGvGm/8X1qD8WS0AyUFj71m0wjDuP5Dqu6pgfTSPFPNBg+8u4rtTtKP7jhUteJjcQ36
	qjUfcWO4tE1ZCHmJW1s02K+eSl2ufzUt0Q788b0TwV5Q5j7pT5XbheqPSCkTgvU47JpKrHptWMX
	rxrTZVseC9lAdEUttQZzbDk/8FBGBtq5md6adeTzC4zf1QWDKQaJ98NlEA=
X-Google-Smtp-Source: AGHT+IGGNCd4p0sJX/4gp7exDY80VoS2WtVFIY6zapDFmz02C1lJT6KKjyX12J3HUgrQWFiw1mcwgyrYVr5mOIDWlfk=
X-Received: by 2002:a17:907:7f9f:b0:b71:f9d5:70d5 with SMTP id
 a640c23a62f3a-b73678369aemr213167866b.27.1763112484700; Fri, 14 Nov 2025
 01:28:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <YT1PR01MB9451424C6870795133FB7C96B3A72@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <36fb31bf2c854cdc930a3415f5551dcd@izw-berlin.de> <CAH2r5mtNtyqZBpT8hL2xvZ8QYWAymrPR-5LmpZbeTHr_1ATPWg@mail.gmail.com>
 <uildcjpqxzc5nckupgdeeifkrqwrau2qxuc2df2uxuyys3i2k2@iz2bmi6yojyu>
 <YT1PR01MB945191C652AEE173CEADBA3EB3A12@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <aaloi77h2f5xolhrnegxsxntqp2jopwisunmjfp45idsoockpy@cy5agf2oqjop>
 <YT1PR01MB9451A0F623371F50E77CC1C9B3AD2@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <CAGypqWw0bnE7_=49HSxgExouk4s5PVFQ6gVH50wrE8_=4b5vAg@mail.gmail.com>
 <958479.1762852948@warthog.procyon.org.uk> <CANT5p=rh7BQBnwNYLxHtFw=YUhAGVnskJ=33i6Eg4porU-X+5A@mail.gmail.com>
 <CANT5p=px8Lh1C2O0F8i1htoMACWZbLPfw0NEzUco5Njss2c7pQ@mail.gmail.com>
 <1392200.1762971247@warthog.procyon.org.uk> <CANT5p=p4KSRsCAB-peTKehvsYYiuOxy3qLNDO9j5H+5PP_eiyw@mail.gmail.com>
 <1640439.1763042251@warthog.procyon.org.uk>
In-Reply-To: <1640439.1763042251@warthog.procyon.org.uk>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 14 Nov 2025 14:57:52 +0530
X-Gm-Features: AWmQ_bmmuR-DnvnrMa_3-8yoPtpRnIKsLFKXqzbYGrdFjoVL11D2uW5mo_3C8mc
Message-ID: <CANT5p=pye46OnCQB+DB=ts7PkZS-bCpC+cURC1HnptmSwApX-Q@mail.gmail.com>
Subject: Re: [[ EXT ]] [BUG REPORT] cifs/smb data corruption when writing,
 x86_64, kernel 6.6.71
To: David Howells <dhowells@redhat.com>
Cc: Bharath SM <bharathsm.hsk@gmail.com>, Mark A Whiting <whitingm@opentext.com>, 
	henrique.carvalho@suse.com, Enzo Matsumiya <ematsumiya@suse.de>, 
	Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@manguebit.org>, 
	"Heckmann, Ilja" <heckmann@izw-berlin.de>, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000059c4b606438a9d03"

--00000000000059c4b606438a9d03
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 7:27=E2=80=AFPM David Howells <dhowells@redhat.com>=
 wrote:
>
> Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> > +
> > +                     /* boundary check before the folio is accounted *=
/
> > +                     if ((max_pages - nr_pages) <=3D 0 ||
> > +                         (*_len + len) >=3D max_len ||
> > +                         (*_count - nr_pages) <=3D 0) {
> > +                             folio_unlock(folio);
> > +                             folio_put(folio);
> > +                             xas_reset(xas);
> > +                             break;
> > +                     }
> > +
>
> I suspect that whilst this will work, it will mean that you can never app=
end a
> partial page to a write op; a partial page will always have to start a ne=
w RPC
> call.
>
> So if you do:
>
>         fd =3D open("/cifs/foo");
>         write(fd, buf, 0x1001);
>         close(fd);
>
> it will make two Write ops, one for 4K and one for 1 byte (give or take
> PAGE_SIZE=3D=3D4096).
>
> David
>

Spoke to David yesterday to discuss this more.
David: Here's a patch with the changes like you suggested. This fixes
the corruption and has not affected other write patterns in my
testing.
Please let me know if I can add your "Reviewed-by" and submit to stable tod=
ay.

--=20
Regards,
Shyam

--00000000000059c4b606438a9d03
Content-Type: application/octet-stream; 
	name="0001-cifs-stop-writeback-extension-when-change-of-size-is.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-stop-writeback-extension-when-change-of-size-is.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mhynivsk0>
X-Attachment-Id: f_mhynivsk0

RnJvbSBjNDQ5NGY3YWQ3YzBkZDQ2YjY3ZGM2NzA1ODUwNzI3OGU1NmM5MzExIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBGcmksIDE0IE5vdiAyMDI1IDE0OjMwOjU1ICswNTMwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogc3RvcCB3cml0ZWJhY2sgZXh0ZW5zaW9uIHdoZW4gY2hhbmdlIG9mIHNpemUgaXMKIGRl
dGVjdGVkCgpjaWZzX2V4dGVuZF93cml0ZWJhY2sgY2FuIHBpY2sgdXAgYSBmb2xpbyBvbiBhbiBl
eHRlbmRpbmcgd3JpdGUgd2hpY2gKaGFzIGJlZW4gZGlydGllZCwgYnV0IHdlIGhhdmUgYWNsYW1w
IG9uIHRoZSB3cml0ZWJhY2sgdG8gYW4gaV9zaXplCmxvY2FsIHZhcmlhYmxlLCB3aGljaCBjYW4g
Y2F1c2Ugc2hvcnQgd3JpdGVzLCB5ZXQgbWFyayB0aGUgcGFnZSBhcyBjbGVhbi4KVGhpcyBjYW4g
Y2F1c2UgYSBkYXRhIGNvcnJ1cHRpb24uCgpBcyBhbiBleGFtcGxlLCBjb25zaWRlciB0aGlzIHNj
ZW5hcmlvOgoxLiBGaXJzdCB3cml0ZSB0byB0aGUgZmlsZSBoYXBwZW5zIG9mZnNldCAwIGxlbiA1
ay4KMi4gV3JpdGViYWNrIHN0YXJ0cyBmb3IgdGhlIHJhbmdlICgwLTVrKS4KMy4gV3JpdGViYWNr
IGxvY2tzIHBhZ2UgMSBpbiBjaWZzX3dyaXRlcGFnZXNfYmVnaW4uIEJ1dCBkb2VzIG5vdCBsb2Nr
CnBhZ2UgMiB5ZXQuCjQuIFBhZ2UgMiBpcyBub3cgd3JpdHRlbiB0byBieSB0aGUgbmV4dCB3cml0
ZSwgd2hpY2ggZXh0ZW5kcyB0aGUgZmlsZQpieSBhbm90aGVyIDVrLiBQYWdlIDIgYW5kIDMgYXJl
IG5vdyBtYXJrZWQgZGlydHkuCjUuIE5vdyB3ZSByZWFjaCBjaWZzX2V4dGVuZF93cml0ZWJhY2ss
IHdoZXJlIHdlIGV4dGVuZCB0byBpbmNsdWRlIHRoZQpuZXh0IGZvbGlvIChldmVuIGlmIGl0IHNo
b3VsZCBiZSBwYXJ0aWFsbHkgd3JpdHRlbikuIFdlIHdpbGwgbWFyayBwYWdlCjIgZm9yIHdyaXRl
YmFjay4KNi4gQnV0IGFmdGVyIGV4aXRpbmcgY2lmc19leHRlbmRfd3JpdGViYWNrLCB3ZSB3aWxs
IGNsYW1wIHRoZQp3cml0ZWJhY2sgdG8gaV9zaXplLCB3aGljaCB3YXMgNWsgd2hlbiBpdCBzdGFy
dGVkLiBTbyB3ZSB3cml0ZSBvbmx5IDFrCmJ5dGVzIGluIHBhZ2UgMi4KNy4gV2Ugc3RpbGwgd2ls
bCBub3cgbWFyayBwYWdlIDIgYXMgZmx1c2hlZCBhbmQgbWFyayBpdCBjbGVhbi4gU28KcmVtYWlu
aW5nIGNvbnRlbnRzIG9mIHBhZ2UgMiB3aWxsIG5vdCBiZSB3cml0dGVuIHRvIHRoZSBzZXJ2ZXIg
KGhlbmNlCnRoZSBob2xlIGluIHRoYXQgZ2FwLCB1bmxlc3MgdGhhdCByYW5nZSBnZXRzIG92ZXJ3
cml0dGVuKS4KCldpdGggdGhpcyBwYXRjaCwgd2Ugd2lsbCBtYWtlIHN1cmUgbm90IGV4dGVuZCB0
aGUgd3JpdGViYWNrIGFueW1vcmUKd2hlbiBhIGNoYW5nZSBpbiB0aGUgZmlsZSBzaXplIGlzIGRl
dGVjdGVkLgoKVGhpcyBmaXggYWxzbyBjaGFuZ2VzIHRoZSBlcnJvciBoYW5kbGluZyBvZiBjaWZz
X2V4dGVuZF93cml0ZWJhY2sgd2hlbgphIGZvbGlvIGdldCBmYWlscy4gV2Ugd2lsbCBub3cgc3Rv
cCB0aGUgZXh0ZW5zaW9uIHdoZW4gYSBmb2xpbyBnZXQgZmFpbHMuCgpDYzogc3RhYmxlQGtlcm5l
bC5vcmcgIyB2Ni4zfnY2LjkKU2lnbmVkLW9mZi1ieTogU2h5YW0gUHJhc2FkIE4gPHNwcmFzYWRA
bWljcm9zb2Z0LmNvbT4KU3VnZ2VzdGVkLWJ5OiBEYXZpZCBIb3dlbGxzIDxkaG93ZWxsc0ByZWRo
YXQuY29tPgpSZXBvcnRlZC1ieTogTWFyayBBIFdoaXRpbmcgPHdoaXRpbmdtQG9wZW50ZXh0LmNv
bT4KU2lnbmVkLW9mZi1ieTogU2h5YW0gUHJhc2FkIE4gPHNwcmFzYWRAbWljcm9zb2Z0LmNvbT4K
LS0tCiBmcy9zbWIvY2xpZW50L2ZpbGUuYyB8IDE4ICsrKysrKysrKysrKysrKy0tLQogMSBmaWxl
IGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
ZnMvc21iL2NsaWVudC9maWxlLmMgYi9mcy9zbWIvY2xpZW50L2ZpbGUuYwppbmRleCA3YTJiODFm
YmQ5Y2ZkLi5jYzJiYTJiMThjOGQ0IDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2ZpbGUuYwor
KysgYi9mcy9zbWIvY2xpZW50L2ZpbGUuYwpAQCAtMjc0Nyw4ICsyNzQ3LDEwIEBAIHN0YXRpYyB2
b2lkIGNpZnNfZXh0ZW5kX3dyaXRlYmFjayhzdHJ1Y3QgYWRkcmVzc19zcGFjZSAqbWFwcGluZywK
IAkJCQkgIGxvZmZfdCBzdGFydCwKIAkJCQkgIGludCBtYXhfcGFnZXMsCiAJCQkJICBsb2ZmX3Qg
bWF4X2xlbiwKLQkJCQkgIHNpemVfdCAqX2xlbikKKwkJCQkgIHNpemVfdCAqX2xlbiwKKwkJCQkg
IHVuc2lnbmVkIGxvbmcgbG9uZyBpX3NpemUpCiB7CisJc3RydWN0IGlub2RlICppbm9kZSA9IG1h
cHBpbmctPmhvc3Q7CiAJc3RydWN0IGZvbGlvX2JhdGNoIGJhdGNoOwogCXN0cnVjdCBmb2xpbyAq
Zm9saW87CiAJdW5zaWduZWQgaW50IG5yX3BhZ2VzOwpAQCAtMjc3OSw3ICsyNzgxLDcgQEAgc3Rh
dGljIHZvaWQgY2lmc19leHRlbmRfd3JpdGViYWNrKHN0cnVjdCBhZGRyZXNzX3NwYWNlICptYXBw
aW5nLAogCiAJCQlpZiAoIWZvbGlvX3RyeV9nZXQoZm9saW8pKSB7CiAJCQkJeGFzX3Jlc2V0KHhh
cyk7Ci0JCQkJY29udGludWU7CisJCQkJYnJlYWs7CiAJCQl9CiAJCQlucl9wYWdlcyA9IGZvbGlv
X25yX3BhZ2VzKGZvbGlvKTsKIAkJCWlmIChucl9wYWdlcyA+IG1heF9wYWdlcykgewpAQCAtMjc5
OSw2ICsyODAxLDE1IEBAIHN0YXRpYyB2b2lkIGNpZnNfZXh0ZW5kX3dyaXRlYmFjayhzdHJ1Y3Qg
YWRkcmVzc19zcGFjZSAqbWFwcGluZywKIAkJCQl4YXNfcmVzZXQoeGFzKTsKIAkJCQlicmVhazsK
IAkJCX0KKworCQkJLyogaWYgZmlsZSBzaXplIGlzIGNoYW5naW5nLCBzdG9wIGV4dGVuZGluZyAq
LworCQkJaWYgKGlfc2l6ZV9yZWFkKGlub2RlKSAhPSBpX3NpemUpIHsKKwkJCQlmb2xpb191bmxv
Y2soZm9saW8pOworCQkJCWZvbGlvX3B1dChmb2xpbyk7CisJCQkJeGFzX3Jlc2V0KHhhcyk7CisJ
CQkJYnJlYWs7CisJCQl9CisKIAkJCWlmICghZm9saW9fdGVzdF9kaXJ0eShmb2xpbykgfHwKIAkJ
CSAgICBmb2xpb190ZXN0X3dyaXRlYmFjayhmb2xpbykpIHsKIAkJCQlmb2xpb191bmxvY2soZm9s
aW8pOwpAQCAtMjkzMCw3ICsyOTQxLDggQEAgc3RhdGljIHNzaXplX3QgY2lmc193cml0ZV9iYWNr
X2Zyb21fbG9ja2VkX2ZvbGlvKHN0cnVjdCBhZGRyZXNzX3NwYWNlICptYXBwaW5nLAogCiAJCQlp
ZiAobWF4X3BhZ2VzID4gMCkKIAkJCQljaWZzX2V4dGVuZF93cml0ZWJhY2sobWFwcGluZywgeGFz
LCAmY291bnQsIHN0YXJ0LAotCQkJCQkJICAgICAgbWF4X3BhZ2VzLCBtYXhfbGVuLCAmbGVuKTsK
KwkJCQkJCSAgICAgIG1heF9wYWdlcywgbWF4X2xlbiwgJmxlbiwKKwkJCQkJCSAgICAgIGlfc2l6
ZSk7CiAJCX0KIAl9CiAJbGVuID0gbWluX3QodW5zaWduZWQgbG9uZyBsb25nLCBsZW4sIGlfc2l6
ZSAtIHN0YXJ0KTsKLS0gCjIuNDMuMAoK
--00000000000059c4b606438a9d03--
