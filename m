Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B33C636D3
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Jan 2023 02:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjAaCjl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Jan 2023 21:39:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbjAaCjk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Jan 2023 21:39:40 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B9AAD02
        for <linux-cifs@vger.kernel.org>; Mon, 30 Jan 2023 18:39:39 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id z1so6131722plg.6
        for <linux-cifs@vger.kernel.org>; Mon, 30 Jan 2023 18:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Av8nuXDb3ehCMmKHr8yr1MaT2beeOkgE9Ws+9RcVzT4=;
        b=kTRV+yKckURisyIAwjKxmwj9h0qC9+D87EcB2jtc6ZvePip6tXP4eVYnO/E2lpvzIQ
         Aoo27MXZh65rWTXDkvR5U4F04LHtHjtdBLnNjsgHjJmaTgCg9bZzEeFQvfFlGWkpE1q5
         /y6vAM5gxBS7QpCoTz3SWlm8Q2OklqhP2FpdM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Av8nuXDb3ehCMmKHr8yr1MaT2beeOkgE9Ws+9RcVzT4=;
        b=3raXGobiCWPtF0D/CiVSSp6XLwMGa/07Q4ClKGzL+FY1ZcflVTvHxeRoOAtRSF/Y1a
         iEq9eefpNNd5qWfavywHCqKRdKr5FI84PGVXfv6djwT4s94En8Ss7E355GA7WwbQMDqK
         +2KawzDU3rZJQ7iKFh2giew2cRbm1P9VvI1fNXvF6+7J4k6LxdtvXDlzMMkbao+mqnmy
         M5KwpiQUMovn8AAaQPX3ju6PZFeTDCFfDSpOMxTbxMTC6aynApyJnVDXRNtoWQBQpan/
         yMWkC4z8J9TJ0cp2kVq1MdXgmzl9nzCYTu7kgf1rRsu9KruEjAaGhz+9FO8pAHxVLMe2
         ovKg==
X-Gm-Message-State: AO0yUKWK/ZlGkvTeOqyfEGimU7rN7XdxpxtgsS9JvOVTzABZ7FTynjVU
        zXefqZphEfCEkuidDWhE0ygFzQ==
X-Google-Smtp-Source: AK7set/f7uBMUKqu9KFk26rahjgTv38fqPMMgcxHXRi4/E/5YLC9GO0kqR7X6odW3Kl48bh1QBtT4A==
X-Received: by 2002:a17:903:11d2:b0:192:ac33:7f91 with SMTP id q18-20020a17090311d200b00192ac337f91mr12063975plh.69.1675132778722;
        Mon, 30 Jan 2023 18:39:38 -0800 (PST)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id w9-20020a1709027b8900b0019682e27995sm2834039pll.223.2023.01.30.18.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 18:39:38 -0800 (PST)
Date:   Tue, 31 Jan 2023 11:39:33 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Dawei Li <set_pte_at@outlook.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        linkinjeon@kernel.org, sfrench@samba.org, tom@talpey.com,
        hyc.lee@gmail.com, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] ksmbd: replace rwlock with rcu for concurrenct
 access on conn list
Message-ID: <Y9h/ZbLPQlbKiRzZ@google.com>
References: <20230115103209.146002-1-set_pte_at@outlook.com>
 <TYCP286MB23235FDD8102162698EF3154CAC09@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM>
 <Y9dEZ5IgfwpZNlVm@google.com>
 <TYCP286MB23230E29CC81F5C0590C59C9CAD39@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYCP286MB23230E29CC81F5C0590C59C9CAD39@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

On (23/01/30 22:16), Dawei Li wrote:
> Hi Sergey,
> 
> Thanks for reviewing,
> 
> On Mon, Jan 30, 2023 at 01:15:35PM +0900, Sergey Senozhatsky wrote:
> > On (23/01/15 18:32), Dawei Li wrote:
> > > 
> > >  void ksmbd_conn_free(struct ksmbd_conn *conn)
> > >  {
> > > -	write_lock(&conn_list_lock);
> > > -	list_del(&conn->conns_list);
> > > -	write_unlock(&conn_list_lock);
> > > +	spin_lock(&conn_list_lock);
> > > +	list_del_rcu(&conn->conns_list);
> > > +	spin_unlock(&conn_list_lock);
>         synchronize_rcu(); 
> > >  
> > >  	xa_destroy(&conn->sessions);
> > >  	kvfree(conn->request_buf);
> > 
> > From a quick look this does not seem like a correct RCU usage. E.g.
> > where do you wait for grace periods and synchronize readers/writers?
> 
> Nice catch, I totally mess it up. Thanks!
> 
> At first glance, I assume synchronize_rcu() will do the job if sleeping
> is OK?

Yes, synchronize_rcu() will sleep (schedule()) and wait for grace
period to expire (and synchronize will all the RCU readers). RCU
is good for cases when writes are seldom, which may not be the case
with ksmb.

I really want to see benhcmarks, why do we want to remove the RW-lock.
