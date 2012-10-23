From: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Subject: Re: CIFS: Deprecating NFS mounting syntax in mount.cifs
Date: Tue, 23 Oct 2012 21:23:08 +0200
Message-ID: <5086EE9C.7030800@steve-ss.com>
References: <1350583669-12118-1-git-send-email-scott.lovenberg@gmail.com> <5086BE25.8080102@gmail.com> <5086CA29.8030305@steve-ss.com> <CAFB9KM26Qk-MC+_w-Q4Rrg3X0nMJ2efS72Y+GjWckgf9g6fzEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFB9KM26Qk-MC+_w-Q4Rrg3X0nMJ2efS72Y+GjWckgf9g6fzEg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/23/2012 07:27 PM, Scott Lovenberg wrote:
> On Tue, Oct 23, 2012 at 12:47 PM, steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org> wrote:
>> On 10/23/2012 05:56 PM, Scott Lovenberg wrote:
>>> On 10/18/2012 2:07 PM, scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>>> no one has objected (or really said anything).  Can we merge this patch?
>>> --
>> Hi
>> I'm just trying to represent users. Can we take this to user level by giving
>> an example of what will work and what will not work after the patch?
>>
> I should clarify, this patch doesn't change the behavior of the mount
> utility, it just warns the user that in future releases the syntax
> that they are using will be removed.  The patch to remove the behavior
> is going to be in a later release.
>
> What will work is any path that begins with "//" or "\\" which is a
> normal UNC.  So your normal "//server/share" path is fine.  NFS syntax
> allows for you to specify the path like "server:/share".  That syntax
> will no longer work in cifs-utils 6.0.
>
>> For example, the Linux automounter.
>>
>> Currently, we have this map:
>> * -fstype=cifs,rw,sec=krb5 ://myserver/myshare/&
>>
>> Are you talking about the difference between that and this:
>> * -fstype=cifs,rw,sec=krb5 myserver:/myshare/&
>>
>> Question: will I need to change anything due to this patch?
>>
> Quite the opposite, the "//myserver/myshare" is correct,
> "myserver:/myshare" will no longer work.  The ':' is part of the
> automounter's map syntax.  It will use the path "//myserver/myshare".
>
Hi Scott, hi everyone
Yeah, that's fine.
Does this clear up the issue with the ':'? I should have made it clearer 
that I was referring to autofs and not mounting e.g. from fstab. I just 
tried the automounter on cifs without the ':' and it doesn't work.

Would it perhaps help to put a message in the logs when it fails, rather 
than silence? Or maybe that's more of a question for the autofs guys.
Cheers,
Steve
