Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF43331A43
	for <linux-cifs@vger.kernel.org>; Thu, 11 Jun 2026 22:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781215664; cv=pass; b=kdjPaXjPplIbXhEmQ2iI1P7zqbuNeNoJUd7jlmtnjFKO3f3JTKiBIwkSGayQWGjxV25Jz38x2QuQrI0YMmU3NqHJijMjYXOHuQiuoIeYzVKhnaGUfpTFgKheFcG4xkx4m9hPP2yd1IiEF2k3QYfETUdMeFLmQiuvjK+Tfa0ksfE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781215664; c=relaxed/simple;
	bh=ixzXwJkxrQ+aOQSHKo5CN6fP+WRsAZ6bHt8E82prl9w=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=KNFEWH7iDJrkmu5i7wT1XKVA52X7Ci8sBH9H0bxAKgzxTUFj3zBo1mB+rCY38BI73gnXkkaEEk7hTDjThUGM6qszcBPFRirKCNUKPk6A1CGpsxiR6Ex7gFcZ3w8OhVOHOaP7oqexgF6aux5fRL7b/UhOe8WbJRsC1yg8R+HrOAc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VymaA3bp; arc=pass smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VymaA3bp"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8ccea53f35cso4541626d6.1
        for <linux-cifs@vger.kernel.org>; Thu, 11 Jun 2026 15:07:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781215658; cv=none;
        d=google.com; s=arc-20240605;
        b=ewrOXugQe1td9Zz/bOpe+1Ms1unQTIb/O7cz7JO0qm8TaFlMoV7wkdZQB18VbEXEmv
         Gsivjz/XCybGXsxrej44jOy5fTPHw9Q3pZM3vJBpDVBRf4eeRAWlq5o0jkxC1q3NEBDG
         lP1skvZVhCsqLO0+1CbuEHboENdKdRgm0OzYaXaGDkNVfhCFtF+wXO3KSGNCHzXXCnYw
         XaUiGZfuiBfP8G5ZTujtXB2NLoiQdVakYC+eOl0SjhjkGeqHIsoaSXhbyQBqvp1NcvRs
         rzup5lhjQHBGVP80NYe3gHtXr5uc0geRL8oN1dBRlgAtFOGssdBxbRplEP0c0U1nE0nP
         RGxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=b+jc7yia6mRVSL4nlR5dX43HBdKsuumf3DrnhwHEzkk=;
        fh=ALXeND1Ar9VAsjG6VGlB6Pb5meIjYbcUvYnEf5TToqU=;
        b=ZxY8e7uvJjHOhpFzLhVUmr2JlpssYAqHYlXk1LQ4ATwfv2DFM31awohAcAcGGzXsHL
         empeSWm8jPkjePbJ9Lj4/HD7YplgiDbtUqpXLTtiJDdDsSJFwXWs1rc/UjK65opN/xU5
         njbvl66nEET8MoTCriK49lDmA2Xn1HCcMd3NWhjE8qEufPoqVGWWfcY2tREEpmM9QHzB
         aJxVTwcUrEvm9XQHCUjlZC68FeEa0ECqcltEi/vZdTX/RyJcXabeQb598A07ss40Q13z
         pHSrObScRIWhrGa5NNlniPSrV96o87G9SgT4D5GpOSdoHNaWS/zHI5O0nLQ2hSEPhg9m
         zWRg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781215658; x=1781820458; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=b+jc7yia6mRVSL4nlR5dX43HBdKsuumf3DrnhwHEzkk=;
        b=VymaA3bpwvUuikV5RI+JZMO2J6Y3DShAT+5d1BOsh3rzkFwAeSQTpyvS4+Py5F+7Ni
         57ZuzKydFYzuDrJaX05I1+eTQ7Ilu5JwaZE350pGpEpI1ONsNZU0tMMZNyOyRGNKnzwF
         7fezy6ghq4XLjp/Gf/hXJk1sZ/TrwNkVFE3EAZO73S+CbCLxG34Sqti+7GAXmpp+QPUB
         fLVOrgGLhboTVlJ/oxQus8I/dxauJDsGiv0ckaaThS6YsrwRYEp6TQ0N83uC/2eiConq
         mA67Dha736UjRJSJwyqFY2VpFdZNNlbtQxXOr6iWFWgQMCeb9JotBFeQgqniRvRmXZ/r
         KPEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781215658; x=1781820458;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b+jc7yia6mRVSL4nlR5dX43HBdKsuumf3DrnhwHEzkk=;
        b=cQxPkWrY0uYa7oC6ehsvQvpk0f6TkD/eGxluTG4G6ImFJUf6MB86MsJJ//vgwTvxGZ
         F0uIncNPiHGcT7o4JSozgKA/Lokg3o6DBL16NfjwV983kxLuW2TGEch+rRIOU7RJhuLU
         vQ35yGQJvVa3K2IbzId04UnxBjRmVM+Nr2q2eHTfebhu+FVGXYsnK68liTkaJHGsY6Bc
         rnUsR3lRq346Vn4zZs2OFngJSS87yIyqCgbn1oNGm8ci2atfLMRfoG6xhVm9KhYpuDqc
         moc8iXq2iRpYz+nL1CRaE8RSUn4x6KA2QK4a0fgQuumr2hV2hRjwIVJ6/V3u9TogJO27
         US+g==
X-Forwarded-Encrypted: i=1; AFNElJ+pcAsVL3jtnvx+DmCQ9KkwfoEhh9TQoEBHQyWWbiiByBbZWIaAbECLBesP0PRGO0oyJEQ3zdPhIyYR@vger.kernel.org
X-Gm-Message-State: AOJu0YyPOAWLUl02B3fM6kuL18dgFksnOrEcMtq+RHHRKR6oPhsyijhx
	tJKBokZXbWlJRA29Bd96AROXjNXjWyhyZULKL0OdsrrC9E4IYHrRniWLhNBamyau/IXdpPL1Vaa
	rQCzLuDifDJQh76UldfcH5VlXmaUIGWo=
X-Gm-Gg: Acq92OH+IWuKyBjBLvI6u57cY1V8ax9/we8Va+eQpKdt/uXOihapIbJwVWbCUH8yXWm
	VbHaBe3OoV9iCsjVvDhwSEM553j1iAIn82I/E2ZyJaPu3eGT1rnQVAeADxOPCTPd44+qzGNzScO
	Esz3pNiO0gIZOJMMBRX6h0iq2HlM1ND+r+XZrPz603uGlhwyOQA8fdfUXw023pnmSSlXP/Uqbds
	7nAEh6QswhW4eNKvirW4KYBCo+5QiXgJe7cLBet+5kxxZTKfuEBW/bwIZWYTQ4Y5FO0Kfjub22G
	766uj1UEX/H3wmRDcLgVvSdHAW755TK4spikQEq6RHAzhKz+SDQo3ju2KKvOVBeSL4qrgsaOY40
	Z47X4gYlb9Oh3PRXEfUU7wl/tB7pIaY+M4oNVrYjkYjXWCrZYD32834oj01EaQWGsEAg6WDmi8R
	4JJFDezpxQ/vXgOzqKrouxBw==
X-Received: by 2002:ad4:5ce9:0:b0:8ce:a542:361 with SMTP id
 6a1803df08f44-8d32b5758d2mr6351196d6.13.1781215658019; Thu, 11 Jun 2026
 15:07:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 11 Jun 2026 17:07:26 -0500
X-Gm-Features: AVVi8Cd2tu6e4Vi2H6BEmsSwTH5eXWK_xkl44_io_VCVaLU4nO6IgUXujpn6bHU
Message-ID: <CAH2r5mu4GxsASC6kh+JrFDG1AS2OETehHE5fPMr6QGiUC03Q_w@mail.gmail.com>
Subject: Good news about quality improvements and more tests now passing
To: samba-technical <samba-technical@lists.samba.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Yesterday I was able to add 34 more xfstests to our main test group (I
could have added even more but some of those tests are slow so I left
the slow ones out) due to more bugfixes and thus more tests now able
to pass.

http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/5/builds/416

We are up to running 340 fstests in our main test group which is great
news for quality.  I have also added more to the Azure target testing
groups and will be updating some of the other testing groups later.

Thank you for all of the bugfixes!

-- 
Thanks,

Steve
