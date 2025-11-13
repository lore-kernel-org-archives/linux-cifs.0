Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E040338F54
	for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 12:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763035496; cv=none; b=lbQbrI9MtesiP6mYJZqMr2HZhRkT1AetDXEM2fv1jXXVUeVUtEw+X1boeIPcy+uRhAfmnOBkGBJfZPuUVt2KSiWTnlrpx4TzrMICT15kD4Pa2IXSUE2YS4/dzG6RLx+h5r+WnpKEMZ0lBH8feIkPzTEYzegdp351KTpXiEgpSpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763035496; c=relaxed/simple;
	bh=QzzBqDF5/xLJ9B6qVM79inL2YYfdqVq/JL12c9SmHLo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gRsbVz2e+k2Pqu5yHDtVo0mO6smi4Wmlyu9/bsv4vgDKIYdkv6FGShLn046b643AYv/O1zL9B5evZK6UC+sthWeYLb3PyiADErZEkoGye5ACQGUWA5kco2UUaX51jgc0z/3LqlrCceiM1B92ku93NFMAJxupYJ3VAM9G6/MtFGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RLDlvUap; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RLDlvUap"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b728a43e410so110566966b.1
        for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 04:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763035493; x=1763640293; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cZ9o9+b7ZfoR4zVo9+P4q/NSoxMMP4glOQokhYHLxnM=;
        b=RLDlvUapkRLUqxROKgO8ciS4v6kItqXXbOixd5JWlK5pMyRujytn3+uVwYVZADgCtS
         YLX7gSNlTjPUtqA2xzQtci0s2J4olowOoT2dQRx7Zs7WhlZFeZHv8Zv4YPmLEeKYMQ1g
         F/gvlycSeg1sWrbqUsh/5Lm8nJhJiM+Fzjp9STlPFV/9pw710cBEzgpaoENBXyONCmur
         Hs+qOSG20TQ+9LV+flNreWnLDb4hHK3rq52yxOHE0Oar266mXDTBknM7+8AL3Dn0+D1U
         1hnbWZSC8eMlQJLySdKtziHyqJCqSng+NXXlecx1wAcWrUK4b/L4sZ7JO3d55IoWQdxm
         L+Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763035493; x=1763640293;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cZ9o9+b7ZfoR4zVo9+P4q/NSoxMMP4glOQokhYHLxnM=;
        b=r4TIcD7BwNGI5LUkT+x7Q31M0JM4Px9x/C75TrL6EZGmozTV/Ip1kF4h7iIHgz36UM
         KEPugTL+t+NphTsl+MJ017bvGn58Og/LzYaX4K40Bx0C2TrR26u5WBK3I+udmTNMr79o
         V5Yd9EJLGCHj6TJIXDt9WxzpI9z3xifZIS7PEX9J/j93omCDkOHxaJ6cBy3nOyxo75St
         6Kd9ZqpN/WIY7KDQVnihzMQDMigQk192EZ3cIaJq3nDhtPjIvwm9LKiP0rnwvhD64cQv
         n2dAOs8tgxlei4pCNu8+KKSIoCQGPEFmbXZEURDqnr4SQ/SiUkNmD9VqrPgvyz3WRCdp
         U6kQ==
X-Forwarded-Encrypted: i=1; AJvYcCVV7betFAcKwfgNTxXDJbv5HN12NdE2eYTx3WzdhrT6IZ91UCfKr8oAkqXNdSFdIta/yMEINBBeC1pF@vger.kernel.org
X-Gm-Message-State: AOJu0Yzch8MCeWmid4DY5IOVaBCXhmD0slxZxuQug7Z4RUInM1LgfCbK
	++5sVFoT6IAREgseNZpwzJmMfcbrZL1TSSmmL1dHu+IisF5FSSwAl2q3wZPkzJsRW5IjOBpOQg2
	FBq1Ewn8suNZHtlZK84qPdxxuQ6SGqF6zwgYm3oc=
X-Gm-Gg: ASbGncsKkQeI9m0qpbGg7XBxr6YgumivA/eXjZgBBIbaZJlhHzoRdWUxt+LpyhSalWu
	On87Jm8diRISK5WZMqGNzKEwfJRs1qF/+xkzyqL9/cAHtLSvmCvKX1eMBrclxNo+YsUycU27uEI
	P0PAk4lhNl/VRTsgmCWaLte+ZhdwKi1uzGNy9mEqab3HfjpsEX4XY6b7IiAHj2Ox5BDEVnAD88j
	WmOHWeNzOaKfDAou/WCoTVEb+lYPPA9R6d3VNkFWO0xsDG5uizdm1fXDfDG4DFAysw39Q==
X-Google-Smtp-Source: AGHT+IGHFiY4jasRdDwkCRmXANlLW5JlIFq7xC6BowWclB3EddXCmT2gKzxTvMcgnU7xXnjUv1OUxwRREEAEtKiWebU=
X-Received: by 2002:a17:907:da6:b0:b4b:4f7:7a51 with SMTP id
 a640c23a62f3a-b7331b3bcb6mr781080566b.62.1763035493287; Thu, 13 Nov 2025
 04:04:53 -0800 (PST)
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
 <CANT5p=px8Lh1C2O0F8i1htoMACWZbLPfw0NEzUco5Njss2c7pQ@mail.gmail.com> <1392200.1762971247@warthog.procyon.org.uk>
In-Reply-To: <1392200.1762971247@warthog.procyon.org.uk>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 13 Nov 2025 17:34:41 +0530
X-Gm-Features: AWmQ_bk-6eBYZDqtBoroZDIHgD5C8O5lGu3lSy4URw9m715k0xvuJT5ChXqoUfc
Message-ID: <CANT5p=p4KSRsCAB-peTKehvsYYiuOxy3qLNDO9j5H+5PP_eiyw@mail.gmail.com>
Subject: Re: [[ EXT ]] [BUG REPORT] cifs/smb data corruption when writing,
 x86_64, kernel 6.6.71
To: David Howells <dhowells@redhat.com>
Cc: Bharath SM <bharathsm.hsk@gmail.com>, Mark A Whiting <whitingm@opentext.com>, 
	henrique.carvalho@suse.com, Enzo Matsumiya <ematsumiya@suse.de>, 
	Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@manguebit.org>, 
	"Heckmann, Ilja" <heckmann@izw-berlin.de>, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000004dfdc5064378b03b"

--0000000000004dfdc5064378b03b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi David,

Thanks for taking a look. Please review a draft patch attached.

On Wed, Nov 12, 2025 at 11:44=E2=80=AFPM David Howells <dhowells@redhat.com=
> wrote:
>
> Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> > 4. Page 2 is now written to by the next write, which extends the file
> > by another 5k. Page 2 and 3 are now marked dirty.
>
> It sounds like this is the crux of the problem.
>
> The caller, cifs_write_back_from_locked_folio() has a stale copy of ->i_s=
ize.
>
> I think we need to do one or more of:
>
>  (1) our copy of i_size should be updated by cifs_extend_writeback() whil=
st we
>      hold the lock on a folio
>
>  (2) we should reject on what appears (given the stale i_size) to be a pa=
rtial
>      folio if inode->i_size changed
>
>  (3) cifs_extend_writeback() should just stop - and maybe abandon the cur=
rent
>      batch - if it sees i_size has changed.
>
>      Note that abandoning the contents of the batch rather than doing the
>      flag-flipping loop is fine as they're merely locked to that point an=
d we
>      don't have to reverse the PG_dirty -> PG_write transition.
>
> David
>

I'm contemplating whether the change to retrieve the updated i_size in
cifs_extend_writeback is really necessary.
With the attached patch, we ensure that we never include the last
folio in the extended writeback (if it is partial write). It should
however be picked up for writeback in the next cifs_writepages_begin.
Even if i_size has increased, would we not get the updated size in the
following iteration to writeback the last folio?
If i_size has decreased, we anyway seem to have the handling for it.

Also, regarding your suggestion to have the xas declaration in
cifs_writepages_begin, do you think this change is necessary?
The way I see it, xas_reset would reset the state to how it began.
i.e. to whatever index it was initialized to.
If we don't make the change you suggested, we might do a lot of
unnecessary iterations in xas_find_marked (inside
cifs_writepages_begin):
https://elixir.bootlin.com/linux/v6.9.12/source/fs/smb/client/file.c#L2986
But I don't see any functional issues due to this. Do you agree?

Since this is for the stable trees, I'm a bit hesitant to make those
changes unless we have strong reason to believe that is necessary.
Let me know if you think those changes are really necessary.

--=20
Regards,
Shyam

--0000000000004dfdc5064378b03b
Content-Type: application/octet-stream; 
	name="0001-cifs-avoid-writeback-extension-beyond-the-len-specif.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-avoid-writeback-extension-beyond-the-len-specif.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mhx8cnl80>
X-Attachment-Id: f_mhx8cnl80

RnJvbSBlYzBmYjQ2OTY3MWFjODk0ZGFlOTliN2RmZjg2YTUyY2UxZTRhYjExIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBUaHUsIDEzIE5vdiAyMDI1IDE0OjMyOjI2ICswNTMwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogYXZvaWQgd3JpdGViYWNrIGV4dGVuc2lvbiBiZXlvbmQgdGhlIGxlbiBzcGVjaWZpZWQK
CmNpZnNfZXh0ZW5kX3dyaXRlYmFjayBjYW4gcGljayB1cCBhIGZvbGlvIG9uIGFuIGV4dGVuZGlu
ZyB3cml0ZSB3aGljaApoYXMgYmVlbiBkaXJ0aWVkLCBidXQgd2UgaGF2ZSBhY2xhbXAgb24gdGhl
IHdyaXRlYmFjayB0byBhbiBpX3NpemUKbG9jYWwgdmFyaWFibGUsIHdoaWNoIGNhbiBjYXVzZSBz
aG9ydCB3cml0ZXMsIHlldCBtYXJrIHRoZSBwYWdlIGFzIGNsZWFuLgpUaGlzIGNhbiBjYXVzZSBh
IGRhdGEgY29ycnVwdGlvbi4KCkFzIGFuIGV4YW1wbGUsIGNvbnNpZGVyIHRoaXMgc2NlbmFyaW86
CjEuIEZpcnN0IHdyaXRlIHRvIHRoZSBmaWxlIGhhcHBlbnMgb2Zmc2V0IDAgbGVuIDVrLgoyLiBX
cml0ZWJhY2sgc3RhcnRzIGZvciB0aGUgcmFuZ2UgKDAtNWspLgozLiBXcml0ZWJhY2sgbG9ja3Mg
cGFnZSAxIGluIGNpZnNfd3JpdGVwYWdlc19iZWdpbi4gQnV0IGRvZXMgbm90IGxvY2sKcGFnZSAy
IHlldC4KNC4gUGFnZSAyIGlzIG5vdyB3cml0dGVuIHRvIGJ5IHRoZSBuZXh0IHdyaXRlLCB3aGlj
aCBleHRlbmRzIHRoZSBmaWxlCmJ5IGFub3RoZXIgNWsuIFBhZ2UgMiBhbmQgMyBhcmUgbm93IG1h
cmtlZCBkaXJ0eS4KNS4gTm93IHdlIHJlYWNoIGNpZnNfZXh0ZW5kX3dyaXRlYmFjaywgd2hlcmUg
d2UgZXh0ZW5kIHRvIGluY2x1ZGUgdGhlCm5leHQgZm9saW8gKGV2ZW4gaWYgaXQgc2hvdWxkIGJl
IHBhcnRpYWxseSB3cml0dGVuKS4gV2Ugd2lsbCBtYXJrIHBhZ2UKMiBmb3Igd3JpdGViYWNrLgo2
LiBCdXQgYWZ0ZXIgZXhpdGluZyBjaWZzX2V4dGVuZF93cml0ZWJhY2ssIHdlIHdpbGwgY2xhbXAg
dGhlCndyaXRlYmFjayB0byBpX3NpemUsIHdoaWNoIHdhcyA1ayB3aGVuIGl0IHN0YXJ0ZWQuIFNv
IHdlIHdyaXRlIG9ubHkgMWsKYnl0ZXMgaW4gcGFnZSAyLgo3LiBXZSBzdGlsbCB3aWxsIG5vdyBt
YXJrIHBhZ2UgMiBhcyBmbHVzaGVkIGFuZCBtYXJrIGl0IGNsZWFuLiBTbwpyZW1haW5pbmcgY29u
dGVudHMgb2YgcGFnZSAyIHdpbGwgbm90IGJlIHdyaXR0ZW4gdG8gdGhlIHNlcnZlciAoaGVuY2UK
dGhlIGhvbGUgaW4gdGhhdCBnYXAsIHVubGVzcyB0aGF0IHJhbmdlIGdldHMgb3ZlcndyaXR0ZW4p
LgoKV2l0aCB0aGlzIHBhdGNoLCB3ZSB3aWxsIG1ha2Ugc3VyZSB0aGF0IHRoZSBib3VuZGFyeSBj
aGVjayBpbgpjaWZzX2V4dGVuZF93cml0ZWJhY2sgd2lsbCBoYXBwZW4gYmVmb3JlIGFkZGluZyBp
dCB0byB0aGUgZXh0ZW5kZWQKZm9saW8gYmF0Y2guCgpUaGlzIGZpeCBhbHNvIGNoYW5nZXMgdGhl
IGVycm9yIGhhbmRsaW5nIG9mIGNpZnNfZXh0ZW5kX3dyaXRlYmFjayB3aGVuCmEgZm9saW8gZ2V0
IGZhaWxzLiBXZSB3aWxsIG5vdyBzdG9wIHRoZSBleHRlbnNpb24gd2hlbiBhIGZvbGlvIGdldCBm
YWlscy4KCkNjOiBzdGFibGVAa2VybmVsLm9yZyAjIHY2LjN+djYuOQpTaWduZWQtb2ZmLWJ5OiBT
aHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29tPgpTdWdnZXN0ZWQtYnk6IEVuem8g
TWF0c3VtaXlhIDxlbWF0c3VtaXlhQHN1c2UuZGU+ClJlcG9ydGVkLWJ5OiBNYXJrIEEgV2hpdGlu
ZyA8d2hpdGluZ21Ab3BlbnRleHQuY29tPgotLS0KIGZzL3NtYi9jbGllbnQvZmlsZS5jIHwgMTcg
KysrKysrKysrKysrKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspLCA0IGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvZmlsZS5jIGIvZnMvc21iL2Ns
aWVudC9maWxlLmMKaW5kZXggN2EyYjgxZmJkOWNmZC4uMWM1ODNmOTcwZTE3NyAxMDA2NDQKLS0t
IGEvZnMvc21iL2NsaWVudC9maWxlLmMKKysrIGIvZnMvc21iL2NsaWVudC9maWxlLmMKQEAgLTI3
NzksNyArMjc3OSw3IEBAIHN0YXRpYyB2b2lkIGNpZnNfZXh0ZW5kX3dyaXRlYmFjayhzdHJ1Y3Qg
YWRkcmVzc19zcGFjZSAqbWFwcGluZywKIAogCQkJaWYgKCFmb2xpb190cnlfZ2V0KGZvbGlvKSkg
ewogCQkJCXhhc19yZXNldCh4YXMpOwotCQkJCWNvbnRpbnVlOworCQkJCWJyZWFrOwogCQkJfQog
CQkJbnJfcGFnZXMgPSBmb2xpb19ucl9wYWdlcyhmb2xpbyk7CiAJCQlpZiAobnJfcGFnZXMgPiBt
YXhfcGFnZXMpIHsKQEAgLTI4MDcsMTUgKzI4MDcsMjQgQEAgc3RhdGljIHZvaWQgY2lmc19leHRl
bmRfd3JpdGViYWNrKHN0cnVjdCBhZGRyZXNzX3NwYWNlICptYXBwaW5nLAogCQkJCWJyZWFrOwog
CQkJfQogCi0JCQltYXhfcGFnZXMgLT0gbnJfcGFnZXM7CiAJCQlsZW4gPSBmb2xpb19zaXplKGZv
bGlvKTsKKworCQkJLyogYm91bmRhcnkgY2hlY2sgYmVmb3JlIHRoZSBmb2xpbyBpcyBhY2NvdW50
ZWQgKi8KKwkJCWlmICgobWF4X3BhZ2VzIC0gbnJfcGFnZXMpIDw9IDAgfHwKKwkJCSAgICAoKl9s
ZW4gKyBsZW4pID49IG1heF9sZW4gfHwKKwkJCSAgICAoKl9jb3VudCAtIG5yX3BhZ2VzKSA8PSAw
KSB7CisJCQkJZm9saW9fdW5sb2NrKGZvbGlvKTsKKwkJCQlmb2xpb19wdXQoZm9saW8pOworCQkJ
CXhhc19yZXNldCh4YXMpOworCQkJCWJyZWFrOworCQkJfQorCiAJCQlzdG9wID0gZmFsc2U7CiAK
KwkJCW1heF9wYWdlcyAtPSBucl9wYWdlczsKIAkJCWluZGV4ICs9IG5yX3BhZ2VzOwogCQkJKl9j
b3VudCAtPSBucl9wYWdlczsKIAkJCSpfbGVuICs9IGxlbjsKLQkJCWlmIChtYXhfcGFnZXMgPD0g
MCB8fCAqX2xlbiA+PSBtYXhfbGVuIHx8ICpfY291bnQgPD0gMCkKLQkJCQlzdG9wID0gdHJ1ZTsK
IAogCQkJaWYgKCFmb2xpb19iYXRjaF9hZGQoJmJhdGNoLCBmb2xpbykpCiAJCQkJYnJlYWs7Ci0t
IAoyLjQzLjAKCg==
--0000000000004dfdc5064378b03b--
