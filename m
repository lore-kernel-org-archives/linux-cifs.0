From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/09] cifs: local caching support using FS-Cache
Date: Fri, 23 Jul 2010 10:03:03 -0500
Message-ID: <AANLkTinso+Lu81UF4akBr3VJHwt+Fo4JGdX4NjEYiLmi@mail.gmail.com>
References: <4C480F51.8070204@suse.de>
	<1278333663-30464-1-git-send-email-sjayaraman@suse.de>
	<4C3DF6BF.3070001@gmail.com>
	<AANLkTin2tKtkWTflrrzBMYBEd6SFr35uYUl1SmfYlj9W@mail.gmail.com>
	<4C3F35F7.8060408@suse.de>
	<1892.1279820400@redhat.com>
	<4C4983B0.5080804@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cachefs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C4983B0.5080804-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jul 23, 2010 at 6:57 AM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> On 07/22/2010 11:10 PM, David Howells wrote:
>> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>>
>>> As it can been seen, the performance while reading when data is cache
>>> hot (disk) is not great as the network link is a Gigabit ethernet (with
>>> server having working set in memory) which is mostly expected.
>>
>> That's what I see with NFS and AFS too.
>>
>>> (I could not get access to a slower network (say 100 Mb/s) where the real
>>> performance boost could be evident).
>>
>> ethtool?
>>
>
> Thanks for the pointer. Here are the results on a 100Mb/s network:
 <snip>
Excellent data - thx

> As noted by Andreas, the read performance with more number of clients
> would be more interesting as the cache can positively impact the
> scalability. However, I don't have a number of clients or know a way to
> simulate a large number of cifs clients.

You could simulate increased load by running multiple smbtorture
instances from each real client, and perhaps some local dbench like
activity run locally on the server.

> The cache also can positively
> impact the performance on heavily loaded network and/or server due to
> reduction of network calls to the server.

Reminds me a little about the discussions during the last few SMB2 plugfests:

http://channel9.msdn.com/posts/Darryl/Peer-Content-Branch-Caching-and-Retrieval-Presentation/

and an earlier one (I couldn't find the newer version of this talk)
http://channel9.msdn.com/pdc2008/ES23/

and


-- 
Thanks,

Steve
