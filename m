Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B043020299B
	for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 11:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763465012; cv=none; b=gVdDuAKgOFzCmt8cLeb5e1PlCmed/Z7MoulUSwFANY3xsDsORJMH+T3C7GeGEdLJ7PqKLLM7owkUqerJsuOjoKF/70TphAVfQlUoutT1DOaXPHA6nzb62iWhEAcTJxOG6WPQILNGWI4gB4L9zccbd5sQJuI/J0urs8A/eppnCb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763465012; c=relaxed/simple;
	bh=jRxq3ewCSJc+jxAhUG4ibJ4ufu+h4co9k72tV0osL+8=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=mW7Am5mfTbwqYipKBU1Qo/j53Eu016I+eh7boW6S5ugGsGgkkokhIsgkYSjGsBZ1FVitCiwOODcf40Ybc7ZEMvDZcM5sp15/1HRSzMC2h/Ym7PsZXUaJbE58XTzHl5pY+vEsjj0OA5fGAdMbjsSI4IrYW/H7UM8+r7MiNuWo9NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y+E44rwK; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y+E44rwK"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-297d4a56f97so59434385ad.1
        for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 03:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763465010; x=1764069810; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WovrDOD/v+hm0oJf+TFW/PTjUsqQxA+rdneFLIgQGzE=;
        b=Y+E44rwKz0An2+QpmvwWvvjosIF/+PRuIXSPawEme7b17+cYs2hLds2ksL4Jc42Xni
         h0OIg+ofEwAWWypG1GXmAXsnLshtVoysxt3Xbbpt9vSi2Ar64vyiXFvE27cw8FHk5xzJ
         nhUdGckZYJ8EfkXOhnnvFuCEjISs2jGoGptZicxVAoieL8yltrsbJSmCy0km7L0tTheE
         nW2n6UJQz/9h72TRisxbdq8uBMwVOqiUhxxOh16RyGrgD0zRBg9TgYIJS9fmQIzG/S5W
         /w6wwrvoNzr+JPV0jiC5QcmvdCRfiNBmGTeHy40JZck/bvv7qecd17aZjya8CoUoPK3b
         Fg8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763465010; x=1764069810;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WovrDOD/v+hm0oJf+TFW/PTjUsqQxA+rdneFLIgQGzE=;
        b=Zl3lww55hD5gFrL/msRuczMBqvgvgq85UEzqU4To46S8/IybYXP222CQaeXubVyFKC
         xd5jiAKJM3ZXoXHzUn39eYU7h2ZGlZ8YtPJ/VKOulEEA/olMGC8LEVvcvHZjXRXRva3Q
         lAKwnC1+UPQimswlaeigiBGP6Wt/awAGVJMUfdYtAD1D8ylT86FqytpqlnCFzACkO9iq
         nKEuEwThdr/KKyytYYw/7irmmmYUY6JMJ3Ip5AM7gmdFGc+aQkrKDMyTfmf9gOe66KXB
         5C0lGt4m8+u7YhZKYf2YQK7i+YvhqGwI8QT0Jyb2W/eA1ciqjwwIzd18jQ14amLZSjul
         wztQ==
X-Gm-Message-State: AOJu0YzAFb+P2sUIfek3nXDDml1z1Q5zVfixQqc9poSBNmNv4fein1ry
	MbhzK9zl+OzG1PWcIcaG/pGWeJjFdWt6GRE5A70Fg9sgLAKgOTQCitK9
X-Gm-Gg: ASbGnctZvAboyBG4aQNsAUNi/nA6L7L8mk5QSUwzuj6zcUJ3y80HnDauiUjLUB7yFHS
	y7cGQMpOI0l8ZBZXRt+6TmGNnOzrbBoeMxF9ut3XU/OV42kWDrC/0jLF4XkQWgto7qRO3rU5f9n
	5vNHcgg5DxlV/lbvEw9YfUjthMb/tmyVs2E5MMOz2+LWINw7NPlurKI35d2bzO9w5LJ69Q18iw/
	UqLGaCrbQx+aRUZhhj9fwk+sqglUp941RSQcpgwd8XZ6NoI9AywCyTVS7eTZy4UVQvC2dFrkQdr
	uVHBIq25vcByQuYA+5UFxYhKZhFd2uAjDR6GeF+i+yUtAI32A9O9INgYp82swNt6YU2VGA/OLFc
	pW6Zkv0BP41e3/GPF/mnwHDxGMsQWKR1kCcyM4BzB+tq652l4xh1/Ag7GqE77GQLL4Fmzycjz6Z
	O2LViG/rSty9sd5G16YfcFryQOfbkaAGRCU2KcFe//iSRWTOFQSjyZTSY=
X-Google-Smtp-Source: AGHT+IFJgF6/yZx2++MVekhAyAbtGKs0OVIuCERy7L50xiNNEXZ+X3spfJOI+YZiBtB+TWbnBofhMQ==
X-Received: by 2002:a17:903:2948:b0:295:9db1:ff41 with SMTP id d9443c01a7336-2986a6be5b3mr131180765ad.21.1763465009910;
        Tue, 18 Nov 2025 03:23:29 -0800 (PST)
Received: from ?IPV6:2405:201:31:d869:12a7:9863:8e31:b180? ([2405:201:31:d869:12a7:9863:8e31:b180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2b1055sm172014445ad.59.2025.11.18.03.23.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Nov 2025 03:23:29 -0800 (PST)
Message-ID: <8831475d-0eeb-4107-ad87-c9c8736c219c@gmail.com>
Date: Tue, 18 Nov 2025 16:53:26 +0530
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: syzbot+87be6809ed9bf6d718e3@syzkaller.appspotmail.com
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <69155df4.a70a0220.3124cb.0016.GAE@google.com>
Subject: Re: [syzbot] [cifs?] memory leak in smb3_fs_context_fullpath
Content-Language: en-US
From: shaurya <ssranevjti@gmail.com>
In-Reply-To: <69155df4.a70a0220.3124cb.0016.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

#syz test:
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 0f894d09157b..975f1fa153fd 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1834,6 +1834,12 @@ static int smb3_fs_context_parse_param(struct 
fs_context *fc,
      ctx->password = NULL;
      kfree_sensitive(ctx->password2);
      ctx->password2 = NULL;
+    kfree(ctx->source);
+    ctx->source = NULL;
+    if (fc) {
+        kfree(fc->source);
+        fc->source = NULL;
+    }
      return -EINVAL;
  }

-- 
2.34.1

