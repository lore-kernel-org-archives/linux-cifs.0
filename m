Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB9126982C
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 00:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779152083; cv=none; b=LK+K4V4sa4dIC9iFjOoYd2Bf/pTfrYvx4nTxc9WHI5RQRhbHQyXYbM2uK//sousUrlpUx8hzhakr2nvYH7qRDHCdMuSwmD3RInhSVpG+OZ02H0GVeV60iUvWDViNzs8XHuBvUtCUnaTn3OrQdhuC1xNpmqwDHu0RYF3b+CUWfkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779152083; c=relaxed/simple;
	bh=lSja7ZbOLuuM+tCrgRWCxBG/Huz3q30x9CbuMKnrvBM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SUJkxm8i5oXC/+sl54ENJZhmM/6FZrJnPKQaO1VPt3X+i6DStyZVXpkN1zri+JIGZJgwK7o3JUYO3eqryFQgZTZ+EJp/E5P6j358hzZbW0gQwh/+/umQIuFyldikz450LfSs6fcP4u9avml5VcML9MUi93DrmXWWXaI5LG0a8sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IJab62+/; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IJab62+/"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-bd3d7c29b4dso435389566b.2
        for <linux-cifs@vger.kernel.org>; Mon, 18 May 2026 17:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1779152080; x=1779756880; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CP8YOlMTq6wrxw+7ONW3izZGo2Gu6xGgxSrk4HzA858=;
        b=IJab62+/L0MwSui/BweH8H9sX05dwnmPqqkMfCxmn/fETyptRyhuaZwLSpYVjmNEAw
         akRs/CfmbmLNr8rx5TCajjhixhdrIH5+ZtN1uaVOHbJz4erq6ykCqVH2WMqKqlpPDZ0p
         DzkbDwYszIsg9yd2x5p5JmXW12HO/ircr6EeE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779152080; x=1779756880;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CP8YOlMTq6wrxw+7ONW3izZGo2Gu6xGgxSrk4HzA858=;
        b=tXliUMD7HkQmbx5+3eWLu79GMj2WLjXl5+zGNUgK1fP4TKjvQfJU9bFOmQfUQ67N2p
         rXX2Kf5gXHpZmCo8rEqDA45De/+n85D+ukOoNiZvcjFtoMR8xOc6hQo3EW9IYV5qvsJK
         d3F5DD9foZ4LT1QshnMhdhMBm6Bq745RqM25m8794L2gPsJUDzcVpmKiY1OXm7huKciC
         CBbe50dtyF8FdLgnmQRwxgQR1ynvS63SAYuFI3jWO35pMbtNqZkoZ8G3KLpkl/PqoDVe
         e3+NP0rVGq0dCeMEcwCUI4Z+L2fxknTkch3i/DnEIzADEhW6WDUr/6pKcoXb/CqSRNUT
         EUfQ==
X-Forwarded-Encrypted: i=1; AFNElJ9yCWsKZROKDc8FeNP7XYRt1owk4Iu6Q/cvUeLfwVBFCkuumTqKNLAQUSD0mTP3DOWBUZXfsVUkC68O@vger.kernel.org
X-Gm-Message-State: AOJu0YyQ21wXE2GQEycUvbu/1h3LQVtxMh7JI0vqKaZHbqbbJ4JdP5zx
	dCZO5FQMbJhai/0yhTPtCWvHlctVTEzpmI9ZV8zwcM9uzHqFsWcZyWcr5qmkgu1r10oWuHifUSV
	Go64Zguk=
X-Gm-Gg: Acq92OF6+xtjGQglSTzurEl3l8nHW92f8ODXzaUchL2PXBXEzEWaXz/p2Mh1c9AXgjl
	HkcrKZ298UOiJ0P3UcFE1j1wCAP7bcuL6ZS9CUU1Z4MKaYwQ3MaEX5Mkibvki0PddTRAiRITno+
	ac7bg72VahpSMBX164S9RKxFToXY2wHNWRs/1KH4EKrQ4brgLFuNJITx0lAv8lIF+k7jcODeOp3
	9f2+hl3nNcA1PBS8D4N/oswKdTf+fX4VzdphWV1iU8uJZSEVHxRwjbLyyhw3R3I8zfy7lM+Rnv2
	e5/FsgfyKS/C1VPFnyHh6ZV6X1FprLeouxxj2W/EujZ9VH2UKwtxYPhMjksdrwkD/Sdw55xV1ot
	i/EUWDe35PDAPSCPU0LO87k8AwMP+MJKgFIRQkZbXm4cI6kJS5XtO7QuDiKuV3vK+8iXc84ClRb
	PdY6I4w9WxtTTKeufFuXelUqMjY+87iQXh5MAshb4Y0oy6Htyyav2ccW0vj3OAQ2ccDoLgZAdb
X-Received: by 2002:a17:906:9fc6:b0:bd8:5ef9:9b34 with SMTP id a640c23a62f3a-bd85ef9a07bmr280153666b.48.1779152080609;
        Mon, 18 May 2026 17:54:40 -0700 (PDT)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68311769040sm5829938a12.24.2026.05.18.17.54.39
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 17:54:40 -0700 (PDT)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-67c9616b4feso5136710a12.1
        for <linux-cifs@vger.kernel.org>; Mon, 18 May 2026 17:54:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8ZYu6xBLhYBF9L9mwwzz5T0vdRHyg+x87ZQdZhtvE10OhsP4PR0GUSINV+nDF6MGq8pOE1+BkDKa9s@vger.kernel.org
X-Received: by 2002:a05:6402:a204:20b0:674:74bf:8813 with SMTP id
 4fb4d7f45d1cf-683bd28e6a2mr6610808a12.21.1779152079390; Mon, 18 May 2026
 17:54:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <413536.1779138789@warthog.procyon.org.uk>
In-Reply-To: <413536.1779138789@warthog.procyon.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 18 May 2026 17:54:23 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjf32qPV86aShAgdqyBBNogwtsHzTD0_EvS-E5hqqOmVg@mail.gmail.com>
X-Gm-Features: AVHnY4KUQimu0k87RSyMxbO9S8Svq-BAbgZL8GTzoxNq4QpYl0eT4JDtoHR9hKI
Message-ID: <CAHk-=wjf32qPV86aShAgdqyBBNogwtsHzTD0_EvS-E5hqqOmVg@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix undefined variables
To: David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>, Nathan Chancellor <nathan@kernel.org>, 
	kernel test robot <lkp@intel.com>, Paulo Alcantara <pc@manguebit.org>, Matthew Wilcox <willy@infradead.org>, 
	Christian Brauner <brauner@kernel.org>, linux-cifs@vger.kernel.org, netfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 18 May 2026 at 14:13, David Howells <dhowells@redhat.com> wrote:
>
> Fix a couple of undefined variables introduced by the patch to fix tearing
> on ->remote_i_size and ->zero_point.

Applied directly.

              Linus
