Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AD61C9EAD
	for <linux-cifs@vger.kernel.org>; Wed, 18 Sep 2024 17:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726681978; cv=none; b=EVybUmZ5QYVdoh56eU05k2Tn/MzWWyI5RiMvt+/bKutL/qGJzeGAA3MDDNCxrqBI1pHMDgNwrwz4ASJptOcpXToZ+h5ruOm9oFZhj6O7r/5t171KtUd3ZTdQECAGtmK57FHjFCD7l+22jB/f2fZDwlGlJQLbRuV3jxF+RbL7spg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726681978; c=relaxed/simple;
	bh=11VZD1qOa2ru3urXTJN1IT9r0aIGNIz8KQ+dg+XkLlg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nL1SEMXEuQ/wRbBgF/b++kDlVCt/RtzNvGoa0cj1SejCZf76Z2Z6WCSzV/HsFj/FyqWMdGBhpzROczDfhMw1FqHeFeFrKfU+vGbVRAMA/v3HDheHcsY/1jpWvIhz7OB4b/IIHuVFnaBTGUa9fcr+QXB9kYMPxoG4x54tCSnX7OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ch1sKFWW; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ch1sKFWW"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-53653682246so8474784e87.1
        for <linux-cifs@vger.kernel.org>; Wed, 18 Sep 2024 10:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1726681974; x=1727286774; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mz9e9ltNeeFw3jtmwhfVjZ94KhRB1fmKur2lGBqRaQc=;
        b=ch1sKFWW/OMr2h+hDRfFzWzC5m9167aiE1jxzepf1m+Qj0AehS2YgV9v9HUKNV2QKB
         My1HNctIzqgNir6KRBPz0SWuENLTGiijXrlHO8q9P6d1Qu/wNnNA7Od2i7U4AXr1GRGF
         MBD+cCFJQEVlo+Yl0+YMSbojYcFwYLYtBH47UAryqjbN4LugVai76brlqd912kP60r6f
         5dlETgpjonXKP0Rs0xv6t2GH1jWhLuvdR0QbP4itKpdCN8yhqDzT8P7DXroqSW0ROrjN
         BpZLmEx52B2F6n7ETVfyV+pb0ludwp4oL4HUPjrkk7fdMwAmhX9avNi6gIE0boIGyI5q
         TP8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726681974; x=1727286774;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mz9e9ltNeeFw3jtmwhfVjZ94KhRB1fmKur2lGBqRaQc=;
        b=bsM/TROFslpl6cejVXEgqP0n5dyQff4d76sauCy8KIhw119qdV0M+wY6P65NdXrVAG
         II0QcCa0BarseVUiMGTEbrrkp3PkzBe2ghDOcM9/DWQvaM+1JymWquzLnWKmwl02oLOf
         1svZGsK0vMoaCwf+i+fgavhdSJldqmuAsjHBtzMJuQz33HvwHIVRs7lD3AUVSf9bG0qa
         vGde+SswRCyLB+r9NUOUPL9Qpc6BylZ6pjULqYoRaPc1x6d51+LeGCgliHYQXoiVMTgU
         T40W5hF+ppgeEH3SkLiOi5S59kPNjYwDOKU4Ftrg3TDjN0HANzaDRjbtDSnAtk3WkEYu
         9MSA==
X-Gm-Message-State: AOJu0Yx9Y8QATOaI18DhFGlUnKtDIsyIJfj+t6g+YlCuAWX5FZes0Y5v
	SBhf/6jrerNhxT8T9umF0+s689j++PdPkk1EwRVld2/LvetPHqbbiQu5YMLmC00oMSmvleaO4fT
	PTak=
X-Google-Smtp-Source: AGHT+IHCLbWmzIcZfSPKiiRuUHv1UufmKRRs0bSM5JdEdRO31MFKzcnJN6fK0aPTBDj/Ye11cFqVIw==
X-Received: by 2002:a05:6512:12ca:b0:535:3d15:e718 with SMTP id 2adb3069b0e04-53678ff2ed6mr13378602e87.50.1726681973989;
        Wed, 18 Sep 2024 10:52:53 -0700 (PDT)
Received: from precision ([2804:7f0:bc00:2db8:81fe:b730:54c4:ad89])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944adf70fsm6969423b3a.89.2024.09.18.10.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 10:52:53 -0700 (PDT)
Date: Wed, 18 Sep 2024 14:52:35 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Maxim Patlasov <mpatlaso@redhat.com>
Cc: linux-cifs@vger.kernel.org
Subject: Re: rmdir() fails for a dir w/o write perm
Message-ID: <nfqi2vtpgpvmmix4h2fesil2smneezbhciqhz5rj6dxilh5h3l@eoa6hlabnjml>
References: <CAKRryJZs-gXnWCYUXhbjV__OM7T85xpKp9nvPOprJzcOJGX9=A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKRryJZs-gXnWCYUXhbjV__OM7T85xpKp9nvPOprJzcOJGX9=A@mail.gmail.com>

Hi,

On Mon, Sep 16, 2024 at 03:43:22PM GMT, Maxim Patlasov wrote:
> Hi,
> 
> Is this a bug or well-known issue?

I think this is the expected behavior.

When I try to reproduce this I get a STATUS_CANNOT_DELETE from the
server.

This is from a MS-SMB2 Normative Reference: 

If File.FileAttributes.FILE_ATTRIBUTE_READONLY is TRUE, the 
operation MUST be failed with STATUS_CANNOT_DELETE.

ref.: https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fsa/386d9ec5-e0f6-4853-b175-c05be01419e0

--
Henrique
