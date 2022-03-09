Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC1B4C433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Mar 2022 15:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbiCIPbk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Mar 2022 10:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbiCIPbk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Mar 2022 10:31:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2BE79106628
        for <linux-cifs@vger.kernel.org>; Wed,  9 Mar 2022 07:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646839840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6EsyJDNMaW7aLzLkycFQGvPjjJ3FlfDqU3pzS9T1Q8I=;
        b=XB9RjTZdiQzvdItYkAHnQbhBLRUMCfCVXT8h3XzuidooxZxeHy7Ft7uvv2daKkUjGJlpOf
        mNn8YCJQ4tzUpkAhf/ZQO7ByEzJQimC6+I0CeKRVlY5ViqdrRhqyOOdWktTPYb/zBmhLR8
        QzI4zbyi3U5a9EjuPMeU8d1TWCMmO1M=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-421-fyUknCvLNRqPkrySr15DQg-1; Wed, 09 Mar 2022 10:30:39 -0500
X-MC-Unique: fyUknCvLNRqPkrySr15DQg-1
Received: by mail-qk1-f197.google.com with SMTP id q5-20020a05620a0d8500b004738c1b48beso1787780qkl.7
        for <linux-cifs@vger.kernel.org>; Wed, 09 Mar 2022 07:30:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=6EsyJDNMaW7aLzLkycFQGvPjjJ3FlfDqU3pzS9T1Q8I=;
        b=R75C7TwnUKx1CeyTHU3Qu+dzbwmLYs6aT9bAMN1bZ7EosBxLeoo72XqVd3Y/511FCX
         +o6fjUTXbpipzEfdmOPLNtl8Ff/pDN9X6rTJGsY9liEMZWjOPaSTBhNiFhaap+kPEq2o
         GSSqdAYyhG3VWWfW89eUadOAfjedWn44pOooiR3sz8SJBDtjctoQ9Dgyp+ApNutim60a
         oSpvMObY9eNImDHxXf7XF/kiV11WM+cSlAnmhqOKIJxxiS68h1Op+oIFUl7lilxC5z/F
         +Ve1xZM4sPFHV66UvibSB6YhpRt1RtEyuE4dSC+D+FJGiQj1294BDBFXsMmJeoShuflt
         r1YQ==
X-Gm-Message-State: AOAM533TztYFWqUrUrKC/5waD00bGJHwZrwUHeKgHoyzpgh8iddOHwDA
        tWqWmWs1WjX1AmiA8NI3VQ/Syh+1YzwLRT90bMIj+oMLunhPcZyvInFxnKlBLFMeJr47grWZaU5
        a3Ufhwkifon37tM948j1AOw==
X-Received: by 2002:a05:622a:102:b0:2de:6596:73ff with SMTP id u2-20020a05622a010200b002de659673ffmr166628qtw.75.1646839838466;
        Wed, 09 Mar 2022 07:30:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwFSSJDdxTCAvhdcrcS/qlT4SNihglL15R3cIkJvlDoonZ+iPAI4r0UaiLtAuAoNBZeA0b9IA==
X-Received: by 2002:a05:622a:102:b0:2de:6596:73ff with SMTP id u2-20020a05622a010200b002de659673ffmr166596qtw.75.1646839838220;
        Wed, 09 Mar 2022 07:30:38 -0800 (PST)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id x12-20020a05620a14ac00b0060deaee7a21sm1055813qkj.51.2022.03.09.07.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 07:30:37 -0800 (PST)
Message-ID: <c2f4b3dc107b106e04c48f54945a12715cccfdf3.camel@redhat.com>
Subject: Re: [PATCH v2 02/19] netfs: Generate enums from trace symbol
 mapping lists
From:   Jeff Layton <jlayton@redhat.com>
To:     David Howells <dhowells@redhat.com>, linux-cachefs@redhat.com
Cc:     Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        David Wysochanski <dwysocha@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-afs@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 09 Mar 2022 10:30:36 -0500
In-Reply-To: <164678192454.1200972.4428834328108580460.stgit@warthog.procyon.org.uk>
References: <164678185692.1200972.597611902374126174.stgit@warthog.procyon.org.uk>
         <164678192454.1200972.4428834328108580460.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, 2022-03-08 at 23:25 +0000, David Howells wrote:
> netfs has a number of lists of symbols for use in tracing, listed in an
> enum and then listed again in a symbol->string mapping for use with
> __print_symbolic().  This is, however, redundant.
> 
> Instead, use the symbol->string mapping list to also generate the enum
> where the enum is in the same file.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: linux-cachefs@redhat.com
> 
> Link: https://lore.kernel.org/r/164622980839.3564931.5673300162465266909.stgit@warthog.procyon.org.uk/ # v1
> ---
> 
>  include/trace/events/netfs.h |   57 ++++++++++--------------------------------
>  1 file changed, 14 insertions(+), 43 deletions(-)
> 
> diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
> index e6f4ebbb4c69..88d9a74dd346 100644
> --- a/include/trace/events/netfs.h
> +++ b/include/trace/events/netfs.h
> @@ -15,49 +15,6 @@
>  /*
>   * Define enums for tracing information.
>   */
> -#ifndef __NETFS_DECLARE_TRACE_ENUMS_ONCE_ONLY
> -#define __NETFS_DECLARE_TRACE_ENUMS_ONCE_ONLY
> -
> -enum netfs_read_trace {
> -	netfs_read_trace_expanded,
> -	netfs_read_trace_readahead,
> -	netfs_read_trace_readpage,
> -	netfs_read_trace_write_begin,
> -};
> -
> -enum netfs_rreq_trace {
> -	netfs_rreq_trace_assess,
> -	netfs_rreq_trace_done,
> -	netfs_rreq_trace_free,
> -	netfs_rreq_trace_resubmit,
> -	netfs_rreq_trace_unlock,
> -	netfs_rreq_trace_unmark,
> -	netfs_rreq_trace_write,
> -};
> -
> -enum netfs_sreq_trace {
> -	netfs_sreq_trace_download_instead,
> -	netfs_sreq_trace_free,
> -	netfs_sreq_trace_prepare,
> -	netfs_sreq_trace_resubmit_short,
> -	netfs_sreq_trace_submit,
> -	netfs_sreq_trace_terminated,
> -	netfs_sreq_trace_write,
> -	netfs_sreq_trace_write_skip,
> -	netfs_sreq_trace_write_term,
> -};
> -
> -enum netfs_failure {
> -	netfs_fail_check_write_begin,
> -	netfs_fail_copy_to_cache,
> -	netfs_fail_read,
> -	netfs_fail_short_readpage,
> -	netfs_fail_short_write_begin,
> -	netfs_fail_prepare_write,
> -};
> -
> -#endif
> -
>  #define netfs_read_traces					\
>  	EM(netfs_read_trace_expanded,		"EXPANDED ")	\
>  	EM(netfs_read_trace_readahead,		"READAHEAD")	\
> @@ -98,6 +55,20 @@ enum netfs_failure {
>  	EM(netfs_fail_short_write_begin,	"short-write-begin")	\
>  	E_(netfs_fail_prepare_write,		"prep-write")
>  
> +#ifndef __NETFS_DECLARE_TRACE_ENUMS_ONCE_ONLY
> +#define __NETFS_DECLARE_TRACE_ENUMS_ONCE_ONLY
> +
> +#undef EM
> +#undef E_
> +#define EM(a, b) a,
> +#define E_(a, b) a
> +
> +enum netfs_read_trace { netfs_read_traces } __mode(byte);
> +enum netfs_rreq_trace { netfs_rreq_traces } __mode(byte);
> +enum netfs_sreq_trace { netfs_sreq_traces } __mode(byte);
> +enum netfs_failure { netfs_failures } __mode(byte);
> +

Should you undef EM and E_ here after creating these?

> +#endif
>  
>  /*
>   * Export enum symbols via userspace.
> 
> 

Looks fine otherwise:

Acked-by: Jeff Layton <jlayton@redhat.com>

