From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cifs - check S_AUTOMOUNT in revalidate
Date: Thu, 03 May 2012 11:19:26 +0530
Message-ID: <4FA21C66.1030009@suse.com>
References: <20120427081815.4478.26011.stgit@perseus.themaw.net> <CA+55aFwx-vCQcbU5pKcRxFm1uJmjrT_OafTTMx026idX+H1oJg@mail.gmail.com> <CAH2r5mvd9PFZ5sxC+QLNObX23qWpJkUNdQmS_aqYA++zxueT6w@mail.gmail.com> <4FA11E59.9050004@suse.com> <20120502135044.6d815e62@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120502135044.6d815e62-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 05/02/2012 11:20 PM, Jeff Layton wrote:
> On Wed, 02 May 2012 17:15:29 +0530
> Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:
> 
>> On 04/28/2012 09:03 AM, Steve French wrote:
>>> The fix makes sense, but it is fairly recent and I haven't had a
>>> chance to try it,
>>> so unless a new release is imminent, I would prefer to put in the next merge
>>> request (I have at least one more fix likely as well) next week.
>>
>> We need this fix for -stable as well, right? Please include
>>
>>    Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> 
> The stable-kernel-rules.txt file says this:
> 
>  - It must fix a real bug that bothers people (not a, "This could be a
>    problem..." type thing).
> 

Doh, looks like I had assumed (wrongly) that this fixes the problem
reported here

   http://marc.info/?l=linux-cifs&m=133460168320472&w=2

(mapping to a dfsroot and cd to a reflink returning "Object is remote"
or "Not a directory" error). I didn't have a setup to verify it too.

I notice that Steve has already merged this patch adding Cc to stable
and the Cc has to be removed before sending the pull request.


Suresh
