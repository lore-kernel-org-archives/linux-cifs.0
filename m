Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40A52C4167B
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Dec 2022 15:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235036AbiL3PZD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 30 Dec 2022 10:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235018AbiL3PZC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 30 Dec 2022 10:25:02 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E393B186C3
        for <linux-cifs@vger.kernel.org>; Fri, 30 Dec 2022 07:25:01 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 79so14365825pgf.11
        for <linux-cifs@vger.kernel.org>; Fri, 30 Dec 2022 07:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W+CEKLXl7lMjuybNJOymH+CI8SxoM9EObQdCL8HHvkI=;
        b=KMd5SsPlZj0/2yUH4KGi0Dn5hjXLjlZ/tB1u0yAD6ctHO8Z/0WDoQE74iGfuRa8vv4
         UL8qYif3pzR5/kDsd8fB5ZvYl7TY1IUK/mc3wOOUchy+0QZIOSG4Y1Gl40nAkvk2/zHb
         bvQvFHf9oNiXKj1J+ErY9poTGA4B2JYHn6RQ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W+CEKLXl7lMjuybNJOymH+CI8SxoM9EObQdCL8HHvkI=;
        b=XDYPWrxXCxwI8ACYOiho8+kURGqSGktGbLN2lXKqIlfJ95963dra4divrohPOpOGXz
         VazwHKfoH+r6PXZBeo4A9bo10k3/6EMlkmfDN6vGF1vUUVOUAAenWpgVF6hE3UTo9awW
         hPkLFwVsNZJhfsEo2/xQ12or6UX7pTjSR+zxusHZcK/5+aGCwSogfjWK7H6jb/dxfCcs
         d0C9306mTE43z+lyrEY3mAbmU3VHXSbuE9VngdcDJ3NuLwBpNt3E2RZkFnxFwGThSjnX
         dVVxu2iwCFPi+/IVWejCXZxyQhmg3IE4mtywRnaew9u7cXwBKMRkRgW4z24y92CzTwmg
         8WvQ==
X-Gm-Message-State: AFqh2krFaD+bnpvV2xewzQFMUysUw5Hl2nyXmKnodIZ+wGxrZnYkNLz8
        IqJ9kjXFwD81kZ/dgGR8uWxhVg==
X-Google-Smtp-Source: AMrXdXuE0VnZbDilsBpMXCoN0RPodmJpewJQXg/eLTMxxX0VJXY0RtfaW4o23hiK04oiZfDNXQv3DA==
X-Received: by 2002:aa7:981c:0:b0:578:83f5:554d with SMTP id e28-20020aa7981c000000b0057883f5554dmr38359584pfl.23.1672413901252;
        Fri, 30 Dec 2022 07:25:01 -0800 (PST)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id b67-20020a621b46000000b0053e38ac0ff4sm13834187pfb.115.2022.12.30.07.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 07:25:00 -0800 (PST)
Date:   Sat, 31 Dec 2022 00:24:56 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com
Subject: Re: [PATCH v2] ksmbd-tools: add max connections parameter to global
 section
Message-ID: <Y68CyMM/swjY/mhz@google.com>
References: <20221230142420.10930-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221230142420.10930-1-linkinjeon@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (22/12/30 23:24), Namjae Jeon wrote:
[..]
> @@ -548,6 +548,16 @@ static gboolean global_group_kv(gpointer _k, gpointer _v, gpointer user_data)
>  		return TRUE;
>  	}
>  
> +	if (!cp_key_cmp(_k, "max connections")) {
> +		global_conf.max_connections = memparse(_v);
> +		if (global_conf.max_connections > KSMBD_CONF_MAX_CONNECTIONS) {
> +			pr_info("Limits exceeding the maximum simultaneous connections(%d)\n",
> +				KSMBD_CONF_MAX_CONNECTIONS);
> +			global_conf.max_connections = KSMBD_CONF_MAX_CONNECTIONS;
> +		}
> +		return TRUE;
> +	}

A quick question: do you want "max connections = 0" to be possible or
should ksmb never permit unlimited connections?

> +	global_conf.max_connections = 512;
>  }
[..]
> +	share->max_connections = 512;

A nit: may be have a define for default limit instead?
