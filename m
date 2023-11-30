Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FgwC5isQ"
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A2190
	for <linux-cifs@vger.kernel.org>; Wed, 29 Nov 2023 18:29:38 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-50bc36725bbso708903e87.2
        for <linux-cifs@vger.kernel.org>; Wed, 29 Nov 2023 18:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701311377; x=1701916177; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=20eNRNxEsdBKCGiU8N0BYUqtEEyn4jxP5YDCANyHCo4=;
        b=FgwC5isQs/rX9cmZP15iFW1dBORIVDPLr6waFZ8zvyd7Z7IkeC7SQ4KQTpoHcZ27xT
         aN9OZMRhnTeUYqDd7Of7GOhUWikomZGslA3jdIHnO0XtST3UocJFbVB0n0vyKugP14+r
         +5y620Q2nuaxizYuGlGn4FoHM2jEBpCo0C5OGkXN8k94+Ya03LYCl0lxcpEKeJPfjpLb
         RxUfc2LABTNEp1lkJvS80r7PZoAirClfzeqP5idVgHCNyRHCka1q96hg+qa+XuZz3fvm
         tfGLOwUgSgn2W2er/Qjp2kHUNBTXP09RF6MjlS0X4H9wvZ5fAvVnK9pikUdfJJ7hWFHy
         2nkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701311377; x=1701916177;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=20eNRNxEsdBKCGiU8N0BYUqtEEyn4jxP5YDCANyHCo4=;
        b=WlQ17t1aQJbpCMA/rSGj5rz+gtZ37+3fbQgbdd7XksQw29f5XTRO01C5oo+WLiIWzx
         BRNfMhLT8pu8w4NLWJvr+KAa91zD9QmPyQuAMLGpoggh7ptl1UrE27HRSDIjQNBjl35n
         PprD0lWJlKFGnPWdXj3r46NmQTUHyrqzSED/rtuHUVpw6JcSOSwgmht5YtvKsHVyce2m
         gm3NnTlDHJhW6ktyxI8G96g4qeX4S4EN/HQh5CWUrlO6bbtIWUIFyrVbd7wr1fZ+4yi7
         /fy3wYfvCWhPMLCz+CGwrIhIkpB4kFe+j+tydNswxX5D1k7r9RNymsKNglOfUzOHKpFA
         EI/Q==
X-Gm-Message-State: AOJu0YyACj6Fy61EpTCOIGo9f70DKI60b/E67RTJZfYg2arAW+0iNFLr
	0vqs93BYhSfpjfOsUlCGKz7bu7NVnww4EQQvdPPn3SnKgZVQIQ==
X-Google-Smtp-Source: AGHT+IFLxxPzr25kxwc9GopROImJ6X1SXgLuYqi99nONA2LhwtI+B2rYK2PDGdynAkq4SrU4TchcthBO/+2dmQIwguI=
X-Received: by 2002:a05:6512:a92:b0:500:99a9:bc40 with SMTP id
 m18-20020a0565120a9200b0050099a9bc40mr12006734lfu.69.1701311376425; Wed, 29
 Nov 2023 18:29:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231128105351.47201-1-dmantipov@yandex.ru> <CAKYAXd-QzUq4Ejv6Q8BFPHes-vSwqJW-kPt6tfhTu=h-OKAHsQ@mail.gmail.com>
 <411a0163-8169-48bd-8b89-75713e95311b@yandex.ru>
In-Reply-To: <411a0163-8169-48bd-8b89-75713e95311b@yandex.ru>
From: Steve French <smfrench@gmail.com>
Date: Wed, 29 Nov 2023 20:29:25 -0600
Message-ID: <CAH2r5mthsZZJz8aBnrzeJbrQpb3YLDuB27Y+gyrje8VHS6KHzw@mail.gmail.com>
Subject: Re: [PATCH] smb: client, common: fix fortify warnings
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

added the acked-by and tentatively put patch in cifs-2.6.git for-next
pending testing

On Tue, Nov 28, 2023 at 11:30=E2=80=AFPM Dmitry Antipov <dmantipov@yandex.r=
u> wrote:
>
> On 11/29/23 08:12, Namjae Jeon wrote:
>
> > I'm confused by your use of the word "may" above. Did you checked if
> > the warnings are silenced with this patch ?
>
> Sure (but note I've used an experimental gcc-14 and clang-18 to check).
>
> Dmitry
>


--=20
Thanks,

Steve
