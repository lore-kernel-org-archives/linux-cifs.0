From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [RFC][PATCH 03/10] cifs: register CIFS for caching
Date: Fri, 25 Jun 2010 16:26:22 +0530
Message-ID: <4C248B56.8030207@suse.de>
References: <1277220189-3485-1-git-send-email-sjayaraman@suse.de> <yes> <9603.1277311877@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9603.1277311877-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 06/23/2010 10:21 PM, David Howells wrote:
> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> 
>> +	rc = cifs_fscache_register();
>> +	if (rc)
>> +		goto out;
>> +
>>  	rc = cifs_init_inodecache();
>>  	if (rc)
>>  		goto out_clean_proc;
>> @@ -949,8 +954,10 @@ init_cifs(void)
>>  	cifs_destroy_mids();
>>   out_destroy_inodecache:
>>  	cifs_destroy_inodecache();
>> +	cifs_fscache_unregister();
>>   out_clean_proc:
> 
> This is incorrect.  You need to call cifs_fscache_unregister() if
> cifs_init_inodecache() fails.
> 

Doh! I'll fix it.


-- 
Suresh Jayaraman
