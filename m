From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Backported cifs module
Date: Wed, 08 Jun 2011 19:07:34 +0530
Message-ID: <4DEF7B1E.7060008@suse.de>
References: <201106072346.02460.johnmiller@email.it> <20110608085143.729e9c92@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: JM <johnmiller-06ZeP6ie+xM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110608085143.729e9c92-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 06/08/2011 06:21 PM, Jeff Layton wrote:
> On Tue, 7 Jun 2011 23:46:02 +0200
> JM <johnmiller-06ZeP6ie+xM@public.gmane.org> wrote:
> 
>> Hi, 
>> sorry to disturb you directly, Steve French told me that you have
>> backported the cifs module to older kernels.
>> According to him, the latest release should fix some reading
>> slowness that I have experienced.
>> I am available if you need some testers too. 
>>
>> JM
>>
>> PS: I am using
>> opensuse with their 2.6.37.6 kernel.

Have you create a bug report against openSUSE-11.4 (I guess)? If yes,
could please add me in Cc? If not, can you create a bug report and
include me in Cc, I'll take a look at it.

Thanks,

> (cc'ing Steve and linux-cifs ml...)
> 
> The only commit I know of that would affect read performance is
> 2b6c26a0. A quick look at 2.6.37.y tree shows that it doesn't have that
> patch.
> 


-- 
Suresh Jayaraman
