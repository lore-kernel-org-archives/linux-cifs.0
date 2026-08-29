Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D692E7F25
	for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 05:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787981456; cv=pass; b=ihZ/eRRH3N+AGOlRqPLAHnnWnhH2NSJyti5JOERgN6uHWP3EFuJObr7tTiEu08Eulsij79Nn/Yl+9rbN1PVyU8uF04On/sHmxDsy+39d9YxKdzgW3G9mEqp3o5xC5xc0kA5gDSMqh0BjeJqEGTP6jpNVUamMz76oeu4x1f8ji6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787981456; c=relaxed/simple;
	bh=Fmzzq7VxlDcP/qSuMj2DsvFNsgHYoE0juz3zrY1yd1E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u92Yz6t4nqU8FsJggN9o+EyreiliQMzjWCwUIve2Id0FUJktlZdaFf8Eg84LJhdJjKod3bvdd6lRJNH+kVPhgsxjjuCluSYstCljdczniDo0RC0vCocqIjFfBq+oF5WX+3XbUC/jIrLcGT8mgQX+e3gvgMYX7tCLiQ2Hw8CwYeg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=dM2EeSse; arc=pass smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="dM2EeSse"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2d715f4a587so24351095ad.2
        for <linux-cifs@vger.kernel.org>; Fri, 28 Aug 2026 22:30:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787981454; cv=none;
        d=google.com; s=arc-20260327;
        b=rpNASQrnjpG9VPBEQmZJn53JFVem6Sk1JGJCQ2Lhk8TfSm1WttD52XQ99YWNgv8OIv
         o05oW2cfje53QjInlnVbGyb4zS7lJNvmc2P6wZrpHKNyhxMazTOLz/Q08Rx1hRiHpDjH
         +QPcnT8zrp3Vc8/jPKnT2uzJCh7h+DAiNkpKR7PszDMxleNJ7jb0iDFLnYZqMRzWbsRe
         fwTXY3u8tjOGVkAY/6mfLWWKNuug1Eujmiqc2IJS7KuKLhsNMb8C/3EPMOujY/b9DY9H
         UPygvELGWJEKIgyVjrWDBbO6cf2TsTzZ40/YPs5HYNb040EBU2MLQf8AtT/a/jZy7kWn
         KIyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=msGGMsAOPCBtRMN69Xb7hRwfBrAw4wH3kcCi/IqwT/4=;
        fh=bk4AS9ffjCmmogBo2ye2iWj5f+Y1Ec6nGnQkJhnZAeE=;
        b=rpdko8GzWC/QfJSg7HtfiTQCx2TZSHZ1V+wqHAuyv9fs3LeeiUiJAkWOB0hD6rfOjy
         rspBlKYPzvCLM8K7Z05O526PVsdRJ95nPazEhxmKuJsA8JEzrw6WNuHxEQAJ5AJNeAPw
         Lxjmvq7axm9c+j558hMbSIfo6r6NxJcPX6bFH+6TOebvZKL1Nx6u/3GuLXF0ZdSzdfj8
         wWallCBvyovdnJwwoe38JvaOorwteg1GVZio4kSveGezBUrOqqOfcyQo0B0LB5Sdm/hm
         gXY0dd0/NE1yE2NCBlxxnLzmqeN2djsUhn5DKYFGdA2BTgMq/t3nMhoVyHzLcxvrhNVZ
         KkNA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1787981454; x=1788586254; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=msGGMsAOPCBtRMN69Xb7hRwfBrAw4wH3kcCi/IqwT/4=;
        b=dM2EeSseVvuVYajKKX6h76RE5qwujDGGcnNHweQ2736O/+8dJwbGy75bnrHoNEHEfL
         qNQUqJwuyO+9R4Ywz+FfpkJ1980qwr3dgKEyX/vSl9YXni4/wDZij24dH9jbjKMFoHr2
         0BAOPA55/TZCneHKhqlAFpmXqJgQTPmzJwGSl4lB3Ahus7nLIIw+gpczGTzK4CpPxJho
         4xDjilm+nUuP4vuc0wVofw7e4dycy4pjBbb8KGmZxvK/gAQegzqeRqiQicvAwwzKtMWQ
         MwIu8F+F33xACb8D59Ml7udPSsuu9eAL22w+dBqWKEjDg2kSR4nHuROI39KSAkRJMhUv
         DTYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787981454; x=1788586254;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=msGGMsAOPCBtRMN69Xb7hRwfBrAw4wH3kcCi/IqwT/4=;
        b=Fa1rVYGDgMe9HJ2XhDsjXqYjtMS1DTCorsPlDLwUT9VjiqwzHOwXkFMyaerorllxUN
         HLe7//tH0RWcyCdYPo1ky6A4cR4gOqT5ANq+F9rwcZ3N3Ju7zRTAmeUvXtncfl/AJvh3
         vFucpRVdYTERygoarupocOqAP75GDT+IxMKiacJ8/9JkumPnNQeGBJANuk/XCaYqNM8O
         3CQf6yMzuAluTgjdam536Kx40VSeaQ6+5fPkAdhnL2fB2DMFfQLP/bJ2le/XTl1ozGrR
         4ybkupXSBqY+zHNzfL2Kt4zfacerIcVqIpX4HqDjZIKGkHLCVH1AR4tyT0ZgTuNeMszh
         /5kQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro+uRUIQhnw3CU5eYvkKdeIzALFclfwtqnnmlomCxzRVDYBwkYcf94dXWg8K/GMHZvCZ33yYG9tfEtB@vger.kernel.org
X-Gm-Message-State: AFuF++mU264/PjsWVdAfYAuRskHaEcLMjFNHVFV6SHf8e3o0iNAFhkR0
	MBV7dtx8u16KOaDoQWGEmVP1WbbL0idWkjRt3k7XNG8qKEt1a/9y5mDb/T7nlb4D7Y630JsW50c
	RueIiqSgm7vsUgRgl+vLM+IyC4FDy6pxhfDSQbswS
X-Gm-Gg: AYBFou3ggAs+kM6COvJAb3J+ZchiIx3toNPNqsaQQyeatkUgCS+/ub0QxD2CqWm9XwZ
	B32MxTFoCsVXztomHkp9y6O2GOvhQuQIkZP4DkeyIuAwEWTDelZyFricqEOhOhAepwwHceLgPB5
	OUMv9l9IAWlXT4DM0tkcnjdLiWeq51oxAujyrfeYHZq4Dbz8vhOFuvlC99wmNqORNiAqSrqsQ8U
	9fx0EMAgoAjKAgAmUfzeeqBvnIAL+pE/CTehJsk6XUignbY058EubO9nyadhp5+s45nYTgxnwSj
	vtzTuzvpxRRBUXxEixmudUlwdrtuigQpfWD1xU6ZCWALA+aOxiGiIMAqADB6zdQ22fZFe3y6cXy
	j8qrceijGFfR0TtahfTLm0iYblvt328FNrenVOLO9Rg==
X-Received: by 2002:a17:903:1b44:b0:2d8:d4cc:5bb1 with SMTP id
 d9443c01a7336-2d8d4cc5db8mr71701325ad.17.1787981452763; Fri, 28 Aug 2026
 22:30:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+0ovCiMX1XFqCf0z=tPOb2nnQaqsxG=FEf2X6CshAQ86gAYMg@mail.gmail.com>
 <CAKYAXd-Z_H2O3W=_KrUifR44yisJJhR=-bQQp1mML7vHgfcdDw@mail.gmail.com>
In-Reply-To: <CAKYAXd-Z_H2O3W=_KrUifR44yisJJhR=-bQQp1mML7vHgfcdDw@mail.gmail.com>
From: Farhad Alemi <farhad.alemi@berkeley.edu>
Date: Fri, 28 Aug 2026 22:30:40 -0700
X-Gm-Features: AcwNN1VJW_q2u0ZDerXqM431NG-qt1B-dx1vNq7txCD_Tj2ViejSZJUPduG3978
Message-ID: <CA+0ovCiDdpM2foeKtEBnoPRQ0AEYE-pJbEtLqiPY5wO_gSvdVA@mail.gmail.com>
Subject: Re: [BUG] ksmbd: OOB read in share_config_request() when payload_sz
 == 0
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 27, 2026 at 7:36=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> On Fri, Aug 28, 2026 at 7:38=E2=80=AFAM Farhad Alemi <farhad.alemi@berkel=
ey.edu> wrote:
> >
> > Hello Namjae and Steve,
> >
> > While fuzzing Linux 7.1-rc5 with syzkaller, as part of research at ASU'=
s
> > SEFCOM lab, we hit the crash below. Crash reports can be found here:
> >
> >   https://github.com/farhad-alemi/public_bug_reports/tree/main/106-ksmb=
d-oob-read-share_config_request/
> >
> >   BUG: KASAN: slab-out-of-bounds in strnlen+0x66/0x90 lib/string.c:432
> >   kstrndup+0x2d/0x160 mm/util.c:120
> >   share_config_request fs/smb/server/mgmt/share_config.c:168 [inline]
> >   ksmbd_share_config_get+0x5e0/0x1190
> >        fs/smb/server/mgmt/share_config.c:243
> >   smb2_tree_connect+0x2f4/0x1320 fs/smb/server/smb2pdu.c:2015
> >
> > Our reproducer.c is available upon request.
> >
> > Happy to test a patch if that would help.
> Can you test if the attached patch fixes this issue?
>
> Thanks.

Tested on 388b607d107c07aaade04c7f22f344cab6bdccd3 built w
UpstreamAppArmorKASAN.config; patched version no longer panics.
Thanks!
