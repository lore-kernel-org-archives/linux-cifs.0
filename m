From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 00/09] cifs: local caching support using FS-Cache
Date: Fri, 23 Jul 2010 17:27:36 +0530
Message-ID: <4C4983B0.5080804@suse.de>
References: <4C480F51.8070204@suse.de> <1278333663-30464-1-git-send-email-sjayaraman@suse.de> <4C3DF6BF.3070001@gmail.com> <AANLkTin2tKtkWTflrrzBMYBEd6SFr35uYUl1SmfYlj9W@mail.gmail.com> <4C3F35F7.8060408@suse.de> <1892.1279820400@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cachefs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1892.1279820400-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 07/22/2010 11:10 PM, David Howells wrote:
> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> 
>> As it can been seen, the performance while reading when data is cache
>> hot (disk) is not great as the network link is a Gigabit ethernet (with
>> server having working set in memory) which is mostly expected.
> 
> That's what I see with NFS and AFS too.
> 
>> (I could not get access to a slower network (say 100 Mb/s) where the real
>> performance boost could be evident).
> 
> ethtool?
> 

Thanks for the pointer. Here are the results on a 100Mb/s network:


Environment
------------

I'm using my T60p laptop as the CIFS server (running Samba) and one of
my test machines as CIFS client, connected over an ethernet of reported
speed 1000 Mb/s. ethtool was used to throttle the speed to 100 Mb/s. The
TCP bandwidth as seen by a pair of netcats between the client and the
server is about 89.555 Mb/s.

Client has a 2.8 GHz Pentium D CPU with 2GB RAM
Server has a 2.33GHz Core2 CPU (T7600) with 2GB RAM


Test
-----
The benchmark involves pulling a 200 MB file over CIFS to the client
using cat to /dev/zero under `time'. The wall clock time reported was
recorded.

Note
----
   - The client was rebooted after each test, but the server was not.
   - The entire file was loaded into RAM on the server before each test
     to eliminate disk I/O latencies on that end.
   - A seperate partition of size 4GB has been dedicated for the cache.
   - There were no other CIFS client that was accessing the Server when
     the tests were performed.


First, the test was run on the server twice and the second result was
recorded (noted as Server below).

Secondly, the client was rebooted and the test was run with cachefiled
not running and was recorded (noted as None below).

Next, the client was rebooted, the cache contents (if any) were erased
with mkfs.ext3 and test was run again with cachefilesd running (noted as
COLD)

Next the client was rebooted, tests were run with cachefilesd running
this time with a populated disk cache (noted as HOT).

Finally, the test was run again without unmounting, stopping cachefiled
or rebooting to ensure pagecache is valid (noted as PGCACHE).

The benchmark was repeated twice:

Cache (state)	Run #1		Run#2
=============  =======		=======
Server		 0.104 s	 0.107 s
None		26.042 s	26.576 s
COLD		26.703 s        26.787 s
HOT		 5.115 s	 5.147 s
PGCACHE		 0.091 s	 0.092 s

I think the results are inline with the expectations given the speed
reported by netcat.

As noted by Andreas, the read performance with more number of clients
would be more interesting as the cache can positively impact the
scalability. However, I don't have a number of clients or know a way to
simulate a large number of cifs clients. The cache also can positively
impact the performance on heavily loaded network and/or server due to
reduction of network calls to the server.

Also, it should be noted that local caching is not for all workloads and
a few workloads could suffer (for e.g. read-once type workloads).


Thanks,

-- 
Suresh Jayaraman
