Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73E07ECAAD8
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Sep 2022 18:27:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbiIMS07 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Sep 2022 14:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiIMS0k (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Sep 2022 14:26:40 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B872120BD
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 10:44:43 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id a8so21274233lff.13
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 10:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=2fMBNU4XYL1HrR4KdaCCo6QVoS+DsiGeCK3uaEyrboE=;
        b=WlkR9EYy7b30ufLhKRmtijavK3VghnSXrjFCincT7nGbVUzb5eIiEzyq+hYD2qETES
         KvZUlkakHmSofHrAbqGJkDCV3vRf8FM60qB4OG2QBFho7BC2Q6mA6sLyJ8weW3H1KlX5
         mxrsb3rMsJ1kXyLSpjpmjt2Sh8bbVsCLg/cv3oXl4vBkAeAKYdauV1vvfti0mSpJGQz4
         gHCB0w1BH5J6G+GasDXuoPUCYJR4xeFAeCSfiHULSaL7EAEuw89gtP60WGt5zg7JFQSX
         BZIVWDVnFOKS9gyvLlzYcoOn+3wuBccPPpUmcS78VY+MTXzBybh281BusJCrY/oE+Ms2
         J14Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=2fMBNU4XYL1HrR4KdaCCo6QVoS+DsiGeCK3uaEyrboE=;
        b=KsM1XzOAxFa9cQG9rYDdyITY9x5MIXsCo+kcGVL7A1s5JDDM6QMS9LnlnU1vw6qOXi
         kansOZCotsMwpHL+6iaFGyKmOPjAxuN9lIU+WDAfT9/IlcqWQslZujezwBN+iz4vhbN9
         u2UtjU8OsDcatUT8gPxq/veQtUrmCJ2uyUscArwz3FYYwz1ojRPAwCHe4HjaqHySZylJ
         X/syiIFO9+acRyq47vbzCBFjjhWEkX46CB0cIas7C3yCNC3Ba6jmucRmLfSyvXnuHZ2m
         pYPuFEHgRL6cvzPSoaV8pWua55FWMg4Dsb0GhB+f9/n7Nnvq78zn5mwAcBTy6DtJGNGm
         pdoQ==
X-Gm-Message-State: ACgBeo0XuEtwZvzXRfGBe95ngueZs64BG/hTnXkn0VaCLNcuZ6L/ZCf0
        uKsoOMenEqfkmtz493syDSShErZ0Y1U=
X-Google-Smtp-Source: AA6agR7Zq7JLlcTCSCD6HlY+rqxSsijIA301rf9cnY5oB31DUesL/FoJcpTmfC4ej4DM4g5eZjezWA==
X-Received: by 2002:a19:5e4f:0:b0:497:aa47:86b8 with SMTP id z15-20020a195e4f000000b00497aa4786b8mr9438610lfi.261.1663091081573;
        Tue, 13 Sep 2022 10:44:41 -0700 (PDT)
Received: from pohjola.lan (mobile-user-2e84bc-66.dhcp.inet.fi. [46.132.188.66])
        by smtp.gmail.com with ESMTPSA id d4-20020ac25444000000b00494a2a0f6cfsm1846240lfn.183.2022.09.13.10.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 10:44:40 -0700 (PDT)
From:   =?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
To:     linkinjeon@kernel.org
Cc:     atteh.mailbox@gmail.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH 1/2] ksmbd: casefold utf-8 share names and fix ascii lowercase conversion
Date:   Tue, 13 Sep 2022 20:44:32 +0300
Message-Id: <20220913174432.22748-1-atteh.mailbox@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <CAKYAXd-pWSWiVy3YMWUpdRGcUS4CNCO8MDDxPin+hQjz4dFPFQ@mail.gmail.com>
References: <CAKYAXd-pWSWiVy3YMWUpdRGcUS4CNCO8MDDxPin+hQjz4dFPFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, 13 Sep 2022 23:04:02 +0900, Namjae Jeon wrote:
>2022-09-13 1:14 GMT+09:00, Atte Heikkilä <atteh.mailbox@gmail.com>:
>>
>> This mailing list already has a v2 patch series. Please, reply to that one.
>Okay, but please add cc me when you send the patch to the list.

I sent the v2 patch to the mailing list an hour after the first one:
https://lore.kernel.org/linux-cifs/20220911215542.104935-1-atteh.mailbox@gmail.com/

Please, let's have further discussion as replies to the v2 patch series
and not this one.

>
>> As for your suggestion, I thought to keep the statements separate since the
>> block with the IS_ENABLED() macro is optimized away when CONFIG_UNICODE is
>> not set. I understand that the behavior is the same with your suggestion.
>When CONFIG_UNICODE is not set, um is not checked in my suggestion.

I didn't mean to imply that it was.

>Please tell me why my suggestion is worse. if you are okay, I will
>update it directly.(i.e. no need to send v3 patch).

I didn't mean that your suggestion is worse. Feel free to update it directly
if you'd like.

>and please check the use of strncasecmp() in __caseless_lookup() also.

I thought that the change to utf8_strncasecmp() would be out of place for
this patch series.

>
>And I need to do full test for this patches, I think it will take
>about two days.

Please do not feel inclined to hurry, considering the mistake I managed
to make in the the v1 patch series (this one you're replying to).

>>
>> Thank you.
>>
