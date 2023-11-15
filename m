Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q6s3c9jb"
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D069F92
	for <linux-cifs@vger.kernel.org>; Wed, 15 Nov 2023 12:03:35 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id 3f1490d57ef6-d9ca471cf3aso7322843276.2
        for <linux-cifs@vger.kernel.org>; Wed, 15 Nov 2023 12:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700078614; x=1700683414; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:content-language:to
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8sASxTprz7iqMnqUhV2io7qqAJmSIwJfp20Hyqkb8VU=;
        b=Q6s3c9jbNDIAJiNnH/Ctj/OtRnnYlhQGzXJ14l2fG3uWrhU5WTlF0HIB1tRwGJb3OG
         aihLx+/L6YeSp69x5RKqtjqSPPOiIjJ+ez2Jf3YHVFdZoyNRdslJI7r4XuVGQHBEb/y8
         b/AciAESObvXWiy4+T+BB+s/bhBgXCk0u0/1zGYc5FGa42B8aYyGHcpN6lpsqShWCpkw
         nfaJa3Auz18u6kZ3gp5E1T0NBQYA3S+ATpcbT2RuuAWm+Sec4oM/t33nblSJsVmdnhS2
         0JkHGnWiXM29UbGoNfHSNwj3Ufqg9a9FECxQM8T+mXWC4W2kKCpt9MJlZn/sqf4i/30C
         ZCrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700078614; x=1700683414;
        h=content-transfer-encoding:subject:from:content-language:to
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8sASxTprz7iqMnqUhV2io7qqAJmSIwJfp20Hyqkb8VU=;
        b=MpPGzG36Bbm2A/g0zzPSUdZWdwcHPnd3i/9HF3jJdifvizlARk7ZQMhiRSghw6o9uC
         SLQsGyxol3fmZpH6AUcJuAz8/9nX2YW54BSVbCPSV8ycqPMHVZqGcns8OigIjVjsNnwZ
         0q3apqUYGL5d9CSafvQm402/zdOPCZErF0tzJsyYY4hoFrfXw5b52Sb7ERkGH0Ydp5L+
         QnDsJ1dwwIcsHiZ8S5ZBr4vB1KkGAViXTspSvbhWGepuRov7R0XLE6S0g46JnH0A3NUI
         wEBN+4n7yfcFvmUOQl/sW8eoCq4Ge77NHsNg/GX+Nksa4O0Kn/6vk6coy75R4zBydBlA
         FPKA==
X-Gm-Message-State: AOJu0YxFAonCy7p0YAV/SnKdvKWdviBNqNn1ndi0hz1Horc347jZBKYI
	Gj19+TjJYUkrOK/go15Dxc/T4vNknH9uiw==
X-Google-Smtp-Source: AGHT+IHsuRuWKal+hhMzXRsvbc4blhWji+a6+HUrbAc4qXicJ0LpWjr9jcTuyL9Ld95GltRb1nn0EQ==
X-Received: by 2002:a25:4d87:0:b0:d9a:4870:7943 with SMTP id a129-20020a254d87000000b00d9a48707943mr11874265ybb.28.1700078614185;
        Wed, 15 Nov 2023 12:03:34 -0800 (PST)
Received: from [10.0.0.28] ([194.36.111.30])
        by smtp.gmail.com with ESMTPSA id e2-20020a056902034200b00d8674371317sm477885ybs.36.2023.11.15.12.03.33
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Nov 2023 12:03:33 -0800 (PST)
Message-ID: <c913d8d2-3f86-4756-9058-4704dddcfd95@gmail.com>
Date: Wed, 15 Nov 2023 15:03:32 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-cifs@vger.kernel.org
Content-Language: en-US
From: Larry Marek <larrym404@gmail.com>
Subject: subscribe
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

auth c3709a96 subscribe linux-cifs \
         larrym404@gmail.com

