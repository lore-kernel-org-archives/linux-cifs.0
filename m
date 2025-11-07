Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FA829A33E
	for <linux-cifs@vger.kernel.org>; Fri,  7 Nov 2025 12:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762520066; cv=none; b=VL75WRQCPr0VPAKozkvUbk3fVOqEN8toQTUsNib4fDjKGcp87FMdiLOL+iY9OS3o9YjJ/nUlxzkEjXzufz1n4zFRYMTcb6xCenSf62CG7INMJijJevIlqhie8n+PesuIecIitJOAea9HpYRF3ICjVGSqJSw6HjdZqSWOEuAOurU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762520066; c=relaxed/simple;
	bh=8pu6rm5AfsFpxIVh9Q2XtU3/QB4gOI+ZMX3/Z5GHfW8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gt0BV6ZwYWQfMbRIskk4YS8fq/BdCE8iIeMbvDD5oNmJcODtBcnmhObhLhlo0kT2sdYyj/jUMPDs5QMXoji/o5JtR9i1cSdEQq1WTuSki1vnm2EKfunZEjq+DWNApN9I7HmhDlzD7hnGVtOLjTM8M/VRu7QViPkfpkSbAmA4doY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OWA+2KbA; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OWA+2KbA"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b713c7096f9so103558966b.3
        for <linux-cifs@vger.kernel.org>; Fri, 07 Nov 2025 04:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762520063; x=1763124863; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7zlQTq+936U9oPTpTa05k6OIYh+uEnd/bNRU0qCGB5g=;
        b=OWA+2KbAGB3PGPOAMtl28XTMPqEAtRu/VOIvPNoGuFzqRlmI2F5ciJaWUE2nOULT0W
         RgRxsyux5TRDCz10mF2yXLzqCLxhdNUfgAgoHLt6Ep3xKfGp7fbjtHJLcgR5RnbpnTLs
         5cmz2HvPEboqsESo8zKrJl/iUdw2kWGx9B+xeT/q2VlPT9ugx51xfhtHHl9AynZI+kW/
         icVNkiepzad1BzpO7pxVjZrhJR9f1IfXhnI1/7Nuou8bFxlaQ5fO+5IPWGW5STUbXW5P
         vkYeIU0A4FWhu5Aoqn7n8N3rykMxJ/ZKQuYxlz/7SgxIiLkYlZl/qkeif0JYqA/YdrWg
         ukjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762520063; x=1763124863;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7zlQTq+936U9oPTpTa05k6OIYh+uEnd/bNRU0qCGB5g=;
        b=KklA1HIg9gQzKTKlGCvyYb6RJBkKRZWAmM3RlsZYAiJptCEmXaXxQXDi/OovRr7WTd
         brMNCX0ia5292i+ZGM3hmfuEy6qyM853U+IgZYRYwvftT07e0IddK8va5i9bzGrTd/LK
         ZUlbdJ/JjuLDhPiK8Ev1VsQpTgOAZ2S8c7EdIgMfbZsUCiLW6zx9/CuQnu1DewgtWnKy
         TWOMiuCfc76fXRKv/PJDvbYrJa8TqGcvXXvN0Fe1Ig7vmczZVc4GDPG2wDlncScm4Rv6
         sDN+TjkBvthvcUIBdjGtbyPTVA68QswW4cxBONWnqiWMAwPbXLEFF7vwQuNiEbi4Fgi2
         av0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWVIJjsivgVpCadiPLuJYG3PRYC+3IXQ0uv6XJjeTTqJCFEZbNMv2SGtZU//3JJ5AJ5w6FZf+twc5qR@vger.kernel.org
X-Gm-Message-State: AOJu0YyYjffygYHqgc+++rWPhyEx/tEkzIqmBHIpiFkRktDzqShlZ6aJ
	FkaCVlqRwS3zwnTIKyQHq1/Xj3LrtC9bjq6lxyzrlPrjhq+esSjdmcNjwWPaPGDUNztET3fArUx
	TdaQWOkB0jUXpgktPvhQ/7/5RazhjuM8=
X-Gm-Gg: ASbGncvZmAnnLkrZEOyI16g8HsCmieJ+x3k4W2lfHxHkHFyEf7JIKrxxCE8aoXI4CYi
	cCERpTU5StTQWXejNDSLVpAlDyBTKO5pKg7yWRxAA6dGF86IE7zqd4lzJOOLT93lsF/S1O1IPWd
	cXLruI6mJv8/cQKYhm3kZ8aXly5/Mc9+1n7lgOV7eY41dSYiDokHo+jdNQMpApqzOqPvwhVmHrA
	wfzrJC3Xih53AehS9anxRc4wms6ckSQkR3uQVFvXkPfdYiScPYI4N7rXsXn+J7FWsh4uQ==
X-Google-Smtp-Source: AGHT+IEPgtMlUKaht1ovA3aDh36/52WETEiI4LJw/jCM8IfG3n/+XC02Lrmxhj7k3vQqRkHvzGU4fxYnYWytX34ADLw=
X-Received: by 2002:a17:907:1c08:b0:b40:8deb:9cbe with SMTP id
 a640c23a62f3a-b72c08dc7e9mr312866866b.2.1762520062670; Fri, 07 Nov 2025
 04:54:22 -0800 (PST)
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
In-Reply-To: <aaloi77h2f5xolhrnegxsxntqp2jopwisunmjfp45idsoockpy@cy5agf2oqjop>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 7 Nov 2025 18:24:10 +0530
X-Gm-Features: AWmQ_blcBd6W2zro5oPc02GV5eATdJZXgSpAMBVDyRdYXQuo6Bl26ek3b4gV9n0
Message-ID: <CANT5p=r=QgseACdUQySq2MCxycMsG-EvHCx-wwUPWo+xkSRVXg@mail.gmail.com>
Subject: Re: [[ EXT ]] [BUG REPORT] cifs/smb data corruption when writing,
 x86_64, kernel 6.6.71
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: Mark A Whiting <whitingm@opentext.com>, Steve French <smfrench@gmail.com>, 
	"Heckmann, Ilja" <heckmann@izw-berlin.de>, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, 
	"henrique.carvalho@suse.com" <henrique.carvalho@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 27, 2025 at 6:39=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> Hi Mark,
>
> On 03/27, Mark A Whiting wrote:
> >>This is the fix we used (rebased on top of v6.6.71 tag):
> >>https://git.exis.tech/linux.git/commit/?h=3Ddata_corruption_v6.x&id=3D8=
d4c40e084f3d132434d5d3d068175c8db59ce65
> >
> >I tried following the link but it gave me a "502 Bad Gateway" error, I a=
lso tried the link on my personal machine at home in case it was my corpora=
te network blocking things, same result. I don't know how big the patch is.=
 Any chance you could just drop it in this thread?
>
> Yes, sorry about that, I'm having problems on that server.
> Patch is attached.
>
> >>@Ilja @Mark could you test it with your reproducer please?
> >>@Steve can you try it with the reproducer mentioned in the commit messa=
ge please?
> >>
> >
> >I would be happy to try it out.
>
> Thanks, I'm eager to know the results.
>
>
> Cheers,
>
> Enzo

Hi Enzo,

I reviewed the patch from my end.

I think you missed the test for non-dirty folios in your change.
-           if (!folio_test_dirty(folio) ||
-               folio_test_writeback(folio)) {
+           if (folio_test_writeback(folio)) {
I think this is why Mark and Bharath saw the WARNING with this patch.
This happens when there's a clean folio in the extended range. With
your patch, it will add such a folio to the batch as well.

I also did not understand the reason for setting stop to false in these cas=
es:
+           if (xa_is_value(folio)) {
+               stop =3D false;
                break;
            }

+           if (unlikely(folio !=3D xas_reload(xas) || folio->mapping !=3D
mapping)) {
+               stop =3D false;
+               goto put_next;
            }

It looks to me like it's a bug if we're hitting either of the above
conditions. i.e. file mapping should always match and the folio should
always be a pointer in the file mapping.
Won't we end up in an infinite loop if ever something causes these to be tr=
ue?

Rest of the changes look good to me.

--=20
Regards,
Shyam
