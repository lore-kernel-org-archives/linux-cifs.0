Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A83FC433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 23 May 2022 01:21:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiEWBVh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 22 May 2022 21:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345723AbiEWBVh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 22 May 2022 21:21:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD4FDA45A
        for <linux-cifs@vger.kernel.org>; Sun, 22 May 2022 18:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653268894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QeksuAmJWYaEi0TQFOkREQ3m4yGhTUgNwHT42YPdtQw=;
        b=RuNdgxpSHRi0aU+IsvZiTfBrJlVUwFNM3ifxHiv+YhmOSxpqlnBXnAAnOXas5EizN6Ov4c
        ngsQMBGJs6kKGUYRjoCEQXqpTEulCumZEunebJ9++52iXVmmBJlV1M+2touoeQzj3GugCN
        ZRFXvJ4e9q3IPA1nsVazYF1LFpAyiqo=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-519-Xld-WYIqPGClVjzOAe6Nog-1; Sun, 22 May 2022 21:21:33 -0400
X-MC-Unique: Xld-WYIqPGClVjzOAe6Nog-1
Received: by mail-pf1-f198.google.com with SMTP id d6-20020aa78e46000000b0050cfcce2fefso5395749pfr.18
        for <linux-cifs@vger.kernel.org>; Sun, 22 May 2022 18:21:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=QeksuAmJWYaEi0TQFOkREQ3m4yGhTUgNwHT42YPdtQw=;
        b=aFF5r/IHeP5Ho2aHc9/qi6MEGR4PMyGV7uH/bHVCrFHNVDn6uFxzH0kH0f+6fgWspf
         KbDe1I/FeuZrvboiR6IW9yHmtJNIn7r+g7+1FIfqAopaQw7CsuW4F5E1/R+aE9RIR6Xv
         XyV8bK97Znc6fJcRd+PFreeUrGWUBYscAmP632YDiMj37XNzJ44nBcCB2K+lwG2RjhlF
         1NiPhScbTI7n9TwV2cPwkM9inLBE4nM1fznEnvdG2wLqVnJKmbi0ooMKosZGU8+32CNW
         pxsT22B6PZXNTUVTZHSmfJF/pCs32zJ2XpM30FuWagTif4K0H9M3L7FbYTQEIsmeEiDT
         2xYQ==
X-Gm-Message-State: AOAM533ULYIUSJzrRzmeog+UGpVQDp42cEZ7PvcW0LPU3mxmlDDgpYC0
        cw4gH5SIfuZADcbbhLcOM+rQPN8dQomSM+Okwf9Ke7bocXqdHXXuvGEYTetGTD5SYrQm9VizQeb
        S4+tBtZxhztljnekiRI8w2w==
X-Received: by 2002:a17:90a:d903:b0:1df:a0da:20f0 with SMTP id c3-20020a17090ad90300b001dfa0da20f0mr23423505pjv.182.1653268892049;
        Sun, 22 May 2022 18:21:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyNU9E4cxJdDWjM4BXDRtnTqV2SL+V24TO114v2WBtj4cxB6iy5/XCHNte78zG0bsganOQmLw==
X-Received: by 2002:a17:90a:d903:b0:1df:a0da:20f0 with SMTP id c3-20020a17090ad90300b001dfa0da20f0mr23423486pjv.182.1653268891813;
        Sun, 22 May 2022 18:21:31 -0700 (PDT)
Received: from [10.72.12.81] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a15-20020a170902710f00b0015e8d4eb283sm3677403pll.205.2022.05.22.18.21.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 May 2022 18:21:31 -0700 (PDT)
Subject: Re: [PATCH 1/2] netfs: ->cleanup() op is always given a rreq pointer
 now
To:     Jeff Layton <jlayton@kernel.org>,
        David Howells <dhowells@redhat.com>
Cc:     Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        David Wysochanski <dwysocha@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        v9fs-developer@lists.sourceforge.net, ceph-devel@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-cachefs@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <165296980082.3595490.3561111064004493810.stgit@warthog.procyon.org.uk>
 <e5f6fee5518ce8e1b4fc5aa7038de1617a341c2f.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <72a1cb54-4632-659d-e6ec-2d754ab2fc28@redhat.com>
Date:   Mon, 23 May 2022 09:21:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <e5f6fee5518ce8e1b4fc5aa7038de1617a341c2f.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


On 5/19/22 11:36 PM, Jeff Layton wrote:
> On Thu, 2022-05-19 at 15:16 +0100, David Howells wrote:
>> As the ->init() netfs op is now used to set up the netfslib I/O request
>> rather than passing stuff in, thereby allowing the netfslib functions to be
>> pointed at directly by the address_space_operations struct, we're always
>> going to be able to pass an I/O request pointer to the cleanup function.
>>
>> Therefore, change the ->cleanup() function to take a pointer to the I/O
>> request rather than taking a pointer to the network filesystem's
>> address_space and a piece of private data.
>>
>> Also, rename ->cleanup() to ->free_request() to match the ->init_request()
>> function.
>>
>> Signed-off-by: David Howells <dhowells@redhat.com>
>> cc: Jeff Layton <jlayton@kernel.org>
>> cc: Steve French <sfrench@samba.org>
>> cc: Dominique Martinet <asmadeus@codewreck.org>
>> cc: Jeff Layton <jlayton@redhat.com>
>> cc: David Wysochanski <dwysocha@redhat.com>
>> cc: Ilya Dryomov <idryomov@gmail.com>
>> cc: v9fs-developer@lists.sourceforge.net
>> cc: ceph-devel@vger.kernel.org
>> cc: linux-afs@lists.infradead.org
>> cc: linux-cifs@vger.kernel.org
>> cc: linux-cachefs@redhat.com
>> cc: linux-fsdevel@vger.kernel.org
>> ---
>>
>>   fs/9p/vfs_addr.c      |   11 +++++------
>>   fs/afs/file.c         |    6 +++---
>>   fs/ceph/addr.c        |    9 ++++-----
>>   fs/netfs/objects.c    |    8 +++++---
>>   include/linux/netfs.h |    4 +++-
>>   5 files changed, 20 insertions(+), 18 deletions(-)
>>
>> diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
>> index 501128188343..002c482794dc 100644
>> --- a/fs/9p/vfs_addr.c
>> +++ b/fs/9p/vfs_addr.c
>> @@ -66,13 +66,12 @@ static int v9fs_init_request(struct netfs_io_request *rreq, struct file *file)
>>   }
>>   
>>   /**
>> - * v9fs_req_cleanup - Cleanup request initialized by v9fs_init_request
>> - * @mapping: unused mapping of request to cleanup
>> - * @priv: private data to cleanup, a fid, guaranted non-null.
>> + * v9fs_free_request - Cleanup request initialized by v9fs_init_rreq
>> + * @rreq: The I/O request to clean up
>>    */
>> -static void v9fs_req_cleanup(struct address_space *mapping, void *priv)
>> +static void v9fs_free_request(struct netfs_io_request *rreq)
>>   {
>> -	struct p9_fid *fid = priv;
>> +	struct p9_fid *fid = rreq->netfs_priv;
>>   
>>   	p9_client_clunk(fid);
>>   }
>> @@ -94,9 +93,9 @@ static int v9fs_begin_cache_operation(struct netfs_io_request *rreq)
>>   
>>   const struct netfs_request_ops v9fs_req_ops = {
>>   	.init_request		= v9fs_init_request,
>> +	.free_request		= v9fs_free_request,
>>   	.begin_cache_operation	= v9fs_begin_cache_operation,
>>   	.issue_read		= v9fs_issue_read,
>> -	.cleanup		= v9fs_req_cleanup,
>>   };
>>   
>>   /**
>> diff --git a/fs/afs/file.c b/fs/afs/file.c
>> index 26292a110a8f..b9ca72fbbcf9 100644
>> --- a/fs/afs/file.c
>> +++ b/fs/afs/file.c
>> @@ -383,17 +383,17 @@ static int afs_check_write_begin(struct file *file, loff_t pos, unsigned len,
>>   	return test_bit(AFS_VNODE_DELETED, &vnode->flags) ? -ESTALE : 0;
>>   }
>>   
>> -static void afs_priv_cleanup(struct address_space *mapping, void *netfs_priv)
>> +static void afs_free_request(struct netfs_io_request *rreq)
>>   {
>> -	key_put(netfs_priv);
>> +	key_put(rreq->netfs_priv);
>>   }
>>   
>>   const struct netfs_request_ops afs_req_ops = {
>>   	.init_request		= afs_init_request,
>> +	.free_request		= afs_free_request,
>>   	.begin_cache_operation	= afs_begin_cache_operation,
>>   	.check_write_begin	= afs_check_write_begin,
>>   	.issue_read		= afs_issue_read,
>> -	.cleanup		= afs_priv_cleanup,
>>   };
>>   
>>   int afs_write_inode(struct inode *inode, struct writeback_control *wbc)
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index b6edcf89a429..ee8c1b099c4f 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -392,11 +392,10 @@ static int ceph_init_request(struct netfs_io_request *rreq, struct file *file)
>>   	return 0;
>>   }
>>   
>> -static void ceph_readahead_cleanup(struct address_space *mapping, void *priv)
>> +static void ceph_netfs_free_request(struct netfs_io_request *rreq)
>>   {
>> -	struct inode *inode = mapping->host;
>> -	struct ceph_inode_info *ci = ceph_inode(inode);
>> -	int got = (uintptr_t)priv;
>> +	struct ceph_inode_info *ci = ceph_inode(rreq->inode);
>> +	int got = (uintptr_t)rreq->netfs_priv;
>>   
>>   	if (got)
>>   		ceph_put_cap_refs(ci, got);
>> @@ -404,12 +403,12 @@ static void ceph_readahead_cleanup(struct address_space *mapping, void *priv)
>>   
>>   const struct netfs_request_ops ceph_netfs_ops = {
>>   	.init_request		= ceph_init_request,
>> +	.free_request		= ceph_netfs_free_request,
>>   	.begin_cache_operation	= ceph_begin_cache_operation,
>>   	.issue_read		= ceph_netfs_issue_read,
>>   	.expand_readahead	= ceph_netfs_expand_readahead,
>>   	.clamp_length		= ceph_netfs_clamp_length,
>>   	.check_write_begin	= ceph_netfs_check_write_begin,
>> -	.cleanup		= ceph_readahead_cleanup,
>>   };
>>   
>>   #ifdef CONFIG_CEPH_FSCACHE
>> diff --git a/fs/netfs/objects.c b/fs/netfs/objects.c
>> index e86107b30ba4..d6b8c0cbeb7c 100644
>> --- a/fs/netfs/objects.c
>> +++ b/fs/netfs/objects.c
>> @@ -75,10 +75,10 @@ static void netfs_free_request(struct work_struct *work)
>>   	struct netfs_io_request *rreq =
>>   		container_of(work, struct netfs_io_request, work);
>>   
>> -	netfs_clear_subrequests(rreq, false);
>> -	if (rreq->netfs_priv)
>> -		rreq->netfs_ops->cleanup(rreq->mapping, rreq->netfs_priv);
>>   	trace_netfs_rreq(rreq, netfs_rreq_trace_free);
>> +	netfs_clear_subrequests(rreq, false);
>> +	if (rreq->netfs_ops->free_request)
>> +		rreq->netfs_ops->free_request(rreq);
>>   	if (rreq->cache_resources.ops)
>>   		rreq->cache_resources.ops->end_operation(&rreq->cache_resources);
>>   	kfree(rreq);
>> @@ -140,6 +140,8 @@ static void netfs_free_subrequest(struct netfs_io_subrequest *subreq,
>>   	struct netfs_io_request *rreq = subreq->rreq;
>>   
>>   	trace_netfs_sreq(subreq, netfs_sreq_trace_free);
>> +	if (rreq->netfs_ops->free_subrequest)
>> +		rreq->netfs_ops->free_subrequest(subreq);
>>   	kfree(subreq);
>>   	netfs_stat_d(&netfs_n_rh_sreq);
>>   	netfs_put_request(rreq, was_async, netfs_rreq_trace_put_subreq);
>> diff --git a/include/linux/netfs.h b/include/linux/netfs.h
>> index c7bf1eaf51d5..1970c21b4f80 100644
>> --- a/include/linux/netfs.h
>> +++ b/include/linux/netfs.h
>> @@ -204,7 +204,10 @@ struct netfs_io_request {
>>    */
>>   struct netfs_request_ops {
>>   	int (*init_request)(struct netfs_io_request *rreq, struct file *file);
>> +	void (*free_request)(struct netfs_io_request *rreq);
>> +	void (*free_subrequest)(struct netfs_io_subrequest *rreq);
> Do we need free_subrequest? It looks like nothing defines it in this
> series.

If this is needed in future, or shall we do this in 
netfs_clear_subrequests() ?

-- Xiubo

>>   	int (*begin_cache_operation)(struct netfs_io_request *rreq);
>> +
>>   	void (*expand_readahead)(struct netfs_io_request *rreq);
>>   	bool (*clamp_length)(struct netfs_io_subrequest *subreq);
>>   	void (*issue_read)(struct netfs_io_subrequest *subreq);
>> @@ -212,7 +215,6 @@ struct netfs_request_ops {
>>   	int (*check_write_begin)(struct file *file, loff_t pos, unsigned len,
>>   				 struct folio *folio, void **_fsdata);
>>   	void (*done)(struct netfs_io_request *rreq);
>> -	void (*cleanup)(struct address_space *mapping, void *netfs_priv);
>>   };
>>   
>>   /*
>>
>>

