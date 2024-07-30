Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57581AA3C5
	for <linux-cifs@vger.kernel.org>; Tue, 30 Jul 2024 19:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722367523; cv=none; b=YbgzLLu+mpmks5HoKZB4uirMniQ3+Cz7eYeJ2D4KRhh+mYwYTIUh83UefVUxK5Zcm7lVPUnar9TplM0KLMegJkYbOiSNXj9dqbRaD9Il23xkue8qBb1b9E4nZl/lJKrMJa83noJwEsNeIdPu1Moplf6vRtR+rGARJgJJ+A3T7Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722367523; c=relaxed/simple;
	bh=3nKKmxqeGDPksU5j6ap00Im3U5NBnwvhOxBRl7AhYvg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jZXZs4Hfi8CMhWyCN1qEhT7OdGOzQcRktnWaMXbUyaS/JJA/MzD7MtpviaafZL+L4rC5gXE0l1esicQvLptzVM8Pt5lQbF7fT/PbKDHyCtVDJLCjeagAMP7GWixhnsEg7T2xJ19dB0Ddj/SLwllcflTWU+IDDwn5UnNzcqJR1wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IrnCuMTa; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IrnCuMTa"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-52efd530a4eso7775687e87.0
        for <linux-cifs@vger.kernel.org>; Tue, 30 Jul 2024 12:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722367519; x=1722972319; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=09BQsVFTEGV+AB8hjjXTqVoU4J+0/oTGaYSQjYGi4QY=;
        b=IrnCuMTaeuI+Nn6F55j8DY1FLP9xKvisuAMMHF8aM2x0d8xTVEnUJTg/gDQ7A/TG5C
         d2zQ2o8S0NFs9bsf8j+5NoOziEon7qmAzD83Y2kNCIDl3iLhwJWMP9Z8Db+FowDznveW
         QJv9c7lhrbgO9C2EGUWnwq/viWRPkiA11Jwll3mkSDsmihde2425Ddbwez10PdZCn53S
         fZjd9+b4ezv4gBlsHmHShhbPZYeM6pboam2VLTAvEvOTZ/0K9AtxWVsWGknJWu79DpD5
         bPCQcQS8aNelYpJTrS1N11n2Rsav6frPgSdLx1PTgQtAUbsBOg8LkLK7CpiDWvKKA94V
         gQdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722367519; x=1722972319;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=09BQsVFTEGV+AB8hjjXTqVoU4J+0/oTGaYSQjYGi4QY=;
        b=n4m/mD+nGyKeNU0554WjX+2ZsjHaTTu5e5sZ8ynNHwXz4XLz2IZ/z0VmI7ZUOGf9HN
         cFFNCx7k8ciOohZP+15uxYPSUfsCxNkYM7xlxtzjxy9GNPm5fbbduub6g4jUE6lzV4u9
         HjUh2/nU+JA8H7K5zTa3vNy16jl/rQQe+NHAuUMiLCrAtdsD6AXKwlCnHASJLTScJK5Q
         lDKJZPCu6svMqwXYF+Lyq9xSWxncbqNnyj2Vl4GXY1P9SAtrKthTjcTb+wtFQvEY66qU
         Xf7eEuvxaLUVVuS0cjuAuDVY/TDnW0CXScRXtchhWNMmTB7465+NTmCujhHzRbfFwITC
         L7ww==
X-Gm-Message-State: AOJu0YxaWbQSt4wNQVkEevq4t6Z/q3vulHrqcqaalVzUQhSxgBnSUSdn
	F2yEII9+Dhp8q6bjSQheCg8wQiSwCXzNpTbkbjIWCOqGLe2P6PhNU+M6ck0Jv3a6g2etLuUQpj1
	RtEO/batFxz7cNCL40/QbrRLdwpvqFQ==
X-Google-Smtp-Source: AGHT+IFm6CmLrBK2iEPrHll8vGmJFbJKLzmllGwQnhQKJQTwNJwmZ7vJ9CCs1YIIDCghnOWKjOnp0N24T3LhFqgRw9E=
X-Received: by 2002:a05:651c:201:b0:2ef:2d4c:b4ba with SMTP id
 38308e7fff4ca-2f12ee5bca7mr80652891fa.36.1722367519076; Tue, 30 Jul 2024
 12:25:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5msodFELeYf5h3h1qqR-tgaE6ZNMMbWvFbFDzCjDjPnqsA@mail.gmail.com>
In-Reply-To: <CAH2r5msodFELeYf5h3h1qqR-tgaE6ZNMMbWvFbFDzCjDjPnqsA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 30 Jul 2024 14:25:07 -0500
Message-ID: <CAH2r5msJ0=ny39n1sL80+sO30q0inw7w=MC_Zkpa+iO41CfA_g@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] add dynamic tracepoints for shutdown ioctl
To: CIFS <linux-cifs@vger.kernel.org>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, Bharath S M <bharathsm@microsoft.com>
Content-Type: multipart/mixed; boundary="0000000000002679d2061e7bf0f5"

--0000000000002679d2061e7bf0f5
Content-Type: multipart/alternative; boundary="0000000000002679cf061e7bf0f3"

--0000000000002679cf061e7bf0f3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Minor update to the patch (first goto was incorrect). See attached



On Tue, Jul 30, 2024 at 12:34=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:

> For debugging an umount failure in xfstests generic/043 generic/044 in so=
me
> configurations, we needed more information on the shutdown ioctl which
> was suspected of being related to the cause, so tracepoints are added
> in this patch e.g.
>
>   "trace-cmd record -e smb3_shutdown_enter -e smb3_shutdown_done -e
> smb3_shutdown_err"
>
> Sample output:
>   godown-47084   [011] .....  3313.756965: smb3_shutdown_enter:
> flags=3D0x1 tid=3D0x733b3e75
>   godown-47084   [011] .....  3313.756968: smb3_shutdown_done:
> flags=3D0x1 tid=3D0x733b3e75
>
> See attached
>
>
>
> --
> Thanks,
>
> Steve
>


--=20
Thanks,

Steve

--0000000000002679cf061e7bf0f3
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Minor update to the patch (first goto was incorrect). See =
attached<div><br></div><div><br></div></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Tue, Jul 30, 2024 at 12:34=E2=80=
=AFAM Steve French &lt;<a href=3D"mailto:smfrench@gmail.com">smfrench@gmail=
.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1=
ex">For debugging an umount failure in xfstests generic/043 generic/044 in =
some<br>
configurations, we needed more information on the shutdown ioctl which<br>
was suspected of being related to the cause, so tracepoints are added<br>
in this patch e.g.<br>
<br>
=C2=A0 &quot;trace-cmd record -e smb3_shutdown_enter -e smb3_shutdown_done =
-e<br>
smb3_shutdown_err&quot;<br>
<br>
Sample output:<br>
=C2=A0 godown-47084=C2=A0 =C2=A0[011] .....=C2=A0 3313.756965: smb3_shutdow=
n_enter:<br>
flags=3D0x1 tid=3D0x733b3e75<br>
=C2=A0 godown-47084=C2=A0 =C2=A0[011] .....=C2=A0 3313.756968: smb3_shutdow=
n_done:<br>
flags=3D0x1 tid=3D0x733b3e75<br>
<br>
See attached<br>
<br>
<br>
<br>
-- <br>
Thanks,<br>
<br>
Steve<br>
</blockquote></div><br clear=3D"all"><div><br></div><span class=3D"gmail_si=
gnature_prefix">-- </span><br><div dir=3D"ltr" class=3D"gmail_signature">Th=
anks,<br><br>Steve</div>

--0000000000002679cf061e7bf0f3--
--0000000000002679d2061e7bf0f5
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-dynamic-tracepoints-for-shutdown-ioctl.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-dynamic-tracepoints-for-shutdown-ioctl.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lz8t4zvn0>
X-Attachment-Id: f_lz8t4zvn0

RnJvbSA1MGQ3NTJjY2NhMWIzNTY0ZmE5YWMyODdkMmU5NzRjMTRkMGMzNjljIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMzAgSnVsIDIwMjQgMDA6MjY6MjEgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhZGQgZHluYW1pYyB0cmFjZXBvaW50cyBmb3Igc2h1dGRvd24gaW9jdGwKCkZvciBkZWJ1
Z2dpbmcgYW4gdW1vdW50IGZhaWx1cmUgaW4geGZzdGVzdHMgZ2VuZXJpYy8wNDMgZ2VuZXJpYy8w
NDQgaW4gc29tZQpjb25maWd1cmF0aW9ucywgd2UgbmVlZGVkIG1vcmUgaW5mb3JtYXRpb24gb24g
dGhlIHNodXRkb3duIGlvY3RsIHdoaWNoCndhcyBzdXNwZWN0ZWQgb2YgYmVpbmcgcmVsYXRlZCB0
byB0aGUgY2F1c2UsIHNvIHRyYWNlcG9pbnRzIGFyZSBhZGRlZAppbiB0aGlzIHBhdGNoIGUuZy4K
CiAgInRyYWNlLWNtZCByZWNvcmQgLWUgc21iM19zaHV0ZG93bl9lbnRlciAtZSBzbWIzX3NodXRk
b3duX2RvbmUgLWUgc21iM19zaHV0ZG93bl9lcnIiCgpTYW1wbGUgb3V0cHV0OgogIGdvZG93bi00
NzA4NCAgIFswMTFdIC4uLi4uICAzMzEzLjc1Njk2NTogc21iM19zaHV0ZG93bl9lbnRlcjogZmxh
Z3M9MHgxIHRpZD0weDczM2IzZTc1CiAgZ29kb3duLTQ3MDg0ICAgWzAxMV0gLi4uLi4gIDMzMTMu
NzU2OTY4OiBzbWIzX3NodXRkb3duX2RvbmU6IGZsYWdzPTB4MSB0aWQ9MHg3MzNiM2U3NQoKU2ln
bmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZz
L3NtYi9jbGllbnQvaW9jdGwuYyB8IDMyICsrKysrKysrKysrKysrKysrKysrKy0tLS0tLQogZnMv
c21iL2NsaWVudC90cmFjZS5oIHwgNTEgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrLQogMiBmaWxlcyBjaGFuZ2VkLCA3NSBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvaW9jdGwuYyBiL2ZzL3NtYi9jbGllbnQv
aW9jdGwuYwppbmRleCA4NTVhYzVhNjJlZGYuLjQ0ZGJhZjk5MjlhNCAxMDA2NDQKLS0tIGEvZnMv
c21iL2NsaWVudC9pb2N0bC5jCisrKyBiL2ZzL3NtYi9jbGllbnQvaW9jdGwuYwpAQCAtMTcwLDcg
KzE3MCwxMCBAQCBzdGF0aWMgbG9uZyBzbWJfbW50X2dldF9mc2luZm8odW5zaWduZWQgaW50IHhp
ZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIHN0YXRpYyBpbnQgY2lmc19zaHV0ZG93bihzdHJ1
Y3Qgc3VwZXJfYmxvY2sgKnNiLCB1bnNpZ25lZCBsb25nIGFyZykKIHsKIAlzdHJ1Y3QgY2lmc19z
Yl9pbmZvICpzYmkgPSBDSUZTX1NCKHNiKTsKKwlzdHJ1Y3QgdGNvbl9saW5rICp0bGluazsKKwlz
dHJ1Y3QgY2lmc190Y29uICp0Y29uOwogCV9fdTMyIGZsYWdzOworCWludCByYzsKIAogCWlmICgh
Y2FwYWJsZShDQVBfU1lTX0FETUlOKSkKIAkJcmV0dXJuIC1FUEVSTTsKQEAgLTE3OCwxNCArMTgx
LDIxIEBAIHN0YXRpYyBpbnQgY2lmc19zaHV0ZG93bihzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLCB1
bnNpZ25lZCBsb25nIGFyZykKIAlpZiAoZ2V0X3VzZXIoZmxhZ3MsIChfX3UzMiBfX3VzZXIgKilh
cmcpKQogCQlyZXR1cm4gLUVGQVVMVDsKIAotCWlmIChmbGFncyA+IENJRlNfR09JTkdfRkxBR1Nf
Tk9MT0dGTFVTSCkKLQkJcmV0dXJuIC1FSU5WQUw7CisJdGxpbmsgPSBjaWZzX3NiX3RsaW5rKHNi
aSk7CisJaWYgKElTX0VSUih0bGluaykpCisJCXJldHVybiBQVFJfRVJSKHRsaW5rKTsKKwl0Y29u
ID0gdGxpbmtfdGNvbih0bGluayk7CisKKwl0cmFjZV9zbWIzX3NodXRkb3duX2VudGVyKGZsYWdz
LCB0Y29uLT50aWQpOworCWlmIChmbGFncyA+IENJRlNfR09JTkdfRkxBR1NfTk9MT0dGTFVTSCkg
eworCQlyYyA9IC1FSU5WQUw7CisJCWdvdG8gc2h1dGRvd25fb3V0X2VycjsKKwl9CiAKIAlpZiAo
Y2lmc19mb3JjZWRfc2h1dGRvd24oc2JpKSkKLQkJcmV0dXJuIDA7CisJCWdvdG8gc2h1dGRvd25f
Z29vZDsKIAogCWNpZnNfZGJnKFZGUywgInNodXQgZG93biByZXF1ZXN0ZWQgKCVkKSIsIGZsYWdz
KTsKLS8qCXRyYWNlX2NpZnNfc2h1dGRvd24oc2IsIGZsYWdzKTsqLwogCiAJLyoKIAkgKiBzZWU6
CkBAIC0yMDEsNyArMjExLDggQEAgc3RhdGljIGludCBjaWZzX3NodXRkb3duKHN0cnVjdCBzdXBl
cl9ibG9jayAqc2IsIHVuc2lnbmVkIGxvbmcgYXJnKQogCSAqLwogCWNhc2UgQ0lGU19HT0lOR19G
TEFHU19ERUZBVUxUOgogCQljaWZzX2RiZyhGWUksICJzaHV0ZG93biB3aXRoIGRlZmF1bHQgZmxh
ZyBub3Qgc3VwcG9ydGVkXG4iKTsKLQkJcmV0dXJuIC1FSU5WQUw7CisJCXJjID0gLUVJTlZBTDsK
KwkJZ290byBzaHV0ZG93bl9vdXRfZXJyOwogCS8qCiAJICogRkxBR1NfTE9HRkxVU0ggaXMgZWFz
eSBzaW5jZSBpdCBhc2tzIHRvIHdyaXRlIG91dCBtZXRhZGF0YSAobm90CiAJICogZGF0YSkgYnV0
IG1ldGFkYXRhIHdyaXRlcyBhcmUgbm90IGNhY2hlZCBvbiB0aGUgY2xpZW50LCBzbyBjYW4gdHJl
YXQKQEAgLTIxMCwxMSArMjIxLDE4IEBAIHN0YXRpYyBpbnQgY2lmc19zaHV0ZG93bihzdHJ1Y3Qg
c3VwZXJfYmxvY2sgKnNiLCB1bnNpZ25lZCBsb25nIGFyZykKIAljYXNlIENJRlNfR09JTkdfRkxB
R1NfTE9HRkxVU0g6CiAJY2FzZSBDSUZTX0dPSU5HX0ZMQUdTX05PTE9HRkxVU0g6CiAJCXNiaS0+
bW50X2NpZnNfZmxhZ3MgfD0gQ0lGU19NT1VOVF9TSFVURE9XTjsKLQkJcmV0dXJuIDA7CisJCWdv
dG8gc2h1dGRvd25fZ29vZDsKIAlkZWZhdWx0OgotCQlyZXR1cm4gLUVJTlZBTDsKKwkJcmMgPSAt
RUlOVkFMOworCQlnb3RvIHNodXRkb3duX291dF9lcnI7CiAJfQorCitzaHV0ZG93bl9nb29kOgor
CXRyYWNlX3NtYjNfc2h1dGRvd25fZG9uZShmbGFncywgdGNvbi0+dGlkKTsKIAlyZXR1cm4gMDsK
K3NodXRkb3duX291dF9lcnI6CisJdHJhY2Vfc21iM19zaHV0ZG93bl9lcnIocmMsIGZsYWdzLCB0
Y29uLT50aWQpOworCXJldHVybiByYzsKIH0KIAogc3RhdGljIGludCBjaWZzX2R1bXBfZnVsbF9r
ZXkoc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwgc3RydWN0IHNtYjNfZnVsbF9rZXlfZGVidWdfaW5m
byBfX3VzZXIgKmluKQpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC90cmFjZS5oIGIvZnMvc21i
L2NsaWVudC90cmFjZS5oCmluZGV4IDZiM2JkZmI5NzIxMS4uMGYwYzEwYzdhZGE3IDEwMDY0NAot
LS0gYS9mcy9zbWIvY2xpZW50L3RyYWNlLmgKKysrIGIvZnMvc21iL2NsaWVudC90cmFjZS5oCkBA
IC0xMzg4LDcgKzEzODgsNyBAQCBERUNMQVJFX0VWRU5UX0NMQVNTKHNtYjNfaW9jdGxfY2xhc3Ms
CiAJCV9fZW50cnktPmNvbW1hbmQgPSBjb21tYW5kOwogCSksCiAJVFBfcHJpbnRrKCJ4aWQ9JXUg
ZmlkPTB4JWxseCBpb2N0bCBjbWQ9MHgleCIsCi0JCV9fZW50cnktPnhpZCwgX19lbnRyeS0+Zmlk
LCBfX2VudHJ5LT5jb21tYW5kKQorCQkgIF9fZW50cnktPnhpZCwgX19lbnRyeS0+ZmlkLCBfX2Vu
dHJ5LT5jb21tYW5kKQogKQogCiAjZGVmaW5lIERFRklORV9TTUIzX0lPQ1RMX0VWRU5UKG5hbWUp
ICAgICAgICBcCkBAIC0xNDAwLDkgKzE0MDAsNTggQEAgREVGSU5FX0VWRU5UKHNtYjNfaW9jdGxf
Y2xhc3MsIHNtYjNfIyNuYW1lLCAgXAogCiBERUZJTkVfU01CM19JT0NUTF9FVkVOVChpb2N0bCk7
CiAKK0RFQ0xBUkVfRVZFTlRfQ0xBU1Moc21iM19zaHV0ZG93bl9jbGFzcywKKwlUUF9QUk9UTyhf
X3UzMiBmbGFncywKKwkJX191MzIgdGlkKSwKKwlUUF9BUkdTKGZsYWdzLCB0aWQpLAorCVRQX1NU
UlVDVF9fZW50cnkoCisJCV9fZmllbGQoX191MzIsIGZsYWdzKQorCQlfX2ZpZWxkKF9fdTMyLCB0
aWQpCisJKSwKKwlUUF9mYXN0X2Fzc2lnbigKKwkJX19lbnRyeS0+ZmxhZ3MgPSBmbGFnczsKKwkJ
X19lbnRyeS0+dGlkID0gdGlkOworCSksCisJVFBfcHJpbnRrKCJmbGFncz0weCV4IHRpZD0weCV4
IiwKKwkJICBfX2VudHJ5LT5mbGFncywgX19lbnRyeS0+dGlkKQorKQorCisjZGVmaW5lIERFRklO
RV9TTUIzX1NIVVRET1dOX0VWRU5UKG5hbWUpICAgICAgICBcCitERUZJTkVfRVZFTlQoc21iM19z
aHV0ZG93bl9jbGFzcywgc21iM18jI25hbWUsICBcCisJVFBfUFJPVE8oX191MzIgZmxhZ3MsCQkg
ICAgIFwKKwkJX191MzIgdGlkKSwJCSAgICAgXAorCVRQX0FSR1MoZmxhZ3MsIHRpZCkpCisKK0RF
RklORV9TTUIzX1NIVVRET1dOX0VWRU5UKHNodXRkb3duX2VudGVyKTsKK0RFRklORV9TTUIzX1NI
VVRET1dOX0VWRU5UKHNodXRkb3duX2RvbmUpOwogCitERUNMQVJFX0VWRU5UX0NMQVNTKHNtYjNf
c2h1dGRvd25fZXJyX2NsYXNzLAorCVRQX1BST1RPKGludCByYywKKwkJX191MzIgZmxhZ3MsCisJ
CV9fdTMyIHRpZCksCisJVFBfQVJHUyhyYywgZmxhZ3MsIHRpZCksCisJVFBfU1RSVUNUX19lbnRy
eSgKKwkJX19maWVsZChpbnQsIHJjKQorCQlfX2ZpZWxkKF9fdTMyLCBmbGFncykKKwkJX19maWVs
ZChfX3UzMiwgdGlkKQorCSksCisJVFBfZmFzdF9hc3NpZ24oCisJCV9fZW50cnktPnJjID0gcmM7
CisJCV9fZW50cnktPmZsYWdzID0gZmxhZ3M7CisJCV9fZW50cnktPnRpZCA9IHRpZDsKKwkpLAor
CVRQX3ByaW50aygicmM9JWQgZmxhZ3M9MHgleCB0aWQ9MHgleCIsCisJCV9fZW50cnktPnJjLCBf
X2VudHJ5LT5mbGFncywgX19lbnRyeS0+dGlkKQorKQogCisjZGVmaW5lIERFRklORV9TTUIzX1NI
VVRET1dOX0VSUl9FVkVOVChuYW1lKSAgICAgICAgXAorREVGSU5FX0VWRU5UKHNtYjNfc2h1dGRv
d25fZXJyX2NsYXNzLCBzbWIzXyMjbmFtZSwgIFwKKwlUUF9QUk9UTyhpbnQgcmMsCQkgICAgIFwK
KwkJX191MzIgZmxhZ3MsCQkgICAgIFwKKwkJX191MzIgdGlkKSwJCSAgICAgXAorCVRQX0FSR1Mo
cmMsIGZsYWdzLCB0aWQpKQogCitERUZJTkVfU01CM19TSFVURE9XTl9FUlJfRVZFTlQoc2h1dGRv
d25fZXJyKTsKIAogREVDTEFSRV9FVkVOVF9DTEFTUyhzbWIzX2NyZWRpdF9jbGFzcywKIAlUUF9Q
Uk9UTyhfX3U2NAljdXJybWlkLAotLSAKMi40My4wCgo=
--0000000000002679d2061e7bf0f5--
