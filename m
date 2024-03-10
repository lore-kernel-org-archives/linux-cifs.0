Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E359A2943C
	for <linux-cifs@vger.kernel.org>; Sun, 10 Mar 2024 13:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710077785; cv=none; b=LyEZRjrLK7WcQ9P2Lm3e1LpOg/2yM0KLW5Dirs5uklycGmcfPlUkOTb5PRSKLhrup2FESySAxxPB+RrXdCaaJ1TUYJtRNwD+owmWwArK3rJzJcgmo1nxu3OObvgM18uQl5uCPh5KCwu6iet1HlMEqh8oZQ0PBzKBT3sSyZgiEHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710077785; c=relaxed/simple;
	bh=4cThLgXmn7Sa3G2UYUrb0o768WzXJXn+UcnrsE6hZ8g=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=GI9E917G+h1CK+P/oFf/pQ3xz+8rZ/N9fvzSAaenvmM+TiNLwkvk5TkYjUCS+0eX1SYG5dJwW+avz3AL1TEBCBYUtvxyvQkUpOwiox17SOcXhCYGO3oGovKE+5gmap3R3pQR1wmpuCN83jl0fgAg6yrVM+KdWHWAH0iWhg2Py8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CWu5nGQc; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CWu5nGQc"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-513298d6859so3202825e87.3
        for <linux-cifs@vger.kernel.org>; Sun, 10 Mar 2024 06:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710077782; x=1710682582; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JQoWdAOWAYhBYvybfi3oz9YuriDqWEUZ10ut7byU3SY=;
        b=CWu5nGQcGZUpWZBv3Yh6OnPRCqnEMo6rv0Q6AGsCThjYpit2pfARSZRFOT/ofEjGG4
         hJA1lAx7Ya6fw/y8qAW2q7buk9g1kWf+Js9q+XMKQSmpEshKcdB6TZiOv7MaxlBiSBKd
         f2BssX5+l5xAzQqY6OkAm1UGk6FuK5k8RIrLa8CqQKtKIAJcD6ARd48c1DrZ6RCKizPY
         jAUwdBZ0q1iY+9eph3OngDiVpEH3cm4Emu0OeAFcPGItXtkAGg3D6Z4RyqU+AdDApB/G
         NGZ4r8QnV6DYp/UGod+QFQ9CbE3d0A5ffP5IwHDfD1ZvgFgHUSr5kgWIunpfbM3gCqxw
         X0Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710077782; x=1710682582;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JQoWdAOWAYhBYvybfi3oz9YuriDqWEUZ10ut7byU3SY=;
        b=HlNBX7yDXF0TvHyOjzHrFv1wQ0ahlM93Bon+KXGNIch0/gXcfV7HTbF8uOPt82xrZV
         DN+LM7iuw672QPoD7odWxQ6aczWW30Y+h8R9myhn/15s3mdazcVwVJWSG6Ri/Y5GWq5E
         odTdXUubDiMGVGpgytQlfvje4upOvLR6RKwCKLMEzpa6Hd6bOLhvNjJPaqCeYertV/3q
         HTJrW7E0BHV1+l5v/oZjjJR6CxCXxNsVxlkncUMGhhtJCtXUsvB3YX7frZM71Ql2/iyW
         N0QEb4jJrpOOuVGXaHoe78YO/O3ozvM+/O19HWaXYZLpvqcCFMjI45t4UjXa64b7/iN5
         Ic3A==
X-Gm-Message-State: AOJu0YwwmpkOpmbuY91EiRLLPKoOrgrlK+iTX9DVEH22RgUh2iCYQoO5
	REYptr+HwOUTHIVeGayh5pmOWYIXIVnngBelWjglRcZ5XqR4lCKPCIMr74FdAyzJMwR3+yCwlQJ
	k3cNGYuhyH/f2WdVWT40xDJegFu3tMnHl3GXkiQ==
X-Google-Smtp-Source: AGHT+IFTSh62/ZNr+EWP55kJ30mLBayYY/tQ013JgSOihlsupGteiMEAQxwvoMuWR6EeO0u68q1BdiLgUNQJMnFz3Ns=
X-Received: by 2002:a05:6512:102a:b0:513:a977:933b with SMTP id
 r10-20020a056512102a00b00513a977933bmr178953lfr.42.1710077781523; Sun, 10 Mar
 2024 06:36:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sun, 10 Mar 2024 08:36:09 -0500
Message-ID: <CAH2r5mv=bBS2EH_g+xFbAdZX==bQX1Y_C7jDTQSSd+mm_DeFxQ@mail.gmail.com>
Subject: progress in automated testing
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

I have updated the buildbot, adding about 20 additional automated
tests for the Azure target (and more for the broader cifs-testing test
group).  We still have to fix the test setup for the git functional
tests (and readd those), but tests  for SMB3.1.1 mounts are much
improved.   To Windows we do still see the hang with test generic/072
but looks good to other servers so far, and not clear yet when that
bug was introduced.

Example run with current for-next branch:

http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/5/builds/36

-- 
Thanks,

Steve
