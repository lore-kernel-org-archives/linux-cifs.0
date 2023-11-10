Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB871877
	for <linux-cifs@vger.kernel.org>; Fri, 10 Nov 2023 07:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KvaEuCja"
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD1F825D
	for <linux-cifs@vger.kernel.org>; Thu,  9 Nov 2023 23:10:04 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-5094cb3a036so2260997e87.2
        for <linux-cifs@vger.kernel.org>; Thu, 09 Nov 2023 23:10:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699600202; x=1700205002; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YJP5qTRtuZcVZvUNSgHKo7QSwb9ciHUra42VIGSwBpg=;
        b=KvaEuCjap7gypqcJ0VRJ7HKCvtGivWBPCLgNZXOSwi7aShrKYMsUPlueiSTPAp0L/H
         BEBKI6y3oqPuyXOtjkRdCX+Hi7LeBBk3DQGy+1BSaV2IGDq+Cv1OkEcG0kLDnR3hI3pD
         KOzCihQW7bHHjPIH7vVmwgO2cLmWD+KooZfxzQpaVGitjgnpXpPOibCo350G4/3jtmNQ
         mbA/AEfzU1E6LXicTpCne9wP2wa5HQsOSVbp+izZfnN7IvrEYpyqy9B26bNmgSHBOSyj
         CnIQ1xRvEISYnHLqDA431HDdJlbarCXpuj8iOZCisQ1dztzdtBdWolCTjY8RgZFfaW6J
         34vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699600202; x=1700205002;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YJP5qTRtuZcVZvUNSgHKo7QSwb9ciHUra42VIGSwBpg=;
        b=wsdI41CUNGEcsrtShzDDlzFuLKnpmkQVHeqtFBxootbTdqup2ZxLuuUJCWLdDswJ8C
         F7YTI8AN81TQuTxe90H1FAs4TDKaQ5OMA7xlC70kynqNbwScbtZqtkYe43BK/aikOf7m
         CipNhSbZsC4NGyb4OyzKWR+Xk+7mByWj7HxudDUZqNdGz02+CZUUKwa5a/SLVIK3fKRU
         DDd0xJj+LIF6+zxslRJ3f0dzncqbHlY+Bv1Gt79Q76lqfvB432UBwq33ctVFkhWdebVa
         aZkX2dMyrw2wal1y5xLQLfCcrX5DfEPb6YKDs/iQRBVtI4LSAauv0vfo3wrmhH0k519T
         mcqA==
X-Gm-Message-State: AOJu0YywYhYclTDNx98wC2fmkrYKnnjPd9xyVYcFUupDSSf9ckbij2j3
	eVo7MXamcxUNXeNlhgCjmpieMGBs4sg9k9IgxyB8v4/qLRrjV55u
X-Google-Smtp-Source: AGHT+IHm4Jxh0L2SD39HlEEFtLhcp35pC028LV4wfCSsv7srAhe6FIz7fmE9ivtkNstAR/Xq5r3rw9i57aYnBsNh7QU=
X-Received: by 2002:ac2:44d8:0:b0:509:44cd:241c with SMTP id
 d24-20020ac244d8000000b0050944cd241cmr3101543lfm.32.1699600202119; Thu, 09
 Nov 2023 23:10:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mt-t0QDZk4Zz+cSs8=s=VhUW09erUBAtm8f7xXG3rHJqw@mail.gmail.com>
 <CAH2r5mtWC4hX8v-CwDQC6qp4tWzdNaMSag9myYM4dGmC4zr9FA@mail.gmail.com>
In-Reply-To: <CAH2r5mtWC4hX8v-CwDQC6qp4tWzdNaMSag9myYM4dGmC4zr9FA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 10 Nov 2023 01:09:50 -0600
Message-ID: <CAH2r5mugOefduw_pgpYCZtHPiuosSQrcOKb0MFcv8v7giEopMA@mail.gmail.com>
Subject: Re: [PATCH][smb3 client] allow debugging session and tcon info to
 improve stats analysis and debugging
To: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="0000000000004f3f560609c702e8"

--0000000000004f3f560609c702e8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Fixed one minor bug (missing cifs_put_tlink call to free reference on
tlink) and updated cifs-2.6.git for-next

See attached (updated patch)


On Thu, Nov 9, 2023 at 8:51=E2=80=AFPM Steve French <smfrench@gmail.com> wr=
ote:
>
> Updated patch to remove dumping of flags (tcon->Flags was already
> supposed to be dumped via
> the other ioctl (CIFS_IOC_GET_MNT_INFO) but it had a minor bug - will
> send followon patch for that)
>
>
> On Thu, Nov 9, 2023 at 3:51=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
> >
> > [PATCH] smb3: allow debugging session and tcon info to improve stats
> >  analysis and debugging
> >
> > When multiple mounts are to the same share from the same client it was =
not
> > possible to determine which section of /proc/fs/cifs/Stats (and DebugDa=
ta)
> > correspond to that mount.  In some recent examples this turned out to  =
be
> > a significant problem when trying to analyze performance problems - sin=
ce
> > there are many cases where unless we know the tree id and session id we
> > can't figure out which stats (e.g. number of SMB3.1.1 requests by type,
> > the total time they take, which is slowest, how many fail etc.) apply t=
o
> > which mount.
> >
> > Add an ioctl to return tid, session id, tree connect count and tcon fla=
gs.
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve



--
Thanks,

Steve

--0000000000004f3f560609c702e8
Content-Type: application/x-patch; 
	name="0001-smb3-allow-dumping-session-and-tcon-id-to-improve-st.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-allow-dumping-session-and-tcon-id-to-improve-st.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_losa10tl0>
X-Attachment-Id: f_losa10tl0

RnJvbSBlNTE5YmQxOTdhN2UyZjU4ZTA4MGYxNjk0OTk3NTdkYTg4MTIyNGI0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgOSBOb3YgMjAyMyAxNToyODoxMiAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGFsbG93IGR1bXBpbmcgc2Vzc2lvbiBhbmQgdGNvbiBpZCB0byBpbXByb3ZlIHN0YXRzCiBh
bmFseXNpcyBhbmQgZGVidWdnaW5nCgpXaGVuIG11bHRpcGxlIG1vdW50cyBhcmUgdG8gdGhlIHNh
bWUgc2hhcmUgZnJvbSB0aGUgc2FtZSBjbGllbnQgaXQgd2FzIG5vdApwb3NzaWJsZSB0byBkZXRl
cm1pbmUgd2hpY2ggc2VjdGlvbiBvZiAvcHJvYy9mcy9jaWZzL1N0YXRzIChhbmQgRGVidWdEYXRh
KQpjb3JyZXNwb25kIHRvIHRoYXQgbW91bnQuICBJbiBzb21lIHJlY2VudCBleGFtcGxlcyB0aGlz
IHR1cm5lZCBvdXQgdG8gIGJlCmEgc2lnbmlmaWNhbnQgcHJvYmxlbSB3aGVuIHRyeWluZyB0byBh
bmFseXplIHBlcmZvcm1hbmNlIGRhdGEgLSBzaW5jZQp0aGVyZSBhcmUgbWFueSBjYXNlcyB3aGVy
ZSB1bmxlc3Mgd2Uga25vdyB0aGUgdHJlZSBpZCBhbmQgc2Vzc2lvbiBpZCB3ZQpjYW4ndCBmaWd1
cmUgb3V0IHdoaWNoIHN0YXRzIChlLmcuIG51bWJlciBvZiBTTUIzLjEuMSByZXF1ZXN0cyBieSB0
eXBlLAp0aGUgdG90YWwgdGltZSB0aGV5IHRha2UsIHdoaWNoIGlzIHNsb3dlc3QsIGhvdyBtYW55
IGZhaWwgZXRjLikgYXBwbHkgdG8Kd2hpY2ggbW91bnQuIFRoZSBvbmx5IGV4aXN0aW5nIGxvb3Nl
bHkgcmVsYXRlZCBpb2N0bCBDSUZTX0lPQ19HRVRfTU5UX0lORk8KZG9lcyBub3QgcmV0dXJuIHRo
ZSBpbmZvcm1hdGlvbiBuZWVkZWQgdG8gdW5pcXVlbHkgaWRlbnRpZnkgd2hpY2ggdGNvbgppcyB3
aGljaCBtb3VudCBhbHRob3VnaCBpdCBkb2VzIHJldHVybiB2YXJpb3VzIGZsYWdzIGFuZCBkZXZp
Y2UgaW5mby4KCkFkZCBhIGNpZnMua28gaW9jdGwgQ0lGU19JT0NfR0VUX1RDT05fSU5GTyAoMHg4
MDBjY2YwYykgdG8gcmV0dXJuIHRpZCwKc2Vzc2lvbiBpZCwgdHJlZSBjb25uZWN0IGNvdW50LgoK
Q2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxz
dGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL3NtYi9jbGllbnQvY2lmc19pb2N0bC5oIHwg
IDYgKysrKysrCiBmcy9zbWIvY2xpZW50L2lvY3RsLmMgICAgICB8IDI1ICsrKysrKysrKysrKysr
KysrKysrKysrKysKIDIgZmlsZXMgY2hhbmdlZCwgMzEgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdp
dCBhL2ZzL3NtYi9jbGllbnQvY2lmc19pb2N0bC5oIGIvZnMvc21iL2NsaWVudC9jaWZzX2lvY3Rs
LmgKaW5kZXggMzMyNTg4ZTc3YzMxLi4yNjMyNzQ0MmUzODMgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9j
bGllbnQvY2lmc19pb2N0bC5oCisrKyBiL2ZzL3NtYi9jbGllbnQvY2lmc19pb2N0bC5oCkBAIC0y
Niw2ICsyNiwxMSBAQCBzdHJ1Y3Qgc21iX21udF9mc19pbmZvIHsKIAlfX3U2NCAgIGNpZnNfcG9z
aXhfY2FwczsKIH0gX19wYWNrZWQ7CiAKK3N0cnVjdCBzbWJfbW50X3Rjb25faW5mbyB7CisJX191
MzIJdGlkOworCV9fdTY0CXNlc3Npb25faWQ7Cit9IF9fcGFja2VkOworCiBzdHJ1Y3Qgc21iX3Nu
YXBzaG90X2FycmF5IHsKIAlfX3UzMgludW1iZXJfb2Zfc25hcHNob3RzOwogCV9fdTMyCW51bWJl
cl9vZl9zbmFwc2hvdHNfcmV0dXJuZWQ7CkBAIC0xMDgsNiArMTEzLDcgQEAgc3RydWN0IHNtYjNf
bm90aWZ5X2luZm8gewogI2RlZmluZSBDSUZTX0lPQ19OT1RJRlkgX0lPVyhDSUZTX0lPQ1RMX01B
R0lDLCA5LCBzdHJ1Y3Qgc21iM19ub3RpZnkpCiAjZGVmaW5lIENJRlNfRFVNUF9GVUxMX0tFWSBf
SU9XUihDSUZTX0lPQ1RMX01BR0lDLCAxMCwgc3RydWN0IHNtYjNfZnVsbF9rZXlfZGVidWdfaW5m
bykKICNkZWZpbmUgQ0lGU19JT0NfTk9USUZZX0lORk8gX0lPV1IoQ0lGU19JT0NUTF9NQUdJQywg
MTEsIHN0cnVjdCBzbWIzX25vdGlmeV9pbmZvKQorI2RlZmluZSBDSUZTX0lPQ19HRVRfVENPTl9J
TkZPIF9JT1IoQ0lGU19JT0NUTF9NQUdJQywgMTIsIHN0cnVjdCBzbWJfbW50X3Rjb25faW5mbykK
ICNkZWZpbmUgQ0lGU19JT0NfU0hVVERPV04gX0lPUignWCcsIDEyNSwgX191MzIpCiAKIC8qCmRp
ZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2lvY3RsLmMgYi9mcy9zbWIvY2xpZW50L2lvY3RsLmMK
aW5kZXggZjcxNjAwMDNlMGVkLi43M2VkZWRhOGViYTUgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGll
bnQvaW9jdGwuYworKysgYi9mcy9zbWIvY2xpZW50L2lvY3RsLmMKQEAgLTExNyw2ICsxMTcsMjAg
QEAgc3RhdGljIGxvbmcgY2lmc19pb2N0bF9jb3B5Y2h1bmsodW5zaWduZWQgaW50IHhpZCwgc3Ry
dWN0IGZpbGUgKmRzdF9maWxlLAogCXJldHVybiByYzsKIH0KIAorc3RhdGljIGxvbmcgc21iX21u
dF9nZXRfdGNvbl9pbmZvKHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sIHZvaWQgX191c2VyICphcmcp
Cit7CisJaW50IHJjID0gMDsKKwlzdHJ1Y3Qgc21iX21udF90Y29uX2luZm8gdGNvbl9pbmY7CisK
Kwl0Y29uX2luZi50aWQgPSB0Y29uLT50aWQ7CisJdGNvbl9pbmYuc2Vzc2lvbl9pZCA9IHRjb24t
PnNlcy0+U3VpZDsKKworCWlmIChjb3B5X3RvX3VzZXIoYXJnLCAmdGNvbl9pbmYsIHNpemVvZihz
dHJ1Y3Qgc21iX21udF90Y29uX2luZm8pKSkKKwkJcmMgPSAtRUZBVUxUOworCisJcmV0dXJuIHJj
OworfQorCiBzdGF0aWMgbG9uZyBzbWJfbW50X2dldF9mc2luZm8odW5zaWduZWQgaW50IHhpZCwg
c3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJCQl2b2lkIF9fdXNlciAqYXJnKQogewpAQCAtNDE0
LDYgKzQyOCwxNyBAQCBsb25nIGNpZnNfaW9jdGwoc3RydWN0IGZpbGUgKmZpbGVwLCB1bnNpZ25l
ZCBpbnQgY29tbWFuZCwgdW5zaWduZWQgbG9uZyBhcmcpCiAJCQl0Y29uID0gdGxpbmtfdGNvbihw
U01CRmlsZS0+dGxpbmspOwogCQkJcmMgPSBzbWJfbW50X2dldF9mc2luZm8oeGlkLCB0Y29uLCAo
dm9pZCBfX3VzZXIgKilhcmcpOwogCQkJYnJlYWs7CisJCWNhc2UgQ0lGU19JT0NfR0VUX1RDT05f
SU5GTzoKKwkJCWNpZnNfc2IgPSBDSUZTX1NCKGlub2RlLT5pX3NiKTsKKwkJCXRsaW5rID0gY2lm
c19zYl90bGluayhjaWZzX3NiKTsKKwkJCWlmIChJU19FUlIodGxpbmspKSB7CisJCQkJcmMgPSBQ
VFJfRVJSKHRsaW5rKTsKKwkJCQlicmVhazsKKwkJCX0KKwkJCXRjb24gPSB0bGlua190Y29uKHRs
aW5rKTsKKwkJCXJjID0gc21iX21udF9nZXRfdGNvbl9pbmZvKHRjb24sICh2b2lkIF9fdXNlciAq
KWFyZyk7CisJCQljaWZzX3B1dF90bGluayh0bGluayk7CisJCQlicmVhazsKIAkJY2FzZSBDSUZT
X0VOVU1FUkFURV9TTkFQU0hPVFM6CiAJCQlpZiAocFNNQkZpbGUgPT0gTlVMTCkKIAkJCQlicmVh
azsKLS0gCjIuMzkuMgoK
--0000000000004f3f560609c702e8--
