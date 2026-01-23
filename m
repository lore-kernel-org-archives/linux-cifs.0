Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEE52D877E
	for <linux-cifs@vger.kernel.org>; Fri, 23 Jan 2026 13:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769174601; cv=pass; b=mtL/U/iZAM9VbmwHNBMHdvW4W7m74iHXBp7RJuzUUvA/o/NGc+H/rZo9GtUs2Fj/phJPFtNVpaqh0CTSrTBhFkPBChJsh5E6WbPvJIEZHpLGl9JKHkHpkWjpSasYqPnIyRaMEqF59fg3T0ff5lJjkNJXI8ZpXliZe2ptNmmL11A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769174601; c=relaxed/simple;
	bh=2yMX4KMIacTi5G1FaT6jVtT+6BVY1UFvsXDRT1eQCDg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=on5qKvMoUNnPAI0GDbLp+evoqA7pWjljZ4vfUvjbT5lM3V8rmMWMGbnN2xDke7HK6XgpFnOMlf48ak9H5F0iYoOzpQRc/RX+ltSmsLjIZGmP2r2W4Yxgl79ZuDa8dNWfBO1txtB2eJksbFYkGZ8Oo07njcFtCOy99ZxxNBNYrJY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NkoyQRiZ; arc=pass smtp.client-ip=209.85.217.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NkoyQRiZ"
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-5eeaae02888so640840137.1
        for <linux-cifs@vger.kernel.org>; Fri, 23 Jan 2026 05:23:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769174599; cv=none;
        d=google.com; s=arc-20240605;
        b=jfJlKkTbtK8BG3iZk2xXLLQtjtrmDlZf9Ed7y5LlujMkB9SrLN7YFAgxLMAFahSRss
         +xtDNf+luTTuS/VVRMDbjGxu4BWQaowMXFxRAZW+zHmciPgPJs3PPFnIXHdN9R9RaQbZ
         +40JviyhKR5QPJzlPBIJw5N7u7Tcb8OfKBr33q3YDnd4M1wzWznR59ZJlShluDySG1t/
         5CKB6FGEGSY6n1NImmyB6kILOgK54aOVNasZHDTGzJCwIb78Btmy4KPRYTiHATlr4xX5
         TsmYWKTUAC79GVCUpYqS7ZAUU8EmXR2FAKS/yg7Dx2v6CGT5n8URb68HdKbbsM32mOkP
         UHfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :dkim-signature;
        bh=an5pupjXgIQPeCf/UmDnIpSea/cRkdaOPzIbp8qXmEc=;
        fh=8eUXjq+P/fg2mTFjf4b2ZMO8AcRNufsf5T02WOZIgWc=;
        b=gcmrQGruH2+iveyeFFWA5suDgqnhjDjlD2GrNmCAQQPt7lH3tdZ3q+4d3QCmO1HUa7
         DX4VmeIPvhSz6m4HrwgVwyyBNnYHvKC10EASFnZC2cnurAY8GxTlUTFPqeQkvtsQJLjg
         yU3xIFCVTwfVLm/dmL3n8w3DQ7STuMUq+aaUP94MtR64elebQHsD+fwSsjtb/IQyzIIH
         kIee3Zj4Bht1ic3JZPk0Ko+lM89wFThroABw9PtgKMUH6Fzl4GZWfBgcXGe2vqsmITzI
         sUIor7QEuk0eQCiOAWF22WWrIWNqh5s36pQu/aVSF1FCGRpHrO6GZM//3cuk1mLqCEwv
         lZ5g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769174599; x=1769779399; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=an5pupjXgIQPeCf/UmDnIpSea/cRkdaOPzIbp8qXmEc=;
        b=NkoyQRiZO9++ahzHH1OJ5cCT3E2o0WVv3qA2Qem70FoCG8ghW61cHe4bSRBatgsOm5
         A9UVv1hPLOdqS7Om0j7zlcMFFBFxVAx1uBlswhWJlXn3OASJqKNdFhdsiFhkTqg9kX7H
         xjegM32LrT1LO+E+NmFwksOsoU/PioZNNfbxLms6YJ73QwTqql0xy6uHu8v6t5HbKdX1
         i9yLP0dUZ+jNxtpqiNPKX3OTx+CZM48wY44I/D/1o6pVuDZ/7wY+Jlkug/UcX9Oi+mCW
         OqBmRXD2GC/fp3HrUbK+h4svEPIprnXIEdwdawESvoKrh/ycipkVN9urALaU/ZPu6A9e
         gyBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769174599; x=1769779399;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=an5pupjXgIQPeCf/UmDnIpSea/cRkdaOPzIbp8qXmEc=;
        b=sVBph/ST7IJFDRoW/XWTWLElFerSrbV0+afdjv0s/GEe6IGONWFA5aA0JoPWSwL6jM
         XNB70IZO5zVGVWPFjszWG0QBTqne7eZNH5TkztCy1qg0HCGiYo2GLI+U1RASLPunMiJ7
         2Y4NliYO7ollWms/dIcDxThrMl8+TU8ubKaY15RvHOHYVT7+U4IyNhHfsahRNdRu2hoN
         zMdv1NnBOQK/G+CcPwXU5suAuKE2mZJ7bzcp5oOdEzY/B/jWTpc2Sv/S2b3l2oChYopH
         j4qeNjuKrcmjzlpqzLac6QlzbDOo4Tb/13Hj7FlssjGPoeXzVTz2Z7+F7NmqGXxG7d2I
         cz3w==
X-Forwarded-Encrypted: i=1; AJvYcCWLK4C3z6aMaFgId4gYx+U8u6QsWDHOgQAynKKrRDWjePWdSVopgKY/SibB2YKgrfqTfV2bBsucmJHP@vger.kernel.org
X-Gm-Message-State: AOJu0YzT4pama3mzogkt0JZOdSWqaO+ICZ91ZPdYekTABt6EZndza616
	ddzPNK5I1buWSxHmvMvphcfbJi+PFQB/7E5uhA+fWgo2A8W00P6F2mn36fW//rNQF/QzhE5HuQY
	7XVmgwRDfJim5BWg3/7ZHLtQQ4uJrHG8=
X-Gm-Gg: AZuq6aJxnD7Kpy5hWTejq3zSjdq64M54pOzCn62VkqTFM9g/2jcgOWZHxXE0EGSSvko
	RBKZZ+lJ2It2Y5H8tXC/2lMxnuhxTuWufY6VD/sdBtRNuq8CfTn6fC68rCpJVUnAV0q4B+sWdjt
	VuSNA8X1LGHK5drb8J0cj2L+gsdJmv7DmOmMyzf2oXo5/ifFhpcIAXiubEnF1dgGFmWax2jTT3R
	YNy8kSNUfH7Td+jcPknvGgdBFPmDWxPUQRMW8zQ17g1ir8V3YPQ5qHTT6rQ1L1i6swU31Q=
X-Received: by 2002:a05:6102:38cb:b0:5ef:7220:bca6 with SMTP id
 ada2fe7eead31-5f54bcbc2c0mr848495137.33.1769174599222; Fri, 23 Jan 2026
 05:23:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260120142439.1821554-1-cel@kernel.org> <20260123-zwirn-verfassen-c93175b7a1ee@brauner>
In-Reply-To: <20260123-zwirn-verfassen-c93175b7a1ee@brauner>
From: Cedric Blancher <cedric.blancher@gmail.com>
Date: Fri, 23 Jan 2026 14:22:43 +0100
X-Gm-Features: AZwV_QjeaJNq0W-Cpcx_JErnCmrcMqvA53IgZ6NSy4KMyZ7YPDQ4CrxDdLy3saQ
Message-ID: <CALXu0Uc3gkrCmFApP1xswew9AmfotgZXR4uZXr_RetyEtC2pPA@mail.gmail.com>
Subject: Re: [PATCH v6 00/16] Exposing case folding behavior
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 23 Jan 2026 at 13:12, Christian Brauner <brauner@kernel.org> wrote:
>
> > Series based on v6.19-rc5.
>
> We're starting to cut it close even with the announced -rc8.
> So my current preference would be to wait for the 7.1 merge window.

My preference would be to move forward with 6.19 as a target, as there
are requests to have this in some distros using 6.x LTS kernels (Bosch
for example).

Ced
-- 
Cedric Blancher <cedric.blancher@gmail.com>
[https://plus.google.com/u/0/+CedricBlancher/]
Institute Pasteur
