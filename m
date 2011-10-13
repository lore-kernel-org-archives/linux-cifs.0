From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 2/3] cifs: warn about deprecation of /proc/fs/cifs/OplockEnabled
 interface
Date: Thu, 13 Oct 2011 10:18:12 +0530
Message-ID: <4E966D8C.30101@suse.com>
References: <4E953201.9060606@suse.com>	<CAH2r5mub6MNsq84pCHb048KQJs8QQucUWARropbQ8nh5DgL=uQ@mail.gmail.com> <CAH2r5ms5QbKiwTzjTbNBrQgpe=E68jd6xhoNJ32kCdvp7UK+Kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5ms5QbKiwTzjTbNBrQgpe=E68jd6xhoNJ32kCdvp7UK+Kw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/13/2011 04:22 AM, Steve French wrote:
> Minor clarification - the readme mentions
> 
> 	/proc/module/cifs/parameters/<param>
> 
> i.e. echo "value" > /proc/module/cifs/parameters/<param>
> 
> but in my system they are under /sys/module/....  not /proc/module/....

Sorry about this.. It is meant to be /sys/module/.. only. It was a typo.
Thanks for fixing it.


-Suresh
