From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: ALPHA: advice for a patch to CIFS
Date: Fri, 27 Jul 2012 15:11:18 -0500
Message-ID: <CAH2r5mursgTxp1VesL-MgMxWj=76M18B0zOuY8dLU9X=sXwtBQ@mail.gmail.com>
References: <7CE799CC0E4DE04B88D5FDF226E18AC2CDF8E31455@LONPMAILBOX01.citrite.net>
	<CAFB9KM05gZpoRSQb-QrDrXe0+zPK33k8OzL=Q2WKWWEZTAaLfQ@mail.gmail.com>
	<CAFB9KM0NKGFw0rtb3qt41oaufss7OEN9nP0z-amRMis3AWNWmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Frediano Ziglio <frediano.ziglio-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>,
	"sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFB9KM0NKGFw0rtb3qt41oaufss7OEN9nP0z-amRMis3AWNWmA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jul 27, 2012 at 2:50 PM, Scott Lovenberg
<scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Fri, Jul 27, 2012 at 3:42 PM, Scott Lovenberg
> <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>>
>> On Fri, Jul 27, 2012 at 3:13 PM, Frediano Ziglio
>> <frediano.ziglio-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org> wrote:
>>>
>>> Hi,
>>>   I'm currently trying to support utf-16 with characters not in plane 0.
>>>
>>> I'm currently end up with this patch. Currently is not against latest
>>> kernel but the problem still reside in last git kernel.
>>>
>>> wchar_t is currently 16bit so converting a utf8 encoded characters not
>>> in plane 0 (>= 0x10000) to wchar_t (that is calling char2uni) lead to a
>>> -EINVAL return. This patch detect utf8 in cifs_strtoUCS and add special
>>> code calling directly utf8_to_utf32.
>>>
>>> Does it sound a good patch or just a bad hack. Perhaps would be better
>>> to change char2uni converting to unicode_t (32bit) instead of wchar_t
>>> but probably many code have to be checked in order to make sure it does
>>> not lead to wrong conversions, overflows or other bad stuff.
>>>
>>> Is it worth working in this hacking way? I'd like to upstream this
>>> patch.


Terminology is confusing.   Refreshing my memory by looking at

http://en.wikipedia.org/wiki/Universal_Character_Set

are we talking about UTF-16 vs. UCS-2 (ie cases where a pair of
16 bit unicode characters are interpreted as one)?

IIRC there are a few languages where this helps, at least
since Windows XP when apparently it became more common.
and we have to support this in kernel.


> Just my $0.02, but there are a lot of magic numbers in this patch

Agreed.  The check vs. 3F and against the maximum unicode
value should be against #defined values which are easier to read.



-- 
Thanks,

Steve
