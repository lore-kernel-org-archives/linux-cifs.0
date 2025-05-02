Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D73D1F2C44
	for <linux-cifs@vger.kernel.org>; Fri,  2 May 2025 21:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746219671; cv=none; b=tYbuWk+I/+qFvAajmFVn61UoWlwkmcw3KG8qE06PgXiYcjimqaJOzFzEVA8zI00ucATtLd0V33rSY+Cz3Tsunoz1Xjtc/zYCuVB/4s7VMtvONa3LOP1LQDzTNTz6mzigcTrAOP+p55K4oYN4u0sYdbIKUyJkn7VyIyQzooSPwSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746219671; c=relaxed/simple;
	bh=yR21I1QMX79J+RnkxS4e/ktINfL6gQMpXho8pldFHwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SOoYZYf7bUCJ3q0fcYoChkTGtXMkUjOhTrOTYtbB6k8otaZ6HbC/9uL7J1gVYlifyx36MmlOi0u28NUsakGGYNq9OfEUmHaVBMyGhxExhnohPpTPh299FpLcBYbzQzQWsGvbAamc7WPNCjXxx/qFehozxOxqCkeTCp0hR781j+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eC+oNgAF; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eC+oNgAF"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ac3fcf5ab0dso390972266b.3
        for <linux-cifs@vger.kernel.org>; Fri, 02 May 2025 14:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746219667; x=1746824467; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/Fe3HRLwRA4QXp7HlCxrjsF7M5CYn1pNcIOLH2DF3Eg=;
        b=eC+oNgAF82Mwf9WaekI6Qa/FxTSeR76+ZH4CRzBP69Xn8JyEM+aG6ZrHpB5VdMERUK
         On1ZfiLzKKzXyQryJon6jhYatDZzarkkbP7SN8BKsto8BcTKBiZ6049GctE7aRKW14wZ
         A8DqthfvsX6rWAts6qT2hzlw8siFz4xkU8m05aDqgRspAqxvf1umOUdiBrVL+PzUZzlM
         3LY3SsuJ8/Srj1epEYNk6cxzpja/vC8bTYjq0GvcgBxHyKqML/4f0F9jt+ZLg1v3tuvN
         590xWQC1Dk/0E808wQHd3nVWpWGJzskWxH7mpmbWtEGCCyPHsRjUj5TgLjEjIgMNZ+0b
         Wczw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746219667; x=1746824467;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Fe3HRLwRA4QXp7HlCxrjsF7M5CYn1pNcIOLH2DF3Eg=;
        b=rYV1dShhemfvpAC4/h+zn2qPY1n3SbXarwzxkXN8ukoPdiHbrxlEEKXpNyk0HCJFmk
         yKPKLkEnhXqZ4ijZGLtUcP071s3mhW6GY10V/Ylnz+Z9YWzDF/7FBhejj/MDtnLczrKw
         3R/j55u+V55htvc5n4Ep48uJ0KgTxdWwzEfdAGR7Cl2U4Of5gZTPthQeEDJ8awvfSTqH
         F96bC54bV2KdR3Po2JflqAI13CS0WWkbMoYA+gQmHttMh+/NfFdc+JkUpFfcpz4nAB3G
         5WEiCXHw8prIlvaEhVcbxrMv1nTTTHpyEzR6dVOY774lYPLGMUZCfpDm3lJOsaHHjjy7
         BIJA==
X-Forwarded-Encrypted: i=1; AJvYcCVx5ogi0y2Smw6EYjSquPdoCPuTyjde1MR5sG/8f/NaLDSBZH1d77ZxROXH6s25RLgQL4onxL0xdiLU@vger.kernel.org
X-Gm-Message-State: AOJu0YyinqIV4PTcXD8IC0uIgiX7VCI36ewqcqGxMHzyQ21yXU5ho7Ju
	DJRr6fX40TZaZYwOE8HmuinwpHmhgvhx7kS/HUklipMqBgzK7xS1dSzYPY50AM4=
X-Gm-Gg: ASbGncvnBPw4d1nQqM+gyKieMH0+0bXrr0DSh60QQleKJYk1Uf1Gh/sQIylPj/3DQ6K
	iEkLLL9le09TwBwkbAfd6EdBxsXJ50G7DQhpQbeXGkwL1bxXDUHYRGgy4FoHVE+Q43OnL+fMWIG
	CzbJZkbONYBPZelMZ13qPoczYPDc3W2xAcW9QllG66rlNgqhC+oyVh/A14Nfc0YmyjcEbu2GVqd
	DbIYNZpHmGdr9by5IrUArGGjK5pIhRgMJ/BX2IRk5eh0RJdOnAd2UfucOhWb4MOm2FAa9aZCH/z
	tfQHval+J72ydEKg97/IL1JSht8yrZHliUDHcFuUV7fe5+O0
X-Google-Smtp-Source: AGHT+IFEWB7VGIKEhre4AQnEaGbwc4YkBEPImJMq/L0DHqHNWwBzS1sD0JwqetJvWpTbXUfTdwCn8A==
X-Received: by 2002:a17:907:7f94:b0:ace:6f45:b5c6 with SMTP id a640c23a62f3a-ad1906577fbmr62747466b.22.1746219667310;
        Fri, 02 May 2025 14:01:07 -0700 (PDT)
Received: from precision ([138.121.131.123])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a476421aasm3503698a91.49.2025.05.02.14.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 14:01:06 -0700 (PDT)
Date: Fri, 2 May 2025 17:59:27 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: Steve French <smfrench@gmail.com>, pc@manguebit.com,
	ronniesahlberg@gmail.com, sprasad@microsoft.com,
	paul@darkrain42.org, bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: Re: [PATCH] smb: cached_dir.c: fix race in cfid release
Message-ID: <aBUyL2ypuI2PTvoy@precision>
References: <20250502180136.192407-1-henrique.carvalho@suse.com>
 <CAH2r5msw0gCUH29up7D5p2eH5LLGtmwu9E5PJagUi3S2trPHrA@mail.gmail.com>
 <fh2ose2otti5opro6jmpoo6dr4uhc2nfdrlgo3e2ikim4y4gqq@7zxtxyyhphah>
 <aBUpD0LzzzPUbRjz@precision>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aBUpD0LzzzPUbRjz@precision>

On Fri, May 02, 2025 at 05:20:31PM -0300, Henrique Carvalho wrote:
> On Fri, May 02, 2025 at 04:58:00PM -0300, Enzo Matsumiya wrote:
> > On 05/02, Steve French wrote:
> > > I fixed a minor checkpatch warning but also noticed this compile
> > > warning - is there a missing lock call?
> > > 
> > > cached_dir.c:429:20: warning: context imbalance in 'cfid_release' -
> > > unexpected unlock
> > 
> > The lock is taken (inside kref_put_lock) if count == 0 (i.e. when the
> > release function is called) and must be released from within the
> > release function (which is done here).
> > 
> > However, sparse can't recognize this and also there doesn't seem to
> > exist an annotation to indicate so.
> > 
> > @Henrique do you think you could rework the patch to something like:
> > 
> > cfid_release() {
> > 	list_del();
> > 	on_list = false;
> > 	num_entries--;
> > }
> > 
> > cfid_put() {
> > 	lock();
> > 	if (kref_put(..., cfid_release)) {
> > 		unlock();
> > 		dput();
> > 		SMB2_close();
> > 		free_cached_dir();
> > 		return;
> > 	}
> > 	unlock();
> > }
> >
> 
> @Enzo, good idea. I will rework the patch.
> 

Actually, this change would prevent me from calling cfid_put() with the
lock held in cases where the kref does *not* reach 0 and the release 
function isn't supposed to run. While it could work, the code won't be
as elegant.

I’m open to suggestions if there's a way to preserve that behavior
while satisfying sparse.

In the meantime, I'm reviewing similar discussions on other mailing 
lists to see if there are known solutions.


Henrique
