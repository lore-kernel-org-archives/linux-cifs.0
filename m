Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BB01877
	for <linux-cifs@vger.kernel.org>; Sun, 28 Jul 2024 03:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722136624; cv=none; b=fopVSw+CRiC/o2mjxXjfbUJQL5pHKS05pnTjUHBPhC0UvmqGCPc5lsnMU0Pgs9yXInNz5WdiXyvOoN8XpfzAXXeFavV7ccnxS5Tps+oFZ2Ws6+Lf68QwE768a8c3MrFDx/lUAD4bNlJQgp8IbRMXsH5lemB72kIVSGsTbLQcPwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722136624; c=relaxed/simple;
	bh=qEo/9Or08UvAowho9Zrgf+1Yho0yllWXoK4yuUDNzfc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NM/X5FZONUkpC0mhplRlRTrpf9e16LR93SzAM1m4S9k4T0xm9rBCQDzEC+tLHB7a2vBR1b7fAy9zV+xq46nZwLt5gvsoPMwJIdRdJ4o7Nqy0//UZ4TaLE6ph9n26BXbhdjRtdlMMGc/JXUUvZ2woemQKwspCtS6cW5j/UxDv2n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LUjuwFRV; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LUjuwFRV"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2ef1c12ae23so29063181fa.0
        for <linux-cifs@vger.kernel.org>; Sat, 27 Jul 2024 20:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1722136621; x=1722741421; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KLxdjUr3nZZ/xXHM7u/PpsffYwjEQJpfVQzmD3d51LU=;
        b=LUjuwFRVifsR1qSoDn38whwavZjhO3yukhWgqH6Jn5/X+XhZ8USP5xDP4jzeaJQx9J
         QQdnc92errqf9EakbGO89Zvw4tC/xh24YHlNY2DGk0nGMLXWifKsDILjO7XU1/JiOnpj
         VA4hckaKx97Tx2WZPlDIC8y6USNLEPgAsnH2g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722136621; x=1722741421;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KLxdjUr3nZZ/xXHM7u/PpsffYwjEQJpfVQzmD3d51LU=;
        b=dWqAeVS2vy+KtEhsZIm/DY6X7kV0/w1Cxw1Ixq7KWn4cO/wFWH1ogMLMj24PSE89Lf
         bQDZVzhrZxmcvFFBBVzWpl48jDnml7bJp7O0mGszcGwbWruxuv4+dTCBuaHXnmvloOvc
         cP1Xje7dPGRAXW9xCBIW+qCbZLmJ5vOfea2L7IYIfzVC3hDy5sMd0wjS9+3Ja39d2Ems
         MhgCtBxA8SfWEqdXmuQpU7gwzQ3ab5p03YqXlpqdYG+cmKO1pqkU/f0d8A3aZ7qh9XDv
         hHEHcFoQzxHRoXhhx4pNYSCzgMaTIV0O4dVBJEmF3udogvyJ2rhnr4rE4CywppLhZcqu
         tUoA==
X-Gm-Message-State: AOJu0Yy/v+iCejwxTvGZxFsQqlRzVw4og/ZGINGTyyvE2xb5GhDo1Zvd
	Rk+z6vPoxSBHennco5It9g/o2qcMiCO+8mTzIHDRiss1vOirfyDel4dzN4SXwNYY9WpuFjkLCD3
	oAbRJaA==
X-Google-Smtp-Source: AGHT+IEF8vBnuIvzNZ6LMAL8bPdjxlWb/4H3z2MohpQi/d5Jy98S+02Iu4EwTfASZmV83szy98MbWQ==
X-Received: by 2002:a2e:9d49:0:b0:2ef:7fef:3b27 with SMTP id 38308e7fff4ca-2f12ee5abb5mr21791991fa.35.1722136620906;
        Sat, 27 Jul 2024 20:17:00 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2f03d07583csm8498871fa.113.2024.07.27.20.17.00
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Jul 2024 20:17:00 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2ef2ed59200so29810991fa.3
        for <linux-cifs@vger.kernel.org>; Sat, 27 Jul 2024 20:17:00 -0700 (PDT)
X-Received: by 2002:a2e:9bcf:0:b0:2ef:1d79:cae7 with SMTP id
 38308e7fff4ca-2f12ee14eb5mr26336921fa.14.1722136619815; Sat, 27 Jul 2024
 20:16:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5msuLY9XywuKvnggezTdjCBQx8HDfYhHNstS-Yijz15sdg@mail.gmail.com>
In-Reply-To: <CAH2r5msuLY9XywuKvnggezTdjCBQx8HDfYhHNstS-Yijz15sdg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 27 Jul 2024 20:16:43 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgS+TLGrPpcL4fy+NRRyuXbd-mJed50sXoqsPR0w75Oig@mail.gmail.com>
Message-ID: <CAHk-=wgS+TLGrPpcL4fy+NRRyuXbd-mJed50sXoqsPR0w75Oig@mail.gmail.com>
Subject: Re: [GIT PULL] SMB3 client fixes
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 27 Jul 2024 at 17:35, Steve French <smfrench@gmail.com> wrote:
>
> Please pull the following changes since commit
> 33c9de2960d347c06d016c2c07ac4aa855cd75f0:

Hmm. I  got this twice.

After looking closely at the _almost_ identical emails, I assume the
re-send was because the first one was html and was rejected by the
lists?

But in case there was something else going on, and the second email
was supposed to be another pull request (perhaps for the server
side?), please holler.

             Linus
