Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AFD387370
	for <linux-cifs@vger.kernel.org>; Tue, 10 Feb 2026 16:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770740675; cv=pass; b=niyMUW1/59SmkvbI+14tqDU3CEB8RK4+AcS4QmEbwkIO4maWgdwnPIvU4tc/aPAIdMSErL1ELeFWfDM3siYPq+AiJQsg50iKV5WXBXzeQnAdh5DVvFbuAtZI5x3UH0OC1N5JvE70Bs2FBWp8+4mTAIC1Gjj6BNN2/kHw/PmjX9Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770740675; c=relaxed/simple;
	bh=BkWtyYpqejlmByRC727LdbfV/RYqAERDreFY/UP2Aa4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FiOSAxCpqrkF0So9EGLnrz848rxo0cfWT0UKvSmCZnC+x01h9HLH6iWjOZ8UsbRueGp6NGDrxTflHyMD/ozqlukrd4MUiS1lufd4L+SvDHBMfXXWzghhkKiyHm3ULaFLikkcAzhxKsx7/WnRajirePpQQdLsRu/rZscQ+5LJxWw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jXoHp7nY; arc=pass smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jXoHp7nY"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-45f0c1f1b54so3483926b6e.1
        for <linux-cifs@vger.kernel.org>; Tue, 10 Feb 2026 08:24:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770740674; cv=none;
        d=google.com; s=arc-20240605;
        b=E2gib4y27BaCmbuxy8vvmhU9iUVDDQcDfZdKvy4aONgKy6wNZcHKXXK8t9ViFlWYjb
         ypts2uEKkTVCmJlHgXNjcYzJ+5mO3Bt9OAd/E2O7UNDPtFDPmSVj0rvPOOeV/oNLqum1
         kRhXJjg7pFiidpwHKGIr19WhbE5swO+T6eYnQoNBvmRdreMOpC8MVpqGGJAVcULEdcAa
         Qtc1A38wUEJX+p8cjazx+v6zPQmUFVVNwpNR49Nks1+1yda5E790jxsmpdAvtyEcicIG
         EI3B0mG434+vVX7aPpRr5Eo2SCFa3MOd8urhxE7qWHhkHdIV37vKx3BTRdH+QmUAc8wT
         KzzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=e87k8iFish9q2Uq3v9Uy7Fjw166hMufB5O7qErb387U=;
        fh=mETyyNx601eptDds1AqIJUB3j27aq18ByceMhJ39OTw=;
        b=IPtRdNoNyX5v0iHHfmAZPK7TCJNP8uZffGG/t4oClYoECbCr14B8TVr10XZvoePz6/
         9Ys3+zLQWDch4+yTiDl5aJ5+HyLIKqhLeRqTwljRwLUThjeIaqegjY174R4xorgXpMXx
         JPPed9FY/OPsUJf3ShT5Y5HeRq15gaAPaUS5IVRXHwNhEKPEBrKN394x0Abe7V4cG67e
         a+d+UOvObWAny15uAFjDvghbK4QzZrUQ0vWye9flLzL2S8qplqYvSX2ERKFNgXqH6pXg
         1hEZY4E/zkwehiOAXSd57YLXaBhmUjaUtM4eUtOROoS2lFJmEbhVqGVZf+zeaeMfc1/N
         u1RA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770740674; x=1771345474; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=e87k8iFish9q2Uq3v9Uy7Fjw166hMufB5O7qErb387U=;
        b=jXoHp7nY23Kq85huTPiHL1JsEK6nChfn2n6ItO9mJhQQLQMLKOQUwAVBSk5naFxJhY
         R/CAa71VMkrHO+oF8K/OeGmgfjlswwdenQw7JEPsknyqg9LfdHHw0qjAjeMFHb7LmAQ0
         sJGdIejhGm1kpLSexdcYBGDFglcXyj/uHKnuemJHLlww8nLSGLHYaDtZaLpyytNS4u7q
         5lZFsffLsIby593IrGgzTQKuGXwsc2GUrRsA2zUNcdHq2LR4zmXIHCTuBkFVCbD5V0Zm
         maODHoWpBu+PpgywObJIsMVDxwDufhdioUxtB/jrMD9+mMy1p548uzR+djRpr1ECBXDU
         x+Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770740674; x=1771345474;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e87k8iFish9q2Uq3v9Uy7Fjw166hMufB5O7qErb387U=;
        b=XujX3hZkdfy8eFLva6nva4i1H5DC36z0KRf4KlvfwjVYxqPjmcrCYsUeUTnD2YNIMs
         dEuAsJsfPQVs20AP5u7uBAF6+NjeY4pOUtH9YUdDjxjV/lTPMMTBru2grB2ohK7LgOXs
         FZUNgg/l9V5qAa6FS4OhMBDWGfNU3T83Ej0zZ46lamDofl7vqdJ5UmAlHwTXcQbh2707
         9GUAknPtww/v9Lwj/UPd1rNarv4HDG5ptWAVLivvZlfBivNTTIcHT0I4E8I/dWdseKOg
         vPzXIR4G2MqtLUser2NTaLw4gUWZU4ik6l5kIXiLSnWAtpOojDNe2Rf67c2TqREC5d7i
         Da+A==
X-Forwarded-Encrypted: i=1; AJvYcCXA68+KZBIzFzBOcdk0PAbh09fFX/CeNKFyCPlSAZwN0VjdNDKeLhTZClJGcvRcSBHGnjdo+1HufNfx@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/jnikrHX07snHKd+6ohCL0FL7fddzBjMu2kb19bXLuhcE0dRX
	saMt92b27XQupr2xEPt/3pOVi86P+Hozh/+5qCwYO7gm/qEaD1PgAw3QoQLPrO5yw/pzxzZV0zq
	9Ww2YuzgqWdRR6bZc2Lg5iL3gGqhbfzA=
X-Gm-Gg: AZuq6aLFCvc0tfGrl+tuX/IjASdtS+mYvKwNwBhJ+gIvML3HsqerBtUWsuHhqN2WfS8
	3d+hPtWbGj5u+AVNKCp7P+XiPRZHl2v/ExwD4VGJiKeZgQSVtoPvLMIHbwDJwlb+ZA7BTc81zuk
	kD65C9RgiqBWLfxSLOOfzk2z6v2FNSNZA8Cww8WJc/Y7WAe3TSSs6ZS60ImXjNbzLsmPrqDs9bR
	Sq2pLg/AWlMpIrtCbLJppUf4yyEReHa6orHCU76cojTQmoKerfV8/ppnxzRsDOabT5aSkrDYb9S
	Xy5TV0A=
X-Received: by 2002:a05:6808:4f23:b0:45f:42d6:2ffb with SMTP id
 5614622812f47-462fd051fdamr6992569b6e.41.1770740673692; Tue, 10 Feb 2026
 08:24:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260120142439.1821554-1-cel@kernel.org> <20260123-zwirn-verfassen-c93175b7a1ee@brauner>
 <41b1274b-0720-451d-80db-210697cdb6ac@app.fastmail.com> <20260124-gezollt-vorbild-4f65079ab1f1@brauner>
 <a1692040-58d0-412d-b0fc-c7b7a62585c4@app.fastmail.com>
In-Reply-To: <a1692040-58d0-412d-b0fc-c7b7a62585c4@app.fastmail.com>
From: Cedric Blancher <cedric.blancher@gmail.com>
Date: Tue, 10 Feb 2026 17:23:57 +0100
X-Gm-Features: AZwV_Qjy3M0uZY-NRx3otdHnq6x-9RSVjw1ETeNOu6B1p4FZNE0JCUf2MFslsk8
Message-ID: <CALXu0UcJf+R3HuzwUrUTjsuYWdFrLZOwAsEtSyto2T9Rtg4rsw@mail.gmail.com>
Subject: Re: [PATCH v6 00/16] Exposing case folding behavior
To: linux-nfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"

On Sun, 25 Jan 2026 at 23:05, Chuck Lever <cel@kernel.org> wrote:
>
>
>
> On Sat, Jan 24, 2026, at 7:52 AM, Christian Brauner wrote:
> > On Fri, Jan 23, 2026 at 10:39:55AM -0500, Chuck Lever wrote:
> >>
> >>
> >> On Fri, Jan 23, 2026, at 7:12 AM, Christian Brauner wrote:
> >> >> Series based on v6.19-rc5.
> >> >
> >> > We're starting to cut it close even with the announced -rc8.
> >> > So my current preference would be to wait for the 7.1 merge window.
> >>
> >> Hi Christian -
> >>
> >> Do you have a preference about continuing to post this series
> >> during the merge window? I ask because netdev generally likes
> >> a quiet period during the merge window.
> >
> > It's usually most helpful if people resend after -rc1 is out because
> > then I can just pull it without having to worry about merge conflicts.
> > But fwiw, I have you series in vfs-7.1.casefolding already. Let me push
> > it out so you can see it.
>
> There will be at least one more revision of this series (and it can
> happen in a few weeks) to split 1/16 as Darrick requested, and
> address the nit that Jan noted.

Are you targeting LInux 7.0 or Linux 7.1?

Ced
-- 
Cedric Blancher <cedric.blancher@gmail.com>
[https://plus.google.com/u/0/+CedricBlancher/]
Institute Pasteur
