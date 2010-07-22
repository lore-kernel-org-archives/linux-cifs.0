From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: [PATCH 00/09] cifs: local caching support using FS-Cache
Date: Thu, 22 Jul 2010 16:49:20 -0600
Message-ID: <A55FDF07-DC44-4A5D-BDC4-ACC7D76CC753@dilger.ca>
References: <4C480F51.8070204@suse.de> <1278333663-30464-1-git-send-email-sjayaraman@suse.de> <4C3DF6BF.3070001@gmail.com> <AANLkTin2tKtkWTflrrzBMYBEd6SFr35uYUl1SmfYlj9W@mail.gmail.com> <4C3F35F7.8060408@suse.de> <1892.1279820400@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cachefs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1892.1279820400-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 2010-07-22, at 11:40, David Howells wrote:
> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>> As it can been seen, the performance while reading when data is cache
>> hot (disk) is not great as the network link is a Gigabit ethernet (with
>> server having working set in memory) which is mostly expected.
> 
> That's what I see with NFS and AFS too.
> 
>> (I could not get access to a slower network (say 100 Mb/s) where the real
>> performance boost could be evident).

More interesting than a slow network is testing with more clients.  10 clients should be able to get 10x the read performance from the client-local cache, probably more than the server's peak disk/network bandwidth.

Cheers, Andreas
