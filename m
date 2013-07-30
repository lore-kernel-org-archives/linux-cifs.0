From: Chen Gang <gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Correct comment about domainname length
Date: Tue, 30 Jul 2013 08:09:58 +0800
Message-ID: <51F70456.3050901@asianux.com>
References: <1374777285-25639-1-git-send-email-scott.lovenberg@gmail.com> <1374777285-25639-2-git-send-email-scott.lovenberg@gmail.com> <51F1C564.5070006@asianux.com> <CAFB9KM2zF9m4Y4vcDRkZpMfvWP8NQWYKQTeJTiwgVVVu=4M6Cw@mail.gmail.com> <51F5B708.4090404@asianux.com> <CACyXjPxffbb8VQ55mCWTCP-GDivijXVkHNwtkVTwgAmi1XMyQQ@mail.gmail.com> <20130729161709.19c52e0f@tlielax.poochiereds.net> <CAFB9KM3CxJcHdFPrGTW595hjNzvYnLgVA6F8J3EMdddz3n0ivw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFB9KM3CxJcHdFPrGTW595hjNzvYnLgVA6F8J3EMdddz3n0ivw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 07/30/2013 05:10 AM, Scott Lovenberg wrote:
> On Mon, Jul 29, 2013 at 4:17 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>>>> Still, how can we have a FQDN that's 256 characters long when the host
>>>>> name length can be 1024 characters long?
>>>>>
>>>>
>>>> Excuse me, I am not quite familiar about cifs, so can not provide
>>>> additional more information (I found it only by reading code).
>>>>
>>>> But I feel, it really need additional discussion and check by the
>>>> related experts (related members who are familiar with cifs).
>>>>
>>>> Welcome any members' suggestions and completions.
>>>>
>>>> Thanks.
>>>
>>> Come on guys, enough already. As per here:
>>> https://en.wikipedia.org/wiki/Domain_Name_System
>>>
>>> and a comment above the max len of the fully qualified domain name (FQDN) is
>>> 63 octets per label and 255 bytes per FQDN. This maximum includes 254
>>> bytes for the FQDN and one byte for the ending dot.
>>>
>>
>> Ok, I think I knew that at one point and paged it out. It does make one
>> wonder why NI_MAXHOST is so big though -- is that for some
>> internationalization scheme?
>>
>> --
>> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> I guess it works if you're storing as UTF-32 or wchar_t at 4 bytes per
> character. 256 characters * 4 bytes/char + 1 byte for NULL.  Microsoft
> seems to use the same value for NI_MAXHOST ref:
> http://msdn.microsoft.com/en-us/library/windows/desktop/ms738532(v=vs.85).aspx
> .
> 

As far as I know, the kernel implementation wants to use 255 + 1 as
character count, not bytes count for FQDN (256 bytes for 8-bit, 512
bytes for 16-bit, ...), it can be translated into uni-code or other
format within 255 + 1 character count.

May it be useful for our discussion ?

(BTW: if kernel really wants to do, I also suggest to check the kernel
implementation for it whether correct or not).


Thanks.
-- 
Chen Gang
