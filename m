Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB12A30B502
	for <linux-cifs@vger.kernel.org>; Wed, 24 Sep 2025 15:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758726608; cv=none; b=iDBrZg1ifrV5qL7BRH3bRgmG26UhbLB+E6SVoSdmaAB2af3swJXYk9NIj+D8/vRRnlsbKDOPpDsB0w3qytOVSI/ZpWJRgqr6EmiJfyOx3SGB2ih5OK0jRnhEXohumwJoW+7krmdXjcZd1MLPHHfYt70oJenmNZPD9EakfQO6rio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758726608; c=relaxed/simple;
	bh=o9l+UpM6TnvuIgqAlQQqwM5+vFrRpxqhLUwLqQT6bUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p3vm7Fu0r2bODMhWT0+zRLyZd612y08giA7Ull2/MO5BlH3wyRi4nIr1emLuybTuqH/ujQj6WlHG3C/6FFTG2EHug3Vj6htrjKVCYH9w4zg6jMD1C2lHx/eO21gXK+T0vudfzgHB4mcKmpQW1ZsonAK1cTZijnhFOoJ/u7+qTh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=CO1LEN93; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="CO1LEN93"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7704f3c46ceso6518030b3a.2
        for <linux-cifs@vger.kernel.org>; Wed, 24 Sep 2025 08:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1758726606; x=1759331406; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YKov2x3Z1C460EYUujFQHxRe53csDS7SRInDm9gIRVY=;
        b=CO1LEN93+8XO70USrOEjH8LXzlaNqj6qfjHxvOzb1e29n9TjgOBgFHlZDAHdLiD+LO
         JKQ88PLbtcu3Sc2j20AFihSUH17rbqNApNBmaK5pIAQAGCtoSNrsicxf2T/NUIJHfQdn
         /cNmM3anfJGPYlBj+PezRPcQrQqar389jsidbUeq+EsRsWPTZPGLyrmRkWP9EnPWL9IW
         IaqzDRsNLVEOCcU/IoyaoxccToeNiafSCEpu81SJAHKCHSRO52ntdwebhSl/RnvVL9RN
         Mo+xC05YxKK9p/MA4RSUOklvFzdB5P8fj/H56T2JK1TU/Sf98a6u/LMmajeh2G3YHGrb
         8ueg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758726606; x=1759331406;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YKov2x3Z1C460EYUujFQHxRe53csDS7SRInDm9gIRVY=;
        b=bcsecca7blLXrreO4zwYrvpUqfsIAriDvbxdvXReQslcqdzCnMMHLVmBp6RLj6efka
         qPpd10hJsgd13Q6smP4Gy5z91y3ebDHZDiwi0B4NWhWJFAktARnKy5mhW8W6ELfLbunY
         /7B74v5MswP5YugbaxiYzu5JRf3sA0GZgpCS/fjmdQ+6YsHh+Z0K8cFXqQNCpD9vTzRo
         scuiKD8/H6VobGvLEH14nO7LEL0tyKpV31WhvvlxbOdd4IkGq3wmqx4A+tujR5wWRTgX
         c5zbUmJIBcRzsDWIyxoKTqC1rb346zz3WP2sXU+mD0cMDL06Q50rbLXO+Lgc+tpiVgA6
         VN4A==
X-Forwarded-Encrypted: i=1; AJvYcCXmmj1Kp8qYcAn2vG9W53ZnzQh5ZhO1A1j5Zv/xW826gyDanvUamhjk8O4u8YpUYNaxOh1bYcAr4ENR@vger.kernel.org
X-Gm-Message-State: AOJu0YzUHzJuXlSn/JXiDY1GGhI3WXBb6kDSB5Grctv5P3qD1H92nZOO
	lv7+PCW0wFeSS0ExSWf63H+pNKMkCQKaO9Wbix8iTuSG5YStStFkEH10MxnyAdPKrUbqYItoyEm
	DTq/V
X-Gm-Gg: ASbGncvvlGy6pCZ8VAaqj4mUriWD+NPTW7JrILjUkZZI9fyTZ8WoeHoTBN7xK+Jux7l
	jFbvChJjiFEwBIia2i5nmY5tiUgf4N0fKas29J2QP0s0UxbJZesf5BRp98vWEZ7x8OhPKgLZ7pH
	xqg4aVooFtUx6HeIOOtpNipxd15pn6muywvOrdK4ISYk99l8YJihwnEYXenXyoPwG8jjEgJgYqp
	31i178GY9WoIumh/Gcl0pWsyDAuAHlm60wT18wjsoVnLzRvUdfM4au+xBySvNLZZn3UPGDKvKtW
	efhd5ftrMkpjQ5JkjhnfqyTS/oPzMui8DcmYZQP4t1olgh/EVt9YDZ0/I33zFlrmKJq2FTqN
X-Google-Smtp-Source: AGHT+IEgx+qHnsS6Q7aqCIQPwDj5ptlLouPvJ1KZj1zhC86yYDGO9mFDajeOyDgyihQlbs/qjdFEtQ==
X-Received: by 2002:a17:902:c102:b0:269:b65a:cbb2 with SMTP id d9443c01a7336-27ed4a46418mr446155ad.47.1758726605948;
        Wed, 24 Sep 2025 08:10:05 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-26cbd206904sm153909175ad.0.2025.09.24.08.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 08:10:04 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1v1R86-0000000BEYn-3u9r;
	Wed, 24 Sep 2025 12:10:02 -0300
Date: Wed, 24 Sep 2025 12:10:02 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Stefan Metzmacher <metze@samba.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: Does ib_dereg_mr require an additional IB_WR_LOCAL_INV?
Message-ID: <20250924151002.GK2547959@ziepe.ca>
References: <656eacb1-a39f-4b59-99db-5522d102468a@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <656eacb1-a39f-4b59-99db-5522d102468a@samba.org>

On Tue, Sep 23, 2025 at 11:09:48PM +0200, Stefan Metzmacher wrote:
> Hi,
> 
> I'm trying to understand (and hopefully simplify) the code in fs/smb/client/smbdirect.c,
> related to 'struct ib_mr' cleanup on disconnect.
> 
> Assume we have the following sequence of calls:
> 
> ...
> ib_alloc_mr()
> ib_dma_map_sg()
> ib_map_mr_sg()
> ib_post_send(IB_WR_REG_MR)
> 
> On cleanup we currently us something like this:
> 
> ib_drain_qp()
> init_completion()
> ib_post_send(IB_WR_LOCAL_INV)
> wait_for_completion()...
> ib_dereg_mr()
> ib_drain_qp() // again
> rdma_destroy_qp();
> ib_destroy_cq(revc_cq)
> ib_destroy_cq(send_cq)
> ib_dealloc_pd()
> rdma_destroy_id()
> 
> Now I'm wondering if the following is really required:
> init_completion()
> ib_post_send(IB_WR_LOCAL_INV)
> wait_for_completion()...

I would say IB_WR_LOCAL_INV is redundent with the ib_dereg_mr(). There
is no need to invalidate something that will be de-registered in a few
moments.

Jason
