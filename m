Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51385C6FA82
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Sep 2022 14:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbiIMOEI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Sep 2022 10:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232408AbiIMOEF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Sep 2022 10:04:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C230151A0C
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 07:04:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A53E614A1
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 14:04:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51E7C433D7
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 14:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663077843;
        bh=QtwhAlKFOUilXtwOTWOLavm4H73Oank5adpasO/c+kY=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=S7AAampFRYz8oSfD/Pm6OBERPwa6eNBIPB+yYJ6h/amSZDBRpqpJE9C8plBtlaZPZ
         uE+LKS56mQDRY0FzgrYlP2RxWplQuWo78NOIfMyNdoGeqx+QVSyPzMYvrhrNqoKFok
         Ru3sTXryTbokXflOEwrQ5cReGuX5mkVL3uuTf6hk/5VZmDO+lxp8/oGX7kHyi1B3jZ
         PkDog2HEkilH5AiQtGND/rn+jkve5rXcDUQLFULx9lnYDDZNnhCkgQecqlQgO49/HF
         bPv6Xfk2LCZSa4Y7Cnf4f7Jgg1MoojLrztc933zY775vjpAiSr6A844oYlVNKPQg/e
         Ux6jA5CRKtTgw==
Received: by mail-qv1-f43.google.com with SMTP id s13so9219106qvq.10
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 07:04:03 -0700 (PDT)
X-Gm-Message-State: ACgBeo0WtJ1LLZFl2yWgFqtimeENQSI1GLfExYl+wlbENrBIu1jb6Ifs
        Qw3zLL3/HZH8GvYfhdECDnjJC5KJWlZ06V8vkdw=
X-Google-Smtp-Source: AA6agR5s/mEF9PHnKISFmDL3b7d57efm2O4t2D3i47PZYLNRF/D4tblS81KFtRIJ/c4CcCsWmZeXfNyKLyJoFNe5B3U=
X-Received: by 2002:a05:6214:daf:b0:49f:5ce8:e628 with SMTP id
 h15-20020a0562140daf00b0049f5ce8e628mr26941973qvh.115.1663077842780; Tue, 13
 Sep 2022 07:04:02 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6214:d8a:0:0:0:0 with HTTP; Tue, 13 Sep 2022 07:04:02
 -0700 (PDT)
In-Reply-To: <20220912161459.23505-1-atteh.mailbox@gmail.com>
References: <CAKYAXd_ondWwEuHhVZnVp0dd6N5ZZzw=2EJXSicEYSjwdBB46A@mail.gmail.com>
 <20220912161459.23505-1-atteh.mailbox@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 13 Sep 2022 23:04:02 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-pWSWiVy3YMWUpdRGcUS4CNCO8MDDxPin+hQjz4dFPFQ@mail.gmail.com>
Message-ID: <CAKYAXd-pWSWiVy3YMWUpdRGcUS4CNCO8MDDxPin+hQjz4dFPFQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: casefold utf-8 share names and fix ascii
To:     =?UTF-8?Q?Atte_Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-13 1:14 GMT+09:00, Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>:
> On Mon, 12 Sep 2022 19:20:54 +0900, Namjae Jeon wrote:
>>2022-09-12 5:57 GMT+09:00, Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>:
>>Hi Atte,
>>
>>[snip]
>>> +static char *casefold_sharename(struct unicode_map *um, const char
>>> *name>)
>>> +{
>>> +	char *cf_name;
>>> +	int cf_len;
>>> +
>>> +	cf_name =3D kzalloc(KSMBD_REQ_MAX_SHARE_NAME, GFP_KERNEL);
>>> +	if (!cf_name)
>>> +		return ERR_PTR(-ENOMEM);
>>> +
>>> +	if (IS_ENABLED(CONFIG_UNICODE)) {
>>> +		const struct qstr q_name =3D {.name =3D name, .len =3D strlen(name)}=
;
>>> +
>>> +		if (!um)
>>> +			goto out_ascii;
>>Minor nit, Wouldn't it be simpler to change something like the one below?
>>
>>+	if (IS_ENABLED(CONFIG_UNICODE) && um) {
>
> This mailing list already has a v2 patch series. Please, reply to that on=
e.
Okay, but please add cc me when you send the patch to the list.

> As for your suggestion, I thought to keep the statements separate since t=
he
> block with the IS_ENABLED() macro is optimized away when CONFIG_UNICODE i=
s
> not set. I understand that the behavior is the same with your suggestion.
When CONFIG_UNICODE is not set, um is not checked in my suggestion.
Please tell me why my suggestion is worse. if you are okay, I will
update it directly.(i.e. no need to send v3 patch). and please check
the use of strncasecmp() in __caseless_lookup() also.

And I need to do full test for this patches, I think it will take
about two days.
>
> Thank you.
>
>>
>>Thanks!
>>> +
>>> +		cf_len =3D utf8_casefold(um, &q_name, cf_name,
>>> +				       KSMBD_REQ_MAX_SHARE_NAME);
>>> +		if (cf_len < 0)
>>> +			goto out_ascii;
>>> +
>>> +		return cf_name;
>>> +	}
>>> +
>>> +out_ascii:
>>> +	cf_len =3D strscpy(cf_name, name, KSMBD_REQ_MAX_SHARE_NAME);
>>> +	if (cf_len < 0)
>>> +		return ERR_PTR(-E2BIG);
>>> +
>>> +	for (; *cf_name; ++cf_name)
>>> +		*cf_name =3D isascii(*cf_name) ? tolower(*cf_name) : *cf_name;
>>> +	return cf_name - cf_len;
>>> +}
>>> +
>
