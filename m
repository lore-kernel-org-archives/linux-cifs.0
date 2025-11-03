Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FBC2F692D
	for <linux-cifs@vger.kernel.org>; Mon,  3 Nov 2025 23:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762211089; cv=none; b=iZ0BwFAF0wr25Bkk4p5re8JsvuNB6eAqG4hDON6ExPtAn7e/3U1fWUHaHSNKXWXUj2U2q6T3UiPYaYOrHm+hIUz8qSUgEyCv5gRnYSlwy44m+1Plrdk2rX/LIv8N37JdCTaJVpvmtfRMVjdqexlkXVPeTxj6sBinjQyFp28llg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762211089; c=relaxed/simple;
	bh=qFJb3QTz/3jg/L6x2lbG2psgJfjIQh5q1KW1+nPPaBI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fa9wM56mq1ttSLtx14XBEjd2tQGiBxUWUKu/xvIv+rp9Jnzb5PQVKuq6pl1Eel1ypWcQBnCzYZnWu5ThcKAr43YVfipvPVa4wVj4uhSI0nBGMqVzsPW0qETPOcfHgfjwJTM9Z310VZrXPONfd1x2VKRpmOEqgpTFfe3IpKLuTtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YM/vBNLf; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YM/vBNLf"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b4aed12cea3so892271266b.1
        for <linux-cifs@vger.kernel.org>; Mon, 03 Nov 2025 15:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1762211086; x=1762815886; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZH0fDpUKrbZ7Y4RH7y1khfYrGo0F4yDKdY+imctMyp4=;
        b=YM/vBNLfGZhALocJlfoM6aqdmbn5u8aYcjTXacwZOFqpL3l5z8OuzQs6K2rZ842TQq
         JDUFj37ukjeLXKuhviMAaY+wo1sBiAhilUnarZzwRPT0jgmXXWP8ZMmsSwdqGyzz6RnZ
         yxZ7p0axNYKHN/OuxGRYqE0I0tFcS69gd7FaM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762211086; x=1762815886;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZH0fDpUKrbZ7Y4RH7y1khfYrGo0F4yDKdY+imctMyp4=;
        b=uKiHbsGl4h9CYhnJ8HBMVl0fLc0/CXVJDPMJI+0yKBvsuuX13IAY7q/41qU0P1Qj4W
         JqiLcwS8aaLK0NqjntqkxmFS1qg6fwlcGtMKlqfGBgV4C1OSVDBhccD3SpjthfjJ6w6w
         olje7PpZ4uOxihqpbRt/iKwPF5tfo//kIbjYuQ5QeG8sVQJfa/1nOekiLzNF3Vqc4b9v
         KHzlNrozPIHOML7wk/UY+xpMDYEUiNfrslLif9FyJ+QA86hjjv8pGTkjIWUn8g0SKUUl
         iakQgGrGWw9aZaoSvm86OUZhydA996ySr45zJ/est6sRirFASpPP7l/eovMswROjidjI
         IZow==
X-Forwarded-Encrypted: i=1; AJvYcCXxYYkoLbufonfvOmmurtM6Pw9qcvePMD/ZBD6mW9J/ULRfyMyKPOUI1W/VjErNd/AEliO0ZHpbyDfG@vger.kernel.org
X-Gm-Message-State: AOJu0YzGKWHKCLi3HU4kOWK8ndsM/Rw2N1RBQlGrmEgqqpgTCU4bP198
	XZ6hK0m8kql2RhA/gK5qWg/nRXECE6BhzbN2LRcEkJy87VCQrHYwgKy0vAxyGxJNm2oJVuaQbpS
	kcnYrWMGAzQ==
X-Gm-Gg: ASbGncuGp0dTXmlUDgYR7Wyz4x+sfOTMb1CE/pOwrlXgB/GFO8iT+VVzmL765zfh5Bf
	K6Tf1Q2LSV9aGvxyZElpSN9YTKLn537Oc/VOQLsOtHjDSsHlQ+HPcHBHULymt0KP618sW/L67c+
	P1xvo5y8nG3Q5nMY+r26xEImWhhi/TnU6XWmXiqGfKOL2oq4mZbaaVuUs9NMRHysSFwZRtdzLWU
	+hYOt5jvbke4n0IQZD9D7T7SB0t1Sd1llzLbK42PzDdpt6JRWiPM9OrbO3MV6hirMBMf+AozwWZ
	CGwzOOLX4/7NK/fR/TIAsWfUG1fXk7HInl/k2ZN50wsqH1kv8U6QCOGGTF21MN4PFBmvtueKIuz
	85y0IKpMc1NYb3QlIinO2DyChRzkjXYPJBTPSmkiG3TTdQovppwayxIXPG0azqK4xhNauFzd4Fj
	BicRIUhfdAYHZM+pL+3BIC9BjJCS+C+L5T8XaQ5OOZDQ/GfWPujg==
X-Google-Smtp-Source: AGHT+IG3rCc2yHcs7YhEpTGwR9c6kebUFlsQmPain0HrG5EuU3P/YPmrFAsSnGe6z/A6QSk2RXnuWg==
X-Received: by 2002:a17:907:97d0:b0:b63:9bef:8d94 with SMTP id a640c23a62f3a-b70704bc2ccmr1410229866b.38.1762211085841;
        Mon, 03 Nov 2025 15:04:45 -0800 (PST)
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com. [209.85.218.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b723db0f1besm32527266b.31.2025.11.03.15.04.44
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Nov 2025 15:04:44 -0800 (PST)
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b70fb7b531cso232815866b.2
        for <linux-cifs@vger.kernel.org>; Mon, 03 Nov 2025 15:04:44 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXQY9EuOY2co5eT76QkMESFT1tgWGLYhJqioG/VM9iw87ItkVYgd9bB3GdUY1BKWs36plEFje0EcStR@vger.kernel.org
X-Received: by 2002:a17:907:1c28:b0:b71:854:4e49 with SMTP id
 a640c23a62f3a-b710854688emr499540366b.56.1762211084280; Mon, 03 Nov 2025
 15:04:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251103-work-creds-guards-simple-v1-0-a3e156839e7f@kernel.org> <20251103-work-creds-guards-simple-v1-14-a3e156839e7f@kernel.org>
In-Reply-To: <20251103-work-creds-guards-simple-v1-14-a3e156839e7f@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 4 Nov 2025 08:04:28 +0900
X-Gmail-Original-Message-ID: <CAHk-=wiSmez2LFEpM05VUX=_GKJC8Ag68TJDByVPO=x4QwjyuA@mail.gmail.com>
X-Gm-Features: AWmQ_bmQaBgs1Hs2Yx75LVx_L0plRwfdpBhmjm5wyWf-G7aoJOGX7gmwXWEf8f8
Message-ID: <CAHk-=wiSmez2LFEpM05VUX=_GKJC8Ag68TJDByVPO=x4QwjyuA@mail.gmail.com>
Subject: Re: [PATCH 14/16] act: use credential guards in acct_write_process()
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-aio@kvack.org, linux-unionfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	cgroups@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 3 Nov 2025 at 20:27, Christian Brauner <brauner@kernel.org> wrote:
>
>         /* Perform file operations on behalf of whoever enabled accounting */
> -       cred = override_creds(file->f_cred);
> -
> +       with_creds(file->f_cred);

I'd almost prefer if we *only* did "scoped_with_creds()" and didn't
have this version at all.

Most of the cases want that anyway, and the couple of plain
"with_creds()" cases look like they would only be cleaned up by making
the cred scoping more explicit.

What do you think?

Anyway, I approve of the whole series, obviously, I just suspect we
could narrow down the new interface a bit more.

                Linus
