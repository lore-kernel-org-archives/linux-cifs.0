From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Re: CIFS endless console spammage in 2.6.38.7
Date: Wed, 01 Jun 2011 11:07:58 -0700
Message-ID: <4DE67FFE.3040907@candelatech.com>
References: <4DE5385C.1030808@candelatech.com>	<BANLkTik+Z32vDVjB3_Rt7iPrqpJPJYnpwA@mail.gmail.com>	<4DE54561.1090906@candelatech.com>	<20110531164408.178eeebf@tlielax.poochiereds.net>	<BANLkTinyb=tekDwPLqxuSqyQfrgc8MykCw@mail.gmail.com>	<4DE55537.5040705@candelatech.com>	<BANLkTimNgW-Ff_50HeuFqmS7PXXjuLmYVw@mail.gmail.com> <20110601140139.079287da@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110601140139.079287da-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 06/01/2011 11:01 AM, Jeff Layton wrote:
> On Tue, 31 May 2011 15:54:36 -0500
> Steve French<smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>  wrote:
>
>> we will have more info when run with he quick and dirty modified logging
>>
>
> I'm not sure what that is, but what may be helpful is to launch a
> kernel debugger when this happens, track down the TCP_Server_Info and
> see what the state of the socket that hangs off of it is. If it's a
> NULL pointer or an already-closed socket, then that may help point the
> way to the root cause.

We put in some WARN_ON calls to get stack traces, and some other
connection related logging.  We should get a WARN_ON if the socket is NULL.

We were not able to reproduce the problem last night..the file servers did
screw up, but the CIFS clients acted normally.

Thanks,
Ben

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
