From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: 2.6.36 merge plans
Date: Tue, 03 Aug 2010 10:25:06 +0530
Message-ID: <4C57A12A.1030404@suse.de>
References: <AANLkTim2UcxAXuR0K8JexGAIq3UoEj1KMH4JMGLnJ72D@mail.gmail.com>	<20100630141755.4ac97143@tlielax.poochiereds.net>	<4C2CDD02.2090403@suse.de>	<AANLkTilEg0zG1DD9fF9T890nFhaqNNeLta1-RAo9iKpM@mail.gmail.com>	<AANLkTimTjDJeR7ktNcJpPSc-zioHrndPwPxb98HAYgpY@mail.gmail.com>	<20100701195247.71c3f572@tlielax.poochiereds.net>	<AANLkTi=X5PyZLdaJj_ikSv7HUNtfmQYhPc50mecx_mMj@mail.gmail.com>	<20100802134654.3ac129e7@tlielax.poochiereds.net> <AANLkTim-fb4obi7KBxpUsyeYi4eAQmTuSAx+14jOE3kr@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim-fb4obi7KBxpUsyeYi4eAQmTuSAx+14jOE3kr-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


On 08/03/2010 03:44 AM, Steve French wrote:
> On Mon, Aug 2, 2010 at 12:46 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> On Fri, 23 Jul 2010 17:19:29 -0500
>> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> I had no problem with the last patch in your tree, but wanted
> to test the one before it (the creation time patch) before merging,
> and thought it would be easier to merge them in order since
> they hit at least one file in common.
> 
> Backing out the one patch I wanted to test more with Samba (the
> creation time one)
> I made a big merge request today to clear the 27 patches queued up already,
> and expect to merge your last two and Dave's DNS one and probably
> Shirish's (if they can be tested/reviewed more) this week.
> 

Steve, are you considering the following patches as well..?

cifs: show features compiled in as part of DebugData
cifs: update README

(I think there are no outstanding issues left unaddressed).


Thanks,

-- 
Suresh Jayaraman
