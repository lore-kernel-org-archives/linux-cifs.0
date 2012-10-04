From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: reinstate the forcegid option
Date: Thu, 4 Oct 2012 10:20:00 -0400
Message-ID: <CAFB9KM0=STBs4E1cOpKAHcEf3P519Nvcs+MnS+QbRYeOoAp=Hg@mail.gmail.com>
References: <1349294556-20656-1-git-send-email-jlayton@redhat.com>
	<506D8C16.6070408@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <506D8C16.6070408-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Oct 4, 2012 at 9:16 AM, Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:
> On 10/04/2012 01:32 AM, Jeff Layton wrote:
>> Apparently this was lost when we converted to the standard option
>> parser.
>>
>> Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Reported-by: Gregory Lee Bartholomew <gregory.lee.bartholomew-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>
> Oops, atleast a couple of options have been reported missing and fixed
> so far. Time to audit the new parsing code so that we fix them
> proactively before we get reports from users..?
>
>
> Thanks
> Suresh
>

Seems like every time we play with the parsing code an option gets
dropped.  It's difficult though because there are over 80 options at
this point.  :/
I'll take a look over the code too.

-- 
Peace and Blessings,
-Scott.
