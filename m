From: Ben Harris <bjh21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Subject: Re: TLINK_ERROR_EXPIRE breakage
Date: Mon, 5 Sep 2016 19:12:18 +0100 (BST)
Message-ID: <alpine.DEB.2.10.1609051728360.28184@thunderbird-1.linux.ds.cam.ac.uk>
References: <alpine.DEB.2.10.1609011625050.20241@thunderbird-1.linux.ds.cam.ac.uk> <1472822881.23692.9.camel@poochiereds.net>
Reply-To: UIS Platforms <unix-support-IE+S/cj2AuA2EctHIo1CcQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1870862089-1867542228-1473094712=:28184"
Cc: UIS Platforms <unix-support-IE+S/cj2AuA2EctHIo1CcQ@public.gmane.org>,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472822881.23692.9.camel-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Content-ID: <alpine.DEB.2.10.1609051908490.28184-DQa+Qhn4Z596hOdV6ebWgAmrLCtcsW2JsGvUnSjEs/k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1870862089-1867542228-1473094712=:28184
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15; FORMAT=flowed
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.10.1609051759431.28184-DQa+Qhn4Z596hOdV6ebWgAmrLCtcsW2JsGvUnSjEs/k@public.gmane.org>

On Fri, 2 Sep 2016, Jeff Layton wrote:

>>                  /* return error if we tried this already recently */
>>                  if (time_before(jiffies, tlink->tl_time + TLINK_ERROR_EXPIRE)) {
>>                          cifs_put_tlink(tlink);
>>                          return ERR_PTR(-EACCES);
>>                  }
>>
>> Essentially, the CIFS layer is caching the failed key look-up for a 
>> second even though in the intervening time the kernel has received a 
>> suitable key.
>
> Interesting. It has been a while since that code was written, but IIRC
> the main worry was spamming the server (and upcalls) that are just
> going to fail.

The keys subsystem has negative caching for request_key() calls that fail, 
and it keeps those much longer than the CIFS timeout.  So at least the 
upcalls to user space are properly rate-limited.

> A more subtle approach may make sense there though. One idea might be
> to continue to retry for a period of time, and only back off with
> EACCES errors after that. Or, we could just sleep in the kernel for a
> bit, and retry there, and only give up after that fails for a while.

I think the right thing might be to distinguish request_key() failures 
from other kinds of failure, and to only apply the rate limit to failures 
that didn't come from request_key().

-- 
Ben Harris, University of Cambridge Information Services.
--1870862089-1867542228-1473094712=:28184--
