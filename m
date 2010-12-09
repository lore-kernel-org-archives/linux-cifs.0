From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] cifs: Add information about noserverino
Date: Thu, 09 Dec 2010 17:10:28 +0530
Message-ID: <4D00C02C.4070006@suse.de>
References: <1291568855-22604-1-git-send-email-bernhard@bwalle.de>	<20101206095725.78422138@tlielax.poochiereds.net>	<20101206101214.52a24415@tlielax.poochiereds.net>	<20101206163506.56232lqqhc5c3co4@webmail.df.eu> <20101206103836.0714369a@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Bernhard Walle <bernhard-X9USDgGjgfuzQB+pC5nmwQ@public.gmane.org>, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101206103836.0714369a-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 12/06/2010 09:08 PM, Jeff Layton wrote:
> On Mon, 06 Dec 2010 16:35:06 +0100
> Bernhard Walle <bernhard-X9USDgGjgfuzQB+pC5nmwQ@public.gmane.org> wrote:
> 
>>
>> Zitat von Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>>
>>>
>>> I'm still not sure I like this patch however. It potentially means a
>>> lot of printk spam since these things have no ratelimiting. It also
>>> doesn't tell me anything about which server might be giving me grief.
>>>
>>> Maybe this should be turned into a cFYI?
>>
>> Well, if I see it in the kernel log, it doesn't matter if it's info or
>> something else.
>>
>>> The bottom line though is that running 32-bit applications that were
>>> built without -D_FILE_OFFSET_BITS=64 on a 64-bit kernel is a very bad
>>> idea. It would be nice to be able to alert users that things aren't
>>> working the way they expect, but I'm not sure this is the right place
>>> to do that.
>>
>> Well, but there *are* such application (in my case it was Softmaker Office
>> which is a proprietary word processor) and it's quite nice if you know
>> how you can workaround it when you encounter such a problem. That's all.
>>
> 
> Sure...but this problem is not limited to CIFS. Many modern filesystems
> use 64-bit inodes. Running this application on XFS or NFS for instance
> is likely to give you the same trouble. You just hit it on CIFS because
> the server happened to give you a very large inode number.
> 
> If we're going to add printk's for this situation, it probably ought to
> be in a more generic place.
> 

By generic place, did you mean at the VFS level? I think at VFS level,
there is little information about the Server or underlying fs and this
information doesn't seem too critical that VFS should warn/care much about.

May be sticking to a cFYI along with Server detail is a good idea?


-- 
Suresh Jayaraman
