Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E4t6n75y"
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4560129
	for <linux-cifs@vger.kernel.org>; Sat, 18 Nov 2023 05:24:54 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-5bf58914bacso31950787b3.3
        for <linux-cifs@vger.kernel.org>; Sat, 18 Nov 2023 05:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700313893; x=1700918693; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:content-language:to
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8sASxTprz7iqMnqUhV2io7qqAJmSIwJfp20Hyqkb8VU=;
        b=E4t6n75yDpM3DNmZVam8i+wfqXIk/p28ShxQq2zeqKTzhrEUYdUsNLT36nwcOOGZy/
         75afQCU7HRLB3VQSB88Qj7cjT0opCeIEftkBTonT6KLQ4GUJzPRrG+dsI6SagdvA9K3P
         H2Rn8gyATtj488VuTGW8KEKkX6tg4jzyEdXMqNKL5DcLpGO0YrbqK8W60tOVOdv0jyPR
         NRTFobR4OfQSZy1UAAlMSdGjOz/mbgfO9ZFvZwAmgLQanddQ9zqfcL+sfjEV6/zBdoUI
         sLsYZYHF/vyw7WoAPwMBa6bRcB1XdSLiPUuywnphwmZXcSb3Jz91fyC/bmSf4fUSngsY
         Lt6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700313893; x=1700918693;
        h=content-transfer-encoding:subject:from:content-language:to
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8sASxTprz7iqMnqUhV2io7qqAJmSIwJfp20Hyqkb8VU=;
        b=sk6BboqVLjpuBib5ve9fZW0MiR2QG8IyEJ/YaO1Gf8Ff/KyFLGxZHtPZNanXgKb0x7
         Zf+qKn+j9Kf17a4GvvjzMPh5lswcu8SEItxkFPZqOlQbP6W4TT62cE10L7l2cd68lXBj
         NSRFPomxqCocSebaCgzPSFr9fKDFsemYPBP3HqkQNEahf84d+Q+nJ/dUnBMUA3m1ly4I
         6NlxVr2eLciKcwgxGpto3louQHlKxnSyzCppWRx/ZJuWylNLbxKx04cA3uVPPM5MXg+k
         XVkP/rKH2Je/wYY5zZFxSpTaWNUnx9ESZNSaZqQ9dL8MoKe8dPRxaI6Ngb1Sm5JbkSju
         c2mw==
X-Gm-Message-State: AOJu0YyUDPO4TiGS5Sfov3VuUlhCF/jSzAA1GjJvxFlCqGhaVKt7U1ku
	m0mbIdp1DVwQqr2FCZmK99Z0oNBdgVHuCg==
X-Google-Smtp-Source: AGHT+IFLEvojm0FeCCkunX2jh7pEgIhCbT92bdLxgIETeqFWsNH+5X164rn4zBuDH+SslHbVNBabuw==
X-Received: by 2002:a0d:d553:0:b0:5a7:ba09:52c7 with SMTP id x80-20020a0dd553000000b005a7ba0952c7mr2221101ywd.11.1700313893226;
        Sat, 18 Nov 2023 05:24:53 -0800 (PST)
Received: from [10.0.0.28] ([194.36.111.27])
        by smtp.gmail.com with ESMTPSA id p195-20020a0de6cc000000b0059be6a5fcffsm1111702ywe.44.2023.11.18.05.24.52
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Nov 2023 05:24:52 -0800 (PST)
Message-ID: <767cd9ed-c145-4fd5-8eed-5d0ab8e0866c@gmail.com>
Date: Sat, 18 Nov 2023 08:24:51 -0500
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

