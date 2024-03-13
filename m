Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CE23D386
	for <linux-cifs@vger.kernel.org>; Wed, 13 Mar 2024 10:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710326737; cv=none; b=WR5ONnmsVmOpJuNK2JoYcKZpR8VQEqcDyEPJe2S0mC3aYFsoU/RdE7qnov9W/K+e2hlmZI5eT/WoYaxhji43e15sHXiKl4iJ2N0WfyG3lYRvjjNOicD3jTENHdUBps+6cwNvZNOAi/v1YotKNLCwSl4akLel6hdicT+STwSBcsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710326737; c=relaxed/simple;
	bh=8HBh+WXEdt1wIlSF5vgTLeDOy2vNRKWif75mR2BLQqo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hjBhjffDmWFG8ZQ4DUqm/QJ8htGWRjwTy4fuDjxmetvH6VAi5ldA9PLLtsRwOg8+aRK+bzVpBIwlis7wiC4zSouaH56pJ0o5rbHIthggYAQteBs3nNvPlZRW4QJD2Uw1bcQl/+g6LArny8QEaSxDdkjp1nv2OG77DZj7bgNh7v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P/+e/wM3; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P/+e/wM3"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-512f54fc2dbso821988e87.1
        for <linux-cifs@vger.kernel.org>; Wed, 13 Mar 2024 03:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710326734; x=1710931534; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8HBh+WXEdt1wIlSF5vgTLeDOy2vNRKWif75mR2BLQqo=;
        b=P/+e/wM34KDmzvu1Wn4f9cC7yHxPvIA1t8NE6Bk1fCNS8c2fXNVCIcFOtQBwpaw6p8
         nawa+KrGZj9VYyYwmLKQuhE3m8N/kn/AKhtzbIiay7VRtQJ41UMKUzWV8ISfzzYaqFRw
         0cVbEBc/BXtZg8tc+Xm410jMe0H2c4sSEPvm41AJhe30C8SOx1EotcNn2UBqPB/9+zKJ
         NN+Auc4tE5oVJuPvtOPLWvhymQlfBPeG0Ouk5W3wzvKg0LYGY0QDWoFdt+DXv3TT8ap3
         9M8psK/yQB1kta0+H4DOqbt4CH79Y8ouRubh5lrVA2osWszqcv7uVdDiBL9yPokimS2Z
         2Ecg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710326734; x=1710931534;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8HBh+WXEdt1wIlSF5vgTLeDOy2vNRKWif75mR2BLQqo=;
        b=Yl8Apmh5LWXx/HHZlDGT2YxozV6rJwxYaMRw2s/ujI8gZDx8g2WlFNYc6Su5AODNtZ
         8ikM6FN27/VCl8TTi4TjX7czGfdskqxyLFf+kA3J/m/C89BdA3QwuPwVAb4qSm0SEDM9
         I/w43equnlV+cmOnl+LAjV4cxdn9Q4dC8r66dtFBrX00HH1/M93oIggyPlB/LNEPC6+1
         Ak9JQPU49fIlKfrE9Uf2s/kjJ7tWgqAZ2jdAdGB53SfU9hb2DG1GgyGQcrp7mu5csJ5g
         nKaWeucAf5UyRONR1qbX8Aew0dHuNkGTqd1UEwvK3OVB/vWkHssPjZyNvTq8jgXXcvzT
         maGA==
X-Forwarded-Encrypted: i=1; AJvYcCVAVESNAh6NjH9gn3BrwJ/OV0Ks0Ah4O98G8cqdbadB+an2+1siR6HhE3tzY1X+bGZu2K/Ed8hLCXGEemySwAD9lr2/guLDUVSIhg==
X-Gm-Message-State: AOJu0Yw8unqY/uR4H1TOtvtonnh+0yCo0C5b4U4GIJ7EAshiyNmfJCdg
	aQDLrGVsbDJm4IF/n0bTpngw3fiTpZHawsmu9ZnUOl0sB3kUm1BIyBvgB90jbh6+pS9alexs7Nx
	wn8vSepafSEzvtx52TWP3WDvA3AY=
X-Google-Smtp-Source: AGHT+IFeZeuIJt4bSv3fzvXZnurDkK6lqcXZYIgBmM51ztXo3Hoh7qiy+ScjN00rFPFJEt0KV7dj8wM9ahP65AZWuNc=
X-Received: by 2002:a05:6512:282a:b0:513:a1eb:c084 with SMTP id
 cf42-20020a056512282a00b00513a1ebc084mr2089744lfb.7.1710326733287; Wed, 13
 Mar 2024 03:45:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230310153211.10982-1-sprasad@microsoft.com> <20230310153211.10982-8-sprasad@microsoft.com>
 <4b04b2c4-b3ff-48e7-9c24-04b1f124e7fa@sairon.cz> <CANT5p=p4+7uiWFBa6KBsqB1z1xW2fQwYD8gbnZviCA8crFqeQw@mail.gmail.com>
 <2abdfcf3-49e7-42fe-a985-4ce3a3562d73@sairon.cz> <CANT5p=oFg28z7vTgyHBOMvOeMU=-cgQQdiZOw22j4RHO94C3UA@mail.gmail.com>
 <f395be9305cbe75c3171a84e45db42fe@manguebit.com> <3fc78929-2b5e-4961-b5da-6914f2dc45e1@sairon.cz>
 <CANT5p=oX_d-aZMJLhECU47mqsxz+oeaqqZEzjjVv5pq2gxwtVA@mail.gmail.com> <669bc66f-74ce-4753-bbff-bfa497c8905c@sairon.cz>
In-Reply-To: <669bc66f-74ce-4753-bbff-bfa497c8905c@sairon.cz>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Wed, 13 Mar 2024 16:15:21 +0530
Message-ID: <CANT5p=oSYbhVsupD5r0uDU3Miq7gnL15RoB-i2cwBmkap9Hj+w@mail.gmail.com>
Subject: Re: [PATCH 08/11] cifs: distribute channels across interfaces based
 on speed
To: =?UTF-8?B?SmFuIMSMZXJtw6Fr?= <sairon@sairon.cz>
Cc: Paulo Alcantara <pc@manguebit.com>, smfrench@gmail.com, bharathsm.hsk@gmail.com, 
	tom@talpey.com, linux-cifs@vger.kernel.org, 
	Shyam Prasad N <sprasad@microsoft.com>, Stefan Agner <stefan@agner.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 12, 2024 at 7:50=E2=80=AFPM Jan =C4=8Cerm=C3=A1k <sairon@sairon=
.cz> wrote:
>
> On 11. 03. 24 12:14, Shyam Prasad N wrote:
> > Let me submit a patch to check the exact dialect before calling these
> > functions to make sure we only do it for SMB3+.
> >
>
> FWIW, most of the reports (except the first one with macOS) are users
> running their SMB server on QNAP NAS's (more details are in the GH
> ticket I linked earlier).
>
> Please CC me in the e-mail with the patch as well, I can create a build
> with that patch applied to 6.6.y and ask if someone could try if it
> resolves the issue in their environment.
>
> Cheers,
> Jan

Just sent two patches for this.
One patch is just to change the log level for this log from VFS -> FYI.
The other one is for the suggestions made by Paulo.
#1 will fix this anyway. I'm curious to know if #2 alone would fix this pro=
blem.
Also, please ask for the output of the following command while testing this=
 out:
# cat /proc/fs/cifs/DebugData

--=20
Regards,
Shyam
