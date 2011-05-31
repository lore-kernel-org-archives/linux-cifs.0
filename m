From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Re: CIFS endless console spammage in 2.6.38.7
Date: Tue, 31 May 2011 13:53:11 -0700
Message-ID: <4DE55537.5040705@candelatech.com>
References: <4DE5385C.1030808@candelatech.com>	<BANLkTik+Z32vDVjB3_Rt7iPrqpJPJYnpwA@mail.gmail.com>	<4DE54561.1090906@candelatech.com>	<20110531164408.178eeebf@tlielax.poochiereds.net> <BANLkTinyb=tekDwPLqxuSqyQfrgc8MykCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTinyb=tekDwPLqxuSqyQfrgc8MykCw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 05/31/2011 01:51 PM, Steve French wrote:
> On Tue, May 31, 2011 at 3:44 PM, Jeff Layton<jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>  wrote:

>> Fixing it looks to be anything but trivial. I'm not even quite sure how
>> to approach it at this point. Suggestions welcome.
>
> I thought the kernel was more recent than that - how recent is the kernel here?
>
> I think something related to cifs_sendv returning ENOTSOCK immediately
> when not reconnected could be related.

My kernel is 2.6.38.7, quite recent.  We're using the bind-to-local-IP
features too, but not sure that matters.

Ben

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
