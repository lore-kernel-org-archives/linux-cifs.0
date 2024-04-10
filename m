Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EF512E73
	for <linux-cifs@vger.kernel.org>; Wed, 10 Apr 2024 06:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712731151; cv=none; b=Y/BmTMOWueHmssn4nfeJfoLtU+FVzv2HvXwvpDuzz79AjAdulGqM6743LKfQG/r8qCN1ctgpUR1oPtfM53P0HBp+qHvSaOt5i6lQEgR7QQAsWEt/Ima9DYryEdHmYv6PFUYfF/r1HXqHtEeW6Q8m0eIiYGUHJRja1KnnRPl1y6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712731151; c=relaxed/simple;
	bh=B9U4RAod8ppxexu6VCdoCOzOIxalMOiR57+xdnPAxOE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tHtvZ376fl7WgIuoivyg6uzOH2WJj5uPfsSySlP/1i47rT6XmpJmfw/9oyMI01ONosdiI+f2zuNzdo882T3AJekuHILPYev6pj0GvbLete77o10gO+f3uxMqYxj45sb1u0biy4ZqpIwiw8YDyJpLg3W8cAI14k7gcdUlifV+JxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3I7AHLeJ; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3I7AHLeJ"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-434ffc2b520so136821cf.0
        for <linux-cifs@vger.kernel.org>; Tue, 09 Apr 2024 23:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712731148; x=1713335948; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0dboPWTzsLcjAmdXsTUafVmjVeuu8qgi0h5yfaWPb04=;
        b=3I7AHLeJlzElQJYXzHFUDLuBVi9PQwtw3urmEc8xCs1Whs+muX3qSJ+aDHAMclKnZU
         o//YwL6ssf6zNDhHjnNfWJ+lR+XGmrqCK4DgkBoXP6Ox/GimxnoCSfXg7kWezMJ6ihQk
         Jw+4mU4EzMHpYF5C8/jB+eEu7zkmFWZgxAMwO7BBolzMFfA2G7NxIIlCs/1oqgPgJJFP
         t2Otv3lBS8hddst9rqaeV5MyAFo2j6LEwqNAFneITIxHbirXJBF6j+KN0ByJdIirtr8Y
         9OTjhgS6LUtUYgsBLWzCQYknwO80QprNKQ9ZKkZQM5e20khO1U8/6xuToqK9BozfkHfw
         hC/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712731148; x=1713335948;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0dboPWTzsLcjAmdXsTUafVmjVeuu8qgi0h5yfaWPb04=;
        b=HnFNGE42JQf7+ElYOOIkCzTeJ1cYvWxFf1vgQnAe+iWpu8oyPbKLuKFtIj/mL32nBl
         nJoW9PN75wp3AvKX2Kd35rs2s06eGjCzTRt6/JupgOg9QFs4ZXAUy/tlnMPt9Q9f0WYT
         XRi7BkWudFcZdkoBQKDPzbJ8IoUT67oXWLqGjuLmccbyfDau5BDqS5AN9NSWQE/lRfwP
         cZxsPIf+jslRbhXpLhx62oUuoaHfByFk/fE9IX9b5r2cA9L8l195rClUXvCQi0tZ/zkf
         6WXhFH4+Ej91EjeXchBO/SoMJmvnpL/Y9C+8OCqekE/WG/2KlB+DKrZBxVngxKIf5gZN
         Cw2A==
X-Forwarded-Encrypted: i=1; AJvYcCUT5xRRWxVOKsS1slsityrBAdhRfB1NkCHnWggYlkjiqxWZ9N+HGhC28HX1ZMh1IGLTavuFrWZi1nhgYQJbAZMciQSP7avcSJPSyA==
X-Gm-Message-State: AOJu0YwQEttFZYmSUMhoWyjPxW110m/5lnz5U1XyijOsSCN/8WSmqAaD
	MaH6O8ENFY2aGN/fZfQIzsdJUdy0oxiCKoJl8g7zUDw9zEV4atYOwimBVJNKf8d6G9NTQ8nRqiZ
	L8n2OgYydyK+Z+9ipXwzUL8bWGzqRuDmzisMD
X-Google-Smtp-Source: AGHT+IG1KM7vRRi7XPfRJYZepUYKpdpB6nJG5Q5dTylEBNGc4+hpCNj/pxkpKJ7YEzcW8id6Eep5yMTFSk1AOCVj27k=
X-Received: by 2002:a05:622a:5513:b0:434:b6cc:4786 with SMTP id
 fj19-20020a05622a551300b00434b6cc4786mr164498qtb.19.1712731148448; Tue, 09
 Apr 2024 23:39:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOdxtTa0S125Lx=ipe7t_sfrBCiTqftb2=OHQcZsiXkVxvi9ZA@mail.gmail.com>
In-Reply-To: <CAOdxtTa0S125Lx=ipe7t_sfrBCiTqftb2=OHQcZsiXkVxvi9ZA@mail.gmail.com>
From: Chenglong Tang <chenglongtang@google.com>
Date: Tue, 9 Apr 2024 23:38:57 -0700
Message-ID: <CAOdxtTZhsy4=Eo+HV80ZJorasg31aWgMFSRjxjoA582HAMfnzQ@mail.gmail.com>
Subject: Re: kernel panic caused by recent changes in fs/cifs
To: stable@vger.kernel.org
Cc: regressions@lists.linux.dev, pc@manguebit.com, linkinjeon@kernel.org, 
	dhowells@redhat.com, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, Oleksandr Tymoshenko <ovt@google.com>, 
	Robert Kolchmeyer <rkolchmeyer@google.com>
Content-Type: multipart/mixed; boundary="000000000000b362700615b84b94"

--000000000000b362700615b84b94
Content-Type: multipart/alternative; boundary="000000000000b3626f0615b84b92"

--000000000000b3626f0615b84b92
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Here is the backtrace.

On Tue, Apr 9, 2024 at 11:37=E2=80=AFPM Chenglong Tang <chenglongtang@googl=
e.com>
wrote:

> Hi, developers,
>
> This is Chenglong Tang from the Google Container Optimized OS team. We
> recently received a kernel panic bug from the customers regarding cifs.
>
> This happened since the backport of following changes in cifs(in our
> kernel COS-5.10.208 and COS-5.15.146):
>
> cifs: Fix non-availability of dedup breaking generic/304:
> https://lore.kernel.org/r/3876191.1701555260@warthog.procyon.org.uk/
> smb: client: fix potential NULL deref in parse_dfs_referrals(): Upstream
> commit 92414333eb375ed64f4ae92d34d579e826936480
> ksmbd: fix wrong name of SMB2_CREATE_ALLOCATION_SIZE: Upstream
> commit  13736654481198e519059d4a2e2e3b20fa9fdb3e
> smb: client: fix NULL deref in asn1_ber_decoder(): Upstream commit
> 90d025c2e953c11974e76637977c473200593a46
> smb: a few more smb changes...
>
> The line that crashed is line 197 in fs/cifs/dfs_cache.c
> ```
> if (unlikely(strcmp(cp->charset, cache_cp->charset))) {
> ```
> I attached the dmesg and backtrace for debugging purposes. Let me know if
> you need more information.
>
> Best,
>
> Chenglong
>

--000000000000b3626f0615b84b92
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Here is the backtrace.</div><br><div class=3D"gmail_quote"=
><div dir=3D"ltr" class=3D"gmail_attr">On Tue, Apr 9, 2024 at 11:37=E2=80=
=AFPM Chenglong Tang &lt;<a href=3D"mailto:chenglongtang@google.com">chengl=
ongtang@google.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote=
" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);=
padding-left:1ex"><div dir=3D"ltr">Hi, developers,<div><br></div><div>This =
is Chenglong Tang from the Google Container Optimized OS team. We recently =
received a kernel panic bug from the customers regarding cifs.=C2=A0</div><=
div><br></div><div>This happened since the backport of following changes in=
 cifs(in our kernel COS-5.10.208 and COS-5.15.146):</div><div><br></div><di=
v>cifs: Fix non-availability of dedup breaking generic/304: <a href=3D"http=
s://lore.kernel.org/r/3876191.1701555260@warthog.procyon.org.uk/" target=3D=
"_blank">https://lore.kernel.org/r/3876191.1701555260@warthog.procyon.org.u=
k/</a><br></div><div>smb: client: fix potential NULL deref in parse_dfs_ref=
errals(): Upstream commit 92414333eb375ed64f4ae92d34d579e826936480<br></div=
><div>ksmbd: fix wrong name of SMB2_CREATE_ALLOCATION_SIZE: Upstream commit=
=C2=A0=C2=A013736654481198e519059d4a2e2e3b20fa9fdb3e<br></div><div>smb: cli=
ent: fix NULL deref in asn1_ber_decoder(): Upstream commit 90d025c2e953c119=
74e76637977c473200593a46<br></div><div>smb: a few more smb changes...</div>=
<div><br></div><div>The=C2=A0line that crashed is line 197 in fs/cifs/dfs_c=
ache.c</div><div>```</div><div><span style=3D"box-sizing:border-box;margin:=
0px;padding:0px;color:rgb(0,0,136);font-family:&quot;Source Code Pro&quot;,=
monospace;font-size:13.3333px;white-space:pre-wrap">if</span><span style=3D=
"box-sizing:border-box;margin:0px;padding:0px;color:rgb(0,0,0);font-family:=
&quot;Source Code Pro&quot;,monospace;font-size:13.3333px;white-space:pre-w=
rap"> </span><span style=3D"box-sizing:border-box;margin:0px;padding:0px;co=
lor:rgb(102,102,0);font-family:&quot;Source Code Pro&quot;,monospace;font-s=
ize:13.3333px;white-space:pre-wrap">(</span><span style=3D"box-sizing:borde=
r-box;margin:0px;padding:0px;color:rgb(0,0,0);font-family:&quot;Source Code=
 Pro&quot;,monospace;font-size:13.3333px;white-space:pre-wrap">unlikely</sp=
an><span style=3D"box-sizing:border-box;margin:0px;padding:0px;color:rgb(10=
2,102,0);font-family:&quot;Source Code Pro&quot;,monospace;font-size:13.333=
3px;white-space:pre-wrap">(</span><span style=3D"box-sizing:border-box;marg=
in:0px;padding:0px;color:rgb(0,0,0);font-family:&quot;Source Code Pro&quot;=
,monospace;font-size:13.3333px;white-space:pre-wrap">strcmp</span><span sty=
le=3D"box-sizing:border-box;margin:0px;padding:0px;color:rgb(102,102,0);fon=
t-family:&quot;Source Code Pro&quot;,monospace;font-size:13.3333px;white-sp=
ace:pre-wrap">(</span><span style=3D"box-sizing:border-box;margin:0px;paddi=
ng:0px;color:rgb(0,0,0);font-family:&quot;Source Code Pro&quot;,monospace;f=
ont-size:13.3333px;white-space:pre-wrap">cp</span><span style=3D"box-sizing=
:border-box;margin:0px;padding:0px;color:rgb(102,102,0);font-family:&quot;S=
ource Code Pro&quot;,monospace;font-size:13.3333px;white-space:pre-wrap">-&=
gt;</span><span style=3D"box-sizing:border-box;margin:0px;padding:0px;color=
:rgb(0,0,0);font-family:&quot;Source Code Pro&quot;,monospace;font-size:13.=
3333px;white-space:pre-wrap">charset</span><span style=3D"box-sizing:border=
-box;margin:0px;padding:0px;color:rgb(102,102,0);font-family:&quot;Source C=
ode Pro&quot;,monospace;font-size:13.3333px;white-space:pre-wrap">,</span><=
span style=3D"box-sizing:border-box;margin:0px;padding:0px;color:rgb(0,0,0)=
;font-family:&quot;Source Code Pro&quot;,monospace;font-size:13.3333px;whit=
e-space:pre-wrap"> cache_cp</span><span style=3D"box-sizing:border-box;marg=
in:0px;padding:0px;color:rgb(102,102,0);font-family:&quot;Source Code Pro&q=
uot;,monospace;font-size:13.3333px;white-space:pre-wrap">-&gt;</span><span =
style=3D"box-sizing:border-box;margin:0px;padding:0px;color:rgb(0,0,0);font=
-family:&quot;Source Code Pro&quot;,monospace;font-size:13.3333px;white-spa=
ce:pre-wrap">charset</span><span style=3D"box-sizing:border-box;margin:0px;=
padding:0px;color:rgb(102,102,0);font-family:&quot;Source Code Pro&quot;,mo=
nospace;font-size:13.3333px;white-space:pre-wrap">)))</span><span style=3D"=
box-sizing:border-box;margin:0px;padding:0px;color:rgb(0,0,0);font-family:&=
quot;Source Code Pro&quot;,monospace;font-size:13.3333px;white-space:pre-wr=
ap"> </span><span style=3D"box-sizing:border-box;margin:0px;padding:0px;col=
or:rgb(102,102,0);font-family:&quot;Source Code Pro&quot;,monospace;font-si=
ze:13.3333px;white-space:pre-wrap">{</span><br></div><div>```<br></div><div=
>I attached the dmesg and backtrace for debugging purposes. Let me know if =
you need more information.</div><div><br></div><div>Best,</div><div><br></d=
iv><div>Chenglong</div></div>
</blockquote></div>

--000000000000b3626f0615b84b92--
--000000000000b362700615b84b94
Content-Type: text/plain; charset="US-ASCII"; name="backtrace.txt"
Content-Disposition: attachment; filename="backtrace.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_lutfw4co0>
X-Attachment-Id: f_lutfw4co0

UElEOiA1MjU5NiAgICBUQVNLOiBmZmZmOTkyYzkyZWRjMzAwICBDUFU6IDkgICAgQ09NTUFORDog
Im1vdW50LmNpZnMiCiAjMCBbZmZmZmIzZGJjMzRmYjk0OF0gbWFjaGluZV9rZXhlYyBhdCBmZmZm
ZmZmZjk0MDc1Zjc1CiAgICAvYnVpbGQvbGFraXR1L3RtcC9wb3J0YWdlL3N5cy1rZXJuZWwvbGFr
aXR1LWtlcm5lbC01XzE1LTUuMTUuMTQ2LXIxODEvd29yay9sYWtpdHUta2VybmVsLTVfMTUtNS4x
NS4xNDYvYXJjaC94ODYva2VybmVsL21hY2hpbmVfa2V4ZWNfNjQKLmM6IDM1OAogIzEgW2ZmZmZi
M2RiYzM0ZmI5YzhdIGNyYXNoX2tleGVjIGF0IGZmZmZmZmZmOTQxNjRiZTMKICAgIC9idWlsZC9s
YWtpdHUvdG1wL3BvcnRhZ2Uvc3lzLWtlcm5lbC9sYWtpdHUta2VybmVsLTVfMTUtNS4xNS4xNDYt
cjE4MS93b3JrL2xha2l0dS1rZXJuZWwtNV8xNS01LjE1LjE0Ni9pbmNsdWRlL2xpbnV4L2F0b21p
Yy9hdG9taWMtYXJjaAotZmFsbGJhY2suaDogMTczCiAjMiBbZmZmZmIzZGJjMzRmYmE5OF0gb29w
c19lbmQgYXQgZmZmZmZmZmY5NDA0MWI0NgogICAgL2J1aWxkL2xha2l0dS90bXAvcG9ydGFnZS9z
eXMta2VybmVsL2xha2l0dS1rZXJuZWwtNV8xNS01LjE1LjE0Ni1yMTgxL3dvcmsvbGFraXR1LWtl
cm5lbC01XzE1LTUuMTUuMTQ2L2FyY2gveDg2L2tlcm5lbC9kdW1wc3RhY2suYzogMzY0CiAjMyBb
ZmZmZmIzZGJjMzRmYmFjMF0gcGFnZV9mYXVsdF9vb3BzIGF0IGZmZmZmZmZmOTQwODhjYTcKICAg
IC9idWlsZC9sYWtpdHUvdG1wL3BvcnRhZ2Uvc3lzLWtlcm5lbC9sYWtpdHUta2VybmVsLTVfMTUt
NS4xNS4xNDYtcjE4MS93b3JrL2xha2l0dS1rZXJuZWwtNV8xNS01LjE1LjE0Ni9hcmNoL3g4Ni9t
bS9mYXVsdC5jOiA3MDgKICM0IFtmZmZmYjNkYmMzNGZiYjUwXSBleGNfcGFnZV9mYXVsdCBhdCBm
ZmZmZmZmZjk0YjYxZTA2CiAgICAvYnVpbGQvbGFraXR1L3RtcC9wb3J0YWdlL3N5cy1rZXJuZWwv
bGFraXR1LWtlcm5lbC01XzE1LTUuMTUuMTQ2LXIxODEvd29yay9sYWtpdHUta2VybmVsLTVfMTUt
NS4xNS4xNDYvYXJjaC94ODYvbW0vZmF1bHQuYzogMTQ4MwogIzUgW2ZmZmZiM2RiYzM0ZmJiODBd
IGFzbV9leGNfcGFnZV9mYXVsdCBhdCBmZmZmZmZmZjk0YzAwYmEyCiAgICAvYnVpbGQvbGFraXR1
L3RtcC9wb3J0YWdlL3N5cy1rZXJuZWwvbGFraXR1LWtlcm5lbC01XzE1LTUuMTUuMTQ2LXIxODEv
d29yay9sYWtpdHUta2VybmVsLTVfMTUtNS4xNS4xNDYvYXJjaC94ODYvaW5jbHVkZS9hc20vaWR0
ZW50cnkuaDoKIDU2OAogICAgW2V4Y2VwdGlvbiBSSVA6IGRmc19jYWNoZV9jYW5vbmljYWxfcGF0
aCs5OF0KICAgIFJJUDogZmZmZmZmZmZjMDY5ZGRlMiAgUlNQOiBmZmZmYjNkYmMzNGZiYzM4ICBS
RkxBR1M6IDAwMDEwMjQ2CiAgICBSQVg6IGZmZmZmZmZmMDAwMDAwMDAgIFJCWDogZmZmZjk5MmRk
ZDk3ODk0MSAgUkNYOiAwMDAwMDAwMDAwMDAwMDAxCiAgICBSRFg6IDAwMDAwMDAwMDAwMDAwMDEg
IFJTSTogZmZmZmZmZmZjMDcyNzEwMCAgUkRJOiBmZmZmZmZmZmMwNzI2MDAwCiAgICBSQlA6IGZm
ZmZiM2RiYzM0ZmJjNzAgICBSODogZmZmZjk5MmRkZDk3ODk0MSAgIFI5OiAwMDAwMDAwMDAwMDAw
MDAwCiAgICBSMTA6IGZmZmZiM2RiYzM0ZmJjZTggIFIxMTogZmZmZmZmZmZjMDY4MmNiMCAgUjEy
OiBmZmZmZmZmZmMwNzI3MTAwCiAgICBSMTM6IDAwMDAwMDAwMDAwMDAwMzIgIFIxNDogZmZmZmZm
ZmZmZmZmZmZlYSAgUjE1OiAwMDAwMDAwMDAwMDAwMDAxCiAgICBPUklHX1JBWDogZmZmZmZmZmZm
ZmZmZmZmZiAgQ1M6IDAwMTAgIFNTOiAwMDE4CiAgICAvYnVpbGQvbGFraXR1L3RtcC9wb3J0YWdl
L3N5cy1rZXJuZWwvbGFraXR1LWtlcm5lbC01XzE1LTUuMTUuMTQ2LXIxODEvd29yay9sYWtpdHUt
a2VybmVsLTVfMTUtNS4xNS4xNDYvZnMvY2lmcy9kZnNfY2FjaGUuYzogMTk3CiAjNiBbZmZmZmIz
ZGJjMzRmYmM3OF0gZGZzX2NhY2hlX2ZpbmQgYXQgZmZmZmZmZmZjMDY5ZTMyYiBbY2lmc10KICAg
IC9idWlsZC9sYWtpdHUvdG1wL3BvcnRhZ2Uvc3lzLWtlcm5lbC9sYWtpdHUta2VybmVsLTVfMTUt
NS4xNS4xNDYtcjE4MS93b3JrL2xha2l0dS1rZXJuZWwtNV8xNS01LjE1LjE0Ni9mcy9jaWZzL2Rm
c19jYWNoZS5jOiA5NTYKICM3IFtmZmZmYjNkYmMzNGZiY2I4XSBjaWZzX21vdW50IGF0IGZmZmZm
ZmZmYzA2NTNhZmMgW2NpZnNdCiAgICAvYnVpbGQvbGFraXR1L3RtcC9wb3J0YWdlL3N5cy1rZXJu
ZWwvbGFraXR1LWtlcm5lbC01XzE1LTUuMTUuMTQ2LXIxODEvd29yay9sYWtpdHUta2VybmVsLTVf
MTUtNS4xNS4xNDYvZnMvY2lmcy9jb25uZWN0LmM6IDMzNDQKICM4IFtmZmZmYjNkYmMzNGZiZGE4
XSBjaWZzX3NtYjNfZG9fbW91bnQgYXQgZmZmZmZmZmZjMDY0MzNmZiBbY2lmc10KICAgIC9idWls
ZC9sYWtpdHUvdG1wL3BvcnRhZ2Uvc3lzLWtlcm5lbC9sYWtpdHUta2VybmVsLTVfMTUtNS4xNS4x
NDYtcjE4MS93b3JrL2xha2l0dS1rZXJuZWwtNV8xNS01LjE1LjE0Ni9mcy9jaWZzL2NpZnNmcy5j
OiA4OTQKICM5IFtmZmZmYjNkYmMzNGZiZTAwXSBzbWIzX2dldF90cmVlIGF0IGZmZmZmZmZmYzA2
OWI4MDkgW2NpZnNdCiAgICAvYnVpbGQvbGFraXR1L3RtcC9wb3J0YWdlL3N5cy1rZXJuZWwvbGFr
aXR1LWtlcm5lbC01XzE1LTUuMTUuMTQ2LXIxODEvd29yay9sYWtpdHUta2VybmVsLTVfMTUtNS4x
NS4xNDYvaW5jbHVkZS9saW51eC9lcnIuaDogMzYKIzEwIFtmZmZmYjNkYmMzNGZiZTI4XSB2ZnNf
Z2V0X3RyZWUgYXQgZmZmZmZmZmY5NDMyM2JlYgogICAgL2J1aWxkL2xha2l0dS90bXAvcG9ydGFn
ZS9zeXMta2VybmVsL2xha2l0dS1rZXJuZWwtNV8xNS01LjE1LjE0Ni1yMTgxL3dvcmsvbGFraXR1
LWtlcm5lbC01XzE1LTUuMTUuMTQ2L2ZzL3N1cGVyLmM6IDE1MTgKIzExIFtmZmZmYjNkYmMzNGZi
ZTU4XSBkb19uZXdfbW91bnQgYXQgZmZmZmZmZmY5NDM0ZGUzNwogICAgL2J1aWxkL2xha2l0dS90
bXAvcG9ydGFnZS9zeXMta2VybmVsL2xha2l0dS1rZXJuZWwtNV8xNS01LjE1LjE0Ni1yMTgxL3dv
cmsvbGFraXR1LWtlcm5lbC01XzE1LTUuMTUuMTQ2L2ZzL25hbWVzcGFjZS5jOiAyOTk0CiMxMiBb
ZmZmZmIzZGJjMzRmYmVjMF0gX19zZV9zeXNfbW91bnQgYXQgZmZmZmZmZmY5NDM0ZTlhOQogICAg
L2J1aWxkL2xha2l0dS90bXAvcG9ydGFnZS9zeXMta2VybmVsL2xha2l0dS1rZXJuZWwtNV8xNS01
LjE1LjE0Ni1yMTgxL3dvcmsvbGFraXR1LWtlcm5lbC01XzE1LTUuMTUuMTQ2L2ZzL25hbWVzcGFj
ZS5jOiAzMzM3CiMxMyBbZmZmZmIzZGJjMzRmYmYxOF0gZG9fc3lzY2FsbF82NCBhdCBmZmZmZmZm
Zjk0YjVlNmQxCiAgICAvYnVpbGQvbGFraXR1L3RtcC9wb3J0YWdlL3N5cy1rZXJuZWwvbGFraXR1
LWtlcm5lbC01XzE1LTUuMTUuMTQ2LXIxODEvd29yay9sYWtpdHUta2VybmVsLTVfMTUtNS4xNS4x
NDYvYXJjaC94ODYvZW50cnkvY29tbW9uLmM6IDUwCiMxNCBbZmZmZmIzZGJjMzRmYmY1MF0gZW50
cnlfU1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1lIGF0IGZmZmZmZmZmOTRjMDAwZGEKICAgIC9idWls
ZC9sYWtpdHUvdG1wL3BvcnRhZ2Uvc3lzLWtlcm5lbC9sYWtpdHUta2VybmVsLTVfMTUtNS4xNS4x
NDYtcjE4MS93b3JrL2xha2l0dS1rZXJuZWwtNV8xNS01LjE1LjE0Ni9hcmNoL3g4Ni9lbnRyeS9l
bnRyeV82NC5TOiAxMTgKICAgIFJJUDogMDAwMDdmNTcwZGE1ZGI3YSAgUlNQOiAwMDAwN2ZmZTky
ZDE2YzU4ICBSRkxBR1M6IDAwMDAwMjAyCiAgICBSQVg6IGZmZmZmZmZmZmZmZmZmZGEgIFJCWDog
MDAwMDU1NzRjNzZjY2ViMCAgUkNYOiAwMDAwN2Y1NzBkYTVkYjdhCiAgICBSRFg6IDAwMDA1NTc0
YzVlZDM0NWIgIFJTSTogMDAwMDU1NzRjNWVkMzRmYSAgUkRJOiAwMDAwN2ZmZTkyZDE3OGEyCiAg
ICBSQlA6IDAwMDA1NTc0YzVlZDMxMDkgICBSODogMDAwMDU1NzRjNzZjY2ViMCAgIFI5OiAwMDAw
N2ZmZTkyZDE1ZmYwCiAgICBSMTA6IDAwMDAwMDAwMDAwMDAwMDAgIFIxMTogMDAwMDAwMDAwMDAw
MDIwMiAgUjEyOiAwMDAwN2ZmZTkyZDE3OGEyCiAgICBSMTM6IDAwMDA1NTc0Yzc2Y2RmNDAgIFIx
NDogMDAwMDAwMDAwMDAwMDAwYSAgUjE1OiAwMDAwN2Y1NzBkOTRlMDAwCiAgICBPUklHX1JBWDog
MDAwMDAwMDAwMDAwMDBhNSAgQ1M6IDAwMzMgIFNTOiAwMDJiCg==
--000000000000b362700615b84b94--
