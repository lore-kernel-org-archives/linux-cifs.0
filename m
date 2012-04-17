From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] docs: update to project resources in README
Date: Tue, 17 Apr 2012 19:03:50 +0530
Message-ID: <4F8D713E.2010301@suse.com>
References: <1334600063-27527-1-git-send-email-jlayton@samba.org> <4F8CF4A7.5070109@suse.com> <20120417074710.0620bf9c@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org, jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120417074710.0620bf9c-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 04/17/2012 05:17 PM, Jeff Layton wrote:
> On Tue, 17 Apr 2012 10:12:15 +0530
> Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:
> 
>> On 04/16/2012 11:44 PM, Jeff Layton wrote:
>>> diff --git a/README b/README
>>> index 619dc3f..befe4b3 100644
>>> --- a/README
>>> +++ b/README
>>> @@ -5,8 +5,8 @@ separate package.
>>>  
>>>  0. PROJECT RESOURCES
>>>  
>>> -    Home page: http://linux-cifs.samba.org/cifs-utils/
>>> -    Mailing list: linux-cifs-client-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
>>> +    Home page: http://http://wiki.samba.org/index.php/LinuxCIFS_utils
>>> +    Mailing list: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>      Maintainer: cifs-utils-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
>>
>> The "Maintainer" information seems out of date as well. Could you please
>> update this as well when you are at it?
>>
>>
> 
> No, that's a valid email alias that I had Metze add when I first
> branched off cifs-utils. It just forwards to me at the moment.
> 
> If I ever need to hand off maintainership of the project to someone
> else, then that'll be one less publicly visible change that we'll need
> to make. I'd rather keep that in place unless there's a good reason to
> change it. 
> 

Ok, didn't know that. Typically, one would expect to see the
maintainer's email address there and it is not obvious in this case.
There is a slight chance that someone looking at it might consider that
there is no active maintainer but just an alias.

In my personal opinion, users understand that Maintainers change during
the course of the project (which happens not so often) and there is no
need to mask the name of the Maintainer. Just my thoughts...


Suresh
