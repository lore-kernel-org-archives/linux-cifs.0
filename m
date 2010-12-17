From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 0/4] cifs: CONFIG_CIFS_EXPERIMENTAL removal (try #2)
Date: Fri, 17 Dec 2010 21:41:53 +0530
Message-ID: <4D0B8BC9.70801@suse.de>
References: <1291820625-20907-1-git-send-email-jlayton@redhat.com>	<4D0B8196.3050102@suse.de> <20101217103717.22ce07b1@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101217103717.22ce07b1-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 12/17/2010 09:07 PM, Jeff Layton wrote:
> On Fri, 17 Dec 2010 20:58:22 +0530
> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> 
>> On 12/08/2010 08:33 PM, Jeff Layton wrote:
>>> This is the second version of this patchset. The changes since the last
>>> set are:
>>>
>>> 1) The patch to remove "/proc/fs/cifs/Experimental" did not remove the
>>> deregistration of that file, which caused a warning on rmmod.
>>>
>>> 2) The patch to remove "/proc/fs/cifs/Experimental" now adds a new
>>> module parameter so that people relying on it to allow zero-copy
>>> writes with signing have a way to continue using that.
>>>
>>> A modified description of the set follows...
>>>
>>> The CONFIG_CIFS_EXPERIMENTAL KConfig option is the sort of thing that
>>> gives distro packagers nightmares. The things that live under it are
>>> impossible to predict for someone who isn't following development
>>> upstream.
>>
>> In general, I like the overall idea of removing heavily overloaded
>> CIFS_EXPERIMENTAL config option. It's true that it was at times hard to
>> narrow down suspect once this option is enabled.
>>
>> However, the dependency of a few options on EXPERIMENTAL (fscache and
>> acl) is not removed. CIFS_FSCACHE can be marked as not dependent on
>> EXPERIMENTAL. Not sure about CIFS_ACL though.
>>
>> Can you make this patchset or a subsequent patch accomodates this change
>> too?
>>
> 
> There's a difference between CONFIG_CIFS_EXPERIMENTAL and
> CONFIG_EXPERIMENTAL. Those options depend on the latter. I'm removing
> the former. I think it's still appropriate to mark these new features
> as EXPERIMENTAL and to leave them dependent on CONFIG_EXPERIMENTAL.

Doh, I missed it. Indeed they are different. Sorry about the noise.

> Note, that I don't necessarily think we must leave these features
> tagged CONFIG_EXPERIMENTAL just that if we want to remove those labels,
> we should do that in the context of a separate discussion...
> 

Agreed.

-- 
Suresh Jayaraman
