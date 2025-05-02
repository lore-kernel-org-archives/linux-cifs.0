Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D374252914
	for <linux-cifs@vger.kernel.org>; Fri,  2 May 2025 12:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746189739; cv=none; b=aonCXpY4uzAGYAAmwPqLt/YU4x15sTc5cxSdWSc23tt1/rsOSBB63GLnI+6VL9ntKDbpxBStHLXT96I53j5a4qibu/lHz4A50pmgR1KP9x4w3a+7va1k8AcUwIyzxATjUEjHvrqUfXwv0br759I+9onR/nF3H9RiAAczN6uXkd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746189739; c=relaxed/simple;
	bh=mok54u5rE/tvg96Rxp3VatJ3u/1VGFoxlIUq/EOxXH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HzSnUxmXdWrHwzIhVVEze4w6RqCogvC31K2l+GP+0ylXwPULKy/8/UYsyDt+dIazy8xjASlLaHQo1wHy845XrcVcjbQkhdbDvpgm77DsvpYGvo9hwrEw6KY+UX2bUsxYSxzgbltucvHqR78KxsM/D1rlDuwWLEGZl91WLpMZ0u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AZIuxVIb; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AZIuxVIb"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ace333d5f7bso353201866b.3
        for <linux-cifs@vger.kernel.org>; Fri, 02 May 2025 05:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746189735; x=1746794535; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WwQCZD+ACHCjsnWTcyteZcF0dTR4NO/x2munawgpHvY=;
        b=AZIuxVIb93qAG2+sK0fLFzX05TD79ihY0bNz2W9ijLFkditBem+ziumzRAOOce9PaO
         JVEwwH1sfYGrNIckGvzqk3hfUtvqmSJXDRP4cfJ/1OoWdapqgQdu2Oy6/PAQ8ffr0Aq/
         0t5O7GJFJd8yAhzzq9YbhC2RKNH/GSvG4Hz/8DtlpewWelSNZKs/4ywgIqF44YkH2hV4
         tP79EgEb25GO7zNSgYwFR3kRRNEgAAyxDvCgGNu18AFz0VFRc/uDyVqjiyAnFeo5/4x1
         fv7hry3tDHZP38HxnMGvNpQiPz9TpM/PRRAx7gO7LDixdNoV3E5pQkIfnM5kCmKclqMu
         Mw/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746189735; x=1746794535;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WwQCZD+ACHCjsnWTcyteZcF0dTR4NO/x2munawgpHvY=;
        b=DLD7zM8YlILgGEaQfu5ayBeniQXjBR7HsV+CtrYeZr8HPM0yABQovz3qmc+BXuuJBA
         eYp+Zm/B1GlgvjE9veuiNyjLOE3xzEm17kBtItd/9tbTiCxYW++4FzRq9ETeD0RFSmxM
         x5OUqQN93CNRmJk/tHbszBdfjZNCYnFHvWB7bOFRb5At7jQLiQo0X+0Tvr4OZWqcAucT
         42sYL7iFZ48wBMlOBXCWYmXTNEmDcRPwr6mrU53nn+bf7njjFxb3odr5QoMdf5LOeeFJ
         oKDabTUj0rSUmXwBXmEeF+ieLrsXTiE545Xfkql3G6sb2u51CmeikJ4HRU6FBQwIo3Cd
         h5OA==
X-Forwarded-Encrypted: i=1; AJvYcCUiW5wOOOwaBIBMJLc1eHJhTbYIVv1PaksoVyqRTreSgrAu6YmXyg+txJOCNsgrbp5HPiCZ4TmrT9mg@vger.kernel.org
X-Gm-Message-State: AOJu0Yx60DyX6mTDC2h24SRtaT6YSvjRPX337HcC0AhKJY1kXNXiBpAC
	+9DfXYOozJj+ATEowHvxWn3cPRgJryTGhcOg5AILzi7339e/dPGAGRWXv6cauZw=
X-Gm-Gg: ASbGncv3hJnnSoYRBQPSoOAOs05rrY7xNfFwUbqQ42/H5Cpr1o2+4hVYbjvzMcZZcdz
	se4u27p+YgWf7YWJfssPHYiN/6J1BDCEySPLK3XkydXJ64IAXTZ1hmuKOr27YdNYLQkdfPdo7Gc
	kxrE2p3MvsMl1QdVt8wjl/ZgWHzTyzzRKu2wjBaOyJGGJa19J5zfF9Em/eA3g4DRFY17yjakMAN
	K28Wl+7Of1jgUutMsn8ruuIEZ3LhRpr+QyR2do7jIaWZqjvrddyQ9Gb/QRGSOzbkg/jEO1cpKP2
	O3UtisbkQf0jfV0PaRch9pEw3q0f5sV/k+eLEFH5QBWdkCKF
X-Google-Smtp-Source: AGHT+IGxF6QASigBJBwGuChw8+SLjPEMFaYYmE19YZuMV6z12jXXMbHkTrgzOGM1g58DTRewM5n8ew==
X-Received: by 2002:a17:907:7d87:b0:ac2:a4ec:46c2 with SMTP id a640c23a62f3a-ad17afcb2e1mr272974266b.49.1746189735593;
        Fri, 02 May 2025 05:42:15 -0700 (PDT)
Received: from precision ([138.121.131.123])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb2890685sm636048a12.0.2025.05.02.05.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 05:42:15 -0700 (PDT)
Date: Fri, 2 May 2025 09:40:35 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: nspmangalore@gmail.com
Cc: smfrench@gmail.com, bharathsm.hsk@gmail.com, ematsumiya@suse.de,
	pc@manguebit.com, paul@darkrain42.org, ronniesahlberg@gmail.com,
	linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 1/5] cifs: protect cfid accesses with fid_lock
Message-ID: <aBS9Q2esx9y4FgW2@precision>
References: <20250502051517.10449-1-sprasad@microsoft.com>
 <aBS8jg4bcmh6EdwT@precision>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBS8jg4bcmh6EdwT@precision>

On Fri, May 02, 2025 at 09:37:34AM -0300, Henrique Carvalho wrote:
> 
> You are calling dput() here with a lock held, both in path_to_dentry and
> in smb2_close_cached_fid. Is this correct?
> 

Correction: it is in cfids_laundromat_worker.

