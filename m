Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61573246F8
	for <linux-cifs@vger.kernel.org>; Tue, 10 Feb 2026 10:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770720236; cv=none; b=o+AcGUWIaU34iVWRP7FUGkaXYdtYzw9lR8gZO3hgcDx4lvEZIn6toscHGsOEfjMv18MUt/C3oJA+9bAhpoKSgyRJ8JLNnFOVxy0Rd7Ml4fwvVjnfbKsdTbxcGJFliB2XJZoHhyJnoKyvERhNRfCUufz/hY9Whn70npBCF69sUM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770720236; c=relaxed/simple;
	bh=94aHYOw2nX2XxrPNHDYFWnWPEoP2v2C9z1A5yLmc9Kg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BcQv9SFhnVFVyOEbo1EYPZVSqz/KRgqo2eQZi4Mj596ltoZ7cTVNr33/oEnPMg8yL5likhr+Nqk47sPL5LadMgXMf59MS4Us+kU8R56MQD0t8AGj6Er1mtVvDBi4oW01ENQ7CNm5qJGUCO6X8NvroUp1YBRkvc0oIjYSKTTqgoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-896fd2c5337so5633406d6.2
        for <linux-cifs@vger.kernel.org>; Tue, 10 Feb 2026 02:43:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770720234; x=1771325034;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wxTZChuQvYnYAfchI6rKnpLi7lD4JzDEprV4DeGLhBs=;
        b=CJpZtN7MRGD9GNa9U2vXJv7sadzMzfik/jJ8cXrTaA51/ZCD/UgnO93j/5Miusmig1
         9GfyPjnyYG/U6SZhxFvLDQLZUI0KFEa7ZB7FYre6Xrs9UdJB+gWsP4wLuc7mYPirvSt7
         3Ra1Q9pLjxppLVX8SqxZEBr6z66LbxHbKGvcV7GKmWq9c7SeF2MirY1MaktSxJoMxG/w
         bq+zaHk+KKYiZPqNiEt6EDaem+pkaXphXAQ2ZNkcY2jJQSjyUMt4V9cemLyZY+eRsDEk
         YuYUaxebGv8pjIUhQvCJCq2GHGzKT7ofUr+SFDChMeQXDP/6SGo7wuOCuH4KpSBFwhQg
         nLhg==
X-Forwarded-Encrypted: i=1; AJvYcCWDf6K6no6xivMlnKpPu/g3xy8ggphE5bkuk5fyrWrDfr49UUyg1Dz1EhLMWUDDxlv+JWtxsFmPp+2p@vger.kernel.org
X-Gm-Message-State: AOJu0Yywi0vxgqQIZMIT64DO9YWYIHFoUh47wYv32Vb118mwwqUNEkoM
	TRQoVzz2hZeWbq+G4559hqD/livB++uxYf31EhR6DlLIfEjSxHRTzRtBNU8/HBR8
X-Gm-Gg: AZuq6aIUYxn1Z8eulFih5a348u1LCSRbQB9BcuEi5Mx3+R30a7sYMib37x3WOaeu3YP
	ejD/EdYtstLYNwn9TGjmOXPUC1DmVJFSbfDnHJPJnOszZ9OOGofBKJUXPm5TuZj3PtPEtxCyNYX
	ri9HlwTMy87dlLuHnils2AMsJC649D33lelLHTUSBE9+2Y6mf/JwH7klBJTqXY7bljew6mE75KC
	jC+c4illzk+udGh5124lrrGAzL6XL2zAOqJyxXiLnV6OaFIJLlQUASEQXkXyrlK+jYYHfnLMjFu
	9yZv22EMr2/aZFJsbk9WkvJM6wGDkPnucIsZ15uHkkwWc1MHQgVxMDJxaOmVMI7mB1lI224BWf7
	abjtN9n0uAto+AeWuBI/C+cLv7X4N99wetGvRpIPPtGKpYmevlObl/0f0+TOTC2ySEkp97HWW3R
	7YceF/WekPfrwPPgR9dRuSyzm4D5S63Biu2a7QNMvEYqlF4ao9B/1WyCD90vP9UulD
X-Received: by 2002:ad4:5be4:0:b0:896:fc9f:3744 with SMTP id 6a1803df08f44-896fc9f3f5fmr100334436d6.64.1770720233580;
        Tue, 10 Feb 2026 02:43:53 -0800 (PST)
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com. [209.85.222.180])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8caf77f6982sm1012336885a.6.2026.02.10.02.43.53
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Feb 2026 02:43:53 -0800 (PST)
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8c5389c3cd2so71213085a.0
        for <linux-cifs@vger.kernel.org>; Tue, 10 Feb 2026 02:43:53 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW3RO/qnzYtfZNqC6LOdSseIgFDPheA8xejXpmpgX0miF57fZU8ELYYKDxAEBqEJUoO7rwzZBe9uDnk@vger.kernel.org
X-Received: by 2002:a05:6102:3713:b0:5ee:a03c:8782 with SMTP id
 ada2fe7eead31-5fae8c05a23mr4360465137.21.1770719930578; Tue, 10 Feb 2026
 02:38:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260118091313.1988168-1-chenxiaosong.chenxiaosong@linux.dev>
 <20260210081040.4156383-1-geert@linux-m68k.org> <5c4bbbea-d68c-4089-b3aa-adb4b05696ba@linux.dev>
In-Reply-To: <5c4bbbea-d68c-4089-b3aa-adb4b05696ba@linux.dev>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 10 Feb 2026 11:38:39 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXBBCzWK8HPQ8zQYJ1_Pxim3_ku4_2-CnWXm3M4ysnQ+w@mail.gmail.com>
X-Gm-Features: AZwV_QjCZ0dsEnS1lBtbxtndXEm6HBL8E2zwBOjjm9WbKYhgkBIIkBh1X1XBuDg
Message-ID: <CAMuHMdXBBCzWK8HPQ8zQYJ1_Pxim3_ku4_2-CnWXm3M4ysnQ+w@mail.gmail.com>
Subject: Re: [PATCH v9 1/1] smb/client: introduce KUnit test to check search
 result of smb2_error_map_table
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: bharathsm@microsoft.com, chenxiaosong@kylinos.cn, dhowells@redhat.com, 
	linkinjeon@kernel.org, Brendan Higgins <brendan.higgins@linux.dev>, 
	David Gow <davidgow@google.com>, Rae Moar <raemoar63@gmail.com>, 
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	linux-cifs@vger.kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	senozhatsky@chromium.org, smfrench@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com
Content-Type: text/plain; charset="UTF-8"

Hi ChenXiaoSong,

On Tue, 10 Feb 2026 at 10:53, ChenXiaoSong
<chenxiaosong.chenxiaosong@linux.dev> wrote:
> The KUnit test cases are only executed when the CONFIG_SMB_KUNIT_TESTS
> is enabled.

... which defaults to KUNIT_ALL_TESTS, so if KUNIT_ALL_TESTS is enabled,
the test is enabled by default, too.

> Making it a separate test module would require exporting local variables
> and functions so that the test code can access them. However, exporting
> local variables and functions would likely make the code much uglier, as
> it would require adding "#if" conditionals into the production code to
> isolate the test code.
>
> Geert, please let me know if you have a better idea.
>
> I am also discussing this with the ext4 community, and we all hope to
> find a way to make the tests a separate module.

There are ways to restrict exported symbols to test modules only,
see EXPORT_SYMBOL_FOR_TESTS_ONLY(), EXPORT_SYMBOL_FOR_MODULES(),
and EXPORT_SYMBOL_NS().

If it is really hard to convert the tests into a separate module,
you can add a new kernel/module parameter, which needs to be specified
explicitly to run the test. That would avoid running the tests when just
(auto)loading cifs.ko.

> On 2/10/26 4:10 PM, Geert Uytterhoeven wrote:
> > Thanks for your patch, which is now commit 480afcb19b61385d
> > ("smb/client: introduce KUnit test to check search result of
> > smb2_error_map_table") in linus/master
> >
> >> The KUnit test are executed when cifs.ko is loaded.
> > This means the tests are_always_ executed when cifs.ko is loaded,
> > which is different from how most other test modules work.
> > Please make it a separate test module, so it can be loaded independently
> > of the main cifs module.  That way people can enable all tests in
> > production kernels, without affecting the system unless a test module
> > is actually loaded.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
