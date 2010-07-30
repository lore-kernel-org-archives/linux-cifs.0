From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 1/2] cifs: show features compiled in as part of DebugData
Date: Fri, 30 Jul 2010 22:15:07 +0530
Message-ID: <4C530193.2080001@suse.de>
References: <1280494556.19538.7.camel@jay-t60p> <AANLkTikgA8mXTcX-i3avjuQygrekicntcy3P2NBW5QuB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikgA8mXTcX-i3avjuQygrekicntcy3P2NBW5QuB-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 07/30/2010 08:09 PM, Steve French wrote:
> If someone ever wants a script to parse this - seems like your
> (original?) idea of putting this in /proc/fs/cifs/features instead of
> /proc/fs/cifs/DebugData (which has various other pieces of debug
> information) could be easier.

I'm not sure whether a seperate proc file for features is justified or
not.. Since the primary aim of introducing this is to faciliate
debugging and provide references in documentation etc.., looks like it
is a suitable candidate to DebugData.. but that is a matter of
preference.. Feel free to go ahead with any of these versions..

Thanks,

> On Fri, Jul 30, 2010 at 7:55 AM, Suresh Jayaraman <sjayaraman-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org> wrote:
>> Fixed the nit pointed out by Jeff.
>>
>> From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>> Subject: [PATCH 1/2] cifs: show features compiled in as part of DebugData
>>
>> This patch adds the features that are compiled in to the CIFS debugging data
>> as shown below:
> 
> 


-- 
Suresh Jayaraman
