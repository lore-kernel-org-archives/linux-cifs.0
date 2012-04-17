From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] automake: add -Werror to CFLAGS
Date: Tue, 17 Apr 2012 11:00:07 +0530
Message-ID: <4F8CFFDF.9010509@suse.com>
References: <1334600010-27430-1-git-send-email-jlayton@samba.org> <CAH2r5mu5h+QWq8a3jjE6HBZUYvyYW_a74vPgg0nOqhRgzwU+HA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mu5h+QWq8a3jjE6HBZUYvyYW_a74vPgg0nOqhRgzwU+HA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 04/17/2012 03:03 AM, Steve French wrote:
> Good idea - thx
> 
> On Mon, Apr 16, 2012 at 1:13 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>> With the recent patch to fix the warnings in asn1.c, cifs-utils now
>> builds without any warnings. Ban them henceforth by adding -Werror for
>> builds.
>>
>> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> ---
>>  Makefile.am |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/Makefile.am b/Makefile.am
>> index 17ad8e1..d95142a 100644
>> --- a/Makefile.am
>> +++ b/Makefile.am
>> @@ -1,4 +1,4 @@
>> -AM_CFLAGS = -Wall -Wextra
>> +AM_CFLAGS = -Wall -Wextra -Werror
>>  ACLOCAL_AMFLAGS = -I aclocal

Any thoughts on making a similar change to the cifs kernel module
Makefile as well?

I see from the sources that some of arch/ code, a few drivers and perf
are already using it. Perf Makefile treats warnings as errors unless
directed not to and there is a flag to disable treating any warnings as
error (for e.g. by passing WERROR=0).


Suresh
