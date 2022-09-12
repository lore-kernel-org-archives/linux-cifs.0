Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3365ECAAD5
	for <linux-cifs@archiver.kernel.org>; Mon, 12 Sep 2022 16:15:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiILQPQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 12 Sep 2022 12:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiILQPM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 12 Sep 2022 12:15:12 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5AB13D14
        for <linux-cifs@vger.kernel.org>; Mon, 12 Sep 2022 09:15:08 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id a14so9056147ljj.8
        for <linux-cifs@vger.kernel.org>; Mon, 12 Sep 2022 09:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=sbnja3IcNLcJ541amIvmSAbP4Fs9AsojaNZk+Dm8M2s=;
        b=GQ+/nowZEls0GDO0Kr3GPL5Xnm4rDc5BJtfPyi/UyLqzhtDQS1ZIRmMZGK7ziNuDlK
         +OKctfh4KSd+xAD9tdCOOvcGr8o63/NjL9S1c+sBw2VOg1T8KurJ6czkoXkrPE6seU+E
         ilvWVMkS2Ii8pvjgL/qfz1M6ZdyPlAVumSSB5217aQSEAbK+wdcToV8KHZ6ggpD4m44L
         U9R4mqppysHdPX52DDFKKowJn8QK8uH7aF/o3CD4f+3Was9gCUG2ESvVUd5MxnouQ2UZ
         OhhfnPv2W0G5C9B1Hu9F15ouFyGV83zhBCzyP8lMxyRKPEDRJhugDkAh2+wo4T7ZsRc2
         LWsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=sbnja3IcNLcJ541amIvmSAbP4Fs9AsojaNZk+Dm8M2s=;
        b=ZNFfUParU9e3BjLmIWJFvqZgsF5I2ph8Ilc/r5uvt9KQ4BSGqa7hSkjwEd45IBq2R1
         Jkh+X7CLMVHNkp1gsA/MR30xpNQhyKhoqiZDiNeYXcoaehvfhE6sVidVpBzrYHJ6hytZ
         WoMthe0gn9UQnVa3dmyPgzOs7NCA2Akf1maCTHlQSUB//ofT0XoiG+ykNIv8POVpKyBy
         bHiNxdt5ntxlvktFMuV/FvAkA9qyS0YqPtgHPJgI+e8FlqVQTfOwZvZNrJyA0T1nQpsr
         DN9FUVzm9U2RymrUjcKuEQUmVDhHed3c7QbHSJcwKo407xscZYvRAvSgEUY/8ZNg/3Y5
         t9Vw==
X-Gm-Message-State: ACgBeo2v6T1QOaYAY0EbtmZcwcCc2Mw64agqY9vV9ZpGZSfT7nUtkvBq
        hWrwX6nGheYLFub7lrckhPE=
X-Google-Smtp-Source: AA6agR72ges3sfAOZ+VvliiejuHHgDX4aJF3bSORDB/bgKKZYYBUJeiNEzAw3Q2tfy9nZpsEyP2yqA==
X-Received: by 2002:a2e:824c:0:b0:25f:de27:f013 with SMTP id j12-20020a2e824c000000b0025fde27f013mr7750336ljh.447.1662999306392;
        Mon, 12 Sep 2022 09:15:06 -0700 (PDT)
Received: from pohjola.lan (mobile-user-2e84bc-66.dhcp.inet.fi. [46.132.188.66])
        by smtp.gmail.com with ESMTPSA id a19-20020a056512201300b0048a757d1303sm1145425lfb.217.2022.09.12.09.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 09:15:05 -0700 (PDT)
From:   =?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
To:     linkinjeon@kernel.org
Cc:     atteh.mailbox@gmail.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH 1/2] ksmbd: casefold utf-8 share names and fix ascii
Date:   Mon, 12 Sep 2022 19:14:59 +0300
Message-Id: <20220912161459.23505-1-atteh.mailbox@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <CAKYAXd_ondWwEuHhVZnVp0dd6N5ZZzw=2EJXSicEYSjwdBB46A@mail.gmail.com>
References: <CAKYAXd_ondWwEuHhVZnVp0dd6N5ZZzw=2EJXSicEYSjwdBB46A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, 12 Sep 2022 19:20:54 +0900, Namjae Jeon wrote:
>2022-09-12 5:57 GMT+09:00, Atte Heikkilä <atteh.mailbox@gmail.com>:
>Hi Atte,
>
>[snip]
>> +static char *casefold_sharename(struct unicode_map *um, const char *name>)
>> +{
>> +	char *cf_name;
>> +	int cf_len;
>> +
>> +	cf_name = kzalloc(KSMBD_REQ_MAX_SHARE_NAME, GFP_KERNEL);
>> +	if (!cf_name)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	if (IS_ENABLED(CONFIG_UNICODE)) {
>> +		const struct qstr q_name = {.name = name, .len = strlen(name)};
>> +
>> +		if (!um)
>> +			goto out_ascii;
>Minor nit, Wouldn't it be simpler to change something like the one below?
>
>+	if (IS_ENABLED(CONFIG_UNICODE) && um) {

This mailing list already has a v2 patch series. Please, reply to that one.
As for your suggestion, I thought to keep the statements separate since the
block with the IS_ENABLED() macro is optimized away when CONFIG_UNICODE is
not set. I understand that the behavior is the same with your suggestion.

Thank you.

>
>Thanks!
>> +
>> +		cf_len = utf8_casefold(um, &q_name, cf_name,
>> +				       KSMBD_REQ_MAX_SHARE_NAME);
>> +		if (cf_len < 0)
>> +			goto out_ascii;
>> +
>> +		return cf_name;
>> +	}
>> +
>> +out_ascii:
>> +	cf_len = strscpy(cf_name, name, KSMBD_REQ_MAX_SHARE_NAME);
>> +	if (cf_len < 0)
>> +		return ERR_PTR(-E2BIG);
>> +
>> +	for (; *cf_name; ++cf_name)
>> +		*cf_name = isascii(*cf_name) ? tolower(*cf_name) : *cf_name;
>> +	return cf_name - cf_len;
>> +}
>> +
