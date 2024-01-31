Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5B347F7B;
	Wed, 31 Jan 2024 06:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706682645; cv=none; b=sbHeByrhgw4oIu/WnKmZrQi/KrHrdn1bihWrpxoq00yRk5y6Oer10QIbgcIDeZ7+W1FlZVilSHXxKG9EZMpCB2nohVuDIx22tNCbegwThwvFOolGLVpiA/ei1vnsv9Fe74aoPKAJ6c1q7UyNg8BkzusKwUXbZkIAF4Mr2yiutEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706682645; c=relaxed/simple;
	bh=HDBr9vOZxFay+edDsZgAptwCJ/oKKwkEzYfcKNkxY3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IEFCBvjHlWbkL41+930YlJ2Ti+9SiAQtxe76pZ+4wK1hkLLeeG3nbDsPs+wutcsxonC8E0hc37nb3lOWgQid6Nh14L9K6Ijt5n5zkElrjpQCFh6alFg0vHQc1sO6Ut2v2DV3bBqFkh2iY2ViT0ar+fzvT2BWn0nhdMJ7IayYcBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F01jTKNW; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F01jTKNW"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-55f0367b15fso3688167a12.0;
        Tue, 30 Jan 2024 22:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706682641; x=1707287441; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IEwg9afw4u1sOTeb8Gs+nYWC/t/ruyXWb+PKAxK3AR0=;
        b=F01jTKNWN3NLc3BvDAOsJhCh5whNp7Yz4KJgsFwqgINj7HkRi6svzLnPrrd1ilDNS8
         B01luMSLAOaUNteaXotOEBLhtRM5TcDZFcabDQ7nqzkLvn1smAdmJ3AJFS1NXmWb+TlY
         Lbxw/+ALg1Ojx0DKn4HaTGh6s+W7ivmXJF83xcJ7c/3sc8DopjQ1FtuTPN/xw+l1C0jT
         fRIPQNxprpWvIIgbkhU5aUDUcakJ4MZAYfOSq+LoXuXPlsZWQ5QhWw9nu8v5Kumar+bg
         ru+E4xUtRA5+8AVi7CLRVRjOTFzPs+TfXJ7o84XI4HetM+Ev2gymQodBMp+mOPEouQ7M
         qQXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706682641; x=1707287441;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IEwg9afw4u1sOTeb8Gs+nYWC/t/ruyXWb+PKAxK3AR0=;
        b=TeufJbKWgpL8Zy+RVqWw7mscXZsCU0VARWKnS1FCzdMkyBuiz/BQm1+/hY2ASoNHue
         A0ZK4JT4HJ0s4VtzO+BNzBRsGlg+2d+gdWrIcdNd9nYUg1p2npKkoWAd+YNCSOy2oKZH
         /v5M7/xHaAyt4dyTD5NHetgAdQ/bI9Oyo5S0WA34tHIn7QHok9u2Hf2q+JOV3o4A+4CD
         uZzZUvN9d7MRljlcicmxaedCFVOnx2yPC67xNRX7lXwpxF1NzeCsEOZ0zKKIcma6IsJs
         bCRIKgJ0EduGpWQ+Xla11almUphVC4nJxiOblXHME7h45jGoJKbd/PZjj/lo89Xtv1gq
         4w+A==
X-Gm-Message-State: AOJu0YxXUZv6ixKd95vCRoVnA7abcT2J+ygHe8K08haW+yzpQqe8dqce
	RlFimmjW+FkPlPjQOz2evcpXmtSE9StLwB7ilPLDfJxYcknwo96n
X-Google-Smtp-Source: AGHT+IFk1qhBrpfQXnqfbsB1jZHkXsEX9haNcgmHftxJjglWVgEW9wTSF+vKlynagor381APN8AosQ==
X-Received: by 2002:a17:906:d0c9:b0:a36:6c96:3161 with SMTP id bq9-20020a170906d0c900b00a366c963161mr417340ejb.32.1706682641212;
        Tue, 30 Jan 2024 22:30:41 -0800 (PST)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id ig8-20020a1709072e0800b00a366406772dsm491691ejc.29.2024.01.30.22.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 22:30:38 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id B0105BE2DE0; Wed, 31 Jan 2024 07:30:37 +0100 (CET)
Date: Wed, 31 Jan 2024 07:30:37 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"pc@manguebit.com" <pc@manguebit.com>,
	"leonardo@schenkel.net" <leonardo@schenkel.net>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	"m.weissbach@info-gate.de" <m.weissbach@info-gate.de>,
	"regressions@lists.linux.dev" <regressions@lists.linux.dev>,
	"sairon@sairon.cz" <sairon@sairon.cz>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [REGRESSION 6.1.70] system calls with CIFS mounts failing with
 "Resource temporarily unavailable"
Message-ID: <ZbnpDbgV7ZCRy3TT@eldamar.lan>
References: <53F11617-D406-47C6-8CA7-5BE26EB042BE@amazon.com>
 <9B20AAD6-2C27-4791-8CA9-D7DB912EDC86@amazon.com>
 <2024011521-feed-vanish-5626@gregkh>
 <716A5E86-9D25-4729-BF65-90AC2A335301@amazon.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <716A5E86-9D25-4729-BF65-90AC2A335301@amazon.com>

Hi,

On Mon, Jan 15, 2024 at 03:30:46PM +0000, Mohamed Abuelfotoh, Hazem wrote:
> Thanks Greg, I will submit separate patch inclusion requests for 
> fixing this on 5.15 and 5.10.

Note, my reply in the secondary thread:
https://lore.kernel.org/stable/Zbl881W5S-nL7iof@eldamar.lan/T/#mb9a9a012adde1c5c6e9d3daa1d8dce2c9b5cc78f

Now
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit?id=a280ecca48beb40ca6c0fc20dd5a7fdd9b3ee0b7
was applied, but equally the backport
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?id=06aa6eff7b243891c631b40852a0c453e274955d
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?id=ef8316e0e29e98d9cf7e0689ddffa37e79d33736

So I guess
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit?id=a280ecca48beb40ca6c0fc20dd5a7fdd9b3ee0b7
should be dropped again.

Regards,
Salvatore
