Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A7B3C38145
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Sep 2022 18:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiIGSPL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Sep 2022 14:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiIGSPK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Sep 2022 14:15:10 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7678462A9F
        for <linux-cifs@vger.kernel.org>; Wed,  7 Sep 2022 11:15:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 14D871FF09;
        Wed,  7 Sep 2022 18:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1662574508; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AwQh2rE+cLxQT8qstUVbglixdhlRX1vsyWPIrPHj6+A=;
        b=af2WG9mTnBtTFkZZVezwUIGBmNW9CIOW5a0ZTvQ7bo/3FGautfAzNEdxHxhUYcwLC5UY+v
        NeEbLJlfq5RT2K7bCxJtSe2LYXJ32GPlDETfgjxTtl49Jri13FMfzEQBBn79BacqTycL7z
        jeWWkGTja5qn4oJFuv5COg7CO56Zcbk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1662574508;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AwQh2rE+cLxQT8qstUVbglixdhlRX1vsyWPIrPHj6+A=;
        b=OJZUVnxaQLbot52zJKc2NlQpNc9Q9yeHAs+vfHuT67cY6xLtmI5yI4zDwCBnWQJ3Cym1w0
        WI5bb7keDwHTQ9DA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8B0D413486;
        Wed,  7 Sep 2022 18:15:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3O9cE6vfGGM1GQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 07 Sep 2022 18:15:07 +0000
Date:   Wed, 7 Sep 2022 15:15:04 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     =?utf-8?B?QXVyw6lsaWVu?= Aptel <aurelien.aptel@gmail.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [PATCH] cifs: perf improvement - use faster macros ALIGN() and
 round_up()
Message-ID: <20220907181504.slrof5u42vijakje@cyberdelia>
References: <20220906013040.2467-1-ematsumiya@suse.de>
 <CA+5B0FNBJVFC6-SfVodctu0DkyyZ9DzJM8OJsDBbVb453Mvfsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CA+5B0FNBJVFC6-SfVodctu0DkyyZ9DzJM8OJsDBbVb453Mvfsw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Aurelien,

On 09/07, Aur=E9lien Aptel wrote:
>Hi,
>
>Changes are good from a readability stand point but like the others
>I'm very skeptical about the perf improvement claims.

I also am/was. That's why I ran 5 times each test after sending the
patch. For each run, I made sure to have the mount point clean, both
server and client freshly booted, and aside from the patch, the build
env/compile options were exactly the same.

The server had no parallel workload at all as it's only a test server.

>Many of these compile to the same division-less instructions
>especially if any of the values are known at compile time.

<snip>

>> @@ -2826,9 +2819,7 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_=
Server_Info *server,
>> -               copy_size =3D uni_path_len;
>> -               if (copy_size % 8 !=3D 0)
>> -                       copy_size =3D roundup(copy_size, 8);
>> +               copy_size =3D round_up(uni_path_len, 8);
>> @@ -4090,7 +4081,7 @@ smb2_new_read_req(void **buf, unsigned int *total_=
len,
>> -                       *total_len =3D DIV_ROUND_UP(*total_len, 8) * 8;
>> +                       *total_len =3D ALIGN(*total_len, 8);
>
>These 2 are also hot paths, but skeptical about the optimizations.

As you point out, SMB2_open_init() was indeed the function with greater
improvement, and as per my measurements, the one that actually impacted
the general latency.

>I've looked at those macros in Compiler Explorer and sure enough they
>compile to the same thing on x86_64.
>Even worse, the optimized versions compile with extra instructions for som=
e:
>
>https://godbolt.org/z/z1xhhW9sj

I did the same comparison on a userspace program and got similar
results, but I didn't bother to check the kernel objects as testing it
was quicker to me. But I'll do it today.

>I suspect the improvements are more likely to be related to caches,
>system load, server load, ...

See above.

>You can try to use perf to make a flamegraph and compare.
>
>Cheers,

Not really used to perf, but will check it out, thanks!


Cheers,

Enzo
