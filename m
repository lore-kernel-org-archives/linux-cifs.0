From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [RFC][PATCH 04/10] cifs: define server-level cache index objects
 and register them with FS-Cache
Date: Wed, 23 Jun 2010 11:04:39 +0530
Message-ID: <4C219CEF.5000003@suse.de>
References: <yes>	<1277220198-3522-1-git-send-email-sjayaraman@suse.de> <20100622175214.4c56234f@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100622175214.4c56234f-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 06/23/2010 03:22 AM, Jeff Layton wrote:
> On Tue, 22 Jun 2010 20:53:18 +0530
> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> 
>> Define server-level cache index objects (as managed by TCP_ServerInfo structs).
>> Each server object is created in the CIFS top-level index object and is itself
>> an index into which superblock-level objects are inserted.
>>
>> Currently, the server objects are keyed by hostname.
>>
>> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>> ---
>>  fs/cifs/Makefile   |    2 +-
>>  fs/cifs/cache.c    |   25 +++++++++++++++++++++++++
>>  fs/cifs/cifsglob.h |    3 +++
>>  fs/cifs/connect.c  |    4 ++++
>>  fs/cifs/fscache.c  |   47 +++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/cifs/fscache.h  |   12 ++++++++++++
>>  6 files changed, 92 insertions(+), 1 deletion(-)
>>  create mode 100644 fs/cifs/fscache.c
>>
>> Index: cifs-2.6/fs/cifs/Makefile
>> ===================================================================
>> --- cifs-2.6.orig/fs/cifs/Makefile
>> +++ cifs-2.6/fs/cifs/Makefile
>> @@ -12,4 +12,4 @@ cifs-$(CONFIG_CIFS_UPCALL) += cifs_spneg
>>  
>>  cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o
>>  
>> -cifs-$(CONFIG_CIFS_FSCACHE) += cache.o
>> +cifs-$(CONFIG_CIFS_FSCACHE) += fscache.o cache.o
>> Index: cifs-2.6/fs/cifs/cache.c
>> ===================================================================
>> --- cifs-2.6.orig/fs/cifs/cache.c
>> +++ cifs-2.6/fs/cifs/cache.c
>> @@ -51,3 +51,28 @@ void cifs_fscache_unregister(void)
>>  	fscache_unregister_netfs(&cifs_fscache_netfs);
>>  }
>>  
>> +/*
>> + * Server object currently keyed by hostname
>> + */
>> +static uint16_t cifs_server_get_key(const void *cookie_netfs_data,
>> +				   void *buffer, uint16_t maxbuf)
>> +{
>> +	const struct TCP_Server_Info *server = cookie_netfs_data;
>> +	uint16_t len = strnlen(server->hostname, sizeof(server->hostname));
>> +
> 
> Would a tuple of address/family/port be a better choice here? Imagine I
> mount "foo" and then later mount "foor.bar.baz". If they are the same
> address and only the UNC differs, then you won't get the benefit of
> the cache, right?
> 

Good point. I'll fix it up when I do a respin.

Thanks,

-- 
Suresh Jayaraman
