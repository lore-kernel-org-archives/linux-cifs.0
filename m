Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BC55EE93;
	Sat,  3 Feb 2024 15:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706974775; cv=none; b=pKEfMnd3VoAT1PwLui8l2i1ZFEekLOdUI1pDnQpneeyeUmOIzKw1SLAFCljxTGS0PRQpkGtKEIlOCZYkoXN0l0kLWKg4SC1IjDfbQ3cL/iVQ7EDxNh2+BduEYwgtxa70iTN9oQr3panznoKmomTvENImEBP1hjuCJYkdAEH5d4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706974775; c=relaxed/simple;
	bh=Z1fDkFW4kV9tEN1kIOx6hcdERykgbZCyqDgFffJZqRc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HO/7N76Vku5U9nJtmhHdwztRRoM3f8qRhz8SR4HIFhiqKzyX1pId5OaccM6S7HscB2MIOGuepiS7FXvtO/2PS457ATmLJbY23LIQ6JeScSJsPW07PdYsoS1qGbNn9X0lD0Ojl97NGJ7b88+qn4d/THM3OWWsEdYhglW5bg2pzuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VgVf/Wst; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VgVf/Wst"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-40fb63c40c0so26797255e9.2;
        Sat, 03 Feb 2024 07:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706974771; x=1707579571; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ln5iyegle7KBccGgpjlokaPDsuKYOZ/+34oUY61UwW0=;
        b=VgVf/WstXD1r/CItTK3VYoktOXEncyweKcU/6Soa8vLY2/56YtzD2JEblLmZio6VDF
         TrZMfSlLuVjpt0x4pv/Fu/JgqSxvcEkou0C57l9T2T7AlnvQY4+nFV+C7dCI+OIMFmXD
         +s8iO0bG10UrqrQgpCtVejre8ShtaAr8TdmgRA0vPG/poMJ2nz/fFTyKiHyGczuFqUSe
         4snWLYvR0mDqrugt4+IdtybuSKozrWLfe6sZuFkfJaoKqpkg/f8qSlz11S3iCAFNM+XX
         DoMkqdM+/nYvAfgOxp1J2fZh6AhsKWIc2aGyODfqiUn/NoKumVFe5NRGdUSDg4PBDRer
         zX+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706974771; x=1707579571;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ln5iyegle7KBccGgpjlokaPDsuKYOZ/+34oUY61UwW0=;
        b=RDdu059C/NY5R1JakFUUQWKEp0My6APldZzN3R2WbvKEmNI/IiNZGE8TvvgxHESDRR
         +Gph0U0p8UgKYrO5yzC/YhICIYunMyBT0C6M4RhFQLtjXGG/XtenXOg461Bs/LqJqHoE
         O57SLZHQRYQYrLAw2KaK7OdqUMHTxmkbsZsqfiBWSR5SXOQFCmQqBhE/GrNtVizMpk/s
         wmn0qMTKLvXYn3cFAf1+a/0TVrr5r3DZIOI+vNJEYNQjInoTSc6GsIXCtvv00c2Cbc9V
         uKrygO5pr/fqPEgtajnhbymFKBg02M37aLOQLmtxopIh8/ozgM1v1HIFyWSPhavSPyAW
         DnOA==
X-Gm-Message-State: AOJu0Yw1h3INe4kjNH/1kyUTWD1ASAIPwUKgP/ICs0jYVWL1fj4aoHX1
	0mM58mRM3Jbalaa6g6gmjo3OcZjUMXOkhjmwKvYU6hbj/BtLsTNyj86UdJynMYc=
X-Google-Smtp-Source: AGHT+IEeis0FDJ+NTvAp2Xq5aZSNeviKJ178cvYpwcXGtqP8JkyxDd1G0WES/FpXQ4r5igP1I+h19Q==
X-Received: by 2002:a05:600c:2111:b0:40f:b33a:a6f8 with SMTP id u17-20020a05600c211100b0040fb33aa6f8mr1140489wml.18.1706974769169;
        Sat, 03 Feb 2024 07:39:29 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCW6I1o5/nqqFIBXMANZNFaRXuU4dydSkR5AwqWmhPhqZAkXLXjcyX9jZg7MAoXflyN/mcRWPqhCeDp/Pes4psT/JuCUwbsUyEUJ7HrMoeRqbaWxyzMu0mLlBsve/UP4CptmVFkeFKKsLY3rFY9fjN42rlIuu2PBLFI/4p8IfsH4WziTgMQFF+rEx5HLMtIWvGiySzFnZkq4qMFj4JSxSejTcXr/in1iGSDKM1khEpdItzU6CBR2jhTEa0dm67j+0UHYitmXLbycUeDn2n7wLLAFg5NMtkH0iepOrMOMmLY=
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id b15-20020a5d40cf000000b0033aeb0afa8fsm4262198wrq.39.2024.02.03.07.39.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Feb 2024 07:39:28 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id E04B8BE2DE0; Sat,  3 Feb 2024 16:39:27 +0100 (CET)
Date: Sat, 3 Feb 2024 16:39:27 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
Cc: Paulo Alcantara <pc@manguebit.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"leonardo@schenkel.net" <leonardo@schenkel.net>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	"m.weissbach@info-gate.de" <m.weissbach@info-gate.de>,
	"regressions@lists.linux.dev" <regressions@lists.linux.dev>,
	"sairon@sairon.cz" <sairon@sairon.cz>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [REGRESSION 6.1.70] system calls with CIFS mounts failing with
 "Resource temporarily unavailable"
Message-ID: <Zb5eL-AKcZpmvYSl@eldamar.lan>
References: <53F11617-D406-47C6-8CA7-5BE26EB042BE@amazon.com>
 <9B20AAD6-2C27-4791-8CA9-D7DB912EDC86@amazon.com>
 <2024011521-feed-vanish-5626@gregkh>
 <716A5E86-9D25-4729-BF65-90AC2A335301@amazon.com>
 <ZbnpDbgV7ZCRy3TT@eldamar.lan>
 <848c0723a10638fcf293514fab8cfa2e@manguebit.com>
 <3bfc7bc4-05cd-4353-8fca-a391d6cb9bf4@amazon.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bfc7bc4-05cd-4353-8fca-a391d6cb9bf4@amazon.com>

Hi,

On Thu, Feb 01, 2024 at 12:58:28PM +0000, Mohamed Abuelfotoh, Hazem wrote:
> 
> On 31/01/2024 17:19, Paulo Alcantara wrote:
> > Greg, could you please drop
> > 
> >          b3632baa5045 ("cifs: fix off-by-one in SMB2_query_info_init()")
> > 
> > from v5.10.y as suggested by Salvatore?
> > 
> > Thanks.
> 
> Are we dropping b3632baa5045 ("cifs: fix off-by-one in
> SMB2_query_info_init()") from v5.10.y while keeping it on v5.15.y? if we are
> dropping it from v5.15.y as well then we should backport 06aa6eff7b smb3:
> Replace smb2pdu 1-element arrays with flex-arrays to v5.15.y I remember
> trying to backport this patch on v5.15.y but there were some merge conflicts
> there.
> 
> 06aa6eff7b smb3: Replace smb2pdu 1-element arrays with flex-arrays

While I'm not eligible to say what should be done, my understading is
that Greg probably would prefer to have the "backport 06aa6eff7b"
version. What we know is that having now both commits in the
stable-rc/linux-5.10.y queue breaks  cifs and the backport variants
seens to work fine (Paulo Alcantara probably though can comment best).

As 06aa6eff7b smb3: Replace smb2pdu 1-element arrays with flex-arrays
was backportable to 5.10.y it should now work as well for the upper
one 5.15.y.

Regards,
Salvatore
