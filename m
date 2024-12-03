Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8F61F707A;
	Tue,  3 Dec 2024 14:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237116; cv=none; b=gPTJci5czj4ukEBh1Ulu8pU4Q8xQ2I1YDQtcy4BVCwbNWS3E9goTKD83qRlQ2cBwi5zIxvuQ+S3jeSG6le+HJCtDAfss6Grtvu9bM6UTuKcSoQ8BENFlyqUzeIYN37b1yYvjEaoJP9IbIDWig3pSeFLzfkoyD+4O0I3AUFbab6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237116; c=relaxed/simple;
	bh=XN8ES0rHOFOYBm7jewQYFcVIpPB9gtMoX1yXuz3STQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jjUjaeql589RzyNBKqZwVQCRlCUB1guIZxdihOQjNWtU2okHP8tdGfk2YUsb8FkhgfglOaC8HLsFslEsdwreB5MvQIvFnjMa/i164SF3dgkDHb8jxsbN/xnNyxPMNhjWjTBsEtYkHYLNxuDFzUulwFOiS7Vyeu4jxO1sVoYlkhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jyIiBg2f; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jyIiBg2f"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5d0bde80b4bso5332151a12.2;
        Tue, 03 Dec 2024 06:45:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733237112; x=1733841912; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z02kD3ptGLXxLPiul0GJ51OSn05xcfsBoxVOvzJnNTk=;
        b=jyIiBg2f7+fb+eA/IQk6/uaDS6rJLbx6YwARQm7MBUdhj9iEYjOHhSEVeWphk/Xsmx
         oN3LCXxsaZhndXxHvKRt3a7F7mtjreErjGi05l6/VrToz1f4lSBjyhxhBnE2HizYN9Mc
         cUAt/cia/Q0z28TgnyJuKc5UY+u5SM12RKFPyWhEYh/qe/Aje0Cinjvsm5hb729AA1NS
         iKFFROv3y/Z2jLRVXpa/lN+QUDQ9PA2UJps7Q1nnd4S9HypCbhYEfV7MTXe18jEcktj1
         lCHT5C3vGdQ5EVG8NK7fF/k2RY6B+qMICdiAvzQmdQO9ab7L9Q+LEeSXvyPiw6OtCymZ
         Kc1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733237112; x=1733841912;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z02kD3ptGLXxLPiul0GJ51OSn05xcfsBoxVOvzJnNTk=;
        b=vw/QZqHLCGrl1s9qgsrmcpmnJGmR2oWVMtYwVsz0qWWmz8ma1I7uRR7/5cVKtmesn5
         TT/w6yC5vtoACde9IrEInPA2Etuxki7h6ANvRSYEUWYx0UkUqF/3EHTGRdorJpDS/yqa
         VVgz/8XAu6H1FzoNrjNKnX0m1lU53rH9S4YUT88hFUfTo7ja7XzfAfyeHYUWk94vRL8W
         TtVukQHmwr0dDgEW5Xt/eKkmkMZC1zUVgEgg1yEkgBdCZxZZmuFTHgTMKa401X47NkyX
         wMnqJwuV0b6hIbC+Z+bWZwsV1PY4SPgflusaa1ku836SQOYnp50baW9F11RKixKLAypI
         pWAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTH87qEcABvVkmQnbKUG419m81hfrCw61Mel3wPRs5v7dfRqjy9PhPqXkSLX2BnOzUwLYDpITKPtWD@vger.kernel.org, AJvYcCVa585um/DXYh0vuJU2ePJcU6vpsP9sXONyEN7LcwO1P1hnrDtCqsPNQHyW8Hz1Dj/dSP8hA317@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6T0+SZoTSJvqDqgW5wD6yYPIz2uiBnhrJaef6ExRiZZOxMeEb
	wusc+O8UnYjbHOlG3+BRplde1TJYWXwqvVcdiyUFdPmRab6qFKbx
X-Gm-Gg: ASbGncsenAnlVAnQTK+kloofud//O5/WtW648SZ+KGRsZvVbPgNYu/3SroG7EbKXPec
	V/s2hl8xqONdCPjEAMy78UQMxGpPOFxJyo/RtKEZBpMqLsX2sYyBQMva4/MphKglMarzHqbGNrl
	EUk7xqUnM1bOf3tiiiQHxlIoiDTjJBElNdYXmZjjve4NZ3jB7G5EqaGtCLjiRQOClZFmg4STKDG
	ufQuFq52ZXcc4/57dUXdqREdP0hVTuhV9dnbltjrz/3/FV3fvppm4qX1UdDOshuh0sISYBoSLVE
	CE1chHHs8Q==
X-Google-Smtp-Source: AGHT+IE/Bn2fcuUlIImOBoxukH5+B0LMPADawiYsSHDX+FHVMxtEyUFbGv8mThyhcbxmpLz0M1ZQog==
X-Received: by 2002:a05:6402:1d54:b0:5d0:f830:ef4e with SMTP id 4fb4d7f45d1cf-5d10cba37a1mr2595659a12.34.1733237112236;
        Tue, 03 Dec 2024 06:45:12 -0800 (PST)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d097d9f5fdsm6172512a12.15.2024.12.03.06.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2024 06:45:11 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 7684CBE2EE7; Tue, 03 Dec 2024 15:45:10 +0100 (CET)
Date: Tue, 3 Dec 2024 15:45:10 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: Paulo Alcantara <pc@manguebit.com>
Cc: Michael Krause <mk-debian@galax.is>, gregkh@linuxfoundation.org,
	Steve French <stfrench@microsoft.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, linux-cifs@vger.kernel.org
Subject: Re: backporting 24a9799aa8ef ("smb: client: fix UAF in
 smb2_reconnect_server()") to older stable series
Message-ID: <Z08ZdhIQeqHDHvqu@eldamar.lan>
References: <2024040834-magazine-audience-8aa4@gregkh>
 <Z0rZFrZ0Cz3LJEbI@eldamar.lan>
 <2e1ad828-24b3-488d-881e-69232c8c6062@galax.is>
 <1037557ef401a66691a4b1e765eec2e2@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1037557ef401a66691a4b1e765eec2e2@manguebit.com>

Paulo,

On Tue, Dec 03, 2024 at 10:18:25AM -0300, Paulo Alcantara wrote:
> Michael Krause <mk-debian@galax.is> writes:
> 
> > On 11/30/24 10:21 AM, Salvatore Bonaccorso wrote:
> >> Michael, did a manual backport of 24a9799aa8ef ("smb: client: fix UAF
> >> in smb2_reconnect_server()") which seems in fact to solve the issue.
> >> 
> >> Michael, can you please post your backport here for review from Paulo
> >> and Steve?
> >
> > Of course, attached.
> >
> > Now I really hope I didn't screw it up :)
> 
> LGTM.  Thanks Michael for the backport.

Thanks a lot for the review. So to get it accepted it needs to be
brough into the form which Greg can pick up. Michael can you do that
and add your Signed-off line accordingly?

Regards,
Salvatore
