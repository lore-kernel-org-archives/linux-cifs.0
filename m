Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6CF21CFE0
	for <linux-cifs@vger.kernel.org>; Thu,  6 Nov 2025 15:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762441241; cv=none; b=uq1iE70J2GTqp2TPD30/dcvazVc9OEmpizZWGpuXbmUlcIJuXdK/jjEPwEU4fcbg2Cc0B3CGbyKpbHgTQuh16+JxxSnbS15ZldTB3SopESccl8WH1BIcsiAlnkWvh/POJeJQFr3/txN8EPZQwnax2tAs0sr7PC1mX2f2Y/2Fl1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762441241; c=relaxed/simple;
	bh=dugxVZzFglr3tfihpX1KoGLQB7WMlJXucp8s8GrbxVs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fluADorWj+mI8m787OKjr7/rLBLQsFxCD8aeNW4Ivg97hQ7kgwTQhVowD1oNCuuIz3LBw/C0qbCKqnzvhonsDbzsWWgFtMxNIO6LjWEfo4ulMqPmYn8OQM4dezhLJwjoQimficYSJSNE3wl10+ce6iOPEwhIrKo69ujqZTKMmgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AFGSMVEI; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AFGSMVEI"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-7866aca9ff4so12289257b3.3
        for <linux-cifs@vger.kernel.org>; Thu, 06 Nov 2025 07:00:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762441238; x=1763046038; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=p6PEtyJ7zJ8M4ASy7pA/NZnk1Jz23014Pt1KVSuqYRk=;
        b=AFGSMVEIKaa8+x6oaSHOINmEPIKF/0/qVDxnaK6IdYj5NrkphTZh7dIVh7VGAoMUUL
         yvD7tXSjnr6futr/sw//52slDSjSrrmeOu9PDH1recSe+/PypZXs0y1e4RTKe6MRTYmZ
         wzVBlWZeAsQfitNB43BAtBkNZ5Ww51V7Y7MwqY79oLnVZFwo927FEZpht7qrQ0dMDZh4
         PYwFE9JLnO/x6X48hLsfqMEVTV7A3Usuk9G/6pHFuHx8jnviy1MSgLRRpLNs1mnK/1cX
         /tsbgkJYUUnYEOWeEZlpcVnQ7G7yxndcNflAazMX/22CCwRjyBISjo4VxxXAR4o0F0VP
         BBKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762441238; x=1763046038;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p6PEtyJ7zJ8M4ASy7pA/NZnk1Jz23014Pt1KVSuqYRk=;
        b=lqCAYcAaHDcogmSK09DHq054hDaSldf+yUEYI9X2IY0ZFdcAkdykCmHW8NGDE1ANGz
         x6mHW4E9sSHJY4s7tUA4pgAYbdAn3/42dL9269zWnVKmudvjloLPRR2me6HFnUsQL/he
         V+tROWXgd9n7RbtIdSmcXWC+DOwLSi6s/oAhhUvRebr8lK0DIPGBGqBLvdJz8M88jBuR
         8w+tJJDs2TEqAGtVAizHKwMaUpJNtpMrn8RfM9SofkY3YPfNX0P0ELf3FuV2vVMpVInz
         AznWYFSPcIR0sRv1ppkmVeLJbV+Q1AjUNsVTXhcaseB2LUfLPApfCTn7/+1rLaNfnj/F
         9RxA==
X-Forwarded-Encrypted: i=1; AJvYcCV72v0B2+zADsFBW9wqUC9aBG3JMXj/X/UQ2Hvc9uirWJBDdman2f4cloa6req03OoP29A9wDW8Bv7X@vger.kernel.org
X-Gm-Message-State: AOJu0YykGqKoFn+Lqe8saAauhw3sFB8+enSo9Z8FdetzRol/0JlD8zYJ
	wFajvMrXokU01ttgdLTiF+I9sFLj9fMumgeGEiYABwHXBusYoQKmrR9BCfabHMN7VqIgYHKUSp9
	cMKLA3ErxENXyZA+2R/Eia0kxL3yS/cw=
X-Gm-Gg: ASbGnctlhYIjc1elxdPZsVmwjRWSAhhtnJWFs5rP4ES0bC0G1lDqv0Lg8roBkWdOt5M
	vofLWpv7wbTtaNPfEIvayIbpoeA81kgpSb5jeR/nP9HLjYkl6m55v4gD6HrnGJRil1FhcOFGV6J
	3TA6xDzCLmMSOLPBVzemU5WTKoZ47VGWRLoUV84h9duOblUHMp3X8VV7phjmNxX9z12ZH2kwh/e
	9H27Q4HOCmIi9iWTtPXO6sZa2y5NVjz4Td1L/cl82i0vA8eOxLTNh2KZLo=
X-Google-Smtp-Source: AGHT+IGVoGY0cvUJypkZeWF8qxz6WUCDcSjVVflOaTpCeMzoDmpFaRGOPLxiPlXvS746/+zEfMosYSsv1Fp99G2olNs=
X-Received: by 2002:a05:690e:4259:b0:636:d286:4867 with SMTP id
 956f58d0204a3-63fd34b616cmr4620641d50.1.1762441237978; Thu, 06 Nov 2025
 07:00:37 -0800 (PST)
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
 <aaloi77h2f5xolhrnegxsxntqp2jopwisunmjfp45idsoockpy@cy5agf2oqjop> <YT1PR01MB9451A0F623371F50E77CC1C9B3AD2@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
In-Reply-To: <YT1PR01MB9451A0F623371F50E77CC1C9B3AD2@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Thu, 6 Nov 2025 07:00:26 -0800
X-Gm-Features: AWmQ_ble9pcetwcmtju_BdLmfTv-aQvDpPYrXaWEUrOLulgmoZNFKRyfykR0Eis
Message-ID: <CAGypqWw0bnE7_=49HSxgExouk4s5PVFQ6gVH50wrE8_=4b5vAg@mail.gmail.com>
Subject: Re: [[ EXT ]] [BUG REPORT] cifs/smb data corruption when writing,
 x86_64, kernel 6.6.71
To: Mark A Whiting <whitingm@opentext.com>, henrique.carvalho@suse.com, 
	Enzo Matsumiya <ematsumiya@suse.de>, Steve French <smfrench@gmail.com>, 
	Shyam Prasad <nspmangalore@gmail.com>, David Howells <dhowells@redhat.com>, 
	Paulo Alcantara <pc@manguebit.org>
Cc: "Heckmann, Ilja" <heckmann@izw-berlin.de>, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000edaf3f0642ee53ee"

--000000000000edaf3f0642ee53ee
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Enzo,

We are noticing the similar behavior with the 6.6 kernel, can you
please submit a patch to the 6.6 stable kernel.

Hi Steve and David,

Can you please review the attached patch from Enzo and share your comments.

Thanks,
Bharath

On Mon, Mar 31, 2025 at 12:48=E2=80=AFPM Mark A Whiting <whitingm@opentext.=
com> wrote:
>
> Hi Enzo,
>
> I now have a couple days of testing done. The good news is that we've run=
 several terabytes of data through cifs and haven't had a single failure wi=
th the patch you provided.
>
> Now for the not as good news. Even though we aren't seeing any data corru=
ption or failures. We are regularly and very frequently hitting a WARN_ON i=
n cifs_extend_writeback() on line 2866.
>
> >for (i =3D 0; i < folio_batch_count(&batch); i++) {
> >       folio =3D batch.folios[i];
> >       /* The folio should be locked, dirty and not undergoing
> >        * writeback from the loop above.
> >        */
> >       if (!folio_clear_dirty_for_io(folio))
> >               WARN_ON(1);
>
> Reading through the folio_clear_dirty_for_io() function it appears the on=
ly way this would happen is if the folio is clean, i.e., the dirty flag is =
not set.
>
> >if (folio_test_writeback(folio)) {
> >       /*
> >        * For data-integrity syscalls (fsync(), msync()) we must wait fo=
r
> >        * the I/O to complete on the page.
> >        * For other cases (!sync), we can just skip this page, even if
> >        * it's dirty.
> >        */
> >       if (!sync) {
> >               stop =3D false;
> >               goto unlock_next;
> >       } else {
> >               folio_wait_writeback(folio);
>
> Reading through your patch, unless I missed something, this folio_wait_wr=
iteback() call is the only addition that could affect the dirty flag indire=
ctly. I'm assuming that when the current writeback is complete it would mar=
k the folio clean. Then when it's added to the current batch and later chec=
ked, it's clean instead of the dirty flag being set as expected.
>
> Since you wrote the patch, is this expected behavior and that WARN_ON isn=
't valid anymore? Or is this something I should be worried about?
>
> Thanks,
> Mark Whiting
>
>
>

--000000000000edaf3f0642ee53ee
Content-Type: application/octet-stream; 
	name="smb-client-fix-corruption-in-cifs_extend_writeback.patch"
Content-Disposition: attachment; 
	filename="smb-client-fix-corruption-in-cifs_extend_writeback.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mhnjtvk00>
X-Attachment-Id: f_mhnjtvk00

RnJvbSA4ZDRjNDBlMDg0ZjNkMTMyNDM0ZDVkM2QwNjgxNzVjOGRiNTljZTY1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogRW56byBNYXRzdW1peWEgPGVtYXRzdW1peWFAc3VzZS5kZT4N
CkRhdGU6IFdlZCwgMjYgTWFyIDIwMjUgMTc6NDg6MjcgLTAzMDANClN1YmplY3Q6IFtQQVRDSF0g
c21iOiBjbGllbnQ6IGZpeCBjb3JydXB0aW9uIGluIGNpZnNfZXh0ZW5kX3dyaXRlYmFjaw0KDQpj
aWZzLmtvIHdyaXRlcGFnZXMgaW1wbGVtZW50YXRpb24gd2lsbCB0cnkgdG8gZXh0ZW5kIHRoZSB3
cml0ZSBidWZmZXIgc2l6ZSBpbiBvcmRlciB0byBpc3N1ZSBsZXNzLA0KYnV0IGJpZ2dlciB3cml0
ZSByZXF1ZXN0cyBvdmVyIHRoZSB3aXJlLg0KDQpUaGUgZnVuY3Rpb24gcmVzcG9uc2libGUgZm9y
IGRvaW5nIHNvLCBjaWZzX2V4dGVuZF93cml0ZWJhY2ssIGhvd2V2ZXIsIGRpZCBub3QgYWNjb3Vu
dCBmb3Igc29tZQ0KaW1wb3J0YW50IGZhY3RvcnMsIGFuZCBub3QgaGFuZGxpbmcgc29tZSBvZiB0
aG9zZSBmYWN0b3JzIGNvcnJlY3RseSBsZWFkIHRvIGRhdGEgY29ycnVwdGlvbiBvbg0Kd3JpdGVz
IGNvbWluZyB0aHJvdWdoIHdyaXRlcGFnZXMuDQoNClN1Y2ggY29ycnVwdCB3cml0ZXMgYXJlIHZl
cnkgc3VidGxlIGFuZCBzaG93IG5vIGVycm9ycyB3aGF0c29ldmVyIG9uIGRtZXNnIC0tIHRoZXkg
Y2FuIG9ubHkgYmUNCm9ic2VydmVkIGJ5IGNvbXBhcmluZyBleHBlY3RlZCB2cyBhY3R1YWwgb3V0
cHV0cy4gIEVhc3kgcmVwcm9kdWNlcjoNCg0KCWRvbmUgfCBkZCBpYnM9NDE5NDMwNCBpZmxhZz1m
dWxsYmxvY2sgY291bnQ9MTAyNDAwMDAgb2Y9cmVtb3RlZmlsZQ0KODk5OTk0Ng0KPGNvcnJ1cHQg
bGluZXMgc2hvd3MgaGVyZT4NCg0KJ3djIC1sJyBpcyBub3QgcmVhbGx5IHJlbGlhYmxlIGFzIHdl
J3ZlIHNlZW4gZmlsZXMgd2l0aCBjb3JydXB0IGxpbmVzLCBidXQgbm8gbWlzc2luZyBvbmVzLg0K
T2YgY291cnNlLCB0aGUgY29ycnVwdGlvbiBkb2Vzbid0IGhhcHBlbiB3aXRoIGNhY2hlPW5vbmUg
bW91bnQgb3B0aW9uLg0KDQpCdWcgZXhwbGFuYXRpb246DQoNCi0gUG9pbnRlciBhcmd1bWVudHMg
YXJlIHVwZGF0ZWQgYmVmb3JlIGJvdW5kIGNoZWNraW5nIChhY3R1YWwgcm9vdCBjYXVzZSkNCkBf
bGVuIGFuZCBAX2NvdW50IGFyZSB1cGRhdGVkIHdpdGggdGhlIGN1cnJlbnQgZm9saW8gdmFsdWVz
IGJlZm9yZSBhY3R1YWxseSBjaGVja2luZyBpZiB0aGUgY3VycmVudA0KdmFsdWVzIGZpdCBpbiB0
aGVpciBib3VuZGFyaWVzLCBzbyBieSB0aGUgdGltZSB0aGUgZnVuY3Rpb24gZXhpdHMsIHRoZSBj
YWxsZXIgKG9ubHkNCmNpZnNfd3JpdGVfYmFja19mcm9tX2xvY2tlZF9mb2xpbygpLCB0aGF0IEJU
VyBkb2Vzbid0IGRvIGFueSBmdXJ0aGVyIGNoZWNrcykgdGhvc2UgYXJndW1lbnRzIG1pZ2h0DQpo
YXZlIGNyb3NzZWQgYm91bmRzIGFuZCBleHRyYSBkYXRhICh6ZXJvZXMpIGFyZSBhZGRlZCBhcyBw
YWRkaW5nLg0KTGF0ZXIsIHdpdGggdGhvc2Ugb2Zmc2V0cyBtYXJrZWQgYXMgJ2RvbmUnLCB0aGUg
cmVhbCBhY3R1YWwgZGF0YSB0aGF0IHNob3VsZCd2ZSBiZWVuIHdyaXR0ZW4gaW50bw0KdGhvc2Ug
b2Zmc2V0cyBhcmUgc2tpcHBlZCwgbWFraW5nIHRoZSBmaW5hbCBmaWxlIGNvcnJ1cHQuDQoNCi0g
U3luYyBjYWxscyB3aXRoIG9uZ29pbmcgd3JpdGViYWNrIGFyZW4ndCBzeW5jDQpGb2xpb3MgYXJl
IHRlc3RlZCBmb3Igb25nb2luZyB3cml0ZWJhY2sgKGZvbGlvX3Rlc3Rfd3JpdGViYWNrKSwgYnV0
IG5vdCBoYW5kbGVkIGRpcmVjdGx5IGZvcg0KZGF0YS1pbnRlZ3JpdHkgc3luYyBzeXNjYWxscyAo
ZS5nLiBmc3luYygpIG9yIG1zeW5jKCkpLiAgV2hlbiBiZWluZyBjYWxsZWQgZnJvbSB0aG9zZSwg
YW5kIGZvbGlvDQoqaXMqIHVuZGVyIHdyaXRlYmFjaywgd2UgTVVTVCB3YWl0IGZvciB0aGUgd3Jp
dGViYWNrIHRvIGNvbXBsZXRlIGJlY2F1c2UgdGhvc2UgY2FsbHMgbXVzdCBndWFyYW50ZWUNCnRo
ZSB3cml0ZSB3ZW50IHRocm91Z2guDQpCeSBzaW1wbHkgYmFpbGluZyBvdXQgb2YgdGhlIGZ1bmN0
aW9uLCB0aGUgaW1wbGVtZW50YXRpb24gcmVsaWVzIG9uIHRoZSB0aW1pbmcvbHVjayB0aGF0IG5v
IGZ1cnRoZXINCmVycm9ycyBoYXBwZW5zIGxhdGVyLCBhbmQgdGhhdCB0aGUgd3JpdGViYWNrIGlu
ZGVlZCBmaW5pc2hlZCBiZWZvcmUgcmV0dXJuaW5nLg0KDQotIEFueSBmYWlsZWQgY2hlY2tzIHRv
IHRoZSBmb2xpb3MgaW4gQHhhcyB3b3VsZCBjYWxsIHhhc19yZXNldA0KVGhpcyBtZWFucyB0aGF0
IHdoZW5ldmVyIHNvbWUvYW55IGZvbGlvcyB3ZXJlIGFkZGVkIHRvIGJhdGNoIGFuZCBwcm9jZXNz
ZWQsIHRoZXkgYXJlIHNvIGFnYWluDQppbiBmdXJ0aGVyIHdyaXRlIGNhbGxzIGJlY2F1c2UgQHhh
cywgbWFraW5nIHVwcGVyIGxheWVycyBkbyBkb3VibGUgd29yayBvbiBpdC4NCg0KVGhpcyBwYXRj
aCBmaXhlcyB0aGUgY2FzZXMgYWJvdmUsIGFuZCBhbHNvIGxlc3NlbiB0aGUgJ2hhcmQgc3RvcCcg
Y29uZGl0aW9ucyBmb3IgY2FzZXMgd2hlcmUgb25seSBhDQpzaW5nbGUgZm9saW8gaXMgYWZmZWN0
ZWQsIGJ1dCBvdGhlcnMgaW4gQHhhcyBjYW4gc3RpbGwgYmUgcHJvY2Vzc2VkIChtb3JlIG9mIGEg
cGVyZm9ybWFuY2UNCmltcHJvdmVtZW50KS4NCg0KU2lnbmVkLW9mZi1ieTogRW56byBNYXRzdW1p
eWEgPGVtYXRzdW1peWFAc3VzZS5kZT4NCi0tLQ0KIGZzL3NtYi9jbGllbnQvZmlsZS5jIHwgMTQ3
ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0NCiAxIGZpbGUgY2hh
bmdlZCwgMTA0IGluc2VydGlvbnMoKyksIDQzIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEv
ZnMvc21iL2NsaWVudC9maWxlLmMgYi9mcy9zbWIvY2xpZW50L2ZpbGUuYw0KaW5kZXggY2I3NWI5
NWVmYjcwLi5lZGRkMGRhYjQ0ZWQgMTAwNjQ0DQotLS0gYS9mcy9zbWIvY2xpZW50L2ZpbGUuYw0K
KysrIGIvZnMvc21iL2NsaWVudC9maWxlLmMNCkBAIC0yNzE5LDE1ICsyNzE5LDE3IEBAIHN0YXRp
YyB2b2lkIGNpZnNfZXh0ZW5kX3dyaXRlYmFjayhzdHJ1Y3QgYWRkcmVzc19zcGFjZSAqbWFwcGlu
ZywNCiAJCQkJICBsb2ZmX3Qgc3RhcnQsDQogCQkJCSAgaW50IG1heF9wYWdlcywNCiAJCQkJICBs
b2ZmX3QgbWF4X2xlbiwNCi0JCQkJICBzaXplX3QgKl9sZW4pDQorCQkJCSAgc2l6ZV90ICpfbGVu
LA0KKwkJCQkgIGludCBzeW5jX21vZGUpDQogew0KIAlzdHJ1Y3QgZm9saW9fYmF0Y2ggYmF0Y2g7
DQogCXN0cnVjdCBmb2xpbyAqZm9saW87DQotCXVuc2lnbmVkIGludCBucl9wYWdlczsNCi0JcGdv
ZmZfdCBpbmRleCA9IChzdGFydCArICpfbGVuKSAvIFBBR0VfU0laRTsNCi0Jc2l6ZV90IGxlbjsN
Ci0JYm9vbCBzdG9wID0gdHJ1ZTsNCi0JdW5zaWduZWQgaW50IGk7DQorCXVuc2lnbmVkIGludCBu
cl9wYWdlcywgaTsNCisJcGdvZmZfdCBpZHgsIGluZGV4ID0gKHN0YXJ0ICsgKl9sZW4pIC8gUEFH
RV9TSVpFOw0KKwlzaXplX3QgbGVuID0gKl9sZW4sIGZsZW47DQorCWJvb2wgc3RvcCA9IHRydWUs
IHN5bmMgPSAoc3luY19tb2RlICE9IFdCX1NZTkNfTk9ORSk7DQorCWxvbmcgY291bnQgPSAqX2Nv
dW50Ow0KKwlpbnQgbnBhZ2VzID0gbWF4X3BhZ2VzOw0KIA0KIAlmb2xpb19iYXRjaF9pbml0KCZi
YXRjaCk7DQogDQpAQCAtMjc0Miw1OSArMjc0NCwxMTAgQEAgc3RhdGljIHZvaWQgY2lmc19leHRl
bmRfd3JpdGViYWNrKHN0cnVjdCBhZGRyZXNzX3NwYWNlICptYXBwaW5nLA0KIAkJCXN0b3AgPSB0
cnVlOw0KIAkJCWlmICh4YXNfcmV0cnkoeGFzLCBmb2xpbykpDQogCQkJCWNvbnRpbnVlOw0KLQkJ
CWlmICh4YV9pc192YWx1ZShmb2xpbykpDQotCQkJCWJyZWFrOw0KLQkJCWlmIChmb2xpby0+aW5k
ZXggIT0gaW5kZXgpIHsNCi0JCQkJeGFzX3Jlc2V0KHhhcyk7DQorCQkJaWYgKHhhX2lzX3ZhbHVl
KGZvbGlvKSkgew0KKwkJCQlzdG9wID0gZmFsc2U7DQogCQkJCWJyZWFrOw0KIAkJCX0NCisJCQlp
ZiAoZm9saW9faW5kZXgoZm9saW8pICE9IGluZGV4KQ0KKwkJCQlnb3RvIHhhcmVzZXRfbmV4dDsN
CiANCi0JCQlpZiAoIWZvbGlvX3RyeV9nZXQoZm9saW8pKSB7DQotCQkJCXhhc19yZXNldCh4YXMp
Ow0KLQkJCQljb250aW51ZTsNCi0JCQl9DQotCQkJbnJfcGFnZXMgPSBmb2xpb19ucl9wYWdlcyhm
b2xpbyk7DQotCQkJaWYgKG5yX3BhZ2VzID4gbWF4X3BhZ2VzKSB7DQotCQkJCXhhc19yZXNldCh4
YXMpOw0KLQkJCQlicmVhazsNCi0JCQl9DQorCQkJaWYgKCFmb2xpb190cnlfZ2V0KGZvbGlvKSkN
CisJCQkJZ290byB4YXJlc2V0X25leHQ7DQogDQogCQkJLyogSGFzIHRoZSBwYWdlIG1vdmVkIG9y
IGJlZW4gc3BsaXQ/ICovDQotCQkJaWYgKHVubGlrZWx5KGZvbGlvICE9IHhhc19yZWxvYWQoeGFz
KSkpIHsNCi0JCQkJZm9saW9fcHV0KGZvbGlvKTsNCi0JCQkJeGFzX3Jlc2V0KHhhcyk7DQotCQkJ
CWJyZWFrOw0KKwkJCWlmICh1bmxpa2VseShmb2xpbyAhPSB4YXNfcmVsb2FkKHhhcykgfHwgZm9s
aW8tPm1hcHBpbmcgIT0gbWFwcGluZykpIHsNCisJCQkJc3RvcCA9IGZhbHNlOw0KKwkJCQlnb3Rv
IHB1dF9uZXh0Ow0KIAkJCX0NCiANCi0JCQlpZiAoIWZvbGlvX3RyeWxvY2soZm9saW8pKSB7DQot
CQkJCWZvbGlvX3B1dChmb2xpbyk7DQotCQkJCXhhc19yZXNldCh4YXMpOw0KLQkJCQlicmVhazsN
Ci0JCQl9DQotCQkJaWYgKCFmb2xpb190ZXN0X2RpcnR5KGZvbGlvKSB8fA0KLQkJCSAgICBmb2xp
b190ZXN0X3dyaXRlYmFjayhmb2xpbykpIHsNCi0JCQkJZm9saW9fdW5sb2NrKGZvbGlvKTsNCi0J
CQkJZm9saW9fcHV0KGZvbGlvKTsNCi0JCQkJeGFzX3Jlc2V0KHhhcyk7DQotCQkJCWJyZWFrOw0K
KwkJCWlmICghZm9saW9fdHJ5bG9jayhmb2xpbykpDQorCQkJCWdvdG8gcHV0X25leHQ7DQorDQor
CQkJbnJfcGFnZXMgPSBmb2xpb19ucl9wYWdlcyhmb2xpbyk7DQorCQkJaWYgKG5yX3BhZ2VzID4g
bnBhZ2VzIHx8IG5yX3BhZ2VzID4gY291bnQpDQorCQkJCWdvdG8gdW5sb2NrX25leHQ7DQorDQor
CQkJaWYgKGZvbGlvX3Rlc3Rfd3JpdGViYWNrKGZvbGlvKSkgew0KKwkJCQkvKg0KKwkJCQkgKiBG
b3IgZGF0YS1pbnRlZ3JpdHkgc3lzY2FsbHMgKGZzeW5jKCksIG1zeW5jKCkpIHdlIG11c3Qgd2Fp
dCBmb3INCisJCQkJICogdGhlIEkvTyB0byBjb21wbGV0ZSBvbiB0aGUgcGFnZS4NCisJCQkJICog
Rm9yIG90aGVyIGNhc2VzICghc3luYyksIHdlIGNhbiBqdXN0IHNraXAgdGhpcyBwYWdlLCBldmVu
IGlmDQorCQkJCSAqIGl0J3MgZGlydHkuDQorCQkJCSAqLw0KKwkJCQlpZiAoIXN5bmMpIHsNCisJ
CQkJCXN0b3AgPSBmYWxzZTsNCisJCQkJCWdvdG8gdW5sb2NrX25leHQ7DQorCQkJCX0gZWxzZSB7
DQorCQkJCQlmb2xpb193YWl0X3dyaXRlYmFjayhmb2xpbyk7DQorDQorCQkJCQkvKg0KKwkJCQkJ
ICogTW9yZSBJL08gc3RhcnRlZCBtZWFud2hpbGUsIGJhaWwgb3V0IGFuZCB3cml0ZSBvbiB0aGUN
CisJCQkJCSAqIG5leHQgY2FsbC4NCisJCQkJCSAqLw0KKwkJCQkJaWYgKFdBUk5fT05fT05DRShm
b2xpb190ZXN0X3dyaXRlYmFjayhmb2xpbykpKQ0KKwkJCQkJCWdvdG8gdW5sb2NrX25leHQ7DQor
CQkJCX0NCiAJCQl9DQogDQotCQkJbWF4X3BhZ2VzIC09IG5yX3BhZ2VzOw0KLQkJCWxlbiA9IGZv
bGlvX3NpemUoZm9saW8pOw0KLQkJCXN0b3AgPSBmYWxzZTsNCisJCQkvKg0KKwkJCSAqIFdlIGRv
bid0IHJlYWxseSBoYXZlIGEgYm91bmRhcnkgZm9yIGluZGV4LCBzbyBqdXN0IGNoZWNrIGZvciBv
dmVyZmxvdy4NCisJCQkgKi8NCisJCQlpZiAoY2hlY2tfYWRkX292ZXJmbG93KGluZGV4LCBucl9w
YWdlcywgJmlkeCkpDQorCQkJCWdvdG8gdW5sb2NrX25leHQ7DQorDQorCQkJZmxlbiA9IGZvbGlv
X3NpemUoZm9saW8pOw0KIA0KLQkJCWluZGV4ICs9IG5yX3BhZ2VzOw0KLQkJCSpfY291bnQgLT0g
bnJfcGFnZXM7DQotCQkJKl9sZW4gKz0gbGVuOw0KLQkJCWlmIChtYXhfcGFnZXMgPD0gMCB8fCAq
X2xlbiA+PSBtYXhfbGVuIHx8ICpfY291bnQgPD0gMCkNCi0JCQkJc3RvcCA9IHRydWU7DQorCQkJ
LyogU3RvcmUgc3VtIGluIEBmbGVuIHNvIHdlIGRvbid0IGhhdmUgdG8gdW5kbyBpdCBpbiBjYXNl
IG9mIGZhaWx1cmUuICovDQorCQkJaWYgKGNoZWNrX2FkZF9vdmVyZmxvdyhsZW4sIGZsZW4sICZm
bGVuKSB8fCBmbGVuID4gbWF4X2xlbikNCisJCQkJZ290byB1bmxvY2tfbmV4dDsNCisNCisJCQlp
bmRleCA9IGlkeDsNCisJCQlsZW4gPSBmbGVuOw0KKw0KKwkJCS8qDQorCQkJICogQG5wYWdlcyBh
bmQgQGNvdW50IGhhdmUgYmVlbiBjaGVja2VkIGVhcmxpZXIgKGFuZCBhcmUgc2lnbmVkKSwgc28g
d2UNCisJCQkgKiBjYW4ganVzdCBzdWJ0cmFjdCB0aGVtIGhlcmUuDQorCQkJICovDQorCQkJbnBh
Z2VzIC09IG5yX3BhZ2VzOw0KKwkJCWNvdW50IC09IG5yX3BhZ2VzOw0KIA0KKwkJCS8qDQorCQkJ
ICogVGhpcyBpcyBub3QgYW4gZXJyb3I7IGl0IGp1c3QgbWVhbnMgd2UgX2RpZF8gYWRkIHRoaXMg
Y3VycmVudCBmb2xpbywgYnV0DQorCQkJICogY2FuJ3QgYWRkIGFueSBtb3JlIHRvIHRoaXMgYmF0
Y2gsIHNvIGJyZWFrIG91dCBvZiB0aGlzIGxvb3AgdG8gc3RhcnQNCisJCQkgKiBwcm9jZXNzaW5n
IHRoaXMgYmF0Y2gsIGJ1dCBkb24ndCBzdG9wIHRoZSBvdXRlciBsb29wIGluIGNhc2UgdGhlcmUg
YXJlDQorCQkJICogbW9yZSBmb2xpb3MgdG8gYmUgcHJvY2Vzc2VkIGluIEB4YXMuDQorCQkJICov
DQorCQkJc3RvcCA9IGZhbHNlOw0KIAkJCWlmICghZm9saW9fYmF0Y2hfYWRkKCZiYXRjaCwgZm9s
aW8pKQ0KIAkJCQlicmVhazsNCisNCisJCQkvKg0KKwkJCSAqIEZvbGlvcyBhZGRlZCB0byB0aGUg
YmF0Y2ggbXVzdCBiZSBsZWZ0IGxvY2tlZCBmb3IgdGhlIGxvb3AgYmVsb3cuICBUaGV5DQorCQkJ
ICogd2lsbCBiZSB1bmxvY2tlZCByaWdodCBhd2F5IGFuZCBhbHNvIGZvbGlvX2JhdGNoX3JlbGVh
c2UoKSB3aWxsIHRha2UNCisJCQkgKiBjYXJlIG9mIHB1dHRpbmcgdGhlbS4NCisJCQkgKi8NCisJ
CQljb250aW51ZTsNCit1bmxvY2tfbmV4dDoNCisJCQlmb2xpb191bmxvY2soZm9saW8pOw0KK3B1
dF9uZXh0Og0KKwkJCWZvbGlvX3B1dChmb2xpbyk7DQoreGFyZXNldF9uZXh0Og0KIAkJCWlmIChz
dG9wKQ0KIAkJCQlicmVhazsNCiAJCX0NCiANCisJCS8qDQorCQkgKiBPbmx5IHJlc2V0IEB4YXMg
aWYgd2UgZ2V0IGhlcmUgYmVjYXVzZSBvZiBvbmUgb2YgdGhlIHN0b3BwaW5nIGNvbmRpdGlvbnMg
YWJvdmUsDQorCQkgKiBuYW1lbHk6DQorCQkgKiAgIC0gY291bGRuJ3QgbG9jay9nZXQgYSBmb2xp
byAoc29tZW9uZSBlbHNlIHdhcyBwcm9jZXNzaW5nIHRoZSBzYW1lIGZvbGlvKQ0KKwkJICogICAt
IGZvbGlvIHdhcyBpbiB3cml0ZWJhY2sgZm9yIHRvbyBsb25nIChzeW5jIGNhbGwgd2FzIHdyaXRp
bmcgdGhlIHNhbWUgZm9saW8pDQorCQkgKiAgIC0gb3V0IG9mIGJvdW5kcyBpbmRleCwgbGVuLCBv
ciBjb3VudCAodGhlIGxhc3QgcHJvY2Vzc2VkIGZvbGlvIHdhcyBwYXJ0aWFsIGFuZA0KKwkJICog
ICAgIHdlIGNhbid0IGZpdCBpdCBpbiB0aGlzIHdyaXRlIHJlcXVlc3QsIHNvIGl0IHNoYWxsIGJl
IHByb2Nlc3NlZCBpbiB0aGUgbmV4dA0KKwkJICogICAgIHdyaXRlKQ0KKwkJICovDQorCQlpZiAo
c3RvcCkNCisJCQl4YXNfcmVzZXQoeGFzKTsNCisNCiAJCXhhc19wYXVzZSh4YXMpOw0KIAkJcmN1
X3JlYWRfdW5sb2NrKCk7DQogDQpAQCAtMjgxNSw2ICsyODY4LDEzIEBAIHN0YXRpYyB2b2lkIGNp
ZnNfZXh0ZW5kX3dyaXRlYmFjayhzdHJ1Y3QgYWRkcmVzc19zcGFjZSAqbWFwcGluZywNCiAJCQlm
b2xpb191bmxvY2soZm9saW8pOw0KIAkJfQ0KIA0KKwkJLyoNCisJCSAqIEJ5IG5vdywgZGF0YSBo
YXMgYmVlbiB1cGRhdGVkL3dyaXR0ZW4gb3V0IHRvIEBtYXBwaW5nLCBzbyBmcm9tIHRoaXMgcG9p
bnQgb2YNCisJCSAqIHZpZXcgd2UncmUgZG9uZSBhbmQgd2UgY2FuIHNhZmVseSB1cGRhdGUgQF9s
ZW4gYW5kIEBfY291bnQuDQorCQkgKi8NCisJCSpfbGVuID0gbGVuOw0KKwkJKl9jb3VudCA9IGNv
dW50Ow0KKw0KIAkJZm9saW9fYmF0Y2hfcmVsZWFzZSgmYmF0Y2gpOw0KIAkJY29uZF9yZXNjaGVk
KCk7DQogCX0gd2hpbGUgKCFzdG9wKTsNCkBAIC0yOTAyLDcgKzI5NjIsOCBAQCBzdGF0aWMgc3Np
emVfdCBjaWZzX3dyaXRlX2JhY2tfZnJvbV9sb2NrZWRfZm9saW8oc3RydWN0IGFkZHJlc3Nfc3Bh
Y2UgKm1hcHBpbmcsDQogDQogCQkJaWYgKG1heF9wYWdlcyA+IDApDQogCQkJCWNpZnNfZXh0ZW5k
X3dyaXRlYmFjayhtYXBwaW5nLCB4YXMsICZjb3VudCwgc3RhcnQsDQotCQkJCQkJICAgICAgbWF4
X3BhZ2VzLCBtYXhfbGVuLCAmbGVuKTsNCisJCQkJCQkgICAgICBtYXhfcGFnZXMsIG1heF9sZW4s
ICZsZW4sDQorCQkJCQkJICAgICAgd2JjLT5zeW5jX21vZGUpOw0KIAkJfQ0KIAl9DQogCWxlbiA9
IG1pbl90KHVuc2lnbmVkIGxvbmcgbG9uZywgbGVuLCBpX3NpemUgLSBzdGFydCk7DQotLSANCjIu
NDguMQ0KDQo=
--000000000000edaf3f0642ee53ee--
