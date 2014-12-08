From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 0/3] cifs: small clean up series
Date: Sun, 7 Dec 2014 23:35:06 -0600
Message-ID: <CAH2r5mtQZdHn5hPHJLpppgjBfDgqx5k7G62zqJtQsaN6OEwFgQ@mail.gmail.com>
References: <1409147384-20389-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1413986632.2396.38.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>,
	Alexander Bokovoy <ab-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1413986632.2396.38.camel-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

series merged into cifs-2.6.git

On Wed, Oct 22, 2014 at 9:03 AM, Andy Shevchenko
<andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> On Wed, 2014-08-27 at 16:49 +0300, Andy Shevchenko wrote:
>> This is small clean up series against CIFS kernel module.
>>
>
> Ping? Is there any comments?
>
>> Changes since v3:
>> - rebase on top of recent linux-next
>>
>> Changes since v2:
>> - patch 1 got ACK and Reviwed-by tags
>> - patch 2 incorporates new piece of code similar that it used to have already,
>>   thus tags were dropped for this round
>> - new patch 3
>>
>> Andy Shevchenko (3):
>>   cifs: call strtobool instead of custom implementation
>>   cifs: convert to print_hex_dump() instead of custom implementation
>>   cifs: convert printk(LEVEL...) to pr_<level>
>>
>>  fs/cifs/cifs_debug.c | 77 ++++++++++++++++++++++------------------------------
>>  fs/cifs/cifs_debug.h |  7 ++---
>>  fs/cifs/connect.c    | 51 ++++++++++++----------------------
>>  fs/cifs/misc.c       | 32 ++--------------------
>>  fs/cifs/transport.c  |  4 +--
>>  5 files changed, 58 insertions(+), 113 deletions(-)
>>
>
>
> --
> Andy Shevchenko <andriy.shevchenko-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Intel Finland Oy
>



-- 
Thanks,

Steve
