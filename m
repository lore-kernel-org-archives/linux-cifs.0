Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804D53876BF
	for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 20:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776718560; cv=pass; b=YdR/Jnt6fx5vQCgiAeVtRgUo4MPNIxJWbZREJivOVA6PuI0rluVO9Z+/Mn6oBUX+IPyG5yFe1fgj7Wd0bIy5Bt1wXiWqblpKIzWjEMr4qjLE2XbZ5y6kEiJPIT0WAo9Ml/5l13gBFRFro7wybaC3h5Vu9Sqd8UdExvm++GupA1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776718560; c=relaxed/simple;
	bh=jQsef1nrrUFXEEwHzi13OXBwDXb3hcJzxauEMF9wkIg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ANYYAjyuTseY14jOL8LT0ogkPHWhv+MgLuBPNvPJRpvv4NQndpwhK9mHHb3cmrcO4wfkPE/MSZRrVAtxwJbRBoaEoC0QjL8aiwvLCg4jtmywHpsJxnDceidtEwzmRugxByiOnwjBnTMOby3nDBASlxRVwegIzFNhg8iEPIwAYTQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qxmPKIJ6; arc=pass smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qxmPKIJ6"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-89f1e767f92so33505046d6.2
        for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 13:55:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776718558; cv=none;
        d=google.com; s=arc-20240605;
        b=BH0NxuIsrc2LOqMlBUtZRI7QnXFhiwEQrwn4l6GZSG55Ee3ddoBWowpuwvYacs8BGi
         iUWR5crmAAduHEUlTTdEODMEJVWunoqhmCa04RxS8OA4mKj+fMMW5CI8aIkdqG+aXXHy
         Zo8vuCfwJFJ38yi+mcH49cvuRWTYFFtmSNYcv2ZgcY7xmXi6+6LJ1+sVhN2NQQmRkn3j
         M1O9dEyJwV3jI5hOALxt8NZWJv1wbCD0X0lh7a775zf0ILL6lK0c4+tMa7Yy8SjLnmcx
         vXkvzFSIXHB+mkcKpRNuHMW/Js9vgOHZGHqT/AKKPT30uO2ec2jtcgCKCqBLoFTjJiUm
         5oUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=SkOn3Nx+drgx8Ekbv4vlvgPE5Sw0mB11UeBSsIadLQw=;
        fh=2EOeRQaHvv55sTH1VSvVowx0I5XR6p0J0mOkSH4poSw=;
        b=VNiNyLElDAuNNepiaYkhut7slRCcICD3l9vDRHCicGKB4qisBl4l3o6CaamzUnfplE
         nXhi8yudGbdjD+QdVZ19IM9U3vZY7WQkRrkT9Gvufw1nwY4KPaxG2dXGBzRwmJ7pgVtt
         wpCynMvCOenM6bNr27v/o0amgvqnaTAGA1qB8oUTZa1AM8O+oH5+I8hUTwRjbMh20u+5
         rM1TpfzjBM9w6ZxNJPimaek3OygF2DV+y2gjT61LOFy4PIXBA5LzDzEQfgjpLgmbOHKu
         syr6naMHumtY5NmhR6Qi/dojEOY2AcG4Au0lG33scK6kcfjXrzvLMrHERXidwyXAqFD5
         LtGQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776718558; x=1777323358; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SkOn3Nx+drgx8Ekbv4vlvgPE5Sw0mB11UeBSsIadLQw=;
        b=qxmPKIJ6JYZBy/NJIi0KaMiTGEfCokx+4xaKdoBzCxuQjI5FsE20y6wTmtetlIlUv7
         2xY7LGGkvbOjpfc4onR2fm81BMsKUhqjUcqUdqf+kE5QHFZiwtoAwLrOqAVS8/dXxCwJ
         V4cZp1jEJAGiWBl3xqUNpR3EUPjSwZmsDOMAYTMrV6wMdwERHxCbbltManzHgU7QtDRo
         G5i0t0yZqWEWBneiOiGlhaKFgHeIVnxhH6rtA+1kY/q9FI+AOeP6DcxZYq5NYD0JliEr
         sw1bR/S7hdx7WLNQcnjtrlZ3Qrez9JPetI3jOkXXGn+Gp2TOiYPALKVxCb89i3/Q5fD/
         CLew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776718558; x=1777323358;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SkOn3Nx+drgx8Ekbv4vlvgPE5Sw0mB11UeBSsIadLQw=;
        b=JegGEv+Sy2ecovdDOO5+3nKGihVUZQIpPBkJPa3oQGgu23FL2UgjMdxilt2m8SpkHw
         wJQXud9VVkrRiaaLCJR0m1gC9PRIlGfB62rjjr1Yztk6WqftJVOU9CvnHP5lPdRuG6Ji
         a/fSqd7R/4bXxpDrAANVSixP0mR1O9PmJ45pe1K55Zh0ou4J/Cv8SY8ZrLNorBFLbb6J
         VY1DxRYoeYFoZtsTwCY/4CFeOH2eNH61XD35JlCA7rYZTtNe9/6i2hMMr0uFyJ8DiKN7
         oe6E1r7/VaytRZnJgMA8b6N6OY9grgGV2Mu8yvtX/8XtHs3Zxp5U7FK9JmSVh8C0pz09
         eb3Q==
X-Gm-Message-State: AOJu0Yy6+pmHSoqbG64ZNPWFgcGXbH5sxJubF/gMbXZ1pSZ9rBMn80RF
	n6awbW7PG30kdPt16uBM1rHTvfF2YBajCteE+gWEWr+XDkoWwdb3StAL9G+NNmYM329LFtSjDsR
	2ZR1b5O7B5h1SPnsw9uROLifdB6U8E0M=
X-Gm-Gg: AeBDiesX5FbF3OIJJH8u3f0GNGw2B/iodBwZFiT+BoWcQZ1N4VdVI2UugC+4Kx/PeAB
	Gp8fg9LiiIaeNeU2cdNVc+p9ZMB66JudRRiUfHcn3D9uzHj3YzmLoAzpBZxeRCLjOO8U8LpdOf4
	zrpVKjCod/QJca8iHNheXs3ADpgeuZCcPsS/wYzl0MgDIEFOVCvGAbrTlKJNuvfmnMWJuaR8tts
	83pWRkX4VYESUGPOCoL6h44QNF3VcREEorNKpTvZR+0GY5fWyYuXdqVOqAWAsG8cww/zzr7f1wQ
	a1Pr1lGyPQL7pjXwo7iNZ8Gyhkaqyf7Wte4FtCsMDjpOexkc26d/M1vjbzFjsxKuVQgb1tlmhR7
	/T1aDQLURxaFHCe7WcFygD7xd4x9GBLTIRcf5pquYjbpQnhuCPSux9dNY89EQejwQBc2yWfu3SZ
	31Q2OLnNfOd+V7dzHHm1U7rRwPx5/eknU=
X-Received: by 2002:a05:6214:40b:b0:8ac:ba63:a1b1 with SMTP id
 6a1803df08f44-8b028176865mr263218276d6.49.1776718558402; Mon, 20 Apr 2026
 13:55:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260420135058.469990-1-michael.bommarito@gmail.com>
In-Reply-To: <20260420135058.469990-1-michael.bommarito@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 20 Apr 2026 15:55:46 -0500
X-Gm-Features: AQROBzD8qRbzGNoHBRFQQ-qhVLxIr37bW187p-BIkjgp1HOYAQyTfXz4z952k2Y
Message-ID: <CAH2r5mtNhVtN65gYcbPqxOXMD_Fm3FcHFcURLmF8yma2zKk1aw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: require a full NFS mode SID before reading
 mode bits
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.org>, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000008a9ef1064fea863d"

--0000000000008a9ef1064fea863d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This patch wouldn't apply due to a conflict with "smb: client:
validate the whole DACL before rewriting it in cifsacl"

Had to change "end_of_acl" to "end_of_dacl"

See attached.

On Mon, Apr 20, 2026 at 10:14=E2=80=AFAM Michael Bommarito
<michael.bommarito@gmail.com> wrote:
>
> parse_dacl() treats an ACE SID matching sid_unix_NFS_mode as an NFS
> mode SID and reads sid.sub_auth[2] to recover the mode bits.
>
> That assumes the ACE carries three subauthorities, but compare_sids()
> only compares min(a, b) subauthorities.  A malicious server can return
> an ACE with num_subauth =3D 2 and sub_auth[] =3D {88, 3}, which still
> matches sid_unix_NFS_mode and then drives the sub_auth[2] read four
> bytes past the end of the ACE.
>
> Require num_subauth >=3D 3 before treating the ACE as an NFS mode SID.
> This keeps the fix local to the special-SID mode path without changing
> compare_sids() semantics for the rest of cifsacl.
>
> Fixes: e2f8fbfb8d09 ("cifs: get mode bits from special sid on stat")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4-6
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> ---
>  fs/smb/client/cifsacl.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
> index c920039d733c..a62c8a733779 100644
> --- a/fs/smb/client/cifsacl.c
> +++ b/fs/smb/client/cifsacl.c
> @@ -831,6 +831,7 @@ static void parse_dacl(struct smb_acl *pdacl, char *e=
nd_of_acl,
>                         dump_ace(ppace[i], end_of_acl);
>  #endif
>                         if (mode_from_special_sid &&
> +                           ppace[i]->sid.num_subauth >=3D 3 &&
>                             (compare_sids(&(ppace[i]->sid),
>                                           &sid_unix_NFS_mode) =3D=3D 0)) =
{
>                                 /*
> --
> 2.53.0
>
>


--=20
Thanks,

Steve

--0000000000008a9ef1064fea863d
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb-client-require-a-full-NFS-mode-SID-before-readin.patch"
Content-Disposition: attachment; 
	filename="0001-smb-client-require-a-full-NFS-mode-SID-before-readin.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mo7obp1u0>
X-Attachment-Id: f_mo7obp1u0

RnJvbSA1YTM5ODBmMzAyNzU2MDFkNjllMDY2MjkwZDI4ODRiYjVhZjJkZDI4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNaWNoYWVsIEJvbW1hcml0byA8bWljaGFlbC5ib21tYXJpdG9A
Z21haWwuY29tPgpEYXRlOiBNb24sIDIwIEFwciAyMDI2IDA5OjUwOjU4IC0wNDAwClN1YmplY3Q6
IFtQQVRDSF0gc21iOiBjbGllbnQ6IHJlcXVpcmUgYSBmdWxsIE5GUyBtb2RlIFNJRCBiZWZvcmUg
cmVhZGluZyBtb2RlCiBiaXRzCgpwYXJzZV9kYWNsKCkgdHJlYXRzIGFuIEFDRSBTSUQgbWF0Y2hp
bmcgc2lkX3VuaXhfTkZTX21vZGUgYXMgYW4gTkZTCm1vZGUgU0lEIGFuZCByZWFkcyBzaWQuc3Vi
X2F1dGhbMl0gdG8gcmVjb3ZlciB0aGUgbW9kZSBiaXRzLgoKVGhhdCBhc3N1bWVzIHRoZSBBQ0Ug
Y2FycmllcyB0aHJlZSBzdWJhdXRob3JpdGllcywgYnV0IGNvbXBhcmVfc2lkcygpCm9ubHkgY29t
cGFyZXMgbWluKGEsIGIpIHN1YmF1dGhvcml0aWVzLiAgQSBtYWxpY2lvdXMgc2VydmVyIGNhbiBy
ZXR1cm4KYW4gQUNFIHdpdGggbnVtX3N1YmF1dGggPSAyIGFuZCBzdWJfYXV0aFtdID0gezg4LCAz
fSwgd2hpY2ggc3RpbGwKbWF0Y2hlcyBzaWRfdW5peF9ORlNfbW9kZSBhbmQgdGhlbiBkcml2ZXMg
dGhlIHN1Yl9hdXRoWzJdIHJlYWQgZm91cgpieXRlcyBwYXN0IHRoZSBlbmQgb2YgdGhlIEFDRS4K
ClJlcXVpcmUgbnVtX3N1YmF1dGggPj0gMyBiZWZvcmUgdHJlYXRpbmcgdGhlIEFDRSBhcyBhbiBO
RlMgbW9kZSBTSUQuClRoaXMga2VlcHMgdGhlIGZpeCBsb2NhbCB0byB0aGUgc3BlY2lhbC1TSUQg
bW9kZSBwYXRoIHdpdGhvdXQgY2hhbmdpbmcKY29tcGFyZV9zaWRzKCkgc2VtYW50aWNzIGZvciB0
aGUgcmVzdCBvZiBjaWZzYWNsLgoKRml4ZXM6IGUyZjhmYmZiOGQwOSAoImNpZnM6IGdldCBtb2Rl
IGJpdHMgZnJvbSBzcGVjaWFsIHNpZCBvbiBzdGF0IikKQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5v
cmcKQXNzaXN0ZWQtYnk6IENsYXVkZTpjbGF1ZGUtb3B1cy00LTYKU2lnbmVkLW9mZi1ieTogTWlj
aGFlbCBCb21tYXJpdG8gPG1pY2hhZWwuYm9tbWFyaXRvQGdtYWlsLmNvbT4KU2lnbmVkLW9mZi1i
eTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL3NtYi9jbGll
bnQvY2lmc2FjbC5jIHwgMSArCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykKCmRpZmYg
LS1naXQgYS9mcy9zbWIvY2xpZW50L2NpZnNhY2wuYyBiL2ZzL3NtYi9jbGllbnQvY2lmc2FjbC5j
CmluZGV4IGM5MjAwMzlkNzMzYy4uYTYyYzhhNzMzNzc5IDEwMDY0NAotLS0gYS9mcy9zbWIvY2xp
ZW50L2NpZnNhY2wuYworKysgYi9mcy9zbWIvY2xpZW50L2NpZnNhY2wuYwpAQCAtODMxLDYgKzgz
MSw3IEBAIHN0YXRpYyB2b2lkIHBhcnNlX2RhY2woc3RydWN0IHNtYl9hY2wgKnBkYWNsLCBjaGFy
ICplbmRfb2ZfYWNsLAogCQkJZHVtcF9hY2UocHBhY2VbaV0sIGVuZF9vZl9kYWNsKTsKICNlbmRp
ZgogCQkJaWYgKG1vZGVfZnJvbV9zcGVjaWFsX3NpZCAmJgorCQkJICAgIHBwYWNlW2ldLT5zaWQu
bnVtX3N1YmF1dGggPj0gMyAmJgogCQkJICAgIChjb21wYXJlX3NpZHMoJihwcGFjZVtpXS0+c2lk
KSwKIAkJCQkJICAmc2lkX3VuaXhfTkZTX21vZGUpID09IDApKSB7CiAJCQkJLyoKLS0gCjIuNTEu
MAoK
--0000000000008a9ef1064fea863d--
